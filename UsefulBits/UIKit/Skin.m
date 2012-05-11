#import "Skin.h"

#import "NSDictionary+Types.h"
#import "NSArray+Blocks.h"
#import "NSArray+Access.h"
#import "NSDictionary+Intersection.h"
#import "UIColor+Hex.h"

static NSString *kSectionPathDelimiter = @".";
static NSString *kReferencePrefix = @"@";
static NSString *kHexPrefix = @"0x";

static NSString *kFontNameKey = @"name";
static NSString *kFontSizeKey = @"size";
static NSString *kSystemFont = @"systemfont";
static NSString *kBoldSystemFont = @"systemfont-bold";
static NSString *kItalicSystemFont = @"systemfont-italic";

static const CGFloat kDefaultFontSize = 14.0;

@interface Skin ()

- (id)initWithSkins:(NSArray *)skins;

@property (nonatomic, copy) NSString *section;
@property (nonatomic, copy) NSDictionary *configuration;

@property (nonatomic, copy) NSCache *colors;
@property (nonatomic, copy) NSCache *images;
@property (nonatomic, copy) NSCache *fonts;

- (NSString *)valueForName:(NSString *)name inPart:(NSString *)section;

@end

#pragma mark - Helpers

static void with_skin_cache(void (^action) (NSMutableDictionary *cache))
{
  static dispatch_once_t initialized;
  static NSMutableDictionary *cache = nil;

  dispatch_once(&initialized, ^ {
		cache = [[NSMutableDictionary alloc] init];
  });

  action(cache);
}

static inline BOOL is_reference(id value)
{
  return [value isKindOfClass:[NSString class]] && [value hasPrefix:kReferencePrefix];
}

static inline Skin *cached_skin_for_cache(NSString *section)
{
  __block Skin *result = nil;
  with_skin_cache(^(NSMutableDictionary *cache) {
    result = [cache objectForKey:section];
  });

  return result;
}

static inline void cache_skin(Skin *skin)
{
  with_skin_cache(^(NSMutableDictionary *cache) {
    [cache setObject:skin forKey:[skin section]];
  });
}

static Skin *skin_for_section(NSString *section)
{
  Skin *result = cached_skin_for_cache(section);

  if (nil == result)
  {
    result = [[[Skin alloc] initForSection:section] autorelease];
    cache_skin(result);
  }

  return result;
}

static inline NSString *path_for_section(NSString *section)
{
  return [NSString pathWithComponents:[section componentsSeparatedByString:kSectionPathDelimiter]];
}

static NSString *merged_section_name(NSArray *skins)
{
  return [[skins map:^id(Skin *skin) {
    return [skin section];
  }] componentsJoinedByString:@":"];
}


static NSDictionary *merge_configurations(NSDictionary *parent, NSDictionary *child)
{
  __block NSMutableDictionary *configuration = [NSMutableDictionary dictionaryWithCapacity:7U];

  [[NSArray arrayWithObjects:@"images", @"colors", @"fonts", @"properties", nil] each:^(NSString *key) {
    NSDictionary *merged = [(NSDictionary *)[parent objectForKey:key] merge:[child objectForKey:key]];
    [configuration setObject:merged forKey:key];
  }];

  return configuration;
}

static NSDictionary *resolve_dictionary(NSDictionary *dictionary, NSDictionary *properties)
{
  NSMutableDictionary *resolved = [NSMutableDictionary dictionaryWithDictionary:dictionary];

  NSSet *references = [dictionary keysOfEntriesPassingTest:^ BOOL (id key, id obj, BOOL *stop) {
    return [obj isKindOfClass:[NSString class]] ? [obj hasPrefix:kReferencePrefix] : NO;
  }];

  for (NSString *key in references)
  {
    NSMutableSet *seen = [NSMutableSet set];

    id unresolved_value = [dictionary objectForKey:key];
    id value = unresolved_value;
    do {
      [seen addObject:value];
      NSString *referenced_key = [value substringFromIndex:[kReferencePrefix length]];

      value = [dictionary objectForKey:referenced_key];
      if (nil == value && nil != properties)
      {
        value = [properties objectForKey:referenced_key];
      }

      if (is_reference(value) && [seen containsObject:value])
      {
        NSException *recursive = [NSException
                                  exceptionWithName:@"RecursiveReference"
                                  reason:[NSString stringWithFormat:@"Recursive reference found for key \"%@\"", key]
                                  userInfo:nil];
        @throw recursive;
      }
    } while (is_reference(value));

    [resolved setObject:(nil == value ? unresolved_value : value) forKey:key];
  }

  return resolved;
}

static NSDictionary *resolve_fonts(NSDictionary *fonts, NSDictionary *inherited_properties)
{
  NSDictionary *resolved_fonts = resolve_dictionary(fonts, inherited_properties);

  NSSet *compound_font_keys = [fonts keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
    return [obj isKindOfClass:[NSDictionary class]];
  }];

  NSMutableDictionary *font_properties = [NSMutableDictionary dictionaryWithDictionary:inherited_properties];
  [font_properties addEntriesFromDictionary:[resolved_fonts removeKeys:compound_font_keys]];
  for (NSString *font_key in compound_font_keys)
  {
    NSDictionary *font = [fonts objectForKey:font_key];
    NSDictionary *resolved_font = resolve_dictionary(font, font_properties);
    [resolved_fonts setValue:resolved_font forKey:font_key];
  }

  return resolved_fonts;
}

static NSDictionary *resolve_references(NSDictionary *source)
{
  NSMutableDictionary *resolved = [NSMutableDictionary dictionaryWithCapacity:4];

  for (NSString *part_name in [NSArray arrayWithObjects:@"properties", @"images", @"colors", nil])
  {
    NSDictionary *part = [source objectForKey:part_name];
    [resolved setObject:resolve_dictionary(part, nil) forKey:part_name];
  }

  NSDictionary *fonts = resolve_fonts([source objectForKey:@"fonts"], nil);
  [resolved setObject:fonts forKey:@"fonts"];

  return resolved;
}

static inline NSString *bundle_relative_path(NSString *full_path)
{
  NSUInteger min_length = [[[NSBundle mainBundle] resourcePath] length] + 1;

  return [full_path length] >= min_length ? [full_path substringFromIndex:min_length] : nil;
}

static inline NSString *value_for_name(NSDictionary *source, NSString *name, NSString *part)
{
  id value = [source valueForKeyPath:[[part stringByAppendingString: @"."] stringByAppendingString:name]];

  return value;
}

static inline NSString* expand_path(NSBundle *bundle, NSString *section, NSString *part, NSString *value)
{
  NSString *section_path = [path_for_section(section) stringByAppendingPathComponent:part];
  NSString *resource_path = [bundle pathForResource:value ofType:nil inDirectory:section_path];

  return bundle_relative_path(resource_path);
}

static NSDictionary *expand_paths (NSBundle *bundle, NSString *section, NSString *part, NSDictionary *configuration)
{
  NSMutableDictionary *expanded = [NSMutableDictionary dictionaryWithDictionary:configuration];
  [configuration enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
    if ([value isKindOfClass:[NSString class]] && !([value hasPrefix:kReferencePrefix] || [value hasPrefix:kHexPrefix]))
    {
      NSString *path = expand_path(bundle, section, part, value);
      [expanded setObject:path forKey:key];
    }
    else if ([value isKindOfClass:[NSDictionary class]])
    {
      [expanded setObject:expand_paths(bundle, section, part, value) forKey:key];
    }
  }];

  return expanded;
}

#pragma mark - Skin

@implementation Skin

+ (Skin *)skin;
{
  return [self skinForSection:@""];
}

+ (Skin *)skinForSection:(NSString *)section;
{
  return skin_for_section(section);
}

@synthesize section = section_;
@synthesize configuration = configuration_;

@synthesize colors = colors_;
@synthesize images = images_;
@synthesize fonts = fonts_;

- (id)init;
{
  return [self initForSection:@""];
}

- (id)initForSection:(NSString *)section;
{
  if ((self = [super init]))
  {
    section_ = [section copy];

    colors_ = [[NSCache alloc] init];
    images_ = [[NSCache alloc] init];
    fonts_ = [[NSCache alloc] init];

    NSString *skin_name = [[[NSBundle mainBundle] infoDictionary] stringForKey:@"skin-name" default:@"skin"];
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:skin_name ofType:@"bundle"]];

    NSString *configuration_path = [bundle pathForResource:@"configuration"
                                                     ofType:@"plist"
                                                inDirectory:path_for_section(section)];


    NSMutableDictionary *local_configuration = [NSMutableDictionary dictionaryWithContentsOfFile:configuration_path];
    for (NSString *part in [NSArray arrayWithObjects:@"images", @"colors", nil])
    {
      [local_configuration setObject:expand_paths(bundle, section, part, [local_configuration objectForKey:part])
                              forKey:part];
    }

    NSDictionary *skin_configuration = nil;
    if ([section isEqualToString:@""])
    {
      skin_configuration = local_configuration;
    }
    else
    {
      NSArray *address = [section componentsSeparatedByString:kSectionPathDelimiter];
      NSString *parent_name = [[address trunk] componentsJoinedByString:kSectionPathDelimiter];
      Skin *parent = skin_for_section(parent_name);

      NSDictionary *parent_configuration = [parent configuration];

      skin_configuration = merge_configurations(parent_configuration, local_configuration);
    }

    configuration_ = [resolve_references(skin_configuration) copy];
  }

  return self;
}

- (id)initWithSkins:(NSArray *)skins;
{
  if ((self = [super init]))
  {
    section_ = [merged_section_name(skins) copy];

    colors_ = [[NSCache alloc] init];
    images_ = [[NSCache alloc] init];
    fonts_ = [[NSCache alloc] init];

    NSDictionary *configuration = [[skins rest] reduce:^id(NSDictionary *configuration, Skin *skin) {
      return merge_configurations(configuration, [skin configuration]);
    } initial:[[skins first] configuration]];

    configuration_ = [resolve_references(configuration) copy];
  }

  return self;
}

- (void)dealloc;
{
  [colors_ release];
  [images_ release];
  [fonts_ release];

  [section_ release];
  [configuration_ release];

  [super dealloc];
}

#pragma mark - Subsections

- (Skin *)sectionNamed:(NSString *)name;
{
  return [Skin skinForSection:[NSString stringWithFormat:@"%@.%@", [self section], name]];
}

#pragma mark - Fonts

static UIFont *resolve_font(NSString *name, CGFloat size)
{
  UIFont *font = nil;

  if ([name isEqualToString:kSystemFont])
  {
    font = [UIFont systemFontOfSize:size];
  }
  else if ([name isEqualToString:kBoldSystemFont])
  {
    font = [UIFont boldSystemFontOfSize:size];
  }
  else if ([name isEqualToString:kItalicSystemFont])
  {
    font = [UIFont italicSystemFontOfSize:size];
  }
  else
  {
    font = [UIFont fontWithName:name size:size];
  }

  return font;
}

- (void)withFontNamed:(NSString *)name do:(void (^) (UIFont *font))action;
{
  id value = [self valueForName:name inPart:@"fonts"];
  if (nil != value)
  {
    action([self fontNamed:name]);
  }
}

- (UIFont *)fontNamed:(NSString *)name;
{
  UIFont *font = [[self fonts] objectForKey:name];

  if (nil == font)
  {
    NSString *font_name = nil;
    CGFloat font_size = kDefaultFontSize;

    id font_value = [self valueForName:name inPart:@"fonts"];

    if ([font_value isKindOfClass:[NSDictionary class]])
    {
      font_name = [font_value objectForKey:kFontNameKey];
      font_size = [[font_value objectForKey:kFontSizeKey] floatValue];
    }
    else
    {
      font_name = font_value;
    }

    font = resolve_font(font_name, font_size);

    if (nil != font)
    {
      [[self fonts] setObject:font forKey:name];
    }
  }

  return font;
}

#pragma mark - Properties

- (void)withPropertyNamed:(NSString *)name do:(void (^) (id value))action;
{
  id value = [self valueForName:name inPart:@"properties"];

  if (nil != value)
  {
    action(value);
  }
}

- (id)propertyNamed:(NSString *)name;
{
  id result = [self valueForName:name inPart:@"properties"];

  return is_reference(result) ? nil : result;
}

#pragma mark - Colors

- (void)withColorNamed:(NSString *)name do:(void (^) (UIColor *color))action;
{
  if (nil != [self valueForName:name inPart:@"colors"])
  {
    action([self colorNamed:name]);
  }
}

- (UIColor *)colorNamed:(NSString *)name;
{
  UIColor *color = [colors_ objectForKey:name];

  if (nil == color)
  {
    color = [UIColor cyanColor];

    NSString *value = [self valueForName:name inPart:@"colors"];
    if ([value hasPrefix:kHexPrefix])
    {
      color = [UIColor colorWithHexString:value];
    }
    else
    {
      UIImage *image = [UIImage imageNamed:value];
      if (nil != image)
      {
        color = [UIColor colorWithPatternImage:image];
      }
    }

    [colors_ setObject:color forKey:name];
  }

  return color;
}

#pragma mark - Images

- (void)withConfigurationAtPath:(NSString *)path do:(void (^) (id value))action
{
  id value = [[self configuration] valueForKeyPath:path];
  if (value)
  {
    action(value);
  }
}

- (void)withImageNamed:(NSString *)name do:(void (^) (UIImage *image))action;
{
  id value = [self valueForName:name inPart:@"images"];
  if (value)
  {
    action([self imageNamed:name]);
  }
}

- (UIImage *)imageNamed:(NSString *)name;
{
  NSParameterAssert(nil != name && [name length] > 0);

  UIImage *image = [images_ objectForKey:name];
  if (nil == image)
  {
    id value = [self valueForName:name inPart:@"images"];

    if ([value isKindOfClass:[NSString class]])
    {
      NSString *image_path = value;
      image = [UIImage imageNamed:image_path];
    }
    else // KAO - Assumes a dictionary
    {
      NSString *image_path = [value objectForKey:@"name"];
      NSNumber *hcap = [value objectForKey:@"horizontal-cap"];
      NSNumber *vcap = [value objectForKey:@"vertical-cap"];

      image = [[UIImage imageNamed:image_path] stretchableImageWithLeftCapWidth:[hcap integerValue]
                                                                   topCapHeight:[vcap integerValue]];
    }

    if (nil != image)
    {
      [images_ setObject:image forKey:name];
    }
  }

  return image;
}

#pragma mark - Utilities

- (NSString *)valueForName:(NSString *)name inPart:(NSString *)part;
{
  return value_for_name([self configuration], name, part);
}

- (Skin *)merge:(Skin *)other;
{
  NSArray *skins = [NSArray arrayWithObjects:self, other, nil];
  NSString *section = merged_section_name(skins);

  Skin *result = cached_skin_for_cache(section);
  if (nil == result)
  {
    result = [[[Skin alloc] initWithSkins:skins] autorelease];
    cache_skin(result);
  }

  return result;
}

@end

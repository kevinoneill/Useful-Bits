  //  Copyright (c) 2011, Kevin O'Neill
  //  All rights reserved.
  //
  //  Redistribution and use in source and binary forms, with or without
  //  modification, are permitted provided that the following conditions are met:
  //
  //  * Redistributions of source code must retain the above copyright
  //   notice, this list of conditions and the following disclaimer.
  //
  //  * Redistributions in binary form must reproduce the above copyright
  //   notice, this list of conditions and the following disclaimer in the
  //   documentation and/or other materials provided with the distribution.
  //
  //  * Neither the name UsefulBits nor the names of its contributors may be used
  //   to endorse or promote products derived from this software without specific
  //   prior written permission.
  //
  //  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  //  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  //  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  //  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
  //  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  //  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  //  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  //  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  //  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  //  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "UsefulQuartzFunctions.h"

#import <UsefulBits/UBMacros.h>

CGSize CGSizeNoSmaller(CGSize size, CGSize min)
{
  return CGSizeMake(MAX(size.width, min.width), MAX(size.height, min.height));
}

CGSize CGSizeNoLarger(CGSize size, CGSize max)
{
  return CGSizeMake(MIN(size.width, max.width), MIN(size.height, max.height));
}

CGSize CGSizeBoundedBy(CGSize size, CGSize min, CGSize max)
{
  return CGSizeMake(UBCLAMP(size.width, min.width, max.width), UBCLAMP(size.height, min.height, max.height));
}

CGRect CGRectInsetLeft(CGRect rect, CGFloat inset)
{
  return CGRectStandardize(CGRectMake(rect.origin.x + inset, rect.origin.y, rect.size.width - inset, rect.size.height));
}

CGRect CGRectInsetRight(CGRect rect, CGFloat inset)
{
  return CGRectStandardize(CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - inset, rect.size.height));
}

CGRect CGRectInsetTop(CGRect rect, CGFloat inset)
{
  return CGRectStandardize(CGRectMake(rect.origin.x, rect.origin.y + inset, rect.size.width, rect.size.height - inset));
}

CGRect CGRectInsetBottom(CGRect rect, CGFloat inset)
{
  return CGRectStandardize(CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - inset));
}

CGRect CGRectMakeSized(CGSize size)
{
  return CGRectStandardize(CGRectMake(0., 0., size.width, size.height));
}

CGRect CGRectMakeSizedCenteredInRect(CGSize size, CGRect rect2)
{
  return CGRectMake(floorf(CGRectGetMidX(rect2) - (size.width / 2)), floorf(CGRectGetMidY(rect2) - (size.height / 2)), size.width, size.height);
}

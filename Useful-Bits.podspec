Pod::Spec.new do |s|

  s.name         = "Useful-Bits"
  s.version      = "1.0"
  s.summary      = "A Collection of Useful Cocoa and UIKit Bits"

  s.description  = <<-DESC
                   A longer description of Useful-Bits in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/kevinoneill/Useful-Bits"
  s.license      = { :type => "MIT", :file => "License.txt" }
  s.author             = { "Kevin O'Neill" => "" }

  s.platform     = :ios
  
  s.source       = { :git => "https://github.com/kevinoneill/Useful-Bits.git", :tag => "#{s.version}" }
  s.source_files  = "UsefulBits"

  s.resource  = "UsefulBits/custom-navigation.xib"

  s.frameworks = "UIKit", "Security", "QuartzCore", "Foundation"

  s.requires_arc = false
end

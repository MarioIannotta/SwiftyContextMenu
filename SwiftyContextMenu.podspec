Pod::Spec.new do |s|
  s.name             = 'SwiftyContextMenu'
  s.version          = '0.1.3'
  s.summary          = 'UIContextMenu backporting with Swifter API.'
  s.description      = <<-DESC
  SwiftyContextMenu is a backporting of UIContextMenu available on iOS 10+ that is easier to integrate.
                       DESC

  s.homepage         = 'https://github.com/MarioIannotta/SwiftyContextMenu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MarioIannotta' => 'info@marioiannotta.com' }
  s.source           = { :git => 'https://github.com/MarioIannotta/SwiftyContextMenu.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MarioIannotta'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.2'
  s.source_files = 'SwiftyContextMenu/**/*'
  
end

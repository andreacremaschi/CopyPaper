Pod::Spec.new do |spec|
  spec.name         = 'CopyPaper'
  spec.version      = '0.1.0'
  spec.license      = 'MIT'
  spec.summary      = 'Let gestures pass through views, so that you can overlay view controllers'
  spec.homepage     = 'https://github.com/andreacremaschi/CopyPaper.git'
  spec.author       = 'Andrea Cremaschi'
  spec.source       = { :git => 'git://github.com/andreacremaschi/CopyPaper.git', :tag => '0.1.0' }
  spec.source_files = 'CopyPaper/*'
  spec.requires_arc = true
end

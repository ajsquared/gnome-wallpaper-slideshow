Gem::Specification.new do |s|
  s.name        = 'gnome-wallpaper-slideshow'
  s.version     = '0.3'
  s.date        = '2012-01-13'
  s.executables << 'create-slideshow'
  s.summary     = "Gnome Wallpaper Slideshow"
  s.description = "A gem for creating and interacting with the XML files that define wallpaper slideshows in GNOME"
  s.authors     = ["Andrew Johnson"]
  s.email       = 'andrew@andrewjamesjohnson.com'
  s.files       = ["lib/gnome-wallpaper-slideshow.rb", "lib/gnome-wallpaper-slideshow/wallpaper.rb", "Rakefile"]
  s.test_files = ["test/test-gnome-wallpaper-slideshow.rb"]
  s.homepage    = 'https://github.com/ajsquared/gnome-wallpaper-slideshow'
  s.require_paths = ["lib"]
  
  s.add_dependency 'nokogiri', '>=1.5.6'
end

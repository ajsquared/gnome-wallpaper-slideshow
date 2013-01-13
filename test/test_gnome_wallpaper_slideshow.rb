require 'test/unit'
require 'gnome-wallpaper-slideshow'

class GnomeWallpaperSlideshowTest < Test::Unit::TestCase
  def test_create_new_slideshow
    slideshow = GnomeWallpaperSlideshow.new do
      create_new_slideshow "xml_slideshow.xml"
    end

    path = Pathname.new "xml_slideshow.xml"
    assert_equal path, slideshow.path
  end

  def test_create_new_slideshow_default_arg
    slideshow = GnomeWallpaperSlideshow.new do
      create_new_slideshow
    end

    path = Pathname.new "slideshow.xml"
    assert_equal path, slideshow.path
  end

  def test_start_time
    slideshow = GnomeWallpaperSlideshow.new

    time = Time.local 2009,8,4,0,0,0
    
    assert_equal time, slideshow.start_time(time) # Test setting the time
    assert_equal time, slideshow.start_time # Test getting the time
  end

  def test_path
    slideshow = GnomeWallpaperSlideshow.new

    path = Pathname.new "xml_slideshow.xml"
    assert_equal path, slideshow.path(path) # Test setting the path
    assert_equal path, slideshow.path # Test getting the path
  end

  def test_wallpapers
    slideshow = GnomeWallpaperSlideshow.new
    wallpaper_one  = GnomeWallpaperSlideshow::Wallpaper.new "test.jpg", 100, 5
    wallpaper_two  = GnomeWallpaperSlideshow::Wallpaper.new "other.jpg", 500, 3

    assert_equal [], slideshow.wallpapers # Test handling of no wallpapers

    # Test adding wallpapers
    slideshow.add_wallpaper wallpaper_one
    slideshow.add_wallpaper wallpaper_two

    assert_equal [wallpaper_one, wallpaper_two], slideshow.wallpapers

    # Test removing wallpapers
    slideshow.remove_wallpaper wallpaper_one.filename

    assert_equal [wallpaper_two], slideshow.wallpapers
  end
end

# gnome-wallpaper-slideshow #

gnome-wallpaper-slideshow is a Ruby gem that allows you to create and
interact with the XML files that define wallpaper slideshows in GNOME.
It supports both creating slideshows from scratch and loading existing
slideshows.

## Example Usage ##

    slideshow = GnomeWallpaperSlideshow.new do
	  create_new_slideshow "slideshow.xml"
	  start_time Time.local 2013, 1, 13, 0, 0, 0 # Start the slideshow at midnight
	  add_wallpaper "test.jpg", 3600, 5 # Display this image for 1 hour with a 5 sec transition
	  add_wallpaper "other.jpg" 1800, 5 # Display this image for 30 minutes with a 5 sec transition
	end
	slideshow.save_xml

## Installation ##

    gem install gnome-wallpaper-slideshow

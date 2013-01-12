# Represents a wallpaper entry in a slideshow
class GnomeWallpaperSlideshow::Wallpaper
  attr_accessor :filename, :duration, :transition_time
  
  # Create a new wallpaper
  # @param [String] filename The path to the image file
  # @param [Float] duration The length of time this wallpaper will be displayed in seconds
  # @param [Float] transition_time The amount of time spent transitioning
  #   to the next wallpaper in seconds
  def initialize(filename, duration = 1795.0, transition_time = 5.0)
    @filename = filename
    @duration = duration
    @transition_time = transition_time
  end
end

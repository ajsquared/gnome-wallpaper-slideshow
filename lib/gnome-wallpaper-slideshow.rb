require 'nokogiri'
require 'pathname'

# Represents an XML file defining a wallpaper slideshow in GNOME
#
# @author Andrew Johnson
class GnomeWallpaperSlideshow
  # Create a new GnomeWallpaperSlideshow
  def initialize(&block)
    instance_eval(&block)
  end

  # Creates a new wallpaper slideshow
  # @param [String] filename The path to the new file to create.
  #   Defaults to slideshow.xml in the current working directory.
  #   If the file already exists it will be overwritten
  def create_new_slideshow(filename = "slideshow.xml")
    @path = Pathname.new filename
  end

  # Loads an existing wallpaper slideshow
  # @param [String] filename The path to the slideshow file
  def load_slideshow(filename)
    @path = Pathname.new filename
    load_slideshow_xml
  end

  # Sets the start time of the slideshow
  # @param [Time] time The start time for the slideshow
  # @return The current start time if one is not given
  def start_time(time = nil)
    return @start_time if time == nil

    @start_time = time
  end

  # Sets the path of the slideshow XML file
  # @param [String] filename The path to the new location of the XML file
  # @return The current path if one is not given
  def path(filename = nil)
    return @path if time == nil

    @path = Pathname.new filename
  end

  # Gets the list of wallpapers in this slideshow
  # @return The list of wallpapers in the slideshow, or the empty list if none exist
  def wallpapers
    @wallpapers = @wallpapers || []
  end

  # Adds a new wallpaper to the slideshow
  # @param [GnomeWallpaperSlideshow::Wallpaper] wallpaper The wallpaper to add
  def add_wallpaper(wallpaper)
    wallpapers << wallpaper
  end

  private

  # Loads a wallpaper slideshow XML file
  def load_slideshow_xml
    File.open(self.path, "r") do |slideshow_file|
      # We want strict parsing to ensure we are given a valid XML file
      @xml_doc = Nokogiri::XML(slideshow_file) do |config|
        config.strict
      end
    end
  end
end

require 'gnome-wallpaper-slideshow/wallpaper'

require 'nokogiri'
require 'pathname'

# Represents an XML file defining a wallpaper slideshow in GNOME
#
# @author Andrew Johnson
class GnomeWallpaperSlideshow
  attr_reader :path
  
  # Create a new GnomeWallpaperSlideshow
  def initialize(&block)
    instance_eval(&block)
  end

  # Creates a new wallpaper slideshow
  # @param [String] filename The path to the new file to create
  #   Defaults to slideshow.xml in the current working directory
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

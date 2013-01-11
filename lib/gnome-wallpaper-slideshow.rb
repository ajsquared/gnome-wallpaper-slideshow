require 'nokogiri'
require 'pathname'

# Represents an XML file defining a wallpaper slideshow in GNOME
#
# @author Andrew Johnson
class GnomeWallpaperSlideshow
  attr_reader :path, :xml_doc
  
  # Initializes a new wallpaper slideshow
  # @param [String] filename The path to a wallpaper slideshow XML file.
  #  Either pass the path to a non-existent file or omit the argument to
  #  create a new slideshow.
  def initialize(filename = "slideshow.xml")
    @path = Pathname.new filename

    if @path.exist?
      File.open(filename, "r") do |slideshow_file|
        # We want strict parsing to ensure that we're given an actual XML file
        @xml_doc = Nokogiri::XML(slideshow_file) do |config|
          config.strict
        end
      end
    end
  end
end

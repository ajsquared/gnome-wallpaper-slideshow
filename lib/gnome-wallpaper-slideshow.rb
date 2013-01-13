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

    # Load the content from the XML doc
    load_start_time
    load_wallpapers
  end

  # Gets or sets the start time of the slideshow
  # @param [Time] time The start time for the slideshow
  # @return The current start time if one is not given
  def start_time(time = nil)
    return @start_time unless time

    @start_time = time
  end

  # Gets or sets the path of the slideshow XML file
  # @param [String] filename The path to the new location of the XML file
  # @return The current path if one is not given
  def path(filename = nil)
    return @path unless filename

    @path = Pathname.new filename
  end

  # Gets the list of wallpapers in this slideshow
  # @return The list of wallpapers in the slideshow, or the empty list if none exist
  def wallpapers
    return @wallpapers = @wallpapers || []
  end

  # Adds a new wallpaper to the slideshow
  # @param [GnomeWallpaperSlideshow::Wallpaper] wallpaper The wallpaper to add
  def add_wallpaper(wallpaper)
    wallpapers << wallpaper
  end

  # Removes a wallpaper from the slideshow
  # @param [String] filename The filename of the wallpaper to remove
  def remove_wallpaper(filename)
    wallpapers.delete_if do |wallpaper|
      wallpaper.filename == filename
    end
  end

  # Generates and saves the slideshow XML to the current @path
  def save_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.background {
        xml.starttime {
          xml.year start_time.year
          xml.month start_time.month
          xml.day start_time.day
          xml.hour start_time.hour
          xml.minute start_time.min
          xml.second start_time.sec
        }
        wallpapers.each_cons(2) do |transition|
          xml.static {
            xml.duration transition.first.duration
            xml.file transition.first.filename
          }
          xml.transition {
            xml.duration transition.first.transition_time
            xml.from transition.first.filename
            xml.to transition.last.filename
          }
        end
        # Now insert the last wallpaper and the transition back to the beginning
        xml.static {
          xml.duration wallpapers.last.duration
          xml.file wallpapers.last.filename
        }
        xml.transition {
          xml.duration wallpapers.last.transition_time
          xml.from wallpapers.last.filename
          xml.to wallpapers.first.filename
        }
      }
    end
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

  # Loads the start time from the XML file
  def load_start_time
    year = starttime_xpath_query "year"
    month = starttime_xpath_query "month"
    day = starttime_xpath_query "day"
    hour = starttime_xpath_query "hour"
    minute = starttime_xpath_query "minute"
    second = starttime_xpath_query "second"

    start_time Time.local year, month, day, hour, minute, second
  end

  # Load the wallpapers and transitions from the XML file
  def load_wallpapers
    files = wallpaper_xpath_query "//static/file"
    durations = wallpaper_xpath_query "//static/duration"
    transitions = wallpaper_xpath_query "//transition/duration"

    @wallpapers = files.zip(durations,transitions).map do |file, duration, transition|
      GnomeWallpaperSlideshow::Wallpaper.new file, duration, transition
    end
  end

  # Performs an XPath query for wallpapers
  # @param [String] query The XPath query to perform
  def wallpaper_xpath_query(query)
    @xml_doc.xpath(query).children.map do |child|
      child.content
    end
  end

  # Performs an XPath query for an element of the starttime
  # @param [String] field The starttime field to extract
  def starttime_xpath_query(field)
    @xml_doc.at_xpath("//starttime/#{field}").children.first.content
  end
end

require 'gnome-wallpaper-slideshow/wallpaper'

require 'minitest/spec'
require 'minitest/autorun'
require 'gnome-wallpaper-slideshow'

describe GnomeWallpaperSlideshow do
  before do
    @slideshow_default = GnomeWallpaperSlideshow.new do
      create_new_slideshow
    end

    @slideshow = GnomeWallpaperSlideshow.new do
      create_new_slideshow "xml_slideshow.xml"
      start_time Time.local 2009,8,4,0,0,0
      add_wallpaper (GnomeWallpaperSlideshow::Wallpaper.new "test.jpg", 100, 5)
      add_wallpaper (GnomeWallpaperSlideshow::Wallpaper.new "other.jpg", 500, 3)
    end

    @slideshow_existing = GnomeWallpaperSlideshow.new

    # Mock out some methods to avoid reading/writing to disk
    def @slideshow.write_xml(xml_string)
      xml_string
    end
    
    def @slideshow_existing.load_slideshow_xml
      @xml_doc = Nokogiri::XML("<?xml version=\"1.0\"?>
<background>
  <starttime>
    <year>2013</year>
    <month>1</month>
    <day>1</day>
    <hour>00</hour>
    <minute>00</minute>
    <second>00</second>
  </starttime>
  <static>
    <duration>100</duration>
    <file>test.jpg</file>
  </static>
  <transition>
    <duration>5</duration>
    <from>test.jpg</from>
    <to>other.jpg</to>
  </transition>
  <static>
    <duration>500</duration>
    <file>other.jpg</file>
  </static>
  <transition>
    <duration>3</duration>
    <from>other.jpg</from>
    <to>test.jpg</to>
  </transition>
</background>
") do |config|
        config.strict
      end
    end

    @slideshow_existing.load_slideshow "real_slideshow.xml"
  end
  

  it "can be created with the default output file" do
    @slideshow_default.path.must_equal (Pathname.new "slideshow.xml")
  end

  it "can be created with a specific output file" do
    @slideshow.path.must_equal (Pathname.new "xml_slideshow.xml")
  end

  it "can have its output path set" do
    path = Pathname.new "new_slideshow.xml"
    @slideshow_default.path path
    @slideshow_default.path.must_equal path
  end

  it "can have its start time set" do
    time = Time.local 2007,5,3,1,0,0
    @slideshow_default.start_time time
    @slideshow_default.start_time.must_equal time
  end
  
  it "can be created with a start time" do
    @slideshow.start_time.must_equal (Time.local 2009,8,4,0,0,0)
  end

  it "can be created with wallpapers" do
    @slideshow.wallpapers.size.must_equal 2
    @slideshow.wallpapers.must_equal [(GnomeWallpaperSlideshow::Wallpaper.new "test.jpg", 100, 5), (GnomeWallpaperSlideshow::Wallpaper.new "other.jpg", 500, 3)]
  end

  it "can be created without wallpapers" do
    @slideshow_default.wallpapers.must_be_empty
  end

  it "can have wallpapers added" do
    wallpaper = GnomeWallpaperSlideshow::Wallpaper.new "test.jpg", 100, 5
    @slideshow_default.add_wallpaper wallpaper
    @slideshow_default.wallpapers.must_equal [(GnomeWallpaperSlideshow::Wallpaper.new "test.jpg", 100, 5)]
  end

  it "can have wallpapers removed" do
    @slideshow.remove_wallpaper "test.jpg"
    @slideshow.wallpapers.must_equal [(GnomeWallpaperSlideshow::Wallpaper.new "other.jpg", 500, 3)]
  end

  it "can load an existing slideshow file" do
    @slideshow_existing.path.must_equal (Pathname.new "real_slideshow.xml")
    @slideshow_existing.start_time.must_equal (Time.local 2013,1,1,0,0,0)
    @slideshow_existing.wallpapers.must_equal [(GnomeWallpaperSlideshow::Wallpaper.new "test.jpg", "100", "5"), (GnomeWallpaperSlideshow::Wallpaper.new "other.jpg", "500", "3")]
  end

  it "can write out an xml file" do
    @slideshow.save_xml.must_equal "<?xml version=\"1.0\"?>
<background>
  <starttime>
    <year>2009</year>
    <month>8</month>
    <day>4</day>
    <hour>0</hour>
    <minute>0</minute>
    <second>0</second>
  </starttime>
  <static>
    <duration>100</duration>
    <file>test.jpg</file>
  </static>
  <transition>
    <duration>5</duration>
    <from>test.jpg</from>
    <to>other.jpg</to>
  </transition>
  <static>
    <duration>500</duration>
    <file>other.jpg</file>
  </static>
  <transition>
    <duration>3</duration>
    <from>other.jpg</from>
    <to>test.jpg</to>
  </transition>
</background>
"
  end
end

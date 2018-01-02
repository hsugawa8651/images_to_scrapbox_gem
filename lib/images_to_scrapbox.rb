require "images_to_scrapbox/version"
require "rest-client"
# require "open-uri"
require "uri"
require "JSON"
require 'base64'

def register_image(image_fullpath)
  gyazo_url="https://upload.gyazo.com/api/upload"
  begin
    r = RestClient.post gyazo_url, {
      "access_token" => ENV["GYAZO_TOKEN"],
    	:imagedata => File.new(image_fullpath, 'rb')
    }
    return JSON.parse(r)
  rescue => e
    p e
    puts e.backtrace
    puts <<EOS
Failed to register image data.
- Be online.
- Set your ACCESS_TOKEN to the environment variable "GYAZO_TOKEN"
EOS
  ensure
  end
  exit(1)
end


module ImagesToScrapbox
  # Your code goes here...
  class Converter
    @@converters=[]

    def Converter.add(globn)
      Dir.glob(globn).each do |g|
        next unless g =~ /\.(gif|jpe?g|png)$/i
        @@converters.push Converter.new(g)
      end
    end

    def Converter.perform(do_convert=true, options)

      if options[:unique]
        @@converters.uniq!{ |e| e.image_name }
      end

      case options[:sort]
      when "none"
      when "name"
        @@converters.sort_by!{ |e| e.image_name }
      else
        raise Thor::Error, "Unknown sort type: #{sort_type}"
      end

      unless options[:ascending]
        @@converters.reverse!
      end

      unless do_convert
        @@converters.each do |c|
          puts c.image_name
        end
        return
      end

      @@converted_on="Converted on #{Time.now.to_s}"

      pages=[]
      @@converters.map do |converter|
        pages.concat converter.start(options)
      end

      if options[:toc]
        pages.concat Converter.toc_page
      end

      result={
        "pages": pages
      }

      puts result.to_json

    end

    attr_reader :image_name, :image_path, :page_title
    def initialize(path)
      @image_name=path
      @image_path=File.expand_path(path)
    end

    def Converter.toc_page()
      tocpage=SbPage.new()
      tocpage.set_page_title(@@converted_on)
      @@converters.map do |converter|
        tocpage.push_text("  ["+converter.page_title+"]")
      end
      tocpage.get_page
    end

    def start(options)

      timestamp=""
      case options[:timestamp]
      when "atime"
        timestamp=File.atime(@image_path).to_s
      when "ctime"
        timestamp=File.ctime(@image_path).to_s
      when "mtime"
        timestamp=File.mtime(@image_path).to_s
      else
        raise Thor::Error, "Unknown timestamp type: #{timestamp_kind}"
      end
      @page_title=@image_name + " " + timestamp

      imagepage=SbPage.new()
      imagepage.set_page_title(@page_title)
      imagepage.push_text(@image_name)
      imagepage.push_empty_text()

      if options[:image]
        r=register_image(@image_path)
        url=r["url"]
        imagepage.push_text( options[:larger] ? "[["+url+"]]" : "["+url+"]"  )
      end

      imagepage.push_text("["+@@converted_on+"]")
      imagepage.get_page
    end
  end

  class SbPage
    def set_page_title(title)
      @page_title=title
      push_text(title)
      push_empty_text
    end

    def get_page()
      [
        {
          "title": @page_title,
          "lines": json
        }
      ]
    end

    def initialize()
      @page_title=""
      @sb_json=[]
    end

    def json()
      @sb_json
    end

    def push_text(s)
      s.split("\n").each do |s1|
        @sb_json << s1
      end
    end

    def push_empty_text()
      @sb_json << ""
    end
  end
end

require 'nokogiri'
module Logline
  def self.load(data)
    Script.new(data)
  end
  
  def self.load_file(path)
    Script.new File.read(path)
  end
  
  class Script
    attr_reader :doc
    def initialize(data)
      @doc = Nokogiri::XML(data)
    end
    
    def headings
      @headings ||= doc.css('Paragraph[@Type="Scene Heading"]').collect {|h| Heading.new(h.inner_text) }
    end
    
    alias_method :slugs, :headings
    
    def characters
      @characters ||= doc.css('Paragraph[@Type="Character"] Text').collect {|c| c.inner_text.upcase }.uniq.collect {|c| Character.new(c) }
    end
    
  end
  
  class Character
    attr_reader :name
    def initialize(name)
      @name = name
    end
    
    def to_s
      name
    end
    
  end
  
  class Heading
    attr_reader :surrounding, :location, :time

    def initialize(text)
      text =~ /-\s*(.*)\s*$/
      @time = $1.strip.upcase if $1
      if @time
        text =~ /(int\.?|ext\.?)\s*(.*)\s*-\s*#{Regexp.escape @time}\s*$/i
      else
        text =~ /(int\.?|ext\.?)\s*(.*)\s*$/i
      end
      @surrounding = $1.strip.upcase if $1
      @location = $2.strip.upcase if $2
    end

    def to_s
      if time && surrounding && location
        "#{surrounding} #{location} - #{time}"
      elsif surrounding && location
        "#{surrounding} #{location}"
      elsif location && time
        "#{location} - #{time}"
      elsif surrounding && time
        "#{surrounding} - #{time}"
      else
        location || time || surrounding || ""
      end
    end
    
  end
end
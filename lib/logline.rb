require 'nokogiri'
module Logline
  
  class Script
    attr_reader :doc
    attr_reader :paragraphs

    def self.from_fdx(path)
      new File.read(path)
    end

    def to_scrippet
      paragraphs.collect {|paragraph| paragraph.to_scrippet }.join("\n")
    end

    class Paragraph
      attr_accessor :content
      
      def initialize(c)
        @content = c
      end
      
      def to_s
        content
      end

      def to_scrippet
        content
      end
      
    end

    class Heading < Paragraph
      def to_scrippet
        "#{content.upcase}\n"
      end
    end

    class Action < Paragraph 
      def to_scrippet
        "#{content}\n"
      end
    end

    class CharacterName < Paragraph
      def to_scrippet
        content.upcase
      end
    end

    class Dialogue < Paragraph 
      def to_scrippet
        "#{content}\n"
      end
    end
    class Transition < Paragraph 
      def to_scrippet
        "#{content}\n"
      end
    end
    class Unknown < Paragraph ; end

    @@klass_map = {'Scene Heading' => Heading, 'Action' => Action, 'Character' => CharacterName, 'Dialogue' => Dialogue, 'Transition' => Transition}

    def initialize(data)
      @doc = Nokogiri::XML(data)
      @paragraphs = doc.xpath('/FinalDraft/Content/Paragraph').collect do |paragraph|
        text = paragraph.css('Text').collect {|t| t.inner_text }.join('')
        (@@klass_map[paragraph.attributes['Type'].to_s] || Unknown).new(text)
      end
    end
    
  end

end
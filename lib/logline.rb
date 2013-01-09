require 'nokogiri'
module Logline
  class Script
    class Scene
      attr_accessor :paragraphs
      attr_reader :heading, :title, :page, :page_length, :page_fraction
      
      def initialize(opts = {})
        @paragraphs = opts[:paragraphs]
      end      
      
      def heading
        paragraphs.select { |pp| pp.is_a? Logline::Script::Heading }.first
      end
      
      def title
        scene_properties['Title']
      end
      
      def page
        scene_properties['Page'].to_i
      end
      
      def page_length
        page_fraction.split.map { |r| Rational(r) }.inject(:+).to_f
      end
      
      def page_fraction
        scene_properties['Length']
      end
      
    private
      def scene_properties
        heading.doc.css('SceneProperties').first
      end  
    end

    class Paragraph
      attr_accessor :doc, :content
      
      def initialize(opts = {})
        @doc = opts[:doc]
        @content = opts[:content]
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
        ".#{content.upcase}\n"
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
        "> #{content}\n"
      end
    end
    
    class Parenthetical < Paragraph
      def to_scrippet
        "#{content}\n"
      end
    end
    
    class Unknown < Paragraph ; end
    
    attr_reader :doc
    attr_reader :paragraphs
    attr_reader :scenes
    
    @@klass_map = {'Scene Heading' => Heading, 'Action' => Action, 'Character' => CharacterName, 'Dialogue' => Dialogue, 'Transition' => Transition}

    def initialize(data)
      @doc = Nokogiri::XML(data)
      @paragraphs = content.collect do |paragraph|
        text = paragraph.css('Text').collect {|t| t.inner_text }.join('')
        (@@klass_map[paragraph.attributes['Type'].to_s] || Unknown).new(doc: paragraph, content: text)
      end
      @scenes = parse_scenes
    end

    def self.from_fdx(path)
      new File.read(path)
    end

    def to_scrippet
      paragraphs.collect {|paragraph| paragraph.to_scrippet }.join("\n")
    end
    
    def find_all(type = nil)
      return paragraphs if type.blank?
      paragraphs.select { |paragraph| paragraph.is_a?("Logline::Script::#{type}".constantize) }
    end
    
    def content
      doc.xpath('/FinalDraft/Content/Paragraph')
    end
    
    def parse_scenes
      s = []
      paragraphs.each do |pp|
        if pp.is_a? Logline::Script::Heading
          s << Scene.new(paragraphs: [pp])
        else
          s.last.nil? ? next : s.last.paragraphs << pp
        end
      end
      s
    end

  end

end
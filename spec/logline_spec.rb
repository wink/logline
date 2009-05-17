require File.dirname(__FILE__) + '/spec_helper'

describe Logline do
  before(:each) do
    @script = Logline.load_file(File.dirname(__FILE__) + '/fixtures/hacker.fdx')
  end
  it "should load an fdx file" do
    @script.should be_kind_of(Logline::Script)
  end

  it "should parse scene headings" do
    @script.headings.size.should == 2
    @script.headings.should == @script.slugs
    @script.headings.collect {|h| h.to_s }.should == ['INT. BEDROOM - NIGHT', 'EXT. HOUSE']
  end
  describe "headings" do
    it "should parse scene heading components" do
      @heading = Logline::Heading.new("\n      \n      Int. Bedroom - night\n    ")
      @heading.surrounding.should == 'INT.'
      @heading.time.should == 'NIGHT'
      @heading.location.should == 'BEDROOM'
      @heading.to_s.should == 'INT. BEDROOM - NIGHT'
    end
    
    it "should parse components without the time" do
      @heading = Logline::Heading.new("\n      \n      EXT. House\n    ")
      @heading.time.should be_nil
      @heading.surrounding.should == 'EXT.'
      @heading.location.should == 'HOUSE'
      @heading.to_s.should == 'EXT. HOUSE'
    end
    
  end

  it "should parse character names" do
    @script.characters.collect {|c| c.to_s}.should == ['BEN']
  end
end
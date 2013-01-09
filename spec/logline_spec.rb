# encoding: UTF-8

require File.dirname(__FILE__) + '/spec_helper'

describe Logline do
  before(:each) do
    @script = Logline::Script.from_fdx(File.dirname(__FILE__) + '/fixtures/hacker.fdx')
  end
  it "should load an fdx file" do
    @script.should be_kind_of(Logline::Script)
  end

  it "should recognize all paragraphs" do
    @script.paragraphs.size.should == 10
    @script.paragraphs[0].should be_kind_of(Logline::Script::Heading)
    @script.paragraphs[1].should be_kind_of(Logline::Script::Action)
  end

  it "should convert it into a scrippet" do
    @script.to_scrippet.should == <<-EOF
INT. BEDROOM - NIGHT

A computer nerd in his late 20’s, BENJAMIN SANDOFSKY, hacks away at a ruby library for parsing Final Draft FDX files.

BEN
Eureka!

He pounds return and we

CUT TO:

EXT. HOUSE

The roof collapses in. The hacker emerges from the ruble, coughs.

BEN
Back to the drawing board.
EOF
  end
  
  context "#scenes" do
    it "breaks up paragraphs by scene" do
      @script.scenes.size.should == 2
      @script.scenes[0].should be_kind_of(Logline::Script::Scene)
    end
    
    it "contains all paragraphs in the scene" do
      @script.scenes[0].paragraphs.size.should == 6
      @script.scenes[0].paragraphs[0].should be_kind_of(Logline::Script::Heading)
    end
    
    it "has a title" do
      @script.scenes[0].title.should == 'My first scene'
    end
    
    it "has a heading" do
      @script.scenes[0].heading.should be_kind_of(Logline::Script::Heading)
      @script.scenes[0].heading.content.should == 'Int. Bedroom - night'
    end
    
    it "has a page number" do
      @script.scenes[0].page.should == 1
    end
    
    it "has a page length" do
      @script.scenes[0].page_length.should == 0.25
    end
    
    it "has a page fraction" do
      @script.scenes[0].page_fraction.should == '2/8'
    end
  end
  

end
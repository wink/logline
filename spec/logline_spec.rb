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
    @script.to_scrippet.should == <<-END
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
END
  end

end

require 'spec_helper'
require 'card_data'

describe CardData do
  context "class methods" do
    context ".from_s" do
      it "should handle an empty dump" do
        derp = described_class.from_s("%?;?+?")
        derp.should respond_to(:track_1)
        derp.should respond_to(:track_2)
        derp.should respond_to(:track_3)
      end
    end
  end

  context "with empty tracks" do
    context "#to_s" do
      it "should return a String" do
        s = subject.to_s
        s.should be_a(String)
        s.should == "\x02\x03"
      end
    end
  end

  context "with track data" do
    subject do
      described_class.new("asdf", "jkl", "qwer")
    end

    it "should have 3 tracks" do
      subject.track_1.should == "asdf"
      subject.track_2.should == "jkl"
      subject.track_3.should == "qwer"
    end

    it "should return raw data" do
      subject.to_s.should == "\x02%asdf?;jkl?+qwer?\x03"
    end
  end
end

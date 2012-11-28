
shared_examples_for "a dump" do
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
    let(:track_1) {
      "B4532691540987877^MCFAKEPANTS/FAKEY J^1304101100001000000000643000000"
    }
    let(:track_2) { "4532691540987877=1304101100001643" }
    let(:track_3) { "" }
    subject do
      described_class.new(track_1, track_2, track_3)
    end

    it "should have 3 tracks" do
      subject.track_1.should == track_1
      subject.track_2.should == track_2
      subject.track_3.should == track_3
    end

    it "should return raw data" do
      subject.to_s.should include(track_1)
      subject.to_s.should include(track_2)
      subject.to_s.should include(track_3)
    end
  end
end

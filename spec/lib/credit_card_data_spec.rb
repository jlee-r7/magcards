
require 'spec_helper'
require 'card_data'
require 'credit_card_data'
require 'lib/card_data_shared'

describe CreditCardData do
  it_behaves_like "a dump"

  context "with a valid dump" do
    valid_dumps = [
      # Visa
      {
        :type => "visa",
        :number => "4532691540987877",
        :dump => "\x02%B4532691540987877^MCFAKEPANTS/FAKEY J^1304101100001000000000643000000?;4532691540987877=1304101100001643?\x03",
      },
      {
        :type => "amex",
        :number => "349485681971183",
        :dump => "\x02;349485681971183=130410111088875500000?\x03"
      },
      {
        :type => "mastercard",
        :number => "5330193338347225",
        :dump => "\x02;5330193338347225=130410100000634?\x03"
      },
    ]

    valid_dumps.each do |dump|
      it "should be a valid #{dump[:type]}" do
        derp = described_class.from_s(dump[:dump])
        derp.should be_valid
        derp.number.should == dump[:number]
        derp.expiration.should == "1304"
      end
    end
  end
  context "with invalid number" do
    it "shouldn't be valid" do
      derp = described_class.from_s("\x02%B7?\x03")
      derp.should_not be_valid
      derp.expiration.should be_nil
      derp.discretionary.should be_nil
      derp.name.should be_nil
    end
  end
end


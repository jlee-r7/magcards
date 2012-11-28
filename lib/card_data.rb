#!/usr/bin/env ruby
# encoding: ascii-8bit

#
# Track data from a magnetic-stripe card
#
class CardData

  # @return [String]
  attr_accessor :track_1
  # @return [String]
  attr_accessor :track_2
  # @return [String]
  attr_accessor :track_3

  #
  # Create a new instance with the given raw track data
  #
  # @param str [String] Raw track data as returned by {CardReader#read}
  # @return [CardData] A new instance with tracks parsed out of +str+
  def self.from_s(str)
    cd = new
    cd.parse!(str)

    cd
  end

  def initialize(t1=nil, t2=nil, t3=nil)
    self.track_1 = t1
    self.track_2 = t2
    self.track_3 = t3
  end

  # Replace the current track data with what can be parsed out of +str+
  #
  # @param str [String] Track data as returned from {CardReader#read}
  # @return [self]
  #
  def parse!(str)
    puts "parsing #{str.inspect}" if $debug
    str =~ /^#{0x02.chr}
      (?:%(.*?)\?)?   # Track 1
      (?:;(.*?)\?)?   # Track 2
      (?:\+(.*?)\?)?  # Track 3
      #{0x03.chr}$/x
    self.track_1 = $1
    self.track_2 = $2
    self.track_3 = $3

    self
  end

  #
  # Convert the current track data to a String usable by {CardReader#write}
  #
  # @return [String] Track data to write back out using {CardReader#write}
  def to_s
    s =  "#{0x02.chr}"
    s << "%#{track_1}?" if track_1
    s << ";#{track_2}?" if track_2
    s << "+#{track_3}?" if track_3
    s << "#{0x03.chr}"

    s
  end

  alias to_raw to_s

  #
  # Return a human-readable string describing this {CardData}
  #
  # @return [String]
  def inspect
    "Track-1: #{track_1.inspect}; Track-2: #{track_2.inspect}; Track-3: #{track_3.inspect}"
  end

  #
  # Return a sequence of hex bytes describing this {CardData}
  #
  # @return [String]
  def to_hex
    s = ""
    self.to_s.each_byte {|c| s << "%.02x "%(c) }
    s
  end

end


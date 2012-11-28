#!/usr/bin/env ruby
# encoding: ascii-8bit

require "serialport"
require "pathname"

$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.to_s)
require "card_data"


class CardReader

  # The device file associated with this {CardReader}. Usually /dev/ttyUSB0
  #
  # @return [String]
  attr_accessor :device

  # @return [SerialPort]
  attr_accessor :serial

  #
  # Open the given device as a SerialPort. Hardcoded with 9600:N:8:1, because
  # I'm lazy.
  #
  # @param device [String] The serial device file associated with your card
  #   reader
  def initialize(device="/dev/ttyUSB0")
    self.device = device
    port_str = device
    baud_rate = 9600
    parity = SerialPort::NONE
    data_bits = 8
    stop_bits = 1

    self.serial = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
  end

  #
  # Write the given data on the next swipe. If the reader says the write
  # failed, this will loop, asking for another swipe.
  #
  # @param data [String,#to_s,#inspect] Raw data to store on the next swiped
  #   card. Can be an instance of {CardData}
  # @return [void]
  def write(data="")
    puts "Writing data: #{data.inspect}"
    puts "Raw data:     #{data.to_s.inspect}"
    serial.write(data.to_s)
    while true
      s = read.to_s
      break if s[0,1] != 0x15.chr
      puts "Write failed, swipe again"
    end
    puts "Write succeeded: #{s.inspect}"

    nil
  end

  #
  # Read in data from a swipe
  #
  # @return [String]
  def read
    s = ""
    while true do
      char = serial.getc.unpack("C").first
      s << char
      case char.ord
      when 0x03
        break
      when 0x15
        puts "Read failed"
        return false
      else
        #puts "Other byte (#{sprintf("%.02x", char.ord)})"
      end
    end

    #puts "Raw: #{s.inspect}"
    #CardData.from_s(s)
    s
  end

end

if __FILE__ == $0
  cr = CardReader.new("/dev/ttyUSB0")

  while true
    raw = cr.read
    p raw
    cd = CardData.from_s(raw)
    p cd
  end
end


#!/usr/bin/env ruby
# encoding: ascii-8bit

$:.push "."

require 'card_data'
require 'card_reader'

reader = CardReader.new("/dev/ttyUSB0")

puts "Swipe card now"
raw = reader.read
puts "Read: #{raw.inspect}"

puts "Attempting to write, swipe new card now"
reader.write(raw)

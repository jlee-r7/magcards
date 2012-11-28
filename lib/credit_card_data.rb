
class CreditCardData < CardData

  attr_accessor :number
  attr_accessor :sum
  attr_accessor :name
  attr_accessor :expiration
  attr_accessor :service_code
  attr_accessor :discretionary

  def parse!(str)
    super

    if track_1
      number,@name,extra = track_1.split(/[\^]/)
      number = number[1,number.length]
    elsif track_2
      number,extra = track_2.split("=")
    else
      return
    end

    if extra
      @expiration = extra[0,4]
      @service_code = extra[4,3]
      @discretionary = extra[7,extra.length]
    end

    # Luhn algorithm stolen from
    # https://github.com/LtCmdDudefellah/cc_validator/blob/master/creditcard.rb
    @number = number
    @sum = 0

    numbers = @number.to_s.split('').reverse.map(&:to_i)
    numbers.each_with_index do |num, i|
      if (i % 2).zero?
        @sum += num
      else
        dbl = (num * 2).to_s.split('').map!(&:to_i)
        @sum += dbl.inject(0) {|a, b| a + b }
      end
    end

  end

  def valid?
    return false unless sum
    return (sum % 10).zero?
  end
end


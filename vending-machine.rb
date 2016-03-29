class VendingMachine
  
  attr_reader :running_total
  
  def initialize
    @running_total = 0.00
    @display_prompts = ""
    @returned_coins = []

    update_display "INSERT COIN"
  end
  
  def receive_coin(coin)
    case coin
    when :n, :nickel
      @running_total += 0.05
    when :d, :dime
      @running_total += 0.10
    when :q, :quarter
      @running_total += 0.25
    else
      @returned_coins << coin
    end
  end
  
  def update_display(prompt)
    @display_prompts += prompt
    present_display
  end
  
  def present_display
    @display_prompts
  end
  
  def coin_return
    @returned_coins
  end
  
end

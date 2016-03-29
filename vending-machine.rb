class VendingMachine
  
  attr_reader :running_total
  
  def initialize
    @running_total = 0.00
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
  
  def dispense_product(product)
    @dispensed_product = product
    update_display "THANK YOU"
  end
  
  def update_display(prompt)
    @display_prompt = prompt
    present_display
  end
  
  def present_display
    @display_prompt
  end
  
  def coin_return
    @returned_coins
  end
  
  def product_return
    update_display "INSERT COIN"
    @running_total = 0.00
    @dispensed_product
  end
  
end

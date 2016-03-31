class VendingMachine
  
  attr_reader :running_total
  
  def initialize
    @running_total = 0.00
    @returned_coins = []
    @coins_to_return = []

    update_display "INSERT COIN"
  end
  
  def receive_coin(coin)
    case coin
    when :n, :nickel
      @coins_to_return << coin
      @running_total += 0.05
    when :d, :dime
      @coins_to_return << coin
      @running_total += 0.10
    when :q, :quarter
      @coins_to_return << coin
      @running_total += 0.25
    else
      @returned_coins << coin
    end
  end
  
  def receive_product_choice(chosen_product)
    @chosen_product = chosen_product
    
    case chosen_product
    when :cola
      necessary_amount = 1.00
    when :chips
      necessary_amount = 0.50
    when :candy
      necessary_amount = 0.65
    end
    
    if necessary_amount
      if necessary_amount == @running_total
        update_display "THANK YOU"
      else
        update_display "PRICE $#{sprintf('%.2f', necessary_amount)} | DEPOSITED $#{@running_total}"
      end
    else
      update_display "CHOICE NOT AVAILABLE, SORRY."
    end
  end
  
  def present_display
    @display_prompt
  end
  
  def coin_return
    return @returned_coins if @returned_coins.any?
    return @coins_to_return if @coins_to_return.any?
  end
  
  def dispense_product
    update_display "INSERT COIN"
    @running_total = 0.00
    @chosen_product
  end
  
  def dispensed_product
    @chosen_product
  end
  
  def return_coins
    returned_coins = @running_total
    @running_total = 0.00
    update_display "INSERT COIN"
    returned_coins
  end
  
  private
  
    def update_display(prompt)
      @display_prompt = prompt
      present_display
    end
  
end

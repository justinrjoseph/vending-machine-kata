class VendingMachine
  
  attr_reader :running_total
  
  def initialize
    @change_available = 0.00
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
  
    @coins_to_return = []

    if necessary_amount
      if ( necessary_amount == @running_total ) || ( @running_total > necessary_amount )
        issue_change(necessary_amount) if @running_total > necessary_amount
        update_display "THANK YOU"
      else
        update_display "PRICE $#{sprintf('%.2f', necessary_amount)} | DEPOSITED $#{@running_total}"
      end
    else
      update_display "SOLD OUT"
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
  
  def issue_change(necessary_amount)
    amount_to_return = ( @running_total - necessary_amount ).round 2

    case amount_to_return
    when 1.00
      4.times { @coins_to_return << :quarter }
    when 0.75
      3.times { @coins_to_return << :quarter }
    when 0.50
      2.times { @coins_to_return << :quarter }
    end
    
    if amount_to_return >= 0.25 && amount_to_return < 0.50
      @coins_to_return << :quarter
      
      2.times { @coins_to_return << :dime } if amount_to_return > 0.4
      
      @coins_to_return << :dime << :nickel if amount_to_return == 0.4
      
      @coins_to_return << :dime if amount_to_return == 0.35
      
      @coins_to_return << :nickel if amount_to_return == 0.3
    end
    
    if amount_to_return >= 0.10 && amount_to_return <= 0.20
      2.times { @coins_to_return << :dime } if amount_to_return == 0.20
      
      @coins_to_return << :dime << :nickel if amount_to_return == 0.15
      
      @coins_to_return << :dime
    else
      @coins_to_return << :nickel
    end
  end
  
  def refresh_state_after_sold_out
    @running_total > 0 ? update_display("DEPOSITED $#{@running_total}") : update_display("INSERT COIN")
  end
  
  def requires_exact_change
    update_display "EXACT CHANGE ONLY" if @change_available = 0.00
  end
  
  private
  
    def update_display(prompt)
      @display_prompt = prompt
      present_display
    end
  
end

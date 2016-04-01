class VendingMachine
  
  attr_reader :running_total
  
  def initialize
    @change_available = 0.00
    @running_total = 0.00
    @returnable_coins = []

    update_display "INSERT COIN"
  end
  
  def accept_coin(coin)
    @returnable_coins << coin

    case coin
    when :n, :nickel
      @running_total += 0.05
    when :d, :dime
      @running_total += 0.10
    when :q, :quarter
      @running_total += 0.25
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
      @returnable_coins = []
      
      if necessary_amount == @running_total
        update_display "THANK YOU"
      elsif @running_total > necessary_amount
        issue_change necessary_amount
        update_display "THANK YOU"
      else
        update_display "PRICE $#{sprintf('%.2f', necessary_amount)} | DEPOSITED $#{@running_total}"
      end
    else
      update_display "SOLD OUT"
    end
  end
  
  def display
    @display_prompt
  end
  
  def coin_return
    @returnable_coins
  end
  
  def dispense_product
    @running_total = 0.00
    update_display "INSERT COIN"
    @chosen_product
  end
  
  def dispensed_product
    @chosen_product
  end
  
  def issue_change(necessary_amount)
    amount_to_return = ( @running_total - necessary_amount ).round 2

    case amount_to_return
    when 1.00
      4.times { @returnable_coins << :quarter }
    when 0.75
      3.times { @returnable_coins << :quarter }
    when 0.50
      2.times { @returnable_coins << :quarter }
    end
    
    if amount_to_return >= 0.25 && amount_to_return < 0.50
      2.times { @returnable_coins << :dime } if amount_to_return > 0.4
      
      @returnable_coins << :dime << :nickel if amount_to_return == 0.4
      
      @returnable_coins << :dime if amount_to_return == 0.35
      
      @returnable_coins << :nickel if amount_to_return == 0.3
      
      @returnable_coins << :quarter
    end
    
    if amount_to_return >= 0.10 && amount_to_return <= 0.20
      2.times { @returnable_coins << :dime } if amount_to_return == 0.20
      
      @returnable_coins << :dime << :nickel if amount_to_return == 0.15
      
      @returnable_coins << :dime
    else
      @returnable_coins << :nickel
    end
  end
  
  def refresh_state_after_sold_out
    @running_total > 0 ? update_display("DEPOSITED $#{@running_total}") : update_display("INSERT COIN")
  end
  
  def requires_exact_change
    update_display "EXACT CHANGE ONLY" if @change_available == 0.00
  end
  
  private
  
    def update_display(prompt)
      @display_prompt = prompt
      display
    end
  
end

require 'minitest/autorun'
require './vending-machine.rb'

class VendingMachineTest < MiniTest::Test
  
  def setup
    @vm = VendingMachine.new
    
    assert_equal "INSERT COIN", @vm.display, "Venching machine does not prompt with 'INSERT COIN'?"
  end

  def test_vending_machine_accepts_nickels
    vending_machine_acccepts? :nickel, 0.05
  end
  
  def test_vending_machine_accepts_dimes
    vending_machine_acccepts? :dime, 0.10
  end
  
  def test_vending_machine_accepts_quarters
    vending_machine_acccepts? :quarter, 0.25
  end
  
  def test_vending_machine_rejects_pennies
    vending_machine_acccepts? :penny, 0.00
    
    assert_equal [:penny], @vm.coin_return, "Vending machine's coin return is empty?"
  end

  def test_customer_purchases_cola_from_vending_machine
    deposit_coins [4, :quarter]
    
    choose_product :cola
  end

  def test_customer_purchases_chips_from_vending_machine
    deposit_coins [2, :quarter]
    
    choose_product :chips
  end

  def test_customer_purchases_candy_from_vending_machine
    deposit_coins [[2, :quarter], [1, :dime], [1, :nickel]]
    
    choose_product :candy
  end
  
  def test_customer_needs_more_money_for_cola
    deposit_coins [3, :quarter]
    
    validate_remaining_amount_needed :cola, 1, 0.75
  end

  def test_customer_needs_more_money_for_chips
    deposit_coins [[1, :quarter], [1, :dime]]
    
    validate_remaining_amount_needed :chips, 0.5, 0.35
  end

  def test_customer_needs_more_money_for_candy
    deposit_coins [[2, :quarter], [1, :dime]]
    
    validate_remaining_amount_needed :candy, 0.65, 0.60
  end

  def test_vending_machine_returns_four_quarters
    coins = [4, :quarter]
    
    deposit_coins coins
    
    validate_coin_return coins
  end

  def test_vending_machine_returns_five_dimes
    coins = [5, :dime]
    
    deposit_coins coins
    
    validate_coin_return coins
  end

  def test_vending_machine_returns_ten_nickels
    coins = [10, :nickel]
    
    deposit_coins coins
    
    validate_coin_return coins
  end

  def test_vending_machine_returns_two_quarters_and_one_dime
    coins = [[2, :quarter], [1, :dime]]
    
    deposit_coins coins
    
    validate_coin_return coins
  end

  def test_vending_machine_returns_one_quarter_two_dimes_and_one_nickel
    coins = [[1, :quarter], [2, :dime], [1, :nickel]]
    
    deposit_coins coins
    
    validate_coin_return coins
  end

  def test_vending_machine_issues_ten_cents_change_for_candy
    deposit_coins [3, :quarter]
    
    choose_product :candy
    
    validate_change_returned [1, :dime]
  end

  def test_vending_machine_is_sold_out_of_gum
    choose_product :gum
  end

  def test_vending_machine_is_sold_out_of_candy_bar
    deposit_coins [3, :quarter]
    
    choose_product :candy_bar
  end
  
  def test_vending_machine_requires_exact_change
    validate_vending_machine_requires_exact_change
  end

  private
  
    def vending_machine_acccepts?(coin, amount)
      @vm.accept_coin coin
      
      assert_equal amount, @vm.running_total, "Vending machine does not accept #{coin.to_s}s?"
    end
    
    def deposit_coins(deposits)
      if deposits.flatten.count == 2
        total_coins = deposits[0]
        coin = deposits[1]
      
        total_coins.times { @vm.accept_coin coin }
      else
        deposits.each do |total_coins, coin|
          total_coins.times { @vm.accept_coin coin }
        end
      end
    end
    
    def choose_product(product)
      @vm.receive_product_choice product
    
      if [:cola, :chips, :candy].include? product
        assert_equal "THANK YOU", @vm.display, "Vending machine does not display 'THANK YOU'?"
      
        @vm.dispense_product
      
        assert_equal product, @vm.dispensed_product, "Vending machine did not dispense #{product}?"
        assert_equal 0.00, @vm.running_total, "Vending machine running total not reset?"
        assert_equal "INSERT COIN", @vm.display, "Vending machine does not prompt with 'INSERT COIN'?"
      else
        validate_sold_out
        
        validate_vending_machine_state_after_sold_out
      end
    end
    
    def validate_remaining_amount_needed(product, amount, short_amount)
      amount = '%.2f' % amount
      
      assert_equal short_amount, @vm.running_total, "Vending machine total not $#{short_amount}?"
    
      @vm.receive_product_choice product
    
      assert_equal "PRICE $#{amount} | DEPOSITED $#{@vm.running_total}", @vm.display, "Vending machine does not display 'PRICE $#{amount} | DEPOSITED $#{short_amount}?"
    end
    
    def validate_coin_return(coins)
      if coins.flatten.count == 2
        count = coins[0]
        coin = coins[1]
  
        assert_equal count, @vm.coin_return.count, "Vending machine did not return #{count} #{coin}(s)?"
        assert_equal coin, @vm.coin_return.uniq.first, "Vending machine did not a #{coin}?"
      else
        coins.each do |total_coins, coin|
          assert_equal total_coins, @vm.coin_return.count(coin), "Vending machine did not return #{total_coins} #{coin}(s)?"
          assert @vm.coin_return.uniq.include?(coin), "Vending machine did not a #{coin}?"
        end
      end
      
      assert_equal "INSERT COIN", @vm.display, "Venching machine does not prompt with 'INSERT COIN'?"
    end
    
    def validate_change_returned(coins)
      validate_coin_return(coins)
    end
    
    def validate_sold_out
      assert_equal "SOLD OUT", @vm.display, "Vending machine does not prompt with 'SOLD OUT'?"
    end
    
    def validate_vending_machine_state_after_sold_out
      @vm.refresh_state_after_sold_out
      
      if @vm.running_total > 0.00
        assert_equal "DEPOSITED $#{@vm.running_total}", @vm.display, "Vending machine does not prompt with 'DEPOSITED $#{@running_total}'?"
      else
        assert_equal "INSERT COIN", @vm.display, "Vending machine does not prompt with 'INSERT COIN'?"
      end
    end
    
    def validate_vending_machine_requires_exact_change
      @vm.requires_exact_change

      assert_equal "EXACT CHANGE ONLY", @vm.display, "Vending machine does not prompt with 'EXACT CHANGE ONLY'?"
    end

end

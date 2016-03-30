require 'minitest/autorun'
require './vending-machine.rb'

class VendingMachineTest < MiniTest::Test
  
  def setup
    @vm = VendingMachine.new
    
    assert_equal "INSERT COIN", @vm.present_display, "Venching machine does not prompt with 'INSERT COIN'?"
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
    
    assert @vm.coin_return.include?(:penny), "Vending machine's coin return is empty?"
  end

  def test_customer_purchases_cola_from_vending_machine
    deposit_coins [4, :quarter]
    
    choose_product :cola, 1.00
  end

  def test_customer_purchases_chips_from_vending_machine
    deposit_coins [2, :quarter]
    
    choose_product :chips, 0.50
  end

  def test_customer_purchases_candy_from_vending_machine
    deposit_coins [[2, :quarter], [1, :dime], [1, :nickel]]
    
    choose_product :candy, 0.65
  end
  
  private
  
    def vending_machine_acccepts?(coin, amount)
      @vm.receive_coin coin
      
      assert_equal amount, @vm.running_total, "Vending machine does not accept #{coin.to_s}s?"
    end
    
    def deposit_coins(deposits)
      if deposits.count == 2
        total_coins = deposits[0]
        coin = deposits[1]
      
        total_coins.times { @vm.receive_coin coin }
      else
        deposits.each do |total_coins, coin|
          total_coins.times { @vm.receive_coin coin }
        end
      end
    end
    
    def choose_product(product, amount)
      @vm.receive_product_choice product
    
      assert_equal "THANK YOU", @vm.present_display, "Vending machine does not display 'THANK YOU'?"
    
      @vm.dispense_product
    
      assert_equal product, @vm.dispensed_product, "Vending machine did not dispense #{product}?"
      assert_equal 0.00, @vm.running_total, "Vending machine running total not reset?"
      assert_equal "INSERT COIN", @vm.present_display, "Vending machine does not prompt with 'INSERT COIN'?"
    end

end

require 'minitest/autorun'
require './vending-machine.rb'

class VendingMachineTest < MiniTest::Test
  
  def setup
    @vm = VendingMachine.new
    
    assert_equal "INSERT COIN", @vm.present_display, "Venching machine does not prompt with 'INSERT COIN'?"
  end
  
  def test_vending_machine_accepts_nickels
    @vm.receive_coin :nickel
    
    assert_equal 0.05, @vm.running_total, "Vending machine does not accept nickels?"
  end
  
  def test_vending_machine_accepts_dimes
    @vm.receive_coin :dime
    
    assert_equal 0.10, @vm.running_total, "Vending machine does not accept dimes?"
  end
  
  def test_vending_machine_accepts_quarters
    @vm.receive_coin :quarter
    
    assert_equal 0.25, @vm.running_total, "Vending machine does not accept quarters?"
  end
  
  def test_vending_machine_rejects_pennies
    @vm.receive_coin :penny
    
    assert_equal 0.00, @vm.running_total, "Vending machine accepts pennies?"
    assert @vm.coin_return.include?(:penny), "Venching machine's coin return empty?"
  end
  
end

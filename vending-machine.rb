require 'minitest/autorun'

class VendingMachine
  attr_reader :running_total
  
  def initialize
    @running_total = 0
  end
  
  def receive_coin(coin)
    case coin
    when :n, :nickel
      @running_total += 0.05
    when :d, :dime
      @running_total += 0.10
    when :q, :quarter
      @running_total += 0.25
    end
  end
  
end



class VendingMachineTest < MiniTest::Test
  
  def setup
    @vm = VendingMachine.new
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
  
end
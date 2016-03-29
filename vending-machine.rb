require 'minitest/autorun'

class VendingMachine
  
  def receive_coin(coin)
    @running_total = 0
    
    case coin
    when :n, :nickel
      @running_total += 0.05
    end
  end
  
  def running_total
    @running_total
  end
  
end



class VendingMachineTest < MiniTest::Test
  
  def test_vending_machine_accepts_nickels
    @vm = VendingMachine.new
    
    @vm.receive_coin :nickel
    
    assert_equal 0.05, @vm.running_total, "Vending machine does not accept nickels?"
  end
  
end
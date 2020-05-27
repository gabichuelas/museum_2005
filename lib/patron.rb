class Patron
  attr_reader :name, :spending_money
  def initialize(name, money)
    @name = name
    @spending_money = money
  end
end

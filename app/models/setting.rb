class Setting
  attr_accessor :currency, :currency_symbol

  def initialize
    self.currency = 'Taka'
    self.currency_symbol = '$'
  end
end
class Money
  self.default_bank.add_rate('BDT', 'USD', 0.012)

  def to_display
    Money.new(self.fractional * 100, self.currency).format
  end
end
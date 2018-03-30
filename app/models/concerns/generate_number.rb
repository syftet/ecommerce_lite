module GenerateNumber
  extend ActiveSupport::Concern

  BASE = 10
  DEFAULT_LENGTH = 9
  NUMBERS = (0..9).to_a.freeze
  LETTERS = ('A'..'Z').to_a.freeze

  included do
    validates(:number, presence: true, uniqueness: true)
    before_validation do
      self.number ||= generate_permalink
    end
  end

  def generate_permalink
    length = DEFAULT_LENGTH
    loop do
      candidate = new_candidate(length)
      return candidate unless self.class.exists?(number: candidate)
      length += 1 if self.class.count > Rational(BASE**length, 2)
    end
  end

  def new_candidate(length)
    candidates = NUMBERS + LETTERS
    (self.prefix || 'OR-') + length.times.map { candidates.sample(random: Random.new) }.join
  end

end
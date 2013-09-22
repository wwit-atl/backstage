class Phone < ActiveRecord::Base
  belongs_to :member
  before_save :strip_number
  #validates_length_of :number, is: 10

  def self.ntypes
    %w(Mobile Home Work Other)
  end

  def npa
    number[0..2]
  end

  def nxx
    number[3..5]
  end

  def sub
    number[6..9]
  end

  def fnumber
    '(%s) %s-%s' % [npa, nxx, sub]
  end

  private

  def strip_number
    number.gsub!(/\D/, '')
  end
end

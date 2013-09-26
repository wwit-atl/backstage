class Phone < ActiveRecord::Base
  belongs_to :member
  before_validation :strip_number
  validates_length_of :number, is: 10

  scope :by_type, ->{ order(:ntype) }

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

  def listing
    "#{fnumber} (#{ntype[0].downcase})"
  end

  private

  def strip_number
    return false if number.nil?
    number.gsub!(/\D/, '')
  end
end

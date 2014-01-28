class Phone < ActiveRecord::Base
  belongs_to :member
  before_validation :strip_number
  validates_length_of :number, minimum: 10, allow_blank: true

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
    '%s-%s-%s' % [npa, nxx, sub]
  end

  def ntype_abbr
    "<abbr title=#{ntype}>#{ntype[0].downcase}</abbr>"
  end

  def listing
    "#{fnumber} (#{ntype_abbr})".html_safe
  end

  def long_listing
    "#{ntype}: #{fnumber}"
  end

  def as_tel_link
    "tel:+1#{number}"
  end

  private

  def strip_number
    return false if number.nil?
    number.gsub!(/\D/, '')
  end
end

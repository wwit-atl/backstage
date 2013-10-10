class Skill < ActiveRecord::Base
  resourcify

  has_and_belongs_to_many :members
  has_many :notes, :as => :notable
  has_many :shows, :through => :shifts

  validates_presence_of :code, :name

  before_save do
    code.upcase!
  end

  scope :crewable, -> { where(category: 'Crew') }
  scope :castable, -> { where(category: 'Cast') }
  scope :find_code, lambda { |code| where(code: code.to_s.upcase) }

  def self.categories
    %w(Cast Crew Performance)
  end

  class << self
    def method_missing(method_id, *arguments, &block)
      obj = find_code(method_id).first
      return obj unless obj.blank?

      super
    end

    def respond_to?(method_id, include_private = false)
      if find_code(method_id).empty?
        super
      else
        true
      end
    end
  end

end

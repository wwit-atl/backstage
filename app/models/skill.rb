class Skill < ActiveRecord::Base
  resourcify

  has_and_belongs_to_many :members
  has_many :notes, :as => :notable
  has_many :shows, :through => :shifts

  validates_presence_of :code, :name

  before_save do
    code.upcase!
  end

  scope :crewable, -> { where(:category => :crew) }
  scope :castable, -> { where(:category => :cast) }

  scope :with_code, lambda { |code| where(code: code.to_s.upcase) }

  scope :by_code, -> { order(:code) }

  class << self
    def categories
      %w(cast crew performance)
    end

    #def method_missing(method_id, *arguments, &block)
    #  with_code(method_id).first || super
    #end

    #def respond_to?(method_id, include_private = false)
    #  !with_code(method_id).first.nil?
    #end
  end

end

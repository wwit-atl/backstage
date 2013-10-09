class Skill < ActiveRecord::Base
  resourcify

  has_and_belongs_to_many :members
  has_many :notes, :as => :notable
  has_many :shifts

  validates_presence_of :code, :name

  before_save do
    code.upcase!
  end

  scope :crew, -> { where(category: 'Shift') }
  scope :get_code, lambda { |code| where(code: code.upcase) }

  def self.categories
    %w(Shift Performance)
  end

  class << self
    def method_missing(method_id, *arguments, &block)
      obj = get_code(method_id.upcase)
      return obj unless obj.empty?

      super
    end

    def respond_to?(method_id, include_private = false)
      if get_code(method_id.upcase).empty?
        super
      else
        true
      end
    end
  end

end

class Address < ActiveRecord::Base
  belongs_to :member

  def self.categories
    %w(Home Work Other)
  end

end

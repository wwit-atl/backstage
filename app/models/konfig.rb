# Config is a reserved class, so we use Konfig but refer to Config in the routes
class Konfig < ActiveRecord::Base
  def self.load!
    klass = class << self; self; end
    Konfig.all.each do |c|
      klass.send(:define_method, c.name.underscore) { find(c.id).value.to_i }
    end
  end

  self.load!
end

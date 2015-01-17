# Config is a reserved class, so we use Konfig but refer to Config in the routes
class Konfig < ActiveRecord::Base
  def self.load!
    klass = class << self; self; end
    Konfig.all.each { |c| klass.send(:define_method, c.name.tableize) { find(c.id).value.to_i } }
  end

  self.load!
end

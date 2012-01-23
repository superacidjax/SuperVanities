module Vanities
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def has_vanity
      has_one :slug, :as => :vain
    end
  end
  
  
end

class ActiveRecord::Base
  include Vanities
end
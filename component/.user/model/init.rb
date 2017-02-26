class Component::User < ActiveRecord::Base
  extend Memoist

  def domain
    self.class::Domain.new(self)
  end
  memoize(:domain)

end

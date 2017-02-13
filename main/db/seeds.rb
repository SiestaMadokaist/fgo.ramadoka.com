require File.expand_path("../../application", __FILE__)
require File.expand_path("../seed/servant", __FILE__)
require File.expand_path("../seed/servant.class", __FILE__)
ActiveRecord::Base.logger = Logger.new(STDOUT)

sx = Servant.klass.map{|k| k.to_s.classify }
  .map{|k| "http://fategrandorder.wikia.com/wiki/#{k}"}
  .map{|url| Seed::ServantClass.new(url) }
sx.each do |s|
  s.seed!
end

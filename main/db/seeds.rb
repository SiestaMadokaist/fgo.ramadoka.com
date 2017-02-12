require File.expand_path("../../application", __FILE__)
require File.expand_path("../seed/servant", __FILE__)
ActiveRecord::Base.logger = Logger.new(STDOUT)
seed1 = Seed::Servant.new("http://fategrandorder.wikia.com/wiki/Artoria_Pendragon")
seed2 = Seed::Servant.new("http://fategrandorder.wikia.com/wiki/Artoria_Pendragon_(Alter)")
seed1.seed!
seed2.seed!

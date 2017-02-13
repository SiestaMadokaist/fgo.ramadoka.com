require File.expand_path("../../application", __FILE__)
require File.expand_path("../seed/servant", __FILE__)
require File.expand_path("../seed/servant.class", __FILE__)
ActiveRecord::Base.logger = Logger.new(STDOUT)

# sx = Servant.klass.map{|k| k.to_s.classify }
  # .map{|k| "http://fategrandorder.wikia.com/wiki/#{k}"}
  # .map{|url| Seed::ServantClass.new(url) }
# sx.each do |s|
  # s.seed!
# end

Component::UserAuth::Email.register!("homu@ramadoka.com", ENV["FGO_ADMIN_PASS"], "ramadoka")
user = User.first
servants = [
  Servant.lookup("morder").first,
  Servant.lookup("edmo").first,
  Servant.lookup("tamamonomae").first,
  Servant.lookup("eliza").first,
  Servant.lookup("heracles").first,
  Servant.lookup("jeanne").first,
  Servant.lookup("camilia").first,
  Servant.lookup("ibaraki").first,
  Servant.lookup("stheno").first,
  Servant.lookup("mariant").first
  Servant.lookupp("rama").first
]

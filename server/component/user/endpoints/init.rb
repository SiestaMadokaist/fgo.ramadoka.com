class Component::User::Endpoints
  module V1; end
  module V1::Web; end
  module V2; end
  module V2::Web; end
  require File.expand_path("../v1.web.grape.rb", __FILE__)
  require File.expand_path("../v2.web.grape.rb", __FILE__)
  require File.expand_path("../v1.web.sinatra.rb", __FILE__)
end

require File.expand_path("../component/init.rb", __FILE__)
require File.expand_path("../environment", __FILE__)
Dir["#{File.dirname(__FILE__)}/common/**/*.rb"].each{|f| require f}

class ActiveRecord::Base
  class << self
    def get1!(options, kwargs={})
      g = where(options).first
      if(g.nil?)
        create(options.merge(kwargs))
      else
        g
      end
    end
  end
end
module Ramadoka
  class API < Grape::API
    namespace :v1 do
      namespace :web do
        mount Component::User::Endpoints::V1::Web
      end
    end
    before do
      header["Access-Control-Allow-Origin"] = headers["Origin"]
      header["Access-Control-Allow-Headers"] = headers["Access-Control-Request-Header"]
      header["Access-Control-Allow-Methods"] = "GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD"
      header["Access-Control-Expose-Headers"] = "ETag"
      header["Access-Control-Allow-Credentials"] = "true"
    end
    format(:json)
    add_swagger_documentation(
      info: { title: "user-endpoints-v1" },
      hide_format: true,
      api_version: 1,
      mount_path: "api/docs"
    )
  end
end

ApplicationServer = Rack::Builder.new do
  map "/" do
    run Ramadoka::API
  end
end

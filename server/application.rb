require File.expand_path("../environment", __FILE__)
Dir["#{File.dirname(__FILE__)}/common/**/init.rb"].each{|f| require f}
Dir["#{File.dirname(__FILE__)}/initialization/**/init.rb"].each{|f| require f}
require File.expand_path("../component/init.rb", __FILE__)

require 'garner/mixins/active_record'
require 'garner/mixins/rack'
include Garner::Mixins::Rack
class String
  def realpath
    self
  end
end

class Hash
  def serialize(str)
    q = map{|k, v| "#{k}=#{v}"}.join("&")
    "#{str}?#{q}"
  end
end

OAuth2::Response.register_parser(:text, 'text/plain') do |body|
  kv = body
    .split("&")
    .map{|s| s.split("=")}
  Hash[kv]
  # key, value = body.split('=')
  # {key => value}
end
class Sinatra::Request
  def uri
    "#{base_url}#{path}"
  end
end
class ActiveRecord::Base
  class << self
    include Garner::Mixins::ActiveRecord::Base

    def get1(options)
      where(options).first
    end

    def get1!(options, kwargs={})
      g = get1(options)
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
        mount Component::Material::Endpoints::V1::Web
      end
    end
    before do
      header["Access-Control-Allow-Origin"] = headers["Origin"]
      header["Access-Control-Allow-Headers"] = headers["Access-Control-Request-Headers"]
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
    mount Component::User::Endpoints::V1::Web::Sinatra
  end
end

ApplicationServer = Rack::Builder.new do
  map "/" do
    run Ramadoka::API
  end
end

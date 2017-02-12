require File.expand_path("../component/init.rb", __FILE__)
module Ramadoka
  class API < Grape::API
    namespace :v1 do
      namespace :web do
      end
    end
    before do
      header["Access-Control-Allow-Origin"] = headers["Origin"]
      header["Access-Control-Allow-Headers"] = headers["Access-Control-Request-Header"]
      header["Access-Control-Allow-Methods"] = "GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD"
      header["Access-Control-Expose-Headers"] = "ETag"
      header["Access-Control-Allow-Credentials"] = "true"
    end
  end
end

ApplicationServer = Rack::Builder.new do
  map "/" do
    run Ramadoka::API
  end
end

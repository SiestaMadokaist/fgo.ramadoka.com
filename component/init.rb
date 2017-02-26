module Component
  Dir["#{File.dirname(__FILE__)}/*/init.rb"].each{|f| require f }
end

require 'memoist'
require 'set'
module Seed; end
class Seed::Servant

  extend Memoist
  attr_reader(:url)
  def initialize(url)
    @url = url
  end

  def data
    Nokogiri::HTML.parse(response)
  end
  memoize(:data)

  def name
    @url.split("/").last
  end

  def slug
    name.parameterize
  end

  def klass
    data.css(".ServantInfoClass a")
      .first
      .attributes["title"]
      .value
      .parameterize
  end

  def servant
    Servant.get1!({slug: slug}, star: star, klass: klass, name: name)
  end
  memoize(:servant)

  def store_ascend_material!(level)
    tds = data
      .css("#mw-content-text > table:nth-child(6) > tr:nth-child(#{level + 1}) .InumWrapper.hidden")
      .map do |td|
      name = td.css(".InumIconTop a").first.attributes["title"].value
      count = td.css(".InumNum").first.text.to_i
      material = Material.get1!({slug: name.parameterize}, name: name)
      material.material_servants << Component::MaterialServant::Model.new(classifier: :ascension, count: count, servant: servant, level: level)
    end
      # .map{|element| element.attributes["alt"].value }.to_set.to_a
  end

  def seed!
    (1..4).map{|i| store_ascend_material!(i)}
  end

  def name
    data.css(".ServantInfoName").first.text.strip
  end

  def star
    data
      .css(".ServantInfoStars")
      .first
      .text
      .scan(/\S/)
      .length
  end

  def response
    HTTParty.get(@url)
  end
  memoize(:response)

end

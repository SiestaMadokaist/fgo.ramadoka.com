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

  def ascension
    data.css("#Ascension").first
  end

  def table
    # data.css("#mw-content-text > table:nth-child(7)")
    ascension.parent.next_element
  end

  class NoTableFound < StandardError; end
  def store_ascend_material!(level)
    raise NoTableFound if table.name != "table"
    tds = table
      .css("tr:nth-child(#{level + 1}) .InumWrapper.hidden")
    tds
      .map do |td|
      name = td.css(".InumIconTop a").first.attributes["title"].value
      count = td.css(".InumNum").first.text.to_i
      begin
        if(name.upcase != "QP")
          material = Material.get1!({slug: name.parameterize}, name: name)
          material.material_servants << Component::MaterialServant::Model.new(classifier: :ascension, count: count, servant: servant, level: level)
        end
      rescue ActiveRecord::RecordNotUnique
        # pass
      end
    end
  end

  def seed!
    return if servant.materials.count > 0
    (1..4).map{|i| store_ascend_material!(i)}
  end

  def name
    begin
      data.css(".ServantInfoName").first.text.strip
    rescue => e
      puts("#{@url}")
      raise e
    end
  end

  def to_s
    begin
      "Servant(#{name})"
    rescue
      "Servant(#{@url})"
    end
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

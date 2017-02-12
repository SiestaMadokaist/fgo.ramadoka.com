require 'memoist'
class Seed::ServantClass
  extend Memoist
  def initialize(url)
    @url = url
  end

  def servant_wikis
    data.css(".article-thumb.tnone.show-info-icon a.image.image-thumbnail.link-internal")
      .map{|x| x.attributes["href"].value }
      .map{|x| "http://fategrandorder.wikia.com#{x}"}
  end
  memoize(:servant_wikis)

  def servants
    servant_wikis.map{|url| Seed::Servant.new(url)}
  end
  memoize(:servants)

  def seed!
    servants.map(&:seed!)
  end

  def data
    Nokogiri::HTML.parse(response)
  end
  memoize(:data)

  def response
    HTTParty.get(@url)
  end
  memoize(:response)
end

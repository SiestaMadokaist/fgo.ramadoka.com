class Component::Material::Wiki
  extend Memoist
  # @param material [Component::Material::Model]
  def initialize(material)
    @material = material
  end

  def response
    HTTParty.get(@material.wiki_url)
  end
  memoize(:response)

  def data
    Nokogiri::HTML.parse(response)
  end
  memoize(:data)

  def image
    data.css("td > img")
      .select{|x| x.attributes["data-image-key"]}
      .first
  end

  def image_url
    image.attributes["src"].value
  end

  def image_data
    HTTParty.get(image_url)
  end
  memoize(:image_data)

  def image_key_name
    image.attributes["data-image-key"].value
  end

  def save!(dir)
    File.open("#{dir}/#{@material.id}.#{image_key_name}", "wb"){|f| f.write(image_data)}
  end

end

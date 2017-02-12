class Component::MaterialServant::Model < ActiveRecord::Base
  class << self
    def name
      "MaterialServant"
    end
  end
  # before_save(:convert_classifier!)
  belongs_to(:material, class_name: "Component::Material::Model")
  belongs_to(:servant, class_name: "Component::Servant::Model")
  enum classifier: [ :ascension, :skill ]

  # CLASSIFIER = Hash[
    # ascension: 0,
    # skill: 1
  # ]
#
  # def convert_classifier!
    # return if self.classifier >= 0 and self.classifier <= 1
    # self.classifier = CLASSIFIER[self.classifier]
  # end
end

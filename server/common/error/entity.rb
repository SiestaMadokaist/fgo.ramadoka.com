module ERR
  class Presenter < Grape::Entity
    expose(:code, documentation: {type: "Integer"})
    expose(:message, documentation: {type: "String"})
  end
end

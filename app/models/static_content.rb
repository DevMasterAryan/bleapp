class StaticContent
  include Mongoid::Document
  field :title, type: String
  field :content, type: String
end

class StaticContent
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :content, type: String
  field :additional, type: Mongoid::Boolean, default: false
end

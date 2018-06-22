class Faq
  include Mongoid::Document
  include Mongoid::Timestamps
  field :question, type: String
  field :answer, type: String
end

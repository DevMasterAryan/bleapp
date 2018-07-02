class Help
  include Mongoid::Document
  field :content, type: String
  field :status, type: String
  field :user_id, type: Integer

  belongs_to :user
end

class Help
  include Mongoid::Document
  field :content, type: String
  field :status, type: String
  field :user_id, type: Integer
  
  field :help_id, type: String
  field :help_description, type: String  
  belongs_to :user
end

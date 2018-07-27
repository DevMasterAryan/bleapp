class Help
  include Mongoid::Document
  field :status, type: String
  field :help_id, type: String
  field :help_description, type: String  
  
end

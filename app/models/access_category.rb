class AccessCategory
  include Mongoid::Document
  field :model_name, type: String
  field :column_name, type: String
  field :category_id, type: Integer

end

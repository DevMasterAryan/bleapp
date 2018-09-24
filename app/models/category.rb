class Category
  include Mongoid::Document

  field :name, type: String
  has_many :admin_users

  has_many :tabs, dependent: :destroy
  
end

class Category
  include Mongoid::Document

  field :name, type: String
  has_many :admin_users

  has_many :tabs, dependent: :destroy
  validates :name, :presence => true, length: {minimum: 3, maximum: 30} ,format: { with: /[A-Za-z ]+/}
  
end

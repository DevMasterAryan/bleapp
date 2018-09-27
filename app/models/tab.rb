class Tab
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :category_id, type: String
  field :is_active, type: Boolean, default: true
  field :columns, type: Hash, default: {}

  belongs_to :category
  has_many :tab_tables, dependent: :destroy
  has_many :notifications, dependent: :destroy
  validates :name, :presence => true, length: {minimum: 3, maximum: 30} ,format: { with: /[A-Za-z ]+/}
end

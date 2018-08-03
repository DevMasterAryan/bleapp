class UserPromotion
  include Mongoid::Document
  field :user_id, type: Integer
  field :promotion_id, type: Integer


  belongs_to :user
  belongs_to :promotion
end

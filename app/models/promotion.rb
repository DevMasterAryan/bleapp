class Promotion
  include Mongoid::Document
  include Mongoid::Timestamps
  field :promotion_count, type: Integer
  field :start_date, type: Time
  field :end_date, type: Time


  has_many :user_promotions
  # has_many :users, through: :user_promotions
  # has_many :user_promotions
  # has_many :promotions, through: :user_promotions
  def users
    User.in(id: user_promotions.pluck(:user_id))
  end

end

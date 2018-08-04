class UserPromotion
  include Mongoid::Document
  field :user_id, type: Integer
  field :promotion_id, type: Integer


  belongs_to :user
  belongs_to :promotion


  after_create :send_notification
   
  def send_notification
  	p "=======#{self.user_id}======"
    user = User.find_by(id: self.user_id)
    promotion = Promotion.find_by(id: self.promotion_id)
    NotificationJob.perform_later(user, promotion) 	
  end
end

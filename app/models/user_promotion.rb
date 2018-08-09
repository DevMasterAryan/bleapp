class UserPromotion
  include Mongoid::Document
  field :user_id, type: Integer
  field :promotion_id, type: Integer


  belongs_to :user
  belongs_to :promotion


  after_create :send_notification


  private
   
  def send_notification
  	p "=======#{self.user_id}======"
    user = User.find_by(id: self.user_id)
    promotion = Promotion.find_by(id: self.promotion_id)
    user.update(promotion_count: Promotion.find_by(id: self.promotion_id).promotion_count)
    NotificationJob.perform_later(user.id.as_json["$oid"], promotion&.promotion_count) 	

  end

end


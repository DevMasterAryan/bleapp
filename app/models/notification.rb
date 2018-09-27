class Notification
  include Mongoid::Document
  field :admin_user_id, type: String
  field :type, type: String
  field :tab_id, type: String 
  belongs_to :tab
  belongs_to :admin_user 
end

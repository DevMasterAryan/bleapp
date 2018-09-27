class Notification
  include Mongoid::Document
  field :emp_id, type: String
  field :type, type: Integer

  enum type: ["Notification","Approval and Notification","Approval"]
end

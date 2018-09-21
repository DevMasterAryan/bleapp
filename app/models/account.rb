class Account
  include Mongoid::Document

  field :name, type: String
  field :contact_person, type: String
  field :contact_email, type: String
  field :contact_mobile, type: String
  field :potential_site, type: String
  field :emp_id, type: String
   
end

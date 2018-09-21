class SiteManagement
  include Mongoid::Document
  include Mongoid::Timestamps
   
  field :lead_id,  type: String
  field :d3_id, type: String
  field :site_manager, type: String
  field :site_installer_id, type: String
  field :site_installer_status_report, type: Boolean, default: false 
  field :attachment, type: String
  field :site_approval, type: Boolean, default: false
  field :site_activation_date, type: Boolean, default: false
  

end

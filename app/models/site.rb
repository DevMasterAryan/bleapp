class Site
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  field :site_name, type: String
  field :location_address, type: String
  field :address, type: String
  field :lat, type: Float
  field :long, type: Float
  #fields added after payment integration
  field :account_id, type: String
  field :site_person, type: String
  field :site_mobile, type: String
  field :estimated_value, type: String
  field :sales_emp_id, type: String  # auto
  field :attachment, type: String
  field :quotation_id, type: String
  field :emp_remarks, type: String
  field :escalation_one, type: String
  field :escalation_two, type: String
  field :status_one, type: String
  field :status_two, type: String
  field :site_manager_id, type: String
  field :manager_id, type: String #auto
  field :est_close_date, type: Time
  field :s1_close_date, type: Time
  field :s2_close_date, type: Time
  field :manager_remark, type: String

  
  # field :coordinates, :type => Array
  # field :longitude, :type=> Float
  # field :latitude, :type=> Float

  has_many :devices
  #association added after payment gateway integration
  belongs_to :account, optional: true 
  has_many :quotations
  

  def self.search lati, longi
    result = Array.new
    self.all.each do |position|
      lat = position.lat
      long = position.long
      distance_in_km = Geocoder::Calculations.distance_between([lati,longi], [lat,long]) * 1.60934
      result << position if distance_in_km <= 3
    end
    result
  end
end

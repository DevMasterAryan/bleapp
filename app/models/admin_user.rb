class AdminUser
  include Mongoid::Document
  include RememberMe::Model
  include ActiveModel::SecurePassword
  field :email, type: String
  field :password_digest, type: String
  field :remember_created_at,type: Time
  field :type, type: String
  field :reset_digest, type: String
  field :reset_token, type: String
  field :reset_created_at, type: Time
  field :category_id, type: String
  field :department, :type=> String 
  field :designation, :type=> String 
  field :territory, :type=> String
  field :emp_id, type: String
  field :manager_id, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :phone, type: String
  field :is_active?, type: Boolean, default: false
  has_secure_password validations: false
  belongs_to :category, optional: true
  validates :password, presence: false, :on => :create
  validates :password_confirmation, presence: false, :on => :create
  
  has_many :notifications

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      AdminUser.create! row.to_hash      
    end    
  end

  def self.export(options = {})
    headers = ['first_name','last_name','emp_id','email','phone','department','designation','territory']  
    dummy = ['Lalit','Saini','02091995','saini.lalitkmr@gmail.com','9876543210','ROR','dev','LA']  
    CSV.generate(options) do |csv|
      csv << headers
      csv << dummy
    end
  end

end

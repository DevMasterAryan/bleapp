 require 'net/http'
 require 'uri' 
 require 'json'
class Billing
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Pagination
  field :session_id, type: String
  field :method_of_payment, type: String
  field :transaction_id, type: String
  field :payment_time_stamp, type: Time
  field :package_id, type: String
  field :usage_start_ts, type: Time
  field :usage_end_ts, type: Time
  field :user_id, type: String
  # field :rating, type: Integer
  # field :help_id, type: Array, default: []
  # field :help_status, type: String
  field :payment_status, type: Boolean, default: false
  field :device_battery_ts15, type: String
  field :device_battery_ts30, type: String
  field :device_battery_ts45, type: String
  field :device_battery_ts60, type: String
  field :amount, type: Float
  field :device_id, type: String
  field :charging_status, type: String
  # field :help_id, type: String
  # field :feedback, type: String
  # field :rating, type: Integer, default: 0
  # field :rating_status, type: Boolean, default: false

  index({ user_id: 1,  })

  belongs_to :transaction, optional: true
  belongs_to :session
  belongs_to :package
  belongs_to :user

  has_many :user_feedbacks

# require 'net/http'
# require 'uri' 
# require 'json'
# uri = URI.parse("https://securegw-stage.paytm.in/merchant-status/getTxnStatus")
# request = Net::HTTP::Post.new(uri) 
# request.content_type = "application/json" 
# request["Cache-Control"] = "no-cache"
# request.body = JSON.dump({ "MID" => "Wavedi27436137685521", "ORDERID" => "1533282036", "CHECKSUMHASH" => "PBDyp5R0v63PSdDe/JswAukraDzmit7pAjZdm8b+vKRTkgWEaqztr1QfNm2w9j+kUqS9wAl5fE3+J7CRmOwFQeaHdBvBQuFTjr0hUewSvy4=" })
# req_options = { use_ssl: uri.scheme == "https", } 
# response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http| http.request(request) end
# response.body




  def self.transaction_status params
    uri = URI.parse("https://securegw.paytm.in/merchant-status/getTxnStatus")
    request = Net::HTTP::Post.new(uri) 
    request.content_type = "application/json" 
    request["Cache-Control"] = "no-cache"
    request.body = JSON.dump({ "MID" => "Wavedi71402481589558", "ORDERID" => params[:order_id], "CHECKSUMHASH" => params[:checksum] })
    req_options = { use_ssl: uri.scheme == "https", } 
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http| http.request(request) end
    p "......................."
    if JSON.parse(response.body)["STATUS"]=="TXN_SUCCESS"
       return true
    else
       return false
    end 
  end

  def self.session_destroy  id, user_id
     user = User.find_by(id: user_id)



     p ".........#{user.inspect}..........................."
    
     if user.billings[-2].present?
       if user.billings.order(created_at: :asc)[-2].usage_end_ts > DateTime.current
        p "........#{user.billings[-2].usage_end_ts.inspect}.................................."

           user.billings.order(created_at: :asc)[-2].update(usage_end_ts: DateTime.current - 5.seconds)
       end
     end
     billing = Billing.find_by(id: id)
     # billing_to_destroy = Billing.where({'device_id'=> billing.device_id, 'usage_end_ts'=> {'$gt'=> DateTime.current}}) - Billing.where({'user_id'=> user_id, 'id'=> id})
     billing_to_destroy = Billing.where({'device_id'=> billing.device_id, 'usage_end_ts'=> {'$gt'=> DateTime.current}}) - Billing.where({'user_id'=> user_id})
     billing_to_destroy.each do |billing|
        billing.update(usage_end_ts: DateTime.current)
       SessionExpireJob.perform_later(billing.user.id.as_json["$oid"])
     end
  end

end


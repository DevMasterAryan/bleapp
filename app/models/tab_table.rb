class TabTable
  include Mongoid::Document
  field :tab_id, type: String
  field :table_name, type: String
  field :table_columns, type: Hash, default: {}
  belongs_to :tab

end

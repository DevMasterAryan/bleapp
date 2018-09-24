class TabTable
  include Mongoid::Document
  field :tab_id, type: String
  field :table_name, type: String
  field :table_columns, type: Array, default: []
  belongs_to :tab, dependent: :destroy

end

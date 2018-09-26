module Admin::TabsHelper
  def check_create tab, column_name
  	return true if tab&.tab_tables&.first&.table_columns["create"]&.include?(column_name)
  end


  def check_deactive tab,column_name
    return true if tab&.tab_tables&.first&.table_columns["deactive"]&.include?(column_name)
  end

  def check_compulsary tab,column_name
  	return true if tab&.tab_tables&.first&.table_columns["compulsary"]&.include?(column_name)
  end
end

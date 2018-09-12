class ExportdataController < ApplicationController
    http_basic_authenticate_with name: "admin", password: "password"
    layout :false
    def index
            @data = eval("@data = #{params[:table]}.all") if params[:table].present?
              respond_to do |format|
                format.html
                format.csv do
                response.headers["Content-Disposition"] = "attachment; filename= data.csv"
                 headers['Content-Disposition'] = "attachment; filename='#{params[:table]}.csv'"
                 headers['Content-Type'] ||= 'text/csv'
                 format.csv { render templete: index.csv.erb }
                end
              end
	end

end


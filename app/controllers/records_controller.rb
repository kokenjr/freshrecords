class RecordsController < ApplicationController
  def index
    if params[:date] == "may"
      @records = Record.where("release_date BETWEEN :date1 AND :date2", {:date1 => '2012-05-01', :date2 => '2012-05-31'})
    elsif params[:date] == "april"
      @records = Record.where("release_date BETWEEN :date1 AND :date2", {:date1 => '2012-04-01', :date2 => '2012-04-30'})
    else
      @records = Record.all
    end
  end
end

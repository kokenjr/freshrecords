class RecordsController < ApplicationController
  def index
    if params[:date] == "Today"
      @records = Record.where("release_date = :date1", {:date1 => Date.today}).paginate(:page => params[:page]).order('release_date DESC').per_page(24)
    elsif params[:date] == "Last week"
      @records = Record.where("release_date BETWEEN :date1 AND :date2", {:date1 => 1.week.ago, :date2 => Date.today}).paginate(:page => params[:page]).order('release_date DESC').per_page(24)
    elsif params[:date] == "Last month"
      @records = Record.where("release_date BETWEEN :date1 AND :date2", {:date1 => 1.month.ago, :date2 => Date.today}).paginate(:page => params[:page]).order('release_date DESC').per_page(24)
    elsif params[:date] == "Last 2 months"
      @records = Record.where("release_date BETWEEN :date1 AND :date2", {:date1 => 2.months.ago, :date2 => Date.today}).paginate(:page => params[:page]).order('release_date DESC').per_page(24)
    elsif params[:date] == "Last 3 months"
      @records = Record.where("release_date BETWEEN :date1 AND :date2", {:date1 => 3.months.ago, :date2 => Date.today}).paginate(:page => params[:page]).order('release_date DESC').per_page(24)
    elsif params[:date] == "Coming soon"
      @records = Record.where("release_date > :date1", {:date1 => Date.today}).paginate(:page => params[:page]).order('release_date ASC').per_page(24)
    else
      @records = Record.where("release_date <= :date1", {:date1 => Date.today}).paginate(:page => params[:page]).order('release_date DESC').per_page(24)
    end

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @records }
    end

  end
end

require 'will_paginate/array'

class RecordsController < ApplicationController
  def index
    case
    when params[:date] == "This week" then
      @records = Record.this_week(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "Last week" then
      @records = Record.last_week(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "2 weeks ago" then
      @records = Record.two_weeks_ago(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "Last month" then
      @records = Record.last_month(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "2 months ago" then
      @records = Record.two_months_ago(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "3 months ago" then
      @records = Record.three_months_ago(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "Coming soon" then
      @records = Record.coming_soon(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "" then
      @records = Record.all_new(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    else
      @records = Record.all_new("").paginate(:page => params[:page], :per_page => 24)
    end

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @records }
    end

  end
end

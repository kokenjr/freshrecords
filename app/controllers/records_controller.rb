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

  def comingsoon
    case
    when params[:date] == "This week" then
      @records = Record.coming_this_week(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "Next week" then
      @records = Record.next_week(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "In 2 weeks" then
      @records = Record.two_weeks_from_now(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "Next month" then
      @records = Record.next_month(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "In 2 months" then
      @records = Record.two_months_from_now(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "In 3+ months" then
      @records = Record.three_months_from_now(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "" then
      @records = Record.coming_soon(params[:genre]).paginate(:page => params[:page], :per_page => 24)
    else
      @records = Record.coming_soon("").paginate(:page => params[:page], :per_page => 24)
    end

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @records }
    end

  end

end

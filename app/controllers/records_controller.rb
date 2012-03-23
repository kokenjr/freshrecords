require 'will_paginate/array'

class RecordsController < ApplicationController
  def index
    case
    when params[:date] == "Today" && params[:genre] != "" then
      @records = Record.find(:all, :conditions => ['release_date = ? AND genre = ?', Date.today, params[:genre]], :order => 'created_at DESC').paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "Today" && params[:genre] == "" then
      @records = Record.find(:all, :conditions => ['release_date = ?', Date.today], :order => 'created_at DESC').paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "Last week" then
      @records = Record.find(:all, :conditions => ['release_date BETWEEN ? AND ?', 1.week.ago, Date.today], :order => 'release_date DESC, created_at DESC').paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "Last month" then
      @records = Record.find(:all, :conditions => ['release_date BETWEEN ? AND ?', 1.month.ago, Date.today], :order => 'release_date DESC, created_at DESC').paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "Last 2 months" then
      @records = Record.find(:all, :conditions => ['release_date BETWEEN ? AND ?', 2.months.ago, Date.today], :order => 'release_date DESC, created_at DESC').paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "Last 3 months" then
      @records = Record.find(:all, :conditions => ['release_date BETWEEN ? AND ?', 3.months.ago, Date.today], :order => 'release_date DESC, created_at DESC').paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "Coming soon" && params[:genre] != "" then
      @records = Record.find(:all, :conditions => ['release_date > ? AND genre = ?', Date.today, params[:genre]], :order => 'release_date ASC, created_at DESC').paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "Coming soon" && params[:genre] == "" then
      @records = Record.find(:all, :conditions => ['release_date > ?', Date.today], :order => 'release_date ASC, created_at DESC').paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "" && params[:genre] != "" then
      @records = Record.find(:all, :conditions => ['release_date <= ? AND genre = ?', Date.today, params[:genre]], :order => 'release_date DESC, created_at DESC').paginate(:page => params[:page], :per_page => 24)
    when params[:date] == "" && params[:genre] == "" then
      @records = Record.find(:all, :conditions => ['release_date <= ?', Date.today], :order => 'release_date DESC, created_at DESC').paginate(:page => params[:page], :per_page => 24)
    else
      @records = Record.find(:all, :conditions => ['release_date <= ?', Date.today], :order => 'release_date DESC, created_at DESC').paginate(:page => params[:page], :per_page => 24)
    end

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @records }
    end

  end
end

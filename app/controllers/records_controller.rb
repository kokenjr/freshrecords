require 'will_paginate/array'

class RecordsController < ApplicationController
  before_action :authenticate_user!, only: [:wish_list, :add_to_wish_list]
  def index
    @filterrific = initialize_filterrific(
      Record,
      params[:filterrific],
      :select_options => {
        sorted_by: Record.options_for_sorted_by,
        with_record_label: Record.label_options,
        with_released_range: Record.released_options,
        with_genre: Record.genre_options
      },
      default_filter_params: {sorted_by: "release_date_desc"}
    ) or return

    @records = @filterrific.find.where("release_date <= ?", Time.zone.today).page(params[:page])

    respond_to do |format|
      format.js
      format.html
    end
  end

  def coming_soon
    @filterrific = initialize_filterrific(
      Record,
      params[:filterrific],
      :select_options => {
        sorted_by: Record.options_for_sorted_by,
        with_record_label: Record.label_options,
        with_releasing_range: Record.releasing_options,
        with_genre: Record.genre_options
      },
      default_filter_params: {sorted_by: "release_date_asc"}
    ) or return

    @records = @filterrific.find.where("release_date > ?", Time.zone.today).page(params[:page])

    respond_to do |format|
      format.js {render "index"}
      format.html
    end
  end

  def wish_list
    @filterrific = initialize_filterrific(
      Record,
      params[:filterrific],
      :select_options => {
        sorted_by: Record.options_for_sorted_by,
        with_record_label: Record.label_options,
        with_genre: Record.genre_options
      },
      default_filter_params: {sorted_by: "name_asc"}
    ) or return

    @records = @filterrific.find.includes(:users).where("users.id = ?", current_user.id).references(:users).page(params[:page])

    respond_to do |format|
      format.js {render "index"}
      format.html
    end
  end

  def toggle_wish_list
    records_user = current_user.records.where(id: params[:id])
    if !records_user.blank?
      current_user.records.delete(records_user)
    else
      current_user.records << Record.find(params[:id])
    end
    render nothing: true
  end
end

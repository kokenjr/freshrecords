require 'will_paginate/array'

class RecordsController < ApplicationController
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

    @records = @filterrific.find.where("release_date <= ?", Date.today).page(params[:page])

    respond_to do |format|
      format.js
      format.html
    end
  end

  def comingsoon
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

    @records = @filterrific.find.where("release_date > ?", Date.today).page(params[:page])

    respond_to do |format|
      format.js {render "index"}
      format.html
    end
  end

end

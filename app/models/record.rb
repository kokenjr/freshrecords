class Record < ActiveRecord::Base
  belongs_to :artist
  has_and_belongs_to_many :users

  filterrific(
    default_filter_params: {},
    available_filters: [
      :sorted_by,
      :search_query,
      :with_record_label,
      :with_released_range,
      :with_releasing_range,
      :with_genre
    ]
  )

  scope :genrelist, -> { group(:genre).select(:genre).order('genre IS NOT NULL, genre ASC') }

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^release_date_/
      order("records.release_date #{ direction }, records.created_at DESC")
    when /^name/
      order("records.name #{ direction }, records.created_at DESC")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  scope :search_query, lambda { |query|
    return nil  if query.blank?
    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)

    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    # terms = terms.map { |e|
    #   (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    # }

    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 2
    includes(:artist).where(
    terms.map {
      or_clauses = [
        "LOWER(records.name) LIKE ?",
        "LOWER(artists.name) LIKE ?"
      ].join(' OR ')
      "(#{ or_clauses })"
    }.join(' AND '),
    *terms.map { |e| ["%#{e}%"] * num_or_conditions }.flatten
    ).references(:artist)
  }

  scope :with_record_label, lambda { |record_label|
    where(record_label: record_label)
  }

  scope :with_released_range, lambda { |release_option|
    case release_option.downcase
    when /^this week/
      where('release_date BETWEEN ? AND ?', Time.zone.today.beginning_of_week, Time.zone.today)
    when /^last week/
      where('release_date BETWEEN ? AND ?', 1.week.ago.beginning_of_week, 1.week.ago.end_of_week)
    when /^2 weeks ago/
      where('release_date BETWEEN ? AND ?', 2.weeks.ago.beginning_of_week, 2.weeks.ago.end_of_week)
    when /^last month/
      where('release_date BETWEEN ? AND ?', 1.month.ago.beginning_of_month, 1.month.ago.end_of_month)
    when /^2 months ago/
      where('release_date BETWEEN ? AND ?', 2.months.ago.beginning_of_month, 2.months.ago.end_of_month)
    when /^3 months ago/
      where('release_date BETWEEN ? AND ?', 3.months.ago.beginning_of_month, 3.months.ago.end_of_month)
    else
      raise(ArgumentError, "Invalid release option: #{ release_option.inspect }")
    end
  }

  scope :with_releasing_range, lambda { |release_option|
    case release_option.downcase
    when /^this week/
      where('release_date BETWEEN ? AND ?', Time.zone.today + 1.day, Time.zone.today.end_of_week)
    when /^next week/
      where('release_date BETWEEN ? AND ?', 1.week.from_now.beginning_of_week, 1.week.from_now.end_of_week)
    when /^in 2 weeks/
      where('release_date BETWEEN ? AND ?', 2.weeks.from_now.beginning_of_week, 2.weeks.from_now.end_of_week)
    when /^next month/
      where('release_date BETWEEN ? AND ?', 1.month.from_now.beginning_of_month, 1.month.from_now.end_of_month)
    when /^in 2 months/
      where('release_date BETWEEN ? AND ?', 2.months.from_now.beginning_of_month, 2.months.from_now.end_of_month)
    when /^in 3+ months/
      where('release_date >= ?', 3.months.from_now.beginning_of_month)
    else
      raise(ArgumentError, "Invalid release option: #{ release_option.inspect }")
    end
  }

  scope :with_genre, lambda { |genre|
    where(genre: genre)
  }

  self.per_page = 24

  def self.genre_options
    where('genre IS NOT NULL').select('DISTINCT genre').order('genre ASC').map { |r| [r.genre] }
  end

  def self.label_options
    where('record_label IS NOT NULL').select('DISTINCT record_label').order('record_label ASC').map { |r| [r.record_label] }
  end

  def self.released_options
    # ['This week', 'Last week', '2 weeks ago', 'Last month', '2 months ago', '3 months ago']
    ['This week', 'Last week', '2 weeks ago', 'Last month', '2 months ago']
  end

  def self.releasing_options
    ['This week', 'Next week', 'In 2 weeks', 'Next month', 'In 2 months', 'In 3+ months']
  end

  def self.options_for_sorted_by
    [
      ['Record Name (a-z)', 'name_asc'],
      ['Release date (descending)', 'release_date_desc'],
      ['Release date (ascending)', 'release_date_asc'],
    ]
  end

end

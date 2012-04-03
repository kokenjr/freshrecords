class Record < ActiveRecord::Base
  scope :genrelist,
    :group => 'genre', :select => 'genre', :order => 'genre IS NOT NULL, genre ASC'
  
  def self.this_week(genre)
    if genre == ""
      find(:all, :conditions => ['release_date BETWEEN ? AND ?', Date.today.beginning_of_week, Date.today], :order => 'release_date DESC, created_at DESC')
    else
      find(:all, :conditions => ['release_date BETWEEN ? AND ? AND genre = ?', Date.today.beginning_of_week, Date.today, genre], :order => 'release_date DESC, created_at DESC')
    end
  end
  
  def self.last_week(genre)
    if genre == ""
      find(:all, :conditions => ['release_date BETWEEN ? AND ?', 1.week.ago.beginning_of_week, 1.week.ago.end_of_week], :order => 'release_date DESC, created_at DESC')
    else
      find(:all, :conditions => ['release_date BETWEEN ? AND ? AND genre = ?', 1.week.ago.beginning_of_week, 1.week.ago.end_of_week, genre], :order => 'release_date DESC, created_at DESC')
    end
  end
  
  def self.two_weeks_ago(genre)
    if genre == ""
      find(:all, :conditions => ['release_date BETWEEN ? AND ?', 2.weeks.ago.beginning_of_week, 2.weeks.ago.end_of_week], :order => 'release_date DESC, created_at DESC')
    else
      find(:all, :conditions => ['release_date BETWEEN ? AND ? AND genre = ?', 2.weeks.ago.beginning_of_week, 2.weeks.ago.end_of_week, genre], :order => 'release_date DESC, created_at DESC')
    end
  end
  
  def self.last_month(genre)
    if genre == ""
      find(:all, :conditions => ['release_date BETWEEN ? AND ?', 1.month.ago.beginning_of_month, 1.month.ago.end_of_month], :order => 'release_date DESC, created_at DESC')
    else
      find(:all, :conditions => ['release_date BETWEEN ? AND ? AND genre = ?', 1.month.ago.beginning_of_month, 1.month.ago.end_of_month, genre], :order => 'release_date DESC, created_at DESC')
    end
  end
  
  def self.two_months_ago(genre)
    if genre == ""
      find(:all, :conditions => ['release_date BETWEEN ? AND ?', 2.months.ago.beginning_of_month, 2.months.ago.end_of_month], :order => 'release_date DESC, created_at DESC')
    else
      find(:all, :conditions => ['release_date BETWEEN ? AND ? AND genre = ?', 2.months.ago.beginning_of_month, 2.months.ago.end_of_month, genre], :order => 'release_date DESC, created_at DESC')
    end
  end
  
  def self.three_months_ago(genre)
    if genre == ""
      find(:all, :conditions => ['release_date BETWEEN ? AND ?', 3.months.ago.beginning_of_month, 3.months.ago.end_of_month], :order => 'release_date DESC, created_at DESC')
    else
      find(:all, :conditions => ['release_date BETWEEN ? AND ? AND genre = ?', 3.months.ago.beginning_of_month, 3.months.ago.end_of_month, genre], :order => 'release_date DESC, created_at DESC')
    end
  end
  
  def self.coming_soon(genre)
    if genre == ""
      find(:all, :conditions => ['release_date > ?', Date.today], :order => 'release_date ASC, created_at DESC')
    else
      find(:all, :conditions => ['release_date > ? AND genre = ?', Date.today, genre], :order => 'release_date ASC, created_at DESC')
    end
  end
  
  def self.all_new(genre)
    if genre == ""
      find(:all, :conditions => ['release_date <= ?', Date.today], :order => 'release_date DESC, created_at DESC')
    else
      find(:all, :conditions => ['release_date <= ? AND genre = ?', Date.today, genre], :order => 'release_date DESC, created_at DESC')
    end
  end

end

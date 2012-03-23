class Record < ActiveRecord::Base
  scope :genrelist,
    :group => 'genre', :select => 'genre', :order => 'genre IS NOT NULL, genre ASC'
end

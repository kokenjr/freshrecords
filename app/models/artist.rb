class Artist < ActiveRecord::Base
  has_many :records
  has_and_belongs_to_many :users
end

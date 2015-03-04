class User < ActiveRecord::Base
  # has_many :records_users
  # has_many :records, through: :records_users
  has_and_belongs_to_many :records

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
end

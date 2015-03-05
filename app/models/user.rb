class User < ActiveRecord::Base
  has_and_belongs_to_many :records
  has_and_belongs_to_many :artists

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
end

class Administrator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :faculties

  validates :name, presence: true
  validates :phone, presence: true
  validates :department, presence: true
  validates :university, presence: true

end

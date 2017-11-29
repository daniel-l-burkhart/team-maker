class Response < ActiveRecord::Base
  belongs_to :survey
  belongs_to :student
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers
end

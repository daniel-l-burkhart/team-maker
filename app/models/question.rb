class Question < ActiveRecord::Base
  belongs_to :survey
  has_many :answers, dependent: :destroy

  GPA = 'What is your GPA?'
  COMMENTS = 'Comments'
  PRIORITIES = 0..10

  validates :content, presence: true
  validates :priority, presence: true

end

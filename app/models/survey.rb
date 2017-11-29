class Survey < ActiveRecord::Base
  attr_accessor :gpa_question, :comments_question, :team_creation_preference, :team_size
  belongs_to :course
  has_many :questions, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :students, through: :responses
  has_many :teams

  accepts_nested_attributes_for :questions,
                                reject_if: proc {|attributes| attributes['content'].blank?},
                                allow_destroy: true

  validates :name, presence: true
  validates :end_date, presence: true
  validates_associated :questions
  validate :priorities_must_be_unique, :one_gpa_and_comments_question, :end_date_must_be_in_future

  PRIORITY_MAX = 10


  def end_date_must_be_in_future
    if self.end_date < DateTime.now
      self.errors.add(:validation, "The survey's end date must not have already occurred.")
    end
  end

  def one_gpa_and_comments_question
    gpa_count = 0
    comments_count = 0

    self.questions.each do |question|
      gpa_count += 1 if question.content == Question::GPA
      comments_count += 1 if question.content == Question::COMMENTS
    end

    if gpa_count > 1
      self.errors.add(:validation, "Only one question can contain content of: 'What is your GPA?'.")
    end

    if comments_count > 1
      self.errors.add(:validation, "Only one question can contain content of: 'Comments'.")
    end
  end

  def priorities_must_be_unique
    priorities = []

    self.questions.each do |question|
      next if question.priority == 0

      if priorities.include? question.priority
        self.errors.add(:validation, 'Duplicate priority:  ' + question.priority.to_s + '. Please ensure priorities are unique (excluding 0).')
        break
      else
        priorities << question.priority
      end

    end
  end

  def get_survey_progress
    survey_progress = 0

    self.responses.each do |response|
      survey_progress += 1 if response.completed?
    end

    survey_progress.to_s + '/' + self.responses.count.to_s
  end

  def gpa_priority
    Question.find_by(survey_id: self.id, content: self.gpa_question).priority
  end

  def gpa_priority=(value)
    question = Question.find_by(survey_id: self.id, content: self.gpa_question)
    question.priority = value
    self.questions << question
  end

  def is_survey_complete?

    complete = true

    self.responses.each do |response|

      unless response.completed?
        complete = false
      end

    end

    complete
  end

end

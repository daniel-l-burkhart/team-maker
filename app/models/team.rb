class Team < ActiveRecord::Base
  belongs_to :survey
  has_and_belongs_to_many :students

  validates :survey_id, presence: true

  def addStudent(student)
    self.students.push(student)
  end

  def remove_student(student)
    self.students.delete(student)
  end
end

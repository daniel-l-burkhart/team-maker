class Course < ActiveRecord::Base
  require 'csv'

  belongs_to :faculty
  has_many :surveys, dependent: :destroy
  has_and_belongs_to_many :students
  accepts_nested_attributes_for :students, :allow_destroy => true

  attr_accessor :file

  validates :name, presence: true
  validates :semester, presence: true
  validates :section, presence: true

  def delete_student(student)

    self.surveys.each do |survey|
      survey.students.delete(student)
    end

    self.students.delete(student)

    redirect_to 'welcome/index'

  end

  ##
  # Parses students out of CSV file
  ##
  def parse_students(file)
    begin
      rows = CSV.parse(file.read)
      rows.each_with_index do |row, i|
        if row.length != 4
          raise StandardError
        end

        if i == 0
          next
        end

        student_id = row[0]
        first_name = row[1]
        last_name = row[2]
        email = row[3]

        name = first_name + ' ' + last_name

        add_student_to_course(student_id, name, email)
      end
    end
  rescue
    errors.add(:file, 'is invalid. Please ensure that the file is properly formatted and that the data is correct.')
    return
  end
end

##
# Adds student to course
##
def add_student_to_course(student_id, name, email)
  if Student.find_by_email(email)
    student = Student.find_by_email(email)
  else
    student = Student.new
    student.email = email
    student.student_id = student_id
    student.name = name
    student.university = Faculty.find(faculty_id).university
  end

  if self.surveys.count > 0
    add_student_to_course_surveys(student)
  end

  self.students << student
end

def add_student_to_course_surveys(student)
  self.surveys.each do |survey|
    survey.students << student
  end
end
class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_and_belongs_to_many :courses
  has_many :responses
  has_many :surveys, through: :responses
  has_and_belongs_to_many :teams

  validates :student_id, uniqueness: {
      scope: :university
  }

  validates :name, presence: true
  validates :student_id, presence: true
  validates :university, presence: true

  # new function to set the password without knowing the current password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  def password_match?
    self.password == self.password_confirmation
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.password.blank?
  end

  # new function to provide access to protected method unless_confirmed
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def password_required?
    # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

end

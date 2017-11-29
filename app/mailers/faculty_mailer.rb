class FacultyMailer < Devise::Mailer
  default from: 'rorteammaker@gmail.edu'

  ##
  # Faculty email
  ##
  def send_faculty_confirmation_email(faculty)
    @faculty = faculty

    mail(to: 'rorteammaker@gmail.com', subject: 'A new faculty member is awaiting approval!', body: 'A new faculty member is awaiting your approval!')
  end
end

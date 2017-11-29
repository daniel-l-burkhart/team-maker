class ReleaseTeamsMailer < Devise::Mailer

  default from: 'rorteammaker@gmail.com'

  def release_new_teams_mailer(student)

    mail(to: student.email, subject: 'New Teams available!', body: 'A faculty member has put you on a new team. Check TeamMaker for details')

  end
end

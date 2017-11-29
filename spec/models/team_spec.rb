require 'rails_helper'

RSpec.describe Team, type: :model do

  it 'has an invalid survey' do
    myTeam = Team.create(survey_id: nil)
    expect(myTeam).not_to be_valid
  end

  it 'has a valid survey' do
    myTeam = Team.create(survey_id: Survey.create(name: 'name', end_date: DateTime.now+2).id)
    expect(myTeam).to be_valid
  end

end

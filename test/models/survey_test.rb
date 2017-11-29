require 'test_helper'

class SurveyTest < ActiveSupport::TestCase

  test "name_is_required" do

    survey = Survey.new(name: nil, start_date: DateTime.now, end_date: DateTime.now+1)
    assert_not survey.save

  end

  test "end_date_is_required" do

    survey = Survey.new(name: "", start_date: DateTime.now, end_date: nil)
    assert_not survey.save

  end

end
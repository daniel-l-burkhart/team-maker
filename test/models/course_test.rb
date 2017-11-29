require 'test_helper'

class CourseTest < ActiveSupport::TestCase


  test "name_is_required" do

    course = Course.new(name: nil, semester: "", section: "")
    assert_not course.save

  end

  test "semester_is_required" do

    course = Course.new(name: "", semester: nil, section: "")
    assert_not course.save

  end

  test "section_is_required" do

    course = Course.new(name: "", semester: "", section: nil)
    assert_not course.save

  end

end
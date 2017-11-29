require 'test_helper'

class FacultyTest < ActiveSupport::TestCase

  test 'name_is_required' do

    faculty = Faculty.new(name: nil, phone: '', department: '', university: '')
    assert_not faculty.save

  end

  test 'address_is_required' do

    faculty = Faculty.new(name: '', phone: '', department: '', university: '')
    assert_not faculty.save

  end

  test 'phone_is_required' do

    faculty = Faculty.new(name: '', phone: nil, department: '', university: '')
    assert_not faculty.save

  end

  test 'department_is_required' do

    faculty = Faculty.new(name: '', phone: '', department: nil, university: '')
    assert_not faculty.save

  end

  test 'university_is_required' do

    faculty = Faculty.new(name: '', phone: '', department: '', university: nil)
    assert_not faculty.save

  end

end
require 'test_helper'

class StudentTest < ActiveSupport::TestCase

  test 'name_is_required' do

    student = Student.new(name: nil, phone: '')
    assert_not student.save

  end

  test 'address_is_required' do

    student = Student.new(name: '', phone: '')
    assert_not student.save

  end

  test 'phone_is_required' do

    student = Student.new(name: '', phone: nil)
    assert_not student.save

  end

end
require 'test_helper'

class AdministratorTest < ActiveSupport::TestCase

  test "name_is_required" do

    administrator = Administrator.new(name: nil, phone: "", department: "", university: "")
    assert_not administrator.save

  end

  test "address_is_required" do

    administrator = Administrator.new(name: "nil", phone: "", department: "", university: "")
    assert_not administrator.save

  end

  test "phone_is_required" do

    administrator = Administrator.new(name: "", phone: nil, department: "", university: "")
    assert_not administrator.save

  end

  test "department_is_required" do

    administrator = Administrator.new(name: "nil", phone: "", department: nil, university: "")
    assert_not administrator.save

  end

  test "university_is_required" do

    administrator = Administrator.new(name: "", phone: "", department: "", university: nil)
    assert_not administrator.save

  end


end
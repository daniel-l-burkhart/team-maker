require 'test_helper'

class FacultiesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

=begin
  setup do
    @faculty = faculties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:faculties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should show faculty" do
    get :show, id: @faculty
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @faculty
    assert_response :success
  end

=begin

  test "should update faculty" do
    patch :update, id: @faculty, faculty: {address: @faculty.address, department: @faculty.department, name: @faculty.name, password: @faculty.password, phone: @faculty.phone, university: @faculty.university}
    assert_redirected_to faculty_path(assigns(:faculty))
  end



  test "should destroy faculty" do
    assert_difference('Faculty.count', -1) do
      delete :destroy, id: @faculty
    end

    assert_redirected_to faculties_path
  end
=end

end

require 'test_helper'

class CleaningDrawControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end

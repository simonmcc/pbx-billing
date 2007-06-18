require File.dirname(__FILE__) + '/../test_helper'
require 'pbxcdr_controller'

# Re-raise errors caught by the controller.
class PbxcdrController; def rescue_action(e) raise e end; end

class PbxcdrControllerTest < Test::Unit::TestCase
  def setup
    @controller = PbxcdrController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

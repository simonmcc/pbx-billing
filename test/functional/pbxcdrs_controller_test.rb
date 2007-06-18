require File.dirname(__FILE__) + '/../test_helper'
require 'pbxcdrs_controller'

# Re-raise errors caught by the controller.
class PbxcdrsController; def rescue_action(e) raise e end; end

class PbxcdrsControllerTest < Test::Unit::TestCase
  fixtures :pbxcdrs

  def setup
    @controller = PbxcdrsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = pbxcdrs(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:pbxcdrs)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:pbxcdr)
    assert assigns(:pbxcdr).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:pbxcdr)
  end

  def test_create
    num_pbxcdrs = Pbxcdr.count

    post :create, :pbxcdr => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_pbxcdrs + 1, Pbxcdr.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:pbxcdr)
    assert assigns(:pbxcdr).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Pbxcdr.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Pbxcdr.find(@first_id)
    }
  end
end

require File.dirname(__FILE__) + '/../test_helper'
require 'clientbills_controller'

# Re-raise errors caught by the controller.
class ClientbillsController; def rescue_action(e) raise e end; end

class ClientbillsControllerTest < Test::Unit::TestCase
  fixtures :clientbills

  def setup
    @controller = ClientbillsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = clientbills(:first).id
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

    assert_not_nil assigns(:clientbills)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:clientbill)
    assert assigns(:clientbill).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:clientbill)
  end

  def test_create
    num_clientbills = Clientbill.count

    post :create, :clientbill => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_clientbills + 1, Clientbill.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:clientbill)
    assert assigns(:clientbill).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Clientbill.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Clientbill.find(@first_id)
    }
  end
end

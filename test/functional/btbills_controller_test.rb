require File.dirname(__FILE__) + '/../test_helper'
require 'btbills_controller'

# Re-raise errors caught by the controller.
class BtbillsController; def rescue_action(e) raise e end; end

class BtbillsControllerTest < Test::Unit::TestCase
  fixtures :btbills

  def setup
    @controller = BtbillsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = btbills(:first).id
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

    assert_not_nil assigns(:btbills)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:btbill)
    assert assigns(:btbill).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:btbill)
  end

  def test_create
    num_btbills = Btbill.count

    post :create, :btbill => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_btbills + 1, Btbill.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:btbill)
    assert assigns(:btbill).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Btbill.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Btbill.find(@first_id)
    }
  end
end

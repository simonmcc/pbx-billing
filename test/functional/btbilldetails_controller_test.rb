require File.dirname(__FILE__) + '/../test_helper'
require 'btbilldetails_controller'

# Re-raise errors caught by the controller.
class BtbilldetailsController; def rescue_action(e) raise e end; end

class BtbilldetailsControllerTest < Test::Unit::TestCase
  fixtures :btbilldetails

  def setup
    @controller = BtbilldetailsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = btbilldetails(:first).id
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

    assert_not_nil assigns(:btbilldetails)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:btbilldetail)
    assert assigns(:btbilldetail).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:btbilldetail)
  end

  def test_create
    num_btbilldetails = Btbilldetail.count

    post :create, :btbilldetail => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_btbilldetails + 1, Btbilldetail.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:btbilldetail)
    assert assigns(:btbilldetail).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Btbilldetail.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Btbilldetail.find(@first_id)
    }
  end
end

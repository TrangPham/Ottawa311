require 'test_helper'

class ServiceRequestsControllerTest < ActionController::TestCase
  setup do
    @service_request = service_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:service_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create service_request" do
    assert_difference('ServiceRequest.count') do
      post :create, service_request: { call_description: @service_request.call_description, call_type: @service_request.call_type, creation_date: @service_request.creation_date, maintenance_yard: @service_request.maintenance_yard, priority_name: @service_request.priority_name, ward: @service_request.ward }
    end

    assert_redirected_to service_request_path(assigns(:service_request))
  end

  test "should show service_request" do
    get :show, id: @service_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @service_request
    assert_response :success
  end

  test "should update service_request" do
    patch :update, id: @service_request, service_request: { call_description: @service_request.call_description, call_type: @service_request.call_type, creation_date: @service_request.creation_date, maintenance_yard: @service_request.maintenance_yard, priority_name: @service_request.priority_name, ward: @service_request.ward }
    assert_redirected_to service_request_path(assigns(:service_request))
  end

  test "should destroy service_request" do
    assert_difference('ServiceRequest.count', -1) do
      delete :destroy, id: @service_request
    end

    assert_redirected_to service_requests_path
  end
end

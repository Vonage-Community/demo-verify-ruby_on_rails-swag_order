require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    order = Order.first
    get order_url(order)
    assert_response :success
  end

  test "should get new" do
    get new_order_url
    assert_response :success
  end
end

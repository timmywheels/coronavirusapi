require 'test_helper'

class StatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @state = states(:one)
  end

  test "should get index" do
    get states_url
    assert_response :success
  end

  test "should get new" do
    get new_state_url
    assert_response :success
  end

  test "should create state" do
    assert_difference('State.count') do
      post states_url, params: { state: { deaths: @state.deaths, deaths_crawl_date: @state.deaths_crawl_date, deaths_source: @state.deaths_source, name: @state.name, positive: @state.positive, positive_crawl_date: @state.positive_crawl_date, positive_source: @state.positive_source, tested: @state.tested, tested_crawl_date: @state.tested_crawl_date, tested_source: @state.tested_source } }
    end

    assert_redirected_to state_url(State.last)
  end

  test "should show state" do
    get state_url(@state)
    assert_response :success
  end

  test "should get edit" do
    get edit_state_url(@state)
    assert_response :success
  end

  test "should update state" do
    patch state_url(@state), params: { state: { deaths: @state.deaths, deaths_crawl_date: @state.deaths_crawl_date, deaths_source: @state.deaths_source, name: @state.name, positive: @state.positive, positive_crawl_date: @state.positive_crawl_date, positive_source: @state.positive_source, tested: @state.tested, tested_crawl_date: @state.tested_crawl_date, tested_source: @state.tested_source } }
    assert_redirected_to state_url(@state)
  end

  test "should destroy state" do
    assert_difference('State.count', -1) do
      delete state_url(@state)
    end

    assert_redirected_to states_url
  end
end

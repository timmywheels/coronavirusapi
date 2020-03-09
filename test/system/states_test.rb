require "application_system_test_case"

class StatesTest < ApplicationSystemTestCase
  setup do
    @state = states(:one)
  end

  test "visiting the index" do
    visit states_url
    assert_selector "h1", text: "States"
  end

  test "creating a State" do
    visit states_url
    click_on "New State"

    fill_in "Deaths", with: @state.deaths
    fill_in "Deaths crawl date", with: @state.deaths_crawl_date
    fill_in "Deaths source", with: @state.deaths_source
    fill_in "Name", with: @state.name
    fill_in "Positive", with: @state.positive
    fill_in "Positive crawl date", with: @state.positive_crawl_date
    fill_in "Positive source", with: @state.positive_source
    fill_in "Tested", with: @state.tested
    fill_in "Tested crawl date", with: @state.tested_crawl_date
    fill_in "Tested source", with: @state.tested_source
    click_on "Create State"

    assert_text "State was successfully created"
    click_on "Back"
  end

  test "updating a State" do
    visit states_url
    click_on "Edit", match: :first

    fill_in "Deaths", with: @state.deaths
    fill_in "Deaths crawl date", with: @state.deaths_crawl_date
    fill_in "Deaths source", with: @state.deaths_source
    fill_in "Name", with: @state.name
    fill_in "Positive", with: @state.positive
    fill_in "Positive crawl date", with: @state.positive_crawl_date
    fill_in "Positive source", with: @state.positive_source
    fill_in "Tested", with: @state.tested
    fill_in "Tested crawl date", with: @state.tested_crawl_date
    fill_in "Tested source", with: @state.tested_source
    click_on "Update State"

    assert_text "State was successfully updated"
    click_on "Back"
  end

  test "destroying a State" do
    visit states_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "State was successfully destroyed"
  end
end

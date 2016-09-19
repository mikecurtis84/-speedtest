require 'test_helper'

class PagesummaryControllerTest < ActionDispatch::IntegrationTest
  test "should get allpages" do
    get pagesummary_allpages_url
    assert_response :success
  end

  test "should get individualpage" do
    get pagesummary_individualpage_url
    assert_response :success
  end

end

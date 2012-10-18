require 'test_helper'

class StoriesTest < ActionDispatch::IntegrationTest

  setup do
    # Simulate production environment so exception is converted to
    # HTTP code and then delivered to the BetterExceptionApp::Engine
    Rails.application.config.action_dispatch.show_exceptions = true
    Rails.application.config.consider_all_requests_local = false
  end

  test 'exception renders error in layout' do
    visit '/not_implemented'
    assert_equal 200, page.status_code
    assert_match /body/, page.body # Layout renders
    assert has_content?('not able to process') # has error message
  end

  test 'format requested' do
    visit '/not_implemented.json'
    assert_equal 501, page.status_code
    assert_no_match /body/, page.source # Layout doesn't renders
    assert_equal '{"status":501,"error":"Only  requests are allowed."}',
      page.source.strip # Error message right
  end

end

class ExampleController < ActionController::Base
  def not_implemented
    raise ActionController::NotImplemented
  end
end
Rails.application.routes.draw do
  match 'not_implemented' => 'example#not_implemented'
end

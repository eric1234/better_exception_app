require 'test_helper'

class HttpErrorsControllerTest < ActionController::TestCase
  tests BetterExceptionApp::HttpErrorsController

  setup do
    BetterExceptionApp::HttpError.error_files_paths.replace []
    request.env['action_dispatch.exception'] =
      StandardError.new('exception message')
  end

  test 'template exists' do
    BetterExceptionApp::HttpError.error_files_paths.replace \
      [File.expand_path("../../fixtures/by_number", __FILE__)]
    request.env["PATH_INFO"] = '/404'
    get :show, :status => '404', :use_route => 'better_exception_app'
    assert_response :ok
    assert_select 'body' # We have a layout
    assert_match /404 by number/, response.body.strip # Error message right
  end

  test 'i18n description' do
    request.env["PATH_INFO"] = '/404'
    get :show, :status => '404', :use_route => 'better_exception_app'
    assert_response :ok
    assert_select 'body' # We have a layout
    assert_match /not be found/, response.body.strip # Error message right
  end

  test 'exception message' do
    request.env["PATH_INFO"] = '/200'
    get :show, :status => '200', :use_route => 'better_exception_app'
    assert_response :ok
    assert_select 'body' # We have a layout
    assert_match /exception message/, response.body.strip # Error message right
  end

  test 'alternate format' do
    request.env["PATH_INFO"] = '/404'
    get :show, :status => '404', :format => 'json',
      :use_route => 'better_exception_app'
    assert_response :not_found
    assert_equal '{"status":404,"error":"exception message"}',
      response.body.strip # Error message right
  end

end

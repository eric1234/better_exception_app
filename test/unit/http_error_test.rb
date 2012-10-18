require File.expand_path('../../test_helper', __FILE__)

class HttpErrorTest < ActiveSupport::TestCase

  setup do
    @error = BetterExceptionApp::HttpError.new '404',
      StandardError.new('test exception')
  end

  test 'symbol lookup' do
    assert_equal :not_found, @error.symbol
  end

  test 'formattable' do
    assert !@error.formattable?(Mime::HTML)
    assert @error.formattable?(Mime::XML)
    assert @error.formattable?(Mime::JSON)
  end

  test 'formatted' do
    assert_equal '{"status":404,"error":"test exception"}',
      @error.formatted(Mime::JSON)
  end

  test 'template lookup - by symbol with locale' do
    errors_path 'i18n_by_name'
    assert_equal '404 i18n by name',
      open("#{@error.template}.html").read.strip
  end

  test 'template lookup - by symbol without locale' do
    errors_path 'by_name'
    assert_equal '404 by name',
      open("#{@error.template}.html").read.strip
  end

  test 'template lookup - by code with locale' do
    errors_path 'i18n_by_number'
    assert_equal '404 i18n by number',
      open("#{@error.template}.html").read.strip
  end

  test 'template lookup - by code without locale' do
    errors_path 'by_number'
    assert_equal '404 by number',
      open("#{@error.template}.html").read.strip
  end

  test 'description lookup - found' do
    assert_match /not be found/, @error.description
  end

  test 'description lookup - not found' do
    error = BetterExceptionApp::HttpError.new '200',
      StandardError.new('test exception')
    assert_nil error.description
  end

  private

  def errors_path path
    paths = [File.expand_path("../../fixtures/#{path}", __FILE__)]
    BetterExceptionApp::HttpError.error_files_paths.replace paths
  end

end

class BetterExceptionApp::HttpErrorsController < ApplicationController

  def show
    # Pull from path info instead of params since we will get
    # params of real request instead of params for this app.
    error = BetterExceptionApp::HttpError.new \
      request.env["PATH_INFO"][1..-1],
      request.env['action_dispatch.exception']

    if error.formattable? request.format
      # If they requested a format other than HTML just give them the
      # raw data in their format like the default exception app.
      render :status => error.status,
        request.format.to_sym => error.formatted(request.format)
    else
      # If they are cool with HTML (or we don't know how to convert
      # to the format they requested) then kick in our magic.
      if error.template
        # First try static template. Mainly for 500 Internal Server Error
        # since we cannot be sure they can render in a layout.
        render error.template
      elsif error.description
        # If static error doesn't exist try a i18n-based description
        # within the layout.
        render :text => error.description, :layout => true
      else
        # If not a static file or boilerplate description doesn't exist
        # then just get the exception to do the talking.
        render :text => error.exception.message, :layout => true
      end
    end
  end

end

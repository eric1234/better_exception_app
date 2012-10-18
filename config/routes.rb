BetterExceptionApp::Engine.routes.draw do
  match '/:status' => 'http_errors#show', :status => /\d{3}/
end

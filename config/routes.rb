Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    scope 'exporters/:exporter_id' do
      resources :exports, only: [:index, :show, :new, :create]
    end

    mount ActiveWaiter::Engine => "/active_waiter/:id"
  end

end

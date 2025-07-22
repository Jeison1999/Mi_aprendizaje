Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # ⚠️ En producción, cambia esto por la URL de tu frontend

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization']
  end
end

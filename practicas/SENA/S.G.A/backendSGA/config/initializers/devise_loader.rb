# Cargar Devise correctamente para API
Rails.application.config.to_prepare do
  # Asegurar que Devise se carga correctamente
  require 'devise'
  require 'devise/orm/active_record'
end

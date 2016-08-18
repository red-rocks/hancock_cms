if defined?(RailsAdmin)
  RailsAdmin.config do |config|
    config.excluded_models ||= []
    if Hancock::Pages.mongoid?
      config.excluded_models << [
        'Hancock::EmbeddedElement'
      ]
    end
    config.excluded_models.flatten!
  end
end

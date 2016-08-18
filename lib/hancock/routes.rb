module ActionDispatch::Routing
  class Mapper

    def hancock_cms_routes(config = {})
      routes_config = {
        root_path: "home#index"
      }
      routes_config.merge!(config)

      scope module: 'hancock' do

        if routes_config[:root_path]
          root to: routes_config[:root_path]
        end
      end

    end

  end
end

module ActionDispatch::Routing
  class Mapper

    def hancock_cms_routes(config = {})
      routes_config = {
        root_path:       "home#index",
        privacy_policy:  {path: "privacy_policy", action: "home#privacy_policy"},
        cookies_policy:  {path: "cookies_policy", action: "home#cookies_policy"}
      }
      routes_config.merge!(config)

      scope module: 'hancock' do

        if routes_config[:root_path]
          root to: routes_config[:root_path]
        end

        if routes_config[:privacy_policy]
          get "#{routes_config[:privacy_policy][:path]}" => routes_config[:privacy_policy][:action], as: :privacy_policy
        end

        if routes_config[:cookies_policy]
          get "#{routes_config[:cookies_policy][:path]}" => routes_config[:cookies_policy][:action], as: :cookies_policy
          post "cookies_policy_accept" => "home#cookies_policy_accept", as: :cookies_policy_accept
        end

      end

    end

  end
end

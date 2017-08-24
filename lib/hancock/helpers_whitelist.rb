module Hancock::HelpersWhitelist

  def self.included(base)

    class << base
      def helpers_whitelist
        (Hancock.config.helpers_whitelist || {}).merge(Settings.ns('admin').helpers_whitelist(default: {}, kind: :hash))
      end
      def helpers_whitelist_obj
        Settings.ns('admin').getnc(:helpers_whitelist)
      end
      def helpers_whitelist_as_array(exclude_blacklist = false)
        _list = helpers_whitelist.keys.map(&:to_s).map(&:strip)
        (exclude_blacklist ? (_list - helpers_blacklist_as_array) : _list)
      end
      def can_render_helper?(name)
        helpers_whitelist_as_array(true).include?(name)
      end

      def helpers_blacklist
        Settings.ns('admin').helpers_blacklist(default: [], kind: :array)
      end
      def helpers_blacklist_obj
        Settings.ns('admin').getnc(:helpers_blacklist)
      end
      def helpers_blacklist_as_array
        helpers_blacklist
      end

      def helpers_whitelist_human_names
        helpers_whitelist
      end
      def helpers_whitelist_human_names_obj
        helpers_whitelist_obj
      end


      def helpers_whitelist_enum
        helpers_whitelist_as_array(true).map do |f|
          helpers_whitelist_human_names[f] ? "#{helpers_whitelist_human_names[f]} (#{f})" : f
        end
      end

    end

  end

end

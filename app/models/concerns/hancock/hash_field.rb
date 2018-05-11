module Hancock::HashField
  extend ActiveSupport::Concern

  class_methods do
    def hancock_cms_hash_field(name, opts = {})
      opts.merge!({type: Hash, default: {}})

      meth = name
      meth_str = "#{name}_str".freeze
      meth_hsh = "#{name}_hash".freeze
      meth_json = "#{name}_json".freeze
      meth_hsh_changed = "#{name}_hash_changed?".freeze

      if Hancock.mongoid?
        field meth_hsh, opts
        class_eval <<-RUBY
        def #{meth}=(val)
          self.#{meth_hsh} = val
        end
        def #{meth}
          #{meth_hsh}
        end

        def #{meth_str}=(val)
          self.#{meth_hsh} = begin
            begin
              self.meth_json = val
            rescue
              YAML.load(val)
            end
          rescue
            {}
          end
        end
        def #{meth_str}
          #{meth_hsh}.to_s
        end

        def #{meth_json}=(val)
          self.#{meth_hsh} = JSON.parse(val) rescue val
        end
        def #{meth_json}
          #{meth_hsh}.to_json
        end

        def get_#{meth}_from_old_field(field_name = :#{meth})
          self.#{meth} = self[field_name]
        end
        RUBY

      else
        class_eval <<-RUBY
        def #{meth}=(val)
          self.#{meth_hsh} = val
        end
        def #{meth}
          #{meth_hsh}
        end

        def #{meth_hsh}=(val)
          self.#{meth_json} = val.to_json rescue "{}"
        end
        def #{meth_hsh}
          @#{meth_hsh} ||= JSON.parse(#{meth_json})
        end
        def #{meth_hsh_changed}
          !!@#{meth_hsh}
        end

        def #{meth_str}=(val)
          self.#{meth_hsh} = YAML.load(val) rescue val
        end
        def #{meth_str}
          #{meth_hsh}.to_s
        end

        def #{meth_json}
          puts "meth_jsonmeth_jsonmeth_json"
          self.#{meth_hsh} = @#{meth_hsh} if #{meth_hsh_changed}
          super
        end
        before_validation do
          self.#{meth_hsh} = @#{meth_hsh} if #{meth_hsh_changed}
        end

        def get_#{meth}_from_old_field(field_name = :#{meth})
          self.#{meth} = self[field_name]
        end
        RUBY
      end

      # if opts[:localize]
      #   meth_str_t = "#{meth_str}_translations".freeze
      #   meth_hsh_t = "#{meth_hsh}_translations".freeze
      #   class_eval <<-RUBY
      #     def #{meth_str_t}=(val)
      #       return self.#{meth_hsh_t} = {} if val.blank?
      #       _hash = {}
      #       I18n.available_locales.each do |l|
      #         begin
      #           _hash[l] = JSON.parse(val[l])
      #         rescue
      #         end
      #       end
      #       self.#{meth_hsh_t} = _hash
      #     end
      #     def #{meth_str_t}
      #       self.#{meth} if self.#{meth}
      #     end
      #     def #{meth_str}
      #       self.#{meth_str_t}[I18n.locale].to_s if self.#{meth_str_t}
      #     end
      #     def #{meth}
      #       if Hancock.mongoid?
      #         self.#{meth_hsh}
      #       else
      #         self.#{meth_str}
      #       end
      #     end
      #     def #{meth}=(val)
      #       self.#{meth_str} = val
      #     end
      #     def #{meth_json}
      #       self.#{meth_hsh}.to_json if self.#{meth_hsh}
      #     end
      #
      #     validate do
      #       unless self.#{meth_hsh_t}.nil?
      #         _has_errors = false
      #         I18n.available_locales.each do |l|
      #           I18n.with_locale(l) do
      #             if self.#{meth_hsh_t}[l].nil?
      #               _has_errors ||= true
      #               _meth = "#{meth_hsh_t}_\#{l}".to_s
      #               self.errors.add(_meth, "Неверный формат данных")
      #             end
      #           end
      #         end
      #       end
      #       true
      #     end
      #   RUBY
      #
      # else
      #   class_eval <<-RUBY
      #     def #{meth_str}=(val)
      #       if Hancock.mongoid?
      #         return self.#{meth_hsh} = {} if val.blank?
      #         self.#{meth_hsh} = #{meth_formatted_hash}(val)
      #       else
      #         return self.#{meth_str} = "{}" if val.blank?
      #         self.#{meth_str} = #{meth_formatted_hash}(val).to_json
      #       end
      #     end
      #     def #{meth_str}
      #       if Hancock.mongoid?
      #         self.#{meth}.to_s if self.#{meth}
      #       else
      #         super
      #       end
      #     end
      #     def #{meth}
      #       if Hancock.mongoid?
      #         self.#{meth_hsh}
      #       else
      #         self.#{meth_str}
      #       end
      #     end
      #     def #{meth}=(val)
      #       self.#{meth_str} = #{meth_formatted_hash}(val).to_json
      #     end
      #     def #{meth_json}
      #       self.#{meth_hsh}.to_json if self.#{meth_hsh}
      #     end
      #     def #{meth_formatted_hash}(val = #{meth_hsh})
      #       if val.is_a?(String)
      #         begin
      #           begin
      #             JSON.parse(val)
      #           rescue
      #             YAML.load(val)
      #           end
      #         rescue
      #         end
      #       elsif val.is_a?(Hash)
      #         val
      #       elsif val.nil?
      #         {}
      #       end
      #     end
      #
      #     validate do
      #       unless self.#{meth}.nil?
      #         # if self.#{meth_str} != self.#{meth}.to_json
      #         #   self.errors.add(:#{meth}, "Неверный формат данных")
      #         # end
      #         true
      #       end
      #     end
      #   RUBY
      # end #if opts[:localize]
    end #def hancock_cms_hash_field(name, opts = {})
  end # class_methods do

end

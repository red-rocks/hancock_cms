module Hancock::InsertionField
  extend ActiveSupport::Concern

  REGEXP = {
    old_insertion:    /\{\{(?<old_insertion>self\.(?<old_insertion_name>\w+?))\}\}/i,
    new_insertion:    /\{\{\{\{(?<new_insertion>(?<new_insertion_name>\w+?))\}\}\}\}/i,
    insertion:        /(\{\{(?<insertion>self\.(?<insertion_name>\w+?))\}\}|\{\{\{\{(?<insertion>(?<insertion_name>\w+?))\}\}\}\})/i,

    new_helper: /\[\[\[\[(?<new_helper>(?<new_helper_name>\w+?))\]\]\]\]/i,
    old_helper: /\{\{(?<old_helper>HELPER\|(?<old_helper_name>\w+?))\}\}/i,
    helper:     /(\[\[\[\[(?<helper>(?<helper_name>\w+?))\]\]\]\]|\{\{(?<helper>HELPER\|(?<helper_name>\w+?))\}\})/i,

    settings:         /\{\{(?<setting>(?<setting_name>\w+?))\}\}/i,
    settings_with_ns: /\{\{(?<setting_with_ns>(?<setting_with_ns_ns>[\w\-\.]+?)\.(?<setting_with_ns_name>\w+?))\}\}/i
  }

  included do
    class_attribute :added_insertions, :removed_insertions, :insertions_fields
    self.removed_insertions ||= []
    self.added_insertions ||= []
    self.insertions_fields ||= {}
    def possible_insertions
      self.class.possible_insertions
    end

    # /(\[\[(\w+?)\]\] | \{\{(self\.(\w+?))\}\} | \{\{(([\w\-\.]+?)\.(\w+?))\}\} | \{\{(\w+?)\}\} | \{\{(BS\|(\w+?))\}\})/
    #
    # reg1 = /\[\[(?<new_bs>(?<new_bs_name>\w+?))\]\]/i
    # reg2 = /\[\[\[\[(?<new_helper>(?<new_helper_name>\w+?))\]\]\]\]/i
    # reg3 = /\{\{(?<insertion_old>self\.(?<insertion_old_name>\w+?))\}\}/i
    # reg4 = /\{\{(?<setting_with_ns>(?<setting_with_ns_ns>[\w\-\.]+?)\.(?<setting_with_ns_name>\w+?))\}\}/i
    # reg5 = /\{\{(?<setting>(?<setting_name>\w+?))\}\}/i
    # reg6 = /\{\{(?<old_bs>BS\|(?<old_bs_name>\w+?))\}\}/i
    # reg7 = /\{\{(?<old_helper>HELPER\|(?<old_helper_name>\w+?))\}\}/i
    # reg8 = /\{\{\{\{(?<insertion>(?<insertion_name>\w+?))\}\}\}\}/i
    private
    def process_with_insertions(_data)
      if _data.nil?
        ''
      else
        if _data.is_a?(Symbol)
          if insertions_fields.include?(_data)
            _data = self.send(_data)
          else
            return ''
          end
        end
        # {{self.%insertion%}}
        # _ret = _data.gsub(/\{\{self\.(.*?)\}\}/i) do
        #   get_insertion($1)
        # # {{"some_text"}} #temporary disabled - need tests
        # # end.gsub(/\{\{(['"])(.*?)(\1)\}\}/) do
        # #   $2
        # # {{%ns%.%key%}}
        # end.gsub(/\{\{(([^\.]*?)\.)?(.*?)\}\}/i) do
        #   (Settings and !$3.nil? and $2 != "self") ? Settings.ns($2).get($3).val : "" #temp
        # end
        _ret = _data.gsub(REGEXP[:new_insertion]) do
          get_insertion($~[:new_insertion_name]) rescue ""

        end.gsub(REGEXP[:old_insertion]) do
          get_insertion($~[:old_insertion_name]) rescue ""

        end.gsub(REGEXP[:settings]) do
          if defined?(Settings)
            name = $~[:setting_name]
            if !name.blank?
              Settings.ns(ns).get(name) rescue ""
            else
              ""
            end
          end

        end.gsub(REGEXP[:new_helper]) do
          if Hancock.helpers_whitelist_as_array.include?($~[:new_helper_name].to_s)
            ApplicationController.helpers.__send__($~[:new_helper_name]) rescue ""
          end

        end.gsub(REGEXP[:old_helper]) do
          if Hancock.helpers_whitelist_as_array.include?($~[:old_helper_name].to_s)
            ApplicationController.helpers.__send__($~[:old_helper_name]) rescue ""
          end

        end.gsub(REGEXP[:settings_with_ns]) do
          if defined?(Settings)
            ns = $~[:setting_with_ns_ns]
            name = $~[:setting_with_ns_name]
            if ns != "self" and !name.blank?
              Settings.ns(ns).get(name) rescue ""
            else
              ""
            end
          end

        end
        # end.gsub(/\{\{(?<old_helper>HELPER\|(?<old_helper_name>\w+?))\}\}/i) do
        #   ActionView::Base.send($~[:old_helper_name]) rescue ""
        # end.gsub(/\[\[\[\[(?<new_helper>(?<new_helper_name>\w+?))\]\]\]\]/i) do
        #   ActionView::Base.send($~[:new_helper_name]) rescue ""
        _ret
      end
    end
    def get_insertion(name)
      begin
        self.send(name) if possible_insertions.include?(name)
      rescue
        ""
      end
    end
  end

  class_methods do
    def insertions_field(name, opts = {type: String, default: ''})
      field name, opts
      insertions_for name, opts
    end
    def insertions_for(name, opts = {})
      return if name.blank?
      name = name.to_sym
      return if insertions_fields.keys.include?(name)
      (opts.delete(:add_insertions) || []).each do |_ins|
        add_insertion _ins
      end
      (["page_#{name}", name.to_s] + (opts.delete(:remove_insertions) || [])).uniq.each do |_ins|
        remove_insertion _ins
      end
      _method_name = opts[:as].present? ? opts[:as] : "page_#{name}"
      insertions_fields[name] = {
        method: _method_name,
        options: opts
      }
      if _method_name
        class_eval <<-RUBY
          def #{_method_name}
            process_with_insertions(#{name})
          end
        RUBY
      end
      name
    end

    def insertion(name, opts = {})
      name = name.to_s.strip
      if opts[:remove]
        self.removed_insertions << name unless self.removed_insertions.include?(name)
      else
        self.added_insertions << name unless self.added_insertions.include?(name)
      end
    end
    def add_insertion(name)
      insertion(name.to_s.strip)
    end
    def remove_insertion(name, opts = {})
      insertion(name.to_s.strip, opts.merge({remove: true}))
    end

    def default_insertions
      # self.fields.keys # we was here but inheritance and we need check

      # # version with store in
      # return @default_insertions unless @default_insertions.nil?
      # @default_insertions =
      self.fields.select { |_name, _field|
        _field.options[:klass] and self <= _field.options[:klass]
      }.keys
    end
    def possible_insertions
      @possible_insertions ||= (default_insertions + added_insertions).map(&:to_s).uniq - removed_insertions.map(&:to_s)
    end
  end

end

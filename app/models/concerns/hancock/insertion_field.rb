module Hancock::InsertionField
  extend ActiveSupport::Concern

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
    # reg2 = /\{\{(?<insertion_old>self\.(?<insertion_old_name>\w+?))\}\}/i
    # reg3 = /\{\{(?<setting_with_ns>(?<setting_with_ns_ns>[\w\-\.]+?)\.(?<setting_with_ns_name>\w+?))\}\}/i
    # reg4 = /\{\{(?<setting>(?<setting_name>\w+?))\}\}/i
    # reg5 = /\{\{(?<old_bs>BS\|(?<old_bs_name>\w+?))\}\}/i
    # reg6 = /\{\{\{\{(?<insertion>(?<insertion_name>\w+?))\}\}\}\}/i
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
        _ret = _data.gsub(/\{\{self\.(.*?)\}\}/) do
          get_insertion($1)
        # {{"some_text"}} #temporary disabled - need tests
        # end.gsub(/\{\{(['"])(.*?)(\1)\}\}/) do
        #   $2
        # {{%ns%.%key%}}
        end.gsub(/\{\{(([^\.]*?)\.)?(.*?)\}\}/) do
          (Settings and !$3.nil? and $2 != "self") ? Settings.ns($2).get($3).val : "" #temp
        end
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

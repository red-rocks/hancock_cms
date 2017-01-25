module Hancock::Insertions
  extend ActiveSupport::Concern

  included do
    class_attribute :added_insertions, :removed_insertions
    self.removed_insertions ||= []
    self.added_insertions ||= []
    def possible_insertions
      self.class.possible_insertions
    end
    def process_with_insertions(_data)
      if _data.nil?
        ''
      else
        # {{self.%insertion%}}
        _ret = _data.gsub(/\{\{self\.(.*?)\}\}/) do
          begin
            self.send($1) if possible_insertions.include?($1)
          rescue
            ""
          end
        end.gsub(/\{\{(([^\.]*?)\.)?(.*?)\}\}/) do
          (Settings and !$3.nil? and $2 != "self") ? Settings.ns($2).get($3).val : "" #temp
        end
        _ret
      end
    end
  end

  class_methods do
    def insertions_for(name, opts = {})
      (opts.delete(:add_insertions) || []).each do |_ins|
        add_insertion _ins
      end
      (["page_#{name}", name.to_s] + (opts.delete(:remove_insertions) || [])).uniq.each do |_ins|
        remove_insertion _ins
      end
      _method_name = opts[:as].present? ? opts[:as] : "page_#{name}"
      if _method_name
        class_eval <<-EVAL
          def #{_method_name}
            process_with_insertions(#{name})
          end
        EVAL
      end
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
      self.fields.keys
    end
    def possible_insertions
      @possible_insertions ||= (default_insertions + added_insertions).map(&:to_s).uniq - removed_insertions.map(&:to_s)
    end
  end
end

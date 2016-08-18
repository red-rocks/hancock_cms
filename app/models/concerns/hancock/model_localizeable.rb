module Hancock::ModelLocalizeable
  extend ActiveSupport::Concern

  module ClassMethods
    def convert2localize
      self.all.to_a.map do |p|
        p.convert2localize
      end
    end
  end

  def convert2localize(save_it = true)
    arr = {}
    self.localized_fields.keys.each do |f|
      if self[f].is_a?(Hash) and f !~ /_translations$/
        self[f + '_translations'] = self.remove_attribute(f)
        puts self.inspect
      else
        arr[f] = self.remove_attribute(f)
        self[f] = {}
      end
    end
    self.save if save_it

    I18n.available_locales.each do |l|
      I18n.with_locale(l) do
        arr.each_pair do |f, v|
          self.send(f + "=", v)
        end
      end
    end
    self.save if save_it
  end
end

module RailsAdminSettings
  module_eval <<-EVAL
    def self.kinds
      #{RailsAdminSettings.kinds.to_a.to_s} + ['js', 'css']
    end
  EVAL
end

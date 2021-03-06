module Hancock::SettingsHelper

  def hancock_settings(key, options = {}, &block)
    if key.is_a?(Hash)
      key, options = key[:key], key
    end
    ns = options.delete(:ns)
    settings_scope = options.delete(:settings_scope) || Settings.ns(ns)
    key ||= options.delete(:key)
    options.delete(:key)

    cache_keys = options[:cache_keys_str] || options[:cache_keys] || options[:cache_key] || []
    if cache_keys.is_a?(::Array)
      cache_keys = cache_keys.map { |k| k.to_s.strip }.join(" ")
    else
      cache_keys = cache_keys.to_s.strip
    end
    options.delete(:cache_keys)
    options.delete(:cache_key)

    # options[:loadable] = cache_keys.blank? if options[:loadable].nil? # temporary
    options[:cache_keys_str] = cache_keys
    options[:kind] ||= :html

    options[:default] = capture(&block) if block
    case (options.delete(:as) || :value).to_sym
    when :value
      ret = settings_scope.__send__(key, options)
    when :object
      ret = settings_scope.getnc(key)
      ret.loadable ||= options[:loadable]
      _old_cache_keys = options[:cache_keys_str].strip.split(" ")
      options[:cache_keys_str] = (_old_cache_keys + ret.cache_keys).uniq
      if (options[:cache_keys_str] - _old_cache_keys).blank?
        ret.cache_keys_str = options[:cache_keys_str]
      end
      ret.save unless ret.changes.blank?
      ret
    else
      ret = settings_scope.__send__(key, options)
    end
  end

end

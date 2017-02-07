module Hancock::SettingsHelper

  def hancock_settings(key, options = {}, &block)
    if key.is_a?(Hash)
      key, options = key[:key], key
    end
    ns = options.delete(:ns)
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

    options[:loadable] = cache_keys.blank? if options[:loadable].nil?
    options[:cache_keys_str] = cache_keys
    options[:kind] ||= :html

    options[:default] = capture(&block) if block
    Settings.ns(ns).__send__(key, options)
  end

end

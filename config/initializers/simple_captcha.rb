if defined?(SimpleCaptcha)

  module SimpleCaptcha #:nodoc
    module ViewHelper #:nodoc
      def show_simple_captcha(options={})
        key = simple_captcha_key(options[:object])
        options[:field_value] = set_simple_captcha_data(key, options)

        defaults = {
            :image            => simple_captcha_image(key, options),
            :label            => options[:label] || I18n.t('simple_captcha.label'),
            :field            => simple_captcha_field(options),
            :error_messages   => options[:error_messages]
        }

        render :partial => 'hancock/simple_captcha/simple_captcha', :locals => { :simple_captcha_options => defaults }
      end
    end
  end

  SimpleCaptcha.setup do |sc|
    sc.image_size = "200x50"
    sc.length = 4
    sc.charset = "0123456789"

    sc.add_image_style("hancock_cms_style", [
      "-alpha set",
      "-fill 'orange'",
      "-background 'transparent'",
      "-size 200x50", "xc:transparent"
    ])

    sc.image_style = 'hancock_cms_style'

    sc.tmp_path = "tmp/sc"
  end
  
end

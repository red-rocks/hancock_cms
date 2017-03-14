module Hancock::PoweredHelper

  # TODO CMS site block
  # def render_hancock_powered_on_block
  #   content_tag :div, class: 'hancock-powered-on' do
  #     ret = []
  #     ret << content_tag(:span, class: 'powered-on') do
  #       "Сайт работает на "
  #     end
  #     _attrs = {
  #       class: "powered_on",
  #       target: "_blank",
  #       title: "Hancock CMS",
  #       data: {
  #         "hancock-goto-disabled": true
  #       }
  #     }
  #     ret << link_to("Hancock CMS", "https://hancock.redrocks.pro/", _attrs)
  #     ret.join.html_safe
  #   end
  # end

  def render_hancock_created_by_block
    content_tag :div, class: 'hancock-created-by' do
      ret = []
      ret << content_tag(:span, class: 'created-by') do
        "Сайт разработан".freeze
      end
      _attrs = {
        class: "created_by",
        target: "_blank",
        title: "Redrocks Creative studio",
        data: {
          "hancock-goto-disabled": true
        }
      }.freeze
      ret << link_to("Redrocks studio".freeze, "https://redrocks.pro/".freeze, _attrs)
      ret.join.html_safe
    end
  end

end

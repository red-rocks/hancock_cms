module Hancock::PoweredHelper

  # TODO CMS site block
  # def render_hancock_powered_by_block
  #   content_tag :div, class: 'hancock-powered' do
  #     ret = []
  #     ret << content_tag(:span, class: 'powered') do
  #       "Сайт работает на "
  #     end
  #     _attrs = {
  #       class: "powered_by",
  #       target: "_blank",
  #       title: "Hancock CMS",
  #       data: {
  #         "hancock-goto-disabled": true
  #       }
  #     }
  #     ret << link_to("Hancock CMS", "http://cms.hancockcreate.ru", _attrs)
  #     ret.join.html_safe
  #   end
  # end

  def render_hancock_created_by_block
    content_tag :div, class: 'hancock-created-by' do
      ret = []
      ret << content_tag(:span, class: 'created-by') do
        "Сайт разработан"
      end
      _attrs = {
        class: "created_by",
        target: "_blank",
        title: "Hancock Creative studio",
        data: {
          "hancock-goto-disabled": true
        }
      }
      ret << link_to("Hancock Creative studio", "http://hancockcreate.ru", _attrs)
      ret.join.html_safe
    end
  end

end

module ApplicationHelper
  FLASH_NOTICE_KEYS = [ :error, :notice, :warning ]

  def flash_messages
    return unless messages = flash.keys.select{|k| FLASH_NOTICE_KEYS.include?(k)}
    formatted_messages = messages.map do |type|
      content_tag :div, :class => "notifier #{type}" do
        #image_tag("deco/#{type}.gif", :style => 'padding: 0 2px 0 0; vertical-align: middle;') +
        message_for_item(flash[type], flash["#{type}_item".to_sym])
      end
    end
    unless formatted_messages.empty?
      "<div id='flash' style='display: none;' onmouseout='this.style.cursor = \'default\''  onmouseover='this.style.cursor = \'pointer\''>" +
        formatted_messages.join +
        "<script> $('#flash').hide(); $('#flash').slideDown('slow').delay(2200).slideUp('slow');</script></div>".html_safe



    else
      ""
    end
  end

  def message_for_item(message, item = nil)
    if item.is_a?(Array)
      message % link_to(*item)
    else
      message % item
    end
  end
end

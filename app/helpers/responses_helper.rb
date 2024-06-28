module ResponsesHelper
  def parse_and_render_cards(html_content)
    # NokogiriでHTMLを解析
    doc = Nokogiri::HTML(html_content)

    # ポジションごとに要素を分ける
    doc.css('h3').map do |header|
      content = ''
      element = header.next_element
      while element && element.name != 'h3'
        content += element.to_html
        element = element.next_element
      end
      {
        title: header.text,
        content:
      }
    end
  end

  def position_style(index)
    styles = {
      0 => "left: 50%; top: 5%; transform: translateX(-50%);",
      1 => "right: 10%; top: 20%;",
      2 => "left: 10%; top: 20%;",
      3 => "left: 50%; bottom: 35%; transform: translateX(-50%);",
      4 => "right: 25%; bottom: 50%;",
      5 => "left: 25%; bottom: 50%;",
      6 => "left: 30%; bottom: 20%;",
      7 => "right: 30%; bottom: 20%;",
      8 => "left: 5%; bottom: 20%;",
      9 => "right: 5%; bottom: 20%;",
      10 => "left: 50%; bottom: 5%; transform: translateX(-50%);"
    }
    base_style = styles[index] || ""

    responsive_style = "@media (max-width: 640px) { #{base_style.gsub(/(\d+)%/) { |_match| "#{(::Regexp.last_match(1).to_i * 0.9).round}%" }} }"

    base_style + responsive_style
  end
end

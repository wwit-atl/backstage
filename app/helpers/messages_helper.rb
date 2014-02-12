module MessagesHelper

  def markdown(text, format=nil)
    require 'redcarpet/render_strip'
    if format.nil?
      renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: false)
      options = {
          autolink: true,
          no_intra_emphasis: true,
          fenced_code_blocks: true,
          lax_html_blocks: true,
          strikethrough: true,
          superscript: true
      }
    else
      renderer = Redcarpet::Render::StripDown.new()
      options = {}
    end

    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end

end

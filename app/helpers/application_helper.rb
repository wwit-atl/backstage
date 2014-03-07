module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("#{association}/#{association.to_s.singularize}_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def format_time_ampm(time)
    return time.strftime('%l:%M %P') if time.respond_to?(:strftime)
    'N/A'
  end

  def human_datetime(input)
    return input.strftime('%m/%d/%Y %l:%M %P') if input.respond_to?(:strftime)
    'N/A'
  end

  def is_active?(link)
    current_page?(link) ? 'active' : nil
  end

  def bs_class_for(type)
    case type
      when :notice then 'alert-info'
      when :alert  then 'alert-warning'
      when :error  then 'alert-danger'
      else "alert-#{type}"
    end
  end

  # Displays a <span> using the requested glyphicon
  #   Opts = {
  #     text: 'The text to display along with the icon',
  #     class: 'Any additional classes to include on the span',
  #     title: 'The title text to insert (typically for popover help)',
  # }
  def get_icon(type, opts = {} )
    # Symbol shortcuts for frequently used icons.  Let's us easily change the icon site-wide when necessary.
    case type
      when :ban      then icon_class = 'ban-circle'
      when :add      then icon_class = 'plus'
      when :show     then icon_class = 'eye-open'
      when :edit     then icon_class = 'pencil'
      when :email    then icon_class = 'send'
      when :delete   then icon_class = 'trash'
      when :member   then icon_class = 'user'
      when :back     then icon_class = 'circle-arrow-left'
      when :next     then icon_class = 'circle-arrow-right'
      else icon_class = type.to_s
    end
    content_tag(:span, nil, class: ["glyphicon glyphicon-#{icon_class}", opts[:class]].compact, title: opts[:title]) +
        ( opts[:text].nil? ? nil : "&nbsp;#{opts[:text]}".html_safe )
  end

  def link_to_new(path, text = 'Add New')
    link_to get_icon(:add, text: text), path
  end

  def link_to_member(member, opts = {})
    return 'No Member Assigned' unless member.respond_to?(:name)
    link_to opts[:text] || member.name, member_path(member)
  end

  def link_to_skill(skill, opts = {})
    return 'No Skill Assigned' unless skill.respond_to?(:name)
    link_to opts[:text] || skill.name, skill_path(skill)
  end

  def link_to_show(show, opts = {})
    return 'No Show Assigned' unless show
    link_to opts[:text] || show.title, show_path(show)
  end

  def theatre_url
    'http://www.wholeworldtheatre.com'
  end

  def _markdown(text, format='html')
    require 'redcarpet/render_strip'
    if format == 'html'
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

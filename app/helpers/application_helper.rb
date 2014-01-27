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
    'Invalid Time Format'
  end

  def format_date(input)
    date = Date.parse(input)
    return date.strftime('%m/%d/%Y') if date.respond_to?(:strftime)
    'Invalid Date Format'
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

  def is_authorized?(member = Member.none)
    !!( current_member and ( current_member.is_admin? or current_member.id == member.id ) )
  end

  def theatre_url
    'http://www.wholeworldtheatre.com'
  end

end

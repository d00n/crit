module CharactersHelper
  def remove_link_unless_new_record(fields)
    out = ''
    out << fields.hidden_field(:_destroy)  unless fields.object.new_record?
    out << link_to("Remove", "##{fields.object.class.name.underscore}", :class => 'remove')
    out.html_safe
  end

  # This method demonstrates the use of the :child_index option to render a
  # form partial for, for instance, client side addition of new nested
  # records.
  #
  # This specific example creates a link which uses javascript to add a new
  # form partial to the DOM.
  #
  #   <% form_for @project do |project_form| -%>
  #     <div id="tasks">
  #       <% project_form.fields_for :tasks do |task_form| %>
  #         <%= render :partial => 'task', :locals => { :f => task_form } %>
  #       <% end %>
  #     </div>
  #   <% end -%>


  def generate_html(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f  

    form_builder.fields_for(method, options[:object], :child_index => 'NEW_RECORD') do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
    end

  end


  def generate_template(form_builder, method, options = {})
    escape_javascript generate_html(form_builder, method, options = {})
  end

  def column_is_populated(collection, attr_name)
    collection.each do |row|
      if !row[attr_name].blank?
        return true
      end
    end
    return false
  end
end

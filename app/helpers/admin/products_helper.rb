module Admin::ProductsHelper
  def link_to_add_image(name, form, association, options = {}, purchase = nil)
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render("#{association.to_s.singularize}_fields#{purchase.present? ? '_edit' : ''}", ff: builder)
    end
    link_to '#', class: "#{options[:klass]}", data: {id: id, fields: fields.gsub('\n', '')} do
      raw "<i class='fa fa-plus-circle'></i> #{name}"
    end
  end
end

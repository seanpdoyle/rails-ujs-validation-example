class ValidationMessageFormBuilder < ActionView::Helpers::FormBuilder
  NULL_OBJECT = Class.new(BasicObject) do
    def to_s
      ""
    end

    def to_ary
      [self]
    end

    def method_missing(*)
      self
    end
  end.new

  def email_field(attribute, *arguments, **attributes)
    super attribute, *arguments, **validation_attributes(attribute).with_defaults(attributes)
  end

  def text_field(attribute, *arguments, **attributes)
    super attribute, *arguments, **validation_attributes(attribute).with_defaults(attributes)
  end

  def validation_message_template(data: {}, **attributes, &block)
    @validation_message_template = block

    content = @template.with_output_buffer do
      @validation_message_template.call(NULL_OBJECT, NULL_OBJECT)
    end

    data_attribute = data.with_defaults(validation_message_template: id)

    @template.tag.template content, data: data_attribute, **attributes
  end

  def validation_message(attribute)
    if @validation_message_template.present?
      html = @template.with_output_buffer do
        @validation_message_template.call(object, attribute)
      end

      fragment = Nokogiri::HTML::DocumentFragment.parse(html)
      node = fragment.at_css("*:first-child")

      node["id"] ||= validation_dom_id(attribute)
      if node.content.blank?
        node.content = object.errors[attribute].first
      end

      @template.raw node
    end
  end

  def id
    @options.dig(:html, :id)
  end

  def to_partial_path
    "form"
  end

  private

  def validation_attributes(attribute)
    invalid = object.errors[attribute].any?

    {
      aria: { invalid: ("true" if invalid), describedby: validation_dom_id(attribute) },
      data: { will_validate: (true if invalid) },
    }
  end

  def validation_dom_id(attribute)
    [id, object.model_name.singular, attribute, :validation_message].join("_")
  end
end

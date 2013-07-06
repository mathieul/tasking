class ImportService
  FORMATS = %I[csv]

  def teammates(request)
    request, default_attributes = request.slice(*FORMATS), request.except(*FORMATS)
    default_attributes.stringify_keys!
    request.each do |format, content|
      klass = Import.const_get(:"Teammates#{format.to_s.camelize}")
      klass.new.import(content, default_attributes)
    end
  end
end

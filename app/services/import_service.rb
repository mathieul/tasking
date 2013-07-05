class ImportService
  attr_reader :attributes

  def initialize(attributes = {})
    @attributes = attributes.stringify_keys
  end

  def teammates(request)
    request.each do |format, content|
      klass = Import.const_get(:"Teammates#{format.to_s.camelize}")
      klass.new(attributes).import(content)
    end
  end
end

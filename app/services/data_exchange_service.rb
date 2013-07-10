class DataExchangeService
  FORMATS = %I[csv]

  attr_reader :operation

  def import
    @operation = "Import"
    self
  end

  def export
    @operation = "Export"
    self
  end

  def teammates(format = nil, request)
    format, request = request, {} unless request.is_a?(Hash)
    request[format] = true if format
    run_exchange("Teammates", request)
  end

  private

  def run_exchange(type, request)
    request, default_attributes = request.slice(*FORMATS), request.except(*FORMATS)
    default_attributes.stringify_keys!
    format, content = request.first
    worker_class_for(type, format).new.run(content, default_attributes)
  end

  def worker_class_for(type, format)
    DataExchange.const_get(:"#{operation}#{type}#{format.to_s.camelize}")
  end
end

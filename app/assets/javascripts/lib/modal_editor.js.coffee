class @App.ModalEditor
  resource: "override .resource!"
  resourceFields: "override .resourceFields!"

  constructor: (selector) ->
    @box = $(selector)
    @postConstructor?()

  newResource: (attributes) ->
    @initializeForm("create")
    @initializeFields(attributes)
    @initializeLabels("create")
    @box.modal("show")

  editResource: (attributes) ->
    @initializeForm("update", attributes.id)
    @initializeFields(attributes)
    @initializeLabels("update")
    @box.modal("show")

  initializeForm: (method, id = null) ->
    form = @box.find("form")
    url = form.data(method).replace /__id__/, id
    form.prop("action", url)
    verb = form.find("input[name=_method]")
    verb.val(if method is "create" then "post" else "patch")

  initializeFields: (attributes) ->
    for field in @resourceFields
      @box.find("*[name=\"#{@resource}[#{field}]\"]").val(attributes[field])
    @box.one "shown", =>
      @box.find('*[name="#{@resource}[description]"]').select()
    @postInitializeFields?(attributes)

  initializeLabels: (method) ->
    submit = @box.find(".btn-primary")
    submit.val(submit.data(method))
    title = @box.find(".title")
    title.text(title.data(method))

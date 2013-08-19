#= require ../lib/base_controller

class SignupController extends App.BaseController
  setup: ->
    @focusFirstField()
    @guessTeamName()

  destroy: ->
    $("#account_email").off("blur")

  guessTeamName: ->
    $("#account_email").on "blur", (event) ->
      teamName = $("#account_team_attributes_name")
      email = $(event.target).val()
      if teamName.val() is '' and email isnt '' and (match = /@([^.]+)/.exec email)
        name = match[1][0].toUpperCase() + match[1][1..-1].toLowerCase()
        teamName.val(name)

@App.signup = new SignupController

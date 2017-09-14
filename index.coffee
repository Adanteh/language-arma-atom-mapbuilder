{CompositeDisposable} = require 'atom'
copyNewer = require 'copy-newer'

buildProject = require './lib/build-functionlist'
optionalAutocomplete = require './lib/optional-autocomplete'

module.exports =
  subscriptions: null

  config:
    includeMB:
      title: "Include MapBuilder"
      description: "Include MB Snippets and highlighting"
      type: "boolean"
      default: true
      order: 1
    includeFRL:
      title: "Include Frontline"
      description: "Include FRL Snippets and highlighting"
      type: "boolean"
      default: false
      order: 2

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'language-arma-atom-mapbuilder:build-functionlist': => buildProject.functions()
    # If package is updated, copy required autosuggest files
    copyNewer "language-sqf-mapbuilder*", "#{__dirname}/snippets", {
      cwd: "#{__dirname}/snippetsAvailable"
    }
    copyNewer "language-sqf-mapbuilder*", "#{__dirname}/settings", {
      cwd: "#{__dirname}/settingsAvailable"
    }

    # Copy optional autosuggest files
    atom.config.observe 'language-arma-atom-mapbuilder.includeMB', (checked) ->
      optionalAutocomplete.set('mb', checked)

    atom.config.observe 'language-arma-atom-mapbuilder.includeFRL', (checked) ->
      optionalAutocomplete.set('frl', checked)

  deactivate: ->
    @subscriptions.dispose()

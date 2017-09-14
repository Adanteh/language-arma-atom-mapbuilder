spawn = require('child_process').spawn

module.exports =
  build: (text, script) ->
    # Start notification
    startNotification = atom.notifications.addInfo (text + ' Creating list'), dismissable: true, detail: 'Stand by ...'

    # Get Script Path
    path = atom.project.getPaths() + '\\@MapBuilder\\Addons\\MapBuilder\\functions' + script

    # Spawn build process and add Error notification handler
    buildProcess = spawn 'python', [path.replace(/%([^%]+)%/g, (_,n) -> process.env[n])]
    buildProcess.stderr.on 'data', (data) -> atom.notifications.addError (text + ' Build Error'), dismissable: true, detail: data

    buildProcess: buildProcess
    startNotification: startNotification

  functions: ->
    info = @build("CfgFunctions creator", "makefunctionlist.py")

    # Add Success notification handler
    info.buildProcess.stdout.on 'data', (data) -> atom.notifications.addSuccess 'Function list created', dismissable: true, detail: data

    # Hide start notification
    info.buildProcess.stdout.on 'close', => info.startNotification.dismiss()

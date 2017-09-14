# From  ACE language, don't know how to include in this scripting

fs = require 'fs'
path = require 'path'
copyNewer = require 'copy-newer'

packageRoot = path.resolve(__dirname, '../')
fileList =
  mb:
    snippets: [
      'language-sqf-mapbuilder.cson'
    ]
    settings: [
      'language-sqf-functions-mapbuilder.cson'
    ]
  frl:
    snippets: [
      'language-sqf-frontline.cson'
    ]
    settings: [
      'language-sqf-functions-frontline.cson'
    ]

module.exports =
  set: (addonName, required) ->
    addon = fileList[addonName]
    operations = []

    # If required always try to copy; If package was updated we'll get newest files
    if required
      for type of addon
        operations.push copyNewer(file, "#{packageRoot}/#{type}", {
          cwd: "#{packageRoot}/#{type}Available/"
        }) for file in addon[type]
    else
      for type of addon
        operations.push deleteFile "#{packageRoot}/#{type}/#{f}" for f in addon[type]

    # For debugging
    Promise.all(operations)
      .catch (err) -> console.error 'Error while updating autocomplete settings. =>', err


deleteFile = (file) ->
  return new Promise (resolve, reject) ->
    fs.unlink file, (err) ->
      # Ignore error for non-existing file
      if err and err.toString().indexOf('ENOENT') < 0
        reject("ERROR deleting file: #{file}")
      else resolve("#{file} removed")

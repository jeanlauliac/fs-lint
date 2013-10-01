# # File-system Lint
#
# This tool lints a structure of files and folders, enforcing the type of
# files, as well as the file naming.

'use strict'
path        = require 'path'
glob        = require 'glob'
_           = require 'lodash'
{EventEmitter} = require 'events'

namings =
    'lowerCamelCase'        : /^_*[a-z][A-Za-z0-9]*[-_a-z.]*$/
    'UpperCamelCase'        : /^_*[A-Z][A-Za-z0-9]*[-_a-z.]*$/
    'lowercase-dash'        : /^_*[a-z0-9]+(-[a-z0-9]+)*[-_a-z.]*$/
    'lowercase_underscore'  : /^_*[a-z0-9]+(_[a-z0-9]+)*[-_a-z.]*$/

class FsLint extends EventEmitter
    createEntry: (isError, filePath, naming) ->
        { isError, filePath, naming }

    processPaths: (filePaths, namingName, naming, isError, callbacks) ->
        okay = true
        for filePath in filePaths
            if naming.test(path.basename(filePath))
                continue
            @emit 'entry', @createEntry(isError, filePath, namingName)
            okay = false if isError
        okay

    processRule: (rule) ->
        okay = true
        patterns = if _.isArray rule.files then rule.files else [rule.files]
        naming = namings[rule.naming]
        for pattern in patterns
            @emit 'pattern', pattern
            filePaths = glob.sync(pattern)
            if filePaths.length == 0
                @emit 'emptyPattern', pattern
                continue
            okay = false unless @processPaths(filePaths, rule.naming
                naming, rule.level == 'error')
        okay

    process: (config, baseDir) ->
        baseDir ?= process.cwd
        okay = true
        for rule in config.rules
            rule.level = 'error' unless rule.level?
            unless rule.level in ['ignore', 'warning', 'error']
                @emit 'unknownLevel', rule.level
                okay = false
                continue
            unless rule.naming of namings
                @emit 'unknownNaming', rule.naming
                okay = false
                continue
            if rule.level != 'ignore'
                okay = false unless @processRule rule
        okay

module.exports = FsLint

FsLint      = require './fs-lint'
log         = require('yadsil')('fs-lint')
commander   = require 'commander'
fs          = require 'fs'

processCli = ->
    commander
        .usage('[options]')
        .option('-c, --config <file>', 'specify configuration file')
        .option('-v, --verbose', 'show more information')
        .option('--color', 'force color display out of a TTY')
        .parse(process.argv)
    log.verbose commander.verbose
    log.color commander.color
    commander

module.exports = ->
    commander = processCli()
    configPath = commander.config ? '.fs-lint'
    unless fs.existsSync(configPath)
        log.error "can not find '#{configPath}' config. file"
        process.exit 2
    config = JSON.parse(fs.readFileSync(configPath, 'utf8'))
    fsLint = new FsLint
    fsLint.on 'entry', (entry) ->
        message = "violates '#{entry.namingName}' naming: #{entry.filePath}"
        unless entry.isError
            return log.warning message
        log.error message
    fsLint.on 'pattern', (pattern) ->
        log.info "testing pattern '#{pattern}'..."
    fsLint.on 'unknownLevel', (level) ->
        log.error "unknown log level '#{level}'"
    fsLint.on 'unknownNaming', (naming) ->
        log.error "unknown naming type '#{naming}'"
    fsLint.on 'emptyPattern', (pattern) ->
        log.warning "no file matched for pattern '#{pattern}'"
    unless fsLint.process(config)
        process.exit 1

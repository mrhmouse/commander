cp = require 'child_process'
module.exports = ->
	cp.exec 'fortune', ( error, stdout ) =>
		@say error ? stdout.toString()

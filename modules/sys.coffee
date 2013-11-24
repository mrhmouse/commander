cp = require 'child_process'

module.exports = ( from, args... ) ->
	console.log args.join ' '
	cp.exec ( args.join ' ' ), ( error, stdout, stderr ) =>
		@say if error? then error else stdout.toString()

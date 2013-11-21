path = require 'path'
hooks = {}

module.exports = ( action, args... ) ->
	if 'init' is action
		for m in args
			key = path.join __dirname, 'hooks', m + '.coffee'
			delete require.cache[key]
			try
				hooks[m] = require key
				hooks[m].init.call this
			catch e
				console.log e
	else if hooks[action]?
		[ op, args... ] = args
		func = hooks[action][op]
		if typeof func is 'function'
			func.apply this, args
		else
			@say "Unknown command '#{ op }' for hook '#{ action }'..."
	else
		@say "Hook '#{ action }' not loaded..."
	return

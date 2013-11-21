irc = require 'irc'
path = require 'path'
fs = require 'fs'
{ EventEmitter } = require 'events'
MODULE_DIR = 'modules'

class Commander extends EventEmitter
	constructor: ({ @prefix, @channel, @masters, @server, @name }) ->
		@server ?= 'localhost'
		@commands = {}
		@permissions = {}
		@_client = new irc.Client @server, @name,
			channels: [@channel]
			userName: @name
			realName: @name

		@_client.on 'message', ( from, to, text ) =>
			return unless 0 is text.indexOf @prefix
			text = text[@prefix.length...]
			[op, args...] = ( t for t in text.split ' ' when t.length )
			if typeof @commands[op] is 'function'
				perms = @permissions[op]
				unless from in @masters
					unless perms?
						@say "No permissions found for #{ op }..."
						return

					unless from in perms
						@say "You don't have permission to use #{ op }..."
						return

				try
					@commands[op].apply @, args
				catch e
					console.log e
					@say "Command '#{ op }' had an error..."
				return

			if op is 'load'
				unless from in @masters
					@say 'You are not in the master list, so you cannot load modules.'
					return

				if args.length
					@load args
				else
					@say "Please specify a module to load."
			else if op is 'perm'
				unless from in @masters
					@say 'You are not in the master list, so you cannot change permissions.'
					return

				@perm args...
			else
				@say "Module '#{ op }' not loaded..."
				names = ( n for n, v of @commands when typeof v is 'function' )
				@say "Try one of these: #{ names.sort().join ', ' }" if names.length

	say: ( message ) =>
		@_client.say @channel, message

	load: ( filenames ) =>
		for filename in filenames
			key = path.join __dirname, MODULE_DIR, filename + '.coffee'
			delete require.cache[key]
			console.log "Loading #{ key }..."
			try
				@commands[filename] = require key
				@emit 'load', filename, key, @commands[filename]
			catch e
				console.log e
				@say "Failed to load '#{ filename }'."

	perm: ( action, user, ops... ) =>
		switch action
			when 'grant'
				for op in ops
					@permissions[op] ?= []
					@permissions[op].push user
				@say "Granted '#{ user }' access to commands: #{ ops }..."
			when 'revoke'
				for op in ops
					@permissions[op] ?= []
					index = @permissions[op].indexOf user
					if index is 0
						@permissions[op].pop()
					else
						@permissions[op] =
							@permissions[op][0..index].concat @permissions[op][index + 1..]
				@say "Revoked '#{ user }' permissions for: #{ ops }..."
			when 'save'
				out = fs.createWriteStream path.join __dirname, 'permissions.json'
				out.write ( JSON.stringify @permissions ), -> out.close()
				@say 'Saved permissions...'
			when 'load'
				@permissions = require path.join __dirname, 'permissions.json'
				@say 'Loaded permissions...'
			else
				@say "Uknown action '#{ action }'..."
				return

		@emit 'perm', action, user, ops...
		return

new Commander
	channel: '#redspider'
	masters: [ 'mrhmouse' ]
	server: 'irc.foonetic.net'
	name: 'mbot'
	prefix: '~!'

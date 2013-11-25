messages = {}
hooked = no
elapsedSince = require '../lib/elapsedSince.coffee'

module.exports = ( from, name, message... ) ->
	# If the user is already online, there's no
	# need to tell them.
	if @names[name]?
		@say "#{ name } is already here! Tell them yourself!"
		return

	message =
		time: new Date
		from: from
		message: message.join ' '

	messages[name] ?= []
	messages[name].push message

	unless hooked
		hooked = yes
		@_client.on 'join', ( channel, nick ) =>
			return unless messages[nick]?.length
			for m in messages[nick]
				@say "#{ nick }: Message from #{ m.from } " +
				"about #{ elapsedSince m.time } ago: #{ m.message }"
			messages[nick] = []
			return

	@say 'Consider it noted.'

	return

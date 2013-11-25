elapsedSince = require '../lib/elapsedSince.coffee'
times = {}

saw = ( name ) -> times[name] = new Date
seen = ( name ) -> times[name]
hooked = no

module.exports = ( name ) ->
	unless hooked
		hooked = yes
		@_client.on 'join', ( channel, nick ) -> saw nick
		@_client.on 'part', ( channel, nick ) -> saw nick
		@_client.on 'message#', ( nick ) -> saw nick

	last = seen name
	@say if last?
		"I last saw #{ name } about #{ elapsedSince last } ago."
	else
		 "I haven't seen #{ name }, sorry."

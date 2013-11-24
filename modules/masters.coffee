module.exports = ( from, action, users... ) ->
	unless users?.length
		@say 'Usage: masters [add | remove] <users...>'
		@say '       masters list'
		return

	for user in users
		switch action
			when 'add'
				@masters.push user unless user in @masters
				@say "Added #{ user } to master list..."
			when 'remove'
				if user in @masters
					index = @masters.indexOf user
					@masters = @masters[0...index].concat @masters[index + 1..]
					@say "Removed '#{ user }' from master list..."
				else
					@say "'#{ user }' isn't in the master list..."
			when 'list'
				@say @masters.join ', '
			else
				@say "Unknown action '#{ action }'."

	return

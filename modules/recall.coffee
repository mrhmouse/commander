path = require 'path'
fs = require 'fs'
file = path.join __dirname, 'modules.json'

module.exports = ( from, action ) ->
	switch action
		when 'save'
			modules = ( name for name, value of @commands )
			out = fs.createWriteStream file
			out.write ( JSON.stringify modules ), =>
				out.close()
				@say "Saved module list: #{ modules.join ', ' }"
		when 'load'
			delete require.cache[file]
			@load require file
		else
			@say "Unknown action '#{ action }'..."
	return

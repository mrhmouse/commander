fs = require 'fs'
http = require 'http'
https = require 'https'

module.exports = ( from, name, url ) ->
	unless url? and name?
		@say 'You must provide a name and a URL...'
		return

	out = fs.createWriteStream path.join __dirname, name + '.coffee'
	( if url[0...5].toLowerCase() is 'https' then https else http )
	.get url, ( res ) =>
		res.pipe out
		res.on 'end', => @load name

https = require 'https'
qs = require 'querystring'

module.exports = ( from, word ) ->
	path = 'https://duckduckgo.com/?' + qs.stringify q: word, format: 'json'
	https.get path, ( res ) =>
		data = new Buffer 0
		res.on 'data', ( d ) -> data = Buffer.concat [ data, d ]
		res.on 'end', =>
			{ Definition: result } = JSON.parse data.toString()
			@say if result.length is 0
				"No definition for #{ word } could be found."
			else
				result

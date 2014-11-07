# Description:
#   Saves your quotes, sorted by #tag
#
# Dependencies:
#   redis-brain
#
# Configuration:
#   None
#
# Commands:
#   hubot add quote #TAG "QUOTE" -SPEAKER - Save the QUOTE under tag TAG and speaker SPEAKER
#   hubot get quote #TAG - Get a random quote tagged by TAG
#
# Author:
#   bencentra

class Quotes

  constructor: (@robot) -> 
    @savePerTag = 25
    @cache = {}
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.quotes
        @cache = @robot.brain.data.quotes
      else
        @robot.brain.data.quotes = {}

  dumpCache: ->
    return JSON.stringify(@cache)

  getQuotesByTag: (tag) ->
    return @cache[tag] or []

  addQuote: (tag, quote, speaker) ->
    if (!@cache[tag])
      @cache[tag] = []
    len = @cache[tag].length
    @cache[tag].push({speaker: speaker, quote: quote});
    if (@cache[tag].length > len)
      if (@cache[tag].length > @savePerTag)
        @cache[tag] = @cache[tag].slice(-1 * @savePerTag)
      @robot.brain.data.quotes = @cache
      return true
    return false

module.exports = (robot) ->

  quotes = new Quotes(robot)

  robot.respond /add quote #(\w+) "(.*)" -\s*(.*)/i, (msg) ->
    tag = msg.match[1]
    quote = msg.match[2]
    speaker = msg.match[3]
    result = quotes.addQuote(tag, quote, speaker)
    if (result)
      msg.send("Success!")
    else
      msg.send("Error!")

  robot.respond /get quote #(\w+)/i, (msg) ->
    tag = msg.match[1]
    taggedQuotes = quotes.getQuotesByTag(tag)
    if (quotes.length > 0)
      result = msg.random taggedQuotes
      msg.send("\"" + result.quote + "\" -" + result.speaker)
    else
      msg.send("No quotes for #" + tag)

  # robot.hear /test cache/i, (msg) ->
  #   msg.send(quotes.dumpCache())

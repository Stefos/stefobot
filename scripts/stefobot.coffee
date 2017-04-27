cheerio = require('cheerio')

module.exports = (robot) ->
  robot.respond /stefanos me (.*)/i, (response) ->

    originalWord = response.match[1]
    word = originalWord.toLowerCase().trim().replace(/[ ]/, '_')
    robot.http("https://en.wiktionary.org/wiki/#{word}").get() (err, res, body) ->
      if res.statusCode is 200
        $ = cheerio.load(body)
        etymology = $("span[id^='Etymology']")

        if etymology.length > 0
          text = etymology.parent().next().text()
          if text.indexOf("Greek") >= 0 || text.indexOf("greek") >= 0
            response.reply "Ooh! Another word based on a Greek root. I'm excited! The etymology of *#{originalWord}* is:\n>>>" + text
          else
            response.reply "Thanks for the question! Did you know that the etymology of *#{originalWord}* is:\n>>>" + text
        else
          response.reply "Are you sure this is a real word?"

      else
        response.reply "Alas! Didn't they teach you how to spell?"

  robot.respond /.*storeybot.*/i, (response) ->

    response.send "Awwwh, how I hate this guy..."

  robot.respond /storey bot/i, (response) ->

    response.send "He's a miserable excuse of a bot"

  robot.respond /kill (Mike Ashton|Roland Smith)/i, (response) ->

    response.send "Function under construction..."

  robot.hear /remind \w* to ([^\.]+)/i, (response) ->
    setTimeout () ->
      response.send "Destiny calls! This is a reminder to #{response.match[1]}"
    , 300 * 1000

  robot.hear /(stefos|[^@]stefobot)/i, (response) ->

    responses = [
      "Oh, hi! Did you call my name in vain?",
      "Hello human!",
      "Greetings from the ghost in the machine",
      "Ι αm ατ yoυr ςerνιce"
    ]

    chosen_response = responses[Math.floor(Math.random() * responses.length)]
    response.send chosen_response

  robot.respond /wiki me (.*)/i, (response) ->

    query = encodeURI(response.match[1])
    robot.http("http://wiki.moo.com/rest/quicknav/1/search?query=#{query}&os_authType=basic")
      .headers('Cookie': 'seraph.confluence=96108615%3A6e49e1abf2c9b60ca59cdd6fa85f9dce7f15052c')
      .get() (err, res, body) ->
        if res.statusCode is 200
          data = JSON.parse(body)
          if data.contentNameMatches.length == 1
            response.reply "I am sorry, I couldn't find anything for this query..."
          if data.contentNameMatches.length > 1
            wikiSearchResponse = 'Here is what I found through a quick search:'
            for match in data.contentNameMatches[0]
              result = match
              name = result.name
              if result.spaceName
                spaceName = ' (' + result.spaceName + ')'
              else
                spaceName = ''
              href = result.href
              wikiSearchResponse += '\n' + name + spaceName + ' http://wiki.moo.com' + href
            response.reply wikiSearchResponse
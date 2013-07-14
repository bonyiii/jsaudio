class @Player
  constructor: (fadeoutTime = 10, fadeinTime = 2) ->
    @second = 1000
    @fadeingOut = false
    @fadeoutTime = fadeoutTime
    @fadeinTime = fadeinTime
    @current = window.audio1
    @next = window.audio2

  switchPlayer: ->
    if @current == window.audio1
      @current = window.audio2
      @next = window.audio1
    else
      @current = window.audio1
      @next = window.audio2

  play: ->
    @current.volume = 1
    @current.play()
    @current.addEventListener("MozAudioAvailable", @setFadeout, false)

  pause: ->
    @current.pause()

  setFadeout: =>
    #console.log("#{@fadeingOut} #{@current.duration - @current.currentTime} <= #{@fadeoutTime}")
    if @current.duration - @current.currentTime <= @fadeoutTime
      @playNext()

  playNext: ->
    if @fadeingOut
      console.log("Fadeing out already, bro")
      return
    #@fadeoutStarted = new Date.getTime() / @second
    @fadeingOut = true
    @doFadeout()

  doFadeout: ->
    interval = 1 * @second
    volumeStep = (@current.volume * 100 / @fadeoutTime) / 100
    console.log "volumeStep: #{volumeStep} interval: #{interval / @second} fadeoutTime: #{@fadeoutTime}"
    fadeout = setInterval =>
      if @current.volume > 0
        if @current.volume - volumeStep < 0
          @current.volume = 0
        else
          @current.volume -= volumeStep
        console.log "Decreasing volume by #{volumeStep}"
      else
        @finishFadeout(fadeout)
      if @current.volume < 0.5 && @next.paused
        @next.volume = 1
        @next.play()
    , interval

  finishFadeout: (fadeoutInterval) ->
    clearInterval(fadeoutInterval)
    @fadeingOut = false
    @current.pause()
    @switchPlayer()
    console.log "Fadeout finished"



jQuery ->
  window.audio1 = document.getElementsByTagName("audio")[0]
  window.audio2 = document.getElementsByTagName("audio")[1]
  player = new Player(10)
  player.play()
  $('#play-next').on 'click', ->
    player.playNext()
  $('#play').on 'click', ->
    player.play()
  $('#pause').on 'click', ->
    player.pause()

    #  doFadeout: ->
    #    interval = 1 * @second
    #    volumeStep = (@current.volume * 100 / @fadeoutTime) / 100
    #    console.log "volumeStep: #{volumeStep} interval: #{interval / @second} fadeoutTime: #{@fadeoutTime}"
    #    fadeout = setInterval =>
    #      currentTime = new Date().getTime() / @second
    #      console.log "#{@fadeoutStartTime} + #{@fadeoutTime} <= #{currentTime} + #{@fadeinTime}"
    #      if @current.volume > 0
    #        if @current.volume - volumeStep < 0
    #          @current.volume = 0
    #        else
    #          @current.volume -= volumeStep
    #        console.log "Decreasing volume by #{volumeStep}"
    #      else
    #        @finishFadeout(fadeout)
    #      if @fadeoutStartTime + @fadeoutTime <= currentTime + @fadeinTime  && @next.paused
    #        @next.volume = 1
    #        @next.play()
    #    , interval
    #

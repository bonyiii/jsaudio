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

  setFadeout: =>
    #console.log("#{@fadeingOut} #{@current.duration - @current.currentTime} <= #{@fadeoutTime}")
    return if @fadeingOut
    if @current.duration - @current.currentTime <= @fadeoutTime + 40
      @fadeingOut = true
      @doFadeout()
      console.log("#{@current.currentTime} fadeout started")

   doFadeout: ->
     interval = 1 * @second #@current.volume * 100 / @fadeoutTime
     volumeStep = 0.1
     console.log "Fadeout should start"
     fadeout = setInterval =>
        if @current.volume > 0
          if @current.volume - volumeStep < 0
            @current.volume = 0
          else
            @current.volume -= volumeStep
          console.log "Decreasing volume by #{volumeStep}"
        else
          clearInterval(fadeout)
        if @current.volume < 0.5 && @next.paused
          @next.play()
      , interval


jQuery ->
  window.audio1 = document.getElementsByTagName("audio")[0]
  window.audio2 = document.getElementsByTagName("audio")[1]
  player = new Player()
  player.play()
  #audio1.load()
  #audio1.play()
  #audio.pause()
  
  #$display = $("#display-samples")
  #lines = []
  #window.writeSamples = (event) ->
  #  lines.push "#{event.frameBuffer[0]}, #{event.frameBuffer[1]}, #{event.frameBuffer[2]}"
  #  lines.shift() if lines.length > 20
  #  $display.html(lines.join("<br>"))

  #audio.addEventListener("MozAudioAvailable", writeSamples, false)

  #vol = 1
  #interval = 600

  #fadeout = setInterval ->
  #  if vol > 0
  #    vol -= 0.05
  #    vol = if vol < 0 then 0 else vol
  #    audio1.volume = vol
  #  else
  #    clearInterval(fadeout)
  #  if vol < 0.4 && audio2.paused
  #    console.log "audio2 start was called"
  #    audio2.volume = 1
  #    audio2.play()
  #  console.log "#{vol} #{fadeout}"
  #, interval

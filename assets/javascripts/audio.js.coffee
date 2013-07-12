class @Player
  constructor: (fadeoutTime = 10, fadeinTime = 2) ->
    @second = 1000
    @fadeoutTime = fadeoutTime * second
    @fadeinTime = fadeinTime * second
    @current = window.audio1
    @next = window.audio2

  switchPlayer: ->
    if @current == window.audio1
      @current = window.audio2
      @next = window.audio1
    else
      @current = window.audio1
      @next = window.audio2

  initPlay: ->
    @current.play()
    @current.addEventListener("MozAudioAvailable", @setFadout, false)

  setFadeout: ->
    return if @fadeingOut
    if @current.duration - audio.currentTime <= @fadoutTime * second
      interval = @fadeoutTime / 20 
      @fadeingOut = true
      fadout = setInterval ->
        if vol > 0
          vol -= 0.05
          vol = if vol < 0 then 0 else vol
          @current.volume = vol
        else
          clearInterval(fadeout)
        if vol < 0.5 && audio2.paused
          audio2.play()
      , interval


jQuery ->
  window.audio1 = document.getElementsByTagName("audio")[0]
  window.audio2 = document.getElementsByTagName("audio")[1]
  audio1.load()
  audio1.play()
  #audio.pause()
  $display = $("#display-samples")
  lines = []

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

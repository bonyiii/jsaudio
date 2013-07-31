class @Player
  constructor: (@fadeoutTime = 10, @fadeinTime = 2) ->
    @ui()
    @second = 1000
    @fadeingOut = false
    @current = window.audio1
    @current.addEventListener("MozAudioAvailable", @timeTrack, false)
    @volume = @current.volume
    @next = window.audio2

  switchPlayer: ->
    # http://stackoverflow.com/questions/4402287/javascript-remove-event-listener
    @current.removeEventListener("MozAudioAvailable", @timeTrack)
    if @current == window.audio1
      @current = window.audio2
      @next = window.audio1
    else
      @current = window.audio1
      @next = window.audio2
    @current.addEventListener("MozAudioAvailable", @timeTrack, false)

  play: ->
    @current.play()
    @$pause.removeClass("hide")
    @$play.addClass("hide")

  pause: ->
    @current.pause()
    @$play.removeClass("hide")
    @$pause.addClass("hide")

  now: ->
    date = new Date()
    date.getTime() / @second

  timeTrack: =>
    progress = ((@current.currentTime / @current.duration) * 100)
    @$progressBar.val(progress)
    #console.log("#{@fadeingOut} #{@current.duration - @current.currentTime} <= #{@fadeoutTime}")
    if @current.duration - @current.currentTime <= @fadeoutTime
      @playNext({auto: true})

  playNext: (obj = {}) ->
    if @fadeingOut
      console.log("Fadeing out already, bro") unless obj.auto
      return 
    @fadeoutStarted = @now()
    @volume = @current.volume
    @fadeingOut = true
    @doFadeout()
    #@iterator = 0

  doFadeout: ->
    interval = 1 * @second
    volumeStep = (@current.volume * 100 / @fadeoutTime) / 100
    #console.log "volumeStep: #{volumeStep} interval: #{interval / @second} fadeoutTime: #{@fadeoutTime}"
    fadeout = setInterval =>
      if @current.volume > 0
        if @current.volume - volumeStep < 0
          @current.volume = 0
        else
          @current.volume -= volumeStep
        #console.log "Decreasing volume by #{volumeStep}"
      if @fadeoutStarted + @fadeoutTime <= @now() + @fadeinTime && @next.paused
        @next.volume = @volume
        console.log("start playing on next #{@next.id}")
        @next.play()
      @finishFadeout(fadeout) if @current.volume == 0
      #console.log "#{@fadeoutStarted} + #{@fadeoutTime} <= #{@now()} + #{@fadeinTime}"
      #console.log("iterator: #{@iterator}")
      #@iterator += 1
    , interval

  finishFadeout: (fadeoutInterval) ->
    clearInterval(fadeoutInterval)
    @fadeingOut = false
    @current.pause()
    @switchPlayer()
    console.log "Fadeout finished"

  ui: ->
    @$progressBar = $('.music-player progress.progress')
    @$play = $('.music-player .icon-play')
    @$pause = $('.music-player .icon-pause')
    @$play.on 'click', =>
      @play()
    @$pause.on 'click', =>
      @pause()
    $('.music-player .icon-forward').on 'click', =>
      @playNext()
    timeDrag = false

    @$progressBar.mousedown (e) => 
      timeDrag = true
      @updateBar(e.pageX)
    $(document).mouseup (e) =>
      if !!timeDrag
        timeDrag = false
        @updateBar(e.pageX)
    $(document).mousemove (e) =>
      @updateBar(e.pageX) if !!timeDrag

  # http://www.inwebson.com/html5/custom-html5-video-controls-with-jquery/
  updateBar: (x) ->
    position = x - @$progressBar.offset().left
    percentage  = 100 * position / @$progressBar.width()

    if (percentage > 100)
      percentage = 100
      @pause()
    if (percentage < 0)
      percentage = 0
    @current.currentTime = @current.duration * (percentage / 100)
    @$progressBar.val(percentage)


jQuery ->
  window.audio1 = document.getElementsByTagName("audio")[0]
  window.audio2 = document.getElementsByTagName("audio")[1]
  player = new Player(10, 10)
  player.play()

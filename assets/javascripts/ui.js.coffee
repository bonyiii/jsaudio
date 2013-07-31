class @UI
  constructor: (@player) ->
    @dom()
    @listeners()

  dom: ->
    @$progressBar = $('.music-player progress.progress')
    @$volumeBar = $('.music-player progress.volume')
    @$play = $('.music-player .icon-play')
    @$pause = $('.music-player .icon-pause')
    @$ff = $('.music-player .icon-forward')
    @$mute = $('.music-player .mute')

  listeners: ->
    @buttonListener()
    @progressBarListener()
    @volumeBarListener()

  # http://www.inwebson.com/html5/custom-html5-video-controls-with-jquery/
  seek: (x) ->
    position = x - @$progressBar.offset().left
    percentage = 100 * position / @$progressBar.width()
    if (percentage > 100)
      percentage = 100
    if (percentage < 0)
      percentage = 0
    @player.seek(percentage)

  updateProgressBar: (percentage) ->
    @$progressBar.val(percentage)

  # called by player
  playButton: (status) ->
    switch status
      when "pause"
        @$play.removeClass("hide")
        @$pause.addClass("hide")
      when "play"
        @$pause.removeClass("hide")
        @$play.addClass("hide")

  # called by player
  muteButton: (muted) ->
    if muted
     @$mute.removeClass("icon-volume-up") 
     @$mute.addClass("icon-volume-off") 
    else
     @$mute.removeClass("icon-volume-off") 
     @$mute.addClass("icon-volume-up") 

  buttonListener: ->
    @$play.on 'click', =>
      @player.play()
    @$pause.on 'click', =>
      @player.pause()
    @$ff.on 'click', =>
      @player.playNext()
    @$mute.on 'click', =>
      @player.toggleMute()

  progressBarListener: ->
    timeDrag = false

    @$progressBar.mousedown (e) => 
      timeDrag = true
      @seek(e.pageX)
    $(document).mouseup (e) =>
      if !!timeDrag
        timeDrag = false
        @seek(e.pageX)
    $(document).mousemove (e) =>
      @seek(e.pageX) if !!timeDrag

  volumeBarListener: ->
    @$volumeBar.on 'mousedown', (e) =>
      position = e.pageX - @$volumeBar.offset().left
      percentage = 100 * position / @$volumeBar.width()
      @player.setVolume(percentage)

  updateVolumeBar: (percentage) ->
    @$volumeBar.val(percentage)

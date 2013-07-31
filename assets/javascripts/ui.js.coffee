class @UI
  constructor: (@player) ->
    @dom()
    @listeners()

  dom: ->
    @$progressBar = $('.music-player progress.progress')
    @$play = $('.music-player .icon-play')
    @$pause = $('.music-player .icon-pause')
    @$ff = $('.music-player .icon-forward')


  # http://www.inwebson.com/html5/custom-html5-video-controls-with-jquery/
  seek: (x) ->
    position = x - @$progressBar.offset().left
    percentage  = 100 * position / @$progressBar.width()

    if (percentage > 100)
      percentage = 100
      @pause()
    if (percentage < 0)
      percentage = 0
    @player.current.currentTime = @player.current.duration * (percentage / 100)
    @updateProgressBar(percentage)

  updateProgressBar: (percentage) ->
    @$progressBar.val(percentage)

  playButton: (status) ->
    switch status
      when "pause"
        @$play.removeClass("hide")
        @$pause.addClass("hide")
      when "play"
        @$pause.removeClass("hide")
        @$play.addClass("hide")

  listeners: ->
    @buttonListener()
    @progressBarListener()

  buttonListener: ->
    @$play.on 'click', =>
      @player.play()
    @$pause.on 'click', =>
      @player.pause()
    @$ff.on 'click', =>
      @player.playNext()

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

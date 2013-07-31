class @UI
  constructor: ->
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

class @Player
  constructor: (@fadeoutTime = 10, @fadeinTime = 2) ->
    @ui = new UI(@)
    @second = 1000
    @fadeingOut = false
    @audio1 = window.audio1 # new Audio()
    @audio2 = window.audio2 # new Audio()

    @current = @audio1
    @current.addEventListener("timeupdate", @timeTrack, false)
    @volume = @current.volume
    @ui.updateVolumeBar(@volume * 100)
    @next = @audio2

  setup: (obj) ->
    if obj.hasOwnProperty("tracklist")
      @tracklist = new Tracklist
      @tracklist.add(new Track(track)) for track in obj.tracklist
      @current.src = @tracklist.current().srcOgg
      @next.src = @tracklist.next().srcOgg

  switchPlayer: ->
    # http://stackoverflow.com/questions/4402287/javascript-remove-event-listener
    @current.removeEventListener("timeupdate", @timeTrack)
    if @current == @audio1
      @current = @audio2
      @next = @audio1
    else
      @current = @audio1
      @next = @audio2
    @current.addEventListener("timeupdate", @timeTrack, false)

  play: ->
    @current.play()
    @ui.playButton("play")

  pause: ->
    @current.pause()
    @ui.playButton("pause")

  seek: (percentage) ->
    @current.currentTime = @current.duration * (percentage / 100)
    @ui.updateProgressBar(percentage)
    if !@shouldFadeout() && @current.duration != @current.currentTime
      @resetFadeout()

  toggleMute: ->
    @current.muted = !@current.muted
    value = if @current.muted then 0 else @current.volume * 100
    @ui.muteButton(@current.muted)
    @ui.updateVolumeBar(value)
    # return true instead of jquery dom element
    true

  setVolume: (percentage) ->
    @current.volume = percentage / 100
    @ui.updateVolumeBar(percentage)

  now: ->
    date = new Date()
    date.getTime() / @second

  shouldFadeout: ->
    @current.duration - @current.currentTime <= @fadeoutTime 

  timeTrack: =>
    percentage = ((@current.currentTime / @current.duration) * 100)
    @ui.updateProgressBar(percentage)
    #console.log("#{@fadeingOut} #{@current.duration - @current.currentTime} <= #{@fadeoutTime}")
    if @shouldFadeout()
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
    @fadeout = setInterval =>
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
      @finishFadeout() if @current.volume == 0 || @current.duration == @current.currentTime
      #console.log "#{@fadeoutStarted} + #{@fadeoutTime} <= #{@now()} + #{@fadeinTime}"
      #console.log("iterator: #{@iterator}")
      #@iterator += 1
    , interval

  resetFadeout: ->
    clearInterval(@fadeout)
    @fadeingOut = false
    @next.pause()
    @next.currentTime = 0
    @current.volume = @volume 
    @current.play()

  finishFadeout: () ->
    clearInterval(@fadeout)
    @fadeingOut = false
    @current.pause()
    @switchPlayer()
    if @tracklist.step()
      @next.src = @tracklist.next().srcOgg
    console.log "current #{@current.src}"
    console.log "next #{@next.src}"
    console.log "Fadeout finished"

jQuery ->
  track1 = new Track({ name: "Nice 1", srcOgg: "/music/egy.ogg" })
  track2 = new Track({ name: "Nice 2", srcOgg: "/music/ketto.ogg" })
  track3 = new Track({ name: "Nice 2", srcOgg: "/music/harom.ogg" })
  window.audio1 = document.getElementsByTagName("audio")[0]
  window.audio2 = document.getElementsByTagName("audio")[1]
  window.player = new Player(5, 2)
  window.player.setup(tracklist: [ track1, track2, track3 ])
  window.player.play()

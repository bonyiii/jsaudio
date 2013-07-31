class @Tracklist
  constructor: (@items = []) ->
    @idx = 0 

  step: ->
    return false if @idx > @items.length
    @idx++

  add: (track) ->
    @items.push(track)

  current: ->
    @items[@idx]

  next: ->
    @items[@idx + 1]

class @Track
  constructor: (obj = {}) ->
    @name = obj.name
    @srcOgg = obj.srcOgg



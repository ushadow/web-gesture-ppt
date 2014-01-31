class HandInputController
  constructor: (@view)->
    @view.onConnect = => @connect()
    @view.onDisconnect = => @disconnect()

  connect: ->
    @view.showInfo 'Connecting'
   
    ws_uri = "ws://#{@view.ws_addr()}"
    @ws = new WebSocket(ws_uri)
    @ws.onopen = => @onSocketOpen()
    @ws.onclose = => @onSocketClose()
    @ws.onerror = (errorMessage) => @onSocketError errorMessage
    @ws.onmessage = (event) => @onMessage event.data

  disconnect: ->
    @ws.close()

  onSocketOpen: ->
    @view.showInfo 'Connected'

  onSocketClose: ->
    @view.showInfo 'Disconnected'

  onSocketError: (errorMessage) ->
    @view.showInfo "WebSocket Error: #{errorMessage}"

  onMessage: (data) ->
    status = "Server: #{data}"
    event = JSON.parse data
    
    if 'gestureEvent' of event
      @handleGestureEvent(event.gestureEvent, event.rightHandPos)
    else if 'speechEvent' of event
      @handleSpeechEvent()
  
  handleGestureEvent: (gestureJson, rightHandPos) ->
    return unless gestureJson.length

    gestureEvent = JSON.parse gestureJson
    switch gestureEvent.eventType
      when 'StopGesture'
        switch gestureEvent.gesture
          when 'SwipeLeft' then Reveal.right()
          when 'SwipeRight' then Reveal.left()
      else
        switch gestureEvent.gesture
          when 'Point' then @view.updateCirclePointer(rightHandPos)
          when 'PalmUp' then @view.updateSquarePointer(rightHandPos)
          when 'Rest' then @view.hidePointers()

  handSpeechEvent: ->




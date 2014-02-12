class HandInputController
  constructor: (@_view)->
    @_view.onConnect = => @connect()
    @_view.onDisconnect = => @disconnect()

  connect: ->
    @_view.showInfo 'Connecting'
   
    wsUri = "ws://#{@_view.wsAddr()}"
    @_ws = new WebSocket(wsUri)
    @_ws.onopen = => @onSocketOpen()
    @_ws.onclose = => @onSocketClose()
    @_ws.onerror = (errorMessage) => @onSocketError errorMessage
    @_ws.onmessage = (event) => @onMessage event.data

  disconnect: ->
    @_ws.close()

  onSocketOpen: ->
    @_view.showInfo 'Connected'

  onSocketClose: ->
    @_view.showInfo 'Disconnected'

  onSocketError: (errorMessage) ->
    @_view.showInfo "WebSocket Error: #{errorMessage}"

  onMessage: (data) ->
    if data?.length
      event = JSON.parse data
      
      if 'gesture' of event
        @_onGestureEvent(event)
      else if 'speechEvent' of event
        @_onSpeechEvent(event.speechEvent)
  
  _onGestureEvent: (ge) ->
    switch ge.eventType
      when 'StartPostStroke'
        switch ge.gesture
          when 'SwipeLeft' then Reveal.right()
          when 'SwipeRight' then Reveal.left()
          when 'Circle' then Reveal.toggleOverview()
          when 'ShakeHand' then Reveal.togglePause()
      else
        switch ge.gesture
          when 'Point' then @_view.updateCirclePointer(ge.rightX, ge.rightY)
          when 'PalmUp' then @_view.updateSquarePointer(ge.rightX, ge.rightY)
          when 'Rest' then @_view.reset()

  _onSpeechEvent: (speechText) ->
    switch speechText
      when 'MORE'
        @_view.onMore()


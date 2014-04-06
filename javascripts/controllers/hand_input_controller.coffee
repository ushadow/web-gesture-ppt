class HandInputController
  constructor: (@_view)->
    @_view.onConnect = => @_connect()
    @_view.onDisconnect = => @_disconnect()
    @_currentGesture = ''

  _connect: ->
    @_view.showInfo 'Connecting'
   
    wsUri = "ws://#{@_view.wsAddr()}"
    @_ws = new WebSocket(wsUri)
    @_ws.onopen = => @_onSocketOpen()
    @_ws.onclose = => @_onSocketClose()
    @_ws.onerror = (errorMessage) => @_onSocketError errorMessage
    @_ws.onmessage = (event) => @_onMessage event.data

  _disconnect: ->
    @_ws.close()

  _onSocketOpen: ->
    @_view.showInfo 'Connected'

  _onSocketClose: ->
    @_view.showInfo 'Disconnected'

  _onSocketError: (errorMessage) ->
    @_view.showInfo "WebSocket Error: #{errorMessage}"

  _onMessage: (data) ->
    if data?.length
      event = JSON.parse data
      
      if 'gesture' of event
        @_onGestureEvent(event)
      else if 'speech' of event
        @_onSpeechEvent(event.speech)
  
  _onGestureEvent: (ge) ->
    switch ge.eventType
      when 'StartPostStroke'
        switch ge.gesture
          when 'Swipe_Left' then Reveal.right()
          when 'Swipe_Right' then Reveal.left()
          when 'Circle' then Reveal.toggleOverview()
          when 'Horizontal_Wave' then Reveal.togglePause()
      else
        switch ge.gesture
          when 'Point' then @_view.updateCirclePointer(ge.rightX, ge.rightY)
          when 'Palm_Up' then @_view.updateSquarePointer(ge.rightX, ge.rightY)
          when 'Rest' then @_view.reset()

    @_currentGesture = ge.gesture

  _onSpeechEvent: (speechText) ->
    switch speechText
      when 'MORE'
        @_view.onMore() if @_currentGesture is 'PalmUp'
      when 'LESS'
        @_view.onLess() if @_currentGesture is 'PalmUp'
      when 'SHOW'
        @_view.onShowSlide() if @_currentGesture is 'Point'


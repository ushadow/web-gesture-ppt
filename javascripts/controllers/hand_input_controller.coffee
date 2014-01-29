class TestController
  constructor: (@view)->
    view.onConnect = => @connect()
    view.onDisconnect = => @disconnect()

    @pointer = document.createElement('div')
    @pointer.id = 'pointer'
    @pointer.style.position = 'absolute'
    @pointer.style.visibility = 'hidden'
    @pointer.style.zIndex = 50
    @pointer.style.opacity = 0.7
    @pointer.style.backgroundColor = '#00aaff'
    @pointer.style.width = '30px'
    @pointer.style.height = '30px'
    @pointer.style.top = '100px'
    @pointer.style.left = '100px'

    body = document.body
    body.appendChild(@pointer)

    revealDiv = $('.reveal')
    @presentationWidth = revealDiv.width()
    @presentationHeight = revealDiv.height()

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
    gestureJson = event.gestureEvent
    return unless gestureJson.length

    gestureEvent = JSON.parse gestureJson
    switch gestureEvent.eventType
      when 'StopGesture'
        switch gestureEvent.gesture
          when 'SwipeLeft' then Reveal.right()
          when 'SwipeRight' then Reveal.left()
      else
        switch gestureEvent.gesture
          when 'Point' then @updatePointer(event.rightHandPos)
          when 'Rest' then @pointer.style.visibility = 'hidden'

  updatePointer: (pos) ->
    @pointer.style.left = pos.x * @presentationWidth / 640 + 'px'
    @pointer.style.top = pos.y * @presentationHeight / 480 + 'px'
    @pointer.style.visibility = 'visible'


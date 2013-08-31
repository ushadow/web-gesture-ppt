class TestController
  constructor: (@view, @ws_uri)->
    view.onConnect = => @connect()
    view.onDisconnect = => @disconnect()
    @hand = {x: 0, y: 0}

    draw = => @view.drawRect @hand.x, @hand.y
    setInterval draw, 100

  connect: ->
    @view.showInfo 'Connecting'

    @ws = new WebSocket(@ws_uri)
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
    dataArray = data.split ','
    status = "Server: #{data}"
    json = JSON.parse data
    @hand.x = parseInt(json.RightHand.X)
    @hand.y = parseInt(json.RightHand.Y)
    @view.showInfo status

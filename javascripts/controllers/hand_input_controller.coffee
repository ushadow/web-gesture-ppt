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
    console.log 'Connected'
    @view.showInfo 'Connected'

  onSocketClose: ->
    @view.showInfo 'Disconnected'

  onSocketError: (errorMessage) ->
    @view.showInfo "WebSocket Error: #{errorMessage}"

  onMessage: (data) ->
    dataArray = data.split ','
    status = "Server: #{data}"
    json = JSON.parse data
    if json[0].posDisplay?
      @hand.x = parseInt(json[0].posDisplay.x)
      @hand.y = parseInt(json[0].posDisplay.y)
    @view.showInfo status

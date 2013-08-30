class HandInputView
  constructor: ->
    @rectWidth = 30

    @onConnect = ->
    @onDisconnect = ->

    @$status = $('#status')
    @$button = $('button')
    @$button.click => @onButtonClick()
    @canvas = document.getElementById 'canvas'
    @canvas.width = window.innerWidth - @canvas.offsetLeft * 2
    @canvas.height = window.innerHeight - @canvas.offsetTop
    @canvasHeight = @canvas.clientHeight
    @canvasWidth = @canvas.clientWidth

  showInfo: (message) ->
    @$status.text message
    switch message
      when 'Connected'
        @$button.html 'Disconnect'
      when 'Disconnected'
        @$button.html 'Connect'

  # Draws a rectangle with top left corner at (x, y).
  #
  # @param {int} x screen coordinate where top left is the origin.
  # @param {int} y screen coordinate where top left is the origin.
  drawRect: (x, y) ->
    context = @canvas.getContext '2d'
    context.clearRect 0, 0, @canvasWidth, @canvasHeight
    context.fillStyle = '#ff0000'
    [canvasX, canvasY] = @screenToCanvasCoord x, y
    context.fillRect canvasX, canvasY, @rectWidth, @rectWidth

  onButtonClick: ->
    if @$button.html() is 'Connect'
      @onConnect()
    else
      @onDisconnect()

  # Converts screen coordinate to canvas coordinate.
  #
  # @param {int} x screen coordinate where top left is the origin.
  # @param {int} y screen coordinate where top left is the origin.
  screenToCanvasCoord: (x, y) ->
    # window.screenX and window.screenY are the position of the browser window
    # on the screen.
    canvasX = x - window.screenX - (window.outerWidth - window.innerWidth) -
      @canvas.offsetLeft
    canvasY = y - window.screenY - (window.outerHeight - window.innerHeight) -
      @canvas.offsetTop
    [canvasX, canvasY]

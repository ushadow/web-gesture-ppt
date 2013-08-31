class HandInputView
  constructor: ->
    @rectWidth = 30
    @defaultWidth = 640
    @defaultHeight = 480

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
    [canvasX, canvasY] = @toCanvasCoord x, y
    context.fillRect canvasX, canvasY, @rectWidth, @rectWidth

  onButtonClick: ->
    if @$button.html() is 'Connect'
      @onConnect()
    else
      @onDisconnect()

  # Converts default coordinate to canvas coordinate.
  #
  # @param {int} x cordinate in a 640 X 480 image.
  # @param {int} y screen coordinate where top left is the origin.
  toCanvasCoord: (x, y) ->
    # window.screenX and window.screenY are the position of the browser window
    # on the screen.
    canvasX = x * @canvas.width / @defaultWidth
    canvasY = y * @canvas.height / @defaultHeight
    [canvasX, canvasY]

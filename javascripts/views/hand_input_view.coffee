class HandInputView
  constructor: ->
    @rectWidth = 30
    @defaultWidth = 640
    @defaultHeight = 480

    @onConnect = ->
    @onDisconnect = ->

    @$status = $('#status-text')
    @$button = $('button')
    @$button.click => @onButtonClick()

    @createSquarePointer()
    @createCirclePointer()

    revealDiv = $('.reveal')
    @presentationWidth = revealDiv.width()
    @presentationHeight = revealDiv.height()

  ws_addr: ->
    $('#ws-addr').attr('value')

  showInfo: (message) ->
    @$status.text message
    switch message
      when 'Connected'
        @$button.html 'Disconnect'
      when 'Disconnected'
        @$button.html 'Connect'

  # Update the canvas to visualize the new hand event.
  #
  # @param {int} x screen coordinate where top left is the origin.
  # @param {int} y screen coordinate where top left is the origin.
  update: (handEvent) ->
    return unless handEvent?
    context = @canvas.getContext '2d'
    context.clearRect 0, 0, @canvasWidth, @canvasHeight
    rightX = parseInt handEvent.RightHand.X
    rightY = parseInt handEvent.RightHand.Y
    @drawHand context, rightX, rightY, '#ff0000'

    leftX = parseInt handEvent.LeftHand.X
    leftY = parseInt handEvent.LeftHand.Y
    @drawHand context, leftX, leftY, '#00ff00'

  drawHand: (context, x, y, color) ->
    context.fillStyle = color
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
    
  createSquarePointer: ->
    @square = document.createElement('div')
    @square.id = 'square-pointer'
    @square.className = 'pointer'
    document.body.appendChild(@square)
    
    @squareX = -1
    @squareY = -1

  createCirclePointer: ->
    @circle = document.createElement('div')
    @circle.id = 'circle-pointer'
    @circle.className = 'pointer'

    document.body.appendChild(@circle)

  updateSquarePointer: (pos) ->
    x = pos.x * @presentationWidth / 640
    y = pos.y * @presentationHeight / 480
    @updatePointer @square, x, y
    if @squareX >= 0
      @videoSeek (x - @squareX)
    @squareX = x
    @squareY = y

    @hide @circle

  # Hides an element.
  hide: (e) ->
    e.style.visibility = 'hidden'

  updateCirclePointer: (pos) ->
    x = pos.x * @presentationWidth / 640
    y = pos.y * @presentationHeight / 480
    @updatePointer @circle, x, y
    @hide @square

  updatePointer: (pointer, x, y) ->
    pointer.style.left = x + 'px'
    pointer.style.top = y + 'px'
    pointer.style.visibility = 'visible'

  hidePointers: ->
    @hide @square
    @hide @circle

  videoSeek: (pixelStep) ->
    unless @video?
      slide = Reveal.getCurrentSlide()
      @video = slide.querySelector('video')
   
    unless @video?
      return

    videoWidth = @video.width
    timeStep = pixelStep * @video.duration / videoWidth
    @video.currentTime += timeStep


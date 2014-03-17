class HandInputView
  @_USER_WIDTH: 1 # m 

  constructor: ->
    @onConnect = ->
    @onDisconnect = ->

    @$status = $('#status-text')
    @$button = $('button')
    @$button.click => @_onButtonClick()

    @_createSquarePointer()
    @_createCirclePointer()

    revealDiv = $('.reveal')
    @_viewWidth = revealDiv.width()
    @_viewHeight = revealDiv.height()
   
    @_multiplier = 1

  wsAddr: ->
    $('#ws-addr').attr('value')

  showInfo: (message) ->
    @$status.text message
    switch message
      when 'Connected'
        @$button.html 'Disconnect'
      when 'Disconnected'
        @$button.html 'Connect'

  updateSquarePointer: (x, y) ->
    x = @_viewWidth / 2 + x * @_viewWidth / HandInputView._USER_WIDTH
    y = @_viewHeight / 2 - y * @_viewHeight / HandInputView._USER_WIDTH
    @_updatePointer @_square, x, y
    if @_squareX >= 0
      @_videoSeek (x - @_squareX)
    @_squareX = x
    @_squareY = y

    @_hide @_circle

  ###
  # @param {pos} x, y positions relative to the shoulder in world coordinate. 
  ###
  updateCirclePointer: (x, y) ->
    x = @_viewWidth / 2 + x * @_viewWidth / HandInputView._USER_WIDTH
    y = @_viewHeight / 2 - y * @_viewHeight / HandInputView._USER_WIDTH
    @_updatePointer @_circle, x, y
    @_hide @_square

  reset: ->
    @_hide @_square
    @_hide @_circle
    @_multiplier = 1

  onMore: ->
    @_multiplier *= 2

  _onButtonClick: ->
    if @$button.html() is 'Connect'
      @onConnect()
    else
      @onDisconnect()

  _createSquarePointer: ->
    @_square = document.createElement('div')
    @_square.id = 'square-pointer'
    @_square.className = 'pointer'
    document.body.appendChild(@_square)
    
    @_squareX = -1
    @_squareY = -1

  _createCirclePointer: ->
    @_circle = document.createElement('div')
    @_circle.id = 'circle-pointer'
    @_circle.className = 'pointer'

    document.body.appendChild(@_circle)

  # Hides an element.
  _hide: (e) ->
    e.style.visibility = 'hidden'

  _updatePointer: (pointer, x, y) ->
    pointer.style.left = x + 'px'
    pointer.style.top = y + 'px'
    pointer.style.visibility = 'visible'

  _videoSeek: (pixelStep) ->
    unless @video?
      slide = Reveal.getCurrentSlide()
      @video = slide.querySelector('video')
   
    unless @video?
      return

    videoWidth = @video.width
    timeStep = pixelStep * @video.duration * @_multiplier / videoWidth
    @video.currentTime += timeStep

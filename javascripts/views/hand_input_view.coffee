# Actions directly related to view manipulation.
class HandInputView
  # Bigger means slower pointer. 
  @_POINTER_TOLERANCE: 500 # mm
  # Offset from the shoulder center in mm.
  @_USER_OFFSET_X: 100

  constructor: ->
    @onConnect = ->
    @onDisconnect = ->

    @$status = $('#status-text')
    @$button = $('button')
    @$button.click => @_onConnectButtonClick()

    @_createSquarePointer()
    @_createCirclePointer()

    revealDiv = $('.reveal')
    @_viewWidth = revealDiv.width()
    @_viewHeight = revealDiv.height()
   
    @_multiplier = 1
    @_entered = false
    
    document.addEventListener('keydown', @_onDocumentKeyDown, false)

  wsAddr: ->
    $('#ws-addr').attr('value')

  showInfo: (message) ->
    @$status.text message
    switch message
      when 'Connected'
        @$button.html 'Disconnect'
      when 'Disconnected'
        @$button.html 'Connect'

  ###
  # @param {mirror} true if the user faces the display.
  ###
  updateSquarePointer: (x, y, mirror, autoCenter) ->
    [x, y] = @_centerPosition x, y, autoCenter
    factor = if mirror then 1 else -1
    x = @_viewWidth / 2 +
        x * @_viewWidth * factor / HandInputView._POINTER_TOLERANCE
    y = @_viewHeight / 2 - y * @_viewHeight / HandInputView._POINTER_TOLERANCE
    @_updatePointer @_square, x, y
    if @_squareX >= 0 && Math.abs(x - @_squareX) > Math.abs(y - @_squareY)
      @_videoSeek(x - @_squareX)
    @_squareX = x
    @_squareY = y

    @_hide @_circle

  ###
  # @param {x} x position relative to the shoulder center in world 
  #     coordinate. 
  ###
  updateCirclePointer: (x, y, mirror, autoCenter) ->
    [x, y] = @_centerPosition x, y, autoCenter
    factor = if mirror then 1 else -1
    x = @_viewWidth / 2 +
        x * @_viewWidth * factor / HandInputView._POINTER_TOLERANCE
    y = @_viewHeight / 2 - y * @_viewHeight / HandInputView._POINTER_TOLERANCE
    @_updatePointer @_circle, x, y
    @_hide @_square

  reset: ->
    @_hideMultiplier()
    @_hide @_square
    @_hide @_circle
    @_multiplier = 1
    @_entered = false
    @_squareX = -1
    @_squareY = -1

  onMore: ->
    @_multiplier *= 2

  onLess: ->
    @_multiplier /= 2

  onShowSlide: ->
    rect = @_circle.getBoundingClientRect()
    elem = document.elementFromPoint(rect.left, rect.top)
    regex = /section/gi
    elem = @_upToElement elem, regex
    console.log elem
    if elem and elem.nodeName.match regex
        h = parseInt(elem.getAttribute('data-index-h'), 10)
        v = parseInt(elem.getAttribute('data-index-v'), 10)
        Reveal.slide(h, v)
        if Reveal.isOverview
          Reveal.toggleOverview()

  _centerPosition: (x, y, autoCenter) ->
    if autoCenter
      unless @_entered
        @_entered = true
        @_enteredX = x
        @_enteredY = y
      x -= @_enteredX
      y -= @_enteredY
    else
      x += HandInputView._USER_OFFSET_X
    [x, y]

  _onConnectButtonClick: ->
    if @$button.html() is 'Connect'
      @onConnect()
    else
      @onDisconnect()
  
  _onDocumentKeyDown: (event) =>
    switch event.keyCode
      when 67 then @_onConnectButtonClick()

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
    slide = Reveal.getCurrentSlide()
    video = slide.querySelector('video')
   
    unless video?
      return

    @_showMultiplier video.parentNode
    videoWidth = video.width
    timeStep = pixelStep * video.duration * @_multiplier / videoWidth
    video.currentTime += timeStep
    if video.paused then video.play()

  _showMultiplier: (parent) ->
    node = parent.querySelector('#multiplier')
    unless node?
      node = document.createElement('p')
      node.id = 'multiplier'
      parent.appendChild(node)

    node.innerHTML = "X #{@_multiplier}"
    node.style.visibility = 'visible'

  _hideMultiplier: ->
    slide = Reveal.getCurrentSlide()
    node = slide.querySelector('#multiplier')
    if node?
      node.style.visibility = 'hidden'

  _upToElement: (el, tagNameRegex) ->
    while el && !el.nodeName.match(tagNameRegex)
      el = el.parentNode

    el

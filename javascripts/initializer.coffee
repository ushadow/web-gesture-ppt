# Sets up everything when the document loads.
$ ->
  view = new HandInputView()
  controller = new TestController view, 'ws://127.0.0.1:8080'

  # Debugging convenience.
  window.controller = controller

# Sets up everything when the document loads.
$ ->
  view = new HandInputView()
  controller = new TestController view

  # Debugging convenience.
  window.controller = controller

# Sets up everything when the document loads.
$ ->
  view = new HandInputView()
  controller = new HandInputController view

  # Debugging convenience.
  window.controller = controller

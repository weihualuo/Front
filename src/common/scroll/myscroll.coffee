
angular.module( 'myscroll', [])
.directive('ihscroll', ($document)->  (scope, el, attr)->
  y = 0
  moving = no
  offset = 0
  startY = 0
  margin = Number(attr.imargin) or 40
  startPull = 5
  THRESHOLD = 2
  viewHeight = el.parent()[0].offsetHeight
  if attr.ipull?
    viewHeight -= el[0].offsetTop
    pull = el.children()[0]
    offset = -pull.offsetHeight

  # function from angular touch
  `function getCoordinates(event) {
    var touches = event.touches && event.touches.length ? event.touches : [event];
    var e = (event.changedTouches && event.changedTouches[0]) ||
        (event.originalEvent && event.originalEvent.changedTouches &&
            event.originalEvent.changedTouches[0]) ||
        touches[0].originalEvent || touches[0];

    return {
      x: e.clientX,
      y: e.clientY
    }
  }
  `
  # backticks end

  scope.$watch 'pullStatus', (newValue, oldValue)->
    if newValue is 0 and oldValue is 2

      y = offset
      el.css {"-webkit-transform": "translate3d(0, #{y}px, 0)"}
      console.log "refesh finished"

  el.on 'touchstart mousedown', (e)->
#    e.preventDefault()
    startY = getCoordinates(e).y - y
    el.on 'touchmove mousemove', onMove
    console.log "touchstart", y

  onMove = (e)->

    pos = getCoordinates(e).y - startY
    if Math.abs(pos - y)< THRESHOLD then return

    e.preventDefault()
    if !moving
      moving = yes
      el.css {"-webkit-transition": "none"}
      el.on 'touchend mouseup', onMoveEnd

    y = pos
    # margin >= y >= viewHeight-el[0].offsetHeight-margin
    #             >= offset-margin
    if y > margin then y = margin
    else if el[0].offsetHeight > viewHeight
      if y < viewHeight-el[0].offsetHeight-margin  then y = viewHeight-el[0].offsetHeight-margin
      # else y = y
    else if y < offset-margin then y = offset-margin
    # else y = y

    if pull
      if scope.pullStatus is 0 and y > startPull
        scope.pullStatus  = 1
        scope.$apply()
      else if scope.pullStatus is 1 and y < startPull
        scope.pullStatus  = 0
        scope.$apply()

    el.css {"-webkit-transform": "translate3d(0, #{y}px, 0)"}
    console.log "move ", y

  onMoveEnd = (e)->
    el.off 'touchmove mousemove', onMove
    el.off 'touchend mouseup', onMoveEnd
    if !moving then return
    e.preventDefault()
    moving = no
    el.css {"-webkit-transition": "all 0.3s ease-in"}

    if pull and scope.pullStatus is 1
      scope.pullStatus = 2
      scope.$apply()

#    set y to valid values
#    y = y
#    y = 0
#    y = offset
    if y > offset
      if scope.pullStatus is 2 then y = 0
      else y = offset
    else if el[0].offsetHeight > viewHeight
      if y < viewHeight-el[0].offsetHeight then y = viewHeight-el[0].offsetHeight
      # else y = y
    else if y < offset
      if scope.pullStatus is 2 then y = 0
      else y = offset

    el.css {"-webkit-transform": "translate3d(0, #{y}px, 0)"}
    console.log "moveend"

#  el.css background:'gray'

  )
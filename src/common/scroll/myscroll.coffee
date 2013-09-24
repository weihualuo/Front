
angular.module( 'myscroll', [])
.directive('hscroll', ($document)->  (scope, el, attr)->
  y = 0
  offset = 0
  startY = 0
  margin = 20
  startPull = 5
  console.log "hscroll"
  viewHeight = el.parent()[0].offsetHeight - el[0].offsetTop
  console.log "viewHeight", viewHeight
  pull = el.children()[0]
  if pull.classList.contains('pull')
    offset = -pull.offsetHeight
    scope.$watch 'pullStatus', (newValue, oldValue)->
      if newValue is 0 and oldValue is 2
        y = offset
        el.css {"-webkit-transform": "translate3d(0, #{y}px, 0)"}
        console.log "refesh finished"
  else pull = null

  #from angular touch
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

  el.on 'touchstart mousedown', (e)->
    e.preventDefault()
    startY = getCoordinates(e).y - y
    el.css {"-webkit-transition": "none"}
    $document.on 'touchmove mousemove', onMove
    $document.on 'touchend mouseup', onMoveEnd
    #console.log "touchstart", y

  onMove = (e)->
    y = getCoordinates(e).y - startY
    if y > margin then y = margin
    if el[0].offsetHeight + margin > viewHeight
      if y < viewHeight-el[0].offsetHeight-margin  then y = viewHeight-el[0].offsetHeight-margin
    else
      if y < offset-margin then y = offset-margin

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

    el.css {"-webkit-transition": "all 0.3s ease-in"}

    if pull
      if scope.pullStatus is 1
        scope.pullStatus = 2
        scope.$apply()
#    y = y
#    y = 0
#    y = offset
    if y > offset
      if scope.pullStatus is 2 then y = 0
      else y = offset
    else if el[0].offsetHeight + margin > viewHeight
      if y < viewHeight-el[0].offsetHeight then y = viewHeight-el[0].offsetHeight
      # else y = y
    else if y < offset
      if scope.pullStatus is 2 then y = 0
      else y = offset

    el.css {"-webkit-transform": "translate3d(0, #{y}px, 0)"}
    $document.off 'touchmove mousemove', onMove
    $document.off 'touchend mouseup', onMoveEnd
    console.log "moveend", e

#  el.css background:'gray'

  )
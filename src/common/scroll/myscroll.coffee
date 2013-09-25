
angular.module( 'myscroll', ['ngTouch'])

  .directive('iautoHeight', -> (scope, el)->
    height = document.height - el[0].offsetTop - 5
    el.css height:height+'px'
  )

  .directive('ihshift', ($swipe)-> (scope, el, attr)->

    cards = el.children()
    style = position:"absolute", width:"100%", height:"100%"
    margin = Number(attr.imargin) or 0
    isel = attr.isel or "card"
    width = el[0].offsetWidth
    offset = 0
    startX = 0
    x = 0
    el.css height:"100%"
    for card in cards
      card.style['-webkit-transform'] = "translate3d(#{offset}px, 0, 0)"
      angular.extend card.style, style
      offset += width

    $swipe.bind el,
      'start': (coords)->
        startX = coords.x - x
        el.css {"-webkit-transition": "none"}
        console.log 'start'

      'cancel': (coords)-> console.log 'cancel'

      'move': (coords)->
        x = coords.x - startX
        if x > margin then x = margin
        else if x < width - offset - margin then  x = width - offset - margin
        el.css "-webkit-transform": "translate3d(#{x}px, 0, 0)"
        console.log 'move', x

      'end': (coords)->
        card = scope[isel]
        scope[isel] = - Math.round x/width
        if card isnt scope[isel] then scope.$apply()
        else
          x = width * Math.round(x/width)
          el.css {"-webkit-transition": "all 0.3s ease-in"}
          el.css "-webkit-transform": "translate3d(#{x}px, 0, 0)"
        console.log 'end'

    scope.$watch isel, (newValue, oldValue)->
      x = -newValue * width
      if newValue isnt oldValue
        el.css {"-webkit-transition": "all 0.5s ease-in"}
      el.css "-webkit-transform": "translate3d(#{x}px, 0, 0)"
  )

.directive('ivscroll', ()->  (scope, el, attr)->
  y = 0
  moving = no
  offset = 0
  startY = 0
  margin = Number(attr.imargin) or 0
  startPull = 5
  THRESHOLD = 2
  viewHeight = el.parent()[0].offsetHeight - el[0].offsetTop
  pull = attr.ipull
  if pull
    offset = -el.children()[0].offsetHeight

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

  scope.$watch pull, (newValue, oldValue)->
    if newValue is 0 and oldValue is 2
      y = offset
      el.css {"-webkit-transform": "translate3d(0, #{y}px, 0)"}
      console.log "refesh finished"

  el.on 'touchstart mousedown', (e)->
#    e.preventDefault()
    startY = getCoordinates(e).y - y
    el.on 'touchmove mousemove', onMove
    el.on 'touchend mouseup', onMoveEnd
    console.log "touchstart", y

  onMove = (e)->

    e.preventDefault()
    pos = getCoordinates(e).y - startY
    if Math.abs(pos - y)< THRESHOLD then return

    if !moving
      moving = yes
      el.css {"-webkit-transition": "none"}

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
      if scope[pull] is 0 and y > startPull
        scope[pull]  = 1
        scope.$apply()
      else if scope[pull] is 1 and y < startPull
        scope[pull]  = 0
        scope.$apply()

    el.css {"-webkit-transform": "translate3d(0, #{y}px, 0)"}
    console.log "move ", y, viewHeight, el[0].offsetHeight

  onMoveEnd = (e)->
    el.off 'touchmove mousemove', onMove
    el.off 'touchend mouseup', onMoveEnd
    console.log "moveend"
    if !moving then return
    e.preventDefault()
    moving = no
    el.css {"-webkit-transition": "all 0.3s ease-in"}

    if pull and scope[pull] is 1
      scope[pull] = 2
      scope.$apply()

#    set y to valid values
#    y = y
#    y = 0
#    y = offset
    if y > offset
      if scope[pull] is 2 then y = 0
      else y = offset
    else if el[0].offsetHeight > viewHeight
      if y < viewHeight-el[0].offsetHeight then y = viewHeight-el[0].offsetHeight
      # else y = y
    else if y < offset
      if scope[pull] is 2 then y = 0
      else y = offset

    el.css {"-webkit-transform": "translate3d(0, #{y}px, 0)"}



#  el.css background:'gray'

  )
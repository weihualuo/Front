
angular.module( 'myscroll', ['ngTouch'])

  .directive('ifillBottom', -> (scope, el, attr)->

    dataid = 'ifillbottom'
    type = attr.ifillBottom
    margin = Number(attr.ifillMargin) or 0

    if type is "nested"
      data = el.data(dataid) or []
      data.push([el,margin])
      angular.element(el[0].offsetParent).data(dataid, data)
      el.data dataid, null
      return

    fill = (el, m) ->
      height = el[0].offsetParent.offsetHeight - el[0].offsetTop - m
      el.css height:height+'px'
      console.log "set Height ", height

    fill el, margin

    if type is 'recursive'
      data = el.data(dataid) or []
      fill(pair[0], pair[1]) while (pair = data.pop())
      el.data dataid, null
  )

  .directive('ifillLeft', -> (scope, el, attr)->
    margin = Number(attr.ifillLeft) or 0
    height = el[0].nextElementSibling.offsetHeight
    width = el[0].nextElementSibling.offsetLeft - margin
    el.css width:width+'px', height:height+'px', boxSizing:"border-box"
  )

  .directive('iposMiddle', -> (scope, el, attr)->
    parent = el[0].offsetParent or el[0].parentElement or document.children[0]
    top = (parent.offsetHeight - el[0].offsetHeight)/2
    left = (parent.offsetWidth - el[0].offsetWidth)/2
    el.css top:top+'px', left:left+'px'
  )

  .directive('ihshift', ($swipe)-> (scope, el, attr)->

    cards = el.children()
    margin = Number(attr.ihshiftMargin) or 0
    isel = attr.ihshift or ""
    width = el[0].offsetWidth
    offset = 0
    startX = 0
    x = 0
    el.css position:"relative"
    style = position:"absolute", width:"100%", 'min-height':"100%"
    for card in cards
      card.style.left = offset+'px'
      angular.extend card.style, style
      offset += width

    updatePosition = ->
      el.css "-webkit-transform": "translate3d(#{x}px, 0, 0)"
    setAnimate = (prop)->
      el.css "-webkit-transition": prop

    onShiftEnd = ->
      card = scope[isel]
      scope[isel] = - Math.round x/width
      if card isnt scope[isel] then scope.$apply()
      else
        x = width * Math.round x/width
        setAnimate "all 0.3s ease-in"
        updatePosition()

    $swipe.bind el,
      'start': (coords)->
        startX = coords.x - x
        setAnimate "none"
        console.log 'start'

      'cancel': ->
        onShiftEnd()
        console.log 'cancel'

      'move': (coords)->
        x = coords.x - startX
        if x > margin then x = margin
        else if x < width - offset - margin then  x = width - offset - margin
        updatePosition()
        console.log 'move', x

      'end': ->
        onShiftEnd()
        console.log 'end'

    scope.$watch isel, (newValue, oldValue)->
      x = -newValue * width
      if newValue isnt oldValue
        setAnimate "all 0.5s ease-in"
      updatePosition()
  )

  .directive('ivpull', ()->  (scope, el, attr)->
    status = attr.ivpull
    handler = attr.ihandler
    el.parent().data 'ivpull', {el:el, status:status, handler: handler}
  )
  .directive('ivmore', ()->  (scope, el, attr)->
    status = attr.ivmore
    handler = attr.ihandler
    el.parent().data 'ivmore', {el:el, status:status, handler: handler}
  )

  .directive('ivscroll', ()->  (scope, el, attr)->
    y = 0
    moving = no
    offset = 0
    startY = 0
    margin = Number(attr.imargin) or 0
    startPull = 5
    THRESHOLD = 2
    reset = attr.ivreset

    pullData = el.data 'ivpull'
    moreData = el.data 'ivmore'

    if pullData
      pull = pullData.status
      offset = -el.children()[0].offsetHeight
      refresh = scope[pullData.handler]
      if !angular.isFunction(refresh)
        refresh = angular.noop
      el.data 'ivpull', null

    if moreData
      more = moreData.status
      loadMore = scope[moreData.handler]
      if !angular.isFunction(loadMore)
        loadMore = angular.noop
      moreData.el.on 'click', ->
        if scope[more] isnt 2
          scope[more] = 2
          loadMore -> scope[more] = 0
      el.data 'ivmore', null

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

    getViewHeight = ->  el[0].offsetParent.offsetHeight - el[0].offsetTop

    updatePosition = ->
      el.css "-webkit-transform": "translate3d(0, #{y}px, 0)"
    setAnimate = (prop)->
      el.css "-webkit-transition": prop

    scope.$watch reset, (newValue, oldValue)->
      if newValue isnt oldValue
        y = offset
        updatePosition()
        console.log "iv reset"


    scope.$watch pull, (newValue)->
      if newValue is 2
        refresh ->
          scope[pull] = 0
          scope[more] = 0 if scope[more]

      else if newValue is 0
        y = offset
        updatePosition()

    el.on 'touchstart mousedown', (e)->
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
        setAnimate "none"

      y = pos
      viewHeight = getViewHeight() #el.parent()[0].offsetHeight - el[0].offsetTop
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

      updatePosition()
      console.log "move ", y, viewHeight, el[0].offsetHeight

    onMoveEnd = (e)->
      el.off 'touchmove mousemove', onMove
      el.off 'touchend mouseup', onMoveEnd
      console.log "moveend"
      if !moving then return
      e.preventDefault()
      moving = no
      setAnimate "all 0.3s ease-in"

      if pull and scope[pull] is 1
        scope[pull] = 2
        scope.$apply()

      viewHeight = getViewHeight() #el.parent()[0].offsetHeight - el[0].offsetTop
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
      updatePosition()

    )
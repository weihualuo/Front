
angular.module( 'mywidget', [])

  .directive('ihtabs', ->  (scope, el, attr)->

    x = 0
    isel = attr.ihtabs
    viewWidth = el[0].offsetWidth
    minPadding = Number(el.attr "ihtabs-padding") or 0

    tabs = el.children()
    totalOffset = 1
    totalOffset += tab.offsetWidth for tab in tabs
    margin = viewWidth - totalOffset
    padding = margin/(tabs.length*2)
    padding = minPadding if padding < minPadding
    navsWidth = totalOffset+padding*tabs.length*2

    style = float:"left", paddingLeft:padding+'px', paddingRight: padding+'px'
    angular.extend tab.style, style for tab in tabs

    el.css width: "#{navsWidth}px"
    el.append("<div style='clear: both;'></div>")

    updatePosition = ->
      el.css "-webkit-transform": "translate3d(#{x}px, 0, 0)"
    setAnimate = (prop)->
      el.css "-webkit-transition": prop

    M = (n)->
      m = tabs[n].offsetWidth/2
      m += tabs[n].offsetWidth while n-- > 0
      m
    scope.$watch isel, (n, old)->
      #center the tab if possible
      min = viewWidth - navsWidth
      x = viewWidth/2 - M(n)
      x = 0 if x > 0
      x = min if x < min
      if n isnt old
        setAnimate "all 0.5s ease-in"
      updatePosition()
      console.log n, viewWidth, navsWidth, M(n), x

  )
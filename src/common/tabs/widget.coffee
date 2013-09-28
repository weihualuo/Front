
angular.module( 'mywidget', [])

.directive('ihtabs', ->
  scope: true
  link:  (scope, el, attr)->

    x = 0
    isel = attr.ihtabs
    divs = el.children()
    navs = angular.element(divs[0])
    bar = angular.element(divs[1])
    viewWidth = el[0].offsetWidth
    minPadding = Number(navs.attr "ihtabs-padding") or 0

    tabs = navs.children()
    totalOffset = 1
    totalOffset += tab.offsetWidth for tab in tabs
    margin = viewWidth - totalOffset
    padding = margin/(tabs.length*2)
    padding = minPadding if padding < minPadding
    navsWidth = totalOffset+padding*tabs.length*2

    style = float:"left", paddingLeft:padding+'px', paddingRight: padding+'px'
    angular.extend tab.style, style for tab in tabs

    navs.css width: "#{navsWidth}px"
    navs.append("<div style='clear: both;'></div>")

    updatePosition = ->
      navs.css "-webkit-transform": "translate3d(#{x}px, 0, 0)"
    setAnimate = (prop)->
      navs.css "-webkit-transition": prop

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

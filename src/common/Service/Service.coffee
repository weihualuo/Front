angular.module( 'Service', [])

.factory( 'noRepeat', ($timeout)->
  _objs={}
  (name, time=2000)->
    console.log _objs
    _objs[name] ?= false
    if _objs[name]
      console.log name+' buzy'
      false
    else
      console.log name+' idle'
      $timeout (-> _objs[name] = false; console.log name+' released'), time
      _objs[name] = true
)

.factory 'titleService', ( $document ) ->
  suffix = title = ""

  {
    setSuffix: ( s ) ->
      suffix = s

    getSuffix: () ->
      suffix

    setTitle: ( t ) ->
      if suffix isnt ""
        title = t + suffix
      else
        title = t

      $document.prop 'title', title

    getTitle: () ->
      $document.prop 'title'
  }


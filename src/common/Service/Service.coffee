angular.module( 'Service', [])

.factory( 'noRepeat', ($timeout)->
  _objs={}
  (name, time=2000)->
    _objs[name] ?= false
    if _objs[name]
      false
    else
      $timeout (-> _objs[name] = false), time
      _objs[name] = true
)



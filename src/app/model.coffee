angular.module( 'Model', [])
  .factory('Many', (Restangular)->
    _objs = {}
    Obj = (name, init)->
      @ra = Restangular.all name
      @model =  _.extend objects:[], init
      @cur = null
      @load = (more)->
        objs = @model.objects

        if more or !@model.$d

          if more and objs.length
            if more > 0
              p = last:objs[objs.length-1].id
            else if more < 0
              p = first:objs[0].id

          @model.$d = true
          @ra.getList(p).then (d)=>
            if d.length
              if more > 0
                angular.forEach d, (v)->objs.push v
              else
                angular.forEach d, (v,i)->objs.splice i,0,v
        objs

      @get = (id, force)->
        if !@cur or @cur.id isnt id
          @cur = _.find(@model.objects, id:Number id) or Restangular.one(name, id)
        if !@cur.$d or force
          @cur.$d = true
          @cur.get().then (d)=> _.extend @cur, d
        @cur

      this

    (name, init)->  _objs[name] ?=  new Obj name, init

  )



  .factory('Single', (Restangular)->
    _objs = {}
    Obj = (name, init)->
      @ra = Restangular.one name
      @value = _.extend {}, init
      @get = (force)->
        if !@value.$d or force
          @value.$d = true
          @ra.get().then (d)=>_.extend @value, d
        @value
      this

    (name, init)-> _objs[name] ?=  new Obj name, init

  )



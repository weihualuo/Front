angular.module( 'Model', ['restangular'])

  .config( (RestangularProvider) ->

    RestangularProvider.setBaseUrl '/api/'
#    RestangularProvider.setRequestSuffix '/'
#    RestangularProvider.setResponseExtractor (response, operation, what, url)->
#      if operation is 'getList'
#        res = response.results
#        res.meta= response.meta
#      else
#        res = response
#      res
#    RestangularProvider.addElementTransformer 'events', false, (event) ->
#      event
  )

  .factory('Many', (Restangular)->
    _objs = {}
    Obj = (name, option)->
      @ra = Restangular.all name
      @option =  option
      @objects = []
      @cur = null
      @load = (more, cb)->
        objs = @objects

        if more or !@$d

          if more and objs.length
            if more > 0
              p = last:objs[objs.length-1].id
            else if more < 0
              p = first:objs[0].id

          @$d = true
          @ra.getList(p).then (d)=>
            if d.length
              if more > 0
                angular.forEach d, (v)->objs.push v
              else
                angular.forEach d, (v,i)->objs.splice i,0,v
            if cb then cb d
        objs

      @new = (p, cb)->
        @ra.post(p).then cb

      @get = (id, force, cb)->
        if !@cur or @cur.id isnt id
          @cur = _.find(@objects, id:Number id) or Restangular.one(name, id)
        if !@cur.$d or force
          @cur.$d = true
          @cur.get().then (d)=>
            _.extend @cur, d
            if cb then cb d
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



angular.module( 'app', ['restangular',
                          'templates-app',
                          'templates-common',
                          'app.home',
                          'jqm'
                          'ngMobile'
])
  .config( (RestangularProvider, $routeProvider) ->
    $routeProvider.when( '/',
      controller: 'HomeCtrl'
      templateUrl: 'home/home.tpl.html'
      animation: 'page-slide-reverse'
    )
    .when( '/detail/:id'
      controller: 'DetailCtrl'
      templateUrl: 'detail/detail.tpl.html'
      animation: 'page-slide'
      )
    .otherwise(
      redirectTo: '/'
    )

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

    (name, init)->
      if _objs[name]
        _objs[name]
      else
        _objs[name] = new Obj name, init
  )

  .factory('Model', (Restangular, $location, $timeout)->
    root = Restangular.all('events')
    all = []
    current = null
    Model = {}
    Model.all = -> all

    Model.load = (refresh, cb)->
      if all.length
        if refresh then p = first:all[0].id
        else p = last:all[all.length-1].id

      root.getList(p).then (data)->
        if refresh
          all = data.concat all
        else
          all = all.concat data
        #wait 1 sec to simulate network congestion
        #cb all
        $timeout (->cb all), 1000

    Model.get = (id)->
      #wait 1 sec to simulate network congestion
      #id = id or current.id
      current = (_.find all, id:Number(id)) or {}
      if !current.$d
        #root.one(id).get().then (data)->
        #  cb _.extend current, data, $d:true
        $timeout (->root.one(id).get().then (data)->
          _.extend current, data, $d:true
          ), 1000
      current
    Model
  )

  .factory('Meta', (Restangular,  $timeout)->
    root = Restangular.one('meta')
    meta = {}
    Meta = {}
    Meta.get = ->
      if !meta.$d
        root.get().then (data)->  _.extend meta, data, $d:true
      meta
    Meta
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

    (name, init)->
      if _objs[name]
        _objs[name]
      else
        _objs[name] = new Obj name, init
  )

  .run( ()->
    console.log 'app run'
  )

  .controller('AppCtrl', ($scope, $location, Single) ->
#    $scope.m1 = Single('meta1').get()
#    $scope.m3 = Single('meta1').get()
#    $scope.m2 = Single('meta2', abc:'abcd').get()
#    $scope.$watchCollection 'm1', ->
#      console.log 'watch m1'
#      console.log $scope.m1
#    $scope.$watchCollection 'm2', ->
#      console.log 'watch m2'
#      console.log $scope.m2

    $scope.meta = Single('meta').get()
    appTitle = '集结号'
    $scope.setTitle = (title)-> $scope.title = title or appTitle

    $scope.isLogin = -> Boolean $scope.meta.user
    $scope.loginOrPopup = ->
      if $scope.meta.user
        true
      else
        $scope.popupLogin()
        false

    $scope.popupLogin = ->
      $scope.loginPopupShow = true
      $scope.path = $location.path()

    $scope.onOption = (option)-> $scope.$broadcast option
    $scope.goBack = ->
      console.log "goback"
      $location.path "/"
  )



angular.module( 'app', ['ngRoute', 'templates-app', 'templates-common',
                           'Model', 'app.home', 'ui.bootstrap'
])
  .config( ($routeProvider) ->
    $routeProvider.when( '/',
      controller: 'HomeCtrl'
      templateUrl: 'home/home.tpl.html'
    )
    .when( '/detail/:id'
      controller: 'DetailCtrl'
      templateUrl: 'detail/detail.tpl.html'
      animation: 'page-slide'
    )
    .when( '/edit/:id'
      controller: 'EditCtrl'
      templateUrl: 'edit/edit.tpl.html'
      animation: 'page-slide'
    )
    .otherwise(
      redirectTo: '/'
    )

  )

  .run( ()->
    console.log 'app run'
  )

  .controller('AppCtrl', ($scope, $location, Single, $modal, $log) ->

    popupLogin = ->
      #items = ['item1', 'item2', 'item3']
      $modal.open(
        templateUrl: "modal/login.tpl.html"
        #controller: "ModalInstanceCtrl"
        #resolve: items: -> items
      )
#      .result.then(
#        (ret)->
#          $log.info ret
#        (ret)->
#          $log.info(ret + ' Modal dismissed at: ' + new Date())
#      )
      false

#      $scope.loginPopupShow = true
#      $scope.path = $location.path()


    $scope.meta = Single('meta').get()
    $scope.setTitle = (title)-> $scope.title = title or $scope.appTitle

    $scope.isLogin = -> Boolean $scope.meta.user
    $scope.loginOrPopup = -> Boolean $scope.meta.user or popupLogin()

    $scope.onOption = (option)-> $scope.$broadcast option

    $scope.$on 'new', ->
      if $scope.loginOrPopup() and $location.path().indexOf("/edit/") isnt 0
        $location.path("/edit/0")

    $scope.goBack = ->  history.back()
  )

  .controller('ModalInstanceCtrl', ($scope, $modalInstance, items)->
    $scope.items = items
    $scope.selected = {
      item: $scope.items[0]
    }

    $scope.ok = ->
      $modalInstance.close($scope.selected.item)

    $scope.cancel = ->
      $modalInstance.dismiss('cancel...')
  )



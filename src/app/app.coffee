angular.module( 'app', ['ngRoute', 'templates-app', 'templates-common',
                           'Model', 'app.home',
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

  .controller('AppCtrl', ($scope, $location, Single) ->

    popupLogin = ->
      $scope.loginPopupShow = true
      $scope.path = $location.path()
      false

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



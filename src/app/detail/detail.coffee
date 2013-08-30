angular.module('front.detail', ['ui.state'])

  .config( ($stateProvider) ->
#    $stateProvider.state 'detail' ,
#      url : '/home/:id',
#      views:
#        "main":
#          controller: 'DetailCtrl',
#          templateUrl: 'detail/detail.tpl.html'

  )

  .controller( 'DetailCtrl', ($scope, Events, $routeParams, $timeout) ->
    id = $routeParams.id

    Events.get id, (data)->
      $scope.e = data
      $scope.setTitle(data.title)

#    e = Events.one(id).get()
#    for e in Events.all()
#      break if e.id is id
#    $scope.e = e
#    $scope.$parent.title = 'set title'
  )
  .run(  -> console.log 'detailrun'

  )

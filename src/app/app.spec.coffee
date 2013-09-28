

describe 'app', ->
  $rootScope = null
  $httpBackend = null
  $timeout = null
  Many = null
  Single = null

  beforeEach module 'app'

  beforeEach inject (_$httpBackend_, _Many_, _Single_,_$rootScope_,_$timeout_)->
    Many = _Many_
    Single = _Single_
    $httpBackend = _$httpBackend_
    $rootScope = _$rootScope_
    $timeout = _$timeout_

  xdescribe 'Scope test', ->

    it "should watch", ->
      obj = a:"aa", b:[1,2,3], c:{c1:1}
      scope = $rootScope.$new()
      scope.obj = obj

      deepChange = jasmine.createSpy 'deepChange'
      change = jasmine.createSpy 'change'
      collectChange = jasmine.createSpy 'collectChange'

      scope.$watch 'obj', ((n, o)-> change())
      scope.$watch 'obj', ((n, o)-> deepChange()), true
      scope.$watchCollection 'obj', ((n, o)-> collectChange())

      scope.$digest()
      expect(change).toHaveBeenCalled()
      expect(deepChange).toHaveBeenCalled()
      expect(collectChange).toHaveBeenCalled()

      objcopy = angular.copy scope.obj
      scope.obj = objcopy
      scope.$digest()
      expect(change.calls.length).toEqual(2)         #changed
      expect(collectChange.calls.length).toEqual(2)  #changed
      expect(deepChange.calls.length).toEqual(1)     #unchanged


      scope.obj.b.push 4
      scope.$digest()
      expect(change.calls.length).toEqual(2)          #unchanged
      expect(collectChange.calls.length).toEqual(2)   #unchanged
      expect(deepChange.calls.length).toEqual(2)      #changed

      scope.obj.d = "new"
      scope.$digest()
      expect(change.calls.length).toEqual(2)          #unchanged
      expect(collectChange.calls.length).toEqual(3)   #changed
      expect(deepChange.calls.length).toEqual(3)      #changed

      scope.obj.a = "value changed"
      scope.$digest()
      expect(change.calls.length).toEqual(2)          #unchanged
      expect(collectChange.calls.length).toEqual(4)   #changed
      expect(deepChange.calls.length).toEqual(4)      #changed


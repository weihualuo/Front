
describe 'Model factory', ->

  events = [ {"id": 21,"title": "title21"} , {"id": 22,"title": "title22"}]
  events_new = [ {"id": 11,"title": "title11"} , {"id": 12,"title": "title12"}]
  events_more = [ {"id": 31,"title": "title31"} , {"id": 32,"title": "title32"}]
  item = id:21, title: "title21", desc: "this is detail information"
  item2 = id:22, title: "title22", desc: "this is detail information 2"

  others = [ {"id": 21,"other": "other21"} , {"id": 22,"other": "other22"}]
  others_new = [ {"id": 11,"other": "other11"} , {"id": 12,"other": "other12"}]
  others_more = [ {"id": 31,"other": "other31"} , {"id": 32,"other": "other32"}]

  meta = key: 'value', user: {id:1, name: "my name"}
  meta2 = key2: 'value2', user2: {id:2, name2: "my name2"}

#  // Utils
#  // Apply "sanitizeRestangularOne" function to an array of items
  sanitizeRestangularAll = (items) ->
    all = _.map items, (item)->
      sanitizeRestangularOne(item)
    sanitizeRestangularOne(all)

#  // Remove all Restangular/AngularJS added methods in order to use Jasmine toEqual between the retrieve resource and the model
  sanitizeRestangularOne = (item)->
    _.omit(item, "route", "parentResource", "getList", "get", "post", "put", "remove", "head", "trace", "options", "patch",
      "$then", "$resolved", "restangularCollection", "customOperation", "customGET", "customPOST", "oneUrl", "allUrl",
      "customPUT", "customDELETE", "customGETLIST", "$getList", "$resolved", "restangularCollection", "one", "all","doGET", "doPOST",
      "doPUT", "doDELETE", "doGETLIST", "addRestangularMethod", "getRestangularUrl")

  beforeEach module 'Model'

  beforeEach ->
    this.addMatchers
      toEqualData: (expected)->
        angular.equals(this.actual, expected)

  $rootScope = null
  $httpBackend = null
  $timeout = null
  Many = null
  Single = null

  beforeEach inject (_$httpBackend_, _Many_, _Single_,_$rootScope_,_$timeout_)->
    Many = _Many_
    Single = _Single_
    $httpBackend = _$httpBackend_
    $rootScope = _$rootScope_
    $timeout = _$timeout_


  describe 'Single factory', ->

    it 'should load only once on first visit', ->
      $httpBackend.expectGET('/api/meta').respond meta
      single = Single('meta')
      object = single.get()
      $rootScope.$apply()
      expect(object).toEqualData({})
      $httpBackend.flush()
      expect(object).toEqualData(meta)
      single.get()
      #apply should be used to verify there is no Unexpected request
      $rootScope.$apply()

    it 'should alwayse refresh by force parameter', ->
      $httpBackend.expectGET('/api/meta').respond meta
      single = Single('meta')
      object = single.get()
      $rootScope.$apply()
      $httpBackend.flush()
      expect(object).toEqualData(meta)

      newItem = newkey: "new value"
      $httpBackend.expectGET('/api/meta').respond newItem
      single.get(true)
      $rootScope.$apply()
      $httpBackend.flush()
      expect(object).toEqualData(_.extend(meta, newItem))


    it 'should be able to serve for multiple models with initial value', ->
      $httpBackend.expectGET('/api/meta').respond meta
      $httpBackend.expectGET('/api/meta2').respond meta2

      init1 = initkey: "init value", options: "this is options"
      single1 = Single 'meta', init1
      single2 = Single 'meta2'
      obj1 = single1.get()
      obj2 = single2.get()
      $rootScope.$apply()
      expect(obj1).toEqualData(init1)
      $httpBackend.flush()
      expect(obj1).toEqualData(_.extend(init1, meta))
      expect(obj2).toEqualData(meta2)

  describe 'Many factory', ->


#    afterEach ->
#      $httpBackend.verifyNoOutstandingRequest()
#      $httpBackend.expectGET('/api/events?last=22').respond events_more
#      (method, url, data, headers)->
#        console.log url, data
#        [200, JSON.stringify(events), ""]

    it 'should load only once with initial objects', ->
      $httpBackend.expectGET('/api/events').respond events
      model = Many('events')
      objects = model.load()
      #apply is required since angular 1.1.4
      $rootScope.$apply()
      expect(objects).toEqual([])
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(sanitizeRestangularAll objects).toEqualData sanitizeRestangularAll events
      model.load()
      #apply should be used to verify there is no Unexpected request
      $rootScope.$apply()
      expect(sanitizeRestangularAll objects).toEqualData sanitizeRestangularAll events


    it 'should insert objects before the first', ->
      $httpBackend.expectGET('/api/events').respond events
      model = Many('events')
      #parameter doesn't matter on the first load
      objects = model.load(-10)
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(sanitizeRestangularAll objects).toEqualData sanitizeRestangularAll events

      $httpBackend.expectGET('/api/events?first=21').respond events_new
      model.load(-1)
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(sanitizeRestangularAll objects).toEqualData sanitizeRestangularAll events_new.concat events


    it 'should insert objects after the last', ->
      $httpBackend.expectGET('/api/events').respond events
      model = Many('events')
      #parameter doesn't matter on the first load
      objects = model.load(10)
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(sanitizeRestangularAll objects).toEqualData sanitizeRestangularAll events

      $httpBackend.expectGET('/api/events?last=22').respond events_more
      model.load(1)
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(sanitizeRestangularAll objects).toEqualData sanitizeRestangularAll events.concat events_more

    it 'should fetch item details only on the first visit', ->
      $httpBackend.expectGET('/api/events').respond events
      model = Many('events')
      objects = model.load()
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()

      $httpBackend.expectGET('/api/events/21').respond item
      cur = model.get 21
      expect(cur).toEqual(objects[0])
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(cur).toEqual(objects[0])
      expect(cur).toEqualData(item)

      $httpBackend.expectGET('/api/events/22').respond item2
      cur = model.get 22
      expect(cur).toEqual(objects[1])
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(cur).toEqual(objects[1])
      expect(cur).toEqualData(item2)

      # should get the same object on the later request
      cur1 = model.get 21
      $rootScope.$apply()
      expect(cur1).toEqual(objects[0])
      cur2 = model.get 22
      $rootScope.$apply()
      expect(cur2).toEqual(objects[1])

    it "should be able fetch item details which not in list", inject (Restangular)->
      $httpBackend.expectGET('/api/events/21').respond item
      model = Many('events')
      cur = model.get 21
      $rootScope.$apply()
      expect(cur).toEqualData(Restangular.one('events', 21))

      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(cur).toEqualData(item)

      # should get the same object on the later request
      cur2 = model.get 21
      $rootScope.$apply()
      expect(cur2).toEqual(cur)


    it "should alwayse fetch item details by force", inject (Restangular)->
      $httpBackend.expectGET('/api/events/21').respond item
      model = Many('events')
      cur = model.get 21
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(cur).toEqualData(item)

      extra = extra:"extra value", title: "title new"
      $httpBackend.expectGET('/api/events/21').respond extra
      model.get 21, true
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(cur).toEqualData(_.extend(cur, extra))


    it 'should be able to serve for multiple models at the same time ', ->
      $httpBackend.expectGET('/api/events').respond events
      $httpBackend.expectGET('/api/others').respond others
      model = Many('events')
      other = Many('others')
      objects = model.load()
      other_objects = other.load()
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(sanitizeRestangularAll objects).toEqualData sanitizeRestangularAll events
      expect(sanitizeRestangularAll other_objects).toEqualData sanitizeRestangularAll others
      #no further request
      model.load()
      other.load()
      $rootScope.$apply()

      $httpBackend.expectGET('/api/events?last=22').respond events_more
      model.load(1)
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(sanitizeRestangularAll objects).toEqualData sanitizeRestangularAll events.concat events_more

      $httpBackend.expectGET('/api/others?first=21').respond others_new
      other.load(-1)
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(sanitizeRestangularAll other_objects).toEqualData sanitizeRestangularAll others_new.concat others


    it 'should be able to create a item before load', ->
      p = title:"new item", avenue: "here"
      newId = id:100
      $httpBackend.expectPOST('/api/events').respond (method, url, data, headers)->
        [201, JSON.stringify(_.extend(JSON.parse(data), newId)), ""]

      model = Many('events')
      newItem = null
      model.new p, (d)-> newItem = d
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(sanitizeRestangularOne newItem).toEqualData(_.extend(p, newId))

    it 'should be able to create a item after load', ->
      $httpBackend.expectGET('/api/events').respond events
      model = Many('events')
      objects = model.load()
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()

      p = title:"new item", avenue: "here"
      newId = id:100
      $httpBackend.expectPOST('/api/events').respond (method, url, data, headers)->
        [201, JSON.stringify(_.extend(JSON.parse(data), newId)), ""]

      newItem = null
      model.new p, (d)-> newItem = d
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(sanitizeRestangularOne newItem).toEqualData(_.extend(p, newId))

    it 'should call callback function after load', ->
      $httpBackend.expectGET('/api/events').respond events
      callback = jasmine.createSpy 'callback'
      model = Many('events')
      objects = model.load(-1, callback)
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(callback).toHaveBeenCalled()
      expect(sanitizeRestangularAll callback.mostRecentCall.args[0]).toEqualData sanitizeRestangularAll events

    it "should call callback function after fetch", inject (Restangular)->
      $httpBackend.expectGET('/api/events/21').respond item
      callback = jasmine.createSpy 'callback'
      model = Many('events')
      cur = model.get 21, true, callback
      $rootScope.$apply()
      $httpBackend.flush()
      #test evn
      $timeout.flush()
      expect(callback).toHaveBeenCalled()
      expect(sanitizeRestangularOne callback.mostRecentCall.args[0]).toEqualData sanitizeRestangularOne item


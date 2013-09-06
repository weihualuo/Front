
describe 'noRepeat', ->
  $timeout = null
  noRepeat = null

  beforeEach module 'Service'
#  beforeEach ->  jasmine.Clock.useMock()
  beforeEach inject (_$timeout_, _noRepeat_) ->
    $timeout = _$timeout_
    noRepeat = _noRepeat_

  it 'should be true at first', inject ()->
    expect(noRepeat('first',2000)).toBeTruthy()

  it 'should be false before timeout', inject ()->
    expect(noRepeat('first')).toBeTruthy()
    expect(noRepeat('first')).toBeFalsy()
    expect(noRepeat('first', 1000)).toBeFalsy()
    $timeout.flush()
#    jasmine.Clock.tick(3000)
    expect(noRepeat('first', 3000)).toBeTruthy()
    expect(noRepeat('first', 3000)).toBeFalsy()
    $timeout.flush()
    expect(noRepeat('first', 3000)).toBeTruthy()

  it 'should work for multiple objecs', inject ()->
    expect(noRepeat('first')).toBeTruthy()
    expect(noRepeat('first')).toBeFalsy()
    expect(noRepeat('second')).toBeTruthy()
    expect(noRepeat('second')).toBeFalsy()
    $timeout.flush()
    expect(noRepeat('first')).toBeTruthy()
    expect(noRepeat('second')).toBeTruthy()




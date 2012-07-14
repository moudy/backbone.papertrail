describe "Backbone.PaperTrail", ->

  book = null
  edit1 = title:'The next Great American Novel', pages:350
  edit2 = title:'The next Great American Website', price:3
  edit3 = title:'The next Great American JS library', author:'Uncle Sam', price:4

  beforeEach ->
    book = new Backbone.PaperTrail(edit1)


  describe "restoring to original state", ->
    it "should restore to it's original state", ->
      book.store().set(edit2)
      book.store().set(edit3)
      book.restore()
      expect(book.attributes).toEqual(edit1)

    it "should have on effect if there are no previous edits", ->
      book.restore()
      expect(book.attributes).toEqual(edit1)


  describe "rolling back to previous state(s)", ->
    it "should rollback to it's prevois state", ->
      book.store().set(edit2)
      book.store().set(edit3)
      book.rollback()
      edit1And2 = _.extend({}, edit1, edit2)
      expect(book.attributes).toEqual(edit1And2)

    it "should rollback multiple times", ->
      book.store().set(edit2)
      book.store().set(edit3)
      book.rollback(2)
      expect(book.attributes).toEqual(edit1)

    it "should rollback to first possible state if distance excedes available states", ->
      book.store().set(edit2)
      book.store().set(edit3)
      book.rollback(9)
      expect(book.attributes).toEqual(edit1)


  describe "edits", ->
    it "should keep the eidts array updated to reflect number of edits", ->
      book.store().set(edit2)
      book.store().set(edit3)
      expect(book.edits().length).toBe(2)
      book.rollback()
      expect(book.edits().length).toBe(1)

    it "should return false is it hasn't been edited", ->
      expect(book.wasEdited()).toBe(false)

    it "should return true if it has been edited", ->
      book.store().set(edit2)
      expect(book.wasEdited()).toBe(true)


  describe "retrieving prior attributes", ->
    it "should give you the previous attributes", ->
      book.store().set(edit2)
      expect(book.priorAttributes()).toEqual(edit1)

    it "should give you the previous attributes multiple steps back", ->
      book.store().set(edit2)
      book.store().set(edit3)
      expect(book.priorAttributes(distance:2)).toEqual(edit1)

    it "should be falsy if no previous attributes", ->
      expect(book.priorAttributes()).toBeFalsy()

    it "should return a specified prior attribute", ->
      book.store().set(edit2)
      book.store().set(edit3)
      expect(book.prior('title')).toBe(edit2.title)

    it "should return a specified prior attribute multiple levels back", ->
      book.store().set(edit2)
      book.store().set(edit3)
      expect(book.prior('title', distance:2)).toBe(edit1.title)

    it "should be falsy when no prior attribute", ->
      book.store().set(edit2)
      expect(book.prior('price')).toBeFalsy()




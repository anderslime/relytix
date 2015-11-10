import testView from "./test_view"
import eventView from "./event_view"

var App = {
  test: testView,
  event: eventView
};

if (window.onAppLoad !== undefined) {
  window.onAppLoad.call(this, App);
}

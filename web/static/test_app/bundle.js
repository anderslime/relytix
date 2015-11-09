import tracker from "./tracking"

window.ahoy = {
  visitsUrl: "/api/visits",
  eventsUrl: "/api/events"
};

let trackerClient = tracker(window);

$(document).ready(() => {
  $("#custom-event").submit((event) => {
    event.preventDefault();

    var eventName = $($(event.target).find("input[name='name']")).val();
    var propertiesVal = $($(event.target).find("textarea[name='properties']")).val();
    var properties = JSON.parse(propertiesVal);

    trackerClient.track(eventName, properties);
  });

  trackerClient.trackView();
});

var ahoy = {
  visitsUrl: "/api/visits",
  eventsUrl: "/api/events"
};
console.log("JHA");

$(document).ready(() => {
  console.log("JIHA");
  $("#custom-event").submit((event) => {
    console.log("HUHEJ");
    event.preventDefault();
    console.log($(event.target).find("input[type='name']").val());
  });
});

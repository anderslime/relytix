import {Socket} from "deps/phoenix/web/static/js/phoenix"

class EventViewModel {
  constructor() {
    this.events = ko.observableArray([]);
  }

  addEvent(event) {
    this.events.unshift(event);
  }

  setupSocketConnection() {
    this.socket = new Socket("/socket")
    this.socket.connect()
    this.channel = this.socket.channel("events:lobby", {})
    this.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    var _this = this;
    this.channel.on("new_msg", payload => {
      _this.addEvent({
        name: payload.name,
        id: payload.id,
        properties: JSON.stringify(payload.properties)
      })
    })
  }
}

export default function(element) {
  let eventViewModel = new EventViewModel();
  eventViewModel.setupSocketConnection();

  ko.applyBindings(eventViewModel, element);
}

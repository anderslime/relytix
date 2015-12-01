import {Socket} from "deps/phoenix/web/static/js/phoenix"

export default function initializeDashboard() {
  var dashboard = new Dashboard();
}

export class Dashboard {
  constructor() {
    // Initialize variables
    this.dataLoaded = false;
    this.chartLibraryLoaded = false;
    this.data = {};
    this.eventType = "$view"
    var obj = this;

    // Load the Visualization API and the piechart package.
    google.load('visualization', '1.0', {'packages':['corechart']});

    // Set a callback to run when the Google Visualization API is loaded.
    google.setOnLoadCallback(function() {
      obj.chartLibraryLoaded = true;
      obj.checkReadyState();
    });

    this.setupSocketConnection();
    setInterval($.proxy(this.loadChartData, this), 1000);
  }

  loadChartData() {
    var _this = this;
    $.ajax({
      url: `/api/queries/${this.eventType}`
    }).done(function(data) {
      _this.data = data;
      _this.dataLoaded = true;
      _this.checkReadyState();
    });
  }

  checkReadyState() {
    if(this.dataLoaded && this.chartLibraryLoaded) {
      this.drawCharts();
    }
  }

  drawCharts() {
    var dataTable = new google.visualization.DataTable();
    dataTable.addColumn('datetime', 'Date');


    var rows = []
    var columnValues = this.data.columns;

    $.each(this.data.series, function(series_name, column) {
      dataTable.addColumn('number', series_name);

      $.each(column, function(index, value) {
        if (!rows[index]) {
          rows[index] = [new Date(columnValues[index])]
        }

        rows[index].push(value);
      })
    });

    dataTable.addRows(rows);

    // Set chart options
    var options = {'title':'Pageviews'};

    // Instantiate and draw our chart, passing in some options.
    var chart = new google.visualization.LineChart(document.getElementById('chart'));
    chart.draw(dataTable, options);
  }

  setupSocketConnection() {
    this.socket = new Socket("/socket")
    this.socket.connect()
    this.channel = this.socket.channel(`events:${this.eventType}`, {})
    this.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    var _this = this;
    this.channel.on("new_msg", payload => {
      this.loadChartData();
    })
  }
}

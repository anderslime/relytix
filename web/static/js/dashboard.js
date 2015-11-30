export default function initializeDashboard() {
  var dashboard = new Dashboard();
}

export class Dashboard {
  constructor() {
    // Initialize variables
    this.dataLoaded = false;
    this.chartLibraryLoaded = false;
    this.data = {};
    var obj = this;

    // Load the Visualization API and the piechart package.
    google.load('visualization', '1.0', {'packages':['corechart']});

    // Set a callback to run when the Google Visualization API is loaded.
    google.setOnLoadCallback(function() {
      obj.chartLibraryLoaded = true;
      obj.checkReadyState();
    });

    // Load chart data
    $.ajax({
      url: "/api/queries/$view"
    }).done(function(data) {
      console.log(data);
      obj.data = data;
      obj.dataLoaded = true;
      obj.checkReadyState();
    });
  }

  checkReadyState() {
    if(this.dataLoaded && this.chartLibraryLoaded) {
      this.drawCharts();
    }
  }

  drawCharts() {
    var dataTable = new google.visualization.DataTable();
    dataTable.addColumn('date', 'Date');


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
}

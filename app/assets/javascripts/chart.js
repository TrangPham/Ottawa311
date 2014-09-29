window.onload = function() {
  getCharts({});
}

getCharts = function(options) {
  $.ajax({
    type: "GET",
    url: "charts/",
    data: options
  })
  .done(function(rv) {
    loadCharts(rv);
  });
}

function toggle_visibility(id) 
{
  var e = document.getElementById(id);
  if ( e.style.display == 'block' )
      e.style.display = 'none';
  else
      e.style.display = 'block';
}

function loadCharts(data) {
  document.getElementById("title").innerText = data["title"];
  document.getElementById("total").innerText = "Total: " + data["total"];


  r = data["results"]
  if (r[0]) {
    loadChart("1", data["select"], r[0]["group"], r[0]["columns"]);
  } else {
    display("chart1panel", false);
  }

  if (r[1]) {
    loadChart("2", data["select"], r[1]["group"], r[1]["columns"]);
  } else {
    display("chart2panel", false);
  }
}

function loadChart(chart, select, group, columns) {
  display("chart" +  chart + "panel", true);

  title = "by " + group;
  document.getElementById("chart" + chart + "title").innerText = title;

  c3.generate({
    bindto: "#chart" + chart,
    data: {
      columns: columns,
      type: 'pie',
      onclick: function(d, i) { 
        select[group] = d.id
        options = {select: select, group: group}
        getCharts(options)
      },
    },
    tooltip: {
      format: {
        value: function(value, ratio, id) {
          return value + " | " + (ratio*100).toPrecision(3) + "%";
        }
      }
    },
    legend: {
      position: 'right'
    }
  });
}

function display(id, show) {
  if (show) {
    document.getElementById(id).style.display = '';
  }
  else {
    document.getElementById(id).style.display = 'none';
  }
}
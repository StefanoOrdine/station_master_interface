// refresh schedules automatically every 60 seconds
window.setInterval(updateSchedules, 60000);
window.setInterval(updateTime, 60000);

// get the schedules data for the first time
$(document).ready(function() {
  updateTime();
  updateSchedules();
});

// update schedules if a station code is given
function updateSchedules() {
  var station_code = urlParam('station_code');

  if(station_code != null) {
    getRemoteSchedules('departures', station_code);
    getRemoteSchedules('arrivals', station_code);
  }
}

// perform the remote call to departures or arrivals in order to retrieve fresh schedules
function getRemoteSchedules(schedule_type, station_code, schedule_count) {
  // get the table body
  var table_body = $('#' + schedule_type + ' > tbody');
  $.ajax({
    // build url for ajax request
    url: '/' + schedule_type + '?' + $.param({ station_code: station_code, schedule_count: table_body.data("schedule-count") })
  }).done(function (data) {
    if(!_.isEmpty(data)) {
      // flush the schedules list
      table_body.empty();
      // create a new row for each new schedule
      _.each(data, function(schedule) {
        // prepare data for row creation
        var train_code = schedule.train_code;
        var place;
        if(schedule_type == 'departures') {
          place = schedule.destination;
        }
        else {
          place = schedule.origin;
        }
        var time = schedule.time;
        var delay = schedule.delay;
        if(delay == 0) {
          delay = '';
        }
        var platform = schedule.platform;
        // create the new row
        var row = '<tr><td></td><td>' + train_code + '</td><td>' + place + '</td><td>' + time + '</td><td>' + delay + '</td><td>' + platform + '</td></tr>';
        // append the row to the table
        table_body.append(row);
      });
    }
  });
}

// extract param from url
function urlParam(name) {
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results==null) {
       return null;
    }
    else {
       return results[1] || 0;
    }
}

// update the time
function updateTime() {
  // get the time element
  var time = $('.current-time');
  $.ajax({
    // build url for ajax request
    url: '/current_time'
  }).done(function (data) {
    if(data) {
      time.text(data)
    }
  });
}
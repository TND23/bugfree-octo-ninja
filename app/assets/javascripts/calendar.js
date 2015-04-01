$(document).ready(function() {
  return $('#calendar').fullCalendar({
    editable: true,
    header: {
      left: 'prev,next',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    // will show month, be 500 px high, and have 24 slots by default 
    defaultView: 'month',
    height: 500,
    slotMinutes: 60,

    eventSources: [
      {
        // magic number which is liable to change if routes get moved around
        // this is built this way so users can look at each others calendars
        // since now the data will fetch json data from the url in the window
        url: '/users/' +  window.location.pathname.split("/")[2] + '/activities',
        color: 'yellow',
        textColor: 'black'
      }
    ],
    // when rendering, the elements title will display the tags
    eventRender: function(event, element, view) {
      return element.attr({
        "title": this.tag
      });
    },
    timeFormat: 'h:mm t{ - h:mm t} ',
    dragOpacity: "0.5",
    eventDrop: function(activity, dayDelta, minuteDelta, allDay, revertFunc) {

      return updateEvent(activity);
    },
    eventResize: function(activity, dayDelta, minuteDelta, revertFunc) {
      // sendAjaxRequest(activity);
      return updateEvent(activity);
    }
  });
});

updateEvent = function(the_activity) {
  return $.update("/activies/" + the_activity.id, {
    activity: {
      title: the_activity.title,
      starts_at: "" + the_activity.started,
      ends_at: "" + the_activity.finished,
      description: the_activity.description
    }
  });
};

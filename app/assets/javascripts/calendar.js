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
    ignoreTimezone: false,
    eventSources: [
      {
        // magic number which is liable to change if routes get moved around
        // this is built this way so users can look at each others calendars
        // since now the data will fetch json data from the url in the window
        url: '/users/' +  window.location.pathname.split("/")[2] + '/activities',
        color: '#3B91AD',
        textColor: 'black'
      }
    ],
    // when rendering, the elements title will display the tags
    eventRender: function(event, element, view) {
      //console.log(event);
      return element.attr({
        "title": this.tag
      });
    },

    eventClick: function(event){
      // blank out the background screen
      $("#overlay").show();
      $("#hiddenForm").show();

      renderForm(event);
      return false;
    },

    timeFormat: 'h:mm t{ - h:mm t} ',
    dragOpacity: "0.5",
    eventDrop: function(activity, dayDelta, minuteDelta, allDay, revertFunc) {
      return updateEvent(activity);
    },

    eventResize: function(activity, dayDelta, minuteDelta, revertFunc) {
      // sendAjaxRequest(activity);;
      return updateEvent(activity);
    }
  });
});

updateEvent = function(the_activity) {
  //debugger;
  // javascript assumes that + is trying to concat the string. 
  // to get around this, we substract the negative.
  // the_activity._start = the_activity.start = new Date(the_activity.start - (delta * -1));
  // the_activity._end = the_activity.end = new Date(the_activity.end - (delta * -1));
  // debugger;
  $.ajax({
    type: 'PUT',
    dataType: 'json',
    url: the_activity.url,
    data: {
      activity: {
        content: the_activity.long_description, 
        tag: the_activity.tag, 
        status: the_activity.current_state, 
        overview: the_activity.title, 
        started: the_activity.start, 
        finished: the_activity.end 
      }, _method : 'put'
    },
    error: function(data,resp,error){
      console.log(resp); console.log(error);
    },
    success: function(){ console.log("SUCCESS"); }
  });

};

renderForm = function(activity){
  var hiddenForm = document.getElementById("hidden-form");
  hiddenForm.style.display = "block";
  var form = generateForm(activity, listenToClick);
  return false;
};

generateForm = function(activity, callback){
  // nasty
  var f = document.getElementById("temp-form");

  var i1 = document.getElementById("activity_tag")
  var i2 = document.getElementById("activity_overview");
  var i3 = document.getElementById("activity_content");
  i1.setAttribute('value', activity.tag);
  i2.setAttribute('value', activity.title);
  i3.setAttribute('value', activity.long_description);

  document.getElementById("hidden-form").appendChild(f);
  callback(activity);
};

listenToClick = function(activity){
  // take current form values and set them to whatever.
  $("#submit-hidden-form").click(function(){
    activity.tag = document.getElementById("activity_tag").value;
    activity.overview = document.getElementById("activity_overview").value;
    activity.content = document.getElementById("activity_content").value;
    activity.status = document.getElementById("activity_status").value;
    updateEvent(activity);
  })
};
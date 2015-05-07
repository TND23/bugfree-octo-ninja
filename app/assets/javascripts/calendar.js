$(document).ready(function() {
  // immediately load the calendarcreation function
  // by waiting for the function to finish first,
  // we let the calendar recieve json data from dynamic urls corresponding with
  // the users departments
  if (window.location.pathname.split("calendar").length > 1){
    return asynchCalendarCreation();    
  }
});

updateEvent = function(the_activity) {
  // for justice.
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

// send a get request to the path users/(curr_id)/departments
// and shovel in the ids of all departments found there
// once this is done, create the json urls that will be used by the event objects
asynchCalendarCreation = function(){
  var department_ids = [];
  $.ajax({
    type: 'GET',
    dataType: 'json',
    url: '/users/' + window.location.pathname.split("/")[2] + '/departments',
    error: function(){
      console.log("HERE");
    },
    success: function(data){
      data.forEach(function(datum){
        department_ids.push(datum.id);
      });
      return createEventSources(department_ids);
    }
  });
};

createEventSources = function(department_ids){
  var depts = department_ids;
  var eventSources = [
    {
      url: '/users/' +  window.location.pathname.split("/")[2] + '/activities',
      color: '#3B91AD',
      textColor: 'black'
    }
  ];
  
  depts.forEach(function(dpt){
    var newObj = {
      url: '/departments/' + dpt + '/department_activities',
      color: 'red',
      textColor: 'black'
    };
    eventSources.push(newObj);
  });
  return $('#calendar').fullCalendar(createCalendarObject(eventSources));
};

createCalendarObject = function(eventSources){
  var eventSources = eventSources; 
  var obj = 
  {
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

    eventSources: eventSources,

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
  };

  return obj; 
}


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
    // debugger;
    activity.tag = document.getElementById("activity_tag").value;
    activity.overview = document.getElementById("activity_overview").value;
    activity.long_description = document.getElementById("activity_content").value;
    activity.status = document.getElementById("activity_status").value;
    updateEvent(activity);
  })
};

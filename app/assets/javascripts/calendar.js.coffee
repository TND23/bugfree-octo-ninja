$(document).ready ->
  $('#calendar').fullCalendar
    editable: true,
    header:
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    defaultView: 'month',
    height: 500,
    slotMinutes: 30,

    eventSources: [
        {
            url: 'users/1/activities', 
            color: 'blue',    
            textColor: 'black'  
        }
    ]


    eventRender: (event, element, view) ->
      that = this
      element.attr({"title": that.tag})
   

    timeFormat: 'h:mm t{ - h:mm t} ',
    dragOpacity: "0.5"

    eventDrop: (activity, dayDelta, minuteDelta, allDay, revertFunc) ->
      updateEvent(activity);

    eventResize: (activity, dayDelta, minuteDelta, revertFunc) ->
      updateEvent(activity);


updateEvent = (the_activity) ->
  $.update "/activies/" + the_activity.id,
    activity:
      title: the_activity.title,
      starts_at: "" + the_activity.started,
      ends_at: "" + the_activity.finished,
      description: the_activity.description

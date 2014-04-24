$ ->
  map = null
  initialize = ->
    mapOptions = (
      center: new google.maps.LatLng(-41.287, 174.776)
      zoom: 4
    )
    return new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
  
  map = initialize()

  ll = (lat, lon) ->
    return new google.maps.LatLng(lat,lon)

  routes = $('#all_data').data('route')
  places = $('#all_data').data('place')
  mails  = $('#all_data').data('mail')
  current_time = $('#all_data').data('time')

  get_route = (id) ->
    for row in routes
      return row if row.id is id
    return null
  get_place = (id) ->
    for row in places
      return row if row.id is id
    return null
  get_mail = (id) ->
    for row in mails
      return row if row.id is id
    return null
  mail_state = (mail, id) ->
    for mail_st in mail.states
      return mail_st if mail_st.id is id
    return null
  mails_for_route = (route_id) ->
    ms = []
    for mail in mails
      m_state = mail_state(mail, mail.current_state)
      if m_state.route_id is route_id and m_state.state_int != 2
        ms.push(mail)
    return ms
  mail_total_duration = (mail) ->
    mail_state(mail, mail.current_state).full_duration
  mail_current_duration = (mail) ->
    mail_state(mail, mail.current_state).current_duration


  update_mail_current_state = (mail) ->
    past_states = []
    for state in mail.states
      past_states.push(state) if current_time >= state.start_time
    new_state = past_states[past_states.length - 1]
    if mail.current_state != new_state.id
      mail["current_state"] = new_state.id




  line_symbol = ( 
    path: google.maps.SymbolPath.CIRCLE 
    scale: 4
  )
  arrow_symbol = (
    path: google.maps.SymbolPath.FORWARD_OPEN_ARROW
    scale: 1.5
  )
  polyLines = []

  for route in routes
    origin = get_place(route.origin_id)
    destination = get_place(route.destination_id)
    path = [ll(origin.lat, origin.lon), ll(destination.lat, destination.lon)]
    r = new google.maps.Polyline(
      path: path
      geodesic: true
      strokeColor: '#000000'
      strokeOpacity: 0.9
      strokeWeight: 1
      route_id: route.id
      icons: []
    )
    r.setMap(map)
    polyLines.push(r)

  animateThings = ->
    setInterval ->
      for mail in mails
        update_mail_current_state(mail)
      for poly in polyLines
        route_mails = mails_for_route(poly.route_id)
        icons = []
        icons.push(
          icon: arrow_symbol
          offset: '50%'
        )
        
        for mail in route_mails
          curdur = mail_current_duration(mail)
          totdur = mail_total_duration(mail)
          percent = (curdur / totdur) * 100
          percent = "#{percent}%"
          m_state = mail_state(mail, mail.current_state)
          m_state["current_duration"] += 1
          console.log "#{percent} - #{mail.current_state}"
          if m_state.state_int == 0
            percent = "0%"
            console.log "RESET"
          if m_state.state_int == 2
            percent = "100%"

          icons.push(
            icon: line_symbol
            offset: percent
            scale: 10
            total_duration: totdur
            current_duration: curdur
          )
        poly.set 'icons', icons
      current_time += 1
    , 1000

  animateThings()
  

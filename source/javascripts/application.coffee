//= require 'jquery'
//= require 'd3'
//= require 'topojson'
//= require 'datamaps'
//= require 'dimple/dist/dimple.v2.0.0.js'
//= require 'director/build/director.js'
//= require 'spinjs/spin.js'
//= require 'bootstrap/modal'

map = null
setContainerSize = ->
  w = $('#main').width()
  w = if w < 500 then 500 else w
  h = $(window).height()-$('#head').height()-140
  h = if h < 400 then 400 else h
  $('#mapContainer, #chartContainer').width(w)
    .height(h)
  $('#mapContainer').empty()
  $('#contents').height(h+$('#chartMenu').height())
  map = new Datamap(
    element: document.getElementById('mapContainer')
    geographyConfig:
      highlightOnHover: false
      popupOnHover: false
    fills:
      'bubbleColor': '#2667C1'
      defaultFill: '#BED4DF'
    bubbleConfig:
      borderWidth: 1
  )
setContainerSize()

jump = (path) ->
  window.location.hash = '#' + path

setDescription = (path, param = null) ->
  if path == 'map'
    $('#desc-title').text(param)
    $('#desc-body').text('Number of issued visas by country')
  else if path == 'chart'
    desc = switch param.replace(/-/, '')
      when 'Overview' then 'Number of issued visas by visa categories'
      when 'A1' then 'Ambassador, public minister, career diplomat, consul, and immediate family'
      when 'A2' then 'Other foreign government official or employee, and immediate family'
      when 'A3' then 'Attendant, servant, or personal employee of A1 and A2, and immediate family'
      when 'B1' then 'Temporary visitor for business'
      when 'B1,2' then 'Temporary visitor for business and pleasure'
      when 'B1,2/BCC' then 'Combination B1/B2 and Border Crossing Card'
      when 'B2' then 'Temporary visitor for pleasure'
      when 'B1,2/BCV' then 'Combination B1/B2 and Mexican Lincoln'
      when 'C1' then 'Person in transit'
      when 'C1/D' then 'Combination transit/crew member (indiv. iss.)'
      when 'C2' then 'Person in transit to United Nations Headquarters'
      when 'C3' then 'Foreign government official, immediate family, attendant, servant, or personal employee in transit'
      when 'CW1' then 'Commonwealth of Northern Mariana Islands transitional worker'
      when 'CW2' then 'Spouse or child of CW1'
      when 'D' then 'Crew member (sea or air) (individual issuance)'
      when 'DCREW' then 'Crewlist Visas'
      when 'E1' then 'Treaty trader, spouse and children'
      when 'E2' then 'Treaty investor, spouse and children'
      when 'E2C' then 'Commonwealth of the Northern Mariana Islands investor, spouse and children'
      when 'E3' then 'Australian specialty occupation professional'
      when 'E3D' then 'Spouse or child of Australian specialty occupation professional'
      when 'E3R' then 'Returning Australian specialty occupation professional'
      when 'F1' then 'Student (academic or language training program)'
      when 'F2' then 'Spouse or child of student'
      when 'F3' then 'Border commuter academic or language student'
      when 'G1' then 'Principal resident representive of recognized foreign member government to international organization, staff, and immediate family'
      when 'G2' then 'Other representative of recognized foreign member government to international organization, and immediate family'
      when 'G3' then 'Representative of nonrecognized or nonmember foreign government to international organization, and immediate family'
      when 'G4' then 'International organization officer or employee, and immediate family'
      when 'G5' then 'Attendant, servant, or personal employee of G1 through G4, and immediate family'
      when 'H1A' then 'Temporary worker performing services as a registered nurse'
      when 'H1B' then 'Temporary worker of distinguished merit and ability performing services other than as a registered nurse'
      when 'H1B1' then 'Free Trade Agreement Professional'
      when 'H1C' then 'Shortage area nurse'
      when 'H2A' then 'Temporary worker performing agricultural services'
      when 'H2B' then 'Temporary worker performing other services'
      when 'H3' then 'Trainee'
      when 'H4' then 'Spouse or child of H1A/B/B1/C, H2A/B/R, or H3'
      when 'I' then 'Representative of foreign information media, spouse and children'
      when 'J1' then 'Exchange visitor'
      when 'J2' then 'Spouse or child of exchange visitor'
      when 'K1' then 'Fiance(e) of U.S. citizen'
      when 'K2' then 'Child of K1'
      when 'K3' then 'Certain spouse of U.S. citizen'
      when 'K4' then 'Child of K3'
      when 'L1' then 'Intracompany transferee (executive, managerial, and specialized personnel continuing employment with international firm or corporation)'
      when 'L2' then 'Spouse or child of intracompany transferee'
      when 'M1' then 'Vocational and other nonacademic student'
      when 'M2' then 'Spouse or child of vocational student'
      when 'M3' then 'Border commuter vocational or nonacademic student'
      when 'N8' then 'Parent of SK3 special immigrant'
      when 'N9' then 'Child of N8 or of SK1, SK2 or SK4 special immigrant'
      when 'NATO1' then 'Principal permanent representative of member state to NATO (including any of its subsidiary bodies) resident in the U.S.,and resident members of official staff; principal NATO officers; and immediate family'
      when 'NATO2' then 'Other representatives of member states to NATO (including any of its subsidiary bodies), and immediate family; dependents of member of a force entering in accordance with provisions of NATO agreements; members of such force if issued visas'
      when 'NATO3' then 'Official clerical staff accompanying a representative of member state to NATO, and immediate family'
      when 'NATO4' then 'Officials of NATO (other than those classifiable as NATO1), and immediate family'
      when 'NATO5' then 'Experts, other than NATO4 officials, employed in missions on behalf of NATO, and their dependents'
      when 'NATO6' then 'Members of a civilian component accompanying a force entering in accordance with the provisions of NATO agreements, and their dependents'
      when 'NATO7' then 'Attendant, servant, or personal employee of NATO1 through NATO6, and immediate family'
      when 'O1' then 'Person with extraordinary ability in the sciences, art, education, business, or athletics'
      when 'O2' then 'Person accompanying and assisting in the artistic or athletic performance by O1'
      when 'O3' then 'Spouse or child of O1 or O2'
      when 'P1' then 'Internationally recognized athlete or member of an internationally recognized entertainment group'
      when 'P2' then 'Artist or entertainer in a reciprocal exchange program'
      when 'P3' then 'Artist or entertainer in a culturally unique program'
      when 'P4' then 'Spouse or child of P1, P2, or P3'
      when 'Q1' then 'Participant in an International Cultural Exchange Program'
      when 'Q2' then 'Irish Peace Process trainee'
      when 'Q3' then 'Spouse or child of Q2'
      when 'R1' then 'Person in a religious occupation'
      when 'R2' then 'Spouse or child of R1'
      when 'S5' then 'Informant processing critical reliable information concerning criminal organization or enterprise'
      when 'S6' then 'Informant processing critical reliable information concerning terrorist organization, enterprise, or operation'
      when 'S7' then 'Spouse, married or unmarried son or daughter, or parent of S5 or S6'
      when 'T1' then 'Victim of a severe form of trafficking in persons'
      when 'T2' then 'Spouse of T1'
      when 'T3' then 'Child of T1'
      when 'T4' then 'Parent of T1'
      when 'T5' then 'Unmarried sibling under 18 years of age on date T1 applied'
      when 'TD' then 'Spouse or child of TN'
      when 'TN' then 'NAFTA professional'
      when 'U1' then 'Victim of criminal activity'
      when 'U2' then 'Spouse of U1'
      when 'U3' then 'Child of U1'
      when 'U4' then 'Parent of U1'
      when 'U5' then 'Unmarried sibling under 18 years of age on date U1 applied'
      when 'V1' then 'Certain Spouse of Legal Permanent Resident'
      when 'V2' then 'Certain Child of Legal Permanent Resident'
      when 'V3' then 'Child of V1 or V2'
    $('#desc-title').text(param + (if param != 'Overview' then ' Visa' else ''))
    $('#desc-body').text(desc)

spinner = null
d3.csv('/visa_data.csv')
  .on('beforesend', ->
    spinner = new Spinner().spin(document.body)
  )
  .row((d) ->
    Object.keys(d).map((key, index) ->
      if not isNaN(+d[key])
        d[key] = +d[key]
    )
    $.extend(d,
      Year: parseInt(d.Year)
      radius: Math.pow(d['Grand Total'] / 500, 1/2)
      fillKey: 'bubbleColor'
    )
  )
  .get((error, rows) ->
    palette = [
      '#5B8CCF' # B-1,2
      '#045868' # B-1,2/BCC
      '#A3EBE3' # B-2
      '#EE7170' # F-1
      '#36B898' # J-1
      '#1A5984' # C-1/D
      '#FFE27D' # B-1,2/BCV
      '#DB9657' # H-1B
      '#1f204f' # A-2
      '#04BCD2' # B-1
      '#b8dcaa' # H-4
      '#E25942' # L-1
      '#52616E' # L-2
      '#FD8079' # H-2B
      '#A9CFBD' # H-2A
    ]
    customColors =
      (new dimple.color(color, color) for color in palette)

    fetch_visa_categories = (x, callback) ->
      Object.keys(x).map((category) ->
        if ['name', 'Grand Total', 'Year', \
        'latitude', 'longitude', 'radius', 'fillKey'].indexOf(category) == -1
          callback(x, category)
      )

    assignColors = (chart) ->
      specialCategories = [
        'B-1,2'
        'B-1,2/BCC'
        'B-2'
        'F-1'
        'J-1'
        'C-1/D'
        'B-1,2/BCV'
        'H-1B'
        'A-2'
        'B-1'
        'H-4'
        'L-1'
        'L-2'
        'H-2B'
        'H-2A'
      ]
      idx = 0
      assigned = []
      specialCategories.forEach((element, index) ->
        chart.assignColor(element, palette[index], palette[index])
        assigned.push(element)
      )
      fetch_visa_categories(rows[0], (x, category) ->
        chart.assignColor(category, '#eee', '#ccc') if assigned.indexOf(category) == -1
      )


    fetch_by_year = (year) ->
      rows.filter((value) ->
        value.Year == year
      )

    fetch_by_country_and_year = (country, year) ->
      r = rows.filter((value) ->
        value.name == country && value.Year == year
      )
      r.shift()

    renderCountry = (d) ->
      items = []
      fetch_visa_categories(d, (x, category) ->
        items.push(
          issued: x[category]
          category: category
          country: x.name
        ) if x[category] > 0
      )
      items.sort((a, b) ->
        if a.issued < b.issued
          1
        else if a.issued > b.issued
          -1
        else
          0
      )
      $m = $('#countryModal')
      $m.data('country', d.name)
      title = 'Number of issued visas by visa category in ' + d.name + ' (' + d.Year + ')'
      $m.find('.modal-title').text(title)
      $('#countryChart').empty()
      svg = dimple.newSvg('#countryChart', 570, 140)
      c = new dimple.chart(svg, items)
      c.defaultColors = customColors
      assignColors(c)
      c.addPctAxis('x', 'issued')
      c.addCategoryAxis('y', 'country')
      t = c.addSeries('category', dimple.plot.bar)
      t.getTooltipText = (e) ->
        [e.aggField.join(''), d3.format(',')(e.xValue)]
      c.setBounds(9, 10, 500, 100)
      c.draw()
      # NOTE the position of xAxis looks weird
      c.svg.selectAll('.dimple-title').remove()

    renderMap = (y) ->
      map.bubbles(fetch_by_year(y),
        borderWidth: 1
        popupTemplate: (geo, data) ->
          '<div class="map-tooltip">' + data.name + ': ' + d3.format(',')(data['Grand Total']) + '</div>'
      )
      map.svg.selectAll('.datamaps-bubble').on('click', (d) ->
        renderCountry(d)
        $('#countryModal').on('shown.bs.modal', (e) ->
          # lets allow scroll
          $('body').removeClass('modal-open')
        ).modal()
      )

    current_year = 1996
    next_year = ->
      if current_year >= 2013
        current_year = 1997
      else
        current_year += 1
      current_year

    mapAnimation = null
    stopMapAnimation = ->
      $('#play').removeClass('glyphicon-pause').addClass('glyphicon-play')
      clearInterval(mapAnimation)

    startMapAnimation = ->
      $p = $('#play')
      if $p.hasClass('glyphicon-play')
        $p.removeClass('glyphicon-play').addClass('glyphicon-pause')
        mapAnimation = window.setInterval(->
          jump('/map/' + next_year())
        , 1000)
      else
        stopMapAnimation()

    viewMap = ->
      jump('/map/1997')

    viewMapWithYear = (path, year) ->
      current_year = parseInt(year)
      setDescription(path, current_year)
      renderMap(current_year)
      if $('#countryModal').is(':visible')
        renderCountry(fetch_by_country_and_year($('#countryModal').data('country'), current_year))

    sortByTotal = (data, type) ->
      sum = {}
      data.map((x) ->
        if not sum[x.name]?
          sum[x.name] =
            total: 0
            data: []
        sum[x.name]['total'] += x[type]
        sum[x.name]['data'].push(x)
      )
      sortable = []
      for country of sum
        continue if sum[country]['total'] == 0
        sortable.push([country, sum[country]['total']])
      sortable.sort((a, b) ->
        b[1] - a[1]
      )
      results = []
      for i in [0..9]
        if sortable[i]?
          results = results.concat(sum[sortable[i][0]]['data'])
      results

    sortByType = (data) ->
      # [{type: , total: , year: }]
      results = {}
      find_or_initialize = (type, total, year) ->
        key = type + '--' + year
        if results[key]
          results[key]['Total'] += total
        else
          results[key] =
            type: type
            'Total': total
            Year: year

      data.map((x) ->
        fetch_visa_categories(x, (x, category) ->
          find_or_initialize(category, x[category], x['Year'])
        )
      )
      r = []
      for i, result of results
        if result['Total'] > 0
          r.push(result)
      r

    drawChart = (data, yAxis, series, seriesType) ->
      w = $('#chartContainer').width()
      h = $('#chartContainer').height()
      svg = dimple.newSvg('#chartContainer', w, h)
      c = new dimple.chart(svg, data)
      c.defaultColors = customColors
      x = c.addCategoryAxis('x', 'Year')
      x.addOrderRule('Year')
      c.addMeasureAxis('y', yAxis)
      t = c.addSeries(series, seriesType)
      t.getTooltipText = (e) ->
        [e.aggField.join(''), d3.format(',')(e.yValue)]
      c.setBounds(50, 10, w-60, h-70)
      [c, t]

    renderingNow = false
    viewChart = (path, type = 'Overview') ->
      return if renderingNow
      $('#countryModal').modal('hide')
      setDescription(path, type)
      $('#chartContainer').empty()
      if type == 'Overview'
        $('#chartNote').hide()
        document.body.appendChild(spinner.spin().el)
        renderingNow = true
        # give a browser a time to render the spinner
        setTimeout(->
          c = drawChart(sortByType(rows), 'Total', 'type', dimple.plot.bar)
          assignColors(c[0])
          c[0].draw()
          spinner.stop()
          renderingNow = false
        , 100)
      else
        $('#chartNote').show()
        c = drawChart(sortByTotal(rows, type), type, 'name', dimple.plot.line)
        c[1].lineWeight = 2
        c[1].lineMarkers = true
        c[0].draw()

    viewChartWithType = (path, type) ->
      viewChart(path, decodeURIComponent(type))

    beforeRender = (path) ->
      $('#head .nav li').removeClass('active')
      $('#head .nav a[href^="#/' + path + '"]').closest('li').addClass('active')
      $('.btn.menu').removeClass('active')
      $('.btn.menu[href="' + window.location.hash + '"]')
        .addClass('active')
      $('#' + path).removeClass('invisible')
      $('#' + (if path == 'map' then 'chart' else 'map'))
        .addClass('invisible')

    routes =
      '/(map)':
        '/:year':
          on: viewMapWithYear
        on: viewMap
      '/(chart)':
        '/(.+)':
          on: viewChartWithType
        on: viewChart
    router = Router(routes).configure(
      before: beforeRender
    )
    router.init('/map')

    $('#play').click(startMapAnimation)

    $('a').click((e) ->
      stopMapAnimation()
      true
    )

    $('#chartMenu select').on('change', ->
      jump('/chart/' + encodeURIComponent($(this).val()))
    )
    $(window).resize(->
      setContainerSize()
      router.destroy().init(window.location.hash.substring(1))
    )
    spinner.stop()
  )

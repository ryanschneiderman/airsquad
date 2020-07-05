function init_shot_charts(court_width, shot_chart_data, team_name){
    init_team_shot_chart(court_width, shot_chart_data, team_name)
    init_player_shot_charts(court_width, shot_chart_data)
}

function init_team_shot_chart(court_width, shot_chart_data, team_name){
    var court = d3.select("#shot-trends-"+team_name).append('svg');
    // 14 shot locations = length of array
    var make_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var efg_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var att_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var court_regions = [];


    court.attr('width', court_width  + 5)
         .attr('height', court_height  + 5)
         
    var heat_g = court.append('g')
    var court_g = court.append('g');
    team_shot_chart = {"make_array": make_array, "court" : court, "court_g" : court_g, "efg_array": efg_array, "att_array": att_array, "court_regions": court_regions, "shot_chart_data": shot_chart_data}

    draw_court(court_width, team_shot_chart, inner_width, inner_height, x_offset, y_offset, region_spacing);
    insert_team_shot_chart_data(team_shot_chart, court_width);
    fill_regions(team_shot_chart);
}

function init_player_shot_charts(court_width, shot_chart_data){
    var len = shot_chart_data.length
    for(var i = 0; i < len; i++){
      var court = d3.select("#shot-trends-"+shot_chart_data[i].member_id).append('svg');
      // 14 shot locations = length of array
      var make_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      var efg_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      var att_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      var court_regions = [];


      
      court.attr('width', court_width + 5)
           .attr('height', court_height + 5)
           
      var heat_g = court.append('g')
      var court_g = court.append('g');
      shot_charts.push({"make_array": make_array, "court" : court, "court_g" : court_g, "efg_array": efg_array, "att_array": att_array, "court_regions": court_regions, "shot_chart_data": shot_chart_data[i].data, "member_id": shot_chart_data[i].member_id})
      
      draw_court(court_width, shot_charts[i], inner_width, inner_height, x_offset, y_offset, region_spacing);
      insert_player_shot_chart_data(shot_charts[i], court_width);
      fill_regions(shot_charts[i]);
    } 
}


function initCalibration(){
    var itemSize = $(window).innerWidth() *.025;
    var cellSize = itemSize-1;
    var x_offset = 5;
    var colorCalibration = [["#3661ad"],["#5176b8", "25%"],["#7c98ca", "30%"],["#abbddd", "35%"], ["#e4eaf4", "40%"], ["#f7d3d4", "45%"], ["#f0aaad", "50%"], ["#e7767b", "55%"], ["#de2429", "60%"], ["#d10002", "65%"]]
    var g = d3.select('[role="calibration"] [role="example"]').select('svg')
      .selectAll('rect').data(colorCalibration).enter()
      .append('g')

      g.append('rect')
        .attr('width',cellSize/1.5)
        .attr('height',cellSize)
        .attr('x', 0)
        .attr('y',function(d,i){
          return i*(itemSize);
        })
        .attr('fill',function(d){
          return d[0];
        })
      g.append("text")
        .attr("class","color-scale-text")
        .attr('x', cellSize + 2)
        .attr('y',function(d,i){
          return i*(itemSize);
        })
        .text(function(d) {return d[1]});
  }

function draw_court(width, shot_chart, inner_width, inner_height, x_offset, y_offset, region_spacing){

  var title = d3.select(document.getElementById('caption')).append('text');
      var slider_axis = shot_chart.court.append('g')
                             .attr('class', 'slider-axis');
      var slider_rect = shot_chart.court.append('g')
                             .attr('class', 'slider-rect');

      var rect_entity = slider_rect.append('rect');

      var court_xScale = d3.scaleLinear()
                                   .domain([0, court_width]);
      var court_yScale = d3.scaleLinear()
                                   .domain([0,court_height]);

      var color = d3.scaleSequential(d3.interpolateOrRd)
                    .domain([5e-6, 3e-2]); // Points per square pixel.
      
      var RestrictedArea = shot_chart.court_g.append('path')
      
      var BottomFreeThrow = shot_chart.court_g.append('path')
      var ThreeLine = shot_chart.court_g.append('path')
      var CenterOuter = shot_chart.court_g.append('path')
      var CenterInner = shot_chart.court_g.append('path')

      var BasketRegion = shot_chart.court_g.append('circle');
      var MidRangeRegion = shot_chart.court_g.append('circle');

    shot_chart.court_g.attr("width", court_width)
           .attr("height", court_height)

    var lineFunction = d3.line()
                         .x(function(d) { return d.x; })
                         .y(function(d) { return d.y; })
                         .curve(d3.curveLinear)

    


    var leftCornerThreePath = "M " + (x_offset + region_spacing) + "," + (y_offset + region_spacing) + " L " + (inner_width/12.4) + " , " + (y_offset + region_spacing) + " L " + (inner_width/12.4) + "," + (inner_width / 7.1) + " Q " + (inner_width/11.5) + "," + (inner_width / 5.5) + " " + (inner_width/ 10.5) + "," + (inner_width/4.82) + " L " + (x_offset + region_spacing) + " , " + (inner_width/4.82) + " Z"

    var leftWingThreePath = "M " + (x_offset + region_spacing) + "," + (inner_width/4.72) + " L " + (inner_width/10.4) + "," + (inner_width/4.72) + " Q " + (inner_width / 6.3) + "," + (inner_width / 2.49) + " " + (inner_width/2.889) + "," + (inner_width/2.075) + " L " + (inner_width/2.889) + "," + (inner_height - region_spacing) + " L " + (x_offset + region_spacing) + "," + (inner_height - region_spacing) + " Z";

    var straightAwayThreePath = "M " + (inner_width / 2.857) + "," + (inner_width / 2.07) + " Q " + (inner_width / 1.99) + "," + (inner_width/1.85) + " " + (inner_width/1.525) + "," + (inner_width/2.07) + " L " + (inner_width / 1.525) + "," + (inner_height - region_spacing) + " L " + (inner_width/2.857) +"," + (inner_height - region_spacing) + "Z";

    var rightWingThreePath = "M " + (inner_width / 1.1) + "," + (inner_width/4.72) + " L " + (inner_width - region_spacing/2) + "," + (inner_width/4.72) + " L " + (inner_width - region_spacing/2 ) + "," + (inner_height - region_spacing) + " L " + (inner_width / 1.515) + "," + (inner_height - region_spacing) + " L " + (inner_width / 1.515) + "," + (inner_width/2.08) + " Q " + (inner_width / 1.18) + "," + (inner_width / 2.495) + " " + (inner_width / 1.1) + "," + (inner_width/4.72);

    var rightCornerThreePath = "M " + (inner_width / 1.098) + "," + (inner_width/4.82) + " Q " + (inner_width/1.089) + "," + (inner_width/5.6) + " " + (inner_width/1.081) + "," + (inner_width / 7.1) + " L " + (inner_width/1.081) + "," + (y_offset + region_spacing) + " L " + (inner_width - region_spacing/2) + "," + (y_offset + region_spacing) + " L " + (inner_width - 2) + "," + (inner_width /4.82) + " Z"


    var leftCornerLongPath = "M " + (inner_width/10.5) + "," + (y_offset + region_spacing) + " L " + (inner_width/4.54) + "," + (y_offset + region_spacing) + " Q " + (inner_width/4.88) + "," + (inner_width/9.7) + " " + (inner_width/4.07) + "," + (inner_width/5.33) + " L " + (inner_width/8.1) + ","  + (inner_width/4.06) + " Q " + (inner_width/9.9) + "," + (inner_width/5.2) + " " + (inner_width/10.5) + "," + (inner_width/7.1) + " Z"  

    var leftWingLongPath = "M " + (inner_width/8) + "," + (inner_width/3.98) + " L " + (inner_width/4.02) + "," + (inner_width/5.22) + " Q " + (inner_width /3.42) + "," + (inner_width/3.63) + " " + (inner_width/2.65) + "," + (inner_width/3.15) + " L " + (inner_width/3.2) + "," + (inner_width/2.215) + " Q " + (inner_width/5.5) + "," + (inner_width/2.63) + " " + (inner_width/8) + "," + (inner_width/3.98);

    var middleLongPath = "M " + (inner_width /2.623) + "," + (inner_width/3.13) + " Q " + (inner_width/1.98) + "," + (inner_width/2.68) + " " + (inner_width/1.598) +"," + (inner_width/3.135) + " L " + (inner_width/1.456) + "," + (inner_width/2.198) + " Q " + (inner_width/2) + "," + (inner_width/1.845) + " " + (inner_width/3.16) + "," + (inner_width/2.205) + " Z ";

    var rightWingLongPath = "M " + (inner_width/1.587) + "," +(inner_width/3.159) + " Q " + (inner_width/1.4) + "," + (inner_width/3.64) + " " + (inner_width/1.318) + ',' + (inner_width/5.24) + " L " + (inner_width/1.135) + "," + (inner_width/4) + " Q " + (inner_width/1.222) + "," + (inner_width/2.6) + " " + (inner_width/1.448) + "," + (inner_width/2.21) + " Z ";

    var rightCornerLongPath = "M " + (inner_width/1.315) + "," + (inner_width/5.35) + " Q " + (inner_width/1.247) + "," + (inner_width/10) + " " + (inner_width/1.272) + "," + (y_offset + region_spacing) + " L " + (inner_width/1.099) + "," + (y_offset + region_spacing) + " L " + (inner_width/1.099) + "," + (inner_width/7.1) + " Q " + (inner_width/1.108) + "," + (inner_width/5.1) + " " + (inner_width/1.133) +"," + (inner_width/4.07) +  " Z ";

    var leftShortPath = "M " + (inner_width/4.46) + "," + (y_offset + region_spacing) + " C " + (inner_width/4.8) +"," + (inner_width/9.5) + " " + (inner_width/4.2) +"," + (inner_width/4.6) + " " + (inner_width/2.918) +"," + (inner_width/3.414) + " L " + (inner_width/2.375) +"," + (inner_width/5.64) + " C " + (inner_width/2.82) + "," + (inner_width/7.7) + " " + (inner_width/2.86) + "," + (inner_width/18) + " " + (inner_width/2.718) + "," + (y_offset + region_spacing) + " Z ";

    var middleShortPath = "M " + (inner_width/2.355) +"," + (inner_width/5.575) + " C " + (inner_width/2.12) + "," + (inner_width/4.75) + " " + (inner_width/1.87) + "," + (inner_width/4.75) + " " + (inner_width/1.714) +"," + (inner_width/5.63) + " L " + (inner_width/1.514) + "," + (inner_width/3.39) +  " C " + (inner_width/1.78) + "," + (inner_width/2.795) + " " + (inner_width/2.26) + "," + (inner_width/2.795) + " " + (inner_width/2.89) + "," + (inner_width/3.39) + " Z"; 

    var rightShortPath = "M " + (inner_width/1.705) + "," + (inner_width/5.70) + " C " + (inner_width/1.541) + "," + (inner_width/7.7) + " " +  (inner_width/1.526) + "," + (inner_width/18) + " " + (inner_width/1.573) + "," + (y_offset + region_spacing) + " L " + (inner_width/1.278) + ',' + (y_offset + region_spacing) + " C " + (inner_width/1.247) + "," + (inner_width/8) + " " +  (inner_width/1.327) + "," + (inner_width/4.4) + " " + (inner_width/1.505) + "," + (inner_width/3.415) + " Z"

    var LeftCornerThreeCointainer = shot_chart.court_g.append("path")
                                .attr("d", leftCornerThreePath)
                                //.attr("fill", "#93b9ff") 
    var leftCornerThreeText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/36))
                              .attr("y", (inner_width/9))

    shot_chart.court_regions.push({"region" : LeftCornerThreeCointainer, "text" : leftCornerThreeText});

    var LeftWingThreeContainer = shot_chart.court_g.append("path")
                                .attr("d", leftWingThreePath)
                                //.attr("fill", "#ff6363")

    var leftWingThreeText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/8))
                              .attr("y", (inner_width/2.2))

    shot_chart.court_regions.push({"region":LeftWingThreeContainer, "text" : leftWingThreeText});
    var StraightAwayThreeContainer = shot_chart.court_g.append("path")
                                .attr("d", straightAwayThreePath)
                                //.attr("fill", "#93b9ff")

    var straightAwayThreeText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/2.05))
                              .attr("y", (inner_width/1.7))                            
    shot_chart.court_regions.push({ "region" : StraightAwayThreeContainer, "text": straightAwayThreeText});  
    var RightWingThreeContainer = shot_chart.court_g.append("path")
                                .attr("d", rightWingThreePath)
                                //.attr("fill", "#ff6363") 
    var rightWingThreeText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/1.2))
                              .attr("y", (inner_width/2.2))  
    shot_chart.court_regions.push({"region" : RightWingThreeContainer, "text" : rightWingThreeText});
    var RightCornerThreeContainer = shot_chart.court_g.append("path")
                                .attr("d", rightCornerThreePath)
                                //.attr("fill", "#93b9ff")
    var rightCornerThreeText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/1.06))
                              .attr("y", (inner_width/9)) 

    shot_chart.court_regions.push({ "region" : RightCornerThreeContainer, "text" : rightCornerThreeText});
    
    var LefCornerLongCointainer = shot_chart.court_g.append("path")
                                .attr("d", leftCornerLongPath)
                                //.attr("fill", "#93b9ff")
    var leftCornerLongText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/7.5))
                              .attr("y", (inner_width/8.5))
    shot_chart.court_regions.push({ "region" : LefCornerLongCointainer, "text":leftCornerLongText});
    var LefWingLongCointainer = shot_chart.court_g.append("path")
                                .attr("d", leftWingLongPath)
                                //.attr("fill", "#93b9ff")
    var leftWingLongText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/4.2))
                              .attr("y", (inner_width/3.1))                            
    shot_chart.court_regions.push({ "region" : LefWingLongCointainer, "text":leftWingLongText});
    var MiddleLongCointainer = shot_chart.court_g.append("path")
                                .attr("d", middleLongPath)
                                //.attr("fill", "#93b9ff")
    var middleLongText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/2.05))
                              .attr("y", (inner_width/2.4))
    shot_chart.court_regions.push({ "region" : MiddleLongCointainer, "text":middleLongText});
    var RightWingLongCointainer = shot_chart.court_g.append("path")
                                .attr("d", rightWingLongPath)
                                //.attr("fill", "#93b9ff") 
    var rightWingLongText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/1.35))
                              .attr("y", (inner_width/3.1))
    shot_chart.court_regions.push({ "region" : RightWingLongCointainer, "text" : rightWingLongText});
    var RightCornerLongCointainer = shot_chart.court_g.append("path")
                                .attr("d", rightCornerLongPath)
                                //.attr("fill", "#93b9ff") 
    var rightCornerLongText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/1.2))
                              .attr("y", (inner_width/8))
    shot_chart.court_regions.push({ "region" : RightCornerLongCointainer, "text": rightCornerLongText});
    var LeftShortCointainer = shot_chart.court_g.append("path")
                                .attr("d", leftShortPath)
                                //.attr("fill", "#ffaaaa") 
    var leftShortText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/3.5))
                              .attr("y", (inner_width/7.5))
    shot_chart.court_regions.push({ "region" : LeftShortCointainer, "text":leftShortText});
    var MiddleShortCointainer = shot_chart.court_g.append("path")
                                .attr("d", middleShortPath)
                                //.attr("fill", "#ffaaaa")
    var middleShortText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/2.05))
                              .attr("y", (inner_width/3.5)) 
    shot_chart.court_regions.push({ "region" : MiddleShortCointainer, "text":middleShortText});
    var RightShortCointainer = shot_chart.court_g.append("path")
                                .attr("d", rightShortPath)
                                //.attr("fill", "#ffaaaa") 
    var rightShortText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/1.45))
                              .attr("y", (inner_width/7.5)) 
    shot_chart.court_regions.push({ "region" : RightShortCointainer, "text": rightShortText});

      
      var Basket = shot_chart.court_g.append('circle');
      var Backboard = shot_chart.court_g.append('rect');
      var Outterbox = shot_chart.court_g.append('rect');
      var Innerbox = shot_chart.court_g.append('rect');
      var CornerThreeLeft = shot_chart.court_g.append('rect');
      var CornerThreeRight = shot_chart.court_g.append('rect');
      var OuterLine = shot_chart.court_g.append('rect');
      var TopFreeThrow = shot_chart.court_g.append('path');


     

      Basket.attr('cx', inner_width /2 + x_offset)
             .attr('cy', inner_width / 17 + inner_width / 66.67)
             .attr('r', inner_width / 66.67)
             .style('fill', 'None')
             .attr('stroke-width', x_offset /2)
             .style('stroke', 'black');

      Backboard.attr('x', inner_width / 2 - inner_width / 16.67 + x_offset)
             .attr('y', inner_width / 17)
             .attr('width', inner_width / 8.33)
             .attr('height', 0.25)
             .style('fill', 'none')
             .attr('stroke-width', x_offset /2)
             .style('stroke', 'black');

      BasketRegion.attr('cx', inner_width /1.99)
              .attr('cy', inner_width / 17 )
              .attr('r', inner_width / 7.05)
              .style('stroke', 'black')
              .attr('stroke-width', x_offset * .75)

      BasketRegionText = shot_chart.court_g.append("text")
                              .attr("font-size", 13)
                              .text("0/0")
                              .attr("x", (inner_width/2.05))
                              .attr("y", (inner_width/8))
      shot_chart.court_regions.push({"region": BasketRegion, "text": BasketRegionText})

      CornerThreeLeft
             .attr('x', inner_width * 0.088)
             .attr('y', y_offset)
             .attr('width', 0.2)
             .attr('height', inner_height * .197)
             .style('fill', 'none')
             .attr('stroke-width', x_offset * .75)
             .style('stroke', 'white');

      CornerThreeRight
             .attr('x', inner_width *.9172)
             .attr('y', y_offset)
             .attr('width', 0.2)
             .attr('height', inner_height * .197)
             .style('fill', 'none')
             .attr('stroke-width', x_offset * .75)
             .style('stroke', 'white');

      OuterLine
             .attr('x', x_offset)
             .attr('y', y_offset)
             .attr("rx", 2)
             .attr('width', inner_width - x_offset /2)
             .attr('height', inner_height - y_offset)
             .style('fill', 'none')
             .style('stroke', 'white')
             .style('stroke-width', x_offset * .75)



      var angle = Math.atan((10-0.75)/(70))* 180 / Math.PI
      var dis = inner_width / 2.39;
      appendArcPath(ThreeLine, dis, (angle+90)*(Math.PI/180), (270-angle)*(Math.PI/180))
          .attr('fill', 'none')
          .attr("stroke", "white")
          .attr('stroke-width', x_offset * .75)
          .attr('class', 'shot-chart-court-3pt-line')
          .attr("transform", "translate(" + (inner_width / 1.99)  + ", " + inner_width * 0.086 +")");
}


function appendArcPath(base, radius, startAngle, endAngle) {
      var points = 100;

      var angle = d3.scaleLinear()
          .domain([0, points - 1])
          .range([startAngle, endAngle]);

      var line = d3.lineRadial()
          .radius(radius)
          .angle(function(d, i) { return angle(i); });

      return base.datum(d3.range(points))
          .attr("d", line);
}

function insert_shot_in_array(index, is_make, eff_fg_val, shot_chart){
  if(is_make) {
    shot_chart.make_array[index]++;
    shot_chart.efg_array[index]+=eff_fg_val;
  }
  shot_chart.att_array[index]++;

}

function determine_three_region(x,y,is_make, shot_chart, inner_width){
  if (y < (inner_width/4.82)){
    //left side of court
    if (x < inner_width/2){
      insert_shot_in_array(0, is_make, 1.5, shot_chart)
    }
    /*right corner */
    else{
     insert_shot_in_array(4, is_make, 1.5, shot_chart)
    } 
  }
  else if (x < (inner_width/2.889)) {
    insert_shot_in_array(1, is_make, 1.5, shot_chart)
  }
  else if (x < (inner_width/1.525)){
   insert_shot_in_array(2, is_make, 1.5, shot_chart)
  }
  /*right wing*/
  else {
    insert_shot_in_array(3, is_make, 1.5, shot_chart)
  }
}

function determine_long_mr_region(x,y,is_make, shot_chart, inner_width){
  if(x < (inner_width/4.03) && y < (-0.48 * (x - inner_width/8.3) + inner_width/4)){
    insert_shot_in_array(5, is_make, 1, shot_chart);
  }
  else if (x < (inner_width/2.63) && y < (-2.05 * (x - inner_width/3.2) + inner_width/2.19)){

    insert_shot_in_array(6, is_make, 1, shot_chart);
  }
  else if (x < (inner_width/1.45) && y > (2.25 * (x - inner_width/1.595) + inner_width/3.15)) {
    insert_shot_in_array(7, is_make, 1, shot_chart);
  }
  else if (x < (inner_width/1.13) && y > (0.48 * (x - inner_width/1.32) + inner_width/5.3)){
    insert_shot_in_array(8, is_make, 1, shot_chart);
  }
  else insert_shot_in_array(9, is_make, 1, shot_chart);
}

function determine_short_mr_region(x,y,is_make, shot_chart, inner_width){
  if(x < (inner_width/2.3) && y < (-1.477 * (x - inner_width/2.9) + inner_width/3.4)){
    insert_shot_in_array(10, is_make, 1, shot_chart);
  }
  else if (x < (inner_width/1.51) && y > (1.517 * (x - inner_width/1.74) + inner_width/6.2)){
    insert_shot_in_array(11, is_make, 1, shot_chart);
  }
  else insert_shot_in_array(12, is_make, 1, shot_chart);
}

function determine_region(x, y, is_make, shot_chart, inner_width){
  if(determine_arc_region(x, y, inner_width / 7.1, inner_width / 7.1, inner_width /2 + x_offset, inner_width / 17)){
    insert_shot_in_array(13, is_make, 1, shot_chart, inner_width);
  }
  else if (determine_arc_region(x, y, inner_width / 3.5, inner_width / 3.5, inner_width /2 + x_offset, inner_width / 17)){
    determine_short_mr_region(x,y,is_make, shot_chart, inner_width);
  }
  else if (determine_arc_region(x, y, inner_width / 2.39, inner_width / 2.39,(inner_width / 1.99), inner_width * 0.086) && determine_corner_three(x, y)){
    determine_long_mr_region(x,y,is_make, shot_chart, inner_width);
  }
  else {
    determine_three_region(x,y,is_make, shot_chart, inner_width);
  }
  
}

function determine_corner_three(x, y, inner_width, y_offset){
  if (x < inner_width * 0.088 && y < y_offset + inner_height * .182){
    return false;
  }
  else if ( x > inner_width *.9172 && y < y_offset + inner_height * .182){
    return false;
  }
  else return true;
}
  


function determine_arc_region(x_loc, y_loc, arc_horiz_radius, arc_vert_radius, center_x, center_y){

    var rel_pos_x = center_x - x_loc;
    var rel_pos_y = y_loc - center_y;
    //x^2
    var x_val = (rel_pos_x * rel_pos_x);
    // radius x^2
    var x_denom = arc_horiz_radius * arc_horiz_radius;
    var x_ratio = x_val/x_denom

    // radius_y ^2
    var y_denom = arc_vert_radius * arc_vert_radius;
    // y^2
    var y_val = rel_pos_y * rel_pos_y;
    y_ratio = y_val/y_denom

    var ellipse_val = x_ratio + y_ratio


    if (ellipse_val > 1) {
      return false;
    }
    else return true;
}

function determine_efg_color(color_array, eff_fg_pct){
    if(eff_fg_pct > 0.65){
      return color_array[0];
    }
    else if(eff_fg_pct > 0.6){      
      return color_array[1];
    }
    else if(eff_fg_pct > 0.55){
      return color_array[2];
    }
    else if(eff_fg_pct > 0.50){
      return color_array[3];
    }
    else if(eff_fg_pct > 0.45){
      return color_array[4];
    }
    else if(eff_fg_pct > 0.4){
      return color_array[5];
    }
    else if(eff_fg_pct > 0.35){
      return color_array[6];
    }
    else if(eff_fg_pct > 0.3){
      return color_array[7];
    }
    else if(eff_fg_pct > 0.25){
      return color_array[8];
    }
    else{
      return color_array[9];
    }
}

function determine_adv_color(color_array, pct){
    pct = pct * 10;
    var index = Math.floor(pct)
    return color_array[index]
}


function fill_regions(shot_chart){
  // 13 == number of shot chart regions -1
  for(var i = 0; i <= 13; i++){
    if(shot_chart.att_array[i] == 0){
      shot_chart.court_regions[i].region.attr('fill', "#bdbdbd")
    }
    else{
      var eff_fg_pct = shot_chart.efg_array[i]/shot_chart.att_array[i]
      var color = determine_efg_color(color_array, eff_fg_pct)
      shot_chart.court_regions[i].region.attr('fill', color)
      shot_chart.court_regions[i].text.text(shot_chart.make_array[i]+"/"+shot_chart.att_array[i])
    }
  }
}

function insert_team_shot_chart_data(shot_chart, court_width){
  var num_players = shot_chart.shot_chart_data.length;
  for(var i = 0; i < num_players; i++){
    var shot_data_len = shot_chart.shot_chart_data[i].data.length;
    for(var j = 0; j < shot_data_len; j++){
      insert_shot_data(shot_chart.shot_chart_data[i].data[j], shot_chart, court_width)
    }
  }
}

function insert_shot_data(shot, shot_chart, court_width){
    var metadata = shot.metadata
    var y_loc = parseFloat(metadata.y_loc) * court_width;
    var x_loc = parseFloat(metadata.x_loc) * court_width;
    var shot_val = parseInt(metadata.shot_val);
    var shot_result = parseInt(shot.stat_list_id)
    var ShotLoc = shot_chart.court_g.append('circle');
    if(shot_result == 1){
      determine_region(x_loc, y_loc, true, shot_chart, court_width)
      ShotLoc.attr('cx', x_loc)
           .attr('cy', y_loc)
           .attr('r', 1)
           .style('fill', 'black')
           .attr('stroke-width', '2px')
           .style('stroke', 'green');
    }
    else {
      determine_region(x_loc, y_loc, false, shot_chart, court_width)
      ShotLoc.attr('cx', x_loc)
           .attr('cy', y_loc)
           .attr('r', 1)
           .style('fill', 'black')
           .attr('stroke-width', '2px')
           .style('stroke', 'black');
    }
}

function insert_player_shot_chart_data(shot_chart, court_width){
  var shot_chart_data = shot_chart.shot_chart_data
  var len = shot_chart_data.length;
  for(var i = 0; i < len; i++){
    insert_shot_data(shot_chart_data[i], shot_chart, court_width)
  }
}

function show_shot_chart(button, id){
    $(".index-shot-chart").addClass("shot-chart-deactivated")
    $("#shot-trends-"+id).removeClass("shot-chart-deactivated")
    $("#show-shot-chart-dropdown").hide()
    $("#shot-chart-current").text($(button).text())
}




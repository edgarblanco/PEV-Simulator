class Statistics{
  //GLOBAL VARIABLES
  //PFont f = createFont("TruetypewritterPolyglOTT", 10);
  //http://adilapapaya.com/papayastatistics/ - for Vizualization
  int HEADING1_FONT_SIZE =25;
  int HEADING2_FONT_SIZE =20;
  int HEADING3_FONT_SIZE =12;
  int STAT_FONT_SIZE =20;
  color HEADING_TEXT_COLOR = color(200);
  color STAT_TEXT_COLOR = color(190);
  color LINE_COLOR = color(255);
  
  
  int PANEL_SPACING = 15;
  int PANEL_MARGIN = 5;
  int DASHBOARD_HEIGHT = 10*HEADING2_FONT_SIZE+7*PANEL_SPACING + 6*STAT_FONT_SIZE + HEADING1_FONT_SIZE;
  int DASHBOARD_WIDTH = 200;
  int DASHBOARD_TOPLEFT_X = displayWidth-DASHBOARD_WIDTH - PANEL_SPACING;
  int DASHBOARD_TOPLEFT_Y = 50;
  
  
  //CONSTRUCTOR (run just once)
   Statistics() {
   
   } 
  void static_dashboard(){
    
    //order_table();
    //PEV_table();
    fill(0,0,50,200);
    roundRect(DASHBOARD_TOPLEFT_X,DASHBOARD_TOPLEFT_Y,DASHBOARD_WIDTH, DASHBOARD_HEIGHT);
    fill(255);
    //Gantt();
    big_display();
  }
  void roundRect(float x, float y, float w, float h)
  {
    float corner = w/50.0;
    float midDisp = w/10.0;
    
    beginShape();  
    curveVertex(x+corner,y);
    curveVertex(x+w-corner,y);
    curveVertex(x+w+midDisp,y+h/2.0);
    curveVertex(x+w-corner,y+h);
    curveVertex(x+corner,y+h);
    curveVertex(x-midDisp,y+h/2.0);
    
    curveVertex(x+corner,y);
    curveVertex(x+w-corner,y);
    curveVertex(x+w+midDisp,y+h/2.0);
    endShape();
  }  
  
  //FUNCTIONS
  void running_time(){
        noStroke();
        //PFont a = createFont("TruetypewritterPolyglOTT", 30);
        //textFont(f);
        textAlign(LEFT);
		textSize(HEADING3_FONT_SIZE);
		fill(HEADING_TEXT_COLOR);
		int time_X = DASHBOARD_TOPLEFT_X + PANEL_MARGIN ;
		int time_Y = DASHBOARD_TOPLEFT_Y+PANEL_MARGIN+ 2*HEADING1_FONT_SIZE;
		text("Time (HH:MM):",time_X,time_Y );
		
        textAlign(RIGHT);
		textSize(HEADING2_FONT_SIZE);
		fill(STAT_TEXT_COLOR);
        text(str(floor(TNOW/3600))+":"+nf((TNOW % 3600)/60,2,0), time_X +150, time_Y);
  }
  
  void order_table(){
    int x_distance=10;
    int x_interval=60;
    int y_distance=50;
    int y_interval=10;
    noStroke();
    fill(255);
    rect(0,40,displayWidth,90);
    fill(0);
    int i=0, num_display = 8;
    
    while (vec_order_status_delivery[i] != 0){
      i++;
    }
    
    int kk=0;
    text("ID", x_distance +kk* x_interval, y_distance);
    kk++;
    text("Released", x_distance +kk* x_interval, y_distance);
    kk++;
    text("Scheduled", x_distance +kk* x_interval, y_distance);
    kk++;
    text("Pickup", x_distance +kk* x_interval, y_distance);
    kk++;
    text("Delivery", x_distance +kk* x_interval, y_distance);
    kk++;
    text("X-pick.", x_distance +kk* x_interval, y_distance);
    kk++;
    text("Y-pick.", x_distance +kk* x_interval, y_distance);
    kk++;
    text("X-deliv.", x_distance +kk* x_interval, y_distance);
    kk++;
    text("Y-deliv.", x_distance +kk* x_interval, y_distance);
    kk++;
    text("Type", x_distance +kk* x_interval, y_distance);
    kk++;
    text("Alloc.", x_distance +kk* x_interval, y_distance);
    kk++;
    text("A", x_distance +kk* x_interval, y_distance);
    kk++;
    text("P", x_distance +kk* x_interval, y_distance);
    kk++;
    text("D", x_distance +kk* x_interval, y_distance);
    kk++;
    text("C", x_distance +kk* x_interval, y_distance);
    
    for (int k=i;k<min(ORDER_SIZE,i+num_display);k++){
      kk=0;
      text(str(k), x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      text(vec_release_time[k], x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      text(vec_scheduled_time[k], x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      text(vec_pickup_time[k], x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      text(vec_delivery_time[k], x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      text(vec_pickup_x[k], x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      text(vec_pickup_y[k], x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      text(vec_delivery_x[k], x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      text(vec_delivery_y[k], x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      if (vec_order_type[k]==0) {
      text("USER", x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      }
      if (vec_order_type[k]==1) {
      text("CARGO", x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      }      
      text(vec_assigned_PEV[k], x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      text(vec_order_status_allocation[k], x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      text(vec_order_status_pickup[k], x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      text(vec_order_status_delivery[k], x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
      kk++;
      text(vec_order_status_canceled[k], x_distance +kk* x_interval, y_distance+(k-i+1)*y_interval);
    }
    
    
    
  }
  
  void PEV_table(){
        int x_distance=880;
        int x_interval=80;
        int y_distance=50;
        int y_interval=10;
        
        int i=0, num_display = 8;
        text("ID", x_distance +0* x_interval, y_distance);
        text("Order", x_distance +1* x_interval, y_distance);
        text("Occup.", x_distance +2* x_interval, y_distance);
        text("KM", x_distance +3* x_interval, y_distance);
        text("SL(Pickup)", x_distance +4* x_interval, y_distance);
        text("AVG. WT", x_distance +5* x_interval, y_distance);
        text("Cost", x_distance +6* x_interval, y_distance);
        for (int k=i;k<min(PEV_FLEET_SIZE,i+num_display);k++){
            text(str(k), x_distance +0* x_interval, y_distance+(k-i+1)*y_interval);
            text(vec_PEV_order_allocated[k], x_distance +1* x_interval, y_distance+(k-i+1)*y_interval);    
            text(nf((vec_PEV_carry_time[k]/TNOW)*100,1,1)+"%", x_distance +2* x_interval, y_distance+(k-i+1)*y_interval);   
            text(nf(vec_PEV_distance[k],1,1), x_distance +3* x_interval, y_distance+(k-i+1)*y_interval);    
            text(nf((vec_PEV_num_pickup_ontime[k]/vec_PEV_num_pickup[k])*100,1,1)+"%", x_distance +4* x_interval, y_distance+(k-i+1)*y_interval);    
            text(nf((vec_PEV_wait_time[k]/vec_PEV_num_deliveries[k]),1,1), x_distance +5* x_interval, y_distance+(k-i+1)*y_interval);    
            text("$"+nf(vec_PEV_carry_time[k]*4.50,1,1), x_distance +6* x_interval, y_distance+(k-i+1)*y_interval);    
        }
 
  }
   void Gantt(){
        int x_distance=830;
        int x_interval=60;
        int y_distance=50;
        int y_interval=10;
        int i=0, num_display = 8;
        for (int k=i;k<min(PEV_FLEET_SIZE,i+num_display);k++){
          fill(120);
          rect(displayWidth-200,305-10*k,100,5);

        }
        fill(255);
        stroke(255);
        line(displayWidth-200, 310,displayWidth-200, 230);
        line(displayWidth-200, 310,displayWidth-10, 310);
        stroke(0);
        fill(0);
   }
   
  void big_display(){
		
	  	int PANEL1_Y = DASHBOARD_TOPLEFT_Y + PANEL_SPACING*5;
	  	int PANEL2_Y = DASHBOARD_TOPLEFT_Y + PANEL_SPACING*11;
	    int PANEL3_Y = DASHBOARD_TOPLEFT_Y + PANEL_SPACING*17;
	 	int PANEL4_Y = DASHBOARD_TOPLEFT_Y + PANEL_SPACING*23;
		int PANEL5_Y = DASHBOARD_TOPLEFT_Y + PANEL_SPACING*28;
		
		int COL_OFFSET = (int) DASHBOARD_WIDTH/3;
		
        float average_wait_time = 0.0f;
        float average_carry_rate = 0.0f;
        float average_alloc_rate = 0.0f;
        int count_allocated_PEV = 0;
        for (int k=0;k<PEV_FLEET_SIZE;k++){
          average_wait_time = average_wait_time + vec_PEV_wait_time[k];
          average_carry_rate = average_carry_rate + vec_PEV_carry_time[k];
          average_alloc_rate = average_alloc_rate + vec_PEV_alloc_time[k];
          if (vec_PEV_order_allocated[k] != -1){
            count_allocated_PEV = count_allocated_PEV + 1;
          }

        }
        int num_active_person = 0;
        int num_lost_person = 0;
        int num_filled_person = 0;
        int num_active_box = 0;
        int num_lost_box = 0;
        int num_filled_box = 0;
        
        for (int k=0;k<ORDER_SIZE;k++){
          
          if ((vec_order_status_delivery[k] == 0)&&(vec_order_type[k] == 0)&&(vec_release_time[k] <= TNOW)) num_active_person++;
          if ((vec_order_status_canceled[k] == 1)&&(vec_order_type[k] == 0)&&(vec_release_time[k] <= TNOW)) num_lost_person++;
          if ((vec_order_status_delivery[k] == 1)&&(vec_order_status_canceled[k] == 0)&&(vec_order_type[k] == 0)) num_filled_person++;
          if ((vec_order_status_delivery[k] == 0)&&(vec_order_type[k] == 1)&&(vec_release_time[k] <= TNOW)) num_active_box++;
          if ((vec_order_status_canceled[k] == 1)&&(vec_order_type[k] == 1)&&(vec_release_time[k] <= TNOW)) num_lost_box++;
          if ((vec_order_status_delivery[k] == 1)&&(vec_order_status_canceled[k] == 0)&&(vec_order_type[k] == 1)) num_filled_box++;


        }        
        
        
        average_wait_time = (average_wait_time/(float)(PEV_FLEET_SIZE*timestamp_standard));
        average_carry_rate = (average_carry_rate/(float)TNOW)/(float)PEV_FLEET_SIZE;
        average_alloc_rate = (average_alloc_rate/(float)TNOW)/(float)PEV_FLEET_SIZE;
        
		//TITLE
        textSize(HEADING1_FONT_SIZE);
		fill(HEADING_TEXT_COLOR);
		textAlign(LEFT);
        text("PEV Dynamics", DASHBOARD_TOPLEFT_X + PANEL_MARGIN, DASHBOARD_TOPLEFT_Y + 4*PANEL_MARGIN);
		
		//Subtitle
		textSize(HEADING3_FONT_SIZE);
		fill(HEADING_TEXT_COLOR);
		textAlign(LEFT);
        text("(Location:"+place_name+")", DASHBOARD_TOPLEFT_X + PANEL_MARGIN, DASHBOARD_TOPLEFT_Y + 4*PANEL_MARGIN + HEADING3_FONT_SIZE+1 );
        //stroke(255);
		
        //ORDERS PANEL
		
		
		
		//Persons 
        //fill(LINE_COLOR);
        //stroke(LINE_COLOR);
        //line(DASHBOARD_TOPLEFT_X, PANEL1_Y, DASHBOARD_TOPLEFT_X+DASHBOARD_WIDTH,PANEL1_Y);
        //a = createFont("TruetypewritterPolyglOTT", 10);
        stroke(0);
        //text(""+str(displayHeight-230), 80, 395);
        fill(PERSON_WAITING_COLOR);
        noStroke();
        rect(DASHBOARD_TOPLEFT_X-1, PANEL1_Y+1,DASHBOARD_WIDTH+1, HEADING3_FONT_SIZE+6);
        stroke(HEADING_TEXT_COLOR);
        fill(HEADING_TEXT_COLOR);
		textSize(HEADING3_FONT_SIZE);
        text("USERS ("+str(round(person_arrival_rate*3600))+" persons per hour)",DASHBOARD_TOPLEFT_X, PANEL1_Y+HEADING3_FONT_SIZE+3);
		
		textSize(HEADING3_FONT_SIZE);      
        text("Active:",DASHBOARD_TOPLEFT_X, PANEL1_Y+2*HEADING3_FONT_SIZE+6);
        text("Filled:",DASHBOARD_TOPLEFT_X+COL_OFFSET, PANEL1_Y+2*HEADING3_FONT_SIZE+6);
        text("Lost:",DASHBOARD_TOPLEFT_X+2*COL_OFFSET, PANEL1_Y+2*HEADING3_FONT_SIZE+6);   
		     
        textSize(STAT_FONT_SIZE);
		fill(STAT_TEXT_COLOR);
		stroke(STAT_TEXT_COLOR);
        text(num_active_person,DASHBOARD_TOPLEFT_X, PANEL1_Y+4*HEADING3_FONT_SIZE+6);
        text(num_filled_person,DASHBOARD_TOPLEFT_X+COL_OFFSET, PANEL1_Y+4*HEADING3_FONT_SIZE+6);
        text(num_lost_person,DASHBOARD_TOPLEFT_X+2*COL_OFFSET, PANEL1_Y+4*HEADING3_FONT_SIZE+6);
        textSize(STAT_FONT_SIZE);

		//Boxes
        fill(BOX_WAITING_COLOR);
        noStroke();
        rect(DASHBOARD_TOPLEFT_X-1, PANEL2_Y+1,DASHBOARD_WIDTH+1, HEADING3_FONT_SIZE+6);
        stroke(HEADING_TEXT_COLOR);
        fill(HEADING_TEXT_COLOR);
		textSize(HEADING3_FONT_SIZE);
        text("CARGO ("+round(box_arrival_rate*3600)+" boxes per hour)",DASHBOARD_TOPLEFT_X, PANEL2_Y+HEADING3_FONT_SIZE+3);
        
		textSize(HEADING3_FONT_SIZE);               
        text("Active:",DASHBOARD_TOPLEFT_X, PANEL2_Y+2*HEADING3_FONT_SIZE+6);
        text("Filled:",DASHBOARD_TOPLEFT_X+COL_OFFSET, PANEL2_Y+2*HEADING3_FONT_SIZE+6);
        text("Lost:",DASHBOARD_TOPLEFT_X+2*COL_OFFSET, PANEL2_Y+2*HEADING3_FONT_SIZE+6);  
		     
        textSize(STAT_FONT_SIZE);
		fill(STAT_TEXT_COLOR);
		stroke(STAT_TEXT_COLOR);
        text(num_active_box,DASHBOARD_TOPLEFT_X, PANEL2_Y+4*HEADING3_FONT_SIZE+6);
        text(num_filled_box,DASHBOARD_TOPLEFT_X+COL_OFFSET, PANEL2_Y+4*HEADING3_FONT_SIZE+6);    
        text(num_lost_box,DASHBOARD_TOPLEFT_X+2*COL_OFFSET, PANEL2_Y+4*HEADING3_FONT_SIZE+6); 

        //PEV (two columns)
        fill(100);
        noStroke();
        rect(DASHBOARD_TOPLEFT_X-1, PANEL3_Y+1,DASHBOARD_WIDTH+1, HEADING3_FONT_SIZE+6);
        stroke(HEADING_TEXT_COLOR);
        fill(HEADING_TEXT_COLOR);
		textSize(HEADING3_FONT_SIZE);
        text("PEV Stats",DASHBOARD_TOPLEFT_X, PANEL3_Y+HEADING3_FONT_SIZE+3);
        textSize(HEADING3_FONT_SIZE);
		
        noStroke();
        fill(PEV_BUSY_COLOR); 
        rect(DASHBOARD_TOPLEFT_X, PANEL3_Y+2*HEADING3_FONT_SIZE,COL_OFFSET, 10);
        fill(HEADING_TEXT_COLOR);
        text("Loaded (%):",DASHBOARD_TOPLEFT_X, PANEL3_Y+2*HEADING3_FONT_SIZE+29);
		
        fill(PEV_ASSIGNED_COLOR);
        rect(DASHBOARD_TOPLEFT_X+2*COL_OFFSET, PANEL3_Y+2*HEADING3_FONT_SIZE,COL_OFFSET, 10);   
        fill(HEADING_TEXT_COLOR); 
        text("Reserved (%):",DASHBOARD_TOPLEFT_X+2*COL_OFFSET, PANEL3_Y+2*HEADING3_FONT_SIZE+29);
		
        text("Waiting time",DASHBOARD_TOPLEFT_X, PANEL4_Y+ HEADING3_FONT_SIZE);
        text("Active Bikes",DASHBOARD_TOPLEFT_X+2*COL_OFFSET, PANEL4_Y+ HEADING3_FONT_SIZE);
		
        textSize(STAT_FONT_SIZE);
        text(int((average_carry_rate)*100)+"%", DASHBOARD_TOPLEFT_X, PANEL3_Y+ 6*HEADING3_FONT_SIZE);
        text(int((average_alloc_rate)*100)+"%", DASHBOARD_TOPLEFT_X+2*COL_OFFSET, PANEL3_Y+ 6*HEADING3_FONT_SIZE);
        text(str(int(average_wait_time/60))+"'", DASHBOARD_TOPLEFT_X, PANEL4_Y+ 3*HEADING3_FONT_SIZE);
        text(str(count_allocated_PEV) +"/"+str(PEV_FLEET_SIZE), DASHBOARD_TOPLEFT_X+2*COL_OFFSET, PANEL4_Y+ 3*HEADING3_FONT_SIZE);
        
        //MIT Logo
        float scale_pic = 0.15;
        image(img,DASHBOARD_TOPLEFT_X+2*COL_OFFSET, PANEL5_Y,321*scale_pic,166*scale_pic);
        
    
  }
}

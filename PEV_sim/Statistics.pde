class Statistics{
  //GLOBAL VARIABLES
  //PFont f = createFont("TruetypewritterPolyglOTT", 10);

  //http://adilapapaya.com/papayastatistics/ - for Vizualization

  
  //CONSTRUCTOR (run just once)
   Statistics() {
   
   } 
  void static_dashboard(){
    //PFont f1 = createFont("TruetypewritterPolyglOTT", 40);
    //textFont(f1);
//    noStroke();
//    fill(0);
//    rect(0,0,displayWidth,40);
//    fill(255);
//    textSize(26);
//    text("PEV - Simulation", displayWidth/2 - 200, 30);
//    text("(Location:"+place_name+")", displayWidth/2+100, 30);
//    textSize(12);
//    fill(0);
    //f1 = createFont("TruetypewritterPolyglOTT", 20);
    
    //order_table();
    //PEV_table();
    fill(0,0,0,155);
    roundRect(displayWidth-200,100,200,displayHeight-200);
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
        fill(255);
        //rect(displayWidth-100,100,80,20);
        fill(0);
        fill(255);
        //PFont a = createFont("TruetypewritterPolyglOTT", 30);
        //textFont(f);
        textAlign(LEFT);
        text("Time:",displayWidth-120, 140);
        textSize(72);
        textAlign(RIGHT);
        text(str(floor(TNOW/3600))+":"+nf(TNOW % 3600/60,2,0), displayWidth-10, 200);
        textSize(12);
        fill(255);
        stroke(255);
        line(displayWidth-200, 210,displayWidth-10, 210);
        //a = createFont("TruetypewritterPolyglOTT", 10);
        stroke(0);
        //text(""+str(displayHeight-230), 80, 395);
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
          
          if ((vec_order_status_allocation[k] == 0)&&(vec_order_type[k] == 0)&&(vec_release_time[k] < TNOW)) num_active_person++;
          if ((vec_order_status_canceled[k] == 1)&&(vec_order_type[k] == 0)&&(vec_release_time[k] < TNOW)) num_lost_person++;
          if ((vec_order_status_delivery[k] == 1)&&(vec_order_type[k] == 0)) num_filled_person++;
          if ((vec_order_status_allocation[k] == 0)&&(vec_order_type[k] == 1)&&(vec_release_time[k] < TNOW)) num_active_box++;
          if ((vec_order_status_canceled[k] == 1)&&(vec_order_type[k] == 1)&&(vec_release_time[k] < TNOW)) num_lost_box++;
          if ((vec_order_status_delivery[k] == 1)&&(vec_order_type[k] == 1)) num_filled_box++;


        }        
        
        
        average_wait_time = (average_wait_time/(float)PEV_FLEET_SIZE);
        average_carry_rate = (average_carry_rate/(float)TNOW)/(float)PEV_FLEET_SIZE;
        average_alloc_rate = (average_alloc_rate/(float)TNOW)/(float)PEV_FLEET_SIZE;
        
        fill(255);
        text("PEV - Simulation", displayWidth-55, 95);
        text("(Location:"+place_name+")", displayWidth-55, 115);
        stroke(255);
        fill(255);
        textAlign(LEFT);
        //ORDERS
         fill(200,0,0,150); //red
        noStroke();
        rect(displayWidth-200, 210,190, 20);
        stroke(255);
        fill(0);
        text("USERS ("+round(person_arrival_rate*3600/timestamp_standard)+" persons per hour)",displayWidth-200, 225);
        fill(255);
        line(displayWidth-200, 230,displayWidth-10, 230);        
        text("Active:",displayWidth-200, 245);
        text("Filled:",displayWidth-140, 245);
        text("Lost:",displayWidth-80, 245);        
        textSize(30);
        text(num_active_person,displayWidth-200, 280);
        text(num_filled_person,displayWidth-140, 280);
        text(num_lost_person,displayWidth-80, 280);
        textSize(12);

        line(displayWidth-200, 314,displayWidth-10, 314);
        fill(255,255,0,150);
        noStroke();
        rect(displayWidth-200, 315,190, 20);
        stroke(255);
        fill(0);
        text("CARGO ("+round(box_arrival_rate*3600/timestamp_standard)+" boxes per hour)",displayWidth-200, 330);
        fill(255);
        line(displayWidth-200, 335,displayWidth-10, 335);        
        text("Active:",displayWidth-200, 350);
        text("Filled:",displayWidth-140, 350);
        text("Lost:",displayWidth-80, 350);         
        textSize(30);
        text(num_active_box,displayWidth-200, 385);
        text(num_filled_box,displayWidth-140, 385);        
        text(num_lost_box,displayWidth-80, 385);
        textSize(12);

        //PEV
        line(displayWidth-200, 500,displayWidth-10, 500);
        text("Carry (%):",displayWidth-200, 520);
        text("Allocation (%):",displayWidth-100, 520);
        text("Waiting time:",displayWidth-200, 620);
        text("Active Bikes:",displayWidth-100, 620);
        textSize(30);
        //textAlign(RIGHT);
        text(nf((average_carry_rate)*100,1,1)+"%", displayWidth-200, 580);
        text(nf((average_alloc_rate)*100,1,1)+"%", displayWidth-100, 580);
        //text(nf(average_wait_time/60,0,0), displayWidth-200, 680);
        text(str(count_allocated_PEV) +"/"+str(PEV_FLEET_SIZE), displayWidth-100, 680);
        textSize(12);
        fill(255);
        //image(images[frame], xpos, ypos); Include PEV picture
        
        
        //Logo
        image(img,displayWidth-190, displayHeight-180,180,60);
    
  }
}

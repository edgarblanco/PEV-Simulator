

class PEV {
  //GLOBAL VARIABLES
  int status = 0; //idle
  int speed_value = 1;
  color c = color(44, 91, 167);
  float [][] PEV_routes;
  int num_steps=0;
  int step_count=0;
  int k = 0;
  boolean started_pickup = false;
  boolean started_delivery = false;
  
  float diff_tolerance = 0.00001;


  //int assigned_order = 0;
  float lat = 0;
  float lon = 0;
  
  float time_busy=0;
  
  GraphNode initialNode, pickupNode, deliveryNode;
  GraphNode[] rNodes_init_pickup, rNodes_pickup_delivery;
  
  PFont f = createFont("TruetypewritterPolyglOTT", 10);
  
  
  public Vec3D loc = new Vec3D(0,0,0);
  Vec3D speed = new Vec3D(0,0,0);

  //CONSTRUCTOR (run just once)
  PEV(Vec3D _loc) {
    loc = _loc;
  }

    //FUNCTIONS
    void searching_order(int PEV_ID, int ORDER_ID){
      //Search for the next order
      //for (int i=0;i<ORDER_SIZE;i++){
      //    if ((vec_release_time[i] < TNOW) && (vec_order_status_allocation[i] == 0) && (status == 0)){

            status = 1;
            vec_allocation_time[ORDER_ID] = (int)TNOW;
            vec_PEV_order_allocated[PEV_ID] = ORDER_ID;
            vec_order_status_allocation[ORDER_ID] = 1;
            k = 0;
      //    }
      //}
      //javax.swing.JOptionPane.showMessageDialog(null, str(current_order));  
    }
    void searching_order2(){
      //Search for the next order
      int min_order_idx = -1;
      int min_vehicle_idx = -1;
      float eval_distance = 99999.9f;
      
      for (int j=0;j<PEV_FLEET_SIZE;j++){
        PEV myPEV = (PEV)PEVCollection.get(j);
        for (int i=0;i<ORDER_SIZE;i++){
            if ((vec_release_time[i] < TNOW) && (vec_order_status_allocation[i] == 0) && (status == 0)){
                
              if(eval_distance > (abs(myPEV.lat - vec_pickup_x[i])+abs(myPEV.lon - vec_pickup_y[i]))){
                eval_distance = abs(myPEV.lat - vec_pickup_x[i])+abs(myPEV.lon - vec_pickup_y[i]);
                min_order_idx = i;
                min_vehicle_idx = j;
              }
  
            }
        }
      }
      if (min_order_idx != -1){  
        PEV myPEV = (PEV)PEVCollection.get(min_vehicle_idx);
        vec_allocation_time[min_order_idx] = (int)TNOW;     
        myPEV.status = 1;
        vec_PEV_order_allocated[min_vehicle_idx] = min_order_idx;
        vec_order_status_allocation[min_order_idx] = 1;
        myPEV.k = 0;
      }
//javax.swing.JOptionPane.showMessageDialog(null, str(current_order));  
    }    
    void find_path(int PEV_ID,int ID, float x_pickup_pos, float y_pickup_pos, float x_delivery_pos, float y_delivery_pos){
      
      PEV_routes = new float[1000000][2];
      
      
      
      DrawNetwork myNetWork = new DrawNetwork();
      float precision_node = 0.00001f;
      do {
        initialNode = gs2.getNodeAt(lat, lon, 0, precision_node);
        pickupNode = gs2.getNodeAt(y_pickup_pos, x_pickup_pos, 0, precision_node);
        pathFinder = myNetWork.makePathFinder(gs2, 2);
        myNetWork.usePathFinder(pathFinder, initialNode, pickupNode);
        //myNetWork.drawRoute(rNodes, color(200,0,0), 5.0f);
        rNodes_init_pickup = rNodes;
        precision_node = precision_node*(1.001);
        //javax.swing.JOptionPane.showMessageDialog(null, str(precision_node));
      } while (rNodes.length == 0);
      
      //println("PICKUP ->"+precision_node);

      precision_node = 0.00001f;
      do {
        pathFinder = myNetWork.makePathFinder(gs2, 2);
        deliveryNode = gs2.getNodeAt(y_delivery_pos, x_delivery_pos, 0, precision_node);
        myNetWork.usePathFinder(pathFinder, pickupNode, deliveryNode);
        //myNetWork.drawRoute(rNodes, color(0,200,0), 5.0f);
        precision_node = precision_node*(1.001);
        rNodes_pickup_delivery = rNodes;
      } while (rNodes.length == 0);
      
      //println("DELIVERY ->"+precision_node);
      num_steps = build_path_lerp(rNodes_init_pickup, rNodes_pickup_delivery);
      //javax.swing.JOptionPane.showMessageDialog(null, num_steps);

      //num_steps = build_path_nodes(rNodes_init_pickup, rNodes_pickup_delivery);


    }
    int build_path_lerp(GraphNode[] pickup,GraphNode[] delivery){
      int pace = 2;
      int step = 0;
      PEV_routes[step][0] = pickup[0].xf();
      PEV_routes[step][1] = pickup[0].yf();
      step++;
    
      for (int i=1;i<pickup.length;i++){
          int step_distance = max(1,(int)((sqrt(pow(pickup[i-1].xf()-pickup[i].xf(),2)+pow(pickup[i-1].yf()-pickup[i].yf(),2))*300)/(timestamp_standard*PEV_speed)));
          println(step_distance);
          for (int j=0;j<step_distance;j++){
            PEV_routes[step][0] = lerp(pickup[i-1].xf(), pickup[i].xf(),float(j)/float(pace));
            PEV_routes[step][1] = lerp(pickup[i-1].yf(), pickup[i].yf(),float(j)/float(pace));
            step++;
          }
      }
      PEV_routes[step][0] = pickup[pickup.length-1].xf();
      PEV_routes[step][1] = pickup[pickup.length-1].yf();
      step++;
      
      PEV_routes[step][0] = delivery[0].xf();
      PEV_routes[step][1] = delivery[0].yf();
      step++;
      
      for (int i=1;i<delivery.length;i++){
          int step_distance = max(1,(int)((sqrt(pow(delivery[i-1].xf()-delivery[i].xf(),2)+pow(delivery[i-1].yf()-delivery[i].yf(),2))*300)/(timestamp_standard*PEV_speed)));
          //println(step_distance);
          for (int j=0;j<step_distance;j++){
            PEV_routes[step][0] = lerp(delivery[i-1].xf(), delivery[i].xf(),float(j)/float(pace));
            PEV_routes[step][1] = lerp(delivery[i-1].yf(), delivery[i].yf(),float(j)/float(pace));
            step++;
          }
      }
      PEV_routes[step][0] = delivery[delivery.length-1].xf();
      PEV_routes[step][1] = delivery[delivery.length-1].yf();
      step++;
      
//      println("PICKUP: "+pickup.length+" ->DELIVERY: "+delivery.length); 
//      for (int i=0;i<step;i++){
//        println("X:"+PEV_routes[i][0]+" ->Y: "+PEV_routes[i][1]); 
//      }
//      println("_______________________________________");

      
      return step;    

      
    }
    
    void run(int PEV_ID,int ID, float x_pickup_pos, float y_pickup_pos, float x_delivery_pos, float y_delivery_pos){
      
      int initial_point = -1,pickup_point = -1,delivery_point = -1;
      float lat_initial = lat;
      float lon_initial = lon;
      DrawNetwork myNetWork = new DrawNetwork(); 
      myNetWork.drawRoute(rNodes_init_pickup, color(44, 91, 167,60), 5.0f); //blue
      myNetWork.drawRoute(rNodes_pickup_delivery, color(238, 137, 40,120), 5.0f); //orange
      
      if (status == 1) {
        vec_assigned_PEV[ID] = PEV_ID+1;
        pickup(PEV_ID, ID, x_pickup_pos, y_pickup_pos);
      }
      if (status == 2){
        deliver(PEV_ID, ID, x_delivery_pos, y_delivery_pos);
      }
      vec_PEV_distance[PEV_ID] = vec_PEV_distance[PEV_ID] + sqrt(pow(lat_initial - lat,2) + pow(lon_initial - lon,2))*30; //30 aprox. transf. lat/lon into km
//      if((mouseX < loc.x + 30)&&(mouseX > loc.x - 30)&&(mouseY < loc.y + 30)&&(mouseY > loc.y - 30)){
//        //javax.swing.JOptionPane.showMessageDialog(null, "Worked");
//        //rect(loc.x,loc.y,50,50);
//        display_statistics(PEV_ID);
//      
//      }
      
    }
    
    void pickup(int PEV_ID, int ID, float x_pickup_pos, float y_pickup_pos) {

      //javax.swing.JOptionPane.showMessageDialog(null, "X:"+lat+"- Pickup:"+x_pickup_pos);

      if ((abs(lat - y_pickup_pos) < diff_tolerance)&&(abs(lon - x_pickup_pos)<diff_tolerance)) {
        if (started_pickup == false) {
          vec_pickup_time[ID] = int(TNOW);
          started_pickup = true;
        }        
        //javax.swing.JOptionPane.showMessageDialog(null, str(started_pickup));
        
        if (vec_pickup_time[ID] + vec_loading_time[ID] >  int(TNOW)){
          lat = y_pickup_pos;
          lon = x_pickup_pos;
          ScreenPosition pos_loading = map.getScreenPosition(new Location(lat, lon));
          text("Status:"+"Loading", pos_loading.x+10, pos_loading.y+35);
          
        } else {
          status = 2; //seized
          vec_order_status_pickup[ID] = 1;
          started_pickup = false;
          vec_PEV_num_pickup[PEV_ID] = vec_PEV_num_pickup[PEV_ID] + 1;
          if (vec_pickup_time[ID] <= vec_scheduled_time[ID])
            vec_PEV_num_pickup_ontime[PEV_ID] = vec_PEV_num_pickup_ontime[PEV_ID] + 1;
        }
        
      } else {
        //c = color(44, 91, 167); //blue
        if (k < num_steps) {
          lat = PEV_routes[k][0];
          lon = PEV_routes[k][1];
          ScreenPosition pos = map.getScreenPosition(new Location(lat, lon));
          loc.x = pos.x;
          loc.y = pos.y;
          k = k + speed_value;
          //javax.swing.JOptionPane.showMessageDialog(null, str(k));
        } 
      }
      //lat = x_pickup_pos;
      //lon = y_pickup_pos;
      
    }


    void deliver(int PEV_ID, int ID, float x_delivery_pos, float y_delivery_pos) {
      if ((abs(lat - y_delivery_pos) < diff_tolerance)&&(abs(lon - x_delivery_pos)<diff_tolerance)) {
       
        //c = color(44, 91, 167); //blue
        if (started_delivery == false) {
          started_delivery = true;
        }   
        
        if (vec_delivery_time[ID] + vec_unloading_time[ID] >  int(TNOW)){
          lat = y_delivery_pos;
          lon = x_delivery_pos;          
          ScreenPosition pos_unloading = map.getScreenPosition(new Location(lat, lon));
          text("Status:"+"Unloading", pos_unloading.x+10, pos_unloading.y+35);
        } else {
          status = 0;
          vec_order_status_delivery[ID] = 1;
          started_delivery = false;
          vec_PEV_order_allocated[PEV_ID] = -1;
          vec_PEV_has_path[PEV_ID] = false;

          vec_delivery_time[ID] = int(TNOW);
          vec_PEV_carry_time[PEV_ID] = vec_PEV_carry_time[PEV_ID] + (vec_delivery_time[ID] - vec_pickup_time[ID]);
          vec_PEV_alloc_time[PEV_ID] = vec_PEV_alloc_time[PEV_ID] + (vec_delivery_time[ID] - vec_allocation_time[ID]);
          vec_PEV_wait_time[PEV_ID] = vec_PEV_wait_time[PEV_ID] + (vec_pickup_time[ID] - vec_release_time[ID]);
          
          //vec_PEV_num_deliveries[PEV_ID] = vec_PEV_num_deliveries[PEV_ID] + 1;
          //if (vec_delivery_time[ID] <= vec_scheduled_time[ID])
          //  vec_PEV_num_deliveries_ontime[PEV_ID] = vec_PEV_num_deliveries_ontime[PEV_ID] + 1;
        }        
      } else {
        //c = color(238, 137, 40); //orange
        if (k < num_steps) {
          lat = PEV_routes[k][0];
          lon = PEV_routes[k][1];
          ScreenPosition pos = map.getScreenPosition(new Location(lat, lon));
          loc.x = pos.x;
          loc.y = pos.y;
          k = k + speed_value;
        }        
      }
    }

    void display(int ID) {
      //fill(c, 100);
      // tint(0, 153, 204, 126);
      //stroke(c);
      //c = color(44, 91, 167);
      ScreenPosition pos_PEV = map.getScreenPosition(new Location(lat, lon));
      // rect(pos_PEV.x, pos_PEV.y, 8, 8);
      fill(44, 91, 167,150);
      if ((status > 0) && (vec_order_type[vec_PEV_order_allocated[ID]] == 0))  fill(200,0,0,150);   //red
      if ((status > 0) && (vec_order_type[vec_PEV_order_allocated[ID]] == 1))  fill(255,255,0,150); //yellow

      ellipse(pos_PEV.x, pos_PEV.y, 18, 18);
      //textSize(10);
      //text(ID, pos_PEV.x+8, pos_PEV.y+8);
      // text(ID, pos_PEV.x+4, pos_PEV.y+4);
      //textSize(12);
//      text(lat, pos_PEV.x, pos_PEV.y+5);
//      text(lon, pos_PEV.x, pos_PEV.y+15);

     
    }
    
    void display_interior(int ID) {
      fill(44, 91, 167); //blue
      if (status > 0){
        if (vec_order_type[vec_PEV_order_allocated[ID]] == 0 && vec_order_status_pickup[vec_PEV_order_allocated[ID]] == 1) fill(200,0,0); //red
        if (vec_order_type[vec_PEV_order_allocated[ID]] == 1 && vec_order_status_pickup[vec_PEV_order_allocated[ID]] == 1) fill(255,255,0); //yellow
      }
      //fill(c);
      // tint(0, 153, 204, 126);
      // stroke(c);
      ScreenPosition pos_PEV = map.getScreenPosition(new Location(lat, lon));
      // rect(pos_PEV.x, pos_PEV.y, 8, 8);
      ellipse(pos_PEV.x, pos_PEV.y, 8, 8);
      //fill(255);
     
    }
    void display_statistics(int ID) {
      fill(c);
      stroke(c);
      textFont(f);
      text(ID, loc.x+10, loc.y-5);
      text("X:"+str(int(loc.x)), loc.x+10, loc.y+5);
      text("Y:"+str(int(loc.y)), loc.x+10, loc.y+15);
      text("Order:"+str(ID), loc.x+10, loc.y+25);
      text("Status:"+str(status), loc.x+10, loc.y+35);
     
    }    
 
int build_path_nodes(GraphNode[] pickup,GraphNode[] delivery){

      int num_nodes_pickup = pickup.length;
      int num_nodes_delivery = delivery.length;
      int num_nodes_total = num_nodes_pickup + num_nodes_delivery;
      
      float fraction = 5;
      
       //Identify direction
       int x_directional = 0;
       int y_directional = 0;      
      
       //Node Follow construction path
       int step=0;
       float x_pos = pickup[0].xf();
       float y_pos = pickup[0].yf();
       PEV_routes[step][0] = x_pos;
       PEV_routes[step][1] = y_pos;
       step++;       
       float move_step = 0.0001;
       
       //javax.swing.JOptionPane.showMessageDialog(null, num_nodes_pickup);
       
       for (int i=0;i<num_nodes_pickup-1;i++){
            //javax.swing.JOptionPane.showMessageDialog(null, num_nodes_pickup+"->"+i+"->"+str(i+1));
            float x_slope_pickup = pickup[i+1].xf() - pickup[i].xf();
            float y_slope_pickup = pickup[i+1].yf() - pickup[i].yf();
            
            //javax.swing.JOptionPane.showMessageDialog(null, x_slope_pickup + "->" + y_slope_pickup);
            
            if(x_slope_pickup == 0) 
                x_directional = 0;
            else if(x_slope_pickup > 0)
                x_directional = 1;
            else if(x_slope_pickup < 0)
                x_directional = -1;
    
            if(y_slope_pickup == 0) 
                y_directional = 0;
            else if(y_slope_pickup > 0)
                y_directional = 1;
            else if(y_slope_pickup < 0)
                y_directional = -1;
            
            
            if (abs(x_directional*y_directional) == 0){
              while(abs(x_pos - pickup[i+1].xf()) > diff_tolerance){
                boolean updated = false;
                if(abs(x_pos - pickup[i+1].xf()) > diff_tolerance){
                      x_pos = x_pos + x_slope_pickup/fraction;
                      updated = true;
                }
                if (updated==false) break;
                x_pos = x_pos + x_slope_pickup/fraction;
                y_pos = y_pos;
      
                PEV_routes[step][0] = x_pos;
                PEV_routes[step][1] = y_pos;
                //javax.swing.JOptionPane.showMessageDialog(null, int(pickup[1].yf())+"->"+int(y_pos));
                step++;
                if (step > 1000) break; 
              }
              while(abs(y_pos - pickup[i+1].yf()) > diff_tolerance){
                x_pos = x_pos;
                y_pos = y_pos + y_slope_pickup/fraction;

                PEV_routes[step][0] = x_pos;
                PEV_routes[step][1] = y_pos;
                //javax.swing.JOptionPane.showMessageDialog(null, pickup[i+1].yf()+"->"+pickup[i].yf());
                step++;
                if (step > 1000) break; 
              }
            } else{
              while(sqrt(pow(x_pos - pickup[i+1].xf(),2) + pow(y_pos - pickup[i+1].yf(),2)) > diff_tolerance){
              boolean updated = false;
              if(abs(x_pos - pickup[i+1].xf()) > diff_tolerance){
                    x_pos = x_pos + x_slope_pickup/fraction;
                    updated = true;
              }
              if(abs(y_pos - pickup[i+1].yf()) > diff_tolerance){
                    y_pos = y_pos + y_slope_pickup/fraction;
                    updated = true;
              }
              if (updated==false) break;
      
                PEV_routes[step][0] = x_pos;
                PEV_routes[step][1] = y_pos;
                                
                step++;
                if (step > 1000) break; 
              }
              //javax.swing.JOptionPane.showMessageDialog(null, "SAIU");
              
            }
        
       }
        PEV_routes[step][0] = pickup[pickup.length-1].xf();
        PEV_routes[step][1] = pickup[pickup.length-1].yf();
        
        step++;       
        
       for (int i=0;i<num_nodes_delivery-1;i++){
         float x_slope_delivery = delivery[i+1].xf() - delivery[i].xf();
         float y_slope_delivery = delivery[i+1].yf() - delivery[i].yf();
    
         if(x_slope_delivery == 0)
              x_directional = 0;
          else if(x_slope_delivery > 0)
              x_directional = 1;
          else if(x_slope_delivery < 0)
              x_directional = -1;
         
          if(y_slope_delivery == 0)
              y_directional = 0;
          else if(y_slope_delivery > 0)
              y_directional = 1;
          else if(y_slope_delivery < 0) 
              y_directional = -1;
          
          if (abs(x_directional*y_directional) == 0){
              while(abs(x_pos - delivery[i+1].xf()) > diff_tolerance){
              boolean updated = false;
              if(abs(x_pos - delivery[i+1].xf()) > diff_tolerance){
                    x_pos = x_pos + x_slope_delivery/fraction;
                    updated = true;
              }
              if (updated==false) break;                
                
      
                PEV_routes[step][0] = x_pos;
                PEV_routes[step][1] = y_pos;
                step++;
                if (step > 2000) break;
              }
              while(abs(y_pos - delivery[i+1].yf()) > diff_tolerance){
                y_pos = y_pos + y_slope_delivery/fraction;
      
                PEV_routes[step][0] = x_pos;
                PEV_routes[step][1] = y_pos;
                step++;
                if (step > 2000) break;
              }
          } else {
            while(sqrt(pow(x_pos - delivery[i+1].xf(),2) + pow(y_pos - delivery[i+1].yf(),2)) > diff_tolerance){
              boolean updated = false;
              if(abs(x_pos - delivery[i+1].xf()) > diff_tolerance){
                    x_pos = x_pos + x_slope_delivery/fraction;
                    updated = true;
              }
              if(abs(y_pos - delivery[i+1].yf()) > diff_tolerance){
                    y_pos = y_pos + y_slope_delivery/fraction;
                    updated = true;
              }
              if (updated==false) break;


    
              PEV_routes[step][0] = x_pos;
              PEV_routes[step][1] = y_pos;
              step++;
              if (step > 2000) break;
            }
          }
        
       }
       //if (delivery.length > 0){
         PEV_routes[step][0] = delivery[delivery.length-1].xf();
         PEV_routes[step][1] = delivery[delivery.length-1].yf();
       
         //step++;       
       //}
      
      //println(str(step));
      
      
      //println(str(num_nodes_pickup)+"+"+str(num_nodes_delivery)+"="+num_nodes_total);
      
      
      return step;
    }

          
}



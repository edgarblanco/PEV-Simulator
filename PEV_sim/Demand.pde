
BufferedReader reader;
int [][] positions = new int[100][4];
String line;
//int counter = 0;

final double E = 2.7182818284590452353602875; 


int next_release_time_person = 0; //Person
int next_release_time_box = 0; //Box  

////infra-structure
//int [] eligible_x = new int[600];
//int [] eligible_y = new int[600];  

class Demand {
  //GLOBAL VARIABLES  
  int status = 0; //0 = waiting to be pickup
                  //1 = waiting to be delivered
                  //2 = closed
  int k = 0;
  float speed = 1;
  //next_release_time[0];

  
  //CONSTRUCTOR (run just once)
   Demand(int i) {
      int rnd_node = 0; 
      int rnd_loading = 0; 
      int rnd_unloading = 0; 
      
      // Network
      
//      for (int h=0;h<num_horiz_streets;h++){
//        eligible_y[h] = int(((displayHeight-230 - Y_ORIGN)/num_horiz_streets)*h) + Y_ORIGN;
//      }
//      for (int v=0;v<num_vertical_streets;v++){
//        eligible_x[v] = int(((displayWidth-230 - X_ORIGN)/num_vertical_streets)*v) + X_ORIGN;
//      }
        vec_order_type[i] = int(random(2)); //0 = Person
                                            //1 = Box
        
        if (vec_order_type[i] == 0){ // Person
          vec_release_time[i] = next_release_time_person;
          next_release_time_person = next_release_time_person - int(log(random(1))/(person_arrival_rate/timestamp_standard));
          vec_scheduled_time[i] = vec_release_time[i] + int(random(person_timewindow*0.5 , person_timewindow*1.5));
        }
        if (vec_order_type[i] == 1){ // Box
          vec_release_time[i] = next_release_time_box;
          next_release_time_box = next_release_time_box - int(log(random(1))/(box_arrival_rate/timestamp_standard));
          vec_scheduled_time[i] = vec_release_time[i] + int(random(box_timewindow*0.5 , box_timewindow*1.5));
        }        
        
        rnd_node = int(random(nodes.size()-1));
//        rnd_node = 0;
        Nodes node = (Nodes)nodes.get(rnd_node);
        vec_origin_x[i] = node.lon;
        vec_origin_y[i] = node.lat;
        
        rnd_node = int(random(nodes.size()-1));
        //rnd_node = 3;
        node = (Nodes)nodes.get(rnd_node);
        vec_pickup_x[i] = node.lon;
        vec_pickup_y[i] = node.lat;
        
        rnd_node = int(random(nodes.size()-1));
        //rnd_node = 0;
        node = (Nodes)nodes.get(rnd_node);
        vec_delivery_x[i] = node.lon;
        vec_delivery_y[i] = node.lat;
        //println((node.lat));

        
        vec_order_status_pickup[i] = 0;
        vec_order_status_delivery[i] = 0;
        
        rnd_loading = int(random(4,5));
        vec_loading_time[i] = rnd_loading;

        rnd_unloading = int(random(4,5));
        vec_unloading_time[i] = rnd_unloading;

        


   } 
  
  //FUNCTIONS
  void cancelation(int ID){
    vec_order_status_delivery[ID] = 1;
    vec_order_status_canceled[ID] = 1;
  }
  
  void display(int ID, float x_pickup, float y_pickup, float x_delivery, float y_delivery, int status_pickup, int status_delivery, int type_delivery) {
      noStroke();
      ScreenPosition pos_Demand_pickup = map.getScreenPosition(new Location(y_pickup, x_pickup));
      ScreenPosition pos_Demand_delivery = map.getScreenPosition(new Location(y_delivery, x_delivery));

      if ((status_pickup == 0) && (vec_release_time[ID] < TNOW)){
        fill(0, 0, 0, 90);
        //adjust_position(ID,x_pickup,y_pickup);
        
        //javax.swing.JOptionPane.showMessageDialog(null, "X:"+x_pickup);
        if (type_delivery == 1){
          fill(255, 255, 0, 200);
          if (vec_assigned_PEV[ID] == 1) {
            ellipse(pos_Demand_pickup.x, pos_Demand_pickup.y, k*speed*3, k*speed*3);
          } else {
            ellipse(pos_Demand_pickup.x, pos_Demand_pickup.y, 6, 6);
          }
        } else {
          // rect(pos_Demand_pickup.x - k*speed/2, pos_Demand_pickup.y - k*speed/2, k*speed, k*speed);
          fill(200, 0, 0, 200);
          if (vec_assigned_PEV[ID] == 1) {
            ellipse(pos_Demand_pickup.x, pos_Demand_pickup.y, k*speed*3, k*speed*3);
          } else {
            ellipse(pos_Demand_pickup.x, pos_Demand_pickup.y, 6, 6);
          }
        }
        fill(233, 57, 35);
        //text(ID, pos_Demand_pickup.x, pos_Demand_pickup.y);
        //text(x_pickup, pos_Demand_pickup.x, pos_Demand_pickup.y+5);
        //text(y_pickup, pos_Demand_pickup.x, pos_Demand_pickup.y+15);
      }
      
//      if ((status_delivery == 0)&& (vec_release_time[ID] < TNOW)){
//        fill(255, 0, 0, 50);
//        if (type_delivery == 1){
//          ellipse(pos_Demand_delivery.x, pos_Demand_delivery.y, k*speed, k*speed);
//        } else {
//          rect(pos_Demand_delivery.x - k*speed/2, pos_Demand_delivery.y - k*speed/2, k*speed, k*speed);
//        }
//        fill(255, 0, 0);
//        text(ID, pos_Demand_delivery.x, pos_Demand_delivery.y);      
//        //text(x_delivery, pos_Demand_delivery.x, pos_Demand_delivery.y+5);      
//        //text(y_delivery, pos_Demand_delivery.x, pos_Demand_delivery.y+15);      
//      }
      
      if (k==10) k=0; else k++;      
    }
  
//   void adjust_position(int ID, int x_pickup, int y_pickup){
//      int slope_temp=0, slope=9999;
//      int slope_idx = 0;
//      
//      for (int v=0;v<num_vertical_streets;v++){
//        slope_temp = abs(x_pickup - eligible_x[v]);
//        if (slope_temp < slope) {
//         slope = slope_temp;
//         slope_idx = v; 
//        }
//      }
//      //print("("+str(x_pickup)+"-"+str(slope)+"-"+str(slope_idx)+")");
//
//   }
 
// void read_demand(){
//   reader = createReader("positions.txt"); 
//   try
//     {
//      line = reader.readLine();
//     } 
//   catch (IOException e) 
//    {
//      e.printStackTrace();
//      line = null;
//    }
//   if(line != null)
//      { 
//      int []nums= int(split(line,','));
//      vec_pickup_x[counter] = nums[0];
//      vec_pickup_y[counter] = nums[1];
//      vec_delivery_x[counter] = nums[2];
//      vec_delivery_y[counter] = nums[3];
//      vec_order_type[counter] = nums[4];
//      vec_order_status_pickup[counter] = 0;
//      vec_order_status_delivery[counter] = 0;
//    
//      counter++;
//      }
// 
//   
// }
  
}

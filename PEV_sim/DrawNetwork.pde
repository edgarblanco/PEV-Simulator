PrintWriter output;
PrintWriter output2;
PrintWriter output3;

class DrawNetwork{
  //Globals
  int x_scale = 80;
  int y_scale = 50;
  int graphNo = 0;
  float nodeSize = 1.0f;
  long time;
  //nodeSize = 12.0f;
  //Pathfinder
  ////Graph gs2 = new Graph();
  int start;
  int end;
  //Constructor


  //Functions
    
    void show_coordinates(){

      fill(0);
      PFont f = createFont("TruetypewritterPolyglOTT", 10);
      for(int i=0 ;i < 18; i++){
          for(int j=0 ;j < 14; j++){
            text("x", i*x_scale+X_ORIGN, j*y_scale+Y_ORIGN);
            text("("+str(i*x_scale+X_ORIGN)+"-"+str(j*y_scale+Y_ORIGN)+")", i*x_scale+X_ORIGN, j*y_scale+Y_ORIGN+10);
          }
      }
    }
    //Pathfinder
      
      void usePathFinder(IGraphSearch pf, GraphNode start, GraphNode end){
        time = System.nanoTime();
        pf.search(start.id(), end.id(), true);
        time = System.nanoTime() - time;
        rNodes = pf.getRoute();
        exploredEdges = pf.getExaminedEdges();
      }
      
      IGraphSearch makePathFinder(Graph graph, int pathFinder){
        IGraphSearch pf = null;
        float f = (graphNo == 2) ? 2.0f : 1.0f;
        switch(pathFinder){
//        case 0:
//          pf = new GraphSearch_DFS(gs[graphNo]);
//          break;
//        case 1:
//          pf = new GraphSearch_BFS(gs[graphNo]);
//          break;
        case 2:
          pf = new GraphSearch_Dijkstra(graph);
          break;
        case 3:
          pf = new GraphSearch_Astar(graph, new AshCrowFlight(f));
          break;
//        case 4:
//          pf = new GraphSearch_Astar(gs[graphNo], new AshManhattan(f));
//          break;
        }
        return pf;
      }
      

      void drawArrow(GraphNode fromNode, GraphNode toNode, float nodeRad, float arrowSize){
        float fx, fy, tx, ty;
        float ax, ay, sx, sy, ex, ey;
        float awidthx, awidthy;
      
        fx = fromNode.xf();
        fy = fromNode.yf();
        tx = toNode.xf();
        ty = toNode.yf();
      
        float deltaX = tx - fx;
        float deltaY = (ty - fy);
        float d = sqrt(deltaX * deltaX + deltaY * deltaY);
      
        sx = fx + (nodeRad * deltaX / d);
        sy = fy + (nodeRad * deltaY / d);
        ex = tx - (nodeRad * deltaX / d);
        ey = ty - (nodeRad * deltaY / d);
        ax = tx - (nodeRad + arrowSize) * deltaX / d;
        ay = ty - (nodeRad + arrowSize) * deltaY / d;
      
        awidthx = - (ey - ay);
        awidthy = ex - ax;
      
        noFill();
        strokeWeight(4.0f);
        stroke(160, 128);
        line(sx,sy,ax,ay);
      
        noStroke();
        fill(48, 128);
        beginShape(TRIANGLES);
        vertex(ex, ey);
        vertex(ax - awidthx, ay - awidthy);
        vertex(ax + awidthx, ay + awidthy);
        endShape();
       }
       
      void drawNodes(float nside){
        pushStyle();
        noStroke();
        //fill(255,0,255,72);
        for(GraphNode node : gNodes){
          //Location loc_node = new Location(float(node.xf()),float(node.yf()));
          ScreenPosition pos = map.getScreenPosition(new Location(node.xf(),node.yf()));
          text(node.id(),pos.x,pos.y);
          ellipse(pos.x,pos.y, nside, nside);
        }
        popStyle();
      }
      
      void drawEdges(GraphEdge[] edges, float wheel_state, int lineCol, float sWeight, boolean arrow){
        if(edges != null){
          pushStyle();
          noFill();
          stroke(lineCol);
          strokeWeight(sWeight);
          for(GraphEdge ge : edges){
            if(arrow)
              drawArrow(ge.from(), ge.to(), nodeSize / 2.0f, 6);
            else {
              ScreenPosition pos_from = map.getScreenPosition(new Location(ge.from().xf(),ge.from().yf()));
              ScreenPosition pos_to = map.getScreenPosition(new Location(ge.to().xf(),ge.to().yf()));
              line(pos_from.x, pos_from.y, pos_to.x, pos_to.y); 
            }
          }
          popStyle();
        }
      }
   
      void drawRoute(GraphNode[] r, int lineCol, float sWeight){
        if(r.length >= 2){
          pushStyle();
          stroke(lineCol);
          strokeWeight(sWeight);
          noFill();
          for(int i = 1; i < r.length; i++){
            ScreenPosition pos_line_from = map.getScreenPosition(new Location(r[i-1].xf(), r[i-1].yf()));
            ScreenPosition pos_line_to = map.getScreenPosition(new Location(r[i].xf(), r[i].yf()));
            line(pos_line_from.x, pos_line_from.y, pos_line_to.x, pos_line_to.y);
          }
          // Route start node
          strokeWeight(1.0f);
          stroke(0,0,160);
          fill(0,0,255);
          ScreenPosition pos = map.getScreenPosition(new Location(r[0].xf(), r[0].yf()));
          ellipse(pos.x, pos.y, nodeSize, nodeSize);
          // Route end node
          stroke(160,0,0);
          fill(255,0,0);
          pos = map.getScreenPosition(new Location(r[r.length-1].xf(), r[r.length-1].yf()));
          ellipse(pos.x, pos.y, nodeSize, nodeSize); 
          popStyle();
        } 
  }
  
  void create_network_streets(String csv_file_name){
        Table table = loadTable(csv_file_name,"header");
        int idx_node = 0;
        
        for (TableRow row : table.rows()){
            boolean repeated = false;
            float street_id = row.getFloat("id");
            for (Streets street : streets){
                if (street.id == street_id){
                    repeated = true;
                }
            }
            if (repeated == false){
              Streets street = new Streets();
              street.id = (long)street_id;
              streets.add(street);
            }
        }
        
        for (TableRow row : table.rows()){
          float street_id = row.getFloat("id");
          for (Streets street : streets){
            if (street.id == street_id){
              float lat = row.getFloat("Y");
              float lon = row.getFloat("X");
              
              Nodes node = new Nodes();
              //location of events
              node.id = idx_node;
              idx_node++;
              Location location = new Location(lat, lon);
              node.location = location;
              node.lat = lat;
              node.lon = lon;
              node.street_id = (long)street_id; 
              street.nodes.add(node);
            }
          }
        }
        
        //FIX with TSP - Start
        for (Streets street : streets){
          if (street.nodes.size()>1){
              float [][] adj_mat = new float[street.nodes.size()][street.nodes.size()];
              for(int i=0;i<street.nodes.size();i++)
                  for(int j=0;j<street.nodes.size();j++)
                        adj_mat[i][j] = adj_mat[j][i] = (float)(distFrom(street.nodes.get(i),street.nodes.get(j))*2000);
                          
    //             for(int i=0;i<street.nodes.size();i++){
    //                for(int j=0;j<street.nodes.size();j++)
    //                    print(adj_mat[i][j] + " ");
    //                println(" ");
    //             }
    
              TSP_NN tspNN = new TSP_NN();
              tspNN.tsp(adj_mat,3);
             
    //          println("-------------------- ");
    //          for(int node:shortest_path)
    //            print(node + " ");
             
              Streets street_temp = new Streets();   
              street_temp.id = street.id;
              for(int node:shortest_path){
               //javax.swing.JOptionPane.showMessageDialog(null, "Node:"+str(street_temp.nodes.size()));
               street_temp.nodes.add(street.nodes.get(node));
               //javax.swing.JOptionPane.showMessageDialog(null, "Node:"+str(street_temp.nodes.size()));
              }  
              street.nodes = street_temp.nodes;
          }
        }
//        println("-------------------- ");
//       for(Streets street: streets)
//         {
//          for(Nodes node:street.nodes)
//            print(node.id + " ");
//           println();
//         }
      
      
      //FIX with TSP - Finish 
      for (Streets st1 : streets){
        for(Nodes nd1 : st1.nodes){
           for (Streets st2 : streets){
             for(Nodes nd2 : st2.nodes){
               if ((nd1.lat == nd2.lat)&&(nd1.lon == nd2.lon)&&(st1.id != st2.id)){
                 st1.is_connected++;
                 st2.is_connected++;
                 break;
               }
           }
         } 
        }
      }
      println("_________________________________");
      for (Streets st1 : streets){
          println("ID: " +st1.id + " -> Conn: "+st1.is_connected);
      }
      
      for (Streets street : streets){
        if(street.is_connected > 9 ){
          Nodes curr = null;
          for (Nodes node : street.nodes){
              nodes.add(node);
              if (curr != null) {
  
                
                Edges edge = new Edges();
                edge.origin = curr;
                edge.destination = node;
                edge.forward_cost = distFrom(curr, node);
                edge.backward_cost = distFrom(node, curr);
                edges.add(edge);
  //
  //              Edges edge2 = new Edges();
  //              edge2.origin = node;
  //              edge2.destination = curr;
  //              edge2.forward_cost = euc_dist(curr, node)*30;
  //              edge2.backward_cost = euc_dist(node, curr)*30;
  //              edges.add(edge2);
              }
              curr = node;
          }
        }
      
      }
      //if (fix_nodes_on == true) fix_nodes();
      PrintWriter output_edge, output_node;
      output_edge = createWriter("edge_list.txt");
      for (Edges edge:edges){
         //javax.swing.JOptionPane.showMessageDialog(null, edges.size());
         output_edge.println(edge.origin.id + " " + edge.destination.id+ " " + edge.forward_cost+ " " + edge.backward_cost); 
      }
      output_edge.close();
      output_node = createWriter("node_list.txt");
      for (Nodes node:nodes){
         output_node.println(node.id + " " + node.lat+ " " + node.lon+ " " + node.street_id); 
      }
      output_node.close(); 

  }
  public double dist(Nodes a, Nodes b){
     return sqrt((float) ( (a.lat-b.lat)*(a.lat-b.lat) + (a.lon-b.lon)*(a.lon-b.lon) ));
  }

  void create_network(String csv_file_name){
    
       Table table = loadTable(csv_file_name,"header");
       String temp;
       int idx_node = 0;
       int idx_temp = 0;
       float lat_temp = 0;
       float lon_temp = 0;
       float street_id_temp = 0;
       
       for (TableRow row : table.rows()){
            float lat = row.getFloat("Y");
            float lon = row.getFloat("X");
            float street_id = row.getFloat("id");
            
            for (Nodes node : nodes){
              //if((abs(lat - node.lat) <= tolerance) && (abs(lon - node.lon) <= tolerance)&& (street_id == node.street_id)){
              if((abs(lat - node.lat) <= tolerance) && (abs(lon - node.lon) <= tolerance)){
                  idx_temp = node.id;
                  lat_temp = node.lat;
                  lon_temp = node.lon;
                  //street_id_temp = node.street_id; 
              }
            }
            
            
            //create new empty object to store data
            Nodes node = new Nodes();
            //location of events
            Location location = new Location(lat, lon);
            node.location = location;
            node.lat = lat;
            node.lon = lon;
            node.street_id = street_id;
            if (idx_temp == 0){
                node.id = idx_node;
                idx_node++;
            } else {
                node.id = idx_temp;
                node.lat = lat_temp;
                node.lon = lon_temp;
                //node.street_id = street_id_temp;
                idx_temp = 0;
                lat_temp = 0;
                lon_temp = 0;
                //street_id_temp = 0;
            }       
            // Add to list of all events
            //javax.swing.JOptionPane.showMessageDialog(null, "Lat:"+str(lat)+"Location.y:"+(location.y));
            nodes.add(node);
            
            //node_list.add(nodeID); 
            //println(node.id +" " + node.lat + " -  " + node.lon);
       }
       /////// Fixing distances between nodes - START
       
       /////// Fixing distances between nodes - END
      
      Nodes curr = null;
      for (Nodes next : nodes) {
        if (curr != null) {
          //if ((curr.street_id == next.street_id)&&(curr.id != next.id)&&(euc_dist(curr, next)*30 < 0.2)){
          if ((curr.street_id == next.street_id)&&(curr.id != next.id)){
              int origin;
              int destination;
              
              Edges edge = new Edges();
              edge.origin = curr;
              edge.destination = next;
              edge.forward_cost = distFrom(curr, next);
              edge.backward_cost = distFrom(next, curr);
              edges.add(edge);

              Edges edge2 = new Edges();
              edge2.origin = next;
              edge2.destination = curr;
              edge2.forward_cost = distFrom(curr, next);
              edge2.backward_cost = distFrom(next, curr);
              edges.add(edge2);
              
          }
        }
        curr = next;
      }

//      for(Nodes node:nodes)
//          print(str(node.id) + " ");
//      println(" ");
      //javax.swing.JOptionPane.showMessageDialog(null, nodes.size());
      Set<Integer> nodes_id = new HashSet<Integer>();
      for (Nodes next : nodes) {
           nodes_id.add(next.id);
      }
//      for(int node_temp:nodes_id)
//          print(str(node_temp) + " ");
//      //javax.swing.JOptionPane.showMessageDialog(null, " ");
//      println(" ");

      
      ArrayList<Nodes> nodes_temp = new ArrayList();
      
      for (Integer node_temp : nodes_id) {
          for (Nodes next : nodes) {
            if(next.id == node_temp){
                  nodes_temp.add(next);
                  node_list.add(next.id);
                  break;
            }
          }
//          Nodes myNode = (Nodes)nodes.get(node_temp);
//          nodes_temp.add(myNode);
//          node_list.add(myNode.id);
          
      }
//      for(Nodes node_temp2:nodes_temp)
//          print(str(node_temp2.id) + " ");
      nodes.clear(); 
      nodes = nodes_temp;

      //javax.swing.JOptionPane.showMessageDialog(null, edges.size());
      if (fix_nodes_on == true) fix_nodes();
      //javax.swing.JOptionPane.showMessageDialog(null, edges.size());
      PrintWriter output_edge, output_node;
      output_edge = createWriter("edge_list.txt");
      for (Edges edge:edges){
         //javax.swing.JOptionPane.showMessageDialog(null, edges.size());
         output_edge.println(edge.origin.id + " " + edge.destination.id+ " " + edge.forward_cost+ " " + edge.backward_cost); 
      }
      output_edge.close();
      output_node = createWriter("node_list.txt");
      for (Nodes node:nodes){
         output_node.println(node.id + " " + node.lat+ " " + node.lon+ " " + node.street_id); 
      }
      output_node.close();      

  
  } 
  
  
float euc_dist(Nodes x, Nodes y) {
   return sqrt(pow((x.lat-y.lat),2) + pow((x.lon-y.lon),2));
   }

  
  void makeGraphFromCSV(Graph g){
        int nodeID;
        float x,y, z = 0;
        for (Nodes node : nodes) {
            nodeID = node.id;
            x = node.lon;
            y = node.lat; 
            //javax.swing.JOptionPane.showMessageDialog(null, "Node: "+nodeID+" X: "+x+" Y: "+y);
            g.addNode(new GraphNode(nodeID, y, x, z));//Proposital changed given the lat information goes to X in the Graph (not in the class)
        }
        
        for (Edges edge : edges) {
          int fromID, toID;
          float costOut = 0, costBack = 0;
          
          // Convert geo locations to screen positions
          Nodes origin = new Nodes();
          Nodes destination = new Nodes();
          
          origin = edge.origin;
          destination = edge.destination;
          //javax.swing.JOptionPane.showMessageDialog(null, " Origin: ID"+edge.origin.id+"Lat:"+edge.origin.lat+" Destination: ID"+edge.destination.id+" Lat"+edge.destination.lat);
          
          fromID = origin.id;
          toID = destination.id;
          costOut = edge.forward_cost;
          costBack = edge.backward_cost;
          g.addEdge(fromID, toID, costOut);
          g.addEdge(toID, fromID, costBack);  
        }
  
  }
    
   void fix_nodes(){
      int [][]temp_neighbour_mat = new int [nodes.size()][nodes.size()];
      int [][]new_edges = new int[100000][4];
      int new_edge_count=0, temp_label=0, node_no=5;
     
      for (Edges edge : edges){
        temp_neighbour_mat[edge.origin.id][edge.destination.id] = 1;
      }
      for (int i=0;i<nodes.size();i++){
        for (int j=0;j<nodes.size();j++){
          if(temp_neighbour_mat[i][j] != 1)
              temp_neighbour_mat[i][j] = 0;
//          print(temp_neighbour_mat[i][j] + " ");
        }
//        println(" ");
      }
//      println("----------------------------------------");
      BFS bfs = new BFS();
     
      int []list = new int[nodes.size()];
      int no_nodes,label=0,next=0;
      int []labels = new int[nodes.size()];
      Set<Integer> lab_node_list = new HashSet<Integer>();
      Set<Integer> unlab_node_list = new HashSet<Integer>();
      Iterator iterator;
      no_nodes = bfs.bfs(temp_neighbour_mat, 0,list);
//      for(int i=0;i<no_nodes;i++)
//        print(list[i] + " ");
//      println(" ");
//        println("Nodes disconnected: "+no_nodes);
        
      while ( lab_node_list.size() < nodes.size() ) {
            for(int i=0;i<no_nodes;i++) {
               lab_node_list.add(list[i]);
               labels[list[i]] = label;
            }
            
            label++;
//            print("\nlabel:\n");
//            for(int i=0;i<nodes.size();i++)
//                print(labels[i] + " ");
//            print("\n node list: \n");
//            for(int ele:node_list)
//                print(ele + " ");
//            print("\n lab node list: \n");
//            for(int ele:lab_node_list)
//                print(ele + " ");   
            unlab_node_list = symmetricDifference(node_list,lab_node_list);
//            print("\n unlab node list: \n");
//            for(int ele:unlab_node_list)
//                print(ele + " ");
            iterator = unlab_node_list.iterator();
            if(iterator.hasNext())
                next =(Integer)iterator.next();
            else
                break;
            //javax.swing.JOptionPane.showMessageDialog(null, " ");
            no_nodes = bfs.bfs(temp_neighbour_mat, next,list);
          }
//      print("\nlabel:\n");
//      for(int i=0;i<nodes.size();i++)
//          print(labels[i] + " ");
//      println(" ");
//      println("----------------------------------------");
      //adding edges
        //javax.swing.JOptionPane.showMessageDialog(null, no_nodes);
         for(int i=1;i<=nodes.size()-1;i++) 
              if( labels[i] !=labels[i-1] ) {
                    //javax.swing.JOptionPane.showMessageDialog(null, i);
                     new_edges[new_edge_count][0] = i-1;
                     new_edges[new_edge_count][1] = i;
                     new_edges[new_edge_count][2] = new_edges[new_edge_count][3] = 1;
                     temp_label = labels[i];
                     for(int j=i;j<nodes.size();j++)
                         {  
                           if(labels[j] == temp_label)
                             labels[j] = labels[i-1];
                         }
                     new_edge_count++;
                   }             
                 
        //printing new edges
        //println("\n");
//        println("New Edges");
//        javax.swing.JOptionPane.showMessageDialog(null, new_edge_count);
//        for(int i=0;i<new_edge_count;i++){
//          for(int j=0;j<4;j++)
//              print(new_edges[i][j] + " ");
//            print("\n");}     
          
          
          
          Nodes origin = new Nodes();
          Nodes destination = new Nodes();
          
          for (int i=0;i<new_edge_count;i++){
            for (Nodes node : nodes) {
              if (node.id == new_edges[i][0]){
                    origin = node;
              }
              if (node.id == new_edges[i][1]){
                    destination = node;
              }  
            }
            Edges edge = new Edges();
            edge.origin = origin;
            edge.destination = destination;
            edge.forward_cost = distFrom(origin, destination);
            edge.backward_cost = distFrom(destination, origin);
            edges.add(edge);
          }
       
  }
  Set<Integer> symmetricDifference(Set<Integer> a, Set<Integer> b) {
      Set<Integer> result = new HashSet<Integer>(a);
      for (Integer element : b) {
           if (!result.add(element)) 
              result.remove(element);        
          }
      return result;
   }
   
    float distFrom(Nodes A, Nodes B) {
      
      float lat1 = A.lat;
      float lng1 = A.lon;
      float lat2 = B.lat;
      float lng2 = B.lon;
      double earthRadius = 6371000; //meters
      double dLat = Math.toRadians(lat2-lat1);
      double dLng = Math.toRadians(lng2-lng1);
      double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                 Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                 Math.sin(dLng/2) * Math.sin(dLng/2);
      double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
      float dist = (float) (earthRadius * c);
  
      return dist;
    }

 

  
}

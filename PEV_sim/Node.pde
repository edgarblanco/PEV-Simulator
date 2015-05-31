import java.util.*;

class Node
  {
  int index,x_pos,y_pos;
  Set neighbours = new HashSet();
  
  int nothing_goes=1,direct_found=0;
  int []path_found = new int[NUM_NODES];
  Set<Integer> temp = new HashSet<Integer>();
  Set<Integer> final_link = new HashSet<Integer>();
  Set<Integer> not_checked_indices = new HashSet<Integer>();
    
   //Pathfinder
   void makeGraphFromFile(Graph g, String fname){
    String lines[];
    lines = loadStrings(fname);
    int mode = 0;
    int count = 0;
    while(count < lines.length){
      lines[count].trim();
      if(!lines[count].startsWith("#") && lines[count].length() > 1){
        switch(mode){
        case 0:
          if(lines[count].equalsIgnoreCase("<nodes>"))
            mode = 1;
          else if(lines[count].equalsIgnoreCase("<edges>"))
            mode = 2;
        break;
        case 1:
          if(lines[count].equalsIgnoreCase("</nodes>"))
            mode = 0;
          else 
            makeNode(lines[count], g);
        break;
        case 2:
          if(lines[count].equalsIgnoreCase("</edges>"))
            mode = 0;
          else
            makeEdge(lines[count], g);
         break;
        } // end switch
      } // end if
     count++;
    } // end while
  }
  
  
  void makeNode(String s, Graph g){
    int nodeID;
    float x,y, z = 0;
    String part[] = split(s, " ");
    if(part.length >= 3){
      nodeID = Integer.parseInt(part[0]);
      x = Float.parseFloat(part[1]);
      y = Float.parseFloat(part[2]);
      if(part.length >=4)
        z = Float.parseFloat(part[3]);
      g.addNode(new GraphNode(nodeID, x, y, z));
    }
  }
  
  
  void makeEdge(String s, Graph g){
    int fromID, toID;
    float costOut = 0, costBack = 0;
    String part[] = split(s, " ");
    if(part.length >= 3){
      fromID = Integer.parseInt(part[0]);
      toID = Integer.parseInt(part[1]);
      try{
        costOut = Float.parseFloat(part[2]);
      }
      catch(Exception excp){
        costOut = -1;
      }
      try{
        costBack = Float.parseFloat(part[3]);
      }
      catch(Exception excp){
        costBack = -1;
      }
      if(costOut >= 0)
        g.addEdge(fromID, toID, costOut);
      if(costBack >= 0)
        g.addEdge(toID, fromID, costBack);  
    }
  }  
}
  

import toxi.processing.*;
import toxi.geom.*;
import toxi.math.*;
import java.util.*;
import pathfinder.*;
import processing.opengl.*;

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.mapdisplay.MapDisplayFactory;


//Key System Parameters
float person_arrival_rate = 200/60/60; //# orders per second
float box_arrival_rate = 2/60/60; //# orders per second
static final private int PEV_FLEET_SIZE = 4;

//Key Animation Settings
float timestamp_standard = 60; //number of "real life" seconds that each frame represent in the simulation

//Simulation Colors
color PEV_INTERIOR_COLOR = color(96,96,96);//grey
color PEV_IDLE_COLOR = color(28,255,0,100); //green
color PEV_ASSIGNED_COLOR = color(255,255,0,100); //yellow
color PEV_BUSY_COLOR = color(204,0,0,100); //red
color PATH_ASSIGNED_COLOR = color(255,255,0,200); //yellow
color PATH_BUSY_COLOR = color(204,0,0,200); //red
color PERSON_WAITING_COLOR = color(51,153,255,100); //blue
color PERSON_ASSIGNED_COLOR = color(0,0,255,100); //blue
color BOX_WAITING_COLOR = color(204,153,255,100); //purple
color BOX_ASSIGNED_COLOR = color(153,51,255,100); //purple

//Globals
static final private int ORDER_SIZE = 100;

static final private int X_ORIGN = 150;
static final private int Y_ORIGN = 150;
static final private int X_LAST = 1370;
static final private int Y_LAST = 670;
static final private int NUM_NODES = 16;
static final private int STANDARD_DISTANCE = 10; //meters

//
////MIT
//static final private String place_name = "Boston - MIT";
//static final private float bbox_left = -71.1276;
//static final private float bbox_right = -71.0424;
//static final private float bbox_top = 42.3803;
//static final private float bbox_bottom = 42.3462;
//Nantes
static final private String place_name = "Nantes";
static final private float bbox_left = -1.60343;
static final private float bbox_right = -1.52757;
static final private float bbox_top = 47.2316;
static final private float bbox_bottom = 47.2061;
//Sao Caetano
//static final private String place_name = "Sao Caetano";
//static final private float bbox_left = -46.619;
//static final private float bbox_right = -46.4606;
//static final private float bbox_top = -23.5896;
//static final private float bbox_bottom = -23.6613;


boolean is_paused = true;
boolean is_under_draw = false;
boolean fix_nodes_on = true;

float wheel_state=1;

PImage bg;

//int step_count=0;
//int [][]gen_path = new int [1000][2];

float inc = 0;
int num_pev = PEV_FLEET_SIZE;
int current_order = 0;
int num_orders = 0;
float TNOW = 0;
float LAST_TNOW = 0;


ArrayList PEVCollection;
ArrayList DemandCollection;

int [] vec_release_time = new int[ORDER_SIZE];
int [] vec_scheduled_time = new int[ORDER_SIZE];
int [] vec_allocation_time = new int[ORDER_SIZE];
int [] vec_delivery_time = new int[ORDER_SIZE];
int [] vec_pickup_time = new int[ORDER_SIZE];
int [] vec_assigned_PEV = new int[ORDER_SIZE];
float [] vec_origin_x = new float[ORDER_SIZE];
float [] vec_origin_y = new float[ORDER_SIZE];
float [] vec_pickup_x = new float[ORDER_SIZE];
float [] vec_pickup_y = new float[ORDER_SIZE];
float [] vec_delivery_x = new float[ORDER_SIZE];
float [] vec_delivery_y = new float[ORDER_SIZE];
int [] vec_order_type = new int[ORDER_SIZE];
int [] vec_order_status_allocation = new int[ORDER_SIZE];
int [] vec_order_status_pickup = new int[ORDER_SIZE];
int [] vec_order_status_delivery = new int[ORDER_SIZE];
int [] vec_order_status_canceled = new int[ORDER_SIZE];
int [] vec_loading_time = new int[ORDER_SIZE];
int [] vec_unloading_time = new int[ORDER_SIZE];

int [] vec_PEV_order_allocated = new int[PEV_FLEET_SIZE];
float [] vec_PEV_carry_time = new float[PEV_FLEET_SIZE];
float [] vec_PEV_alloc_time = new float[PEV_FLEET_SIZE];
float [] vec_PEV_wait_time = new float[PEV_FLEET_SIZE];
float [] vec_PEV_distance = new float[PEV_FLEET_SIZE];
float [] vec_PEV_num_deliveries = new float[PEV_FLEET_SIZE];
float [] vec_PEV_num_deliveries_ontime = new float[PEV_FLEET_SIZE];
float [] vec_PEV_num_pickup = new float[PEV_FLEET_SIZE];
float [] vec_PEV_num_pickup_ontime = new float[PEV_FLEET_SIZE];
boolean [] vec_PEV_has_path = new boolean[PEV_FLEET_SIZE];


float person_timewindow = 10; //# seconds
float box_timewindow = 10; //# seconds

int PEV_speed = 3; //meters per second
float base_time = (float)PEV_speed/(float)STANDARD_DISTANCE; //meters

//Declare class
PEV myPEV;
Demand myDemand;
Statistics myStatistics;
DrawNetwork myNetWork;
MercatorMap mercatorMap;
UnfoldingMap map;

Location boundTopLeft = new Location(bbox_top, bbox_left);
Location boundBottomRight = new Location(bbox_bottom, bbox_right);

ArrayList<Nodes> nodes = new ArrayList();    //2 arraylists for points in 2 areas
ArrayList<Edges> edges = new ArrayList();    //2 arraylists for points in 2 areas
ArrayList<Streets> streets = new ArrayList();    //2 arraylists for points in 2 areas
ArrayList<Integer> shortest_path = new ArrayList<Integer>();
Set<Integer> node_list = new HashSet<Integer>();
float tolerance = 0.0001f;  // Tolerance for grouping nodes

////Pathfinder
Graph gs2 = new Graph();
GraphNode[] gNodes, rNodes;
//GraphNode[] rNodes_init_pickup, rNodes_pickup_delivery;
GraphEdge[] gEdges, exploredEdges;
IGraphSearch pathFinder;
//GraphNode initialNode, pickupNode, deliveryNode;
//int start;
//int end;
PImage img;

//Timer timer = new Timer("Test Timer");

void setup(){
  //size(800,600,OPENGL);
  size(displayWidth, displayHeight);
  img = loadImage("mit_logo_0.png");
  //frameRate(10);
  
  
  DrawNetwork myNetWork = new DrawNetwork();
  //myNetWork.create_network_streets("Nantes_Better.csv");
  //myNetWork.create_network_streets("MIT3_4.csv");
  //myNetWork.create_network_streets("Boston.csv");
  myNetWork.create_network("Nantes_Better.csv");
  //myNetWork.create_network("Boston.csv");
  //myNetWork.create_network("Nantes.csv");
  //myNetWork.create_network("Sao_Caetano.csv");
  myNetWork.makeGraphFromCSV(gs2);
  gNodes =  gs2.getNodeArray();
  gEdges = gs2.getAllEdgeArray();
  gs2.compact();
  //String mbTilesString = sketchPath("maps/blank-1-3.mbtiles");
  //map = new UnfoldingMap(this, new AcetateProvider.Foreground());
  //map = new UnfoldingMap(this, new CartoDB.DarkMatter());
  map = new UnfoldingMap(this);
  //map = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());
  //map = new UnfoldingMap(this, new Google.GoogleSimplifiedProvider());
  //map = new UnfoldingMap(this, new EsriProvider.WorldGrayCanvas());
  //MIT
  //Location mitCampus = new Location(42.3594f, -71.0852f);
  //Nantes
  Location mapCenterLocation = new Location(47.217402f, -1.553677f);
  //Sao Caetano
  //Location mapCenter = new Location(-23.6613f, -46.619f);
  MapUtils.createDefaultEventDispatcher(this, map);

  float maxPanningDistance = 5; //Restricted panning in kilometers 0=no movement allowed
  map.setZoomRange(13, 18); //Restricted zooming a=b  no zoom allowed
  map.zoomAndPanTo(mapCenterLocation, 14);
  map.setPanningRestriction(mapCenterLocation, maxPanningDistance);  
  //checkBoundingBox();
  
  //Initialize class 
  //PEV(initialX, initialY)
  PEVCollection = new ArrayList();
  DemandCollection = new ArrayList();
  
  TNOW = 0;
  LAST_TNOW = 0;

  for(int i=0; i < ORDER_SIZE; i++){
    Demand myDemand = new Demand(i);
    //myDemand.read_demand();
    DemandCollection.add(myDemand);
  }    
  
  //Initialize the PEVs
  for(int i=0; i < PEV_FLEET_SIZE; i++){
    ScreenPosition pos_origin_PEV = map.getScreenPosition(new Location(vec_origin_y[0], vec_origin_x[0]));
    Vec3D vec_origin = new Vec3D(pos_origin_PEV.x,pos_origin_PEV.y,0);
    PEV myPEV = new PEV(vec_origin);
    //javax.swing.JOptionPane.showMessageDialog(null, "Lat: "+vec_origin_y[0]+"Lon: "+vec_origin_x[0]);
    myPEV.lat = vec_origin_y[i];
    myPEV.lon = vec_origin_x[i];
    PEVCollection.add(myPEV);
    vec_PEV_order_allocated[i] = -1;
    vec_PEV_has_path[i] = false;
  }

  
  //timer.scheduleAtFixedRate(new Output(),1,10000);
}




void draw(){
  is_under_draw = true;
  background(255);
  //println("Frame Rate:"+frameRate+"Seconds:"+(float)frameCount/(float)frameRate+"TNOW: "+TNOW);
  //tint(255, 127);

  fill(0,100);
  rect(0, 0, width, height);
  //noStroke();
  DrawNetwork myNetWork = new DrawNetwork();
  tint(255, 255);
  map.draw();
  //myNetWork.drawEdges(gEdges, wheel_state, color(0,0,0, 160), 1.0f, false);
   
  //fill(0);
  
  
  //myNetWork.drawNodes(8.0f);
  //myNetWork.show_coordinates();

  // Call class
  for(int i=0; i < num_pev; i++){
      PEV myPEV = (PEV)PEVCollection.get(i);
      if (vec_PEV_order_allocated[i] >= 0){
         //javax.swing.JOptionPane.showMessageDialog(null, myPEV.lat + "-> " + myPEV.lon);
         if (vec_PEV_has_path[i] == false){
             myPEV.find_path(i,vec_PEV_order_allocated[i],vec_pickup_x[vec_PEV_order_allocated[i]], vec_pickup_y[vec_PEV_order_allocated[i]],vec_delivery_x[vec_PEV_order_allocated[i]], vec_delivery_y[vec_PEV_order_allocated[i]]);
             vec_PEV_has_path[i] = true;
         } else {
           myPEV.run(i,vec_PEV_order_allocated[i],vec_pickup_x[vec_PEV_order_allocated[i]], vec_pickup_y[vec_PEV_order_allocated[i]],vec_delivery_x[vec_PEV_order_allocated[i]], vec_delivery_y[vec_PEV_order_allocated[i]]);
         }
      }
  }
    for(int i=0; i < num_pev; i++){
      PEV myPEV = (PEV)PEVCollection.get(i);
      myPEV.display(i);
    }
    
    //TNOW = millis()/1000;
    TNOW = TNOW  + timestamp_standard;
    Statistics myStatistics = new Statistics();
    myStatistics.static_dashboard();
    myStatistics.running_time();
    
    if(LAST_TNOW + 1 < TNOW) {
        LAST_TNOW = TNOW;
        for (int j=0;j<ORDER_SIZE;j++){
            if ((vec_release_time[j] < TNOW) && (vec_order_status_allocation[j] == 0)){
              float eval_distance = 99999.9f;
              int min_vehicle_idx = -1;              
              for(int i=0; i < num_pev; i++){
                  PEV myPEV = (PEV)PEVCollection.get(i);
                  //javax.swing.JOptionPane.showMessageDialog(null, myPEV.lon + "-> " + vec_pickup_x[j]);
                  if((myPEV.status == 0) && (eval_distance > (abs(myPEV.lon - vec_pickup_x[j])+abs(myPEV.lat - vec_pickup_y[j])))){
                    eval_distance = abs(myPEV.lon - vec_pickup_x[j])+abs(myPEV.lat - vec_pickup_y[j]);
                    min_vehicle_idx = i;
                  }
              }
              //javax.swing.JOptionPane.showMessageDialog(null, eval_distance + "-> " + min_vehicle_idx);
              if (min_vehicle_idx != -1) {
                PEV myPEV = (PEV)PEVCollection.get(min_vehicle_idx);
                myPEV.searching_order(min_vehicle_idx,j);
              }
            }
        }
        //if (min_order_idx != -1) myPEV.searching_order(i,min_order_idx);
        //myPEV.searching_order2();
    }
      
    for(int i=0; i < ORDER_SIZE; i++){
      Demand myDemand = (Demand)DemandCollection.get(i);
      
      myDemand.display(i,vec_pickup_x[i],vec_pickup_y[i],vec_delivery_x[i],vec_delivery_y[i],vec_order_status_pickup[i],vec_order_status_delivery[i],vec_order_type[i]);
      if ((vec_order_status_allocation[i] == 0)&&(vec_scheduled_time[i] < int(TNOW))){
          myDemand.cancelation(i);
      }
    }
    
    
    
//    while (is_paused){
//       println("IS PAUSED"); 
//    }

}

class Nodes {
    int id;
    float street_id;
    String locationType;
    float lat;
    float lon;
    float edge;
    Location location;
}

class Streets{
   long id;
   int is_connected = 0;
   ArrayList<Nodes> nodes = new ArrayList();
}

class Edges{
   Nodes origin;
   Nodes destination;
   float forward_cost;
   float backward_cost; 
}

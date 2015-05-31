#!/usr/bin/env python
############################################################################
#
# MODULE:       osm_find_nearby_matches.py
# AUTHOR:       Hamish Bowman, Dunedin, New Zealand
# PURPOSE:      Search a .osm file for nodes within a certain distance of
#                 nodes in another .osm file. i.e. point out near-duplicates.
# COPYRIGHT:    (c) 2010 Hamish Bowman, and the OpenStreetMap Foundation
#
#               This program is free software under the GNU General Public
#               License (>=v2) and comes with ABSOLUTELY NO WARRANTY.
#               See http://www.gnu.org/licenses/gpl2.html for details.
#
#############################################################################
# do not expect this script to be efficient or robust.
# this is hardly tested at all
# TODO:
# ? this will not deal with </node> on a separate line in the new-comer input file
# ? this will not deal with ' as the value quoting char in the new-comer input file
#
# !! Need a second pass over the hits to supress/combine/only report once
#    for each cluster of duplicate hits, &/or to reduce parallel ways to just
#    reporting the way IDs, not every node.
#    In the mean time, if there are more than 8 hits write out a .csv file
#    with the coords for later analysis.
#
# arbitrarily use 100m as the search threshold.
#   export node ID, and URLs to OSM map showing it and OSM db feature webpage
#
# ... run this BEFORE uploading new data ...
#
# Download any existing OSM data for comparison: 
#   URL="http://osmxapi.hypercube.telascience.org/api/0.6"
#   BBOX="157.5,-59.0,179.9,-25.5"
#   wget -O existing_data.osm "$URL/*[leisure=slipway][bbox=$BBOX]"
 
import sys
import os
from math import cos, radians
 
def main():
    input_new = 'MIT3.osm'
    input_established = 'MIT3.osm'
    csv_output= input_new.split('.osm')[-2] + '_matching_nodes.csv'
    #output = 'boatramp_dupe_summary.txt'
    output = 'MIT3_3.txt'
 
    # threshold measured in meters (2.5cm ~ 1")
    threshold_m = 100.0
 
    thresh_lat = threshold_m / (1852. * 60)
    #thresh_lon calc'd per node by cos(node_lat)
 
    #### set up input files
    infile_new = input_new
    if not os.path.exists(infile_new):
        print("ERROR: Unable to read new input data")
        sys.exit(1)
 
    infile_old = input_established
    if not os.path.exists(infile_old):
        print("ERROR: Unable to read established input data")
        sys.exit(1)
    inf_old = file(infile_old)
    print("existing OSM data input file=[%s]" % infile_old)
 
    # read in old file first and build a table of node positions and IDs
    #   node|lon|lat    long|double|double
    # init array
    old_id_lonlat = [[] for i in range(3)]
 
    while True:
        line = inf_old.readline()
        #.strip()
        if not line:
            break
 
        if 'node id=' not in line:
            continue
 
        #bits = line.split('"')
        id_i = line.find('id=') + 4
        lat_i = line.find('lat=') + 5
        lon_i = line.find('lon=') + 5
 
        old_id = line[id_i:].replace('"',"'").split("'")[0]
        old_lat = float(line[lat_i:].replace('"',"'").split("'")[0])
        old_lon = float(line[lon_i:].replace('"',"'").split("'")[0])
 
        old_id_lonlat[0].append(old_id)
        old_id_lonlat[1].append(old_lon)
        old_id_lonlat[2].append(old_lat)
 
    inf_old.close()
 
 
    #### read in new file and build a table of node positions and IDs which have a pair
    # open new-comer file.osm
    inf_new = file(infile_new)
    print("new-comer input file=[%s]" % infile_new)
 
    #   new_node|old_node|lon|lat    long|long|double|double
    # init array
    newid_oldid_lonlat = [[] for i in range(4)]
 
    lines = inf_new.readlines()
 
    for i in range(len(lines)):
        lines[i] = lines[i].rstrip('\n')
 
 
    for line in lines:
        if 'node id=' not in line:
            continue
        #elif line.strip() == '</node>':
        #    continue
        else:
            id_i = line.find('id=') + 4
            lat_i = line.find('lat=') + 5
            lon_i = line.find('lon=') + 5
 
            new_id = line[id_i:].replace('"',"'").split("'")[0]
            new_lat = float(line[lat_i:].replace('"',"'").split("'")[0])
            new_lon = float(line[lon_i:].replace('"',"'").split("'")[0])
 
            thresh_lon = thresh_lat / abs(cos(radians(new_lon)))
            #print thresh_lat, thresh_lon, new_id
 
            for i in range(len(old_id_lonlat[0])):
                if abs(new_lon - old_id_lonlat[1][i]) < thresh_lon and \
                   abs(new_lat - old_id_lonlat[2][i]) < thresh_lat:
		    # ?keep?:
                    if new_id == old_id_lonlat[0][i]:
                        print 'skip'
                        continue
 
                    newid_oldid_lonlat[0].append(new_id)
                    newid_oldid_lonlat[1].append(old_id_lonlat[0][i])
                    newid_oldid_lonlat[2].append(old_id_lonlat[1][i])
                    newid_oldid_lonlat[3].append(old_id_lonlat[2][i])
                    #print 'hit: node %s is %s' % (new_id, old_id_lonlat[0][i])
 
    inf_new.close()
 
 
    ##### with those two tables populated, write output
 
    # set up output file
    if not output:
        outfile = None
        outf = sys.stdout
    else:
        outfile = output
        outf = open(outfile, 'w')
        print("output file=[%s] (possible duplicates to investigate)" % outfile)
    # loop through match table and display results
    hits = set(newid_oldid_lonlat[1])
 
    if len(hits) > 8:
        csv_outfile = csv_output
        csv_outf = open(csv_outfile, 'w')
        print("csv output file=[%s] (clusters of possible duplicates to investigate)" % csv_outfile)
        csv_outf.write('#longitude|latitude|node_id\n')
 
    if not output:
        outf.write('\n')
 
    for i in hits:
        matches = [j for j,x in enumerate(newid_oldid_lonlat[1]) if x == i]
 
        outf.write('Node')
        if len(matches) > 1:
            outf.write('s <')
        else:
            outf.write(' <')
        for node in matches:
            if node != matches[0]:
                outf.write(',')
            outf.write(newid_oldid_lonlat[0][node])
        outf.write('> ')
        if len(matches) > 1:
            outf.write('are')
        else:
            outf.write('is')
        outf.write(' within ' + str(threshold_m) + 'm of node <' + i + '>\n')
 
        latstr = str(newid_oldid_lonlat[3][newid_oldid_lonlat[1].index(i)])
	lonstr = str(newid_oldid_lonlat[2][newid_oldid_lonlat[1].index(i)])
 
        outf.write('  Info: http://www.openstreetmap.org/browse/node/' + i + '\n')
        outf.write('  Map:  http://www.openstreetmap.org/' + \
          '?lat=' + latstr + '&lon=' + lonstr + '&zoom=18&node=' \
          + i + '\n\n')
 
        if len(hits) > 8:
            csv_outf.write(lonstr + '|' + latstr + '|' + i + '\n')
 
    inf_new.close()
    if outfile is not None:
        outf.close()
    if len(hits) > 8:
        csv_outf.close()
 
 
if __name__ == "__main__":
    main()
public class TSP_NN
{
    private int numberOfNodes;
    private Stack<Integer> stack;
 
    public void TSPNearestNeighbour()
    {
        stack = new Stack<Integer>();
    }
    
    public int randInt(int min, int max)
    {
    Random rand = new Random();
    int randomNum = rand.nextInt((max - min) + 1) + min;
    return randomNum;
    }
 
     public void actual_tsp(float adjacencyMatrix[][], int index)
    {
        shortest_path.clear();
        stack = new Stack<Integer>();
        numberOfNodes = adjacencyMatrix[1].length - 1;
        int[] visited = new int[numberOfNodes + 1];
        visited[index] = 1;
        stack.push(index);
        int element, dst = 0, i;
        float min = Integer.MAX_VALUE;
        boolean minFlag = false;
        shortest_path.add(index);
 
        while (!stack.isEmpty())
        {
            
            element = stack.peek();
            i = 0;
            min = Integer.MAX_VALUE;
            while (i <= numberOfNodes)
            {
                if (adjacencyMatrix[element][i] > 0.0 && visited[i] == 0)                
                    if (min > adjacencyMatrix[element][i])
                    {
                        min = adjacencyMatrix[element][i];
                        dst = i;
                        minFlag = true;
                    }                
                i++;
            }
            if (minFlag)
            {
                visited[dst] = 1;
                stack.push(dst);
                shortest_path.add(dst);
                minFlag = false;
                continue;
            }
            stack.pop();
        }
    }
    public void tsp(float adjacencyMatrix[][],int iter)
    {
        shortest_path.clear();
        stack = new Stack<Integer>();        
        numberOfNodes = adjacencyMatrix[1].length - 1;
        int[] visited = new int[numberOfNodes + 1];
        int sc_index=0,counter = 0;
        float cost = 0.0,shortest_cost=Integer.MAX_VALUE;
        while ( counter < iter)
            {
            shortest_path.clear();
            int rand_no = randInt(0,numberOfNodes);
            for(int k=0;k<(numberOfNodes+1);k++)
                visited[k]=0;
            visited[rand_no] = 1;
            stack.clear();
            stack.push(rand_no);
            int element, dst = 0, i;
            float min = Integer.MAX_VALUE;
            boolean minFlag = false;            
            shortest_path.add(rand_no);
            cost = 0.0;
            //sc_index = rand_no;
            while (!stack.isEmpty())
            {
                
                element = stack.peek();
                i = 0;
                min = Integer.MAX_VALUE;
                while (i <= numberOfNodes)
                {
                    if (adjacencyMatrix[element][i] > 0.0 && visited[i] == 0)                
                        if (min > adjacencyMatrix[element][i])
                        {
                            cost += adjacencyMatrix[element][i];
                            min = adjacencyMatrix[element][i];
                            dst = i;
                            minFlag = true;
                        }                
                    i++;
                }
                if (minFlag)
                {
                    visited[dst] = 1;
                    stack.push(dst);
                    shortest_path.add(dst);
                    minFlag = false;
                    continue;
                }
                stack.pop();
            }
            println("\nrand no: " + rand_no);
            println("total cost: " + cost);
            print("path: ");
            for(int node:shortest_path)
              print(" " + node);
            if( cost < shortest_cost)
              {
                shortest_cost = cost;
                sc_index = rand_no;
              }
            counter++;
         }
         println("shortest cost:  "+ shortest_cost);
         println("initial rno: " + sc_index);
         //actual_tsp(adjacencyMatrix,sc_index);
         //rerun with optimal source
            shortest_path.clear();            
            for(int k=0;k<(numberOfNodes+1);k++)
                visited[k]=0;
            visited[sc_index] = 1;
            stack.clear();
            stack.push(sc_index);
            int element, dst = 0, i;
            float min = Integer.MAX_VALUE;
            boolean minFlag = false;            
            shortest_path.add(sc_index);
            cost = 0.0;            
            while (!stack.isEmpty())
            {
                
                element = stack.peek();
                i = 0;
                min = Integer.MAX_VALUE;
                while (i <= numberOfNodes)
                {
                    if (adjacencyMatrix[element][i] > 0.0 && visited[i] == 0)                
                        if (min > adjacencyMatrix[element][i])
                        {
                            cost += adjacencyMatrix[element][i];
                            min = adjacencyMatrix[element][i];
                            dst = i;
                            minFlag = true;
                        }                
                    i++;
                }
                if (minFlag)
                {
                    visited[dst] = 1;
                    stack.push(dst);
                    shortest_path.add(dst);
                    minFlag = false;
                    continue;
                }
                stack.pop();
            }
            println("total cost: " + cost);
            print("path: ");
            for(int node:shortest_path)
              print(" " + node);
         //end of re run
    }

}

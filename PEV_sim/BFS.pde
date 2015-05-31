public class BFS
{ 
 
    private Queue<Integer> queue;
 
    public BFS()
    {
        queue = new LinkedList<Integer>();
    }
 
    public int bfs(int adjacency_matrix[][], int source,int[]list)
    {
        int number_of_nodes = adjacency_matrix[source].length - 1;
 
        int[] visited = new int[number_of_nodes + 1];
        int i, element,counter=0;
        //int [] list = new int[number_of_nodes];
 
        visited[source] = 1;
        queue.add(source);
 
        while (!queue.isEmpty())
        {
            element = queue.remove();
//            print(" queue element : " + element);
            i = 0;

              list[counter++] = element;
            while (i <= number_of_nodes)
            {
                if (adjacency_matrix[element][i] == 1 && visited[i] == 0)
                {
//                    print("element : " + i);
                    queue.add(i);
                    visited[i] = 1;
                }
                i++;
            }
        }
        return counter;
    }
}

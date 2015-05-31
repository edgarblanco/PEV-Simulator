import java.io.*;
int time_counter = 0;
class Output extends TimerTask
    {
    public void run()
        {
        //println("Hello"); 
          try
            {
              Writer out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("logger.txt",true), "UTF-8"));
              //BufferedWriter bw = new BufferedWriter(new FileWriter(output_file,true));
              //println(time_counter);
              //bw.write(time_counter);
              //bw.close();
              for(Object pev:PEVCollection)
                {
                  //println(pev);
                  //out.write(pev.loc.x);
               // out.write(pev.loc.y);
                }
              //out.write(time_counter);
              out.close();
            }  
          catch(IOException e)
            {
             e.printStackTrace();
            }
         time_counter++;
        }
     }

package apiserver.workers.coldfusion;

import apiserver.workers.coldfusion.services.TestService;
import org.apache.ignite.Ignite;

import java.util.Date;

/**
 * Created by mnimer on 6/8/14.
 */
public class TaskRouter implements Runnable
{
    Ignite grid = null;


    public TaskRouter(Ignite grid) {
        this.grid = grid;
    }


    @Override
    public void run() {
        System.out.println("*** RUNNING TaskRouter ***");

        try{ // wait for me start debugger
            Thread.sleep(5000);
        }catch (Exception ex){}

        System.out.println("*** Start Executing TestService 1***" );
        long startTime = new Date().getTime();
        new TestService().execute("Checking Grid - " +grid.configuration().getNodeId());
        long endTime = new Date().getTime();
        System.out.println("*** END TestService (" +(endTime-startTime) +")***" );

        //System.out.println("*** Start Executing TestService 2***" );
        //startTime = new Date().getTime();
        //new TestService().executeProxy();
        //endTime = new Date().getTime();
        //System.out.println("*** END TestService (" +(endTime-startTime) +")***" );
    }
}

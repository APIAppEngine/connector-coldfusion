package apiserver.workers.coldfusion;

import org.gridgain.grid.Grid;
import org.gridgain.grid.GridConfiguration;
import org.gridgain.grid.GridGain;
import org.gridgain.grid.marshaller.optimized.GridOptimizedMarshaller;
import org.gridgain.grid.spi.discovery.tcp.GridTcpDiscoverySpi;
import org.gridgain.grid.spi.discovery.tcp.ipfinder.multicast.GridTcpDiscoveryMulticastIpFinder;

import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by mnimer on 6/8/14.
 */
public class ColdFusionWorkerServlet implements Servlet
{
    private TaskRouter router = null;
    private Grid grid;
    public static String rootPath;

    @Override
    public void init(ServletConfig config) throws ServletException {

        System.out.println("***************************************");
        System.out.println("ApiAppEngine Grid Manager");
        System.out.println("***************************************");

        try
        {
            rootPath = config.getServletContext().getRealPath("/");

            grid = GridGain.start(getGridConfiguration());
            router = new TaskRouter(grid);
            new Thread(router).run();
        }
        catch(Exception ge){
            ge.printStackTrace();
        }
    }


    @Override
    public ServletConfig getServletConfig() {
        return null;
    }


    @Override
    public void service(ServletRequest req, ServletResponse res) throws ServletException, IOException {

    }


    @Override
    public String getServletInfo() {
        return null;
    }


    @Override
    public void destroy() {

    }




    private GridConfiguration getGridConfiguration() {
        Map<String, String> userAttr = new HashMap<String, String>();
        userAttr.put("ROLE", "ApiAppEngine");
        userAttr.put("ROLE", "connector-coldfusion");

        GridOptimizedMarshaller gom = new GridOptimizedMarshaller();
        gom.setRequireSerializable(false);

        GridTcpDiscoveryMulticastIpFinder fndr = new GridTcpDiscoveryMulticastIpFinder();
        fndr.setLocalAddress("127.0.0.1");
        GridTcpDiscoverySpi spi = new GridTcpDiscoverySpi();
        spi.setIpFinder(fndr);

        GridConfiguration gc = new GridConfiguration();
        gc.setGridName("ApiAppEngine");
        gc.setPeerClassLoadingEnabled(true);
        gc.setUserAttributes(userAttr);
        gc.setMarshaller(gom);
        gc.setDiscoverySpi(spi);



        /**
         * Configure grid to use multicast based discovery.
        GridTcpDiscoveryMulticastIpFinder fndr = new GridTcpDiscoveryMulticastIpFinder();
        GridTcpDiscoverySpi gd = new GridTcpDiscoverySpi();
        gd.setLocalAddress("127.0.0.1");
        gd.setIpFinder(fndr);
        //fndr.setMulticastGroup("127.0.0.1");
        gc.setDiscoverySpi(gd);
         */

        //GridCacheConfiguration gcc = new GridCacheConfiguration();
        //gcc.setCacheMode(GridCacheMode.PARTITIONED);
        //gcc.setName("documentcache");
        //gcc.setSwapEnabled(true);
        //gcc.setAtomicityMode(GridCacheAtomicityMode.ATOMIC);
        //gcc.setQueryIndexEnabled(true);
        //gcc.setBackups(0);
        //gcc.setStartSize(200000);

        //gc.setCacheConfiguration(gcc);

        return gc;
    }
}

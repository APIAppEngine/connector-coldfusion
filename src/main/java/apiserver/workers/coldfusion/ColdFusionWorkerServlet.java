package apiserver.workers.coldfusion;

import org.apache.ignite.Ignite;
import org.apache.ignite.Ignition;
import org.apache.ignite.configuration.IgniteConfiguration;
import org.apache.ignite.internal.client.marshaller.optimized.GridClientOptimizedMarshaller;
import org.apache.ignite.spi.discovery.tcp.TcpDiscoverySpi;
import org.apache.ignite.spi.discovery.tcp.ipfinder.sharedfs.TcpDiscoverySharedFsIpFinder;

import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Created by mnimer on 6/8/14.
 */
public class ColdFusionWorkerServlet implements Servlet
{
    private TaskRouter router = null;
    private Ignite grid;
    public static String rootPath;

    @Override
    public void init(ServletConfig config) throws ServletException {

        System.out.println("***************************************");
        System.out.println("ApiAppEngine ColdFusion Worker");
        System.out.println("***************************************");

        try
        {
            rootPath = config.getServletContext().getRealPath("/");

            grid = Ignition.start(getGridConfiguration());
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




    private IgniteConfiguration getGridConfiguration()
    {
        Map<String, String> userAttr = new HashMap<String, String>();
        userAttr.put("ROLE", "ApiAppEngine");
        userAttr.put("ROLE", "worker-coldfusion");

        GridClientOptimizedMarshaller gom = new GridClientOptimizedMarshaller();

        Collection<String> ips = new ArrayList<>();
        ips.add("127.0.0.1");
        //finder.setAddresses(ips);

        //GridTcpDiscoveryMulticastIpFinder finder = new GridTcpDiscoveryMulticastIpFinder();
        //finder.setLocalAddress("127.0.0.1");
        //GridTcpDiscoveryVmIpFinder finder = new GridTcpDiscoveryVmIpFinder();
        //finder.setShared(true);


        TcpDiscoverySpi spi = new TcpDiscoverySpi();


        TcpDiscoverySharedFsIpFinder finder = new TcpDiscoverySharedFsIpFinder();
        finder.setPath("/opt");
        spi.setLocalAddress("127.0.0.1");
        spi.setIpFinder(finder);


        IgniteConfiguration gc = new IgniteConfiguration();
        gc.setNodeId(UUID.fromString("5d59104a-674b-4cec-88a8-86264d02641b"));
        gc.setGridName("ApiAppEngine");
        gc.setPeerClassLoadingEnabled(true);
        gc.setUserAttributes(userAttr);
        gc.setLocalHost("127.0.0.1");
        gc.setDiscoverySpi(spi);
        //gc.setMarshaller(gom);
        return gc;
    }
}

package apiserver.workers.coldfusion.services.pdf;

import apiserver.workers.coldfusion.ColdFusionWorkerServlet;
import apiserver.workers.coldfusion.exceptions.ColdFusionException;
import apiserver.workers.coldfusion.model.ByteArrayResult;
import apiserver.workers.coldfusion.model.Stats;
import coldfusion.cfc.CFCProxy;
import org.gridgain.grid.lang.GridCallable;

import java.util.Map;

/**
 * Created by mnimer on 6/10/14.
 */
public class UrlToPdfCallable implements GridCallable
{

    private String url;
    private Map options;


    public UrlToPdfCallable(String url, Map options) {
        this.url = url;
        this.options = options;
    }


    @Override
    public ByteArrayResult call() throws Exception {
        String cfcPath = ColdFusionWorkerServlet.rootPath + "/apiserver-inf/components/v1/api-pdf-convert.cfc";
        try {
            long startTime = System.nanoTime();
            System.out.println("Invoking Grid Service: api-pdf-convert.cfc::urlToPdf ");

            // Invoke CFC
            CFCProxy proxy = new CFCProxy(cfcPath, false);
            byte[] result = (byte[])proxy.invoke("urlToPdf", new Object[]{this.url, this.options});


            // return the raw bytes of the pdf & stats
            long endTime = System.nanoTime();
            Stats stats = new Stats();
            stats.setExecutionTime(endTime-startTime);

            return new ByteArrayResult(stats, result);
        }
        catch (Throwable e) {
            //e.printStackTrace();
            throw new ColdFusionException("Error Invoking URL2PDF Service on grid", e);
        }
    }
}

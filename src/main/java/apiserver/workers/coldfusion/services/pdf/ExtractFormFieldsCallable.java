package apiserver.workers.coldfusion.services.pdf;

import apiserver.workers.coldfusion.ColdFusionWorkerServlet;
import apiserver.workers.coldfusion.exceptions.ColdFusionException;
import apiserver.workers.coldfusion.model.MapResult;
import apiserver.workers.coldfusion.model.Stats;
import coldfusion.cfc.CFCProxy;
import org.apache.ignite.internal.util.lang.GridPlainCallable;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by mnimer on 6/10/14.
 */
public class ExtractFormFieldsCallable implements GridPlainCallable
{

    private byte[] file;


    public ExtractFormFieldsCallable(byte[] file) {
        this.file = file;
    }


    public MapResult call() throws Exception {
        String cfcPath = ColdFusionWorkerServlet.rootPath + "/apiserver-inf/components/v1/api-pdfform.cfc";
        try {
            long startTime = System.nanoTime();
            System.out.println("Invoking Grid Service: api-pdfform.cfc::populateFormFields ");

            // Invoke CFC
            CFCProxy proxy = new CFCProxy(cfcPath, false);
            Map result = (Map)proxy.invoke("extractFormFields", new Object[]{this.file});

            // return the raw bytes of the pdf
            long endTime = System.nanoTime();
            Stats stats = new Stats();
            stats.setExecutionTime(endTime-startTime);


            HashMap returnMap = new HashMap<String, Object>();
            for (Object o : result.keySet()) {
                returnMap.put(o.toString(), result.get(o).toString());
            }
            return new MapResult(stats, returnMap);
        }
        catch (Throwable e) {
            //e.printStackTrace();
            throw new ColdFusionException("Error Invoking ExtractFormFields Service on grid", e);
        }
    }
}

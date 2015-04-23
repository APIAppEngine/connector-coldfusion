package apiserver.workers.coldfusion.services.pdf;

import apiserver.workers.coldfusion.ColdFusionWorkerServlet;
import apiserver.workers.coldfusion.exceptions.ColdFusionException;
import apiserver.workers.coldfusion.model.ByteArrayResult;
import apiserver.workers.coldfusion.model.Stats;
import coldfusion.cfc.CFCProxy;
import org.apache.ignite.internal.util.lang.GridPlainCallable;

import java.util.Map;

/**
 * Created by mnimer on 6/10/14.
 */
public class TransformPdfCallable implements GridPlainCallable
{

    private byte[] file;
    private Map options;


    public TransformPdfCallable(byte[] file, Map options) {
        this.file = file;
        this.options = options;
    }


    public ByteArrayResult call() throws Exception {
        String cfcPath = ColdFusionWorkerServlet.rootPath + "/apiserver-inf/components/v1/api-pdf.cfc";
        try {
            long startTime = System.nanoTime();
            System.out.println("Invoking Grid Service: api-pdf.cfc::transformPdf ");

            // Invoke CFC
            CFCProxy proxy = new CFCProxy(cfcPath, false);
            byte[] result = (byte[])proxy.invoke("transformPdf", new Object[]{this.file, this.options});

            // return the raw bytes of the pdf
            long endTime = System.nanoTime();
            Stats stats = new Stats();
            stats.setExecutionTime(endTime-startTime);

            return new ByteArrayResult(stats, result);
        }
        catch (Throwable e) {
            //e.printStackTrace();
            throw new ColdFusionException("Error Invoking TransformPDF Service on grid", e);
        }
    }
}

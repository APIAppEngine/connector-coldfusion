package apiserver.workers.coldfusion.services.pdf;

import apiserver.workers.coldfusion.ColdFusionWorkerServlet;
import apiserver.workers.coldfusion.exceptions.ColdFusionException;
import apiserver.workers.coldfusion.model.ByteArrayResult;
import apiserver.workers.coldfusion.model.Stats;
import coldfusion.cfc.CFCProxy;
import org.apache.commons.codec.binary.Base64;
import org.apache.ignite.internal.util.lang.GridPlainCallable;

import java.util.Map;

/**
 * Created by mnimer on 6/10/14.
 */
public class MergePdfCallable implements GridPlainCallable
{

    private byte[] file;
    private Map options;


    public MergePdfCallable(byte[] file, Map options) {
        this.file = file;
        this.options = options;
    }


    //TODO: test passing in multiple files
    @Override
    public ByteArrayResult call() throws Exception {
        String cfcPath = ColdFusionWorkerServlet.rootPath + "/apiserver-inf/components/v1/api-pdf.cfc";
        try {
            long startTime = System.nanoTime();
            System.out.println("Invoking Grid Service: api-pdf.cfc::mergePdf ");

            // covert file to base64 for transfer
            String base64File = Base64.encodeBase64String(this.file);

            // Invoke CFC
            CFCProxy proxy = new CFCProxy(cfcPath, false);
            byte[] result = (byte[])proxy.invoke("mergePdf", new Object[]{base64File, this.options});

            // return the raw bytes of the pdf
            long endTime = System.nanoTime();
            Stats stats = new Stats();
            stats.setExecutionTime(endTime-startTime);

            return new ByteArrayResult(stats, result);
        }
        catch (Throwable e) {
            //e.printStackTrace();
            throw new ColdFusionException("Error Invoking MergePDF Service on grid", e);
        }
    }
}

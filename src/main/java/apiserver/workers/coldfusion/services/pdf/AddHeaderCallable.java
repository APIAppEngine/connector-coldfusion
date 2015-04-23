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
public class AddHeaderCallable implements GridPlainCallable
{

    private byte[] file;
    private Map options;


    public AddHeaderCallable(byte[] file, Map options) {
        this.file = file;
        this.options = options;
    }


    @Override
    public ByteArrayResult call() throws Exception {
        String cfcPath = ColdFusionWorkerServlet.rootPath + "/apiserver-inf/components/v1/api-pdf.cfc";
        try {
            long startTime = System.nanoTime();
            System.out.println("Invoking Grid Service: api-pdf.cfc::addHeader ");

            // covert file to base64 for transfer
            String base64File = Base64.encodeBase64String(this.file);

            // Invoke CFC
            CFCProxy proxy = new CFCProxy(cfcPath, false);
            String result = (String)proxy.invoke("addHeader", new Object[]{base64File, this.options});

            // return the raw bytes of the pdf
            long endTime = System.nanoTime();
            Stats stats = new Stats();
            stats.setExecutionTime(endTime-startTime);

            byte[] resultBytes = Base64.decodeBase64(result);
            return new ByteArrayResult(stats, resultBytes);
        }
        catch (Throwable e) {
            //e.printStackTrace();
            throw new ColdFusionException("Error Invoking AddHeader Service on grid", e);
        }
    }
}

package apiserver.workers.coldfusion.services;

import apiserver.workers.coldfusion.ColdFusionWorkerServlet;
import coldfusion.cfc.CFCProxy;
import org.apache.ignite.lang.IgniteCallable;

/**
 * Created by mnimer on 4/22/15.
 */
public class EchoCallable implements IgniteCallable
{
    String echo;

    public EchoCallable(String echo_) {
        this.echo = echo_;
    }


    @Override
    public byte[] call() throws Exception {
        String cfcPath = ColdFusionWorkerServlet.rootPath +"/apiserver-inf/components/v1/api-test.cfc";
        try
        {
            CFCProxy proxy = new CFCProxy(cfcPath, false);
            String result = (String)proxy.invoke("echo", new Object[]{this.echo});
            System.out.println("EchoCallable Result:" +result);
            return result.getBytes();
        }
        catch (Throwable e)
        {
            e.printStackTrace();
            //throw new RuntimeException(e);
        }
        return null;
    }
}

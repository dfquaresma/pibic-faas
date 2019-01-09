package com.openfaas.function;

import com.openfaas.model.IHandler;
import com.openfaas.model.IResponse;
import com.openfaas.model.IRequest;
import com.openfaas.model.Response;

import java.lang.management.GarbageCollectorMXBean;
import java.lang.management.ManagementFactory;

import java.util.List;
import java.util.ArrayList;

import net.coobird.thumbnailator.Thumbnails;
import net.coobird.thumbnailator.geometry.Positions;
import java.net.URL;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

public class Handler implements com.openfaas.model.IHandler {

    public IResponse Handle(IRequest req) {
        List<GarbageCollectorMXBean> gcs = ManagementFactory.getGarbageCollectorMXBeans();
        GarbageCollectorMXBean scavenge = gcs.get(0);
        GarbageCollectorMXBean markSweep = gcs.get(1);

        long countBeforeScavenge = scavenge.getCollectionCount();
        long timeBeforeScavenge = scavenge.getCollectionTime();
        long countBeforeMarkSweep = markSweep.getCollectionCount();
        long timeBeforeMarkSweep = markSweep.getCollectionTime();
        long before = System.currentTimeMillis();

        String err = callFunction();

        long after = System.currentTimeMillis();
        long countAfterScavenge = scavenge.getCollectionCount();
        long timeAfterScavenge = scavenge.getCollectionTime();
        long countAfterMarkSweep = markSweep.getCollectionCount();
        long timeAfterMarkSweep = markSweep.getCollectionTime();

        String processName = java.lang.management.ManagementFactory.getRuntimeMXBean().getName();
        long pid = Long.parseLong(processName.split("@")[0]);

        String output = err;
        if (err.length() == 0) {
            output = Long.toString(pid) + "," + // Pid
                Long.toString(after - before) + "," + // Business Logic Time in Milliseconds
                Long.toString(countAfterScavenge - countBeforeScavenge) + "," + // Scavenge Number of Collections
                Long.toString(timeAfterScavenge - timeBeforeScavenge) + "," + // Scavenge Collections Time Spent in Milliseconds
                Long.toString(countAfterMarkSweep - countBeforeMarkSweep) + "," + // MarkSweep Number of Collections
                Long.toString(timeAfterMarkSweep - timeBeforeMarkSweep); // MarkSweep Collections Time Spent in Milliseconds
        }

        Response res = new Response();
        res.setBody(output);
        return res;
    }

    static int rotate;
    static double outputQuality, scale;
    static float transparency;
    static BufferedImage image, watermark;
    static {
        try{
            rotate = Integer.parseInt(System.getenv("rotate"));
            outputQuality = Double.parseDouble(System.getenv("output_quality"));
            scale = Double.parseDouble(System.getenv("scale"));
            transparency = Float.parseFloat(System.getenv("transparency"));

            URL imageUrl = new URL(System.getenv("image_url"));
            URL watermarkUrl = new URL(System.getenv("watermark_url"));
            image = ImageIO.read(imageUrl);
            watermark = ImageIO.read(watermarkUrl);

        } catch(Exception e) {
            System.err.println(e.getMessage());
        }
    }

    public String callFunction() {
        String err = "";
        try {
            Thumbnails.of(this.image)
                .scale(this.scale)
                .rotate(this.rotate)
                .watermark(Positions.BOTTOM_RIGHT, this.watermark, this.transparency)
                .outputQuality(this.outputQuality)
                .asBufferedImage();
            
        } catch (Exception e) {
            err = e.getMessage();
        }

        return err;
    }

}

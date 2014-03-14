/**
 * Created by IntelliJ IDEA.
 * User: Dinkar
 * Date: 7/26/11
 * Time: 10:01 PM
 * To change this template use File | Settings | File Templates.
 */

import java.nio.channels.SocketChannel;
import java.util.*;
import java.text.MessageFormat;
import it.gotoandplay.smartfoxserver.db.*;
import it.gotoandplay.smartfoxserver.data.*;
import it.gotoandplay.smartfoxserver.exceptions.*;
import it.gotoandplay.smartfoxserver.extensions.*;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;
import it.gotoandplay.smartfoxserver.lib.MailManager;
import it.gotoandplay.smartfoxserver.events.InternalEventObject;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

public class RealtimeGridExtension extends AbstractExtension {
    public static String DEFAULT_COMMAND = "RealtimeGrid";
    public static int DEFAULT_TIME_INTERVAL = 5000; //in milliseconds
    private AtomicInteger commandCount = new AtomicInteger();
    private static Logger log = LoggerFactory.getLogger(RealtimeGridExtension.class);

    private Zone currentZone = null;
    public void init()
    {
    	currentZone = ExtensionHelper.instance().getZone(this.getOwnerZone());
    }
    @Override
    public void handleInternalEvent(InternalEventObject internalEventObject) {
        //To change body of implemented methods use File | Settings | File Templates.
    }

    @Override
    public void handleRequest(String s, ActionscriptObject actionscriptObject,
                              User user, int fromRoom) {
        if(s.equals(DEFAULT_COMMAND)){
    	    Room room = currentZone.getRoom(fromRoom);
            sendStatusMessage(actionscriptObject, user,room, false);
        }else {
            throw new RuntimeException("Unhandled command "+ s);
        }
    }

    @Override
    public void handleRequest(String s, String[] strings, User user, int i) {
        //To change body of implemented methods use File | Settings | File Templates.
    }
    private void sendStatusMessage(ActionscriptObject ao, User u, Room room, boolean publish){
          // Prepare a list of recipients and put the user that requested the command
        trace("Processing a slow moving request");
        try {
          ActionscriptObject result = new ActionscriptObject();
          result.put("startTime", (new Date()).toString());
          Thread.sleep(DEFAULT_TIME_INTERVAL);
          LinkedList recipients = new LinkedList();
          if(publish){
              User[] users = room.getAllUsers();
              for(User aUser : users){
              recipients.add(aUser.getChannel());
              }
          }else {
              if(u != null){
              recipients.add(u.getChannel());
              }
          }
          if(recipients.size() > 0){
            // Send data to client
            trace("Sending " + ao + ": Command count " + commandCount);
            commandCount.incrementAndGet();
            trace(" Received " + ao.getString("name"));

            result.put("_cmd",DEFAULT_COMMAND);
            result.put("parameter1", ao.getString("parameter1"));
//            result.put("name", ao.getString("name"));
//            result.put("someVal",ao.getNumber("someVal"));
//            result.put("note", ao.getString("note"));
            result.put("endTime", (new java.util.Date()).toString());
            sendResponse(result, room.getId(), u, recipients);
          }else {
              trace("No recipients " + new Date());
          }
        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }
}

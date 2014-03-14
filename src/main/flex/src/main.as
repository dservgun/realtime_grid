// ActionScript file
/**
 *	SmartFoxClient Actionscript 3.0 code template
 *	version 1.0.0
 * 
 * (c) 2004-2007 gotoAndPlay()
 * www.smartfoxserver.com
 * www.gotoandplay.it 
*/

import it.gotoandplay.smartfoxserver.SFSEvent;
import it.gotoandplay.smartfoxserver.SmartFoxClient;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.DataGridEvent;

private const NEWLINE:String = "\n";
private const SERVER_IP_ADDRESS: String = "64.22.81.244";
private const DEFAULT_EXTENSION : String ="REALTIME_GRID_EXTENSION";
private const DEFAULT_ZONE : String ="realtime_grid";
private const APPLICATION_ROOM: String ="Demo";
private var sfs:SmartFoxClient;

private var autoConnect: Boolean = true;
 

      [Bindable]
      private var marketDataData:ArrayCollection;

      [Bindable]
      private var riskDataData:ArrayCollection;

      private static const ADD_DEAL:String = "Click to Add Task";
      [Bindable]
      private var deals:ArrayCollection;

      private function initMarketDataGridData():void {
          marketDataData = new ArrayCollection();
          marketDataData.addItem({tenure: 0,rate: 0.5});
          marketDataData.addItem({tenure: 2,rate: 0.5});
          marketDataData.addItem({tenure: 3,rate: 0.5});
          marketDataData.addItem({tenure: 5,rate: 0.5});
          marketDataData.addItem({tenure: 7,rate: 0.5});
          marketDataData.addItem({tenure: 9,rate: 0.5});
          marketDataData.addItem({tenure: 10,rate: 0.5});
          marketDataData.addItem({tenure: 15,rate: 0.5});
          marketDataData.addItem({tenure: 30,rate: 0.5});
      }

      private function initRiskDataGridData():void {
          riskDataData = new ArrayCollection();
      }

      private function initDealerDataGridData():void {
          deals = new ArrayCollection();
          deals.addItem(new Deal("My Deal 1", 4, "deal1"));
          deals.addItem(new Deal("My Deal 2", 1, "deal2"));
          deals.addItem({title: ADD_DEAL})
      }


      private function checkEdit(e:DataGridEvent):void
        {
          // Do not allow editing of Add Task row except for
          // "Click to Add" column
          if(e.rowIndex == deals.length - 1 && e.columnIndex != 0){
            e.preventDefault();
          }
        }

	private function editEnd(e:DataGridEvent):void
	{
	  // Adding a new task
	  if(e.rowIndex == deals.length - 1)
	  {
	    var txtIn:TextInput = TextInput(e.currentTarget.itemEditorInstance);
	    var dt:Object = e.itemRenderer.data;
	
	    // Add new task
	    if(txtIn.text != ADD_DEAL)
	    {
	      deals.addItemAt(new Deal(txtIn.text, 0, ""), e.rowIndex);
	    }
	
	    // Destroy item editor
	    dealGrid.destroyItemEditor();
	
	    // Stop default behavior
	    e.preventDefault();	    
	    sendDeal(deals[e.rowIndex]);
	  }
	  
	}
    
public function main():void
{
//	Alert.show("Creating sfs client");
	sfs = new SmartFoxClient();
	sfs.addEventListener(SFSEvent.onConfigLoadSuccess, onConfigLoadSuccess)
	sfs.addEventListener(SFSEvent.onConfigLoadFailure, onConfigLoadFailure)
	sfs.addEventListener(SFSEvent.onConnection, onConnection)
	sfs.addEventListener(SFSEvent.onLogin, onLogin)
	sfs.addEventListener(SFSEvent.onRoomListUpdate, onRoomListUpdate)
	sfs.addEventListener(SFSEvent.onUserCountChange, onUserCountChange)
	sfs.addEventListener(SFSEvent.onJoinRoom, onJoinRoom)
	sfs.addEventListener(SFSEvent.onJoinRoomError, onJoinRoomError)
	sfs.addEventListener(SFSEvent.onRoomAdded, onRoomAdded)
	sfs.addEventListener(SFSEvent.onRoomDeleted, onRoomDeleted)
	sfs.addEventListener(SFSEvent.onCreateRoomError, onCreateRoomError)
	sfs.addEventListener(SFSEvent.onPublicMessage, onPublicMessage)
	sfs.addEventListener(SFSEvent.onUserEnterRoom, onUserEnterRoom)
	sfs.addEventListener(SFSEvent.onUserLeaveRoom, onUserLeaveRoom)
	sfs.addEventListener(SFSEvent.onConnectionLost, onConnectionLost)
	sfs.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponse);    
	sfs.addEventListener(SFSEvent.onObjectReceived, onObjectReceivedHandler);
	sfs.loadConfig("config.xml");     
}

private function onConfigLoadSuccess(event :SFSEvent): void{
  try {
//  	Alert.show("Connecting to " + sfs.ipAddress);	
  	sfs.connect(sfs.ipAddress, sfs.port);
  }catch(err: Error){
  	Alert.show("Error loading config file " + err.message);
  }      
}
private function onConfigLoadFailure(event : SFSEvent): void{
  Alert.show("Config file failed to load");
}


/**
 * Handle connection
 */
public function onConnection(evt:SFSEvent):void
{
	var success:Boolean = evt.params.success;
	//Alert.show("Success " +success);
	sfs.login(DEFAULT_ZONE, "", "");
	if (success)
	{
    	Alert.show("Connected to the server successfully");
	}
	else
	{
		Alert.show("Connection failed!");	
	}
}


/**
 * Handle connection lost
 */
public function onConnectionLost(evt:SFSEvent):void
{
	Alert.show("Connection lost!");
	if(sfs.isConnected){
		sfs.disconnect();
		sfs.connect(sfs.ipAddress, sfs.port);
	}
}


/**
 * Handle room list
 */
public function onRoomListUpdate(evt:SFSEvent):void
{
   	//Alert.show("On room list update" );
      for(var r : String in evt.params.roomList){
        if(evt.params.roomList[r].getName() == APPLICATION_ROOM){
          var applicationRoomId:int = evt.params.roomList[r].getId();
          sfs.joinRoom(applicationRoomId);
          break;
        }
      }
}

/**
 * Handle successful join
 */
public function onJoinRoom(evt:SFSEvent):void
{
	try {
	//Alert.show("Successfully joined room: " + evt.params.room.getId());		
	}catch(err: Error){
		Alert.show("Error joining room " + err.message);
	}
}

/**
 * Handle problems with join
 */
public function onJoinRoomError(evt:SFSEvent):void
{
	Alert.show("Error joining the room");
}

/**
 * Handle a Security Error
 */
public function onSecurityError(evt:SecurityErrorEvent):void
{
	Alert.show("Security error: " + evt.text);
}

/**
 * Handle an I/O Error
 */
public function onIOError(evt:IOErrorEvent):void
{
	debugTrace("I/O Error: " + evt.text);
}

/**
 * Trace messages to the debug text area
 */
public function debugTrace(msg:String):void
{
	Alert.show("--> " + msg + NEWLINE);
}
public function getSFS() : SmartFoxClient{
	return sfs;
}
private function onLogin(event : SFSEvent): void{      
	//Alert.show("On login event");	
}
private function onUserCountChange(event : SFSEvent) : void{
	//Alert.show("On user count change");
	generateDeals();
	
}
private function onRoomAdded(event: SFSEvent): void{
	//Alert.show("On room added");
	
}
private function onRoomDeleted(event: SFSEvent) :void{
	//Alert.show("On room deleted");	
}
private function onCreateRoomError(event: SFSEvent): void{
	//Alert.show("On create room error");
}
private function onPublicMessage(event: SFSEvent) : void{
	try {
	var dataObject: String = event.params.message;
	//Alert.show("Public message received "+ dataObject);
	this.riskDataData.addItem({name: dataObject});
	}catch(err: Error){
		Alert.show("Error in handling public message ")
	}	
}
private function onUserEnterRoom(event : SFSEvent): void{
	generateDeals();
	//Alert.show("On user enter room");	
}
private function onUserLeaveRoom(event: SFSEvent): void{
	Alert.show("On user leave room");	
}
private function printObject(anObject: Object): String{
	var result: String = "";
	for(var prop : String in anObject){
		result = result + prop +  ":" + anObject[prop] + ";" ;
	}
	return result;
}
private function onExtensionResponse(event: SFSEvent): void{
	var obj:Object = event.params.dataObj;
	var name: String = obj.name;
	var someVal: String = "Received "+ obj.someVal;
	var note: String = "Received "+  obj.note;
	var command: String =obj._cmd;
	this.riskDataData.addItem(
		{name: "Received " + obj._cmd + " parameter1:" + obj.parameter1,
		someVal: "server end time " + obj.endTime,
		note: "Start time: "  + obj.startTime
	});	
}
private function onObjectReceivedHandler(event: SFSEvent):void{
	try {
	var dataObject:Object = event.params.obj;
	//Alert.show("On object received " + dataObject);
	}catch(err: Error){
		Alert.show("Error handling object received message");
	}	
}
private function sendDeal(deal:Deal):void{
	try {
		var request:Object = new Object();
		request.parameter1 = "parameter1";
		sfs.sendXtMessage(DEFAULT_EXTENSION,"RealtimeGrid", request, "xml");
	}catch(err: Error){
		Alert.show("Nothing to send " + err);
	}
//	sfs.sendPublicMessage(deal.name, -1);
//	sfs.sendObject(deal, -1);
}
private function generateDeals():void{
	try{
	this.initDealerDataGridData();
	this.initMarketDataGridData();
	this.initRiskDataGridData();		
//	Alert.show("Inside generate deals")	
//	Alert.show("Sending message"  + "inside generate deals");
	}catch(err: Error){
		Alert.show("Error generating deals " + err.message);
	} 
}

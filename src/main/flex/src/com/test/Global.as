// ActionScript file
package com.test{	
import it.gotoandplay.smartfoxserver.SmartFoxClient;

import mx.controls.Alert;

class Global
{
	public static var DEFAULT_ZONE : String= "realtime_grid";
	public static var DEFAULT_EXTENSION: String = "realtime_grid";
	public static var SERVER_IP_ADDRESS: String ="64.22.81.244";
	public static var LOGIN_ID : int = -1;
	public static var APPLICATION_ROOM_ID: int = -1;
	public static var SFS_CLIENT : SmartFoxClient;
	public static var LOGIN_SUCCESSFUL : Boolean;
	public static function showGenericAlert(aMessage : String){
		Alert.show("Inside Generic alert " + aMessage);
	}
	public static function showAlert(anObject : Object, aMessage : String){
		if(anObject.modifiedBy == null){
			if(anObject.createdBy == SFS_CLIENT.myUserName){
				Alert.show(aMessage);
			}
		}else if(anObject.modifiedBy == SFS_CLIENT.myUserName){
			Alert.show(aMessage);
		}
	}
}

}

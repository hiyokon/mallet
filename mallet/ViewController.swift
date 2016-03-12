//
//  ViewController.swift
//  mallet
//
//  Created by Kotaro Kamiya on 3/12/16.
//  Copyright © 2016 pettypay. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CLLocationManagerDelegate, UIAlertViewDelegate {

	// Monitering and Ranging
	let peripheralManager = PeripheralManager()
    let locationManager = CLLocationManager()
	let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "pettypay")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	    locationManager.delegate = self;
		if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
			locationManager.requestWhenInUseAuthorization()
		}
		
		if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways) {
				locationManager.requestAlwaysAuthorization()
		}
		
		// pheripheralManager = CBPeripheralManager(delegate: self, queue: nil)
		PeripheralManager.setupAdvertising()
		locationManager.startMonitoringForRegion(region)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// ----------------------------------------
	// Local Notification
	// ----------------------------------------

	func sendLocalNotificationForMessage(message: String!) {
		let localNotification:UILocalNotification = UILocalNotification()
		localNotification.alertBody = message
		localNotification.soundName = UILocalNotificationDefaultSoundName
  		UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
	}

	// ----------------------------------------
	// Advertising
	// ----------------------------------------

	@IBOutlet weak var advertiseSwitch: UISwitch!
	@IBAction func advertise(sender: UISwitch) {
		if(advertiseSwitch.on) {
			print("on!")
			locationManager.stopMonitoringForRegion(region)
			PeripheralManager.startAdvertising()
		} else {
			print("off!")
			PeripheralManager.stopAdvertising()
			locationManager.startMonitoringForRegion(region)
		}
	}

	// ----------------------------------------
	// Monitoring and Ranging
	// ----------------------------------------
	
	func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
		print("start monitoring")
		sendLocalNotificationForMessage("Start Monitoring Region")
	}

	func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
		print("enter region")
		sendLocalNotificationForMessage("Enter Region")
		if(region.isMemberOfClass(CLBeaconRegion) && CLLocationManager.isRangingAvailable()) {
			locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
 		}
	}
	
	func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
		print(beacons)
	}

}


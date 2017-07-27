//
//  BluetoothShareInstance.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/4.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothShareInstance: NSObject,CBCentralManagerDelegate, CBPeripheralDelegate {
    
    //添加属性
    var manager: CBCentralManager!
    //连接的外围
    var connectedPeripheral : CBPeripheral!
    //保存的设备特性
    var savedCharacteristic : CBCharacteristic!
    
    //保存收到的蓝牙设备
    var discoveredPeripheralsArr :[CBPeripheral?] = []
    //服务和特征的UUID
    let kServiceUUID = [CBUUID(string:"FFE0")]
    let kCharacteristicUUID = [CBUUID(string:"FFE1")]
    let ServiceUUID1 =  "D0611E78-BBB4-4591-A5F8-487910AE4366"
    
    var lastString : NSString = ""
    var sendString : NSString!
    
    static var shared: BluetoothShareInstance {
        struct Static {
            static let instance: BluetoothShareInstance = BluetoothShareInstance()
        }
        return Static.instance
    }
    private override init() {
        super.init()
        self.manager = CBCentralManager(delegate:self, queue: nil)
    }
        

    func centralManagerDidUpdateState(_ central: CBCentralManager){
        print("开始扫描外围设备")
        switch central.state {
        case .unknown:
            print("CBCentralManagerStateUnknown")
        case .resetting:
            print("CBCentralManagerStateResetting")
        case .unsupported:
            print("CBCentralManagerStateUnsupported 不支持蓝牙")
        case .unauthorized:
            print("CBCentralManagerStateUnauthorized 未获取权限")
        case .poweredOff:
            print("CBCentralManagerStatePoweredOff 蓝牙关")
        case .poweredOn:
            print("CBCentralManagerStatePoweredOn 蓝牙开")
            startScan();
        }
        
    }
    
    func startScan() {
        print("开始扫描周围设备")
        manager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        //接下连接我们的测试设备，如果你没有设备，可以下载一个app叫lightbule的app去模拟一个设备
        /*
         一个主设备最多能连7个外设，每个外设最多只能给一个主设备连接,连接成功，失败，断开会进入各自的委托
         func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
         func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?)
         func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?)
         */
        //找到的设备必须持有它，否则CBCentralManager中也不会保存peripheral，那么CBPeripheralDelegate中的方法也不会被调用！
        print("找到设备就会调用如下方法")
        
        var isExisted = false
        for obtainedPeriphal  in discoveredPeripheralsArr {
            if (obtainedPeriphal?.identifier == peripheral.identifier){
                isExisted = true
            }
        }
        
        if !isExisted{
            
            if peripheral.name != nil {
                discoveredPeripheralsArr.append(peripheral)
            }
        }
        
    }
    
    
    //连接上
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        print("连接外设成功的委托")
        connectedPeripheral = peripheral
        //外设寻找service
        peripheral.discoverServices(nil)
        
        peripheral.delegate = self
//        self.title = peripheral.name
        manager .stopScan() //连接上后我们就停止扫描，并查找Peripheral的service
        
        let alertController = UIAlertController.init(title: "已连接上 \(String(describing: peripheral.name))", message: nil, preferredStyle: .alert)
//        self.present(alertController, animated: true) {
//            
//            alertController.dismiss(animated: false, completion: {
//                //连接上后跳转
//                let inputController = InputValueController.init()
//                self.present(inputController, animated: true) {
//                }
//                inputController.imputValueBlock = { (sendStr ) -> () in
//                    self.sendString = sendStr as NSString!
//                    let data = sendStr?.data(using: .utf8)
//                    self.viewController(self.connectedPeripheral , didWriteValueFor :self.savedCharacteristic, value: data!)
//                }
//            })
//        }
    }
    
    //连接到Peripherals-失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?){
        print("外设连接失败的委托")
        print("连接到名字为 \(String(describing: peripheral.name)) 的设备失败，原因是 \(String(describing: error?.localizedDescription))")
        
    }
    ///断开
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        print("断开外设的委托")
        print("连接到名字为 \(String(describing: peripheral.name)) 的设备断开，原因是 \(String(describing: error?.localizedDescription))")
        
        let alertView = UIAlertController.init(title: "抱歉", message: "蓝牙设备\(String(describing: peripheral.name))连接断开，请重新扫描设备连接", preferredStyle: UIAlertControllerStyle.alert)
//        alertView.show(self, sender: nil)
        
    }
    // CBPeripheralDelegate
    
    
    //扫描到Services
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
        print("扫描到service，我们走协议方法")
        if (error != nil){
            print("查找 services 时 \(String(describing: peripheral.name)) 报错 \(String(describing: error?.localizedDescription))")
        }
        
        for service in peripheral.services! {
            //需要连接的 CBCharacteristic 的 UUID
            if service.uuid.uuidString == ServiceUUID1{
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    
    //扫描到 characteristic
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        print("获取到service会走 1")
        if error != nil{
            print("查找 characteristics 时 \(String(describing: peripheral.name)) 报错 \(String(describing: error?.localizedDescription))")
        }
        
        for characteristic in service.characteristics! {
            peripheral.readValue(for: characteristic)
            peripheral.setNotifyValue(true, for: characteristic)//设置 characteristic 的 notifying 属性 为 true ， 表示接受广播
        }
    }
    
    //获取的charateristic的值
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        print("获取到service会走 2")
        let resultStr = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)! as String
        
        print("characteristic uuid:\(characteristic.uuid)   value:\(String(describing: resultStr))")
        
        if lastString as String == resultStr{
            return;
        }
        
        // 操作的characteristic 保存
        self.savedCharacteristic = characteristic
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?){
        if error != nil{
            print("写入 characteristics 时 \(String(describing: peripheral.name)) 报错 \(String(describing: error?.localizedDescription))")
        }
        
        let alertView = UIAlertController.init(title: "抱歉", message: "写入成功", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction.init(title: "好的", style: .cancel, handler: nil)
        alertView.addAction(cancelAction)
//        alertView.show(self, sender: nil)
        if characteristic.value == nil{
            lastString = ""
        }else{
            lastString = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)!
        }
        
    }
    
}

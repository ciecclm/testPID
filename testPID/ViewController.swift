//
//  ViewController.swift
//  testPID
//
//  Created by clm on 2017/7/12.
//  Copyright © 2017年 clm. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
   
    var client: TCPClient?
    @IBOutlet weak var IPaddress: UITextField!
    @IBOutlet weak var receivemsg: UILabel!
    @IBOutlet weak var IPport: UITextField!
    @IBOutlet weak var pidp1: UIStepper!
    @IBOutlet weak var pidp2: UIStepper!
    @IBOutlet weak var pidp3: UIStepper!
    @IBOutlet weak var pidp4: UIStepper!
    
    @IBOutlet weak var pidi1: UIStepper!
    @IBOutlet weak var pidi2: UIStepper!
    @IBOutlet weak var pidi3: UIStepper!
    @IBOutlet weak var pidi4: UIStepper!
    
    @IBOutlet weak var pidd1: UIStepper!
    @IBOutlet weak var pidd2: UIStepper!
    @IBOutlet weak var pidd3: UIStepper!
    @IBOutlet weak var pidd4: UIStepper!
    
    @IBOutlet weak var angle: UIStepper!
    
    @IBOutlet weak var connectbtn: UIButton!
    @IBAction func steperact(_ sender: Any) {
        stepperValueIschanged()
        
    }

    @IBOutlet weak var Ptext: UITextField!
    @IBOutlet weak var Itxt: UITextField!
    @IBOutlet weak var Dtxt: UITextField!
    
    @IBAction func connectiontoIP(_ sender: Any) {
        client = TCPClient(address: IPaddress.text!, port: Int32(IPport.text!)!)
        guard let client = client else { return }

        switch client.connect(timeout: 2) {
        case .success:
            connectbtn.isUserInteractionEnabled=false
            receivemsg.text = String("已连接")
        case .failure(let error):
            receivemsg.text = String(describing: error)
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        IPaddress.delegate=self
        IPport.delegate=self
        IPaddress.text="192.168.0.36"
        IPport.text="8899"
        
    }
    
    func stepperValueIschanged(){
        Ptext.text="当前值为：\(pidp1.value+pidp2.value+pidp3.value+pidp4.value)"
        Itxt.text="当前值为：\(pidi1.value+pidi2.value+pidi3.value+pidi4.value)"
        Dtxt.text="当前值为：\(pidd1.value+pidd2.value+pidd3.value+pidd4.value)"
        IPport.text="\(angle.value)"
        /*
        let mp=(pidp1.value+pidp2.value+pidp3.value+pidp4.value) as Int
        let mi=(pidi1.value+pidi2.value+pidi3.value+pidi4.value) as Int
        let md=(pidd1.value+pidd2.value+pidd3.value+pidd4.value) as Int
        */
        let tempstrp=String(format:"%06.2f",pidp1.value+pidp2.value+pidp3.value+pidp4.value)
        print(tempstrp)
        let tempstri=String(format:"%06.2f",pidi1.value+pidi2.value+pidi3.value+pidi4.value)
        let tempstrd=String(format:"%06.2f",pidd1.value+pidd2.value+pidd3.value+pidd4.value)
        let tempsangle=String(format:"%06.2f",angle.value)
        
        let sendmessage=tempstrp+tempstri+tempstrd+tempsangle
        print("send:"+sendmessage)
        
        guard let client = client else { return }
        
        switch client.connect(timeout: 2) {
        case .success:
            appendToTextField(string: "Connected to host \(client.address)")
            if let response = sendRequest(string: sendmessage, using: client) {
                appendToTextField(string: "Response: \(response)")
            }
        case .failure(let error):
            appendToTextField(string: String(describing: error))
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.IPaddress.endEditing(true)
        self.IPport.endEditing(true)
        /*
        self.multiplep.endEditing(true)
        self.multiplei.endEditing(true)
        self.multipled.endEditing(true)
        */
        //也可以用下面这个方法
        //self.mytext.resignFirstResponder();
        return true;
    }

    private func sendRequest(string: String, using client: TCPClient) -> String? {
        appendToTextField(string: "Sending data ... ")
        
        switch client.send(string: string) {
        case .success:
            return readResponse(from: client)
        case .failure(let error):
            appendToTextField(string: String(describing: error))
            return nil
        }
    }
    
    private func readResponse(from client: TCPClient) -> String? {
        guard let response = client.read(20) else { return nil }
       // receivemsg.text=String(bytes: response, encoding: .utf8)
        return String(bytes: response, encoding: .utf8)
    }
    
    private func appendToTextField(string: String) {
        print(string)
        receivemsg.text = ("\(string)")
    }



}


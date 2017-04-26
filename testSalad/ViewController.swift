//
//  ViewController.swift
//  testSalad
//
//  Created by naomi-hidaka on 2017/04/26.
//  Copyright © 2017年 naomi-hidaka. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var hogeLabel: UILabel!
    var handle: UInt?
    var hogeRef: FIRDatabaseReference? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let ref: FIRDatabaseReference = FIRDatabase.database().reference()
        self.hogeRef = ref.child("hoge")
        self.hogeRef?.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            self.hogeLabel.text = snapshot.value as? String
        })
        self.handle = self.hogeRef?.observe(.value, with: { (snapshot) in
            self.hogeLabel.text = snapshot.value as? String
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.hogeRef?.setValue("wwwwwwwww")
        })

    }

    deinit {
        if let handle = handle {
            hogeRef?.removeObserver(withHandle: handle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


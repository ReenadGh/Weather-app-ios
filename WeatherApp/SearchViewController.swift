//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Reenad gh on 22/05/1443 AH.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var zipcodeTextF: UITextField!
    var passZipCode : zipCodeBus?
    @IBAction func serachForWearher(_ sender: Any) {
        
        guard let enterdZipcode = zipcodeTextF.text else {return }
        
        passZipCode?.passZipCode(zipCode: enterdZipcode)
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

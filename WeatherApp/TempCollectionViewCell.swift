//
//  TempCollectionViewCell.swift
//  WeatherApp
//
//  Created by Reenad gh on 21/05/1443 AH.
//

import UIKit

class TempCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var hourlbl: UILabel!
    
    @IBOutlet weak var monthlbl: UILabel!
    @IBOutlet weak var daylbl: UILabel!
    
 
    func settempCell(temp:String , hour : String , img : UIImage , day : String , month :String  ){
        self.temp.text = temp
        self.hourlbl.text = hour
        self.img.image = img
        self.daylbl.text = day
        self.monthlbl.text = month

   }
}



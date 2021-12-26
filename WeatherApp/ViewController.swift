//
//  ViewController.swift
//  WeatherApp
//
//  Created by Reenad gh on 21/05/1443 AH.
//

import UIKit



class ViewController: UIViewController  , UICollectionViewDataSource  , UICollectionViewDelegate , zipCodeBus {
    @IBOutlet weak var lowTemplbl: UILabel!
    @IBOutlet weak var highTemplbl: UILabel!
    @IBOutlet weak var cityNamelbl: UILabel!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var stsuslbl: UILabel!
    @IBOutlet weak var templbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var tempCollectionView: UICollectionView!
    var DailyWeather = [List] ()
    var zipCode = "10006" // defult zip code : newYork city

   
    override func viewDidLoad() {
        super.viewDidLoad()
        tempCollectionView.dataSource = self
        tempCollectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataFromApi(zipCode: zipCode)
      
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(DailyWeather.count)
        return DailyWeather.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = tempCollectionView.dequeueReusableCell(withReuseIdentifier:"tempCell", for: indexPath) as! TempCollectionViewCell

        cell.settempCell(
            temp: ConvertKivToC(temperature : DailyWeather[indexPath.row].main.temp) ,
            hour : fromDtToformatedDate(dt: Double (DailyWeather[indexPath.row].dt) , foramt : "h:mm a" )  ,
            img: getWeatherStatusImg( status: DailyWeather[indexPath.row].weather[0].main.rawValue ),
            day : fromDtToformatedDate(dt: Double (DailyWeather[indexPath.row].dt) , foramt : "EEEE" ),
            month : fromDtToformatedDate(dt: Double (DailyWeather[indexPath.row].dt) , foramt : "MMM d" )
        )
        
        return cell
    }
    
   
    
 

    // pass zip code value by protocol and delegate
    
    func passZipCode(zipCode: String) {
        print(zipCode)
        self.zipCode = zipCode
        getDataFromApi(zipCode: zipCode)

    }
    @IBAction func takenewZipCode(_ sender: Any) {
        
        let searchView = self.storyboard?.instantiateViewController(withIdentifier: "serachbyZipCpde")as!SearchViewController
        searchView.passZipCode = self
        present(searchView, animated: true, completion: nil)
    }
    
    
    
    func fromDtToformatedDate(dt: Double, foramt : String ) -> String {
        
//        Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
//        09/12/2018                        --> MM/dd/yyyy
//        09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
//        Sep 12, 2:11 PM                   --> MMM d, h:mm a
//        September 2018                    --> MMMM yyyy
//        Sep 12, 2018                      --> MMM d, yyyy
//        Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
//        2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
//        12.09.18                          --> dd.MM.yy
//        10:41:02.112                      --> HH:mm:ss.SSS
        
          let date = Date(timeIntervalSince1970: dt)
        let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = foramt
          return dateFormatter.string(from: date)
      }
    
    
   
    func ConvertKivToC(temperature : Double)->String {
       return  "\(String(format: "%.0f", temperature - 273.15))°"
    }
    
    
   func getWeatherStatusImg(status : String )->UIImage {
      
       switch status {
       case "Clouds":
           return UIImage(systemName: "cloud.fill")!
       case "Rain":
           return  UIImage(systemName: "cloud.rain.fill")!
       case "Clear":
           return UIImage(systemName: "sun.max")!
       case "Snow":
           return UIImage(systemName: "cloud.snow.fill")!
       default:
           return UIImage(systemName: "cloud.snow.fill")!
       }
    
    }
    
    
    
    
    func getDataFromApi(zipCode : String ){
        
        
        let jsonURLstring = "http://api.openweathermap.org/data/2.5/forecast?zip=\(zipCode)&appid=553626bed26b25f56af0d6fa3890d1c5"
        guard let url = URL(string : jsonURLstring) else {return }
        URLSession.shared.dataTask(with: url) { data , response, errur in
            guard let data = data else {return }
            
            let dataAsString = String(data: data , encoding: .utf8)
            
            do {
                let watherData = try JSONDecoder().decode( Welcome.self ,from: data )
            
                self.DailyWeather.removeAll()
                for i in 0...20{
                    self.DailyWeather.append(watherData.list[i])
                }
                
                DispatchQueue.main.async {
                    
                    self.templbl.text = self.ConvertKivToC(temperature :watherData.list[0].main.temp)
                    self.cityNamelbl.text = watherData.city.name
                    self.datelbl.text = self.fromDtToformatedDate(dt:Double(watherData.list[0].dt) , foramt : "EEEE, MMM d, yyyy" )
                    self.statusImg.image = self.getWeatherStatusImg( status: watherData.list[0].weather[0].main.rawValue )
                    self.stsuslbl.text = watherData.list[0].weather[0].weatherDescription
                    self.lowTemplbl.text = "\(self.ConvertKivToC(temperature : Double(watherData.list[0].main.tempMin)))↓"
                    self.highTemplbl.text = "\(self.ConvertKivToC(temperature : Double(watherData.list[0].main.tempMax)))↑"
                    
                    self.tempCollectionView.reloadData()
                    
                }
                print (self.DailyWeather)
            }catch let jsonErr{
                print("Error :" ,jsonErr )
            }
            
        }.resume()
    }
 
    

}


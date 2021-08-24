//
//  ViewController.swift
//  APIsession
//
//  Created by apple on 26/07/21.

import UIKit
import CoreData
import SDWebImage
class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [APIsessionEntity]()
    
    @IBOutlet weak var tableUsers: UITableView!
    var usersArray : [Entry]?
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //        deleteAllData("APIsessionEntity")
        self.callAPIUsingSession()
    }
    
    //MARK:- API Calling using URL Session
    func callAPIUsingSession() {
        
        //    1 -> Convert the url
        let Url = String(format: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=200/json")
        guard let serviceUrl = URL(string: Url) else {
            print("Invalid URL")
            return
        }
        
        //2 -> Create a request which will tell server the method and required thing he needed to know
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        // 3 -> Fetches the data from server
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] (data, response, error) in
            if let response = response {
                print(response)
            }
            
            // 4 -> Handle the response
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(ModelActor.self, from: data)
                    self?.usersArray = decodedResponse.feed?.entry ?? []
                    //Comment below part if using local storage
                    DispatchQueue.main.async {
                        self?.tableUsers.reloadData()
                    }
                    
                    //MARK:- Store Data In Core Data
//                    for someData in self!.usersArray! {
//                        self?.createItem(name: someData.imName?.label ?? "", price: someData.imPrice?.label ?? "", image: someData.imImage?[0].label ?? "", summary: someData.summary?.label ?? "")
//                    }
//                    self?.getAllItems()
//
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    //MARK:- Core Data
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    func getAllItems(){
        do{
            models = try context.fetch(APIsessionEntity.fetchRequest())
            DispatchQueue.main.async {
                self.tableUsers.reloadData()
            }
        }catch{
            //error
        }
    }
    
    func createItem(name : String, price : String, image : String, summary : String){
        let newItem = APIsessionEntity(context: context)
        newItem.summary = summary
        newItem.imName = name
        newItem.imPrice = price
        newItem.imImage = image
        do{
            try context.save()
            //            getAllItems()
        }catch{
            //error
        }
    }
}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        
        //MARK:- To Diplsay Data From API CALL
        cell.lblNames.text = self.usersArray?[indexPath.row].imName?.label ?? ""
        cell.imageViewGames.sd_setImage(with: URL(string: self.usersArray?[indexPath.row].imImage?[0].label ?? ""), placeholderImage: UIImage(named: ""))
        cell.priceLabel.text = self.usersArray?[indexPath.row].imPrice?.label ?? ""
        
        //MARK:- If You Want To Display Data From Local Storage
        //
        //        let item = models[indexPath.row]
        //
        //        cell.lblNames.text = item.imName
        //        cell.imageViewGames.sd_setImage(with: URL(string: item.imImage ?? ""), placeholderImage: UIImage(named: ""))
        //        cell.priceLabel.text = item.imPrice
        
        //MARK:- To Delete Data Stored In Local Storage
        //        self.deleteItem(item: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as!
            DetailViewController
        
        //MARK:- Data Directly Displayed From API CALL
        vc.summary = self.usersArray?[indexPath.row].summary?.label ?? ""
        vc.image = self.usersArray?[indexPath.row].imImage?[0].label ?? ""
        vc.name = self.usersArray?[indexPath.row].imName?.label ?? ""
        vc.price = self.usersArray?[indexPath.row].imPrice?.label ?? ""
        
        //MARK:- If You Want To Display Data From Local Storage
        //        let item = models[indexPath.row]
        //        vc.summary = item.summary
        //        vc.image = item.imImage
        //        vc.name = item.imName
        //        vc.price = item.imPrice
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

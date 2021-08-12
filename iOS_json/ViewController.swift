//
//  ViewController.swift
//  iOS_json
//
//  Created by ac1ra on 10.08.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    let url = URL(string: "https://api.opendota.com/api/heroStats")

    var isSearching = false
    
    var filteredData: [String] = []
    
    var heroes = [heroStats]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        downloadJSON()
        
        searchBar.delegate = self
        
        for itm in heroes {
            filteredData = [itm.localized_name]
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        } else{
            return heroes.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        //MARK: isSearching
        
        if isSearching {
            cell.nameCell.text = filteredData[indexPath.row]
        } else{
        
        cell.nameCell.text = heroes[indexPath.row].localized_name
        cell.attributeCell.text = heroes[indexPath.row].primary_attr
        cell.attackCell.text = heroes[indexPath.row].attack_type

        if let imgURL = URL(string: "https://api.opendota.com" + self.heroes[indexPath.row].img){
            
            //MARK: method#1 downloading image files from cell
        DispatchQueue.global().async {
                let data = try? Data(contentsOf: imgURL)
                if let data = data{
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imgViewCell.image =  image
                    }
                }
            }
        }
        }
        return cell
    
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination  = segue.destination as? DetailViewController{
            destination.hero = heroes[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    func downloadJSON() {
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.heroes = try! JSONDecoder().decode([heroStats].self, from: data!)
                    
                DispatchQueue.main.async{
                    for one in self.heroes{
                        print("id:\(one.id), local:\(one.localized_name), attribute:\(one.primary_attr), attack:\(one.attack_type), image:\(one.img)")
                        }
                    self.tableView.reloadData()
                    }
                }catch{
                    print("JSON error")
                }
            }
        }.resume()
    }
    //MARK: Search Bar config
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        
        if searchText == "" {
            isSearching = false
//            for o in self.heroes {
//                self.filteredData = [o.localized_name]
//            }
            } else {
            isSearching = true
            
            for item in heroes{
               
                if item.localized_name.lowercased().contains(searchText.lowercased()) {
                    
                    filteredData.append(item.localized_name)
                }
            }
        }
        tableView.reloadData()
    }
}

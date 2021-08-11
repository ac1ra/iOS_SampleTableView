//
//  ViewController.swift
//  iOS_json
//
//  Created by ac1ra on 10.08.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let url = URL(string: "https://api.opendota.com/api/heroStats")

    var heroes = [heroStats]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        downloadJSON()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.nameCell.text = heroes[indexPath.row].localized_name
        cell.attributeCell.text = heroes[indexPath.row].primary_attr
        cell.attackCell.text = heroes[indexPath.row].attack_type

        if let imgURL = URL(string: "https://api.opendota.com" + self.heroes[indexPath.row].img){
            
            //mark: method#1 downloading image files from cell
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
}

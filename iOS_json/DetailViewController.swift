//
//  DetailViewController.swift
//  iOS_json
//
//  Created by ac1ra on 10.08.2021.
//

import UIKit

class DetailViewController: UIViewController {

    var hero:heroStats?
    
    @IBOutlet weak var imgViewDetail: UIImageView!
    @IBOutlet weak var nameDetial: UILabel!
    @IBOutlet weak var attributeDetail: UILabel!
    @IBOutlet weak var attackDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameDetial.text = hero?.localized_name
        attackDetail.text = hero?.attack_type
        attributeDetail.text = hero?.primary_attr

        let urlstrh = "https://api.opendota.com" + (hero?.img)!
        let url_img = URL(string: urlstrh)
        
        imgViewDetail.downloaded(from: url_img!)
    }
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

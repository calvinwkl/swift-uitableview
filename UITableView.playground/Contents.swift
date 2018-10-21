//: # Using UITableView in Swift
//:
//: ## [1. The Basics](https://medium.com/p/bdc0048c2a94/)

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct Place: Decodable {
    let name: String
    let desc: String    
}

class TravelViewController: UIViewController {
    
    var tableView = UITableView()
    var places: [Place]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        
        fetchData()
    }
    
    func fetchData() {
        if let url = URL(string: "https://api.myjson.com/bins/hg9uk") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let places = try JSONDecoder().decode([Place].self, from: data)
                        DispatchQueue.main.async {
                            self.places = places
                            self.tableView.reloadData()
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
}

extension TravelViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let places = places {
            return places.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let places = places {
            cell.textLabel?.text = "\(places[indexPath.row].name), \(places[indexPath.row].desc)"
            cell.textLabel?.numberOfLines = 0
        }
        return cell
    }
}

PlaygroundPage.current.liveView = TravelViewController()

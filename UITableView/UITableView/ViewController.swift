//
//  ViewController.swift
//  UITableView
//
//  Created by Wong Ka Lok on 30/12/2018.
//  Copyright © 2018 Wong Ka Lok. All rights reserved.
//

import UIKit
import SafariServices

import RxSwift
import RxCocoa

struct Place: Decodable {
    let name: String
    let desc: String
    let url: String
}

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    let tableView = UITableView()
    let places: BehaviorRelay<[Place]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Travel"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        places.bind(to: tableView.rx.items(cellIdentifier: "cell")) { row, model, cell in
            cell.textLabel?.text = "\(model.name), \(model.desc)"
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Place.self)
            .map{ URL(string: $0.url) }
            .subscribe(onNext: { [weak self] url in
                guard let url = url else {
                    return
                }
                self?.present(SFSafariViewController(url: url), animated: true)
        }).disposed(by: disposeBag)
        
        fetchData()
    }
    
    func fetchData() {
        if let url = URL(string: "https://api.myjson.com/bins/16w6h0") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let places = try JSONDecoder().decode([Place].self, from: data)
                        self.places.accept(places)
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }

}


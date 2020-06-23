//
//  TableViewController.swift
//  weatherproj
//
//  Created by Angelo Ou on 6/18/20.
//  Copyright © 2020 Angelo Ou. All rights reserved.
//

import UIKit
import WeatherFramework

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var listOfMainInfo = [Double]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView : UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfMainInfo.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentRow = indexPath.row
        
        if currentRow == 0 {
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "MM/dd/yyyy"
            let currentDate = format.string(from: date)
            cell.textLabel?.text = "Today's Date: "
            cell.detailTextLabel?.text = currentDate
        }
        else if currentRow == 1 {
            cell.textLabel?.text = "Current Temperature:"
            cell.detailTextLabel?.text = String(listOfMainInfo[currentRow - 1]) + " ℉"
        } else if currentRow == 2 {
            cell.textLabel?.text = "Mininum Temperature:"
            cell.detailTextLabel?.text = String(listOfMainInfo[currentRow - 1]) + " ℉"
        } else if currentRow == 3 {
            cell.textLabel?.text = "Maxinum Temperature:"
            cell.detailTextLabel?.text = String(listOfMainInfo[currentRow - 1]) + " ℉"
        } else if currentRow == 4 {
            cell.textLabel?.text = "Pressure"
            cell.detailTextLabel?.text = String(listOfMainInfo[currentRow - 1]) + " hpa"
        } else {
            cell.textLabel?.text = "Humidity:"
            cell.detailTextLabel?.text = String(listOfMainInfo[currentRow - 1]) + " %"
        }
        
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {
            return
        }
        let request = WeatherRequest(city: searchBarText)
        request.getWeather { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let mainInfo):
                self?.listOfMainInfo = [mainInfo.temp, mainInfo.temp_min, mainInfo.temp_max, mainInfo.pressure, mainInfo.humidity]
            }
        }
    }
}

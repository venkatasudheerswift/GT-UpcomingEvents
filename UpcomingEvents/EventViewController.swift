//
//  EventViewController.swift
//  UpcomingEvents
//
//  Created by Venkata Sudheer Muthineni on 5/1/22.
//

import UIKit

final class EventViewController: UIViewController {
    private var items: [Event] = []
    private var groupedItems: [Date: [Event]] = [:]
    private var dates: [Date] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if let eventsArray = loadJson(fileName: "mock") {
            items = eventsArray
            configureData()
        }
    }
    
    private func configureData(){
        groupedItems = Dictionary(grouping: items, by: { Calendar.current.startOfDay(for: $0.start) })
        dates = groupedItems.map { return $0.key }
        dates.sort { (($0).compare($1)) == .orderedAscending }
    }
    
    private func getObject(day: Date, row: Int) -> Event? {
        if let object = groupedItems[day] {
            return object[row]
        }
        return nil
    }
}

//MARK: TableViewDataSource
extension EventViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = dates[section]
        return groupedItems[day]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = getObject(day: dates[indexPath.section], row: indexPath.row)
        
        guard let cell: EventCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = object?.title
        let warningImage = UIImage(named: "warning")
        cell.imageview.image = (object?.conflict ?? false) ? warningImage : nil
        return cell
    }
    
}

//MARK: TableViewDelegate
extension EventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dates[section].description
    }
}



//
//  ListPlacesMapTableViewController.swift
//  Le Baluchon
//
//  Created by Yoan on 23/04/2022.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController {

    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    var handleMapSearchDelegate: HandleMapSearch?

    @IBOutlet var searchBar: SearchResultController!
    @IBOutlet var locationSearchTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
              let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.locationSearchTable.reloadData()
        }
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let mapView = mapView,
              let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.locationSearchTable.reloadData()
        }
    }
}

extension LocationSearchTable {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case locationSearchTable:
            return matchingItems.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListPlaces")!
        let selectedItem = matchingItems[indexPath.row].placemark
        let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = selectedItem.name
            content.secondaryText = address
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = selectedItem.name
            cell.detailTextLabel?.text = address
        }
        
        return cell
    }
}
    

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
    }
}

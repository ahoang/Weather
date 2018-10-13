//
//  HomeViewController.swift
//  Weather
//
//  Created by Anthony Hoang on 10/12/18.
//  Copyright © 2018 Anthony Hoang. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!

    private var pins = [String : MKAnnotation]()
    private var favoritesService = FavoritesService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoritesService.tableView = self.tableView
        self.mapView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    @IBAction func userDidLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        let location = sender.location(in: mapView)
        let coordinates = mapView.convert(location, toCoordinateFrom: mapView)

        WeatherService.getCurrentWeather(lat: coordinates.latitude, long: coordinates.longitude, success: { [weak self] (city) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.favoritesService.insertNewObject(city)
                self.tableView.reloadData()
            }

        }) { (error) in

        }
    }

    private func requestLocation(_ coordinates: CLLocationCoordinate2D) {

    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.favoritesService.fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.favoritesService.fetchedResultsController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            fatalError("no cell registered")
        }
        let city = self.favoritesService.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = city.name
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
        pin.title = city.name
        self.pins[city.name!] = pin
        self.mapView.addAnnotation(pin)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let city = self.favoritesService.fetchedResultsController.object(at: indexPath).name else { return }
            if let pin = self.pins[city] {
                self.mapView.removeAnnotation(pin)
                self.pins[city] = nil
            }
            self.favoritesService.deleteObject(indexPath)
        }
    }
}

extension HomeViewController: MKMapViewDelegate {
    
}

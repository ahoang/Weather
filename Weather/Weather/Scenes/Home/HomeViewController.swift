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

    private var favorites = [City]()
    private var pins = [String : MKAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    @IBAction func userDidLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        let location = sender.location(in: mapView)
        let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)


        WeatherService.getCurrentWeather(lat: coordinates.latitude, long: coordinates.longitude, success: { [weak self] (city) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                pin.title = city.name
                self.pins[city.name] = pin
                self.favorites.append(city)
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
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            fatalError("no cell registered")
        }
        let city = self.favorites[indexPath.row]
        cell.textLabel?.text = city.name

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = self.favorites[indexPath.row]
            if let pin = self.pins[city.name] {
                self.mapView.removeAnnotation(pin)
                self.pins[city.name] = nil
            }

            self.favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension HomeViewController: MKMapViewDelegate {
    
}

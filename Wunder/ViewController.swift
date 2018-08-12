//
//  ViewController.swift
//  Wunder
//
//  Created by Soham Bhowmik on 09/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
    let carViewModel = CarViewModel()
    @IBOutlet weak var carTableView: UITableView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    let kCarTableCellReuseId = "CarTableCellReuseId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupBindings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupBindings()
    {
        carViewModel.carArray.bind { [unowned self] (_)  in
            self.carTableView.reloadData()
        }
        
        carViewModel.isLoading.bind { [unowned self](isLoading) in
            if isLoading {
                self.loadingIndicator.startAnimating()
            }
            else{
                self.loadingIndicator.stopAnimating()
            }
        }
        
        carViewModel.errorUserInfo.bind { (errString) in
            //handle appropiate error with status code or desc as required
        }
    }
    
    func registerCells() {
        carTableView.register(UINib(nibName: "CarTableViewCell", bundle: nil), forCellReuseIdentifier: kCarTableCellReuseId)
        carTableView.estimatedRowHeight = 90.0
        carTableView.rowHeight = UITableViewAutomaticDimension
        carTableView.separatorStyle = .none
    }
    
    
    @IBAction func displayMapView(_ sender: UIBarButtonItem) {
        let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
        mapViewController.carViewModel = carViewModel
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    //Table View DataSource and Delegates
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carViewModel.carArray.value.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: kCarTableCellReuseId, for: indexPath) as? CarTableViewCell
        {
            cell.nameLabel.text = carViewModel.nameOfCar(atIndex: indexPath.row)
            cell.addressLabel.text = carViewModel.addressOfCar(atIndex: indexPath.row)
            cell.vinLabel.text = carViewModel.vinOfCar(atIndex: indexPath.row)
            cell.engineLabel.text = carViewModel.engineTypeOfCar(atIndex: indexPath.row)
            //cell.fuelLabel.text = carViewModel.fuelContainedInCar(atIndex: indexPath.row)
            cell.interiorLabel.text = carViewModel.interiorConditionOfCar(atIndex: indexPath.row)
            cell.exteriorLabel.text = carViewModel.exteriorConditionOfCar(atIndex: indexPath.row)
            //let width = CGFloat(Int(carViewModel.fuelContainedInCar(atIndex: indexPath.row))!/100)
            cell.fuelPercentageViewWidthConstraint.constant = CGFloat(carViewModel.percentFuelContainedInCar(atIndex: indexPath.row))
            cell.fuelPecentageView.backgroundColor = carViewModel.fuelIndicatorColor(atIndex: indexPath.row)
            
            return cell
        }
        else{
            return tableView.dequeueReusableCell(withIdentifier: kCarTableCellReuseId, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("CarTableHeaderView", owner: self, options: nil)?.first as! CarTableHeaderView
        headerView.delegate = self
        return headerView
    }

}

extension ViewController: CarTableHeaderDelegate {
    
    //Text Field Delegates use as necessary
    func textFieldDidBeginEditing(_ textField: UITextField, inCarTableHeaderView headerView: CarTableHeaderView)
    {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, inCarTableHeaderView headerView: CarTableHeaderView)
    {
        carViewModel.restoreCarsList()
    }
    
    func textFieldShouldReturn(_ textField: UITextField, inCarTableHeaderView headerView: CarTableHeaderView)
    {
        
    }
    
    func changeCharactersInRange(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, inCarTableHeaderView headerView: CarTableHeaderView)
    {
        if textField.text == nil {
            textField.text = ""
        }
        let currentString: NSString = textField.text! as NSString
        let finalString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        carViewModel.searchCarsWith(searchString: finalString as String)
    }
    
}




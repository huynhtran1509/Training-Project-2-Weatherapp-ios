//
//  SettingsTableViewController.swift
//  Project2
//
//  Created by KFernandez on 1/26/17.
//  Copyright © 2017 KFernandez. All rights reserved.
//

import UIKit

class SettingsTableViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyles()
    }
    
    // MARK: - NavigationBar style
    func setNavigationBarStyles() {
        let backImage = UINavigationBar.appearance().backgroundImage(for: .default)
        navigationController?.navigationBar.setBackgroundImage(backImage, for: .default)
        navigationController?.navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
        navigationController?.navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        navigationController?.navigationBar.backgroundColor = UINavigationBar.appearance().backgroundColor
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        return cell
    }
    
    
    
}

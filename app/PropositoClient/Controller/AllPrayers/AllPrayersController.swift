//
//  AllPrayersController.swift
//  PropositoClient
//
//  Created by Matheus Silva on 01/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class AllPrayersController: UIViewController {
    @IBOutlet weak var illustrationPrayer: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var prayerAllCellDelegate: PrayerAllCellDelegate = PrayerAllCellDelegate(prayers: [])
    var prayerAllCellDataSource: PrayerAllCellDataSource = PrayerAllCellDataSource(prayers: [])
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup() {
        setupCellDelegate()
        setupCellDataSource()
        loadCellData()
        prayerIllustration()
        setupEvents()
    }
    func setupCellDelegate() {
        prayerAllCellDelegate.setup(collectionView: collectionView, viewController: self)
    }
    func setupCellDataSource() {
        prayerAllCellDataSource.setup(collectionView: collectionView, viewController: self)
    }
    func loadCellData() {
        prayerAllCellDataSource.fetch(delegate: prayerAllCellDelegate)
    }
    func prayerIllustration() {
        if prayerAllCellDataSource.prayers.count > 0 {
            illustrationPrayer.alpha = 0
        } else {
            illustrationPrayer.alpha = 1
        }
    }
    func setupEvents() {
        EventManager.shared.listenTo(eventName: "addPrayer") {
            self.prayerAllCellDataSource.fetch(delegate: self.prayerAllCellDelegate)
        }
    }
    func generatorImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    @IBAction func close(_ sender: Any? = nil) {
        generatorImpact()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func add(_ sender: Any? = nil) {
        generatorImpact()
    }
}
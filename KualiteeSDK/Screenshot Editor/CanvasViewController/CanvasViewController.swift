//
//  ViewController.swift
//  DeepLinkTest
//
//  Created by VF on 04/03/2019.
//  Copyright © 2019 VF. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet var colorCollectionView: UICollectionView!
    @IBOutlet var slider: UISlider!
    @IBOutlet var canvasBGView: UIView!
    @IBOutlet var undoBtn: UIButton!
    @IBOutlet var clearAllBtn: UIButton!
    @IBOutlet var canvas: KualiteeCanvas!
    @IBOutlet var canvasImageView: UIImageView!
    
    var image: UIImage?
    
    fileprivate var selectedColorIndex: Int = 0
    
    fileprivate var cellId: String = "ColorCollectionCell"
    
    fileprivate var colors: [UIColor] = [.black, .red, .green, .gray, .orange, .purple, .blue, .cyan, .yellow, .magenta]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerCells()
        
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        KualiteeSDK.hasConfigured = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        KualiteeSDK.hasConfigured = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.dismissBtn.getRounded(cornerRadius: self.dismissBtn.frame.width/2)
    }
    
    fileprivate func setupViews() {
        self.colorCollectionView.delegate = self
        self.colorCollectionView.dataSource = self
        
        
        self.slider.value = 3
        self.canvasImageView.image = self.image
    }
    
    fileprivate func registerCells() {
        self.colorCollectionView.register(CanvasColorCollectionCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    final internal func authForBugReport() {
        let alert = UIAlertController(title: "Kualitee", message: "Are you sure you want to report a bug? You will be redirected to Kualitee Application", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            KualiteeSDK.showDeepLinkedApp(key: "ss.png") { [weak self] (success) in
                guard let self = self else {return}
                if success == false {
                    KualiteeUtility.standardAlert(controller: self, title: "Error", message: "Kualitee Application is not installed in your system. Download it from AppStore.")
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func uploadFileToBucket(image: UIImage) {
        
        AWSKualiteeS3.uploadImageFileToBucket (image: image) { [weak self] (success, error) in
            guard let self = self else {return}
            if let err = error {
                KualiteeUtility.standardAlert(controller: self, title: "Error", message: err.localizedDescription)
                return
            }
            self.authForBugReport()
        }
    }
    
    @IBAction func brushWidthSliderAction(_ sender: Any) {
        let width = CGFloat(self.slider.value)
        self.canvas.updateBrushWidth(with: width)
    }
    
    @IBAction func undoAction(_ sender: Any) {
        self.canvas.undoChanges()
    }
    
    @IBAction func clearAllAction(_ sender: Any) {
        self.canvas.clearAll()
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        guard let image = self.canvasBGView.captureScreenshot() else {
            print("ss not captured")
            return
        }
        self.uploadFileToBucket(image: image)
    }
    
    deinit {
        print("CanvasViewController deinit")
    }
}

extension CanvasViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CanvasColorCollectionCell
        cell.backgroundColor = self.colors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = self.colors[indexPath.item]
        self.selectedColorIndex = indexPath.item
        self.canvas.updateBrushColor(with: color)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = selectedColorIndex == indexPath.item ? 35 : 30
        let height:CGFloat = selectedColorIndex == indexPath.item ? 35 : 30
        return CGSize(width: width, height: height)
    }
}

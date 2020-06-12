//
//  SettingsViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/21/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

extension UserDefaults {
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            do {
                colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
                set(colorData, forKey: key)
            } catch let error {print("Error archiving data", error)}
        }
    }
    
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            do {
                color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
            } catch let error {print("Error unarchiving data", error)}
        }
        return color
    }
}

class SettingsUIButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 6
    }
}

class TextUIButton: SettingsUIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOpacity = 0.2
    }
}

class IconUIButton: SettingsUIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        self.layer.shadowOpacity = 0.5
    }
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Views
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var tableVIew: UITableView!
    
    // Text Buttons
    @IBOutlet weak var clearBarrierButton: UIButton!
    @IBOutlet weak var clearPathButton: UIButton!
    @IBOutlet weak var godModeButton: UIButton!
    @IBOutlet weak var snakeSpeedButton: UIButton!
    @IBOutlet weak var foodWeightButton: UIButton!
    @IBOutlet weak var foodCountButton: UIButton!
    
    // Icon Buttons
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var stepOrPlayPauseButton: UIButton!
    @IBOutlet weak var darkOrLightModeButton: UIButton!
    
    let defaults = UserDefaults.standard
    let colors = [
        UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.00), // White Clouds
        UIColor(red:0.74, green:0.76, blue:0.78, alpha:1.00), // White Silver
        UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.00), // Light Gray Concrete
        UIColor(red:0.50, green:0.55, blue:0.55, alpha:1.00), // Light Gray Asbestos
        UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.00), // Dark Gray Wet Asphalt
        UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.00), // Dark Gray Green Sea
        UIColor(red:0.61, green:0.35, blue:0.71, alpha:1.00), // Purple Amethyst
        UIColor(red:0.56, green:0.27, blue:0.68, alpha:1.00), // Purple Wisteria
        UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.00), // Blue Peter River
        UIColor(red:0.16, green:0.50, blue:0.73, alpha:1.00), // Blue Belize Hole
        UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.00), // Green Emerald
        UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.00), // Green Nephritis
        UIColor(red:0.10, green:0.74, blue:0.61, alpha:1.00), // Teal Turquoise
        UIColor(red:0.09, green:0.63, blue:0.52, alpha:1.00), // Teal GreenSea
        UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.00), // Red Alizarin
        UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.00), // Red Pomegranate
        UIColor(red:0.90, green:0.49, blue:0.13, alpha:1.00), // Orange Carrot
        UIColor(red:0.83, green:0.33, blue:0.00, alpha:1.00), // Orange Pumpkin
        UIColor(red:0.95, green:0.77, blue:0.06, alpha:1.00), // Yellow Sun Flower
        UIColor(red:0.95, green:0.61, blue:0.07, alpha:1.00)] // Yellow Orange
    var legendData = [["Snake", 0], ["Snake Head", 0], ["Food", 3], ["Path", 17], ["Visited Square", 5], ["Queued Square", 15], ["Unvisited Square", 13], ["Barrier", 7], ["Weight", 19]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.integer(forKey: "Dark Mode On Setting") == 1 ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        loadViewStyling()
        loadButtonStyling()
    }
    
    func loadViewStyling() {
        leftView.layer.shadowColor = UIColor.darkGray.cgColor
        leftView.layer.shadowRadius = 10
        leftView.layer.shadowOpacity = 0.5
        leftView.layer.shadowOffset = .zero
    }
    
    func loadButtonStyling() {
        func boolButtonLoader(isIconButton: Bool, targetButton: UIButton, key: String, trueOption: String, falseOption: String) {
            let buttonSetting = NSNumber(value: defaults.bool(forKey: key)).intValue
            if isIconButton == true {
                buttonSetting == 1 ? (targetButton.setImage(UIImage(named: trueOption), for: .normal)) : (targetButton.setImage(UIImage(named: falseOption), for: .normal))
            } else {
                buttonSetting == 1 ? (targetButton.setTitle(trueOption, for: .normal)) : (targetButton.setTitle(falseOption, for: .normal))
            }
        }
        
        func fourOptionButtonLoader(targetButton: UIButton, key: String, optionArray: [String]) {
            let buttonSetting = defaults.integer(forKey: key)
            if buttonSetting == 1 {
                targetButton.setTitle(optionArray[0], for: .normal)
            } else if buttonSetting == 2 {
                targetButton.setTitle(optionArray[1], for: .normal)
            } else if buttonSetting == 3 {
                targetButton.setTitle(optionArray[2], for: .normal)
            } else {
                targetButton.setTitle(optionArray[3], for: .normal)
            }
        }
        
        var options = ["Speed: Slow", "Speed: Normal", "Speed: Fast", "Speed: Extreme"]
        fourOptionButtonLoader(targetButton: snakeSpeedButton, key: "Snake Speed Setting", optionArray: options)
        options = ["Food Weight: 1", "Food Weight: 2", "Food Weight: 3", "Food Weight: 5"]
        fourOptionButtonLoader(targetButton: foodWeightButton, key: "Food Weight Setting", optionArray: options)
        options = ["Food Count: 1", "Food Count: 2", "Food Count: 3", "Food Count: 5"]
        fourOptionButtonLoader(targetButton: foodCountButton, key: "Food Count Setting", optionArray: options)
        
        boolButtonLoader(isIconButton: false, targetButton: godModeButton, key: "God Button On Setting", trueOption: "God Mode: On", falseOption: "God Mode: Off")
        boolButtonLoader(isIconButton: true, targetButton: soundButton, key: "Volume On Setting", trueOption: "Volume_On_Icon.pdf", falseOption: "Volume_Mute_Icon.pdf")
        boolButtonLoader(isIconButton: true, targetButton: stepOrPlayPauseButton, key: "Step Mode On Setting", trueOption: "Step_Icon.pdf", falseOption: "Play_Icon.pdf")
        boolButtonLoader(isIconButton: true, targetButton: darkOrLightModeButton, key: "Dark Mode On Setting", trueOption: "Dark_Mode_Icon.pdf", falseOption: "Light_Mode_Icon.pdf")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legendData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        legendData = defaults.array(forKey: "Legend Preferences") as? [[Any]] ?? legendData
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsScreenTableViewCell
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.legendOptionText.text = legendData[indexPath.row][0] as? String
        cell.legendOptionSquareColor.backgroundColor = colors[(legendData[indexPath.row][1] as? Int)!]
        cell.legendOptionSquareColor.layer.borderWidth = 1
        cell.legendOptionSquareColor.layer.cornerRadius = cell.legendOptionSquareColor.frame.size.width/4
        cell.legendOptionSquareColor.tag = indexPath.row
        cell.legendOptionSquareColor.isUserInteractionEnabled = true
        cell.legendOptionSquareColor.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedSquare = tapGestureRecognizer.view as! UIImageView
        var colorID = (legendData[tappedSquare.tag][1] as! Int) + 1
        colorID == colors.count ? (colorID = 0) : ()
        legendData[tappedSquare.tag][1] = colorID
        defaults.set(legendData, forKey: "Legend Preferences")
        defaults.setColor(color: colors[(legendData[tappedSquare.tag][1] as! Int)], forKey: legendData[tappedSquare.tag][0] as! String)
        tableVIew.reloadData()
    }
    
    @IBAction func clearAllButtonPressed(_ sender: UIButton) {
        sender.setTitle("Gameboard Cleared", for: .normal)
        clearBarrierButton.setTitle("Barriers Cleared", for: .normal)
        clearPathButton.setTitle("Path Cleared", for: .normal)
        defaults.set(true, forKey: "Clear All Setting")
    }
    
    @IBAction func clearBarrierButtonPressed(_ sender: UIButton) {
        sender.setTitle("Barriers Cleared", for: .normal)
        defaults.set(true, forKey: "Clear Barrier Setting")
    }
    
    @IBAction func clearPathButtonPressed(_ sender: UIButton) {
        sender.setTitle("Path Cleared", for: .normal)
        defaults.set(true, forKey: "Clear Path Setting")
    }
    
    @IBAction func snakeSpeedButtonPressed(_ sender: UIButton) {
        let options = ["Speed: Slow", "Speed: Normal", "Speed: Fast", "Speed: Extreme"]
        fourOptionButtonResponder(sender, isSpeedButton: true, key: "Snake Speed Setting", optionArray: options)
    }
    
    @IBAction func foodWeightButtonPressed(_ sender: UIButton) {
        let options = ["Food Weight: 1", "Food Weight: 2", "Food Weight: 3", "Food Weight: 5"]
        fourOptionButtonResponder(sender, isSpeedButton: false, key: "Food Weight Setting", optionArray: options)
    }
    
    @IBAction func foodCountButtonPressed(_ sender: UIButton) {
        let options = ["Food Count: 1", "Food Count: 2", "Food Count: 3", "Food Count: 5"]
        fourOptionButtonResponder(sender, isSpeedButton: false, key: "Food Count Setting", optionArray: options)
    }
    
    @IBAction func godButtonPressed(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: false, key: "God Button On Setting", trueOption: "God Mode: On", falseOption: "God Mode: Off")
    }
    
    @IBAction func returnButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Volume On Setting", trueOption: "Volume_On_Icon.pdf", falseOption: "Volume_Mute_Icon.pdf")
    }
    
    @IBAction func stepButtonPressed(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Step Mode On Setting", trueOption: "Step_Icon.pdf", falseOption: "Play_Icon.pdf")
    }
    
    @IBAction func darkModeButtonPressed(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Dark Mode On Setting", trueOption: "Dark_Mode_Icon.pdf", falseOption: "Light_Mode_Icon.pdf")
        defaults.bool(forKey: "Dark Mode On Setting") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
    }

    func boolButtonResponder(_ sender: UIButton, isIconButton: Bool, key: String, trueOption: String, falseOption: String) {
        sender.tag = NSNumber(value: defaults.bool(forKey: key)).intValue
        if isIconButton {
            // If on when clicked, change to off, and vise versa.
            if sender.tag == 1 {
                sender.setImage(UIImage(named: falseOption), for: .normal)
                sender.tag = 0
            } else {
                sender.setImage(UIImage(named: trueOption), for: .normal)
                sender.tag = 1
            }
        } else {
            // If on when clicked, change to off, and vise versa.
            if sender.tag == 1 {
                sender.setTitle(falseOption, for: .normal)
                sender.tag = 0
            } else {
                sender.setTitle(trueOption, for: .normal)
                sender.tag = 1
            }
        }
        defaults.set(Bool(truncating: sender.tag as NSNumber), forKey: key)
    }
    
    func fourOptionButtonResponder(_ sender: UIButton, isSpeedButton: Bool, key: String, optionArray: [String]) {
        var gameMoveSpeed = Float()
        sender.tag = defaults.integer(forKey: key)

        if isSpeedButton {gameMoveSpeed = defaults.float(forKey: "Snake Move Speed")}
        if sender.tag == 1 {
            sender.setTitle(optionArray[1], for: .normal)
            sender.tag = 2
            if isSpeedButton {gameMoveSpeed = 0.10}
        } else if sender.tag == 2 {
            sender.setTitle(optionArray[2], for: .normal)
            sender.tag = 3
            if isSpeedButton {gameMoveSpeed = 0.01}
        } else if sender.tag == 3 {
            sender.setTitle(optionArray[3], for: .normal)
            sender.tag = 5
            if isSpeedButton {gameMoveSpeed = 0.50}
        } else {
            sender.setTitle(optionArray[0], for: .normal)
            sender.tag = 1
            if isSpeedButton {gameMoveSpeed = 0.25}
        }
        
        defaults.set(sender.tag, forKey: key)
        if isSpeedButton {defaults.set(gameMoveSpeed, forKey: "Snake Move Speed")}
    }
}

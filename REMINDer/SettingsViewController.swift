//
//  SettingsViewController.swift
//  REMINDer
//
//  Created by Michael Ho on 1/6/17.
//  Copyright © 2017 reminder.com. All rights reserved.
//

import UIKit
import DropDown

struct Preference {
    static let setCharacter = "setCharacter"
    static let setFrequency = "setFrequency"
    static let setClock = "setClock"
    static let setSnooze = "setSnooze"
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var tvCharacter: UILabel!
    @IBOutlet weak var tvClockPref: UILabel!
    @IBOutlet weak var tvSnooze: UILabel!
    @IBOutlet weak var tvFreq: UILabel!
    
    let defaults = UserDefaults.standard
    let freqDropDown = DropDown()
    let clockDropDown = DropDown()
    let snoozeDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.freqDropDown,
            self.clockDropDown,
            self.snoozeDropDown
        ]
    }()
    
    var gender: Bool = true
    var character: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (defaults.object(forKey: Preference.setCharacter) != nil) {
            self.character = defaults.bool(forKey: Preference.setCharacter)
        }
        setCharacter()
        
        if (defaults.object(forKey: Preference.setClock) != nil) {
            self.tvClockPref.text = defaults.string(forKey: Preference.setClock)
        }
        
        if (defaults.object(forKey: Preference.setSnooze) != nil) {
            self.tvSnooze.text = defaults.string(forKey: Preference.setSnooze)
        }
        
        self.freqDropDown.dataSource = ["Always", "Often", "Seldom"]
        self.freqDropDown.anchorView = tvFreq
        self.freqDropDown.bottomOffset = CGPoint(x: 0, y:(self.tvFreq.bounds.height))
        self.clockDropDown.dataSource = ["12-Hour", "24-Hour"]
        self.clockDropDown.anchorView = tvClockPref
        self.clockDropDown.bottomOffset = CGPoint(x: 0, y:(self.tvClockPref.bounds.height))
        self.snoozeDropDown.dataSource = ["5 minutes", "10 minutes", "15 minutes", "20 minutes", "25 minutes", "30 minutes"]
        self.snoozeDropDown.anchorView = tvSnooze
        self.snoozeDropDown.bottomOffset = CGPoint(x: 0, y:(self.tvSnooze.bounds.height))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setCharacter(){
        if character {
            tvCharacter.text = "Angel"
        } else {
            tvCharacter.text = "Devil"
        }
    }
    
    @IBAction func btnCharPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SettingsToCharIdentifier", sender: self)
    }
    
    @IBAction func btnFreqPressed(_ sender: UIButton) {
        customizeDropDown(freqDropDown)
        freqDropDown.show()
    }
    @IBAction func btnClockPressed(_ sender: UIButton) {
        customizeDropDown(clockDropDown)
        clockDropDown.show()
    }
    @IBAction func btnSnoozePressed(_ sender: UIButton) {
        customizeDropDown(snoozeDropDown)
        snoozeDropDown.show()
    }
    
    func customizeDropDown(_ sender: AnyObject) {
        view.endEditing(true)
        let appearance = DropDown.appearance()
        appearance.cellHeight = 50
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.5
        appearance.shadowRadius = 10
        appearance.animationduration = 0.25
        appearance.textColor = tvClockPref.textColor!
        appearance.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        appearance.direction = .bottom
        
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "DropDownListCell", bundle: nil)
            $0.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? DropDownListCell else { return }
            }
        }
        
        freqDropDown.selectionAction = { [unowned self] (index, item) in
            //TODO define frequency
        }
        
        clockDropDown.selectionAction = { [unowned self] (index, item) in
            self.tvClockPref.text = self.clockDropDown.dataSource[index]
            self.defaults.setValue("\(self.tvClockPref.text!)", forKey: Preference.setClock)
        }
        snoozeDropDown.selectionAction = { [unowned self] (index, item) in
            self.tvSnooze.text = self.snoozeDropDown.dataSource[index]
            self.defaults.setValue("\(self.tvSnooze.text!)", forKey: Preference.setSnooze)
        }
    }
}

//
//  CharacterViewController.swift
//  REMINDer
//
//  Created by Michael Ho on 1/7/17.
//  Copyright © 2017 reminder.com. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController {

    @IBOutlet weak var ivCharacter: UIImageView!
    @IBOutlet weak var tvCharacter: UILabel!
    @IBOutlet weak var segGender: UISegmentedControl!
    @IBOutlet weak var segCharacter: UISegmentedControl!
    
    var gender: Bool = true
    var character: Bool = true
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (defaults.object(forKey: Preference.setGender) != nil) {
            self.gender = defaults.bool(forKey: Preference.setGender)
            setSegControl(segment: self.gender, segControl: self.segGender)
            self.character = defaults.bool(forKey: Preference.setCharacter)
            setSegControl(segment: self.character, segControl: self.segCharacter)
        }
        updateCharacter()
    }
    
    func setSegControl(segment: Bool, segControl: UISegmentedControl){
        if segment {
            segControl.selectedSegmentIndex = 0
        } else {
            segControl.selectedSegmentIndex = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func segGenderChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                self.gender = true
            case 1:
                self.gender = false
            default:
                break;
        }
        updateCharacter()
    }
    
    @IBAction func segCharacterChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                self.character = true
            case 1:
                self.character = false
            default:
                break;
        }
        updateCharacter()
    }
    
    @IBAction func btnBackPressed(_ sender: UIBarButtonItem) {
        self.defaults.setValue(self.gender, forKey: Preference.setGender)
        self.defaults.setValue(self.character, forKey: Preference.setCharacter)
        self.performSegue(withIdentifier: "CharToSettingsIdentifier", sender: self)
    }
    
    func updateCharacter(){
        ivCharacter.alpha = 0
        tvCharacter.alpha = 0
        if gender {
            if character {
                tvCharacter.text = "Angel David"
                ivCharacter.image = UIImage(named: "sample_angel")
            } else {
                tvCharacter.text = "Devil Luke"
                ivCharacter.image = UIImage(named: "sample_devil")
            }
        } else {
            if character {
                tvCharacter.text = "Angel Lauren"
                ivCharacter.image = UIImage(named: "sample_angel")
            } else {
                tvCharacter.text = "Devil Bella"
                ivCharacter.image = UIImage(named: "sample_devil")
            }
        }
        fadeIn(imageView: ivCharacter, textView: tvCharacter)
    }
    
    func fadeIn(imageView: UIImageView, textView: UILabel, withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            imageView.alpha = 1.0
            textView.alpha = 1.0
        })
    }
}

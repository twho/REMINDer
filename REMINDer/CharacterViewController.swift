//
//  CharacterViewController.swift
//  REMINDer
//
//  Created by Michael Ho on 1/7/17.
//  Copyright © 2017 reminder.com. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController {
    
    var character: Bool = true
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var ibCharAngel: UIButton!
    @IBOutlet weak var ibCharDevil: UIButton!
    @IBOutlet weak var tvCharAngel: UILabel!
    @IBOutlet weak var tvCharDevil: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (defaults.object(forKey: Preference.setCharacter) != nil) {
            character = defaults.bool(forKey: Preference.setCharacter)
        }
        updateCharacter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnBackPressed(_ sender: UIBarButtonItem) {
        self.defaults.setValue(self.character, forKey: Preference.setCharacter)
        self.performSegue(withIdentifier: "CharToSettingsIdentifier", sender: self)
    }
    
    @IBAction func ibAngelPressed(_ sender: UIButton) {
        self.character = true
        updateCharacter()
    }
    
    @IBAction func ibDevilPressed(_ sender: UIButton) {
        self.character = false
        updateCharacter()
    }
    
    func updateCharacter(){
        if character {
            ibCharDevil.setImage(UIImage(named: "devil_normal"), for: .normal)
            ibCharAngel.setImage(UIImage(named: "angel_selected"), for: .normal)
            tvCharDevil.textColor = UIColor.white
            tvCharAngel.textColor = UIColor(red:0.00, green:1.00, blue:1.00, alpha:1.0)
        } else {
            ibCharDevil.setImage(UIImage(named: "devil_selected"), for: .normal)
            ibCharAngel.setImage(UIImage(named: "angel_normal"), for: .normal)
            tvCharAngel.textColor = UIColor.white
            tvCharDevil.textColor = UIColor(red:0.00, green:1.00, blue:1.00, alpha:1.0)
        }
    }
}

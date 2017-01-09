//
//  HistoryViewController.swift
//  REMINDer
//
//  Created by Michael Ho on 1/7/17.
//  Copyright © 2017 reminder.com. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var viewChart: UIView!
    @IBOutlet weak var viewDay: UIView!
    @IBOutlet weak var ivChart: UIImageView!
    @IBOutlet weak var tvTaskPercentage: UILabel!
    @IBOutlet weak var tvTask: UILabel!
    @IBOutlet weak var tvTimeSpent: UILabel!
    @IBOutlet weak var tvTimeAdvanced: UILabel!
    @IBOutlet weak var tvTimeDelayed: UILabel!
    @IBOutlet weak var tvTip: UILabel!
    
    var percString: NSString = ""
    var perMutableString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDayView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func segControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setDayView()
            break
        case 1:
            setWeekView()
            break
        case 2:
            setMonthView()
            break
        default:
            break
        }
    }
    
    func setDayView(){
        clearView()
        fadeIn(view: viewDay)
    }
    
    func setWeekView(){
        clearView()
        setTvPercentAttrText(textView: tvTaskPercentage, setText: "87 %")
        tvTask.text = "24"
        setTvHrAttrText(textView: tvTimeSpent, setText: "50 hr")
        setTvHrAttrText(textView: tvTimeAdvanced, setText: "2.0 hr")
        setTvHrAttrText(textView: tvTimeDelayed, setText: "1.5 hr")
        tvTip.text = "Nice Job!"
        ivChart.image = UIImage(named: "sample_chartweek")
        fadeIn(view: viewChart)
    }
    
    func setMonthView(){
        clearView()
        setTvPercentAttrText(textView: tvTaskPercentage, setText: "54 %")
        tvTask.text = "107"
        setTvHrAttrText(textView: tvTimeSpent, setText: "212 hr")
        setTvHrAttrText(textView: tvTimeAdvanced, setText: "8.9 hr")
        setTvHrAttrText(textView: tvTimeDelayed, setText: "7.2 hr")
        tvTip.text = "Come on, you can do it!"
        ivChart.image = UIImage(named: "sample_chartmonth")
        fadeIn(view: viewChart)
    }
    
    func clearView(){
        viewDay.alpha = 0.0
        viewChart.alpha = 0.0
    }
    
    func fadeIn(view: UIView, withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 1.0
        })
    }
    
    func setTvPercentAttrText(textView: UILabel, setText: String){
        perMutableString = NSMutableAttributedString(string: setText, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 30.0)])
        perMutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18.0), range: NSRange(location: setText.characters.count-1, length:1))
        textView.attributedText = perMutableString
    }
    
    func setTvHrAttrText(textView: UILabel, setText: String){
        perMutableString = NSMutableAttributedString(string: setText, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 30.0)])
        perMutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18.0), range: NSRange(location:setText.characters.count-2, length:2))
        textView.attributedText = perMutableString
    }
}

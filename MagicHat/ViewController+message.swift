//
//  ViewController+message.swift
//  MagicHat
//
//  Created by Lorenzo Rossi on 09/12/17.
//  Copyright © 2017 reds. All rights reserved.
//

import UIKit

extension ViewController {

    func showMessage(_ message: String) {
        DispatchQueue.main.async {
            self.labelMessage.text = message
            
            if (self._timerMessage != nil && !self._timerMessage!.isValid) {
                self.viewMessage.isHidden = false
                self.viewMessage.alpha = 0
                UIView.animate(withDuration: 0.2) {
                    self.viewMessage.alpha = 1
                }
            }
            
            if self._timerMessage != nil {
                self._timerMessage?.invalidate()
            }
            
            self._timerMessage = Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { (timer) in
                self.hideMessage()
            })
        }
    }
    
    func hideMessage()
    {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.viewMessage.alpha = 0
            }) { (complete) in
                if complete {
                    self.viewMessage.isHidden = true
                }
            }
        }
    }
}

//
//  LoginViewTests.swift
//  swift-testing
//
//  Created by Rodrigo Cavalcante on 03/03/17.
//  Copyright © 2017 Rodrigo Cavalcante. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import SnapshotIssues

class Issue2Tests: QuickSpec {
    
    var superView: UIView!
    
    override func spec() {
        
        describe("Issue2Tests") {
            
            var view: LoginView!
            
            beforeEach {
                self.superView = UIView()
                view = LoginView()
                view.translatesAutoresizingMaskIntoConstraints = false
                self.superView.addSubview(view)
                
                view.textLabel.isHidden = true
                view.passwordTextField.isHidden = true
                view.loginButton.isHidden = true
            }
            
            it("should have a cool layout") {
                view.userNameTextField.placeholder = ""
                expect(view) == snapshot()
            }
        }
    }
}

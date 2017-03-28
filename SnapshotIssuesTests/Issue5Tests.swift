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

class Issue5Tests: QuickSpec {
    
    var superView: UIView!
    
    override func spec() {
        
        describe("Issue5Tests") {
            
            var view: LoginView!
            
            beforeEach {
                self.superView = UIView()
                view = LoginView()
                view.translatesAutoresizingMaskIntoConstraints = false
                self.superView.addSubview(view)
                
                view.textLabel.isHidden = true
                view.passwordTextField.isHidden = true
                view.userNameTextField.isHidden = true
            }
            
            it("should have a cool layout") {
                expect(view) == snapshot("iOS10.2")
            }
        }
    }
}

//
//  Issue6Tests.swift
//  SnapshotIssues
//
//  Created by Rodrigo Cavalcante on 24/03/17.
//  Copyright © 2017 Rodrigo Cavalcante. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import SnapshotIssues

class Issue6Tests: QuickSpec {
    
    override func spec() {
        
        describe("Issue6Tests") {
            
            var view: ButtonXIB!
            
            beforeEach {
                let bundle = Bundle(for: ButtonXIB.self)
                view = bundle.loadNibNamed("ButtonXIB",
                                                owner: nil,
                                                options: nil)?.first as! ButtonXIB
                view.layoutIfNeeded()
            }
            
            it("should have cool layout") {
                expect(view) == snapshot("iOS8.1")
            }
        }
    }
}

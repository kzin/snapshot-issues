//
//  Issue4Tests.swift
//  SnapshotIssues
//
//  Created by Rodrigo Cavalcante on 24/03/17.
//  Copyright © 2017 Rodrigo Cavalcante. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import SnapshotIssues

extension UITableViewCell {
    func setDynamicFrame(forWidth width: Double) {
        let cellSize = self.systemLayoutSizeFitting(CGSize(width: width, height: 10000))
        self.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(width), height: cellSize.height))
    }
}

class Issue4Tests: QuickSpec {
    
    override func spec() {
        
        describe("Issue4Tests") {
            
            var cell: UserCell!
            
            beforeEach {
                let validJson = JSON.user()
                let user = User(json: validJson)!
                
                cell = UserCell(style: UITableViewCellStyle.default, reuseIdentifier: "UserCell")
                cell.setup(user: user)
                cell.setDynamicFrame(forWidth: 320)
            }
            
            it("should have cool layout when load a user") {
                expect(cell) == snapshot("iOS10.2")
            }
        }
    }
}

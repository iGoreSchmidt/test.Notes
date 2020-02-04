//
//  test_Notes_ModelTests.swift
//  test.Notes.ModelTests
//
//  Created by zentity on 03/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation

@testable import test_Notes_Model
import Nimble
import Quick

extension String: Error {}

class ModelTests: QuickSpec   {
    override func spec() {
        describe("Note object") {
            let mockObject: [String : Any] = [
                "id": 1,
                "title": "test"
            ]

            it("can create new instance without id") {
                var note: Note!
                expect { note = NoteImpl(mockObject["title"] as? String ?? "") }.toNot(throwError())
                expect(note?.id).to(beNil())
                expect(note?.title) == (mockObject["title"] as? String)
            }

            it("can encode created object") {
                expect {
                    let json = String(data: try JSONEncoder().encode(NoteImpl(mockObject["title"] as? String ?? "")),
                                      encoding: .utf8)
                    print("Generated json:", json ?? "")
                    guard json?.contains("\"id\"") == false else {
                        throw "'id' found in result: \(json ?? "")"
                    }
                    guard json?.contains("\"title\"") == true else {
                        throw "'title' not found in result: \(json ?? "")"
                    }
                    return ()
                }.toNot(throwError())
            }

            it("can be parsed from correct json") {
                var note: Note!
                let data = Data("""
                    {\(mockObject
                        .map { "\"\($0)\":\($1 is String ? "\"\($1)\"" : $1)" }
                        .joined(separator: ","))}
                    """
                    .utf8)
                print("Mock for parsing:", String(data: data, encoding: .utf8) ?? "")
                expect { note = try JSONDecoder().decode(NoteImpl.self, from: data) }.toNot(throwError())
                expect(note?.id) == (mockObject["id"] as? Int ?? Int.min)
                expect(note?.title) == (mockObject["title"] as? String ?? "")
            }
        }
    }
}

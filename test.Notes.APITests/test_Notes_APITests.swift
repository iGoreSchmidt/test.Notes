//
//  test_Notes_APITests.swift
//  test.Notes.APITests
//
//  Created by zentity on 02/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

@testable import test_Notes_API
import test_Notes_Model
import Combine
import Nimble
import Quick

class APITests: QuickSpec   {
    override func spec() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockProtocol.self]
        let mockManager = RequestManagerImpl(URL(string: "https://xctest")!, session: URLSession(configuration: config))
        
        describe("For ListRequest") {
            context("RequestManager") {
                let request = ListRequestImpl()
                it("able to make URLRequest") {
                    expect { try mockManager.prepare(request) }.toNot(satisfyAnyOf(throwError(), beNil()))
                }
                it("able to send request") {
                    expect { try mockManager.send(request) }.toNot(satisfyAnyOf(throwError(), beNil()))
                }
            }
            context("with correct data response") {
                var listRequest: ListRequestImpl!
                var tokens: [Int: AnyCancellable?] = [:]
                let mockObjects = [
                    [
                        "id": 1,
                        "title": "Jogging in park"
                    ],
                    [
                        "id": 2,
                        "title": "Pick-up posters from post-office"
                    ]
                ]

                beforeEach {
                    listRequest = ListRequestImpl()
                    listRequest.urlRequest = try? mockManager.prepare(listRequest) as? NSMutableURLRequest
                    guard let urlRequest = listRequest.urlRequest else { return fail("preconditions failed") }

                    MockProtocol.setProperty("""
                        [\(mockObjects
                            .map { mockObject in return """
                                {\(mockObject
                                    .map { "\"\($0)\":\($1 is String ? "\"\($1)\"" : $1)" }
                                    .joined(separator: ","))}
                                """
                            }.joined(separator: ","))]
                        """,
                        forKey: "responseString",
                        in: urlRequest)
                    print("Mock for request:",
                          urlRequest.url?.absoluteString ?? "",
                          MockProtocol.property(forKey: "responseString", in: urlRequest as URLRequest) as? String ?? "")
                }
                afterEach {
                    if tokens[$0.exampleIndex] != nil { tokens[$0.exampleIndex] = nil }
                }

                it("produce correct objects") {
                    // precondition
                    guard let publisher = try? mockManager.send(listRequest) else { return fail("Publisher required") }
                    var receivedCompletion: Subscribers.Completion<Error>!
                    var receivedValue: [Note]!
                    let token = publisher.sink(receiveCompletion: { receivedCompletion = $0 }, receiveValue: { receivedValue = $0 })
                    tokens[tokens.count] = token
                    expect({
                        switch receivedCompletion {
                        case .finished?:
                            return .succeeded
                        case .failure(let error)?:
                            return .failed(reason: "\(error)")
                        default:
                            return .failed(reason: "Still no value")
                        }
                    }).toEventually(succeed(), description: "Request flow")

                    expect({
                        guard let values = receivedValue else { return .failed(reason: "Still no value") }
                        guard values.count == mockObjects.count else {
                            return .failed(reason: "Expected \(mockObjects.count) object(s), got \(values.count)")
                        }
                        let check: (Note?, [String: Any]?) -> ToSucceedResult = { (value, mock) in
                            guard value?.id == mock?["id"] as? Int? else {
                                return .failed(reason: "Expected id = \(String(describing: mock?["id"])),"
                                    + "got \(String(describing: value?.id))"
                                )
                            }
                            guard value?.title == mock?["title"] as? String? else {
                                return .failed(reason: "Expected title = '\(String(describing: mock?["title"]))', "
                                    + "got '\(String(describing: value?.title))'"
                                )
                            }
                            return .succeeded
                        }
                        let firstCheck = check(values.first, mockObjects.first)
                        guard case .succeeded = firstCheck else { return firstCheck }
                        return check(values.last, mockObjects.last)
                    }).toEventually(succeed(), description: "Parsed value matches mock")
                }
            }
        }

        describe("For NoteRequest") {
            context("RequestManager") {
                let request = NoteRequestImpl(id: 1)
                it("able to make URLRequest") {
                    expect { try mockManager.prepare(request) }.toNot(satisfyAnyOf(throwError(), beNil()))
                }
                it("able to send request") {
                    expect { try mockManager.send(request) }.toNot(satisfyAnyOf(throwError(), beNil()))
                }
            }
            context("with correct data response") {
                var noteRequest: NoteRequestImpl!
                var tokens: [Int: AnyCancellable?] = [:]
                let mockObject: [String: Any] = [
                    "id": 1,
                    "title": "Jogging in park"
                ]

                beforeEach {
                    noteRequest = NoteRequestImpl(id: 1)
                    noteRequest.urlRequest = try? mockManager.prepare(noteRequest) as? NSMutableURLRequest
                    guard let urlRequest = noteRequest.urlRequest else { return fail("preconditions failed") }

                    MockProtocol.setProperty("""
                        {\(mockObject
                            .map { "\"\($0)\":\($1 is String ? "\"\($1)\"" : $1)" }
                            .joined(separator: ","))}
                        """,
                        forKey: "responseString",
                        in: urlRequest)
                    print("Mock for request:",
                          urlRequest.url?.absoluteString ?? "",
                          MockProtocol.property(forKey: "responseString", in: urlRequest as URLRequest) as? String ?? "")
                }

                afterEach {
                    if tokens[$0.exampleIndex] != nil { tokens[$0.exampleIndex] = nil }
                }

                it("produce correct object") {
                    // precondition
                    guard let publisher = try? mockManager.send(noteRequest) else { return fail("Publisher required") }
                    var receivedCompletion: Subscribers.Completion<Error>!
                    var receivedValue: Note!
                    let token = publisher.sink(receiveCompletion: { receivedCompletion = $0 }, receiveValue: { receivedValue = $0 })
                    tokens[tokens.count] = token
                    expect({
                        switch receivedCompletion {
                        case .finished?:
                            return .succeeded
                        case .failure(let error)?:
                            return .failed(reason: "\(error)")
                        default:
                            return .failed(reason: "Still no value")
                        }
                    }).toEventually(succeed(), description: "Request flow")

                    expect({
                        guard let value = receivedValue else { return .failed(reason: "Still no value") }

                        guard value.id == mockObject["id"] as? Int else {
                            return .failed(reason: "Expected id = \(String(describing: mockObject["id"])),"
                                + "got \(String(describing: value.id))"
                            )
                        }
                        guard value.title == mockObject["title"] as? String else {
                            return .failed(reason: "Expected title = '\(String(describing: mockObject["title"]))', "
                                + "got '\(value.title)'"
                            )
                        }
                        return .succeeded

                    }).toEventually(succeed(), description: "Parsed value matches mock")
                }
            }
        }
        describe("For DeleteNoteRequest") {
            context("RequestManager") {
                let request = DeleteNoteRequestImpl(id: 1)
                it("able to make URLRequest") {
                    expect { try mockManager.prepare(request) }.toNot(satisfyAnyOf(throwError(), beNil()))
                }
                it("able to send request") {
                    expect { try mockManager.send(request) }.toNot(satisfyAnyOf(throwError(), beNil()))
                }
            }
        }
        describe("For SetupNoteRequest") {
            struct EditNoteMock: Note {
                let id: Int! = 1
                var title = "test"
            }
            struct NewNoteMock: Note {
                let id: Int! = nil
                var title = "test"
            }
            context("RequestManager") {
                let request = SetupNoteRequestImpl(note: EditNoteMock())
                it("able to make URLRequest") {
                    expect { try mockManager.prepare(request) }.toNot(satisfyAnyOf(throwError(), beNil()))
                }
                it("able to send request") {
                    expect { try mockManager.send(request) }.toNot(satisfyAnyOf(throwError(), beNil()))
                }
            }
            context("Edit request") {
                let request = SetupNoteRequestImpl(note: EditNoteMock())
                it("have correct HTTP METHOD") {
                    expect { (try mockManager.prepare(request)).httpMethod }
                        .toNot(satisfyAnyOf(
                            throwError(),
                            be(HTTPMethod.get.rawValue),
                            be(HTTPMethod.post.rawValue),
                            be(HTTPMethod.delete.rawValue)
                        ))
                }
                it("have body") {
                    expect { (try mockManager.prepare(request)).httpBody?.isEmpty }
                        .toNot(satisfyAnyOf(
                            throwError(),
                            beNil(),
                            be(true)
                        ))
                }
            }
            context("Create request") {
                let request = SetupNoteRequestImpl(note: NewNoteMock())
                it("have correct HTTP METHOD") {
                    expect { (try mockManager.prepare(request)).httpMethod }
                        .toNot(satisfyAnyOf(
                            throwError(),
                            be(HTTPMethod.get.rawValue),
                            be(HTTPMethod.put.rawValue),
                            be(HTTPMethod.delete.rawValue)
                        ))
                }
                it("have body") {
                    expect { (try mockManager.prepare(request)).httpBody?.isEmpty }
                        .toNot(satisfyAnyOf(
                            throwError(),
                            beNil(),
                            be(true)
                        ))
                }
            }
        }
    }
}

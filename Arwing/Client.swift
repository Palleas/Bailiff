//
//  Cliebt.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-04-16.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Cocoa
import ReactiveCocoa
import SwiftyJSON

public protocol AuthenticationProvider {
    var headers: [String: String]? { get }
    var rawToken: String { get }
}

public struct Project {
    public let id: Int
    public let name: String
    public let nameWithNamespace: String

    init(payload: JSON) {
        self.id = payload["id"].intValue
        self.name = payload["name"].stringValue
        self.nameWithNamespace = payload["name_with_namespace"].stringValue
    }
}

public struct Issue {
    public let projectId: Int
    public let id: Int
    public let iid: Int
    public let title: String
    public let description: String

    init(payload: JSON) {
        self.projectId = payload["project_id"].intValue
        self.id = payload["project_id"].intValue
        self.iid = payload["iid"].intValue
        self.title = payload["title"].stringValue
        self.description = payload["description"].stringValue
    }

}

public struct TokenAuthentication: AuthenticationProvider {
    public let rawToken: String

    public init(token: String) {
        self.rawToken = token
    }

    public var headers: [String: String]? {
        return ["PRIVATE-TOKEN": rawToken]
    }
}

public enum ClientError: ErrorType {
    case InternalError(NSError)
}

public class Client: NSObject {
    public let provider: AuthenticationProvider
    public let endpoint: NSURL

    public init(provider: AuthenticationProvider, endpoint: NSURL) {
        self.provider = provider
        self.endpoint = endpoint

        super.init()
    }

    public func projects() -> SignalProducer<Project, ClientError> {
        let url = endpoint.URLByAppendingPathComponent("/api/v3/projects")
        let request = NSMutableURLRequest(URL: url)
        request.allHTTPHeaderFields = provider.headers

        return NSURLSession
            .sharedSession()
            .rac_dataWithRequest(request)
            .mapError { return ClientError.InternalError($0) }
            .flatMap(.Latest) { (data, response) -> SignalProducer<Project, ClientError> in
                let payload = JSON(data: data)
                    .arrayValue
                    .lazy
                    .map(Project.init)
                
                return SignalProducer(values: payload)
            }
    }

    public func createIssue(project: Project, title: String, description: String) -> SignalProducer<Issue, ClientError> {
        let url = endpoint.URLByAppendingPathComponent("/api/v3//projects/\(project.id)/issues")
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = provider.headers
        request.HTTPBody = {
                let components = NSURLComponents()
                components.queryItems = ["title": title, "description": description].map(NSURLQueryItem.init)

                return components.query?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            }()

        return NSURLSession
            .sharedSession()
            .rac_dataWithRequest(request)
            .mapError { return ClientError.InternalError($0) }
            .flatMap(.Latest) { (data, response) -> SignalProducer<Issue, ClientError> in
                return SignalProducer(value: Issue(payload: JSON(data: data)))
        }
    }
}

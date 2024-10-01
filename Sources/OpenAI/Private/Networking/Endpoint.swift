//
//  Endpoint.swift
//
//
//  Created by James Rochabrun on 10/11/23.
//

import AsyncHTTPClient
import Foundation
import NIOFoundationCompat

// MARK: HTTPMethod

enum HTTPMethod: String {
   case post = "POST"
   case get = "GET"
   case delete = "DELETE"
}

// MARK: Endpoint

protocol Endpoint {
   
   var base: String { get }
   var path: String { get }
}

// MARK: Endpoint+Requests

extension Endpoint {

   private func urlComponents(
      queryItems: [URLQueryItem])
      -> URLComponents
   {
      var components = URLComponents(string: base)!
      components.path = path
      if !queryItems.isEmpty {
         components.queryItems = queryItems
      }
      return components
   }
   
   func request(
      apiKey: Authorization,
      organizationID: String?,
      method: HTTPMethod,
      params: Encodable? = nil,
      queryItems: [URLQueryItem] = [],
      betaHeaderField: String? = nil,
      extraHeaders: [String: String]? = nil)
    throws -> HTTPClientRequest
   {
      var request = HTTPClientRequest(url: urlComponents(queryItems: queryItems).url!.absoluteString)
      request.headers.add(name: "Content-Type", value: "application/json")
      request.headers.add(name: apiKey.headerField, value: apiKey.value)
      if let organizationID {
         request.headers.add(name: "OpenAI-Organization", value: organizationID)
      }
      if let betaHeaderField {
         request.headers.add(name: "OpenAI-Beta", value: betaHeaderField)
      }
      if let extraHeaders {
         for header in extraHeaders {
            request.headers.add(name: header.key, value: header.value)
         }
      }
       request.method = .init(rawValue: method.rawValue)
      if let params {
         let bodyData = try JSONEncoder().encode(params)
         request.body = .bytes(bodyData, length: .known(Int64(bodyData.count)))
      }
      return request
   }
   
   func multiPartRequest(
      apiKey: Authorization,
      organizationID: String?,
      method: HTTPMethod,
      params: MultipartFormDataParameters,
      queryItems: [URLQueryItem] = [])
      throws -> HTTPClientRequest
   {
      var request = HTTPClientRequest(url: urlComponents(queryItems: queryItems).url!.absoluteString)
      request.method = .init(rawValue: method.rawValue)
      let boundary = UUID().uuidString
       request.headers.add(name: apiKey.headerField, value: apiKey.value)
      if let organizationID {
          request.headers.add(name: "OpenAI-Organization", value: organizationID)
      }
      request.headers.add(name: "Content-Type", value: "multipart/form-data; boundary=\(boundary)")
      let bodyData = params.encode(boundary: boundary)
      request.body = .bytes(bodyData, length: .known(Int64(bodyData.count)))
      return request
   }
}

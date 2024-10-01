//
//  OpenAIServiceFactory.swift
//
//
//  Created by James Rochabrun on 10/18/23.
//

import AsyncHTTPClient
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public class OpenAIServiceFactory {
   
   // MARK: OpenAI
   
   /// Creates and returns an instance of `OpenAIService`.
   ///
   /// - Parameters:
   ///   - apiKey: The API key required for authentication.
   ///   - organizationID: The optional organization ID for multi-tenancy (default is `nil`).
   ///   - configuration: The URL session configuration to be used for network calls (default is `.default`).
   ///   - decoder: The JSON decoder to be used for parsing API responses (default is `JSONDecoder.init()`).
   ///   - debugEnabled: If `true` service prints event on DEBUG builds, default to `false`.

   /// - Returns: A fully configured object conforming to `OpenAIService`.
   public static func service(
      apiKey: String,
      organizationID: String? = nil,
      httpClient: HTTPClient = .shared,
      decoder: JSONDecoder = .init(),
      debugEnabled: Bool = false)
      -> OpenAIService
   {
      DefaultOpenAIService(
         apiKey: apiKey,
         organizationID: organizationID,
         httpClient: httpClient,
         decoder: decoder,
         debugEnabled: debugEnabled)
   }
   
   // MARK: Azure

   /// Creates and returns an instance of `OpenAIService`.
   ///
   /// - Parameters:
   ///   - azureConfiguration: The AzureOpenAIConfiguration.
   ///   - urlSessionConfiguration: The URL session configuration to be used for network calls (default is `.default`).
   ///   - decoder: The JSON decoder to be used for parsing API responses (default is `JSONDecoder.init()`).
   ///   - debugEnabled: If `true` service prints event on DEBUG builds, default to `false`.
   ///
   /// - Returns: A fully configured object conforming to `OpenAIService`.
   public static func service(
      azureConfiguration: AzureOpenAIConfiguration,
      httpClient: HTTPClient = .shared,
      decoder: JSONDecoder = .init(),
      debugEnabled: Bool = false)
   -> OpenAIService
   {
      DefaultOpenAIAzureService(
         azureConfiguration: azureConfiguration,
         httpClient: httpClient,
         decoder: decoder,
         debugEnabled: debugEnabled)
   }
   
   // MARK: Custom URL

   /// Creates and returns an instance of `OpenAIService`.
   ///
   /// Use this service if you need to provide a custom URL, for example to run local models with OpenAI endpoints compatibility using Ollama.
   /// Check [Ollama blog post](https://ollama.com/blog/openai-compatibility) for more.
   ///
   /// - Parameters:
   ///   - apiKey: The optional API key required for authentication.
   ///   - baseURL: The local host URL. defaults to  "http://localhost:11434"
   ///   - debugEnabled: If `true` service prints event on DEBUG builds, default to `false`.
   ///
   /// - Returns: A fully configured object conforming to `OpenAIService`.
   public static func service(
      apiKey: Authorization = .apiKey(""),
      baseURL: String,
      httpClient: HTTPClient = .shared,
      debugEnabled: Bool = false)
      -> OpenAIService
   {
      LocalModelService(
         apiKey: apiKey,
         baseURL: baseURL,
         httpClient: httpClient,
         debugEnabled: debugEnabled)
   }
}

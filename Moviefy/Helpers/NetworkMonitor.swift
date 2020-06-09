//
//  NetworkMonitor.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 6/8/20.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import Foundation
import Combine
import Network

public protocol PathProtocol {
    var status: NWPath.Status { get }
    var isExpensive: Bool { get }
}

extension NWPath: PathProtocol {}

public class NetworkMonitor {
    private var monitor = NWPathMonitor()
    @Published var connected: Bool = false
    
    public func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.handleUpdate(path: path)
        }
    }
    
    private func handleUpdate(path: PathProtocol) {
        let reachabilityState = path.status == .satisfied
        self.connected = reachabilityState
    }
}

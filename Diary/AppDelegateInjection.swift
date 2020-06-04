//
//  AppDelegateInjection.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/4/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { UserService() }
            .scope(application)
    }
}

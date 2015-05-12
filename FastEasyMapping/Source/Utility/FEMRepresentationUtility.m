//
// Created by zen on 12/05/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "FEMRepresentationUtility.h"

id FEMRepresentationRootForKeyPath(id representation, NSString *keyPath) {
    if (keyPath.length > 0) {
        return [representation valueForKeyPath:keyPath];
    }

    return representation;
}
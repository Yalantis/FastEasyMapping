// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMObjectRef.h"

@implementation FEMObjectRef

- (instancetype)initWithValue:(id)value {
    self = [super init];
    if (self) {
        _strongValue = value;
    }
    return self;
}

- (void)setUseWeakOwnership:(BOOL)useWeakOwnership {
    if (_useWeakOwnership == useWeakOwnership) {
        return;
    }
    
    _useWeakOwnership = useWeakOwnership;
    
    if (_useWeakOwnership) {
        _weakValue = _strongValue;
        _strongValue = nil;
    } else {
        _strongValue = _weakValue;
        _weakValue = nil;
    }
}

- (id)value {
    return _strongValue ?: _weakValue;
}

@end

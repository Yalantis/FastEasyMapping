// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "Fixture.h"

@implementation Fixture

+ (id)buildUsingFixture:(NSString *)fileName {
    NSBundle *bundle = [NSBundle bundleForClass:self];
    NSString *path = [bundle pathForResource:fileName ofType:@"json"];

    if (path != nil) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    }

    return nil;
}

@end

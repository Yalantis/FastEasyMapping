# CMFactory

This project brings the idea of [FactoryGirl](https://github.com/thoughtbot/factory_girl) to iOS projects, and it loads fixtures and unmarshall them into a [Mantle](https://github.com/github/Mantle) class or NSDictionary class.

##Contact:

Developed by [Lucas Medeiros](https://www.twitter.com/aspmedeiros) at [Codeminer42](http://www.codeminer42.com) in [Fortaleza](http://goo.gl/maps/EIAxy)

Follow us on twitter: [@Codeminer42](https://twitter.com/Codeminer42)

## Development requirements

* Cocoapods - https://github.com/CocoaPods/CocoaPods

## Install cocoapods

To install cocoapods you will need ruby.

	gem install cocoapods
	
More information about cocoapods:

* https://github.com/CocoaPods/CocoaPods
* http://nsscreencast.com/episodes/5-cocoapods

## Cocoapods

Add the dependency to your `Podfile`:

```ruby
platform :ios

...

target :WhateverExampleTests, :exclusive => true do
  pod 'CMFactory'
  ...
end

```
Run `pod install` to install the dependencies.

## Usage

* Loading fixtures

```objective-c
#import "CMFixture.h"
#import "Kiwi.h"

SPEC_BEGIN(YourSpec)
	
	//If you use github's Mantle library                    
	beforeEach(^{
	     YourClass *yourInstance = [CMFactory buildUsingMantleClass:[YourClass class] fromFactory:@"YourClass"];
		 //Or
		 NSArray *aColletion = [CMFactory buildUsingMantleClass:[YourClass class] fromFactory:@"People"];
	});
	
	//If you don't use github's Mantle library
	beforeEach(^{
	     NSDictionary *dictionary = [CMFactory buildUsingFactory:@"YourClass"];
		 //Or
		 NSArray *aColletion = [CMFactory buildUsingFactory:@"People"];
	});

SPEC_END

```
After that, in your test project, you need to create a file with your factory name in .json or .plist format
(Ex: if your factory name is 'People' and you have a file people.json and other people.plist it will unmarshall the .json file)

* Creating instances dynamically

```objective-c
#import "CMFactory.h"
#import "Kiwi.h"

SPEC_BEGIN(YourSpec)
	
	specify(^{

		CMFactory *factory = [CMFactory forClass:[YourClass class]];

	    [factory addToField:@"aFieldName" value:^{
	         return @"www.codeminer42.com";
	    }];
	
		YourClass *instance = [factory build];
		[[instance.aFieldName should] equal: @"www.codeminer42.com"];

	});
	
	context(@"when using sequence method", ^{

		 __block CMFactory *factory;
		 __block NSArray *images;

	     beforeEach(^{
	          factory = [CMFactory forClass:[CMImage class]];
	          [factory addToField:@"url" sequenceValue:^(NSUInteger sequence) {
	              return [NSString stringWithFormat:@"www.github.com%d", sequence];
	          }];
	          images = [factory buildWithCapacity:3];
	     });

	     specify(^{
	          [[images should] haveCountOf:3];
	     });

	     specify(^{

	         for(NSUInteger i = 0; i < 3; i++) {
	             CMImage *image = [images objectAtIndex:i];
	              [[image.url should] equal:[NSString stringWithFormat:@"www.github.com%d", i]];
	         }

	     });

	});

SPEC_END

```

* See the example code

## Requirements

`CMFactory` requires iOS 5.x or greater.

## Next version

Integration with core data to use 'create' like methods

## License

Usage is provided under the [MIT License](http://http://opensource.org/licenses/mit-license.php).  See LICENSE for the full details.



//
// Copyright (c) 2015 Artsy Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>

#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS" 
#define IPHONE_4_NAMESTRING             @"iPhone 4" 
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_4G_NAMESTRING              @"iPad 4G"
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

#define SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator" // :)

typedef enum {
    UIDeviceUnknown,
    
    UIDeviceSimulator,
    UIDeviceSimulatoriPhone,
    UIDeviceSimulatoriPad,
    UIDeviceSimulatorAppleTV,
    
    UIDevice1GiPhone,
    UIDevice3GiPhone,
    UIDevice3GSiPhone,
    UIDevice4iPhone,
    UIDevice4SiPhone,
    UIDevice5iPhone,
    
    UIDevice1GiPod,
    UIDevice2GiPod,
    UIDevice3GiPod,
    UIDevice4GiPod,
    
    UIDevice1GiPad,
    UIDevice2GiPad,
    UIDevice3GiPad,
    UIDevice4GiPad,
    
    UIDeviceAppleTV2,
    UIDeviceAppleTV3,
    UIDeviceAppleTV4,
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceUnknownAppleTV,
    UIDeviceIFPGA,

} UIDevicePlatform;

typedef enum {
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown,
    
} UIDeviceFamily;

@interface UIDevice (Hardware)
- (NSString *) platform;
- (NSString *) hwmodel;
- (NSUInteger) platformType;
- (NSString *) platformString;

- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) cpuCount;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;

- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;

- (NSString *) macaddress;

- (BOOL) hasRetinaDisplay;
- (UIDeviceFamily) deviceFamily;

/// Orta
+ (BOOL)isPad;
+ (BOOL)isPhone;
+ (BOOL)isRunningUnitTests;
- (NSString *)deviceFamilyString;
@end
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

#import "ARExpectaExtensions.h"

void _itTestsAsyncronouslyWithDevicesRecording(id self, int lineNumber, const char *fileName, BOOL record, NSString *name, id (^block)()) {

    void (^snapshot)(id, NSString *) = ^void (id sut, NSString *suffix) {

        EXPExpect *expectation = _EXP_expect(self, lineNumber, fileName, ^id{ return EXPObjectify((sut)); });

        if (record) {
            expectation.will.recordSnapshotNamed([name stringByAppendingString:suffix]);
        } else {
            expectation.will.haveValidSnapshotNamed([name stringByAppendingString:suffix]);
        }
    };

    it([name stringByAppendingString:@" as iphone"], ^{
        [ARTestContext stubDevice:ARDeviceTypePhone5];
        id sut = block();
        snapshot(sut, @" as iphone");
        [ARTestContext stopStubbing];
    });

    it([name stringByAppendingString:@" as ipad"], ^{
        [ARTestContext stubDevice:ARDeviceTypePad];
        id sut = block();
        snapshot(sut, @" as ipad");
        [ARTestContext stopStubbing];
    });
}

void _itTestsSyncronouslyWithDevicesRecording(id self, int lineNumber, const char *fileName, BOOL record, NSString *name, id (^block)()) {
    
    void (^snapshot)(id, NSString *) = ^void (id sut, NSString *suffix) {
        
        EXPExpect *expectation = _EXP_expect(self, lineNumber, fileName, ^id{ return EXPObjectify((sut)); });
        
        if (record) {
            expectation.to.recordSnapshotNamed([name stringByAppendingString:suffix]);
        } else {
            expectation.to.haveValidSnapshotNamed([name stringByAppendingString:suffix]);
        }
    };
    
    it([name stringByAppendingString:@" as iphone"], ^{
        [ARTestContext stubDevice:ARDeviceTypePhone5];
        id sut = block();
        snapshot(sut, @" as iphone");
        [ARTestContext stopStubbing];
    });
    
    it([name stringByAppendingString:@" as ipad"], ^{
        [ARTestContext stubDevice:ARDeviceTypePad];
        id sut = block();
        snapshot(sut, @" as ipad");
        [ARTestContext stopStubbing];
    });
}

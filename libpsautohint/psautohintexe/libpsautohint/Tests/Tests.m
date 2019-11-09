//
//  Tests.m
//  Tests
//
//  Created by Georg Seifert on 09.11.19.
//  Copyright © 2019 rroberts. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "psautohint.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (NSString *)autohintFontInfo:(NSString *)fontInfo bezString:(NSString *)bezString {
    
    NSString *resultString = nil;
#ifdef DEBUG
    NSDate *startdate = [NSDate date];
#endif
    ACBuffer* output;
    const char* bezdata = [bezString UTF8String];
    const char* fontinfo = [fontInfo UTF8String];         /* the string of fontinfo data */
    bool allowEdit, roundCoords, allowHintSub;
    allowEdit = allowHintSub = roundCoords = true;
    allowEdit = false;
    roundCoords = false;
    
    output = ACBufferNew(4 * strlen(bezdata));
    
    int result = AutoHintString(bezdata, fontinfo, output, allowEdit, allowHintSub, roundCoords);
    
    if (result == AC_Success) {
        resultString = [NSString stringWithCString:output->data encoding:NSASCIIStringEncoding];
    }
    
    ACBufferFree(output);
    output = NULL;
    return resultString;
}

- (void)testSimple {
    NSString *fontInfo = @"OrigEmSqUnits 1000 FontName Default AscenderHeight 641 AscenderOvershoot 1 FigHeight 456 FigOvershoot 1 LcHeight 431 LcOvershoot 1 BaselineYCoord 0 BaselineOvershoot -1 DescenderHeight -186 DescenderOvershoot -1 DominantV [14] StemSnapV [14 14] DominantH [12] StemSnapH [12 12] FlexOK true";
    NSString *bezString = @"sc\n  464 0 mt\n  479 0 dt\n  269 641 dt\n  255 641 dt\n  400.746 194 dt\n  105.557 194 dt\n  252 641 dt\n  238 641 dt\n  27 0 dt\n  42 0 dt\n  101.626 182 dt\n  404.658 182 dt\n  cp";
    NSString *expectedResult = @"27 452 vstem\n21 -21 hstem\n182 12 hstem\n641 -20 hstem\n464 hmoveto\n15 hlineto\n-210 641 rlineto\n-14 hlineto\n14575 100 div -447 rlineto\n-29519 100 div hlineto\n14644 100 div 447 rlineto\n-14 hlineto\n-211 -641 rlineto\n15 hlineto\n5962 100 div 182 rlineto\n30302 100 div hlineto\nclosepath\nendchar\n";
    NSString *result = [self autohintFontInfo:fontInfo bezString:bezString];
    XCTAssertEqualObjects(result, expectedResult);
}

- (void)testPerformanceExample {
    [self measureBlock:^{
        
    }];
}

@end

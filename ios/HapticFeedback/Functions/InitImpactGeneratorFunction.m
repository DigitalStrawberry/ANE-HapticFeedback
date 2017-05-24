/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2017 Digital Strawberry LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "InitImpactGeneratorFunction.h"
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "HapticFeedback.h"

UIImpactFeedbackStyle uihf_getImpactStyle( int impactStyleId ) {
    if( impactStyleId == 0 ) {
        return UIImpactFeedbackStyleLight;
    }
    if( impactStyleId == 1 ) {
        return UIImpactFeedbackStyleMedium;
    }
    return UIImpactFeedbackStyleHeavy;
}

FREObject uihf_initImpactGenerator( FREContext context, void* functionData, uint32_t argc, FREObject argv[] ) {
    if( [[HapticFeedback sharedInstance] isAvailable] ) {
        int generatorId = [MPFREObjectUtils getInt:argv[0]];
        int impactStyleId = [MPFREObjectUtils getInt:argv[1]];
        [[HapticFeedback sharedInstance] initImpactGenerator:generatorId withStyle:uihf_getImpactStyle(impactStyleId)];
    } else if( [[HapticFeedback sharedInstance] showLogs] ) {
        [[HapticFeedback sharedInstance] log:@"HapticFeedback is not supported on this device."];
    }
    return nil;
}

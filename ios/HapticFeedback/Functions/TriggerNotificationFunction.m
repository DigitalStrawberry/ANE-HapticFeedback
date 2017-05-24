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

#import "TriggerNotificationFunction.h"
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "HapticFeedback.h"

UINotificationFeedbackType uihf_getNotificationType( int notificationTypeId ) {
    if( notificationTypeId == 0 ) {
        return UINotificationFeedbackTypeSuccess;
    }
    if( notificationTypeId == 1 ) {
        return UINotificationFeedbackTypeWarning;
    }
    return UINotificationFeedbackTypeError;
}

FREObject uihf_triggerNotification( FREContext context, void* functionData, uint32_t argc, FREObject argv[] ) {
    if( [[HapticFeedback sharedInstance] isAvailable] ) {
        int generatorId = [MPFREObjectUtils getInt:argv[0]];
        int notificationTypeId = [MPFREObjectUtils getInt:argv[1]];
        [[HapticFeedback sharedInstance] triggerNotification:generatorId notificationType:uihf_getNotificationType(notificationTypeId)];
    } else if( [[HapticFeedback sharedInstance] showLogs] ) {
        [[HapticFeedback sharedInstance] log:@"HapticFeedback is not supported on this device."];
    }
    return nil;
}

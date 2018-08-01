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

#import "HapticFeedback.h"
#import "Functions/SetLogEnabledFunction.h"
#import "Functions/InitImpactGeneratorFunction.h"
#import "Functions/InitSelectionGeneratorFunction.h"
#import "Functions/InitNotificationGeneratorFunction.h"
#import "Functions/PrepareGeneratorFunction.h"
#import "Functions/TriggerImpactFunction.h"
#import "Functions/TriggerSelectionFunction.h"
#import "Functions/TriggerNotificationFunction.h"
#import "Functions/ReleaseGeneratorFunction.h"
#import "Functions/IsAvailableFunction.h"
#import <sys/utsname.h>
#import <AIRExtHelpers/MPFREObjectUtils.h>

FREContext airHapticFeedbackExtContext = nil;
static HapticFeedback* airHapticFeedbackSharedInstance = nil;

@implementation HapticFeedback {
    NSMutableDictionary* _generatorsMap;
    NSString* _deviceId;
    BOOL _isAvailable;
}

@synthesize showLogs;

+ (nonnull instancetype) sharedInstance {
    if( airHapticFeedbackSharedInstance == nil ) {
        airHapticFeedbackSharedInstance = [[HapticFeedback alloc] init];
    }
    return airHapticFeedbackSharedInstance;
}

# pragma mark - Init

- (instancetype) init {
    self = [super init];
    
    if( self != nil ) {
        _generatorsMap = [NSMutableDictionary dictionary];
        
        _isAvailable = NO;
        
        struct utsname systemInfo;
        uname(&systemInfo);
        _deviceId = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        if(_deviceId != nil)
        {
            NSRange prefixRange = [_deviceId rangeOfString:@"iPhone"];
            if(prefixRange.location != NSNotFound)
            {
                NSString* deviceVer = [_deviceId substringFromIndex:prefixRange.length];
                deviceVer = [deviceVer stringByReplacingOccurrencesOfString:@"," withString:@"."];
                float ver = [deviceVer floatValue];
                
                // Available on iOS 10 and iPhone 7 and newer
                _isAvailable = NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max;
                _isAvailable = _isAvailable && (ver > 9.0);
            }
        }
    }
    
    return self;
}

- (void) initImpactGenerator:(int) generatorId withStyle:(UIImpactFeedbackStyle) style {
    UIFeedbackGenerator* generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:style];
    if( [self showLogs] ) {
        [self log:[NSString stringWithFormat:@"Created impact feedback generator with style: %li", (long)style]];
    }
    [self addGenerator:generatorId generator:generator];
}

- (void) initNotificationGenerator:(int) generatorId {
    UIFeedbackGenerator* generator = [[UINotificationFeedbackGenerator alloc] init];
    if( [self showLogs] ) {
        [self log:@"Created notification feedback generator"];
    }
    [self addGenerator:generatorId generator:generator];
}

- (void) initSelectionGenerator:(int) generatorId {
    UIFeedbackGenerator* generator = [[UISelectionFeedbackGenerator alloc] init];
    if( [self showLogs] ) {
        [self log:@"Created notification feedback generator"];
    }
    [self addGenerator:generatorId generator:generator];
}

# pragma mark - Prepare / Trigger / Remove

- (void) prepareGenerator:(int) generatorId {
    UIFeedbackGenerator* generator = [self getGenerator:generatorId];
    if( generator != nil ) {
        if( [self showLogs] ) {
            [self log:[NSString stringWithFormat:@"Preparing generator with id %i", generatorId]];
        }
        [generator prepare];
    }
}

- (void) triggerImpact:(int) generatorId {
    UIFeedbackGenerator* generator = [self getGenerator:generatorId];
    if( generator != nil && [generator isKindOfClass:[UIImpactFeedbackGenerator class]] ) {
        if( [self showLogs] ) {
            [self log:@"Triggering impact feedback."];
        }
        [(UIImpactFeedbackGenerator*) generator impactOccurred];
    } else if( [self showLogs] ) {
        [self log:@"Cannot trigger impact feedback, generator not found."];
    }
}

- (void) triggerNotification:(int) generatorId notificationType:(UINotificationFeedbackType)notificationType {
    UIFeedbackGenerator* generator = [self getGenerator:generatorId];
    if( generator != nil && [generator isKindOfClass:[UINotificationFeedbackGenerator class]] ) {
        if( [self showLogs] ) {
            [self log:@"Triggering notification feedback."];
        }
        [(UINotificationFeedbackGenerator*) generator notificationOccurred:notificationType];
    } else if( [self showLogs] ) {
        [self log:@"Cannot trigger notification feedback, generator not found."];
    }
}

- (void) triggerSelection:(int) generatorId {
    UIFeedbackGenerator* generator = [self getGenerator:generatorId];
    if( generator != nil && [generator isKindOfClass:[UISelectionFeedbackGenerator class]] ) {
        if( [self showLogs] ) {
            [self log:@"Triggering selection feedback."];
        }
        [(UISelectionFeedbackGenerator*) generator selectionChanged];
    } else if( [self showLogs] ) {
        [self log:@"Cannot trigger selection feedback, generator not found."];
    }
}

- (void) releaseGenerator:(int) generatorId {
    if( [_generatorsMap objectForKey:@(generatorId)] ) {
        if( [self showLogs] ) {
            [self log:[NSString stringWithFormat:@"Removing generator with id: %i | generator: %@", generatorId, _generatorsMap[@(generatorId)]]];
        }
        [_generatorsMap removeObjectForKey:@(generatorId)];
    } else if( [self showLogs] ) {
        [self log:[NSString stringWithFormat:@"Generator with id %i not found.", generatorId]];
    }
}

# pragma mark - Misc

- (void) log:(const NSString*) message {
    NSLog( @"[HapticFeedback] %@", message );
}

- (BOOL) isAvailable {
    return _isAvailable;
}

# pragma mark - Private API

- (void) addGenerator:(int) generatorId generator:(nullable UIFeedbackGenerator*) generator {
    if( generator != nil ) {
        _generatorsMap[@(generatorId)] = generator;
    }
}

- (nullable UIFeedbackGenerator*) getGenerator:(int) generatorId {
    return _generatorsMap[@(generatorId)];
}

@end

/**
 *
 *
 * Context initialization
 *
 *
 **/

FRENamedFunction airHapticFeedbackExtFunctions[] = {
    { (const uint8_t*) "setLogEnabled",               0, uihf_setLogEnabled },
    { (const uint8_t*) "initImpactGenerator",         0, uihf_initImpactGenerator },
    { (const uint8_t*) "initNotificationGenerator",   0, uihf_initNotificationGenerator },
    { (const uint8_t*) "initSelectionGenerator",      0, uihf_initSelectionGenerator },
    { (const uint8_t*) "prepareGenerator",            0, uihf_prepareGenerator },
    { (const uint8_t*) "triggerImpactFeedback",       0, uihf_triggerImpact },
    { (const uint8_t*) "triggerNotificationFeedback", 0, uihf_triggerNotification },
    { (const uint8_t*) "triggerSelectionFeedback",    0, uihf_triggerSelection },
    { (const uint8_t*) "releaseGenerator",            0, uihf_releaseGenerator },
    { (const uint8_t*) "isAvailable",                 0, uihf_isAvailable }
};

void HapticFeedbackContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet ) {
    *numFunctionsToSet = sizeof( airHapticFeedbackExtFunctions ) / sizeof( FRENamedFunction );
    
    *functionsToSet = airHapticFeedbackExtFunctions;
    
    airHapticFeedbackExtContext = ctx;
}

void HapticFeedbackContextFinalizer( FREContext ctx ) { }

void HapticFeedbackInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &HapticFeedbackContextInitializer;
    *ctxFinalizerToSet = &HapticFeedbackContextFinalizer;
}

void HapticFeedbackFinalizer( void* extData ) { }








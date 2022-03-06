//
//  SafariWebExtensionHandler.m
//  wordleMatrix Extension
//
//  Created by 吉沢 正敏 on 2022/02/24.
//

#import <Foundation/Foundation.h>
#import <IOKit/serial/ioss.h>
#import <sys/ioctl.h>
#import <sys/fcntl.h>

#import "SafariWebExtensionHandler.h"

#import <SafariServices/SafariServices.h>

#if __MAC_OS_X_VERSION_MIN_REQUIRED < 110000
NSString * const SFExtensionMessageKey = @"message";
#endif

@implementation SafariWebExtensionHandler

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
    id message = [context.inputItems.firstObject userInfo][SFExtensionMessageKey];
    NSDictionary    *messageDict = (NSDictionary*)message;
    NSString        *boardStr = messageDict[@"message"];
    
    if(boardStr.length == (5*6)) {
        char    boardLeds[(5*6)+1];
        [boardStr getCString:boardLeds maxLength:(5*6)+1 encoding:NSASCIIStringEncoding];

        struct termios options;
        int baud = 115200;
        
        int serialFileDescriptor = open("/dev/cu.usbserial-9D525ABF5C", O_RDWR | O_NOCTTY | O_NONBLOCK);
        // your device here

        if( serialFileDescriptor != -1) {
            ioctl(serialFileDescriptor, TIOCEXCL);
            fcntl(serialFileDescriptor, F_SETFL, 0);
            tcgetattr(serialFileDescriptor, &options);
            cfmakeraw(&options);
            ioctl(serialFileDescriptor, IOSSIOSPEED, &baud);
            
            for( int i = 0 ; i < 25 ; i++) {
                int x = i % 5;
                int y = i / 5;
                unsigned char   dat = 0;
                
                dat += (x & 7) << 5;
                dat += (y & 7) << 2;
                switch(boardLeds[i]) {
                    case 'Y':
                        dat += 1;
                        break;
                    case 'G':
                        dat += 2;
                        break;
                    case 'B':
                    default:
                        dat += 0;
                }
                write(serialFileDescriptor, &dat, 1);
            }
            close(serialFileDescriptor);
        }
    }
}

@end

//
//  main.m
//  matrixSend / test tool
//
//  Created by 吉沢 正敏 on 2022/02/28.
//

#import <Foundation/Foundation.h>
#import <IOKit/serial/ioss.h>
#import <sys/ioctl.h>
#import <sys/fcntl.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if(argc != 2)
            exit(1);

        char    *boardLeds = argv[1];
        if( strlen(boardLeds) != (5*6))
            exit(1);

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

    return 0;
}

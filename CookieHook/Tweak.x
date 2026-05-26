#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *logPath = @"/var/mobile/Media/safari_cookie_log.txt";

static void writeLog(NSString *content) {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:logPath]) {
        [fm createFileAtPath:logPath contents:nil attributes:nil];
    }
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:logPath];
    [handle seekToEndOfFile];
    [handle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}

%hook NSHTTPCookieStorage
- (void)setCookie:(NSHTTPCookie *)cookie {
    NSString *log = [NSString stringWithFormat:@"[+] %@ | %@ = %@\n",
                    [NSDate date],
                    cookie.name,
                    cookie.value];
    NSLog(@"CookieHook: %@", log);
    writeLog(log);
    %orig;
}
%end

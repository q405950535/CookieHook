#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *logPath = @"/var/mobile/Documents/CookieHook.txt";

static void writeLog(NSString *content) {
    @try {
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:logPath]) {
            [fm createFileAtPath:logPath contents:nil attributes:nil];
            [fm setAttributes:@{NSFilePosixPermissions: @0777} ofItemAtPath:logPath error:nil];
        }
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:logPath];
        [handle seekToEndOfFile];
        [handle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [handle closeFile];
    } @catch (NSException *e) {
        NSLog(@"[CookieHook] 写入错误: %@", e);
    }
}

%hook NSHTTPCookieStorage
- (void)setCookie:(NSHTTPCookie *)cookie {
    %orig;
    if (cookie && cookie.name && cookie.value) {
        NSString *log = [NSString stringWithFormat:@"%@=%@;\n", cookie.name, cookie.value];
        NSLog(@"[CookieHook] 捕获: %@", log);
        writeLog(log);
    }
}
%end

%hook WKHTTPCookieStore
- (void)setCookie:(NSHTTPCookie *)cookie completionHandler:(void (^)(void))completionHandler {
    %orig;
    if (cookie && cookie.name && cookie.value) {
        NSString *log = [NSString stringWithFormat:@"%@=%@;\n", cookie.name, cookie.value];
        NSLog(@"[CookieHook] WK捕获: %@", log);
        writeLog(log);
    }
}
%end

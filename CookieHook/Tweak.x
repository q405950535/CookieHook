#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 无根环境通用、按键精灵可直接读取的路径
static NSString *logPath = @"/var/mobile/Documents/CookieHook.txt";

static void writeLog(NSString *content) {
    @try {
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:logPath]) {
            [fm createFileAtPath:logPath contents:nil attributes:nil];
            // 给最高权限，避免按键精灵读不到
            [fm setAttributes:@{NSFilePosixPermissions: @0777} ofItemAtPath:logPath error:nil];
        }
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:logPath];
        [handle seekToEndOfFile];
        [handle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [handle closeFile];
    } @catch (NSException *e) {
        NSLog(@"[CookieHook] 写入失败: %@", e);
    }
}

// 旧接口 Hook
%hook NSHTTPCookieStorage
- (void)setCookie:(NSHTTPCookie *)cookie {
    %orig;
    if (cookie && cookie.name && cookie.value) {
        NSString *line = [NSString stringWithFormat:@"%@=%@;\n", cookie.name, cookie.value];
        NSLog(@"[CookieHook] NS捕获: %@", line);
        writeLog(line);
    }
}
%end

// 现代浏览器（WKWebView）Cookie 捕获
%hook WKHTTPCookieStore
- (void)setCookie:(NSHTTPCookie *)cookie completionHandler:(void (^)(void))completionHandler {
    %orig;
    if (cookie && cookie.name && cookie.value) {
        NSString *line = [NSString stringWithFormat:@"%@=%@;\n", cookie.name, cookie.value];
        NSLog(@"[CookieHook] WK捕获: %@", line);
        writeLog(line);
    }
}
%end

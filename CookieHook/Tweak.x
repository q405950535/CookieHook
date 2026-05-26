#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 🔥 按键精灵最容易读取的路径（通用、权限最高）
static NSString *logPath = @"/var/mobile/Documents/CookieHook.txt";

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
    // 只保存有用的 Cookie，过滤空值
    if (cookie && cookie.name && cookie.value) {
        NSString *log = [NSString stringWithFormat:@"%@=%@\n", cookie.name, cookie.value];
        NSLog(@"[CookieHook] 捕获: %@", log);
        writeLog(log);
    }
    %orig;
}
%end

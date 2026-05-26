#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 全越狱环境通用路径（绝对能写）
static NSString *logPath = @"/var/mobile/Documents/CookieHook.txt";

static void writeLog(NSString *content) {
    @try {
        NSFileManager *fm = NSFileManager.defaultManager;
        if (![fm fileExistsAtPath:logPath]) {
            [fm createFileAtPath:logPath contents:nil attributes:nil];
            // 关键：给最高权限，按键精灵也能读
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

%hook NSHTTPCookieStorage
- (void)setCookie:(NSHTTPCookie *)cookie {
    %orig;
    
    if (!cookie) return;
    
    NSString *line = [NSString stringWithFormat:@"%@=%@;\n", cookie.name, cookie.value];
    NSLog(@"[CookieHook] 成功捕获: %@", line);
    writeLog(line);
}

- (void)setCookies:(NSArray *)cookies {
    %orig;
    for (NSHTTPCookie *c in cookies) {
        NSString *line = [NSString stringWithFormat:@"%@=%@;\n", c.name, c.value];
        NSLog(@"[CookieHook] 批量捕获: %@", line);
        writeLog(line);
    }
}
%end

// 额外加强 Hook WKWebView（现代浏览器都用这个）
%hook WKHTTPCookieStore
- (void)setCookie:(NSHTTPCookie *)cookie completionHandler:(void (^)(void))completionHandler {
    %orig;
    NSString *line = [NSString stringWithFormat:@"%@=%@;\n", cookie.name, cookie.value];
    NSLog(@"[CookieHook] WKWebView捕获: %@", line);
    writeLog(line);
}
%end

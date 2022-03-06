//
//  ViewController.m
//  wordleMatrix
//
//  Created by 吉沢 正敏 on 2022/02/24.
//

#import "ViewController.h"

#import <SafariServices/SafariServices.h>
#import <WebKit/WebKit.h>

static NSString * const extensionBundleIdentifier = @"com.yoz-jp.wordleMatrix.Extension";

@interface ViewController () <WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic) IBOutlet WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _webView.navigationDelegate = self;

    [_webView.configuration.userContentController addScriptMessageHandler:self name:@"controller"];

    [_webView loadFileURL:[NSBundle.mainBundle URLForResource:@"Main" withExtension:@"html"] allowingReadAccessToURL:NSBundle.mainBundle.resourceURL];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [SFSafariExtensionManager getStateOfSafariExtensionWithIdentifier:extensionBundleIdentifier completionHandler:^(SFSafariExtensionState *state, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!state) {
                // Insert code to inform the user something went wrong.
                return;
            }

            [webView evaluateJavaScript:[NSString stringWithFormat:@"show(%@)", state.isEnabled ? @"true" : @"false"] completionHandler:nil];
        });
    }];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (![message.body isEqualToString:@"open-preferences"])
        return;

    [SFSafariApplication showPreferencesForExtensionWithIdentifier:extensionBundleIdentifier completionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSApplication.sharedApplication terminate:nil];
        });
    }];
}

@end

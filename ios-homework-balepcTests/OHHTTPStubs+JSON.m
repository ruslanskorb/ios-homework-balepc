//
// Copyright (c) 2015 Artsy Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "OHHTTPStubs+JSON.h"

@implementation OHHTTPStubs (JSON)

+ (void)stubJSONResponseAtPath:(NSString *)path withResponse:(id)response
{
    [OHHTTPStubs stubJSONResponseAtPath:path withResponse:response andStatusCode:200];
}

+ (void)stubJSONResponseAtPath:(NSString *)path withResponse:(id)response andStatusCode:(NSInteger)code;
{
    [OHHTTPStubs stubJSONResponseAtPath:path withParams:nil withResponse:response andStatusCode:code];
}

+ (void)stubJSONResponseAtPath:(NSString *)path withParams:(NSDictionary *)params withResponse:(id)response
{
    [OHHTTPStubs stubJSONResponseAtPath:path withParams:params withResponse:response andStatusCode:200];
}

+ (void)stubJSONResponseAtPath:(NSString *)path withParams:(NSDictionary *)params withResponse:(id)response andStatusCode:(NSInteger)code
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSURLComponents *requestComponents = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:NO];
        NSString *urlString = path;
        
        if (params) {
            NSString *stubbedQueryString = AFQueryStringFromParametersWithEncoding(params, NSUTF8StringEncoding);
            urlString = [urlString stringByAppendingFormat:@"?%@", stubbedQueryString];
        }
        
        NSURL *stubbedURL = [NSURL URLWithString:urlString];
        NSURLComponents *stubbedComponents = [NSURLComponents componentsWithURL:stubbedURL resolvingAgainstBaseURL:NO];
        
        BOOL pathsMatch = [requestComponents.path isEqualToString:stubbedComponents.path];
        BOOL queriesMatch = params ? [requestComponents.query isEqualToString:stubbedComponents.query] : YES;
        return (pathsMatch && queriesMatch);
        
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:response options:0 error:nil];
        return [OHHTTPStubsResponse responseWithData:data statusCode:(int)code headers:@{ @"Content-Type": @"application/json" }];
    }];
}

@end

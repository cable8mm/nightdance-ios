//
//  IAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "VerificationController.h"
#import "UserManager.h"
#import "SCManager.h"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPHelper {
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (NSSet*)getProductIdentifiers {
    return _productIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
        // Add self as transaction observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }
    return self;
    
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    
    _completionHandler = [completionHandler copy];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)validateReceiptForTransaction:(SKPaymentTransaction *)transaction {
    // 결제 성공
    [self purchaseSubscriptionForProductIdentifier:transaction];

//    VerificationController * verifier = [VerificationController sharedInstance];
//    [verifier verifyPurchase:transaction completionHandler:^(BOOL success) {
//        if (success) {
//            NSLog(@"Successfully verified receipt!");
//            // 결제 성공
////            [self purchaseSubscriptionForProductIdentifier:transaction];
//        } else {
//            NSLog(@"Failed to validate receipt.");
//            [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//        }
//
//    }];
}

- (NSDictionary *)getProductInfo:(NSString *)key {
    return _productsInfo[key];
}

- (void)purchaseSubscriptionForProductIdentifier:(SKPaymentTransaction *)transaction {
    // productIdentifier 구입 로직
    NSLog(@"Phchased productIdentifier = %@", transaction.payment.productIdentifier);
    
    NSDictionary *productInfo   = [self getProductInfo:transaction.payment.productIdentifier];
    [UserManager expandExpiryDate:[productInfo[@"term"] intValue]];
    
    NSTimeInterval expireDateTimeStamp  = [UserManager getExpiryDateTimeStamp];
    NSInteger time = round(expireDateTimeStamp);
    NSString *params    = [NSString stringWithFormat:@"product_id=%@&transaction_id=%@&ticket_expired=%d", transaction.payment.productIdentifier, transaction.transactionIdentifier, (int)time];
    
    NSString *urlString = [SCManager getAuthUrl:@"submit_payment.php" param:params];
//    NSDictionary *jsonData  = [SCManager getJsonData:urlString];
    [SCManager getJsonData:urlString];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}

#pragma mark SKPaymentTransactionOBserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self validateReceiptForTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self validateReceiptForTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"failedTransaction...");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"결제 실패"
                                                         message:transaction.error.localizedDescription
                                                        delegate:self
                                               cancelButtonTitle:@"닫기"
                                               otherButtonTitles:nil];
        [alert show];
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
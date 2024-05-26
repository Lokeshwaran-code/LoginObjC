//
//  ViewController.m
//  LoginObjC
//
//  Created by LOKESH on 20/05/24.
//

#import "ViewController.h"
#import "SecondPage.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *userId;
@property (strong, nonatomic) IBOutlet UIButton *login;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)login:(id)sender 
{
    NSString *username = self.userName.text;
    NSString *userID = self.userId.text;
    
    if ([self areFieldsValidWithUsername:username userID:userID]) 
    {
        [self validateLoginWithUsername:username userID:userID];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SecondPage *secondVC = [storyboard instantiateViewControllerWithIdentifier:@"SecondPage"];
            [self.navigationController pushViewController:secondVC animated:YES];
    }
    else
    {
        NSLog(@"Error");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                       message:@"Enter Correct Details."
                                       preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {}];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
   

}

- (BOOL)areFieldsValidWithUsername:(NSString *)username userID:(NSString *)userID {
    return username.length > 0 && userID.length > 0;
    
    - (void)validateLoginWithUsername:(NSString *)username userID:(NSString *)userID {
        NSString *urlString = @"https://mocki.io/v1/2cda35a6-fdc0-4d3c-9810-fc4af224b82b";
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                return;
            }
            
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (jsonError) {
                NSLog(@"JSON Error: %@", jsonError.localizedDescription);
                return;
            }
            
            NSString *apiUsername = jsonResponse[@"username"];
            NSString *apiUserID = jsonResponse[@"userid"];
            
            if ([username isEqualToString:apiUsername] && [userID isEqualToString:apiUserID]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"showNextViewController" sender:self];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid Username or UserID" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }
        }] resume];
    }
}
@end

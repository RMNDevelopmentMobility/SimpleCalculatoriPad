//
//  ViewController.m
//  SimpleCalculatoriPad
//
//  Created by Mobile3 on 10/16/15.
//  Copyright © 2015 RMN Development Mobiliy. All rights reserved.
//

#import "ViewController.h"
#import "Calculadora.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCalculatorClick:(id)sender {
    
    Calculadora* calc = [[[NSBundle mainBundle] loadNibNamed:@"Calculadora" owner:self options:nil] objectAtIndex:0];
    
    [calc presentTransparentModalViewController:calc animated:YES withAlpha:0.5f controller:self];
}

@end

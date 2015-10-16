//
//  Calculadora.h
//  XMobPOS
//
//  Created by Rodrigo Mendes Nunes / Rafael Baraldi on 12/10/15.
//  Copyright © 2015 resource. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    operacaoNenhuma = 0,
    operacaoSoma,
    operacaoSub,
    operacaoMulti,
    operacaoDiv,
    operacaoPercent
} operacaoCalc ;

typedef enum {
    acaoNenhuma = 0,
    acaoNumero,
    acaoOperacao,
    acaoIgual,
    acaoDecimal,
    acaoLimpar
} acao ;

@interface Calculadora : UIView

@property UIView* transparentView;
@property BOOL isAnimating;

@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UITextField *txtVisor;
@property (weak, nonatomic) IBOutlet UILabel *lblOperacoes;

@property double primeiroValor;
@property double segundoValor;

@property BOOL primeiroValorVazio;

@property int operacao;
@property int ultimaOperacao;
@property int ultimaAcao;

- (IBAction)btnACClick:(id)sender;

- (IBAction)btnDivisaoClick:(id)sender;
- (IBAction)btnMultiplicacaolick:(id)sender;
- (IBAction)btnSubtracaoClick:(id)sender;
- (IBAction)btnSomaClick:(id)sender;
- (IBAction)btnPercentClick:(id)sender;
- (IBAction)btnDecimalClick:(id)sender;
- (IBAction)btnIgualClick:(id)sender;

- (IBAction)btnNumClick:(id)sender;

- (IBAction)btnCancelarClick:(id)sender;

-(void) presentTransparentModalViewController: (UIView *) aView
                                     animated: (BOOL) isAnimated
                                    withAlpha: (CGFloat) anAlpha
                                   controller: (UIViewController*) controller;

-(void) dismissTransparentModalViewControllerAnimated:(BOOL) animated;

-(void) dismissTransparentModalViewControllerAnimated:(BOOL) animated completion:(void (^)(void))completion;

@end

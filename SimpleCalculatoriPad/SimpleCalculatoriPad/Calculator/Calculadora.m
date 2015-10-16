//
//  Calculadora.m
//  XMobPOS
//
//  Created by Rodrigo Mendes Nunes / Rafael Baraldi on 12/10/15.
//  Copyright © 2015 resource. All rights reserved.
//

#import "Calculadora.h"

@implementation Calculadora

CGFloat const kAnguloBordaRedonda = 30;
CGFloat const kAnguloBordaArredondada = 5;
CGFloat const kLarguraBordaCarrinho = 3;
CGFloat const kLarguraBorda = 1;
CGFloat const kAlturaTextField = 60;

#pragma mark - INICIALIZACAO

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self padronizaLayout:self];
    [self arredondaModalView:self.viewMain];
    
    // Inicia as variáveis 
    _primeiroValor = 0;
    _segundoValor = 0;
    _operacao = operacaoNenhuma;
    _ultimaAcao = acaoNenhuma;
    _primeiroValorVazio = YES;
    _lblOperacoes.text = @"";
}


#pragma mark - COMPONENTES APRESENTACAO

-(void)atualizaVisorAdiciona:(NSString*)btn{
    
    _txtVisor.text = [NSString stringWithFormat:@"%@%@", [_txtVisor.text stringByReplacingOccurrencesOfString:@"." withString:@","], btn];
}

-(void)atualizaVisorSubstitui:(NSString*)op{
    
    _txtVisor.text = [op stringByReplacingOccurrencesOfString:@"." withString:@","];
}

-(void)atualizaLabel:(NSString*)texto{
    
    switch (_ultimaAcao) {
        case acaoIgual:
            _lblOperacoes.text = [NSString stringWithFormat:@"%@%@", @"", texto];
            break;
        case acaoOperacao:{
                NSString* ultimoCaracter = [_lblOperacoes.text substringWithRange:NSMakeRange(((int)_lblOperacoes.text.length - 1), 1)];
            
                NSString *operacoes = @"+-x÷%";
                NSRange searchResult = [operacoes rangeOfString:ultimoCaracter];
            
                if (searchResult.location == NSNotFound) {
                    _lblOperacoes.text = [NSString stringWithFormat:@"%@%@", _lblOperacoes.text, texto];

                } else {
                    NSString* lblAjustado = [_lblOperacoes.text substringWithRange:NSMakeRange(0, ((int)_lblOperacoes.text.length - 1))];
                    _lblOperacoes.text = [NSString stringWithFormat:@"%@%@", lblAjustado, texto];
                }
            }
            break;
        default:
            _lblOperacoes.text = [NSString stringWithFormat:@"%@%@", _lblOperacoes.text, texto];
            break;
    }
}

-(void)ajustaApresentacao:(NSString*)simboloOperacao{
    
    if(_ultimaAcao == acaoOperacao){
        
        if(_segundoValor != 0){
            [self executaoOperacao];
        
            [self atualizaVisorSubstitui:[NSString stringWithFormat:@"%.5f", _primeiroValor]];
            [_lblOperacoes setText:[NSString stringWithFormat:@"%@%@", [[NSString stringWithFormat:@"%.5f", _primeiroValor] stringByReplacingOccurrencesOfString:@"." withString:@","], simboloOperacao]];
        }
    }
    else{
        [self atualizaLabel:simboloOperacao];
    }
    [self atualizaVisorSubstitui:simboloOperacao];
}


#pragma mark - BOTOES DE FUNCOES

- (IBAction)btnCancelarClick:(id)sender {
    
    [self dismissTransparentModalViewControllerAnimated:YES];
}

- (IBAction)btnACClick:(id)sender {
    
    _primeiroValor = 0;
    _segundoValor = 0;
    _primeiroValorVazio = YES;
    _ultimaAcao = acaoLimpar;
    [self atualizaVisorSubstitui:@"0"];
    [_lblOperacoes setText:@""];
}

- (IBAction)btnDivisaoClick:(id)sender{
    
    if ((_ultimaAcao == acaoDecimal) || (_primeiroValor == 0)){
        return;
    }

    _primeiroValorVazio = NO;
    _ultimaOperacao = operacaoDiv;
    _ultimaAcao = acaoOperacao;
    
    [self atualizaLabel:@"÷"];
    [self ajustaApresentacao:@"÷"];

    _operacao = operacaoDiv;
}

- (IBAction)btnMultiplicacaolick:(id)sender{
    
    if ((_ultimaAcao == acaoDecimal) || (_primeiroValor == 0)){
        return;
    }
    
    _primeiroValorVazio = NO;
    _ultimaOperacao = operacaoMulti;
    _ultimaAcao = acaoOperacao;
  
    [self atualizaLabel:@"x"];
    [self ajustaApresentacao:@"x"];
    
    _operacao = operacaoMulti;
}

- (IBAction)btnSubtracaoClick:(id)sender{
    
    if ((_ultimaAcao == acaoDecimal) || (_primeiroValor == 0)){
        return;
    }
    
    _primeiroValorVazio = NO;
    _ultimaOperacao = operacaoSub;
    _ultimaAcao = acaoOperacao;

    [self atualizaLabel:@"-"];
    [self ajustaApresentacao:@"-"];
    
    _operacao = operacaoSub;
}

- (IBAction)btnSomaClick:(id)sender{
    
    if ((_ultimaAcao == acaoDecimal) || (_primeiroValor == 0)){
        return;
    }
    
    _primeiroValorVazio = NO;
    _ultimaOperacao = operacaoSoma;
    _ultimaAcao = acaoOperacao;
    
    [self atualizaLabel:@"+"];
    [self ajustaApresentacao:@"+"];
    
    _operacao = operacaoSoma;
}

- (IBAction)btnPercentClick:(id)sender{
    
    if ((_ultimaAcao == acaoDecimal) || (_primeiroValor == 0)){
        return;
    }
    
    _primeiroValorVazio = NO;
    _ultimaOperacao = operacaoPercent;
    _ultimaAcao = acaoOperacao;

    [self atualizaLabel:@"%"];
    [self ajustaApresentacao:@"%"];
    
    _operacao = operacaoPercent;
}

- (IBAction)btnIgualClick:(id)sender{
    
    _ultimaAcao = acaoIgual;
    _operacao = _ultimaOperacao;
    
    [self executaoOperacao];
    [self atualizaVisorSubstitui:[NSString stringWithFormat:@"%.5f", _primeiroValor]];
    
    if(_primeiroValor == 0){
        [_lblOperacoes setText:@""];
    }else{
        [_lblOperacoes setText:[[NSString stringWithFormat:@"%.5f", _primeiroValor]stringByReplacingOccurrencesOfString:@"." withString:@","]];
    }
    
    _operacao = operacaoNenhuma;
    _primeiroValorVazio = YES;
    _primeiroValor = [_txtVisor.text stringByReplacingOccurrencesOfString:@"," withString:@"."].doubleValue;
    _segundoValor = 0;
}

#pragma mark - BOTOES NUMERICOS

- (IBAction)btnDecimalClick:(id)sender{
    
    if ((_ultimaAcao == acaoDecimal) || (_ultimaAcao == acaoOperacao)){
        return;
    }
    
    if([_txtVisor.text rangeOfString:@","].location != NSNotFound){
        return;
    }
    
    UIButton* btn=sender;
    [self atualizaVisorAdiciona:[NSString stringWithFormat:@"%@", (_primeiroValor == 0) ? @"0,": btn.titleLabel.text]];
    [self atualizaLabel:[NSString stringWithFormat:@"%@", (_primeiroValor == 0) ? @"0,": btn.titleLabel.text]];
    
    _ultimaAcao = acaoDecimal;
}

- (IBAction)btnNumClick:(id)sender{
    
    if (_ultimaAcao == acaoIgual){
        return;
    }
    
    UIButton* btn=sender;
        
    double num = [btn.titleLabel.text doubleValue];
    
    if (!_primeiroValorVazio){
        if([_txtVisor.text rangeOfString:@","].location != NSNotFound){
            int potencia = (int)_txtVisor.text.length - (int)[_txtVisor.text rangeOfString:@","].location;
            _segundoValor = _segundoValor + (num/pow(10,potencia));
        }
        else{
            _segundoValor = _segundoValor * 10 + num;
        }
    }
    else {
        if([_txtVisor.text rangeOfString:@","].location != NSNotFound){
            int potencia = (int)_txtVisor.text.length - (int)[_txtVisor.text rangeOfString:@","].location;
            _primeiroValor = _primeiroValor + (num/pow(10,potencia));
        }
        else{
            _primeiroValor = _primeiroValor * 10 + num;
        }
    }

    if (_primeiroValor == 0 || (_operacao > 0 && _segundoValor == 0) || (_ultimaAcao == acaoOperacao)) {
        [self atualizaVisorSubstitui:[@(num) stringValue]];
    }
    else{
        [self atualizaVisorAdiciona:[@(num) stringValue]];
    }
    
    _ultimaAcao = acaoNumero;
    [self atualizaLabel:[@(num) stringValue]];
}


#pragma mark - OPERACAO MATEMATICA

-(void)executaoOperacao{
    
    if((_primeiroValor != 0) && (_segundoValor !=0)){
    
        switch (_operacao) {
            case operacaoDiv:
                _primeiroValor = _primeiroValor / _segundoValor;
                break;
            case operacaoMulti:
                _primeiroValor = _primeiroValor * _segundoValor;
                break;
            case operacaoSoma:
                _primeiroValor = _primeiroValor + _segundoValor;
                break;
            case operacaoSub:
                _primeiroValor = _primeiroValor - _segundoValor;
                break;
            case operacaoPercent:
                _primeiroValor = (_primeiroValor/100) * _segundoValor;
                break;
                
            default:
                _primeiroValorVazio = YES;
                _primeiroValor = 0;
                _segundoValor = 0;
                _operacao = operacaoNenhuma;
                break;
        }
        _operacao = operacaoNenhuma;
        _segundoValor = 0;
    }
}


#pragma mark - TRANSPARENTE MODAL

-(void) presentTransparentModalViewController: (UIView *) aView
                                     animated: (BOOL) isAnimated
                                    withAlpha: (CGFloat) anAlpha
                                   controller: (UIViewController*) controller
{
    if(!_isAnimating){
        _transparentView = aView;
        UIView *view = aView;
        
        //    view.opaque = NO;
        //    view.alpha = anAlpha;
        [view setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0]];
        [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *each = obj;
            each.opaque = YES;
            each.alpha = 1.0;
        }];
        
        if (isAnimated) {
            //Animated
            CGRect mainrect = [[UIScreen mainScreen] bounds];
            CGRect newRect = CGRectMake(0, mainrect.size.height, mainrect.size.width, mainrect.size.height);
            
            
            [[controller view] addSubview:view];
            view.frame = newRect;
            
            _isAnimating = YES;
            [UIView animateWithDuration:0.5
                             animations:^{
                                 view.frame = mainrect;
                             } completion:^(BOOL finished) {
                                 //nop
                                 [UIView animateWithDuration:0.5
                                                  animations:^{
                                                      [view setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:anAlpha]];
                                                  } completion:^(BOOL finished) {
                                                      //nop
                                                      _isAnimating = NO;
                                                  }];
                             }];
            
        }else{
            view.frame = [[UIScreen mainScreen] bounds];
            [[controller view] addSubview:view];
        }
    }
}

-(void) dismissTransparentModalViewControllerAnimated:(BOOL) animated{
    
    if(!_isAnimating){
        if (animated) {
            CGRect mainrect = [[UIScreen mainScreen] bounds];
            CGRect newRect = CGRectMake(0, mainrect.size.height, mainrect.size.width, mainrect.size.height);
            _transparentView.backgroundColor = [UIColor clearColor];
            
            _isAnimating = YES;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 _transparentView.frame = newRect;
                             } completion:^(BOOL finished) {
                                 [_transparentView removeFromSuperview];
                                 //                             transparentView = nil;
                                 _isAnimating = NO;
                             }];
        }
    }
}

-(void) dismissTransparentModalViewControllerAnimated:(BOOL) animated completion:(void (^)(void))completion{
    
    if(!_isAnimating){
        if (animated) {
            CGRect mainrect = [[UIScreen mainScreen] bounds];
            CGRect newRect = CGRectMake(0, mainrect.size.height, mainrect.size.width, mainrect.size.height);
            _transparentView.backgroundColor = [UIColor clearColor];
            
            _isAnimating = YES;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 _transparentView.frame = newRect;
                             } completion:^(BOOL finished) {
                                 [_transparentView removeFromSuperview];
                                 //                             transparentView = nil;
                                 _isAnimating = NO;
                                 completion();
                             }];
        }
    }
}


#pragma mark - AJUSTA LAYOUT DA TELA

-(void)padronizaLayout:(UIView*)mainView{
    
    for (UIView* view in mainView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [self layoutButton:(UIButton*)view];
        }
        else if ([view isKindOfClass:[UITextField class]]){
            [self layoutTextField:(UITextField*)view];
        }
        else if ([view isKindOfClass:[UILabel class]]){
            [self layoutLabel:(UILabel*)view];
        }
        else if ([view isKindOfClass:[UIView class]]){
            [self padronizaLayout:view];
        }
    }
}

-(void)arredondaModalView:(UIView*)mainView{
    
    [self layoutView:mainView];
}

-(void)layoutView:(UIView*)modalView{
    
    modalView.layer.cornerRadius = kAnguloBordaArredondada;
}

-(void)layoutButton:(UIButton*)button{
    button.layer.cornerRadius = kAnguloBordaRedonda;
}

-(void)layoutLabel:(UILabel*)label{
    
}

-(void)layoutTextField:(UITextField*)textField{
    textField.layer.cornerRadius = kAnguloBordaRedonda;
    textField.layer.borderWidth = kLarguraBorda;
    textField.layer.borderColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f].CGColor;
    
    textField.frame = [self frame:textField.frame withHeight:kAlturaTextField];
}

-(CGRect)frame:(CGRect)frame withX:(CGFloat)x{
    frame.origin.x = x;
    return frame;
}

-(CGRect)frame:(CGRect)frame withY:(CGFloat)y{
    frame.origin.y = y;
    return frame;
}

-(CGRect)frame:(CGRect)frame withWidth:(CGFloat)width{
    frame.size.width = width;
    return frame;
}

-(CGRect)frame:(CGRect)frame withHeight:(CGFloat)height{
    frame.size.height = height;
    return frame;
}

@end

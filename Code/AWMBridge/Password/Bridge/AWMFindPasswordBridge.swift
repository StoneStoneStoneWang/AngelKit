//
//  AWMFindPwdBridge.swift
//  AWMBridge
//
//  Created by three stone 王 on 2019/8/26.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import AWMBase
import AWMHud
import RxCocoa
import RxSwift
import AWMCocoa

public typealias AWMFindPasswordAction = () -> ()

@objc (AWMFindPasswordBridge)
public final class AWMFindPasswordBridge: AWMBaseBridge {
    
    public var viewModel: AWMFindPasswordModel!
}
// MARK:  手机号 201  验证码 202  密码 203  完成按钮 204
extension AWMFindPasswordBridge {
    
    @objc public func createPassword(_ vc: AWMBaseViewController,passwordAction: @escaping AWMFindPasswordAction ) {
        
        if let phone = vc.view.viewWithTag(201) as? UITextField ,let vcode = vc.view.viewWithTag(202) as? UITextField ,let vcodeItem = vcode.rightView as? UIButton,let password = vc.view.viewWithTag(203) as? UITextField, let passwordItem = password.rightView
            as? UIButton ,let completeItem = vc.view.viewWithTag(204) as? UIButton {
            
            let input = AWMFindPasswordModel.WLInput(username: phone.rx.text.orEmpty.asDriver(),
                                              vcode: vcode.rx.text.orEmpty.asDriver() ,
                                              password: password.rx.text.orEmpty.asDriver(),
                                              verifyTaps: vcodeItem.rx.tap.asSignal(),
                                              completeTaps: completeItem.rx.tap.asSignal(),
                                              passwordItemTaps: passwordItem.rx.tap.asSignal())
            
            viewModel = AWMFindPasswordModel(input, disposed: disposed)
            
            // MARK: 完成点击中序列
            viewModel
                .output
                .completing
                .drive(onNext: { _ in
                    
                    vc.view.endEditing(true)
                    
                    AWMHud.show(withStatus: "找回密码中...")
                    
                })
                .disposed(by: disposed)
            
            // MARK: 完成事件返回序列
            viewModel
                .output
                .completed
                .drive(onNext: {
                    
                    AWMHud.pop()
                    
                    switch $0 {
                        
                    case let .failed(msg): AWMHud.showInfo(msg)
                        
                    case let .ok(msg):
                        
                        AWMHud.showInfo(msg)
                        
                        passwordAction()
                        
                    default: break
                    }
                })
                .disposed(by: disposed)
            // 验证码序列
            viewModel
                .output
                .verifying
                .drive(onNext: { (_) in
                    
                    vc.view.endEditing(true)
                    
                    AWMHud.show(withStatus: "获取验证码中...")
                })
                .disposed(by: disposed)
            // 验证码结果序列
            viewModel
                .output
                .smsRelay
                .asObservable()
                .bind(to: vcodeItem.rx.awmSms)
                .disposed(by: disposed)
            // 验证码结果序列
            viewModel
                .output
                .verifyed
                .drive(onNext: { [weak self] result in
                    
                    guard let `self` = self else { return }
                    
                    switch result {
                    case let .failed(message: msg):
                        AWMHud.pop()
                        AWMHud.showInfo(msg)
                    case let .ok(msg):
                        AWMHud.pop()
                        AWMHud.showInfo(msg)
                    case let .smsOk(isEnabled: isEnabled, title: title):
                        
                        self.viewModel.output.smsRelay.accept((isEnabled,title))
                    default: break
                        
                    }
                })
                .disposed(by: disposed)
            
            viewModel
                .output
                .passwordItemed
                .drive(passwordItem.rx.isSelected)
                .disposed(by: disposed)
            
            viewModel
                .output
                .passwordEntryed
                .drive(password.rx.isSecureTextEntry)
                .disposed(by: disposed)
        }
    }
}

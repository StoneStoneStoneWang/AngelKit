//
//  AWMFeedBackViewModel.swift
//  AWMBridge
//
//  Created by 王磊 on 2020/3/30.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import RxCocoa
import WLReqKit
import WLBaseViewModel
import WLToolsKit
import WLBaseResult
import AWMRReq
import AWMApi

struct AWMFeedBackViewModel: WLBaseViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let feedBack: Driver<String>
        
        let phone:Driver<String>
        
        let completTaps:Signal<Void>
    }
    
    struct WLOutput {
        
        let completeEnabled: Driver<Bool>
        
        let completing: Driver<Void>
        
        let completed: Driver<WLBaseResult>
        
        let placeholderHidden: Driver<Bool>
    }
    
    init(_ input: WLInput) {
        
        self.input = input
        
        let ou = Driver.combineLatest(input.feedBack, input.phone)
        
        let completEnabled = ou.flatMapLatest { return Driver.just($0.0 != $0.1 && !$0.1.isEmpty && !$0.1.wl_isEmpty) }
        
        let completing: Driver<Void> = input.completTaps.flatMap { Driver.just($0) }
        
        let completed: Driver<WLBaseResult> = input.completTaps
            .withLatestFrom(ou)
            .flatMapLatest({
                
                return awmVoidResp(AWMApi.feedback("yuanxingfu1314@163.com", content: $0.0))
                    .map { _ in WLBaseResult.ok("意见建议提交成功")}
                    .asDriver(onErrorRecover: { return Driver.just(WLBaseResult.failed(($0 as! WLBaseError).description.0)) }) })
        
        let placeholderHidden: Driver<Bool> = input.feedBack.flatMapLatest { Driver.just(!$0.wl_isEmpty)}
        
        self.output = WLOutput(completeEnabled: completEnabled, completing: completing, completed: completed, placeholderHidden: placeholderHidden)
    }
}

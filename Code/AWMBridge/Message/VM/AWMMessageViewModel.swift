//
//  AWMMessageViewModel.swift
//  AWMBridge
//
//  Created by 王磊 on 2020/4/13.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import WLBaseViewModel
import RxCocoa
import RxSwift
import WLReqKit
import WLBaseResult
import AWMApi
import AWMBean
import AWMRReq

struct AWMMessageViewModel: WLBaseViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let modelSelect: ControlEvent<AWMMessageBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let headerRefresh: Driver<Void>
        
    }
    
    struct WLOutput {
        
        let zip: Observable<(AWMMessageBean,IndexPath)>
        
        let collectionData: BehaviorRelay<[AWMMessageBean]> = BehaviorRelay<[AWMMessageBean]>(value: [])
        
        let endHeaderRefreshing: Driver<WLBaseResult>
    }
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        let headerRefreshData = input
            .headerRefresh
            .startWith(())
            .flatMapLatest({_ in
                return awmArrayResp(AWMApi.fetchSystemMsg(1))
                    .mapArray(type: AWMMessageBean.self)
                    .map({ return $0.count > 0 ? WLBaseResult.fetchList($0) : WLBaseResult.empty })
                    .asDriver(onErrorRecover: { return Driver.just(WLBaseResult.failed(($0 as! WLBaseError).description.0)) })
            })
        
        let endHeaderRefreshing = headerRefreshData.map { $0 }
        
        let output = WLOutput(zip: zip, endHeaderRefreshing: endHeaderRefreshing)
        
        headerRefreshData
            .drive(onNext: { (result) in
                
                switch result {
                case let .fetchList(items):
                    
                    output.collectionData.accept(items as! [AWMMessageBean])
                    
                default: break
                }
            })
            .disposed(by: disposed)
        
        self.output = output
    }
}
extension AWMMessageViewModel {
    
    static func messageRead(_ encode: String) -> Driver<WLBaseResult> {
        
        return awmVoidResp(AWMApi.readMsg(encode))
            .flatMapLatest({ return Driver.just(WLBaseResult.ok("")) })
            .asDriver(onErrorRecover: { return Driver.just(WLBaseResult.failed(($0 as! WLBaseError).description.0)) })
    }
    
    static func fetchFirstMessage() -> Driver<WLBaseResult> {
        
        return awmArrayResp(AWMApi.fetchFirstMsg)
            .mapArray(type: AWMMessageBean.self)
            .flatMapLatest({ return Driver.just(WLBaseResult.fetchList($0)) })
            .asDriver(onErrorRecover: { return Driver.just(WLBaseResult.failed(($0 as! WLBaseError).description.0)) })
    }
}

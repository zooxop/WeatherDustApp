//
//  Observable.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/13.
//

import Foundation

class Observable<T> {
    typealias Observer = (T) -> Void
    var observer: Observer?
    
    func observe(_ observer: Observer?) {
        self.observer = observer  // 전달받은 클로저 등록
        guard let value = value else { return }
        observer?(value)  // 클로저 실행
    }
    
    
    // didSet이 호출될 때 마다, 할당되어 있는 클로저를 실행시킨다.
    // -> 옵저버 역할을 수행한다.
    var value: T? {
        didSet {
            guard let value = value else { return }
            observer?(value)
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
}

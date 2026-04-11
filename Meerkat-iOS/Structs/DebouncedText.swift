//
//  DebouncedText.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 11.04.26.
//

import Foundation
import Combine

class DebouncedText: ObservableObject {
    
    @Published var debouncedText = ""
    @Published var inputText = ""
    
    init(delay: DispatchQueue.SchedulerTimeType.Stride) {
        $inputText
            .debounce(for: delay, scheduler: DispatchQueue.main)
            .assign(to: &$debouncedText)
    }
}

// Asynchronous implementation of a timer that executes a given block of code on tick

import Foundation

class BackgroundTimer {
    
    // Dispatch queue for the code execution
    private var queue : DispatchQueue!
    
    // Internal timer that will be used
    private var timer : Timer?
    
    // Interval between timer ticks
    private var intervalInSeconds : TimeInterval!
    
    // Code to be executed on timer triggers
    private var timerHandler : (() -> Void)?
    
    // Note that the init receives the time in milliseconds
    init(intervalInMilliseconds: Int, timerHandler: @escaping () -> Void) {
        self.timerHandler = timerHandler
        self.queue = DispatchQueue(label: "timer", qos: .background, attributes: .concurrent)
        
        self.intervalInSeconds = TimeInterval(intervalInMilliseconds) / 1000.0
    }
    
    // Runs the given code block on timer trigger
    @objc func timerActions() {
        self.timerHandler?()
    }
    
    // Starts the timer asynchronously
    func start() {
        self.queue.async { [weak self] in
            
            if let strongSelf = self {
                // Invalidate timer if it exists
                if strongSelf.timer != nil {
                    strongSelf.timer?.invalidate()
                    strongSelf.timer = nil
                }
                
                // Timer initialization
                strongSelf.timer = Timer(timeInterval: strongSelf.intervalInSeconds, target: strongSelf, selector: #selector(strongSelf.timerActions), userInfo: nil, repeats: true)
                RunLoop.current.add(strongSelf.timer!, forMode: .commonModes)
                RunLoop.current.run()
            }
        }
    }
    
    // Stops the timer synchronously
    func stop() {
        queue.sync { [weak self] in
            if let strongSelf = self {
                // Invalidate timer if it exists
                if strongSelf.timer != nil {
                    strongSelf.timer?.invalidate()
                    strongSelf.timer = nil
                }
            }
        }
    }
    
    deinit {
        self.stop()
    }
}

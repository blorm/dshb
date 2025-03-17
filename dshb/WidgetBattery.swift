//
// WidgetBattery.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2014-2017  beltex <https://beltex.github.io>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

struct WidgetBattery: WidgetType {

    let name = "Battery"
    let displayOrder = 4
    var title: WidgetUITitle
    var stats = [WidgetUIStat]()

    init(window: Window = Window()) {
        title = WidgetUITitle(name: name, window: window)


        stats = [
//            WidgetUIStat(name: "Temperature",      unit: .Celsius,         max: 50.0),
            WidgetUIStat(name: "System Wattage",   unit: .Watt,            max: 100.0),
            WidgetUIStat(name: "Amerage",          unit: .Milliampere,     max: 4000.0),
            WidgetUIStat(name: "Charge",           unit: .Percentage,      max: 100.0),
            WidgetUIStat(name: "Time Remaining",   unit: .None,            max: 6.0),
            WidgetUIStat(name: "Cycles",           unit: .None,            max: 500),
            WidgetUIStat(name: "Degradation",      unit: .Percentage,      max: Double(battery.designCapacity()))
        ]

//        stats[0].Cool.range  =   -Double.infinity ..< 0.3
//        stats[0].Nominal.range  = 0.3 ..< 0.65
//        stats[0].Danger.range  = 0.65 ..< 0.8
//        stats[0].Crisis.range  = 0.8  ..< 1.0
        stats[0].Nominal.range = -Double.infinity ..< 0.2
        stats[0].Cool.range    = 0.2 ..< 0.5
        stats[0].Danger.range  = 0.5 ..< 0.8
        stats[0].Crisis.range  = 0.8  ..< Double.infinity
      
        stats[1].Cool.range    =  -Double.infinity ..< 0
        stats[1].Nominal.range  = 0 ..< 0.5
        stats[1].Danger.range =  0.5 ..< 0.8
        stats[1].Crisis.range =  0.8 ..< 1.0
      
        stats[2].Nominal.range = 0.20 ..< 1.00
        stats[2].Danger.range  = 0.07 ..< 0.20
        stats[2].Crisis.range  = 0.00 ..< 0.07
      
        stats[3].Nominal.range = 0.30 ..< 1.00
        stats[3].Danger.range  = 0.15 ..< 0.30
        stats[3].Crisis.range  = 0.01 ..< 0.15
      
        stats[5].Nominal.color = WidgetUIColor.warningLevelCrisis
        stats[5].Crisis.color = WidgetUIColor.warningLevelNominal
      
    }
    
    mutating func draw() {
      
        do {
//          let temperature = try SMCKit.temperature(TemperatureSensors.BATTERY.code)
            let system_wattage = try SMCKit.get_system_wattage()
          stats[0].draw(String(system_wattage), percentage: Double(system_wattage) / stats[0].maxValue)
        } catch {
            stats[0].draw("\(error)", percentage: 0)
        }
      
        let amperage = battery.amperage()
        if amperage < 0 {
          stats[1].maxValue = 1500
          stats[1].draw(String(amperage), percentage: min(1.0, -amperage / stats[1].maxValue))
        } else {
          stats[1].maxValue = 4000
          stats[1].draw(String(amperage), percentage: min(1.0, amperage / stats[1].maxValue))
        }
      
        let charge = battery.charge()
        stats[2].draw(String(charge), percentage: charge / 100.0)
      
        stats[3].draw(battery.timeRemainingFormatted(),
                      percentage: min(1.0, Double(battery.timeRemaining()) / 60.0 / stats[3].maxValue))

        let cycleCount  = battery.cycleCount()
        stats[4].draw(String(cycleCount),
                      percentage: Double(cycleCount) / stats[4].maxValue)

        let maxCapactiy = battery.maxCapactiy()
        stats[5].draw(String(format: "%.2f", Double(maxCapactiy) / stats[5].maxValue * 100.0),
                      percentage: Double(maxCapactiy) / stats[5].maxValue)
      
      
    }
}

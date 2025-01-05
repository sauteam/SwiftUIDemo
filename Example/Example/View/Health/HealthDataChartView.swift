//
//  HealthDataChartView.swift
//  Example
//
//  Created by scy on 2025/1/5.
//

import SwiftUI
import HealthKit
import Charts

// MARK: - 健康数据管理器
class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    @Published var steps: [HKQuantitySample] = []
    @Published var heartRates: [HKQuantitySample] = []
    @Published var sleepData: [HKCategorySample] = []
    @Published var oxygenData: [HKQuantitySample] = []
    
    // 需要读取的数据类型
    let typesToRead: Set<HKSampleType> = [
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
        HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
    ]
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if success {
                print("HealthKit 授权成功")
                self.fetchAllData()
            } else {
                print("HealthKit 授权失败: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    func fetchAllData() {
        fetchSteps()
        fetchHeartRate()
        fetchSleep()
        fetchOxygenSaturation()
    }
    
    // 获取步数数据
    func fetchSteps() {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now)
        
        let query = HKSampleQuery(sampleType: stepsType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKQuantitySample] else { return }
            
            DispatchQueue.main.async {
                self.steps = samples
            }
        }
        
        healthStore.execute(query)
    }
    
    // 获取心率数据
    func fetchHeartRate() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now)
        
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKQuantitySample] else { return }
            
            DispatchQueue.main.async {
                self.heartRates = samples
            }
        }
        
        healthStore.execute(query)
    }
    
    // 获取睡眠数据
    func fetchSleep() {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }
        
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKCategorySample] else { return }
            
            DispatchQueue.main.async {
                self.sleepData = samples
            }
        }
        
        healthStore.execute(query)
    }
    
    // 获取血氧数据
    func fetchOxygenSaturation() {
        guard let oxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else { return }
        
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now)
        
        let query = HKSampleQuery(sampleType: oxygenType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKQuantitySample] else { return }
            
            DispatchQueue.main.async {
                self.oxygenData = samples
            }
        }
        
        healthStore.execute(query)
    }
}

// MARK: - 图表视图
struct HealthDataChartView: View {
    @StateObject private var healthKit = HealthKitManager()
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            Picker("数据类型", selection: $selectedTab) {
                Text("步数").tag(0)
                Text("心率").tag(1)
                Text("睡眠").tag(2)
                Text("血氧").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TabView(selection: $selectedTab) {
                StepsChartView(steps: healthKit.steps)
                    .tag(0)
                
                HeartRateChartView(heartRates: healthKit.heartRates)
                    .tag(1)
                
                SleepChartView(sleepData: healthKit.sleepData)
                    .tag(2)
                
                OxygenChartView(oxygenData: healthKit.oxygenData)
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

// MARK: - 步数图表
struct StepsChartView: View {
    let steps: [HKQuantitySample]
    
    var body: some View {
        VStack {
            Text("每日步数")
                .font(.headline)
            
            Chart {
                ForEach(groupedSteps, id: \.date) { data in
                    BarMark(
                        x: .value("日期", data.date, unit: .day),
                        y: .value("步数", data.steps)
                    )
                }
            }
            .frame(height: 200)
            .padding()
            
            // 统计信息
            HStack {
                StatView(title: "日均步数", value: String(format: "%.0f", averageSteps))
                StatView(title: "总步数", value: String(totalSteps))
            }
        }
    }
    
    // 数据处理
    private var groupedSteps: [(date: Date, steps: Double)] {
        let calendar = Calendar.current
        var result: [Date: Double] = [:]
        
        for sample in steps {
            let date = calendar.startOfDay(for: sample.startDate)
            let steps = sample.quantity.doubleValue(for: .count())
            result[date, default: 0] += steps
        }
        
        // 将排序后的字典转换为元组数组
       return result.sorted(by: { $0.key < $1.key })
                .map { (date: $0.key, steps: $0.value) }
        
//        return result.map { (date: $0.key, steps: $0.value) }
//            .sorted { $0.date < $1.date }
    }
    
    private var averageSteps: Double {
        let total = groupedSteps.reduce(0) { $0 + $1.steps }
        return total / Double(max(1, groupedSteps.count))
    }
    
    private var totalSteps: Int {
        Int(groupedSteps.reduce(0) { $0 + $1.steps })
    }
}

// MARK: - 心率图表
struct HeartRateChartView: View {
    let heartRates: [HKQuantitySample]
    
    var body: some View {
        VStack {
            Text("心率变化")
                .font(.headline)
            
            Chart {
                ForEach(groupedHeartRates, id: \.date) { data in
                    LineMark(
                        x: .value("时间", data.date),
                        y: .value("心率", data.rate)
                    )
                }
            }
            .frame(height: 200)
            .padding()
            
            HStack {
                StatView(title: "平均心率", value: String(format: "%.0f", averageHeartRate))
                StatView(title: "最高心率", value: String(format: "%.0f", maxHeartRate))
                StatView(title: "最低心率", value: String(format: "%.0f", minHeartRate))
            }
        }
    }
    
    private var groupedHeartRates: [(date: Date, rate: Double)] {
        heartRates.map { sample in
            (date: sample.startDate,
             rate: sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute())))
        }.sorted { $0.date < $1.date }
    }
    
    private var averageHeartRate: Double {
        let rates = groupedHeartRates.map { $0.rate }
        return rates.reduce(0, +) / Double(max(1, rates.count))
    }
    
    private var maxHeartRate: Double {
        groupedHeartRates.map { $0.rate }.max() ?? 0
    }
    
    private var minHeartRate: Double {
        groupedHeartRates.map { $0.rate }.min() ?? 0
    }
}

// MARK: - 睡眠图表
struct SleepChartView: View {
    let sleepData: [HKCategorySample]
    
    var body: some View {
        VStack {
            Text("睡眠分析")
                .font(.headline)
            
            Chart {
                ForEach(groupedSleepData, id: \.date) { data in
                    BarMark(
                        x: .value("日期", data.date, unit: .day),
                        y: .value("小时", data.hours)
                    )
                }
            }
            .frame(height: 200)
            .padding()
            
            HStack {
                StatView(title: "平均睡眠", value: String(format: "%.1f小时", averageSleepHours))
                StatView(title: "最长睡眠", value: String(format: "%.1f小时", maxSleepHours))
            }
        }
    }
    
    private var groupedSleepData: [(date: Date, hours: Double)] {
        let calendar = Calendar.current
        var result: [Date: TimeInterval] = [:]
        
        for sample in sleepData where sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
            let date = calendar.startOfDay(for: sample.startDate)
            let duration = sample.endDate.timeIntervalSince(sample.startDate)
            result[date, default: 0] += duration
        }
        
        return result.map { (date: $0.key, hours: $0.value / 3600) }
            .sorted { $0.date < $1.date }
    }
    
    private var averageSleepHours: Double {
        let total = groupedSleepData.reduce(0) { $0 + $1.hours }
        return total / Double(max(1, groupedSleepData.count))
    }
    
    private var maxSleepHours: Double {
        groupedSleepData.map { $0.hours }.max() ?? 0
    }
}

// MARK: - 血氧图表
struct OxygenChartView: View {
    let oxygenData: [HKQuantitySample]
    
    var body: some View {
        VStack {
            Text("血氧饱和度")
                .font(.headline)
            
            Chart {
                ForEach(groupedOxygenData, id: \.date) { data in
                    LineMark(
                        x: .value("时间", data.date),
                        y: .value("血氧", data.percentage)
                    )
                }
            }
            .frame(height: 200)
            .padding()
            
            HStack {
                StatView(title: "平均血氧", value: String(format: "%.1f%%", averageOxygen * 100))
                StatView(title: "最低血氧", value: String(format: "%.1f%%", minOxygen * 100))
            }
        }
    }
    
    private var groupedOxygenData: [(date: Date, percentage: Double)] {
        oxygenData.map { sample in
            (date: sample.startDate,
             percentage: sample.quantity.doubleValue(for: .percent()))
        }.sorted { $0.date < $1.date }
    }
    
    private var averageOxygen: Double {
        let values = groupedOxygenData.map { $0.percentage }
        return values.reduce(0, +) / Double(max(1, values.count))
    }
    
    private var minOxygen: Double {
        groupedOxygenData.map { $0.percentage }.min() ?? 0
    }
}

// MARK: - 统计视图组件
struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

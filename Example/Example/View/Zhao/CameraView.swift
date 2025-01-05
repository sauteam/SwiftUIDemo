//
//  CameraView.swift
//  Example
//
//  Created by scy on 2025/1/4.
//

import SwiftUI
import AVFoundation
import Photos

struct CameraView: View {
    @StateObject private var camera = CameraModel()
    @State private var showingImagePicker = false
    @State private var capturedImage: UIImage?
    @State private var brightness: Double = 0.5
    @State private var isFlashOn = false
    
    var body: some View {
        ZStack {
            // 相机预览层
            CameraPreviewView(camera: camera)
                .edgesIgnoringSafeArea(.all)
            
            // 屏幕补光层
            if isFlashOn {
                Color.white
                    .opacity(brightness)
                    .edgesIgnoringSafeArea(.all)
            }
            
            // 控制界面
            VStack {
                Spacer()
                
                // 补光控制
                HStack {
                    Image(systemName: "sun.min")
                    Slider(value: $brightness, in: 0...1)
                        .accentColor(.white)
                    Image(systemName: "sun.max")
                }
                .padding()
                .background(Color.black.opacity(0.6))
                .cornerRadius(10)
                .padding()
                
                // 底部控制栏
                HStack(spacing: 60) {
                    // 补光开关
                    Button(action: {
                        isFlashOn.toggle()
                    }) {
                        Image(systemName: isFlashOn ? "bolt.fill" : "bolt.slash")
                            .font(.system(size: 24))
                            .foregroundColor(isFlashOn ? .yellow : .white)
                            .frame(width: 50, height: 50)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    
                    // 拍照按钮
                    Button(action: {
                        camera.capturePhoto()
                    }) {
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 3)
                            .frame(width: 80, height: 80)
                            .background(Circle().fill(Color.white))
                    }
                    
                    // 切换相机
                    Button(action: {
                        camera.switchCamera()
                    }) {
                        Image(systemName: "camera.rotate")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .alert(isPresented: $camera.showAlert) {
            Alert(
                title: Text("错误"),
                message: Text(camera.alertError?.message ?? ""),
                dismissButton: .default(Text("确定"))
            )
        }
        .sheet(isPresented: $camera.showCapturedImage) {
            if let image = camera.capturedImage {
                CapturedImageView(image: image, isPresented: $camera.showCapturedImage)
            }
        }
    }
}

// 相机预览视图
struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

// 拍摄照片预览视图
struct CapturedImageView: View {
    let image: UIImage
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                HStack(spacing: 40) {
                    Button(action: {
                        savePhoto()
                    }) {
                        Text("保存")
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("重拍")
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 20)
            }
            .navigationTitle("预览")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func savePhoto() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, error in
                    if success {
                        print("照片保存成功")
                    } else {
                        print("照片保存失败: \(error?.localizedDescription ?? "")")
                    }
                }
            }
        }
    }
}

// 相机模型
class CameraModel: NSObject, ObservableObject {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var capturedImage: UIImage?
    @Published var showCapturedImage = false
    @Published var showAlert = false
    @Published var alertError: AlertError?
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    override init() {
        super.init()
        checkPermissions()
        setupCamera()
    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                if !status {
                    self.alertError = AlertError(message: "需要相机权限才能拍照")
                    self.showAlert = true
                }
            }
        default:
            alertError = AlertError(message: "需要相机权限才能拍照")
            showAlert = true
        }
    }
    
    func setupCamera() {
        do {
            session.beginConfiguration()
            
            // 设置输入
            let devices = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .unspecified
            ).devices
            
            for device in devices {
                if device.position == .back {
                    backCamera = device
                } else if device.position == .front {
                    frontCamera = device
                }
            }
            
            currentCamera = backCamera
            
            guard let currentCamera = currentCamera else {
                alertError = AlertError(message: "无法访问相机")
                showAlert = true
                return
            }
            
            let input = try AVCaptureDeviceInput(device: currentCamera)
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            session.commitConfiguration()
            
        } catch {
            alertError = AlertError(message: "无法设置相机: \(error.localizedDescription)")
            showAlert = true
        }
    }
    
    func switchCamera() {
        session.beginConfiguration()
        
        // 移除当前输入
        for input in session.inputs {
            session.removeInput(input)
        }
        
        // 切换相机
        if currentCamera?.position == .back {
            currentCamera = frontCamera
        } else {
            currentCamera = backCamera
        }
        
        // 添加新输入
        guard let newCamera = currentCamera else { return }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: newCamera)
            if session.canAddInput(newInput) {
                session.addInput(newInput)
            }
        } catch {
            alertError = AlertError(message: "切换相机失败")
            showAlert = true
        }
        
        session.commitConfiguration()
    }
    
    func capturePhoto() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }
}

extension CameraModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            alertError = AlertError(message: "拍照失败: \(error.localizedDescription)")
            showAlert = true
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            alertError = AlertError(message: "照片数据无效")
            showAlert = true
            return
        }
        
        guard let image = UIImage(data: imageData) else {
            alertError = AlertError(message: "无法创建图片")
            showAlert = true
            return
        }
        
        DispatchQueue.main.async {
            self.capturedImage = image
            self.showCapturedImage = true
        }
    }
}

struct AlertError {
    let message: String
}

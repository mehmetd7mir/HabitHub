# 🎯 HabitHub - iOS Alışkanlık Takip Uygulaması

<div align="center">
  <img src="https://img.shields.io/badge/iOS-26.0+-blue.svg" alt="iOS Version">
  <img src="https://img.shields.io/badge/Swift-5.0+-orange.svg" alt="Swift Version">
  <img src="https://img.shields.io/badge/SwiftUI-4.0+-green.svg" alt="SwiftUI Version">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
</div>

<div align="center">
  <h3>🚀 Modern iOS Alışkanlık Takip Uygulaması</h3>
  <p>SwiftUI ve Core Data ile geliştirilmiş, kullanıcı dostu alışkanlık yönetim uygulaması</p>
</div>

---

## 📱 Uygulama Önizlemesi

<div align="center">
  <img src="https://via.placeholder.com/300x600/007AFF/FFFFFF?text=HabitHub+App" alt="HabitHub App Preview" width="200">
  <img src="https://via.placeholder.com/300x600/34C759/FFFFFF?text=Today+View" alt="Today View" width="200">
  <img src="https://via.placeholder.com/300x600/FF9500/FFFFFF?text=Statistics" alt="Statistics" width="200">
</div>

---

## ✨ Özellikler

### 🎯 **Temel Özellikler**
- ✅ **Alışkanlık Yönetimi**: Kolay ekleme, düzenleme ve silme
- 📅 **Günlük Takip**: Her gün alışkanlıklarınızı işaretleyin
- 🔥 **Streak Takibi**: Kesintisiz gün sayısını takip edin
- 📊 **Detaylı İstatistikler**: İlerleme raporları ve analizler
- 🔍 **Arama ve Filtreleme**: Alışkanlıklarınızı kolayca bulun

### 🚀 **Gelişmiş Özellikler**
- 🗄️ **Core Data**: Güvenli yerel veri saklama
- 🌍 **Çoklu Dil Desteği**: Türkçe ve İngilizce
- 📤 **Veri Dışa Aktarma**: CSV ve JSON formatında
- 💾 **Yedekleme Sistemi**: Verilerinizi güvenle saklayın
- 🎨 **Modern UI**: SwiftUI ile tasarlanmış
- 📱 **Haptic Feedback**: Dokunsal geri bildirim
- 🔔 **Hatırlatıcılar**: Özelleştirilebilir bildirimler

### 🆕 **Yeni Özellikler**
- 🏷️ **Kategori Sistemi**: Alışkanlıkları kategorilere ayırın
- 🎨 **Renk Özelleştirme**: Her alışkanlık için özel renk
- 🔤 **İkon Seçimi**: 100+ özel ikon
- 📝 **Notlar**: Alışkanlık açıklamaları
- ⏰ **Hatırlatıcı Zamanı**: Özelleştirilebilir bildirim zamanları
- 📋 **Şablonlar**: Hazır alışkanlık şablonları

---

## 🛠️ Teknik Detaylar

### **Kullanılan Teknolojiler**
- **SwiftUI**: Modern UI framework
- **Core Data**: Veri yönetimi ve kalıcılık
- **MVVM Architecture**: Temiz kod yapısı
- **Combine**: Reaktif programlama
- **Localization**: Çoklu dil desteği
- **UserNotifications**: Bildirim sistemi

### **Mimari Yapı**
```
HabitHub/
├── 📱 Views/                 # UI Bileşenleri
│   ├── 🧩 Components/        # Yeniden kullanılabilir bileşenler
│   ├── ➕ AddHabitView.swift
│   ├── 📋 HabitListView.swift
│   ├── 📅 TodayView.swift
│   ├── 📊 StatsView.swift
│   └── ⚙️ SettingsView.swift
├── 🧠 ViewModels/            # İş mantığı
│   ├── 📝 HabitViewModel.swift
│   └── 📊 HabitLogViewModel.swift
├── 🗄️ Models/                # Veri modelleri
│   ├── 🎯 Habit+CoreDataClass.swift
│   └── 📋 HabitLog+CoreDataProperties.swift
├── 🔧 Utils/                 # Yardımcı sınıflar
│   ├── 🔥 StreakCalculator.swift
│   ├── 📤 DataExporter.swift
│   ├── 🌍 LocalizationHelper.swift
│   └── 📳 Haptics.swift
└── 🌐 Resources/             # Lokalizasyon dosyaları
    ├── 🇹🇷 tr.lproj/
    └── 🇺🇸 en.lproj/
```

---

## 📊 Veri Modeli

### **Habit Entity**
```swift
- id: UUID (Benzersiz kimlik)
- name: String (Alışkanlık adı)
- targetDays: Int32 (Hedef gün sayısı)
- isActive: Bool (Aktif durumu)
- createdDate: Date (Oluşturulma tarihi)
- category: String (Kategori)
- iconName: String (İkon adı)
- colorHex: String (Renk kodu)
- notes: String (Notlar)
- frequency: String (Sıklık)
- reminderTime: Date (Hatırlatıcı zamanı)
```

### **HabitLog Entity**
```swift
- id: UUID (Benzersiz kimlik)
- date: Date (Tarih)
- isCompleted: Bool (Tamamlanma durumu)
- notes: String (Günlük notlar)
- habit: Habit (İlişkili alışkanlık)
```

---

## 🎨 UI/UX Özellikleri

### **Tasarım Prensipleri**
- 🎯 **Sade ve Temiz**: Karmaşık animasyonlar yok
- 👥 **Kullanıcı Dostu**: Sezgisel navigasyon
- ♿ **Erişilebilir**: Tüm kullanıcılar için uygun
- 📱 **Responsive**: Tüm cihaz boyutlarında çalışır

### **Renk Paleti**
- 🔵 **Accent Color**: Sistem mavisi
- 🟢 **Success**: Yeşil (tamamlanan alışkanlıklar)
- 🟠 **Warning**: Turuncu (dikkat gerektiren durumlar)
- 🔴 **Error**: Kırmızı (hata durumları)

---

## 🔧 Kurulum

### **Gereksinimler**
- 📱 iOS 15.0+
- 💻 Xcode 14.0+
- 🚀 Swift 5.0+

### **Adımlar**
1. **Projeyi klonlayın**
   ```bash
   git clone https://github.com/mehmetd7mir/HabitHub.git
   cd HabitHub
   ```

2. **Xcode'da açın**
   ```bash
   open HabitHub.xcodeproj
   ```

3. **Simulator veya cihazda çalıştırın**
   - ⌘ + R tuşlarına basın

---

## 📱 Kullanım

### **Alışkanlık Ekleme**
1. Ana ekranda **"+"** butonuna tıklayın
2. Alışkanlık adını girin
3. Kategori, ikon ve renk seçin
4. Hedef gün sayısını belirleyin
5. Hatırlatıcı zamanı ayarlayın
6. **"Kaydet"** butonuna tıklayın

### **Günlük Takip**
1. **"Bugün"** sekmesine gidin
2. Tamamladığınız alışkanlıkları işaretleyin
3. İlerlemenizi takip edin

### **İstatistikler**
1. **"İstatistikler"** sekmesine gidin
2. Genel ilerlemenizi görün
3. Haftalık performansınızı analiz edin

---

## 🌍 Lokalizasyon

Uygulama şu dilleri destekler:
- 🇹🇷 **Türkçe** (Varsayılan)
- 🇺🇸 **İngilizce**

---

## 📤 Veri Dışa Aktarma

### **Desteklenen Formatlar**
- 📊 **CSV**: Excel ile uyumlu
- 📄 **JSON**: Programatik erişim

### **Kullanım**
1. **"Ayarlar"** sekmesine gidin
2. **"Verileri Dışa Aktar"** seçeneğini seçin
3. İstediğiniz formatı seçin
4. Paylaşın veya kaydedin

---

## 🚀 Gelecek Özellikler

- [ ] 📱 Widget desteği
- [ ] 🔔 Push bildirimleri
- [ ] ☁️ iCloud senkronizasyonu
- [ ] ⌚ Apple Watch uygulaması
- [ ] 👥 Sosyal özellikler
- [ ] 🎯 Hedef belirleme sistemi
- [ ] 📈 Gelişmiş analitikler
- [ ] 🏆 Başarı rozetleri

---

## 👨‍💻 Geliştirici

<div align="center">
  <img src="https://via.placeholder.com/150x150/007AFF/FFFFFF?text=MD" alt="Mehmet Demir" width="100">
  
  **Mehmet Demir**
  
  🎯 Savunma sanayii alanına geçiş için geliştirilmiş
  
  💻 SwiftUI ve Core Data uzmanlığı
  
  🚀 Modern iOS geliştirme pratikleri
</div>

---

## 📄 Lisans

Bu proje kişisel kullanım için geliştirilmiştir.

---

## 🤝 Katkıda Bulunma

Bu proje kişisel bir portfolyo projesidir. Katkılarınız için teşekkürler!

### **Katkıda Bulunma Adımları**
1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Commit yapın (`git commit -m 'Add some AmazingFeature'`)
4. Push yapın (`git push origin feature/AmazingFeature`)
5. Pull Request açın

---

## 📞 İletişim

- 📧 **Email**: [mehmetd7mir@gmail.com](mailto:mehmetd7mir@gmail.com)
- 💼 **LinkedIn**: [Mehmet Demir](https://linkedin.com/in/mehmetd7mir)
- 🐙 **GitHub**: [@mehmetd7mir](https://github.com/mehmetd7mir)

---

<div align="center">
  <p>⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın!</p>
  <p>🚀 <strong>HabitHub ile alışkanlıklarınızı takip edin, hedeflerinize ulaşın!</strong></p>
</div>

---

**Not**: Bu uygulama savunma sanayii alanına geçiş yapmak için geliştirilmiş bir portfolyo projesidir. Tüm özellikler tamamen yerel olarak çalışır ve internet bağlantısı gerektirmez.
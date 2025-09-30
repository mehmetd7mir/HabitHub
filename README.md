# HabitHub - Alışkanlık Takip Uygulaması

HabitHub, günlük alışkanlıklarınızı takip etmenizi ve hedeflerinize ulaşmanızı sağlayan modern bir iOS uygulamasıdır.

## 🚀 Özellikler

### 📱 Temel Özellikler
- **Alışkanlık Yönetimi**: Alışkanlık ekleme, düzenleme ve silme
- **Günlük Takip**: Her gün alışkanlıklarınızı işaretleyin
- **Streak Takibi**: Kesintisiz gün sayısını takip edin
- **İstatistikler**: Detaylı ilerleme raporları
- **Arama ve Filtreleme**: Alışkanlıklarınızı kolayca bulun

### 🎯 Gelişmiş Özellikler
- **Core Data**: Yerel veri saklama
- **Çoklu Dil Desteği**: Türkçe ve İngilizce
- **Veri Dışa Aktarma**: CSV ve JSON formatında
- **Yedekleme**: Verilerinizi güvenle saklayın
- **Modern UI**: SwiftUI ile tasarlanmış

## 🛠️ Teknik Detaylar

### Kullanılan Teknolojiler
- **SwiftUI**: Modern UI framework
- **Core Data**: Veri yönetimi
- **MVVM Architecture**: Temiz kod yapısı
- **Localization**: Çoklu dil desteği

### Proje Yapısı
```
HabitHub/
├── Views/                 # UI Bileşenleri
│   ├── Components/        # Yeniden kullanılabilir bileşenler
│   ├── AddHabitView.swift
│   ├── HabitListView.swift
│   ├── TodayView.swift
│   ├── StatsView.swift
│   └── SettingsView.swift
├── ViewModels/            # İş mantığı
│   ├── HabitViewModel.swift
│   └── HabitLogViewModel.swift
├── Utils/                 # Yardımcı sınıflar
│   ├── StreakCalculator.swift
│   ├── DataExporter.swift
│   └── LocalizationHelper.swift
├── Resources/             # Lokalizasyon dosyaları
│   ├── tr.lproj/
│   └── en.lproj/
└── DataModel.xcdatamodeld # Core Data modeli
```

## 📊 Veri Modeli

### Habit Entity
- `id`: UUID (Benzersiz kimlik)
- `name`: String (Alışkanlık adı)
- `targetDays`: Int32 (Hedef gün sayısı)
- `isActive`: Bool (Aktif durumu)
- `createdDate`: Date (Oluşturulma tarihi)

### HabitLog Entity
- `id`: UUID (Benzersiz kimlik)
- `date`: Date (Tarih)
- `isCompleted`: Bool (Tamamlanma durumu)
- `habit`: Habit (İlişkili alışkanlık)

## 🎨 UI/UX Özellikleri

### Tasarım Prensipleri
- **Sade ve Temiz**: Karmaşık animasyonlar yok
- **Kullanıcı Dostu**: Sezgisel navigasyon
- **Erişilebilir**: Tüm kullanıcılar için uygun
- **Responsive**: Tüm cihaz boyutlarında çalışır

### Renk Paleti
- **Accent Color**: Sistem mavisi
- **Success**: Yeşil (tamamlanan alışkanlıklar)
- **Warning**: Turuncu (dikkat gerektiren durumlar)
- **Error**: Kırmızı (hata durumları)

## 🔧 Kurulum

### Gereksinimler
- iOS 15.0+
- Xcode 14.0+
- Swift 5.0+

### Adımlar
1. Projeyi klonlayın
2. Xcode'da açın
3. Simulator veya cihazda çalıştırın

## 📱 Kullanım

### Alışkanlık Ekleme
1. Ana ekranda "+" butonuna tıklayın
2. Alışkanlık adını girin
3. Hedef gün sayısını belirleyin
4. "Kaydet" butonuna tıklayın

### Günlük Takip
1. "Bugün" sekmesine gidin
2. Tamamladığınız alışkanlıkları işaretleyin
3. İlerlemenizi takip edin

### İstatistikler
1. "İstatistikler" sekmesine gidin
2. Genel ilerlemenizi görün
3. Haftalık performansınızı analiz edin

## 🌍 Lokalizasyon

Uygulama şu dilleri destekler:
- 🇹🇷 Türkçe (Varsayılan)
- 🇺🇸 İngilizce

## 📤 Veri Dışa Aktarma

### Desteklenen Formatlar
- **CSV**: Excel ile uyumlu
- **JSON**: Programatik erişim

### Kullanım
1. "Ayarlar" sekmesine gidin
2. "Verileri Dışa Aktar" seçeneğini seçin
3. İstediğiniz formatı seçin
4. Paylaşın veya kaydedin

## 🚀 Gelecek Özellikler

- [ ] Widget desteği
- [ ] Push bildirimleri
- [ ] iCloud senkronizasyonu
- [ ] Apple Watch uygulaması
- [ ] Sosyal özellikler

## 👨‍💻 Geliştirici

**Mehmet Demir**
- Savunma sanayii alanına geçiş yapmak için geliştirilmiş
- SwiftUI ve Core Data uzmanlığı
- Modern iOS geliştirme pratikleri

## 📄 Lisans

Bu proje kişisel kullanım için geliştirilmiştir.

## 🤝 Katkıda Bulunma

Bu proje kişisel bir portfolyo projesidir. Katkılarınız için teşekkürler!

---

**Not**: Bu uygulama savunma sanayii alanına geçiş yapmak için geliştirilmiş bir portfolyo projesidir. Tüm özellikler tamamen yerel olarak çalışır ve internet bağlantısı gerektirmez.

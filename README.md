# ÜNOG Bot

## Kurulum

### Onaylama Mesajını Atma

Onaylama mesajını `/onaylanma_mesajını_at` komutuyla atabilirsiniz. Bu komut, kullanıldığı kanala onaylanma mesajını atar. Onaylama mesajı onaylanma formunu açan butonun olduğu mesajdır.

> Bu komutu sadece _Sunucuyu Yönet_ izni olan kişiler görür ve kullanabilir.

### Kullanıcıyı Onaylama

Kullanıcı formu doldurduğunda bot:
- Ayarlanan kanala bir mesaj atar. Bu mesajda kullanıcının formda yazdıkları ve _Onayla_ butonu bulunur.
- Sheet'e kullanıcı bilgilerini ve formda yazdıklarını ekler.

_Onayla_ tuşuna basıldığında bot:
- Kullanıcının ismini formdaki isim soyisme ayarlar.
    - Aynı zamanda isim ve soyismin ilk harflerini büyük harf yapar.
- Belirlenmiş onaylanmadı rolünü kullanıcıdan alır.
- Sheet'teki doğrulanma durumunu günceller.

> Onaylandı rolünün verilebilmesi için bot'un rolünün onaylanmadı rolünün ve onaylanacak kullanıcının rollerinin üzerinde olması gerekir. 

### Sheets Kullanımı

Kullanıcı formu doldurduğunda bot sheet'e kullanıcının ID'sini ve formdaki bilgileri içeren bir satır ekler. Bu satırda _Onaylanma Durumu_, _Onaylanmadı_ diye ayarlanır.

Kullanıcı onaylandığında bot bu satırdaki _Onaylanma Durumu_ sütununu _Onaylandı_ olarak ayarlanır.

## Hostlama

> Bu bilgiler botu sunucusunda hostlayan kişi için gerekli.

### Environment Variable'ları

> `.env` dosyası kullanılabilir.

- `TOKEN`: Bot'un Discord Developer Portal'dan alınan token'ı
- `GUILD_ID`: Komutların oluşturulacağı sunucunun ID'si
- `VERIFICATION_SUBMISSIONS_CHANNEL_ID`: Kullanıcılar onaylama formunu attığında, formun ve dogrulama butonlarının olduğu mesajın atılacağı kanalın ID'si, bu kanal sadece onaylama yetkisi olanların görebildiği bir kanal olmalı.
- `UNVERIFIED_ROLE_ID`: Kullanıcılar onaylandığında onlardan alınacak rolün ID'si

Bu bilgileri [Lara](https://lara.lv)'ya sorun:
- `LOGGING_WEBHOOK_URL`: Bot'un error'ları vs. için kullanılacak webhook'un linki
- `SPREADSHEET_ID`: Onaylanma bilgilerinin kaydedileceği Google Sheet'in ID'si
- `GOOGLE_SERVICE_ACCOUNT_EMAIL`: Google Sheets için kullanılacak olan servis hesabının e-postası

### Gereken diğer dosyalar

- `GoogleServiceAccountPrivateKey.key`: Google Servis Hesabının gizli anahtarı

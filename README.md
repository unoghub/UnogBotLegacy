# ÜNOG Bot

ÜNOG Discord sunucusunda kullanılan Discord botu

Şu anda sadece kullanıcıların onaylanmasını sağlar.

## Onaylama

Kullanıcı formu doldurduğunda bot:
- Ayarlanan kanala bir mesaj atar. Bu mesajda kullanıcının formda yazdıkları ve _Onayla_ butonu bulunur.
- Sheet'e kullanıcının Discord ID'sini ve formda yazdıklarını ekler.

_Onayla_ butonuna basıldığında bot:
- Kullanıcının ismini formdaki isim soyisme ayarlar.
    - Aynı zamanda isim ve soyismin ilk harflerini büyük harf yapar.
- Belirlenmiş onaylanmadı rolünü kullanıcıdan alır.
- Sheet'teki onaylanma durumunu günceller.

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

### Dosyalar

- `GoogleServiceAccountPrivateKey.key`: Google Sheets için kullanılacak olan servis hesabının gizli anahtarı

### Bot'u Davet Etmek

#### Scope'lar

- bot
- applications.commands

#### İzinler

##### Genel

- Manage Roles
- Manage Nicknames

##### Kanallara Özel

- `/onaylanma_mesajını_at` komutunun kullanıldığı kanalda:
    - Send Messages
- `VERIFICATION_SUBMISSIONS_CHANNEL_ID`:
    - Send Messages

#### Davet Linki

> Bu link, bot'un scope'larını ve izinlerini de belirtir.

`https://discord.com/api/oauth2/authorize?client_id={CLIENT_ID}&permissions=402655232&scope=applications.commands+bot`

> `{CLIENT_ID}`'yi bot'un application ID'si ile değiştirin.

#### Ekledikten Sonra Yapılacaklar

##### Bot'un Rolünün Konumu

Onaylanmadı rolünün alınabilmesi için bot'un rolünü, onaylanmadı rolünün ve onaylanacak kullanıcının rollerinin üstüne yerleştirin.

##### Onaylanma Mesajının Atılması

Onaylama mesajını, `/onaylanma_mesajını_at` komutuyla atın. Bu komut, kullanıldığı kanala onaylanma mesajını atar. Onaylama mesajı onaylanma formunu açan butonun olduğu mesajdır.

> Bu komutu sadece _Sunucuyu Yönet_ izni olan kişiler görür ve kullanabilir.

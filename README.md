# Eski Repo

Bu repo bot'un eski kodunu içerir. Güncel versiyonu [UnogBot repo'sunda](https://github.com/unoghub/UnogBot) bulabilirsiniz.

# ÜNOG Bot

ÜNOG Discord sunucusunda kullanılan Discord botu

Şu anda sadece kullanıcıların doğrulanmasını sağlar.

## Doğrulanma

Kullanıcı formu doldurduğunda bot:
- Ayarlanan kanala bir mesaj atar. Bu mesajda kullanıcının formda yazdıkları ve _Doğrula_ butonu bulunur.
- Sheet'e kullanıcının Discord ID'sini ve formda yazdıklarını ekler.

_Doğrula_ butonuna basıldığında bot:
- Kullanıcının ismini formdaki isim soyisme ayarlar.
    - Aynı zamanda isim ve soyismin ilk harflerini büyük harf yapar.
- Belirlenmiş doğrulandı rolünü kullanıcıya verir.
- Sheet'teki doğrulanma durumunu günceller.

## Hostlama

> Bu bilgiler botu sunucusunda hostlayan kişi için gerekli.

### Build'leme

> Bu komutlar sadece Debian 12'de denenmiştir.

1. Swift için gerekli dependency'leri kurun:
    - `sudo apt-get install binutils git libc6-dev libcurl4 libedit2 libsqlite3-0 pkg-config tzdata zlib1g-dev gnupg2 libgcc-12-dev libstdc++-12-dev libz3-dev uuid-dev libcurl4-openssl-dev libpython3.8 libxml2-dev unzip`
2. Swift 5.9.2'nin tarball'ını indirin:
    - `wget https://download.swift.org/swift-5.9.2-release/ubuntu2204/swift-5.9.2-RELEASE/swift-5.9.2-RELEASE-ubuntu22.04.tar.gz`
3. `tar` dosyasını extract'leyin:
    - `tar xzf swift-5.9.2-RELEASE-ubuntu22.04.tar.gz`
4. Swift'i `PATH`'e ekleyin:
    - `PATH="$HOME/swift-5.9.2-RELEASE-ubuntu22.04/usr/bin:$PATH"`
5. Repo'yu klonlayın:
    - `git clone https://github.com/unoghub/UnogBot`
6. Repo'nun klasörüne girin:
    - `cd UnogBot`
7. SwiftLint'i kapatın:
    - `Package.swift` dosyasında şu satırların başına `//` ekleyin:
        - `.package(url: "https://github.com/realm/SwiftLint.git", from: "0.0.0"),`
        - `plugins: [`
        - `.plugin(name: "SwiftLintPlugin", package: "SwiftLint"),`
        - `plugins: [` satırından sonraki ilk `]`'in olduğu satır
    - Yine `Package.swift` dosyasında `dependencies: [` satırından sonraki ilk `]`'den sonraki `,`'ü silin.
8. Release için build'leyin:
    - `swift build -c release`
9. Uygulama `UnogBot/.build/release/UnogBot`'ta.

### Environment Variable'ları

> `.env` dosyası kullanılabilir.

- `TOKEN`: Bot'un Discord Developer Portal'dan alınan token'ı
- `GUILD_ID`: Komutların oluşturulacağı sunucunun ID'si
- `VERIFICATION_SUBMISSIONS_CHANNEL_ID`: Kullanıcılar doğrulanma formunu doldurduğunda, formun ve dogrulama butonunun olduğu mesajın atılacağı kanalın ID'si, bu kanal sadece doğrulanma yetkisi olanların görebildiği bir kanal olmalı.
- `VERIFIED_ROLE_ID`: Kullanıcılar doğrulandığında onlara verilecek rolün ID'si

Bu bilgileri [Lara](https://lara.lv)'ya sorun:
- `LOGGING_WEBHOOK_URL`: Bot'un error'ları vs. için kullanılacak webhook'un linki
- `SPREADSHEET_ID`: Doğrulanma bilgilerinin kaydedileceği Google Sheet'in ID'si
- `GOOGLE_SERVICE_ACCOUNT_EMAIL`: Google Sheets için kullanılacak olan servis hesabının e-postası

### Dosyalar

- `GoogleServiceAccountPrivateKey.key`: Google Sheets için kullanılacak olan servis hesabının gizli anahtarı

### Bot'u Davet Etme

#### Scope'lar

- bot
- applications.commands

#### İzinler

##### Genel

- Manage Roles
- Manage Nicknames

##### Kanallara Özel

- `/doğrulanma_mesajını_at` komutunun kullanıldığı kanalda:
    - Send Messages
- `VERIFICATION_SUBMISSIONS_CHANNEL_ID`:
    - Send Messages

#### Davet Linki

> Bu link, bot'un scope'larını ve izinlerini de belirtir.

`https://discord.com/api/oauth2/authorize?client_id={CLIENT_ID}&permissions=402655232&scope=applications.commands+bot`

> `{CLIENT_ID}`'yi bot'un application ID'si ile değiştirin.

#### Ekledikten Sonra Yapılacaklar

##### Bot'un Rolünün Konumu

Doğrulandı rolünün verilebilmesi için bot'un rolünü, doğrulandı rolünün ve doğrulanacak kullanıcının rollerinin üstüne yerleştirin.

##### Doğrulanma Mesajının Atılması

Doğrulanma mesajını, `/doğrulanma_mesajını_at` komutuyla atın. Bu komut, kullanıldığı kanala doğrulanma mesajını atar. Doğrulanma mesajı doğrulanma formunu açan butonun olduğu mesajdır.

> Bu komutu sadece _Sunucuyu Yönet_ izni olan kişiler görür ve kullanabilir.

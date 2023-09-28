# ÜNOG Bot

## Kurulum

### Onaylama Mesajını Atma

Onaylama mesajını `/onaylanma_mesajını_at` komutuyla atabilirsiniz. Bu komut, kullanıldığı kanala onaylanma mesajını atar. Onaylama mesajı onaylanma formunu açan butonun olduğu mesajdır.

> Bu komutu sadece _Sunucuyu Yönet_ izni olan kişiler görür ve kullanabilir.

### Kullanıcıyı Onaylama

Kullanıcı formu doldurduğunda bot ayarlanan kanala bir mesaj atar. Bu mesajda kullanıcının formda yazdıkları ve _Onayla_ ve _Reddet_ tuşları bulunur.

- _Onayla_ tuşuna basıldığında, bot kullanıcının ismini formdaki isim soyisme ayarlar ve belirlenmis onaylandı rolünü verir.
- _Reddet_ tuşuna basıldığında ise bot bu kullanıcıyı sunucudan atar.

Her iki tuşta da bot onaylanma mesajını siler.

### Sheets Kullanımı

Kullanıcı formu doldurduğunda bot belirlenen sheet'e tarih, form ve kullanıcı bilgilerini içeren bir satır ekler. Bu satırda _Onaylanma Durumu_, _Bekliyor_ diye ayarlanır.

Kullanıcı doğrulandığında ya da reddedildiğinde bot bu satırdaki _Onaylanma Durumu_ sütununu _Onaylandı_ ya da _Reddedildi_ diye ayarlar.

## Hostlama

> Bu bilgiler botu sunucusunda hostlayan kişi için gerekli.

### Environment Variable'ları

> `.env` dosyası kullanılabilir.

- `TOKEN`: Bot'un Discord Developer Portal'dan alınan token'ı
- `GUILD_ID`: Komutların oluşturulacağı sunucunun ID'si
- `LOGGING_WEBHOOK_URL`: Bot'un error'ları vs. için kullanılacak webhook'un linki, bu linki [Lara](https://lara.lv)'ya sorun.

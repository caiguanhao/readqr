# readqr

QR code reader (decoder).

- Fork of [github.com/makiuchi-d/gozxing](https://github.com/makiuchi-d/gozxing).
Only QR code source files are included. To update source code, run `update.sh`.
- Added WASM support. [Demo](https://caiguanhao.github.io/readqr/wasm/).

```go
import "github.com/caiguanhao/readqr"

f, err := os.Open("qrcode.png")
if err != nil {
	panic(err)
}
defer f.Close()
result, err := readqr.Decode(f)
if err != nil {
	panic(err)
}
fmt.Println(result)
```

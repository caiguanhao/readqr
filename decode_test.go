package readqr

import (
	"net/http"
	"testing"
)

func TestDecode(t *testing.T) {
	resp, err := http.Get("https://user-images.githubusercontent.com/1284703/165458105-f761a8f1-eafc-4943-b1c2-255887a5025f.png")
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()
	result, err := Decode(resp.Body)
	if err != nil {
		panic(err)
	}
	const expected = "https://aweme.snssdk.com/passport/web/scan_index/" +
		"?hide_nav_bar=1&next_url=https%3A%2F%2Faweme.snssdk.com%2Fpassport%2F" +
		"sso%2Fscan_qrcode%2F&qr_source_aid=6383&token=a89227ac6d66b40743179376bf45b002&web_app_from=rcode"
	if result != expected {
		t.Error("wrong result")
	}
}

package readqr

import (
	"image"
	_ "image/jpeg"
	_ "image/png"
	"io"

	"github.com/caiguanhao/readqr/gozxing"
	"github.com/caiguanhao/readqr/qrcode"
)

func Decode(r io.Reader) (string, error) {
	img, _, err := image.Decode(r)
	if err != nil {
		return "", err
	}
	return DecodeImage(img)
}

func DecodeImage(img image.Image) (string, error) {
	bmp, err := gozxing.NewBinaryBitmapFromImage(img)
	if err != nil {
		return "", err
	}
	result, err := qrcode.NewQRCodeReader().Decode(bmp, nil)
	if err != nil {
		return "", err
	}
	return result.GetText(), nil
}

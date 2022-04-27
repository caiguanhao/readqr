package main

import (
	"io"
	"syscall/js"

	"github.com/caiguanhao/readqr"
)

func main() {
	c := make(chan struct{}, 0)
	js.Global().Set("ReadQR", js.FuncOf(ReadQR))
	js.Global().Call("eval", "document.dispatchEvent(new Event('ReadQR.Ready'))")
	<-c
}

func ReadQR(this js.Value, inputs []js.Value) interface{} {
	window := js.Global()
	return window.Get("Promise").New(js.FuncOf(func(this js.Value, args []js.Value) interface{} {
		r, w := io.Pipe()

		window := js.Global()
		writer := window.Get("Object").New()
		writer.Set("write", js.FuncOf(func(this js.Value, args []js.Value) interface{} {
			uint8array := args[0]
			data := make([]byte, uint8array.Length())
			js.CopyBytesToGo(data, uint8array)
			n, _ := w.Write(data)
			return n
		}))
		writer.Set("close", js.FuncOf(func(this js.Value, args []js.Value) interface{} {
			w.Close()
			return nil
		}))
		writer.Set("next", window.Get("Promise").New(js.FuncOf(func(this js.Value, args []js.Value) interface{} {
			resolve, reject := args[0], args[1]
			go func() {
				content, err := readqr.Decode(r)
				w.Close()
				if err != nil {
					reject.Invoke(window.Get("Error").New(err.Error()))
				} else {
					resolve.Invoke(content)
				}
			}()
			return nil
		})))

		resolve := args[0]
		resolve.Invoke(writer)

		return nil
	}))
}

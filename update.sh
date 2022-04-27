#!/bin/bash

SRCPKG=github.com/makiuchi-d/gozxing
SRCDIR=source

NEWPKG=github.com/caiguanhao/readqr

if [ ! -d $SRCDIR ]; then
  git clone https://$SRCPKG $SRCDIR
fi

rm -rf common gozxing qrcode LICENSE

COMMON_FILES=(
  common/perspective_transform.go
  common/decoder_result.go
  common/util/math_utils.go
  common/grid_sampler.go
  common/default_grid_sampler.go
  common/bit_source.go
  common/string_utils.go
  common/detector_result.go
  common/character_set_eci.go
  common/reedsolomon/reedsolomon_decoder.go
  common/reedsolomon/reedsolomon_encoder.go
  common/reedsolomon/reedsolomon_exception.go
  common/reedsolomon/generic_gf.go
  common/reedsolomon/generic_gf_poly.go
)

mkdir -p common/util common/reedsolomon

for f in ${COMMON_FILES[@]}; do
  echo "Processing $f..."
  sed \
    -e "s#$SRCPKG/common#$NEWPKG/common#" \
    -e "s#$SRCPKG#$NEWPKG/gozxing#" \
      $SRCDIR/$f > $f
done


QRCODE_FILES=(
  qrcode/encoder/matrix_util.go
  qrcode/encoder/encoder.go
  qrcode/encoder/qrcode.go
  qrcode/encoder/byte_matrix.go
  qrcode/encoder/block_pair.go
  qrcode/encoder/mask_util.go
  qrcode/decoder/error_correction_level.go
  qrcode/decoder/decoded_bit_stream_parser.go
  qrcode/decoder/version.go
  qrcode/decoder/decoder.go
  qrcode/decoder/data_mask.go
  qrcode/decoder/format_information.go
  qrcode/decoder/bit_matrix_parser.go
  qrcode/decoder/qrcode_decoder_meta_data.go
  qrcode/decoder/mode.go
  qrcode/decoder/data_block.go
  qrcode/qrcode_reader.go
  qrcode/detector/finder_pattern_finder.go
  qrcode/detector/alignment_pattern.go
  qrcode/detector/detector.go
  qrcode/detector/finder_pattern.go
  qrcode/detector/alignment_pattern_finder.go
  qrcode/detector/finder_pattern_info.go
  qrcode/qrcode_writer.go
)

mkdir -p qrcode/decoder qrcode/detector qrcode/encoder

for f in ${QRCODE_FILES[@]}; do
  echo "Processing $f..."
  sed \
    -e "s#$SRCPKG/common#$NEWPKG/common#" \
    -e "s#$SRCPKG/qrcode#$NEWPKG/qrcode#" \
    -e "s#$SRCPKG#$NEWPKG/gozxing#" \
      $SRCDIR/$f > $f
done

FILES=(
  barcode_format.go
  binarizr.go
  binary_bitmap.go
  bit_array.go
  bit_matrix.go
  checksum_exception.go
  decode_hint_type.go
  encode_hint_type.go
  format_exception.go
  global_histogram_binarizer.go
  go_image_luminance_source.go
  hybrid_binarizer.go
  inverted_luminance_source.go
  luminance_source.go
  not_found_exception.go
  reader.go
  reader_exception.go
  result.go
  result_metadata_type.go
  result_point.go
  result_point_callback.go
  rgb_luminance_source.go
  writer_exception.go
)

mkdir -p gozxing

for f in ${FILES[@]}; do
  echo "Processing $f..."
  sed \
    -e "s#$SRCPKG/common#$NEWPKG/common#" \
    -e "s#$SRCPKG#$NEWPKG/gozxing#" \
      $SRCDIR/$f > gozxing/$f
done

gofmt -s -w common gozxing qrcode

cp -v $SRCDIR/LICENSE LICENSE

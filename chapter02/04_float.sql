-- FLOAT의 정밀도는 이진 자릿수이므로 십진 자릿수로 바꿀 때 log10(2)를 곱한다.
SELECT LOG(10, 2) AS binary_to_decimal,
       126 * LOG(10, 2) AS float_126_decimal_digits
  FROM dual;

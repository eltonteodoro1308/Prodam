SELECT
  SUBSTRING(SE5.E5_DATA, 1, 8) E5_DATA,
  SE5.E5_NATUREZ,
  SED.ED_DESCRIC,
  SED.ED_COND,
  E5_VALOR = SUM(SE5.E5_VALOR *
                               CASE SE5.E5_RECPAG
                                 WHEN 'R' THEN 1
                                 WHEN 'P' THEN -1
                                 ELSE 0
                               END)
FROM SE5010 SE5
LEFT JOIN SED010 SED
  ON SE5.E5_FILIAL = SED.ED_FILIAL
  AND SE5.E5_NATUREZ = SED.ED_CODIGO
WHERE SE5.D_E_L_E_T_ = ''
AND SED.D_E_L_E_T_ = ''
AND SE5.E5_FILIAL = '01'
AND SED.ED_FILIAL = '01'
AND SE5.E5_NATUREZ BETWEEN '          ' AND '7.5.1.99  '
AND SE5.E5_DATA BETWEEN SUBSTRING('20180601', 1, 8) AND SUBSTRING('20180630', 1, 8)
AND SE5.E5_BANCO + SE5.E5_AGENCIA + SE5.E5_CONTA IN ('0011897 590562    ', '0011897 5905621   ', '1042873 191       ', '1042873 191-8     ', '1042873 1914      ', '1042873 1918      ', '1042873 194       ', '1042873 1942      ', '1042873 62        ', '1043278 0         ', '2370301 5461      ', '3410057 63501     ', 'CX1000010000000001', 'FFC0000100001     ')
AND SE5.E5_TIPODOC IN ('VL')
AND SED.ED_NATMT = ''
GROUP BY SUBSTRING(SE5.E5_DATA, 1, 8),
         SE5.E5_NATUREZ,
         SED.ED_DESCRIC,
         SE5.E5_RECPAG,
         SED.ED_COND
HAVING SUM(SE5.E5_VALOR *
                         CASE SE5.E5_RECPAG
                           WHEN 'R' THEN 1
                           WHEN 'P' THEN -1
                           ELSE 0
                         END) <> 0
ORDER BY SE5.E5_NATUREZ, SUBSTRING(SE5.E5_DATA, 1, 8)
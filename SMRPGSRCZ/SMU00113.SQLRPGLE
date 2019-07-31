     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
 **** *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Migration Utility for SDLENOPD')
 **** *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00112 - Migration Utility for SDLENOPD                    *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. AR1092128B         Date 01Mar13               *
      *                 AR1075447A*CREATE  Date 11Feb13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1092128B - Update SDLENOPD to move the values from the     *
      *               numeric to the alpha loan ranges and initialize *
      *               the numeric loan ranges to 0.                   *
      *  AR1085447A - Migration utility for SDLENOPD                  *
      *                                                               *
      *****************************************************************

     D*SQLSTRING*      S          32000A   VARYING INZ                                    AR1092128B

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** File SDLENOPD

     C/exec SQL
     C+  UPDATE SDLENOPD                                                                  AR1092128B
     C+  SET F9FRAA=CASE WHEN F9FRAN=0 THEN '      ' ELSE CONCAT(                         AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=1 THEN '00000' ELSE                       AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=2 THEN '0000' ELSE                        AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=3 THEN '000' ELSE                         AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=4 THEN '00' ELSE                          AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=5 THEN '0' ELSE ''                        AR1092128B
     C+    END END END END END,TRIM(CHAR(F9FRAN))) END, F9FRAN=0,                         AR1092128B
     C+    F9LRAA=CASE WHEN F9LRAN=0 THEN '      ' ELSE CONCAT(                           AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=1 THEN '00000' ELSE                       AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=2 THEN '0000' ELSE                        AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=3 THEN '000' ELSE                         AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=4 THEN '00' ELSE                          AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=5 THEN '0' ELSE ''                        AR1092128B
     C+    END END END END END,TRIM(CHAR(F9LRAN))) END, F9LRAN=0,                         AR1092128B
     C+    F9NALA=CASE WHEN F9NALN=0 THEN '      ' ELSE CONCAT(                           AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=1 THEN '00000' ELSE                       AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=2 THEN '0000' ELSE                        AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=3 THEN '000' ELSE                         AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=4 THEN '00' ELSE                          AR1092128B
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=5 THEN '0' ELSE ''                        AR1092128B
     C+    END END END END END,TRIM(CHAR(F9NALN))) END, F9NALN=0                          AR1092128B
     C**INSERT*INTO SDLENOPD(                                                             AR1092128B
     C*****F9RGNB,                                                                        AR1092128B
     C*****F9RGDS,                                                                        AR1092128B
     C*****F9LCD,                                                                         AR1092128B
     C*****F9TYLC,                                                                        AR1092128B
     C*****F9ZONE,                                                                        AR1092128B
     C*****F9IUSR,                                                                        AR1092128B
     C*****F9AUSR,                                                                        AR1092128B
     C*****F9XUSR,                                                                        AR1092128B
     C*****F9AACC,                                                                        AR1092128B
     C*****F9EACC,                                                                        AR1092128B
     C*****F9GPDT,                                                                        AR1092128B
     C*****F9FRAA,                                                                        AR1092128B
     C*****F9LRAA,                                                                        AR1092128B
     C*****F9NALA)                                                                        AR1092128B
     C***SELECT*                                                                          AR1092128B
     C*****a.F9RGNB,                                                                      AR1092128B
     C*****a.F9RGDS,                                                                      AR1092128B
     C*****a.F9LCD,                                                                       AR1092128B
     C*****a.F9TYLC,                                                                      AR1092128B
     C*****a.F9ZONE,                                                                      AR1092128B
     C*****a.F9IUSR,                                                                      AR1092128B
     C*****a.F9AUSR,                                                                      AR1092128B
     C*****a.F9XUSR,                                                                      AR1092128B
     C*****a.F9AACC,                                                                      AR1092128B
     C*****a.F9EACC,                                                                      AR1092128B
     C*****a.F9GPDT,                                                                      AR1092128B
     C*****DIGITS(a.F9FRAN),                                                              AR1092128B
     C*****DIGITS(a.F9LRAN),                                                              AR1092128B
     C*****DIGITS(a.F9NALN)                                                               AR1092128B
     C***FROM*SMLENOPD a                                                                  AR1092128B
     C/end-exec

     C                   IF         SQLCOD < 0 AND SQLCOD <> -204
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
      *
     C                   RETURN
     C                   EVAL      *INLR = *ON
     C                   ENDSR
      *
      *****************************************************************

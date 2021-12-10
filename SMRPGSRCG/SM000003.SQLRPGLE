     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/******  RPGBASEBND                                                   *                     MD057599
/*STD *  RPGSQLBND                                                    *                     MD057599
/*EXI *  TEXT('Midas SM Update SMCNUMPD status to blank')             *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000003 - Update SMCNUMPD status to blank                   *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD058089           Date 01Sep21               *
      *  Prev Amend No. MD057599           Date 21Jan21               *
      *                 MD046248           Date 27Oct17               *
      *                 AR1085447          Date 05Feb13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CUP034  *CREATE    Date 12Mar07               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058089 - Deliverable Data Split for SM and UP              *
      *  MD057599 - Deliverable Data Split for Bridge and Util files  *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1085447 - Set status field on SMLNRFPD to blank            *
      *  CUP034 - Set status field on SMCNUMPD to blank.              *
      *                                                               *
      *****************************************************************
      *
      * +--------------------------------------+
      * ¦ F-specs                              ¦
      * ¦ =======                              ¦
      * +--------------------------------------+
      *
     F*SMCNUMPD* UF   E             DISK                                                    MD058089
     F*SMLNRFPD  UF   E             DISK                                          AR1085447 MD057599
      *
     D Recursive       S              1    INZ('N')
     D Layer           S              7                                                     MD057599
     D SMCNUM        E DS                  EXTNAME(SMCNUJW0)                                MD058089
      * +--- Start of Main processing -----------------------------------+
      * ¦                                                                ¦
      * +----------------------------------------------------------------+
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode              7
     C                   PARM                    Optn              7                       AR1085447
      *
     C                   eval      Layer = Mode                                             MD057599
                                                                                            MD057599
     C                   IF        Optn = '*PREAC'
     C*****1****         SETLL     SMCNUMPD                                                 MD058089
     C**********         READ      SMCNUMPD                                                 MD058089
                                                                                            MD058089
     C/EXEC SQL                                                                             MD058089
     C+ Update SMCNUXTD set CNUPDF = ' '                                                    MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
     C**********         DOU       %EOF                                                     MD058089
     C**********         IF        Mode = CNLAYR or                                         MD058089
     C**********                   Mode = '*ALL   '                                         MD058089
     C**********         EVAL      CNUPDF = *blank                                          MD058089
     C**********         ENDIF                                                              MD058089
      **********                                                                            MD058089
     C**********         READ      SMCNUMPD                                                 MD058089
     C**********         ENDDO
     C                   ENDIF                                                             AR1085447
      *
     C                   IF        Optn = '*PREAL'                                         AR1085447
     C**********         SETLL     SMLNRFPD                                       AR1085447 MD057599
     C**********         READ      SMLNRFPD                                       AR1085447 MD057599
     C**********         DOU       %EOF                                           AR1085447 MD057599
     C**********         IF        Mode = LNLAYR or                               AR1085447 MD057599
     C**********                   Mode = '*ALL   '                               AR1085447 MD057599
     C**********         EVAL      LNUPDF = *BLANKS                               AR1085447 MD057599
     C**********         ENDIF                                                    AR1085447 MD057599
      **********                                                                  AR1085447 MD057599
     C**********         READ      SMLNRFPD                                       AR1085447 MD057599
     C**********         ENDDO                                                    AR1085447 MD057599
     C                   If        Mode = '*ALL   '                                         MD057599
     C/Exec SQL                                                                             MD057599
     C+ Update SMLNRXTD set LNUPDF = ' '                                                    MD057599
     C/End-Exec                                                                             MD057599
     C                   Else                                                               MD057599
     C                   eval      Layer = Mode                                             MD057599
     C/Exec SQL                                                                             MD057599
     C+ Update SMLNRXTD set LNUPDF = ' ' where LNLAYR = :Layer                              MD057599
     C/End-Exec                                                                             MD057599
     C                   Endif                                                              MD057599
     C                   ENDIF                                                             AR1085447
      *
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *

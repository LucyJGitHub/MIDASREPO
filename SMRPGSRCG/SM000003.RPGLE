     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update SMCNUMPD status to blank')             *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000003 - Update SMCNUMPD status to blank                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      *  Last Amend No. AR1085447          Date 05Feb13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CUP034  *CREATE    Date 12Mar07               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
     FSMCNUMPD  UF   E             DISK
     FSMLNRFPD  UF   E             DISK                                                    AR1085447
      *
     D Recursive       S              1    INZ('N')
      * +--- Start of Main processing -----------------------------------+
      * ¦                                                                ¦
      * +----------------------------------------------------------------+
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode              7
     C                   PARM                    Optn              7                       AR1085447
      *
     C                   IF        Optn = '*PREAC'
     C     1             SETLL     SMCNUMPD
     C                   READ      SMCNUMPD
     C                   DOU       %EOF
     C                   IF        Mode = CNLAYR or
     C                             Mode = '*ALL   '
     C                   EVAL      CNUPDF = *blank
     C                   ENDIF
      *
     C                   READ      SMCNUMPD
     C                   ENDDO
     C                   ENDIF                                                             AR1085447
      *
     C                   IF        Optn = '*PREAL'                                         AR1085447
     C     1             SETLL     SMLNRFPD                                                AR1085447
     C                   READ      SMLNRFPD                                                AR1085447
     C                   DOU       %EOF                                                    AR1085447
     C                   IF        Mode = LNLAYR or                                        AR1085447
     C                             Mode = '*ALL   '                                        AR1085447
     C                   EVAL      LNUPDF = *BLANKS                                        AR1085447
     C                   ENDIF                                                             AR1085447
      *                                                                                    AR1085447
     C                   READ      SMLNRFPD                                                AR1085447
     C                   ENDDO                                                             AR1085447
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

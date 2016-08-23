     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*XBI *  OVRDBF FILE(FILEMULMBR) TOFILE(*LIBL/QAFDMBR)                *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Change library names for FILEMULMBR')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM0264 - Change library names for FILEMULMBR                 *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK025  *MOVED     Date 02Sep06               *
      *  Prev Amend No. CUP016 *CREATE     Date 01Apr03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPK025 - MidasPlus 1.3 packaging.  Move to global layer.     *
      *  CUP016 - Add implementation software to core.                *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * File containing list on non-referenced fields
     FFILEMULMBRUF   E             DISK
      *
     D Recursive       S              1
      * +--- Start of Main processing -----------------------------------+
      * ¦                                                                ¦
      * +----------------------------------------------------------------+
      *
      * Read first record;
     C                   READ      FILEMULMBR                             99
     C     *IN99         IFEQ      *ON                                          I01
     C                   GOTO      ENDPGM
     C                   ENDIF                                                  E01
      *
     C                   DOU       *IN99 = *ON
      *
      * Check where physical file and logical file exists and move library in.
     C                   MOVE      *blanks       return_lib       10
     C                   CALL      'SMC0264'
     C                   PARM                    MBBOF
     C                   PARM                    return_lib
      *
     C                   MOVEL     return_lib    MBBOL
      *
     C                   MOVE      *blanks       return_lib
     C                   CALL      'SMC0264'
     C                   PARM                    MBFILE
     C                   PARM                    return_lib
      *
     C                   MOVEL     return_lib    MBLIB
      *
     C                   UPDATE    QWHFDMBR
      *
     C                   READ      FILEMULMBR                             99
      *
     C                   ENDDO
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

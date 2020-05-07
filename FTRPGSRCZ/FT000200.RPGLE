     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FT Incoming MT103 Message for On Hold')          *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer module                                *
      *                                                               *
      *  FT000200 - This program will upddate FTM199 to H (on hold)   *
      *             at Value date +1 when an incoming message is not  *
      *             yet credited/processed                            *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CSW220  *CREATE    Date 09Mar20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW220 - SWIFT Changes 2020
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *  90   If record found in MEINFTL5                             *
      *  91   If record found in INPAYL4                              *
      *  92   If record found in OTPAYL4                              *
      *  LR   Last Record                                             *
      *****************************************************************
      ** FT Detail file
     FMEINFTL5  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(UP_)

      ** Join file MEINFTPD and MEINCRPD
     FMEINFTJ4  IF   E             DISK    INFSR(*PSSR)
      *

      ********************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data structure for bank file
      *
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structure for access programs
      *
      **Work Variables
     D DateIn          S              6  0
     D ZDAYNO          S              5P 0
     D ErrorFlag       S              7A
     D ValDat          S              5P 0
     D PRtcd           S              7
     D POPtn           S              7
     D WYear           S              2A
     D WMMDD           S              4A
      *
      *****************************************************************

      ** Main Processing

     C                   READ      MEINFTJ4

     C                   DOW       NOT %EOF(MEINFTJ4)

      ** Check Value date in control file
      ** All MT103 with value date +1 less than or equal to rundate
      ** must be set to "H", these are message put to ON HOLD

     C                   EXSR      SrCvtDate
     C                   IF        ValDat +1 <= BJRDNB


     C                   EVAL      FTM199 = 'H'

     C     FTMSGR        CHAIN     MEINFTL5                           90
     C                   IF        *IN90 = *OFF
     C                   EVAL      UP_FTM199 = FTM199
     C                   UPDATE    @INFTPD
     C                   ENDIF

     C                   ENDIF
     C                   READ      MEINFTJ4

     C                   ENDDO

     C                   SETON                                        LR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCvtDate - Convert date to Midas date                        *
      *                                                               *
      *****************************************************************
     C     SrCvtDate     BEGSR

     C                   MOVEL     CRSVDT        WYear
     C                   MOVE      CRSVDT        WMMDD
     C                   MOVEL     WMMDD         DateIn
     C                   MOVE      WYear         DateIn
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ErrorFlag
     C                   PARM                    DateIn
     C                   PARM      'M'           BJDFIN
     C                   PARM      *ZERO         ZDAYNO

      ** Invalid Format or Not Numeric

     C                   IF        ErrorFlag <> *BLANKS
     C                   MOVE      '002'         DBASE
     C                   MOVE      'CRMODE'      DBKEY
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     ZDAYNO        ValDat
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Entry parameters
      *
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'FT000200'    DBPGM
     C                   MOVE      *BLANKS       DBASE

      ** Access SDBANKPD for report title

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*FIRST '     POPtn
     C     SDBANK        PARM      SDBANK        DSFDY

     C     PRTcd         IFNE      *BLANKS
     C                   MOVE      '003'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR

      * Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF

     C                   RETURN

     C                   ENDSR
      *****************************************************************

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM MEINFTPD MT199 Initialization')               *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00199 - This program fills MT199 fields in MEINFTPD       *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD056683           Date 14Sep20               *
      *  Prev Amend No. CSW220  *CREATE    Date 09Mar20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056683 - MT199 Confirm is being generated for an IPAY where*
      *             the credit goes to the Account with Bank          *
      *  CSW220 - SWIFT Changes 2020                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *  90   If record found in MEINFTL5                             *
      *  91   If record found in INPAYLA                              *
      *  92   If record found in OTPAYLA                              *
      *
      *  LR   Last Record                                             *
      *                                                               *
      *****************************************************************
      ** FT Detail file
     FMEINFTL5  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(UP_)

      ** Join file MEINFTPD and MEINCRPD
     FMEINFTJ4  IF   E             DISK    INFSR(*PSSR)
      *
      ** IPAY keyed by PREF
     FINPAYLA   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(IN_)

      ** OPAY keyed by PREF
     FOTPAYLA   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(OP_)

      ** Incoming Message Control by Message Tag
     FMEINDTL0  IF   E           K DISK

      ********************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data structure for bank file
      *
     D JNSTAT        E DS                  EXTNAME(JNSTAT) DTAARA
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
     D WRun            S              1A   Inz
     D DateIn          S              6  0
     D ZDAYNO          S              5  0
     D ErrorFlag       S              7A
     D ValDat          S              5  0
     D PRtcd           S              7
     D POPtn           S              7
     D WYear           S              2A
     D WMMDD           S              4A
     D WPRUN           S              5  0
     D WOldDay         S              5  0
     D WDays           S              5  0
     D KFMsgR          S              8S 0
     D KFMtag          S              5A
      *
      *****************************************************************

      ** Main Processing

     C                   READ      MEINFTJ4

     C                   DOW       NOT %EOF(MEINFTJ4)

      *
      ** If Incoming message is with tag 121, validate value date if for
      ** processing of MT199
      ** If no tag 121, tagged as 'O', old data
      *
     C                   EVAL      KFMsgR = FTMSGR
     C                   EVAL      KFMtag = '121:'
     C     KLIncMsg      CHAIN     MEINDTL0
     C                   IF        NOT %FOUND
     C                   EVAL      FTM199 = 'O'
     C                   ELSE

      ** Check date Value Date in control file
      ** All MT103 with Value Date less than rundate minus 1
      ** must be set to "O", these are old data in the system
      ** No need to send an MT199

     C                   EXSR      SrCvtDate
     C                   IF        ValDat < WOldDay

     C                   EVAL      FTM199 = 'O'

      ** Incoming message tagged as IGNORE (Delete)
     C                   ELSEIF    FTINFG = 'MIN0182'
     C                   EVAL      FTM199 = 'R'

      ** Set other status for MT199
     C                   ELSEIF    FTIPRF <> *BLANKS OR
     C                             FTOPRF <> *BLANKS
     C                   EXSR      SrMT199Stat

      ** Data to be determined if On Hold
     C                   ELSE
     C                   EVAL      FTM199 = *BLANKS
     C                   ENDIF

     C                   ENDIF

     C     FTMSGR        CHAIN     MEINFTL5                           90
     C                   IF        *IN90 = *OFF
     C                   EVAL      UP_FTM199 = FTM199
     C                   UPDATE    @INFTPD
     C                   ENDIF

     C                   READ      MEINFTJ4

     C                   ENDDO

     C                   SETON                                        LR
      *
      *****************************************************************
      *                                                               *
      * SrMT199Stat - Subroutine that will determine if the incoming  *
      *               message is an IPAY, OPAY or FTMG transaction    *
      *                                                               *
      *****************************************************************
      *
     C     SrMT199Stat   BEGSR
      *
      ** IPAY Incoming message
     C                   IF        FTIPRF <> *BLANKS
     C                   EXSR      SrIPAY

      ** OPAY Incoming message
     C                   ELSEIF    FTOPRF <> *BLANKS
     C                   EXSR      SrOPAY
     C                   ENDIF

     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * SrIPAY - To update MT199 for IPAY transaction                 *
      *                                                               *
      *****************************************************************
      *
     C     SrIPAY        BEGSR
      *
      ** Check IPAY, set MT199 field accordingly:
      ** A - for generation of ACCC if PAUT is Y
      ** R - for generation of RJCT if Deleted
      ** H - for generation of ACSP if PAUT is N

     C     FTIPRF        CHAIN     INPAYLA                            91
     C                   IF        *IN91 = *OFF AND IN_RECI <> 'M'

      ** Livre records
      ** Authorized
     C                   IF        IN_AUIN = 'Y'
      *                                                                                     MD056683
     C                   IF        IN_ACBT = *BLANK                                         MD056683
     C                   EVAL      FTM199 = 'A'
     C                   ELSE                                                               MD056683
     C                   IF        IN_OPIN = 'Y'                                            MD056683
     C                   EVAL      FTM199 = 'Z'                                             MD056683
     C                   ELSE                                                               MD056683
     C                   EVAL      FTM199 = 'I'                                             MD056683
     C                   ENDIF                                                              MD056683
     C                   ENDIF                                                              MD056683
      *                                                                                     MD056683
     C                   ELSE
      ** Not yet authorize
     C                   EVAL      FTM199 = *BLANKS
     C                   ENDIF

     C                   ELSE
      ** Matured transactions
     C                   EVAL      FTM199 = 'O'
     C                   ENDIF

     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * SroPAY - To update MT199 for OPAY transaction                 *
      *                                                               *
      *****************************************************************
      *
     C     SrOPAY        BEGSR
      *
      ** Check OPAY, set MT199 field accordingly:
      ** T - for generation of ACSP-Transferred if PAUT is Y
      ** R - for generation of RJCT if Deleted
      ** H - for generation of ACSP if PAUT is N
      ** O - No obligation to OPAY on FIN

     C     FTOPRF        CHAIN     OTPAYLA                            92
     C                   IF        *IN92 = *OFF and OP_RECI <> 'M'
      ** Live records
     C                   IF        OP_AUIN = 'Y' AND
     C                             (OP_STMT <> 8 AND OP_STMT <> 1)
     C                   EVAL      FTM199 = 'T'
      ** Not yet authorized
     C                   ELSEIF    OP_AUIN = *BLANKS
     C                   EVAL      FTM199 = *BLANKS
      ** Authorized but not transferred
     C                   ELSE
     C                   EVAL      FTM199 = 'O'
     C                   ENDIF

     C                   ELSE
      ** Matured transactions
     C                   EVAL      FTM199 = 'O'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrCvtDate - Convert date to Midas date                        *
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
      *
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
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'SMU00199'    DBPGM
     C                   MOVE      *BLANKS       DBASE

      ** Access SDBANKPD for report title

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*FIRST '     POPtn
     C     SDBANK        PARM      SDBANK        DSFDY

     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      '003'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IN        JNSTAT
     C                   EVAL      WPRUN = PRUN
     C                   EVAL      WDays = BJRDNB - WPRUN
     C                   EVAL      WOldDay = BJRDNB - WDays

      ** Key List for reading Incoming Messages
      *
     C     KLIncMsg      KLIST
     C                   KFLD                    KFMsgR
     C                   KFLD                    KFMtag
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************

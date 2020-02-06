     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Subject to CRS Reporting')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVCRSR - Validate Subject to CRS Reporting and Reason       *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD050497           Date 11May18               *
      *  Prev Amend No. CGL177             Date 11Jan16               *
      *                 MD036279           Date 21Oct15               *
      *                 CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050497 - User, Date and Time fields are not populated when *
      *             Reason was entered during Customer Insert         *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD036279 - Timestamp for setting subject to reporting to N   *
      *             should be based on system date/time               *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

     FSDCRSDL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F_)
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE

     D/COPY ZACPYSRC,PSDS

     D/COPY ZACPYSRC,ERR_XARRYS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

     D DDCUSR          S              6                                                     MD050497
     D DDCTRY          S              2                                                     MD050497
     D DDPEP1          S             64
     D DDPEP2          S             64
     D DDREPT          S              1
     D DDREP1          S             64
     D DDREP2          S             64
     D DDREPTOK        S              1
     D DDREPROK        S              1
     D DFREPT          S              1
     D DFREPR          S            128
     D DFREPU          S             10
     D DFREPM          S              6
     D DFREPD          S              5P 0
     D WNEW            S              1A
     D PTimeStamp      S             26Z
     D WTimeStamp      S             26A
     D WWRDNB          S              5P 0
     D DDUSID          S             10
     D DDPREP          S              1                                                       CGL177

     DWWEXET           DS             8
     D WHH                     1      2
     D WWW1                    3      3
     D WMM                     4      5
     D WWW2                    6      6
     D WSS                     7      8

     DWWEXED           DS             8                                                     MD036279
     D WY4                     1      4                                                     MD036279
     D WMN                     5      6                                                     MD036279
     D WDY                     7      8                                                     MD036279
      * ZDATE10 parms                                                                       MD036279
     D PDateIn         S              8S 0                                                  MD036279
     D PMDNO           S              5P 0                                                  MD036279
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Initialization

     C                   MOVE      *BLANK        ReturnCode
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      'Y'           DDREPTOK
     C                   MOVE      'Y'           DDREPROK
     C                   EVAL      WNEW = 'N'

     C                   IF        DDREPT <> 'Y' AND
     C                             DDREPT <> 'N' AND
     C                             DDREPT <> ' '

     C                   MOVE      'N'           DDREPTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDREPO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0643'     MsgIdXAr(Idx)

     C                   ELSE
     C                   EVAL      DFREPT = DDREPT
     C                   ENDIF

     C                   IF        DDREPT = 'N'                                               CGL177
     C                             AND (DDPREP = 'Y'                                          CGL177
     C                             OR DDPREP = ' ')                                           CGL177
     C                   EVAL      WNEW = 'Y'
     C                   ENDIF

     C                   IF        DDREPT = 'N'
     C                             AND DDREP1 = *Blanks
     C                             AND DDREP2 = *Blanks
     C                   MOVE      'N'           DDREPROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDREPR'      FldNamXAr(Idx)
     C                   MOVEL     'USS0644'     MsgIdXAr(Idx)
     C                   ELSE
     C                   EVAL      DFREPR = DDREP1
     C                   MOVE      DDREP2        DFREPR
     C                   ENDIF

     C                   IF        DDREPTOK = 'Y' AND
     C                             DDREPROK = 'Y'

      ** Generate Timestamp

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
                                                                                            MD050497
     C                   IF        DDCUSR <> *BLANKS                                        MD050497
     C     KCTRY         CHAIN(N)  SDCRSDL0                                                 MD050497
     C                   ENDIF                                                              MD050497

     C                   IF        WNEW = 'Y'
     C                             OR (DDCUSR <> *BLANKS                                    MD050497
     C                             AND DDREPT = 'N'                                         MD050497
     C                             AND NOT %FOUND(SDCRSDL0))                                MD050497
     C                             OR (DDCUSR <> *BLANKS                                    MD050497
     C                             AND DDREPT = 'N'                                         MD050497
     C                             AND %FOUND(SDCRSDL0)                                     MD050497
     C                             AND F_CDREPR <> DFREPR)                                  MD050497

     C                   MOVE      PTimestamp    WTimestamp
     C                   EVAL      WY4 = %SUBST(WTimestamp:01:4)                            MD036279
     C                   EVAL      WMN = %SUBST(WTimestamp:06:2)                            MD036279
     C                   EVAL      WDY = %SUBST(WTimestamp:09:2)                            MD036279
     C                   MOVEL     WWEXED        PDateIN                                    MD036279
     C                   EXSR      SrZDAT10                                                 MD036279
     C                   EVAL      DFREPD = PMDNO                                           MD036279
     C                   EVAL      WHH = %SUBST(WTimestamp:12:2)
     C                   EVAL      WMM = %SUBST(WTimestamp:15:2)
     C                   EVAL      WSS = %SUBST(WTimestamp:18:2)
     C                   EVAL      DFREPM = '******'                                          CGL177
     C                   EVAL      DFREPU = DDUSID
     C                   ENDIF
     C                   ENDIF

      ** RETURN

     C                   RETURN

      *****************************************************************                     MD036279
      *                                                               *                     MD036279
      *  SrZDAT10 - Convert YYYYMMDD Date to Midas Day                *                     MD036279
      *                                                               *                     MD036279
      *****************************************************************                     MD036279
     C     SrZDAT10      BEGSR                                                              MD036279
                                                                                            MD036279
     C                   CALLB     'ZDATE10'                                                MD036279
     C                   PARM                    PDateIN                                    MD036279
     C                   PARM                    PMDNO                                      MD036279
                                                                                            MD036279
     C                   ENDSR                                                              MD036279
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Return Code
     C                   PARM                    ReturnCode

      ** Subject to Reporting and Reason
     C                   PARM                    DDCUSR                                     MD050497
     C                   PARM                    DDCTRY                                     MD050497
     C                   PARM                    DDPEP1
     C                   PARM                    DDPEP2
     C                   PARM                    DDREPT
     C                   PARM                    DDREP1
     C                   PARM                    DDREP2
     C                   PARM                    WWRDNB
     C                   PARM                    DDUSID
     C                   PARM                    DDPREP                                       CGL177

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Subject to Reporting and Reason - OK
     C                   PARM                    DDREPTOK
     C                   PARM                    DDREPROK

     C                   PARM                    DFREPT
     C                   PARM                    DFREPR
     C                   PARM                    DFREPD
     C                   PARM                    DFREPM
     C                   PARM                    DFREPU

     C     KCTRY         KLIST
     C                   KFLD                    DDCUSR
     C                   KFLD                    DDCTRY

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2015

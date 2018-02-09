     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate FX Rate and M/D Indicator')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEVFXIN01 - Validate Securities Prices Multiply/Divide       *
      *              Indicator and FX Rate.                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060  *CREATE    Date 07Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP060 - Midas APIs, Security Prices Full API                *
      *                                                               *
      *****************************************************************
 
     FPMHSEXPD  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** Rundat
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** EXTERNAL DS FOR SECURITIES TRADING DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D IDX             S              3P 0
     D WIDX            S              3P 0
 
      ** Error flag passed back from ZDATE1
     D ErrorFlag       S              1A
 
      ** Midas day number
     D ZDAYNO          S              5P 0
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WMSGIDXAR
     C                   MOVE      *BLANK        WFLDNMXAR
     C                   Z-ADD     0             WIDX
 
      *
      * Validate FX and Mult/Divide indicator
     C                   EXSR      SRFXIN
      *
     C     DDNPXROK      IFEQ      'N'
     C     DDNPMDOK      ANDEQ     'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      * Sr FXIN - Multiply/Divide and FX Indicator validation
      *****************************************************************
     C     SrFXIN        BEGSR
 
     C     DDPTFR        IFEQ      *BLANKS
     C     DDNPXR        ANDNE     *BLANKS
     C     DDPTFR        OREQ      *BLANKS
     C     DDNPMD        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr (Idx) = 'DDNPXR'
 
      * Error : Neither FX Rate nor M/D Indicator can be entered if Portfolio Reference is blank.
 
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1145'
     C                   EVAL      DDNPXROK  = 'N'
     C                   EVAL      DDNPMDOK  = 'N'
     C                   GOTO      EFXIN
     C                   ENDIF
 
     C     BGPFMG        IFEQ      'Y'
     C*
     C** FX Rate and multiply/divide indicator may not be entered
     C** if reference for '9997' portfolio has been input
     C*
     C     DDPTFR        IFEQ      FCR997
     C*
     C     DDNPXR        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr (Idx) = 'DDNPXR'
 
      * Error : FX Rate may not be entered if reference for 9997 portfolio has been input.
 
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1134'
     C                   EVAL      DDNPXROK  = 'N'
     C                   ENDIF
     C*
     C     DDNPMD        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr (Idx) = 'DDNPMD'
 
      * Error : M/D ind may not be entered if reference for 9997 portfolio has been input.
 
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1135'
     C                   EVAL      DDNPMDOK  = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C** FX Rate must be entered if M/D indicator is entered
     C*
     C     DDNPXR        IFEQ      *BLANKS
     C     DDNPMD        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr (Idx) = 'DDNPXR'
 
      * Error : FX Rate and a M/D indicator must be entered
 
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1136'
     C                   EVAL      DDNPXROK  = 'N'
     C                   EVAL      DDNPMDOK  = 'N'
     C                   END
     C*
     C** FX Rate must be entered if M/D indicator is entered
     C*
     C     DDNPXR        IFNE      *BLANKS
     C     DDNPMD        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr (Idx) = 'DDNPXR'
 
      * Error : FX Rate and a M/D indicator must be entered
 
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1144'
     C                   EVAL      DDNPXROK  = 'N'
     C                   EVAL      DDNPMDOK  = 'N'
     C                   END
     C*
     C** Check that valid FX rate input
     C*
     C     DDNPXROK      IFNE      'N'
     C     DDNPXR        ANDNE     *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDNPXR        ZFIELD
     C                   Z-ADD     5             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   MOVE      ZFIELD        WNPXR            13 8
     C     ZRTN          IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr (Idx) = 'DDNPXR'
 
      * Error : FX Rate must be numeric. The FX Rate entered must contain only
      *         numeric characters with a maximum of 5 integers and 8
      *         decimal places.
 
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1137'
     C                   EVAL      DDNPXROK  = 'N'
     C                   ENDIF
 
     C** Format amount for output to screen
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WNPXR         ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        DDNPXR
     C                   ENDIF
 
     C*  If details valid calculate FX cross rate on price date between
     C*  security nominal currency and portfolio currency
 
     C     DDNPXROK      IFNE      'N'
 
     C*  If settlement currency and portfolio currency are the same
     C*  set cross rate to 1 and multiply/divide indicator to 'M'
     C*  and skip straight to amount validation
 
     C     QATNMC        IFEQ      QAPTCY
     C                   MOVE      'M'           ZCRSMD
     C                   Z-ADD     1             ZCRSRT
     C                   GOTO      AMCHK
     C                   END
 
     C*   Obtain FX rate for trade date between settlement currency
     C*   and base currency for accounting
 
     C                   MOVE      QATNMC        HSEXCY            3
     C     HSEXKY        SETGT     PMHSEXPD
     C                   READP     PMHSEXPD                               33
 
     C     *IN33         IFEQ      '1'
     C     QATNMC        ORNE      Q8CCY
 
     C     HSEXKY        SETLL     PMHSEXPD
     C                   READ      PMHSEXPD                               33
 
     C     *IN33         IFEQ      '1'
     C     QATNMC        ORNE      Q8CCY
     C                   SETON                                        U7U8LR
     C                   MOVE      '01'          DBASE                           ************
     C                   MOVEL     'HSEXPD'      DBFILE                          * DATABASE *
     C                   MOVEL     QATNMC        DBKEY                           * ERROR 01 *
     C                   MOVE      PVDT          DBKEY                           ************
     C                   RETURN
     C                   END
     C                   END
     C*
     C*   Set up ZCCYCN with 'FROM' details for settlement currency
     C                   Z-ADD     Q8SPOT        ZRATEF
     C                   MOVE      Q8MDV1        ZMDINF
     C                   Z-ADD     Q8CDP         ZCDPF
     C                   MOVE      QATNMC        ZCCYF
     C*
     C*   Obtain FX rate for trade date between portfolio currency
     C*   and base currency for accounting
 
     C                   MOVE      QAPTCY        HSEXCY
     C     HSEXKY        SETGT     PMHSEXPD
     C                   READP     PMHSEXPD                               99
     C*
     C     *IN99         IFEQ      '1'
     C     QAPTCY        ORNE      Q8CCY
     C*
     C     HSEXKY        SETLL     PMHSEXPD
     C                   READ      PMHSEXPD                               99
     C*
     C     *IN99         IFEQ      '1'
     C     QAPTCY        ORNE      Q8CCY
     C                   SETON                                        U7U8LR
     C                   MOVE      '02'          DBASE                           ************
     C                   MOVEL     'HSEXPD'      DBFILE                          * DATABASE *
     C                   MOVEL     QAPTCY        DBKEY                           * ERROR 02 *
     C                   MOVE      PVDT          DBKEY                           ************
     C                   RETURN
     C                   END
     C                   END
 
     C*   Set up ZCCYCN with 'TO' details for portfolio currency
 
     C                   Z-ADD     Q8SPOT        ZRATET
     C                   MOVE      Q8MDV1        ZMDINT
     C                   Z-ADD     Q8CDP         ZCDPT
     C                   MOVE      QAPTCY        ZCCYT
     C*
     C*   Calculate cross rate between settlement currency and portfolio
     C*   currency using standard module ZCCYCN
 
     C                   Z-ADD     0             ZAMTF
     C                   CALLB     'ZCCYCN'
     C                   PARM                    ZAMTF            15 0
     C                   PARM                    ZCCYF            10
     C                   PARM                    ZCCYT             3
     C                   PARM                    ZRATEF           13 8
     C                   PARM                    ZRATET           13 8
     C                   PARM                    ZMDINF            1
     C                   PARM                    ZMDINT            1
     C                   PARM                    ZCDPF             1 0
     C                   PARM                    ZCDPT             1 0
     C                   PARM                    ZAMTT            15 0
     C                   PARM                    ZCRSRT           13 8
     C                   PARM                    ZCRSMD            1
 
     C*   If cross multiply/divide indicator entered on screen
     C*   different to that returned from ZCCY take inverse of entered
     C*   rate
 
     C     DDNPMD        IFNE      ZCRSMD
     C     1             DIV       ZCRSRT        ZCRSRT
     C                   END
     C*
     C*   If FX rate details blank output default rate calculated in
     C*   ZCCYCN to screen with warning error
 
     C     AMCHK         TAG
 
     C*   If FX rate details input on screen check that details entered
     C*   for trade date within 10% of cross rate on that day
     C*   calculate range of acceptable values
 
     C     ZCRSRT        DIV       10            WWRT10           13 8
     C     ZCRSRT        ADD       WWRT10        WWRTPS           13 8
     C     ZCRSRT        SUB       WWRT10        WWRTMS           13 8
 
     C*  Warning if FX Rate is not within +- 10%
     C*  of the nominal to Portfolio currency rate
 
     C     WNPXR         IFGT      WWRTPS
     C     WNPXR         ANDNE     WWNPXR
     C     WNPXR         ORLT      WWRTMS
     C     WNPXR         ANDNE     WWNPXR
 
      * Warning W06
     C                   ADD       1             WIdx
     C                   EVAL      WFLDNMXAR (WIdx) = 'DDNPXR'
 
      * Error : FX Rate must be numeric. The FX Rate entered must contain only
      *         numeric characters with a maximum of 5 integers and 8
      *         decimal places.
 
     C                   EVAL      WMSGIDXAR(WIdx) = 'MMA1138'
     C                   EVAL      DDNPXROK  = 'W'
     C                   Z-ADD     WNPXR         WWNPXR           13 8
     C                   ENDIF
 
     C                   ENDIF
 
     C*  M/D indicator must be 'M' or 'D' if FX Rate is entered
 
     C     DDNPXR        IFNE      *BLANKS
     C     DDNPMD        ANDNE     'M'
     C     DDNPMD        ANDNE     'D'
 
      * 211: Multiply/Divide indicator must be "M" or "D".
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr (Idx) = 'DDNPXR'
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1139'
     C                   EVAL      DDNPXROK  = 'N'
     C                   END
     C*
     C     DDNPXROK      IFNE      'N'
     C     DDNPMDOK      ANDNE     'N'
     C                   MOVE      DDNPMD        NPMD
     C*
     C     DDNPXR        IFEQ      *BLANKS
     C                   Z-ADD     0             NPXR
     C                   ELSE
     C                   Z-ADD     WNPXR         NPXR
     C                   END
     C*
     C     DDPPRC        IFEQ      *BLANKS
     C                   Z-ADD     0             PPRC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     EFXIN         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      * Multiply / divide indicator
     C                   PARM                    DDNPMD            1
      * Exchange Rate
     C                   PARM                    DDNPXR           14
      * Portfolio Reference
     C                   PARM                    DDPTFR            4
      * Price
     C                   PARM                    DDPPRC           16
      *
      ** ICD
      *
     C                   PARM                    FCR997            4
      ** Portfolio management indicator
     C                   PARM                    BGPFMG            1
      ** Nominal currency
     C                   PARM                    QATNMC            3
      ** Portfolio currency code
     C                   PARM                    QAPTCY            3
      ** Value Date
     C                   PARM                    PVDT              5 0
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXar
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXar
     C                   PARM                    WMsgDtXAR
      **  OK flags
      * Multiply / divide indicator
     C                   PARM                    DDNPMDOK          1
      * Exchange Rate
     C                   PARM                    DDNPXROK          1
      ** Exchange Rate (Nominl > Port)
     C                   PARM                    NPXR             13 8
      ** Nominal Portfolio Mult/Div Ind
     C                   PARM                    NPMD              1
      ** Price
     C                   PARM                    PPRC             15 8
      ** Warning on FX rate, if this is called more than once
     C                   PARM                    WWNPXR
 
     C     HSEXKY        KLIST
     C                   KFLD                    HSEXCY            3
     C                   KFLD                    PVDT
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************

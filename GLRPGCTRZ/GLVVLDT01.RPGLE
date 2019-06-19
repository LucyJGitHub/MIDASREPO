     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JE item value date (non-retail)')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVVLDT01  - Validate Journal Batch Entry Item               *
      *               Value Date (for Non-Retail Accounts)            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD052075           Date 07Jun19               *
      *  Prev Amend No. CGL150             Date 13Jul18               *
      *                 CGL149             Date 13Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD000091           Date 08May13               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244251             Date 23Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 TCA102             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL010             Date 08Nov99               *
      *                 CAP032 *Create     Date 21May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052075 - [CGL150] Warning message should be displayed when *
      *           the system defaults the value date.                 *
      *  CGL150 - Value date to back value date if prior to           *
      *           backvalue period                                    *
      *  CGL149 - Allow postings to be valued prior to the date       *
      *           account opened                                      *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  244251 - Validate value date correctly.                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TCA102 - Various errors on Journal Entry input (Recompile).  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL010 - Future Value Dated Journal Entries for Non-Retail   *
      *           Accounts.                                           *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
      *
      ** Account details (DS)
     D F1ACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(F1)
      *                                                                         CGL010
      ** GL ICD Details                                                         CGL010
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                    CGL010
     D SDGELRACCD    E                     EXTFLD(QQACCD)                                     CGL029
      *                                                                         CGL010
      ** Switchable Features Details File                                       CGL010
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CGL010
      *                                                                         CGL010
      ** DS for Access Object Programs                                          CGL010
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CGL010
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      ** Index for arrays of warning  message ids, etc.                                     MD052075
     D WIx             S              3P 0                                                  MD052075
      *                                                                         CGL010
      ** Maximum Forward Day Number Work Field                                  CGL010
     D WMaxFwDN        S                   LIKE(BJRDNB)                         CGL010
      *                                                                         CGL010
      ** Switchable feature CGL010 indicator                                    CGL010
     D CGL010          S              1A                                        CGL010
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIx                                        MD052075
     C                   Z-ADD     *ZERO         WVLDT             5 0
     C                   MOVEL     *BLANK        WNRFD             1
      *
      ** Validate Value Date.
      *
     C                   EXSR      SRProc
      *
     C     DDVldtOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C     CGL150        IFEQ      'Y'                                                        CGL150
     C                   EVAL      ZDAYNO = WVLDT                                             CGL150
     C                   EXSR      ZDATE2                                                     CGL150
     C                   EVAL      DDVLDT = *BLANKS                                           CGL150
     C                   MOVEL     ZDATE         DDVLDT                                       CGL150
     C                   ENDIF                                                                CGL150
     C                   Z-ADD     WVLDT         B2VLDT
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Validate Value Date for Non-Retail Accounts         *
      *                                                               *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *
     C     DDVLDT        IFEQ      *BLANKS
     C                   Z-ADD     BJRDNB        WVLDT
     C                   EVAL      ZDAYNO = WVLDT                                             244251
     C                   EXSR      ZDATE2                                                     244251
     C                   EVAL      DDVLDT = *BLANKS                                           244251
     C                   MOVEL     ZDATE         DDVLDT                                       244251
     C                   ELSE
      *
      ** Verify if entry is numeric.
      *
     C                   EXSR      SRValNum
     C                   ENDIF
      *
      ** If entry is numeric and is in valid format, perform
      ** Value Date Account validation.
      *
     C     DDVldtOK      IFEQ      'Y'
     C                   EXSR      SRValAct
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValNum - Validate if Entry is numeric                      *
      *                                                               *
      *****************************************************************
      *
     C     SRValNum      BEGSR
      *
     C                   MOVEL     DDVLDT        WDATE
     C                   CALL      'GL0131U'
     C                   PARM                    WDATE             6
      *
     C                   MOVEL     WDATE         WDATE2            7
     C                   MOVE      '0'           WDATE2
      *
     C                   TESTN                   WDATE2                 01
     C     *IN01         IFEQ      *ON
     C                   MOVEL     '0'           WDATE2
     C                   ENDIF
      *
     C                   TESTN                   WDATE2               01
     C     *IN01         IFEQ      *OFF
     C                   MOVE      'N'           DDVldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0109'     MsgIdXAr(Idx)
     C**********         MOVEL     DDVLDT        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVLDT))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVLDT)                   MD000091
      *
     C                   ELSE
      *
      ** If entry is numeric, check if in valid date format.
      *
     C                   MOVE      *BLANKS       WDNUM             6 0
     C                   MOVE      WDATE         WDNUM
     C                   Z-ADD     WDNUM         WDNUM2            6 0
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      WDATE         PDateIn           6
     C                   PARM                    PDaynoOut         5 0
     C                   PARM      BJDFIN        PDateFmt          1
     C                   PARM                    PError            1
      *
      ** Value Date is not in valid format.
      *
     C     PError        IFEQ      'Y'
     C                   MOVE      'N'           DDVldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0110'     MsgIdXAr(Idx)
     C**********         MOVEL     DDVLDT        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVLDT))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVLDT)                   MD000091
      *
     C                   ELSE
      *
     C                   Z-ADD     PDaynoOut     WVLDT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAct - Value Date Account validation                     *
      *                                                               *
      *****************************************************************
      *
     C     SRValAct      BEGSR
      *                                                                         CGL010
     C                   MOVE      *Blank        WALFU             1            CGL010
      *                                                                         CGL010
      ** If CGL010 is installed, set WALFU to 'Y' when either of the            CGL010
      ** conditions is satisfied                                                CGL010
      *                                                                         CGL010
     C                   IF        CGL010 = 'Y'                                 CGL010
     C                   IF        (B2ACTY = 'N') And (BKAFVN = 'Y') Or         CGL010
     C                             (B2ACTY = 'D') And (BKAFVD = 'Y') Or         CGL010
     C                             (B2ACTY = 'C') And (BKAFVC = 'Y') Or         CGL010
     C                             (B2ACTY = 'G') And (BKAFVG = 'Y')            CGL010
     C                   EVAL      WALFU = 'Y'                                  CGL010
     C                   ENDIF                                                  CGL010
     C                   ENDIF                                                  CGL010
      *
      ** Value Date is greater than rundate.
      *
     C     WVLDT         IFGT      BJRDNB
     C     CGL010        ANDEQ     'N'                                          CGL010
     C     CGL010        OREQ      'Y'                                          CGL010
     C     WVLDT         ANDGT     BJRDNB                                       CGL010
     C     WALFU         ANDEQ     *Blank                                       CGL010
     C                   MOVE      'N'           DDVldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0202'     MsgIdXAr(Idx)
     C                   ENDIF
      *                                                                         CGL010
      ** Value Date is greater than the maximum forward day number for          CGL010
      ** the non-retail account when CGL010 is installed, (Maximum for          CGL010
      ** ward day number is Rundate plus Number of days to Forward value in     CGL010
      ** GL ICD)                                                                CGL010
      *                                                                         CGL010
     C     WVLDT         IFGT      BJRDNB                                       CGL010
     C     WALFU         ANDEQ     'Y'                                          CGL010
     C                   EVAL      WMaxFwDN = BJRDNB + BKNDFV                   CGL010
     C     WVLDT         IFGT      WMaxFwDN                                     CGL010
     C                   MOVE      'N'           DDVldtOK                       CGL010
     C                   ADD       1             Idx                            CGL010
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)                 CGL010
     C                   MOVEL     'GLX0111'     MsgIdXAr(Idx)                  CGL010
     C**********         MOVEL     DDVLDT        MsgDtaXAr(Idx)                      CGL010 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVLDT))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVLDT)                   MD000091
     C                   ENDIF                                                  CGL010
     C                   ENDIF                                                  CGL010
      *
     C     DDVldtOK      IFEQ      'Y'
      *
      ** Value Date Account validation, extract back valuing period.
      *
     C     BJRDNB        SUB       BJBVPD        WBRUN             5 0
      *
     C     PAccount      IFEQ      '*ACID'
     C     PAccount      ANDEQ     '*NRFD'
     C     PAccount      ANDEQ     '*INVD'
     C     PAccount      ANDEQ     '*INCP'
     C                   MOVEL     'Y'           WNRFD
     C                   ENDIF
      *
     C     CGL150        IFEQ      'Y'                                                        CGL150
     C     WVLDT         ANDLT     WBRUN                                                      CGL150
     C     CGL150        OREQ      'Y'                                                      MD052075
     C     WVLDT         ANDEQ     WBRUN                                                    MD052075
     C     VDFLTF        ANDEQ     'Y'                                                      MD052075
     C                   Z-ADD     WBRUN         WVLDT                                        CGL150
     C                   MOVE      'Y'           VDFLTF                                     MD052075
     C                   MOVE      'W'           DDVldtOK                                   MD052075
     C                   ADD       1             WIx                                        MD052075
     C                   MOVEL     'DDVLDT'      WFldNmXAr(WIx)                             MD052075
     C                   MOVEL     'GLX1157'     WMsgIdXAr(WIx)                             MD052075
     C                   ENDIF                                                                CGL150
     C                   SELECT
      *
      ** If CEU013 is installed, Currency is an In Ccy,
      ** Account Code Type is Nostro and the Account is not
      ** found, the tests on Account dates are skipped.
      *
     C     CEU013        WHENEQ    'Y'
     C     PINCY         ANDEQ     'Y'
     C     B2ACTY        ANDEQ     'N'
     C     WNRFD         ANDEQ     'Y'
      *
      ** Value Date is before Date Account Opened.
      *
     C     F1DACO        WHENGT    WVLDT
     C     CGL149        ANDEQ     'N'                                                        CGL149
     C     F1DACO        ORGT      WVLDT                                                      CGL149
     C     WBRUN         ANDGT     WVLDT                                                      CGL149
     C     CGL149        ANDEQ     'Y'                                                        CGL149
     C     CGL149        IFEQ      'N'                                                        CGL149
     C                   MOVE      'N'           DDVldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0112'     MsgIdXAr(Idx)
     C**********         MOVEL     DDVLDT        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVLDT))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVLDT)                   MD000091
     C                   ELSE                                                                 CGL149
     C     CGL150        IFEQ      'N'                                                        CGL150
     C                   MOVE      'N'           DDVldtOK                                     CGL149
     C                   ADD       1             Idx                                          CGL149
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)                               CGL149
     C                   MOVEL     'GLX0113'     MsgIdXAr(Idx)                                CGL149
     C                   MOVEL     DDVLDT        MsgDtaXAr(Idx)                               CGL149
     C                   ENDIF                                                                CGL150
     C                   ENDIF                                                                CGL149
      *
      ** Value Date is before computed backvalue date.
      *
     C     WVLDT         WHENLT    WBRUN
     C                   MOVE      'N'           DDVldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVLDT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0113'     MsgIdXAr(Idx)
     C**********         MOVEL     DDVLDT        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVLDT))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVLDT)                   MD000091
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Value Date
     C                   PARM                    DDVLDT            6
      *
      ** In Currency flag
     C                   PARM                    PINCY             1
      *
      ** Account flag
     C                   PARM                    PAccount          5
      *
      ** Account details (DS)
     C                   PARM                    F1ACCT
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN            1
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD            3 0
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Account Posting Narrative feature
     C                   PARM                    CEU013            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning flds/message IDs/message data (arrays) from/to caller                      MD052075
     C                   PARM                    WFldNmXAr                                  MD052075
     C                   PARM                    WMsgIDXAr                                  MD052075
     C                   PARM                    WMsgDtXAr                                  MD052075
      ** CGL150 Default Value Date 'Y'                                                      MD052075
     C                   PARM                    VDFLTF            1                        MD052075
      *
      ** Value Date - OK indicator
     C                   PARM                    DDVldtOK          1
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *                                                                         CGL010
      ** Access Switchable Features file to check if CGL010 is                  CGL010
      ** installed.                                                             CGL010
      *                                                                         CGL010
     C                   CALL      'AOSARDR0'                                   CGL010
     C                   PARM      *Blanks       @Rtcd                          CGL010
     C                   PARM      '*KEY   '     @Optn                          CGL010
     C                   PARM      'CGL010'      WSard             6            CGL010
     C     SCSARD        PARM      SCSARD        DSFDY                          CGL010
      *                                                                         CGL010
     C                   IF        @Rtcd = *Blank                               CGL010
     C                   EVAL      CGL010 = 'Y'                                 CGL010
     C                   ELSE                                                   CGL010
     C                   EVAL      CGL010 = 'N'                                 CGL010
     C                   ENDIF                                                  CGL010
      *                                                                                       CGL149
      ** Access Switchable Features file to check if CGL149 is                                CGL149
      ** installed.                                                                           CGL149
      *                                                                                       CGL149
     C                   CALL      'AOSARDR0'                                                 CGL149
     C                   PARM      *Blanks       @Rtcd                                        CGL149
     C                   PARM      '*KEY   '     @Optn                                        CGL149
     C                   PARM      'CGL149'      WSard                                        CGL149
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL149
      *                                                                                       CGL149
     C                   IF        @Rtcd = *Blank                                             CGL149
     C                   MOVE      'Y'           CGL149            1                          CGL149
     C                   ELSE                                                                 CGL149
     C                   MOVE      'N'           CGL149                                       CGL149
     C                   ENDIF                                                                CGL149
      *                                                                                       CGL150
      ** Access Switchable Features file to check if CGL150 is                                CGL150
      ** installed                                                                            CGL150
      *                                                                                       CGL150
     C                   CALL      'AOSARDR0'                                                 CGL150
     C                   PARM      *Blanks       @Rtcd                                        CGL150
     C                   PARM      '*KEY   '     @Optn                                        CGL150
     C                   PARM      'CGL150'      WSard                                        CGL150
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL150
      *                                                                                       CGL150
     C                   IF        @Rtcd = *Blank                                             CGL150
     C                   MOVE      'Y'           CGL150            1                          CGL150
     C                   ELSE                                                                 CGL150
     C                   MOVE      'N'           CGL150                                       CGL150
     C                   ENDIF                                                                CGL150
      *                                                                         CGL010
      ** Access General Ledger details                                          CGL010
      *                                                                         CGL010
     C**********         CALL      'AOGELRR0'                                   CGL010        CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *Blanks       @Rtcd                          CGL010
     C                   PARM      '*FIRST '     @Optn                          CGL010
     C*****SDGELR        PARM      SDGELR        DSFDY                          CGL010        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *                                                                         CGL010
      ** Error accessing GL ICD file                                            CGL010
      *                                                                         CGL010
     C                   IF        @Rtcd <> *Blank                              CGL010
     C                   EVAL      DBFILE = 'SDGELRPD'                          CGL010
     C                   EVAL      DBASE = 001                                  CGL010
     C                   EVAL      DBKEY = @Optn                                CGL010
     C                   EXSR      *PSSR                                        CGL010
     C                   ENDIF                                                  CGL010
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                                  244251
      *****************************************************************                       244251
      *                                                               *                       244251
      * ZDATE2 - Format a date for output                             *                       244251
      *                                                               *                       244251
      *****************************************************************                       244251
     C     ZDATE2        BEGSR                                                                244251
                                                                                              244251
     C                   CALLB     'ZDATE2'                                                   244251
     C                   PARM                    ZDAYNO            5 0                        244251
     C                   PARM                    BJDFIN                                       244251
     C                   PARM                    ZDATE             6 0                        244251
     C                   PARM                    ZADATE            7                          244251
                                                                                              244251
     C                   ENDSR                                                                244251
      *****************************************************************                       244251
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001

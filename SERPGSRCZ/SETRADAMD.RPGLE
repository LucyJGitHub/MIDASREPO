     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trades amend/change checking')                *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADAMD - Trades Amend/Change Checking                     *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended trade against those currently on file.    *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             It can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 17May13               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR869264A          Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11197           Date 25Apr06               *
      *                 BUG8820            Date 11Nov05               *
      *                 BUG8612            Date 10Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 BUG8101            Date 04Aug05               *
      *                 BUG6918            Date 20May05               *
      *                 CAP084             Date 10Jul03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 178695             Date 29Jun00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 175216             Date 12Sep00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 07Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 10Aug98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR869264A - Allow change of value in Charge Code/Amount 7    *
      *              field when Stamp Tax feature is enabled          *
      *  BUG11197- Settlement Ex-rate and M/D indicator should        *
      *            default when ccy changes.                          *
      *  BUG8820- Use ZCMPAMTS to compare days adjusted fields        *
      *  BUG8612- Don't format DDITRN when blanks and the file field  *
      *           has not been formatted                              *
      *  CGL031 - Taxation of Savings Income (Recompiled)             *
      *  BUG8101- Use ZCMPAMTS to compare Interest Amount             *
      *  BUG6918- Use ZCMPAMTS to compare amount fields               *
      *  CAP084 - Use ZCMPAMTS to compare Nominal                     *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  178695 - Protect Amend of Portfolio Reference                *
      *  175216 - Add additional field for "Standing Instructions     *
      *           Override" missed at SWIFT 98 change. Compile only.  *
      *  CSE006 - Repurchase Agreements (REPOs) enhancement           *
      *  CAP003 - Conversion of Midas inputs into modular structure   *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      * (Current) Trade in Screen Format - Primary Details
     D CurTrPrim     E DS                  EXTNAME(SETRPRPD)
     D                                     PREFIX(@)
      * (Current) Trade in Screen Format - Secondary Details
     D CurTrSeco     E DS                  EXTNAME(SETRSEPD)
     D                                     PREFIX(@)
      * (Current) Trade in Screen Format - Third screen details                               CAS006
     D CurTrThir     E DS                  EXTNAME(SETRTHPD)                                  CAS006
     D                                     PREFIX(@)                                          CAS006
      * (Current) Trade in Screen Format - Exchange Rates Details
     D CurTrExch     E DS                  EXTNAME(SETREXPD)
     D                                     PREFIX(@)
      * (Current) Trade in Screen Format - Settlement Instructions
     D CurTrSett     E DS                  EXTNAME(SETRSTPD)
     D                                     PREFIX(@)
     D @DDCLTY2      E                     EXTFLD(DDCLTY)
      * (Current) Trade in Screen Format - Charges/Commissions
     D CurTrChCm     E DS                  EXTNAME(SETRCCPD)
     D                                     PREFIX(@)
      * (Current) Trade in Screen Format - SWIFT 'A' Details
     D CurTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@A)
      * (Current) Trade in Screen Format - SWIFT 'B' Details
     D CurTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@B)
 
 
      * New Trade in Screen Format - Primary Details
     D NewTrPrim     E DS                  EXTNAME(SETRPRPD)
      * New Trade in Screen Format - Secondary Details
     D NewTrSeco     E DS                  EXTNAME(SETRSEPD)
      * New Trade in Screen Format - Third screen details                                     CAS006
     D NewTrThir     E DS                  EXTNAME(SETRTHPD)                                  CAS006
      * New Trade in Screen Format - Exchange Rate Details
     D NewTrExch     E DS                  EXTNAME(SETREXPD)
      * New Trade in Screen Format - Settlement Details
     D NewTrSett     E DS                  EXTNAME(SETRSTPD)
     D DDCLTY2       E                     EXTFLD(DDCLTY)
      * New Trade in Screen Format - Charge & Commission Details
     D NewTrChCm     E DS                  EXTNAME(SETRCCPD)
      * New Trade in Screen Format - SWIFT 'A' Details
     D NewTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A)
      * New Trade in Screen Format - SWIFT 'B' Details
     D NewTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B)
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      **  Data structure for Portfolio Management ICD File
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *                                                                         CSE006
      ** Book details                                                           CSE006
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)                    CSE006
                                                                                CSE006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSE006
      ** EXTERNAL DS FOR SAR DETAILS                                            CSE006
                                                                                CSE006
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
     D CAS006          S              1                                                       CAS006
     D SetCcyDec       S              1  0                                                    CAS006
     D WrkNum          S             15  0                                                    CAS006
                                                                                              CAS006
      ** Parameters for ZASIGN/ZSEDIT                                                         CAS006
     D ZFLD15          S             15  0                                                    CAS006
     D ZDECS           S              1  0                                                    CAS006
     D ZECODE          S              1                                                       CAS006
     D ZOUT21          S             21                                                       CAS006
     D ZFLD17          S             17                                                       CAS006
     D ZSDIG           S              2  0                                                    CAS006
     D ZSDCSP          S              1                                                       CAS006
     D ZOUT15          S             15                                                       CAS006
     D ZFSIGN          S              1                                                       CAS006
     D ZAsignOK        S              1                                                       CAS006
 
      * Error indicators
     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
     D OKTrSeco      E DS                  EXTNAME(SEETRSEPD)
     D OKTrThir      E DS                  EXTNAME(SEETRTHPD)                                 CAS006
     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
     D DDCLTY2OK     E                     EXTFLD(DDCLTYOK)
     D OKTrChcm      E DS                  EXTNAME(SEETRCCPD)
     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
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
      *
      * Error message issued
      *
     C     DDACTN        IFEQ      'A'
     C                   MOVEL     'SEA0001'     @ERRMSG           7
     C                   ELSE
     C                   MOVEL     'SEA0002'     @ERRMSG
     C                   END
      *
      * Initialize "check" indicators
      *
     C                   MOVEL     'N'           CHK_PORTFL        1
     C                   MOVEL     'N'           CHK_SETTLE        1
     C                   MOVEL     'N'           CHK_DELIVR        1
      *
      * If completed trade or if bank portfolios, portfolio reference
      * can't be amended or changed.
      *
     C     BJRDNB        IFGT      C_TDMC
     C     C_TINC        ANDEQ     'C'
     C     BGPFMG        ANDEQ     'Y'                                          178695
     C     BGN4ST        OREQ      'Y'                                          178695
     C     BJRDNB        ANDGT     C_TDMC                                       178695
     C     C_TINC        ANDEQ     'C'                                          178695
     C     FCPORS        OREQ      'B'
     C     BGPFMG        ANDEQ     'Y'                                          178695
     C                   MOVEL     'Y'           CHK_PORTFL
     C                   END
      *
      * If internal customer, settlement & delivery instructions
      * can't be amended or changed.
      *
     C     CustClass     IFEQ      'I'
     C                   MOVEL     'Y'           CHK_SETTLE
     C                   MOVEL     'Y'           CHK_DELIVR
     C                   ENDIF
      *
      * If completed trade, delivery instructions
      * can't be amended.
      *
     C     DDACTN        IFEQ      'A'
     C     BJRDNB        ANDGT     C_TDMC
     C     C_TINC        ANDEQ     'C'
     C                   MOVEL     'Y'           CHK_DELIVR
     C                   ENDIF
      *
      **  Compare fields with "amended" values or "changed" values.
      *
     C                   EXSR      COMPFLD
      *
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
      *
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
      *
      *  If any errors were found:
      *  - and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLD
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * COMPFLD  - Compare certain fields on the current trade        *
      *            with those "amended" or "changed".                 *
      *****************************************************************
     C     COMPFLD       BEGSR
      *
      ** Bulk Reference
     C     DDBLKR        IFNE      @DDBLKR
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBLKR'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDBLKR'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDBLKR'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      ddBLKRok        = 'N'
     C                   ENDIF
      *
      ** Security Shortname
     C     DDSESN        IFNE      @DDSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDSESN'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDSESN'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      ddSESNok        = 'N'
     C                   ENDIF
      *
      ** Customer
     C     DDCNUM        IFNE      @DDCNUM
     C     DDACTN        ANDEQ     'A'
     C     C_TINC        ANDNE     'I'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCNUM'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDCNUM'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDCNUM'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      ddCNUMok        = 'N'
     C                   ENDIF
      *
      ** Incomplete Ind.
     C     DDINCS        IFNE      @DDINCS
     C     DDACTN        ANDEQ     'A'
     C     C_TINC        ANDNE     'I'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINCS'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDINCS'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDINCS'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      ddINCSok        = 'N'
     C                   ENDIF
      *
      ** Trade Type
     C     DDTDTP        IFNE      @DDTDTP
     C     DDACTN        ANDEQ     'A'
     C     C_TINC        ANDNE     'I'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTDTP'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTDTP'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTDTP'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      ddTDTPok        = 'N'
     C                   ENDIF
      *
      ** Nominal
     C*****DDNOML        IFNE      @DDNOML                                                    CAP084
     C                   CALLB     'ZCMPAMTS'                                                 CAP084
     C                   PARM      DDNOML        ZCMPAMT1         25                          CAP084
     C                   PARM      @DDNOML       ZCMPAMT2         25                          CAP084
     C                   PARM      'N'           ZCMPAMTDif        1                          CAP084
                                                                                              CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                                        CAP084
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNOML'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDNOML'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDNOML'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      ddNOMLok        = 'N'
     C                   ENDIF
      *
      **  Price/Discount/Yield
     C     DDTPDY        IFNE      @DDTPDY
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTPDY'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTPDY'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTPDY'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      ddTPDYok        = 'N'
     C                   ENDIF
      *
      ** Trade value date
     C     DDTDVD        IFNE      @DDTDVD
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTDVD'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTDVD'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTDVD'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      ddTDVDok        = 'N'
     C                   ENDIF
      *
      ** Booking branch
     C     DDBRCD        IFNE      @DDBRCD
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRCD'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDBRCD'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDBRCD'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      ddBRCDok        = 'N'
     C                   ENDIF
      *
      ** Book
     C     DDBPBK        IFNE      @DDBPBK
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBPBK'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDBPBK'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDBPBK'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      ddBPBKok        = 'N'
     C                   ENDIF
      *
      ** Settlement Currency
     C     DDSETC        IFNE      @DDSETC
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSETC'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDSETC'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDSETC'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDSETCok        = 'N'
     C                   ENDIF
      *
      ** Reallowance
     C     DDRALL        IFNE      @DDRALL
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRALL'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDRALL'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDRALL'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDRALLok        = 'N'
     C                   ENDIF
      *
      ** Price
     C     DDPRIC        IFNE      @DDPRIC
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPRIC'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDPRIC'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDPRIC'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDPRICok        = 'N'
     C                   ENDIF
      *
      * Ex-Dividend Indicator
     C     DDEXDV        IFNE      @DDEXDV
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEXDV'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDEXDV'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDEXDV'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDEXDVok        = 'N'
     C                   ENDIF
      *
      ** Booking profit centre
     C     DDBPRC        IFNE      @DDBPRC
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBPRC'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDBPRC'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDBPRC'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDBPRCok        = 'N'
     C                   ENDIF
      *
      ** Transaction profit centre
     C     DDTPRC        IFNE      @DDTPRC
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTPRC'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTPRC'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTPRC'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTPRCok        = 'N'
     C                   ENDIF
      *
      ** Trade Date
     C     DDTDDT        IFNE      @DDTDDT
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTDDT'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTDDT'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTDDT'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTDDTok        = 'N'
     C                   ENDIF
      *
      ** Trade Sub Type
     C     DDTSUB        IFNE      @DDTSUB
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTSUB'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTSUB'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTSUB'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTSUBok        = 'N'
     C                   ENDIF
      *
      ** Market Indicator
     C     DDTDMI        IFNE      @DDTDMI
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTDMI'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTDMI'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTDMI'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTDMIok        = 'N'
     C                   ENDIF
      *
      ** Accrued Indicator
     C     DDACIN        IFNE      @DDACIN
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACIN'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDACIN'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDACIN'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDACINok        = 'N'
     C                   ENDIF
      *
      ** Days Adjustment
     C*****DDDADJ        IFNE      @DDDADJ                                                   BUG8820
     C                   CALLB     'ZCMPAMTS'                                                BUG8820
     C                   PARM      DDDADJ        ZCMPAMT1         25                         BUG8820
     C                   PARM      @DDDADJ       ZCMPAMT2         25                         BUG8820
     C                   PARM      'N'           ZCMPAMTDif        1                         BUG8820
                                                                                             BUG8820
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG8820
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDADJ'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDDADJ'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDDADJ'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDDADJok        = 'N'
     C                   ENDIF
      *
      ** Act/Diff Indicator
     C     DDACTD        IFNE      @DDACTD
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTD'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDACTD'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDACTD'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDACTDok        = 'N'
     C                   ENDIF
      *
      ** Interest Amount
     C*****DDITRA        IFNE      @DDITRA                                                   BUG8101
     C                   CALLB     'ZCMPAMTS'                                                BUG8101
     C                   PARM      DDITRA        ZCMPAMT1                                    BUG8101
     C                   PARM      @DDITRA       ZCMPAMT2                                    BUG8101
     C                   PARM      'N'           ZCMPAMTDif                                  BUG8101
                                                                                             BUG8101
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG8101
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDITRA'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDITRA'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDITRA'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDITRAok        = 'N'
     C                   ENDIF
      *
      * Settlement Method
     C     DDSMTH        IFNE      @DDSMTH
     C     CHK_SETTLE    ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSMTH'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDSMTH'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDSMTH'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDSMTHok        = 'N'
     C                   ENDIF
      *
      * Pay From
     C     DDPYFM        IFNE      @DDPYFM
     C     CHK_SETTLE    ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPYFM'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDPYFM'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDPYFM'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDPYFMok        = 'N'
     C                   ENDIF
      *
      * Pay From Branch
     C     DDPYFB        IFNE      @DDPYFB
     C     CHK_SETTLE    ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPYFB'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDPYFB'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDPYFB'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDPYFBok        = 'N'
     C                   ENDIF
      *
      * Pay To
     C     DDPAYT        IFNE      @DDPAYT
     C     CHK_SETTLE    ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPAYT'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDPAYT'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDPAYT'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDPAYTok        = 'N'
     C                   ENDIF
      *
      * Pay To Branch
     C     DDPYTB        IFNE      @DDPYTB
     C     CHK_SETTLE    ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPYTB'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDPYTB'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDPYTB'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDPYTBok        = 'N'
     C                   ENDIF
      *
      * For Account of (Pay To)
     C     DDTDFA        IFNE      @DDTDFA
     C     CHK_SETTLE    ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTDFA'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTDFA'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTDFA'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTDFAok        = 'N'
     C                   ENDIF
      *
      * Account Sequence Number
     C     DDASNM        IFNE      @DDASNM
     C     CHK_SETTLE    ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDASNM'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDASNM'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDASNM'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDASNMok        = 'N'
     C                   ENDIF
      *
      * Deliver From
     C     DDDELF        IFNE      @DDDELF
     C     CHK_DELIVR    ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDELF'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDDELF'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDDELF'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDDELFok        = 'N'
     C                   ENDIF
      *
      * Deliver To
     C     DDDELT        IFNE      @DDDELT
     C     CHK_DELIVR    ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDELT'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDDELT'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDDELT'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDDELTok        = 'N'
     C                   ENDIF
      *
      * For A/C of (Deliver from)
     C     DDDFFA        IFNE      @DDDFFA
     C     CHK_DELIVR    ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDFFA'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDDFFA'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDDFFA'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDDFFAok        = 'N'
     C                   ENDIF
      *
      * For Account of (Deliver To)
     C     DDDTFA        IFNE      @DDDTFA
     C     CHK_DELIVR    ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDTFA'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDDTFA'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDDTFA'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDDTFAok        = 'N'
     C                   ENDIF
      *
      * Clearance Type
     C     DDCLTY2       IFNE      @DDCLTY2
     C     CHK_DELIVR    ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCLTY2'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDCLTY2'                              MD000091
     C                   EVAL      MsgDtaTmp = 'DDCLTY2'                                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDCLTY2ok       = 'N'
     C                   ENDIF
      *
      * Broker commission code
     C     DDTBCC        IFNE      @DDTBCC
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTBCC'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTBCC'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTBCC'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTBCCok        = 'N'
     C                   ENDIF
      *
      * Broker commission amount
     C*****DDTBCA        IFNE      @DDTBCA                                                   BUG6918
     C                   CALLB     'ZCMPAMTS'                                                BUG6918
     C                   PARM      DDTBCA        ZCMPAMT1                                    BUG6918
     C                   PARM      @DDTBCA       ZCMPAMT2                                    BUG6918
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6918
                                                                                             BUG6918
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6918
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTBCA'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTBCA'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTBCA'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTBCAok        = 'N'
     C                   ENDIF
      *
      * Customer commission code
     C     DDTCCC        IFNE      @DDTCCC
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCCC'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCCC'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCCC'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCCCok        = 'N'
     C                   ENDIF
      *
      * Customer commission amount
     C*****DDTCCA        IFNE      @DDTCCA                                                   BUG6918
     C                   CALLB     'ZCMPAMTS'                                                BUG6918
     C                   PARM      DDTCCA        ZCMPAMT1                                    BUG6918
     C                   PARM      @DDTCCA       ZCMPAMT2                                    BUG6918
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6918
                                                                                             BUG6918
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6918
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCCA'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCCA'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCCA'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCCAok        = 'N'
     C                   ENDIF
      *
      * Charge Code 1
     C     DDTCC1        IFNE      @DDTCC1
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCC1'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCC1'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCC1'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCC1ok        = 'N'
     C                   ENDIF
      *
      * Charge Amount 1
     C*****DDTCA1        IFNE      @DDTCA1                                                   BUG6918
     C     DDTCA1        IFNE      @DDTCA1                                                  BUG11197
                                                                                            BUG11197
     C                   CALLB     'ZCMPAMTS'                                                BUG6918
     C                   PARM      DDTCA1        ZCMPAMT1                                    BUG6918
     C                   PARM      @DDTCA1       ZCMPAMT2                                    BUG6918
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6918
                                                                                             BUG6918
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6918
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCA1'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCA1'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCA1'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCA1ok        = 'N'
     C                   ENDIF
                                                                                            BUG11197
     C                   ENDIF                                                              BUG11197
      *
      * Charge Code 2
     C     DDTCC2        IFNE      @DDTCC2
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCC2'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCC2'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCC2'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCC2ok        = 'N'
     C                   ENDIF
      *
      * Charge Amount 2
     C*****DDTCA2        IFNE      @DDTCA2                                                   BUG6918
     C     DDTCA2        IFNE      @DDTCA2                                                  BUG11197
                                                                                            BUG11197
     C                   CALLB     'ZCMPAMTS'                                                BUG6918
     C                   PARM      DDTCA2        ZCMPAMT1                                    BUG6918
     C                   PARM      @DDTCA2       ZCMPAMT2                                    BUG6918
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6918
                                                                                             BUG6918
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6918
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCA2'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCA2'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCA2'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCA2ok        = 'N'
     C                   ENDIF
                                                                                            BUG11197
     C                   ENDIF                                                              BUG11197
      *
      * Charge Code 3
     C     DDTCC3        IFNE      @DDTCC3
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCC3'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCC3'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCC3'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCC3ok        = 'N'
     C                   ENDIF
      *
      * Charge Amount 3
     C*****DDTCA3        IFNE      @DDTCA3                                                   BUG6918
     C     DDTCA3        IFNE      @DDTCA3                                                  BUG11197
                                                                                            BUG11197
     C                   CALLB     'ZCMPAMTS'                                                BUG6918
     C                   PARM      DDTCA3        ZCMPAMT1                                    BUG6918
     C                   PARM      @DDTCA3       ZCMPAMT2                                    BUG6918
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6918
                                                                                             BUG6918
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6918
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCA3'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCA3'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCA3'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCA3ok        = 'N'
     C                   ENDIF
                                                                                            BUG11197
     C                   ENDIF                                                              BUG11197
      *
      * Charge Code 4
     C     DDTCC4        IFNE      @DDTCC4
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCC4'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCC4'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCC4'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCC4ok        = 'N'
     C                   ENDIF
      *
      * Charge Amount 4
     C*****DDTCA4        IFNE      @DDTCA4                                                   BUG6918
     C     DDTCA4        IFNE      @DDTCA4                                                  BUG11197
                                                                                            BUG11197
     C                   CALLB     'ZCMPAMTS'                                                BUG6918
     C                   PARM      DDTCA4        ZCMPAMT1                                    BUG6918
     C                   PARM      @DDTCA4       ZCMPAMT2                                    BUG6918
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6918
                                                                                             BUG6918
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6918
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCA4'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCA4'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCA4'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCA4ok        = 'N'
     C                   ENDIF
                                                                                            BUG11197
     C                   ENDIF                                                              BUG11197
      *
      * Charge Code 5
     C     DDTCC5        IFNE      @DDTCC5
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCC5'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCC5'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCC5'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCC5ok        = 'N'
     C                   ENDIF
      *
      * Charge Amount 5
     C*****DDTCA5        IFNE      @DDTCA5                                                   BUG6918
     C     DDTCA5        IFNE      @DDTCA5                                                  BUG11197
                                                                                            BUG11197
     C                   CALLB     'ZCMPAMTS'                                                BUG6918
     C                   PARM      DDTCA5        ZCMPAMT1                                    BUG6918
     C                   PARM      @DDTCA5       ZCMPAMT2                                    BUG6918
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6918
                                                                                             BUG6918
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6918
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCA5'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCA5'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCA5'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCA5ok        = 'N'
     C                   ENDIF
                                                                                            BUG11197
     C                   ENDIF                                                              BUG11197
      *
      * Charge Code 6
     C     DDTCC6        IFNE      @DDTCC6
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCC6'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCC6'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCC6'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCC6ok        = 'N'
     C                   ENDIF
      *
      * Charge Amount 6
     C*****DDTCA6        IFNE      @DDTCA6                                                   BUG6918
     C     DDTCA6        IFNE      @DDTCA6                                                  BUG11197
                                                                                            BUG11197
     C                   CALLB     'ZCMPAMTS'                                                BUG6918
     C                   PARM      DDTCA6        ZCMPAMT1                                    BUG6918
     C                   PARM      @DDTCA6       ZCMPAMT2                                    BUG6918
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6918
                                                                                             BUG6918
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6918
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCA6'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCA6'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCA6'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCA6ok        = 'N'
     C                   ENDIF
                                                                                            BUG11197
     C                   ENDIF                                                              BUG11197
      *
      * Charge Code 7
     C     DDTCC7        IFNE      @DDTCC7
     C     DDACTN        ANDEQ     'A'
     C     CER049        ANDEQ     'N'                                                     AR869264A
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCC7'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCC7'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCC7'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCC7ok        = 'N'
     C                   ENDIF
      *
      * Charge Amount 7
     C*****DDTCA7        IFNE      @DDTCA7                                                   BUG6918
     C     DDTCA7        IFNE      @DDTCA7                                                  BUG11197
                                                                                            BUG11197
     C                   CALLB     'ZCMPAMTS'                                                BUG6918
     C                   PARM      DDTCA7        ZCMPAMT1                                    BUG6918
     C                   PARM      @DDTCA7       ZCMPAMT2                                    BUG6918
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6918
                                                                                             BUG6918
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6918
     C     DDACTN        ANDEQ     'A'
     C     CER049        ANDEQ     'N'                                                     AR869264A
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTCA7'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTCA7'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTCA7'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTCA7ok        = 'N'
     C                   ENDIF
                                                                                            BUG11197
     C                   ENDIF                                                              BUG11197
      *
      ** Tax Amount
     C*****DDTAXA        IFNE      @DDTAXA                                                   BUG6918
     C                   CALLB     'ZCMPAMTS'                                                BUG6918
     C                   PARM      DDTAXA        ZCMPAMT1                                    BUG6918
     C                   PARM      @DDTAXA       ZCMPAMT2                                    BUG6918
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6918
                                                                                             BUG6918
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6918
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTAXA'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTAXA'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTAXA'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTAXAok        = 'N'
     C                   ENDIF
      *
      ** Rebate :Brok Com
     C*****DDBCMR        IFNE      @DDBCMR                                                   BUG6918
     C                   CALLB     'ZCMPAMTS'                                                BUG6918
     C                   PARM      DDBCMR        ZCMPAMT1                                    BUG6918
     C                   PARM      @DDBCMR       ZCMPAMT2                                    BUG6918
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6918
                                                                                             BUG6918
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6918
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBCMR'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDBCMR'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDBCMR'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDBCMRok        = 'N'
     C                   ENDIF
      *
      ** Rebate: Cust Com
     C*****DDCCMR        IFNE      @DDCCMR                                                   BUG6918
     C                   CALLB     'ZCMPAMTS'                                                BUG6918
     C                   PARM      DDCCMR        ZCMPAMT1                                    BUG6918
     C                   PARM      @DDCCMR       ZCMPAMT2                                    BUG6918
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6918
                                                                                             BUG6918
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6918
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCCMR'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDCCMR'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDCCMR'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDCCMRok        = 'N'
     C                   ENDIF
      *
      ** Rebate: Tax
     C*****DDTXRB        IFNE      @DDTXRB                                                   BUG6918
     C                   CALLB     'ZCMPAMTS'                                                BUG6918
     C                   PARM      DDTXRB        ZCMPAMT1                                    BUG6918
     C                   PARM      @DDTXRB       ZCMPAMT2                                    BUG6918
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6918
                                                                                             BUG6918
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6918
     C     DDACTN        ANDEQ     'A'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTXRB'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDTXRB'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDTXRB'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDTXRBok        = 'N'
     C                   ENDIF
      *
      ** Portfolio Ref
     C     DDPTFR        IFNE      @DDPTFR
     C     CHK_PORTFL    ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDPTFR'                               MD000091
     C                   EVAL      MsgDtaTmp = 'DDPTFR'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDPTFRok        = 'N'
     C                   ENDIF
      *                                                                         CSE006
      *** If the book is not a buy-sell book then no new processing is          CSE006
      *** required                                                              CSE006
      *                                                                         CSE006
     C                   IF        CSE006 = 'Y'                                 CSE006
      *                                                                         CSE006
     C                   CALL      'AOBOOKR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD             7            CSE006
     C                   PARM      '*KEY   '     @OPTN             7            CSE006
     C                   PARM      DDBPBK        @BOOK             2            CSE006
     C     SDBOOK        PARM      SDBOOK        DSFDY                          CSE006
      *                                                                         CSE006
     C                   IF        BDBYSL = 'Y'                                 CSE006
     C                   IF        DDLKRF <> @DDLKRF                            CSE006
     C                   ADD       1             Idx                            CSE006
     C                   EVAL      FldNameArr(Idx) = 'DDLKRF'                   CSE006
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG                    CSE006
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDLKRF'                        CSE006 MD000091
     C                   EVAL      MsgDtaTmp = 'DDLKRF'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF                                                  CSE006
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
     C                   ENDIF                                                  CSE006
                                                                                              CAS006
      ** Convert the new amount fields to the same format as that                             CAS006
      ** of the existing trade so as to compare them correctly                                CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
     C                   IF        DDCRSK <> *BLANKS                                          CAS006
     C                   MOVE      DDCRSK        ZFLD17                                       CAS006
     C                   Z-ADD     7             ZSDIG                                        CAS006
     C                   Z-ADD     8             ZDECS                                        CAS006
     C                   EXSR      SRASIGN                                                    CAS006
                                                                                              CAS006
     C                   IF        ZAsignOK = 'Y'                                             CAS006
     C                   MOVE      ZOUT15        WrkNum                                       CAS006
     C     ZFSIGN        IFEQ      '-'                                                        CAS006
     C                   Z-SUB     WrkNum        WrkNum                                       CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   MOVE(P)   WrkNum        ZFLD15                                       CAS006
     C                   EXSR      SRZSEdit                                                   CAS006
     C                   MOVE      ZOUT21        DDCRSK                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        DDLQPR <> *BLANKS                                          CAS006
     C                   MOVE      DDLQPR        ZFLD17                                       CAS006
     C                   Z-ADD     7             ZSDIG                                        CAS006
     C                   Z-ADD     8             ZDECS                                        CAS006
     C                   EXSR      SRASIGN                                                    CAS006
                                                                                              CAS006
     C                   IF        ZAsignOK = 'Y'                                             CAS006
     C                   MOVE      ZOUT15        WrkNum                                       CAS006
     C     ZFSIGN        IFEQ      '-'                                                        CAS006
     C                   Z-SUB     WrkNum        WrkNum                                       CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   MOVE(P)   WrkNum        ZFLD15                                       CAS006
     C                   EXSR      SRZSEdit                                                   CAS006
     C                   MOVE      ZOUT21        DDLQPR                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C     13            SUB       SetCcyDec     ZSDIG                                        CAS006
     C                   Z-ADD     SetCcyDec     ZDECS                                        CAS006
                                                                                              CAS006
     C                   IF        DDITRN <> *BLANKS                                          CAS006
     C                   MOVE(P)   DDITRN        ZFLD17                                       CAS006
     C                   EXSR      SRASIGN                                                    CAS006
                                                                                              CAS006
     C                   IF        ZAsignOK = 'Y'                                             CAS006
     C                   MOVE      ZOUT15        WrkNum                                       CAS006
     C     ZFSIGN        IFEQ      '-'                                                        CAS006
     C                   Z-SUB     WrkNum        WrkNum                                       CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   MOVE(P)   WrkNum        ZFLD15                                       CAS006
     C                   EXSR      SRZSEdit                                                   CAS006
     C                   MOVE      ZOUT21        DDITRN                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   If        DDITRN <> *blanks                                         BUG8612
     C                             and @DDITRN <> *Blanks                                    BUG8612
     C                   MOVE      *ZERO         ZFLD15                                       CAS006
     C                   EXSR      SRZSEdit                                                   CAS006
     C                   MOVE      ZOUT21        DDITRN                                       CAS006
     C                   EndIf                                                               BUG8612
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Interest Amount using Net Treasury Rate                                              CAS006
                                                                                              CAS006
     C                   IF        DDITRN <> @DDITRN  AND  DDACTN = 'A'                       CAS006
     C                   ADD       1             Idx                                          CAS006
     C                   EVAL      FldNameArr(Idx) = 'DDITRN'                                 CAS006
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG                                  CAS006
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDITRN'                        CAS006 MD000091
     C                   EVAL      MsgDtaTmp = 'DDITRN'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDITRNok        = 'N'                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Credit Risk Spread                                                                   CAS006
                                                                                              CAS006
     C                   IF        DDCRSK <> @DDCRSK  AND  DDACTN = 'A'                       CAS006
     C                   ADD       1             Idx                                          CAS006
     C                   EVAL      FldNameArr(Idx) = 'DDCRSK'                                 CAS006
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG                                  CAS006
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDCRSK'                        CAS006 MD000091
     C                   EVAL      MsgDtaTmp = 'DDCRSK'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDCRSKok        = 'N'                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Liquidity Premium                                                                    CAS006
                                                                                              CAS006
     C                   IF        DDLQPR <> @DDLQPR  AND  DDACTN = 'A'                       CAS006
     C                   ADD       1             Idx                                          CAS006
     C                   EVAL      FldNameArr(Idx) = 'DDLQPR'                                 CAS006
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG                                  CAS006
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDLQPR'                        CAS006 MD000091
     C                   EVAL      MsgDtaTmp = 'DDLQPR'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      DDLQPRok        = 'N'                                      CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLD - Reset fields in Error                              *
      *****************************************************************
     C     RESETFLD      BEGSR
      *
      * Reset fields in error to 'current' values
      *
     C     DDBLKROK      IFEQ      'N'
     C                   MOVEL     @DDBLKR       DDBLKR
     C                   END
     C     DDSESNOK      IFEQ      'N'
     C                   MOVEL     @DDSESN       DDSESN
     C                   END
     C     DDCNUMOK      IFEQ      'N'
     C                   MOVEL     @DDCNUM       DDCNUM
     C                   END
     C     DDINCSOK      IFEQ      'N'
     C                   MOVEL     @DDINCS       DDINCS
     C                   END
     C     DDTDTPOK      IFEQ      'N'
     C                   MOVEL     @DDTDTP       DDTDTP
     C                   END
     C     DDNOMLOK      IFEQ      'N'
     C                   MOVEL     @DDNOML       DDNOML
     C                   END
     C     DDTPDYOK      IFEQ      'N'
     C                   MOVEL     @DDTPDY       DDTPDY
     C                   END
     C     DDTDVDOK      IFEQ      'N'
     C                   MOVEL     @DDTDVD       DDTDVD
     C                   END
     C     DDBRCDOK      IFEQ      'N'
     C                   MOVEL     @DDBRCD       DDBRCD
     C                   END
     C     DDBPBKOK      IFEQ      'N'
     C                   MOVEL     @DDBPBK       DDBPBK
     C                   END
     C     DDSETCOK      IFEQ      'N'
     C                   MOVEL     @DDSETC       DDSETC
     C                   END
     C     DDRALLOK      IFEQ      'N'
     C                   MOVEL     @DDRALL       DDRALL
     C                   END
     C     DDPRICOK      IFEQ      'N'
     C                   MOVEL     @DDPRIC       DDPRIC
     C                   END
     C     DDEXDVOK      IFEQ      'N'
     C                   MOVEL     @DDEXDV       DDEXDV
     C                   END
     C     DDBPRCOK      IFEQ      'N'
     C                   MOVEL     @DDBPRC       DDBPRC
     C                   END
     C     DDTPRCOK      IFEQ      'N'
     C                   MOVEL     @DDTPRC       DDTPRC
     C                   END
     C     DDTDDTOK      IFEQ      'N'
     C                   MOVEL     @DDTDDT       DDTDDT
     C                   END
     C     DDTSUBOK      IFEQ      'N'
     C                   MOVEL     @DDTSUB       DDTSUB
     C                   END
     C     DDTDMIOK      IFEQ      'N'
     C                   MOVEL     @DDTDMI       DDTDMI
     C                   END
     C     DDACINOK      IFEQ      'N'
     C                   MOVEL     @DDACIN       DDACIN
     C                   END
     C     DDDADJOK      IFEQ      'N'
     C                   MOVEL     @DDDADJ       DDDADJ
     C                   END
     C     DDACTDOK      IFEQ      'N'
     C                   MOVEL     @DDACTD       DDACTD
     C                   END
     C     DDITRAOK      IFEQ      'N'
     C                   MOVEL     @DDITRA       DDITRA
     C                   END
     C     DDSMTHOK      IFEQ      'N'
     C                   MOVEL     @DDSMTH       DDSMTH
     C                   END
     C     DDPYFMOK      IFEQ      'N'
     C                   MOVEL     @DDPYFM       DDPYFM
     C                   END
     C     DDPYFBOK      IFEQ      'N'
     C                   MOVEL     @DDPYFB       DDPYFB
     C                   END
     C     DDPAYTOK      IFEQ      'N'
     C                   MOVEL     @DDPAYT       DDPAYT
     C                   END
     C     DDPYTBOK      IFEQ      'N'
     C                   MOVEL     @DDPYTB       DDPYTB
     C                   END
     C     DDTDFAOK      IFEQ      'N'
     C                   MOVEL     @DDTDFA       DDTDFA
     C                   END
     C     DDASNMOK      IFEQ      'N'
     C                   MOVEL     @DDASNM       DDASNM
     C                   END
     C     DDDELFOK      IFEQ      'N'
     C                   MOVEL     @DDDELF       DDDELF
     C                   END
     C     DDDELTOK      IFEQ      'N'
     C                   MOVEL     @DDDELT       DDDELT
     C                   END
     C     DDDFFAOK      IFEQ      'N'
     C                   MOVEL     @DDDFFA       DDDFFA
     C                   END
     C     DDDTFAOK      IFEQ      'N'
     C                   MOVEL     @DDDTFA       DDDTFA
     C                   END
     C     DDCLTY2OK     IFEQ      'N'
     C                   MOVEL     @DDCLTY2      DDCLTY2
     C                   END
     C     DDTBCCOK      IFEQ      'N'
     C                   MOVEL     @DDTBCC       DDTBCC
     C                   END
     C     DDTBCAOK      IFEQ      'N'
     C                   MOVEL     @DDTBCA       DDTBCA
     C                   END
     C     DDTCCCOK      IFEQ      'N'
     C                   MOVEL     @DDTCCC       DDTCCC
     C                   END
     C     DDTCCAOK      IFEQ      'N'
     C                   MOVEL     @DDTCCA       DDTCCA
     C                   END
     C     DDTCC1OK      IFEQ      'N'
     C                   MOVEL     @DDTCC1       DDTCC1
     C                   END
     C     DDTCA1OK      IFEQ      'N'
     C                   MOVEL     @DDTCA1       DDTCA1
     C                   END
     C     DDTCC2OK      IFEQ      'N'
     C                   MOVEL     @DDTCC2       DDTCC2
     C                   END
     C     DDTCA2OK      IFEQ      'N'
     C                   MOVEL     @DDTCA2       DDTCA2
     C                   END
     C     DDTCC3OK      IFEQ      'N'
     C                   MOVEL     @DDTCC3       DDTCC3
     C                   END
     C     DDTCA3OK      IFEQ      'N'
     C                   MOVEL     @DDTCA3       DDTCA3
     C                   END
     C     DDTCC4OK      IFEQ      'N'
     C                   MOVEL     @DDTCC4       DDTCC4
     C                   END
     C     DDTCA4OK      IFEQ      'N'
     C                   MOVEL     @DDTCA4       DDTCA4
     C                   END
     C     DDTCC5OK      IFEQ      'N'
     C                   MOVEL     @DDTCC5       DDTCC5
     C                   END
     C     DDTCA5OK      IFEQ      'N'
     C                   MOVEL     @DDTCA5       DDTCA5
     C                   END
     C     DDTCC6OK      IFEQ      'N'
     C                   MOVEL     @DDTCC6       DDTCC6
     C                   END
     C     DDTCA6OK      IFEQ      'N'
     C                   MOVEL     @DDTCA6       DDTCA6
     C                   END
     C     DDTCC7OK      IFEQ      'N'
     C                   MOVEL     @DDTCC7       DDTCC7
     C                   END
     C     DDTCA7OK      IFEQ      'N'
     C                   MOVEL     @DDTCA7       DDTCA7
     C                   END
     C     DDTAXAOK      IFEQ      'N'
     C                   MOVEL     @DDTAXA       DDTAXA
     C                   END
     C     DDBCMROK      IFEQ      'N'
     C                   MOVEL     @DDBCMR       DDBCMR
     C                   END
     C     DDCCMROK      IFEQ      'N'
     C                   MOVEL     @DDCCMR       DDCCMR
     C                   END
     C     DDTXRBOK      IFEQ      'N'
     C                   MOVEL     @DDTXRB       DDTXRB
     C                   END
     C     DDPTFROK      IFEQ      'N'
     C                   MOVEL     @DDPTFR       DDPTFR
     C                   END
     C     DDLKRFOK      IFEQ      'N'                                          CSE006
     C                   MOVEL     @DDLKRF       DDLKRF                         CSE006
     C                   ENDIF                                                  CSE006
     C                   IF        DDCRSKok = 'N'                                             CAS006
     C                   EVAL      DDCRSK = @DDCRSK                                           CAS006
     C                   ENDIF                                                                CAS006
     C                   IF        DDLQPRok = 'N'                                             CAS006
     C                   EVAL      DDLQPR = @DDLQPR                                           CAS006
     C                   ENDIF                                                                CAS006
     C                   IF        DDITRNok = 'N'                                             CAS006
     C                   EVAL      DDITRN = @DDITRN                                           CAS006
     C                   ENDIF                                                                CAS006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRASIGN - Call ZASIGN                                        *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     C     SRASIGN       BEGSR                                                                CAS006
                                                                                              CAS006
     C                   CALLB     'ZASIGN'                                                   CAS006
     C                   PARM                    ZASIGNok                                     CAS006
     C                   PARM                    ZFLD17                                       CAS006
     C                   PARM                    ZSDIG                                        CAS006
     C                   PARM                    ZDECS                                        CAS006
     C                   PARM                    ZSDCSP                                       CAS006
     C                   PARM                    ZOUT15                                       CAS006
     C                   PARM                    ZFSIGN                                       CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRZSEdit - Edit a signed field                               *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     C     SRZSEdit      BEGSR                                                                CAS006
                                                                                              CAS006
     C                   EVAL      ZECODE = *BLANK                                            CAS006
                                                                                              CAS006
     C                   CALLB     'ZSEDIT'                                                   CAS006
     C                   PARM                    ZFLD15                                       CAS006
     C                   PARM                    ZDECS                                        CAS006
     C                   PARM                    ZECODE                                       CAS006
     C                   PARM                    ZOUT21                                       CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * New Trade in Screen Format :
 Form * - Primary Details
      * - Secondary Details
      * - Exchange Rate Details
      * - Settlement Details
      * - Charge & Commission Details
      * - SWIFT Details A
      * - SWIFT Details B
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrThir                                    CAS006
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrChCm
     C                   PARM                    NewTrSwftA
     C                   PARM                    NewTrSwftB
      *
      * (Current) Trade in Screen Format :
 Form * - Primary Details
      * - Secondary Details
      * - Exchange Rates Details
      * - Settlement Instructions
      * - Charges/Commissions
      * - SWIFT Details A
      * - SWIFT Details B
     C                   PARM                    CurTrPrim
     C                   PARM                    CurTrSeco
     C                   PARM                    CurTrThir                                    CAS006
     C                   PARM                    CurTrExch
     C                   PARM                    CurTrSett
     C                   PARM                    CurTrChCm
     C                   PARM                    CurTrSwftA
     C                   PARM                    CurTrSwftB
      *
      * Customer classification
      * Trade incomplete ind
      * Trade Date Made Complete
     C                   PARM                    CustClass         1
     C                   PARM                    C_TINC            1
     C                   PARM                    C_TDMC            5 0
                                                                                              CAS006
      ** Settlement Currency Decimal Places                                                   CAS006
                                                                                              CAS006
     C                   PARM                    SetCcyDec                                    CAS006
                                                                                              CAS006
      ** Switchable features                                                                  CAS006
                                                                                              CAS006
     C                   PARM                    CAS006                                       CAS006
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKTrPrim
     C                   PARM                    OKTrSeco
     C                   PARM                    OKTrThir                                     CAS006
     C                   PARM                    OKTrExch
     C                   PARM                    OKTrSett
     C                   PARM                    OKTrChCm
     C                   PARM                    OKTrSwft
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADAMD'   DBPGM
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
      **
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** PORTFOLIO MANAGEMENT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C                   END
      *                                                                         CSE006
      *** Check if switchable feature CSE006 is on.                             CSE006
      *                                                                         CSE006
     C                   CALL      'AOSARDR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD                          CSE006
     C                   PARM      '*VERIFY'     @OPTN                          CSE006
     C                   PARM      'CSE006'      @SARD                          CSE006
     C     SCSARD        PARM      SCSARD        DSFDY                          CSE006
      *                                                                         CSE006
      *** Check for Database error                                              CSE006
      *                                                                         CSE006
     C     @RTCD         IFNE      *BLANKS                                      CSE006
     C     @RTCD         ANDNE     '*NRF   '                                    CSE006
     C                   MOVEL     'CSE006'      DBKEY                          CSE006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE006
     C                   MOVEL     '903'         DBASE                          CSE006
     C                   EXSR      *PSSR                                        CSE006
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
     C     @RTCD         IFEQ      *BLANK                                       CSE006
     C                   MOVE      'Y'           CSE006            1            CSE006
     C                   ELSE                                                   CSE006
     C                   MOVE      'N'           CSE006                         CSE006
     C                   ENDIF                                                  CSE006
      *                                                                                    AR869264A
      *** Check if switchable feature CER049 is on.                                        AR869264A
      *                                                                                    AR869264A
     C                   CALL      'AOSARDR0'                                              AR869264A
     C                   PARM      *BLANKS       @RTCD                                     AR869264A
     C                   PARM      '*VERIFY'     @OPTN                                     AR869264A
     C                   PARM      'CER049'      @SARD                                     AR869264A
     C     SCSARD        PARM      SCSARD        DSFDY                                     AR869264A
      *                                                                                    AR869264A
      *** Check for Database error                                                         AR869264A
      *                                                                                    AR869264A
     C     @RTCD         IFNE      *BLANKS                                                 AR869264A
     C     @RTCD         ANDNE     '*NRF   '                                               AR869264A
     C                   MOVEL     'CER049'      DBKEY                                     AR869264A
     C                   MOVEL     'SCSARDPD'    DBFILE                                    AR869264A
     C                   MOVEL     '904'         DBASE                                     AR869264A
     C                   EXSR      *PSSR                                                   AR869264A
     C                   ENDIF                                                             AR869264A
      *                                                                                    AR869264A
     C     @RTCD         IFEQ      *BLANK                                                  AR869264A
     C                   MOVE      'Y'           CER049            1                       AR869264A
     C                   ELSE                                                              AR869264A
     C                   MOVE      'N'           CER049                                    AR869264A
     C                   ENDIF                                                             AR869264A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Date for Taxable Transactions')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTAXDATE - Validate Date for Taxable Transaction           *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 16May13               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 CGL035             Date 01Mar05               *
      *                 235434             Date 09Aug05               *
      *                 234998             Date 26Jul05               *
      *                 235546 (reopen)    Date 17Aug05               *
      *                 235546             Date 27Jul05               *
      *                 234616             Date 01Jul05               *
      *                 234599             Date 01Jul05               *
      *                 234577             Date 30Jun05               *
      *                 234552             Date 26Jun05               *
      *                 234440  *CREATE    Date 22Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  235434 - Allow Deletion when record not found on ETCPOSND.   *
      *         - Allow amendment of Trade date if resulting Trade    *
      *           is still the last Trade.                            *
      *  234998 - Allow Authorisation of 'Delete' & 'Insert'.         *
      *  235546 - Change of Value Date problems                       *
      *           Always default market centre if blank               *
      *  235546 - EU Tax backvaluations                               *
      *  234616 - Do no block authorisation                           *
      *  234599 - Unnecessary database errors occurring               *
      *  234577 - Do not block Amendments.                            *
      *  234552 - Check for Joint Account Type = 'N'                  *
      *           and other corrections                               *
      *  234440 - Any input, amendment or reversal of backvalued      *
      *           transactions are blocked if they are prior to a     *
      *           previous, unreversed transaction for a security     *
      *           that is taxable and a customer who is liable for tax*
      *                                                               *
      *****************************************************************
 
     FETCPOSL0  IF   E           K DISK    INFSR(*PSSR)
 
     FETCPOSL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ETCPOSNDF:ETCPOSL3F)
     FPMPORTLL  IF   E           K DISK                                                       WA0001
     FSDBRCHL0  IF   E           K DISK    INFSR(*pssr)                                       234599
     FTRADS     IF   E           K DISK    INFSR(*pssr)                                       234998
     F                                     PREFIX(TR_)                                        234998
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the SE standard declares
     D/COPY SECPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
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
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(SEC_)
 
      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D CUST_DFAC     E                     EXTFLD(QQDFAC)                                     CGL035
 
      ** External DS for Securities Clients
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** External DS for Location Code
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
 
      ** External DS for Country of Tax Code
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
                                                                                              234552
      ** External DS for Midas modules details                                                234552
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  234552
                                                                                              234552
      ** Portfolio ICD                                                                        234552
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                                  234552
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D*ArDate**********S              5P 0 DIM(10)                                            234552
     D*ArType**********S              2A   DIM(10)                                            234552
     D ArType          S              1A   DIM(10)                                            234552
     D ArTRef          S              6A   DIM(10)
                                                                                              234552
      ** The following /COPY includes the customer details data structure                     234552
     D/COPY SECPYSRC,SE_CUSTDT                                                                234552
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input Parameters
 
      ** Output Parameters
 
      ** Working Variables
     D*WCust****       S              6S 0                                                   CSD027A
     D WCust           S              6A                                                     CSD027A
     D TaxFlag         S              1A
     D*MsgDta**********S            256A                                                      234552
     D*MsgDta***       S             45A                                             234552 MD000091
      ** Add 24 Alpha to accomodate 12 Bytes for error code                                 MD000091
     D MsgDta          S             69A                                                    MD000091
     D MsgDta2         S              5A                                                      234552
     D WCNCD           S                   LIKE(DVCNCD)
     D WCOLC           S                   LIKE(BBCOLC)                                       233038
     D KTmst           S             26Z
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
      ** Copy of User's record Timestamp.                                                  235434
     D CurTmst         S                   LIKE(TMST)                                      235434
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *                                                                                     MD000091
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
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
     C                   MOVE      *BLANK        ArType                                       234552
     C                   MOVE      *BLANKS       ArTRef                                       234552
     C                   MOVE      *BLANKS       ErrorFlag                                    234552
 
      ** Retrieve customer details
 
     C                   EXSR      SRRtvCustDet
                                                                                              234552
      ** Default details if required                                                          234552
                                                                                              234552
     C                   EXSR      Default                                                    234552
                                                                                              234552
     C                   Z-ADD     PDate         WDate                                        234552
     C                   IF        PDate < EWEDT1                                             234552
     C                   Z-ADD     EWEDT1        WDate                                        234552
     C                   ENDIF                                                                234552
 
      ** Check if validation is needed
 
     C                   MOVEL     WCust         PCUST                                        WA0002
     C                   CALL      'SECHECKTAX'                                               WA0002
     C                   PARM      *BLANKS       RetCodeIn                                    WA0002
     C                   PARM                    PCUST             6                          WA0002
     C                   PARM      *BLANKS       Taxable           1                          WA0002
                                                                                              WA0002
     C*****************  IF        SEC_SETX = 'Y' and TaxFlag = 'Y'                           WA0002
     C*****************  IF        BFCLAS = 'S' OR BFCLAS = 'D'                               WA0002
     C                   IF        Taxable = 'Y'                                              WA0002
     C                   EXSR      Validate
     C                   ENDIF
     C*****************  ENDIF                                                                WA0002
      *
      ** If an error was found, set the return code appropriately
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * Validate - Validation                                         *
      *                                                               *
      *****************************************************************
 
     C     Validate      BEGSR
 
      ** If Insert, just have to check for transactions after input date
 
     C                   IF        WAction = 'I'
     C     KEYCP0        SETGT     ETCPOSL0
     C                   EXSR      Check
 
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'N'           FieldOK           1
     C                   EVAL      MsgDta = *BLANKS                                           234552
     C                   EVAL      MsgDta2 = *BLANKS                                          234552
                                                                                              234552
     C     WDefault      IFEQ      'Y'                                                        234552
     C                   ADD       1             WIx                                          234552
     C                   MOVEL     WField        WFldNmXAr(WIx)                               234552
     C                   MOVEL     'SEA0918'     WMsgIdXAr(WIx)                               234552
     C                   EVAL      MsgDta2 = WMrk + WPtfr                                     234552
     C                   EVAL      MsgDtaTmp =  WMrk                                        MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   EVAL      MsgDtaTmp =  WPtfr                                       MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(WIx) = WMsgDtXAr(WIx)                          MD000091
     C                                             + LenStr +%TRIM(MsgDtaTmp)               MD000091
     C                   ELSE                                                                 234552
     C**********         ADD       1             Idx                                          235546
     C**********         MOVEL     WField        FldNamXAr(Idx)                               235546
     C**********         MOVEL     'SEC0917'     MsgIdXAr(Idx)                                234552
     C**********         MOVEL     'SEA0917'     MsgIdXAr(Idx)                         234552 235546
     C                   ADD       1             WIx                                          235546
     C                   MOVEL     WField        WFldNmXAr(WIx)                               235546
     C                   MOVEL     'SEA0917'     WMsgIdXAr(WIx)                               235546
     C                   ENDIF                                                                234552
 
     C                   Z-ADD     0             COUNT2            3 0
     C                   EVAL      MsgDta = MsgDta2                                           235546
     C     COUNT2        DOWLT     COUNT
     C                   ADD       1             COUNT2
     C**********         EVAL      MsgDta = MsgDta + ArType(COUNT2)                           234552
     C**********                                   + ArTRef(COUNT2)                           234552
     C**********         EVAL      MsgDta = MsgDta2 + ArType(COUNT2)                   234552 235546
     C**********                                   + ArTRef(COUNT2)                    234552 235546
     C     ArType(COUNT2)CAT       ArTRef(COUNT2)WrkDta            7                          235546
     C                   CAT       WrkDta:0      MsgDTA                                       235546
      *                                                                                     MD000091
     C                   MOVEL(P)  ArType(COUNT2)MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %Trim(WMsgDtXAr(WIx))                   MD000091
     C                                + LenStr + %Trim(MsgDtaTmp)                           MD000091
     C                   MOVEL(P)  ArTRef(COUNT2)MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %Trim(WMsgDtXAr(WIx))                   MD000091
     C                                + LenStr + %Trim(MsgDtaTmp)                           MD000091
      *                                                                                     MD000091
     C                   ENDDO
     C*****WDefault      IFEQ      'Y'                                                 234552 235546
     C**********         MOVEL     MsgDta        WMsgDtXAr(WIx)                      234552 MD000091
     C**********         ELSE                                                          234552 235546
     C**********         MOVEL     MsgDta        MsgDtaXAr(Idx)                               235546
     C**********         ENDIF                                                         234552 235546
     C                   ENDIF
 
      ** Else have to check for transactions after input timestamp
 
     C                   ELSE
     C                   IF        WAction <> 'A' AND WType = 'T'                             234577
     C                             AND WAction <> 'Y'                                         234616
     C                             OR WType = 'D'                                             234577
     C     KEYCP3        CHAIN     ETCPOSL3                           40
     C******IN40         IFEQ      '1'                                                        234998
     C**********        *MOVEL     WType         DBKEY                                        234577
     C**********         MOVE      WTRef         DBKEY                                        234577
     C**********         EVAL      DBFILE = 'ETCPOSL3'                                        234577
     C**********         MOVEL     '001'         DBASE                                        234577
     C**********         EXSR      *PSSR                                                      234577
     C**********         CLEAR                   TMST                                  234577 235546
     C**********         ENDIF                                                                234998
     C                   CLEAR                   TMST                                         235546
 
      *   Determine Timestamp to use depending on User Action & CHTP.                         234998
     C                   Exsr      ChkLastAct                                                 234998
      *                                                                                       234998
     C     TMST          IfEq      *HIVAL                                                     234998
     C                   Eval      ErrorFlag=*Blank                                           234998
      *                                                                                       234998
     C                   Else                                                                 234998
     C                   MOVEL     TMST          KTMST
     C     KEYCPT        SETGT     ETCPOSL0
     C                   EXSR      Check
     C                   EndIf                                                                234998
 
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'N'           FieldOK
     C                   EVAL      MsgDta = *BLANKS                                           235546
     C**********         ADD       1             Idx                                          235546
     C**********         MOVEL     WField        FldNamXAr(Idx)                               235546
     C**********         MOVEL     'SEC0918'     MsgIdXAr(Idx)                                234552
     C**********         MOVEL     'SEA0919'     MsgIdXAr(Idx)                         234552 235546
     C                   ADD       1             WIx                                          235546
     C                   MOVEL     WField        WFldNmXAr(WIx)                               235546
     C                   MOVEL     'SEA0919'     WMsgIdXAr(WIx)                               235546
 
     C                   Z-ADD     0             COUNT2
     C     COUNT2        DOWLT     COUNT
     C                   ADD       1             COUNT2
     C**********         EVAL      MsgDta = MsgDta + ArType(COUNT2)                           234552
     C**********                                   + ArTRef(COUNT2)                           234552
     C**********         EVAL      MsgDta = ArType(COUNT2)                             234552 235546
     C**********                                   + ArTRef(COUNT2)                    234552 235546
     C     ArType(COUNT2)CAT       ArTRef(COUNT2)WrkDta            7                          235546
     C                   CAT       WrkDta:0      MsgDTA                                       235546
     C                   ENDDO
     C**********         MOVEL     MsgDta        MsgDtaXAr(Idx)                               235546
     C**********         MOVEL     MsgDta        WMsgDtXAr(WIx)                      235546 MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDta))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(MsgDta)                   MD000091
     C                   GOTO      EVal
     C                   ENDIF
     C                   ENDIF                                                                234577
     C                   ENDIF
 
     C     EVal          ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * Check    - Check if any transactions dated after this         *
      *                                                               *
      *****************************************************************
 
     C     Check         BEGSR
 
     C     KEYCP         READE     ETCPOSL0                               33
     C                   Z-ADD     0             COUNT             3 0
 
     C     *IN33         DOWEQ     '0'
     C*****COUNT         ANDLT     10                                                         234552
     C     COUNT         ANDLT     5                                                          234552
     C     TTYPE         IFNE      'O'                                                        234552
     C     WAction       ANDEQ     'I'                                                        234552
     C     WAction       ORNE      'I'                                                        234552
      *                                                                                       235434
      ** If Timestamp of record just read is the same as that of the User's record then       235434
      ** ignore this record as it is the same record, and proceed to check the next record.   235434
     C     CurTmst       IfEq      TMST                                                       235434
     C     KEYCP         READE     ETCPOSL0                               33                  235434
     C                   Iter                                                                 235434
     C                   EndIf                                                                235434
      *                                                                                       235434
     C                   MOVEL     'Y'           ErrorFlag         1
     C                   ADD       1             COUNT
     C**************     Z-ADD     CSDA          ArDate(Count)                                234552
     C                   MOVEL     TTYPE         ArType(Count)
     C                   MOVEL     TREF          ArTRef(Count)
     C                   ENDIF                                                                234552
     C     KEYCP         READE     ETCPOSL0                               33
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvCustDet - Retrieve Customer Details                      *
      *****************************************************************
     C     SRRtvCustDet  BEGSR
 
      ** Customer classification
 
     C                   MOVEL     WCust         @PCUST
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    @PCUST            6
     C     SDSECS        PARM      SDSECS        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C*******************EVAL      DBKEY = @PCUST                                             234599
     C*******************EVAL      DBFILE = 'SDSECSPD'                                        234599
     C*******************MOVEL     '912'         DBASE                                        234599
     C*******************EXSR      *PSSR                                                      234599
     C                   CLEAR                   SDSECS                                       234599
     C                   END
 
      ** Branch details
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WBrca         @DTDBA            3
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      **  Database Error
 
     C     PRTCD         IFNE      *BLANKS
     C*******************EVAL      DBKEY = WBrca                                              234599
     C*******************EVAL      DBFILE = 'SDBRCHPD'                                        234599
     C*******************MOVEL     '901'         DBASE                                        234599
     C*******************EXSR      *PSSR                                                      234599
     C     *LOVAL        SETLL     SDBRCHL0                                                   234599
     C                   READ      SDBRCHL0                                                   234599
     C                   ENDIF
 
      ** Country code details
 
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      A8LCCD        @DLCCD            3
     C     SDLOCN        PARM      SDLOCN        DSFDY
 
      **  Database Error
 
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = A8LCCD
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     *BLANK        @PKEY1
     C                   MOVEL     WCust         @PKEY1
 
      ** Customer details
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANK        PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    @PKEY1           10
     C                   PARM                    @PKYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database Error
 
     C     PRTCD         IFNE      *BLANK
     C*******************MOVEL     @PKYST        DBKEY                                        234599
     C*******************EVAL      DBFILE = 'SDCUSTPD'                                        234599
     C*******************MOVEL     '903'         DBASE                                        234599
     C*******************EXSR      *PSSR                                                      234599
     C                   CLEAR                   SDCUST                                       234599
     C                   ENDIF
      ** Tax basket
 
     C                   EVAL      WCNCD = DVCNCD
     C                   EVAL      WCOLC = BBCOLC                                             233038
 
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         @PCTRT            2
     C                   PARM      WCOLC         @PCTRR            2                          233038
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
     C                   IF        PRTCD = '*NRF   '
 
     C                   EVAL      WCOLC = *BLANK                                             233038
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         @PCTRT
     C                   PARM      WCOLC         @PCTRR                                       233038
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
      ** Database Error
 
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL     @PCTRT        DBKEY
     C                   MOVE      @PCTRR        DBKEY
     C                   EVAL      DBFILE = 'SDCTTXPD'
     C                   MOVEL     '904'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Tax rate
 
     C                   MOVE      'N'           TaxFlag
     C****************   Z-ADD     WDate         @PDATE                                 234552234577
     C****************   IF        WDate < EWEDT1                                       234552234577
     C                   Z-ADD     PDate         @PDATE                                 234552234577
     C                   IF        PDate < EWEDT1                                       234552234577
     C                   Z-ADD     EWEDT1        @PDATE                                       234552
     C                   ENDIF                                                                234552
 
     C                   CALL      'AOTXBSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         @PCRTT            7
     C                   PARM      EWTXBS        @PTXBS            2
     C****************   PARM      WDate         @PDATE            5 0                        234552
     C                   PARM                    @PDATE            5 0                        234552
     C                   PARM      *BLANK        @PNARR           15
     C                   PARM      *ZERO         @PRATE            6 4
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANK  AND
     C                             PRTCD <> '*NRF   '
     C                   MOVEL     @PCRTT        DBKEY
     C                   MOVE      @PTXBS        DBKEY
     C                   EVAL      DBFILE = 'SDTXBSPD'
     C                   MOVEL     '916'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANK
     C                   MOVE      'Y'           TaxFlag
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  234552
      *****************************************************************                       234552
      *                                                               *                       234552
      * Default  - Defaults values that are not filled in on the      *                       234552
      *            first call from trades                             *                       234552
      *                                                               *                       234552
      *****************************************************************                       234552
                                                                                              234552
     C     Default       BEGSR                                                                234552
                                                                                              234552
     C*****************  IF        WDefault = 'Y'                                       234552235546
                                                                                              234552
     C                   IF        WMrk = *BLANKS                                             234552
     C                   EVAL      WMrk = SEC_MKTI                                            234552
     C                   ENDIF                                                                234552
                                                                                              234552
     C                   IF        WDefault = 'Y'                                             235546
     C                   IF        WPtfr = '*NK '                                             234552
     C                   MOVEL     *BLANKS       WPtfr                                        234552
     C     BGPFMG        IFEQ      'Y'                                                        234552
     C     FCPORS        ANDNE     'B'                                                        234552
     C     CustPM        ANDEQ     'Y'                                                        234552
     C     CustPB        OREQ      'Y'                                                        234552
     C     BGN4ST        ANDEQ     'Y'                                                        234552
     C     WCust         SETLL     PMPORTLL                                                   234552
     C     WCust         READE     PMPORTLL                               44                  234552
     C     *IN44         IFEQ      *OFF                                                       234552
     C                   MOVEL     PNPTFR        WPtfr                                        234552
     C                   ENDIF                                                                234552
     C                   ENDIF                                                                234552
     C                   ENDIF                                                                234552
                                                                                              234552
     C                   ENDIF                                                                234552
                                                                                              234552
     C     EDef          ENDSR                                                                234552
      *****************************************************************                       234552
      /EJECT                                                                                  234998
      *****************************************************************                       234998
      *                                                               *                       234998
      * ChkLastAct - Trade found on ETCPOSND.                         *                       234998
      *              Determine what is being performed.               *                       234998
      *                                                               *                       234998
      *****************************************************************                       234998
                                                                                              234998
     C     ChkLastAct    BEGSR                                                                234998
                                                                                              234998
      *   Determine whether an authorisation is being performed and                           234998
      *   if so, what action is being authorised.                                             234998
                                                                                              234998
      * - If a Delete being performed do NOT reset the Timestamp to the time of the trade     234998
      *   on ETCPOSND.                                                                        234998
      * - If an Insert is being authorised then permit the authorisation                      234998
      *   without further checking ETCPOSL0.                                                  234998
      *                                                                                       234998
     C                   Select                                                               234998
     C     *IN40         WhenEq    *OFF                                                       234998
     C     WAction       AndEq     'D'                                                        234998
      *   Trade found & action is to Delete. Do not amend the timestamp.                      234998
      *                                                                                       234998
     C     *IN40         WhenEq    *OFF                                                       234998
     C     WAction       AndEq     'C'                                                        234998
      *   Trade found & action is to Change. Do not amend the timestamp.                      234998
      *                                                                                       234998
     C     *IN40         WhenEq    *OFF                                                       234998
     C     WAction       AndEq     'Y'                                                        234998
      *   Trade found & action is to Authorise.                                               234998
      *   -------------------------------------                                               234998
      *   Rtv. last change type from TRADS.                                                   234998
     C     WTRef         Chain     TRADS                              98                      234998
      *                                                                                       234998
     C                   Select                                                               234998
     C     *IN98         WhenEq    *OFF                                                       234998
     C     TR_CHTP       AndEq     'I'                                                        234998
      *   Permit authorisation in any order.                                                  234998
     C                   MOVE      *HIVAL        TMST                                         234998
      *                                                                                       234998
     C     *IN98         WhenEq    *OFF                                                       234998
     C     TR_CHTP       AndEq     'A'                                                        234998
      *   Do not amend the timestamp.                                                         234998
      *                                                                                       234998
     C     *IN98         WhenEq    *OFF                                                       234998
     C     TR_CHTP       AndEq     'C'                                                        234998
      *   Do not amend the timestamp. Do not permit authorisation in any order.               234998
      *                                                                                       234998
     C     *IN98         WhenEq    *ON                                                        234998
      *   Database Error.                                                                     234998
     C                   Eval      DbKey = TR_TDRF                                            234998
     C                   Eval      DbFile = 'TRADSD'                                          234998
     C                   Movel     '917'         DBase                                        234998
     C                   ExSr      *PSSR                                                      234998
      *                                                                                       234998
     C                   Other                                                                234998
      *   Do not permit authorisation in any order.                                           234998
     C                   CLEAR                   TMST                                         234998
     C                   EndSl                                                                234998
      *                                                                                       234998
      *                                                                                       234998
     C     *IN40         WhenEq    *ON                                                        234998
     C     WAction       AndEq     'Y'                                                        234998
      *   Trade not found & action is to authorise, so trade was deleted                      234998
      *    and the authorisation of a delete is requested -                                   234998
      *    therefore permit authorisation without checking ETCPOSL0.                          234998
     C                   MOVE      *HIVAL        TMST                                         234998
      *                                                                                       234998
     C     *IN40         WhenEq    *ON                                                        235434
     C     WAction       AndEq     'D'                                                        235434
      *   Trade not found & action is to delete, so record on ETCPOSND                        235434
      *    is not found for Transaction type & Trade reference.                               235434
      *    There may be a record with Trans Type ='O'.                                        235434
      *    Permit the deletion.                                                               235434
     C                   MOVE      *HIVAL        TMST                                         235434
      *                                                                                       235434
     C                   Other                                                                234998
      *   Do not permit action in any order.                                                  234998
     C                   CLEAR                   TMST                                         234998
     C                   EndSl                                                                234998
      *                                                                                       234998
      *   Note Timestamp on User's record.                                                    235434
     C                   Eval      CurTmst=Tmst                                               235434
      *                                                                                       235434
     C                   EndSr                                                                234998
      *****************************************************************                       234998
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Input Fields
 
     C                   PARM                    RetCodeIn
     C                   PARM                    WDefault          1                          234552
     C                   PARM                    WAction           1
     C                   PARM                    WBrca             3
     C                   PARM                    WCust
     C                   PARM                    WSesn            10
     C                   PARM                    WPtfr             4
     C                   PARM                    WMrk              1
     C                   PARM                    WType             1
     C                   PARM                    WTRef             6
     C*****************  PARM                    WDate             5 0                        234552
     C                   PARM                    PDate                                        234552
     C                   PARM                    WField           10
     C                   PARM                    SECTY
     C                   PARM                    CustDts                                      234552
 
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Average Purchase Date
 
     C                   PARM                    FieldOK
 
      ** Define key list for file
 
     C     KEYCP         KLIST
     C                   KFLD                    WBrca
     C                   KFLD                    WCust
     C                   KFLD                    WSesn
 
     C     KEYCP0        KLIST
     C                   KFLD                    WBrca
     C                   KFLD                    WCust
     C                   KFLD                    WSesn
     C                   KFLD                    WMrk
     C                   KFLD                    WPtfr
     C                   KFLD                    WDate
 
     C     KEYCPT        KLIST
     C                   KFLD                    WBrca
     C                   KFLD                    WCust
     C                   KFLD                    WSesn
     C                   KFLD                    WMrk
     C                   KFLD                    WPtfr
     C                   KFLD                    WDate
     C                   KFLD                    KTmst
 
     C     KEYCP3        KLIST
     C                   KFLD                    WType
     C                   KFLD                    WTRef
 
     C     *LIKE         DEFINE    CSDA          WDate
     C     *LIKE         DEFINE    CSDA          PDate                                        234552
      *
      ** GET MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Portfolio Management
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      ** DATABASE ERROR
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C                   END
 
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
**  CPY@
(c) Finastra International Limited 2005

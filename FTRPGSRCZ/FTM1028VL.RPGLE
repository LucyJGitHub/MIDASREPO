     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate 102 header screen 1')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1028VL - Validate MT102 header record (Screen 1)          *
      *                                                               *
      *  Function: This Program Validates FT MT102 Records for        *
      *            input to the Midas database.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10602           Date 16Feb06               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 15Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      *                 CSD009             Date 10Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178185             Date 26Apr00               *
      *                 CFT006  *CREATE    Date 17Nov99               *
      *                                    Date ddmmmyy               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - SWIFT 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
      *  178185 - Default sending institution with sender for 'BI'    *
      *  CFT006 - Funds Transfer/Swift Messages MT101/MT102           *
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
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD) PREFIX(D)
 
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for Branch Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long data structure
 
     D  @@Arr          S              1    DIM(4)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D GenOkFlag2      S              1    Export
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
     D #I              S              2  0
 
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CSW201
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Reset the OkFlagDS to be 'Y' each time it is called.
     C                   Reset                   OkFlagHs1
 
     C                   Eval      FldNameArr  =  *Blanks
     C                   Eval      MsgIDArr    =  *Blanks
     C                   Eval      MsgDtaArr   =  *Blanks
     C                   Eval      Idx         =  *Zeros
     C                   Eval      WFldNamArr  =  *Blanks
     C                   Eval      WMsgIDArr   =  *Blanks
     C                   Eval      WMsgDtaArr  =  *Blanks
     C                   Eval      WIdx        =  *Zeros
 
      /COPY WNCPYSRC,FT102HV001
      ** Get Default Values only on insert
     C                   Exsr      SrDefault
      /COPY WNCPYSRC,FT102HV002
 
      /COPY WNCPYSRC,FT102HV003
     C                   Exsr      SrPrompt
      /COPY WNCPYSRC,FT102HV004
 
      ** Call Validation Modules in Sequence if action code <> 'E'
     C                   If         ActionCode = 'I' or  ActionCode = 'A' or
     C                              ActionCode = 'X'
 
      /COPY WNCPYSRC,FT102HV005
      ** Validate File Reference
     C                   Exsr      SrFilR
      /COPY WNCPYSRC,FT102HV006
 
      /COPY WNCPYSRC,FT102HV007
      ** Validate CCT Type
     C                   Exsr      SrCct
      /COPY WNCPYSRC,FT102HV008
 
      /COPY WNCPYSRC,FT102HV009
      ** Validate CCT Sub-Type
     C                   Exsr      SrSubT
      /COPY WNCPYSRC,FT102HV010
 
      /COPY WNCPYSRC,FT102HV011
      ** Validate Booking Branch
     C                   Exsr      SrBBch
      /COPY WNCPYSRC,FT102HV012
 
      /COPY WNCPYSRC,FT102HV013
      ** Validate Originating Branch
     C                   Exsr      SrOBch
      /COPY WNCPYSRC,FT102HV014
 
      /COPY WNCPYSRC,FT102HV015
      ** Validate Book Code
     C                   Exsr      SrBCde
      /COPY WNCPYSRC,FT102HV016
 
      /COPY WNCPYSRC,FT102HV017
      ** Validate Profit Center
     C                   Exsr      SrPCtr
      /COPY WNCPYSRC,FT102HV018
 
      /COPY WNCPYSRC,FT102HV019
      ** Validate Swift Priority
     C                   Exsr      SrSwPy
      /COPY WNCPYSRC,FT102HV020
 
      /COPY WNCPYSRC,FT102HV021
      ** Validate Ordering Customer
     C                   Exsr      SrOCust
      /COPY WNCPYSRC,FT102HV022
 
      /COPY WNCPYSRC,FT102HV023
      ** Validate Ordering Institution
     C                   Exsr      SrOInst
      /COPY WNCPYSRC,FT102HV024
 
      /COPY WNCPYSRC,FT102HV025
      ** Validate Sending Institution
     C                   Exsr      SrSInt
      /COPY WNCPYSRC,FT102HV026
 
      /COPY WNCPYSRC,FT102HV027
      ** Validate Destination
     C                   Exsr      SrDest
      /COPY WNCPYSRC,FT102HV028
 
      /COPY WNCPYSRC,FT102HV029
      ** Validate Sender's Correspondent
     C                   Exsr      SrSndC
      /COPY WNCPYSRC,FT102HV030
 
      /COPY WNCPYSRC,FT102HV031
      ** Validate Receiver's Correspondent
     C                   Exsr      SrRcvC
      /COPY WNCPYSRC,FT102HV032
 
      /COPY WNCPYSRC,FT102HV033
      ** Validate Debit Value Date
     C                   Exsr      SrDVdt
      /COPY WNCPYSRC,FT102HV034
 
      /COPY WNCPYSRC,FT102HV035
      ** Validate Transfer Amount and Ccy
     C                   Exsr      SrTrAt
      /COPY WNCPYSRC,FT102HV036
 
      /COPY WNCPYSRC,FT102HV037
      ** Validate Total Transfer Value Date
     C                   Exsr      SrTrDt
      /COPY WNCPYSRC,FT102HV038
 
      /COPY WNCPYSRC,FT102HV039
      ** Validate Exchange Rate
     C                   Exsr      SrExRt
      /COPY WNCPYSRC,FT102HV040
 
      /COPY WNCPYSRC,FT102HV041
      ** Validate Sum of Amounts
     C* * * * * * * CH   Exsr      SrSAmt
      /COPY WNCPYSRC,FT102HV042
 
     C                   Endif
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrFilR - Validate File Reference                              *
      *****************************************************************
     C     SrFilr        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'FILREF'                           CAP084
     C                   Eval      DDSName = 'PFILREF'                          CAP084
     C                   CallB     'FTVRFHD01'   P#List
     C                   Eval      OkFLRF = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrCct - Validate CCT Type                                     *
      *****************************************************************
     C     SrCct         Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'CCTTYP'                           CAP084
     C                   Eval      DDSName = 'PCCTTYP'                          CAP084
     C                   CallB     'FTVCCHD01'   P#List
     C                   Eval      OkCCTP = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrSubt - Validate CCT Sub-Type                                *
      *****************************************************************
     C     SrSubT        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'CCTTST'                           CAP084
     C                   Eval      DDSName = 'PCCTTST'                          CAP084
     C                   CallB     'FTVSTHD01'   P#List
     C                   Eval      OkCCTST = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrBBch - Validate Booking Branch                              *
      *****************************************************************
     C     SrBBch        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C****************** Eval      DDSName = 'BRCA'                             CAP084
     C                   Eval      DDSName = 'PBRCA'                            CAP084
     C                   CallB     'FTVBHHD01'   P#List
     C                   Eval      OkBRCA = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrOBch - Validate Originating Branch                          *
      *****************************************************************
     C     SrOBch        Begsr
 
      * Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'ORBR'                             CAP084
     C                   Eval      DDSName = 'PORBR'                            CAP084
     C                   CallB     'FTVORBH02'   P#List
     C                   Eval      OkORBR = GenOkFlag2
 
      * Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrBCde - Validate Book Code                                   *
      *****************************************************************
     C     SrBCde        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'BOKC'                             CAP084
     C                   Eval      DDSName = 'PBOKC'                            CAP084
     C                   CallB     'FTVBKHD01'   P#List
     C                   Eval      OkBOKC = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrPCtr - Validate Profit Centre                               *
      *****************************************************************
     C     SrPCtr        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'PRFC'                             CAP084
     C                   Eval      DDSName = 'PPRFC'                            CAP084
     C                   CallB     'FTVPFHD01'   P#List
     C                   Eval      OkPRFC = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrSwPy - Validate Swift Priority                              *
      *****************************************************************
     C     SrSwPy        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*****************  Eval      DDSName = 'SWPRIO'                           CAP084
     C                   Eval      DDSName = 'PSWPRIO'                          CAP084
     C                   CallB     'FTVSFIN02'   P#List
     C                   Eval      OkSWPY = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrOCust - Validate Ordering Customer                          *
      *****************************************************************
     C     SrOCust       Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'TOCUS1'                           CAP084
     C                   Eval      DDSName = 'PTOCUS1'                          CAP084
     C                   CallB     'FTVORCS02'   P#List
     C                   Eval      OkOCUS1 = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrOInst - Validate Ordering Institution                       *
      *****************************************************************
     C     SrOInst       Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'OINST3'                           CAP084
     C                   Eval      DDSName = 'POINST3'                          CAP084
     C                   CallB     'FTVORIS01'   P#List
     C                   Eval      OkOINS3 = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrSInt - Validate Sending Institution                         *
      *****************************************************************
     C     SrSInt        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'SINST'                            CAP084
     C                   Eval      DDSName = 'PSINST'                           CAP084
     C                   CallB     'FTVSEIS02'   P#List
     C                   Eval      OkSINST = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrDest - Validate Destination                                 *
      *****************************************************************
     C     SrDest        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'CCTDST'                           CAP084
     C                   Eval      DDSName = 'PCCTDST'                          CAP084
     C                   CallB     'FTVDNHD01'   P#List
     C                   Eval      OkCDST = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrSndC - Validate Sender's Correspondent                      *
      *****************************************************************
     C     SrSndC        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'SNDCOR'                           CAP084
     C                   Eval      DDSName = 'PSNDCOR'                          CAP084
     C                   CallB     'FTVSECR01'   P#List
     C                   Eval      OkSNDCR = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrRcvC - Validate Receiver's Correspondent                    *
      *****************************************************************
     C     SrRcvC        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'RCVCOR'                           CAP084
     C                   Eval      DDSName = 'PRCVCOR'                          CAP084
     C                   CallB     'FTVRECR01'   P#List
     C                   Eval      OkRCVCR = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrDVdt - Validate Debit Value Date                            *
      *****************************************************************
     C     SrDVdt        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'DBTVDT'                           CAP084
     C                   Eval      DDSName = 'PDBTVDT'                          CAP084
     C                   CALLB     'FTVDBHD01'   P#List
     C                   Eval      OkDBVDT = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrTrAt - Validate Transfer Amount and Ccy                     *
      *****************************************************************
     C     SrTrAt        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C****************** Eval      DDSName = 'CCTAMT'                           CAP084
     C                   Eval      DDSName = 'PCCTAMT'                          CAP084
     C                   CallB     'FTVTFCY02'   P#List
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrTrDt - Validate Total Transfer Value Date                   *
      *****************************************************************
     C     SrTrDt        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'TTVDTE'                           CAP084
     C                   Eval      DDSName = 'PTTVDTE'                          CAP084
     C                   CALLB     'FTVTRVL01'   P#List
     C                   Eval      OkTTVDT = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrExRt - Validate Exchange Rate                               *
      *****************************************************************
     C     SrExRt        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C****************** Eval      DDSName = 'CCTRTE'                           CAP084
     C                   Eval      DDSName = 'PCCTRTE'                          CAP084
     C                   CallB     'FTVEXHD01'   P#List
     C                   Eval      OkCRTE = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrSAmt - Sum of Amounts                                       *
      *****************************************************************
     C     SrSAmt        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C****************** Eval      DDSName = 'SUMCCT'                           CAP084
     C                   Eval      DDSName = 'PSUMCCT'                          CAP084
     C                   CallB     'FTVAMAM01'   P#List
     C                   Eval      OkSUMAM = GenOkFlag2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrDefault - Default the values when an RFT is inserted.
      *****************************************************************
     C     SrDefault     Begsr
 
     C**********         CallB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   Parm      *Blanks       PRTCD             7
     C                   Parm      '*KEY   '     POPTN             7
     C                   Parm      PBRCA         PBRCA             3
     C     SDBRCH        Parm      SDBRCH        DSSDY
 
     C                   If        ActionCode = 'I'  AND
     C                             PSTID = *Blanks
     C                   Eval      PSTID = A8BTID
     C                   Endif
      *                                                                                       CSW201
      ** If CSW201 is installed, bypass setting of                                            CSW201
      ** default for Sending Institution                                                      CSW201
 
     C                   If        PSINST = *Blanks AND PCCTTYP = 'BO'          178185
     C                             AND CSW201 = 'N'                                           CSW201
     C     8             Subst     A8BTID:1      BIC1              8            178185
     C     3             Subst     A8BTID:10     BIC2              3            178185
     C     BIC1          Cat       BIC2          PSINST                         178185
     C                   Endif                                                  178185
                                                                                178185
      ** Default the Originating Branch to the Booking branch if not entered
     C                   If        PORBR = *Blanks and
     C                             PRTCD = *Blanks
     C                   Eval      PORBR = PBRCA
     C                   Endif
 
      ** Default the Profit Centre
      ** If profit centre is not entered and BKPRCU = 'Y', default
      ** to the profit centre matrix
 
     C                   If        BKPRCU ='Y' and
     C                             PPRFC = *Blanks
 
     C                   CallB     'AOPRFMR0'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      *Blanks       P@BOKC            2
     C                   Parm      *Blanks       P#TRTP            5
     C                   Parm      *Blanks       P#SUTP            2
     C                   Parm      PBRCA         P#BRCA            3
     C                   Parm      *Blanks       P#DEPT            3
     C                   Parm      *Blanks       P#USER           10
     C                   Parm      *Blanks       P#ACOF            2
     C                   Parm      *Blanks       P#CUST            6
     C     PPRFC         Parm      *Blanks       P#PRFC            4
 
     C                   Endif
 
      ** Debit Value Date.
     C                   If        PDBTVDT = *Blanks and
     C                             PCCTTYP = 'BI'
 
     C                   CallB     'ZDATE2'
     C                   Parm                    BJRDNB
     C                   Parm                    BJDFIN
     C                   Parm                    DateOut           6 0
     C                   Parm                    Filler            7
 
     C                   Movel     DateOut       PDBTVDT
 
     C                   Endif
 
      ** Swift Priority Indicator.
     C                   If        PSWPRIO = *Blank
     C                   Eval      PSWPRIO = 'N'
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrPrompt Prompt fields                                        *
      *****************************************************************
     C     SrPrompt      Begsr
 
      ** Prompt Sub-Type
     C                   Movea     *Blanks       @@Arr
     C                   Movea     PCCTTST       @@Arr
     C     '?'           Lookup    @@Arr                                  96
     C                   If        *In96 = *On
     C                   Call      'SD0250S'
     C                   Parm                    PRTCD
     C                   Parm      *Blanks       PCCTTST
     C                   Endif
 
      ** Prompt Originating Branch
     C                   Movea     *Blanks       @@Arr
     C                   Movea     PORBR         @@Arr
     C     '?'           Lookup    @@Arr                                  96
     C                   If        *In96 = *On
     C                   Call      'SD0061S'
     C                   Parm                    PRTCD
     C                   Parm      *Blanks       PORBR
     C                   Endif
 
      **Prompt Book Code
     C                   Movea     *Blanks       @@Arr
     C                   Movea     PBOKC         @@Arr
     C     '?'           Lookup    @@Arr                                  96
     C                   If        *In96 = *On
     C                   Call      'SD0310S'
     C                   Parm                    PRTCD
     C                   Parm      *Blanks       PBOKC
     C                   Endif
 
      ** Prompt Profit Centre
     C                   Movea     *Blanks       @@Arr
     C                   Movea     PPRFC         @@Arr
     C     '?'           Lookup    @@Arr                                  96
     C                   If        *In96 = *On
     C                   Call      'SD0480S'
     C                   Parm                    PRTCD
     C                   Parm      *Blanks       PPRFC
     C                   Endif
 
      ** Prompt Currency
     C                   Movea     *Blanks       @@Arr
     C                   Movea     PCCTCCY       @@Arr
     C     '?'           Lookup    @@Arr                                  96
     C                   If        *In96 = *On
     C                   Call      'SD0020S'
     C                   Parm                    PRTCD
     C                   Parm      *Blanks       PCCTCCY
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrReset - Reset error information that is received back       *
      *           from each validation module.                        *
      *****************************************************************
     C     SrReset       Begsr
 
     C                   Eval      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *BlankS
     C                   Eval      WMsgIDXAr = *Blanks
     C                   Eval      WMsgDtXAr = *Blanks
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrUpdate - Update error information with that received back   *
      *            from each validation module.                       *
      *****************************************************************
     C     SrUpdate      Begsr
 
      ** Update error fields/message IDs/message data (arrays)
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     FldNamXar     FldNameArr(#I)
     C                   Movea     MsgIDXAr      MsgIdArr(#I)
     C                   Movea     MsgDtaXAr     MsgDtaArr(#I)
     C                   Endif
 
      ** Set Error Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   Eval      Idx = #I - 1
 
      ** Update warning fields/message IDs/message data (arrays)
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     WFldNmXAr     WFldNamArr(#I)
     C                   Movea     WMsgIDXAr     WMsgIDArr(#I)
     C                   Movea     WMsgDtXAr     WMsgDtaArr(#I)
     C                   Endif
 
      ** Set Warning Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   Eval      WIdx = #I - 1
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        Begsr
 
     C     *ENTRY        PLIST
     C                   Parm                    RtnCodeIn        10
      ** Response mode (1A), from source system common header (A or S)
     C                   Parm                    RespMode          1
      ** Action Code
     C                   Parm                    ActionCode        1
 
      ** Header information (DS) from source system
     C                   Parm                    HdrRcdIn
     C                   Parm                    DtlRcdIn
 
      ** OK Flags Data Structure
     C                   Parm                    OkFlagHs1
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   Parm                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   Parm                    WIdx
 
      ** Set up the name of the MSGF from which the message handler will
      ** get the messages
     C                   Eval      #MsgFile = 'FTUSRMSG'
 
     C     P#List        PLIST
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode
      ** Screen fields
     C                   Parm                    HdrRcdIn
     C                   Parm                    DtlRcdIn
      ** OK Flags Data Structure - Screen 1 only
     C                   PARM                    OkFlagHS1
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
 
      ** Access Bank Details
     C                   CallB     'AOBANKR0'
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*FIRST '     POPTN
     C     SDBANK        Parm      SDBANK        DSFDY
 
      ** Database Error
     C                   If        PRTCD <> *Blanks
     C                   Eval      DBFile = 'SDBANKPD'
     C                   Eval      DBase = 1
     C                   Eval      DBKey = POPTN
     C                   Exsr      *PSSR
     C                   Endif
 
      ** Access General Ledger Details
     C**********         CallB     'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*FIRST '     POPTN
     C*****SDGELR        Parm      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Database error
     C                   If        PRTCD <> *Blanks
     C                   Eval      DBFile = 'SDGELRPD'
     C                   Eval      DBase = 2
     C                   Eval      DBKey = POPTN
     C                   Exsr      *PSSR
     C                   Endif
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
      *                                                                                       CSW201
     C                   IF        @RTCD = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
 
     C                   Endsr
      *****************************************************************
      /EJECT
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001

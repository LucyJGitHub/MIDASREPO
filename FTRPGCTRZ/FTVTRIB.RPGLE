     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate OP 3rd Reimbursement Inst.')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprograms                                 *
      *                                                               *
      *  FTVTRIB   - Validate OP Third Reimbursement Institution      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD000091           Date 07May13               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
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
 
      ** Include the standard declares
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
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
 
      /COPY FTCPYSRC,SFTVALCSLE
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Warning in error.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of Warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of Warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Incoming Transaction (Second screen level 2)
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
 
      ** Incoming Transaction (Second screen level 2)
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY2PD)
 
      ** Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** Array of valid swift characters
     D SWCH            S              1    DIM(47) CTDATA PERRCD(47)
 
      ** External data structure for customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Midas Counterparty NOSTROS
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
 
      ** Midas BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D/COPY FTCPYSRC,SFTADDRILE
 
     D STRIBS          DS           175
     D  DSTRI1Pos1             1      1
     D  DSTRI1                 1     35
     D  DSTRI2                36     70
     D  DSTRI3                71    105
     D  DSTRI4               106    140
     D  DSTRI5               141    175
 
     D CLSWTK          DS
     D  SW                     1     12
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
     D W#CNUM          S             10
     D W#KYST          S              7
     D W#OPTN          S              7
     D W#RTCD          S              7
 
     D R               S              2  0
     D Q               S              2  0
 
     D ADLINE          S              1
     D ADSLON          S              1
     D ##CSID          S              1
 
      ** IBAN character test arrays
     D Alpha           S              1    DIM(26) CTDATA PERRCD(26)
     D Numeric         S              1    DIM(10) CTDATA PERRCD(10)
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
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
 
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      WFldNmXAr = *Blanks
     C                   Eval      WMsgIDXAr  = *Blanks
     C                   Eval      WMsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0
     C                   Eval      AD#1 = 'N'
     C                   Eval      AD#2 = 'N'
     C                   Eval      AD#3 = 'N'
     C                   Eval      AD#4 = 'N'
     C                   Eval      AD#5 = 'N'
     C                   Eval      AD#6 = 'N'
 
      ** Third Reimbursement Type Institution
 
     C                   ExSr      SrTrdRbIns
 
      ** If an error was found, set the return code appropriately
 
     C                   If        (OKTRI1 = 'N') Or (OKTRI2 = 'N') Or
     C                             (OKTRI3 = 'N') Or (OKTRI4 = 'N') Or
     C                             (OKTRI5 = 'N')
     C                   Eval      RetCodeIn = 'Error'
     C                   Else                                                                 CSD089
     C                   If        (OKTRI1 = 'W') Or (OKTRI2 = 'W') Or                        CSD089
     C                             (OKTRI3 = 'W') Or (OKTRI4 = 'W') Or                        CSD089
     C                             (OKTRI5 = 'W')                                             CSD089
     C                   Eval      RetCodeIn = 'Warning'                                      CSD089
     C                   EndIf                                                                CSD089
     C                   EndIf
 
     C                   Return
 
      *****************************************************************
      /Title Sr/SrTrdRbIns
      *****************************************************************
      *                                                               *
      * SR/SrTrdRbIns - Validate Third Reimbursement Institution      *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * ADCHK       - Address validation, checks for invalid char.    *
      * AOCUSTR0    - Access to customer detail file.                 *
      * SWIFT       - Swift validation subroutine.                    *
      * AOIBANR3    - IBAN validation.                                *
      * AOIBANR5    - IBAN validation.                                *
      *                                                               *
      *****************************************************************
 
     C     SrTrdRbIns    BegSr
 
     C                   Eval      DSTRI1 = STRI1
     C                   Eval      DSTRI2 = STRI2
     C                   Eval      DSTRI3 = STRI3
     C                   Eval      DSTRI4 = STRI4
     C                   Eval      DSTRI5 = STRI5
     C                   Eval      @TRIT = *Blanks
 
      *** Third reimbursement institution is optional
 
     C                   If        STRIBS <> *Blanks
 
      ** '?' not allowed
 
     C     '?'           Scan      STRI1         Y#                3 0    90
      *
     C                   If        *IN90 = True
     C                   Move      'N'           OKTRI1
     C                   Add       1             Idx
     C                   Movel     'STRI1'       FldNamXAr(Idx)
     C                   Movel     'FTM3204'     MsgIdXAr(Idx)
     C                   EndIf
 
      ** No error
 
     C                   If        OKTRI1 <> 'N'
 
      ** Sender's and Receiver's correspondent cannot be both blank if
      ** third reimbursement institution is entered.
 
     C                   If        (SSNCO  = *Blank) Or (SRCO1 = *Blank)
     C                   Move      'N'           OKTRI1
     C                   Add       1             Idx
     C                   Movel     'STRI1'       FldNamXAr(Idx)
     C                   Movel     'FTM3203'     MsgIdXAr(Idx)
     C                   EndIf
     C                   EndIf
 
     C                   If        OKTRI1 <> 'N'
     C                   Movel(P)  STRIBS        ADDRSS
 
      ** If first ten characters used then try to find via SDCUSTPD
 
     C                   If        ADCH26 = *Blanks And
     C                             ADEXCS = *Blanks And
     C                             ADSLSH <> '/' Or
     C                             ADCH36 = *Blanks And
     C                             ADXCS2 = *Blanks And
     C                             ADCHK2 <> *Blanks And
     C                             ADSLSH = '/' And
     C                             ADSLS2 <> '/'
 
      ** First 10 characters should be key for SDCUST
 
     C                   If        ADSLSH <> '/'
     C                   Movel     ADCHK1        W#CNUM
     C                   Else
     C                   Movel     ADCHK2        W#CNUM
     C                   EndIf
 
      ** Call to access pgm for Customer details
 
     C                   Callb     'AOCUSTR0'
     C                   Parm      *Blanks       W#RTCD
     C                   Parm      '*KEY   '     W#OPTN
     C                   Parm                    W#CNUM
     C                   Parm      *Blanks       W#KYST
     C     SDCUST        Parm      *Blanks       DSSDY
 
     C                   If        W#RTCD = *Blanks
 
      ** Overwrite shortname
 
     C                   If        ADSLSH <> '/'
     C                   Movel(P)  BBCUST        STRI1
     C                   Else
     C                   Movel(P)  BBCUST        STRI2
     C                   EndIf
 
      ** Set third reimbursement type to 'C' customer.
 
     C                   Eval      @TRIT = 'C'
 
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   If        (OKTRI1 <> 'N') And (@TRIT = *Blanks)
 
      ** If 1st 11 Chars of 1st line then SWIFT address assumed
      ** Or first is '/' and second is SWIFT Address
      ** If field does not begin with '/' and is not longer than 11
      ** characters, validate as a S.W.I.F.T. Address
 
     C                   If        (ADCH26 = *Blanks) And
     C                             (ADEXSW = *Blanks) And
     C                             (ADSLSH <> '/') Or
     C                             (ADCH36 = *Blanks) And
     C                             (ADEXS2 = *Blanks) And
     C                             (ADCHK2 <> *Blanks) And
     C                             (ADSLSH = '/') And
     C                             (ADSLS2 <> '/')
 
      ** First 11 characters should be key for CLSWT.
 
     C                   If        ADSLSH <> '/'
     C                   Movel     ADCHK1        CLSWTK
     C                   Else
     C                   Movel     ADCHK2        CLSWTK
     C                   EndIf
 
     C                   Exsr      SWIFT
 
     C                   If        ##CSID = 'Y'
 
     C                   If        *IN31 = True
     C                   Add       1             Idx
     C                   If        ADSLSH <> '/'
     C                   Move      'N'           OKTRI1
     C                   Movel     'STRI1'       FldNamXAr(Idx)
     C                   Else
     C                   Move      'N'           OKTRI2
     C                   Movel     'STRI2'       FldNamXAr(Idx)
     C                   EndIf
     C                   Movel     'FTM3206'     MsgIdXAr(Idx)
 
     C                   Else
 
      ** Set third reimbursement institution to SWIFT 'S'
 
     C                   Eval      @TRIT = 'S'
 
      ** No SWIFT address record.
 
     C                   If        (*IN32 = True) And (*IN31 = False)
 
      ** If text changed then warning needs to be changed
 
     C                   If        ADSLSH <> '/'
     C                   Movel     CLSWTK        @TRI1
     C                   Move      'W'           OKTRI1
     C                   Add       1             WIx
     C                   Movel     'FTM3207'     WMsgIdXAr(WIx)
     C                   Movel     'STRI1'       WFldNmXAr(WIx)
 
     C                   Else
     C                   Movel     CLSWTK        @TRI2
     C                   Move      'W'           OKTRI2
     C                   Add       1             WIx
     C                   Movel     'FTM3207'     WMsgIdXAr(WIx)
     C                   Movel     'STRI2'       WFldNmXAr(WIx)
     C                   EndIf
 
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   If        (OKTRI1 <> 'N') And (@TRIT = *Blanks)
 
      ** Invalid customer number or shortname.
 
     C                   If        (ADCH26 = *Blanks) And
     C                             (ADEXCS = *Blanks) And
     C                             (ADSLSH <> '/') Or
     C                             (ADCH36 = *Blanks) And
     C                             (ADXCS2 = *Blanks) And
     C                             (ADCHK2 <> *Blanks) And
     C                             (ADSLSH = '/') And
     C                             (ADSLS2 <> '/')
 
      ** First 10 characters should be key for SDCUST
 
     C                   Add       1             Idx
     C                   If        ADSLSH <> '/'
     C                   Move      'N'           OKTRI1
     C**********         Movel     ADCHK1        MsgDtaXar(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(ADCHK1))                               MD000091
     C                   EVAL      MsgDtaXar(Idx) = LenStr +%TRIM(ADCHK1)                   MD000091
     C                   Movel     'STRI1'       FldNamXAr(Idx)
     C                   Else
     C                   Move      'N'           OKTRI2
     C**********         Movel     ADCHK2        MsgDtaXar(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(ADCHK2))                               MD000091
     C                   EVAL      MsgDtaXar(Idx) = LenStr +%TRIM(ADCHK2)                   MD000091
     C                   Movel     'STRI2'       FldNamXAr(Idx)
     C                   EndIf
     C                   Movel     'FTM3205'     MsgIdXAr(Idx)
 
     C                   Else
 
      ** Validate as an address
 
     C                   Eval      ADLINE = 'Y'
     C                   Exsr      ADCHK
 
      ** Depending on the indicators, highlight the field in error
 
     C                   If        *IN91 = True
     C                   Move      'N'           OKTRI1
     C                   Add       1             Idx
     C                   Movel     'STRI1'       FldNamXAr(Idx)
     C                   Movel     'FTM3209'     MsgIdXAr(Idx)
     C                   EndIf
      *
     C                   If        *IN92 = True
     C                   Move      'N'           OKTRI1
     C                   Add       1             Idx
     C                   Movel     'STRI1'       FldNamXAr(Idx)
     C                   Movel     'FTM3210'     MsgIdXAr(Idx)
     C                   EndIf
     C                   EndIf
 
     C                   If        AD#1 = 'Y'
     C**********         Move      'N'           OKTRI1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'STRI1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKTRI1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'STRI1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   EndIf
 
     C                   If        AD#2 = 'Y'
     C**********         Move      'N'           OKTRI2                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'STRI2'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKTRI2                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'STRI2'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   EndIf
 
     C                   If        AD#3 = 'Y'
     C**********         Move      'N'           OKTRI3                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'STRI3'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKTRI3                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'STRI3'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   EndIf
 
     C                   If        AD#4 = 'Y'
     C**********         Move      'N'           OKTRI4                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'STRI4'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKTRI4                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'STRI4'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   EndIf
 
     C                   If        AD#5 = 'Y'
     C**********         Move      'N'           OKTRI5                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'STRI5'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKTRI5                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'STRI5'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   EndIf
 
      ** If no errors then customer is an address
 
     C                   If        OKTRI1 = 'Y'And
     C                             OKTRI2 = 'Y'And
     C                             OKTRI3 = 'Y'And
     C                             OKTRI4 = 'Y'And
     C                             OKTRI5 = 'Y'And
     C                             @TRIT = *Blanks
     C                   Eval      @TRIT = 'A'
     C                   EndIf
 
     C                   EndIf
 
      ** Error when bank operation code entered is 'SPRI', or 'SSTD' or
      ** SPAY and type of receiver's correspondent entered is not 'S'
      ** or not 'C' or receiver's correspondent type is 'C' but the
      ** customer entered does not have a SWIFT BIC
 
     C                   If        (SBOCD = 'SPRI') Or (SBOCD = 'SSTD') Or
     C                             (SBOCD = 'SPAY')
     C                   If        (@TRIT <> 'S') And (@TRIT <> 'C') Or
     C                             (@TRIT = 'C') And (BBCSID = *Blank)
     C                   Movel     'N'           OKTRI1
     C                   Add       1             Idx
     C                   Movel     'STRI1'       FldNamXAr(Idx)
     C                   Movel     'FTM3211'     MsgIdXAr(Idx)
     C                   EndIf
     C                   EndIf
 
      ** If IBAN (International Bank Account Number) is switched on
 
     C                   If        @CFT004 = 'Y'
 
      ** Remove '/' from first position
 
     C                   If        DSTRI1Pos1 = '/'
     C     34            Subst     DSTRI1:2      PIBAN
     C                   Else
     C                   Eval      PIBAN = DSTRI1
     C                   EndIf
 
      ** Format field, removing blanks and IBAN prefix
 
     C                   Call      'AOIBANR3'
     C                   Parm                    @Rcode            7
     C                   Parm                    PIBAN            47
     C                   Parm                    POWith           47
     C     P@IBAN        Parm                    PONobl           34
 
      ** If first four characters are 'AANN', proceed with IBAN validn
 
     C     1             Subst     P@IBAN:1      IBCTY1            1
     C     1             Subst     P@IBAN:2      IBCTY2            1
     C     1             Subst     P@IBAN:3      IBCHK1            1
     C     1             Subst     P@IBAN:4      IBCHK2            1
     C     IBCTY1        LookUp    Alpha                                  94
     C                   If        *IN94 = True
     C     IBCTY2        LookUp    Alpha                                  94
     C                   EndIf
     C                   If        *IN94 = True
     C     IBCHK1        LookUp    Numeric                                94
     C                   EndIf
     C                   If        *IN94 = True
     C     IBCHK2        LookUp    Numeric                                94
     C                   EndIf
 
     C                   If        *IN94 = True
 
     C                   Call      'AOIBANR5'                           90
     C                   Parm      *Blanks       @Rcode
     C                   Parm                    P@IBAN           34
 
      ** If no warnings, prefix IBAN with '/'
 
     C                   If        *IN90 = False and @Rcode = *Blanks
     C     '/'           Cat       P@IBAN        STRI1
     C                   Else
 
      ** Warnings:
 
     C                   Eval      OKTRI1 = 'N'
     C                   Eval      WIx = WIx + 1
     C                   Eval      WFldNmXAr(WIx) = 'STRI1     '
     C**********         Eval      WMsgDtaXAr(WIx) =                                        MD000091
     C**********                   'Third Reimb. Ins.'                                      MD000091
     C                   EVAL      MsgDtaTmp = 'Third Reimb. Ins.'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtaXAr(WIx) = LenStr +%TRIM(MsgDtaTmp)               MD000091
     C                   Select
 
      ** Invalid ISO country code
 
     C                   When      @Rcode = '      1'
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2400'
 
      ** Invalid BBAN length
 
     C                   When      @Rcode = '      2'
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2401'
 
      ** Invalid character
 
     C                   When      @Rcode = '      3'
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2402'
 
      ** Invalid IBAN length
 
     C                   When      @Rcode = '      4'
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2403'
 
      ** Invalid check digit
 
     C                   When      @Rcode = '      5'
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2404'
 
      ** Other/non-specific warning
 
     C                   Other
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2405'
     C                   EndSl
 
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C
     C                   EndIf
 
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/*InzSr
      *****************************************************************
      *                                                               *
      * SR/*InzSr     - Program Initialisation Routine                *
      *                                                               *
      * Called By: Automatically executed when program starts.        *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    TranInPrim
     C                   Parm                    TranInSecA
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
 
     C                   EndSr
 
      *****************************************************************
      ** SWIFT subroutine
     C/COPY FTCPYSRC,SFTSWFTCLE
 
      ** ADCHK subroutine
     C/COPY FTCPYSRC,SFTADDRCLE
 
      ** SWSET subroutine
     C/COPY FTCPYSRC,SFTADDRSC1
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  SWCH  - Array of valid Swift characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890/-?:().,'+
**  Alpha - Array of alphabetic characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  Numeric - Array of numeric characters
0123456789

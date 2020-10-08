     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate receivers correspondent')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVRVCR  - Validate Receiver's Correspondent                 *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD000091           Date 07May13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 257144             Date 10Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 22Nov99               *
      *                 CAP031  *CREATE    Date 12Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  257144 - Include lower case in ISO validation.               *
      *           Use new /COPY member SFTVALCSLL.                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - IBAN, International Bank Account Number             *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      **********************************************************************
      /EJECT                                                               *
      **********************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     **COPY*FTCPYSRC,SFTVALCSLE                                                               257144
      /COPY FTCPYSRC,SFTVALCSLL                                                               257144

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

      * Incoming Transaction
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)

      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY2PD)

      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)

      ** Array of valid swift characters
     D SWCH            S              1    DIM(47) CTDATA PERRCD(47)

      ** External data structure for customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Midas Counterparty NOSTROS
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)

      ** Midas BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)

      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D/COPY FTCPYSRC,SFTADDRILE

     D SRCODS          DS           175
     D  DSRCO1Pos1             1      1                                         CFT004
     D  DSRCO1                 1     35
     D  DSRCO2                36     70
     D  DSRCO3                71    105
     D  DSRCO4               106    140
     D  DSRCO5               141    175

     D CLSWTK          DS
     D  SW                     1     12

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0

     D C#CNUM          S             10
     D C#KYST          S              7
     D C#OPTN          S              7
     D C#RTCD          S              7

     D R               S              2  0
     D Q               S              2  0

      * This prog only
     D ADLINE          S              1
     D ADSLON          S              1
     D ##CSID          S              1

      ** IBAN character test arrays                                             CFT004
     D Alpha           S              1    DIM(26) CTDATA PERRCD(26)            CFT004
     D Numeric         S              1    DIM(10) CTDATA PERRCD(10)            CFT004
      **                                                                        CFT004
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      **                                                                                    MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *********************************************************************
      /EJECT                                                              *
      *********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialization
      *
     C                   Eval      RetCodeIn = *BlankS
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
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


      * Sender's Correspondent
      *
     C                   Exsr      VRCVCOR

      ** If an error was found, set the return code appropriately
      *
     C                   If        OKRco1 = 'N' or
     C                             OKRco2 = 'N' or
     C                             OKRco3 = 'N' or
     C                             OKRco4 = 'N' or
     C                             OKRco5 = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Else                                                                 CSD089
     C                   If        OKRco1 = 'W' or                                            CSD089
     C                             OKRco2 = 'W' or                                            CSD089
     C                             OKRco3 = 'W' or                                            CSD089
     C                             OKRco4 = 'W' or                                            CSD089
     C                             OKRco5 = 'W'                                               CSD089
     C                   Eval      RetCodeIn = 'Warning'                                      CSD089
     C                   End                                                                  CSD089
     C                   End

      * RETURN

     C                   RETURN
      ******************************************************************
      /EJECT
     C******************************************************************
     C* VRCVCOR - VALIDATION OF RECEIVER'S CORRESPONDENT                 *
      ******************************************************************
     C*
     C     VRCVCOR       BEGSR

     C                   Eval      DSRCO1 = SRCO1
     C                   Eval      DSRCO2 = SRCO2
     C                   Eval      DSRCO3 = SRCO3
     C                   Eval      DSRCO4 = SRCO4
     C                   Eval      DSRCO5 = SRCO5
     C                   Eval      @RCRT = *Blanks

      *  Receiver's Correspondent is Optional
     C                   If        SRCODS <> *Blanks

      *  ? not allowed
     C     '?'           Scan      SRCO1         Y#                3 0    90
      *
     C                   If        *IN90 = *On
      * Send error to screen
     C                   Move      'N'           OKRco1
     C                   Add       1             Idx
     C                   Movel     'SRCO1'       FldNamXAr(Idx)
     C                   Movel     'MMA1037'     MsgIdXAr(Idx)
     C                   End

      * No error
     C                   If        OKRco1 <> 'N'

     C                   Movel(P)  SRCODS        ADDRSS
      *
      *  If first ten characters used then try to find via SDCUSTPD
     C                   If        ADCH26 = *Blanks and
     C                             ADEXCS = *Blanks and
     C                             ADSLSH <> '/' or
     C                             ADCH36 = *Blanks and
     C                             ADXCS2 = *Blanks and
     C                             ADCHK2 <> *Blanks and
     C                             ADSLSH = '/' and
     C                             ADSLS2 <> '/'

      *  First 10 characters should be key for SDCUST
     C                   If        ADSLSH <> '/'
     C                   Movel     ADCHK1        C#CNUM
     C                   Else
     C                   Movel     ADCHK2        C#CNUM
     C                   End
      *
      *  Call to access pgm for Customer details
     C                   CALLB     'AOCUSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm                    C#CNUM
     C                   Parm      *Blanks       C#KYST
     C     SDCUST        Parm      *Blanks       DSSDY

     C                   If        C#RTCD = *Blanks

      * Overwrite shortname
     C                   If        ADSLSH <> '/'
     C                   Movel(P)  BBCUST        SRCO1
     C                   Else
     C                   Movel(P)  BBCUST        SRCO2
     C                   End

     C                   Eval      @RCRT = 'C'

     C                   End
     C                   End
     C                   End

     C                   If        OKRco1 <> 'N' and
     C                             @RCRT = *Blanks

      *  If 1st 11 Chars of 1st line then SWIFT address assumed
      *  Or first is '/' and second is SWIFT Address

      *  If field does not begin with '/' and is not longer than 11
      *  characters, validate as a S.W.I.F.T. Address
     C                   If        ADCH26 = *Blanks and
     C                             ADEXSW = *Blanks and
     C                             ADSLSH <> '/' or
     C                             ADCH36 = *Blanks and
     C                             ADEXS2 = *Blanks and
     C                             ADCHK2 <> *Blanks and
     C                             ADSLSH = '/' and
     C                             ADSLS2 <> '/'

      *  First 11 characters should be key for CLSWT.
     C                   If        ADSLSH <> '/'
     C                   Movel     ADCHK1        CLSWTK
     C                   Else
     C                   Movel     ADCHK2        CLSWTK
     C                   End

     C                   Exsr      SWIFT

     C                   If        ##CSID = 'Y'

     C                   If        *IN31 = *On
      * Send error to screen
     C**********         Add       1             Idx                                          CSD089
     C                   Add       1             WIx                                          CSD089
     C                   If        ADSLSH <> '/'
     C**********         Move      'N'           OKRco1                                       CSD089
     C**********         Movel     'SRCO1'       FldNamXAr(Idx)                               CSD089
     C                   Move      'W'           OKRco1                                       CSD089
     C                   Movel     'SRCO1'       WFldNmXAr(WIx)                               CSD089
     C                   Else
     C**********         Move      'N'           OKRco2                                       CSD089
     C**********         Movel     'SRCO2'       FldNamXAr(Idx)                               CSD089
     C                   Move      'W'           OKRco2                                       CSD089
     C                   Movel     'SRCO2'       WFldNmXAr(WIx)                               CSD089
     C                   End
     C**********         Movel     'MMA1038'     MsgIdXAr(Idx)                                CSD089
     C                   Movel     'MMA1038'     WMsgIdXAr(WIx)                               CSD089

     C                   Else
     C                   Eval      @RCRT = 'S'
      *
      *  No SWIFT address record.
     C                   If        *IN32 = *On and
     C                             *IN31 = *Off

      *  If text changed then warning needs to be changed
     C                   If        ADSLSH <> '/'
     C                   Movel     CLSWTK        @RCO1
      * Send warning to screen
     C                   Move      'W'           OKRco1
     C                   Add       1             WIx
     C                   Movel     'MMA1039'     WMsgIdXAr(WIx)
     C                   Movel     'SRCO1'       WFldNmXAr(WIx)

     C                   Else
     C                   Movel     CLSWTK        @RCO2
      * Send warning to screen
     C                   Move      'W'           OKRco2
     C                   Add       1             WIx
     C                   Movel     'MMA1039'     WMsgIdXAr(WIx)
     C                   Movel     'SRCO2'       WFldNmXAr(WIx)
     C                   End

     C                   End
     C                   End
     C                   End
     C                   End
     C                   End

     C                   If        OKRco1 <> 'N' and
     C                             @RCRT = *Blanks

      * Invalid customer number or shortname.
     C                   If        ADCH26 = *Blanks and
     C                             ADEXCS = *Blanks and
     C                             ADSLSH <> '/' or
     C                             ADCH36 = *Blanks and
     C                             ADXCS2 = *Blanks and
     C                             ADCHK2 <> *Blanks and
     C                             ADSLSH = '/' and
     C                             ADSLS2 <> '/'

      *  First 10 characters should be key for SDCUST
      * Send error to screen
     C                   Add       1             Idx
     C                   If        ADSLSH <> '/'
     C                   Move      'N'           OKRco1
     C                   Movel     'SRCO1'       FldNamXAr(Idx)
     C                   Else
     C                   Move      'N'           OKRco2
     C                   Movel     'SRCO2'       FldNamXAr(Idx)
     C                   End
     C                   Movel     'MMA1040'     MsgIdXAr(Idx)

     C                   Else
      * Validate as an address
     C                   Eval      ADLINE = 'Y'
     C                   Exsr      ADCHK

      *  Depending on the indicators, highlight the field in error
     C                   If        *IN91 = *On
      * Send error to screen
     C                   Move      'N'           OKRco1
     C                   Add       1             Idx
     C                   Movel     'SRCO1'       FldNamXAr(Idx)
     C                   Movel     'MMA1041'     MsgIdXAr(Idx)
     C                   End
      *
     C                   If        *IN92 = *On
      * Send error to screen
     C                   Move      'N'           OKRco1
     C                   Add       1             Idx
     C                   Movel     'SRCO1'       FldNamXAr(Idx)
     C                   Movel     'MMA1042'     MsgIdXAr(Idx)
     C                   End
     C                   End

     C                   If        AD#1 = 'Y'
     C**********         Move      'N'           OKRco1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SRCO1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKRco1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SRCO1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   End

     C                   If        AD#2 = 'Y'
     C**********         Move      'N'           OKRco2                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SRCO2'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKRco2                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SRCO2'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   End

     C                   If        AD#3 = 'Y'
     C**********         Move      'N'           OKRco3                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SRCO3'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKRco3                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SRCO3'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   End

     C                   If        AD#4 = 'Y'
     C**********         Move      'N'           OKRco4                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SRCO4'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKRco4                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SRCO4'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   End

     C                   If        AD#5 = 'Y'
     C**********         Move      'N'           OKRco5                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SRCO5'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKRco5                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SRCO5'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   End

      *  If no errors then customer is an address
     C                   If        OKRco1 = 'Y'and
     C                             OKRco2 = 'Y'and
     C                             OKRco3 = 'Y'and
     C                             OKRco4 = 'Y'and
     C                             OKRco5 = 'Y'and
     C                             @RCRT = *Blanks
     C                   Eval      @RCRT = 'A'
     C                   End

     C                   End
                                                                                CFT014
      ** Error when bank operation code entered is 'SPRI', or 'SSTD' or         CFT014
      ** SPAY and type of receiver's correspondent entered is not 'S'           CFT014
      ** or not 'C' or receiver's correspondent type is 'C' but the             CFT014
      ** customer entered does not have a SWIFT BIC                             CFT014
                                                                                CFT014
     C                   If        (SBOCD = 'SPRI') Or (SBOCD = 'SSTD') Or      CFT014
     C                             (SBOCD = 'SPAY')                             CFT014
     C                   If        (@RCRT <> 'S') And (@RCRT <> 'C') Or         CFT014
     C                             (@RCRT = 'C') And (BBCSID = *Blank)          CFT014
     C                   Movel     'N'           OKRco1                         CFT014
     C                   Add       1             Idx                            CFT014
     C                   Movel     'SRCO1'       FldNamXAr(Idx)                 CFT014
     C                   Movel     'FTM3202'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                                                                          CFT004
      *  If IBAN (International Bank Account Number) is switched on             CFT004
     C                                                                          CFT004
     C                   IF        @CFT004 = 'Y'                                CFT004
                                                                                CFT004
      *  Remove '/' from first position                                         CFT004
                                                                                CFT004
     C                   IF        DSRCO1Pos1 = '/'                             CFT004
     C     34            SUBST     DSRCO1:2      PIBAN                          CFT004
     C                   ELSE                                                   CFT004
     C                   EVAL      PIBAN = DSRCO1                               CFT004
     C                   ENDIF                                                  CFT004
                                                                                CFT004
      *  Format field, removing blanks and IBAN prefix                          CFT004
                                                                                CFT004
     C                   CALL      'AOIBANR3'                                   CFT004
     C                   PARM                    @Rcode            7            CFT004
     C                   PARM                    PIBAN            47            CFT004
     C                   PARM                    POWith           47            CFT004
     C     P@IBAN        PARM                    PONobl           34            CFT004
                                                                                CFT004
      *  If first four characters are 'AANN', proceed with IBAN validn          CFT004
                                                                                CFT004
     C     1             SUBST     P@IBAN:1      IBCTY1            1            CFT004
     C     1             SUBST     P@IBAN:2      IBCTY2            1            CFT004
     C     1             SUBST     P@IBAN:3      IBCHK1            1            CFT004
     C     1             SUBST     P@IBAN:4      IBCHK2            1            CFT004
     C     IBCTY1        LOOKUP    Alpha                                  94    CFT004
     C   94IBCTY2        LOOKUP    Alpha                                  94    CFT004
     C   94IBCHK1        LOOKUP    Numeric                                94    CFT004
     C   94IBCHK2        LOOKUP    Numeric                                94    CFT004
                                                                                CFT004
     C                   IF        *IN94 = *ON                                  CFT004
                                                                                CFT004
     C                   CALL      'AOIBANR5'                           90      CFT004
     C                   PARM      *Blanks       @Rcode                         CFT004
     C                   PARM                    P@IBAN           34            CFT004
                                                                                CFT004
      *  If no warnings, prefix IBAN with '/'                                   CFT004
                                                                                CFT004
     C                   IF        *IN90 = *Off and @Rcode = *Blanks            CFT004
     C     '/'           CAT       P@IBAN        SRCO1                          CFT004
     C                   ELSE                                                   CFT004
                                                                                CFT004
      *  Warnings:                                                              CFT004
                                                                                CFT004
     C                   EVAL      OKRco1 = 'N'                                 CFT004
     C                   EVAL      WIx = WIx + 1                                CFT004
     C                   EVAL      WFldNmXAr(WIx) = 'SRCO1     '                CFT004
     C**********         EVAL      WMsgDtaXAr(WIx) =                                 CFT004 MD000091
     C**********                   'Receiver''s Corres.'                             CFT004 MD000091
     C                   EVAL      MsgDtaTmp = 'Receiver''s Corres.'                        MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtaXAr(WIx) = LenStr +%TRIM(MsgDtaTmp)               MD000091
     C                   SELECT                                                 CFT004
                                                                                CFT004
      *  Invalid ISO country code                                               CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      1'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2400'                   CFT004
                                                                                CFT004
      *  Invalid BBAN length                                                    CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      2'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2401'                   CFT004
                                                                                CFT004
      *  Invalid character                                                      CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      3'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2402'                   CFT004
                                                                                CFT004
      *  Invalid IBAN length                                                    CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      4'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2403'                   CFT004
                                                                                CFT004
      *  Invalid check digit                                                    CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      5'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2404'                   CFT004
                                                                                CFT004
      *  Other/non-specific warning                                             CFT004
                                                                                CFT004
     C                   OTHER                                                  CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2405'                   CFT004
     C                   ENDSL                                                  CFT004
                                                                                CFT004
     C                   ENDIF                                                  CFT004
     C                   ENDIF                                                  CFT004
     C                   ENDIF                                                  CFT004
     C                                                                          CFT004
     C                   End

     C                   ENDSR
     C*****************************************************************
     C* END OF RECEIVER'S CORRESPONDENT VALIDATION                    *
     C*****************************************************************
     C/EJECT
      * Subroutine SWIFT
     E/COPY FTCPYSRC,SFTSWFTCLE

      * Subroutine ADCHK
     E/COPY FTCPYSRC,SFTADDRCLE

      * Subroutine SWSET
     E/COPY FTCPYSRC,SFTADDRSC1

      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn

      *  Screen fields
     C                   Parm                    TranInSecA

      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  SWCH  - Array of valid Swift characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890/-?:().,'+
**  Alpha - Array of alphabetic characters                                      CFT004
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  Numeric - Array of numeric characters                                       CFT004
0123456789

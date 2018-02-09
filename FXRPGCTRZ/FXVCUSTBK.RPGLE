     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validate cust, book, port & profit centre')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVCUSTBK - Validate Customer, Book, Portfolio, Profit Centre*
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
      *  Prev Amend No. MD030956           Date 09Oct14               *
      *                 MD000091           Date 07May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248269             Date 25Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG5635            Date 17Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CTI004             Date 12Apr04               *
      *                 CLE025             Date 20Oct03               *
      *                 213480             Date 25Mar03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 184685             Date 19Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD009             Date 10Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 179732             Date 21MAR00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 01Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP050             Date 24Jul98               *
      *                 CAP002  *CREATE    Date 08Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  MD000091 - Event Codes Substitution                          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248269 - Use original spot rate in validating the exchange   *
      *           rate of an Option takedown deal.                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  BUG5635- Access to file SDCPTTPD is being done on Customer   *
      *           Shortname when CDL005 is ON, should be Customer No. *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           FX Deals Integration                                *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  213480 - Initialise I#R997 with FCR997, and I#PORS with      *
      *           FCPORS to properly default portfolio reference.     *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  184685 - Initialise field TRTP to default correct profit     *
      *           center.                                             *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
     F*  179732 - Incorporation into core of fix 171062 (Same as fix  *
     F*           176510 for FX0820)  Only default the profit centre  *
     F*           if the customer number is valid.                    *
      *  CPB001 - 'Private Banking' Module                            *
      *  CAP050 - Midas/ToF Interface                                 *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FPMPORTPD  IF   E           K DISK    INFSR(*PSSR)
     FSDCGRPL2  IF   E           K DISK    INFSR(*PSSR)
     FSDCPTTL1  IF   E           K DISK    INFSR(*PSSR)
     F/COPY WNCPYSRC,FXH00104
 
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
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** Array of transaction types
     D @TT             S              2    DIM(40)
 
 
     D*RelDealDts      DS           100                                                       248269
     D RelDealDts      DS           113                                                       248269
      ** Related Deal Details (when deal is option takedown or swap.
      ** Thus related deal will be other leg of swap or option).
     D**RelDCNO*              40     45  0                                                    CSD027
     D  RelDCNO               40     45A                                                      CSD027
     D  RelDCSN               46     55
 
                                                                                CAP050
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP050
      ** EXTERNAL DS FOR SAR DETAILS                                            CAP050
 
      ** External data structure for customer details file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for pm customer details file
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
 
      ** External data structure for book codes file
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
 
      ** External data structure for profit centre details file
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                CPB001
      ** External data structure for access programs (very long)                CPB001
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CPB001
                                                                                              CTI004
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CTI004
     D                                     PREFIX(MM_)                                        CTI004
      ** External DS for Module Details                                                       CTI004
                                                                                              CTI004
     D SDTIIN        E DS                  EXTNAME(SDTIINPD)                                  CTI004
      **  TI ICD FIle                                                                         CTI004
 
     D I@PARM          DS           256
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
 
     D O@PARM          DS           256
     D  O#BOOK                 1      2
     D  O#PTFR                 3      6
     D  O#BICN                 7     12
     D  O#CRNM                13     22
     D  O#ACOF                23     24
 
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
 
      ** Customer number
     D*F3DCNO***       S              6S 0                                                    CSD027
     D F3DCNO          S              6A                                                      CSD027
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
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
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      *
      * CUSTV - CUSTOMER VALIDATION
      *
     C                   EXSR      CUSTV
      *
      * BOKCV - BOOK CODE VALIDATION
      *
     C                   EXSR      BOKCV
      *
      * PTFR - PORTFOLIO REFERENCE VALIDATION
      * If portfolio management is installed
      * or Private Banking Module is installed                                  CPB001
      * and if customer and booking branch are OK
      *
     C     BGPFMG        IFEQ      'Y'
     C     DDCustOK      ANDEQ     'Y'
     C     DDBrsnOK      ANDEQ     'Y'
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C     DDCustOK      ANDEQ     'Y'                                          CPB001
     C                   EXSR      PTFRV
     C                   END
      *
      * PRFC - PROFIT CENTRE VALIDATION
      * If profit centres used
      *
     C     BKPRCU        IFEQ      'Y'
     C                   EXSR      PRFCV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCustOK      IFEQ      'N'
     C     DDBokcOK      OREQ      'N'
     C     DDPtfrOK      OREQ      'N'
     C     DDPrfcOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * CUSTV - CUSTOMER VALIDATION
      *****************************************************************
     C     CUSTV         BEGSR
      *
      * Error if customer is not defined
      *
     C     DDCUST        IFEQ      *BLANKS
     C                   MOVE      'N'           DDCustOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0207'     MsgIdXAr(Idx)
     C                   END
      *
      * If customer is defined
      *
     C     DDCUST        IFNE      *BLANKS
     C**********         CALLB     'AOCUSTR0'                                   CPB001
     C**********         PARM      *BLANKS       @RTCD             7            CPB001
     C**********         PARM      '*KEY   '     @OPTN             7            CPB001
     C**********         PARM      DDCUST        @KEY1            10            CPB001
     C**********         PARM      *BLANKS       @KYST             7            CPB001
     C*****SDCUST        PARM      SDCUST        DSSDY                          CPB001
     C                   CALLB     'AOCUSTR1'                                   CPB001
     C                   PARM      *BLANKS       @RTCD             7            CPB001
     C                   PARM      '*KEY   '     @OPTN             7            CPB001
     C                   PARM      DDCUST        @KEY1            10            CPB001
     C                   PARM      *BLANKS       @KYST             7            CPB001
     C     SDCUST        PARM      SDCUST        DSLDY                          CPB001
      *
      * Invalid customer
      *
     C     @RTCD         IFNE      *BLANKS
     C     @KYST         OREQ      'ERROR  '
     C                   MOVE      'N'           DDCustOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0205'     MsgIdXAr(Idx)
     C                   ELSE
     C     CustFormat    IFEQ      'N'
     C                   MOVEL     *BLANKS       DDCUST
     C                   MOVEL     BBCUST        DDCUST
     C                   ELSE
     C                   MOVEL     BBCSSN        DDCUST
     C                   END
     C                   END
                                                                                              CSD025
      * Check for De-Activation if CSD025 is active                                           CSD025
                                                                                              CSD025
     C                   IF        CSD025 = 'Y'                                               CSD025
     C                             and BBDEAC = 'Y' and DDACTN = 'I'                          CSD025
                                                                                              CSD025
     C                   MOVE      'N'           DDCustOK                                     CSD025
     C                   ADD       1             Idx                                          CSD025
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)                               CSD025
     C                   MOVEL     'ABM0027'     MsgIdXAr(Idx)                                CSD025
     C                   IF        CustFormat = 'N'                                           CSD025
     C**********         EVAL      MsgDtaXAr(IDx) = BBCUST                           CSD025 MD000091
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(BBCUST)                   MD000091
     C                   ELSE                                                                 CSD025
     C**********         EVAL      MsgDtaXAr(IDx) = BBCSSN                           CSD025 MD000091
     C                   EVAL      BLen = %Len(%Trim(BBCSSN))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(BBCSSN)                   MD000091
     C                   ENDIF                                                                CSD025
                                                                                              CSD025
     C                   ENDIF                                                                CSD025
      *
      * If customer is OK, it can't be a parent
      *
     C     DDCustOK      IFEQ      'Y'
     C     BBPAIN        ANDEQ     'P'
     C                   MOVE      'N'           DDCustOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0206'     MsgIdXAr(Idx)
     C                   END
      *
      * If customer is OK, and DRS shortnames to be used,
      * DRS shortname of customer can't be blank
      *
     C     DDCustOK      IFEQ      'Y'
     C     BBDRCS        ANDEQ     *BLANK
     C     BGUDRS        ANDEQ     'Y'
     C                   MOVE      'N'           DDCustOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'FXM4000'     MsgIdXAr(Idx)
     C                   END
      *
      * If customer is OK
      *
     C     DDCustOK      IFEQ      'Y'
      *
     C     @KYST         IFEQ      '*CNUM  '
     C**********         MOVE      BBCUST        @@CNUM            6 0                        CSD027
     C                   MOVE      BBCUST        @@CNUM            6                          CSD027
     C                   END
      *
      ** Check DRS short name from SNAME with shortname on deals file
      *
     C     DDDLTP        IFEQ      'OT'
     C     @KYST         ANDNE     '*CNUM  '
     C     DDSdnoOK      ANDEQ     'Y'
     C     BBCSSN        ANDNE     RelDCSN
     C     DDDLTP        OREQ      'OT'
     C     @KYST         ANDEQ     '*CNUM  '
     C     DDSdnoOK      ANDEQ     'Y'
     C     @@CNUM        ANDNE     RelDCNO
     C                   MOVE      'N'           DDCustOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0117'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *
      * FX Netting Customer check
      *
     C     CDL002        IFEQ      'Y'
     C     DDCustOK      ANDEQ     'Y'
 
     C/COPY WNCPYSRC,FXH00201
     C     DDNBUY        IFEQ      'Y'
     C     DDNSEL        OREQ      'Y'
     C/COPY WNCPYSRC,FXH00105
 
      ** If part of Netting Group check Netting group is on file.
     C     BBNTGP        IFNE      *BLANK
     C     @NGKEY        KLIST
     C                   KFLD                    D6SNBR
     C                   KFLD                    BBNTGP
     C                   MOVEL     '*'           D6SNBR
     C     @NGKEY        CHAIN     SDCGRPL2                           87
     C                   ENDIF
      *
      ** Must be a Netting Customer else if part of a Netting Group,
      ** Netting Group must be defined on Customer Groups Master File.
     C     BBNTGP        IFEQ      *BLANKS
     C     BBNET         ANDNE     'Y'
      ** *IN87 if on, Netting Group not on file.
     C     *IN87         OREQ      *ON
     C     DDNBUY        IFEQ      'Y'
     C                   MOVE      'N'           DDNbuyOK
     C                   ENDIF
     C     DDNSEL        IFEQ      'Y'
     C                   MOVE      'N'           DDNselOK
     C                   ENDIF
     C                   MOVE      'N'           DDCustOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'FXM5010'     MsgIdXAr(Idx)
     C                   ENDIF
     C/COPY WNCPYSRC,FXH00200
      *
      ** Customer/Deal type must be valid combination.
     C****************** MOVEL     DDCUST        CUSTNO            6                         BUG5635
     C                   MOVEL     BBCUST        CUSTNO            6                         BUG5635
     C                   MOVEL     DDDLTP        DT                2
     C     CUSTNO        CHAIN     @CPTTL1                            88
     C     *IN88         IFEQ      *OFF
     C                   MOVEA     B6TYPS        @TT
     C     DT            LOOKUP    @TT(1)                                 89
     C                   ENDIF
      ** Customer not on file (*IN88) Or Transaction type invalid (*IN89).
     C     *IN88         IFEQ      *ON
     C     *IN89         OREQ      *OFF
      ** Hi-light Deal Type and Customer.
     C                   MOVE      'N'           DDDltpOK
     C                   MOVE      'N'           DDCustOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'FXM5011'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C/COPY WNCPYSRC,FXH00106
     C                   ENDIF
     C                   ENDIF
      *
      * If customer is OK
      *
     C     DDCustOK      IFEQ      'Y'
     C                   MOVE      BBCUST        F3DCNO
     C                   MOVE      BBCSSN        F3DCSN
     C                   END
      *
     C                   ELSE
     C**********         Z-ADD     0             F3DCNO                                       CSD027
     C                   EVAL      F3DCNO = *BLANKS                                           CSD027
     C                   MOVE      *BLANKS       F3DCSN
     C                   END                                                    DDCUST NE ' '
     C                   ENDSR
      *******************************************************************
     C/EJECT
      *****************************************************************
      * BOKCV - BOOK CODE VALIDATION
      *****************************************************************
     C     BOKCV         BEGSR
      *
      * Get default book for portfolio customer
      *
     C     BGPFMG        IFEQ      'Y'                                          CPB001
     C                   MOVEL     BBCUST        I#CUST
     C                   MOVEL     DDBRSN        I#BRCA
     C                   MOVEL     DDBOKC        I#BOOK
     C                   MOVEL     DDPTFR        I#PTFR
     C                   MOVEL     FCR997        I#R997                                       213480
     C                   MOVEL     FCPORS        I#PORS                                       213480
     C                   CALL      'AOPLCSR1'
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM                    I@PARM                         I:Parameters
     C                   PARM      *BLANKS       O@PARM                         O:Parameters
     C     SDPLCS        PARM      SDPLCS        DSFDY                          O:Format
     C                   MOVEL     P@RTCD        ERPLCS            7
     C                   ENDIF                                                  CPB001
      *                                                                                     MD030956
      ** If FX generated from TI book code should be defaulted from ICD.                    MD030956
      *                                                                                     MD030956
     C                   If        DDDLST = TIDLST AND                                      MD030956
     C                             DDBOKC = *BLANKS AND                                     MD030956
     C                             MM_BGN3ST = 'Y' OR                                       MD030956
     C                             CTI006 = 'Y' AND                                         MD030956
     C                             DDDLST = TIDLST AND                                      MD030956
     C                             DDBOKC = *BLANKS                                         MD030956
     C                   EVAL      DDBOKC = TIBOOK                                          MD030956
     C                   ENDIF                                                              MD030956
      *
      ** Book code defaulting:
      ** 1) If Book Code Optional from DL ICD is 'Y', default book
      **    code to SDDEALPD/BNBKCD
      ** 2) Else, if Bank Portfolio is supported default book code to
      **    output book code determined from AOPLCSR1
      ** 3) Else, send error message, book code is mandatory.
      *
     C     DDBOKC        IFEQ      *BLANKS
     C     BNBCOP        IFNE      'Y'
     C     FCPORS        IFEQ      'B'
     C     ERPLCS        ANDEQ     *BLANKS
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C                   MOVEL     O#BOOK        DDBOKC
     C                   ELSE
     C                   MOVE      'N'           DDBokcOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBOKC'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1037'     MsgIdXAr(Idx)
     C                   END
     C                   ELSE
     C                   MOVE      BNBKCD        DDBOKC
     C                   END
     C                   END
      *
      * Check that the book code exists
      *
     C     DDBokcOK      IFEQ      'Y'
     C     DDBOKC        ANDNE     *BLANKS
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBOKC        @AJCD             3
     C     SDBOOK        PARM      SDBOOK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDBokcOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBOKC'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1038'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVEL     BDBKCD        DDBOKC
     C                   END
     C                   END
      *****************************************************************              CTI004 MD030956
      ***If*FX*generated*from*TI*book*code*should*be*defaulted*from*ICD.             CTI004 MD030956
      *****************************************************************              CTI004 MD030956
     C**********         If        DDDLST = TIDLST and                               CTI004 MD030956
     C**********                   DDBOKC = *blanks and                              CTI004 MD030956
     C**********                   MM_BGN3ST = 'Y'                                   CTI004 MD030956
     C**********         Eval      DDBOKC = TIBOOK                                   CTI004 MD030956
     C**********         EndIf                                                       CTI004 MD030956
      *
      * Update book on deal
      *
     C                   MOVE      DDBOKC        F3BOKC
     C*
     C                   ENDSR
      *******************************************************************
     C/EJECT
      *****************************************************************
      * PTFR - PORTFOLIO REFERENCE VALIDATION
      *****************************************************************
     C     PTFRV         BEGSR
      *
      * Default portfolio if not defined
      *
     C     DDPTFR        IFEQ      *BLANKS
     C     ERPLCS        ANDEQ     *BLANKS
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C     DDPTFR        OREQ      *BLANKS                                      CPB001
     C     BBPRBA        ANDEQ     'Y'                                          CPB001
     C     BGN4ST        ANDEQ     'Y'                                          CPB001
      *                                                                         CAP050
      * If Midas/ToF Interface, take first customer portfolio as default        CAP050
     C*****CAP050******* IFNE      'Y'                                   CAP050 CPB001
     C     BGN4ST        IFNE      'Y'                                          CPB001
     C                   MOVEL     O#PTFR        DDPTFR
     C                   ELSE                                                   CAP050
      *                                                                         CAP050
      * Check if customer has a defined portfolio reference                     CAP050
     C                   MOVEL     QBCUST        PNCNUM                         CAP050
     C                   MOVEL     BBCUST        PNCNUM                         CPB001
     C     PMPORK        SETLL     PMPORTPD                                     CAP050
     C     PNCNUM        READE     PMPORTPD                               65    CAP050
     C     *IN65         IFEQ      '0'                                          CAP050
     C                   MOVEL     PNPTFR        DDPTFR                         CAP050
     C                   ENDIF                                                  CAP050
      *                                                                         CAP050
     C                   ENDIF                                                  CAP050
      *                                                                         CAP050
     C                   END
      *
      ** If record not found or is deleted return error.
      *
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C     BBPRBA        ANDNE     'Y'                                          CPB001
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C     ERPLCS        ANDNE     *BLANKS                                      CPB001
     C     DDPTFR        ANDNE     *BLANKS                                      CPB001
                                                                                CPB001
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C     BBPRBA        ANDNE     'Y'                                          CPB001
     C     BGPFMG        ANDNE     'Y'                                          CPB001
     C     DDPTFR        ANDNE     *BLANKS                                      CPB001
                                                                                CPB001
     C     BGN4ST        ORNE      'Y'                                          CPB001
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C     ERPLCS        ANDNE     *BLANKS                                      CPB001
     C     DDPTFR        ANDNE     *BLANKS                                      CPB001
      *                                                                         CPB001
     C     ERPLCS        IFEQ      'PMA0008'
     C     DDPTFR        ANDNE     *BLANKS
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVE      'N'           DDPtfrOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'PMA0008'     MsgIdXAr(Idx)
     C                   END
     C*****ERPLCS        IFEQ      'PMA0009'                                    CPB001
     C*****DDPTFR        ANDNE     *BLANKS                                      CPB001
     C*****              MOVE      'N'           DDPtfrOK                       CPB001
     C*****              ADD       1             Idx                            CPB001
     C*****              MOVEL     'DDPTFR'      FldNamXAr(Idx)                 CPB001
     C*****              MOVEL     'PMA0009'     MsgIdXAr(Idx)                  CPB001
     C*****              END                                                    CPB001
     C     DDPTFR        IFNE      *BLANKS                                      CPB001
     C     BGN4ST        IFEQ      'Y'                                          CPB001
      *                                                                         CPB001
      ** If The customer is not a Private Banking Customer                      CPB001
      *                                                                         CPB001
     C     BBPRBA        IFNE      'Y'                                          CPB001
     C                   MOVE      'N'           DDPtfrOK                       CPB001
     C                   ADD       1             Idx                            CPB001
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)                 CPB001
      *                                                                         CPB001
      ** If Portffolio Management is On                                         CPB001
      *                                                                         CPB001
     C     BGPFMG        IFEQ      'Y'                                          CPB001
      *                                                                         CPB001
      ** Send the message . Customer doesn't refer to a Portfolio Customer      CPB001
      ** or a Private Banking Customer                                          CPB001
      *                                                                         CPB001
     C                   MOVEL     'PMA0018'     MsgIdXAr(Idx)                  CPB001
     C                   ELSE                                                   CPB001
      *                                                                         CPB001
      ** Send the message . Customer doesn't refer to a Private Banking         CPB001
      ** Customer                                                               CPB001
      *                                                                         CPB001
     C                   MOVEL     'PMA0017'     MsgIdXAr(Idx)                  CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
      *                                                                         CPB001
      ** Else -  Private Banking Module is OFF                                  CPB001
      *                                                                         CPB001
     C                   ELSE                                                   CPB001
      *                                                                         CPB001
      ** If The customer is not a Portfolio Customer                            CPB001
      *                                                                         CPB001
     C     BGPFMG        IFEQ      'Y'                                          CPB001
     C     ERPLCS        ANDEQ     'PMA0009'                                    CPB001
      *                                                                         CPB001
      ** Send the message . Customer doesn't refer to a Portfolio Customer      CPB001
      *                                                                         CPB001
     C                   MOVE      'N'           DDPtfrOK                       CPB001
     C                   ADD       1             Idx                            CPB001
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)                 CPB001
     C                   MOVEL     'PMA0009'     MsgIdXAr(Idx)                  CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
      *
      **  Portfolio entered but no associated book found in
      **  SDBOOKPD to default blank book code, error.
      *
     C     ERPLCS        IFEQ      'PMA0010'
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C                   MOVEL     O#PTFR        DDPTFR
     C                   MOVE      'N'           DDPtfrOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'PMA0010'     MsgIdXAr(Idx)
     C                   END
      *
      **  Book entered but no portfolio reference defined for
      **  default.
      *
     C     ERPLCS        IFEQ      'PMA0011'
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C                   MOVEL     O#PTFR        DDPTFR
     C                   MOVE      'N'           DDPtfrOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'PMA0011'     MsgIdXAr(Idx)
     C                   END
      *
      * If portfolio OK so far
      *
     C     DDPtfrOK      IFEQ      'Y'
     C     ERPLCS        ANDEQ     *BLANKS
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C     DDPtfrOK      OREQ      'Y'                                          CPB001
     C     BGN4ST        ANDEQ     'Y'                                          CPB001
     C     BBPRBA        ANDEQ     'Y'                                          CPB001
      *
      ** If Portfolio reference is blank, get default value
      *
     C     DDPTFR        IFEQ      *BLANKS
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVEL     O#PTFR        DDPTFR
     C                   END
      *
      ** Portfolio reference must exist for Customer
      *
     C     DDPTFR        IFNE      FCR997
     C     *BLANKS       OREQ      FCR997                                       CAP050
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C                   MOVEL     QBCUST        PNCNUM
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C                   MOVEL     BBCUST        PNCNUM                         CPB001
     C                   ENDIF                                                  CPB001
     C     PMPORK        KLIST
     C                   KFLD                    PNCNUM
     C                   KFLD                    DDPTFR
     C     PMPORK        CHAIN     PMPORTPD                           99
     C     *IN99         IFEQ      '1'
     C     PNRECI        OREQ      '*'
     C                   MOVE      'N'           DDPtfrOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'PMM0001'     MsgIdXAr(Idx)
     C     FCPORS        IFEQ      'B'
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVEL     'PMA0013'     MsgIdXAr(Idx)
     C                   END
     C                   END
     C                   END
      *
     C                   END
      *
      ** If portfolio OK so far
      *
     C     DDPtfrOK      IFEQ      'Y'
      *
      ** Store valid Portfolio reference in deal
      *
     C     DDPTFR        IFEQ      FCR997
     C     I#PORS        ANDNE     'B'
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C     I#PORS        OREQ      'B'
     C     DDPTFR        ANDNE     *BLANKS
     C     DDPTFR        ANDEQ     FCR997
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVE      '9997'        F3PTFR
     C                   ELSE
     C                   MOVE      DDPTFR        F3PTFR
     C                   END
      *
      ** Warning if selected Portfolio has been flagged for closure
      *
     C     DDPTFR        IFNE      *BLANKS
     C     DDPTFR        ANDNE     FCR997
     C     PNDPCL        ANDNE     0
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C     DDPTFR        ORNE      *BLANKS                                      CPB001
     C     PNDPCL        ANDNE     0                                            CPB001
     C     BGN4ST        ANDEQ     'Y'                                          CPB001
     C                   MOVE      'W'           DDPtfrOK
     C                   MOVEL     'PMM0003'     MsgIdXAr(Idx)
     C                   END
      *
      ** Bank Portfolio supported, book and portfolio reference
      ** must match in book codes file.
      *
     C     FCPORS        IFEQ      'B'
     C     DDBOKC        ANDNE     *BLANKS
     C     DDPTFR        ANDNE     *BLANKS
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C     DDPTFR        IFNE      O#PTFR
     C                   MOVE      'N'           DDPtfrOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'PMA0012'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *
     C                   END
     C*
     C                   ENDSR
      *******************************************************************
     C/EJECT
      *****************************************************************
      * PRFC - PROFIT CENTRE VALIDATION
      *****************************************************************
     C     PRFCV         BEGSR
      *
      * If insert and profit centres to be defaulted
      * and the customer is valid                                                             179732
      *
     C     DDACTN        IFEQ      'I'
     C     DDPRFC        ANDEQ     *BLANKS
     C     BKPCDU        ANDEQ     'Y'
     C     DDCustOK      ANDEQ     'Y'                                                        179732
     C                   MOVE      *BLANKS       TRTP                           184685
     C                   MOVEL     DDDLTP        TRTP              5
     C***************************************************************                         179732
     C****If*customer*in*error,*set*appropriate*parameters*to*blank**                         179732
     C***************************************************************                         179732
     C*****DDCustOK***** IFEQ      'N'                                                        179732
     C****************** MOVE      *BLANKS       ACOF                                         179732
     C****************** MOVE      *BLANK        CUST                                         179732
     C****************** ELSE                                                                 179732
     C****************** MOVE      BBACOC        ACOF                                         179732
     C****************** MOVE      BBCUST        CUST                                         179732
     C****************** END                                                                  179732
      *                                                                                       179732
     C                   MOVE      BBACOC        ACOF                                         179732
     C                   MOVE      BBCUST        CUST                                         179732
      *                                                                                       CTI004
     C                   If        DDDLST = TIDLST and                                        CTI004
     C                             MM_BGN3ST = 'Y'                                            CTI004
     C                   Eval      DEPT1 = TIDEPT                                             CTI004
     C                   Eval      USER = *blanks                                             CTI004
     C                   else                                                                 CTI004
     C                   Eval      DEPT1 = DEPT                                               CTI004
     C                   Eval      USER = PSUser                                              CTI004
     C                   Endif                                                                CTI004
      *
      * Default profit centre
      *
     C                   CALLB     'AOPRFMR0'
     C                   PARM                    @RTCD
     C                   PARM      DDBOKC        BOOK              2            Book Code
     C                   PARM                    TRTP              5            Transacton Type
     C                   PARM      DDDLST        SUTP              2            Sub Type
     C                   PARM      DDBRSN        BRAN              3            Branch Code
     C**********         PARM      DEPT          DEPT1             3            Deptment Code CTI004
     C**********         PARM      PSUser        USER             10            User          CTI004
     C                   PARM                    DEPT1             3                          CTI004
     C                   PARM                    USER             10                          CTI004
     C                   PARM                    ACOF              2            Account Officer
     C                   PARM                    CUST              6            Customer Number
     C     DDPRFC        PARM                    PRFC              4            Profit Centre
     C     @RTCD         IFEQ      '2'
     C                   MOVE      'N'           DDPrfcOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPRFC'      FldNamXAr(Idx)
     C                   MOVEL     'FXM4001'     MsgIdXAr(Idx)
     C                   END
     C                   END                                                    DDACTN IFEQ 'I'
      *                                                                                       CTI004
      ** If FX generated from TI, take Profit Centre from TI ICD.                             CTI004
      *                                                                                       CTI004
     C                   If        DDDLST = TIDLST and                                        CTI004
     C                             DDPRFC = *blanks and                                       CTI004
     C                             DDACTN = 'I' and                                           CTI004
     C                             MM_BGN3ST = 'Y'                                            CTI004
     C                             OR CTI006 = 'Y' AND                                      MD030956
     C                             DDDLST = TIDLST AND                                      MD030956
     C                             DDPRFC = *BLANKS AND                                     MD030956
     C                             DDACTN = 'I'                                             MD030956
     C                   Eval      DDPRFC = TIPRFC                                            CTI004
     C                   EndIf                                                                CTI004
      *
      * If profit centre is present, or PCA is on, validate profit centre
      *
     C     DDPRFC        IFNE      *BLANKS
     C     BGN0ST        OREQ      'Y'
     C                   CALLB     'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDPRFC        @K101             4
     C     SDPRFC        PARM      SDPRFC        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDPrfcOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPRFC'      FldNamXAr(Idx)
     C                   MOVEL     'FXM4001'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVEL     DSPCCD        DDPRFC
     C                   END
     C                   END                                                    DDACTN IFEQ 'A'
      *
      * Update profit centre on deal
      *
     C                   MOVE      DDPRFC        F3PRFC
      *
     C                   ENDSR
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
     C                   PARM                    RetCodeIn
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1            action code
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDDLST            2            deal sub type
     C                   PARM                    DDBRSN            3            booking branch
      *
     C                   PARM                    DDCUST           10            customer
     C                   PARM                    DDBOKC            2            book
     C                   PARM                    DDPTFR            4            portfolio
     C                   PARM                    DDPRFC            4            profit centre
     C                   PARM                    DDNBUY            1            profit centre
     C                   PARM                    DDNSEL            1            profit centre
     C/COPY WNCPYSRC,FXH00107
      *
      ** Related deal details
     C                   PARM                    RelDealDts                     SW/OP branch
      *
      ** Swap/Opt Deal no OK
      ** Booking branch OK
     C                   PARM                    DDBrsnOK          1            booking branch
     C                   PARM                    DDSdnoOK          1            SW/OP deal no.
      *
      * ICD
     C                   PARM                    BNBCOP            1            new dl status
     C                   PARM                    BNBKCD            2            new dl status
     C                   PARM                    BGPFMG            1
     C                   PARM                    BGUDRS            1
     C                   PARM                    BKPRCU            1
     C                   PARM                    BKPCDU            1
     C                   PARM                    FCR997            4
     C                   PARM                    FCPORS            1
     C                   PARM                    BGN0ST            1
     C                   PARM                    CDL002            1
     C                   PARM                    BGN4ST            1            CPB001
      * Dept from ZMUSER
     C                   PARM                    DEPT              3
      * customer format
      * N = customer number, else customer shortname
     C                   PARM                    CustFormat        1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Customer - OK
      ** Book - OK
      ** Portfolio - OK
      ** Profit Centre - OK
      ** Deal Type - OK
      ** Net Buy Ind - OK
      ** Net Sell Ind - OK
     C                   PARM                    DDCustOK          1            customer
     C                   PARM                    DDBokcOK          1            book
     C                   PARM                    DDPtfrOK          1            portfolio
     C                   PARM                    DDPrfcOK          1            profit centre
     C                   PARM                    DDDltpOK          1            profit centre
     C                   PARM                    DDNbuyOK          1            profit centre
     C                   PARM                    DDNselOK          1            profit centre
      *
      ** Deal Customer number/shortname, book, portfolio, profit centre
      *
     C                   PARM                    F3DCNO                         customer no
     C                   PARM                    F3DCSN           10            customer shtname
     C                   PARM                    F3BOKC            2            book
     C                   PARM                    F3PTFR            4            portfolio
     C                   PARM                    F3PRFC            4            profit centre
      *                                                                         CAP050
      ** Check if Midas/ToF Interface feature is present                        CAP050
     C                   CALLB     'AOSARDR0'                                   CAP050
     C                   PARM      *BLANKS       @RTCD                          CAP050
     C                   PARM      '*VERIFY'     @OPTN                          CAP050
     C                   PARM      'CAP050'      @SARD                          CAP050
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP050
     C     @RTCD         IFEQ      *BLANKS                                      CAP050
     C                   MOVE      'Y'           CAP050            1            CAP050
     C                   ELSE                                                   CAP050
     C                   MOVE      'N'           CAP050                         CAP050
     C                   ENDIF                                                  CAP050
      *                                                                                       CTI004
      ** Access External Modules Details                                                      CTI004
      *                                                                                       CTI004
     C                   CALL      'AOMMODR0'                                                 CTI004
     C                   PARM      *BLANKS       @RTCD                                        CTI004
     C                   PARM      '*FIRST '     @OPTN                                        CTI004
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CTI004
      *                                                                                       CTI004
      ** Access TI ICD Details via access program                                             CTI004
      *                                                                                       CTI004
     C                   CALL      'AOTIINR0'                                                 CTI004
     C                   PARM      '*MSG'        @RTCD                                        CTI004
     C                   PARM      '*FIRST'      @OPTN                                        CTI004
     C     SDTIIN        PARM      SDTIIN        DSFDY                                        CTI004
                                                                                              CTI004
      ** Check if CSD025 (Customer De-Activation) is active                                   CSD025
      *                                                                                       CSD025
     C                   CALLB     'AOSARDR0'                                                 CSD025
     C                   PARM      *BLANKS       @RTCD                                        CSD025
     C                   PARM      '*VERIFY'     @OPTN                                        CSD025
     C                   PARM      'CSD025'      @SARD                                        CSD025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD025
                                                                                              CSD025
     C                   MOVE      'N'           CSD025            1                          CSD025
     C                   IF        @RTCD = *Blanks                                            CSD025
     C                   EVAL      CSD025 = 'Y'                                               CSD025
     C                   ENDIF                                                                CSD025
      *                                                                                     MD030956
      ** Check if CTI006 is enabled                                                         MD030956
      *                                                                                     MD030956
     C                   CALLB     'AOSARDR0'                                               MD030956
     C                   PARM      *BLANKS       @RTCD                                      MD030956
     C                   PARM      '*VERIFY'     @OPTN                                      MD030956
     C                   PARM      'CTI006'      @SARD                                      MD030956
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD030956
     C     @RTCD         IFEQ      *BLANKS                                                  MD030956
     C                   MOVE      'Y'           CTI006            1                        MD030956
     C                   ELSE                                                               MD030956
     C                   MOVE      'N'           CTI006                                     MD030956
     C                   ENDIF                                                              MD030956
                                                                                            MD030956
     C/COPY WNCPYSRC,FXH00108
      *
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

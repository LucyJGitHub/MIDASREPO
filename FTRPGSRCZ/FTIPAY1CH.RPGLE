     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments charges based on lvl 1')    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY1CH - Incoming Payments Charges based on Level 1       *
      *              Details                                          *
      *                                                               *
      *  Function: This module computes for Charges and Commission,   *
      *            and Total VAT Amounts based on Level 1 details.    *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD039094           Date 15May18               *
      *                 MD046248           Date 27Oct17               *
      *               . CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 09Dec03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD039094 - Adjust CFT157 to work with Rabo MHUB              *
      *           - Recompile due to changes in INPAYDD               *
      *           - Applied fix for MD050928                          *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
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
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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
      ** Charges Computation array
     D POWERS          S              7  0 DIM(6) CTDATA PERRCD(1)
      *
      ** Factors array
     D FCTR            S              4  0 DIM(4) CTDATA PERRCD(1)
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *                                                                         CFT014
      ** Incoming Payments (extension) for file update - file format            CFT014
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)                   CFT014
      *
      ** Incoming Payments retrieved from file - file format
     D CrIPFilFmt    E DS                  EXTNAME(INPAYDD)
      *                                                                         CFT014
      ** Incoming Payments (extension) retrieved from file - file format        CFT014
     D CrIP2FilFmt   E DS                  EXTNAME(INPAYXPD) PREFIX(IX)         CFT014
      *
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for Acess Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                         CFT014
      ** DS for account details                                                 CFT014
     D WACCDS        E DS                  EXTNAME(ACCNTAB) PREFIX(AB)          CFT014
      *                                                                         CFT014
      ** DS for full account number                                             CFT014
     D*WGLACC***       DS            18                                                CFT014 CGL029
     D WGLACC          DS            24                                                       CGL029
     D**WGCNUM**               1      6  0                                             CFT014 CSD027
     D  WGCNUM                 1      6                                                       CSD027
     D  WGCCY                  7      9                                         CFT014
     D  WGACOD                10     19  0                                                    CGL029
     D  WGACSQ                20     21  0                                                    CGL029
     D  WGBRCA                22     24                                                       CGL029
     D**WGACOD**              10     13  0                                             CFT014 CGL029
     D**WGACSQ**              14     15  0                                             CFT014 CGL029
     D**WGBRCA**              16     18                                                CFT014 CGL029
      *
      ** DS for calculation of default Charges (FT0320)
      *
     D P7DATA          DS           321
      *
      ** Payment Type and Payment Subtype
     D  W7PYTP                 1      2
     D  W7PYST                 3      4
      *
      ** Input Currency and Charge Currency
     D  W7ICCY                 5      7
     D  W7CCCY                 8     10
      *
      ** Settlement Method
     D  W7STMT                11     12
      *
      ** Defaults Required
     D  W7DFRQ                13     13
      *
      ** Charges Branch
     D  W7BRCA                14     16
      *
      ** Charge Currency Amount
     D  W7CAMT                17     29  0
      *
      ** Transfer Commission Type
     D  W7TRCT                30     30
      *
      ** SWIFT Priority Code
     D  W7SWPC                31     31
      *
      ** Transfer Commission Amount
     D  W7TRCD                32     42  0
     D  W7TRCH                43     53  0
      *
      ** Telex Charge
     D  W7TXCD                54     64  0
     D  W7TXCH                65     75  0
      *
      ** Cheque Charge
     D  W7CQCD                76     86  0
     D  W7CQCH                87     97  0
      *
      ** Costs Abroad
     D  W7CSTD                98    108  0
     D  W7CSTA               109    119  0
      *
      ** SWIFT Priority Charge
     D  W7SPCD               120    130  0
     D  W7SPCH               131    141  0
      *
      ** Miscellaneous Charge
     D  W7MSCD               142    152  0
     D  W7MSCH               153    163  0
      *
      ** Advice Charge
     D  W7ADCD               164    174  0
     D  W7ADCH               175    185  0
      *
      ** Telephone Charge
     D  W7TLCD               186    196  0
     D  W7TLCH               197    207  0
      *
      ** Collection Charge
     D  W7COLD               208    218  0
     D  W7COLL               219    229  0
      *
      ** Payment Amount Currency
     D  W7PCCY               230    232
      *
      ** Other Currency
     D  W7OCCY               233    235
      *
      ** FX/Change Commission (Input Ccy)
     D  W7CHCD               236    246  0
      *
      ** FX/Change Commission (Charge Ccy)
     D  W7CHCM               247    257  0
      *
      ** Our Deductions (Input Ccy)
     D  W7DEDD               258    268  0
      *
      ** Our Deductions (Charge Ccy)
     D  W7DEDS               269    279  0
      *
      ** Correspondent Charge (Input Ccy)
     D  W7COCD               280    290  0
      *
      ** Correspondent Charge (Charge Ccy)
     D  W7COCH               291    301  0
      *
      ** Default Type (HDR or DET or " ")
     D  W7DFTT               302    304
      *
      ** Customer to be Debited the Charge
     D  W7CUST               305    310
      *
      ** Settle Date
     D  W7SLDT               311    315  0
      *
      ** Pay Date
     D  W7PVDT               316    320  0
      *
      ** Add/Deduct Charges
     D  W7ADDC               321    321
      *
      ** Calling parameter DS for FT0035
     D P0DTA           DS           256
     D  WIPT1                  1      1
     D  WIPTY1                 2     36
     D  WIPT2                 37     37
     D  WIPTY2                38     72
     D  WICCY                 73     75
     D  WOCUST                76     81
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
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
      ** Reset Charges, Commissions and VAT Amounts with
      ** original values.
      *
      ** Transfer Commission Amount.
      *
     C                   Z-ADD     DUMA1         IPDUMA1
     C                   Z-ADD     TRCM          IPTRCM
      *
      ** Telex Charge.
      *
     C                   Z-ADD     DUMA2         IPDUMA2
     C                   Z-ADD     TXCH          IPTXCH
      *
      ** Cheque Charge.
      *
     C                   Z-ADD     DUMA3         IPDUMA3
     C                   Z-ADD     CQCH          IPCQCH
      *
      ** Advice Charge.
      *
     C                   Z-ADD     DUMA4         IPDUMA4
     C                   Z-ADD     ADCH          IPADCH
      *
      ** Telephone Charge.
      *
     C                   Z-ADD     DUMA5         IPDUMA5
     C                   Z-ADD     TLCH          IPTLCH
      *
      ** Miscellaneous Charge.
      *
     C                   Z-ADD     DUMA6         IPDUMA6
     C                   Z-ADD     MSCH          IPMSCH
      *
      ** Reset FX/Change Commission if BLI Funds Transfer
      ** Enhancement feature is on.
      *
     C     S01494        IFEQ      'Y'
     C                   Z-ADD     INDUM7        IPINDUM7
     C                   Z-ADD     INCHCM        IPINCHCM
     C                   ENDIF
      *
      ** Reset Total VAT Amount and Total VAT Charge
      ** if BLI VAT Processing feature is on.
      *
     C     S01499        IFEQ      'Y'
     C                   Z-ADD     INDUM8        IPINDUM8
     C                   Z-ADD     INVATT        IPINVATT
     C                   ENDIF
      *
      ** Perform the rest of the processing if action is Amend
      ** and entry point is Level 1.
      *
     C     DDACTN        IFEQ      'A'
     C     PParmLevel    ANDEQ     '1'
      *
      ** If core feature S01508 (BLI Extended Payment Charges) is
      ** installed, determine if "Charges to the Debit of" Customer
      ** has changed using FT0035.
      *
     C                   MOVE      *BLANK        WRDFTC            1
     C                   MOVE      *BLANKS       WDCUS1            6
     C                   MOVE      *BLANKS       WDCUS2            6
      *
     C     S01508        IFEQ      'Y'
     C                   EXSR      SRDRCus
     C                   ENDIF
      *
      ** If Add/Deduct Indicator has changed, then recalculate
      ** Charge values if needed (only if CDRO blank) and
      ** Pay and Settle Currencies differ.
      *
     C*****CDRO***       IFEQ      *ZERO                                                      CSD027
     C     CDRO          IFEQ      *BLANKS                                                    CSD027
      *
     C     IPADDC        IFNE      ADDC
     C     SMCY          ANDNE     PCCY
     C     IPADDC        ORNE      ADDC
     C     IPSMCY        ANDNE     IPPCCY
     C     IPPCCY        ORNE      PCCY
     C     IPADDC        ANDEQ     'D'
     C     IPSMCY        ORNE      SMCY
     C     IPADDC        ANDEQ     'A'
     C     WRDFTC        OREQ      'Y'
     C     IPSMAM        ORNE      SMAM
     C     IPRATE        ORNE      RATE
     C                   EXSR      SRCharge
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Recalculate total VAT Amounts if BLI VAT Processing
      ** feature is on.
      *
     C     S01499        IFEQ      'Y'
     C                   EXSR      SRTotVATAmt
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Return.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDRCus - Determine if "Charges to the DR of" Customer has   *
      *            changed                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRDRCus       BEGSR
      *
      ** Get original "Charges to the Debit of" Customer.
      ** If S01506 is installed, use Ordering Customer details.
      ** If Add/Deduct is 'A', use Ordering Customer and Bank.
      ** - Third Reimbursement Inst. takes precedence if CFT014 is on.          CFT014
      ** If Add/Deduct is 'D', use Destination and Sender's
      ** Correspondent.
      *
     C                   CLEAR                   P0DTA
      *
     C                   SELECT
      *
     C     S01506        WHENEQ    'Y'
     C                   MOVEL     BNCT          WIPT1
     C                   MOVEL     BNC1          WIPTY1
     C                   MOVEL     PCCY          WICCY
      *
     C     ADDC          WHENEQ    'A'
      *                                                                         CFT014
     C                   SELECT                                                 CFT014
      *                                                                         CFT014
     C     IXINTRIT      WHENEQ    'I'                                          CFT014
     C     CFT014        ANDEQ     'Y'                                          CFT014
     C     CFT004        ANDEQ     'Y'                                          CFT014
     C                   EVAL      PIBAN = IXINTRIB                             CFT014
     C                   EXSR      SRIBAN                                       CFT014
     C                   EVAL      WGCNUM = ABCNUM                              CFT014
     C                   EVAL      WGCCY  = ABCCY                               CFT014
     C                   EVAL      WGACOD = ABACOD                              CFT014
     C                   EVAL      WGACSQ = ABACSQ                              CFT014
     C                   EVAL      WGBRCA = ABBRCA                              CFT014
     C                   EVAL      WICCY = SMCY                                 CFT014
     C                   EVAL      WIPT2  = 'G'                                 CFT014
     C                   EVAL      WIPTY2 = WGLACC                              CFT014
      *                                                                         CFT014
     C     IXINTRIT      WHENNE    *BLANKS                                      CFT014
     C     CFT014        ANDEQ     'Y'                                          CFT014
     C                   EVAL      WICCY = SMCY                                 CFT014
     C                   EVAL      WIPT2  = IXINTRIT                            CFT014
     C                   EVAL      WIPTY2 = IXINTRIB                            CFT014
      *                                                                         CFT014
     C     INRCRT        WHENEQ    'I'                                          CFT014
     C     CFT004        ANDEQ     'Y'                                          CFT014
     C                   EVAL      PIBAN = INRCO1                               CFT014
     C                   EXSR      SRIBAN                                       CFT014
     C                   EVAL      WGCNUM = ABCNUM                              CFT014
     C                   EVAL      WGCCY  = ABCCY                               CFT014
     C                   EVAL      WGACOD = ABACOD                              CFT014
     C                   EVAL      WGACSQ = ABACSQ                              CFT014
     C                   EVAL      WGBRCA = ABBRCA                              CFT014
     C                   EVAL      WICCY = SMCY                                 CFT014
     C                   EVAL      WIPT2  = 'G'                                 CFT014
     C                   EVAL      WIPTY2 = WGLACC                              CFT014
      *                                                                         CFT014
     C                   OTHER                                                  CFT014
      *                                                                         CFT014
     C                   MOVEL     SNTP          WIPT1
     C                   MOVEL     SND1          WIPTY1
     C                   MOVEL     SMCY          WICCY
     C*****RCCO          IFNE      *ZEROS                                       CFT014
     C*****              MOVEL     RCRT          WIPT2                          CFT014
     C*****              MOVEL     RCCO          WIPTY2                         CFT014
     C     INRCO1        IFNE      *ZEROS                                       CFT014
     C                   MOVEL     INRCRT        WIPT2                          CFT014
     C                   MOVEL     INRCO1        WIPTY2                         CFT014
     C                   ENDIF
      *                                                                         CFT014
     C                   ENDSL                                                  CFT014
      *
     C     ADDC          WHENEQ    'D'
     C                   MOVEL     BNCT          WIPT1
     C                   MOVEL     BNC1          WIPTY1
     C                   MOVEL     PCCY          WICCY
     C     ACBB          IFNE      *ZEROS
     C                   MOVEL     ACBT          WIPT2
     C     ACBK          CAT(P)    ACBB          WIPTY2
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   CALL      'FT0035'                             9090
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM                    P0DTA
     C                   PARM                    P0MSG           256
      *
     C     *IN90         IFEQ      *ON
     C     PRTCD         ORNE      *BLANKS
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'FT0035'      DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     WOCUST        WDCUS1
      *
      ** Get new "Charges to the Debit of" Customer.
      ** If S01506 is installed, use Ordering Customer details.
      ** If Add/Deduct is 'A', use Ordering Customer and Bank.
      ** If Add/Deduct is 'D', use Destination and Sender's
      ** Correspondent.
      *
     C                   CLEAR                   P0DTA
      *
     C                   SELECT
      *
     C     S01506        WHENEQ    'Y'
     C                   MOVEL     IPBNCT        WIPT1
     C                   MOVEL     IPBNC1        WIPTY1
     C                   MOVEL     IPPCCY        WICCY
      *
     C     IPADDC        WHENEQ    'A'
      *                                                                         CFT014
     C                   SELECT                                                 CFT014
      *                                                                         CFT014
     C     I2INTRIT      WHENEQ    'I'                                          CFT014
     C     CFT014        ANDEQ     'Y'                                          CFT014
     C     CFT004        ANDEQ     'Y'                                          CFT014
     C                   EVAL      PIBAN = I2INTRIB                             CFT014
     C                   EXSR      SRIBAN                                       CFT014
     C                   EVAL      WGCNUM = ABCNUM                              CFT014
     C                   EVAL      WGCCY  = ABCCY                               CFT014
     C                   EVAL      WGACOD = ABACOD                              CFT014
     C                   EVAL      WGACSQ = ABACSQ                              CFT014
     C                   EVAL      WGBRCA = ABBRCA                              CFT014
     C                   EVAL      WICCY = IPSMCY                               CFT014
     C                   EVAL      WIPT2  = 'G'                                 CFT014
     C                   EVAL      WIPTY2 = WGLACC                              CFT014
      *                                                                         CFT014
     C     I2INTRIT      WHENNE    *BLANKS                                      CFT014
     C     CFT014        ANDEQ     'Y'                                          CFT014
     C                   EVAL      WICCY = IPSMCY                               CFT014
     C                   EVAL      WIPT2  = I2INTRIT                            CFT014
     C                   EVAL      WIPTY2 = I2INTRIB                            CFT014
      *                                                                         CFT014
     C     IPINRCRT      WHENEQ    'I'                                          CFT014
     C     CFT004        ANDEQ     'Y'                                          CFT014
     C                   EVAL      PIBAN = IPINRCO1                             CFT014
     C                   EXSR      SRIBAN                                       CFT014
     C                   EVAL      WGCNUM = ABCNUM                              CFT014
     C                   EVAL      WGCCY  = ABCCY                               CFT014
     C                   EVAL      WGACOD = ABACOD                              CFT014
     C                   EVAL      WGACSQ = ABACSQ                              CFT014
     C                   EVAL      WGBRCA = ABBRCA                              CFT014
     C                   EVAL      WICCY = IPSMCY                               CFT014
     C                   EVAL      WIPT2  = 'G'                                 CFT014
     C                   EVAL      WIPTY2 = WGLACC                              CFT014
      *                                                                         CFT014
     C                   OTHER                                                  CFT014
      *                                                                         CFT014
     C                   MOVEL     IPSNTP        WIPT1
     C                   MOVEL     IPSND1        WIPTY1
     C                   MOVEL     IPSMCY        WICCY
     C*****IPRCCO        IFNE      *ZEROS                                       CFT014
     C*****              MOVEL     IPRCRT        WIPT2                          CFT014
     C*****              MOVEL     IPRCCO        WIPTY2                         CFT014
     C     IPINRCO1      IFNE      *ZEROS                                       CFT014
     C                   MOVEL     IPINRCRT      WIPT2                          CFT014
     C                   MOVEL     IPINRCO1      WIPTY2                         CFT014
     C                   ENDIF
      *                                                                         CFT014
     C                   ENDSL                                                  CFT014
      *
     C     IPADDC        WHENEQ    'D'
     C                   MOVEL     IPBNCT        WIPT1
     C                   MOVEL     IPBNC1        WIPTY1
     C                   MOVEL     IPPCCY        WICCY
     C     IPACBB        IFNE      *ZEROS
     C                   MOVEL     IPACBT        WIPT2
     C     IPACBK        CAT(P)    IPACBB        WIPTY2
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   CALL      'FT0035'                             9090
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    P0DTA
     C                   PARM                    P0MSG
      *
     C     *IN90         IFEQ      *ON
     C     PRTCD         ORNE      *BLANKS
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'FT0035'      DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     WOCUST        WDCUS2
      *
      ** Check if a recalculation is supposed to take place.
      *
     C     S01506        IFEQ      'Y'
     C     WDCUS1        IFNE      WDCUS2
     C     IPSMCY        ORNE      SMCY
     C     IPSMAM        ORNE      SMAM
     C     IPRATE        ORNE      RATE
     C                   MOVE      'Y'           WRDFTC
     C                   ENDIF
     C                   ELSE
     C     WDCUS1        IFNE      WDCUS2
     C     IPPYST        ORNE      PYST
     C     IPSMAM        ORNE      SMAM
     C     IPRATE        ORNE      RATE
     C                   MOVE      'Y'           WRDFTC
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCharge - Recalculate Charges                               *
      *                                                               *
      *****************************************************************
      *
     C     SRCharge      BEGSR
      *
     C     WRDFTC        IFEQ      'Y'
      *
      ** If recalculation for extended payment is necessary, format the
      ** parameter for FT0320.
      *
     C                   CLEAR                   P7DATA
     C                   MOVEL     *BLANKS       P7ACT             8
     C                   MOVEL     'IN'          P7ACT
      *
      ** Payment Type and Subtype.
      *
     C                   MOVEL     IPPYTP        W7PYTP
     C                   MOVEL     IPPYST        W7PYST
      *
      ** Input Currency and Charge Currency.
      *
     C                   SELECT
      *
     C     BTCHCY        WHENEQ    'C'
     C     IPADDC        IFEQ      'A'
     C                   MOVE      IPSMCY        W7ICCY
     C                   ELSE
     C                   MOVE      IPPCCY        W7ICCY
     C                   ENDIF
      *
     C     BTCHCY        WHENEQ    'L'
     C                   MOVE      BJLCCY        W7ICCY
      *
     C                   OTHER
     C                   MOVE      BJCYCD        W7ICCY
      *
     C                   ENDSL
      *
     C     IPADDC        IFEQ      'A'
     C                   MOVEL     IPSMCY        W7CCCY
     C                   ELSE
     C                   MOVEL     IPPCCY        W7CCCY
     C                   ENDIF
      *
      ** Settlement Method.
      *
     C                   MOVEL     *BLANKS       W7STMT
      *
      ** Defaults Required.
      *
     C                   MOVEL     'Y'           W7DFRQ
      *
      ** Charges Branch.
      *
     C                   MOVEL     PPYBR         W7BRCA
      *
      ** Charge Currency Amount.
      *
     C                   SELECT
      *
     C     IPADDC        WHENEQ    'A'
     C                   Z-ADD     IPSMAM        W7CAMT
     C                   MOVEL     IPSMCY        W7PCCY
      *
     C                   OTHER
     C                   Z-ADD     IPPYAM        W7CAMT
     C                   MOVEL     IPPCCY        W7PCCY
      *
     C                   ENDSL
      *
      ** Transfer Commission Type.
      *
     C                   MOVEL     TRCT          W7TRCT
      *
      ** SWIFT Priority Code.
      *
     C     IPSWPC        IFEQ      1
     C                   MOVEL     'U'           W7SWPC
     C                   ELSE
     C                   MOVEL     'N'           W7SWPC
     C                   ENDIF
      *
      ** Transfer Commission Amount.
      *
     C                   Z-ADD     IPDUMA1       W7TRCD
     C                   Z-ADD     IPTRCM        W7TRCH
      *
      ** Telex Charge.
      *
     C                   Z-ADD     IPDUMA2       W7TXCD
     C                   Z-ADD     IPTXCH        W7TXCH
      *
      ** Cheque Charge.
      *
     C                   Z-ADD     IPDUMA3       W7CQCD
     C                   Z-ADD     IPCQCH        W7CQCH
      *
      ** Costs Abroad.
      *
     C                   Z-ADD     *ZERO         W7CSTD
     C                   Z-ADD     *ZERO         W7CSTA
      *
      ** SWIFT Priority Charge.
      *
     C                   Z-ADD     *ZERO         W7SPCD
     C                   Z-ADD     *ZERO         W7SPCH
      *
      ** Miscellaneous Charge.
      *
     C                   Z-ADD     IPDUMA6       W7MSCD
     C                   Z-ADD     IPMSCH        W7MSCH
      *
      ** Set up FX/Change Commission if BLI Funds Transfer
      ** Enhancement feature is on.
      *
     C     S01494        IFEQ      'Y'
     C                   Z-ADD     IPINDUM7      W7CHCD
     C                   Z-ADD     IPINCHCM      W7CHCM
     C                   ENDIF
      *
      ** Advice Charge.
      *
     C                   Z-ADD     IPDUMA4       W7ADCD
     C                   Z-ADD     IPADCH        W7ADCH
      *
      ** Telephone Charge.
      *
     C                   Z-ADD     IPDUMA5       W7TLCD
     C                   Z-ADD     IPTLCH        W7TLCH
      *
      ** Collection Charge.
      *
     C                   Z-ADD     *ZERO         W7COLD
     C                   Z-ADD     *ZERO         W7COLL
      *
      ** Other Currency.
      *
     C     IPADDC        IFEQ      'D'
     C                   MOVE      IPSMCY        W7OCCY
     C                   ELSE
     C                   MOVE      IPPCCY        W7OCCY
     C                   ENDIF
      *
      ** Customer to be Debited.
      *
     C                   MOVE      WDCUS2        W7CUST
      *
      ** Call defaults program FT0320.
      *
     C                   CALL      'FT0320'                             9090
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    P7ACT
     C                   PARM                    P7DATA
      *
     C     *IN90         IFEQ      *ON
     C     PRTCD         ORNE      *BLANKS
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'FT0320'      DBFILE
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Reapply old Charges if only Settlement Amount has changed.
      *
     C     IPPCCY        IFEQ      PCCY
     C     IPSMCY        ANDEQ     SMCY
     C                   Z-ADD     IPDUMA2       W7TXCD
     C                   Z-ADD     IPDUMA3       W7CQCD
     C                   Z-ADD     IPDUMA4       W7ADCD
     C                   Z-ADD     IPDUMA5       W7TLCD
     C                   Z-ADD     IPDUMA6       W7MSCD
     C                   ENDIF
      *
      ** Transfer Commission Amount.
      *
     C                   Z-ADD     W7TRCD        IPDUMA1
     C                   Z-ADD     W7TRCH        IPTRCM
      *
      ** Telex Charge.
      *
     C                   Z-ADD     W7TXCD        IPDUMA2
     C                   Z-ADD     W7TXCH        IPTXCH
      *
      ** Cheque Charge.
      *
     C                   Z-ADD     W7CQCD        IPDUMA3
     C                   Z-ADD     W7CQCH        IPCQCH
      *
      ** Advice Charge.
      *
     C                   Z-ADD     W7ADCD        IPDUMA4
     C                   Z-ADD     W7ADCH        IPADCH
      *
      ** Telephone Charge.
      *
     C                   Z-ADD     W7TLCD        IPDUMA5
     C                   Z-ADD     W7TLCH        IPTLCH
      *
      ** Miscellaneous Charge.
      *
     C                   Z-ADD     W7MSCD        IPDUMA6
     C                   Z-ADD     W7MSCH        IPMSCH
      *
      ** Set up FX/Change Commission if BLI Funds Transfer
      ** Enhancement feature is on.
      *
     C     S01494        IFEQ      'Y'
     C                   Z-ADD     W7CHCD        IPINDUM7
     C                   Z-ADD     W7CHCM        IPINCHCM
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If "Charges to the Debit of" Customer is 0, use Pay
      ** or Settle based on BTCHCY Indicator.
      *
     C     BTCHCY        IFEQ      'C'
     C     ADDC          IFEQ      'A'
     C                   MOVE      SMCY          WSCCCY            3
     C                   ELSE
     C                   MOVE      PCCY          WSCCCY
     C                   ENDIF
     C                   ELSE
     C     BTCHCY        IFEQ      'L'
     C                   MOVE      BJLCCY        WSCCCY
     C                   ELSE
     C                   MOVE      BJCYCD        WSCCCY
     C                   ENDIF
     C                   ENDIF
      *
      ** Only convert if file Charge Ccy not base.
      *
     C     WSCCCY        IFNE      BJCYCD
      *
     C                   EXSR      SRConvOldCcy
      *
     C                   ELSE
      *
     C                   Z-ADD     IPDUMA1       WTRCMB
     C                   Z-ADD     IPDUMA2       WTXCHB
     C                   Z-ADD     IPDUMA3       WCQCHB
     C                   Z-ADD     IPDUMA4       WADCHB
     C                   Z-ADD     IPDUMA5       WTLCHB
     C                   Z-ADD     IPDUMA6       WMSCHB
      *
     C     S01494        IFEQ      'Y'
     C                   Z-ADD     IPINDUM7      WCHCMB
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     IPADDC        IFEQ      'A'
     C                   MOVE      IPSMCY        WSCCCY
     C                   ELSE
     C                   MOVE      IPPCCY        WSCCCY
     C                   ENDIF
      *
      ** Only convert if new Charge Ccy not base.
      *
     C     WSCCCY        IFNE      BJCYCD
      *
     C                   EXSR      SRConvNewCcy
      *
     C                   ELSE
      *
     C                   Z-ADD     WTRCMB        IPTRCM
     C                   Z-ADD     WTXCHB        IPTXCH
     C                   Z-ADD     WCQCHB        IPCQCH
     C                   Z-ADD     WADCHB        IPADCH
     C                   Z-ADD     WTLCHB        IPTLCH
     C                   Z-ADD     WMSCHB        IPMSCH
      *
     C     S01494        IFEQ      'Y'
     C                   Z-ADD     WCHCMB        IPINCHCM
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Calculate DAF Amounts.
      *
     C                   EXSR      SRDAFAmt
      *
      ** Determine new Entry Charges.
      *
     C                   EXSR      SREntryChrg
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvOldCcy - Convert file Charges                          *
      *                                                               *
      *****************************************************************
      *
     C     SRConvOldCcy  BEGSR
      *
      ** Access details of file Charge Ccy for Charge calculations.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      WSCCCY        PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     WSCCCY        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     A6MDIN        IFEQ      'M'
     C                   Z-ADD     1             WMDIN             1 0
     C                   ELSE
     C                   Z-ADD     *ZERO         WMDIN
     C                   ENDIF
      *
      ** WN is the difference between decimals for base and
      ** decimals for file Currency - following calc find true
      ** rate (WTSPOT) to convert file Currency to base.
      *
     C     PBCDP         SUB       A6NBDP        WN                1 0
      *
     C     WMDIN         IFEQ      1
     C                   SELECT
     C     WN            WHENGT    *ZERO
     C     A6SPRT        MULT      POWERS(WN)    WTSPOT           15 9
     C     WN            WHENLT    *ZERO
     C                   Z-SUB     WN            WN
     C     A6SPRT        DIV       POWERS(WN)    WTSPOT
     C                   OTHER
     C                   Z-ADD     A6SPRT        WTSPOT
     C                   ENDSL
     C                   ENDIF
      *
     C     WMDIN         IFEQ      *ZERO
     C                   SELECT
     C     WN            WHENGT    *ZERO
     C     A6SPRT        DIV       POWERS(WN)    WTSPOT
     C     WN            WHENLT    *ZERO
     C                   Z-SUB     WN            WN
     C     A6SPRT        MULT      POWERS(WN)    WTSPOT
     C                   OTHER
     C                   Z-ADD     A6SPRT        WTSPOT
     C                   ENDSL
     C                   ENDIF
      *
      ** Use rate to calculate value for amendment in base.
      *
     C     WMDIN         IFEQ      1
     C     IPDUMA1       MULT(H)   WTSPOT        WTRCMB           11 0
     C     IPDUMA2       MULT(H)   WTSPOT        WTXCHB           11 0
     C     IPDUMA3       MULT(H)   WTSPOT        WCQCHB           11 0
     C     IPDUMA4       MULT(H)   WTSPOT        WADCHB           11 0
     C     IPDUMA5       MULT(H)   WTSPOT        WTLCHB           11 0
     C     IPDUMA6       MULT(H)   WTSPOT        WMSCHB           11 0
     C     S01494        IFEQ      'Y'
     C     IPINDUM7      MULT(H)   WTSPOT        WCHCMB           11 0
     C                   ENDIF
     C                   ENDIF
      *
     C     WMDIN         IFEQ      0
     C     IPDUMA1       DIV(H)    WTSPOT        WTRCMB
     C     IPDUMA2       DIV(H)    WTSPOT        WTXCHB
     C     IPDUMA3       DIV(H)    WTSPOT        WCQCHB
     C     IPDUMA4       DIV(H)    WTSPOT        WADCHB
     C     IPDUMA5       DIV(H)    WTSPOT        WTLCHB
     C     IPDUMA6       DIV(H)    WTSPOT        WMSCHB
     C     S01494        IFEQ      'Y'
     C     IPINDUM7      DIV(H)    WTSPOT        WCHCMB
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvNewCcy - Convert new Charges                           *
      *                                                               *
      *****************************************************************
      *
     C     SRConvNewCcy  BEGSR
      *
      ** Access details of new Charge Ccy for Charge calculations.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WSCCCY        PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     WSCCCY        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     A6MDIN        IFEQ      'M'
     C                   Z-ADD     1             WMDIN
     C                   ELSE
     C                   Z-ADD     *ZERO         WMDIN
     C                   ENDIF
      *
      ** WN is the difference between decimals for base and decimals
      ** for Charge Currency - following calcs find true rate (WTSPOT)
      ** to convert base currency back to new Charge Currency.
      *
     C     A6NBDP        SUB       PBCDP         WN
      *
     C     WMDIN         IFEQ      1
     C                   SELECT
     C     WN            WHENGT    *ZERO
     C     A6SPRT        DIV       POWERS(WN)    WTSPOT
     C     WN            WHENLT    *ZERO
     C                   Z-SUB     WN            WN
     C     A6SPRT        MULT      POWERS(WN)    WTSPOT
     C                   OTHER
     C                   Z-ADD     A6SPRT        WTSPOT
     C                   ENDSL
     C                   ENDIF
      *
     C     WMDIN         IFEQ      *ZERO
     C                   SELECT
     C     WN            WHENGT    *ZERO
     C     A6SPRT        MULT      POWERS(WN)    WTSPOT
     C     WN            WHENLT    *ZERO
     C                   Z-SUB     WN            WN
     C     A6SPRT        DIV       POWERS(WN)    WTSPOT
     C                   OTHER
     C                   Z-ADD     A6SPRT        WTSPOT
     C                   ENDSL
     C                   ENDIF
      *
      ** Use rate to calculate new Charge values.
      *
     C     WMDIN         IFEQ      1
     C     WTRCMB        DIV(H)    WTSPOT        IPTRCM
     C     WTXCHB        DIV(H)    WTSPOT        IPTXCH
     C     WCQCHB        DIV(H)    WTSPOT        IPCQCH
     C     WADCHB        DIV(H)    WTSPOT        IPADCH
     C     WTLCHB        DIV(H)    WTSPOT        IPTLCH
     C     WMSCHB        DIV(H)    WTSPOT        IPMSCH
     C     S01494        IFEQ      'Y'
     C     WCHCMB        DIV(H)    WTSPOT        IPINCHCM
     C                   ENDIF
     C                   ENDIF
      *
     C     WMDIN         IFEQ      *ZERO
     C     WTRCMB        MULT(H)   WTSPOT        IPTRCM
     C     WTXCHB        MULT(H)   WTSPOT        IPTXCH
     C     WCQCHB        MULT(H)   WTSPOT        IPCQCH
     C     WADCHB        MULT(H)   WTSPOT        IPADCH
     C     WTLCHB        MULT(H)   WTSPOT        IPTLCH
     C     WMSCHB        MULT(H)   WTSPOT        IPMSCH
     C     S01494        IFEQ      'Y'
     C     WCHCMB        MULT(H)   WTSPOT        IPINCHCM
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDAFAmt - Calculate DAF Amounts                             *
      *                                                               *
      *****************************************************************
      *
     C     SRDAFAmt      BEGSR
      *
     C     WSCCCY        IFNE      BJCYCD
     C                   Z-ADD     A6NBDP        WFCDP             1 0
     C                   ELSE
     C                   Z-ADD     PBCDP         WFCDP
     C                   END
      *
      ** Transfer Commission.
      *
     C     WFCDP         ADD       1             W                 1 0
     C     IPTRCM        DIV       FCTR(W)       IPTRCMD
      *
      ** Telex Charge.
      *
     C     WFCDP         ADD       1             W
     C     IPTXCH        DIV       FCTR(W)       IPTXCHD
      *
      ** Cheque Charge.
      *
     C     WFCDP         ADD       1             W
     C     IPCQCH        DIV       FCTR(W)       IPCQCHD
      *
      ** Advice Charge.
      *
     C     WFCDP         ADD       1             W
     C     IPADCH        DIV       FCTR(W)       IPADCHD
      *
      ** Telephone Charge.
      *
     C     WFCDP         ADD       1             W
     C     IPTLCH        DIV       FCTR(W)       IPTLCHD
      *
      ** Miscellaneous Charge.
      *
     C     WFCDP         ADD       1             W
     C     IPMSCH        DIV       FCTR(W)       IPMSCHD
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREntryChrg - Determine new Entry Charges                    *
      *                                                               *
      *****************************************************************
      *
     C     SREntryChrg   BEGSR
      *
     C     BTCHCY        IFEQ      'C'
      *
      ** Or BTCHCY is set TO 'B' for base currency and default
      ** Charge Ccy is base.
      *
     C     BTCHCY        OREQ      'B'
     C     WSCCCY        ANDEQ     BJCYCD
      *
      ** Or BTCHCY is set to 'L' for local currency and local
      ** is the same ccy as base and default Charge Ccy is base.
      *
     C     BTCHCY        OREQ      'L'
     C     BJCYCD        ANDEQ     BJLCCY
     C     WSCCCY        ANDEQ     BJCYCD
      *
      ** Or BTCHCY is set to 'L' for local currency and default
      ** Charge Currency is the same as local ccy.
      *
     C     BTCHCY        OREQ      'L'
     C     WSCCCY        ANDEQ     BJLCCY
     C                   Z-ADD     IPTRCM        IPDUMA1
     C                   Z-ADD     IPTXCH        IPDUMA2
     C                   Z-ADD     IPCQCH        IPDUMA3
     C                   Z-ADD     IPADCH        IPDUMA4
     C                   Z-ADD     IPTLCH        IPDUMA5
     C                   Z-ADD     IPMSCH        IPDUMA6
     C     S01494        IFEQ      'Y'
     C                   Z-ADD     IPINCHCM      IPINDUM7
     C                   ENDIF
     C                   GOTO      EEntryChrg
     C                   ENDIF
      *
      ** Input capable Charge field may be based with right hand
      ** side not base - here use base Commission Charge already
      ** calculated.
      *
     C     BTCHCY        IFEQ      'B'
     C     WSCCCY        ANDNE     BJCYCD
     C     BTCHCY        OREQ      'L'
     C     BJLCCY        ANDEQ     BJCYCD
     C                   Z-ADD     WTRCMB        IPDUMA1
     C                   Z-ADD     WTXCHB        IPDUMA2
     C                   Z-ADD     WCQCHB        IPDUMA3
     C                   Z-ADD     WADCHB        IPDUMA4
     C                   Z-ADD     WTLCHB        IPDUMA5
     C                   Z-ADD     WMSCHB        IPDUMA6
     C     S01494        IFEQ      'Y'
     C                   Z-ADD     WCHCMB        IPINDUM7
     C                   ENDIF
     C                   GOTO      EEntryChrg
     C                   ENDIF
      *
     C                   Z-ADD     WTRCMB        WAmtB            11 0
     C                   EXSR      SRChgLt
     C                   MOVE      WAmtE         IPDUMA1
      *
     C                   Z-ADD     WTXCHB        WAmtB
     C                   EXSR      SRChgLt
     C                   MOVE      WAmtE         IPDUMA2
      *
     C                   Z-ADD     WCQCHB        WAmtB
     C                   EXSR      SRChgLt
     C                   MOVE      WAmtE         IPDUMA3
      *
     C                   Z-ADD     WADCHB        WAmtB
     C                   EXSR      SRChgLt
     C                   MOVE      WAmtE         IPDUMA4
      *
     C                   Z-ADD     WTLCHB        WAmtB
     C                   EXSR      SRChgLt
     C                   MOVE      WAmtE         IPDUMA5
      *
     C                   Z-ADD     WMSCHB        WAmtB
     C                   EXSR      SRChgLt
     C                   MOVE      WAmtE         IPDUMA6
      *
     C     S01494        IFEQ      'Y'
     C                   Z-ADD     WCHCMB        WAmtB
     C                   EXSR      SRChgLt
     C                   MOVE      WAmtE         IPINDUM7
     C                   ENDIF
      *
     C     EEntryChrg    ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChgLt  - Convert Amount to Local Currency Equivalent       *
      *                                                               *
      *****************************************************************
      *
     C     SRChgLt       BEGSR
      *
      ** WH is the difference between decimals for base and decimals for
      ** local currency - following calcs find true rate (PLSPOT) to
      ** convert base currency to local.
      *
     C     PLCDP         SUB       PBCDP         WH                1 0
      *
     C     PLMDIN        IFEQ      1
     C                   SELECT
     C     WH            WHENGT    *ZERO
     C     PLSPOT        DIV       POWERS(WH)    WTSPOT
     C     WH            WHENLT    *ZERO
     C                   Z-SUB     WH            WH
     C     PLSPOT        MULT      POWERS(WH)    WTSPOT
     C                   OTHER
     C                   Z-ADD     PLSPOT        WTSPOT
     C                   ENDSL
     C                   ENDIF
      *
     C     PLMDIN        IFEQ      *ZERO
     C                   SELECT
     C     WH            WHENGT    *ZERO
     C     PLSPOT        MULT      POWERS(WH)    WTSPOT
     C     WH            WHENLT    *ZERO
     C                   Z-SUB     WH            WH
     C     PLSPOT        DIV       POWERS(WH)    WTSPOT
     C                   OTHER
     C                   Z-ADD     PLSPOT        WTSPOT
     C                   ENDSL
     C                   ENDIF
      *
      ** Use rate to calculate default value in local currency.
      *
     C     PLMDIN        IFEQ      1
     C     WAmtB         DIV(H)    WTSPOT        WAmtE            11 0
     C                   ENDIF
      *
     C     PLMDIN        IFEQ      *ZERO
     C     WAmtB         MULT(H)   WTSPOT        WAmtE
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTotVATAmt - Recalculate Total VAT Amounts                  *
      *                                                               *
      *****************************************************************
      *
     C     SRTotVATAmt   BEGSR
      *
     C                   Z-ADD     PVATR         IPINVATR
     C                   Z-ADD     *ZERO         IPINDUM8
     C                   Z-ADD     *ZERO         IPINVATT
      *
      ** If apply VAT flag is 'Y', calculate VAT Charge.
      *
      ** Transfer Commission.
      *
     C     INVAT1        IFEQ      'Y'
     C     IPDUMA1       MULT(H)   PVATR         WVATD            13 0
     C     IPTRCM        MULT(H)   PVATR         WVATT            13 0
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
      ** Telex Charge.
      *
     C     INVAT2        IFEQ      'Y'
     C     IPDUMA2       MULT(H)   PVATR         WVATD
     C     IPTXCH        MULT(H)   PVATR         WVATT
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
      ** Cheque Charge.
      *
     C     INVAT3        IFEQ      'Y'
     C     IPDUMA3       MULT(H)   PVATR         WVATD
     C     IPCQCH        MULT(H)   PVATR         WVATT
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
      ** Advice Charge.
      *
     C     INVAT4        IFEQ      'Y'
     C     IPDUMA4       MULT(H)   PVATR         WVATD
     C     IPADCH        MULT(H)   PVATR         WVATT
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
      ** Telephone Charge.
      *
     C     INVAT5        IFEQ      'Y'
     C     IPDUMA5       MULT(H)   PVATR         WVATD
     C     IPTLCH        MULT(H)   PVATR         WVATT
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
      ** Miscellaneous Charge.
      *
     C     INVAT6        IFEQ      'Y'
     C     IPDUMA6       MULT(H)   PVATR         WVATD
     C     IPMSCH        MULT(H)   PVATR         WVATT
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
      ** FX/Change Commission.
      *
     C     S01494        IFEQ      'Y'
     C     INVAT7        IFEQ      'Y'
     C     IPINDUM7      MULT(H)   PVATR         WVATD
     C     IPINCHCM      MULT(H)   PVATR         WVATT
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRIBAN   - Retrieves the full account number of an IBAN acc. *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
     C     SRIBAN        BEGSR                                                  CFT014
      *                                                                         CFT014
     C                   CALL      'AOIBANR4'                                   CFT014
     C                   PARM      *BLANKS       @RTCD                          CFT014
     C                   PARM      '*KEY   '     @OPTN                          CFT014
     C                   PARM                    PIBAN            34            CFT014
     C     WACCDS        PARM      *BLANKS       DSSDY                          CFT014
     C     @RTCD         IFNE      *BLANKS                                      CFT014
     C                   MOVEL     '*CALL   '    DBKEY                          CFT014
     C                   MOVEL     'AOIBANR4'    DBFILE                         CFT014
     C                   Z-ADD     6             DBASE                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *****************************************************************         CFT014
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
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
      *                                                                         CFT014
      ** Incoming Payments (extension) retrieved from file - file fmt           CFT014
     C                   PARM                    CrIP2FilFmt                    CFT014
      *                                                                         CFT014
      ** Incoming Payments (extension) for file update - file format            CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      *
      ** Charges Branch
     C                   PARM                    PPYBR             3
      *
      ** Base Currency No. of Decimal Places
     C                   PARM                    PBCDP             1 0
      *
      ** Local Currency No. of Decimal Places
     C                   PARM                    PLCDP             1 0
      *
      ** Local Currency Multiply/Divide Indicator
     C                   PARM                    PLMDIN            1 0
      *
      ** Local Currency Spot Rate
     C                   PARM                    PLSPOT           13 8
      *
      ** Entry Point
     C                   PARM                    PParmLevel        1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD            3
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY            3
      *
      ** SDFTFR - Charges Currency
     C                   PARM                    BTCHCY            1
      *
      ** VAT Rate
     C                   PARM                    PVATR             5 4
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494            1
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499            1
      *
      ** BLI Payment Charges Enhancements
     C                   PARM                    S01506            1
      *
      ** BLI Extended Payment Charges
     C                   PARM                    S01508            1
      *                                                                         CFT014
      ** FT Batch Authorization and Credit Advices                              CFT014
     C                   PARM                    CFT004            1            CFT014
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014            1            CFT014
      *
      ** OUTPUT
      ** ======
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
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
**  POWERS
0000010
0000100
0001000
0010000
0100000
1000000
**  FCTR
0001
0010
0100
1000

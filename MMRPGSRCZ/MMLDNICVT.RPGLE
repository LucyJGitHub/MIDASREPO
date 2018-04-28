     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits cnvt file to screen format')   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNICVT - Loans/Deposits Conversion: File to Screen Format *
      *                                                               *
      *  Function:  This module converts the fields of a loan/deposit *
      *             from their format as on file to a screen format.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 245692             Date 12Dec13               *
      *                 AR845336           Date 10Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 BUG11107           Date 25Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 211926             Date 09Dec02               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL011             Date 07Jul02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208051             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 185276             Date 15Dec00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 29Jun99               *
      *                 CAP051             Date 09Nov99               *
      *                 CDL007             Date 05Oct99               *
      *                 CPB001             Date 02Sep99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 156618             Date 05Feb99               *
      *                 154477             Date 29Jan99               *
      *                 154453             Date 06Nov98               *
      *                 CAP003             Date 05May98               *
      *                 136941             Date 10Jun98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  AR845336 - Zero contractual spread validation issue          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  BUG11107 - If short term rate exists, this should be the     *
      *             value of the Actual Interest Rate.                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  211926 - When checking whether the Funding Spread/Rate was   *
      *           changed on Amend, convert fields DDFSRP and @DDFSRP *
      *           to numeric first before comparing them.             *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CDL011 - Expansion of Customer Number on Dealing Transactions*
      *  208051 - Ensure -ve interest amounts appear on screen as     *
      *           -x.xx and a -ve interest amount can be keyed in.    *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CAP067 - Repurchase Agreements API. (Recompiled)             *
      *  185276 - Read BKRATAA insteat of FORATAA.                    *
      *  CSE006 - Repurchase Agreement Enhancements                   *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *  CPB001 - 'Private Banking' Module                            *
      *  CGL011 - Collateral Processing for Midas                     *
      *  156618 - Field DDRACD not being set up when AUS007 on.       *
      *  154477 - Recompile for change to MMDELDPP.                   *
      *  154453 - Applied fix 128710.                                 *
      *           Base ccy rate tolerance work field is to small.     *
      *           Increased the size of @ULIM.  Applied fix 114480.   *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs. (RECOMPILED)                           *
      *  136941 - Brokerage wrongly edited                            *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F*FORAT*****IF   E           K DISK                                                      185276
     FBKRAT1    IF   E           K DISK                                                       185276
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Deal Status
     D @STSA           S             24    DIM(5) CTDATA PERRCD(1)
 
     D CGL011          S              1A   EXPORT                                             CGL011
                                                                                              CGL011
      * Deal in File Format
     D DealFilFmt    E DS                  EXTNAME(MMDELDPP)
     D   BsDayFil            148    181                                                       CDL096
 
      * Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(MMLDNIPD)
     D   BsDayScn            667    700                                                       CDL096
     D/COPY WNCPYSRC,MMLDNIND01
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** EXTERNAL DS FOR Portfolio Management DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
 
     D                 DS
     D  @@SXP1                 1      1  0
     D  @@SXP2                 2      2  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CAS001
      ** Define fields used in CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
     D PRTCD           S              7A                                                      CAS001
     D POPTN           S              7A                                                      CAS001
     D PSARD           S              6A                                                      CAS001
                                                                                              CAS005
      ** Define fields used in CAS005                                                         CAS005
                                                                                              CAS005
     D CAS005          S              1A                                                      CAS005
     D CDL033          S              1A                                                      CDL033
      *                                                                                       CDL033
      ** Defined fields for parameter to be passed to ZFRPED                                  CDL033
      *                                                                                       CDL033
     D PZFLD15         S             15P 0                                                    CDL033
     D PZDECS          S              1P 0                                                    CDL033
     D PZECODE         S              1A                                                      CDL033
     D PZWRK25         S             25A                                                      CDL033
      *                                                                                       CER020
     D CER020          S              1A                                                      CER020
     D CRE073          S              1A                                                      CRE073
     D CDL096          S              1A                                                      CDL096
      *                                                                                       CER020
      ** Defined fields for parameter to be passed to SRZDate2                                CER020
      *                                                                                       CER020
     D PZDate          S              6P 0                                                    CER020
     D PZDayNo         S              5P 0                                                    CER020
     D PZaDate         S              7A                                                      CER020
     D PZDtFmt         S              1A                                                      CER020
      *                                                                                       CDL033
      ** Format amount returned by standard subroutine                                        CDL033
      *                                                                                       CDL033
     D                 DS                                                                     CDL033
     D  PZOUT22                1     22                                                       CDL033
     D  PZOUT21                1     21                                                       CDL033
     D  PZOUT20                1     20                                                       CDL033
     D  PZNEG                 21     21                                                       CDL033
      *                                                                                       245692
     D                 DS                                                                     245692
     D  W#AMTP                 1     17                                                       245692
     D  W#AMTD                 1     16                                                       245692
     D  W#NEG                 17     17                                                       245692
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      ** SET OUTPUT SCREEN FIELDS
      *
     C                   EXSR      SETFLD
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - SET OUTPUT SCREEN FIELDS
      *****************************************************************
     C     SETFLD        BEGSR
     C*
     C**  Deal number.
     C                   MOVE      HKDN38        DDDLNO
     C*
     C**  Deal type.
     C                   MOVE      HKMTYP        DDTYPE
     C*
     C**  Deal sub-type.
     C                   MOVE      HKSTYP        DDSTYP
     C*
     C**  Federal funds indicator
     C                   MOVE      HKFEDF        DDFEDF
     C*
     C**  Portfolio Reference
     C*
     C     BGPFMG        IFEQ      'Y'
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C     HKPTFR        IFEQ      '9997'
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVE      FCR997        DDPTFR
     C                   ELSE
     C                   MOVE      HKPTFR        DDPTFR
     C                   END
     C                   END
     C*
     C** Deal date.
     C                   Z-ADD     HKDDYY        @@YEAR
     C                   Z-ADD     HKDDMM        @@MNTH
     C                   Z-ADD     HKDDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDDLDT
     C                   END
     C*
     C**  Branch code.
     C     HKBRCA        IFNE      *BLANKS
     C                   MOVE      HKBRCA        DDBRCA
     C                   END
     C*
     C**  Broker Code.
     C                   MOVE      HKBKCD        DDBKCD
     C*
     C**  Access R/A Indicator for deal if Australian Brokerage
     C**  is switched on
     C*
     C     AUS007        IFEQ      'Y'
     C*****HKDN38        CHAIN     FORAT                              99                      185276
     C     HKDN38        CHAIN     BKRAT1                             99                      185276
     C     *IN99         IFEQ      '0'
     C                   MOVE      RACD          DDRACD
     C                   ELSE                                                                 185276
     C                   MOVE      HKRACD        DDRACD                                       185276
     C                   END
     C                   END
     C*
     C**  Brokerage amount.
     C**  Format brokerage, using broker ccy decimal places
     C*
     C*****HKBRKG        IFEQ      *ZERO                                        136941
     C*****              MOVE      '0'           DDBRKG                         136941
     C*****              END                                                    136941
     C*
     C**  IF BROKERAGE A NUMBER, REFORMAT
     C*
     C     HKBRKG        IFNE      *ALL'9'
     C*****HKBRKG        ANDNE     *ZERO                                        136941
     C*
     C** Access currency for number of decimal places of broker currency.
     C** If brokerage currency is blank, assume deal currency.
     C*
     C     AUS007        IFEQ      'N'
     C     AUS007        OREQ      'Y'
     C     DDRACD        ANDNE     'R'
     C     HKBKCY        IFNE      *BLANKS
     C                   MOVE      HKBKCY        @AJCD             3
     C                   ELSE
     C                   MOVE      HKCCY         @AJCD
     C                   END
     C*
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   ELSE
     C     AUS007        IFEQ      'Y'
     C                   Z-ADD     7             A6NBDP
     C                   END
     C                   END
     C*
     C** Format brokerage
     C                   Z-ADD     HKBRKG        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDBRKG
     C                   END
     C*                                                                         CDL007
     C**  Penalty amount.                                                       CDL007
     C**  Format penalty, using deal ccy decimal places                         CDL007
     C*                                                                         CDL007
     C                   MOVE      *BLANKS       DDPENA                         CDL007
     C     CDL007        IFEQ      'Y'                                          CDL007
     C     HKPENA        IFNE      0                                            CDL007
     C                   Z-ADD     HKPENA        @@AMTW                         CDL007
     C                   Z-ADD     HKCYDP        @@QECN                         CDL007
     C                   EXSR      FMTAMT                                       CDL007
     C                   MOVE      @@AMTD        DDPENA                         CDL007
     C                   ENDIF                                                  CDL007
     C                   ENDIF                                                  CDL007
     C*
     C**  Rollover Deal Number.
     C                   MOVE      HKDADN        DDDADN
     C*
     C**  Customer.
     C     CustFormat    IFEQ      'N'
     C                   MOVEL     HKCNUM        DDCUST
     C                   ELSE
     C                   MOVEL     HKCSNM        DDCUST
     C                   END
     C*
     C**  Value date.
     C                   Z-ADD     HKVDYY        @@YEAR
     C                   Z-ADD     HKVDMM        @@MNTH
     C                   Z-ADD     HKVDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDVDAT
     C                   END
     C*
     C**  Maturity Date.
     C                   Z-ADD     HKMDYY        @@YEAR
     C                   Z-ADD     HKMDMM        @@MNTH
     C                   Z-ADD     HKMDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDMDAT
     C                   END
      *                                                                                       CER020
      ** Initial Start Date and Final Maturity Date                                           CER020
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
     C                   EVAL      PZDayNo = HKISDT                                           CER020
     C                   EXSR      SRZDate2                                                   CER020
     C                   MOVEL     PZDate        DDISDT                                       CER020
      *                                                                                       CER020
     C                   IF        HKFMDT <> *ZEROS                                           CER020
      *                                                                                       CER020
     C                   EVAL      PZDayNo = HKFMDT                                           CER020
     C                   EXSR      SRZDate2                                                   CER020
     C                   MOVEL     PZDate        DDFMDT                                       CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Original Deal Number, if present                                                     CER020
      *                                                                                       CER020
     C                   IF        HKORDN <> *ZEROS                                           CER020
      *                                                                                       CER020
     C                   MOVEL     HKORDN        DDORDN                                       CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
     C/COPY WNCPYSRC,MMLDNINC01
     C*
     C**  Notice Days.
     C     HKNTCE        IFEQ      0
     C     DDTYPE        IFEQ      'CD'
     C     DDMDAT        ANDEQ     *BLANKS
     C     DDTYPE        OREQ      'CL'
     C     DDMDAT        ANDEQ     *BLANKS
     C     DDTYPE        OREQ      'DL'
     C     DDMDAT        ANDEQ     *BLANKS
     C                   MOVE      0             DDNTCE
     C                   END
     C                   ELSE
     C     HKNTCE        IFNE      -999
     C                   Z-ADD     HKNTCE        @@AMTW
     C                   Z-ADD     0             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDNTCE
     C                   END
     C                   END
     C*
     C**  Account Sequnce Number.
     C     HKACSQ        IFNE      0
     C                   MOVE      HKACSQ        DDACSQ
     C                   END
     C*
     C**  Currency Code.
     C                   MOVE      HKCCY         DDCCY
     C*
     C**  Deal Amount.
     C**  Format Deal Amount, using deal ccy decimal places
     C*
     C     HKAMNP        IFLT      0
     C                   Z-SUB     HKAMNP        @@AMTW
     C                   ELSE
     C                   Z-ADD     HKAMNP        @@AMTW
     C                   END
     C                   Z-ADD     HKCYDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDAMNP
     C*
     C**  Base Currency Rate.
     C**  Access the currency file to find the dealing currency
     C**  scaling exponent.
     C*
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C**  Scale the Base Currency Exchange Rate.
     C*
     C                   Z-ADD     A6SCEX        @@SXP1
     C                   Z-ADD     0             @@SXP2
     C                   Z-ADD     HKBRAT        @@INRT
     C                   MOVE      'M'           @@FCMD
     C                   EXSR      SCLRAT
     C*
     C**  Format the rate, using 8 decimal places
     C*
     C     @@SCRT        IFNE      0
     C     @@SCRT        MULT      100000000     @@AMTW
     C                   Z-ADD     8             @@QECN
      *                                                                         154453
      * Fix to allow for 5 integers, if required (& only 7 decimal)             154453
     C                   MOVE      *ZERO         WPOS1             1 0          154453
     C                   MOVEL     @@SCRT        WPOS1                          154453
     C     WPOS1         IFNE      *ZERO                                        154453
     C                   Z-ADD     7             @@QECN                         154453
     C     @@AMTW        DIV       10            @@AMTW                         154453
     C                   END                                                    154453
      *                                                                         154453
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDBRAT
     C                   END
     C*
     C**  Base Rate Code.
     C     HKBSRC        IFNE      *ZEROS
     C                   MOVE      HKBSRC        DDBSRC
     C                   END
     C*
     C**  Spread/Rate - if no Base Rate Code has been entered, use the
     C**  Input Interest Rate, otherwise use the Spread.
     C*
     C     DDBSRC        IFEQ      *BLANKS
     C                   Z-ADD     HKIIRT        WWIIRT           11 7                        211926
     C*****HKIIRT        IFLT      0                                                          208051
     C**********         Z-SUB     HKIIRT        HKIIRT                                       208051
     C**********         END                                                                  208051
     C**********         MOVE      HKIIRT        @@AMTW                                       211926
     C                   MOVE      WWIIRT        @@AMTW                                       211926
     C                   ELSE
     C                   Z-ADD     HKSPRD        WWSPRD           11 7                        211926
     C*****HKSPRD        IFLT      0                                                          208051
     C*********          Z-SUB     HKSPRD        HKSPRD                                       208051
     C**********         END                                                                  208051
     C**********         MOVE      HKSPRD        @@AMTW                                       211926
     C                   MOVE      WWSPRD        @@AMTW                                       211926
     C                   END
     C*
     C**  Format the Spread/Rate, using 7 decimal places
     C*
     C                   Z-ADD     7             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDSPRT
     C*
     C**  Interest Calculation Method.
     C                   MOVE      HKICMT        DDICMT
     C*
     C**  Negative Interest Indicator.
     C                   MOVE      HKNGVI        DDNGVI
     C*
     C**  Interest Payment Frequency.
     C                   MOVE      HKIPFQ        DDIPFQ
     C*
     C**  Format the Next Interest Date.
     C                   Z-ADD     HKNIYY        @@YEAR
     C                   Z-ADD     HKNIMM        @@MNTH
     C                   Z-ADD     HKNIDD        @@DAY
     C     @@DTIN        IFNE      *ZERO
     C     DDIPFQ        ANDNE     'N'
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDNDAT
     C                   END
      *                                                                                       CRE073
      ** Contractual Spread                                                                   CRE073
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C**********         IF        HKCNSP <> *ZEROS                                  CRE073 AR845336
     C     HKCNSP        MULT      10000000      @@AMTW                                       CRE073
     C                   Z-ADD     7             @@QECN                                       CRE073
     C                   EXSR      FMTAMT                                                     CRE073
     C                   MOVE      @@AMTD        DDCNSP                                       CRE073
     C**********         ENDIF                                                       CRE073 AR845336
      *                                                                                       CRE073
      ** Rounding Method                                                                      CRE073
      *                                                                                       CRE073
     C                   MOVEL     HKRDMT        DDRDMT                                       CRE073
      *                                                                                       CRE073
      ** Rounding Fraction/Decimal                                                            CRE073
      *                                                                                       CRE073
     C                   MOVEL     HKRDFD        DDRDFD                                       CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
     C*
     C**  Total interest amount.
     C*
     C     HKNGVI        IFEQ      'Y'                                                        208051
      *                                                                                       208051
     C     HKMTTI        IFGT      0                                                          208051
     C                   Z-SUB     HKMTTI        @@AMTW                                       208051
     C                   ELSE                                                                 208051
     C                   Z-ADD     HKMTTI        @@AMTW                                       208051
     C                   END                                                                  208051
     C                   ELSE                                                                 208051
     C     HKMTTI        IFLT      0
     C                   Z-SUB     HKMTTI        @@AMTW
     C                   ELSE
     C                   Z-ADD     HKMTTI        @@AMTW
     C                   END
      *                                                                                       208051
     C                   END                                                                  208051
      *                                                                                       208051
     C                   Z-ADD     HKCYDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDTOTI
     C*
     C**  Interest Payment Day of Month.
     C     HKIPDM        IFNE      *ZEROS
     C     HKIPFQ        ANDNE     *BLANK
     C     HKIPFQ        ANDNE     'N'
     C                   MOVE      HKIPDM        DDIPDM
     C                   END
     C*
     C**  Interest Capitalisation Indicator.
     C                   MOVE      HKCPTI        DDCPTI
     C*
     C**  Taxable Indicator.
     C*
     C** IF BRT SAR IS INSTALLED
     C*
     C     S01383        IFEQ      'Y'
     C                   MOVE      HKMTAX        DDMTAX
     C                   ELSE
     C     HKMTAX        IFEQ      *BLANKS
     C                   MOVE      'N'           DDMTAX
     C                   ELSE
     C                   MOVE      HKMTAX        DDMTAX
     C                   END
     C                   END
     C*
     C**  C.D. Reference Number.
     C                   MOVE      HKCDRF        DDCDRF
     C*
     C**  Current Holder of CD.
     C*****HKMCDH        IFNE      0                                                          CSD027
     C     HKMCDH        IFNE      *BLANKS                                                    CSD027
     C                   MOVE      HKMCDH        DDCDCH
     C                   END
     C*
     C**  Front Up Interest Indicator
     C*
     C                   MOVE      HKFUID        DDFUID
     C*
     C**  First & Last Day Interest Indicator
     C*
     C                   MOVE      HKFLID        DDFLID
     C*
     C**  Round Down Interest Indicator
     C                   MOVE      HKRDFC        DDRDFC
     C*
     C**  Book code.
     C                   MOVE      HKBOKC        DDBOKC
     C*
     C**  Linked reference number.
     C     HKLNKN        IFNE      *ZEROS
     C                   MOVE      HKLNKN        DDLNKN
     C                   END
     C*
     C** Special processing for ID/IL deals
     C*
     C     HKMTYP        IFEQ      'ID'
     C     HKMTYP        OREQ      'IL'
     C                   MOVE      *BLANKS       DDDADN
     C                   MOVE      HKDADN        DDLNKN
     C                   END
     C*
     C**  Repo/Pledge Indicator
     C                   MOVE      HKDRID        DDDRID
     C*
     C**  Repo/Pledge Number
     C                   MOVE      HKDDMR        DDDDMR
     C*
     C**  Originating Branch
     C                   MOVE      HKORBR        DDORBR
     C*
     C**  Profit Centre
     C                   MOVE      HKPRFC        DDPRFC
     C*
     C**  Automatic Rollover Indicator
     C                   MOVE      HKAURO        DDAURO
     C*
     C**  Interest Paid Separately Indicator
     C                   MOVE      HKIPDS        DDIPDS
     C*
     C**  Rollover Frequency
     C                   MOVE      HKROFQ        DDROFQ
     C*
     C**  Rollover Day Number
     C*
     C     HKRLDN        IFNE      0
     C                   MOVE      HKRLDN        DDRLDN
     C                   END
     C*
     C**  Interest Settlement Method
     C*
     C                   MOVE      HKIMET        DDIMET
     C*
     C**  Interest Settlement Account
     C                   MOVE      HKINSA        DDINSA
     C*
     C**  Interest Counterparty Nostro
     C                   MOVE      HKINOS        DDINOS
     C*
     C**  Confirmation Narrative
     C                   MOVE      HKCNNA        DDCNNA
     C*
     C**  Funding Spread/Rate.
     C*
     C     HKFSRP        IFNE      0
     C     HKFSGN        ORNE      *BLANKS
     C     HKFPRC        ORNE      *BLANKS
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      HKFSRP        @@AMTW
     C                   Z-ADD     7             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDFSRP
     C                   ENDIF
     C*
     C**  Funding Spread Sign and Funding Profit Centre.
     C*
     C                   MOVEL     HKFSGN        DDFSGN
     C                   MOVEL     HKFPRC        DDFPRC
     C*
     C**  Interest Settlement Currency & 'In' Currency in Field 72.
     C*
     C                   MOVEL     HKISCY        DDISCY
     C                   MOVEL     HKII72        DDII72
     C*
     C**  Brokerage Rate/Amount indicator if AUS007 on.                         156618
     C*                                                                         156618
     C     AUS007        IFEQ      'Y'                                          156618
     C                   MOVE      HKRACD        DDRACD                         156618
     C                   END                                                    156618
     C*                                                                         156618
     C**  Set up text for deal status.
     C*
     C     HKDSTS        IFEQ      'C'
     C                   MOVE      @STSA(1)      DDSTS
     C                   END
     C*
     C     HKDSTS        IFEQ      'A'
     C                   MOVE      @STSA(2)      DDSTS
     C                   END
     C*
     C     HKDSTS        IFEQ      'R'
     C                   MOVE      @STSA(3)      DDSTS
     C                   END
     C*
     C     HKDSTS        IFEQ      'M'
     C                   MOVE      @STSA(4)      DDSTS
     C                   END
     C*
     C     HKDDLT        IFEQ      'D'
     C                   MOVE      @STSA(5)      DDSTS
     C                   END
     C*
     C     CGL011        IfEq      'Y'                                                        CGL011
      *                                                                                       CGL011
     C     HKCOLF        IfEq      'Y'                                                        CGL011
     C                   Move      'COLLATERAL'  DDCSTS                                       CGL011
     C                   Else                                                                 CGL011
     C                   Move      *BLANKS       DDCSTS                                       CGL011
     C                   EndIf                                                                CGL011
      *                                                                                       CGL011
     C                   EndIf                                                                CGL011
      *                                                                                       CGL011
     C* Format Transaction Type                                                 CSE006
     C                   IF        HKMTYP = 'IT' or HKMTYP = 'CD'               CSE006
     C                             or HKMTYP = 'TD'                             CSE006
                                                                                CSE006
     C                   IF        HKDRID = 'R'                                 CSE006
     C                   MOVE      'RP'          DDTRTP                         CSE006
     C                   ENDIF                                                  CSE006
                                                                                CSE006
     C                   IF        HKDRID = 'B'                                 CSE006
     C                   MOVE      'BL'          DDTRTP                         CSE006
     C                   ENDIF                                                  CSE006
                                                                                CSE006
     C                   IF        HKDRID = 'P'                                 CSE006
     C                   MOVE      'PD'          DDTRTP                         CSE006
     C                   ENDIF                                                  CSE006
                                                                                CSE006
     C                   ENDIF                                                  CSE006
                                                                                CSE006
     C                   IF        HKMTYP = 'IP' or HKMTYP = 'CL'               CSE006
     C                             or HKMTYP = 'TI'                             CSE006
                                                                                CSE006
     C                   IF        HKDRID = 'R'                                 CSE006
     C                   MOVE      'RR'          DDTRTP                         CSE006
     C                   ENDIF                                                  CSE006
                                                                                CSE006
     C                   IF        HKDRID = 'B'                                 CSE006
     C                   MOVE      'BB'          DDTRTP                         CSE006
     C                   ENDIF                                                  CSE006
                                                                                CSE006
     C                   IF        HKDRID = 'P'                                 CSE006
     C                   MOVE      'PL'          DDTRTP                         CSE006
     C                   ENDIF                                                  CSE006
                                                                                CSE006
     C                   ENDIF                                                  CSE006
                                                                                CSE006
      ** Yield Curves                                                                         CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C                   EVAL      DDOYLC = HKOYLC                                            CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
      ** Set up the fields introduced by CDL033                                               CDL033
                                                                                              CDL033
     C                   IF        (CDL033 = 'Y' AND DDTYPE = 'CF')                           CDL033
     C                             OR (CDL033 = 'Y' AND DDTYPE = 'CI')                        CDL033
     C                             OR (CDL033 = 'Y' AND DDTYPE = 'IP')                        CDL033
     C                             OR (CDL033 = 'Y' AND DDTYPE = 'IT')                        CDL033
     C                             OR (CDL033 = 'Y' AND DDTYPE = 'TI')                        CDL033
     C                             OR (CDL033 = 'Y' AND DDTYPE = 'TD')                        CDL033
      *                                                                                       CDL033
      ** Rate Change Date                                                                     CDL033
      *                                                                                       CDL033
     C                   IF        HKRCDT = 0                                                 CDL033
     C                   EVAL      DDRCDT = *BLANKS                                           CDL033
     C                   ELSE                                                                 CDL033
     C                   CALLB     'ZDATE2'                                                   CDL033
     C                   PARM      HKRCDT        PDateIn                                      CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM      *ZEROS        PDateOut                                     CDL033
     C                   PARM      *BLANKS       PADateOut                                    CDL033
     C                   MOVE      PDateOut      DDRCDT                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   MOVEL     HKRCFR        DDRCFR                                       CDL033
      *                                                                                       CDL033
      ** Rate Change Day                                                                      CDL033
      *                                                                                       CDL033
     C                   IF        HKRCDM = 0                                                 CDL033
     C                   EVAL      DDRCDM = *BLANKS                                           CDL033
     C                   ELSE                                                                 CDL033
     C                   MOVE      HKRCDM        DDRCDM                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Short-term Rate                                                                      CDL033
      *                                                                                       CDL033
     C                   IF        HKSTRF = 'Y'                                               CDL033
     C**********         EVAL      PZFLD15 = HKSTRT * 10000000                         CDL033 245692
     C                   EVAL      W#AMTW  = HKSTRT * 10000000                                245692
     C                   ELSE                                                                 CDL033
     C**********         MOVE      DDSTRT        PZFLD15                               CDL033 245692
     C                   MOVE      DDSTRT        W#AMTW                                       245692
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C**********         EVAL      PZDECS  = 7                                         CDL033 245692
     C                   EVAL      W#DECP  = 7                                                245692
     C**********         CALLB     'ZFRPED'                                            CDL033 245692
     C**********         PARM                    PZFLD15                               CDL033 245692
     C**********         PARM                    PZDECS                                CDL033 245692
     C**********         PARM      'L'           PZECODE                               CDL033 245692
     C**********         PARM      *BLANKS       PZOUT22                               CDL033 245692
     C**********         PARM      *BLANKS       PZWRK25                               CDL033 245692
     C                   CALLB     'ZA0921'                                                   245692
     C                   PARM                    @@RETC                                       245692
     C                   PARM                    W#AMTW           15 0                        245692
     C                   PARM                    W#DECP            1 0                        245692
     C                   PARM                    BNDCSP            1                          245692
     C                   PARM                    W#AMTD           16                          245692
     C                   PARM                    W#AMTP           17                          245692
      *                                                                                       CDL033
     C*****PZNEG         IFEQ      '-'                                                 CDL033 245692
     C**********         MOVE      PZOUT21       DDSTRT                                CDL033 245692
     C**********         ELSE                                                          CDL033 245692
     C**********         MOVE      PZOUT20       DDSTRT                                CDL033 245692
     C**********         ENDIF                                                         CDL033 245692
     C     W#NEG         IFEQ      '-'                                                        245692
     C                   MOVE      W#AMTP        DDSTRT                                       245692
     C                   ELSE                                                                 245692
     C                   MOVE      W#AMTD        DDSTRT                                       245692
     C                   ENDIF                                                                245692
      *                                                                                       CDL033
      ** Rate Fix Days                                                                        CDL033
      *                                                                                       CDL033
     C                   IF        HKFXDM = 0                                                 CDL033
     C                   EVAL      DDFXDM = *BLANKS                                           CDL033
     C                   ELSE                                                                 CDL033
     C                   MOVE      HKFXDM        DDFXDM                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Forward Yield Curve                                                                  CDL033
      *                                                                                       CDL033
     C                   EVAL      DDFYLD = HKFYLD                                            CDL033
      *                                                                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Liquidity Premium                                                                    CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C     HKLQPR        MULT      10000000      @@AMTW                                       CAS005
     C                   Z-ADD     7             @@QECN                                       CAS005
     C                   EXSR      FMTAMT                                                     CAS005
     C                   MOVE      @@AMTD        DDLQPR                                       CAS005
     C                   EVAL      DDLQPS = HKLQPS                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      *                                                                                       CDL016
      ** Rollover Indicator                                                                   CDL016
     C                   IF        CDL016 = 'Y'                                               CDL016
     C                   EVAL      DDROLI = HKROLI                                            CDL016
      *                                                                                       CDL016
      ** Source of Funds                                                                      CDL016
     C                   EVAL      DDSOFD = HKSOFD                                            CDL016
      *                                                                                       CDL016
      ** Blocked Indicator                                                                    CDL016
     C                   EVAL      DDBLKA = HKBLKA                                            CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL017
      ** Cancellation Date                                                                    CDL017
     C                   IF        HKCAND <> 0                                                CDL017
     C                   Z-ADD     HKCAND        PDateIn                                      CDL017
     C                   EXSR      CVTMDAT                                                    CDL017
     C                   MOVEL     PDateOut      DDCAND                                       CDL017
     C                   ELSE                                                                 CDL017
     C                   MOVE      *BLANKS       DDCAND                                       CDL017
     C                   ENDIF                                                                CDL017
      *                                                                                       CDL017
      ** Penalty Pay/Receive                                                                  CDL017
     C                   EVAL      DDPNPR = HKPNPR                                            CDL017
      *                                                                                       CDL019
      ** Fix Base Rate                                                                        CDL019
     C                   IF        CDL019 = 'Y'                                               CDL019
     C                   EVAL      DDFBRT = HKFBRT                                            CDL019
     C                   ENDIF                                                                CDL019
      *                                                                                       CDL020
      ** Format Actual Interest Rate, using 7 decimal places                                  CDL020
     C                   IF        CDL020 = 'Y'                                               CDL020
     C                   IF        HKBSRC <> *BLANKS                                          CDL020
     C                   Z-ADD     0             @@AMTW                                       CDL020
     C                   MOVE      HKINTR        @@AMTW                                       CDL020
     C                   Z-ADD     7             @@QECN                                       CDL020
     C                   EXSR      FMTAMT                                                     CDL020
     C                   MOVE      @@AMTD        DDAIR                                        CDL020
     C                   ELSE                                                                 CDL020
     C                   MOVE      *BLANKS       DDAIR                                        CDL020
     C                   ENDIF                                                                CDL020
      *                                                                                       CDL020
     C                   ENDIF                                                                CDL020
      *                                                                                     BUG11107
      ** Use Short Term Rate if existing as Actual Interest Rate                            BUG11107
     C                   IF        CDL033 = 'Y'                                             BUG11107
     C                   IF        HKSTRT > 0                                               BUG11107
     C                   Z-ADD     0             @@AMTW                                     BUG11107
     C                   MOVE      HKSTRT        @@AMTW                                     BUG11107
     C                   Z-ADD     7             @@QECN                                     BUG11107
     C                   EXSR      FMTAMT                                                   BUG11107
     C                   MOVE      @@AMTD        DDAIR                                      BUG11107
     C                   ENDIF                                                              BUG11107
      *                                                                                     BUG11107
     C                   ENDIF                                                              BUG11107
      *                                                                                       CDL038
      * Class                                                                                 CDL038
     C                   MOVE      HKCLAS        DDCLAS                                       CDL038
      *                                                                                       CDL049
      * Format Reference Rate                                                                 CDL049
     C     CDL049        IFEQ      'Y'                                                        CDL049
     C                   MOVE      HKRRAT        @@AMTW                                       CDL049
     C                   Z-ADD     8             @@QECN                                       CDL049
     C                   EXSR      FMTAMT                                                     CDL049
     C                   MOVE      @@AMTD        DDRRAT                                       CDL049
     C                   ENDIF                                                                CDL049
                                                                                              CDL096
     C                   IF        CDL096 = 'Y'                                               CDL096
     C                   EVAL      DDC1PC = HKC1PC                                            CDL096
     C                   EVAL      DDC2PC = HKC2PC                                            CDL096
     C                   EVAL      DDC3PC = HKC3PC                                            CDL096
     C                   EVAL      DDC4PC = HKC4PC                                            CDL096
     C                   EVAL      DDC5PC = HKC5PC                                            CDL096
     C                   EVAL      DDC6PC = HKC6PC                                            CDL096
     C                   EVAL      DDC7PC = HKC7PC                                            CDL096
     C                   EVAL      DDC8PC = HKC8PC                                            CDL096
     C                   EVAL      DDC9PC = HKC9PC                                            CDL096
     C                   EVAL      DDC0PC = HKC0PC                                            CDL096
     C                   EVAL      DDPYDC = HKPYDC                                            CDL096
     C                   EVAL      DDAMTC = HKAMTC                                            CDL096
     C                   ENDIF                                                                CDL096
      *                                                                                       CDL096
     C                   IF        CDL096 = 'N'                                               CDL096
     C                   Eval      BsDayScn = BsDayFil                                        CDL096
     C                   ENDIF                                                                CDL096
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CDL017
      * CVTMDAT - CONVERT MIDAS DATE TO DDMMYY (OR MMDDYY)            *                       CDL017
      *****************************************************************                       CDL017
     C     CVTMDAT       BEGSR                                                                CDL017
      *                                                                                       CDL017
     C                   CALLB     'ZDATE2'                                                   CDL017
     C                   PARM                    PDateIn           5 0                        CDL017
     C                   PARM                    BJDFIN                                       CDL017
     C                   PARM      *ZERO         PDateOut          6 0                        CDL017
     C                   PARM      *BLANKS       PADateOut         7                          CDL017
      *                                                                                       CDL017
     C                   ENDSR                                                                CDL017
      *****************************************************************                       CDL017
      /EJECT                                                                                  CDL017
      *****************************************************************
      * CVTDAT - CONVERT DATE FROM YYYYMMDD TO DDMMYY (OR MMDDYY)     *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALLB     'ZA0770'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@DTIN
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         @@DTOU            6 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM                    BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCLRAT - SCALE RATE                                           *
      *****************************************************************
     C     SCLRAT        BEGSR
      *
     C                   CALLB     'ZA1150'
     C                   PARM                    @@SXP1            1 0
     C                   PARM                    @@SXP2            1 0
     C*****              PARM                    @@INRT           12 8          154453
     C                   PARM                    @@INRT           13 8          154453
     C                   PARM                    @@FCMD            1
     C*****              PARM      *ZEROS        @@SCRT           12 8          154453
     C*****              PARM      *ZEROS        @@ISRT           12 8          154453
     C                   PARM      *ZEROS        @@SCRT           13 8          154453
     C                   PARM      *ZEROS        @@ISRT           13 8          154453
     C                   PARM      *ZEROS        @@ERCD            1 0
      *
     C                   ENDSR
      *****************************************************************                       CER020
      /EJECT                                                                                  CER020
      *****************************************************************                       CER020
      *                                                               *                       CER020
      *  SRZDate2: Routine to Day Number to DDMMYY                    *                       CER020
      *                                                               *                       CER020
      *  Called by: SETFLD                                            *                       CER020
      *                                                               *                       CER020
      *  Calls: None                                                  *                       CER020
      *                                                               *                       CER020
      *****************************************************************                       CER020
     C     SRZDate2      BEGSR                                                                CER020
      *                                                                                       CER020
     C                   CALL      'ZDATE2'                                                   CER020
     C                   PARM                    PZDayNo                                      CER020
     C                   PARM      BJDFIN        PZDtFmt                                      CER020
     C                   PARM      *ZEROS        PZDate                                       CER020
     C                   PARM      *BLANKS       PZaDate                                      CER020
      *                                                                                       CER020
     C                   ENDSR                                                                CER020
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN DEAL FORMAT)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        DealScnFmt
     C                   MOVEL     ##ACTN        DDACTN
     C                   MOVEL     *BLANK        DDSTS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Deal in file format
     C                   PARM                    DealFilFmt
     C/COPY WNCPYSRC,MMLDNINC02
      *
      * Output parameters
      *
      * Deal in screen format
     C                   PARM                    DealScnFmt
     C/COPY WNCPYSRC,MMLDNINC03
      *
      * Deal Status
     C                   PARM                    DDSTS            24
      *                                                                                       CGL011
      ** Collateral Status                                                                    CGL011
      *                                                                                       CGL011
     C                   PARM                    DDCSTS           10                          CGL011
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMLDNICVT'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
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
      ** ACCESS DEALING DETAILS
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS MIDAS MODULES
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS PORTFOLIO MANAGEMNT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST'      @OPTN             7
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C                   END
      *
      ** ACCESS SAR DETAILS FOR Australian Brokerage
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'AUS007'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'AUS007'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 904 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           AUS007            1
     C                   ELSE
     C                   MOVEL     'N'           AUS007
     C                   END
      *
      ** ACCESS SAR DETAILS FOR Basic Rate Tax
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01383'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '905'         DBASE                          * DBERR 905 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   ELSE
     C                   MOVEL     'N'           S01383
     C                   END
      *
      ** ACCESS SAR DETAILS FOR Customer Format
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CDL005'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '906'         DBASE
     C                   EXSR      *PSSR                                        *************
     C                   END
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat        1
     C                   ELSE
     C                   MOVEL     'N'           CustFormat
     C                   END
      *                                                                                       CDL011
      ** Access SAR details for Expansion of Customer Number                                  CDL011
      *                                                                                       CDL011
     C                   CALLB     'AOSARDR0'                                                 CDL011
     C                   PARM      *BLANKS       @RTCD                                        CDL011
     C                   PARM      '*VERIFY'     @OPTN                                        CDL011
     C                   PARM      'CDL011'      @SARD                                        CDL011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL011
      *                                                                                       CDL011
      * DATABASE ERROR                                                                        CDL011
      *                                                                                       CDL011
     C     @RTCD         IFNE      *BLANKS                                                    CDL011
     C     @RTCD         ANDNE     '*NRF   '                                                  CDL011
     C                   MOVEL     'CDL011'      DBKEY                                        CDL011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL011
     C                   MOVEL     '909'         DBASE                                        CDL011
     C                   EXSR      *PSSR                                                      CDL011
     C                   END                                                                  CDL011
     C*                                                                                       CDL011
     C     @RTCD         IFEQ      *BLANK                                                     CDL011
     C                   MOVEL     'S'           CustFormat                                   CDL011
     C                   END                                                                  CDL011
      *                                                                                       CGL011
      ** Access Switchable Features file to check if CGL011                                   CGL011
      ** is installed.                                                                        CGL011
      *                                                                                       CGL011
     C                   Move      'N'           CGL011                                       CGL011
      *                                                                                       CGL011
     C                   CallB     'AOSARDR0'                                                 CGL011
     C                   Parm      *BLANKS       @RTCD                                        CGL011
     C                   Parm      '*VERIFY'     @OPTN                                        CGL011
     C                   Parm      'CGL011'      @SARD             6                          CGL011
     C     SCSARD        Parm      SCSARD        DSFDY                                        CGL011
                                                                                              CGL011
     C     @RTCD         IfNe      *BLANKS                                                    CGL011
     C     @RTCD         AndNe     '*NRF   '                                                  CGL011
     C     *Lock         In        LDA                                                        CGL011
     C                   MoveL     '906'         DBASE                                        CGL011
     C                   MoveL     'SCSARDPD'    DBFILE                                       CGL011
     C                   MoveL     'CGL011'      DBKEY                                        CGL011
     C                   Out       LDA                                                        CGL011
     C                   Exsr      *PSSR                                                      CGL011
     C                   EndIf                                                                CGL011
      *                                                                                       CGL011
     C     @RTCD         IfEq      *BLANKS                                                    CGL011
     C                   Move      'Y'           CGL011                                       CGL011
     C                   EndIf                                                                CGL011
      *                                                                         CDL007
      ** ACCESS SAR DETAILS FOR Deposit Breakdown Penalty                       CDL007
      *                                                                         CDL007
     C                   CALLB     'AOSARDR0'                                   CDL007
     C                   PARM      *BLANKS       @RTCD                          CDL007
     C                   PARM      '*VERIFY'     @OPTN                          CDL007
     C                   PARM      'CDL007'      @SARD                          CDL007
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL007
      *                                                                         CDL007
      * DATABASE ERROR                                                          CDL007
      *                                                                         CDL007
     C     @RTCD         IFNE      *BLANKS                                      CDL007
     C     @RTCD         ANDNE     '*NRF   '                                    CDL007
     C                   MOVEL     'CDL007'      DBKEY                          CDL007
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL007
     C                   MOVEL     '907'         DBASE                          CDL007
     C                   EXSR      *PSSR                                        CDL007
     C                   ENDIF                                                  CDL007
     C*                                                                         CDL007
     C     @RTCD         IFEQ      *BLANK                                       CDL007
     C                   MOVEL     'Y'           CDL007            1            CDL007
     C                   ELSE                                                   CDL007
     C                   MOVEL     'N'           CDL007                         CDL007
     C                   ENDIF                                                  CDL007
                                                                                              CAS001
      ** Access SAR details file to determine if CAS001 is on.                                CAS001
      ** (Net Present Value Accounting)                                                       CAS001
                                                                                              CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
                                                                                              CAS001
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
     C     *LOCK         IN        LDA                                                        CAS001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
     C                   EVAL      DBASE = 908                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   OUT       LDA                                                        CAS001
     C                   EXSR      *PSSR                                                      CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
     C/COPY WNCPYSRC,MMLDNINC04
                                                                                              CAS005
      ** Access SAR details file to determine if CAS005 is on.                                CAS005
      ** (Enhancements to CAS001, CAS002 and CAS004)                                          CAS005
                                                                                              CAS005
     C                   CALLB     'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
     C                   IF        PRTCD <> *BLANKS AND                                       CAS005
     C                             PRTCD <> '*NRF   '                                         CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBASE = 909                                                CAS005
     C                   EVAL      DBKEY = 'CAS005'                                           CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        PRTCD = *BLANKS                                            CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CDL016
      ** Access SAR details file to determine if CDL016 is switched on                        CDL016
      ** (Autumatic Rollover of Fixed Term Loan/Deposit)                                      CDL016
                                                                                              CDL016
     C                   CallB     'AOSARDR0'                                                 CDL016
     C                   Parm      *Blanks       PRTCD                                        CDL016
     C                   Parm      '*VERIFY'     POPTN                                        CDL016
     C                   Parm      'CDL016'      PSARD                                        CDL016
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL016
      *                                                                                       CDL016
     C                   Move      'N'           CDL016            1                          CDL016
     C                   If        PRTCD = *Blanks                                            CDL016
     C                   Eval      CDL016 = 'Y'                                               CDL016
     C                   Endif                                                                CDL016
                                                                                              CDL019
      ** Access SAR details file to determine if CDL019 is switched on                        CDL019
      ** (Allow Base Rate Changes on Fixed Deposits/Loans)                                    CDL019
                                                                                              CDL019
     C                   CallB     'AOSARDR0'                                                 CDL019
     C                   Parm      *Blanks       PRTCD                                        CDL019
     C                   Parm      '*VERIFY'     POPTN                                        CDL019
     C                   Parm      'CDL019'      PSARD                                        CDL019
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL019
      *                                                                                       CDL019
     C                   Move      'N'           CDL019            1                          CDL019
     C                   If        PRTCD = *Blanks                                            CDL019
     C                   Eval      CDL019 = 'Y'                                               CDL019
     C                   Endif                                                                CDL019
                                                                                              CDL020
      ** Access SAR details file to determine if CDL020 is switched on                        CDL020
      ** (Apply Base Rate at Value Date)                                                      CDL020
                                                                                              CDL020
     C                   CallB     'AOSARDR0'                                                 CDL020
     C                   Parm      *Blanks       PRTCD                                        CDL020
     C                   Parm      '*VERIFY'     POPTN                                        CDL020
     C                   Parm      'CDL020'      PSARD                                        CDL020
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL020
      *                                                                                       CDL020
     C                   Move      'N'           CDL020            1                          CDL020
     C                   If        PRTCD = *Blanks                                            CDL020
     C                   Eval      CDL020 = 'Y'                                               CDL020
     C                   Endif                                                                CDL020
      *                                                                                       CDL033
      ** Access SAR details file to determine if CDL033 is switched on                        CDL033
      *                                                                                       CDL033
     C                   CallB     'AOSARDR0'                                                 CDL033
     C                   Parm      *Blanks       PRTCD                                        CDL033
     C                   Parm      '*VERIFY'     POPTN                                        CDL033
     C                   Parm      'CDL033'      PSARD                                        CDL033
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL033
      *                                                                                       CDL033
     C                   Move      'N'           CDL033            1                          CDL033
     C                   If        PRTCD = *Blanks                                            CDL033
     C                   Eval      CDL033 = 'Y'                                               CDL033
     C                   Endif                                                                CDL033
      *                                                                                       CDL049
      ** Access SAR details for Additional Reference Rate (CDL049)                            CDL049
      *                                                                                       CDL049
     C                   CallB     'AOSARDR0'                                                 CDL049
     C                   Parm      *Blanks       PRTCD                                        CDL049
     C                   Parm      '*VERIFY'     POPTN                                        CDL049
     C                   Parm      'CDL049'      PSARD                                        CDL049
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL049
      *                                                                                       CDL049
     C                   Move      'N'           CDL049            1                          CDL049
     C                   If        PRTCD = *Blanks                                            CDL049
     C                   Eval      CDL049 = 'Y'                                               CDL049
     C                   Endif                                                                CDL049
      *                                                                                       CER020
      ** Access SAR details file to determine if CER020 is on.                                CER020
      *                                                                                       CER020
     C                   CALLB     'AOSARDR0'                                                 CER020
     C                   PARM      *BLANKS       PRTCD                                        CER020
     C                   PARM      '*VERIFY'     POPTN                                        CER020
     C                   PARM      'CER020'      PSARD                                        CER020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER020
      *                                                                                       CER020
     C                   IF        PRTCD = *BLANKS                                            CER020
      *                                                                                       CER020
     C                   EVAL      CER020 = 'Y'                                               CER020
     C                   ELSE                                                                 CER020
     C                   EVAL      CER020 = 'N'                                               CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CRE073
      ** Access SAR details file to determine if CRE073 is on.                                CRE073
      *                                                                                       CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM      '*VERIFY'     POPTN                                        CRE073
     C                   PARM      'CRE073'      PSARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
      *                                                                                       CRE073
     C                   IF        PRTCD = *BLANKS                                            CRE073
      *                                                                                       CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
      *                                                                                       CRE073
     C                   ENDIF                                                                CRE073
      *
      *                                                                                       CDL096
      ** Access SAR details file to determine if CDL096 is on.                                CDL096
      *                                                                                       CDL096
     C                   CALLB     'AOSARDR0'                                                 CDL096
     C                   PARM      *BLANKS       PRTCD                                        CDL096
     C                   PARM      '*VERIFY'     POPTN                                        CDL096
     C                   PARM      'CDL096'      PSARD                                        CDL096
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL096
      *                                                                                       CDL096
     C                   IF        PRTCD = *BLANKS                                            CDL096
     C                   EVAL      CDL096 = 'Y'                                               CDL096
     C                   ELSEIF    PRTCD = '*NRF'                                             CDL096
     C                   EVAL      CDL096 = 'N'                                               CDL096
     C                   ELSE                                                                 CDL096
                                                                                              CDL096
      ** Access program error                                                                 CDL096
     C                   MOVEL     'CDL096'      DBKEY                                        CDL096
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL096
     C                   MOVEL     '910'         DBASE                                        CDL096
     C                   EXSR      *PSSR                                                      CDL096
      *                                                                                       CDL096
     C                   ENDIF                                                                CDL096
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** TEXT FOR DEAL STATUS
COMPLETE
AUTHORIZED
REQUIRES REAUTHORIZATION
MATURED
DELETED

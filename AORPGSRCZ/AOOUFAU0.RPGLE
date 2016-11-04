     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  DFTACTGRP(*NO) ACTGRP(*CALLER)                               *
/*EXI *  TEXT('Midas AO On-line update of LE position files')         *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects Module                                *
      *                                                               *
      *  AOOUFAU0 - On-line Update of LE Positions files              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR943686           Date 23Sep16               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CAP205             Date 03Mar10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE038             Date 04Jun04               *
      *                 CSD027             Date 09Dec05               *
      *                 CRE020             Date 20Jan04               *
      *                 CSC022             Date 24Feb04               *
      *                 223947             Date 19Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 30Oct03               *
      *                 220257             Date 31Jul03               *
      *                 219608             Date 16Jul03               *
      *                 218782             Date 18Jun03               *
      *                 218338             Date 29May03               *
      *                 CLE034             Date 23May03               *
      *                 CLE033             Date 26Mar03               *
      *                 CLE031             Date 06Feb03               *
      *                 CAP084             Date 15May02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 CAP072             Date 15May02               *
      *                 205400             Date 10Jun02               *
      *                 204452             Date 03May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CLE009             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 134284             Date  2Mar99               *
      *                 CEU004             Date 02Feb98               *
      *                 CLE005 *Create     Date 22May97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR943686 - CLE031. System generating wrong projected move-   *
      *             ments. Populate settlement details field with     *
      *             passed value. (Child: AR943687)                   *
      *           - Applied for MD-40690                              *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CLE038 - Lending Enhancement for Nordea: Allocation by Amount*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  223947  - Decimal Data error if CLE033 is switched off, due  *
      *           to a blank BJDNWD. Bug 678.                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  220257 - Negative amounts should be converted to positive on *
      *           LEHOSTPD and the Pay/Receive indicator changed      *
      *  219608 - Amendment of Settlement Allocations needs a 'Before'*
      *           image to ensure the right allocations are reversed. *
      *  218782 - Add Program ref, Sequence Number & Status fields to *
      *           LEHOSTPD. Check system value Settlement09Postings to*
      *           decide whether to use Settlement or Transaction Ccy.*
      *  218338 - Clear Transaction Type and Event Description fields.*
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A.       *
      *  CLE033 - Settlement method 09                                *
      *  CLE031 - Lending Enhancements.                               *
      *  CAP084 - FEST wrapper - convert to ILE pgm to prevent SQL    *
      *           record locking                                      *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee Adjustments API                    *
      *           Recompiled due to changes in LEFEAD                 *
      *  205400 - Projected A/C postings not updated when a fee       *
      *           settlement has been inserted/amended/reversed.      *
      *  204452 - Recompiled due to changed PF/LEFEED.                *
      *  CLE009 - LE I/C Swift Message Generation for Fees            *
      *           Recompiled due to changes in LEFEED                 *
      *  134284 - Do not rollback lending updates in batch mode.      *  *
      *  CEU004 - LE Settlement Ccy Conversion Upgrade to DBA R2.0    *
      *  CLE005 - New program for redesign of update to PRONO, MEMOS, *
      *           OLPOS & RSACMTPD.                                   *
      *                                                               *
      *****************************************************************
     FLEFEEDL1  IF   E           K DISK
     FLEHOSTPD  O    E             DISK                                                       CLE033
     F                                     COMMIT                                             CLE033
     F/COPY WNCPYSRC,AOOUFAU0F1
      /SPACE 5
      *
      ** Program Status Data Structure                                                        CSC022
      ** =============================                                                        CSC022
      ** The following /COPY line includes all the defined fields in the                      CSC022
      ** PSDS.  They have meaningful names, prefixed by 'PS'.                                 CSC022
      *                                                                                       CSC022
     D/COPY ZACPYSRC,PSDS                                                                     CSC022
      *                                                                                       CSC022
      *  Subroutine stack
     D @STK            S             10    DIM(20)
      *
      *  Array for job name                                                                   CSC022
     D ARRJBNAM        S             10A   DIM(10)                                            CSC022
      **  Copyright array.
     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D/COPY WNCPYSRC,AOH00027
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
     D/COPY ZSRSRC,ZPOWERZ1IL                                                                 CLE031
     D*                                                                                       CLE033
     D**  System values array                                                                 CLE033
     D**********          SVAL    1   3 20                                             CLE033 218782
     D SVAL            S             20    DIM(4) CTDATA PERRCD(1)                            CLE033
      *
     D/SPACE 5
      *
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
      *
     D FEEAD         E DS                  EXTNAME(LEFEEAD)
     D  FASSTS       E                     EXTFLD(SSTS)                                       CLE033
     D  FAIUSR       E                     EXTFLD(IUSR)                                       CLE033
     D  FAAUSR       E                     EXTFLD(AUSR)                                       CLE033
     D  FAXUSR       E                     EXTFLD(XUSR)                                       CLE033
     D  FAPCRF       E                     EXTFLD(PCRF)                                       CLE033
     D  FAOSDB       E                     EXTFLD(OSDB)                                       CLE033
     D  FAOMDB       E                     EXTFLD(OMDB)                                       CLE033
     D  FARSTM       E                     EXTFLD(RSTM)                                       CLE033
     D  FARONS       E                     EXTFLD(RONS)                                       CLE033
     D  FARIBN       E                     EXTFLD(RIBN)                                       CLE033
     D  FARIBA       E                     EXTFLD(RIBA)                                       CLE033
     D  FAROBN       E                     EXTFLD(ROBN)                                       CLE033
     D  FAROCN       E                     EXTFLD(ROCN)                                       CLE033
     D  FAPSTM       E                     EXTFLD(PSTM)                                       CLE033
     D  FAPONS       E                     EXTFLD(PONS)                                       CLE033
     D  FAPIBN       E                     EXTFLD(PIBN)                                       CLE033
     D  FAPIBA       E                     EXTFLD(PIBA)                                       CLE033
     D  FAPOBN       E                     EXTFLD(POBN)                                       CLE033
     D  FAPOCN       E                     EXTFLD(POCN)                                       CLE033
     D  FARCRN       E                     EXTFLD(RCRN)                                       CLE033
     D  FARCRA       E                     EXTFLD(RCRA)                                       CLE033
     D  FARVNO       E                     EXTFLD(RVNO)                                       CLE033
     D  FAAWBN       E                     EXTFLD(AWBN)                                       CLE033
     D  FAAWBA       E                     EXTFLD(AWBA)                                       CLE033
     D  FABENN       E                     EXTFLD(BENN)                                       CLE033
     D  FABENA       E                     EXTFLD(BENA)                                       CLE033
     D  FADTP1       E                     EXTFLD(DTP1)                                       CLE033
     D  FADTP2       E                     EXTFLD(DTP2)                                       CLE033
     D  FADTP3       E                     EXTFLD(DTP3)                                       CLE033
     D  FADTP4       E                     EXTFLD(DTP4)                                       CLE033
     D  FADCHG       E                     EXTFLD(DCHG)                                       CLE033
     D  FABTB1       E                     EXTFLD(BTB1)                                       CLE033
     D  FABTB2       E                     EXTFLD(BTB2)                                       CLE033
     D  FABTB3       E                     EXTFLD(BTB3)                                       CLE033
     D  FABTB4       E                     EXTFLD(BTB4)                                       CLE033
     D  FABTB5       E                     EXTFLD(BTB5)                                       CLE033
     D  FABTB6       E                     EXTFLD(BTB6)                                       CLE033
     D  FACVMR       E                     EXTFLD(CVMR)                                       CLE033
     D  FAPCOB       E                     EXTFLD(PCOB)                                       CLE033
     D SVFEAD          DS           857                                                       CLE034
      *
     D LESTAL        E DS                  EXTNAME(LESTALPD)                                  CLE034
      **  EXTERNAL DS FOR SETTLEMENT ALLOCATION DETAILS                                       CLE034
     D  STRECI       E                     EXTFLD(RECI)                                       CLE034
     D  STLNRF       E                     EXTFLD(LNRF)                                       CLE034
     D  STCNUM       E                     EXTFLD(CNUM)                                       CLE034
     D  STPCRF       E                     EXTFLD(PCRF)                                       CLE034
     D  STVDAT       E                     EXTFLD(VDAT)                                       CLE034
     D  STLASQ       E                     EXTFLD(LASQ)                                       CLE034
     D  STPSTM       E                     EXTFLD(PSTM)                                       CLE034
     D  STPONS       E                     EXTFLD(PONS)                                       CLE034
     D  STPONSQQ     E                     EXTFLD(PONSQQ)                                     CGL029
     D  STPOBR       E                     EXTFLD(POBR)                                       CLE034
     D  STRSTM       E                     EXTFLD(RSTM)                                       CLE034
     D  STRONS       E                     EXTFLD(RONS)                                       CLE034
     D  STRONSQQ     E                     EXTFLD(RONSQQ)                                     CGL029
     D  STROBR       E                     EXTFLD(ROBR)                                       CLE034
     D  STRSCY       E                     EXTFLD(RSCY)                                       CLE034
     D  STTMST       E                     EXTFLD(TMST)                                       CLE034
     D  STREXR       E                     EXTFLD(REXR)                                       CLE034
     D  STREXI       E                     EXTFLD(REXI)                                       CLE034
     D  STPEXR       E                     EXTFLD(PEXR)                                       CLE034
     D  STPEXI       E                     EXTFLD(PEXI)                                       CLE034
     D  STPSCY       E                     EXTFLD(PSCY)                                       CLE034
     D  STSEQ        E                     EXTFLD(SEQ)                                        CLE034
     D  STPYBA       E                     EXTFLD(PYBA)                                       CLE038
     D  STPYAM       E                     EXTFLD(PYAM)                                       CLE038
     D  STRCBA       E                     EXTFLD(RCBA)                                       CLE038
     D  STRCAM       E                     EXTFLD(RCAM)                                       CLE038
     D  STCCY        E                     EXTFLD(CCY)                                        CLE038
      *
     D ##FEE           DS
     D**##CUST**               1      6  0                                                    CSD027
     D  ##CUST                 1      6                                                       CSD027
     D  ##FACL                 7     11  0
     D**##LOAN**              12     17  0                                                    CLE148
     D  ##LOAN                12     17                                                       CLE148
     D  ##FSEQ                18     19  0
     D ##PAYD          DS
     D  ##PAY                  1      1
     D  ##PAYM                 2      3
     D***##PAYA*                4     15                                                      CGL029
     D***##PAYB*               16     18                                                      CGL029
     D  ##PAYA                 4     21                                                       CGL029
     D  ##PAYB                22     24                                                       CGL029
     D ##RECD          DS
     D  ##REC                  1      1
     D  ##RECM                 2      3
     D***##RECA*                4     15                                                      CGL029
     D***##RECB*               16     18                                                      CGL029
     D  ##RECA                 4     21                                                       CGL029
     D  ##RECB                22     24                                                       CGL029
     D ##INTS          DS
     D  ##INPR                 1      1
     D  ##INTM                 2      3
     D***##INTA*                4     15                                                      CGL029
     D***##INTB*               16     18                                                      CGL029
     D  ##INTA                 4     21                                                       CGL029
     D  ##INTB                22     24                                                       CGL029
     D ##SETD          DS
      * pay/receive (P/R)
     D  ##PYRC                 1      1
      * settlement method
     D  ##SETM                 2      3
      * settlement account
     D***##SETA*                4     15                                                      CGL029
     D  ##SETA                 4     21                                                       CGL029
     D  ##NOSN                 4      5
     D  ##ACNO                 4     13
     D  ##CNUM                 4      9
     D***##ACOD*               10     13                                                      CGL029
     D***##ACSQ*               14     15                                                      CGL029
     D  ##ACOD                10     19                                                       CGL029
     D  ##ACSQ                20     21                                                       CGL029
      * settlement branch
     D***##BRCA*               16     18                                                      CGL029
     D  ##BRCA                22     24                                                       CGL029
      *
      *  Calling parameter data structure for AOSPOSU0
      *
     D C#DTA           DS           256
      *  Account type N=nostro nbr F=Full nostro G=General Ledger
      *               P=Partial Ledger R= Retail Number  X= no settlement
     D  C#ATYP                 1      1
      *               Full General Ledger - CNUM/CCY/ACOD/ACSQ
     D  C#ACCT                 2     19
     D**C#CNU1**               2      7  0                                                    CSD027
     D  C#CNU1                 2      7                                                       CSD027
     D  C#CCY1                 8     10
     D***C#ACO1*               11     14  0                                                   CGL029
     D  C#ACS1                15     16  0
     D  C#BRC1                17     19
      *               Nostro number
     D  C#NOSN                 2      3  0
      *               Full Nostro - CCY/NOSN
     D  C#NOS                  2      6
      *               Retail Number
     D  C#ACNO                 2     11  0
      *               Partial Account - CNUM/ACOD/ACSQ
     D**C#CNUM**               2      7  0                                                    CSD027
     D  C#CNUM                 2      7                                                       CSD027
     D***C#ACOD*                8     11  0                                                   CGL029
     D  C#ACSQ                12     13  0
      *               Branch of account if Partial                      '
     D  C#BRCA                14     16
      *               OLPOS Incoming/Outgoing Indicator 'I' or 'O' or ' '
      *                     ' ' no OLPOS update
     D  C#IO                  24     24
      *               Currency of transaction
     D  C#CCY                 25     27
      *               Transaction Type
     D  C#TRYP                28     29
      *               Transaction Narrative
     D  C#NARR                30     59
      *               Cheque Number
     D  C#CHQN                60     67  0
      *               FT transaction reference
     D  C#PREF                68     82
      *               DL/LE/GL/RE transaction reference
     D  C#TRN                 83     88
      *               Movement amount
     D  C#AMT                 89     96P 0
      *               Processing indicators Not blank = no update
      *                                     ' ' = Update
      *               Prono update indicator
     D  C#PRON                97     97
      *               Olpos update indicator
     D  C#OLPS                98     98
      *               Memos update indicator
     D  C#MEMS                99     99
      *               Rsacmtpd write indicator
     D  C#RSAC               100    100
      *               Module
     D  C#MOD                101    102
      *               Olpos record number to update
      *                     '02' for Interest movements
      *                     '03' for loans
     D  C#OLRC               103    104
      *               FT Memos ledger balance override
      *                        'Y' update ledger balance irrespective of
      *                        posting date
     D  C#FTOV               105    105
      *               Value date and posting date
     D  C#VDAT               106    108P 0
     D  C#PSTD               109    111P 0
      *               Override posting date correction
      *                        for forward valued items
      *                        'Y' prevents date being changed
     D  C#PSTO               112    112
      *               Indicator to show if removal allowed Y, N or " "
     D  C#RPST               113    113
      *               Removal set number
     D  C#RPNB               114    116  0
      *               Removal type "C" = Credit entries
      *                            "D" = Debit entries
     D  C#RTYP               117    117
      *               Booking branch
     D  C#BBRN               118    120
                                                                                              CGL029
      ** Account code for full general ledger                                                 CGL029
     D  C#ACO1               121    130  0                                                    CGL029
                                                                                              CGL029
      ** Account code for partial account                                                     CGL029
     D  C#ACOD               131    140  0                                                    CGL029
                                                                                              CAP204
      ** Other Transaction Reference                                                          CAP204
     D  C#OTR1               141    160                                                       CAP204
                                                                                              CAP204
      *                                                                                       CAP205
      ** Movement type                                                                        CAP205
      *                                                                                       CAP205
     D  C#MTYP               161    161                                                       CAP205
                                                                                              CAP205
                                                                                              CLE134
      ** Exception Reference Id/Number                                                        CLE134
                                                                                              CLE134
     D  C#XRFI               162    164                                                       CLE134
     D  C#XRFN               165    174  0                                                    CLE134
      *
     D ##NARR          DS            30
      ** Narrative, composed of fee sequence and fee code desc
     D  ##NSEQ                 1      2
     D  ##NDES                 3     28
      *
     D CPYR            DS
      ** Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D  COMITNOM               1      3S 0                                                    CSC022
     D  COMITJOB               4    100                                                       CSC022
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CEU004
      ** Switchable Features File                                         CEU004
      *                                                                   CEU004
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
      ** Fee Codes detail
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access object
      *                                                                                       CLE031
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CLE031
      ** Second DS for access programs, long data structure                                   CLE031
      *                                                                                       CLE031
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CLE031
      ** Currency details                                                                     CLE031
      *                                                                                       CLE031
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CLE033
      **  EXTERNAL DS FOR BANK DETAILS                                                        CLE033
      *
     D*SDSVAL********E DS                  EXTNAME(SDSVALPD)                           CLE033 222373
      ****EXTERNAL*DS*FOR*SYSTEM*VALUES*                                               CLE033 222373
      *
      ** +--------------------------------------+                                             CSC022
      ** ¦ Use of Indicator                     ¦                                             CSC022
      ** ¦ ================                     ¦                                             CSC022
      ** |                                      |                                             CSC022
      ** | 17      Used by LOOKUP               |                                             CSC022
      ** +--------------------------------------+                                             CSC022
                                                                                              CSC022
     I/COPY WNCPYSRC,AOOUFAU0I1
     C/EJECT
      *****************************************************************
      * Process     :  MAINLINE                                       *
      * Function    :  Mainline processing                            *
      *                                                               *
      * Called by   :  None                                           *
      * Calls       :  SRINIT - Initial Processing - On First Call    *
      *                SRMAIN - Main Processing                       *
      *****************************************************************
      *
      ** Parameter list for current program invocation.
      *
     C     *ENTRY        PLIST
     C                   PARM                    ##RTCD            7
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *................................................................
      *
      ** Initial processing - Once Only
      *
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT            1
     C                   ENDIF
      *
      ** Main processing
      *
     C                   EXSR      SRMAIN
      *
      *................................................................
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C/COPY WNCPYSRC,AOOUFAU0C3
      *
      ** Terminate program
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Subroutine  :  SRMAIN                                         *
      * Function    :  Main processing                                *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  SRCLR  - Clear all postings in store           *
      *                SRFEAD - Fee settlements/adjustments           *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRMAIN'      @STK(Q)
      *
      *................................................................
      *
      ** Clear down all shadow postings in store (within AOSPOSU0)
      *
     C                   EXSR      SRCLR
      *
     C                   MOVEL     Z#BSTS        #BRCID            2
     C                   MOVEL     Z#ASTS        #ARCID            2
      *
      *-------------------------------------------------------------------
      *
      ** GENERATE 'BEFORE STATUS' ACCOUNT MOVEMENTS
      ** (if not insertion, when __RCID will be blank)
      *
     C     #BRCID        IFNE      *BLANK
      *
     C                   MOVEL     'YES'         ##REVI            3
      *
      ** Fee settlements/adjustments
      *
     C                   MOVEL     Z#BSTS        FEEAD
      *
      * TNLU in reversals must be the new one, to match the loan status                       CLE033
      *                                                                                       CLE033
     C     CLE033        IFEQ      'Y'                                                        CLE033
      *                                                                                       CLE033
     C                   MOVEL     Z#ASTS        FEEAD                                        CLE033
     C                   Z-ADD     0             W0TNLU            5 0                        CLE033
      *                                                                                       CLE033
     C     FELCHT        IFEQ      'D'                                                        CLE033
     C                   Z-ADD     FATNLU        W0TNLU                                       CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       CLE033
     C                   MOVEL     Z#BSTS        FEEAD                                        CLE033
      *                                                                                       CLE033
     C     W0TNLU        IFNE      0                                                          CLE033
     C                   Z-ADD     W0TNLU        FATNLU                                       CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       CLE033
     C                   ENDIF                                                                CLE033
      *
     C                   EXSR      SRFEAD
      *
     C                   MOVE      ##SETM        WBSETM            2                          CLE033
      *
     C                   ENDIF                                                  * Z#BSTS
      *-------------------------------------------------------------------
      *
      ** GENERATE 'AFTER STATUS' ACCOUNT MOVEMENTS
      ** (if not deletion, when __CHTP will be 'R')
      *
     C                   MOVEL     *BLANK        ##REVI
      *
      ** Fee settlements/adjustments
      *
     C                   MOVEL     Z#ASTS        FEEAD
     C********** FAACTN    IFNE 'D'                                                           205400
     C     FAACTN        IFNE      ' D'                                                       205400
     C                   EXSR      SRFEAD
     C                   ENDIF
      *
      ** Update database with shadow postings in store (within AOSPOSU0)
      *
     C                   EXSR      SRUPD
      *
      *................................................................
      *
     C     EXMAIN        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/EJECT
      *****************************************************************
      * Subroutine  :  SRFEAD                                         *
      * Function    :  Fee settlement/adjustment processing           *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  AOSPOSU0 - On-line Positions Update            *
      *****************************************************************
     C     SRFEAD        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRFEAD'      @STK(Q)
      *
      *................................................................
      *
      ** Store pay and receive settlement methods, accounts & branches
      *
      ** For fee settlements with blank participant fee indicator
      ** format receive settlement
      *
     C     PTFI          IFEQ      *BLANK
     C                   MOVE      *BLANKS       ##PAYM                         * pay method
     C                   MOVE      *BLANKS       ##PAYA                         * pay account
     C                   MOVE      *BLANKS       ##PAYB                         * pay branch
     C**********           MOVELRSTM      ##RECM           * rec method                       205400
     C**********           MOVELRONS      ##RECA           * rec account                      205400
     C**********           MOVELOSDB      ##RECB           * rec branch                       205400
     C                   MOVEL     FAMETH        ##RECM                         * rec method  205400
     C                   MOVEL     FAOURS        ##RECA                         * rec account 205400
     C                   MOVEL     FAOSBR        ##RECB                         * rec branch  205400
     C                   ELSE
      *
      ** For fee settlements with participant fee indicator 'P'
      ** format pay settlement
      *
     C                   MOVEL     PSTM          ##PAYM                         * pay method
     C                   MOVEL     PONS          ##PAYA                         * pay account
     C                   MOVEL     OMDB          ##PAYB                         * pay branch
     C                   MOVE      *BLANKS       ##RECM                         * rec method
     C                   MOVE      *BLANKS       ##RECA                         * rec account
     C                   MOVE      *BLANKS       ##RECB                         * rec branch
     C                   ENDIF
      *
      ** Store basic fee settlement/adjustment details
      *
     C**********         Z-ADD     FACNUM        ##CUST                         * customer    CSD027
     C                   EVAL      ##CUST = FACNUM                              * customer    CSD027
     C                   Z-ADD     FAFACL        ##FACL                         * facility
     C**********         Z-ADD     FALOAN        ##LOAN                         * loan no     CLE148
     C                   MOVEL     FALOAN        ##LOAN                                       CLE148
     C                   Z-ADD     FAFSEQ        ##FSEQ                         * fac seq
     C                   Z-ADD     FASADJ        ##SADJ           15 0          * adjustment
      *                                                                   CEU004
      **  Move Settlement Currency to ##CCY if CEU004 is switched on      CEU004
      *                                                                   CEU004
     C     CEU004        IFEQ      'Y'                                                        CEU004
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     FASCCY        ANDNE     *BLANKS                                                    CEU004
     C                   MOVE      FASCCY        ##CCY                                        CEU004
     C                   ELSE                                                                 CEU004
     C                   MOVE      FAFCCY        ##CCY             3            * currency
     C                   ENDIF                                                                CEU004
      *                                                                   CEU004
      ** If Lending Enhancements is on.                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
      *                                                                                       CLE031
     C*****FASCCY        IFNE      *BLANK                                            CLE031 AR943686
      * Store receipt settlement currency                                                     CLE031
     C                   MOVEL     FASCCY        SVSCCY            3                          CLE031
     C**********         ENDIF                                                       CLE031 AR943686
      *                                                                                       CLE031
     C*****FAPSCY        IFNE      *BLANK                                            CLE031 AR943686
      * Store pay settlement currency                                                         CLE031
     C                   MOVEL     FAPSCY        SVPSCY            3                          CLE031
     C**********         ENDIF                                                       CLE031 AR943686
      *                                                                                       CLE031
     C                   Z-ADD     FAREXR        SVREXR           13 8                      AR943686
     C                   MOVE      FAREXI        SVREXI            1                        AR943686
     C                   Z-ADD     FAPEXR        SVPEXR           13 8                      AR943686
     C                   MOVE      FAPEXI        SVPEXI            1                        AR943686
      *                                                                                     AR943686
     C                   ENDIF                                                  End If        CLE031
      *
     C                   MOVE      'F2'          ##TRYP            2            * trans type
     C                   MOVE      FAFACL        ##TRN             6            * transact no.
     C                   MOVE      FABRCA        ##BBRN            3            * branch
      *
      ** Initialise work fields
      *
     C                   Z-ADD     *ZERO         ##VDAT            5 0          * event value dte
     C                   Z-ADD     *ZERO         ##AMT            15 0          * amount
     C                   MOVEL     *BLANK        ##NARR                         * narrative
      *
      ** Generate VALUE DATE account movement
      ** ====================================
      *
     C                   Z-ADD     FAVDAT        ##VDAT                           Midas day no.
     C                   Z-ADD     ##SADJ        ##AMT                          * fee adjustment
      *                                                                                       CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C     FASTAL        ANDEQ     'Y'                                                        CLE034
     C                   EXSR      SR34A                                                      CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      'Y'           WRKFLD            1                          CLE034
     C                   MOVE      '*EOF   '     STALCD                                       CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C     WRKFLD        DOWEQ     'Y'
     C     STALCD        OREQ      *BLANKS
      *
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C     FASTAL        ANDEQ     'Y'                                                        CLE034
     C                   EXSR      SR34B                                                      CLE034
     C                   ENDIF                                                                CLE034
      *
      ** Pass movement to write program (with appropriate instructions)
      *
     C     PTFI          IFEQ      *BLANK
     C                   MOVEL     ##RECD        ##SETD                         * Rec details
     C                   ELSE
     C                   MOVEL     ##PAYD        ##SETD                         * Pay details
     C                   END
      *
      ** Get fee sequence and fee code from Fees File
      *
     C     WKFEE         KLIST
     C                   KFLD                    ##CUST
     C                   KFLD                    ##FACL
     C                   KFLD                    ##LOAN
     C                   KFLD                    ##FSEQ
     C     WKFEE         CHAIN     LEFEEDL1                           90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'LEFEEDL1'    W0FILE
     C                   MOVEL     ##FEE         W0KEY
     C                   Z-ADD     904           W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Get fee code description from Fee Codes File
      *
     C                   MOVE      FEFCOD        O#FCD
     C                   CALL      'AOFEER0'                            9090
     C                   PARM      *BLANKS       O#RTN
     C                   PARM      '*KEY   '     O#OPT             8
     C                   PARM                    O#FCD             2
     C     SDFEE         PARM      SDFEE         DSFDY
     C     O#RTN         IFNE      *BLANKS
     C                   MOVEL     'AOFEER0 '    W0FILE
     C                   MOVEL     O#FCD         W0KEY
     C                   Z-ADD     905           W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   Z-ADD     001           ##RPNB            3 0          * 1=value date
      *
      ** Set up narrative as fee sequence and fee code description
      *
     C                   MOVE      FAFSEQ        ##NSEQ
     C                   MOVE      AUFENV        ##NDES
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           ##MTYP            1                          CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
      *
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C     FASTAL        ANDEQ     'Y'                                                        CLE034
     C                   EXSR      SR34C                                                      CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      *BLANKS       WRKFLD                                       CLE034
     C                   ENDIF                                                                CLE034
      *
     C                   ENDDO                                                                CLE034
      *                                                                                       CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C     FASTAL        ANDEQ     'Y'                                                        CLE034
     C                   EXSR      SR34E                                                      CLE034
     C                   ENDIF                                                                CLE034
      *................................................................
      *
      **  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Subroutine  :  SRMOVE                                         *
      * Function    :  Pass Movement To Write Program                 *
      *                                                               *
      * Called by   :  Various                                        *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRMOVE        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMOVE'      @STK(Q)
      *
      *................................................................
      *
      ** Bypass if no amount to post
      *
     C     ##AMT         CABEQ     *ZERO         EXMOVE
      *
      ** Determine account movement settlement details
      *
      ** If Lending Enhancements is on.                                                       CLE031
      ** Check whether a settlement currency has been used:                                   CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
      *                                                                                       CLE031
     C     ##PYRC        IFEQ      'R'                                                        CLE031
     C     SVSCCY        ANDNE     *BLANK                                                     CLE031
      *                                                                                       218782
     C     CLE033        IFNE      'Y'                                                        218782
     C     SET09         ORNE      'T'                                                        218782
     C     ##RECM        ORNE      '09'                                                       218782
      * Store receipt settlement details                                                      CLE031
     C                   MOVEL     SVSCCY        ##CCY             3                          CLE031
     C                   ENDIF                                                                218782
      *                                                                                     AR943686
     C                   MOVE      SVSCCY        FASCCY                                     AR943686
     C                   Z-ADD     SVREXR        FAREXR                                     AR943686
     C                   MOVE      SVREXI        FAREXI                                     AR943686
      *                                                                                     AR943686
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     ##PYRC        IFEQ      'P'                                                        CLE031
     C     SVPSCY        ANDNE     *BLANK                                                     CLE031
      *                                                                                       218782
     C     CLE033        IFNE      'Y'                                                        218782
     C     SET09         ORNE      'T'                                                        218782
     C     ##PAYM        ORNE      '09'                                                       218782
      * Store pay settlement details                                                          CLE031
     C                   MOVEL     SVPSCY        ##CCY             3                          CLE031
     C                   ENDIF                                                                218782
      *                                                                                     AR943686
     C                   MOVE      SVPSCY        FAPSCY                                     AR943686
     C                   Z-ADD     SVPEXR        FAPEXR                                     AR943686
     C                   MOVE      SVPEXI        FAPEXI                                     AR943686
      *                                                                                     AR943686
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   CLEAR                   C#DTA
     C/COPY WNCPYSRC,AOOUFAU0C1
     C     CLE033        IFEQ      'Y'                                                        CLE033
     C     ##SETM        ANDEQ     '09'                                                       CLE033
      *                                                                                       CLE033
     C                   MOVE      'P'           C#ATYP                                       CLE033
     C                   MOVEL     P@VL01        C#CNUM                                       CLE033
     C                   MOVEL     P@VL02        C#ACOD                                       CLE033
     C                   MOVEL     '01'          C#ACSQ                                       CLE033
     C                   MOVEL     FABRCA        C#BRCA                                       CLE033
     C*********************MOVEL##BRCA    C#BRCA                                              CLE033
      *                                                                                       CLE033
     C                   ENDIF                                                                CLE033
      *
     C     ##SETM        IFEQ      '01'
     C     ##SETM        OREQ      '02'
     C     ##SETM        OREQ      '07'
     C     ##SETM        OREQ      '08'
     C     ##SETM        OREQ      '12'
     C                   MOVEL     'N'           C#ATYP
     C                   MOVEL     ##NOSN        C#NOSN
     C                   ELSE
     C     ##SETM        IFEQ      '14'
     C                   MOVEL     'R'           C#ATYP
     C                   MOVEL     ##ACNO        C#ACNO
     C                   ELSE
     C     ##SETM        IFEQ      '04'
     C     ##SETM        OREQ      '05'
     C                   MOVEL     'P'           C#ATYP
     C                   MOVEL     ##CNUM        C#CNUM
     C                   MOVEL     ##ACOD        C#ACOD
     C                   MOVEL     ##ACSQ        C#ACSQ
     C                   MOVEL     ##BRCA        C#BRCA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** OLPOS Incoming/Outgoing Indicator 'I' or 'O'
      *
     C     ##PYRC        IFEQ      'P'
     C                   MOVEL     'O'           C#IO                           * outgoing
     C                   ELSE
     C                   MOVEL     'I'           C#IO                           * incoming
     C                   END
      *
      ** Currency of transaction
      *
     C                   MOVEL     ##CCY         C#CCY
      *
      ** Transaction type
      *
     C                   MOVEL     ##TRYP        C#TRYP
      *
      ** Transaction Narrative
      *
     C/COPY WNCPYSRC,AOH00028
     C                   MOVEL     ##NARR        C#NARR
     C/COPY WNCPYSRC,AOH00029
      *                                                                                       CRE020
     C     CRE020        IFEQ      'Y'                                                        CRE020
     C     ##REVI        IFEQ      'YES'                                                      CRE020
     C                   MOVE      '*'           C#NARR                                       CRE020
     C                   ENDIF                                                                CRE020
     C                   MOVEL     FECNUM        C#PREF                                       CRE020
     C                   ENDIF                                                                CRE020
      *
      ** LE transaction reference
      *
     C                   MOVEL     ##TRN         C#TRN
      *                                                                   CEU004
      ****Call*EURO*Ccy*Conversion*(EU0200)*if*CEU004*is*on*and*                       CEU004 CLE031
      ****FASCCY*is*not*equal*to*FAFCCY*************************                       CEU004 CLE031
      *                                                                                       CLE031
      ** If CLE031 - Lending Enhancements                                                     CLE031
      ** or CEU004 (EMU Settlement Ccy Conversion) is installed,                              CLE031
      ** convert amount to settlement currency if necessary.                                  CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           WRKEMU                                       CLE031
      * If CLE033 is on and settlement method is 09, postings can be                          218782
      * left in transaction ccy instead, if System Value = 'T'.                               218782
      *                                                                                       218782
     C     CLE033        IFNE      'Y'                                                        218782
     C     SET09         ORNE      'T'                                                        218782
     C     ##PAYM        ORNE      '09'                                                       218782
     C     ##PYRC        ANDEQ     'P'                                                        218782
     C     ##RECM        ORNE      '09'                                                       218782
     C     ##PYRC        ANDEQ     'R'                                                        218782
      *                                                                                       CEU004
     C     CEU004        IFEQ      'Y'                                                        CEU004
     C     FASCCY        ANDNE     *BLANKS                                                    CEU004
     C     FASCCY        ANDNE     FAFCCY                                                     CEU004
     C     CLE031        ANDNE     'Y'                                                        CLE031
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     ##PYRC        ANDEQ     'R'                                                        CLE031
     C     FASCCY        ANDNE     *BLANK                                                     CLE031
     C     FASCCY        ANDNE     FAFCCY                                                     CLE031
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     ##PYRC        ANDEQ     'P'                                                        CLE031
     C     FAPSCY        ANDNE     *BLANK                                                     CLE031
     C     FAPSCY        ANDNE     FAFCCY                                                     CLE031
      *                                                                                       CLE031
      * Determine which settlement ccy to use:                                                CLE031
     C     CLE031        IFNE      'Y'                                          CEU004 set. ccCLE031
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     ##PYRC        ANDEQ     'R'                                                        CLE031
     C                   MOVE      FASCCY        SETCCY            3                          CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVE      FAPSCY        SETCCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
      * Check if fee adjustment currency is 'In' or 'EUR'.                                    CLE031
     C                   MOVEL     FAFCCY        WCCY              3                          CLE031
     C                   EXSR      SRCURR                                                     CLE031
     C                   MOVE      A6NBDP        CCYDP             1 0                        CLE031
     C                   Z-ADD     A6SPRT        CCYSPT           13 8                        CLE031
     C                   MOVE      A6MDIN        CCYMDI            1                          CLE031
     C     A6INCY        IFEQ      'Y'                                                        CLE031
     C                   MOVE      'Y'           WRKEMU            1                          CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
      * Check if settlement currency is 'In' or 'EUR'.                                        CLE031
     C                   MOVE      SETCCY        WCCY                                         CLE031
     C                   EXSR      SRCURR                                                     CLE031
     C                   MOVE      A6NBDP        SETDP             1 0                        CLE031
     C                   MOVE      A6SPRT        SETSPT           13 8                        CLE031
     C                   MOVE      A6MDIN        SETMDI            1                          CLE031
      *                                                                                       CLE031
      * If either currency is 'In', use EU0200.                                               CLE031
     C     A6INCY        IFEQ      'Y'                                                        CLE031
     C                   MOVE      'Y'           WRKEMU                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     WRKEMU        IFEQ      'Y'                                                        CLE031
      *                                                                   CEU004
      **  If amount needs to be converted between EUR and In Currrency                        CLE031
      **  Set up the parameters for EU0200                                                    CEU004
      *                                                                                       CEU004
     C                   MOVE      *BLANKS       PRTCD                                        CEU004
     C                   Z-ADD     ##AMT         PFRAM                                        CEU004
     C                   MOVE      FAFCCY        PFRCY                                        CEU004
     C**********           MOVE FASCCY    PTOCY                                        CEU004 CLE031
     C                   MOVE      SETCCY        PTOCY                                        CLE031
     C                   Z-ADD     0             POUTA                                        CEU004
     C                   Z-ADD     0             PEXRT                                        CEU004
     C                   MOVE      *BLANKS       PMDIN                                        CEU004
      *                                                                                       CEU004
      **  Call EU0200                                                                         CEU004
      *                                                                                       CEU004
     C                   CALL      'EU0200'                                                   CEU004
     C                   PARM                    PRTCD             7            Return Code   CEU004
     C                   PARM                    PFRAM            18 3          From amount   CEU004
     C                   PARM                    PFRCY             3            From Currency CEU004
     C                   PARM                    PTOCY             3            To Currency   CEU004
     C                   PARM                    POUTA            15 0          Out amount    CEU004
     C                   PARM                    PINTA            18 3          In amount     CEU004
     C                   PARM                    PEXRT            15 9          Exchange Rate CEU004
     C                   PARM                    PMDIN             1            Mult/Div Ind  CEU004
      *                                                                                       CEU004
      **  Set ##AMT to POUTA if return code is blank                                          CEU004
      *                                                                                       CEU004
     C     PRTCD         IFEQ      *BLANKS                                                    CEU004
     C                   MOVE      POUTA         ##AMT                                        CEU004
     C                   ELSE                                                                 CEU004
     C                   MOVEL     'EU0200  '    W0FILE                                       CEU004
     C                   Z-ADD     906           W0ERNB                                       CEU004
     C                   EXSR      SRERR                                                      CEU004
     C                   ENDIF                                                                CEU004
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
      * Else, convert using settlement exchange rate.                                         CLE031
      * Determine which rate to use:                                                          CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     ##PYRC        ANDEQ     'R'                                                        CLE031
     C                   Z-ADD     FAREXR        ZEXCH                                        CLE031
     C                   MOVE      FAREXI        ZMD                                          CLE031
     C                   ELSE                                                                 CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     ##PYRC        ANDEQ     'P'                                                        CLE031
     C                   Z-ADD     FAPEXR        ZEXCH                                        CLE031
     C                   MOVE      FAPEXI        ZMD                                          CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   Z-ADD     ##AMT         ZAMTCI                                       CLE031
     C                   MOVE      FAFCCY        ZCCYI                                        CLE031
     C                   MOVE      SETCCY        ZCCYO                                        CLE031
     C                   Z-ADD     CCYDP         ZCDPI                                        CLE031
     C                   Z-ADD     SETDP         ZCDPO                                        CLE031
     C                   EXSR      ZCONV                                                      CLE031
     C                   Z-ADD     ZAMTCO        ##AMT                                        CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CEU004
     C                   ENDIF                                                                CEU004
      *                                                                                       218782
     C                   ENDIF                                                                218782
      *
      ** Movement amount
      *
     C     ##PYRC        IFEQ      'P'
     C     ##REVI        ANDNE     'YES'
     C     ##PYRC        OREQ      'R'
     C     ##REVI        ANDEQ     'YES'
     C                   Z-SUB     ##AMT         C#AMT                          * pay ie credit
     C                   ELSE
     C                   Z-ADD     ##AMT         C#AMT                          * rec ie debit
     C                   END
      *
      ** Module
      *
     C                   MOVEL     'LE'          C#MOD
      *
      ** Olpos record number to update
      ** '01' for FX (not used here)
      ** '02' for Interest movements
      ** '03' for Loans and deposits
      *
     C     ##RPNB        IFEQ      2
     C                   MOVE      '02'          C#OLRC
     C                   ELSE
     C                   MOVE      '03'          C#OLRC
     C                   END
      *
      ** Value date and posting date
      *
     C                   Z-ADD     ##VDAT        C#VDAT
     C                   Z-ADD     ##VDAT        C#PSTD
      *
      ** Indicator to show if removal allowed Y, N or " "
      *
     C                   MOVEL     'Y'           C#RPST
      *
      ** Removal set number
      *
     C                   Z-ADD     ##RPNB        C#RPNB
      *
      ** Removal type "C" = Credit entries
      **              "D" = Debit entries
      *
     C                   MOVEL     'C'           C#RTYP
      *
      ** Booking branch
      *
     C                   MOVEL     ##BBRN        C#BBRN
      *                                                                                       CLE134
      ** Extension Reference Id/Number.                                                       CLE134
      *                                                                                       CLE134
     C                   MOVEL     FEXRFI        C#XRFI                                       CLE134
     C                   MOVEL     FEXRFN        C#XRFN                                       CLE134
      *
      ** If settlement details are present
      ** AOSPOSU0 will be called to update PRONO, MEMOS, RSACMTPD, OLPOS
      **
      ** OTHERWISE
      **
      ** If no settlement details are present
      ** AOSPOSU0 will be called to only update OLPOS
      *
     C     C#ATYP        IFEQ      *BLANK
      *
      ** Set account type indicator to signify no settlement
      *
     C                   MOVEL     'X'           C#ATYP
      *
      ** Set update indicators for no update
      *
     C                   MOVE      'N'           C#PRON
     C                   MOVE      'N'           C#MEMS
     C                   MOVE      'N'           C#RSAC
     C                   ENDIF
      *                                                                   CLE033
     C*****##VDAT        IFLT      BJDNWD                                              CLE033 223947
     C*****CLE033        ANDEQ     'Y'                                                 CLE033 223947
     C     CLE033        IFEQ      'Y'                                                        223947
     C     ##VDAT        ANDLT     BJDNWD                                                     223947
     C     ##SETM        ANDEQ     '09'                                                       CLE033
     C                   EXSR      HPOST                                                      CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       CAP205
      ** Set C#MTYP to ##MTYP                                                                 CAP205
      *                                                                                       CAP205
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     ##MTYP        C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
      *
      ** Call AOSPOSU0
      *
     C                   CALL      'AOSPOSU0'                           9090
     C***********R#RTN     PARM *BLANKS   O#RTN   7                                           134284
     C     R#RTN         PARM      ##RTCD        O#RTN             7                          134284
     C                   PARM      '*ADD    '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C***********R#RTN     ORNE *BLANKS                                                       134284
     C     R#RTN         OREQ      '*ERROR*'                                                  134284
     C                   MOVEL     '*CALL   '    W0FILE            8
     C                   MOVEL     'AOSPOSU0'    W0KEY            29
     C                   Z-ADD     902           W0ERNB            3 0
     C                   EXSR      SRERR
     C                   END
      *
      *................................................................
      *
     C     EXMOVE        TAG
      *
      **  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRUPD    : Update database with shadow postings in store     *
      *                                                               *
      *  CALLED BY: Various                                           *
      *                                                               *
      *  CALLS    : SRERR - Report errors                             *
      *                                                               *
      *****************************************************************
     C     SRUPD         BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRUPD'       @STK(Q)
      *
      *................................................................
      *
      ** Call AOSPOSU0 to update database
      *
     C                   CALL      'AOSPOSU0'                           9090
     C***********R#RTN     PARM *BLANKS   O#RTN   7                       134284
     C     R#RTN         PARM      ##RTCD        O#RTN                                         13428
     C                   PARM      '*UPDATE '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C***********R#RTN     ORNE *BLANKS                                   134284
     C     R#RTN         OREQ      '*ERROR*'                                                   13428
     C                   MOVEL     '*CALL   '    W0FILE
     C                   MOVEL     'AOSPOSU0'    W0KEY
     C                   Z-ADD     903           W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      *
      *................................................................
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************                       CLE033
      *                                                               *                       CLE033
      *  HPOST    : Write record to host file                         *                       CLE033
      *                                                               *                       CLE033
      *  CALLED BY: Various                                           *                       CLE033
      *                                                               *                       CLE033
      *  CALLS    : N/A                                               *                       CLE033
      *                                                               *                       CLE033
      *****************************************************************                       CLE033
     C     HPOST         BEGSR                                                                CLE033
      *                                                                                       CLE033
      * Conditions                                                                            CLE033
      *                                                                                       CLE033
     C     FATYPE        IFNE      'W'                                                        CLE033
      *                                                                                       CLE033
     C                   SELECT                                                               CLE033
     C     FAACTN        WHENEQ    ' I'                                                       CLE033
     C     ##REVI        ANDNE     'YES'                                                      CLE033
     C     FAACTN        OREQ      ' A'                                                       CLE033
     C     WBSETM        ANDNE     '09'                                                       CLE033
     C     ##SETM        ANDEQ     '09'                                                       CLE033
     C     #BRCID        ANDNE     *BLANKS                                                    CLE033
     C     ##REVI        ANDNE     'YES'                                                      CLE033
     C                   MOVEL     'Insert  '    HOACTN                                       CLE033
     C     FAACTN        WHENEQ    ' A'                                                       CLE033
     C     ##REVI        ANDNE     'YES'                                                      CLE033
     C                   MOVEL     'Amend   '    HOACTN                                       CLE033
     C     FAACTN        WHENEQ    ' D'                                                       CLE033
     C     ##REVI        OREQ      'YES'                                                      CLE033
     C                   MOVEL     'Reverse '    HOACTN                                       CLE033
     C                   ENDSL                                                                CLE033
      *                                                                                       CLE033
     C                   MOVE      *BLANKS       HOTRYP                                       CLE033
     C                   MOVE      *BLANKS       HOETYD                                       CLE033
     C     'Fee Set'     CAT       'tlement'     HOTRYP                                       CLE033
     C     '71'          CAT       ##TRYP        HOETYP                                       CLE033
     C     'Facility'    CAT       ' Payment'    HOETYD                                       CLE033
     C**********         Z-ADD     FACNUM        HOCNUM                                CLE033 CSD027
     C                   EVAL      HOCNUM = FACNUM                                            CSD027
     C**********         Z-ADD     FALOAN        HOLNRF                                CLE033 CLE148
     C                   MOVEL     FALOAN        HOLNRF                                       CLE148
     C                   Z-ADD     0             HOLASN                                       CLE033
      *                                                                                       CLE033
     C                   MOVE      FAFACL        W0FACL            5                          CLE033
     C                   MOVEL     W0FACL        HOFTYP                                       CLE033
     C                   MOVE      W0FACL        HOFSEQ                                       CLE033
      *                                                                                       CLE033
     C                   Z-ADD     FAFSEQ        HOFESQ                                       CLE033
     C                   MOVE      FABRCA        HOBRCA                                       CLE033
     C                   MOVE      *BLANKS       HOLTYP                                       CLE033
     C                   MOVE      *BLANKS       HOSUTP                                       CLE033
     C                   MOVE      *BLANKS       HOCLAS                                       CLE042
     C                   Z-ADD     BJRDNB        HOPSTD                                       CLE033
     C                   Z-ADD     ##VDAT        HOVALD                                       CLE033
     C                   MOVE      FAFCCY        HOCCY                                        CLE033
      *                                                                                       CLE033
     C                   Z-ADD     ##AMT         HOPSTA                                       CLE033
      *                                                                                       CLE033
     C                   MOVEL     ##NARR        HOPNAR                                       CLE033
     C                   MOVEL     FEAUTO        HOAUTO                                       CLE033
      *                                                                                       CLE033
     C     ##REVI        IFEQ      'YES'                                                      CLE033
     C     ##PYRC        IFEQ      'P'                                                        CLE033
     C                   MOVE      'R'           HOTLXY                                       CLE033
     C                   ELSE                                                                 CLE033
     C                   MOVE      'P'           HOTLXY                                       CLE033
     C                   ENDIF                                                                CLE033
     C                   ELSE                                                                 CLE033
     C                   MOVE      ##PYRC        HOTLXY                                       CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       220257
      * If posting amount is negative, convert to a positive amount                           220257
      * and change the debit/credit indicator                                                 220257
      *                                                                                       220257
     C     ##AMT         IFLT      0                                                          220257
     C                   Z-SUB     ##AMT         HOPSTA                                       220257
     C     HOTLXY        IFEQ      'P'                                                        220257
     C                   MOVE      'R'           HOTLXY                                       220257
     C                   ELSE                                                                 220257
     C                   MOVE      'P'           HOTLXY                                       220257
     C                   ENDIF                                                                220257
     C                   ENDIF                                                                220257
      *                                                                                       CLE033
     C                   Z-ADD     0             HOINTR                                       CLE033
     C                   MOVE      *BLANKS       HOBRTT                                       CLE033
     C                   Z-ADD     0             HOBRTE                                       CLE033
     C                   Z-ADD     0             HORTSP                                       CLE033
     C                   MOVE      *BLANKS       HOSPIN                                       CLE033
     C                   Z-ADD     0             HOMARG                                       CLE033
     C                   MOVE      FASCCY        HOSCCY                                       CLE033
     C                   Z-ADD     FAREXR        HOREXR                                       CLE033
     C                   MOVE      FAREXI        HOREXI                                       CLE033
     C                   MOVE      ##RECB        HORHBR                                       CLE033
     C                   MOVE      ##RECA        HORHAC                                       CLE033
     C**********         Z-ADD     FAROBN        HOROBN                                CLE033 CSD027
     C**********         Z-ADD     FAROCN        HOROCN                                CLE033 CSD027
     C                   EVAL      HOROBN = FAROBN                                            CSD027
     C                   EVAL      HOROCN = FAROCN                                            CSD027
     C                   MOVE      FARIBN        HORIBN                                       CLE033
     C                   MOVE      FARIBA        HORIBA                                       CLE033
     C                   MOVE      FAPSCY        HOPSCY                                       CLE033
     C                   Z-ADD     FAPEXR        HOPEXR                                       CLE033
     C                   MOVE      FAPEXI        HOPEXI                                       CLE033
     C                   MOVE      ##PAYB        HOPHBR                                       CLE033
     C                   MOVE      ##PAYA        HOPHAC                                       CLE033
     C**********         Z-ADD     FAPOBN        HOPOBN                                CLE033 CSD027
     C**********         Z-ADD     FAPOCN        HOPOCN                                CLE033 CSD027
     C                   EVAL      HOPOBN = FAPOBN                                            CSD027
     C                   EVAL      HOPOCN = FAPOCN                                            CSD027
     C                   MOVE      FAPIBA        HOPIBA                                       CLE033
     C                   MOVE      FARVNO        HORVNO                                       CLE033
     C                   MOVE      FACVMR        HOCVMR                                       CLE033
     C                   MOVE      FARCRN        HORCRN                                       CLE033
     C                   MOVE      FARCRA        HORCRA                                       CLE033
     C                   MOVE      FAAWBN        HOAWBN                                       CLE033
     C                   MOVE      FAAWBA        HOAWBA                                       CLE033
     C                   MOVE      FABENN        HOBENN                                       CLE033
     C                   MOVE      FABENA        HOBENA                                       CLE033
     C                   MOVE      FADTP1        HODTP1                                       CLE033
     C                   MOVE      FADTP2        HODTP2                                       CLE033
     C                   MOVE      FADTP3        HODTP3                                       CLE033
     C                   MOVE      FADTP4        HODTP4                                       CLE033
     C                   MOVE      FADCHG        HODCHG                                       CLE033
     C                   MOVE      FABTB1        HOBTB1                                       CLE033
     C                   MOVE      FABTB2        HOBTB2                                       CLE033
     C                   MOVE      FABTB3        HOBTB3                                       CLE033
     C                   MOVE      FABTB4        HOBTB4                                       CLE033
     C                   MOVE      FABTB5        HOBTB5                                       CLE033
     C                   MOVE      FABTB6        HOBTB6                                       CLE033
     C                   Z-ADD     FATNLU        HOTNLU                                       CLE033
     C                   MOVE      *BLANKS       HOPROG                                       218782
     C                   MOVEL     'AOOUFAU0'    HOPROG                                       218782
     C                   Z-ADD     0             HOSEQN                                       218782
     C                   MOVE      *BLANKS       HOSTAT                                       218782
      *                                                                                       CLE033
     C                   WRITE     LEHOSTD0                                                   CLE033
      *                                                                                       CLE033
     C     P@VL03        IFNE      *BLANKS                                                    CLE033
     C                   CALL      P@VL03                                                     CLE033
     C/COPY WNCPYSRC,AOOUFAU0C9                                                               CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       CLE033
     C                   ENDSR                                                                CLE033
      *****************************************************************                       CLE033
     C/EJECT                                                                                  CLE033
      *****************************************************************
      *                                                               *
      *  SRCLR    : Clear all postings in store                       *
      *                                                               *
      *  CALLED BY: Mainline                                          *
      *             UPDATE - Update database                          *
      *                                                               *
      *  CALLS    : SRERR - Report errors                             *
      *                                                               *
      *****************************************************************
     C     SRCLR         BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCLR'       @STK(Q)
      *
      *................................................................
      *
      ** Clear arrays in AOSPOSU0
      *
     C                   CLEAR                   C#DTA
     C                   CALL      'AOSPOSU0'                           9090
     C***********R#RTN     PARM *BLANKS   O#RTN   7                       134284
     C     R#RTN         PARM      ##RTCD        O#RTN                                         13428
     C                   PARM      '*CLEAR  '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C***********R#RTN     ORNE *BLANKS                                   134284
     C     R#RTN         OREQ      '*ERROR*'                                                   13428
     C                   MOVEL     '*CALL   '    W0FILE
     C                   MOVEL     'AOSPOSU0'    W0KEY
     C                   Z-ADD     901           W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      *
      *................................................................
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRERR    : Report error and close down program               *
      *                                                               *
      *  CALLED BY: Various                                           *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
      ** Dump program
      *
     C                   DUMP
     C     ##RTCD        IFNE      '*LEBTCH'                                                   13428
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     WCMT01        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                 13428
      *
      ** Close down program
      *
     C                   SETON                                        LR
     C                   SETON                                        U7U8                    CAP084
     C                   MOVEL     '*ERROR*'     ##RTCD
     C                   RETURN
      *
     C     EXERR         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Function    :  Initial processing - First Call Only           *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *................................................................
      *
      ** Initialise work fields
      *
     C                   MOVEL     'P'           ##PAY
     C                   MOVEL     'R'           ##REC
     C                   MOVEL     *BLANKS       R#RTN             7
     C                   MOVE      '0'           *IN98
      *
      ** Copyright
      *
     C                   MOVEA     ##CPY         ##BIS            80
      *                                                                                       CEU004
      **  Determine if LE Settlement Ccy Conversion Upgrade to DBA R2.0                       CEU004
      **  is installed                                                                        CEU004
      *                                                                                       CEU004
     C                   CALL      'AOSARDR0'                                                 CEU004
     C                   PARM      *BLANKS       WRTCD             7                          CEU004
     C                   PARM      '*KEY    '    WOPTN             7                          CEU004
     C                   PARM      'CEU004  '    WSARD             6                          CEU004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CEU004
      *                                                                                       CEU004
     C     WRTCD         IFEQ      *BLANKS                                                    CEU004
     C                   MOVE      'Y'           CEU004            1                          CEU004
     C                   ELSE                                                                 CEU004
     C                   MOVE      'N'           CEU004                                       CEU004
     C     WRTCD         IFNE      '*NRF    '                                                 CEU004
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CEU004
     C                   MOVEL     'CEU004'      W0KEY                                        CEU004
     C                   Z-ADD     907           W0ERNB                                       CEU004
     C                   EXSR      SRERR                                                      CEU004
     C                   ENDIF                                                                CEU004
     C                   ENDIF                                                                CEU004
      *                                                                                       CLE031
      **  Check if CLE031 - Lending Enhancements is on                                        CLE031
     C                   CALL      'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       WRTCD             7                          CLE031
     C                   PARM      '*KEY   '     WOPTN             7                          CLE031
     C                   PARM      'CLE031'      @SARD             6                          CLE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE031
      *                                                                                       CLE031
      ** If feature is on, set up SAR work flag                                               CLE031
      *                                                                                       CLE031
     C     WRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
      *                                                                                       CLE031
      ** else, database error if return code other than *NRF.                                 CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C     WRTCD         IFNE      '*NRF   '                                                  CLE031
     C                   MOVEL     'AOOUFEUO'    W0PGM             8                          CLE031
     C                   MOVEL     'SCSARDPD'    W0FILE                         ************* CLE031
     C                   Z-ADD     914           W0ERNB                         * DBERR 914 * CLE031
     C                   MOVEL     'CLE031'      W0KEY                          ************* CLE031
     C                   EXSR      SRERR                                                      CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDIF                                                                CLE031
     C*                                                                                       CLE033
     C**  Read switchable features file SCSARDPD using access object                          CLE033
     C**  to determine if switchable feature (CLE033) is switched ON                          CLE033
     C*                                                                                       CLE033
     C                   MOVE      'N'           CLE033            1                          CLE033
     C*                                                                                       CLE033
     C                   CALL      'AOSARDR0'                                                 CLE033
     C                   PARM      *BLANKS       W0RTCD            7                          CLE033
     C                   PARM      '*VERIFY'     W0OPTN            7                          CLE033
     C                   PARM      'CLE033'      W0SARD            6                          CLE033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE033
     C*                                                                                       CLE033
     C**  If feature is on, set up CLE033 variable                                            CLE033
     C*                                                                                       CLE033
     C     W0RTCD        IFEQ      *BLANKS                                                    CLE033
      *                                                                                       CLE033
     C                   MOVE      'Y'           CLE033                                       CLE033
      *                                                                                       CLE033
     C                   CALL      'AOSVALR0'                                                 CLE033
     C                   PARM      *BLANKS       W0RTCD                                       CLE033
     C                   PARM      SVAL(1)       P@OP01           20                          CLE033
     C                   PARM      *BLANKS       P@VL01          200                          CLE033
     C                   PARM      SVAL(2)       P@OP02           20                          CLE033
     C                   PARM      *BLANKS       P@VL02          200                          CLE033
     C                   PARM      SVAL(3)       P@OP03           20                          CLE033
     C                   PARM      *BLANKS       P@VL03          200                          CLE033
     C**********           PARM *BLANKS   P@OP04 20                                    CLE033 218782
     C                   PARM      SVAL(4)       P@OP04           20                          CLE033
     C                   PARM      *BLANKS       P@VL04          200                          CLE033
     C                   PARM      *BLANKS       P@OP05           20                          CLE033
     C                   PARM      *BLANKS       P@VL05          200                          CLE033
     C                   PARM      *BLANKS       P@OP06           20                          CLE033
     C                   PARM      *BLANKS       P@VL06          200                          CLE033
     C                   PARM      *BLANKS       P@OP07           20                          CLE033
     C                   PARM      *BLANKS       P@VL07          200                          CLE033
     C                   PARM      *BLANKS       P@OP08           20                          CLE033
     C                   PARM      *BLANKS       P@VL08          200                          CLE033
     C                   PARM      *BLANKS       P@OP09           20                          CLE033
     C                   PARM      *BLANKS       P@VL09          200                          CLE033
     C                   PARM      *BLANKS       P@OP10           20                          CLE033
     C                   PARM      *BLANKS       P@VL10          200                          CLE033
     C*****SDSVAL        PARM      SDSVAL        DSSDY                                  CLE033222373
      *                                                                                       CLE033
     C     W0RTCD        IFNE      *BLANKS                                                    CLE033
     C                   MOVEL     'AOOUFAUO'    W0PGM                                        CLE033
     C                   MOVEL     'SDSVALPD'    W0FILE                                       CLE033
     C                   MOVEL     '*KEY   '     W0KEY                                        CLE033
     C                   Z-ADD     909           W0ERNB                                       CLE033
     C                   EXSR      SRERR                                                      CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       218782
      ** Save value of Settlement09Postings in a one character field                          218782
     C                   MOVEL     P@VL04        SET09             1                          218782
     C*                                                                                       CLE034
     C**  Read switchable features file SCSARDPD using access object                          CLE034
     C**  to determine if switchable feature (CLE034) is switched ON                          CLE034
     C*                                                                                       CLE034
     C                   CALL      'AOSARDR0'                                                 CLE034
     C                   PARM      *BLANKS       W0RTCD            7                          CLE034
     C                   PARM      '*VERIFY'     W0OPTN            7                          CLE034
     C                   PARM      'CLE034'      W0SARD            6                          CLE034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE034
     C                   MOVE      '0'           *IN10                                        CLE034
     C*                                                                                       CLE034
     C**  If feature is on, set up CLE034 indicator                                           CLE034
     C*                                                                                       CLE034
     C     W0RTCD        IFEQ      *BLANKS                                                    CLE034
     C                   MOVE      'Y'           CLE034            1                          CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      'N'           CLE034                                       CLE034
     C*                                                                                       CLE034
     C** else, database error (if return code other than *NRF)                                CLE034
     C*                                                                                       CLE034
     C     W0RTCD        IFNE      '*NRF   '                                                  CLE034
     C                   MOVEL     'AOOUFAU0'    W0PGM                                        CLE034
     C                   MOVEL     'SCSARDPD'    W0FILE                         ************  CLE034
     C                   MOVEL     '*VERIFY'     W0KEY                          * DBERR 910*  CLE034
     C                   Z-ADD     910           W0ERNB                         ************  CLE034
     C                   ENDIF                                                                CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE033
     C**********         CALL      'AOBANKR0'                                          CLE033 CRE020
     C**********         PARM      *BLANKS       W0RTCD                                CLE033 CRE020
     C**********         PARM      '*KEY  '      W0OPTN                                CLE033 CRE020
     C*****SDBANK        PARM      SDBANK        DSSDY                                 CLE033 CRE020
      **********                                                                       CLE033 CRE020
     C*****W0RTCD        IFNE      *BLANKS                                             CLE033 CRE020
     C**********         MOVEL     'AOOUFAUO'    W0PGM                                 CLE033 CRE020
     C**********         MOVEL     'SDBANKPD'    W0FILE                                CLE033 CRE020
     C**********         MOVEL     '*FIRST '     W0KEY                                 CLE033 CRE020
     C**********         Z-ADD     908           W0ERNB                                CLE033 CRE020
     C**********         EXSR      SRERR                                               CLE033 CRE020
     C**********         ENDIF                                                         CLE033 CRE020
      **********                                                                       CLE033 CRE020
     C                   ELSE                                                                 CLE033
     C*                                                                                       CLE033
     C** else, database error (return code other than *NRF)                                   CLE033
     C*                                                                                       CLE033
     C     W0RTCD        IFNE      '*NRF   '                                                  CLE033
     C                   MOVEL     'AOOUFAUO'    W0PGM                                        CLE033
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CLE033
     C                   MOVEL     '*VERIFY'     W0KEY                                        CLE033
     C                   Z-ADD     907           W0ERNB                                       CLE033
     C                   EXSR      SRERR                                                      CLE033
     C                   ENDIF                                                                CLE033
     C*                                                                                       CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       CRE020
     C                   CALL      'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       WRTCD                                        CRE020
     C                   PARM      '*KEY    '    WOPTN                                        CRE020
     C                   PARM      'CRE020  '    WSARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
     C                   MOVE      'N'           CRE020                                       CRE020
      *                                                                                       CRE020
     C     WRTCD         IFEQ      *BLANKS                                                    CRE020
     C                   MOVE      'Y'           CRE020            1                          CRE020
     C                   ENDIF                                                                CRE020
     C*                                                                                       CLE033
     C                   CALL      'AOBANKR0'                                                 CRE020
     C                   PARM      *BLANKS       W0RTCD                                       CRE020
     C                   PARM      '*KEY  '      W0OPTN                                       CRE020
     C     SDBANK        PARM      SDBANK        DSSDY                                        CRE020
      *                                                                                       CRE020
     C     W0RTCD        IFNE      *BLANKS                                                    CRE020
     C                   MOVEL     'AOBANKR0'    W0PGM                                        CRE020
     C                   MOVEL     'SDBANKPD'    W0FILE                                       CRE020
     C                   MOVEL     '*FIRST '     W0KEY                                        CRE020
     C                   Z-ADD     908           W0ERNB                                       CRE020
     C                   EXSR      SRERR                                                      CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C/COPY WNCPYSRC,AOOUFAU0C2
      *
      * Determine if CSC022 is switched on                                                    CSC022
                                                                                              CSC022
     C                   CALL      'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       W0RTCD                                       CSC022
     C                   PARM      '*VERIFY'     W0OPTN                                       CSC022
     C                   PARM      'CSC022'      W0SARD                                       CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
     C     W0RTCD        IFEQ      *BLANKS                                                    CSC022
     C                   MOVE      'Y'           CSC022                                       CSC022
     C                   MOVE      'N'           WCMT01                                       CSC022
      * SCCMTJOB data area                                                                    CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      * Move data area to commitment array                                                    CSC022
     C                   IF        COMITNOM > 0                                               CSC022
     C                   MOVEA     COMITJOB      ARRJBNAM                                     CSC022
      *                                                                                       CSC022
      * Check if PSJOBNAME exist.                                                             CSC022
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17                  CSC022
     C                   IF        *IN17 = *ON                                                CSC022
     C                   MOVE      'Y'           WCMT01                                       CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ELSE                                                                 CSC022
      * w0rtcd not found                                                                      CSC022
     C     W0RTCD        IFNE      '*NRF   '                                                  CSC022
     C                   MOVEL     'AOOUFAUO'    W0PGM                                        CSC022
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CSC022
     C                   MOVEL     'CSC022'      W0KEY                                        CSC022
     C                   Z-ADD     915           W0ERNB                                       CSC022
     C                   EXSR      SRERR                                                      CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CAP205
      ** Determine if CAP205 is switched on                                                   CAP205
      *                                                                                       CAP205
     C                   CALL      'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       W0RTCD                                       CAP205
     C                   PARM      '*VERIFY'     W0OPTN                                       CAP205
     C                   PARM      'CAP205'      W0SARD                                       CAP205
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP205
     C     W0RTCD        IFEQ      *BLANKS                                                    CAP205
     C                   MOVE      'Y'           CAP205            1                          CAP205
     C                   ELSE                                                                 CAP205
     C                   MOVE      'N'           CAP205                                       CAP205
     C     W0RTCD        IFNE      '*NRF   '                                                  CAP205
     C                   MOVEL     'AOOUFAUO'    W0PGM                                        CAP205
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CAP205
     C                   MOVEL     'CAP205'      W0KEY                                        CAP205
     C                   Z-ADD     916           W0ERNB                                       CAP205
     C                   EXSR      SRERR                                                      CAP205
     C                   ENDIF                                                                CAP205
     C                   ENDIF                                                                CAP205
      *................................................................
      *
     C     EXINIT        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      ** Subroutine  :  SRCURR                                        *                       CLE031
      ** Function    :  Check currency details                        *                       CLE031
      ** Calls       :  AOCURRR0                                      *                       CLE031
      **                                                              *                       CLE031
      *****************************************************************                       CLE031
      *                                                                                       CLE031
     C     SRCURR        BEGSR                                                                CLE031
      *                                                                                       CLE031
     C                   CALL      'AOCURRR0'                                                 CLE031
     C                   PARM      *BLANKS       WRTCD                                        CLE031
     C                   PARM      '*KEY    '    WOPTN                                        CLE031
     C                   PARM      WCCY          WCURR             3                          CLE031
     C     SDCURR        PARM      SDCURR        DSSDY                                        CLE031
      *                                                                                       CLE031
      ** Handle Database Error.                                                               CLE031
      *                                                                                       CLE031
     C     WRTCD         IFNE      *BLANKS                                                    CLE031
     C                   MOVEL     'AOCURRR0'    W0PGM             8                          CLE031
     C                   MOVEL     'SDCURRPD'    W0FILE                                       CLE031
     C                   MOVEL     'WCCY   '     W0KEY                                        CLE031
     C                   Z-ADD     912           W0ERNB                                       CLE031
     C                   EXSR      SRERR                                                      CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
      *                                                                                       CLE031
     C                   ENDSR                                                                CLE031
      *****************************************************************                       CLE031
      ** Subroutine  :  SR34A                                         *                       CLE034
      ** Function    :  Initial set up for CLE034 processing          *                       CLE034
      ** Called by   :  SRFEAD                                        *                       CLE034
      ***Calls*******:**AOSTALR2***************************************                CLE034 219608
      ** Calls       :  AOSTALR2 AOBSTLR0                             *                       219608
      *                                                                                       CLE034
      *****************************************************************                       CLE034
      *                                                                                       CLE034
     C     SR34A         BEGSR                                                                CLE034
      *                                                                                       CLE034
     C                   Z-ADD     0             TOTAMT           13 0                        CLE034
     C                   Z-ADD     0             WRKAMT           13 0                        CLE034
     C                   MOVE      *BLANK        WRKFLD            1                          CLE034
     C                   Z-ADD     ##AMT         SAVAMT           13 0                        CLE034
     C                   MOVE      FEEAD         SVFEAD                                       CLE034
     C                   MOVE      ##RECM        W#RECM            2 0                        CLE034
     C                   MOVE      ##RECA        W#RECA           12                          CLE034
     C                   MOVE      ##RECB        W#RECB            3                          CLE034
     C                   MOVE      ##PAYM        W#PAYM            2 0                        CLE034
     C                   MOVE      ##PAYA        W#PAYA           12                          CLE034
     C                   MOVE      ##PAYB        W#PAYB            3                          CLE034
     C                   MOVE      ##CCY         W#CCY             3                          CLE034
     C                   MOVE      SVSCCY        W#SVCY            3                          CLE034
     C                   MOVE      SVPSCY        W#PSCY            3                          CLE034
     C                   Z-ADD     SVREXR        W#REXR           13 8                      AR943686
     C                   Z-ADD     SVPEXR        W#PEXR           13 8                      AR943686
     C                   MOVE      SVREXI        W#REXI            1                        AR943686
     C                   MOVE      SVPEXI        W#PEXI            1                        AR943686
      *                                                                                       CLE034
     C     PTFI          IFEQ      *BLANK                                                     CLE034
     C                   MOVE      'R'           W#PYRC            1                          CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      'P'           W#PYRC                                       CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C                   MOVE      FALOAN        PLNRF                                        CLE034
     C                   MOVE      FACNUM        PCNUM                                        CLE034
     C                   MOVE      FAFACL        PFACL                                        CLE034
     C                   MOVE      FAFSEQ        PFSEQ                                        CLE034
     C                   MOVE      FAVDAT        PVDAT                                        CLE034
      *                                                                                       CLE034
      ** If reversing existing allocations, call AOBSTLR0 to                                  219608
      ** access the 'before' image from LEBSTLPD:                                             219608
     C     ##REVI        IFEQ      'YES'                                                      219608
     C                   CALL      'AOBSTLR0'                                                 219608
     C                   PARM      *BLANKS       STALCD            7                          219608
     C                   PARM      '*FIRST '     POPTN             7                          219608
     C                   PARM      'FSET'        PTYPE             4                          219608
     C                   PARM                    PLNRF             6                          219608
     C                   PARM                    PVDAT             5                          219608
     C                   PARM      *ZEROS        PLASN             3                          219608
     C                   PARM                    PCNUM             6                          219608
     C                   PARM                    PFACL             5                          219608
     C                   PARM                    PFSEQ             2                          219608
     C                   PARM      W#PYRC        PPYRC             1                          219608
     C     LESTAL        PARM      LESTAL        DSSDY                                        219608
     C                   MOVEL     *BLANKS       BEFORE            1                          219608
      *                                                                                       219608
     C     STALCD        IFNE      *BLANK                                                     219608
      ** If could not find any, use the normal AOSTALR2 to                                    219608
      ** access the existing image                                                            219608
     C                   MOVEL     'N'           BEFORE                                       219608
     C                   CALL      'AOSTALR2'                                                 219608
     C                   PARM      *BLANKS       STALCD                                       219608
     C                   PARM      '*FIRST '     POPTN                                        219608
     C                   PARM      'FSET'        PTYPE                                        219608
     C                   PARM                    PLNRF                                        219608
     C                   PARM                    PVDAT                                        219608
     C                   PARM      *ZEROS        PLASN                                        219608
     C                   PARM                    PCNUM                                        219608
     C                   PARM                    PFACL                                        219608
     C                   PARM                    PFSEQ                                        219608
     C                   PARM      W#PYRC        PPYRC                                        219608
     C     LESTAL        PARM      *BLANKS       DSSDY                                        219608
      *                                                                                       219608
     C     STALCD        IFNE      *BLANKS                                                    219608
     C                   MOVEL     'AOOUFAU0'    W0PGM                                        219608
     C                   MOVEL     'LEBSTLPD'    W0FILE                                       219608
     C                   MOVEL     'AOBSTLR0'    W0KEY                                        219608
     C                   Z-ADD     913           W0ERNB                                       219608
     C                   EXSR      SRERR                                                      219608
     C                   ENDIF                                                                219608
     C                   ENDIF                                                                219608
      ** Else, inserting new allocations, so call AOSTALR2                                    219608
      ** to access the 'after' image of LESTALPD:                                             219608
     C                   ELSE                                                   ##REVI not YES219608
      *                                                                                       219608
     C                   CALL      'AOSTALR2'                                                 CLE034
     C                   PARM      *BLANKS       STALCD            7                          CLE034
     C                   PARM      '*FIRST '     POPTN             7                          CLE034
     C                   PARM      'FSET'        PTYPE             4                          CLE034
     C                   PARM                    PLNRF             6                          CLE034
     C                   PARM                    PVDAT             5                          CLE034
     C                   PARM      *ZEROS        PLASN             3                          CLE034
     C                   PARM                    PCNUM             6                          CLE034
     C                   PARM                    PFACL             5                          CLE034
     C                   PARM                    PFSEQ             2                          CLE034
     C                   PARM      W#PYRC        PPYRC             1                          CLE034
     C     LESTAL        PARM      *BLANKS       DSSDY                                        CLE034
      *                                                                                       CLE034
     C     STALCD        IFNE      *BLANKS                                                    CLE034
     C                   MOVEL     'AOOUFAU0'    W0PGM                                        CLE034
     C                   MOVEL     'LESTALPD'    W0FILE                                       CLE034
     C                   Z-ADD     911           W0ERNB                                       CLE034
     C                   MOVEL     POPTN         W0KEY                                        CLE034
     C                   EXSR      SRERR                                                      CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       219608
     C                   ENDIF                                                  End ##REVI chk219608
      *                                                                                       CLE034
     C                   ENDSR                                                  END SR34A     CLE034
      *****************************************************************                       CLE034
      *                                                                                       CLE034
      ** Subroutine  :  SR34B                                         *                       CLE034
      ** Function    :  Calculate amount for Settlement Allocation    *                       CLE034
      ** Called by   :  SRFEAD                                        *                       CLE034
      ** Calls       :                                                *                       CLE034
      *                                                                                       CLE034
      *****************************************************************                       CLE034
      *                                                                                       CLE034
     C     SR34B         BEGSR                                                                CLE034
      *                                                                                       CLE034
     C     W#PYRC        IFEQ      'P'                                                        CLE034
     C     PYPC          DIV       100           W#PYPC           13 9                        CLE034
     C     SAVAMT        MULT(H)   W#PYPC        WRKAMT                                       CLE034
     C                   ELSE                                                                 CLE034
     C     RCPC          DIV       100           W#RCPC           13 9                        CLE034
     C     SAVAMT        MULT(H)   W#RCPC        WRKAMT                                       CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C     TOTAMT        ADD       WRKAMT        TOTAMT                                       CLE034
      *                                                                                       CLE034
      * If WRKFLD = 'Y' (Last allocation being processed)                                     CLE034
      * check for any rounding errors, and add any difference                                 CLE034
      * to this posting, as this will be the largest allocation.                              CLE034
     C     WRKFLD        IFEQ      'Y'                                                        CLE034
     C     SAVAMT        ANDNE     TOTAMT                                                     CLE034
     C     SAVAMT        SUB       TOTAMT        W#DIFF           13 0                        CLE034
     C     WRKAMT        ADD       W#DIFF        WRKAMT                                       CLE034
     C**********           Z-ADDWRKAMT    ##AMT                                        CLE034 219608
     C                   ENDIF                                                                CLE034
     C                   Z-ADD     WRKAMT        ##AMT                                        219608
      *                                                                                       CLE034
     C                   EXSR      SR34D                                                      CLE034
      *                                                                                       CLE034
     C                   ENDSR                                                  END SR34B     CLE034
      *****************************************************************                       CLE034
      ** Subroutine  :  SR34C                                         *                       CLE034
      ** Function    :  Processing to get next settlement allocation  *                       CLE034
      ** Called by   :  SRFEAD                                        *                       CLE034
      ***Calls*******:**AOSTALR2***************************************                CLE034 219608
      ** Calls       :  AOSTALR2 AOBSTLR0                             *                       219608
      *                                                                                       CLE034
      *****************************************************************                       CLE034
      *                                                                                       CLE034
     C     SR34C         BEGSR                                                                CLE034
      *                                                                                       CLE034
     C     WRKFLD        IFEQ      'Y'                                                        CLE034
     C                   MOVE      *BLANK        WRKFLD                                       CLE034
     C                   ELSE                                                                 CLE034
      *                                                                                       CLE034
     C                   MOVE      FALOAN        PLNRF                                        CLE034
     C                   MOVE      FACNUM        PCNUM                                        CLE034
     C                   MOVE      FAFACL        PFACL                                        CLE034
     C                   MOVE      FAFSEQ        PFSEQ                                        CLE034
     C                   MOVE      FAVDAT        PVDAT                                        CLE034
      *                                                                                       CLE034
      ** If reversing existing allocations, call AOBSTLR0 to                                  219608
      ** access the 'before' image from LEBSTLPD:                                             219608
     C     ##REVI        IFEQ      'YES'                                                      219608
     C     BEFORE        ANDEQ     *BLANKS                                                    219608
     C                   CALL      'AOBSTLR0'                                                 219608
     C                   PARM      *BLANKS       STALCD            7                          219608
     C                   PARM      '*NEXT  '     POPTN             7                          219608
     C                   PARM      'FSET'        PTYPE                                        219608
     C                   PARM                    PLNRF                                        219608
     C                   PARM                    PVDAT                                        219608
     C                   PARM      *ZEROS        PLASN                                        219608
     C                   PARM                    PCNUM                                        219608
     C                   PARM                    PFACL                                        219608
     C                   PARM                    PFSEQ                                        219608
     C                   PARM      W#PYRC        PPYRC                                        219608
     C     LESTAL        PARM      *BLANKS       DSSDY                                        219608
      *                                                                                       219608
      ** Else, inserting new allocations, so call AOSTALR2                                    219608
      ** to access the 'after' image of LESTALPD:                                             219608
     C                   ELSE                                                   ##REVI not YES219608
      *                                                                                       219608
     C                   CALL      'AOSTALR2'                                                 CLE034
     C                   PARM      *BLANKS       STALCD            7                          CLE034
     C                   PARM      '*NEXT  '     POPTN             7                          CLE034
     C                   PARM      'FSET'        PTYPE                                        CLE034
     C                   PARM                    PLNRF                                        CLE034
     C                   PARM                    PVDAT                                        CLE034
     C                   PARM      *ZEROS        PLASN                                        CLE034
     C                   PARM                    PCNUM                                        CLE034
     C                   PARM                    PFACL                                        CLE034
     C                   PARM                    PFSEQ                                        CLE034
     C                   PARM      W#PYRC        PPYRC                                        CLE034
     C     LESTAL        PARM      *BLANKS       DSSDY                                        CLE034
      *                                                                                       219608
     C                   ENDIF                                                  End ##REVI chk219608
      *                                                                                       CLE034
     C     STALCD        IFEQ      '*EOF'                                                     CLE034
     C                   MOVE      'Y'           WRKFLD                                       CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C                   ENDSR                                                  END SR34C     CLE034
      *****************************************************************                       CLE034
      ** Subroutine  :  SR34D                                         *                       CLE034
      ** Function    :  Set up fields from settlement allocation      *                       CLE034
      ** Called by   :  SR34B                                         *                       CLE034
      ** Calls       :                                                *                       CLE034
      *                                                                                       CLE034
      *****************************************************************                       CLE034
      *                                                                                       CLE034
     C     SR34D         BEGSR                                                                CLE034
      *                                                                                       CLE034
     C     W#PYRC        IFEQ      'P'                                                        CLE034
     C                   MOVE      STPSTM        FAMETH                                       CLE034
     C                   MOVE      STPONS        FAOURS                                       CLE034
     C                   MOVE      STPOBR        FAOSBR                                       CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      STRSTM        FAMETH                                       CLE034
     C                   MOVE      STRONS        FAOURS                                       CLE034
     C                   MOVE      STROBR        FAOSBR                                       CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C                   MOVE      STRSTM        ##RECM                                       CLE034
     C                   MOVE      STRONS        ##RECA                                       CLE034
     C                   MOVE      STROBR        ##RECB                                       CLE034
     C                   MOVE      STPSTM        ##PAYM                                       CLE034
     C                   MOVE      STPONS        ##PAYA                                       CLE034
     C                   MOVE      STPOBR        ##PAYB                                       CLE034
     C                   MOVE      STRSCY        FASCCY                                       CLE034
     C                   Z-ADD     STREXR        FAREXR                                       CLE034
     C                   MOVE      STREXI        FAREXI                                       CLE034
     C                   MOVE      ROBN          FAROBN                                       CLE034
     C                   MOVE      ROCN          FAROCN                                       CLE034
     C                   MOVE      RIBN          FARIBN                                       CLE034
     C                   MOVE      RIBA          FARIBA                                       CLE034
     C                   MOVE      STPSCY        FAPSCY                                       CLE034
     C                   Z-ADD     STPEXR        FAPEXR                                       CLE034
     C                   MOVE      STPEXI        FAPEXI                                       CLE034
     C                   MOVE      POBN          FAPOBN                                       CLE034
     C                   MOVE      POCN          FAPOCN                                       CLE034
     C                   MOVE      PIBN          FAPIBN                                       CLE034
     C                   MOVE      PIBA          FAPIBA                                       CLE034
     C                   MOVE      RVNO          FARVNO                                       CLE034
     C                   MOVE      CVMR          FACVMR                                       CLE034
     C                   MOVE      RCRN          FARCRN                                       CLE034
     C                   MOVE      RCRA          FARCRA                                       CLE034
     C                   MOVE      AWBN          FAAWBN                                       CLE034
     C                   MOVE      AWBA          FAAWBA                                       CLE034
     C                   MOVE      BENN          FABENN                                       CLE034
     C                   MOVE      BENA          FABENA                                       CLE034
     C                   MOVE      DTP1          FADTP1                                       CLE034
     C                   MOVE      DTP2          FADTP2                                       CLE034
     C                   MOVE      DTP3          FADTP3                                       CLE034
     C                   MOVE      DTP4          FADTP4                                       CLE034
     C                   MOVE      DCHG          FADCHG                                       CLE034
     C                   MOVE      BTB1          FABTB1                                       CLE034
     C                   MOVE      BTB2          FABTB2                                       CLE034
     C                   MOVE      BTB3          FABTB3                                       CLE034
     C                   MOVE      BTB4          FABTB4                                       CLE034
     C                   MOVE      BTB5          FABTB5                                       CLE034
     C                   MOVE      BTB6          FABTB6                                       CLE034
      *                                                                                       CLE034
     C     CEU004        IFEQ      'Y'                                                        CLE034
     C     CLE031        ANDNE     'Y'                                                        CLE034
     C     FASCCY        ANDNE     *BLANKS                                                    CLE034
     C                   MOVE      FASCCY        ##CCY                                        CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      FAFCCY        ##CCY                                        CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C     CLE031        IFEQ      'Y'                                                        CLE034
      *                                                                                       CLE034
     C*****FASCCY        IFNE      *BLANKS                                           CLE034 AR943686
     C                   MOVE      FASCCY        SVSCCY                                       CLE034
     C**********         ENDIF                                                       CLE034 AR943686
     C*****FAPSCY        IFNE      *BLANKS                                           CLE034 AR943686
     C                   MOVE      FAPSCY        SVPSCY                                       CLE034
     C**********         ENDIF                                                       CLE034 AR943686
      *                                                                                       CLE034
     C                   Z-ADD     FAREXR        SVREXR                                     AR943686
     C                   MOVE      FAREXI        SVREXI                                     AR943686
     C                   Z-ADD     FAPEXR        SVPEXR                                     AR943686
     C                   MOVE      FAPEXI        SVPEXI                                     AR943686
      *                                                                                     AR943686
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C                   ENDSR                                                  END SR34D     CLE034
      *****************************************************************                       CLE034
      *                                                                                       CLE034
      ** Subroutine  :  SR34E                                         *                       CLE034
      ** Function    :  Restore original fields                       *                       CLE034
      ** Called by   :  SRFEED                                        *                       CLE034
      ** Calls       :                                                *                       CLE034
      *                                                                                       CLE034
      *****************************************************************                       CLE034
      *                                                                                       CLE034
     C     SR34E         BEGSR                                                                CLE034
      *                                                                                       CLE034
     C                   MOVE      W#RECM        ##RECM                                       CLE034
     C                   MOVE      W#RECA        ##RECA                                       CLE034
     C                   MOVE      W#RECB        ##RECB                                       CLE034
     C                   MOVE      W#PAYM        ##PAYM                                       CLE034
     C                   MOVE      W#PAYA        ##PAYA                                       CLE034
     C                   MOVE      W#PAYB        ##PAYB                                       CLE034
     C                   MOVE      W#CCY         ##CCY                                        CLE034
     C                   MOVE      W#SVCY        SVSCCY                                       CLE034
     C                   MOVE      W#PSCY        SVPSCY                                       CLE034
     C                   Z-ADD     W#REXR        SVREXR                                     AR943686
     C                   Z-ADD     W#PEXR        SVPEXR                                     AR943686
     C                   MOVE      W#REXI        SVREXI                                     AR943686
     C                   MOVE      W#PEXI        SVPEXI                                     AR943686
     C                   MOVE      SVFEAD        FEEAD                                        CLE034
      *                                                                                       CLE034
     C                   ENDSR                                                  END SR34E     CLE034
      *****************************************************************                       CLE034
     C/COPY WNCPYSRC,AOH00030
      *                                                                                       CLE031
      /TITLE SR/ZCONV                                                                         CLE031
     C/COPY ZSRSRC,ZCONVZ1ILE                                                                 CLE031
     C/SPACE 5
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION                                           CLE031
0000001                                                                                       CLE031
0000010                                                                                       CLE031
0000100                                                                                       CLE031
0001000                                                                                       CLE031
0010000                                                                                       CLE031
0100000                                                                                       CLE031
1000000                                                                                       CLE031
**   SVAL  -  SYSTEM VALUES ARRAY                                                             CLE033
Settlement09Customer                                                                          CLE033
Settlement09AccCode                                                                           CLE033
Settlement09Hostpgm                                                                           CLE033
Settlement09Postings                                                                          218782

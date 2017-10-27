     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Year-end files maintenance')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000008 - Year-End File Maintenance of Unrealized P&L       *
      *                                                               *
      *  Function:  This module will run at year-end and it will copy *
      *             the Unrealized Profit/Loss (xxURPL) to the        *
      *             Unrealized Profit/Loss at Year-End (xxYUPL) for   *
      *             the following files:  DEALSDB, DEALSDC, DEALSDD,  *
      **************TRANSD,*CLOANCL,*IRNPVLPD,*FFNPVLPD*and*SENPVLPD.**                       CAS005
      **************TRANSD,*CLOANCL,*IRNPVAPD,*FFNPVLPD,*SENPVLPD,*****                CAS005 CAS006
      **************RXNPVAPD,*IRNPVBPD*and*RXNPVBPD.*******************                CAS005 CAS006
      *             TRANSD, CLOANCL, IRNPVAPD, FFNPVLPD, SEMKVLPD,    *                       CAS006
      *             SEMKVAPD, RXNPVAPD, IRNPVBPD, RXNPVBPD, FRNPVLPD, *                       CAS006
      *             FRNPVAPD, MMNPVLPD, MMNPVAPD, LENPVLPD & LENPVAPD *                       CAS006
      *                                                               *
      *  Component of: ASC000008                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CLE141             Date 08Feb16               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSW212             Date 03May12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAS009             Date 16May05               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS003             Date 14Jan02               *
      *                 CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS003 - Hedge Strategy/Linkage for Futures and Options      *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRForEx   - Subroutine to update the Unrealized Profit/Loss   *
      *             at Yearend field of Foreign Exchange Deals File   *
      * SRMonMrkt - Subroutine to update the Unrealized Profit/Loss   *
      *             at Yearend field of Money Market Deals File       *
      * SRNegAsst - Subroutine to update the Unrealized Profit/Loss   *
      *             at Yearend field of Negotiable Assets Purchased   *
      *             Deals File                                        *
      * SRLending - Subroutine to update the Unrealized Profit/Loss   *
      *             at Yearend field of Customer Loans Details File   *
      * SRForeTrn - Subroutine to update the Unrealized Profit/Loss   *                       CAS006
      *             at Yearend field of Forecast Transactions File    *                       CAS006
      * SRIRNPV   - Subroutine to update the Unrealized Profit/Loss   *
      *             at Yearend field of Revalued IRSs File            *
      * SRFFTrans - Subroutine to update the Unrealized Profit/Loss   *                       CAS003
      *             at Yearend field of FF Transactions File          *                       CAS003
      * SRFFNPV   - Subroutine to update the Unrealized Profit/Loss   *                       CAS003
      *             at Yearend field of Revalued Futures and Options  *                       CAS003
      *             Positions File                                    *                       CAS003
      * SRSENPV   - Subroutine to update the Unrealized Profit/Loss   *
      *             at Yearend field of Revalued Securities Positions *
      *             File                                              *
      * *PSSR     - Program Exception Error Routine                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDEALSDB   UF   E             DISK    INFSR(*PSSR)
      ** Midas DL Foreign Exchange Deals File
 
     FDEALSDC   UF   E             DISK    INFSR(*PSSR)
      ** Midas DL Money Market and Loans Deals File
 
     FDEALSDD   UF   E             DISK    INFSR(*PSSR)
      ** Midas DL Negotiable Assets Purchased Deals File
 
     FCLOANCL   UF   E             DISK    INFSR(*PSSR)
      ** Midas LE Customer Loans File
 
     FTRANSD    UF   E             DISK    INFSR(*PSSR)                                       CAS003
      ** Midas FF Transaction Details File                                                    CAS003
                                                                                              CAS003
     F***IRNPVLPD  UF   E             DISK    INFSR(*PSSR)                                    CAS005
     FIRNPVAPD  UF   E             DISK    INFSR(*PSSR)                                       CAS005
      ***Midas*IR*Revalued*IRSs*File**********************************                        CAS005
      ** Midas IR Revalued SIRS File                                                          CAS005
                                                                                              CAS005
     FRXNPVAPD  UF   E             DISK    INFSR(*PSSR)                                       CAS005
     F                                     PREFIX(RX)                                         CAS005
      ** Midas IR Revalued CIRS File                                                          CAS005
                                                                                              CAS005
     FIRNPVBPD  UF   E             DISK    INFSR(*PSSR)                                       CAS005
     F                                     RENAME(IRNPVAD0:IRNPVBD0)                          CAS006
     F                                     PREFIX(SB)                                         CAS005
      ** Midas IR Revalued SIRS Using Base Rate                                               CAS005
                                                                                              CAS005
     FRXNPVBPD  UF   E             DISK    INFSR(*PSSR)                                       CAS005
     F                                     RENAME(RXNPVAD0:RXNPVBD0)                          CAS005
     F                                     PREFIX(CB)                                         CAS005
      ** Midas IR Revalued CIRS Using Base Rate                                               CAS005
 
     FFFNPVLPD  UF   E             DISK    INFSR(*PSSR)                                       CAS003
      ** Midas FF Revalued Futures and Options Positions File                                 CAS003
                                                                                              CAS003
     FLENPVLPD  UF   E             DISK    INFSR(*PSSR)                                       CAS006
      ** Midas LE Revalued Customer Loans File                                                CAS006
                                                                                              CAS006
     FLENPVAPD  UF   E             DISK    INFSR(*PSSR)                                       CAS006
      ** Midas LE Revalued Customer Loans with All-in-Rate File                               CAS006
                                                                                              CAS006
     FMMNPVLPD  UF   E             DISK    INFSR(*PSSR)                                       CAS006
     F                                     PREFIX(ML)                                         CAS006
      ** Midas MM Revaluation using N-T-R File                                                CAS006
                                                                                              CAS006
     FMMNPVAPD  UF   E             DISK    INFSR(*PSSR)                                       CAS006
     F                                     PREFIX(MA)                                         CAS006
      ** Midas MM Revaluation using All-in-Rate                                               CAS006
                                                                                              CAS006
     FFRNPVLPD  UF   E             DISK    INFSR(*PSSR)                                       CAS006
     F                                     RENAME(FRNPVAD0:FRNPVLD0)                          CAS006
     F                                     PREFIX(FL)                                         CAS006
      ** Midas IR Revalued FRAs Using All-in-Rate                                             CAS006
                                                                                              CAS006
     FFRNPVAPD  UF   E             DISK    INFSR(*PSSR)                                       CAS006
     F                                     PREFIX(FB)                                         CAS006
      ** Midas IR Revalued FRAs Using Base Rate                                               CAS006
                                                                                              CAS006
     F*SENPVLPD*UF***E*************DISK****INFSR(*PSSR)***************                        CAS006
      ***Midas*SE*Revalued*Securities*Positions*File******************                        CAS006
                                                                                              CAS006
     FSEMKVAPD  UF   E             DISK    INFSR(*PSSR)                                       CAS006
     F                                     PREFIX(SA)                                         CAS006
      ** Midas SE Market Values Using All-in-Prices                                           CAS006
                                                                                              CAS006
     FSEMKVLPD  UF   E             DISK    INFSR(*PSSR)                                       CAS006
     F                                     PREFIX(SL)                                         CAS006
      ** Midas SE Market Values Using Net-Treasury-Prices                                     CAS006
                                                                                              CAS006
     FASFHTRPD  UF   E             DISK    INFSR(*PSSR)                                       CAS006
     F                                                                                        CAS006
      ** Midas AS Forecast Transactions File                                                  CAS006
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** DS for SC Switchable Features                                                        CAS003
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS003
                                                                                              CAS003
      ** First DS for access programs, short data structure                                   CAS003
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CAS003
                                                                                              CAS003
     D WRun            S              1A
     D PRtCd           S              7A                                                      CAS003
     D PSard           S              6A                                                      CAS003
     D POptn           S              7A                                                      CAS003
     D CAS003          S              1A                                                      CAS003
     D CAS004          S              1A                                                      CAS004
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      SRForEx
 
     C                   EXSR      SRMonMrkt
 
     C                   EXSR      SRNegAsst
 
     C                   EXSR      SRLending
                                                                                              CAS006
     C                   EXSR      SRForeTrn                                                  CAS006
 
     C                   EXSR      SRIRNPV
 
     C                   IF        CAS003 = 'Y'                                               CAS003
     C                   EXSR      SRFFTrans                                                  CAS003
                                                                                              CAS003
     C                   EXSR      SRFFNPV                                                    CAS003
     C                   ENDIF                                                                CAS003
 
     C                   EXSR      SRSENPV
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRForEx - Subroutine to update the Unrealized Profit/Loss    *
      *            at Yearend field of Foreign Exchange Deals File    *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
      *                                                               *
      ****************************************************************
 
     C     SRForEx       BEGSR
 
     C                   READ      DEALSDB
 
     C                   DOW       NOT %EOF(DEALSDB)
     C                   EVAL      FSYUPL = FSURPL
                                                                                              CAS004
      ** Save Sell Currency Unrealized Profit/Loss, FSSUPL at yearend to                      CAS004
      ** FSSYL for forward commitments when CAS004 is on                                      CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      FSSYPL = FSSUPL                                            CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   UPDATE    DEALSDBF
     C                   READ      DEALSDB
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMonMrkt - Subroutine to update the Unrealized Profit/Loss  *
      *              at Yearend field of Money Market Deals File      *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
      *                                                               *
      ****************************************************************
 
     C     SRMonMrkt     BEGSR
 
     C                   READ      DEALSDC
 
     C                   DOW       NOT %EOF(DEALSDC)
     C***********        EVAL      FSYUPL = FSURPL                                            CAS005
     C                   EVAL      FSYUPL = FSTUPL                                            CAS005
     C                   UPDATE    DEALSDCF
     C                   READ      DEALSDC
     C                   ENDDO
                                                                                              CAS006
      ** Revalued Money Market using Net-Treasury-Rate                                        CAS006
                                                                                              CAS006
     C                   READ      MMNPVLPD                                                   CAS006
                                                                                              CAS006
     C                   DOW       NOT %EOF(MMNPVLPD)                                         CAS006
     C                   EVAL      MLMMYUPL = MLMMURPL                                        CAS006
     C                   UPDATE    MMNPVLD0                                                   CAS006
     C                   READ      MMNPVLPD                                                   CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
      ** Revalued Money Market using All-in-Rate                                              CAS006
                                                                                              CAS006
     C                   READ      MMNPVAPD                                                   CAS006
                                                                                              CAS006
     C                   DOW       NOT %EOF(MMNPVAPD)                                         CAS006
     C                   EVAL      MAMNYUPL = MAMNURPL                                        CAS006
     C                   UPDATE    MMNPVAD0                                                   CAS006
     C                   READ      MMNPVAPD                                                   CAS006
     C                   ENDDO                                                                CAS006
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNegAsst - Subroutine to update the Unrealized Profit/Loss  *
      *              at Yearend field of Negotiable Assets Purchased  *
      *              Deals File                                       *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
      *                                                               *
      ****************************************************************
 
     C     SRNegAsst     BEGSR
 
     C                   READ      DEALSDD
 
     C                   DOW       NOT %EOF(DEALSDD)
     C***********        EVAL      FSYUPL = FSURPL                                            CAS005
     C                   EVAL      FSYUPL = FSTUPL                                            CAS005
     C                   UPDATE    DEALSDDF
     C                   READ      DEALSDD
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLending - Subroutine to update the Unrealized Profit/Loss  *
      *              at Yearend field of Customer Loans Details File  *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
      *                                                               *
      ****************************************************************
 
     C     SRLending     BEGSR
 
     C                   READ      CLOANCL
 
     C                   DOW       NOT %EOF(CLOANCL)
     C***********        EVAL      FSYUPL = FSURPL                                            CAS005
     C                   EVAL      FSYUPL = FSPLAM                                            CAS005
     C                   UPDATE    CLOANCLF
     C                   READ      CLOANCL
     C                   ENDDO
                                                                                              CAS006
      ** Revalued Customer Loans                                                              CAS006
                                                                                              CAS006
     C                   READ      LENPVLPD                                                   CAS006
                                                                                              CAS006
     C                   DOW       NOT %EOF(LENPVLPD)                                         CAS006
     C                   EVAL      LEYUPL = LEURPL                                            CAS006
     C                   UPDATE    LENPVLD0                                                   CAS006
     C                   READ      LENPVLPD                                                   CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
      ** Revalued Customer Loans using All-in-Rate                                            CAS006
                                                                                              CAS006
     C                   READ      LENPVAPD                                                   CAS006
                                                                                              CAS006
     C                   DOW       NOT %EOF(LENPVAPD)                                         CAS006
     C                   EVAL      LNYUPL = LNURPL                                            CAS006
     C                   UPDATE    LENPVAD0                                                   CAS006
     C                   READ      LENPVAPD                                                   CAS006
     C                   ENDDO                                                                CAS006
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRForeTrn - Subroutine to update the Unrealized Profit/Loss  *                       CAS006
      *              at Yearend field of Forecast Transactions File   *                       CAS006
      *                                                               *                       CAS006
      *  Called By:  Main Processing                                  *                       CAS006
      *                                                               *                       CAS006
      *  Calls    :  None                                             *                       CAS006
      *                                                               *                       CAS006
      ****************************************************************                        CAS006
                                                                                              CAS006
     C     SRForeTrn     BEGSR                                                                CAS006
                                                                                              CAS006
     C                   READ      ASFHTRPD                                                   CAS006
                                                                                              CAS006
     C                   DOW       NOT %EOF(ASFHTRPD)                                         CAS006
     C                   EVAL      FSYUPL = FSURPL                                            CAS006
     C                   UPDATE    ASFHTRD0                                                   CAS006
     C                   READ      ASFHTRPD                                                   CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************                       CAS006
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIRNPV - Subroutine to update the Unrealized Profit/Loss    *
      *            at Yearend field of Revalued IRSs File             *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
      *                                                               *
      ****************************************************************
 
     C     SRIRNPV       BEGSR
 
      ** Single Currency using All-in-Rate                                                    CAS005
                                                                                              CAS005
     C**********         READ      IRNPVLPD                                                   CAS005
     C                   READ      IRNPVAPD                                                   CAS005
 
     C**********         DOW       NOT %EOF(IRNPVLPD)                                         CAS005
     C                   DOW       NOT %EOF(IRNPVAPD)                                         CAS005
     C                   EVAL      IRYUPL = IRURPL
     C**********         UPDATE    IRNPVLD0                                                   CAS005
     C**********         READ      IRNPVLPD                                                   CAS005
     C                   UPDATE    IRNPVAD0                                                   CAS005
     C                   READ      IRNPVAPD                                                   CAS005
     C                   ENDDO
 
      ** Cross Currency using All-in-Rate                                                     CAS005
                                                                                              CAS005
     C                   READ      RXNPVAPD                                                   CAS005
                                                                                              CAS005
     C                   DOW       NOT %EOF(RXNPVAPD)                                         CAS005
     C                   EVAL      RXIRYUPL = RXIRURPL                                        CAS005
     C                   UPDATE    RXNPVAD0                                                   CAS005
     C                   READ      RXNPVAPD                                                   CAS005
     C                   ENDDO                                                                CAS005
                                                                                              CAS005
      ** Single Currency using Base Rate                                                      CAS005
                                                                                              CAS005
     C                   READ      IRNPVBPD                                                   CAS005
                                                                                              CAS005
     C                   DOW       NOT %EOF(IRNPVBPD)                                         CAS005
     C                   EVAL      SBIRYUPL = SBIRURPL                                        CAS005
     C                   UPDATE    IRNPVBD0                                                   CAS005
     C                   READ      IRNPVBPD                                                   CAS005
     C                   ENDDO                                                                CAS005
                                                                                              CAS005
      ** Cross Currency using Base Rate                                                       CAS005
                                                                                              CAS005
     C                   READ      RXNPVBPD                                                   CAS005
                                                                                              CAS005
     C                   DOW       NOT %EOF(RXNPVBPD)                                         CAS005
     C                   EVAL      CBIRYUPL = CBIRURPL                                        CAS005
     C                   UPDATE    RXNPVBD0                                                   CAS005
     C                   READ      RXNPVBPD                                                   CAS005
     C                   ENDDO                                                                CAS005
                                                                                              CAS005
      ** Forward Rate Agreement using All-in-Rate                                             CAS006
                                                                                              CAS006
     C                   READ      FRNPVLPD                                                   CAS006
                                                                                              CAS006
     C                   DOW       NOT %EOF(FRNPVLPD)                                         CAS006
     C                   EVAL      FLIRYUPL = FLIRURPL                                        CAS006
     C                   UPDATE    FRNPVLD0                                                   CAS006
     C                   READ      FRNPVLPD                                                   CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
      ** Forward Rate Agreement using Base Rate                                               CAS006
                                                                                              CAS006
     C                   READ      FRNPVAPD                                                   CAS006
                                                                                              CAS006
     C                   DOW       NOT %EOF(FRNPVAPD)                                         CAS006
     C                   EVAL      FBIRYUPL = FBIRURPL                                        CAS006
     C                   UPDATE    FRNPVAD0                                                   CAS006
     C                   READ      FRNPVAPD                                                   CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CAS003
      *****************************************************************                       CAS003
      *                                                               *                       CAS003
      *  SRFFTrans - Subroutine to update the Unrealized Profit/Loss  *                       CAS003
      *              at Yearend field of FF Transactions File         *                       CAS003
      *                                                               *                       CAS003
      *  Called By:  Main Processing                                  *                       CAS003
      *                                                               *                       CAS003
      *  Calls    :  None                                             *                       CAS003
      *                                                               *                       CAS003
      ****************************************************************                        CAS003
                                                                                              CAS003
     C     SRFFTrans     BEGSR                                                                CAS003
                                                                                              CAS003
     C                   READ      TRANSD                                                     CAS003
                                                                                              CAS003
     C                   DOW       NOT %EOF(TRANSD)                                           CAS003
     C                   EVAL      FSYUPL = FSURPL                                            CAS003
     C                   UPDATE    TRANSDF                                                    CAS003
     C                   READ      TRANSD                                                     CAS003
     C                   ENDDO                                                                CAS003
                                                                                              CAS003
     C                   ENDSR                                                                CAS003
                                                                                              CAS003
      *****************************************************************                       CAS003
      /EJECT                                                                                  CAS003
      *****************************************************************                       CAS003
      *                                                               *                       CAS003
      *  SRFFNPV - Subroutine to update the Unrealized Profit/Loss    *                       CAS003
      *            at Yearend field of Revalued Futures and Options   *                       CAS003
      *            Positions File                                     *                       CAS003
      *                                                               *                       CAS003
      *  Called By:  Main Processing                                  *                       CAS003
      *                                                               *                       CAS003
      *  Calls    :  None                                             *                       CAS003
      *                                                               *                       CAS003
      ****************************************************************                        CAS003
                                                                                              CAS003
     C     SRFFNPV       BEGSR                                                                CAS003
                                                                                              CAS003
     C                   READ      FFNPVLPD                                                   CAS003
                                                                                              CAS003
     C                   DOW       NOT %EOF(FFNPVLPD)                                         CAS003
     C                   EVAL      FFYUPL = FFURPL                                            CAS003
     C                   UPDATE    FFNPVLD0                                                   CAS003
     C                   READ      FFNPVLPD                                                   CAS003
     C                   ENDDO                                                                CAS003
                                                                                              CAS003
     C                   ENDSR                                                                CAS003
                                                                                              CAS003
      *****************************************************************                       CAS003
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSENPV - Subroutine to update the Unrealized Profit/Loss    *
      *            at Yearend field of Revalued Securities Positions  *
      *            File                                               *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
      *                                                               *
      ****************************************************************
 
     C     SRSENPV       BEGSR
 
     C**********         READ      SENPVLPD                                                   CAS006
      **********                                                                              CAS006
     C**********         DOW       NOT %EOF(SENPVLPD)                                         CAS006
     C**********         EVAL      SEYUPL = SEURPL                                            CAS006
     C**********         UPDATE    SENPVLD0                                                   CAS006
     C**********         READ      SENPVLPD                                                   CAS006
     C**********         ENDDO                                                                CAS006
                                                                                              CAS006
      ** Revalued Market Values using All-in-Prices                                           CAS006
                                                                                              CAS006
     C                   READ      SEMKVAPD                                                   CAS006
                                                                                              CAS006
     C                   DOW       NOT %EOF(SEMKVAPD)                                         CAS006
     C                   EVAL      SASAYUPL = SASAURPL                                        CAS006
     C                   UPDATE    SEMKVAD0                                                   CAS006
     C                   READ      SEMKVAPD                                                   CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
      ** Revalued Market Values using Net-Treasury-Prices                                     CAS006
                                                                                              CAS006
     C                   READ      SEMKVLPD                                                   CAS006
                                                                                              CAS006
     C                   DOW       NOT %EOF(SEMKVLPD)                                         CAS006
     C                   EVAL      SLSEYUPL = SLSEURPL                                        CAS006
     C                   UPDATE    SEMKVLD0                                                   CAS006
     C                   READ      SEMKVLPD                                                   CAS006
     C                   ENDDO                                                                CAS006
 
     C                   ENDSR
 
      *****************************************************************                       CAS003
      /EJECT                                                                                  CAS003
      *****************************************************************                       CAS003
      *                                                               *                       CAS003
      * *INZSR - Program Initialisation routine                       *                       CAS003
      *                                                               *                       CAS003
      * Called by: Implicitly on program activation                   *                       CAS003
      *                                                               *                       CAS003
      * Calls: None                                                   *                       CAS003
      *                                                               *                       CAS003
      *****************************************************************                       CAS003
                                                                                              CAS003
     C     *INZSR        BEGSR                                                                CAS003
                                                                                              CAS003
      ** Check if CAS003 is installed                                                         CAS003
                                                                                              CAS003
     C                   EVAL      CAS003 = 'N'                                               CAS003
     C                   CALL      'AOSARDR0'                                                 CAS003
     C                   PARM      *Blanks       PRtCd                                        CAS003
     C                   PARM      '*VERIFY'     POptn                                        CAS003
     C                   PARM      'CAS003'      PSARD                                        CAS003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS003
                                                                                              CAS003
     C                   IF        PRtCd = *Blanks                                            CAS003
     C                   EVAL      CAS003 = 'Y'                                               CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
      ** Database error.                                                                      CAS003
                                                                                              CAS003
     C                   IF        PRtCd <> *BLANKS  AND                                      CAS003
     C                             PRtCd <> '*NRF   '                                         CAS003
     C                   EVAL      DBKEY = PSARD                                              CAS003
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS003
     C                   EVAL      DBASE  =  001                                              CAS003
     C                   EXSR      *PSSR                                                      CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS004
      ** Check if CAS004 is installed                                                         CAS004
                                                                                              CAS004
     C                   EVAL      CAS004 = 'N'                                               CAS004
     C                   CALL      'AOSARDR0'                                                 CAS004
     C                   PARM      *Blanks       PRtCd                                        CAS004
     C                   PARM      '*VERIFY'     POptn                                        CAS004
     C                   PARM      'CAS004'      PSARD                                        CAS004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS004
                                                                                              CAS004
     C                   IF        PRtCd = *Blanks                                            CAS004
     C                   EVAL      CAS004 = 'Y'                                               CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Database error.                                                                      CAS004
                                                                                              CAS004
     C                   IF        PRtCd <> *BLANKS  AND                                      CAS004
     C                             PRtCd <> '*NRF   '                                         CAS004
     C                   EVAL      DBKEY = PSARD                                              CAS004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS004
     C                   EVAL      DBASE  =  002                                              CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS003
     C                   ENDSR                                                                CAS003
                                                                                              CAS003
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************

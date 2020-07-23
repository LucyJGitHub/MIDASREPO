     H*********** Y                                                                           CDL006
     H DEBUG DFTNAME(CDL006) DATEDIT(*YMD)
      *****************************************************************
/*OVR *  OVRDBF FILE(GPCSTXL1) TOFILE(GPCUSTXL1)                      *                       CGP001
/*OVR *  OVRDBF FILE(SDFCTLL0) TOFILE(SDFCTLL0)                      *                       CER073D
/*OVR *  OVRDBF FILE(SDBANKL1) TOFILE(SDBANKL1)                      *                       CER073D
/*S*D****RPGBASE*******************************************************                      CER073D
/*STD *  RPGBASEBND                                                   *                      CER073D
/*EXI *  ALWNULL(*USRCTL)                                             *                      CER073D
/*EXI *  TEXT('Midas SD Customers report')                            *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Standing Data Module
     F*                                                               *
     F*  SD0010P - CLIENT REPORT                                      *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER076             Date 22Jul20               *
      *  Prev Amend No. EML103             Date 19Feb20               *
      *                 CER073D            Date 28Nov19               *
      *                 CER050             Date 16Jun19               *
      *                 MD050212           Date 02Apr18               *
      *                 CGL177             Date 11Jan16               *
      *                 MD046248           Date 05Feb18               *
      *                 MD049187           Date 04Jan18               *
      *                 CER073C            Date 09Oct17               *
      *                 CER073A            Date 05Sep17               *
      *                 CER073             Date 10Jul17               *
      *                 CSW216             Date 14Mar16               *
      *                 CER071             Date 01Aug16               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 CER070             Date 19Aug14               *
      *                 CSW214             Date 25Nov14               *
      *                 MD025682           Date 19Aug14               *
      *                 CGL132             Date 01May13               *
      *                 CSW213             Date 03Jun13               *
      *                 CLE134             Date 01Aug12               *
      *                 AR787620           Date 10Jun11               *
      *                 AR740375           Date 02Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 262205             Date 20Nov09               *
      *                 262064             Date 30Oct09               *
      *                 CER045             Date 20Jul09               *
      *                 BUG23640           Date 15May09               *
      *                 BUG24052           Date 20May09               *
      *                 CER054             Date 07Apr09               *
      *                 CER034A            Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14933           Date 02Oct07               *
      *                 CSW207             Date 09Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240753             Date 06Jun06               *
      *                 CSD027A            Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CSD029             Date 22Aug05               *
      *                 236137             Date 21Sep05               *
      *                 235201             Date 02Aug05               *
      *                 232543             Date 01Apr05               *
      *                 CGL032             Date 05Jul04               *
      *                 CSD025A            Date 27Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CFX001             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001             Date 10Mar04               *
      *                 CGL018             Date 30Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW024             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 151482             Date 12Jan99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 168603             Date 07Jan00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 113339             Date 22Jul99               *
      *                 CEU014             Date 28Apr98               *
     F*                 099441             DATE 19AUG97               *
     F*                 CDL002             DATE 17MAR97               *
     F*                 S01408             DATE 17SEP96               *
     F*                 S01408             DATE 02SEP96               *
     F*                 S01408             DATE 29MAY96               *
     F*                 S01408             DATE 09FEB96               *
     F*                 S01408             DATE 06FEB96               *
     F*                 095938             DATE 17JAN96               *
     F*                 S01408             DATE 13DEC95               *
     F*                 S01408             DATE 07SEP95               *
     F*                 076824             DATE 07OCT94               *
     F*                 S01413             DATE 13APR93               *
     F*                 065369             DATE 07FEB94               *
     F*                 S01421             DATE 12JUL93               *
     F*                 S01383             DATE 12JUN92               *
     F*                 S01310             DATE 31MAY91               *
     F*                 LN1104             DATE 15FEB91               *
     F*                 S01267             DATE 17JAN91               *
     F*                 BHF950             DATE 14DEC90               *
     F*                 BHF399             DATE 15AUG90               *
     F*                 S01212             DATE 08AUG90               *
     F*                 BHF331             DATE 06AUG90               *
     F*                 LN0562             DATE 26JUL90               *
     F*                 LN0502             DATE 25JUL90               *
     F*                 LN0536             DATE 18JUL90               *
     F*                 LN0168             DATE 26JUN90               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  CER076   - Update to KWG § 24c interface specification       *
      *             (BaFin version 3.3)                               *
      *  EML103 - Upgrade EMP001 to FB Midas SP2.1                    *
      *           Additional Fields on customer details.              *
      *           Existing /COPY members used:                        *
      *           SD0010PFP1                                          *
      *           SD0010PC05                                          *
      *           SD0010PC07                                          *
      *           SD0010PC34                                          *
      *  CER073D - Upgrade of EML014 to FB2.1 SP21                    *
      *      EML014 - AnaCredit Reporting Enhancement                 *
      *  CER050 - Annualised Percentage Rate                          *
      *  MD050212 - Replication processing for SDCUSTXC (Recompile)   *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD049187 - AnaCredit fields were introduced to printer file  *
      *             on record format with dependency                  *
      *  CER073C - CER073 Change Control 3 (Recompile)                *
      *  CER073A - CER073 Change Control 1                            *
      *  CER073 - AnaCredit Reporting                                 *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CER071 - BAIS - Legal Form field                             *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *           Recompiled over changes in /COPY                    *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  MD025682 - Correct SDCUSTPD trailer failure in COB.          *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR740375 - State code value in report SD0010PM does not      *
      *             match the value in CUSD (Child: AR740376)         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  262205 - Report SD0010PM contains a lot of useless pages.    *
      *           Do not print header when "Client Report request is  *
      *           Audit and Last Change Date is not equal to Rundate".*
      *  262064 - Overwriting of Market Centre and Investment Company *
      *           Identification. Add SPACEB(1) after Market Centre.  *
      *           Recompiled due to changes in SD0010PM printer file. *
      *  CER045 - German Features - Reporting Bundesbank              *
      *  BUG23640 - Labels were amended for clarity   (Recompile)     *
      *  BUG24052 - Religious Affiliation Narrative is incorrect for  *
      *             'NONE' code.                                      *
      *  CER054 - German Features - Church Tax                        *
      *  CER034A - LF046 German Features - New Fields and Enquiries   *
      *  BUG14933 - Error in checking switchable feature CSW207       *
      *  CSD079 - Enhanced Customer Maintenance API (Recompile)       *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  240753 - Recompiled due to changes in SD0010PM               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSD029 - Customer Details Additional Fields                  *
      *  236137 - Change Control for CGL031                           *
      *  235201 - Show only customers whose record was changed.       *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information                   *
      *  CSD025A- Inactive status                                     *
      *  CSW037A- Additional Field extended to 40 chars               *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CFX001 - FX Margin Trading                                   *
      *  CLE025 - Credit Lines                                        *
      *  CGP001 - Global Processing.                                  *
      *  CGL018 - Risk Weighted Assets                                *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *  CRE007 - Base Rate Tax 2001.                                 *
      *  CSD007 - Customer Closing: new Closure Status fields         *
      *  CDL008 - Continuous Linked Settlement                        *
      *  151482 - Use correct CHips ABA field BBABA2                  *
      *  168603 - For E5BRT1 should treat '000000' as *blanks.        *
      *  CDL006 - Dealing Fiduciary.                                  *
     F*  113339 - Date of birth could be before 01-01-72, thus add    *
     F*           field to retrieve full date.                        *
     F*  CEU014 - EMU User Defined Correspondence Changes:            *
     F*           addition of 'Designated In Currency' field.         *
     F*  099441 - Addition of 'SWIFT Financial Institution' flag.     *
     F*  CDL002 - FX Netting                                          *
     F*  S01408 - Hook SD0010PC25 added.                              *
     F*  S01408 - Hook SD0010PC24 added.                              *
     F*         - Hook SD0010PIP1 added.                              *
     F*  S01408 - Hook SD0010PC23 added.                              *
     F*           Hook SD0010PC22 added.                              *
     F*  S01408 - Hook SD0010PFP2 added.                              *
     F*           Hook SD0010PFP3 added.                              *
     F*           Hook SD0010PFP4 added.                              *
     F*           Hook SD0010PCP9 added.                              *
     F*           Hook SD0010PC10 added.                              *
     F*           Hook SD0010PC11 added.                              *
     F*           Hook SD0010PC12 added.                              *
     F*           Hook SD0010PC13 added.                              *
     F*           Hook SD0010PC14 added.                              *
     F*           Hook SD0010PC15 added.                              *
     F*           Hook SD0010PC16 added.                              *
     F*           Hook SD0010PC17 added.                              *
     F*           Hook SD0010PC18 added.                              *
     F*           Hook SD0010PC19 added.                              *
     F*           Hook SD0010PC20 added.                              *
     F*           Hook SD0010PC21 added.                              *
     F*  S01408 - Hook SD0010PCP7 added.                              *
     F*           Hook SD0010PCP8 added.                              *
     F*           Hook SD0010PFP1 added.                              *
     F*  095938 - Do not print additional details if cust. not changed*
     F*           today                                               *
     F*  S01408 - Hook SD0010PCP6 added.                              *
     F*  S01408 - Hook SD0010PCP1 added.                              *
     F*           Hook SD0010PCP2 added.                              *
     F*           Hook SD0010PCP3 added.                              *
     F*           Hook SD0010PCP4 added.                              *
     F*           Hook SD0010PCP5 added.                              *
     F*  076824 - IF THERE ONLY ADDITIONAL CUSTOMER DETAILS TO REPORT *
     F*           IN AUDIT MODE, DETAILS ARE PRECEDED BY A HEADED     *
     F*           PAGE WITH NO DETAILS.                               *
     F*           DO NOT PRINT 'NO DETAILS TO REPORT' AFTER PRINTING  *
     F*           ADDITIONAL DETAILS ONLY.                            *
     F*  S01413 - Retail 3 development.                               *
     F*  065369 - Recompiled for new fields (title) on printout.      *
     F*  S01421 - BLI STEP 1 DEVELOPMENT-                             *
     F*           Switchable features S01424 and S01425 are checked   *
     F*           for.If S01424 is present a new field is added to    *
     F*           Client Details Listing (XRCEAD) with text:'Customer *
     F*           Eligible for Automatic Deletion'.If S01425 is       *
     F*           present, then a new format is printed (ADCUDT)-     *
     F*           additional Customer Details.Details will be printed *
     F*           if a record is found.                               *
     F*  S01383 - Basic Rate Tax Incorporation. Print A/c Holder data.*
     F*  S01310 - SWIFT Rationalisation.                              *
     F*  LN1104 - Recompiled owing to change to SDCUSTPD.             *
     F*  S01267 - Customer Risk Weighting Code added.                 *
     F*  BHF950 - ENSURE THAT THE CALCULATED NO OF RECORDS IS ONLY    *
     F*           BASED ON THE LIVE CLIENTS ON THE FILE.              *
     F*  BHF399 - PASS SD0010AU TO SDC540P INSTEAD OF PROGRAM NAME.   *
     F*  S01212 - /COPY PROCESSING ADDED.                             *
     F*  BHF331 - REPORT LAYOUT REDESIGNED.                           *
     F*  LN0562 - ZEROS ARE NOW SUPPRESSED ON THE REPORT AND THE      *
     F*           DATES ARE DISPLAYED AS 7 CHARACTER ALPHANUMERICS.   *
     F*  LN0502 - RECOMPILE PROGRAM DUE TO CHANGE IN PRINTER FILE.    *
     F*  LN0536 - SET UP TITLE CORRECTLY.                             *
     F*  LN0168 - SET SCAN LIMIT TO 99999.                            *
     F*                                                               *
     F*****************************************************************
     F/COPY WNCPYSRC,SD0010PFPG
      *                                                                                      LLN022A
     FBYCUSTY0  IF   E           K DISK                                                            L
      *                                                                                      LLN022A
      ** Bank of England Customer details - retrieval                                        LLN022A
      *                                                                                      LLN022A
     FSDCUX2L0  IF   E           K DISK
      * RTV: Customer Details Ext.  file for European Reporting - Luxemb.                     CER001
     FSDCUSTL1  IF   E           K DISK
     F*
      * RTV: Customer Details (SWIFT)                                                         CSW207
     FSDCSSWL1  IF   E           K DISK
     F*                                                                                       CSW207
      * RTV: Customer Details (Ext - C)                                                       CGL132
     FSDCUSXL1  IF   E           K DISK
      *                                                                                       CGL132
      * RTV: Midas SD CRS Customer Country Details                                            CGL177
     FSDCRSDL2  IF   E           K DISK
     FSDCRSDL0  IF   E           K DISK
     F                                     RENAME(SDCRSDD0:SDCRSDD1)
      *                                                                                       CGL177
     F/COPY WNCPYSRC,SD0010PFP2
     F*
      * RTV: Client Details            Retrieval index
      *
     FSDCBRTL1  IF   E           K DISK                                         S01383
     FSDFCTLL1  IF   E           K DISK
      * RTV: Standing Data Controls    Retrieval index
      *
     F/COPY WNCPYSRC,SDH00577
     F***SDBANKL1  IF   E           K DISK                                                   CER073D
     FSDBANKL1  IF   E           K DISK    USROPN                                            CER073D
      * RTV: Bank Details              Retrieval index
      *                                                                   S01421
     F/COPY WNCPYSRC,SD0010PF01
     FSDACUSL1  IF   E           K DISK                                         S01421
      * Additional Cust Details        Retrieval index                    S01421
      *
     FSDANACI1  IF   E           K DISK
      * AnaCredit Reporting            Retrieval index                                        CER073
      *                                                                                       CER076
     FSDACUSY0  IF   E           K DISK    INFSR(*PSSR)                                       CER076
     F                                     USROPN                                             CER076
      * Additional customer details extension                                                 CER076
      *
     F*
     F/COPY WNCPYSRC,SD0010PFP1
     F*
     F***SDFCTLL0  UF   E           K DISK                                                   CER073D
     FSDFCTLL0  UF   E           K DISK    USROPN                                            CER073D
      * UPD: Standing Data Controls    Update index
      *
     FSDCRWAL0  IF   E           K DISK                                         CGL018
      * RTW: Customer Risk Weigted Assets Code/Set                        CGL018
      *                                                                   CGL018
     F*
     F/COPY WNCPYSRC,SD0010PFP3
     F*
     FSD0010PM  O    E             PRINTER OFLIND(*IN97)
     F                                     INFDS(INFDS$)
      *                                                                                       CGL032
     FSDACTXL1  IF   E           K DISK
      ** RTV: Customer Details          Retrieval index                                       CGL032
     F*
     F/COPY WNCPYSRC,SD0010PFP4
     F*
      * PRT: Midas SD Client report
      *
     FGPCSTXL1  IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     F                                     RENAME(GPCUSTXD0:GPCSTXD0)
      ** Midas GP Global Customers X-Reference                                                CGP001
      *                                                                                       CGP001
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D UAR             S              1    DIM(53)
     D ULN             S              1    DIM(53)
     D UARRAY          S             26    DIM(2) CTDATA PERRCD(1)
      *
      ** SAVE INDICATOR *IN 99
      *
     D/COPY WNCPYSRC,SD0010PEPG
     D BLC             S            132    DIM(5)
      * IBLC 2002 Extended informations array                                                 CER001
     D********************@CN     1  14 25               Long constants.  CSD007
     D*****               @CN     1  17 25               Long constants.  CSD007CSD025A
     D @CN             S             25    DIM(18) CTDATA PERRCD(1)             Long constants.  CSD
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY 113
     D TABM            S              3    DIM(12) CTDATA PERRCD(12)
     D TABD            S              2    DIM(12) ALT(TABM)
     D XRWA            S              5    DIM(90)                              Work Array       CGL
     D OVRC            S             80    DIM(1) CTDATA PERRCD(1)
      *                                                                                      LLN022A
     D                 DS                                                                          L
      *                                                                                      LLN022A
      ** BOE fields                                                                          LLN022A
      *                                                                                      LLN022A
     D  UFLD1                  1    131                                                            L
     D  SIO                    1      8    INZ('SIO Ind:')                                         L
     D  ULSIOF                10     10                                                            L
     D  HAIN                  15     22    INZ('H/A Ind:')                                         L
     D  ULHAIN                24     24                                                            L
     D  ULTP                  29     36    INZ('Ult Par:')                                         L
     D  ULULPA                38     43                                                            L
     D  EGFL                  48     55    INZ('Eg.Flag:')                                         L
     D  ULEGFL                57     57                                                            L
     D  LINC                  61     75    INZ('BoE Inst. Code:')                                  L
     D  ULLINC                77     78                                                            L
     D  LICD                  81     94    INZ('BoE Ind. Code:')                                   L
     D  ULLICD                96     98                                                            L
     D  CNTP1                105    114    INZ('Connected ')                                       L
     D  CNTP2                115    127    INZ('Counterparty:')                                    L
     D  LCNTP                129    129                                                            L
      *                                                                                      LLN022A
     D IBFROM          DS
      * Extended informations from IBLC 2002                                                  CER001
     D  IBFRO1                 1    132
     D  IBFRO2               133    264
     D  IBFRO3               265    396
     D  IBFRO4               397    528
     D  IBFRO5               529    660
      /EJECT
      * Data structures:-
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure.
     D/COPY WNCPYSRC,SD0010PI01
     D JBDTTM          DS
      * Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS$        E DS                  EXTNAME(Y2I$DSP)
      * Printer file information data structure.
      *
     D RUNDAT          DS
     D  MRDT                   1      7
     D  MRDD                   1      2  0
     D  MRMM                   3      5
     D  MRYY                   6      7  0
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *                                                                                       262205
     D RNDATE          DS
     D  RNDT                   1      6  0
     D  RNDY                   1      2  0
     D  RNMN                   3      4  0
     D  RNYY                   5      6  0
      *                                                                                       262205
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     array
      /EJECT
      * Parameter declarations.
     D/COPY WNCPYSRC,SD0010PI02
     D P1PARM          DS
      * I:    Audit/Request Status Ind
     D  P1ARSI                 1      1
     D P2PARM          DS
      * I:    RCF sequence number
     D  P2RSQN                 1      5
     D P3PARM          DS
      * I:    Level
     D  P3LEVL                 1      1
     D P4PARM          DS
      * I:    Entity
     D  P4ENTY                 1      3
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0001                 1     10
      *                                                                   S10408
     D/COPY WNCPYSRC,SD0010PIP1                                           S10408
      *                                                                   S10408
     D LDA           EUDS           256    EXTNAME(LDA)                         CDL006
      ** Local data area for database error details                       CDL006
      *                                                                   CDL006
     D  DBLOT                134    183                                         CDL006
     D*                                                                   S01413
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL002
     D** MIDAS Switchable Features Accessed Via Access Program            CDL002
     D*                                                                   CDL002
     D** Data structure for SDMMOD access object                          S01413
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    S01413
      *                                                                                       CGL032
      ** External data structure for Bank details                                             CGL032
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *                                                                                       CGL032
      ** External data structure for Country Details                                          CGL032
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *                                                                                       CER054
      ** External data structure for Federal State Codes                                      CER054
     D SDSTCD        E DS                  EXTNAME(SDGESTPD)
      *                                                                                       CER054
      ** External data structure for Religious Affiliation Codes                              CER054
     D SDRLAF        E DS                  EXTNAME(SDRLAFPD)
     D*                                                                   S01413
     D** Short Data Structure for Access Objects                          S01413
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01413
     D                 DS                                                       113339
     D  E5BRT1                 1      6                                         113339
     D  WWBDAY                 1      2                                         113339
     D  WWBMNT                 3      4  0                                      113339
     D  WWBYR                  5      6                                         113339
     D                 DS                                                       113339
     D  WWBDY1                 1      2                                         113339
     D  WWBMT1                 3      5                                         113339
     D  WWBYR1                 6      7                                         113339
     D  WWBRT1                 1      7                                         113339
      * Datastructure to output RWA details                               CGL018
      *                                                                   CGL018
     D RWSECO          DS             5    OCCURS(1)                            CGL018
     D  #RCODE                 1      2                                         CGL018
     D  #BLANK                 3      3    INZ(' ')                             CGL018
     D  #RSET                  4      4                                         CGL018
     D  #COMMA                 5      5    INZ(',')                             CGL018
      *                                                                   CGL018
     D @VAL01          C                   CONST('AddCustDtlFl01')
     D @VAL02          C                   CONST('AddCustDtlFl02')
     D @VAL03          C                   CONST('AddCustDtlFl03')
     D @VAL04          C                   CONST('AddCustDtlFl04')
     D @VAL05          C                   CONST('AddCustDtlFl05')
     D @VAL06          C                   CONST('AddCustDtlFl06')
     D @VAL07          C                   CONST('AddCustDtlFl07')
     D @VAL08          C                   CONST('AddCustDtlFl08')
     D @VAL09          C                   CONST('AddCustDtlFl09')
     D @VAL10          C                   CONST('AddCustDtlFl10')
      * First name DS                                                                        CER073D
     D RFNAME          DS                                                                          C
     D  R2FNM1                 1    118                                                            C
     D  R2FNM2               119    247                                                            C
     D  R2FNM3               248    376                                                            C
     D  R2FNM4               377    505                                                            C
      * Last name DS                                                                         CER073D
     D RLNAME          DS                                                                          C
     D  R2LNM1                 1    118                                                            C
     D  R2LNM2               119    247                                                            C
     D  R2LNM3               248    376                                                            C
     D  R2LNM4               377    505                                                            C
      * Street DS                                                                            CER073D
     D RSTRET          DS                                                                          C
     D  R2STR1                 1    117                                                            C
     D  R2STR2               118    245                                                            C
      * Town DS                                                                              CER073D
     D RTOWN           DS                                                                          C
     D  R2TWN1                 1    117                                                            C
     D  R2TWN2               118    245                                                            C
      * Town DS                                                                              CER073D
     D RLEGF           DS                                                                          C
     D  R2LGF1                 1     75                                                            C
     D  R2LGF2                76    150                                                            C
     D  R2LGF3               151    225                                                            C
     D/COPY WNCPYSRC,SDH00087
      *                                                                   CDL006
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CDL006
      *                                                                                      CER073D
     ISDANACD0                                                                                     C
     I              ACFNAMQQ                    XACFNA                                             C
     I              ACLNAMQQ                    XCLNAA                                             C
     I              ACSTRTQQ                    XCSTRA                                             C
     I              ACNUMBQQ                    XCNUMA                                             C
     I              ACTOWNQQ                    XCTOWA                                             C
     I              ACPOSTQQ                    XCPOSA                                             C
     I              ACLEGFQQ                    XCLEGA                                             C
      ** ** Midas SD AnaCredit File DS                                                       CER073D
      ** Override Command Array                                                               CGP001
      *                                                                                       CGP001
     I*
     I* Description     : Copyright notice for inclusion in all programs
     I*
     I*00/Copy Member SD0010P   Initialise Program I-Spec
     I/COPY WNCPYSRC,SD0010PIPG
      ** Second DS for access programs, long data structure               CDL006
      *                                                                   CDL006
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C/COPY WNCPYSRC,SD0010PC37
     C                   PARM                    P0RTN             7            Return code
     C/COPY WNCPYSRC,SD0010PC38
     C     P1ARSI        PARM                    WP0001            1            Audit/Request S
     C     P2RSQN        PARM                    WP0002            5            RCF sequence nu
     C     P3LEVL        PARM                    WP0003            1            Level
     C     P4ENTY        PARM                    WP0004            3            Entity
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *                                                                                       CSW207
     C                   MOVE      '0'           *IN88
     C     CSW207        IFEQ      'Y'
     C     BGN4ST        OREQ      'Y'
     C                   MOVE      '1'           *IN88
     C                   ENDIF
      *                                                                                       CSW207
     C*                                                                   S01408
     C/COPY WNCPYSRC,SD0010PCP8                                           S01408
     C*                                                                   S01408
      *
      * Clear overflow indicator.
     C                   SETOFF                                       97
     C*
     C/COPY WNCPYSRC,SD0010PC19
     C*
      * Establish starting position.
     C     *LOVAL        SETLL     @BBREBF                                      *
     C*
     C/COPY WNCPYSRC,SD0010PCP9
     C*
      * Read first record with user selection.
     C                   EXSR      GARDRC
     C*
     C/COPY WNCPYSRC,SD0010PC10
     C*
      * Print null report headings.
     C     W0EOF         IFEQ      '1'
     C                   WRITE     ZZPAGHDR
      * USER: Null report processing
      *CASE:     WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 00/Copy Member SD0010PNRP - Client Details  *
     C*00/Copy Member SD0010P   Null Report Processing
     C/COPY WNCPYSRC,SD0010PNRP
     C                   END                                                    *FI
     C                   WRITE     ZZENDRPT
     C*                                                                   S01421
     C                   ELSE
      * Request all headings.
     C                   MOVEL     'Y'           L0                1            Page headings
      * Initialise final totals.
     C                   MOVEL     *BLANK        ZTCON                          *CON (Screen co
     C                   Z-ADD     *ZERO         ZTNCRC                         No of Calculate
      *                                                                                       262205
     C                   Z-ADD     *ZERO         RNDT
      *                                                                                       262205
     C     MRMM          LOOKUP    TABM          TABD                     19
     C                   MOVE      TABD          RNMN
     C                   Z-ADD     MRDD          RNDY
     C                   Z-ADD     MRYY          RNYY
      *                                                                                       262205
      * Print report body.
     C     W0EOF         DOWEQ     '0'
      *                                                                                       262205
     C                   Z-ADD     *ZERO         #NLCD
      *                                                                                       262205
      *                                                                                       262205
     C                   CALL      'ZDATE2'
     C                   PARM                    BBLCD
     C                   PARM                    BJDFIN
     C                   PARM                    #NLCD             6 0
     C                   PARM                    ZADATE
      *                                                                                       262205
     C     WP0001        IFNE      'A'
     C     WP0001        OREQ      'A'
     C     #NLCD         ANDEQ     RNDT
      * Print headings.
     C                   EXSR      BAPRHD
     C                   ENDIF
      * Print report detail line.
     C                   EXSR      CAPRDT
     C*                                                                   S01421
     C* Sub Routine to write Additional Customer Details if feature       S01421
     C* S10425 is installed.                                              S01421
     C*                                                                   S01421
     C     *IN23         IFEQ      *ON                                                         S0142
     C     W0PFM         ANDEQ     'Y'                                                         09593
     C     CDL006        OREQ      'Y'                                                         CDL00
     C     W0PFM         ANDEQ     'Y'
     C                   EXSR      ACDTSR                                                      S0142
     C                   END                                                                   S0142
     C*                                                                   S01421
     C     CGL032        IFEQ      'Y'
     C     W0PFM         ANDEQ     'Y'
     C                   EXSR      SRETAX
     C                   ENDIF
      *                                                                                       CGL032
     C     CER073        IFEQ      'Y'
     C     W0PFM         ANDEQ     'Y'
     C                   EXSR      SRANAC
      *                                                                                     MD049187
      ** CHECK FOR OVErFlOW, PRINT HEADER IF SO.                                            MD049187
      *                                                                                     MD049187
     C     W0OFL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      @$HDL
     C                   WRITE     ZZPAGHDR
     C                   ENDIF
     C                   WRITE     ZZANADTL
     C                   ENDIF
     C/COPY WNCPYSRC,SD0010PC34
      * Hold current values.
      * Read next record with user selection.
     C                   EXSR      GARDRC
      * Determine level changes.
     C                   EXSR      DALVCH
      * Print totals.
     C/COPY WNCPYSRC,SDH00088
     C                   EXSR      EAPRTT
     C/COPY WNCPYSRC,SDH00089
      * Process necessary heading requests
     C                   EXSR      FASGHD
     C*
     C/COPY WNCPYSRC,SD0010PC11
     C*
     C                   END
     C*
     C/COPY WNCPYSRC,SD0010PC12
     C*
     C                   WRITE     ZZENDRPT
     C                   END
      * Exit program.
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
     C*
     C/COPY WNCPYSRC,SD0010PC13
     C*
      *****************************************************************
      /EJECT
     CSR   BAPRHD        BEGSR
      *================================================================
      * Print report Headers.
      *================================================================
     C     L0            IFEQ      'Y'
     C                   WRITE     ZZPAGHDR
     C                   END
      *
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT                                                                                  CGL032
     CSR   SRETAX        BEGSR
      *================================================================                       CGL032
      * Print additional information of customer                                              CGL032
      *================================================================                       CGL032
      *                                                                                       CGL032
      ** Check if there are more additional information for the customer.                     CGL032
      *                                                                                       CGL032
     C     XRCUST        CHAIN     SDACUSL1                           02
      *                                                                                       CGL032
     C     *IN02         IFEQ      *OFF
     C                   MOVE      E5TINO        R2TINO
     C                   MOVE      E5IDTP        R2IDTP
     C                   MOVE      E5ISCT        R2ISCT
     C                   MOVE      E5BTHC        R2BTHC
     C                   MOVE      E5BTHT        R2BTHT
     C                   MOVE      E5JATP        R2JATP
      *                                                                                       CGL032
      ** Alternative TINs                                                                     CGL132
     C                   MOVE      E5TIN2        R2TIN2
     C                   MOVE      E5TNC2        R2TNC2
     C                   MOVE      E5TIN3        R2TIN3
     C                   MOVE      E5TNC3        R2TNC3
     C                   MOVE      E5TIN4        R2TIN4
     C                   MOVE      E5TNC4        R2TNC4
     C                   MOVE      E5TIN5        R2TIN5
     C                   MOVE      E5TNC5        R2TNC5
      *                                                                                       CGL132
     C     CGL157        IFEQ      'N'
      *                                                                                       CGL177
     C                   MOVEL     BBCOLC        R2TNC1
      *                                                                                       CGL177
      ** Additional TINs                                                                      CGL177
     C                   MOVE      E5TIN6        R2TIN6
     C                   MOVE      E5TNC6        R2TNC6
     C                   MOVE      E5TIN7        R2TIN7
     C                   MOVE      E5TNC7        R2TNC7
     C                   MOVE      E5TIN8        R2TIN8
     C                   MOVE      E5TNC8        R2TNC8
     C                   MOVE      E5TIN9        R2TIN9
     C                   MOVE      E5TNC9        R2TNC9
     C                   MOVE      E5TIN0        R2TIN0
     C                   MOVE      E5TNC0        R2TNC0
      *                                                                                       CGL177
     C                   ENDIF
      *                                                                                       CGL177
      ** Mailing Country and Phone No. Country                                                CGL177
     C                   MOVE      E5CTR1        R2CTR1
     C                   MOVE      E5CTR2        R2CTR2
     C                   MOVE      E5CTR3        R2CTR3
     C                   MOVE      E5CTR4        R2CTR4
     C                   MOVE      E5CTR5        R2CTR5
     C                   MOVE      E5PHN1        R2PHN1
     C                   MOVE      E5PHN2        R2PHN2
     C                   MOVE      E5PHN3        R2PHN3
     C                   MOVE      E5PHN4        R2PHN4
     C                   MOVE      E5PHN5        R2PHN5
      *                                                                                       CGL177
     C     CGL157        IFEQ      'Y'
      *                                                                                       CGL157
      ** Additional TINs when CRS is ON, initialize fields                                    CGL177
      *                                                                                       CGL177
     C                   Z-ADD     *ZERO         CRSCTR            5 0
      *                                                                                       CGL177
     C                   MOVE      *BLANKS       R2TINO
     C                   MOVE      *BLANKS       R2TNC1
     C                   MOVE      *BLANKS       R2TIN2
     C                   MOVE      *BLANKS       R2TNC2
     C                   MOVE      *BLANKS       R2TIN3
     C                   MOVE      *BLANKS       R2TNC3
     C                   MOVE      *BLANKS       R2TIN4
     C                   MOVE      *BLANKS       R2TNC4
     C                   MOVE      *BLANKS       R2TIN5
     C                   MOVE      *BLANKS       R2TNC5
     C                   MOVE      *BLANKS       R2TIN6
     C                   MOVE      *BLANKS       R2TNC6
     C                   MOVE      *BLANKS       R2TIN7
     C                   MOVE      *BLANKS       R2TNC7
     C                   MOVE      *BLANKS       R2TIN8
     C                   MOVE      *BLANKS       R2TNC8
     C                   MOVE      *BLANKS       R2TIN9
     C                   MOVE      *BLANKS       R2TNC9
     C                   MOVE      *BLANKS       R2TIN0
     C                   MOVE      *BLANKS       R2TNC0
      *                                                                                       CGL177
     C                   MOVE      *BLANKS       KDCUST            6
     C                   MOVE      *BLANKS       KDCTRY            2
     C                   MOVE      BBCUST        KDCUST
     C                   MOVE      BBCOLC        KDCTRY
     C     KCRSD         KLIST
     C                   KFLD                    KDCUST
     C                   KFLD                    KDCTRY
      *                                                                                       CGL177
     C     KCRSD         CHAIN     SDCRSDD1                           02
     C     *IN02         IFEQ      *OFF
     C                   MOVE      CDTINN        R2TINO
     C                   MOVE      CDCTRY        R2TNC1
     C                   ENDIF
      *                                                                                       CGL177
      ** Read through CRS Customer Country Detail File - Detail                               CGL177
      *                                                                                       CGL177
     C     XRCUST        SETLL     SDCRSDD0
     C     XRCUST        READE     SDCRSDD0                               03
      *                                                                                       CGL177
     C     *IN03         DOWEQ     *OFF
     C     CRSCTR        ANDLE     9
     C     XRCUST        ANDEQ     CDCUST
      *                                                                                       CGL177
     C     BBCOLC        IFNE      CDCTRY
     C                   ADD       1             CRSCTR
      *                                                                                       CGL177
     C     CRSCTR        IFEQ      1
     C                   MOVE      CDTINN        R2TIN2
     C                   MOVE      CDCTRY        R2TNC2
     C                   ENDIF
     C     CRSCTR        IFEQ      2
     C                   MOVE      CDTINN        R2TIN3
     C                   MOVE      CDCTRY        R2TNC3
     C                   ENDIF
     C     CRSCTR        IFEQ      3
     C                   MOVE      CDTINN        R2TIN4
     C                   MOVE      CDCTRY        R2TNC4
     C                   ENDIF
     C     CRSCTR        IFEQ      4
     C                   MOVE      CDTINN        R2TIN5
     C                   MOVE      CDCTRY        R2TNC5
     C                   ENDIF
     C     CRSCTR        IFEQ      5
     C                   MOVE      CDTINN        R2TIN6
     C                   MOVE      CDCTRY        R2TNC6
     C                   ENDIF
     C     CRSCTR        IFEQ      6
     C                   MOVE      CDTINN        R2TIN7
     C                   MOVE      CDCTRY        R2TNC7
     C                   ENDIF
     C     CRSCTR        IFEQ      7
     C                   MOVE      CDTINN        R2TIN8
     C                   MOVE      CDCTRY        R2TNC8
     C                   ENDIF
     C     CRSCTR        IFEQ      8
     C                   MOVE      CDTINN        R2TIN9
     C                   MOVE      CDCTRY        R2TNC9
     C                   ENDIF
     C     CRSCTR        IFEQ      9
     C                   MOVE      CDTINN        R2TIN0
     C                   MOVE      CDCTRY        R2TNC0
     C                   ENDIF
      *                                                                                       CGL177
     C                   ENDIF
      *                                                                                       CGL177
     C     XRCUST        READE     SDCRSDD0                               03
     C                   ENDDO
     C                   ENDIF
      *                                                                                       CGL177
      * Economic Identification No.                                                           CER076
      *                                                                                       CER076
     C     CER076        IFEQ      'Y'                                                        CER076
     C     SDACUK        KLIST                                                                CER076
     C                   KFLD                    BBCUST                                       CER076
     C     SDACUK        CHAIN     SDACUSY0                           99                      CER076
     C     *IN99         IFEQ      '0'                                                        CER076
     C                   MOVEL     E5EINO        REINO                                        CER076
     C                   ELSE                                                                 CER076
     C                   MOVEL     *BLANK        REINO                                        CER076
     C                   ENDIF                                                                CER076
     C                   ENDIF                                                                CER076
      *                                                                                       CER076
     C**********           Z-ADDE5ISDT    ZDAYNO                                       CGL032 232543
     C     2             SUBST     E5ISDT:7      WDD               2
     C     2             SUBST     E5ISDT:5      WMM               2
     C     2             SUBST     E5ISDT:3      WYY               2
     C     WDD           CAT       WMM           WDM               4
     C     WDM           CAT       WYY           WDMY              6
     C                   MOVE      WDMY          DATEIN
      *                                                                                       232543
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR              7
     C                   PARM                    DATEIN            6 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO
      *                                                                                       232543
     C     ZERR          IFNE      *BLANKS
     C                   MOVE      *BLANKS       R2ISDT
     C                   ELSE
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *                                                                                       CGL032
     C                   MOVE      ZADATE        R2ISDT
     C                   ENDIF
      *                                                                                       232543
     C     CER047        IFEQ      'Y'
     C     CER048        OREQ      'Y'
      *                                                                                      CER034A
      ** Title                                                                               CER034A
      *                                                                                      CER034A
     C                   MOVE      E5TITL        R2TITL
      *                                                                                      CER034A
      ** Maiden Name                                                                         CER034A
      *                                                                                      CER034A
     C                   MOVE      E5MDNM        R2MDNM
      *                                                                                      CER034A
      ** Identification Document/Id                                                          CER034A
      *                                                                                      CER034A
     C                   MOVE      E5DCID        R2DCID
      *                                                                                      CER034A
      ** Identification Document/Id Issued Place                                             CER034A
      *                                                                                      CER034A
     C                   MOVE      E5DIPL        R2DIPL
      *                                                                                      CER034A
     C                   ENDIF
      *                                                                                      CER034A
     C     CER047        IFEQ      'Y'
      *                                                                                      CER034A
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *                                                                                      CER034A
      ** Expiry Date                                                                         CER034A
      *                                                                                      CER034A
     C     E5EXDT        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       R2EXDT
      *                                                                                      CER034A
     C                   ELSE
     C                   MOVE      E5EXDT        ZDAYNO
      *                                                                                      CER034A
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *                                                                                      CER034A
     C                   MOVE      ZADATE        R2EXDT
      *                                                                                      CER034A
     C                   ENDIF
      *                                                                                      CER034A
      ** Subject to 24C Flag                                                                 CER034A
      *                                                                                      CER034A
     C                   MOVE      E5S24C        R2S24C
      *                                                                                      CER034A
      ** Remarks                                                                             CER034A
      *                                                                                      CER034A
     C                   MOVE      E5REM1        R2REM1
     C                   MOVE      E5REM2        R2REM2
     C                   MOVE      E5REM3        R2REM3
      *                                                                                      CER034A
     C                   ENDIF
      *                                                                                       CER054
     C     CER054        IFEQ      'Y'
      *                                                                                       CER054
      ** State Code                                                                           CER054
      *                                                                                       CER054
     C                   MOVEL     *BLANKS       R2STCD
     C                   MOVEL     *BLANKS       R2STNM
     C     E5STCD        IFNE      *BLANKS
      *                                                                                       CER054
     C                   CALL      'AOSTCDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      E5STCD        PKEY              2
     C     SDSTCD        PARM      SDSTCD        DSFDY
      *                                                                                       CER054
      ** DB Error Management.                                                                 CER054
      *                                                                                       CER054
     C     PRTCD         IFNE      *BLANK
      *                                                                                       CER054
     C     *LOCK         IN        LDA
     C                   Z-ADD     006           DBASE
     C                   MOVEL     'SDSTCDPD'    DBFILE
     C                   MOVEL     POPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      GESTCD        R2STCD
     C                   MOVE      GESTNM        R2STNM
     C                   ENDIF
      *                                                                                       CER054
     C                   ENDIF
      *                                                                                       CER054
      ** Religious Affiliation Code                                                           CER054
      *                                                                                       CER054
     C********** E5RLAF    IFEQ 'NONE'                                               CER054 BUG24052
     C**********           MOVE E5RLAF    R2RLAF                                     CER054 BUG24052
     C**********           ENDIF                                                     CER054 BUG24052
      *                                                                                       CER054
     C                   MOVEL     *BLANKS       R2RLAF
     C                   MOVEL     *BLANKS       R2NARR
     C     E5RLAF        IFNE      *BLANKS
     C********** E5RLAF    ANDNE'NONE'                                               CER054 BUG24052
      *                                                                                       CER054
     C                   CALL      'AORLAFR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      E5RLAF        PKEY2             4
     C     SDRLAF        PARM      SDRLAF        DSFDY
      *                                                                                       CER054
      ** DB Error Management.                                                                 CER054
      *                                                                                       CER054
     C     PRTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     010           DBASE
     C                   MOVEL     'SDRLAFPD'    DBFILE
     C                   MOVEL     POPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      AFRLAF        R2RLAF
     C                   MOVE      AFNARR        R2NARR
     C                   ENDIF
      *                                                                                       CER054
     C                   ENDIF
      *                                                                                       CER054
     C                   ENDIF
      *                                                                                      CER034A
     C     CER048        IFEQ      'Y'
      *                                                                                      CER034A
      ** Spouse Reference                                                                    CER034A
      *                                                                                      CER034A
     C                   MOVE      E5SHRF        R2SHRF
      *                                                                                      CER034A
      ** Partner/Associate Indicator                                                         CER034A
      *                                                                                      CER034A
     C                   MOVE      E5PIND        R2PIND
      *                                                                                      CER034A
      ** Exemption Threshold                                                                 CER034A
      *                                                                                      CER034A
     C                   MOVE      E5EXTH        R2EXTH
      *                                                                                      CER034A
      ** Exemption Threshold Approval Date                                                   CER034A
      *                                                                                      CER034A
     C     E5EADT        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       R2EADT
      *                                                                                      CER034A
     C                   ELSE
     C                   MOVE      E5EADT        ZDAYNO
      *                                                                                      CER034A
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *                                                                                      CER034A
     C                   MOVE      ZADATE        R2EADT
      *                                                                                      CER034A
     C                   ENDIF
      *                                                                                      CER034A
      ** Exemption Threshold Value Date                                                      CER034A
      *                                                                                      CER034A
     C     E5EVDT        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       R2EVDT
      *                                                                                      CER034A
     C                   ELSE
     C                   MOVE      E5EVDT        ZDAYNO
      *                                                                                      CER034A
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *                                                                                      CER034A
     C                   MOVE      ZADATE        R2EVDT
      *                                                                                      CER034A
     C                   ENDIF
      *                                                                                      CER034A
      ** Exemption Threshold Expiry Date                                                     CER034A
      *                                                                                      CER034A
     C     E5ETXT        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       R2ETXT
      *                                                                                      CER034A
     C                   ELSE
     C                   MOVE      E5ETXT        ZDAYNO
      *                                                                                      CER034A
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *                                                                                      CER034A
     C                   MOVE      ZADATE        R2ETXT
      *                                                                                      CER034A
     C                   ENDIF
      *                                                                                      CER034A
      ** Characteristic of Demand/Claim                                                      CER034A
      *                                                                                      CER034A
     C                   MOVE      E5CDCL        R2CDCL
      *                                                                                      CER034A
     C                   ENDIF
      *                                                                                      CER034A
     C     CER034        IFEQ      'Y'
      *                                                                                      CER034A
      ** FX Customer                                                                         CER034A
      *                                                                                      CER034A
     C                   MOVE      E5FXCU        R2FXCU
      *                                                                                      CER034A
      ** Securities Customer                                                                 CER034A
      *                                                                                      CER034A
     C                   MOVE      E5SECU        R2SECU
      *                                                                                      CER034A
      ** Staff Member                                                                        CER034A
      *                                                                                      CER034A
     C                   MOVE      E5SMBR        R2SMBR
      *                                                                                      CER034A
     C                   ENDIF
      *                                                                                      CER034A
     C     CER038        IFEQ      'Y'
      *                                                                                      CER034A
      ** Language ID                                                                         CER034A
      *                                                                                      CER034A
     C                   MOVE      E5LNID        R2LNID
      *                                                                                      CER034A
      ** Correspondent Type                                                                  CER034A
      *                                                                                      CER034A
     C                   MOVE      E5CTYP        R2CTYP
      *                                                                                      CER034A
     C                   ENDIF
      *                                                                                      CER034A
     C     CER041        IFEQ      'Y'
      *                                                                                      CER034A
      ** Zero Confirmation Flag                                                              CER034A
      *                                                                                      CER034A
     C                   MOVE      E5ZCFG        R2ZCFG
      *                                                                                      CER034A
     C                   ENDIF
      *                                                                                      CER034A
     C     CER045        IFEQ      'Y'
      *                                                                                       CER045
      ** Borrower Sector Classification Code                                                  CER045
      ** Economic Activity Code                                                               CER045
      ** Borrower Sector Classification/BISTA                                                 CER045
      ** Additional Borrowers Statistics Key                                                  CER045
      ** Customer Required for Bundesbank Reporting                                           CER045
      ** Risk Classification Code                                                             CER070
      ** Legal Form                                                                           CER071
      *                                                                                       CER045
     C                   MOVE      E5BSCC        R2BSCC
     C                   MOVE      E5ECAC        R2ECAC
     C                   MOVE      E5BIST        R2BIST
     C                   MOVE      E5ABSK        R2ABSK
     C                   MOVE      E5BEXT        R2BEXT
     C                   MOVE      E5RIGR        R2RIGR
     C                   MOVE      E5RECH        R2RECH
      *                                                                                       CER045
     C                   ENDIF
      *                                                                                       CER045
     C     @$OFL         SUB       @$CLN         WREM              2 0
     C********** WREM      IFGE 28                                                    CER034A CER071
     C     WREM          IFGE      29
     C                   WRITE     REUTX1
     C                   ELSE
     C                   WRITE     ZZPAGHDR
     C                   WRITE     REUTX1
     C                   END
      *                                                                                       CGL032
      ** If the Joint Account Type is 'I' or 'Y', print additional info.                      CGL032
      *                                                                                       CGL032
     C     E5JATP        IFEQ      'I'
     C     E5JATP        OREQ      'Y'
      *                                                                                       CGL032
      ** Establish starting position.                                                         CGL032
      *                                                                                       CGL032
     C     *LOVAL        SETLL     SDACTXD0
     C                   READ      SDACTXD0                               01
      *                                                                                       CGL032
     C     *IN01         DOWEQ     *OFF
     C     XRCUST        IFEQ      AXCUST
     C                   MOVE      AXCTTX        R3CTTX
     C                   MOVE      AXETXS        R3ETXS
     C                   MOVE      AXCERF        R3CERF
      *                                                                                       CGL032
     C                   Z-ADD     AXCEEX        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *                                                                                       CGL032
     C                   MOVE      ZADATE        R3CEEX
      *                                                                                       CGL032
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      AXCTTX        PKEY              2
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *                                                                                       CGL032
      ** DB Error Management.                                                                 CGL032
      *                                                                                       CGL032
     C     PRTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     007           DBASE                          ************
     C                   MOVEL     'SDCTRYPD'    DBFILE                         * DBERR  07*
     C                   MOVEL     POPTN         DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGL032
     C                   MOVE      A4CNNM        R3CNNM
     C                   MOVE      AXCSTS        R3CSTS
      *                                                                                       CGL032
      ** Check for overflow, print header if so.                                              CGL032
      *                                                                                       CGL032
     C     W0OFL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      @$HDL
     C                   WRITE     ZZPAGHDR
     C                   ENDIF
      *                                                                                       CGL032
     C                   WRITE     REUTX2
     C                   ENDIF
      *                                                                                       CGL032
     C                   READ      SDACTXD0                               01
     C                   ENDDO
      *                                                                                       CGL032
     C                   ENDIF
      *                                                                                       CGL032
     C                   ENDIF
      *================================================================                       CGL032
     CSR                 ENDSR
      /EJECT
     CSR   CAPRDT        BEGSR
      *================================================================
      * Print report detail line.
      *================================================================
      * Load detail line.
      *                                                                   S01383
      ***  Remove fields that serve no purpose (and dummy definitions     S01383
      ***  in the print file). But, must define ones that are used.       S01383
      *                                                                   S01383
     C***********          Z-ADDBBLCD     XRLCD            Last Change DatS01383
     C***********          Z-ADD*ZERO     XRCLCD           CD Laste changeS01383
     C***********          MOVELBBTYLC    XRTYLC           Type of Last ChS01383
     C***********          MOVELBBDRCS    XRDRCS           DRS Customer ShS01383
     C***********          MOVELBBLCCD    XRLCCD           Location Code  S01383
     C***********          Z-ADD*ZERO     XRCDFC           CD date of firsS01383
     C***********          Z-ADDBBSSDT    XRSSDT           Suspended Date S01383
     C***********          Z-ADDBBLRLD    XRLRLD           Last Retail LetS01383
     C***********          Z-ADDBBLALD    XRLALD           Last Audit LettS01383
     C***********          Z-ADDBBLDHD    XRLDHD           Last Dels HistoS01383
     C***********          Z-ADDBBDTDL    XRDTDL           Date Deleted   S01383
     C***********          MOVELBBSTFG    XRSTFG           SWIFT or Telex S01383
     C***********          MOVELBBLETI    XRLETI           LE Past/Int TelS01383
     C***********          MOVELBBCMTI    XRCMTI           Customer ModuleS01383
     C***********          MOVELBBGSFM    XRGSFM           Generate SWIFT S01383
     C***********          Z-ADDBBDOIC    XRDOIC           Date of InitialS01383
      *                                                                   S01383
     C/COPY WNCPYSRC,SD0010PC28
      *                                                                                       CSW207
      ** Get Customer Details Swift Extension                                                 CSW207
      *                                                                                       CSW207
     C     CSW207        IFEQ      'Y'
     C     BGN4ST        OREQ      'Y'
     C     BBCUST        CHAIN     SDCSSWL1                           02
     C     *IN02         IFEQ      *OFF
     C                   MOVEL     CSCICI        XRCICI                         Investor Capacity
     C                   MOVEL     CSCPCI        XRCPCI                         Party Capacity
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     CSIBEI        XRIBEI                         IBEI Code
      *                                                                                       CSW207
     C     BBCUST        CHAIN     SDCUSXL1                           02
     C     *IN02         IFEQ      *OFF
     C                   MOVEL     XCACCZ        XRACCZ                         Alt Ctry of Citi
     C     XCCRDT        IFEQ      0
     C                   MOVE      *BLANK        XRCRDT                         Creation Date
     C                   ELSE
     C                   MOVE      XCCRDT        XRCRDT                         Creation Date
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      XCLCUS        XRLCUS                         Username
     C                   MOVE      XCDRMT        XRDRMT                         Dormant Indicat
      *                                                                                       CGL132
     C                   Z-ADD     BBLCD         XRLCD             5 0                         S0138
     C                   Z-ADD     *ZERO         XRCLCD            6 0                         S0138
     C                   MOVEL     BBTYLC        XRTYLC            1                           S0138
      *                                                                   S01383
     C                   MOVEL     BBCUST        XRCUST                         Customer Number
     C                   MOVEL     BBCNA1        XRCNA1                         Cust. Name & Ad
     C                   MOVEL     BBCRNM        XRCRNM                         Customer Report
     C                   MOVEL     BBPAIN        XRPAIN                         Parent Indicato
     C                   MOVEL     *BLANK        XRACDT                         alpha change da
     C                   MOVEL     *BLANK        XRALCH                         alpha of last c
     C                   MOVEL     BBCSSN        XRCSSN                         Customer Shortn
     C                   MOVEL     BBCNA2        XRCNA2                         Cust. Name & Ad
     C                   MOVEL     BBCRTN        XRCRTN                         Customer Report
     C                   MOVEL     BBPCNB        XRPCNB                         Parent Customer
     C                   MOVEL     BBCNA3        XRCNA3                         Cust. Name & Ad
     C                   MOVEL     BBBRCD        XRBRCD                         Branch code
     C                   MOVEL     *BLANK        XRCSTA                         Customer Status
     C                   MOVEL     BBCNA4        XRCNA4                         Cust. Name & Ad
     C                   Z-ADD     BBDTDL        XRDTDL            5 0          Date Deleted
     C     CSW207        IFEQ      'Y'
     C     BGN4ST        OREQ      'Y'
     C                   MOVEL     CSCICI        XRCICI                         Investor Capacity
     C                   MOVEL     CSCPCI        XRCPCI                         Party Capacity
     C                   ENDIF
     C                   MOVEL     CSIBEI        XRIBEI                         IBEI Code
     C                   MOVEL     BBBSIN        XRBSIN                         Branch/Subsidia
     C                   MOVEL     BBBNBI        XRBNBI                         Bank/non-bank I
     C                   MOVEL     BBCTNB        XRCTNB                         Customer Teleph
     C                   MOVEL     BBCNCZ        XRCNCZ                         Country of Citi
     C                   MOVEL     BBLICD        XRLICD                         Local Industry
     C                   MOVEL     BBCOLC        XRCOLC                         Country of Loca
     C/COPY WNCPYSRC,SD0010PC08
     C                   MOVEL     BBLINC        XRLINC                         Local Instituti
     C/COPY WNCPYSRC,SD0010PC09
     C                   MOVEL     BBTXA1        XRTXA1                         MIDAS Telex Sho
     C                   MOVEL     BBACOC        XRACOC                         Account Officer
     C                   MOVEL     BBCSTY        XRCSTY                         Customer Type
     C                   MOVEL     BBTXA2        XRTXA2                         Telex Address 2
     C                   MOVEL     BBRWCD        XRRWCD                         Risk Weighting
     C                   MOVEL     BBSWFI        XRSWFI                         SWIFT Fin Inst 09944
     C                   MOVEL     BBTAIN        XRTAIN                         Taxable Indicat
     C                   MOVEL     BBTXA3        XRTXA3                         Telex Address 3
     C                   MOVEL     BBTXA4        XRTXA4                         Telex Address 4
     C                   MOVEL     BBTXA5        XRTXA5                         Telex Address 5
     C                   MOVEL     *BLANK        XRRFCD                         Report First Co
     C                   MOVEL     BBREID        XRREID                         Reuter Id.
     C                   MOVEL     BBCSID        XRCSID                         Customer Swift
     C                   MOVEL     *BLANK        XRRSUD                         Report Suspende
     C/COPY WNCPYSRC,SD0010PC26
     C                   MOVEL     BBCASC        XRCASC                         Customer Alpha
     C/COPY WNCPYSRC,SD0010PC27
     C                   MOVEL     BBSTAD        XRSTAD                         STTX Address
     C                   MOVEL     *BLANK        XRRDTD                         Report Date Del
     C                   Z-ADD     BBCHSC        XRCHSC                         Chaps sort code
     C                   MOVEL     *BLANK        XRRRLD                         Report Retail L
     C                   MOVEL     BBBFIC        XRBFIC                         BOJ Fin. Inst.
      *                                                                                       CSW213
     C     CSW213        IFEQ      'Y'
     C                   MOVEL     CSLEIC        XRLEIC
     C                   MOVEL     CSCLSY        XRCLSY
     C                   MOVEL     CSCLID        XRCLID
     C                   ENDIF
      *                                                                                       CSW213
     C     CFT050        IFEQ      'Y'
     C                   MOVEL     CSBDRK        XRBDRK
     C                   ENDIF
      *                                                                                       CSW213
     C**********           Z-ADDBBCABA    XRCABA           Chips ABA      151482
     C                   Z-ADD     BBABA2        XRCABA                         Chips ABA      15148
     C                   MOVEL     *BLANK        XRRALD                         Report Audit Le
     C                   Z-ADD     BBFWCD        XRFWCD                         Fedwire Code
     C                   Z-ADD     BBCHID        XRCHID                         Chips Id
     C                   MOVEL     *BLANK        XRRDHD                         Report Dels His
     C                   MOVEL     BBBLCD        XRBLCD                         Bankleitzahl Co
     C                   MOVEL     BBNG01        XRNG01                         Message Type No
     C                   MOVEL     BBNG02        XRNG02                         Message Type No
     C                   MOVEL     BBNG03        XRNG03                         Message Type No
     C                   MOVEL     BBNG04        XRNG04                         Message Type No
     C                   MOVEL     BBNG05        XRNG05                         Message Type No
     C                   MOVEL     BBNG06        XRNG06                         Message Type No
     C                   MOVEL     BBNG07        XRNG07                         Message Type No
     C                   MOVEL     BBNG08        XRNG08                         Message Type No
     C                   MOVEL     BBNG09        XRNG09                         Message Type No
     C                   MOVEL     BBNG10        XRNG10                         Message Type No
     C                   MOVEL     BBNG11        XRNG11                         Message Type No
     C                   MOVEL     BBNG12        XRNG12                         Message Type No
     C                   MOVEL     BBNG13        XRNG13                         Message Type No
     C                   MOVEL     BBNG14        XRNG14                         Message Type No
     C                   MOVEL     BBNG15        XRNG15                         Message Type No
     C                   MOVEL     BBDS01        XRDS01                         Default Status
     C                   MOVEL     BBDS02        XRDS02                         Default Status
     C                   MOVEL     BBDS03        XRDS03                         Default Status
     C                   MOVEL     BBDS04        XRDS04                         Default Status
     C                   MOVEL     BBDS05        XRDS05                         Default Status
     C                   MOVEL     BBDS06        XRDS06                         Default Status
     C                   MOVEL     BBDS07        XRDS07                         Default Status
     C                   MOVEL     BBDS08        XRDS08                         Default Status
     C                   MOVEL     BBDS09        XRDS09                         Default Status
     C                   MOVEL     BBDS10        XRDS10                         Default Status
     C                   MOVEL     BBDS11        XRDS11                         Default Status
     C                   MOVEL     BBDS12        XRDS12                         Default Status
     C                   MOVEL     BBDS13        XRDS13                         Default Status
     C                   MOVEL     BBDS14        XRDS14                         Default Status
     C                   MOVEL     BBDS15        XRDS15                         Default Status
     C                   MOVEL     BBDNW1        XRDNW1                         Default Network
     C                   MOVEL     BBDNW2        XRDNW2                         Default Network
     C                   MOVEL     BBDNW3        XRDNW3                         Default Network
     C                   MOVEL     BBDNW4        XRDNW4                         Default Network
     C                   MOVEL     BBDNW5        XRDNW5                         Default Network
     C                   MOVEL     BBDNW6        XRDNW6                         Default Network
     C                   MOVEL     BBDNW7        XRDNW7                         Default Network
     C                   MOVEL     BBDNW8        XRDNW8                         Default Network
     C                   MOVEL     BBDNW9        XRDNW9                         Default Network
     C                   MOVEL     *BLANK        XRWNFF                         Window Function
     C                   MOVEL     BBDINC        XRDINC                         Designtd In CcyCEU01
      *                                                                                       CGP001
      ** Move the Global Processing fields to screen                                          CGP001
      ** if CGP001 is enabled.                                                                CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPCU
     C                   ENDIF
      *                                                                                       CGP001
      *                                                                                       CSD025
      ** Move De-Activated flag in position                                                   CSD025
      ** if CSD025 is enabled.                                                                CSD025
      *                                                                                       CSD025
     C     CSD025        IFEQ      'Y'
      *                                                                                       CSD025
     C                   MOVE      BBDEAC        XRDEAC
     C                   MOVE      *BLANKS       XRDEDT
      *                                                                                       CSD025
     C     BBDEDT        IFNE      0
      * Check File Date - Rundate  *                                                          CSD025
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      BBDEDT        WQ0001            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0002            1            Date format fla
     C                   PARM      *ZERO         WQ0003            6 0          Work Converted
     C                   PARM      *BLANK        WQ0004            7            Work Alpha Date
      *                                                                                       CSD025
     C                   MOVE      WQ0003        XRDEDT
      *                                                                                       CSD025
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.                                                       CSD025
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD025
     C                   ENDIF
      *                                                                                       CSD025
      ** Move Fund Account Number into position                           CSW037A
      ** if CSW037 is enabled.                                            CSW037A
      *                                                                   CSW037A
     C     CSW037        IFEQ      'Y'                                                         CSW03
     C                   MOVE      BBFNAC        XRFNAC                                        CSW03
     C                   ENDIF                                                                 CSW03
      *                                                                   CSW037A
     C     CSW024        IFEQ      'Y'
     C                   MOVEL     BBCORP        XRCORP
     C                   MOVEL     BBCBEI        XRCBEI
     C                   MOVEL     BBFUND        XRFUND
     C                   MOVEL     BBRI01        XRRI01
     C                   MOVEL     BBRI02        XRRI02
     C                   MOVEL     BBRI03        XRRI03
     C                   MOVEL     BBRI04        XRRI04
     C                   MOVEL     BBRI05        XRRI05
     C                   ENDIF
     C/COPY WNCPYSRC,SDH00578
      *                                                                                       CLE025
     C     CLE025        IFEQ      'Y'
     C     CFX001        OREQ      'Y'
     C                   MOVE      BBFCMF        XRFCMF
     C                   MOVE      BBINOF        XRINOF
     C                   MOVE      BBMSTF        XRMSTF
     C                   MOVE      BBIOPC        XRIOPC
     C                   ENDIF
     C*                                                                   S01408
     C/COPY WNCPYSRC,SD0010PC24                                           S01408
     C*                                                                   S01408
     C                   MOVEL     *BLANK        XRWNF1                         Window Function
     C                   MOVEL     *BLANK        XRWNF2                         Window Function
     C                   MOVEL     'Y'           W0PFM
     C*                                                                   S01408
     C/COPY WNCPYSRC,SD0010PCP1                                           S01408
     C*                                                                   S01408
     C*                                                                   S01408
     C     ULX004        IFEQ      'Y'
      *                                                                                       CER001
      ** EUROPEAN REPORTING DETAILS                                                           CER001
      *                                                                                       CER001
     C                   MOVE      BBCUST        WWCUST            6
     C     WWCUST        CHAIN     SDCUX2L0                           95
     C     *IN95         IFEQ      '0'
     C                   Z-ADD     VFCONS        XRCONS
     C                   Z-ADD     VFECOS        XRECOS
     C                   Z-ADD     VFNCOS        XRNCOS
     C                   Z-ADD     VFINRF        XRINRF
     C**********           Z-ADDVFCGRP    XRCGRP                                      CER001 CSD027A
     C                   MOVE      VFCGRP        XRCGRP
     C                   Z-ADD     VFPAPS        XRPAPS
     C                   MOVE      VFPERF        XRPERF
     C                   MOVE      VFSMRS        XRSMRS
     C                   ENDIF
      *                                                                                       CER001
      **  If feature UlX012 is installed                                                      CER001
      *                                                                                       CER001
     C     ULX012        IFEQ      'Y'
     C                   MOVE      VFAUTG        XRAUTG
     C                   MOVE      VFPROG        XRPROG
     C                   MOVE      VFASSP        XRASSP
     C                   ENDIF
      *                                                                                       CER001
      ** If feature UlX008 is installed                                                       CER001
      *                                                                                       CER001
     C     ULX008        IFEQ      'Y'
     C                   MOVE      VFICCD        XRICCD
     C                   MOVE      VFMCID        XRMCID
     C                   ENDIF
      *                                                                                       CER001
      ** If feature UlX048 is installed                                                       CER001
      *                                                                                       CER001
     C     ULX048        IFEQ      'Y'
     C                   MOVE      VFMCID        XRMCID
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             XRCONS
     C                   Z-ADD     0             XRECOS
     C                   Z-ADD     0             XRNCOS
     C                   Z-ADD     0             XRINRF
     C**********           Z-ADD0         XRCGRP                                      CER001 CSD027A
     C                   MOVE      *BLANKS       XRCGRP
     C                   Z-ADD     0             XRPAPS
     C                   MOVE      ' '           XRPERF
     C                   MOVE      ' '           XRSMRS
      *                                                                                       CER001
      **  If feature UlX012 is installed                                                      CER001
      *                                                                                       CER001
     C     ULX012        IFEQ      'Y'
     C                   MOVE      ' '           XRAUTG
     C                   MOVE      ' '           XRPROG
     C                   MOVE      ' '           XRASSP
     C                   ENDIF
      *                                                                                       CER001
      ** If both features ULX012 and ULX012 are installed                                     CER001
      *                                                                                       CER001
     C     ULX012        IFEQ      'Y'
     C                   MOVE      *BLANKS       XRPLGT
     C                   ENDIF
      *                                                                                       CER001
      **  If feature UlX008 is installed                                                      CER001
      *                                                                                       CER001
     C     ULX008        IFEQ      'Y'
     C                   MOVE      ' '           XRICCD
     C                   MOVE      ' '           XRMCID
     C                   ENDIF
      *                                                                                       CER001
      **  If feature UlX048 is installed                                                      CER001
      *                                                                                       CER001
     C     ULX048        IFEQ      'Y'
     C                   MOVE      ' '           XRMCID
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,SD0010PCP2                                           S01408
     C*                                                                   S01408
      *                                                                                       CER001
      ** ULX043 Treatment                                                                     CER001
      *                                                                                       CER001
     C     ULX043        IFEQ      'Y'
     C                   CALL      'IL0450'
     C                   PARM      BBCUST        PCNUM             6
     C                   PARM      *BLANKS       IBFROM
     C                   PARM      *BLANK        ILFLAG            1
      *                                                                                       CER001
     C     ILFLAG        IFEQ      '0'
     C                   MOVEA     IBFROM        BLC
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      *                                                                   S01383
      ***  If BRT SAR is installed, determine the sets of Holder data     S01383
      ***  that will be printed. (Controlled by Indicators 11 - 15).      S01383
      *                                                                   S01383
     C     S01383        IFEQ      'Y'                                                         S0138
     C                   MOVEA     '00000'       *IN(11)                                       S0138
      *                                                                   S01383
      ***  If A/c Holder Type is 'J', sets 1 and 2 will be printed.       S01383
      *                                                                   S01383
     C     ACHLRT        IFEQ      'J'                                                         S0138
     C                   SETON                                        1112                     S0138
     C                   END                                                                   S0138
      *                                                                   S01383
      **If*A/c*Holder*Type*is*'I',*at*least*set*1*will*be*printed* S01383 CRE007
      ** If A/c Holder Type is 'I' or 'R', at least set 1 will be printed CRE007
      *                                                                   S01383
     C     ACHLRT        IFEQ      'I'                                                         S0138
     C     ACHLRT        OREQ      'R'                                                         CRE00
     C                   SETON                                        11                       S0138
      *                                                                   S01383
      ***  Then, for sets 2 to 5, each set will be printed if its BRT     S01383
      ***  Liable Flag is 'Y', 'X' or 'N', but if a set has a blank BRT   S01383
      ***  Liable Flag, then all subsequent sets for this customer are    S01383
      ***  blank.                                                         S01383
      *                                                                   S01383
     C     H2BRTL        IFEQ      'Y'                                                         S0138
     C     H2BRTL        OREQ      'X'                                                         S0138
     C     H2BRTL        OREQ      'N'                                                         S0138
     C                   SETON                                        12                       S0138
      *                                                                   S01383
     C     H3BRTL        IFEQ      'Y'                                                         S0138
     C     H3BRTL        OREQ      'X'                                                         S0138
     C     H3BRTL        OREQ      'N'                                                         S0138
     C                   SETON                                        13                       S0138
      *                                                                   S01383
     C     H4BRTL        IFEQ      'Y'                                                         S0138
     C     H4BRTL        OREQ      'X'                                                         S0138
     C     H4BRTL        OREQ      'N'                                                         S0138
     C                   SETON                                        14                       S0138
      *                                                                   S01383
     C     H5BRTL        IFEQ      'Y'                                                         S0138
     C     H5BRTL        OREQ      'X'                                                         S0138
     C     H5BRTL        OREQ      'N'                                                         S0138
     C                   SETON                                        15                       S0138
     C                   END                                                                   S0138
      *                                                                   S01383
     C                   END                                                                   S0138
     C                   END                                                                   S0138
     C                   END                                                                   S0138
      *                                                                   S01383
      ***  END of ACHLRT = 'I'.                                           S01383
     C                   END                                                                   S0138
      ***  END of BRT SAR installed (S01383 = 'Y').                       S01383
     C                   END                                                                   S0138
     C*                                                                   S01421
     C*                                                                   S01421
     C     *IN22         IFEQ      '1'                                                         S0142
     C                   MOVE      BBCDEL        XRCEAD            1                           S0142
     C                   END                                                                   S0142
     C*                                                                   S01421
     C*                                                                   S01408
     C/COPY WNCPYSRC,SD0010PC22                                           S01408
     C*                                                                   S01408
      *                                                                   S01383
      * USER: Process detail record
      * Check File Date - Rundate  *
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      BBLCD         WQ0001            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0002            1            Date format fla
     C     XRCLCD        PARM      *ZERO         WQ0003            6 0          Work Converted
     C     WUWADT        PARM      *BLANK        WQ0004            7            Work Alpha Date
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Start of Fix LN0562
      * Change the processing so that the alpha date is displayed
      * instead of the DDMMYY style format
      * Check File Date - Rundate  *
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      BBDOIC        WQ0005            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0006            1            Date format fla
     C     WUWCDT        PARM      *ZERO         WQ0007            6 0          Work Converted
     C     WUWADT        PARM      *BLANK        WQ0008            7            Work Alpha Date
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
     C                   MOVEL     WUWADT        XRRFCD                         Report First Co
      * Check File Date - Rundate  *
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      BBSSDT        WQ0009            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0010            1            Date format fla
     C     WUWCDT        PARM      *ZERO         WQ0011            6 0          Work Converted
     C     WUWADT        PARM      *BLANK        WQ0012            7            Work Alpha Date
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
     C                   MOVEL     WUWADT        XRRSUD                         Report Suspende
      * Check File Date - Rundate  *
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      BBLDHD        WQ0013            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0014            1            Date format fla
     C     WUWCDT        PARM      *ZERO         WQ0015            6 0          Work Converted
     C     WUWADT        PARM      *BLANK        WQ0016            7            Work Alpha Date
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
     C                   MOVEL     WUWADT        XRRDHD                         Report Dels His
      * Check File Date - Rundate  *
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      BBLRLD        WQ0017            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0018            1            Date format fla
     C     WUWCDT        PARM      *ZERO         WQ0019            6 0          Work Converted
     C     WUWADT        PARM      *BLANK        WQ0020            7            Work Alpha Date
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
     C                   MOVEL     WUWADT        XRRRLD                         Report Retail L
      * Check File Date - Rundate  *
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      BBDTDL        WQ0021            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0022            1            Date format fla
     C     WUWCDT        PARM      *ZERO         WQ0023            6 0          Work Converted
     C     WUWADT        PARM      *BLANK        WQ0024            7            Work Alpha Date
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
     C                   MOVEL     WUWADT        XRRDTD                         Report Date Del
      * Check File Date - Convert to Screen Format *                                          CGL132
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      XCCRDT        WQ0021            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0022            1            Date format fla
     C     WUWCDT        PARM      *ZERO         WQ0023            6 0          Work Converted
     C     WUWADT        PARM      *BLANK        WQ0024            7            Work Alpha Date
      *                                                                                       CGL132
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.                                                       CGL132
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *                                                                                       CGL132
     C                   MOVEL     WUWADT        XRCRDT                         Creation Date
      * Check File Date - Rundate  *
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      BBLALD        WQ0025            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0026            1            Date format fla
     C     WUWCDT        PARM      *ZERO         WQ0027            6 0          Work Converted
     C     WUWADT        PARM      *BLANK        WQ0028            7            Work Alpha Date
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
     C                   MOVEL     WUWADT        XRRALD                         Report Audit Le
      *                                                                   CDL008
      ** If CDL008 is on, print CLS Settlement and Effective Date         CDL008
      *                                                                   CDL008
     C     CDL008        IFEQ      'Y'                                                         CDL00
     C                   MOVEL     BBCLSS        XRCLSS                                        CDL00
      *                                                                   CDL008
     C     BBEFDT        IFEQ      *ZERO                                                       CDL00
     C                   MOVE      *BLANKS       WUWADT                                        CDL00
     C                   ELSE                                                                  CDL00
     C                   CALL      'ZDATE2'                             90                     CDL00
     C                   PARM      BBEFDT        WQ0042            5 0                         CDL00
     C                   PARM      WUDFF         WQ0043            1                           CDL00
     C     WUWCDT        PARM      *ZERO         WQ0044            6 0                         CDL00
     C     WUWADT        PARM      *BLANK        WQ0045            7                           CDL00
     C     *IN90         IFEQ      *ON                                                         CDL00
     C                   MOVEL     'Y2U0021'     W0RTN                                         CDL00
     C                   ENDIF                                                                 CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL008
     C                   MOVE      WUWADT        XREFDT                                        CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL008
      * End of Fix LN0562
     C                   MOVEL     P1ARSI        WUARSI                         Audit/Request S
      * Process Detail Rec PRTFIL
      * Start of Fix BHF950
      * This change to the standard object was required because the
      * clients file has logically deleted records and these were
      * initially being counted as records on the file - thus if there
      * were any deleted clients on the system the file controls would
      * be out of balance. This fix will not affect any other report
      * programs since there will be no records with a last change type
      * of 'D'.
      *CASE:     PAR.Type of Last Change is Not Delete
     C********** XRTYLC    IFEQ @CN,02                     *IF                              MD025682
     C********** XRTYLC    OREQ @CN,03                                                      MD025682
     C     XRDTDL        IFEQ      0                                            *IF
     C                   ADD       1             WUWKNB                         work number
     C                   END                                                    *FI
      * End of Fix BHF950
     C/COPY WNCPYSRC,SD0010PC01
      *CASE:     PAR.Audit/Request Status Ind is Audit Mode
     C     WUARSI        IFEQ      @CN(02)                                      *IF
      *CASE:     PAR.Last Change Date NE WRK.run day number
     C     XRLCD         IFNE      WURDNB                                       *IF
     C                   MOVEL     @CN(04)       W0PFM                          *Print format
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     PGM.*Print format is Print format
     C     W0PFM         IFEQ      @CN(01)                                      *IF
     C                   ADD       1             ZTNCRC                         No of Calculate
      *CASE:     PAR.No of Calculated Recs is Equal 1
     C     ZTNCRC        IFEQ      1                                            *IF
      * Change Print Control to Y - Standing Data Controls  *
     C*
     C* Set Print Control To Y To Enable Column Headers To Be
     C*             Printed On First Record..
     C*
     C                   MOVEL     'Y'           BAPR              1
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Check File Date - Rundate  *
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      XRLCD         WQ0029            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0030            1            Date format fla
     C     WUWCDT        PARM      *ZERO         WQ0031            6 0          Work Converted
     C     XRACDT        PARM      *BLANK        WQ0032            7            Work Alpha Date
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * PAR.alpha of last change = Condition name of PAR.Type of Last Change
     C                   CALL      'Y2RVCNR'                            90      *
     C                   PARM                    W0RTN             7            Return code
     C                   PARM      1100584       Y2LSNO            7 0          List number
     C                   PARM      XRTYLC        W0INVL           20            Type of Last Ch
     C                   PARM      ' '           W0VLMP            1            Value mapped?
     C     XRALCH        PARM                    W0CNNM           25            alpha of last c
      *
      * Start of Fix BHF331
      *CASE:     CUR.Type of Last Change is Delete
     C     XRTYLC        IFEQ      @CN(05)                                      *IF
     C                   MOVEL     @CN(06)       XRCSTA                         Customer Status
     C                   ELSE
      *CASE:     *OTHERWISE
     C                   MOVEL     *BLANK        XRCSTA                         Customer Status
     C                   END                                                    *FI
      * End of Fix BHF331
      *                                                                   CSD007
      ** If CSD007 is installed, display Type of last change, status      CSD007
      ** and change date for Closed or Released Customers                 CSD007
      *                                                                   CSD007
     C                   MOVE      *OFF          *IN71                                         CSD00
     C                   MOVEL     *BLANKS       XRCLDT                                        CSD00
      *                                                                   CSD007
     C     CSD007        IFEQ      'Y'                                                         CSD00
     C     BBDEAC        IFEQ      'Y'                                                         CSD02
     C     CSD025        ANDEQ     'Y'                                                         CSD02
     C                   MOVEL     @CN(18)       XRALCH                                        CSD02
     C                   ENDIF                                                                 CSD02
     C     BBCLDT        IFGT      *ZERO                                                       CSD00
     C                   MOVE      *ON           *IN71                                         CSD00
     C                   CALL      'ZDATE2'                             90                     CSD00
     C                   PARM      BBCLDT        WQ0042            5 0                         CSD00
     C                   PARM      WUDFF         WQ0043            1                           CSD00
     C     WUWCDT        PARM      *ZERO         WQ0044            6 0                         CSD00
     C     XRCLDT        PARM      *BLANKS       WQ0045            7                           CSD00
     C     *IN90         IFEQ      *ON                                                         CSD00
     C                   MOVEL     'Y2U0021'     W0RTN                                         CSD00
     C                   ENDIF                                                                 CSD00
     C     BBCLST        IFEQ      *BLANK                                                      CSD00
     C                   MOVEL     @CN(15)       XRALCH                                        CSD00
     C                   ENDIF                                                                 CSD00
     C                   ENDIF                                                                 CSD00
      *                                                                   CSD007
     C     BBCLST        IFEQ      'Y'                                                         CSD00
     C     BBDTDL        ANDEQ     *ZERO                                                       CSD00
     C                   MOVEL     @CN(16)       XRALCH                                        CSD00
     C                   MOVEL     @CN(17)       XRCSTA                                        CSD00
     C                   ENDIF                                                                 CSD00
     C                   ENDIF                                                                 CSD00
      *                                                                   CSD007
      *CASE:     WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 00/Copy Member SD0010PPDR - Client Details  *
     C/COPY WNCPYSRC,SD0010PPDR
      *                                                                                      LLN022A
      ** If BOE Yellow book module is on                                                     LLN022A
      *                                                                                      LLN022A
     C     LLN007        IFEQ      'Y'
      *                                                                                      LLN022A
     C     BBCUST        CHAIN     BYCUSTY0                           92
      *                                                                                      LLN022A
      ** Record is found                                                                     LLN022A
      *                                                                                      LLN022A
     C     *IN92         IFEQ      *OFF
      *                                                                                      LLN022A
      ** Move Data Structure Fields to 1st Printline                                         LLN022A
      *                                                                                      LLN022A
     C                   MOVE      LSIOF         ULSIOF                         SIO Ind
     C                   MOVE      LHASI         ULHAIN                         H/A Ind
     C                   MOVE      LUPAR         ULULPA                         Ult Parent
     C                   MOVE      LELGF         ULEGFL                         Elig Flag
     C                   MOVE      LLINC         ULLINC
     C                   MOVE      LLICD         ULLICD
     C                   MOVE      UFLD1         XRWNFF
      *                                                                                      LLN022A
      ** Otherwise move blanks to data-structure fields                                      LLN022A
      *                                                                                      LLN022A
     C                   ELSE
     C                   MOVE      *BLANK        ULULPA                         Ult. Parent
     C                   MOVE      *BLANK        ULEGFL                         Elig. Flag
     C                   MOVE      *BLANK        ULLINC
     C                   MOVE      *BLANK        ULLICD
      *                                                                                      LLN022A
     C                   ENDIF
     C                   ENDIF
      *                                                                                      LLN022A
     C                   END                                                    *FI
     C     W0PFM         IFEQ      'Y'
      * Convert fields to external form.
     C                   MOVEL     '0'           *IN79
     C     XRWNFF        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     XRWNF1        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN77
     C     XRWNF2        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN77
     C                   END                                                    *FI
      *                                                                   CGL018
      * Output RWA details for each customer                              CGL018
      *                                                                   CGL018
     C     CGL018        IFEQ      'Y'                                                         CGL01
     C                   EXSR      RWADTL                                                      CGL01
     C                   ENDIF                                                                 CGL01
      **********                                                                     CER073 MD049187
      ***Output*AnaCredit Reporting                                                  CER073 MD049187
      **********                                                                     CER073 MD049187
     C********** CER073    IFEQ 'Y'                                                  CER073 MD049187
     C**********           EXSR SRANAC                                               CER073 MD049187
     C**********           ENDIF                                                     CER073 MD049187
     C/COPY WNCPYSRC,SD0010PC06
      * Print detail line.
     C                   WRITE     ZZDTLRCD
     C*                                                                   S01408
     C/COPY WNCPYSRC,SD0010PCP3                                           S01408
     C*                                                                   S01408
     C     ULX043        IFEQ      'Y'
     C     ILFLAG        ANDEQ     '0'
     C                   MOVE      *BLANKS       RRFROM
     C                   WRITE     ZZIBLC02
      *                                                                                       CER001
     C                   DO        5             BL                1 0
     C     BLC(BL)       IFNE      *BLANKS
     C                   MOVEL     BLC(BL)       RRFROM
      *                                                                                       CER001
      ** If there is not enough space on the                                                  CER001
      ** physical page for this format:-                                                      CER001
      *                                                                                       CER001
     C     @$PGL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      1
      *                                                                                       CER001
      ** Signal artificial overflow.                                                          CER001
      *                                                                                       CER001
     C                   SETON                                        97
      *                                                                                       CER001
      ** Print page headers.                                                                  CER001
      *                                                                                       CER001
     C                   EXSR      FASGHD
     C                   EXSR      BAPRHD
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
     C                   WRITE     ZZIBLC02
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *                                                                                       CER001
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPCU - Gets the Global Customer X-Reference details        *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPCU        BEGSR
      *                                                                                       CGP001
     C                   MOVE      BBBRCD        KBRCD
     C                   MOVE      BBCUST        KCUST
      *                                                                                       CGP001
     C     KGPXR         CHAIN(N)  GPCSTXL1                           46
      *                                                                                       CGP001
     C     *IN46         IFEQ      *OFF
     C                   MOVE      CUGCUS        XRGCID
     C                   ELSE
     C                   MOVE      *BLANKS       XRGCID
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPOF - Opens the Global Processing Cross-Reference Files.  *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPOF        BEGSR
      *                                                                                       CGP001
     C                   Z-ADD     80            PLEN             15 5
      *                                                                                       CGP001
     C                   MOVE      OVRC(1)       PCMD             80
      *                                                                                       CGP001
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PLEN
      *                                                                                       CGP001
     C                   OPEN      GPCSTXL1
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                              S01421
     CSR   ACDTSR        BEGSR                                                                 S0142
      *================================================================   S01421
      *                                                                   CDL006
      ** If Switchable Feature CDL006 is Switched on move File fields     CDL006
      ** to their respective printer file fields.                         CDL006
      *                                                                   CDL006
     C     CDL006        IFEQ      'Y'                                                         CDL00
     C                   MOVEL     BBCOMG        R1COMG                                        CDL00
     C                   MOVEL     BBCHRG        R1CHRG                                        CDL00
     C                   MOVEL     BBAGNT        R1AGNT                                        CDL00
     C                   MOVEL     BBAGNP        R1AGNP                                        CDL00
     C                   MOVEL     BBDFAC        R1DFAC                                        CDL00
     C                   MOVEL     BBDFAS        R1DFAS                                        CDL00
     C                   MOVEL     BBTRAS        R1TRAS                                        CDL00
     C                   MOVEL     BBNAR1        R1NAR1                                        CDL00
     C                   MOVEL     BBNAR2        R1NAR2                                        CDL00
     C                   MOVEL     BBNAR3        R1NAR3                                        CDL00
     C                   MOVEL     BBNAR4        R1NAR4                                        CDL00
      *                                                                   CDL006
      ** Inhibit printing of DL Fiduciary details if Additional           CDL006
      ** Customer Details not printed.                                    CDL006
      *                                                                   CDL006
     C     *IN23         IFEQ      *OFF                                                        CDL00
     C                   MOVE      '0'           *IN17                                         CDL00
     C                   ELSE                                                                  CDL00
     C                   MOVE      '1'           *IN17                                         CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL006
     C                   ENDIF                                                                 CDL00
      *                                                                   S01421
      * The following Sub Routine will search for the customer number     S01421
      * and if found will write a new page header and Additional          S01421
      * Customer Details.                                                 S01421
      *                                                                   S01421
     C     XRCUST        CHAIN     SDACUSL1                           24                       S0142
     C     *IN24         IFEQ      '0'                                                         S0142
     C                   MOVE      E5CUST        ADCNA             6                           S0142
     C/COPY WNCPYSRC,SD0010PC29
     C                   MOVE      E5ALTN        A5ALTN           12                           S0142
     C/COPY WNCPYSRC,SD0010PC30
     C                   MOVE      E5IDNO        A5IDNO           15                           S0142
     C                   MOVE      E5FXNB        A5FXNB           12                           S0142
     C                   MOVE      E5TXNB        A5TXNB           12                           S0142
     C                   MOVE      E5PRVO        A5PRVO            1                           S0142
     C                   MOVE      E5MDTL        A5MDTL            5                           S0142
     C                   MOVE      E5CNA1        A5CNA1           35                           S0142
     C     CSW207        IFEQ      'Y'
     C                   MOVE      E5ISCD        A5ISCD           35
     C                   ENDIF
     C/COPY WNCPYSRC,SD0010PC31
     C                   MOVE      E5CNA2        A5CNA2           35                           S0142
     C                   MOVE      E5CNA3        A5CNA3           35                           S0142
     C                   MOVE      E5CNA4        A5CNA4           35                           S0142
     C                   MOVE      E5CWL1        A5CWL1           20                           S0142
     C                   MOVE      E5CWL2        A5CWL2           20                           S0142
     C/COPY WNCPYSRC,SD0010PC32
     C                   MOVE      E5CWL3        A5CWL3           20                           S0142
     C                   MOVE      E5CWL4        A5CWL4           20                           S0142
     C                   MOVE      E5CWL5        A5CWL5           20                           S0142
      *                                                                   S01421
      * Change the processing so that the alpha date is displayed         S01421
      * instead of the DDMMYY style format                                S01421
      * Check File Date - Date of last visit *                            S01421
      *                                                                   S01421
     C                   CALL      'ZDATE2'                             90      Check File DateS0142
     C                   PARM      E5DOLV        WQ00A1            5 0          Work Midas DateS0142
     C                   PARM      WUDFF         WQ00A2            1            Date format flaS0142
     C     WUWCDT        PARM      *ZERO         WQ00A3            6 0          Work Converted S0142
     C     WUWADT        PARM      *BLANK        WQ00A4            7            Work Alpha DateS0142
      *                                                                   S01421
     C     *IN90         IFEQ      '1'                                                         S0142
      * Call to program ended in error.                                   S01421
     C                   MOVEL     'Y2U0021'     W0RTN             7                           S0142
     C                   END                                                                   S0142
     C                   MOVEL     WUWADT        A5DOLV            7                           S0142
      *                                                                   S01421
     C     E5BRTH        IFNE      0                                                           11333
     C                   CALL      'ZDATE2'                             90      Check File DateS0142
     C                   PARM      E5BRTH        WQ00A5            5 0          Work Midas DateS0142
     C                   PARM      WUDFF         WQ00A6            1            Date format flaS0142
     C     WUWCDT        PARM      *ZERO         WQ00A7            6 0          Work Converted S0142
     C     WUWADT        PARM      *BLANK        WQ00A8            7            Work Alpha DateS0142
      *                                                                   S01421
     C     *IN90         IFEQ      '1'                                                         S0142
      * Call to program ended in error.                                   S01421
     C                   MOVEL     'Y2U0021'     W0RTN             7                           S0142
     C                   END                                                                   S0142
     C                   ELSE                                                                  11333
     C     E5BRT1        IFNE      *BLANKS                                                     11333
     C     E5BRT1        ANDNE     '000000'                                                    16860
      * If format is MMDDYY swap month and day fields for DS E5BRT1       113339
     C     WUDFF         IFEQ      'M'                                                         11333
     C                   MOVE      WWBDAY        WKBMNT            2                           11333
     C                   MOVEL     WWBMNT        WWBDAY                                        11333
     C                   MOVE      WKBMNT        WWBMNT                                        11333
     C                   ENDIF                                                                 11333
     C                   Z-ADD     WWBMNT        Z                 2 0                         11333
     C                   MOVEA     ZMNM(Z)       WWBMT1                                        11333
     C                   MOVEL     WWBDAY        WWBDY1                                        11333
     C                   MOVEL     WWBYR         WWBYR1                                        11333
     C                   MOVEL     WWBRT1        WUWADT                                        11333
     C                   END                                                                   11333
     C                   END                                                                   11333
     C******************** MOVELWUWADT    A5BRTH  7                 S01421113339
     C                   MOVEL(P)  WUWADT        A5BRTH                                        11333
     C*
     C/COPY WNCPYSRC,SD0010PCP7
     C*
      *                                                                   S01421
     C     W0PFM         IFEQ      'Y'                                                         07682
     C                   WRITE     ZZPAGHDR                                                    S0142
     C                   ELSE                                                                  07682
     C                   ADD       1             ZTNCRC                                        07682
     C                   END                                                                   07682
      *                                                                                       CSD029
     C     CSD029        IFEQ      'Y'
     C                   EXSR      SRFMTF
     C                   ELSE
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN33
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN35
     C                   MOVE      *ON           *IN36
     C                   MOVE      *ON           *IN37
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN39
     C                   MOVE      *ON           *IN40
     C                   ENDIF
     C                   WRITE     ADCUDT                                                      S0142
     C*                                                                   S01421
     C                   END                                                                   S0142
     C*                                                                   S01421
     C*================================================================   S01421
     CSR   ACEXIT        ENDSR
      /EJECT
     CSR   DALVCH        BEGSR
      *================================================================
      * Detect level changes.
      *================================================================
      * Clear all level breaks.
     C                   MOVEL     *BLANK        L0                             Page headings
      * Clear heading length to print.
     C                   Z-ADD     *ZERO         @$HDL
      *
      * End of file - Signal all level breaks.
     C     W0EOF         IFEQ      '1'
     C                   ELSE
     C                   END
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   EAPRTT        BEGSR
      *================================================================
      * Print report Totals.
      *================================================================
      * Print level break totals as required
      * End of file - Print final totals.
     C     W0EOF         IFEQ      '1'
     C*
     C/COPY WNCPYSRC,SD0010PC14
     C*
     C                   MOVEL     'Y'           W0PFM
      * USER: Process End of Report
      *CASE:     CUR.No of Calculated Recs is Compare to Zero
     C     ZTNCRC        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(07)       WUALZR                         Alpha Zero
     C                   END                                                    *FI
      *CASE:     PAR.Audit/Request Status Ind is Audit Mode
     C     P1ARSI        IFEQ      @CN(02)                                      *IF
      * Audit/On-Req RTV on FCTL - Standing Data Controls  *
     C                   EXSR      SARVGN
     C*
     C/COPY WNCPYSRC,SD0010PC15
     C*
      *CASE:     WRK.work number NE WRK.No of Records on file
     C     WUWKNB        IFNE      WUNORF                                       *IF
     C                   MOVEL     @CN(04)       WUWFLG                         work flag
     C                   END                                                    *FI
      * Start of Fix BHF399
      * Audit printfile override - Standing Data Controls  *
     C                   CALL      'SDC540P'                            90      Audit printfile
     C                   PARM      @CN(10)       WQ0033           10            *PROGRAM
     C                   PARM      WUWFLG        WQ0034            1            work flag
     C                   PARM      WUNORI        WQ0035            5 0          No of Records I
     C                   PARM      WUNORA        WQ0036            5 0          No of Records A
     C                   PARM      WUNORD        WQ0037            5 0          No of records D
     C                   PARM      WUWKNB        WQ0038            5 0          work number
     C                   PARM      WUNORF        WQ0039            5 0          No of Records o
     C                   PARM      WUAURT        WQ0040           53            Audit/Request T
     C                   PARM      WUBJNA        WQ0041           53            Underline
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * End of Fix BHF399
      *CASE:     PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      @CN(09)                                      *IF
      * Database Error U7 U8 - Standing Data Controls  *
     C*
     C** DATABASE ERROR, SET ON SWITHES U7 AND U8
     C*
     C                   SETON                                        U7U8
     C*
     C                   ELSE
      *CASE:     WRK.work flag is Incorrect
     C     WUWFLG        IFEQ      @CN(04)                                      *IF
      * File Control Error U8 - Standing Data Controls  *
     C*
     C** FILE CONTROLS OUT OF BALANCE SETON U8
     C*
     C                   SETON                                            U8
     C*
     C                   ELSE
      *CASE:     *OTHERWISE
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SBCHRC
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 00/Copy Member SD0010PPER - Client Details  *
     C/COPY WNCPYSRC,SD0010PPER
     C                   END                                                    *FI
     C     W0PFM         IFEQ      'Y'
      * If there is not enough space on the
      * physical page for this format:-
     C     @$PGL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      3
      * Signal artificial overflow.
     C                   SETON                                        97
      * Print page headers.
     C                   WRITE     ZZPAGHDR
     C                   END
     C                   MOVEL     '0'           *IN76
     C     WUALZR        IFEQ      @CN(07)                                      *IF
     C                   MOVEL     '1'           *IN76
     C                   END                                                    *FI
      * Print format.
     C                   WRITE     ZZFINTTL
     C                   END
     C                   END
      *
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   FASGHD        BEGSR
      *================================================================
      * Signal required header formats.
      *================================================================
      * Cascade skip to new page requests upwards.
      *
     C     *IN97         IFNE      '1'
     C     L0            ANDNE     'Y'
      * Signal overflow if requested headings would cause
      * detail format to start past the overflow line.
     C     W0OFL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      @$HDL
     C                   SETON                                        97
     C                   ELSE
     C*                                                                   S01408
     C/COPY WNCPYSRC,SD0010PCP4                                           S01408
     C*                                                                   S01408
      * Signal overflow if requested headings would cause
      * detail format to be printed past end of page
     C     ULX004        IFNE      'Y'
     C                   ADD       36            @$HDL
     C                   ELSE
     C                   ADD       36            @$HDL
     C*                                                                   S01408
     C/COPY WNCPYSRC,SD0010PCP5                                           S01408
     C*                                                                   S01408
      *                                                                                       CER001
      ** Signal overflow if requested headings would cause                                    CER001
      ** detail format to be printed past end of page                                         CER001
      *                                                                                       CER001
     C                   ADD       44            @$HDL
     C                   ENDIF
     C     W0PGL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      @$HDL
     C                   SETON                                        97
     C                   END
     C                   END
     C                   END
      * Overflow detected.
     C     *IN97         IFEQ      '1'
      * Request page headings.
     C                   MOVEL     'Y'           L0
      * Request all formats which print on overflow.
     C                   SETOFF                                       97
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GARDRC        BEGSR
      *================================================================
      * Read next record with user selection.
      *================================================================
     C     W0RSL         DOUEQ     'Y'
     C*
     C/COPY WNCPYSRC,SD0010PC21
     C*
     C                   READ      @BBREBF                                90    *
     C*
     C/COPY WNCPYSRC,SD0010PC20
     C*
     C                   MOVEL     *IN90         W0EOF             1
      * Quit if no record read.
     C     W0EOF         CABEQ     '1'           GAEXIT
     C*
     C/COPY WNCPYSRC,SD0010PC16
     C*
      * Select record unless user action states otherwise.
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Record selection processing
     C*                                                                   S01408
     C/COPY WNCPYSRC,SD0010PC23                                           S01408
     C*                                                                   S01408
      *CASE:     WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 00/Copy Member SD0010PRSP - Client Details  *
     C*00/Copy Member SD0010P   Record Selection Proc.
     C/COPY WNCPYSRC,SD0010PRSP
     C                   END                                                    *FI
      *                                                                   S01408
     C/COPY WNCPYSRC,SD0010PC25                                           S01408
      *                                                                   S01408
      *                                                                   S01383
      ***  If BRT SAR installed, access SDCBRTL1 for Holder details.      S01383
      *                                                                   S01383
     C     S01383        IFEQ      'Y'                                                         S0138
      *                                                                   S01383
     C**********           MOVE BBCUST    KCLBRT  60                                   S01383 CSD027
     C                   MOVE      BBCUST        KCLBRT            6
     C/COPY WNCPYSRC,SDH00090
     C     KCLBRT        CHAIN     SDCBRTL1                           89                       S0138
     C     *IN89         IFEQ      '1'                                                         S0138
     C                   SETON                                        U7U8                     S0138
     C                   MOVEL     'Y2U0005'     W0RTN                                         S0138
     C                   MOVEL     'SDCBRTPD'    ZA0001                                        S0138
     C                   MOVEL     'USR0377'     ZAMSID                                        S0138
     C                   EXSR      ZASNMS                                                      S0138
     C                   EXSR      ZYEXPG                                                      S0138
     C                   END                                                                   S0138
     C/COPY WNCPYSRC,SDH00091
      *                                                                   S01383
     C                   END                                                                   S0138
     C/COPY WNCPYSRC,SD0010PC04
      *                                                                   S01383
     C                   END
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Audit/On-Req RTV on FCTL - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSA         KLIST
     C                   KFLD                    AHFLNM                         Filename
      * Move fields to key list.
     C                   MOVEL     @CN(08)       AHFLNM                         Filename
     C     KRSSA         CHAIN     @AHREAV                            90        *
     C     *IN90         IFEQ      '1'
      * DBF Record not found.
     C                   MOVEL     'USR0020'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(09)       W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   Z-ADD     AHNORC        WUNORF                         No. of Records
     C                   Z-ADD     AHNOIN        WUNORI                         No. of Inserts
     C                   Z-ADD     AHNOAM        WUNORA                         No. of Amends
     C                   Z-ADD     AHNODL        WUNORD                         No. of Deletes
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   OPEN      SDFCTLL0                                                  CER073D
     C                   MOVEL     @CN(08)       AHFLNM                         Filename
      *
     C     KLCHSB        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSB        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SBEXIT
     C                   END
      *
      * USER: Processing after DBF read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move Non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     *ZERO         AHNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         AHNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         AHNODL                         No. of Deletes
      *
     C                   UPDATE    @AHREAU                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Change successful.
     C                   END
     C                   CLOSE     SDFCTLL0                                                  CER073D
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * Get Bank Title - Bank Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   OPEN      SDBANKL1                                                  CER073D
      * Define Keylist.
     C     KRSSC         KLIST
     C                   KFLD                    BJBANK                         Bank
      * Move fields to key list.
     C                   MOVEL     @CN(11)       BJBANK                         Bank
     C     KRSSC         CHAIN     @BJREEF                            90        *
     C     *IN90         IFEQ      '1'
      * DBF Record not found.
     C                   MOVEL     'USR0197'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(09)       W0RTN                          *Return code
      * Setup message data for message.
     C                   MOVEL     @CN(12)       ZA0001                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   GOTO      SCEXIT                                       *QUIT
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   MOVEL     BJURPT        WUURPT                         User Report Tit
     C                   CLOSE     SDBANKL1                                                  CER073D
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   END
      * If no message file specified use default.
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      * Clear all fields for default mechanism next time.
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program
      *================================================================
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct.
      *================================================================
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   CLOSE     GPCSTXL1
     C                   ENDIF
      * Terminate program.
     C                   SETON                                        LR
      *
      * Exit program.
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     C/COPY WNCPYSRC,SD0010PC35
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation.
      *================================================================
      *                                                                                       CGP001
      ** Global Processing X-Reference Key Defn                                               CGP001
      *                                                                                       CGP001
     C     *LIKE         DEFINE    BBCUST        KCUST
     C     *LIKE         DEFINE    BBBRCD        KBRCD
      *                                                                                       CGP001
      ** Global Processing X-Reference Key List                                               CGP001
      *                                                                                       CGP001
     C     KGPXR         KLIST
     C                   KFLD                    KBRCD
     C                   KFLD                    KCUST
      *                                                                                       CGP001
     C*
     C/COPY WNCPYSRC,SD0010PC17
     C*
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      * Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
      * Define work field S01212
     C                   MOVEL     *BLANK        WUMFTS            1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Work Alpha Date
     C                   MOVEL     *BLANK        WUWADT            7
      * Define work field Work Converted Date
     C                   Z-ADD     *ZERO         WUWCDT            6 0
      * Define work field Audit/Request Status Ind
     C                   MOVEL     *BLANK        WUARSI            1
      * Define work field work number
     C                   Z-ADD     *ZERO         WUWKNB            5 0
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Alpha Zero
     C                   MOVEL     *BLANK        WUALZR            1
      * Define work field No of Records on file
     C                   Z-ADD     *ZERO         WUNORF            5 0
      * Define work field No of Records Inserted
     C                   Z-ADD     *ZERO         WUNORI            5 0
      * Define work field No of Records Amended
     C                   Z-ADD     *ZERO         WUNORA            5 0
      * Define work field No of records Deleted
     C                   Z-ADD     *ZERO         WUNORD            5 0
      * Define work field work flag
     C                   MOVEL     *BLANK        WUWFLG            1
      * Define work field Audit/Request Title
     C                   MOVEL     *BLANK        WUAURT           53
      * Define work field Underline
     C                   MOVEL     *BLANK        WUBJNA           53
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field User Report Title
     C                   MOVEL     *BLANK        WUURPT           53
      * Obtain default message file.
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Spool file name
     C                   MOVEL     *BLANK        WUSFNM           10
      * Define work field Spool file number
     C                   Z-ADD     *ZERO         WUSFNB            6 0
      * Define work field ZSFILE error
     C/COPY WNCPYSRC,SD0010PC02
     C                   MOVEL     *BLANK        WUZSER            1
     C                   MOVEL     *BLANK        W0PFM             1
     C                   Z-ADD     *ZERO         @$WRK             4 0
     C                   Z-ADD     *ZERO         @$HDL             4 0
      * Adjust page length and overflow as necessary.
     C     @$PGL         SUB       2             W0PGL             4 0
     C     @$OFL         IFGE      W0PGL
     C     W0PGL         SUB       2             W0OFL             4 0
     C                   ELSE
     C                   Z-ADD     @$OFL         W0OFL
     C                   END
      *                                                                   CDL006
      ** Dataarea LDA                                                     CDL006
      *                                                                   CDL006
     C     *DTAARA       DEFINE                  LDA                                           CDL00
      * USER: Initialise program
      * Standard RPG Creation PAR - Standard Functions  *
      * Last Amend Box SD0010P - Client Details  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT                         RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      *                                                                   CDL006
      ** Prepare LDA                                                      CDL006
      *                                                                   CDL006
     C     *LOCK         IN        LDA                                                         CDL00
     C                   MOVEL     *BLANK        DBLOT                                         CDL00
     C                   MOVEL     'SD0010P'     DBPGM                                         CDL00
     C                   OUT       LDA                                                         CDL00
     C*                                                                   S01413
     C** Access Modules File and check if Retail 3 is installed.          S01413
     C                   CALL      'AOMMODR0'                                                  S0141
     C                   PARM      '*DBERR '     @RTCD             7                           S0141
     C                   PARM      '*FIRST '     @OPTN             7                           S0141
     C     SDMMOD        PARM      SDMMOD        DSFDY                                         S0141
     C*                                                                   S01413
     C     BGNXST        IFEQ      'Y'                                                         S0141
     C                   SETON                                        50                       S0141
     C                   END                                                                   S0141
     C/COPY WNCPYSRC,SD0010PC03
     C*                                                                   S01413
      * Copyright Statement - Standard Functions  * copyright
      * Get Title
      * Get Bank Title - Bank Details  *
     C                   EXSR      SCRVGN
     C*                                                                   S01408
     C/COPY WNCPYSRC,SD0010PCP6                                           S01408
     C*                                                                   S01408
      *                                                                                       CER001
      ** Determine if feature ULX012 (Guarantees and Collateral                               CER001
      ** Management enhancements) is installed                                                CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX012            1
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'ULX012'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CER001
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'ULX012'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER001
      ** If feature ULX012 is installed.                                                      CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           ULX012
     C                   MOVE      *ON           *IN60
     C                   MOVE      *ON           *IN62
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
      ** Determine if feature ULX008 is installed                                             CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX008            1
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'ULX008'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CER001
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'ULX008'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER001
      ** If feature ULX008 is installed.                                                      CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           ULX008
     C                   MOVE      *ON           *IN61
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
      ** Determine if feature ULX048 is installed                                             CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX048            1
     C                   MOVE      *OFF          *IN63
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'ULX048'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CER001
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'ULX048'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER001
      ** If feature ULX048 is installed.                                                      CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           ULX048
     C                   MOVE      *ON           *IN63
     C                   ENDIF
      *                                                                                       CER001
      ** Access Bank Details                                                                  CGL032
      *                                                                                       CGL032
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                                       CGL032
      ** DB Error Management                                                                  CGL032
      *                                                                                       CGL032
     C     PRTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     003           DBASE                          ************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DBERR  03*
     C                   MOVEL     POPTN         DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C*                                                                   CDL002
     C**  Access Switchable features file (FX Netting)                    CDL002
     C*                                                                   CDL002
     C                   CALL      'AOSARDR0'                                                  CDL00
     C                   PARM      '       '     @RTCD                                         CDL00
     C                   PARM      '*VERIFY'     @OPTN                                         CDL00
     C                   PARM      'CDL002'      @SARD                                         CDL00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CDL00
      *                                                                   CDL002
     C     @RTCD         IFEQ      *BLANK                                                      CDL00
     C                   MOVE      'Y'           CDL002            1                           CDL00
     C                   MOVE      *ON           *IN87                                         CDL00
     C                   END                                                                   CDL00
      *                                                                   S01383
      ***  Access SAR details file to see if BRT SAR is installed.        S01383
      *                                                                   S01383
     C                   CALL      'AOSARDR0'                                                  S0138
     C                   PARM      '       '     @RTCD             7                           S0138
     C                   PARM      '*VERIFY'     @OPTN             7                           S0138
     C                   PARM      'S01383'      @SARD             6                           S0138
      *                                                                   S01383
     C     @RTCD         IFEQ      *BLANK                                                      S0138
     C                   MOVE      'Y'           S01383            1                           S0138
     C                   SETON                                        86                       S0138
     C                   END                                                                   S0138
      *                                                                   CRE007
      ** Access SAR details file to see if Base Rate Tax 2001 is ON.      CRE007
      *                                                                   CRE007
     C                   CALL      'AOSARDR0'                                                  CRE00
     C                   PARM      '       '     @RTCD                                         CRE00
     C                   PARM      '*VERIFY'     @OPTN                                         CRE00
     C                   PARM      'CRE007'      @SARD                                         CRE00
      *                                                                   CRE007
      ** If Base Rate Tax 2001 is switched ON output field                CRE007
      ** PSTR - Post 5/4/01 R105.                                         CRE007
      *                                                                   CRE007
     C     @RTCD         IFEQ      *BLANKS                                                     CRE00
     C                   MOVE      *ON           *IN80                                         CRE00
     C                   ENDIF                                                                 CRE00
     C*                                                                   S01383
     C/COPY WNCPYSRC,SD0010PC05
     C*
      *                                                                                       CER001
      ** Check Whether ULX043 is Present or not (Lux Returns)                                 CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX043            1
     C     BGNWST        IFEQ      'Y'
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX043'      @SARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CER001
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'ULX043'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           ULX043
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER001
     C* Access Switchable features file to see if Automatic Customer      S01421
     C* Deletion is installed.                                            S01421
     C*                                                                   S01421
     C                   CALL      'AOSARDR0'                                                  S0142
     C                   PARM      '       '     RTCD1             7                           S0142
     C                   PARM      '*VERIFY'     RTCD2             7                           S0142
     C                   PARM      'S01424'      RTCD3             6                           S0142
     C*                                                                   S01421
     C     RTCD1         IFEQ      *BLANK                                                      S0142
     C                   MOVE      *ON           *IN22                                         S0142
     C                   END                                                                   S0142
     C*                                                                   S01421
     C* Access Switchable features file to see if Additional Customer     S01421
     C* Details is installed.                                             S01421
     C*                                                                   S01421
     C                   CALL      'AOSARDR0'                                                  S0142
     C                   PARM      '       '     RTCDA             7                           S0142
     C                   PARM      '*VERIFY'     RTCDB             7                           S0142
     C                   PARM      'S01425'      RTCDC             6                           S0142
     C*                                                                   S01421
     C     RTCDA         IFEQ      *BLANK                                                      S0142
     C                   MOVE      *ON           *IN23                                         S0142
     C                   END                                                                   S0142
     C*
     C* Access Switchable features file to see if EMU User Defined        CEU014
     C* Correspondence is installed.                                      CEU014
     C*                                                                   CEU014
     C                   CALL      'AOSARDR0'                                                  CEU01
     C                   PARM      '       '     RTCD1                                         CEU01
     C                   PARM      '*VERIFY'     RTCD2                                         CEU01
     C                   PARM      'CEU014'      RTCD3                                         CEU01
     C*                                                                   CEU014
     C* 'Designated In Currency' is only printed if UDC module is on.     CEU014
     C*                                                                   CEU014
     C     RTCD1         IFEQ      *BLANK                                                      CEU01
     C     BGN1ST        ANDEQ     'Y'                                                         CEU01
     C                   MOVE      *ON           *IN70                                         CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                   CDL006
      ** Access Switchable features file, Check if feature CDL006         CDL006
      ** is Switched on.                                                  CDL006
      *                                                                   CDL006
     C                   CALL      'AOSARDR0'                                                  CDL00
     C                   PARM      *BLANKS       PRTCD             7                           CDL00
     C                   PARM      '*VERIFY'     POPTN             7                           CDL00
     C                   PARM      'CDL006'      PSARD             6                           CDL00
     C     SCSARD        PARM      SCSARD        DSSDY                                         CDL00
      *                                                                   CDL006
     C     PRTCD         IFNE      *BLANK                                                      CDL00
     C     PRTCD         ANDNE     '*NRF '                                                     CDL00
     C     *LOCK         IN        LDA                                                         CDL00
     C                   Z-ADD     001           DBASE                          ***************CDL00
     C                   MOVEL     'SCSARDPD'    DBFILE                         **DB ERROR 001*CDL00
     C                   MOVEL     PSARD         DBKEY                          ***************CDL00
     C                   OUT       LDA                                                         CDL00
     C                   EXSR      *PSSR                                                       CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL006
      ** Exhibit printing of DL Fiduciary details if feature is           CDL006
      ** switched on.                                                     CDL006
      *                                                                   CDL006
     C     PRTCD         IFEQ      *BLANK                                                      CDL00
     C                   MOVE      'Y'           CDL006            1                           CDL00
     C                   MOVE      '1'           *IN17                                         CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL008
      ** Access Switchable features file to check if CDL008 is on.        CDL008
      *                                                                   CDL008
     C                   CALL      'AOSARDR0'                                                  CDL00
     C                   PARM      *BLANKS       PRTCD                                         CDL00
     C                   PARM      '*VERIFY'     POPTN                                         CDL00
     C                   PARM      'CDL008'      PSARD                                         CDL00
     C     SCSARD        PARM      SCSARD        DSSDY                                         CDL00
      *                                                                   CDL008
     C     PRTCD         IFNE      *BLANK                                                      CDL00
     C     PRTCD         ANDNE     '*NRF '                                                     CDL00
     C     *LOCK         IN        LDA                                                         CDL00
     C                   Z-ADD     002           DBASE                          ************** CDL00
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DB ERR 002 * CDL00
     C                   MOVEL     'CDL008'      DBKEY                          ************** CDL00
     C                   OUT       LDA                                                         CDL00
     C                   EXSR      *PSSR                                                       CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL008
     C     PRTCD         IFEQ      *BLANK                                                      CDL00
     C                   MOVE      'Y'           CDL008            1                           CDL00
     C                   MOVE      *ON           *IN75                                         CDL00
     C                   ELSE                                                                  CDL00
     C                   MOVE      'N'           CDL008                                        CDL00
     C                   MOVE      *OFF          *IN75                                         CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CSD007
      ** Access switchable features file to check if CSD007 is on         CSD007
      *                                                                   CSD007
     C                   CALL      'AOSARDR0'                                                  CSD00
     C                   PARM      *BLANKS       PRTCD                                         CSD00
     C                   PARM      '*VERIFY'     POPTN                                         CSD00
     C                   PARM      'CSD007'      PSARD                                         CSD00
     C     SCSARD        PARM      SCSARD        DSSDY                                         CSD00
      *                                                                   CSD007
     C     PRTCD         IFNE      *BLANKS                                                     CSD00
     C     PRTCD         ANDNE     '*NRF   '                                                   CSD00
     C     *LOCK         IN        LDA                                                         CSD00
     C                   Z-ADD     002           DBASE                          ************** CSD00
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 02 * CSD00
     C                   MOVEL     PSARD         DBKEY                          ************** CSD00
     C                   OUT       LDA                                                         CSD00
     C                   EXSR      *PSSR                                                       CSD00
     C                   ENDIF                                                                 CSD00
      *                                                                   CSD007
     C     PRTCD         IFEQ      *BLANKS                                                     CSD00
     C                   MOVE      'Y'           CSD007            1                           CSD00
     C                   ELSE                                                                  CSD00
     C                   MOVE      'N'           CSD007                                        CSD00
     C                   ENDIF                                                                 CSD00
     C/COPY WNCPYSRC,SDH00579
      *                                                                                       CSW024
      ** Access Switchable features file, Check if feature CSW024                             CSW024
      ** is Switched on.                                                                      CSW024
      *                                                                                       CSW024
     C                   MOVE      'N'           CSW024            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSW024'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CSW024
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     003           DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     PSARD         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSW024
     C                   MOVE      *ON           *IN18
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CGP001
      ** Check if CGP001 is enabled.                                                          CGP001
      *                                                                                       CGP001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CGP001'      PSARD             6
     C     SCSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CGP001
     C                   MOVE      'N'           CGP001            1
     C                   MOVE      *OFF          *IN68
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGP001
     C                   MOVE      *ON           *IN68
      *                                                                                       CGP001
      ** Open the Global Processing Files.                                                    CGP001
      *                                                                                       CGP001
     C                   EXSR      SRGPOF
      *                                                                                       CGP001
     C                   ELSE
      *                                                                                       CGP001
     C     PRTCD         IFNE      '*NRF'
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CGP001'      DBKEY
     C                   MOVEL     '908'         DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                   CGL018
      ***  Determine if switchable feature CGL018 is activated            CGL018
      *                                                                   CGL018
     C                   CALL      'AOSARDR0'                                                  CGL01
     C                   PARM      *BLANKS       PRTCD             7                           CGL01
     C                   PARM      '*VERIFY'     POPTN             7                           CGL01
     C                   PARM      'CGL018'      PSARD             6                           CGL01
     C     SCSARD        PARM      SCSARD        DSFDY                                         CGL01
      *                                                                   CGL018
     C     PRTCD         IFEQ      *BLANK                                                      CGL01
     C                   MOVE      'Y'           CGL018            1                           CGL01
     C                   SETON                                        81                       CGL01
     C                   ELSE                                                                  CGL01
     C                   MOVE      'N'           CGL018                                        CGL01
     C                   SETOFF                                       81                       CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                                       CLE025
      ** Check if enhancement CLE025 (Multi-Option Facilities) is switched on                 CLE025
      *                                                                                       CLE025
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE025'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CLE025
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     4             DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CLE025'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE025
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      *ON           *IN25
     C                   MOVE      'Y'           CLE025            1
     C                   ELSE
     C                   MOVE      'N'           CLE025            1
     C                   ENDIF
      *                                                                                       CFX001
      ** Check if enhancement CFX001 is installed                                             CFX001
      *                                                                                       CFX001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFX001'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CFX001
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CFX001'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CFX001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFX001            1
     C                   MOVE      *ON           *IN25
     C                   ELSE
     C                   MOVE      'N'           CFX001            1
     C                   ENDIF
      *                                                                                       CFX001
      *                                                                                       CSD025
      ** Check if enhancement CSD025 is installed                                             CSD025
      *                                                                                       CSD025
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD025'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CSD025
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CSD025'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSD025
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD025            1
     C                   MOVE      *ON           *IN72
     C                   ELSE
     C                   MOVE      'N'           CSD025            1
     C                   MOVE      *OFF          *IN72
     C                   ENDIF
      *                                                                                       CSD025
      ** Check if enhancement ULX004 is installed                                             CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'ULX004'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CER001
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'ULX004'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           ULX004            1
     C                   ELSE
     C                   MOVE      'N'           ULX004            1
     C                   ENDIF
      *                                                                                       CSD025
      ** Check if enhancement CSW037A is installed                        CSW037A
      *                                                                   CSW037A
     C                   CALL      'AOSARDR0'                                                  CSW03
     C                   PARM      *BLANKS       PRTCD                                         CSW03
     C                   PARM      '*VERIFY'     POPTN                                         CSW03
     C                   PARM      'CSW037'      PSARD                                         CSW03
     C     SCSARD        PARM      SCSARD        DSSDY                                         CSW03
      *                                                                   CSW037A
     C     PRTCD         IFNE      *BLANKS                                                     CSW03
     C     PRTCD         ANDNE     '*NRF   '                                                   CSW03
     C     *LOCK         IN        LDA                                                         CSW03
     C                   Z-ADD     5             DBASE                                         CSW03
     C                   MOVEL     'SCSARDPD'    DBFILE                                        CSW03
     C                   MOVEL     'CSW037'      DBKEY                                         CSW03
     C                   OUT       LDA                                                         CSW03
     C                   EXSR      *PSSR                                                       CSW03
     C                   ENDIF                                                                 CSW03
      *                                                                   CSW037A
     C     PRTCD         IFEQ      *BLANKS                                                     CSW03
     C                   MOVE      'Y'           CSW037            1                           CSW03
     C                   MOVE      *ON           *IN73                                         CSW03
     C                   ELSE                                                                  CSW03
     C                   MOVE      'N'           CSW037                                        CSW03
     C                   MOVE      *OFF          *IN73                                         CSW03
     C                   ENDIF                                                                 CSW03
      *                                                                   CSW037A
      ** Access switchable features file to check if CSD029 is on                             CSD029
      *                                                                                       CSD029
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD029'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CSD029
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD029            1
     C                   ELSE
     C                   MOVE      'N'           CSD029
     C                   ENDIF
      ** Access Switchable features file to see if Automatic Exchange                         CGL032
      ** of Information CGL032 is installed.                                                  CGL032
      *                                                                                       CGL032
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL032'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CGL032
      ** DB Error Management.                                                                 CGL032
      *                                                                                       CGL032
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     007           DBASE                          **************
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 06 *
     C                   MOVEL     PSARD         DBKEY                          **************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGL032
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL032            1
     C                   ELSE
     C                   MOVE      'N'           CGL032
     C                   ENDIF
      *                                                                                       CGL032
      ** Check CSW207 feature                                                                 CSW207
     C                   CALL      'SWIF2007'
     C                   PARM      '       '     PRTCD
     C********** PRTCD     IFEQ 'CSW207'                                             CSW207 BUG14933
     C     PRTCD         IFEQ      'CSW2007'
     C                   MOVEL     'Y'           CSW207            1
     C                   ELSE
     C                   MOVEL     'N'           CSW207
     C                   ENDIF
      ** Check CGL031 feature                                                                 CSW207
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL031'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CSW207
      ** DB Error Management.                                                                 CSW207
      *                                                                                       CSW207
     C                   MOVEL     'N'           CGL031            1
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     008           DBASE                          **************
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 08 *
     C                   MOVEL     PSARD         DBKEY                          **************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     'Y'           CGL031
     C                   ENDIF
      *                                                                                       CSW207
     C     CSW207        IFEQ      'Y'
     C                   SETON                                        35
     C                   ELSE
     C                   SETOFF                                       35
     C                   ENDIF
      *                                                                                       CSW207
     C     CGL031        IFEQ      'Y'
     C     CGL032        ANDEQ     'Y'
     C                   SETON                                        36
     C                   ELSE
     C                   SETOFF                                       36
     C                   ENDIF
      *                                                                                      CER034A
      ** Access switchable features file to check if CER034 is on                            CER034A
      *                                                                                      CER034A
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER034'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                      CER034A
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER034            1
     C                   ELSE
     C                   MOVE      'N'           CER034
     C                   ENDIF
      *                                                                                      CER034A
      ** Access switchable features file to check if CER038 is on                            CER034A
      *                                                                                      CER034A
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER038'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                      CER034A
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER038            1
     C                   ELSE
     C                   MOVE      'N'           CER038
     C                   ENDIF
      *                                                                                      CER034A
      ** Access switchable features file to check if CER041 is on                            CER034A
      *                                                                                      CER034A
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER041'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                      CER034A
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER041            1
     C                   ELSE
     C                   MOVE      'N'           CER041
     C                   ENDIF
      *                                                                                      CER034A
      ** Access switchable features file to check if CER047 is on                            CER034A
      *                                                                                      CER034A
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER047'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                      CER034A
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER047            1
     C                   ELSE
     C                   MOVE      'N'           CER047
     C                   ENDIF
      *                                                                                      CER034A
      ** Access switchable features file to check if CER048 is on                            CER034A
      *                                                                                      CER034A
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER048'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                      CER034A
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER048            1
     C                   ELSE
     C                   MOVE      'N'           CER048
     C                   ENDIF
      *                                                                                       CER054
      ** Access switchable features file to check if CER054 is on                             CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER054'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CER054
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER054            1
     C                   ELSE
      *                                                                                       CER054
      ** DB Error Management.                                                                 CER054
      *                                                                                       CER054
     C                   MOVEL     'N'           CER054
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     009           DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     PSARD         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER054
     C                   ENDIF
      *                                                                                      CER034A
      ** Access switchable features file to check if CER045 is on                             CER045
      *                                                                                       CER045
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER045'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CER045
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER045            1
     C                   ELSE
     C                   MOVE      'N'           CER045
     C                   ENDIF
      *                                                                                       CER045
      ** Set Display Indicators                                                              CER034A
      *                                                                                      CER034A
     C     CER034        IFEQ      'Y'
     C                   MOVE      *ON           *IN51
     C                   ELSE
     C                   MOVE      *OFF          *IN51
     C                   ENDIF
      *                                                                                      CER034A
     C     CER038        IFEQ      'Y'
     C                   MOVE      *ON           *IN52
     C                   ELSE
     C                   MOVE      *OFF          *IN52
     C                   ENDIF
      *                                                                                      CER034A
     C     CER041        IFEQ      'Y'
     C                   MOVE      *ON           *IN53
     C                   ELSE
     C                   MOVE      *OFF          *IN53
     C                   ENDIF
      *                                                                                      CER034A
     C     CER047        IFEQ      'Y'
     C                   MOVE      *ON           *IN56
     C                   ELSE
     C                   MOVE      *OFF          *IN56
     C                   ENDIF
      *                                                                                      CER034A
     C     CER048        IFEQ      'Y'
     C                   MOVE      *ON           *IN57
     C                   ELSE
     C                   MOVE      *OFF          *IN57
     C                   ENDIF
      *                                                                                       CER054
     C     CER054        IFEQ      'Y'
     C                   MOVE      *ON           *IN58
     C                   ELSE
     C                   MOVE      *OFF          *IN58
     C                   ENDIF
      *                                                                                       CER045
     C     CER045        IFEQ      'Y'
     C                   MOVE      *ON           *IN59
     C                   ELSE
     C                   MOVE      *OFF          *IN59
     C                   ENDIF
      *                                                                                      CER034A
      ** Check if SWIFT Changes 2013 (CSW213) is installed                                    CSW213
      *                                                                                       CSW213
     C                   MOVE      'N'           CSW213            1
     C                   MOVE      *OFF          *IN37
      *                                                                                       CSW213
     C                   CALL      'SWIF2013'
     C                   PARM      *BLANKS       PRTCD
      *                                                                                       CSW213
     C     PRTCD         IFEQ      'CSW2013'
     C                   MOVE      'Y'           CSW213
     C                   MOVE      *ON           *IN37
     C                   ENDIF
      *                                                                                       CSW213
      ** Check if feature CFT050 is installed                                                 CSW213
      *                                                                                       CSW213
     C                   MOVE      'N'           CFT050            1
     C                   MOVE      *OFF          *IN38
      *                                                                                       CSW213
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT050'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CSW213
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFT050
     C                   MOVE      *ON           *IN38
     C                   ENDIF
      *                                                                                       CGL177
      ** Access Switchable features file to see if CRS Reporting is installed.                CGL177
      *                                                                                       CGL177
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL157'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CGL177
      ** DB Error Management.                                                                 CGL177
      *                                                                                       CGL177
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     009           DBASE                          **************
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 09 *
     C                   MOVEL     PSARD         DBKEY                          **************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGL177
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL157            1
     C***                  MOVE '1'       *IN20                                               CGL177
     C                   ELSE
     C                   MOVE      'N'           CGL157
     C***                  MOVE '0'       *IN20                                               CGL177
     C                   ENDIF
      *                                                                                       CER073
      ** Access switchable features file to check if CER073 is on                             CER073
      *                                                                                       CER073
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER073'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CER073
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER073            1
     C                   ELSE
     C                   MOVE      'N'           CER073
     C                   ENDIF
      *                                                                                       CER073
     C     CER073        IFEQ      'Y'
     C                   MOVE      '1'           *IN64
     C                   ELSE
     C                   MOVE      '0'           *IN64
     C                   ENDIF
      *                                                                                       CSW213
      ** Access switchable features file to check if CER050 is on                             CER050
      *                                                                                       CER050
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER050'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CER050
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER050            1
     C                   MOVE      *ON           *IN20
     C                   ELSE
     C                   MOVE      'N'           CER050
     C                   MOVE      *OFF          *IN20
     C                   ENDIF
      *                                                                                       CER050
      ** Check if feature CER076 is installed                                                 CER076
      *                                                                                       CER076
     C                   MOVE      'N'           CER076            1                          CER076
     C                   MOVE      *OFF          *IN48                                        CER076
      *                                                                                       CER076
     C                   CALL      'AOSARDR0'                                                 CER076
     C                   PARM      *BLANKS       PRTCD                                        CER076
     C                   PARM      '*VERIFY'     POPTN                                        CER076
     C                   PARM      'CER076'      PSARD                                        CER076
     C     SCSARD        PARM      SCSARD        DSSDY                                        CER076
      *                                                                                       CER076
     C     PRTCD         IFEQ      *BLANKS                                                    CER076
     C                   MOVE      'Y'           CER076                                       CER076
     C                   OPEN      SDACUSY0                             99                    CER076
     C                   MOVE      *ON           *IN48                                        CER076
     C                   ENDIF                                                                CER076
      *                                                                                       CER076
     C/COPY WNCPYSRC,SD0010PC33
     C*                                                                   CEU014
      * Move title to header - *Standard header/footer  *
     C* 7.10.89 Missing Source - Inserted During Incorporation            S01216
     C* Move User Report Title into Header Field in DDS for PRTF          S01216
     C*                                                                   S01216
     C*********************MOVE #IURPT    ##AGNA                   S01216 S01229
     C                   MOVE      WUURPT        ##URPT                                 S01216 S0122
      * Get Narrative Title - Narrative Codes  *
     C     *IN99         IFEQ      '1'
     C                   MOVE      1             UIND              1 0
     C                   SETOFF                                           99
     C                   ELSE
     C                   MOVE      0             UIND
     C                   END
      *
      ** CALCULATE END OF TEXT POINT
     C                   Z-ADD     1             U                 2 0
     C*********************MOVEA#IBINA    UAR,U
     C                   MOVEA     @CN(13)       UAR(U)
     C/COPY WNCPYSRC,SD0010PC36
     C*
     C     *IN99         DOWEQ     '0'
     C     ' '           LOOKUP    UAR(U)                                 99
     C                   ADD       1             U
     C     UAR(U)        COMP      ' '                                    99
     C                   END
      *
     C**
     C*
     C*          P1LSST    IFEQ 'A'                                       S01216
     C***********P1NEST    IFEQ 'A'                                S01216 S01117
     C     P1ARSI        IFEQ      'A'                                                         S0111
     C*********************MOVELUARRAY,1  UTEMP  26                       LN0536
     C                   MOVEL     UARRAY(1)     UTEMP            53                           LN053
     C                   MOVEA     UTEMP         UAR(U)
     C                   ADD       26            U
     C                   ELSE
      *
     C                   MOVEL     UARRAY(2)     UTEMP                                         LN053
     C*********************MOVEAUARRAY,2  UAR,U            * IF A THIRD   LN0536
     C                   MOVEA     UTEMP         UAR(U)                         * IF A THIRD   LN053
     C                   ADD       7             U                              OPTION TO ARRAY
     C                   END                                                    IS ADDED A
      *                                                    TEMP STORAGE
      *                                                    * IS REQUIRED.
      **  STORE  TEXT IN USTORE FIELD
      *
     C                   MOVEA     UAR           USTORE           53
     C                   MOVE      *BLANKS       UAR
      *
      *
      *
     C     53            SUB       U             UB                2 0
     C     UB            DIV       2             UB
     C                   MVR                     UR                1 0
     C     UB            ADD       U             U
     C     U             SUB       1             U
      *
      *
      **  INSERT UNDERLINE TO ARRAY
      **
     C                   MOVEA     *ALL'-'       ULN(UB)
     C                   MOVEA     *BLANKS       ULN(U)
      *
      *
     C     UB            IFGT      0
     C                   MOVEA     USTORE        UAR(UB)
     C                   ELSE
     C                   MOVEA     USTORE        UAR
     C                   END
      *
      **  MOVE ARRAY VALUE  TO SCREEN TEXT FIELD
      *
     C*                    MOVEAUAR       ##EYTX                          S01216
     C*********************MOVEAUAR       ##E8TX 53                 S01216S01117
     C                   MOVEA     UAR           ##AURT           53                     S01216S0111
     C*
     C/COPY WNCPYSRC,SD0010PC18
     C*
     C*                    MOVEAUAR       WUEYTX
     C*********************MOVEAUAR       WUE8TX                          S01117
     C                   MOVEA     UAR           WUAURT                                        S0111
     C*                    MOVEAULN       ##BJNA                          S01216
     C                   MOVEA     ULN           ##BJNA           53                           S0121
     C                   MOVEA     ULN           WUBJNA
      *
      *
      ** RESET INDICATOR *IN 99
      *
     C     UIND          IFEQ      1
     C                   SETON                                            99
     C                   ELSE
     C                   SETOFF                                           99
     C                   END
      *
      * ZSFILE - log spool file - Standard Functions  *
     C*
     C* Set up spool file number - Standard Functions  *
     C                   Z-ADD     @$FNB         WUSFNB
     C                   MOVE      *BLANKS       UUSRSQ            5                           LN072
     C*
     C* ZSFILE - write report rqs - Standard Functions  *
     C                   CALL      'ZSFILE'                             90      ZSFILE - write
     C*********************PARM #IRSQN    UURSQN  5        RCF sequence nuLN0721
     C     UUSRSQ        PARM      P2RSQN        UURSQN            5            RCF sequence nuLN072
     C                   PARM      P4ENTY        UUENTY            3            Entity
     C                   PARM      @$FVN         UUSFNM           10            Spool file name
     C                   PARM      WUSFNB        UUSFNB            6 0          Spool file numb
     C     WUZSER        PARM      *BLANK        UUZSER            1            ZSFILE error
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
     C*
     C* CASE: WRK.ZSFILE is error occurred
     C*
     C*          #OZSER    IFEQ 'Y'
     C*                    MOVEL'Y2U0004' P0RTN
     C*                    EXSR ZYEXPG
     C*                    END
      *CASE:     WRK.ZSFILE error is Error Occured
     C     WUZSER        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     @CN(14)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     @CN(01)       WUMFTS                         S01212
      *CASE:     WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 00/Copy Member SD0010PIPG - Client Details  *
     C/COPY WNCPYSRC,SD0010PCPG
      *                                                                                      LLN022A
      ** Define work field Yellow book feature ind                                           LLN022A
      *                                                                                      LLN022A
     C                   MOVEL     *BLANK        LLN007            1
      *                                                                                      LLN022A
      ** Check to see if Yellow book changes (LLN007) is switched on.                        LLN022A
      *                                                                                      LLN022A
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'LLN007'      PSARD
      *                                                                                      LLN022A
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           LLN007
     C                   ENDIF
      *                                                                                      LLN022A
     C                   END                                                    *FI
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT                                                              CDL006
     C/COPY WNCPYSRC,SD0010PC07
      *****************************************************************   CDL006
      *                                                               *   CDL006
      * *PSSR    - TO PROCESS DATA BASE ERRORS                        *   CDL006
      *                                                               *   CDL006
      *****************************************************************   CDL006
      *                                                                   CDL006
     C     *PSSR         BEGSR                                                                 CDL00
     C     WRUN          IFEQ      *BLANK                                                      CDL00
     C                   MOVE      'Y'           WRUN              1                           CDL00
     C                   DUMP                                                                  CDL00
     C                   END                                                                   CDL00
      *                                                                   CDL006
     C                   MOVE      '1'           *INU7                                         CDL00
     C                   MOVE      '1'           *INU8                                         CDL00
     C                   MOVE      '1'           *INLR                                         CDL00
     C                   RETURN                                                                CDL00
     C                   ENDSR                                                                 CDL00
      *****************************************************************   CDL006
      * RWA       : Output RWA information from SDCRWAPD                * CGL018
      * ---                                                             * CGL018
      * Called By : CAPRDT                                              * CGL018
      * Calls     : None                                                * CGL018
      ******************************************************************* CGL018
     C     RWADTL        BEGSR                                                                 CGL01
      *                                                                   CGL018
     C     XRCUST        SETLL     SDCRWAD0                                                    CGL01
     C     XRCUST        READE     SDCRWAD0                               82                   CGL01
     C                   MOVE      *BLANKS       XRWA                                          CGL01
     C                   MOVEL     *BLANKS       XRWASE                                        CGL01
     C                   MOVEL     *BLANKS       RWASEC                                        CGL01
     C                   MOVEL     *BLANKS       #CONTI                                        CGL01
     C                   Z-ADD     0             U                 2 0                         CGL01
     C     *IN82         DOWEQ     '0'                                                         CGL01
      *                                                                   CGL018
      * Only live records                                                 CGL018
      *                                                                   CGL018
     C     RWRECI        IFNE      '*'                                                         CGL01
     C                   ADD       1             U                                             CGL01
     C                   MOVE      RWCODE        #RCODE                                        CGL01
     C                   MOVE      RWSETN        #RSET                                         CGL01
      *                                                                   CGL018
     C     U             IFGT      18                                                          CGL01
     C     #CONTI        ANDNE     'C'                                                         CGL01
     C                   Z-ADD     1             U                                             CGL01
     C                   MOVEL     'C'           #CONTI            1                           CGL01
     C                   MOVEL     *BLANKS       XRWASE                                        CGL01
     C                   MOVEA     XRWA          XRWASE                                        CGL01
     C                   MOVE      *BLANKS       XRWA                                          CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                   CGL018
     C                   MOVEA     RWSECO        XRWA(U)                                       CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                   CGL018
     C     BBCUST        READE     SDCRWAD0                               82                   CGL01
     C                   ENDDO                                                                 CGL01
      *                                                                   CGL018
      *                                                                   CGL018
     C     U             IFEQ      0                                                           CGL01
     C                   MOVEL     'None'        XRWASE                                        CGL01
     C                   ELSE                                                                  CGL01
      *                                                                   CGL018
      * Last one must be without comma, so clear and output again         CGL018
      *                                                                   CGL018
     C                   MOVEL     *BLANKS       #COMMA                                        CGL01
     C                   MOVEA     RWSECO        XRWA(U)                                       CGL01
      *                                                                   CGL018
     C     #CONTI        IFEQ      'C'                                                         CGL01
     C                   MOVEA     XRWA          RWASEC                                        CGL01
     C                   ELSE                                                                  CGL01
     C                   MOVEA     XRWA          XRWASE                                        CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                   CGL018
     C                   MOVEL     ','           #COMMA                                        CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                   CGL018
     C                   ENDSR                                                                 CGL01
      ******************************************************************* CGL018
      *****************************************************************                       CER073
      * SRANAC    : Output AnaCredit Reporting from SDANACQD            *                     CER073
      * ---                                                             *                     CER073
      * Called By : CAPRDT                                              *                     CER073
      * Calls     : None                                                *                     CER073
      *******************************************************************                     CER073
     C     SRANAC        BEGSR
      *                                                                                       CER073
     C                   MOVE      *BLANKS       R2HOID
     C                   MOVE      *BLANKS       R2UPID
     C                   MOVE      *BLANKS       R2SOLP
     C                   MOVE      *BLANKS       R2DTLP
     C                   MOVE      *BLANKS       R2ENTS
     C                   MOVE      *BLANKS       R2DTES
     C                   MOVE      *BLANKS       R2NOEM
     C                   MOVE      *BLANKS       R2BALS
     C                   MOVE      *BLANKS       R2ANTU
     C                   MOVE      *BLANKS       R2ASTD
     C**********           MOVE *BLANKS   R2FNAM                                      CER073 CER073D
     C                   MOVE      *BLANKS       R2FNM1
     C                   MOVE      *BLANKS       R2FNM2
     C                   MOVE      *BLANKS       R2FNM3
     C                   MOVE      *BLANKS       R2FNM4
     C**********           MOVE *BLANKS   R2LNAM                                      CER073 CER073D
     C                   MOVE      *BLANKS       R2LNM1
     C                   MOVE      *BLANKS       R2LNM2
     C                   MOVE      *BLANKS       R2LNM3
     C                   MOVE      *BLANKS       R2LNM4
     C**********           MOVE *BLANKS   R2STRT                                      CER073 CER073D
     C                   MOVE      *BLANKS       R2STR1
     C                   MOVE      *BLANKS       R2STR2
     C                   MOVE      *BLANKS       R2NUMB
     C**********           MOVE *BLANKS   R2TOWN                                      CER073 CER073D
     C                   MOVE      *BLANKS       R2TWN1
     C                   MOVE      *BLANKS       R2TWN2
     C                   MOVE      *BLANKS       R2POST
     C                   MOVE      *BLANKS       R2REGN
     C                   MOVE      *BLANKS       R2CTRY
     C**********           MOVE *BLANKS   R2LEGF                                     CER073A CER073D
     C                   MOVE      *BLANKS       R2LGF1
     C                   MOVE      *BLANKS       R2LGF2
     C                   MOVE      *BLANKS       R2LGF3
      *                                                                                       CER073
     C     KANAC         KLIST
     C                   KFLD                    BBBRCD
     C                   KFLD                    BBCUST
     C     KANAC         CHAIN     SDANACI1                           09
      *                                                                                       CER073
     C     *IN09         IFEQ      *OFF
      *                                                                                       CER073
      ** AnaCredit Reporting                                                                  CER073
      *                                                                                       CER073
     C                   MOVE      ACHOID        R2HOID
     C                   MOVE      ACUPID        R2UPID
     C                   MOVE      ACSOLP        R2SOLP
     C                   MOVE      ACENTS        R2ENTS
     C                   MOVE      ACNOEM        R2NOEM
     C                   MOVE      ACBALS        R2BALS
     C                   MOVE      ACANTU        R2ANTU
     C                   MOVE      ACASTD        R2ASTD
     C**********           MOVE ACFNAM    R2FNAM                                      CER073 CER073D
     C                   MOVE      ACFNAM        RFNAME
     C**********           MOVE ACLNAM    R2LNAM                                      CER073 CER073D
     C                   MOVE      ACLNAM        RLNAME
     C**********           MOVE ACSTRT    R2STRT                                      CER073 CER073D
     C                   MOVE      ACSTRT        RSTRET
     C                   MOVE      ACNUMB        R2NUMB
     C**********           MOVE ACTOWN    R2TOWN                                      CER073 CER073D
     C                   MOVE      ACTOWN        RTOWN
     C                   MOVE      ACPOST        R2POST
     C                   MOVE      ACREGN        R2REGN
     C                   MOVE      ACCTRY        R2CTRY
     C**********           MOVE ACLEGF    R2LEGF                                     CER073A CER073D
     C                   MOVE      ACLEGF        RLEGF
      *                                                                                       CER073
      ** Convert Date of initiation of legal proceedings to DDMMMYY                           CER073
      *                                                                                       CER073
     C     ACDTLP        IFEQ      0
     C                   MOVE      *BLANK        R2DTLP
     C                   ELSE
     C                   MOVE      ACDTLP        ZDAYNO
      *                                                                                       CER073
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
      *                                                                                       CER073
     C                   MOVE      ZADATE        R2DTLP
     C                   ENDIF
      *                                                                                       CER073
      ** Convert Date of Enterprise Size to DDMMMYY                                           CER073
      *                                                                                       CER073
     C     ACDTES        IFEQ      0
     C                   MOVE      *BLANKS       R2DTES
     C                   ELSE
     C                   MOVE      ACDTES        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
      *                                                                                       CER073
     C                   MOVE      ZADATE        R2DTES
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      /EJECT                                                                                  CSD029
     *******************************************************************                      CSD029
      *                                                                *                      CSD029
      *  SRFMTF - Suboutine to format fields                            *                     CSD029
      *                                                                 *                     CSD029
      *******************************************************************                     CSD029
     C     SRFMTF        BEGSR
      *                                                                                       CSD029
     C                   CALL      'AOSVALR0'
     C                   PARM                    PRTCD
     C                   PARM      @VAL01        PVALK1           20
     C                   PARM                    PVAL1           200
     C                   PARM      @VAL02        PVALK2           20
     C                   PARM                    PVAL2           200
     C                   PARM      @VAL03        PVALK3           20
     C                   PARM                    PVAL3           200
     C                   PARM      @VAL04        PVALK4           20
     C                   PARM                    PVAL4           200
     C                   PARM      @VAL05        PVALK5           20
     C                   PARM                    PVAL5           200
     C                   PARM      @VAL06        PVALK6           20
     C                   PARM                    PVAL6           200
     C                   PARM      @VAL07        PVALK7           20
     C                   PARM                    PVAL7           200
     C                   PARM      @VAL08        PVALK8           20
     C                   PARM                    PVAL8           200
     C                   PARM      @VAL09        PVALK9           20
     C                   PARM                    PVAL9           200
     C                   PARM      @VAL10        PVALK0           20
     C                   PARM                    PVAL10          200
      *                                                                                       CSD029
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CSD029
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN33
     C                   MOVE      *OFF          *IN34
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN36
     C                   MOVE      *OFF          *IN37
     C                   MOVE      *OFF          *IN38
     C                   MOVE      *OFF          *IN39
     C                   MOVE      *OFF          *IN40
      *                                                                                       CSD029
     C                   SELECT
     C     PVAL1         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN31
     C     PVAL2         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN32
     C     PVAL3         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN33
     C     PVAL4         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN34
     C     PVAL5         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN35
     C     PVAL6         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN36
     C     PVAL7         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN37
     C     PVAL8         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN38
     C     PVAL9         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN39
     C     PVAL10        WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN40
     C                   ENDSL
      *                                                                                       CSD029
     C     25            SUBST     PVAL1:1       A5FLT1
     C                   MOVEL     E5FL01        A5FL01
     C     25            SUBST     PVAL2:1       A5FLT2
     C                   MOVEL     E5FL02        A5FL02
     C     25            SUBST     PVAL3:1       A5FLT3
     C                   MOVEL     E5FL03        A5FL03
     C     25            SUBST     PVAL4:1       A5FLT4
     C                   MOVEL     E5FL04        A5FL04
     C     25            SUBST     PVAL5:1       A5FLT5
     C                   MOVEL     E5FL05        A5FL05
     C     25            SUBST     PVAL6:1       A5FLT6
     C                   MOVEL     E5FL06        A5FL06
     C     25            SUBST     PVAL7:1       A5FLT7
     C                   MOVEL     E5FL07        A5FL07
     C     25            SUBST     PVAL8:1       A5FLT8
     C                   MOVEL     E5FL08        A5FL08
     C     25            SUBST     PVAL9:1       A5FLT9
     C                   MOVEL     E5FL09        A5FL09
     C     25            SUBST     PVAL10:1      A5FLT0
     C                   MOVEL     E5FL10        A5FL00
      *                                                                                       CSD029
     C                   ENDIF
      *                                                                                       CSD029
     C                   ENDSR
      *                                                                                       CSD029
      *****************************************************************   CDL006
     O/COPY WNCPYSRC,SD0010POPG
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA UARRAY
MAINTENANCE - AUDIT REPORT
LISTING
**CTDATA @CN
Y
A
I
N
D
***DELETED***
0
SDCUSTPD
Y2U0005
SD0010AU
BANK
SDBANKPD
CLIENT DETAILS
Y2U0004
Release                                                                   CSD007
Close                                                                     CSD007
***CLOSED***                                                              CSD007
INACTIVE                                                                  CSD025A
**CTDATA ZMNM
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**CTDATA TABM
JAN01FEB02MAR03APR04MAY05JUN06JUL07AUG08SEP09OCT10NOV11DEC12                                  262205
**CTDATA OVRC
OVRDBF FILE(GPCSTXL1) TOFILE(GPCUSTXL1)                                                       CGP001

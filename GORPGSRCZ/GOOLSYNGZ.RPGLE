     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBIA*  OVRDBF FILE(GOOSJSPDN) TOFILE(GOOSJSPD) SHARE(*NO)           *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO On-line synch. of global layer')              *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOOLSYNGZ - On-Line Synchronisation of Global Layer          *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CLE070             Date 19Jun19               *
      *  Prev Amend No. MD054605           Date 17Oct19               *
      *                 CSD101             Date 07Dec18               *
      *                 MD050212           Date 02Apr18               *
      *                 CLE071             Date 18Jul18               *
      *                 MD050231           Date 25Mar18               *
      *                 MD046248           Date 27Oct17               *
      *                 CER073B            Date 25Sep17               *
      *                 CER073A            Date 05Sep17               *
      *                 CER073             Date 10Jul17               *
      *                 MD046901           Date 21Jul17               *
      *                 CLE068             Date 02Aug16               *
      *                 MD035554           Date 25May16               *
      *                 CGL052             Date 02Dec15               *
      *                 MD029739           Date 15Aug14               *
      *                 MD033486           Date 27Feb15               *
      *                 MD031974           Date 16Jan15               *
      *                 CAP212             Date 15Sep14               *
      *                 CGL158             Date 22Aug14               *
      *                 CRE101             Date 27Aug14               *
      *                 CLE164             Date 18Aug14               *
      *                 CTI006             Date 31Mar14               *
      *                 MD027208           Date 28May14               *
      *                 CGL155             Date 19Mar14               *
      *                 CGL153             Date 05Feb14               *
      *                 MD025828           Date 05May14               *
      *                 MD026518           Date 30Apr14               *
      *                 CGL132             Date 01May13               *
      *                 CSD092             Date 01May13               *
      *                 CSD093             Date 01Apr13               *
      *                 MD024772           Date 03Feb14               *
      *                 MD024513           Date 23Jan14               *
      *                 MD022168           Date 12Sep13               *
      *                 MD024245           Date 07Jan14               *
      *                 MD023837           Date 27Nov13               *
      *                 CGL135B            Date 30Oct13               *
      *                 CGL145B            Date 30Oct13               *
      *                 CGL135A            Date 10Jul13               *
      *                 CGL145A            Date 08Oct13               *
      *                 CGL145             Date 10Jul13               *
      *                 AR1096788          Date 18Mar13               *
      *                 CMG003             Date 04Oct12               *
      *                 CGP017             Date 06Aug12               *
      *                 AR1048651          Date 07Feb13               *
      *                 CAP210             Date 28Sep12               *
      *                 CLE134             Date 01Aug12               *
      *                 CSC054             Date 23Feb12               *
      *                 CFT045             Date 04Aug11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CSD090             Date 06Dec10               *
      *                 CAP208             Date 06Dec10               *
      *                 AR751852           Date 02May11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26779           Date 27Nov09               *
      *                 CER045             Date 20Jul09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22529           Date 11Feb09               *
      *                 CER048             Date 19May08               *
      *                 BUG27973           Date 06Aug10               *
      *                 BUG27844A          Date 15Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27288           Date 07Apr10               *
      *                 CAP205             Date 23Mar10               *
      *                 CAP202             Date 10Feb10               *
      *                 CAP204             Date 20Jan10               *
      *                 CAP191             Date 26Nov09               *
      *                 261610             Date 03Sep09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG18050           Date 28Apr08               *
      *                 BUG16177A          Date 08Apr08               *
      *                 ME246418           Date 15Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239452             Date 28Apr06               *
      *                 CRE024             Date 22Dec05               *
      *                 BG7655             Date 27JUn05               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG9684            Date 20Dec05               *
      *                 BUG10215           Date 27Sep06               *
      *                 CLE106             Date 01Aug04               *
      *                 CAS011             Date 16May05               *
      *                 CDL038             Date 10May05               *
      *                 BG7655             Date 27JUn05               *
      *                 CGP010             Date 17Jan05               *
      *                 CLE041             Date 11Oct04               *
      *                 BUG3644            Date 12Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 BG2755             Date 19May04               *
      *                 BG1364             Date 04Mar04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE070 - Manual Diary (Recompile)                            *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  CSD101 - Password Encryption (Recompile)                     *
      *  MD050212 - Replication processing for SDCUSTXC (Recompile)   *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD050231 - Failed global replication process during switchon *
      *  MD046248 - Finastra Rebranding                               *
      *  CER073B - CER073 Change Control 2 (Recompile)                *
      *  CER073A - CER073 Change Control 1 (Recompile)                *
      *  CER073 - AnaCredit Reporting (Recompile)                     *
      *  MD046901 - Batch details listview is not loading in the      *
      *             other zone (Recompile)                            *
      *  CLE068 - Loan Event Modeller (Recompile)                     *
      *  MD035554 - 2o'clock/ABC compatibility (Recompile)            *
      *  CGL052 - Amend Washout Processing (Recompile)                *
      *  MD029739 - File renaming for integration layer. (Recompile)  *
      *  MD033486 - Add new Beneficiary Account field (Recompile)     *
      *  MD031974 - Failed COB Component GOC0100 seq 002234 due to    *
      *             field mismatch. (Recompile)                       *
      *  CAP212 - FT Nostro Transfer API (Recompile)                  *
      *            Recompile due to changes in GPZOLSYNSR and         *
      *            GPZOLSYNWH.                                        *
      *  CGL158 - Nostro Sweeping Rules Maintenance (Recompile)       *
      *  CRE101 - Interim Interest Statements on a Frequency          *
      *            Recompile due to changes in GPZOLSYNSR and         *
      *            GPZOLSYNWH.                                        *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  CTI006   - Trade Finance BF Midas 2.2 Interface (Recompile)  *
      *  MD027208 - RT Postings not incldued in Nostro Group totals   *
      *             (Recompile)                                       *
      *  CGL155 - Forecast Group Limits                               *
      *           (Recompile due to changes in GPZOLSYNSR/GPZOLSYNWH) *
      *  CGL153 - Estimated Exchange Rate                             *
      *            Recompile due to changes in GPZOLSYNSR and         *
      *            GPZOLSYNWH.                                        *
      *  MD025828 - [ENGINEERING] Listview of Maintain Customer       *
      *             (Recompile)                                       *
      *  MD026518 - Incorrect drop down selection in US indicia       *
      *             (Recompile)
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CSD092 - Account Review (Recompile)                          *
      *  CSD093 - Document Management (Recompile)                     *
      *  MD024772 - Problems with Accounting Interface postings and   *
      *             enquiries. (Recompile)                            *
      *  MD024513 - Add Description field (30A) to the Accounting     *
      *             Rules. (Recompile)                                *
      *  MD022168 - GZMEBIB3PD Replication (Recompile)                *
      *  MD024245 - GOOLYNGZ startup failed (Recompile)               *
      *  MD023837 - Triggers on tables GLACMNTD, GLACBHTD, GLACBDTD   *
      *             failed (Recompile)                                *
      *  CGL135B - Accounting Rules Process (Recompile)               *
      *  CGL145B - Subsidiaries Daily Sweeping Forecast               *
      *            Recompile due to changes in GPZOLSYNSR and         *
      *            GPZOLSYNWH.                                        *
      *  CGL135A - Accounting Rules Process                           *
      *            Recompile due to changes in GPZOLSYNSR and         *
      *            GPZOLSYNWH.                                        *
      *  CGL145A - Subsidiaries Daily Sweeping Forecast (Drop 2).     *
      *            Recompile due to changes in GLFORITD/GLFORTTD.     *
      *  CGL145 - Subsidiaries Daily Sweeping Forecast (Recompile)    *
      *  AR1096788 - DLAA details should be written in core STRANF    *
      *              file instead of the new DLSTRANFPD file          *
      *              (Recompile)                                      *
      *  CMG003 - SWIFT MT600 Message Generation (Recompile)          *
      *  CGP017 - Global Layer - GOC0100 Task Split (Recompile)       *
      *  AR1048651 - TRADSDX1 global replication (Child:AR1048654)    *
      *              (Recompile)                                      *
      *  CAP210 - Adjustment to Accrued Interests API (Recompile)     *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSC054 - Period End Adjustments (Recompile)                  *
      *  CFT045 - Outgoing Payments - Extended Settlement Instructions*
      *           (Recompile)                                         *
      *  CSF011 - Customer Name on Inputs (Recompile)                 *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD090 - Customer Segmentation (Recompile)                   *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  AR751852 - No posting made in Account Movement Enquiry and   *
      *             PABE after COB (Child: AR751853) (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26779 - Change request on GSART table (Recompile)         *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  BUG27973 - No section for Blocked Collateral (Recompile)     *
      *  BUG27844A - Incorrect 'from date' default from SOAP enquiry  *
      *           (Recompile)                                         *
      *  BUG27288 - A serios Midas error has occured message comes    *
      *             up when completing insert for Batch Details       *
      *             in GL - JRNE (Recompile)                          *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CAP202 - Retail Account Balance Enquiry (Recompile)          *
      *  CAP204 - Retail Account Transfer (Recompile)                 *
      *  CAP191 - MQ Enabling of FUND and EXTR APIs (Recompile)       *
      *  261610 - Recompile due to changes in the copy source         *
      *           GPZOLSYNSR and GPZOLSYNWH.                          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG18050 - Collateral by facility enquiry displaying CAV     *
      *             and CLV as zero (Recompile)                       *
      *  BUG16177A- Background job EQ_ONL_SYN is not working          *
      *  246418 - CGL013 changes for Midas Plus                       *
      *           Recompile due to changes in GPZOLSYNWH & GPZOLSYNSR *
      *  239452 - Recompiled over correct copy source version.        *
      *  CRE024 - Restricted Account                                  *
      *           Recompile due to changes in GPZOLSYNSR GPZOLSYNWH   *
      *  BG7655 - Rework BG6438 (Secondary triggers on global files)  *
      *           Recompile due to changes in GPZOLSYNSR              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG9684- Recompiled due to BUG433 changing GPZOLSYNSR        *
      *  BUG10215 - Global replication needs a global interface       *
      *             (Recompile)                                       *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1 (Recompile)        *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BG7655 - Rework BG6438 (Secondary triggers on global files)  *
      *           Recompile due to changes in GPZOLSYNSR              *
      *  CGP010 - Global BSPL (Recompile)                             *
      *  CLE041 - Collateralised Lending Phase 2B (Recompile)         *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BG2755 - SDFEEPD not replicated to global layer.             *
      *           Recompile this program with current GPZOLSYNWH/SR   *
      *  BG1364 - Filter Duplicate records in Bulk Synchronization    *
      *           (Recompile)                                         *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     FGPGLOBFL0 IF   E           K DISK    INFSR(*PSSR)
     FGOOSCIL0  UF A E           K DISK    INFSR(*PSSR) COMMIT
     FGOOSJSPD  UF   E             DISK    INFSR(*PSSR) COMMIT
     FGOOSJSPDN UF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(GOOSJSD0:GOOSJSDN)
     FGPSOLOGPD O  A E             DISK    INFSR(*PSSR)

      *****************************************************************


     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS


      * Maximum number of files
     D MaxNoFils       C                   CONST(200)
      * File arrays
     D #_ZPF           S             10    DIM(MaxNoFils)
     D #_PBEF          S              1    DIM(MaxNoFils)


     D JournalEnt      DS
      * Standard fields on all journal entries
     D  Filler01                      5A
     D  JrnSeqn                      10A
     D  JrnCode                       1A
     D  JrnEntType                    2A
     D  Filler02                     38A
     D  Program                      10A
     D  Object                       10A
     D  Library                      10A
     D  Member                       10A
     D  Filler03                     11A
     D  CommitId                     10A
     D  Filler04                      8A
      * Fields specific to the journal entry
     D  EntryData                  4000A


     D ControlInf      DS
     D  CTRLInfo1                     1
     D  CTRLInfo2                     1


     D                 DS
     D  MsgInfo                1     10
     D  Instruction            1      5


     C     *ENTRY        PLIST
     C                   PARM                    JournalEnt
     C                   PARM                    ControlInf

     C                   MOVEL     EntryData     MsgInfo


      * If the first byte of Control Information is 0, no data has been
      *  passed so simply return

     C                   IF        CTRLInfo1 = '0'
     C                   RETURN
     C                   ENDIF

      * If the journal receiver has been changed

     C                   IF        JrnEntType = 'NR'
     C                   EXSR      UPD_COM_OSJS
     C                   EVAL      OSMSG = 'On-line Synchronisation will switch'
     C                                    + ' to ' + MsgInfo
     C                   EXSR      WRITE_LOG
     C                   EVAL      CTRLInfo1 = '9'
     C                   SETON                                        U6LR
     C                   RETURN
     C                   ENDIF

      * PROCESS ENTRY
      * =============

     C                   SELECT

      * Ignore journal entries generated by this function

     C     Program       WHENEQ    'GOOLSYNGZ'
     C                   EXSR      UPD_NCOM_OSJS

      * If this is an 'END' entry,
      *  Write to the log file
      *  and tell the RCVJRNE command (and hence the controlling CL) to stop

     C     JrnEntType    WHENEQ    'OS'
     C     Instruction   ANDEQ     'END  '
     C                   EXSR      UPD_COM_OSJS
     C                   EVAL      OSMSG = 'On-line Synchronisation has ENDED'
     C                   EXSR      WRITE_LOG
     C                   EVAL      CTRLInfo1 = '9'

      * If this is a commit entry
      * action it

     C     JrnEntType    WHENEQ    'CM'
     C                   EXSR      ACTN_COMMIT
     C     CommitUpdate  IFEQ      'Y'
     C                   EXSR      UPD_COM_OSJS
     C                   ELSE
     C                   EXSR      UPD_NCOM_OSJS
     C                   ENDIF

      * If this is a rollback entry
      * action it

     C     JrnEntType    WHENEQ    'RB'
     C                   EXSR      ACTN_ROLLBACK
     C     CommitUpdate  IFEQ      'Y'
     C                   EXSR      UPD_COM_OSJS
     C                   ELSE
     C                   EXSR      UPD_NCOM_OSJS
     C                   ENDIF

      * If this is an update entry, then action it
      * Entries not under commitment control are applied immediately
      * Entries under commitment control are applied on the commit

     C     JrnEntType    WHENEQ    'PT'
     C     JrnEntType    OREQ      'PX'
     C     JrnEntType    OREQ      'UB'
     C     JrnEntType    OREQ      'UP'
     C     JrnEntType    OREQ      'DL'
     C     CommitID      IFNE      '0000000000'
     C                   EXSR      ACTN_UPDATE_C
     C                   ELSE
     C                   EXSR      ACTN_UPDATE_NC
     C                   ENDIF
     C                   EXSR      UPD_COM_OSJS

     C                   ENDSL

     C                   RETURN
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Action commit
      *********************************************************************
     C     ACTN_COMMIT   BEGSR

     C                   MOVE      'N'           CommitUpdate      1

      * Read commit id records and action them

     C                   MOVEL     CommitId      CICCID
     C     CICCID        SETLL     GOOSCID0
     C     CICCID        READE     GOOSCID0                               99
     C     *IN99         DOWEQ     *OFF
     C                   MOVEL     CIFILE        I#FILE           10
     C                   MOVEL     O#ZONE        I#ZONE
     C                   MOVEL     CIBFAF        I#BFAF
     C                   MOVEL     *BLANK        I#BIMG
     C                   MOVEL     *BLANK        I#AIMG
     C     I#BFAF        IFEQ      'B'
     C                   MOVEL     CIIMG         I#BIMG
     C                   ELSE
     C                   MOVEL     CIIMG         I#AIMG
     C                   ENDIF
     C                   EXSR      RECD_Updates
     C                   DELETE    GOOSCID0
     C                   MOVE      'Y'           CommitUpdate
     C     CICCID        READE     GOOSCID0                               99
     C                   ENDDO

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Action rollback
      *********************************************************************
     C     ACTN_ROLLBACK BEGSR

     C                   MOVE      'N'           CommitUpdate

      * Delete commit id record

     C                   MOVEL     CommitId      CICCID
     C     CICCID        CHAIN     GOOSCID0                           99
     C     *IN99         IFEQ      *OFF
     C                   DELETE    GOOSCID0
     C                   MOVE      'Y'           CommitUpdate
     C                   ENDIF

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Action update if under commitment control
      *********************************************************************
     C     ACTN_UPDATE_C BEGSR

      * Write a commitment id record for the 'after' status

     C     JrnEntType    IFEQ      'PT'
     C     JrnEntType    OREQ      'PX'
     C     JrnEntType    OREQ      'UP'
     C                   MOVEL     CommitId      CICCID
     C                   MOVEL     Object        CIFILE
     C                   MOVEL     'A'           CIBFAF
     C                   MOVEL     EntryData     CIIMG
     C                   WRITE     GOOSCID0
     C                   ENDIF

      * Write a commitment id record for the 'before' status

     C     JrnEntType    IFEQ      'UB'
     C                   Z-ADD     1             @T                5 0
     C     Object        LOOKUP    #_ZPF(@T)                              99
     C   99#_PBEF(@T)    IFEQ      'Y'
     C                   MOVEL     CommitId      CICCID
     C                   MOVEL     Object        CIFILE
     C                   MOVEL     'B'           CIBFAF
     C                   MOVEL     EntryData     CIIMG
     C                   WRITE     GOOSCID0
     C                   ENDIF
     C                   ENDIF

     C     JrnEntType    IFEQ      'DL'
     C                   MOVEL     CommitId      CICCID
     C                   MOVEL     Object        CIFILE
     C                   MOVEL     'B'           CIBFAF
     C                   MOVEL     EntryData     CIIMG
     C                   WRITE     GOOSCID0
     C                   ENDIF

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Action update if NOT under commitment control
      *********************************************************************
     C     ACTN_UPDATE_NCBEGSR

     C                   MOVEL     *BLANK        I#BIMG
     C                   MOVEL     *BLANK        I#AIMG

      * Apply updates for the 'after' status

     C     JrnEntType    IFEQ      'PT'
     C     JrnEntType    OREQ      'PX'
     C     JrnEntType    OREQ      'UP'
     C                   MOVEL     Object        I#FILE
     C                   MOVEL     O#ZONE        I#ZONE
     C                   MOVEL     'A'           I#BFAF
     C                   MOVEL     EntryData     I#AIMG
     C                   EXSR      RECD_Updates
     C                   ENDIF

      * Apply updates for the 'before' status

     C     JrnEntType    IFEQ      'UB'
     C                   Z-ADD     1             @T                5 0
     C     Object        LOOKUP    #_ZPF(@T)                              99
     C   99#_PBEF(@T)    IFEQ      'Y'
     C                   MOVEL     Object        I#FILE
     C                   MOVEL     'B'           I#BFAF
     C                   MOVEL     EntryData     I#BIMG
     C                   EXSR      RECD_Updates
     C                   ENDIF
     C                   ENDIF

     C     JrnEntType    IFEQ      'DL'
     C                   MOVEL     Object        I#FILE
     C                   MOVEL     'B'           I#BFAF
     C                   MOVEL     EntryData     I#BIMG
     C                   EXSR      RECD_Updates
     C                   ENDIF

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Update GOOSJSPD with commit
      ********************************************************************
     C     UPD_COM_OSJS  BEGSR

      * Change the sequence number reached on the journal

     C     1             CHAIN     GOOSJSD0                           99
     C     *IN99         IFEQ      *OFF
     C                   EVAL      I#LASTSEQ = JrnSeqn
     C                   IF        JrnEntType = 'NR'                                       BUG16177A
     C                   Eval      I#LASTRCV = MsgInfo                                     BUG16177A
     C                   EndIf                                                             BUG16177A
     C                   UPDATE    GOOSJSD0
     C                   ELSE
     C                   EVAL      I#ERMS   = 'ERROR ON ACCESS OF GOOSJSPD'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   ENDIF

      * Commit the updates

     C                   COMMIT

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Update GOOSJSPD with no commit
      ********************************************************************
     C     UPD_NCOM_OSJS BEGSR

      * Only update on every 100th entry

     C     CountEntries  IFEQ      100
     C     JrnEntType    OREQ      'NR'                                                    BUG16177A

      * Change the sequence number reached on the journal

     C     1             CHAIN     GOOSJSDN                           99
     C     *IN99         IFEQ      *OFF
     C                   EVAL      I#LASTSEQ = JrnSeqn
     C                   IF        JrnEntType = 'NR'                                       BUG16177A
     C                   Eval      I#LASTRCV = MsgInfo                                     BUG16177A
     C                   EndIf                                                             BUG16177A
     C                   UPDATE    GOOSJSDN
     C                   ELSE
     C                   EVAL      I#ERMS   = 'ERROR ON ACCESS OF GOOSJSPD'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     0             CountEntries
     C                   ELSE
     C                   ADD       1             CountEntries
     C                   ENDIF

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Record updates
      *********************************************************************
     C     RECD_Updates  BEGSR
     C                   SELECT
      /COPY GPCPYSRCG,GPZOLSYNWH
     C                   ENDSL
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      /COPY GPCPYSRCG,GPZOLSYNSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Write to the log file
      *********************************************************************
     C     WRITE_LOG     BEGSR
     C                   TIME                    TimeDate         12 0
     C                   MOVE      TimeDate      OSDATE
     C                   MOVEL     TimeDate      OSTIME
     C                   WRITE     GPSOLOGD0
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Load files for on-line synchronisation
      *********************************************************************
     C     LOAD_FILES    BEGSR

      * Read all global 'GZ' files

     C     *LOVAL        SETLL     GPGLOBFD0
     C                   READ      GPGLOBFD0                              99    *
     C     *IN99         DOWEQ     '0'

      * Store each file that may require on-line synchronisation

     C     GFOLSY        IFEQ      'T'
     C     GFOLSY        OREQ      'B'
     C                   Z-ADD     1             @T                5 0
     C     GFZPF         LOOKUP    #_ZPF(@T)                              99    *

     C     *in99         ifeq      '0'
     C                   Z-ADD     1             @T
     C     *BLANK        LOOKUP    #_ZPF (@T)                             99    *
     C                   MOVEL     GFZPF         #_ZPF(@T)
     C                   MOVEL     GFPBEF        #_PBEF(@T)
     C                   endif
     C                   ENDIF

     C                   READ      GPGLOBFD0                              99    *
     C                   ENDDO

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR

     C                   MOVE      *BLANK        I#RTCD            7
     C                   MOVE      *BLANK        I#ERMS           50

      * Job details

     C                   EVAL      OSJOB  = PSJobName
     C                   EVAL      OSUSER = PSUser
     C                   MOVEL     PSJobNo       PSJobNoA          6
     C                   EVAL      OSJOBN = PSJobNoA

      * Load files for on-line synchronisation

     C                   EXSR      LOAD_FILES

     C                   Z-ADD     0             CountEntries      3 0

      * Write to the log file
     C                   EVAL      OSMSG = 'On-line Synchronisation has STARTED'
     C                   EXSR      WRITE_LOG

      * Get Zone

      /COPY GOCPYSRC,GOGETZONE

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003

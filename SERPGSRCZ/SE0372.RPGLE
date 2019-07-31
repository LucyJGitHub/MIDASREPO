     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Clients subject to backup withholding')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE0372 - Clients subject to backup withholding               *
      *                                                               *
      *  Function:  This module displays all the clients who are      *
      *   (I/C)     subject to backup withholding tax by Country of   *
      *             Treaty.                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API (Recompile)       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05         SFLCLR for record subfile                       *
      *    07         SFLDSP for record subfile                       *
      *    08         SFLDSPCTL for record subfile                    *
      *    10         ROLLUP for record subfile                       *
      *    20         Error in country code entry                     *
      *    35         Error in reading file SDWTCSL2                  *
      *    45         End of file for SDWTCSL2                        *
      *    46         SFLEND for MSGCTL                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRScreen     - Read Entry / Display records                  *
      *  SRValidate   - Validate entry                                *
      *  SRBldSubf    - Build subfile record                          *
      *  SRFmtScrFlds - Format screen fields for output               *
      *  SRSndMsg     - Handles the display of error messages         *
      *  *INZSR       - Initialise                                    *
      *  *PSSR        - Error processing                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** SD Customer backup withholding tax
     FSDWTCSL2  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Browse screen
     FSE0372DF  CF   E             WORKSTN
     F                                     SFILE(SE0372S0:WRrn)
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Externally described DS for country details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
      ** Parameters for access object programs
     D PRtcd           S              7A
     D POptn           S              7A
     D PCncd           S              2A
     D PKey1           S             10A
     D PKySt           S              7A
      *
      ** Parameters for ZDATE2
     D ZDayNo          S              5P 0
     D ZDate           S              6P 0
     D ZADate          S              7A
      *
      ** Parameters for ZA0340
     D P_MsgFile       S             10A
     D P_MsgID         S             10A
      *
      ** Other fields used
     D WRun            S              1
     D WRrn            S              5P 0
     D WCnt            S              3  0
     D WInitScrn       S              1    INZ('Y')
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
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
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Read country code entry / Display records
      *
     C                   EXSR      SRScreen
      *
      ** Validate country code entry.
      *
     C                   IF        *INKC = *Off AND
     C                             SCRTTI <> *Blanks
      *
     C                   EXSR      SRValidate
      *
      ** If entry is valid, build subfile for display.
      *
     C                   IF        PRtcd = *Blanks
     C                   EXSR      SRBldSubf
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        *INKC = *On
     C                   EVAL      *INLR = *On
     C                   ENDIF
      *
     C                   ENDIF
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScreen - Read entry / Display records                      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRSndMsg - Send error message                         *
      *                                                               *
      *****************************************************************
      *
     C     SRScreen      BEGSR
 
      *
      ** Write header, footer and message control.
      *
     C                   WRITE     SE0372F0
     C                   WRITE     SE0372F2
     C                   WRITE     SE0372MSGC
      *
     C                   IF        WInitScrn = 'N'
     C                   WRITE     SE0372F1
     C                   ENDIF
      *
     C                   IF        PRtcd <> '*NRF'
     C                   EVAL      SCRTTI = *Blanks
     C                   ENDIF
      *
      ** Read Entry / Display records
      *
     C                   EXFMT     SE0372C0
      *
      ** Clear error message.
      *
     C                   CALL      'ZA0250'
      *
      ** Display error message if no entry has been made.
      *
     C                   IF        SCRTTI = *Blanks
     C                   EVAL      *IN20 = *On
     C                   EVAL      P_MsgID = 'SES0001'
     C                   EXSR      SRSndMsg
     C                   ELSE
     C                   EVAL      *IN20 = *Off
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validate country code entry                     *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *  SRSndMsg - Send error message                                *
      *  *PSSR - Error processing                                     *
      *                                                               *
      *****************************************************************
      *
     C     SRValidate    BEGSR
 
      *
      ** Check if entry is existing from country codes file.
      *
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY    '    POptn
     C     SCRTTI        PARM      SCRTTI        PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *Blanks AND
     C                             PRtcd <> '*NRF' AND
     C                             PRtcd <> '*NOSEL'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = SCRTTI
     C                   EVAL      DBFile = 'SDCTRYPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRtcd = '*NOSEL' OR
     C                             PRtcd = '*NRF'
      *
      ** If no selection made, display error message.
      *
     C                   IF        PRtcd = '*NOSEL'
     C                   EVAL      *IN20 = *On
     C                   EVAL      P_MsgID = 'SES0001'
     C                   EXSR      SrSndMsg
     C                   ENDIF
      *
      ** If entry for country code does not exist, display error message.
      *
     C                   IF        PRtcd = '*NRF'
     C                   EVAL      *IN20 = *On
     C                   EVAL      P_MsgID = 'SES0002'
     C                   EXSR      SrSndMsg
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      *IN20 = *Off
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSubf - Build subfile record                             *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRFmtScrFlds - Format screen fields for output        *
      *                                                               *
      *****************************************************************
      *
     C     SRBldSubf     BEGSR
 
      *
      ** Set initial screen to 'N'.
      *
     C                   EVAL      WInitScrn = 'N'
      *
      ** Initialise subfile relative record number.
      *
     C                   EVAL      WRrn = *Zero
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   EVAL      *IN05 = *On
     C                   WRITE     SE0372C0
     C                   EVAL      *IN05 = *Off
      *
      ** Set file pointer.
      *
     C     SCRTTI        SETLL     SDWTCSL2
     C     SCRTTI        READE     SDWTCSL2                             3545
      *
      ** Error reading file
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDWTCSL2'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Enable SFLDSP and seton ROLLUP indicator to drive intial loop.
      *
     C                   EVAL      *IN07 = *On
     C                   EVAL      *IN10 = *On
      *
      ** Loop 1: Read records from the file until end of file or
      **         ROLLUP has not been entered.
      *
     C                   DOW       EndOfFile = False AND
     C                             *IN10 = *On
      *
      ** Initialise/Reset count of records written to subfile page.
      *
     C                   EVAL      WCnt = 0
      *
      ** Loop 2: Write each record read to subfile until end of file
      **         or subfile page is full.
      *
     C                   DOW       EndOfFile = False AND
     C                             WCnt < 10
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             WRrn
     C                   ADD       1             WCnt
      *
      ** Format screen fields for display.
      *
     C                   EXSR      SRFmtScrFlds
      *
      ** Write the record to subfile.
      *
     C                   WRITE     SE0372S0
      *
      ** Read next record.
      *
     C     SCRTTI        READE     SDWTCSL2                             3545
      *
      ** Error reading file
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDWTCSL2'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** End of Loop 1.
      *
     C                   ENDDO
      *
      ** End of Loop 2.
      *
     C                   ENDDO
      *
      ** If no record for entry: Reset country code screen field,
      ** disable SFLDSP and write 'No Detail' record format.
      *
     C                   IF        WRrn = *Zero
      *
     C                   EVAL      SCRTTO = SCRTTI
     C                   EVAL      *IN07 = *Off
     C                   WRITE     SE0372F3
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtScrFlds - Format screen fields for output               *
      *                                                               *
      *  Called by: SRBldSubf                                         *
      *                                                               *
      *  Calls: *PSSR - Error processing                              *
      *                                                               *
      *****************************************************************
      *
     C     SRFmtScrFlds  BEGSR
 
      *
      ** Retrieve customer details of each record.
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WHCSNO        PKey1
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBkey = WHCSNO
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Write details to corresponding screen fields.
      *
     C                   EVAL      SCSNO = WHCSNO
     C                   EVAL      SCSSN = BBCSSN
     C                   EVAL      SCOLC = BBCOLC
     C                   EVAL      SINTS = WHINTS
     C                   EVAL      SDCRC = WHDCRC
     C                   EVAL      SEXCD = WHEXCD
     C                   EVAL      SRPCD = WHRPCD
      *
      ** If expiry date not equal to zero.
      *
     C                   IF        WHDCEX <> *Zero
      *
      ** Convert Midas Day no. to ICD date format.
      *
     C                   EVAL      ZDayNo = WHDCEX
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   MOVE      ZDate         SDCEX
      *
     C                   ELSE
      *
      ** Blank out expiry date field.
      *
     C                   EVAL      SDCEX = *Blanks
      *
     C                   ENDIF
      *
     C                   EVAL      SCRTTO = WHCRTT
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsg - Handles the display of error messages.            *
      *                                                               *
      *  Called by: SRScreen, SRValidate                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRSndMsg      BEGSR
 
      *
      ** Clear subfile record.
      *
     C                   EVAL      *IN05 = *On
     C                   WRITE     SE0372C0
     C                   EVAL      *IN05 = *Off
      *
      ** Write blank screen to initiate first screen.
      *
     C                   WRITE     BLNKSCRN
     C                   EVAL      WInitScrn = 'Y'
      *
     C                   CALL      'ZA0340'
     C                   PARM      'GBSEUSRMSG'  P_MsgFile
     C                   PARM                    P_MsgID
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR - Error processing                              *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      SUSER = PSUSER
     C                   EVAL      SRUND = BJMRDT
     C                   EVAL      SWSID = PSJOBNAME
     C                   EVAL      SPGMQ = 'SE0372'
      *
     C                   EVAL      *IN08 = *On
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
      *
      ** Check if *PSSR has been called already.
      *
     C                   DUMP
      *
     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
      *
      ** If *PSSR already run, just end the program here.
      *
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2001

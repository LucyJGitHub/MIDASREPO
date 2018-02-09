     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Clients w/o doc for dividend in security')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE0373 - Clients without documentation for a dividend in     *
      *           security.                                           *
      *                                                               *
      *  Function:  This module displays all the clients without      *
      *   (I/C)     documentation for a dividend in security.         *
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
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023   *CREATE   Date 12Jul00               *
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
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05         SFLCLR indicator                                *
      *    07         SFLDSP indicator                                *
      *    08         SFLDSPCTL indicator                             *
      *    10         Rollup indicator                                *
      *    35         Error in reading file SDWTCSL3                  *
      *    45         End of file in SDWTCSL3                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRBldSubf    - Build subfile record                          *
      *  SRFmtScrFlds - Format screen fields                          *
      *  SRPrtSpace   - Print Space                                   *
      *  SRDspScrn    - Display records on screen                     *
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
     FSDWTCSL3  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Browse screen
     FSE0373DF  CF   E             WORKSTN
     F                                     SFILE(SE0373S0:WRRN)
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
     D PKySt           S              7A
     D PKey1           S             10A
      *
      ** Other fields used
     D WRun            S              1
     D WRrn            S              5P 0
     D WCnt            S              3  0
     D WCrttx          S              2A
     D WFirst          S              1A   INZ('Y')
     D WNxt            S              1A
     D WSpace          S              1A
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
      ** Build record subfile.
      *
     C                   EXSR      SRBldSubf
      *
      ** Display records on screen.
      *
     C                   EXSR      SRDspScrn
      *
      ** End program (when F3 is pressed).
      *
     C                   EVAL      *INLR = *On
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSubf - Build record subfile                             *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *  SRFmtScrFlds - Format screen fields                          *
      *  SRPrtSpace   - Print space                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRBldSubf     BEGSR
 
      *
      ** Initialise subfile relative record number.
      *
     C                   EVAL      WRrn  = *Zero
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   EVAL      *IN05 = *On
     C                   WRITE     SE0373C0
     C                   EVAL      *IN05 = *Off
      *
      ** Read record.
      *
     C                   READ      SDWTCSL3                             3545
      *
      ** Error reading file
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDWTCSL3'
     C                   EVAL      DBase = 001
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
     C                   EVAL      WCnt = *Zero
      *
      ** Loop 2: Write each record read to subfile until end of file
      **         or subfile page is full.
      *
     C                   DOW       EndOfFile = False AND
     C                             WCnt < 14
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             WRrn
     C                   ADD       1             WCnt
      *
      ** Reset print space indicator.
      *
     C                   EVAL      WSpace = 'N'
      *
      ** Print space before writing next country code except for
      ** the first record.
      *
     C                   IF        WHCRTT <> WCrttx AND
     C                             WFirst <> 'Y'
     C                   EXSR      SRPrtSpace
     C                   ELSE
      *
      ** Format screen fields for display.
      *
     C                   EXSR      SRFmtScrFlds
     C                   ENDIF
      *
      ** Write the record to subfile.
      *
     C                   WRITE     SE0373S0
      *
      ** Read next record unless space has been printed.
      *
     C                   IF        WSpace <> 'Y'
      *
     C                   READ      SDWTCSL3                             3545
      *
      ** Error reading file
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDWTCSL3'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** End of Loop 2.
      *
     C                   ENDDO
      *
      ** End of Loop 1.
      *
     C                   ENDDO
 
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
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WHCSNO        PKey1
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = WHCSNO
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Print each country code read once in every subfile page and
      ** on every first record of succeeding subfile page.
      *
     C                   IF        WNxt = 'Y' OR
     C                             WCnt = 1
     C                   EVAL      SCRTT = WHCRTT
     C                   ELSE
     C                   EVAL      SCRTT = *Blanks
     C                   ENDIF
      *
      ** Write details to corresponding screen fields.
      *
     C                   EVAL      SCSNO = WHCSNO
     C                   EVAL      SCSSN = BBCSSN
     C                   EVAL      SCOLC = BBCOLC
     C                   EVAL      SINTS = WHINTS
     C                   EVAL      SBCWA = WHBCWA
     C                   EVAL      SEXCD = WHEXCD
     C                   EVAL      SRPCD = WHRPCD
      *
      ** Save previous country code read.
      *
     C                   EVAL      WCrttx = WHCRTT
      *
      ** Set first record and next record indicator to 'N'.
      *
     C                   EVAL      WFirst = 'N'
     C                   EVAL      WNxt = 'N'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrtSpace - Print single space                              *
      *                                                               *
      *  Called by: SRBldSubf                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRPrtSpace    BEGSR
 
      *
      ** Blank out screen fields to print space.
      *
     C                   EVAL      SCRTT = *Blanks
     C                   EVAL      SCSNO = *Blanks
     C                   EVAL      SCSSN = *Blanks
     C                   EVAL      SCOLC = *Blanks
     C                   EVAL      SINTS = *Blanks
     C                   EVAL      SBCWA = *Blanks
     C                   EVAL      SEXCD = *Blanks
     C                   EVAL      SRPCD = *Blanks
      *
      ** Save previous country code read.
      *
     C                   EVAL      WCrttx = WHCRTT
      *
      ** Set space indicator and next country code indicator to 'Y'.
      *
     C                   EVAL      WSpace = 'Y'
     C                   EVAL      WNxt = 'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspScrn - Display output                                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDspScrn     BEGSR
 
      *
      ** Display screen until F3 is pressed.
      *
     C                   DOW       *INKC = *Off
      *
      ** If no record read, disable SFLDSP and write 'No Details'
      ** record format.
      *
     C                   IF        WRrn = *Zero And
     C                             WCnt = *Zero
      *
     C                   EVAL      *IN07 = *Off
     C                   WRITE     SE0373F0
     C                   WRITE     SE0373F1
     C                   WRITE     SE0373F2
     C                   EXFMT     SE0373C0
      *
     C                   ELSE
      *
      ** Display subfile record.
      *
     C                   WRITE     SE0373F0
     C                   WRITE     SE0373F1
     C                   EXFMT     SE0373C0
      *
     C                   ENDIF
      *
      ** If F3 is pressed, end the program.
      *
     C                   ENDDO
 
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
     C                   PARM      '*DBERR '     Prtcd
     C                   PARM      '*FIRST '     Poptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      SUSER = PSUSER
     C                   EVAL      SRUND = BJMRDT
     C                   EVAL      SWSID = PSJOBNAME
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
      *  Calls: DBERRCTL                                              *
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
     C                   CALL      'DBERRCTL'
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

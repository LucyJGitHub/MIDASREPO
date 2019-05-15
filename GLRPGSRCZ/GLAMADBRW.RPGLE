     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVR *: OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)               *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account Maintenance - Browse')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADBRW - ACCOUNT MAINTENANCE - BROWSE                     *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of accounts for selection,     *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG26486           Date 19Oct09               *
      *                 227459A(R          Date 25May05               *
      *                 227459             Date 15Jun04               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 198589             Date 11Feb02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 23Aug99               *
      *                 CFT004             Date 12Nov99               *
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG26486 - Coding Standard (Recompile)                       *
      *  227459A- (reopen) Amend program to bypass reading all other  *
      *           accounts with branches that the user is not         *
      *           authorised to.                                      *
      *  227459 - System performance drops due to large number of     *
      *           records processed in building the subfile. Amended  *
      *           SR/RDACCNT to call ZVACTBU only whenever there is a *
      *           change in branch lessen the processing being done   *
      *           for each record. Also applied 215197 as preventive  *
      *           fix to avoid looping problems.                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  198589 - Correct the validation for the review from fields.  *
      *  CPB001 - Meridian DBA Middleware Replication Customisation.  *
      *           Recompiled due to database changes.                 *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers(Recompile Only)  *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGLAMADBDF CF   E             WORKSTN
     F                                     SFILE(GLAMADS1:@@RRN)
     F                                     SFILE(GLAMADS2:@@RRN)
      ** Account file - by GL A/c No.
     FACCNTLXX  IF   E           K DISK    INFSR(*PSSR)
      ** Account file - by RE A/c No.
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMTBF)
      ** Accounts file - by Front Office Id.
     F***GLAMADL0  IF   E           K DISK    INFSR(*PSSR)                                    CGL029
     FGLAMADL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL029
     F                                     RENAME(ACCNTABF:GLAMADD1)                          227459
     FGLAMADL0  IF   E           K DISK    INFSR(*PSSR)                                       227459
     F                                     RENAME(ACCNTABF:GLAMADD0)
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
     D AFLD10          S              1    DIM(10)
     D NUM             S              1    DIM(10) CTDATA PERRCD(10)
     D AFLD6           S              1    DIM(6)                                             198589
     D***AFLD4**         S              1    DIM(4)                                    198589 CGL029
     D AFLD4           S              1    DIM(10)                                            CGL029
     D AFLD2           S              1    DIM(2)                                             198589
 
     D                 DS
     D***ACKEY**                1     18                                                      CGL029
     D  ACKEY                  1     24                                                       CGL029
     D  WWBRCA                 1      3
     D  WWCNUM                 4      9
     D  WWCCY                 10     12
     D***WWACOD*               13     16                                                      CGL029
     D***WWACSQ*               17     18                                                      CGL029
     D  WWACOD                13     22                                                       CGL029
     D  WWACSQ                23     24                                                       CGL029
     D  WWACNO                 1     10  0
     D  RETKY                  1     10
     D***ACCKY**               11     18                                                      CGL029
     D  ACCKY                 11     24                                                       CGL029
 
     D                 DS
     D***ACNUMB*                1     22                                                      CGL029
     D  ACNUMB                 1     28                                                       CGL029
     D  BRCA                   1      3
     D  FLD0                   4      4    INZ('-')
     D**CNUM****               5     10  0                                                    CSD027
     D  CNUM                   5     10                                                       CSD027
     D  FLD1                  11     11    INZ('-')
     D  CCY                   12     14
     D  FLD2                  15     15    INZ('-')
     D***ACOD***               16     19  0                                                   CGL029
     D***FLD3***               20     20    INZ('-')                                          CGL029
     D***ACSQ***               21     22  0                                                   CGL029
     D  ACOD                  16     25  0                                                    CGL029
     D  FLD3                  26     26    INZ('-')                                           CGL029
     D  ACSQ                  27     28  0                                                    CGL029
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
      *
      ** Initialization
      *
     C                   EXSR      INIT
      *
      ** Build Sub-file
      *
      *
     C     @BDSFL        IFEQ      'Y'
      *
      **  If First time in or subfile by Midas account number was previously
      **  being run, then build subfile keyed on Midas account number.
      **  Stay in loop while F11 toggle key is used.
      *
     C     WOFC          IFNE      'F'
     C     *INKK         DOUEQ     '0'
     C                   EXSR      BLDSFL
      *
      **  If F11, switch to Front Office Account subfile
      *
     C     *INKK         IFEQ      '1'
     C                   MOVE      *BLANKS       DDRFNT
     C                   EXSR      BLDSFL2
     C                   ENDIF
     C                   ENDDO
      *
     C                   ELSE
      *
      **  If the subfile by Front Office Identifier was previously
      **  being run, then build subfile keyed on Front Office ID.
      **  Stay in loop while F11 toggle key is used.
      *
     C     *INKK         DOUEQ     '0'
     C                   EXSR      BLDSFL2
      *
      **  If F11, switch to Midas Account Number subfile
      *
     C     *INKK         IFEQ      '1'
     C                   EXSR      BLDSFL
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
      ** Read Subfile Record
      *
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      * Set indicator ans flag for Midas (back) office A/c number key used
      *
     C                   MOVE      'B'           WOFC              1
     C                   MOVE      '0'           *IN20
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      * Validate Review from Account Number (FOR POINTER)
      *
     C                   EXSR      VALRFRA
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     GLAMADC1
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     GLAMADF1
      *
      **  Set file pointer on key displayed on screen.
      *
     C     ACKEY         IFEQ      *BLANKS
     C     *LOVAL        SETLL     ACCNTLXX
     C                   ELSE
     C     WKACBR        SETLL     ACCNTLXX
     C                   ENDIF
      *
      ** Read a Valid Account
      *
     C                   EXSR      RDACCNT
      *
      **  If no records exist - set up an error message.
      **  and terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'MMM1007'     @ERRMS
     C                   RETURN
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     12
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format account fields for output
      *
     C                   EXSR      FMTACCNT
      *
      **  Write the account to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     GLAMADS1
      *
      ** Read a valid account
      *
     C                   EXSR      RDACCNT
     C                   ENDDO
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C**********         MOVE      DDRFRA        WWRFRA           18                          CGL029
     C                   MOVE      DDRFRA        WWRFRA           24                          CGL029
      *
     C                   TIME                    DDTIME
     C                   WRITE     GLAMADC1
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      GLAMADC1                               99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL2 - BUILD SUBFILE by FRONT OFFICE ID.
      ********************************************************************
 
     C     BLDSFL2       BEGSR
      *
      * Set indicator and flag for Midas (back) office A/c number key used
      *
     C                   MOVE      'F'           WOFC
     C                   MOVE      '1'           *IN20
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
     C     DDRFNT        IFEQ      *BLANKS
      *
      ** Validate Review From Account No. (FOR POINTER)
      *
     C                   EXSR      VALRFRA
      *
      **  Get Front Office Account Ref.
      *
     C     ACKEY         IFNE      *BLANKS
     C     WKACBR        SETLL     ACCNTLXX
     C                   READ      ACCNTLXX                               89
     C     *IN89         IFEQ      *ON
     C     WKACBR        SETLL     ACCNTLXX
     C                   READP     ACCNTLXX                               89
     C                   ENDIF
     C**********         MOVE      FRNT          DDRFNT                                       CGL029
     C                   EVAL      DDRFNT = FRNT + AFRT                                       CGL029
     C                   ELSE
     C                   MOVE      *BLANK        DDRFNT
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     GLAMADC2
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     GLAMADF1
      *
      **  Set file pointer on key displayed on screen.
      *
     C     DDRFNT        IFEQ      *BLANKS
     C******LOVAL        SETLL     GLAMADL0                                                   CGL029
     C     *LOVAL        SETLL     GLAMADL1                                                   CGL029
     C                   ELSE
     C*****DDRFNT        SETLL     GLAMADL0                                                   CGL029
     C*****DDRFNT        SETLL     GLAMADL1                                            CGL029 227459
     C                   MOVE      'AAA'         WWBRCA                                       227459
     C                   MOVE      *BLANKS       WCNUM6                                       227459
     C                   MOVE      'AAA'         WWCCY                                        227459
     C                   Z-ADD     *ZEROS        WACOD4                                       227459
     C                   Z-ADD     *ZEROS        WACSQ2                                       227459
     C     WKFRNT        SETLL     GLAMADL1                                                   227459
     C                   ENDIF
      *
      ** Read a Valid Account No.
      *
     C                   EXSR      RDACCNT
      *
      **  If no records exist - set up an error message.
      **  and terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'MMM1007'     @ERRMS
     C                   RETURN
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     12
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format account fields for output
      *
     C                   EXSR      FMTACCNT
      *
      **  Write the account to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     GLAMADS2
      *
      ** Read a valid account
      *
     C                   EXSR      RDACCNT
     C                   ENDDO
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   TIME                    DDTIME
     C                   WRITE     GLAMADC2
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      GLAMADC2                               99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     *IN49         IFEQ      *OFF
     C     *INKK         OREQ      *ON
     C     DDRFNT        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       DDRFRA
     C                   ELSE
     C                   MOVE      'AAA'         WWBRCA                                       227459
     C                   MOVE      *BLANKS       WCNUM6                                       227459
     C                   MOVE      'AAA'         WWCCY                                        227459
     C                   Z-ADD     *ZEROS        WACOD4                                       227459
     C                   Z-ADD     *ZEROS        WACSQ2                                       227459
     C*****DDRFNT        SETLL     GLAMADL0                                                   CGL029
     C**********         READ      GLAMADL0                               80                  CGL029
     C*****DDRFNT        SETLL     GLAMADL1                                            CGL029 227459
     C     WKFRNT        SETLL     GLAMADL1                                                   227459
     C                   READ      GLAMADL1                               80                  CGL029
     C     *IN80         IFEQ      *ON
     C*****DDRFNT        SETLL     GLAMADL0                                                   CGL029
     C**********         READP     GLAMADL0                               80                  CGL029
     C*****DDRFNT        SETLL     GLAMADL1                                            CGL029 227459
     C     WKFRNT        SETLL     GLAMADL1                                                   227459
     C                   READP     GLAMADL1                               80                  CGL029
     C                   ENDIF
     C                   MOVE      BRCA          WWBRCA
     C                   MOVE      CNUM          WWCNUM
     C                   MOVE      CCY           WWCCY
     C                   MOVE      ACOD          WWACOD
     C                   MOVE      ACSQ          WWACSQ
     C                   MOVE      ACKEY         DDRFRA
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C     WOFC          IFNE      'F'
     C                   READC     GLAMADS1                               99
     C                   ELSE
     C                   READC     GLAMADS2                               99
     C                   END
     C                   END
      *
      **  Return the selected account reference and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C                   MOVE      DDACNUM       ACNUMB
     C                   MOVE      BRCA          WWBRCA
     C                   MOVE      CNUM          WWCNUM
     C                   MOVE      CCY           WWCCY
     C                   MOVE      ACOD          WWACOD
     C                   MOVE      ACSQ          WWACSQ
     C                   MOVE      ACKEY         @ACSEL
     C                   MOVE      DDOPT         @OPSEL
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTTRD - FORMAT ACCOUNT FOR OUTPUT
      *****************************************************************
     C     FMTACCNT      BEGSR
      *
      ** Front Office Account number
     C**********         MOVE      FRNT          DDFRNT                                       CGL029
     C                   EVAL      DDFRNT = FRNT + AFRT                                       CGL029
      *
      ** Account Number
     C                   MOVE      ACNUMB        DDACNUM
      *
      ** Retail Number
     C     ACNO          IFEQ      *ZEROS
     C                   MOVE      *BLANKS       DDACNO
     C                   ELSE
     C                   MOVE      ACNO          DDACNO
     C                   ENDIF
      *
      ** Account Name
     C                   MOVE      ANAM          DDANAM
      *
      ** Date Account Opened
     C                   Z-ADD     DACO          ZDAYNO
     C     ZDAYNO        IFNE      *ZERO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDDACO
     C                   ELSE
     C                   MOVEL     *BLANK        DDDACO
     C                   ENDIF
      *
      ** Date Account Closed
     C                   Z-ADD     DACC          ZDAYNO
     C     ZDAYNO        IFNE      *ZERO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDDACC
     C                   ELSE
     C                   MOVEL     *BLANK        DDDACC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDACCNT - READ A VALID ACCOUNT
      *****************************************************************
     C     RDACCNT       BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C*****CNUM*         ORNE      *ZERO                                                      CSD027
     C     CNUM          ORNE      *BLANKS                                                    CSD027
     C     @@ERR         ANDEQ     *ZERO
      *
      **  Read the file.
      *
     C     WOFC          IFEQ      'B'
     C                   READ      ACCNTLXX                               96
     C                   ELSE
     C**********         READ      GLAMADL0                               96                  CGL029
     C                   READ      GLAMADL1                               96                  CGL029
     C                   ENDIF
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
      *
      ** Show last record if review key not found
     C     @@RRN         IFEQ      *ZERO
     C                   SELECT
     C     WOFC          WHENEQ    'B'
     C     WKACBR        SETLL     ACCNTLXX
     C                   READP     ACCNTLXX                               96
     C     WOFC          WHENEQ    'F'
     C*****DDRFNT        SETLL     GLAMADL0                                                   CGL029
     C**********         READP     GLAMADL0                               96                  CGL029
     C*****DDRFNT        SETLL     GLAMADL1                                            CGL029 227459
     C     WKFRNT        SETLL     GLAMADL1                                                   227459
     C                   READP     GLAMADL1                               96                  CGL029
     C                   ENDSL
      *                                                                                       227459
     C     @@ERR         IFEQ      1                                                          227459
      *                                                                                       227459
     C     WOFC          IFEQ      'B'                                                        227459
     C     @@ERR         DOUEQ     0                                                          227459
     C                   MOVE      BRCA          WWBRCA                                       227459
     C                   MOVE      *BLANKS       WCNUM6                                       227459
     C                   MOVE      'AAA'         WWCCY                                        227459
     C                   Z-ADD     *ZEROS        WACOD4                                       227459
     C                   Z-ADD     *ZEROS        WACSQ2                                       227459
     C     WKACBR        SETLL     ACCNTLXX                                                   227459
     C                   READP     ACCNTLXX                               96                  227459
      *                                                                                       227459
      ** If account read, check whether user can see it                                       227459
      *                                                                                       227459
     C     @@EOF         IFNE      'Y'                                                        227459
     C     BJSBRC        ANDEQ     *BLANK                                                     227459
     C                   CALL      'ZVACTBU'                                                  227459
     C                   PARM      'E'           ZACTN                                        227459
     C                   PARM                    BRCA                                         227459
     C                   PARM                    @@ERR                                        227459
     C                   ENDIF                                                                227459
      *                                                                                       227459
     C                   ENDDO                                                                227459
     C                   ENDIF                                                                227459
      *                                                                                       227459
     C     WOFC          IFEQ      'F'                                                        227459
     C     @@ERR         DOUEQ     0                                                          227459
     C                   MOVE      FRNT          DDRFNT                                       227459
     C                   MOVE      BRCA          WWBRCA                                       227459
     C                   MOVE      *BLANKS       WCNUM6                                       227459
     C                   MOVE      'AAA'         WWCCY                                        227459
     C                   Z-ADD     *ZEROS        WACOD4                                       227459
     C                   Z-ADD     *ZEROS        WACSQ2                                       227459
     C     WKFRNT        SETLL     GLAMADL1                                                   227459
     C                   READP     GLAMADL1                               96                  227459
      *                                                                                       227459
      ** If account read, check whether user can see it                                       227459
      *                                                                                       227459
     C     @@EOF         IFNE      'Y'                                                        227459
     C     BJSBRC        ANDEQ     *BLANK                                                     227459
     C                   CALL      'ZVACTBU'                                                  227459
     C                   PARM      'E'           ZACTN                                        227459
     C                   PARM                    BRCA                                         227459
     C                   PARM                    @@ERR                                        227459
     C                   ENDIF                                                                227459
      *                                                                                       227459
     C                   ENDDO                                                                227459
      *                                                                                       227459
     C                   ENDIF                                                                227459
     C                   ENDIF                                                                227459
      *                                                                                       227459
     C     *IN96         IFEQ      *ON
     C                   MOVEL     'Y'           @@EOF
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'Y'           @@EOF
     C                   ENDIF
     C                   ENDIF
      *
      ** If account read, check whether user can see it
      *
     C     @@EOF         IFNE      'Y'
     C     BJSBRC        ANDEQ     *BLANK
     C     BRCA          ANDNE     PRVBR                                                      227459
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   ENDIF
     C                   MOVE      BRCA          PRVBR             3                         227459A
     C     @@ERR         IFNE      0                                                         227459A
     C     WOFC          IFEQ      'B'                                                       227459A
     C                   MOVE      BRCA          WWBRCA                                      227459A
     C                   MOVE      '999999'      WCNUM6                                      227459A
     C                   MOVE      'ZZZ'         WWCCY                                       227459A
     C                   Z-ADD     9999          WACOD4                                      227459A
     C                   Z-ADD     99            WACSQ2                                      227459A
     C     WKACBR        SETGT     ACCNTLXX                                                  227459A
     C                   ELSE                                                                227459A
     C                   MOVE      BRCA          WWBRCA                                      227459A
     C                   MOVE      FRNT          DDRFNT                                      227459A
     C                   MOVE      '999999'      WCNUM6                                      227459A
     C                   MOVE      'ZZZ'         WWCCY                                       227459A
     C                   Z-ADD     9999          WACOD4                                      227459A
     C                   Z-ADD     99            WACSQ2                                      227459A
     C     WKFRNT        SETGT     GLAMADL1                                                  227459A
     C                   ENDIF                                                               227459A
     C                   ENDIF                                                               227459A
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'RE71889'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALRFRA - VALIDATE REVIEW FROM POINTER
      *****************************************************************
     C     VALRFRA       BEGSR
      *
     C                   MOVE      DDRFRA        ACKEY
      *
      ** Retail
     C     ACCKY         IFEQ      *BLANKS
     C     RETKY         ANDNE     *BLANKS
      *
     C                   MOVEA     RETKY         AFLD10
     C                   Z-ADD     1             IDX1              2 0
     C                   SETON                                            80
      *
     C     IDX1          DOWLT     11
     C     *IN80         ANDEQ     '1'
     C     AFLD10(IDX1)  LOOKUP    NUM                                    80
     C                   ADD       1             IDX1
     C                   ENDDO
      *
      ** If Retail Number used, get the Account Number
     C     *IN80         IFEQ      '1'
     C     WWACNO        SETLL     ACNUM
     C                   READ      ACNUM                                  89
     C     *IN89         IFEQ      *OFF
     C                   MOVE      BRCA          WWBRCA
     C                   MOVE      CNUM          WWCNUM
     C                   MOVE      CCY           WWCCY
     C                   MOVE      ACOD          WWACOD
     C                   MOVE      ACSQ          WWACSQ
     C                   MOVE      ACKEY         DDRFRA
     C                   ELSE
     C                   MOVE      *BLANKS       DDRFRA
     C                   MOVE      *BLANKS       ACKEY
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** General Ledger
     C     ACKEY         IFNE      *BLANKS
      *
      ** Check the customer number.                                                           198589
      *                                                                                       198589
     C                   MOVE      ' '           WCHR              1                          198589
     C**********         TESTN                   WWCNUM               51               198589 CSD027
     C**********         MOVE      WWCNUM        @@TEST                                198589 CSD027
     C**********         TESTZ                   @@TEST                   52           198589 CSD027
     C*****WWCNUM        IFNE      *BLANKS                                             198589 CSD027
     C******IN51         ANDEQ     '0'                                                 198589 CSD027
     C*****WWCNUM        ORNE      *BLANKS                                             198589 CSD027
     C******IN52         ANDEQ     '0'                                                 198589 CSD027
     C                   MOVEA     WWCNUM        AFLD6                                        198589
     C                   Z-ADD     6             IDX2              2 0                        198589
     C     IDX2          DOWNE     0                                                          198589
      *                                                                                       198589
     C     WCHR          IFEQ      'Y'                                                        198589
     C     AFLD6(IDX2)   ANDEQ     *BLANKS                                                    198589
     C                   Z-ADD     1             IDX2                                         198589
     C                   ENDIF                                                                198589
      *                                                                                       198589
     C     AFLD6(IDX2)   IFNE      *BLANKS                                                    198589
     C                   MOVE      'Y'           WCHR                                         198589
     C                   ENDIF                                                                198589
      *                                                                                       198589
     C     AFLD6(IDX2)   IFEQ      *BLANKS                                                    198589
     C     WCHR          ANDNE     'Y'                                                        198589
     C                   MOVE      '0'           AFLD6(IDX2)                                  198589
     C                   ENDIF                                                                198589
      *                                                                                       198589
     C     IDX2          SUB       1             IDX2                                         198589
     C                   ENDDO                                                                198589
     C                   MOVEA     AFLD6         WWCNUM                                       198589
     C**********         ENDIF                                                         198589 CSD027
      *                                                                                       198589
     C**********         TESTN                   WWCNUM               81                      CSD027
     C**********         MOVE      WWCNUM        @@TEST            1                          CSD027
     C**********         TESTZ                   @@TEST                   82                  CSD027
     C*****WWCNUM        IFNE      *BLANKS                                                    CSD027
     C******IN81         ANDEQ     *OFF                                                       CSD027
     C*****WWCNUM        ORNE      *BLANKS                                                    CSD027
     C******IN82         ANDEQ     *OFF                                                       CSD027
     C**********         MOVE      *LOVAL        WCNUM6                                       198589
     C**********         Z-ADD     0             WCNUM6                                198589 CSD027
     C**********         ELSE                                                                 CSD027
     C                   MOVE      *BLANKS       @@TEST            1                          CSD027
     C                   MOVE      WWCNUM        WCNUM6
     C**********         ENDIF                                                                CSD027
      *
      ** Check the account code.                                                              198589
      *                                                                                       198589
     C                   MOVE      ' '           WCHR                                         198589
     C                   TESTN                   WWACOD               51                      198589
     C                   MOVE      WWACOD        @@TEST                                       198589
     C                   TESTZ                   @@TEST                   52                  198589
     C     WWACOD        IFNE      *BLANKS                                                    198589
     C     *IN51         ANDEQ     '0'                                                        198589
     C     WWACOD        ORNE      *BLANKS                                                    198589
     C     *IN52         ANDEQ     '0'                                                        198589
     C                   MOVEA     WWACOD        AFLD4                                        198589
     C                   Z-ADD     4             IDX2                                         198589
     C     IDX2          DOWNE     0                                                          198589
      *                                                                                       198589
     C     WCHR          IFEQ      'Y'                                                        198589
     C     AFLD4(IDX2)   ANDEQ     *BLANKS                                                    198589
     C                   Z-ADD     1             IDX2                                         198589
     C                   ENDIF                                                                198589
      *                                                                                       198589
     C     AFLD4(IDX2)   IFNE      *BLANKS                                                    198589
     C                   MOVE      'Y'           WCHR                                         198589
     C                   ENDIF                                                                198589
      *                                                                                       198589
     C     AFLD4(IDX2)   IFEQ      *BLANKS                                                    198589
     C     WCHR          ANDNE     'Y'                                                        198589
     C                   MOVE      '0'           AFLD4(IDX2)                                  198589
     C                   ENDIF                                                                198589
      *                                                                                       198589
     C     IDX2          SUB       1             IDX2                                         198589
     C                   ENDDO                                                                198589
     C                   MOVEA     AFLD4         WWACOD                                       198589
     C                   ENDIF                                                                198589
      *                                                                                       198589
     C                   TESTN                   WWACOD               81
     C                   MOVE      WWACOD        @@TEST
     C                   TESTZ                   @@TEST                   82
     C     WWACOD        IFNE      *BLANKS
     C     *IN81         ANDEQ     *OFF
     C     WWACOD        ORNE      *BLANKS
     C     *IN82         ANDEQ     *OFF
     C**********         MOVE      *LOVAL        WACOD4                                       198589
     C                   Z-ADD     0             WACOD4                                       198589
     C                   ELSE
     C                   MOVE      WWACOD        WACOD4
     C                   ENDIF
      *
      ** Check the account sequence.                                                          198589
      *                                                                                       198589
     C                   MOVE      ' '           WCHR                                         198589
     C                   TESTN                   WWACSQ               51                      198589
     C                   MOVE      WWACSQ        @@TEST                                       198589
     C                   TESTZ                   @@TEST                   52                  198589
     C     WWACSQ        IFNE      *BLANKS                                                    198589
     C     *IN51         ANDEQ     '0'                                                        198589
     C     WWACSQ        ORNE      *BLANKS                                                    198589
     C     *IN52         ANDEQ     '0'                                                        198589
     C                   MOVEA     WWACSQ        AFLD2                                        198589
     C                   Z-ADD     2             IDX2                                         198589
     C     IDX2          DOWNE     0                                                          198589
      *                                                                                       198589
     C     WCHR          IFEQ      'Y'                                                        198589
     C     AFLD2(IDX2)   ANDEQ     *BLANKS                                                    198589
     C                   Z-ADD     1             IDX2                                         198589
     C                   ENDIF                                                                198589
      *                                                                                       198589
     C     AFLD2(IDX2)   IFNE      *BLANKS                                                    198589
     C                   MOVE      'Y'           WCHR                                         198589
     C                   ENDIF                                                                198589
      *                                                                                       198589
     C     AFLD2(IDX2)   IFEQ      *BLANKS                                                    198589
     C     WCHR          ANDNE     'Y'                                                        198589
     C                   MOVE      '0'           AFLD2(IDX2)                                  198589
     C                   ENDIF                                                                198589
      *                                                                                       198589
     C     IDX2          SUB       1             IDX2                                         198589
     C                   ENDDO                                                                198589
     C                   MOVEA     AFLD2         WWACSQ                                       198589
     C                   ENDIF                                                                198589
      *                                                                                       198589
     C                   TESTN                   WWACSQ               81
     C                   MOVE      WWACSQ        @@TEST
     C                   TESTZ                   @@TEST                   82
     C     WWACSQ        IFNE      *BLANKS
     C     *IN81         ANDEQ     *OFF
     C     WWACSQ        ORNE      *BLANKS
     C     *IN82         ANDEQ     *OFF
     C**********         MOVE      *LOVAL        WACSQ2                                       198589
     C                   Z-ADD     0             WACSQ2                                       198589
     C                   ELSE
     C                   MOVE      WWACSQ        WACSQ2
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALRFNT - VALIDATE REVIEW FROM POINTER
      *****************************************************************
     C     VALRFNT       BEGSR
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @ACSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
     C                   MOVE      '0'           *IN20
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * RETURN CODE
      * Review from Account Number
      * BUILD SUB-FILE
      * READ SUBFILE RECORD
     C                   PARM                    RetCodeIn
     C**********         PARM                    DDRFRA           18                          CGL029
     C                   PARM                    DDRFRA           24                          CGL029
     C                   PARM                    @BDSFL            1
     C                   PARM                    @RDSFL            1
      *
      * OUTPUT PARAMETERS :
      * ERROR MESSAGE
      * OPTION SELECTED
      * Account Ref. selected
     C                   PARM                    @ERRMS            7
     C                   PARM                    @OPSEL            1
     C**********         PARM                    @ACSEL           18                          CGL029
     C                   PARM                    @ACSEL           24                          CGL029
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
     C     WKACBR        KLIST
     C                   KFLD                    WWBRCA
     C**********         KFLD                    WCNUM6            6 0                        CSD027
     C                   KFLD                    WCNUM6            6                          CSD027
     C                   KFLD                    WWCCY
     C**********         KFLD                    WACOD4            4 0                        CGL029
     C                   KFLD                    WACOD4           10 0                        CGL029
     C                   KFLD                    WACSQ2            2 0
      *                                                                                       227459
     C     WKFRNT        KLIST                                                                227459
     C                   KFLD                    DDRFNT           40                          227459
     C                   KFLD                    WWBRCA                                       227459
     C                   KFLD                    WCNUM6                                       227459
     C                   KFLD                    WWCCY                                        227459
     C                   KFLD                    WACOD4                                       227459
     C                   KFLD                    WACSQ2                                       227459
      *
      ** Initialize program name
     C                   MOVEL     'GLAMADBRW '  DBPGM
      *
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** NUM
0123456789

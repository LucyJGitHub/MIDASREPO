     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer Details Browse')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACUDBRW - Additional Customer Details Browse               *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of additional customer details *
      *             for selection , the other picks off the           *
      *             selection made.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CGL132             Date 01May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG23518           Date 30Mar09               *
      *                 BUG22133           Date 20Jan09               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12258           Date 20Oct06               *
      *                 BUG11905           Date 15Aug06               *
      *                 BUG10069           Date 25Jan06               *
      *                 233468             Date 12May05               *
      *                 232543             Date 31Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  BUG22133 - Delete option missing from screen                 *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  BUG12258 - Can't amend newly inserted ACUD record            *
      *  BUG11905 - DB Error encountered on third screen              *
      *  BUG10069 - If no customer details exist, check the shadow    *
      *             file.                                             *
      *  233468 - F9 key on Additional Customer Details Maintenance.  *
      *           Note: Footer text on array @FUNCTIONS (from index   *
      *           1 to 3) changed.                                    *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas SD Additional Customer Details Subfile Display
     FSDACUDBDF CF   E             WORKSTN
     F                                     SFILE(SDACUDS1:@@RRN)
     F                                     SFILE(SDACUDS3:@@RRN)
     F                                     SFILE(SDACUDS5:@@RRN)

      ** Customer Details File - by Customer number
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Customer Details Retrieval Shadow File                                    BUG10069
     FSDCDSHL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG10069
     F                                     RENAME(@BBREBF:SDCDSHD1)                         BUG10069
                                                                                            BUG10069
      ** Additional Customer Details File - by Customer number
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)

      ** Additional Customer Details file - by Front Office Id.
     FSDACUSL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDACUSD0:SDACUSFOID)

      ** Additional Customer Details file - by Customer Shortname
     FSDACUSL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDACUSD0:SDACUSCSSN)

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
      /COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      /COPY ZACPYSRC,MSGHNDDCL
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

     D ErrorFldArr     S             10A   DIM(ArrayMax)
     D ErrorMsgIDArr   S              7A   DIM(ArrayMax)
     D @FUNCTIONS      S             79    DIM(6) CTDATA PERRCD(1)

      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)



      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for ErrorFldArr
     D X               S              2S 0 INZ

      ** Subfile record relactive number
     D @@RRN           S              5  0

      ** Count of records written in the subfile
     D @@CNT           S              3  0
      ** Store first rrn error for option selected
     D Fstrrn          S              5P 0 INZ

      ** End of file indicator
     D @@EOF           S              1A   INZ

      ** Parameter for *Entry
     D DDACTN          S              1A
     D DDCUST          S              6A
     D PBDSFL          S              1A
     D PRDSFL          S              1A
     D PSDACUDENQ      S              1A
     D PMultEntry      S              1A
     D P2Pass          S              1A
     D PERRMS          S              7A
     D POPSEL          S              1A
     D PTRSEL          S              6A
     D PINKC           S              1A
     D PINKI           S              1A                                                      233468

      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A

      ** Parameter for ZVACTU
     D ZACTN           S              1A
     D @@ERR           S              1P 0

      ** Other Variables
     D @@CUST          S              6A
     D @@FOID          S             20A
     D @@CSSN          S             10A
     D @@TEST          S              1A
     D WTrnK           S              1A

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

      ** Set up the transaction reference to be used by the message handler

     C                   EVAL      TranRef = DDCUST
     C                   EVAL      ActionCode = DDACTN

      ** Message Error : For Validation of Option only

     C                   IF        PRdSfl <> 'V'

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      /COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------

     C                   ENDIF

      ** Initialization

     C                   EXSR      SRInit

      ** Build Sub-file

     C                   IF        PBdSfl = 'Y'

      **  If First time in or subfile by Midas transaction number was previously
      **  being run, then build subfile keyed on Midas transaction number.
      **  Stay in loop while F11 toggle key is used.

     C                   IF        WTrnK <> 'F' and
     C                             WTrnK <> 'S'

     C                   EVAL      WTrnK = 'B'

     C                   ENDIF

     C                   DOU       *INKK = *OFF

      ** On F11, initialise position/select fields

     C                   IF        *INKK = *ON

     C                   EVAL      DDCUST = *Blanks
     C                   EVAL      SLCUST = *Blanks
     C                   EVAL      SLCSSN = *Blanks
     C                   EVAL      SLCRNM = *Blanks
     C                   EVAL      SLCRTN = *Blanks
     C                   EVAL      SLCLST = *Blanks
     C                   EVAL      SLFODN = *Blanks

      ** Clear program message queue

     C                   CALL      'ZA0250'

     C                   ENDIF

     C     WTrnK         CASEQ     'B'           SRBldSfl
     C     WTrnK         CASEQ     'F'           SRBldSfl2
     C     WTrnK         CASEQ     'S'           SRBldSfl3
     C                   ENDCS
     C                   ENDDO

     C                   ENDIF

      ** READ Subfile Record

     C                   IF        PRdSfl = 'Y' and
     C                             WTrnK <> *Blanks

     C                   EXSR      SRRdSflr

     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      ********************************************************************
      * SRBldSfl - Build Subfile
      ********************************************************************
     C     SRBldSfl      BEGSR

      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING

     C                   IF        BJSBRC <> *Blanks
     C                   EXSR      SRChAutn
     C                   END

      ** Validate Transaction Reference (FOR POINTER)

     C                   EXSR      SrValTran

      **  Initialise subfile relative record number.

     C                   EVAL      @@RRN = 0

      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.

     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDACUDS0
     C                   EVAL      *IN97 = *OFF

      **  Set file pointer on key displayed on screen.

     C     @@CUST        SETLL     SDACUSL1

      **  Read a Valid Transaction

     C                   EXSR      SRRdTran

      **  set up message 'no data to display'

     C                   EVAL      *IN80 = *OFF
     C                   IF        @@EOF = 'Y'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF

      **  Set on ROLLUP indicator to drive initial loop.

     C                   EVAL      *IN98 = *ON

      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.

     C                   DOW       *IN98 = *ON

      **  Initialise count of records written to subfile page.

     C                   EVAL      @@CNT = 0

      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.

     C                   DOW       @@EOF <> 'Y' and
     C                             @@CNT < 14

      **  Increment the subfile record no. and records written fields.

     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT

      **  Initilialize subfile next change

     C                   EVAL      *IN50 = *OFF


      **  Format transaction fields for output

     C                   EXSR      SRFmtTran

      **  Write the transaction to the subfile.

      **  If action code or Transaction number selected is invalid
      **  the subfile postions on the error record and rebuilds

     C                   EVAL      *IN92 = *OFF
     C                   IF        @@RRN <> 1
     C                   EVAL      DDOPT = *Blanks
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDCUST    '  LOOKUP    FldNameArr                             98
     C                   IF        *IN99 <> *ON and
     C                             *IN98 <> *ON
     C                   EVAL      DDOPT = *Blanks
     C                   ELSE
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      DDSFRN = @@RRN
     C                   WRITE     SDACUDS1

      **  Read a valid Transaction

     C                   EXSR      SRRdTran
     C                   ENDDO

      **  Set up footer toggle text and write the footer

     C                   IF        PSDACUDENQ = 'Y'
     C                   EVAL      TOGLTEXT = @FUNCTIONS(4)
     C                   EVAL      *IN91 = *OFF                                               233468
     C                   ELSE
     C                   EVAL      TOGLTEXT = @FUNCTIONS(1)
     C                   EVAL      *IN91 = *ON                                                233468
     C                   ENDIF
     C                   WRITE     SDACUDF1

      **  Write the message subfile

     C                   WRITE     SDACUDM0

      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record

     C                   IF        @@CNT = 0
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDACUDS0
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      @@RRN = 1
     C                   EVAL      DDSFRN = 1

      **  write to the subfile with non-display set on

     C                   EVAL      *IN93 = *ON
     C                   WRITE     SDACUDS1
     C                   EVAL      *IN93 = *OFF
     C                   WRITE     SDACUDS0
     C                   ELSE

      **  Write the subfile control record to the screen to display
      **  the subfile.

     C                   WRITE     SDACUDS0
     C                   ENDIF

      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.

     C                   READ      SDACUDS0                               99

      ** Clear any messages before processing user input

     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIdArr   = *Blanks
     C                   EVAL      MsgDtaArr  = *Blanks

      **  If F3, bypass further processing.

     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
                                                                                              233468
      **  If F9, return to the calling module.                                                233468
                                                                                              233468
     C                   IF        *INKI = *ON                                                233468
     C                   EVAL      PINKI = '1'                                                233468
     C                   RETURN                                                               233468
     C                   ENDIF                                                                233468

     C                   ENDDO

      ** Set indicator ans flag for Midas Front Office I.D. browse key used

     C                   IF        *INKK = *ON
     C                   EVAL      WTrnK = 'F'
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * SRBldSfl2 - Build Subfile by Front Office ID.
      ********************************************************************
     C     SRBldSfl2     BEGSR

      ** Check for user Authority to Browse If not Multi-Branching

     C                   IF        BJSBRC <> *Blanks
     C                   EXSR      SRChAutn
     C                   ENDIF

      ** Validate Transaction N(FOR POINTER)

     C                   EXSR      SRValTran

      **  Get Front Office Transaction Reference

     C     @@CUST        CHAIN     SDACUSL1                           89
     C                   EVAL      @@FOID = E5FRNT
     C                   IF        *IN89 = *ON
     C                   EVAL      @@FOID = *Blanks
     C                   ENDIF

      **  Initialise subfile relative record number.

     C                   EVAL      @@RRN = 0

      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.

     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDACUDS2
     C                   EVAL      *IN97 = *OFF

      **  Set file pointer on key displayed on screen.

     C     @@FOID        SETLL     SDACUSL2

      ** Read a Valid Trade

     C                   EXSR      SRRdTran

      **  set up message 'no data to display'

     C                   EVAL      *IN80 = *OFF
     C                   IF        @@EOF = 'Y'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF

      **  Set on ROLLUP indicator to drive initial loop.

     C                   EVAL      *IN98 = *ON

      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.

     C                   DOW       *IN98 = *ON

      **  Initialise count of records written to subfile page.

     C                   EVAL      @@CNT = 0

      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.

     C                   DOW       @@EOF <> 'Y' and
     C                             @@CNT <  14

      **  Increment the subfile record no. and records written fields.

     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT

      **  Initilialize subfile next change

     C                   EVAL      *IN50 = *OFF

      ** Format custo fields for output

     C                   EXSR      SRFmtTran

      **  Write the customer to the subfile.

      **  If action code or Transaction number selected is invalid,
      **  the subfile postions on the error record and rebuilds

     C                   EVAL      *IN92 = *OFF
     C                   IF        @@RRN <> 1
     C                   EVAL      DDOPT = *Blanks
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDCUST    '  LOOKUP    FldNameArr                             98
     C                   IF        *IN99 <> *ON and
     C                             *IN98 <> *ON
     C                   EVAL      DDOPT = *Blanks
     C                   ELSE
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      DDSFRN = @@RRN
     C                   WRITE     SDACUDS3

      ** Read a valid Transaction

     C                   EXSR      SRRdTran
     C                   ENDDO

      **  Set up footer toggle text and write the footer

     C                   IF        PSDACUDENQ = 'Y'
     C                   EVAL      TOGLTEXT = @FUNCTIONS(5)
     C                   EVAL      *IN91 = *OFF                                               233468
     C                   ELSE
     C                   EVAL      TOGLTEXT = @FUNCTIONS(2)
     C                   EVAL      *IN91 = *ON                                                233468
     C                   ENDIF
     C                   WRITE     SDACUDF1

      **  Write the message subfile

     C                   WRITE     SDACUDM0

      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record

     C                   IF        @@CNT = 0
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDACUDS2
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      @@RRN = 1
     C                   EVAL      DDSFRN = 1

      **  write to the subfile with non-display set on

     C                   EVAL      *IN93 = *ON
     C                   WRITE     SDACUDS3
     C                   EVAL      *IN93 = *OFF
     C                   WRITE     SDACUDS2
     C                   ELSE

      **  Write the subfile control record to the screen to display
      **  the subfile.

     C                   WRITE     SDACUDS2
     C                   ENDIF

      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.

     C                   READ      SDACUDS2                               99

      ** Clear any messages before processing user input

     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIdArr   = *Blanks
     C                   EVAL      MsgDtaArr  = *Blanks

      **  If F3, bypass further processing.

     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
                                                                                              233468
      **  If F9, return to the calling module.                                                233468
                                                                                              233468
     C                   IF        *INKI = *ON                                                233468
     C                   EVAL      PINKI = '1'                                                233468
     C                   RETURN                                                               233468
     C                   ENDIF                                                                233468

     C                   ENDDO

      ** Set indicator and flag for Midas Customer Shortname key

     C                   IF        *INKK = *ON
     C                   EVAL      WTrnK = 'S'
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * SRBldSfl3 - Build Subfile by Customer Shortname
      ********************************************************************
     C     SRBldSfl3     BEGSR

      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING

     C                   IF        BJSBRC <> *Blanks
     C                   EXSR      SRChAutn
     C                   ENDIF

      ** Validate Transaction N(FOR POINTER)

     C                   EXSR      SRValTran

      **  Get Shortname Shortname

     C     @@CUST        CHAIN     SDACUSL1                           89
     C                   EVAL      @@CSSN = E5CSSN
     C                   IF        *IN89 = *ON
     C                   EVAL      @@CSSN = *Blanks
     C                   ENDIF

      **  Initialise subfile relative record number.

     C                   EVAL      @@RRN = 0

      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.

     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDACUDS4
     C                   EVAL      *IN97 = *OFF

      **  Set file pointer on key displayed on screen.

     C     @@CSSN        SETLL     SDACUSL3

      ** Read a Valid Trade

     C                   EXSR      SRRdTran

      **  set up message 'no data to display'

     C                   EVAL      *IN80 = *OFF
     C                   IF        @@EOF = 'Y'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF

      **  Set on ROLLUP indicator to drive initial loop.

     C                   EVAL      *IN98 = *ON

      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.

     C                   DOW       *IN98 = *ON

      **  Initialise count of records written to subfile page.

     C                   EVAL      @@CNT = 0

      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.

     C                   DOW       @@EOF <> 'Y' and
     C                             @@CNT <  14

      **  Increment the subfile record no. and records written fields.

     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT

      **  Initilialize subfile next change

     C                   Eval      *IN50 = *OFF

      ** Format custo fields for output

     C                   EXSR      SRFmtTran

      **  Write the customer to the subfile.

      **  If action code or Transaction number selected is invalid,
      **  the subfile postions on the error record and rebuilds

     C                   EVAL      *IN92 = *OFF
     C                   IF        @@RRN <> 1
     C                   EVAL      DDOPT = *Blanks
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDCUST    '  LOOKUP    FldNameArr                             98
     C                   IF        *IN99 <> *ON and
     C                             *IN98 <> *ON
     C                   EVAL      DDOPT = *Blanks
     C                   ELSE
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      DDSFRN = @@RRN
     C                   WRITE     SDACUDS5

      ** Read a valid Transaction

     C                   EXSR      SRRdTran
     C                   ENDDO

      **  Set up footer toggle text and write the footer

     C                   IF        PSDACUDENQ = 'Y'
     C                   EVAL      TOGLTEXT = @FUNCTIONS(6)
     C                   EVAL      *IN91 = *OFF                                               233468
     C                   ELSE
     C                   EVAL      TOGLTEXT = @FUNCTIONS(3)
     C                   EVAL      *IN91 = *ON                                                233468
     C                   ENDIF
     C                   WRITE     SDACUDF1

      **  Write the message subfile

     C                   WRITE     SDACUDM0

      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record

     C                   IF        @@CNT = 0
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDACUDS4
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      @@RRN = 1
     C                   EVAL      DDSFRN = 1

      **  write to the subfile with non-display set on

     C                   EVAL      *IN93 = *ON
     C                   WRITE     SDACUDS5
     C                   EVAL      *IN93 = *OFF
     C                   WRITE     SDACUDS4
     C                   ELSE

      **  Write the subfile control record to the screen to display
      **  the subfile.

     C                   WRITE     SDACUDS4
     C                   ENDIF

      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.

     C                   READ      SDACUDS4                               99

      ** Clear any messages before processing user input

     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIdArr   = *Blanks
     C                   EVAL      MsgDtaArr  = *Blanks

      **  If F3, bypass further processing.

     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR =*ON
     C                   RETURN
     C                   ENDIF
                                                                                              233468
      **  If F9, return to the calling module.                                                233468
                                                                                              233468
     C                   IF        *INKI = *ON                                                233468
     C                   EVAL      PINKI = '1'                                                233468
     C                   RETURN                                                               233468
     C                   ENDIF                                                                233468

     C                   ENDDO

      ** Set indicator and flag for Midas Customer Shortnbame key

     C                   IF        *INKK = *ON
     C                   EVAL      WTrnK = 'B'
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * SRRdSflr - Read Subfile Record
      ********************************************************************
     C     SRRdSflr      BEGSR

      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.

     C                   DOU       *IN99 = *ON or
     C                             DDOPT <> *Blanks

     C                   IF        WTrnK = 'B'
     C                   READC     SDACUDS1                               99
     C                   ENDIF
     C                   IF        WTrnK = 'F'
     C                   READC     SDACUDS3                               99
     C                   ENDIF
     C                   IF        WTrnK = 'S'
     C                   READC     SDACUDS5                               99
     C                   ENDIF

     C                   ENDDO

      **  Return the selected transaction reference and option

     C                   IF        *IN99 <> *ON and
     C                             DDOPT <> *Blanks

     C                   EVAL      POPSEL = DDOPT
     C                   EVAL      PTRSEL = DDCUST

     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * SRRdSflOpt -  Read Subfile Record Option
      ********************************************************************
     C     SRRdSflOpt    BEGSR

      ** F5=Refresh is press after the initial loading of subfile
      ** no need to validate the option entries.

     C                   IF        *INKE = *ON
     C                   EVAL      P2Pass = 'R'
     C                   RETURN
     C                   ENDIF

     C                   IF        P2Pass = 'Y'
     C                   EVAL      *IN92 = *OFF
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDCUST    '  LOOKUP    FldNameArr                             98

     C                   IF        *IN99 = *ON or
     C                             *IN98 = *ON
     C                   EVAL      *IN92 = *ON
     C                   EVAL      X = X + 1
     C                   EVAL      ErrorFldArr(X) = FldNameArr(1)
     C                   EVAL      ErrorMsgIDArr(X) = MsgIDArr(1)

      ** Store the RRN of the first error

     C                   IF        Fstrrn = 0
     C                   EVAL      Fstrrn = @@RRN
     C                   ENDIF

     C                   ENDIF

     C                   SELECT
     C                   WHEN      Wtrnk = 'B'
     C                   UPDATE    SDACUDS1
     C                   WHEN      Wtrnk = 'F'
     C                   UPDATE    SDACUDS3
     C                   WHEN      Wtrnk = 'S'
     C                   UPDATE    SDACUDS5
     C                   ENDSL

     C                   ENDIF

      ** Read the subfile for selected records
      ** Only process those for which the option field is blank.

     C                   DOU       *IN99 = *ON or
     C                             DDOPT <> *Blanks

     C                   IF        (*IN99 = *OFF) and (DDOPT = *Blanks) and
     C                             (P2Pass = 'Y')
     C                   EVAL      *IN92 = *OFF
     C                   SELECT
     C                   WHEN      Wtrnk = 'B'
     C                   UPDATE    SDACUDS1
     C                   WHEN      Wtrnk = 'F'
     C                   UPDATE    SDACUDS3
     C                   WHEN      Wtrnk = 'S'
     C                   UPDATE    SDACUDS5
     C                   ENDSL
     C                   ENDIF

     C                   SELECT
     C                   WHEN      WTrnK = 'B'
     C                   READC     SDACUDS1                               99
     C                   WHEN      WTrnK = 'F'
     C                   READC     SDACUDS3                               99
     C                   WHEN      WTrnK = 'S'
     C                   READC     SDACUDS5                               99
     C                   ENDSL

     C                   IF        *IN99 = *OFF

     C                   IF        DDOPT = *Blanks
     C                   EVAL      *IN50 = *OFF
     C                   ELSE
     C                   EVAL      *IN50 = *ON
     C                   ENDIF

     C                   EVAL      PMultEntry = 'Y'
     C                   EVAL      P2Pass = 'Y'

      ** Clear any messages before processing user input

     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIdArr   = *Blanks
     C                   EVAL      MsgDtaArr  = *Blanks
     C                   ENDIF

     C                   ENDDO

     C                   IF        *IN99 = *ON

      ** Initialise indicator for second pass

     C                   EVAL      P2Pass = *Blanks

     C     'DDACTN    '  LOOKUP    ErrorFldArr                            60
     C     'DDCUST    '  LOOKUP    ErrorFldArr                            61

     C                   SELECT
     C                   WHEN      *IN60 = *ON or *IN61 = *ON

      ** Position the subfile to the first error option

     C                   IF        Fstrrn > 0
     C                   EVAL      DDSFRN = Fstrrn
     C                   ENDIF

      ** Get the accumulated message error made by the option selected

     C                   EVAL      MsgIDArr = ErrorMsgIdArr
     C                   EVAL      FldNameArr = ErrorFldArr

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------

      ** Write the message subfile

     C                   WRITE     SDACUDM0

     C                   SELECT
     C                   WHEN      WTrnK = 'B'
     C                   EXFMT     SDACUDS0
     C                   WHEN      WTrnK = 'F'
     C                   EXFMT     SDACUDS2
     C                   WHEN      WTrnK = 'S'
     C                   EXFMT     SDACUDS4
     C                   ENDSL

      ** Clear any messages before processing user input

     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIdArr   = *Blanks
     C                   EVAL      MsgDtaArr  = *Blanks

      ** Initialise error array and index

     C                   EVAL      ErrorFldArr = *Blanks
     C                   EVAL      ErrorMsgIDArr = *Blanks
     C                   EVAL      X = 0

      ** Initialise First Error RRN

     C                   EVAL      Fstrrn = 0

      ** If F3, bypass further processing.

     C                   IF        *INKC = *ON
     C                   EVAL      P2Pass = 'X'
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

      ** If F5, bypass further processing and rebuild subfile

     C                   IF        *INKE = *ON
     C                   EVAL      P2Pass = 'R'
     C                   RETURN
     C                   ENDIF

      ** Set indicator and flag for Midas Front Office I.D. browse key used

     C                   IF        *INKK = *ON
     C                   SELECT
     C                   WHEN      Wtrnk = 'B'
     C                   EVAL      Wtrnk = 'F'
     C                   WHEN      Wtrnk = 'F'
     C                   EVAL      Wtrnk = 'S'
     C                   WHEN      Wtrnk = 'S'
     C                   EVAL      Wtrnk = 'B'
     C                   ENDSL
     C                   ENDIF

     C                   WHEN      *IN60 = *OFF and *IN61 = *OFF

      ** Set P2Pass = 'L' if no more error in the option selected

     C                   EVAL      P2Pass = 'L'

     C                   ENDSL
     C                   ENDIF

      ** Return the selected transaction reference and option

     C                   IF        *IN99 <> '1' and
     C                             DDOPT <> *Blanks

     C                   EVAL      POPSEL = DDOPT
     C                   EVAL      PTRSEL = DDCUST

     C                   ENDIF

      ** Set P2Pass = K when option selected has been inputed as blank
      ** Or Enter is press but no option selected.

     C                   IF        *IN99 = *ON and
     C                             DDOPT = *Blanks
     C                   EVAL      P2Pass = 'K'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FmtTran - Format Transaction for Output
      ******************************************************************
     C     SRFmtTran     BEGSR

      ** Transaction reference

     C                   EVAL      DDCUST = BBCUST
     C                   EVAL      DDCSSN = BBCSSN
     C                   EVAL      DDCRNM = BBCRNM
     C                   EVAL      DDCRTN = BBCRTN
     C                   EVAL      DDFODN = BBFRNT

     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * SRRdTran - Read a Transaction
      *****************************************************************
     C     SRRdTran      BEGSR

      **  Reset End of File and skip record indicator

     C                   EVAL      @@EOF = *Blanks

      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.

     C                   DOU       @@EOF = 'Y' or
     C                             BBCUST <> *Blanks and
     C**********                   @@ERR = *Zero and                                        BUG23518
     C                             @@ERR = *ZEROS                                           BUG23518
     C**********                   E5TYLC <> 'D'                                            BUG23518

      **  Read the file

      **  Position according to Transaction number

     C                   IF        WTrnK = 'B'
     C                   IF        SLCUST <> *Blanks
     C     SLCUST        SETLL     SDACUSL1
     C                   READ      SDACUSL1                               96
     C                   EVAL      SLCUST = *Blanks
     C                   ELSE
     C                   READ      SDACUSL1                               96
     C                   ENDIF
     C                   EXSR      SRGetCust

      ** Select according to customer shortname mask

     C                   IF        SLCSSN <> *Blanks
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCSSN
     C                   PARM      10            LENGTH1           3 0
     C                   PARM      1             START             3 0
     C                   PARM                    SLCSSN
     C                   PARM      10            LENGTH2           3 0
     C                   PARM      '1'           TRANSLATE         1
     C                   PARM      '1'           TRIM              1
     C                   PARM      '?'           WILD              1
     C                   PARM                    RESULT            3 0
     C                   IF        RESULT < 1
     C                   EVAL      BBCUST = *Blanks
     C                   ENDIF
     C                   ENDIF

      ** Select according to customer report name mask

     C                   IF        SLCRNM <> *Blanks
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCRNM
     C                   PARM      20            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SLCRNM
     C                   PARM      20            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   EVAL      BBCUST = *Blanks
     C                   ENDIF
     C                   ENDIF

      ** Select according to customer report town mask

     C                   IF        SLCRTN <> *Blanks
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCRTN
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SLCRTN
     C                   PARM      10            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   EVAL      BBCUST = *Blanks
     C                   ENDIF
     C                   ENDIF

      ** Select according to customer status mask

     C                   IF        SLCLST <> *Blanks
     C                   CALL      'QCLSCAN'
     C                   PARM                    DDCLST
     C                   PARM      7             LENGTH1
     C                   PARM      1             START
     C                   PARM                    SLCLST
     C                   PARM      7             LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   EVAL      BBCUST = *Blanks
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      **  Position according to Front Office Id

     C                   IF        WTrnk = 'F'
     C                   IF        SLFODN <> *Blanks
     C     SLFODN        SETLL     SDACUSL2
     C                   READ      SDACUSL2                               96
     C                   EVAL      SLFODN = *Blanks
     C                   ELSE
     C                   READ      SDACUSL2                               96
     c                   ENDIF
     C                   EXSR      SRGetCust

      ** Select according to customer number mask

     C                   IF        SLCUST <> *Blanks
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCUST
     C                   PARM      6             LENGTH1
     C                   PARM      1             START
     C                   PARM                    SLCUST
     C                   PARM      6             LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   EVAL      BBCUST = *Blanks
     C                   ENDIF
     C                   ENDIF

      ** Select according to customer shortname mask

     C                   IF        SLCSSN <> *Blanks
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCSSN
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SLCSSN
     C                   PARM      10            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   EVAL      BBCUST = *Blanks
     C                   ENDIF
     C                   ENDIF

      ** Select according to customer report town mask

     C                   IF        SLCRTN <> *Blanks
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCRTN
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SLCRTN
     C                   PARM      10            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   EVAL      BBCUST = *Blanks
     C                   ENDIF
     C                   ENDIF

      ** Select according to customer status mask

     C                   IF        SLCLST <> *Blanks
     C                   CALL      'QCLSCAN'
     C                   PARM                    DDCLST
     C                   PARM      7             LENGTH1
     C                   PARM      1             START
     C                   PARM                    SLCLST
     C                   PARM      7             LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   EVAL      BBCUST = *Blanks
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      **  Position according to Customer Shortname

     C                   IF        WTrnk = 'S'
     C                   IF        SLCSSN <> *Blanks
     C     SLCSSN        SETLL     SDACUSL3
     C                   READ      SDACUSL3                               96
     C                   EVAL      SLCSSN = *Blanks
     C                   ELSE
     C                   READ      SDACUSL3                               96
     C                   ENDIF
     C                   EXSR      SRGetCust

      ** Select according to customer number mask

     C                   IF        SLCUST <> *Blanks
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCUST
     C                   PARM      6             LENGTH1
     C                   PARM      1             START
     C                   PARM                    SLCUST
     C                   PARM      6             LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   EVAL      BBCUST = *Blanks
     C                   ENDIF
     C                   ENDIF

      ** Select according to customer report name mask

     C                   IF        SLCRNM <> *Blanks
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCRNM
     C                   PARM      20            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SLCRNM
     C                   PARM      20            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   EVAL      BBCUST = *Blanks
     C                   ENDIF
     C                   ENDIF

      ** Select according to customer report town mask

     C                   IF        SLCRTN <> *Blanks
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCRTN
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SLCRTN
     C                   PARM      10            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   EVAL      BBCUST = *Blanks
     C                   ENDIF
     C                   ENDIF


      ** Select according to customer status mask

     C                   IF        SLCLST <> *Blanks
     C                   CALL      'QCLSCAN'
     C                   PARM                    DDCLST
     C                   PARM      7             LENGTH1
     C                   PARM      1             START
     C                   PARM                    SLCLST
     C                   PARM      7             LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   EVAL      BBCUST = *Blanks
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** End of File

     C                   IF        *IN96 = *ON
     C                   EVAL      @@EOF = 'Y'
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRChAutn - Check for User Authority if Not Multi-Branching
      *****************************************************************
     C     SRChAutn      BEGSR

     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    @@ERR

      ** Return Error Message

     C                   IF        @@ERR = 1
     C                   EVAL      PERRMS = 'FXM0292'
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValTran - Validate Transaction Reference Pointer
      *****************************************************************
     C     SRValTran     BEGSR

      **  Validate that the transaction reference is numeric or blank.

     C**********         TESTN                   DDCUST               98                    BUG12258
     C**********         MOVE      DDCUST        @@TEST                                     BUG12258
     C**********         TESTZ                   @@TEST                   99                BUG12258
     C**********         IF        DDCUST = *Blanks or                                      BUG12258
     C**********                   *IN98 = *ON and                                          BUG12258
     C**********                   *IN99 = *ON                                              BUG12258
     C**********         MOVE      DDCUST        @@CUST                                     BUG12258

      ** Return Error Message

     C**********         ELSE                                                               BUG12258
     C**********         EVAL      PERRMS = 'MMA0087'                                       BUG12258
     C**********         RETURN                                                             BUG11905
     C**********         ENDIF                                                              BUG12258

     C     E5CUST        IFNE      *BLANKS                                                  BUG12258
     C     E5CUST        CHAIN     SDCUSTL1                                                 BUG12258
     C                   IF        Not %Found(SDCUSTL1)                                     BUG12258
     C                   EVAL      PERRMS = 'MMA0087'                                       BUG12258
     C                   ELSE                                                               BUG12258
     C                   MOVE      DDCUST        @@CUST                                     BUG12258
     C                   ENDIF                                                              BUG12258
     C                   ENDIF                                                              BUG12258
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRGetCust - Get Customer Details
      *****************************************************************
     C     SRGetCust     BEGSR

     C     E5CUST        CHAIN     SDCUSTL1

      ** Database Error

     C                   IF        Not %Found(SDCUSTL1)  and
     C                             *IN96 = *OFF
                                                                                            BUG10069
      ** Check the shadow file.                                                             BUG10069
                                                                                            BUG10069
     C     E5CUST        CHAIN     SDCDSHL1                                                 BUG10069
                                                                                            BUG10069
     C                   IF        NOT %FOUND                                               BUG10069
     C     *LOCK         IN        LDA                                                      BUG10069
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = E5CUST
     C                   OUT       LDA                                                      BUG10069
     C                   EXSR      *PSSR
     C                   ENDIF                                                              BUG10069
                                                                                            BUG10069
     C                   ENDIF

      ** Customer Closure Status

     C                   SELECT

     C**********         WHEN      BBDTDL > 0                                               BUG23518
     C                   WHEN      E5TYLC = 'D'                                             BUG23518
     C                   EVAL      DDCLST = 'DELETED'

     C**********         WHEN      BBCLST = 'Y'                                             BUG23518
     C                   WHEN      E5TYLC = 'C'                                             BUG23518
     C                   EVAL      DDCLST = 'CLOSED '

     C                   OTHER
     C                   EVAL      DDCLST = 'ACTIVE '

     C                   ENDSL
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInit - Initialization
      *****************************************************************
     C     SRInit        BEGSR

      ** Clear outputs

     C                   EVAL      PERRMS = *Blanks
     C                   EVAL      POPSEL = *Blanks
     C                   EVAL      PTRSEL = *Blanks
     C                   EVAL      PINKC  = '0'
     C                   EVAL      PINKI  = '0'                                               233468

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR

      ** Parameters

     C     *ENTRY        PLIST

      ** Input Parameters :
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Action Code
     C                   PARM                    DDACTN
      ** Transaction Reference Pointer
     C                   PARM                    DDCUST
      ** Build Subfile
     C                   PARM                    PBDSFL
      ** Read Subfile Record
     C                   PARM                    PRDSFL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Called from SDACUDENQ module if value is 'Y', otherwise from SDACUDSIN
     C                   PARM                    PSDACUDENQ

      ** For Multiple Entry
     C                   PARM                    PMultEntry
      ** Indicate secong pass for option selected
     C                   PARM                    P2Pass

      ** Output Parameters:
      ** Error Message
      ** Option Selected
      ** Transaction Reference selected
     C                   PARM                    PERRMS
     C                   PARM                    POPSEL
     C                   PARM                    PTRSEL
      ** Command Keys
     C                   PARM                    PINKC
     C                   PARM                    PINKI                                        233468

      ** Initialize program name
     C                   EVAL      DBPGM = 'SDACUDBRW'

      ** Move workstation ID to screen field.
     C                   EVAL      DDWID = PsJobName
     C                   EVAL      DDUSER = PsUser

     C                   EVAL      *IN94 = *ON
     C                   EVAL      DDPGMQ = '*'

      ** Clear error array fields

     C                   EVAL      ErrorFldArr = *Blanks
     C                   EVAL      ErrorMsgIDArr = *Blanks

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRtcd <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** Functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------

     C                   ENDSR
      *****************************************************************
      /EJECT
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      /COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------

      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      ** @FUNCTIONS changed to include the Delete option.                                   BUG22133
** CTDATA CPY@
(c) Finastra International Limited 2004
** CTDATA @FUNCTIONS
A=Amend D=Delete E=Enq F3=Main Menu F5=Refrsh F9='Add' F11=Toggle Frnt Ofc Id
A=Amend D=Delete E=Enq F3=Main Menu F5=Refrsh F9='Add' F11=Toggle Cust Shrtname
A=Amend D=Delete E=Enq F3=Main Menu F5=Refrsh F9='Add' F11=Toggle Cust Number
E=Enquire F3=Main Menu F5=Refresh F11 = Toggle Front Office ID
E=Enquire F3=Main Menu F5=Refresh F11 = Toggle Customer Shortname
E=Enquire F3=Main Menu F5=Refresh F11 = Toggle Customer Number

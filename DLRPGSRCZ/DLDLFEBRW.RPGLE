     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees browse')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLFEBRW - Dealing Fees Details Browse                      *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of Dealing Fees details        *
      *             for selection, the other picks off the            *
      *             selection made.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDLDLFEBRDFCF   E             WORKSTN
     F                                     SFILE(DLDLFES1:@@RRN)
     F                                     SFILE(DLDLFES3:@@RRN)
      * Dealing Fees Transaction Details File - by Deal No. and Fee Sequence
     FDLFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLFEEDD0:DLFEEDD1)
      ** Transaction file - by Front Office Id.
     FDLFEEDL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLFEEDD0:DLFEEDFO)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WDAYNO          S              5  0
     D ZFLD15          S             15  0
     D ZDATE           S              6  0
     D ZDECS           S              1  0
     D ZOUT21          S             21A
     D ZADATE          S              7A
     D ZECODE          S              1A
     D @AJCD           S              3A
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
      ** Set up the transaction reference to be used by the message handler
     C                   EVAL      TranRef = DDDLNO
     C                   EVAL      ActionCode = DDACTN
 
      ** Initialization
      *
     C                   EXSR      INIT
 
      ** BUILD Sub-file
 
     C                   IF        @BDSFL = 'Y'
      *
      **  If First time in or subfile by Midas transaction number was previously
      **  being run, then build subfile keyed on Midas transaction number.
      **  Stay in loop while F11 toggle key is used.
      *
     C                   IF        WTrnK <> 'F' and
     C                             WTrnK <> 'S'
 
     C                   MOVE      'B'           WTrnK
      *
     C                   ENDIF
      *
     C                   DOU       *INKK = '0'
      *
      ** On F11, initialise position/select fields
      *
     C                   IF        *INKK = '1'
      *
     C                   EVAL      DDDLNO = *BLANK
     C                   EVAL      DDFSEQ = *BLANK
     C                   EVAL      DDSDAT = *BLANK
     C                   EVAL      DDEDAT = *BLANK
     C                   EVAL      DDFCCY = *BLANK
     C                   EVAL      DDFAMT = *BLANK
     C                   EVAL      DDSTAT = *BLANK
 
      ** Clear program message queue
     C                   CALL      'ZA0250'
 
     C                   ENDIF
 
     C     WTrnK         CASEQ     'B'           BLDSFL
     C     WTrnK         CASEQ     'F'           BLDSFL2
     C                   ENDCS
     C                   ENDDO
 
     C                   ENDIF
 
      ** READ Subfile Record
 
     C                   IF        @RDSFL = 'Y' and
     C                             WTrnK <> *BLANK
 
     C                   EXSR      RDSFLR
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      ** Validate Transaction Reference (FOR POINTER)
      *
     C                   EXSR      VALTran
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   EVAL      *IN97 = *ON
     C                   WRITE     DLDLFES0
     C                   EVAL      *IN97 = *OFF
      *
      ***  Write the select screen footer to the screen.
      *
     C                   WRITE     DLDLFEF1
 
      **  Set file pointer on key displayed on screen.
      *
     C     @@TRNN        SETLL     DLFEEDD1
      *
      **  Read a Valid Transaction
      *
     C                   EXSR      RDTran
      *
      **  If no records exist - set up an error message.
      **  and terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'MMM1007'     @ERRMS
     C                   RETURN
     C                   ENDIF
 
     C                   EVAL      *IN80 = *OFF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   EVAL      *IN98 = *ON
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C                   DOW       *IN98 = *ON
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C                   DOW       @@EOF <> 'Y' and
     C                             @@CNT < 14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Format transaction fields for output
      *
     C                   EXSR      FMTtran
      *
      **  Write the transaction to the subfile.
      *
      **  If action code or Transaction number selected is invalid
      **  the subfile postions on the error record and rebuilds
      *
     C                   EVAL      *IN92 = *OFF
     C                   IF        @@RRN <> 1
     C                   EVAL      DDOPTN = *BLANK
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDDLNO    '  LOOKUP    FldNameArr                             98
     C                   IF        *IN99 <> '1' and
     C                             *IN98 <> '1'
     C                   EVAL      DDOPTN = *BLANK
     C                   ELSE
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     DLDLFES1
      *
      **  Read a valid Transaction
      *
     C                   EXSR      RDTran
     C                   ENDDO
      *
      **  Set up footer toggle text and write the footer
      *
     C                   WRITE     DLDLFEF1
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C                   IF        @@CNT = 0
     C                   EVAL      *IN97 = *ON
     C                   WRITE     DLDLFES0
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      @@RRN = 1
     C                   EVAL      DDSFRN = 1
      *
      **  write to the subfile with non-display set on
      *
     C                   EVAL      *IN93 = *ON
     C                   WRITE     DLDLFES1
     C                   EVAL      *IN93 = *OFF
     C                   WRITE     DLDLFES0
     C                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     DLDLFES0
     C                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      DLDLFES0                               99
      *
      ** Clear any messages before processing user input
      *
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
      *
      **  If F3, bypass further processing.
     C                   IF        *INKC = *ON
     C                   EVAL      @INKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Set indicator ans flag for Midas Front Office I.D. browse key   used
      *
     C                   IF        *INKK = *ON
     C                   MOVE      'F'           WTrnK             1
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL2 - BUILD SUBFILE by FRONT OFFICE ID.
      ********************************************************************
 
     C     BLDSFL2       BEGSR
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      * Validate Transaction N(FOR POINTER)
      *
     C                   EXSR      VALTran
      *
      **  Get Front Office Transaction Reference
      *
     C     @@TRNN        CHAIN     DLFEEDD1                           89
     C                   MOVE      DFFRNT        @@FOID           20
     C                   IF        *IN89 = *ON
     C                   EVAL      @@FOID = *BLANKS
     C                   ENDIF
      *
      **  Initialise subfile relative record number.
      *
     C                   EVAL      @@RRN = 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   EVAL      *IN97 = *ON
     C                   WRITE     DLDLFES2
     C                   EVAL      *IN97 = *OFF
      *
      **  Set file pointer on key displayed on screen.
      *
     C     @@FOID        SETLL     DLFEEDFO
      *
      ** Read a Valid Trade
      *
     C                   EXSR      RDTran
      *
      **  set up message 'no data to display'
      *
     C                   EVAL      *IN80 = *OFF
     C                   IF        @@EOF = 'Y'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   EVAL      *IN98 = *ON
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C                   DOW       *IN98 = *ON
      *
      **  Initialise count of records written to subfile page.
      *
     C                   EVAL      @@CNT = 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C                   DOW       @@EOF <> 'Y' and
     C                             @@CNT <  14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format custo fields for output
      *
     C                   EXSR      FMTtran
      *
      **  Write the customer to the subfile.
      *
      **  If action code or Transaction number selected is invalid,
      **  the subfile postions on the error record and rebuilds
      *
     C                   EVAL      *IN92 = *OFF
     C                   IF        @@RRN <> 1
     C                   EVAL      DDOPTN = *BLANKS
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDDLNO    '  LOOKUP    FldNameArr                             98
     C                   IF        *IN99 <> *ON and
     C                             *IN98 <> *ON
     C                   EVAL      DDOPTN = *BLANKS
     C                   ELSE
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      DDSFRN = @@RRN
     C                   WRITE     DLDLFES3
      *
      ** Read a valid Transaction
      *
     C                   EXSR      RDTran
     C                   ENDDO
      *
      **  Set up footer toggle text and write the footer
      *
     C                   WRITE     DLDLFEF1
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C                   IF        @@CNT = 0
     C                   EVAL      *IN97 = *ON
     C                   WRITE     DLDLFES2
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      @@RRN = 1
     C                   EVAL      DDSFRN = 1
      *
      **  write to the subfile with non-display set on
      *
     C                   EVAL      *IN93 = *ON
     C                   WRITE     DLDLFES3
     C                   EVAL      *IN93 = *OFF
     C                   WRITE     DLDLFES2
     C                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     DLDLFES2
     C                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      DLDLFES2                               99
      *
      ** Clear any messages before processing user input
      *
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
      *
      **  If F3, bypass further processing.
      *
     C                   IF        *INKC = *ON
     C                   EVAL      @INKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  If F9, bypass further processing.
      *
     C                   IF        *INKI = *ON
     C                   EVAL      @OPSEL = 'I'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Set indicator and flag for Midas (back) office Transaction number key
      *
     C                   IF        *INKK = *ON
     C                   EVAL      WTrnK = 'B'
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
     C                   DOU       *IN99 = *ON or
     C                             DDOPTN <> *BLANK
 
     C                   IF        WTrnK = 'B'
     C                   READC     DLDLFES1                               99
     C                   ENDIF
     C                   IF        WTrnK = 'F'
     C                   READC     DLDLFES3                               99
     C                   ENDIF
 
     C                   ENDDO
      *
      **  Return the selected transaction reference and option
      *
     C                   IF        *IN99 <> '1' and
     C                             DDOPTN <> *BLANK
      *
     C                   IF        DDOPTN = 'A' or DDOPTN = 'X' or
     C                             DDOPTN = 'D'
     C                   EVAL      @OPSEL = DDOPTN
     C                   ELSE
     C                   EVAL      @OPSEL = 'E'
     C                   ENDIF
      *
     C                   EVAL      @TRSEL = DDDLNO
      *
     C                   ENDIF
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTtran - FORMAT TRANSACTION FOR OUTPUT
      ******************************************************************
     C     FMTTRAN       BEGSR
 
      * Transaction reference
 
     C                   MOVE      DFDLNO        DDDLNO
     C                   MOVE      DFFRNT        DDFRNT
     C                   MOVE      DFFSEQ        DDFSEQ
      *
      *
      * Start Date
     C                   EVAL      WDAYNO = DFPSTD
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         DDSDAT
      * End Date
     C                   EVAL      WDAYNO = DFPEND
     C                   EXSR      CVTDAT
     C     ZDATE         IFEQ      0
     C                   EVAL      DDEDAT = *BLANKS
     C                   ELSE
     C                   MOVEL     ZDATE         DDEDAT
     C                   ENDIF
     C                   EVAL      DDFCCY = DFFCCY
      *
      ** Get the currency decimal places of Fee ccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DFFCCY        @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     ** Fee Amount
     C     DFFAMT        IFEQ      0
     C                   EVAL      DDFAMT = *BLANKS
     C                   ELSE
     C     DFFAMT        IFLT      0
     C                   Z-SUB     DFFAMT        ZFLD15
     C                   ELSE
     C                   Z-ADD     DFFAMT        ZFLD15
     C                   ENDIF
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        DDFAMT
     C                   ENDIF
     C     DFRECI        IFNE      'M'
     C     DFRECI        ANDNE     'R'
 
     C                   SELECT
     C     DFFSTS        WHENEQ    'C'
     C                   EVAL      DDSTAT = 'COMPLETE'
     C     DFFSTS        WHENEQ    'R'
     C                   EVAL      DDSTAT = 'REAUTHORISE REQ.'
     C     DFFSTS        WHENEQ    'A'
     C                   EVAL      DDSTAT = 'AUTHORISED'
     C     DFFSTS        WHENEQ    'D'
     C                   EVAL      DDSTAT = 'DELETED'
     C                   ENDSL
      *
     C                   ELSE
 
     C                   SELECT
     C     DFRECI        WHENEQ    'M'
     C                   EVAL      DDSTAT = 'MATURED'
     C     DFRECI        WHENEQ    'R'
     C                   EVAL      DDSTAT = 'REAUTHORISE REQ.'
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * RDTran - READ A TRANSACTION
      *****************************************************************
     C     RDTran        BEGSR
      *
      **  Reset End of File and skip record indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C                   DOU       @@EOF = 'Y' or
     C                             @@ERR = *ZERO and
     C                             DFLCDT <> 'D'
      *
      **  Read the file
      *
      **  Position according to Transaction number
      *
     C                   IF        WTrnK = 'B'
     C                   READ      DLFEEDD1                               96
     C                   ENDIF
      *
      **  Position according to Front Office Id
      *
     C                   IF        WTrnk = 'F'
     C                   READ      DLFEEDFO                               96
     C                   ENDIF
      *
      * End of File
      *
     C                   IF        *IN96 = *ON
     C                   EVAL      @@EOF = 'Y'
     C                   ENDIF
 
      ** If deal read, check whether user can see it
 
     C     @@EOF         IFNE      'Y'
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    DFBRCA
     C                   PARM                    @@ERR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
      *
     C     ERDCUST       ENDSR
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
     C                   IF        @@ERR = 1
     C                   EVAL      @ERRMS = 'FXM0292'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALTran - VALIDATE TRANSACTION REFERENCE POINTER
      *****************************************************************
     C     VALTran       BEGSR
      *
      **  Validate that the deal number reference is numeric or blank.
      *
     C                   TESTN                   DDDLNO               98
     C                   MOVE      DDDLNO        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C                   IF        DDDLNO = *BLANKS or
     C                             *IN98 = '1' and
     C                             *IN99 = '1'
     C                   IF        DDDLNO = *BLANKS
     C                   Z-ADD     *LOVAL        @@TRNN
     C                   ELSE
     C                   MOVE      DDDLNO        @@TRNN            6 0
     C                   ENDIF
      *
      * RETURN ERROR MESSAGE
      *
     C                   ELSE
     C                   EVAL      @ERRMS = 'MMM0162'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * CVTDAT - CONVERT DATE FROM Midas no. to DDMMYY (OR MMDDYY)    *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    WDAYNO                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE                          Value date
     C                   PARM      *ZEROS        ZADATE                         Run-date in DDM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT21
      *
     C                   EVAL      ZFLD15 = *ZEROS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * Clear outputs
      *
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @OPSEL = *BLANK
     C                   EVAL      @TRSEL = *BLANK
     C                   EVAL      @INKC  = '0'
     C                   EVAL      @INKI  = '0'
      *
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
      * Input Parameters :
      * Return Code
     C                   PARM                    RetCodeIn
      * Action Code
     C                   PARM                    DDACTN            1
      * Deal Number
     C                   PARM                    DDDLNO            6
      * Fee Sequence
     C                   PARM                    DDFSEQ            2
      * Build Subfile
     C                   PARM                    @BDSFL            1
      * Read Subfile Record
     C                   PARM                    @RDSFL            1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Output Parameters:
      * Error Message
      * Option Selected
      * Transaction Reference selected
     C                   PARM                    @ERRMS            7
     C                   PARM                    @OPSEL            1
     C                   PARM                    @TRSEL            6
      * Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKI             1
      *
      ** Initialize program name
     C                   EVAL      DBPGM = 'DLDLFEBRW'
      *
      ** Move workstation ID to screen field.
     C                   EVAL      DDWID = PsJobName
     C                   EVAL      DDUSER = PsUser
      *
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   MOVEL     '901'         DBASE
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CAS011
     C                   CALL      'AOGELRR1'                                                 CAS011
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CAS011
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS011
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** Functions for the message handler, ZAMSGHNDLE.
     **COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      *
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004

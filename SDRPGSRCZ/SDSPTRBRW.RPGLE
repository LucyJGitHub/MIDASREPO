     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot Rate Browse')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSPTRBRW - Spot Rate Details BROWSE                         *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of Spot Rate details           *
      *             for selection , the other picks off the           *
      *             selection made.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP057  *CREATE    Date 23Oct00               *
      *                 xxxxxx                                        *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDSPTRBDF CF   E             WORKSTN
     F                                     SFILE(SDSPTRS1:@@RRN)
     F                                     SFILE(SDSPTRS3:@@RRN)
      * Spot Rate Transaction Details File - by Transaction number
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@A6REA4:FILETRNN)
      ** Transaction file - by Front Office Id.
     FSDCURRL8  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCURRD0:FILEFOID)
 
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
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
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
      ** Set up the transaction reference to be used by the message handler
     C                   EVAL      TranRef = DDTRNN
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Initialization
      *
     C                   EXSR      INIT
 
      ** BUILD Sub-file
 
     C     @BDSFL        IFEQ      'Y'
      *
      **  If First time in or subfile by Midas transaction number was previously
      **  being run, then build subfile keyed on Midas transaction number.
      **  Stay in loop while F11 toggle key is used.
      *
     C     WTrnK         IFNE      'F'
     C     WTrnK         ANDNE     'S'
     C                   MOVE      'B'           WTrnK
      *
     C                   ENDIF
      *
     C     *INKK         DOUEQ     '0'
      *
      ** On F11, initialize position/select fields
      *
     C     *INKK         IFEQ      '1'
      *
     C                   MOVE      *BLANK        DDTRNN
      ** No position fields need to be initialized
 
      ** Clear program message queue
     C                   CALL      'ZA0250'
 
     C                   ENDIF
 
     C     WTrnK         CASEQ     'B'           BLDSFL
     C     WTrnK         CASEQ     'F'           BLDSFL2
     C                   ENDCS
     C                   ENDDO
 
     C                   ENDIF
 
      ** READ Subfile Record
 
     C     @RDSFL        IFEQ      'Y'
     C     WTrnK         ANDNE     *BLANK
     C                   EXSR      RDSFLR
     C                   END
 
 
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
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ** Validate spot rate (FOR POINTER)
      *
     C                   EXSR      VALSPTR
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDSPTRS0
     C                   MOVE      '0'           *IN97
      *
      **  Set file pointer on key displayed on screen.
      *
     C     @@TRNN        SETLL     FILETRNN
      *
      **  Read a Valid Transaction
      *
     C                   EXSR      RDSPTR
      *
      **  set up message 'no data to display'
      *
     C                   MOVE      *OFF          *IN80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   END
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
     C     *IN98         DOWEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Format transaction fields for output
      *
     C                   EXSR      FMTSPRT
      *
      **  Write the transaction to the subfile.
      *
      **  If action code or Transaction number selected is invalid
      **  the subfile postions on the error record and rebuilds
      *
     C                   MOVE      *OFF          *IN92
     C     @@RRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDTRNN    '  LOOKUP    FldNameArr                             98
     C     *IN99         IFNE      '1'
     C     *IN98         ANDNE     '1'
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C                   MOVE      *ON           *IN92
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SDSPTRS1
      *
      **  Read a valid Transaction
      *
     C                   EXSR      RDSPTR
     C                   ENDDO
      *
      **  Set up footer toggle text and write the footer
      *
     C                   WRITE     SDSPTRF1
      *
      **  Write the message subfile
      *
     C                   WRITE     SDSPTRM0
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C     @@CNT         IFEQ      0
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDSPTRS0
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     c                   MOVE      '1'           *IN93
     C                   WRITE     SDSPTRS1
     c                   MOVE      '0'           *IN93
     C                   WRITE     SDSPTRS0
     c                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SDSPTRS0
     c                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SDSPTRS0                               99
      *
      ** Clear any messages before processing user input
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      **  If F3, bypass further processing.
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
     C                   END
      *
      * Set indicator ans flag for Midas Front Office I.D. browse key   used
      *
     C     *INKK         IFEQ      '1'
     C                   MOVE      'F'           WTrnK             1
     C                   END
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
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ** Validate spot rate (FOR POINTER)
      *
     C                   EXSR      VALSPTR
      *
      **  Get Front Office Transaction Reference
      *
     C     @@TRNN        CHAIN     FILETRNN                           89
     C                   MOVE      A6SRID        @@FOID           20
     C     *IN89         IFEQ      '1'
     C                   MOVE      *BLANK        @@FOID
     C                   END
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDSPTRS2
     C                   MOVE      '0'           *IN97
      *
      **  Set file pointer on key displayed on screen.
      *
     C     @@FOID        SETLL     FILEFOID
      *
      ** Read a Valid Trade
      *
     C                   EXSR      RDSPTR
      *
      **  set up message 'no data to display'
      *
     C                   MOVE      *OFF          *IN80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   END
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
     C     *IN98         DOWEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format custo fields for output
      *
     C                   EXSR      FMTSPRT
      *
      **  Write the customer to the subfile.
      *
      **  If action code or Transaction number selected is invalid,
      **  the subfile postions on the error record and rebuilds
      *
     C                   MOVE      *OFF          *IN92
     C     @@RRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDTRNN    '  LOOKUP    FldNameArr                             98
     C     *IN99         IFNE      '1'
     C     *IN98         ANDNE     '1'
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C                   MOVE      *ON           *IN92
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SDSPTRS3
      *
      ** Read a valid Transaction
      *
     C                   EXSR      RDSPTR
     C                   END
      *
      **  Set up footer toggle text and write the footer
      *
     C                   WRITE     SDSPTRF1
      *
      **  Write the message subfile
      *
     C                   WRITE     SDSPTRM0
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C     @@CNT         IFEQ      0
     c                   MOVE      '1'           *IN97
     C                   WRITE     SDSPTRS2
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     C                   MOVE      '1'           *IN93
     C                   WRITE     SDSPTRS3
     C                   MOVE      '0'           *IN93
     C                   WRITE     SDSPTRS2
     C                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SDSPTRS2
     C                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SDSPTRS2                               99
      *
      ** Clear any messages before processing user input
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F9, bypass further processing.
      *
     C                   END
      *
      * Set indicator and flag for Midas (back) office Transaction number key
      *
     C     *INKK         IFEQ      '1'
     C                   MOVE      'B'           WTrnK
     C                   END
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
 
     C     WTrnK         IFEQ      'B'
     C                   READC     SDSPTRS1                               99
     C                   ENDIF
     C     WTrnK         IFEQ      'F'
     C                   READC     SDSPTRS3                               99
     C                   ENDIF
 
     C                   END
      *
      **  Return the selected transaction reference and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'D'
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   END
      *
     C                   MOVE      DDTRNN        @TRSEL
      *
     C                   END
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTTSPT- FORMAT TRANSACTION FOR OUTPUT
      ******************************************************************
     C     FMTSPRT       BEGSR
 
      * Transaction reference
 
     C                   MOVE      A6CYCD        DDTRNN
     C                   MOVE      A6CYCD        DDTRNN
     C                   MOVE      A6SRID        DDFOID
     C                   MOVE      A6CYNM        DDCYNM
     C     CEU002        IFEQ      'Y'
      ** Formating specific to euro rate
     C                   EXSR      FMEURT
     C                   ELSE
 
     C     A6SPRT        IFEQ      *ZERO
     C                   MOVEL     *BLANK        DDSPRT
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   Z-ADD     8             ZADEC                    130869
     C                   MOVE      A6SPRT        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDSPRT
     C                   ENDIF
     C                   MOVE      A6MDIN        DDMDIN
     C                   EVAL      %SUBST(DDDLSW:1) = A6DLCI
     C                   EVAL      %SUBST(DDDLSW:4) = A6SWCY
 
     C                   ENDIF
 
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * RDSPTR - READ A TRANSACTION
      *****************************************************************
     C     RDSPTR        BEGSR
      *
      **  Reset End of File and skip record indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     A6CYCD        ORNE      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
      *
      **  Read the file
     C     WTrnK         IFEQ      'B'
     C                   READ      FILETRNN                               96
     C                   ENDIF
     C     WTrnK         IFEQ      'F'
     C                   READ      FILEFOID                               96
     C                   ENDIF
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
     C                   END
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
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALSPTR - VALIDATE SPOT RATE POINTER
      *****************************************************************
     C     VALSPTR       BEGSR
     C                   MOVE      *LOVAL        @@TRNN            3
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
     C                   MOVE      *BLANK        @TRSEL
     C                   MOVE      '0'           @INKC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMEURT - FORMATING SPECIFIC TO EURO RATE
      *****************************************************************
     C     FMEURT        BEGSR
     C     *LIKE         DEFINE    A6CYCD        PICYCD
     C     *LIKE         DEFINE    A6MDIN        PIMDIN
     C     *LIKE         DEFINE    A6SPRT        PISPRT
     C     *LIKE         DEFINE    A6INER        PIINER
     C     *LIKE         DEFINE    A6INMD        PIINMD
     C     *LIKE         DEFINE    A6DLCI        PIDLCI
     C     *LIKE         DEFINE    A6SWCY        PISWCY
     C     *LIKE         DEFINE    A6MDIN        #SMDIN
     C     *LIKE         DEFINE    A6MDIN        #SMDI2
     C     *LIKE         DEFINE    #SPRA         #SPRA2
     C     *LIKE         DEFINE    DDDLSW        DLSW
     C     *LIKE         DEFINE    DDDLSW        DLSW2
 
     C                   CALLB     'SDSPTRDEU'                          90
     C                   PARM                    RetCodeIn
     C                   PARM      A6CYCD        PICYCD
     C                   PARM      A6MDIN        PIMDIN
     C                   PARM      A6SPRT        PISPRT
     C                   PARM      A6INER        PIINER
     C                   PARM      A6INMD        PIINMD
     C                   PARM      A6DLCI        PIDLCI
     C                   PARM      A6SWCY        PISWCY
     C     DDSPRT        PARM                    #SPRA            14
     C     DDDLSW        PARM                    DLSW
     C     DDMDIN        PARM                    #SMDIN
     C                   PARM                    #SPRA2
     C                   PARM                    DLSW2
     C                   PARM                    #SMDI2
 
     C                   IF        RetCodeIn <> *BLANK OR *IN90
     C                   MOVEL     'SDSPTRDEU'   DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     A6CYCD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
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
      * Return Code
     C                   PARM                    RetCodeIn
      * Action Code
     C                   PARM                    DDACTN            1
      * Transaction Reference Pointer
     C                   PARM                    DDTRNN            3
      * Build Subfile
     C                   PARM                    @BDSFL            1
      * Read Subfile Record
     C                   PARM                    @RDSFL            1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * OUTPUT PARAMETERS :
      * Error Message
      * Option Selected
      * Transaction Reference selected
     C                   PARM                    @ERRMS            7
     C                   PARM                    @OPSEL            1
     C                   PARM                    @TRSEL            3
      * Command Keys
     C                   PARM                    @INKC             1
      *
      ** Initialize program name
     C                   MOVEL     'SDSPTRBRW'   DBPGM
      *
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
      *
     C                   MOVE      '1'           *IN94
     C                   MOVEL     '*'           DDPGMQ
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
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
 
      ** Check if switchable feature CEU002 is switched on.
      ** Euro rates
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU002'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU002'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU002            1
     C                   ELSE
     C                   MOVE      'N'           CEU002
     C                   END
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      *
      /EJECT
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
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
(c) Misys International Banking Systems Ltd. 2001

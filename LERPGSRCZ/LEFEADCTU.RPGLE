     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee adjustment control')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFEADCTU - Fee Adjustment Control and Update                *
      *                                                               *
      *  Function:  This program allows entry and maintenance of      *
      *             fee adjustments.                                  *
      *             It is a batch function.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE073             Date 13May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG1218            Date 01Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 10Mar03               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  BUG27041 - Incorrect mapping for MQ STCQ (Recompile)         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Autorisation to the API's            *
      *           without it (Recompile)                              *
      *  BUG1218- Status not shown                                    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Valid file changed to match LEFEEAD - recompile     *
      *  CLE031 - Lending Enhancements.                               *
      *           LEFEED & LEFEEAD changed  - recompile               *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FLEIFEADPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FAPILSETPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FZATRNERRPDO  A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      ** Fee Adjustment Details in screen format
     D FEAD          E DS                  EXTNAME(LEFEADPD)
 
      ** Fee Adjustment Details OK indicator
     D FEAD_OK       E DS                  EXTNAME(LEEFEADPD)
 
      ** Fee Adjustment Details in file format
     D LEFEEADFmt    E DS                  EXTNAME(LEFEEAD)
 
      ** New Fee Adjustment Details in file format
     D LEVFEADPD     E DS                  EXTNAME(LEVFEADPD)
     D LEVFEADOURS   E                     EXTFLD(QQOURS)                                     CGL029
 
      ** Current Fee Adjustment Details in screen format
     D C_FEAD        E DS                  EXTNAME(LEFEADPD)
     D                                     PREFIX(C_)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LEF5MFPD)
     D P#INMFRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D P#INMFPONS    E                     EXTFLD(QQPONS)                                     CGL029
 
      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LEF6MFPD)
 
      /SPACE 5
 
      * Initialisation
     C                   EXSR      INITPR
 
      ** Map incoming data into the screen fields
 
     C                   EXSR      MAPFLD
 
      ** Validate action code
 
     C                   EXSR      ValidateAc
 
      *  If error in validation of action code, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
      * Inserts
      * =======
 
     C     S#ACTN        WHENEQ    'I'
 
     C                   EXSR      ValidateTR
 
      * Amends
      * ======
 
     C     S#ACTN        WHENEQ    'A'
 
     C                   EXSR      ValidateTR
 
     C                   EXSR      ValdateAmd
 
      * Deletions
      * =========
 
     C     S#ACTN        WHENEQ    'D'
 
      * Authorisations
      * ==============
 
     C     S#ACTN        WHENEQ    'X'
 
     C                   ENDSL
 
     C     INVALID       TAG
 
      ** Do updates for this transaction
      ** according to whether it is valid or invalid
 
     C     Idx           IFEQ      0
     C                   EXSR      UPDAT_VAL
     C                   ENDIF
     C     Idx           IFNE      0
     C                   EXSR      UPDAT_INVAL
     C                   ENDIF
 
      **  Terminate program
 
     C                   SETON                                        LR
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      **  Map the input data read from the transmitted message.
      *****************************************************************
     C     MAPFLD        BEGSR
 
     C                   MOVEL     F5FIL3        RPLOC             1
      *
      ** Fee adjustment details
      *
     C                   CLEAR                   FEAD
     C                   MOVE      F5ACTN        S#ACTN
      *
     C                   MOVEL     F5CNUM        S#CSSN
     C                   MOVE      F5FACT        S#FACT
     C                   MOVE      F5FCNO        S#FCNO
     C                   MOVE      F5SEQR        S#FSEQ
     C                   MOVE      F5SADJ        S#SADJ
     C                   MOVE      F5SIGN        S#SIGN
     C                   MOVE      F5LOAN        S#LOAN                                       CLE073
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the action
      *****************************************************************
     C     ValidateAc    BEGSR
 
     C                   CALLB     'LEFEADRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Response Code
     C                   PARM      ' '           RESPMODE          1
 
      * Action, customer, facility type, facility number
      * and fee sequence number
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FSEQ            2
     C                   PARM                    S#LOAN            6                          CLE073
 
      *
      * OUTPUTS
 
      * Fee Adjustment Details in file format
     C                   PARM                    LEFEEADFmt
 
      * Action, customer, facility type, facility number
      * and fee sequence number OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FSEQok          1
     C                   PARM                    S#LOANok          1                          CLE073
 
      * Customer number
     C                   PARM                    S#CNUM            6
 
      * Fee currency and decimal places
     C                   PARM                    S#FCCY            3
     C                   PARM                    FecyNBDP          1 0
 
      * Fee type, fee code, fee narrative, total fee accrued to date
     C                   PARM                    S#FTYP           10
     C                   PARM                    S#FCOD            2
     C                   PARM                    S#FENV           20
     C                   PARM                    S#ACCD           18
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
 
      ** TNLU used in 'record updated by another WS' checking
 
     C                   Z-ADD     FATNLU        H#TNLU
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate transaction
      *****************************************************************
     C     ValidateTr    BEGSR
 
     C                   CALLB     'LEFEADVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Fee Adjustment Details in screen format
     C                   PARM                    FEAD
 
      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * Front Office Inputs (if mode = 'B')
     C                   PARM                    F5PCOB            3
     C                   PARM                    F5TNRF           15
      *
      * OUTPUTS
 
      * Status                                                                  BUG1218
     C                   PARM                    S#STAT           10            BUG1218
      * Adjustment amount
     C                   PARM                    W#SADJ           13 0
 
      * Adjustment amount edited
     C                   PARM                    S#SADE           19
 
      * Field OK flags
     C                   PARM                    FEAD_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
 
      * Valid Fee Adjustment
     C                   PARM                    LEVFEADPD
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate amendments
      *****************************************************************
     C     ValdateAmd    BEGSR
 
      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.
 
     C                   CALLB     'LEFEADCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Fee Adjustment details in file format
     C                   PARM                    LEFEEADFmt
      *
      * OUTPUTS
      *
      * Fee Adjustment Details in screen format
     C                   PARM                    C_FEAD
 
      * Customer details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0
 
      * Adjustment amount edited
     C                   PARM                    S#SADE           19
 
      * Record status
     C                   PARM                    S#STAT           10
 
     C                   CALLB     'LEFEADAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * New fee adjustment in Screen Format
     C                   PARM                    FEAD
      *
      * Current fee adjustment in Screen Format
     C                   PARM                    C_FEAD
      *
      * Current fee adjustment in File Format
     C                   PARM                    LEFEEADFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    FEAD_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx             3 0
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           ResetErrs         1
 
      ** If any errors overwrite previous error information
 
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Updates - if invalid transaction
      *****************************************************************
     C     UPDAT_INVAL   BEGSR
 
      ** If repair in back-office
 
     C     RPLOC         IFEQ      'B'
 
      ** Write to the invalid (repair) files
 
     C                   CALL      'LEC0215'
     C                   PARM                    XREPN
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    XTMST
     C                   WRITE     LEIFEADD0
     C                   WRITE     APILSETD0
     C                   EXSR      W_ZATRNERR
 
      ** Commit the database changes
 
     C                   COMMIT
 
     C                   ENDIF
 
      ** Get the text for the first error message
 
     C                   MOVEL     MsgIDArr(1)   ZAMSID
     C     ZAMSID        IFNE      *BLANK
     C                   CALL      'Y2RVMGC'                            9999
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM      *BLANK        ZAMSDA          132
     C                   PARM      *BLANK        ZAMSTX          132
     C                   ENDIF
 
      ** Set up the returned message format
 
     C                   MOVE      F5MSGT        F6MSGT
     C                   MOVE      F5TRUS        F6TRUS
     C                   MOVE      F5TRWS        F6TRWS
     C                   MOVE      F5TNRF        F6TNRF
     C                   MOVE      F5TRSN        F6TRSN
     C                   MOVE      F5ACTN        F6ACTN
     C                   MOVE      F5TRDS        F6TRDS
     C                   MOVE      F5TRTS        F6TRTS
     C                   MOVE      F5NRBA        F6NRBA
     C                   MOVEL     'E'           F6MSGS
     C                   MOVEL     ZAMSID        F6MSGI
     C                   MOVEL     ZAMSTX        F6MSTX
     C                   MOVE      F5CNUM        F6CNUM
     C                   MOVE      F5FACT        F6FACT
     C                   MOVE      F5FCNO        F6FCNO
     C                   MOVE      F5SEQR        F6SEQR
     C                   MOVE      F5LOAN        F6LOAN                                       CLE073
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Updates - if valid transaction
      *****************************************************************
     C     UPDAT_VAL     BEGSR
 
      ** Update the database
 
     C                   EXSR      UPD_DBASE
 
      ** If there were errors, rollback any database changes and increment
      ** the error index by 1 to drive the 'invalid' record processing
 
     C     RetCodeOut    IFNE      *BLANK
 
     C                   ADD       1             Idx
 
     C                   ROLBK
 
     C                   ELSE
 
      ** Commit the database changes
 
     C                   COMMIT
 
      ** Set up the returned message format
 
     C                   MOVE      F5MSGT        F6MSGT
     C                   MOVE      F5TRUS        F6TRUS
     C                   MOVE      F5TRWS        F6TRWS
     C                   MOVE      F5TNRF        F6TNRF
     C                   MOVE      F5TRSN        F6TRSN
     C                   MOVE      F5ACTN        F6ACTN
     C                   MOVE      F5TRDS        F6TRDS
     C                   MOVE      F5TRTS        F6TRTS
     C                   MOVE      F5NRBA        F6NRBA
     C                   MOVE      F5CNUM        F6CNUM
     C                   MOVE      F5FACT        F6FACT
     C                   MOVE      F5FCNO        F6FCNO
     C                   MOVE      F5SEQR        F6SEQR
     C                   MOVE      F5LOAN        F6LOAN                                       CLE073
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update the Database                                           *
      *****************************************************************
     C     UPD_DBASE     BEGSR
      *
     C                   CALLB     'LEFEADUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Action code
     C                   PARM                    S#ACTN            1
 
      * Fee Adjustment Details in file format
     C                   PARM                    LEVFEADPD
 
      * Fee currency
     C                   PARM                    S#FCCY            3
 
      * Adjustment amount
     C                   PARM                    W#SADJ           13 0
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * TNLU of fee adjustment record on LEFEEAD
     C                   PARM                    H#TNLU            5 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * Front office inputs (if mode = 'B')
     C                   PARM                    F5PCOB            3
     C                   PARM                    F5TNRF           15
     C                   PARM                    F5IUSR           10
     C                   PARM                    F5XUSR           10
     C                   PARM                    F5AUSR           10
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FEAD_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Write to the transaction errors file                          *
      *****************************************************************
     C     W_ZATRNERR    BEGSR
 
     C                   MOVE      XREPN         ##REPN            5
     C                   EVAL      ABFOTRNID  = 'LE' + ##REPN
     C                   EVAL      ABMIDASMOD = 'LE'
     C                   EVAL      ABMSGFILE  = ZAMSGF
     C                   EVAL      ABTMESTMP  = XTMST
 
      *  Do while error messages found
      *  Write error messages to file
 
     C                   Z-ADD     1             #C                2 0
     C     #C            DOWLE     ArrayMax
     C     FldNameArr(#C)ANDNE     *BLANKS
     C                   MOVEL     FldNameArr(#C)ABFIELDNAM
     C                   MOVEL     MsgIdArr(#C)  ABMSGID
     C                   WRITE     ZATRNERRD0
     C                   ADD       1             #C
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Initial Processing                                            *
      *****************************************************************
     C     INITPR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#MODE            1
     C                   PARM                    P#INMF
     C                   PARM                    P#OUMF
      *
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     901           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     'LERMSGF '    ZAMSGF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Program exception error routine                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVE      'D'           F6MSGS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002

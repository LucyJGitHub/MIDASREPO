     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility amendment control and update')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFAMDCTU - Facility Amendment Control and Update            *
      *                                                               *
      *  Function:  This program allows entry and maintenance of      *
      *             facility amendments.                              *
      *             It is a batch function.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10384           Date 06Feb06               *
      *                 CAP086             Date 07Jul05               *
      *                 222373             Date 30Oct03               *
      *                 CAP084             Date 20Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP071 *CREATE     Date 19Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00255                                 *
      *             WNCPYSRC,LEH00256                                 *
      *  BUG27041 - Incorrect mapping for MQ STCQ (Recompile)         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10384 - Display Facility UTN and Facility Event UTN       *
      *             correctly.                                        *
      *  CAP086 - Introduce Auto Autorisation to the API's            *
      *           without it (Recompile)                              *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - Change S#CNUM to be 10 long instead of 6            *
      *  CAP071 - Conversion of LE inputs into modular structure to   *
      *           use as API's.                                       *
      *                                                               *
      *****************************************************************
 
     FLEIFAMDPD O  A E             DISK    INFSR(*pssr)
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
 
      ** Facility Amendment Details in screen format
     D FAMD          E DS                  EXTNAME(LEFAMDPD)
 
      ** Facility Amendment Details OK indicator
     D FAMD_OK       E DS                  EXTNAME(LEEFAMDPD)
 
 
      ** Facility Amendment Details in file format
     D LEFCAMPDFmt   E DS                  EXTNAME(LEFCAMPD)
 
      ** New facility Amendment Details in file format
     D LEVFAMDPD     E DS                  EXTNAME(LEVFAMDPD)
     D  V_REC                 72    140
     D  V_PAY                141    699
 
      ** Current Facility Amendment Details in screen format
     D C_FAMD        E DS                  EXTNAME(LEFAMDPD)
     D                                     PREFIX(C_)
 
 
      * Facility run dates
     D  @RUNA          DS            50
 
      * Facility drawn amounts
     D  @OAMA          DS           130
 
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LEA5MFPD)
 
      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LEA6MFPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
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
 
      *  Amends
      *  ======
 
     C     S#ACTN        WHENEQ    'A'
 
     C                   EXSR      ValidateTR
 
     C                   EXSR      ValdateAmd
 
      *  Deletions
      *  =========
 
     C     S#ACTN        WHENEQ    'D'
 
      *  Authorisations
      *  ==============
 
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
 
     C                   MOVEL     A5RPLC        RPLOC             1
      *
      ** Facility amendment details
      *
     C                   CLEAR                   FAMD
     C                   MOVE      A5ACTN        S#ACTN
      *
     C                   MOVEL     A5CNUM        S#CSSN
     C                   MOVE      A5FACT        S#FACT
     C                   MOVE      A5FCNO        S#FCNO
     C                   MOVE      A5MSGT        S#FATP
     C                   MOVEL     A5VDTC        S#VLDT
     C                   MOVE      A5VDTC        ##YEAR            2
     C                   MOVE      ##YEAR        S#VLDT
     C                   MOVE      A5SQNO        S#SQNO
     C                   MOVE      A5ACCY        S#ACCY
     C                   MOVE      A5AAMT        S#AAMT
     C                   MOVE      *BLANK        S#SIGN
     C                   MOVE      A5RVCR        S#RVCR
     C                   MOVEL     A5NDEX        S#NDEX
     C                   MOVE      A5NDEX        ##YEAR
     C                   MOVE      ##YEAR        S#NDEX
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the action
      *****************************************************************
     C     ValidateAc    BEGSR
 
     C                   CALLB     'LEFAMDRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
      * Response Code
     C                   PARM      ' '           RESPMODE          1
 
      * Action, customer, facility type, facility number, facility
      * amendment type, value date and sequence number
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FATP            2
     C                   PARM                    S#VLDT            6
     C                   PARM                    S#SQNO            3
 
      *
      * OUTPUTS
 
      * Facility Amendment Details in file format
     C                   PARM                    LEFCAMPDFmt
 
      * Action, customer, facility type, facility number, facility
      * amendment type, value date and sequence number OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FATPok          1
     C                   PARM                    S#VLDTok          1
     C                   PARM                    S#SQNOok          1
 
      * Customer number
     C**********         PARM                    S#CNUM            6                          CAP084
     C                   PARM                    S#CNUM           10                          CAP084
 
      * Value date of amendment
     C                   PARM                    W#VLDT            5 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
      * Facility tranche/credit agreement ind
      * Facility revolving credit indicator
      * Facility record ID
      * Facility date of expiry
      * Facility closure date
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C                   PARM                    FcrvRVCR          1
     C                   PARM                    FcRECI            1
     C                   PARM                    FcDTEX            5 0
     C                   PARM                    FcCDTE            5 0
     C/COPY WNCPYSRC,LEH00255
 
      * Facility run dates
      * Facility drawn amounts
     C                   PARM                    @RUNA
     C                   PARM                    @OAMA
                                                                                            BUG10384
      ** Facility UTN                                                                       BUG10384
     C                   PARM                    S#FUTN           15                        BUG10384
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
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate transaction
      *****************************************************************
     C     ValidateTr    BEGSR
 
     C                   CALLB     'LEFAMDVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Facility Amendment Details in screen format
     C                   PARM                    FAMD
 
      * Value date of amendment
     C                   PARM                    W#VLDT            5 0
 
      * Generated by assignment
     C                   PARM                    A5GASS            1
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
      * Facility tranche/credit agreement ind
      * Facility revolving credit indicator
      * Facility record ID
      * Facility date of expiry
      * Facility closure date
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C                   PARM                    FcrvRVCR          1
     C                   PARM                    FcRECI            1
     C                   PARM                    FcDTEX            5 0
     C                   PARM                    FcCDTE            5 0
     C/COPY WNCPYSRC,LEH00256
 
      * Front Office Inputs (if mode = 'B')
     C                   PARM                    A5PCOB
     C                   PARM                    A5TNRF
 
      * Facility run dates
      * Facility drawn amount
     C                   PARM                    @RUNA
     C                   PARM                    @OAMA
 
      **Front*Office Inputs (if mode = 'B')                                                   222373
     C**********         PARM                    A5PCOB                                       222373
     C**********         PARM                    A5TNRF                                       222373
      **********                                                                              222373
      * OUTPUTS
 
      * Amendment amount
     C                   PARM                    W#AAMT           13 0
 
      * Field OK flags
     C                   PARM                    FAMD_OK
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
 
      * Valid Facility Amendment
     C                   PARM                    LEVFAMDPD
 
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
 
     C                   CALLB     'LEFAMDCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      * Facility Amendment details in file format
     C                   PARM                    LEFCAMPDFmt
 
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * OUTPUTS
      *
      * Facility Amendment Details in screen format
     C                   PARM                    C_FAMD
 
      * Customer details
     C**********         PARM                    S#CNUM            6                          CAP084
     C                   PARM                    S#CNUM           10                          CAP084
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Facility amendment type narrative
      * Record status
      * Value date in alpha format
     C                   PARM                    S#FATN           24
     C                   PARM                    S#STAT           10
     C                   PARM                    S#VLDA            7
 
     C                   CALLB     'LEFAMDAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * New facility amendment in Screen Format
     C                   PARM                    FAMD
      *
      * Current facility amendment in Screen Format
     C                   PARM                    C_FAMD
      *
      * Current facility amendment in File Format
     C                   PARM                    LEFCAMPDFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    FAMD_OK
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
     C                   WRITE     LEIFAMDD0
     C                   EXSR      W_ZATRNERR
 
      ** Commit the database changes
 
     C                   COMMIT
 
     C                   ENDIF
 
      ** Get the text for the first error message
 
     C                   MOVEL     MsgIDArr(1)   ZAMSID
     C     ZAMSID        IFNE      *BLANK
     C                   CALL      'Y2RVMGC'                            9999
     C                   PARM                    @RTCD
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM      *BLANK        ZAMSDA          132
     C                   PARM      *BLANK        ZAMSTX          132
     C                   ENDIF
 
      ** Set up the returned message format
 
     C                   MOVE      A5MSGT        A6MSGT
     C                   MOVE      A5TRUS        A6TRUS
     C                   MOVE      A5TRWS        A6TRWS
     C                   MOVE      A5TNRF        A6TNRF
     C                   MOVE      A5TRSN        A6TRSN
     C                   MOVE      A5ACTN        A6ACTN
     C                   MOVE      A5TRDS        A6TRDS
     C                   MOVE      A5TRTS        A6TRTS
     C                   MOVE      A5NRBA        A6NRBA
     C                   MOVEL     'E'           A6MSGS
     C                   MOVEL     ZAMSID        A6MSGI
     C                   MOVEL     ZAMSTX        A6MSTX
     C                   MOVE      A5CNUM        A6CNUM
     C                   MOVE      A5FACT        A6FACT
     C                   MOVE      A5FCNO        A6FCNO
     C                   MOVE      A5VDTC        A6VDTC
     C                   MOVE      A5SQNO        A6FASQ
 
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
 
     C                   MOVE      A5MSGT        A6MSGT
     C                   MOVE      A5TRUS        A6TRUS
     C                   MOVE      A5TRWS        A6TRWS
     C                   MOVE      A5TNRF        A6TNRF
     C                   MOVE      A5TRSN        A6TRSN
     C                   MOVE      A5ACTN        A6ACTN
     C                   MOVE      A5TRDS        A6TRDS
     C                   MOVE      A5TRTS        A6TRTS
     C                   MOVE      A5NRBA        A6NRBA
     C                   MOVE      A5CNUM        A6CNUM
     C                   MOVE      A5FACT        A6FACT
     C                   MOVE      A5FCNO        A6FCNO
     C                   MOVE      A5VDTC        A6VDTC
     C     S#ACTN        IFEQ      'I'
     C                   MOVE      A_SQNO        A6FASQ
     C                   ELSE
     C                   MOVE      A5SQNO        A6FASQ
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update the Database                                           *
      *****************************************************************
     C     UPD_DBASE     BEGSR
      *
     C                   CALLB     'LEFAMDUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Action Code
     C                   PARM                    S#ACTN
 
      * Amendment Details in file format
     C                   PARM                    LEVFAMDPD
 
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FAMD_OK
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
 
      * Sequence assigned
     C                   PARM                    A_SQNO            3
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
 
      ** Access API ICD via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   Z-ADD     902           DBASE
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
     C                   MOVE      'D'           A6MSGS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002

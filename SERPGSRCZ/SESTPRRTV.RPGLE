     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statmts Prod. Requests - Details Retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SESTPRRTV - Statements Production Requests - Retrieve  *
      *             (With Action Code Versus Transact.No. Validation) *
      *                                                               *
      *  Function:  This module retrieves a statement production      *
      *             request from the database. As it does so, it      *
      *             validates action code and request Key Fields.     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 TDA035             Date 02Apr04               *
      *                 CSE040   *CREATE   Date 18Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSESTPRL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SESTPRD0:SESTPRD3)
      ** Statement Production Requests by Front Office Id.
 
     FSESTPRL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SESTPRD0:SESTPRD1)
      ** Statement Production Requests by Main Key
 
     FSESTPRL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SESTPRD0:SESTPRD2)
      ** Statement Production Requests - Alternative key
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
 
     D SDUSER        E DS                  EXTNAME(MUSERDD) PREFIX(US_)
      ** External DS for User Details
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
     D SESTPR        E DS                  EXTNAME(SESTPRPD)
      ** Statement Production Request in file format
 
      ** Split up of the Statement Production Request Reference
     D DDStPRRef       DS
      ** -- Main key (used in SIN function)
     D  DDDATE                        6A
     D  DDRSEQ                        7A
      ** -- Alternative key (used in CTL & RPR functions)
     D  DDCUST                        6A
     D  DDTYPE                        2A
     D  DDSNDR                        3A
     D  DDRECP                       11A
     D  DDFREQ                        1A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Ix              S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ subroutine is executed at program activation.              ¦
      ** +------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   EXSR      INIT
      *
      ** If the mode is 'Front Office Transaction Interface'
      ** Do (Extra) Validation for Front Office Transaction Interface
      *
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      VFRNT
      *
      ** Carry out no further validation if errors have occurred.
      *
     C                   IF        DDACTNOK = 'N'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Action Code
      *
     C                   EXSR      VAL
      *
      ** Carry out no further validation if errors have occurred.
      *
     C                   IF        DDACTNOK = 'N' OR
     C                             DDDATEOK = 'N'
     C                   RETURN
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'I'
     C                   EXSR      VALACI
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'E'
     C                   EXSR      RtvStPR
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'A'
     C                   EXSR      RtvStPR
     C                   EXSR      VALACA
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'X' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'X'
     C                   EXSR      RtvStPR
     C                   EXSR      VALACX
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'D'
     C                   EXSR      RtvStPR
     C                   EXSR      VALACD
     C                   ENDIF
      *
      **  Carry out no further validation if errors have occurred.
      *
     C                   IF        DDACTNOK = 'N' OR
     C                             DDDATEOK = 'N'
     C                   RETURN
     C                   ENDIF
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C                   IF        RespMode = 'S'
     C                   EVAL      ZACTN = DDACTN
      *
      ** If single branching
      ** Access Security Checking - Single Branching
      *
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      ACSSES
      *
      ** If multibranching
      ** Access Security Checking - Multi-Branching
      *
     C                   ELSE
     C                   EXSR      ACSSEM
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      ** Error if Action Code isn't "I","A","E","D" or "X"
      ** Note: "X" is only for routing officers
      *
     C                   IF        (DDACTN <> 'I' AND
     C                              DDACTN <> 'A' AND
     C                              DDACTN <> 'E' AND
     C                              DDACTN <> 'D' AND
     C                              DDACTN <> 'X')
     C                                           OR
     C                             (DDACTN = 'X' AND US_ROUF <> 'Y')
     C                   EVAL      DDACTNOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      ** Error if Front Office Transaction ID is Blank
      *
     C                   IF        FOTRID = *BLANK
     C                   EVAL      DDACTNOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      ** Access Transaction with Front Office Transaction ID
      *
     C     FOTRID        CHAIN     SESTPRD3                           99
      *
      ** If Insert
      *
     C                   IF        DDACTN = 'I'
      *
      ** Front Office Transaction ID can't be Present already
      *
     C                   IF        NOT *IN99
     C                   EVAL      DDACTNOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'APM0202'     MsgIdArr(Ix)
     C   99              MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If not insert, Front Office Transaction ID Must be Present
      *
     C                   IF        *IN99
     C                   EVAL      DDACTNOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'APM0203'     MsgIdArr(Ix)
     C   99              MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE
      *****************************************************************
     C     VAL           BEGSR
      *
      ** Action Code
      **  .. must be 'I','A','D','E' or 'X'
      **  .. Note: "X" is only for routing officers
      *
     C                   IF        (DDACTN <> 'I' AND
     C                              DDACTN <> 'A' AND
     C                              DDACTN <> 'D' AND
     C                              DDACTN <> 'E' AND
     C                              DDACTN <> 'X')
     C                                           OR
     C                             (DDACTN = 'X' AND US_ROUF <> 'Y')
     C                   EVAL      DDACTNOK = 'N'
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION FOR ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
      *
      ** As the sequence number, which is the last part of the key, is
      ** incremented at each input of a new request, this new request
      ** can never be already present in file.
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RtvStPR - Retrieve request details if action code 'A', 'E' or 'D'
      *****************************************************************
     C     RtvStPR       BEGSR
      *
      ** The SIN function uses the main key, while the CTL and RPR
      ** functions are more likely to use the alternative key
      *
     C                   IF        DDDATE <> *Blanks
     C                   EXSR      RtvStPR1
     C                   ELSE
     C                   EXSR      RtvStPR2
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RtvStPR1 - Retrieve request details from main key
      *            if action code 'A', 'E' or 'D'
      *****************************************************************
     C     RtvStPR1      BEGSR
      *
      ** The front office can send us both Front Office ID and request ID;
      ** When the RTV is called in the back office the request ID must be valid
      *
 B1  C                   IF        SubForMain = 0 OR ModeofOp <> '*FRONT'
      *
      ** Convert the request date
      *
     C                   MOVE      DDDATE        ZDATE
     C                   EXSR      ZDATE1
     C     ErrorFlag     COMP      'Y'                                    99
     C  N99              MOVE      ZDAYNO        SPDATE
      *
      ** The sequence number must be numeric
      *
 B2  C                   IF        NOT *IN99
     C                   MOVEL     DDRSEQ        WWTEST8           8
     C                   MOVE      '0'           WWTEST8
     C                   TESTN                   WWTEST8              98
     C   98              MOVE      DDRSEQ        SPRSEQ
     C  N98              SETON                                        99
 E2  C                   ENDIF
      *
      ** Access the file by main key if no error
      *
     C  N99KSESTPRL1     CHAIN     SESTPRD1                           99
      *
      ** Not found
      *
 B2  C                   IF        *IN99
     C                   MOVEL     'N'           DDDATEOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDDATE'      FldNameArr(Ix)
     C   99              MOVEL     'ST00053'     MsgIdArr(Ix)
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RtvStPR2 - Retrieve request details from alternative key
      *            if action code 'A', 'E' or 'D'
      *****************************************************************
     C     RtvStPR2      BEGSR
      *
      ** The front office can send us both Front Office ID and request ID;
      ** When the RTV is called in the back office the request ID must be valid
      *
 B1  C                   IF        SubForAlt = 0 OR ModeofOp <> '*FRONT'
      *
      ** Access the file by alternative key
      *
     C     KSESTPRL2     CHAIN     SESTPRD2                           99
      *
      ** Not found
      *
 B2  C                   IF        *IN99
     C                   MOVEL     'N'           DDDATEOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDDATE'      FldNameArr(Ix)
     C   99              MOVEL     'ST00054'     MsgIdArr(Ix)
      *
      ** If found, the key must identify one unique record
      ** (the same reference can have several "Z" and/or "I" frequencies)
      *
 X2  C                   ELSE
     C     KSESTPRL2     READE     SESTPRD2                               99
      *
 B3  C                   IF        NOT *IN99
     C                   CLEAR                   SESTPR
     C                   MOVEL     'N'           DDDATEOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDDATE'      FldNameArr(Ix)
     C   99              MOVEL     'ST00055'     MsgIdArr(Ix)
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - Validation for action code 'A'
      *****************************************************************
     C     VALACA        BEGSR
      *
      ** Can't modify a deleted request
      *
     C                   IF        DDACTNOK = 'Y' AND DDDATEOK = 'Y' AND
     C                             SPCHTP = 'D'
     C                   MOVEL     'N'           DDACTNOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'ST00033'     MsgIdArr(Ix)
     C                   ENDIF
      *
      ** Can't modify an authorized request having a frequency of 'Z'
      *
     C                   IF        DDACTNOK = 'Y' AND DDDATEOK = 'Y' AND
     C                             SPCHTP = 'X'   AND SPFREQ = 'Z'
     C                   MOVEL     'N'           DDACTNOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'ST00056'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACX - Validation for action code 'X'
      *****************************************************************
     C     VALACX        BEGSR
      *
      ** Can't authorise a deleted or already authorised request
      *
     C                   IF        DDACTNOK = 'Y' AND DDDATEOK = 'Y' AND
     C                             (SPCHTP = 'D' OR SPCHTP = 'X')
     C                   MOVEL     'N'           DDACTNOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'ST00033'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - Validation for action code 'D'
      *****************************************************************
     C     VALACD        BEGSR
      *
      ** Verify that the request is not already deleted
      *
     C                   IF        DDACTNOK = 'Y' AND DDDATEOK = 'Y' AND
     C                             SPCHTP = 'D'
     C                   MOVEL     'N'           DDACTNOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'ST00042'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      ** Check user's authority for the action.
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
      *
      ** If action invalid for user
      *
     C                   IF        ERR <> 0
     C                   MOVEL     'N'           DDACTNOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'ST00041'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      ** Check user's authority for the action & Sending Branch
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C                   PARM      SPSNDR        ZBR               3
     C                   PARM                    ERR
      *
      ** If action invalid for user
      *
     C                   IF        ERR <> 0
     C                   MOVEL     'N'           DDACTNOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'ST00041'     MsgIdArr(Ix)
     C                   GOTO      EACSSEM
     C                   ENDIF
      *
      ** Check user's authority for the action & Originating Branch
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C                   PARM      SPORIG        ZBR
     C                   PARM                    ERR
      *
      ** If action invalid for user
      *
     C                   IF        ERR <> 0
     C                   MOVEL     'N'           DDACTNOK
     C     Ix            COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Ix
     C   99              MOVEL     'DDACTN'      FldNameArr(Ix)
     C   99              MOVEL     'ST00041'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     EACSSEM       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDATE1 - Format a date for input
      *****************************************************************
     C     ZDATE1        BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Clear Outputs
      *
     C                   CLEAR                   SESTPR
      *
     C                   EVAL      DDACTNOK = 'Y'
     C                   EVAL      DDDATEOK = 'Y'
      *
      ** Check for the existence of the replacement character in the
      ** request reference
      *
     C                   Z-ADD     0             SubForMain        2 0
     C                   Z-ADD     0             SubForAlt         2 0
      *
     C                   IF        GHSUBS <> *Blank
      ** Main key
     C                   IF        %Scan(GHSUBS:DDDATE) > 0 OR
     C                             %Scan(GHSUBS:DDRSEQ) > 0
     C                   EVAL      SubForMain = 1
     C                   ENDIF
      ** Alternative key
     C                   IF        %Scan(GHSUBS:DDCUST) > 0 OR
     C                             %Scan(GHSUBS:DDTYPE) > 0 OR
     C                             %Scan(GHSUBS:DDSNDR) > 0 OR
     C                             %Scan(GHSUBS:DDRECP) > 0 OR
     C                             %Scan(GHSUBS:DDFREQ) > 0
     C                   EVAL      SubForAlt  = 1
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      ** Return code
     C                   PARM                    RetCodeIn
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      ** Response mode
     C                   PARM                    RespMode          1
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Front Office Transaction ID
     C                   PARM                    FOTRID           20
      ** (Midas) Statement Production Request Reference
     C                   PARM                    DDStPRRef
      *
      ** OUPUT PARAMETERS
      ** Transaction Details in File Format
     C                   PARM                    SESTPR
      ** OK - Action code and first key field of the request reference
     C                   PARM                    DDACTNOK          1
     C                   PARM                    DDDATEOK          1
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** KLIST's
      *
     C     KSESTPRL1     KLIST
     C                   KFLD                    SPDATE
     C                   KFLD                    SPRSEQ
      *
     C     KSESTPRL2     KLIST
     C                   KFLD                    DDCUST
     C                   KFLD                    DDTYPE
     C                   KFLD                    DDSNDR
     C                   KFLD                    DDRECP
     C                   KFLD                    DDFREQ
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'                           ************
     C                   EVAL      DBASE  = 900                                  * DBERR 900*
     C                   EVAL      DBKEY = @Optn                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access API ICD via access program
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDAPIPD'                            ************
     C                   EVAL      DBASE  = 901                                  * DBERR 901*
     C                   EVAL      DBKEY = @Optn                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access User Details
      *
     C                   CALL      'AOUSERR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      PSUser        @USRP            10
     C     SDUSER        PARM      SDUSER        DSSDY
      *
      ** Database error
      *
     C                   IF        @RtCd <> *Blanks
     C                   MOVEL     'MUSERDD'     DBFILE                          ************
     C                   Z-ADD     902           DBASE                           * DBERR 902*
     C                   MOVEL     PSUser        DBKEY                           ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003

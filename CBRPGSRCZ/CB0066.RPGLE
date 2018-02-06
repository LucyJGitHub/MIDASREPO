     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CB RTV spooled files info for job/user/nbr')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Processing                         *
      *                                                               *
      *  CB0066 - Midas CB Retrieve spooled files info. for a         *
      *           Job/User/Job number                                 *
      *                                                               *
      *  Function: This program retrieves spooled files information   *
      *            for the passed in Job, user and job number using   *
      *            IBM API's and output the information to file       *
      *            CBSPLFPD.                                          *
      *                                                               *
      *  Called By: CBC0066                                           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAAA02  *CREATE    Date 14Nov03               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAAA02 - Created to retrieve spooled files info. for a       *
      *           qualified job.                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  *none                                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * ProcListEntry - Process one list entry                        *
      * SetSFileName  - Get spooled file name for output to CBSPLFPD  *
      * SetSFileNbr   - Get spooled file number for output to CBSPLFPD*
      * OutputRec     - Output record to file CBSPLFPD                *
      *                                                               *
      * *INZSR        - Initialise                                    *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      * *PSSR         - Error processing                              *
      *                                                               *
      *****************************************************************
     FCBSPLFPD  O    E             DISK    INFSR(*PSSR)
      *
      * Error Code parameter include
     D/COPY QSYSINC/QRPGLESRC,QUSEC
      *
     D @run            S              1
     D UserSpaceName   S             20    INZ('LSPLSPACE QTEMP     ')
     D USpaceSize      S              9B 0 INZ(2000)
     D USpaceInitVal   S              1    INZ(X'00')
      *
      * Basing Pointers
     DLSTPTR           S               *
     DLSTPTR2          S               *
     DSPCPTR           S               *
      *
     DARR              S              1    BASED(LSTPTR) DIM(32767)
      *
     DKeyRecStartPos   S              9  0                                      Key record start pos
      *
     DQualJobName      DS
     DW0Job                    1     10
     DW0JobUser               11     20
     DW0JobNbr                21     26
      *
     DKeyFields        DS                                                       Key fields to retn
     D                                9B 0 INZ(201)                             Spooled file name ke
     D                                9B 0 INZ(205)                             Spooled file nbr key
     D                                9B 0 INZ(206)                             Output queue name
     D                                9B 0 INZ(209)                             User specified data
     D                                9B 0 INZ(210)                             Status
     D                                9B 0 INZ(211)                             Total pages
      *
     DKeyFieldNbr      S              9B 0 INZ(6)                               No of fields to retn
      *
     D                 DS
     DSPLFDta9N                1      9  0                                      spooled file number
      *
      *****************************************************************
      *
      * The following QUSGEN include from QSYSINC is copied into
      * this program so that it can be declared as BASED on SPCPTR
      *
      *****************************************************************
     DQUSH0100         DS                  BASED(SPCPTR)
      *                                             Qus Generic Header נ1ננ
     D QUSUA                   1     64
      *                                             User Area
     D QUSSGH                 65     68B 0
      *                                             Size Generic Header
     D QUSSRL                 69     72
      *                                             Structure Release Level
     D QUSFN                  73     80
      *                                             Format Name
     D QUSAU                  81     90
      *                                             Api Used
     D QUSDTC                 91    103
      *                                             Date Time Created
     D QUSIS                 104    104
      *                                             Information Status
     D QUSSUS                105    108B 0
      *                                             Size User Space
     D QUSOIP                109    112B 0
      *                                             Offset Input Parameter
     D QUSSIP                113    116B 0
      *                                             Size Input Parameter
     D QUSOHS                117    120B 0
      *                                             Offset Header Section
     D QUSSHS                121    124B 0
      *                                             Size Header Section
     D QUSOLD                125    128B 0
      *                                             Offset List Data
     D QUSSLD                129    132B 0
      *                                             Size List Data
     D QUSNBRLE              133    136B 0
      *                                             Number List Entries
     D QUSSEE                137    140B 0
      *                                             Size Each Entry
     D QUSSIDLE              141    144B 0
      *                                             CCSID List Ent
     D QUSCID                145    146
      *                                             Country ID
     D QUSLID                147    149
      *                                             Language ID
     D QUSSLI                150    150
      *                                             Subset List Indicator
     D QUSERVED00            151    192
      *                                             Reserved
      *
      *****************************************************************
      * The following QUSLSPL include from QSYSINC is copied into
      * this program so that it can be declared as BASED on LSTPTR2
      *****************************************************************
      *Prototype for calling List Spooled File API QUSLSPL
      ******************************************************************
     D QUSLSPL         C                   'QUSLSPL'
      *
      ******************************************************************
      *Type definition for the SPLF0200 format.
      ******************************************************************
     DQUSSPLKI         DS                  BASED(LSTPTR2)
      *                                             Qus LSPL Key Info
     D QUSLFIR02               1      4B 0
      *                                             Len Field Info Retd
     D QUSKFFFR00              5      8B 0
      *                                             Key Field for Field Retd
     D QUSTOD02                9      9
      *                                             Type of Data
     D QUSR300                10     12
      *                                             Reserv3
     D QUSDL02                13     16B 0
      *                                             Data Length
     D QUSDTA10A              17     26
      *                                             Returned data 10A
     D QUSDTA4B               17     20B 0
      *                                             Returned data binary(4)
      *
     DQUSF0200         DS                  BASED(LSTPTR)
      *                                             Qus SPLF0200
     D QUSNBRFR00              1      4B 0
      *                                             Num Fields Retd
      *
      *****************************************************************
      *  Main Processing
      *****************************************************************
      * Set Error Code structure to use exceptions
     C
     C                   EVAL      QUSBPRV = 0
      * Create a User Space for the List generated by QUSLSPL
      *
     C                   CALL      'QUSCRTUS'
     C                   PARM                    UserSpaceName
     C                   PARM      'QUSLSPL '    EXT_ATTR         10
     C                   PARM                    USpaceSize
     C                   PARM                    USpaceInitVal
     C                   PARM      '*ALL'        USpaceAuth       10
     C                   PARM      *BLANKS       USpaceText       50
     C                   PARM      '*YES'        USpaceReplace    10
     C                   PARM                    QUSEC
     C                   PARM      '*USER'       USpaceDomain     10
      *
      * If exception id not blank, call *PSSR.
     C                   IF        QUSEI <> *BLANK
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Call QUSLSPL to get all spooled files for job P0Job, user P0JobUser, Job number P0JobNbr
      *
     C                   CALL      'QUSLSPL'
     C                   PARM                    UserSpaceName
     C                   PARM      'SPLF0200'    Format            8
     C                   PARM      *BLANK        UserName         10
     C                   PARM      *BLANK        QualOutqName     20
     C                   PARM      *BLANK        FormType         10
     C                   PARM      *BLANK        UserData         10
     C                   PARM                    QUSEC                          Error code fr QUSEC
     C                   PARM                    QualJobName
     C                   PARM                    KeyFields
     C                   PARM                    KeyFieldNbr
      *
      * If exception id not blank, call *PSSR.
     C                   IF        QUSEI <> *BLANK
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Get a resolved pointer to the User Space for performance
      *
     C                   CALL      'QUSPTRUS'
     C                   PARM                    UserSpaceName
     C                   PARM                    SPCPTR
     C                   PARM                    QUSEC                          Error Code
      *
      * If exception id not blank, call *PSSR.
     C                   IF        QUSEI <> *BLANK
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If valid information was returned
      *
     C                   IF        QUSSRL = '0100'                              Expected Hdr format
      *
     C                   IF        (QUSIS = 'C') OR                             Infomation Status
     C                             (QUSIS = 'P')
      *
      * and list entries were found
     C                   IF        QUSNBRLE > 0                                 Nbr of list entries
      *
      * set LSTPTR to the first byte of the User Space
     C                   EVAL      LSTPTR = SPCPTR
      *
      * increment LSTPTR to the first List entry
     C                   EVAL      LSTPTR = %ADDR(ARR(QUSOLD + 1))
      *
      * and process all of the entries
     C                   DO        QUSNBRLE                                     Nbr of list entries
      *
      * Process one list entry to retrieve information for one spooled file and
      * output record to file CBSPLFPD.
     C                   EXSR      ProcListEntry
      *
      * after each entry, increment LSTPTR to the next entry
     C                   EVAL      LSTPTR = %ADDR(ARR(QUSSEE + 1))
      *
     C                   ENDDO                                                  OD QUSNBRLE
     C                   ENDIF                                                  FI QUSNBRLE > 0
      *
     C                   ELSE
      * i.e., List data not valid
     C                   EXSR      *PSSR
     C                   ENDIF                                                  FI (QUSIS = 'C') OR
      *                                                                            (QUSIS = 'P')
     C                   ELSE
      * i.e., Unknown generic header
     C                   EXSR      *PSSR
     C                   ENDIF                                                  FI QUSSRL = '0100'
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * ProcListEntry -  Process one list entry to retrieve           *
      *                  information for one spooled file and output  *
      *                  to CBSPLFPD.                                 *
      *                                                               *
      * Called by:  main processing                                   *
      *                                                               *
      * Calls:  SetSFileName                                          *
      *         SetSFileNbr                                           *
      *         OutputRec                                             *
      *                                                               *
      *****************************************************************
     C     ProcListEntry BEGSR
      *
      * set LSTPTR2 to the first key feild entry of the list entry
     C                   EVAL      KeyRecStartPos  = 5
     C                   EVAL      LSTPTR2         = %ADDR(ARR(KeyRecStartPos))
      *
     C                   DO        QUSNBRFR00                                   Nbr of keys retrieve
      *
      * process the data based on key type
     C     QUSKFFFR00    CASEQ     201           SetSFileName
     C     QUSKFFFR00    CASEQ     205           SetSFileNbr
     C     QUSKFFFR00    CASEQ     206           SetOutqName
     C     QUSKFFFR00    CASEQ     209           SetUserData
     C     QUSKFFFR00    CASEQ     210           SetStatus
     C     QUSKFFFR00    CASEQ     211           SetTtlPages
     C                   CAS                     *PSSR
     C                   END
      *
      * increment LSTPTR2 to next variable length record
     C                   EVAL      KeyRecStartPos = QUSLFIR02 + KeyRecStartPos
     C                   EVAL      LSTPTR2        = %ADDR(ARR(KeyRecStartPos))
     C                   ENDDO                                                  OD QUSNBRFR00
      *
     C                   EXSR      OutputRec
      *
     C     ProcListEntryEENDSR
      *****************************************************************
      *                                                               *
      * SetSFileName - Get spooled file name for output to CBSPLFPD   *
      *                                                               *
      * Called by:  ProcListEntry                                     *
      *                                                               *
      * Calls: none                                                   *
      *                                                               *
      *****************************************************************
     C     SetSFileName  BEGSR
      *
     C                   EVAL      SPSPLF = QUSDTA10A
      *
     C     SetSFileNameE ENDSR
      *
      *****************************************************************
      *                                                               *
      * SetSFileNbr  - Get spooled file number for output to CBSPLFPD *
      *                                                               *
      * Called by:  ProcListEntry                                     *
      *                                                               *
      * Calls: none                                                   *
      *                                                               *
      *****************************************************************
     C     SetSFileNbr   BEGSR
      *
     C                   EVAL      SPLFDta9N  = QUSDTA4B
      *
      * Convert the rightmost 4 digits of the numeric spooled file number (9 0)
      *  to alpha field 4A.
     C                   MOVE      SPLFDta9N     SPSNBR
      *
     C     SetSFileNbrE  ENDSR
      *
      *****************************************************************
      *                                                               *
      * SetOutqName  - Get output queue name for output to CBSPLFPD   *
      *                                                               *
      * Called by:  ProcListEntry                                     *
      *                                                               *
      * Calls: none                                                   *
      *                                                               *
      *****************************************************************
     C     SetOutqName   BEGSR
      *
     C                   EVAL      SPOUTQ = QUSDTA10A
      *
     C     SetOutqNameE  ENDSR
      *
      *****************************************************************
      *                                                               *
      * SetUserData  - Get user data for output to CBSPLFPD           *
      *                                                               *
      * Called by:  ProcListEntry                                     *
      *                                                               *
      * Calls: none                                                   *
      *                                                               *
      *****************************************************************
     C     SetUserData   BEGSR
      *
     C                   EVAL      SPUDTA = QUSDTA10A
      *
     C     SetUserDataE  ENDSR
      *
      *****************************************************************
      *                                                               *
      * SetStatus    - Get status for output to CBSPLFPD              *
      *                                                               *
      * Called by:  ProcListEntry                                     *
      *                                                               *
      * Calls: none                                                   *
      *                                                               *
      *****************************************************************
     C     SetStatus     BEGSR
      *
     C                   EVAL      SPSTAT = QUSDTA10A
      *
     C     SetStatusE    ENDSR
      *
      *****************************************************************
      *                                                               *
      * SetTtlPages  - Get total pages for output to CBSPLFPD         *
      *                                                               *
      * Called by:  ProcListEntry                                     *
      *                                                               *
      * Calls: none                                                   *
      *                                                               *
      *****************************************************************
     C     SetTtlPages   BEGSR
      *
     C                   EVAL      SPLFDta9N  = QUSDTA4B
      *
     C                   EVAL      SPTPAG     = SPLFDta9N
      *
      *
     C     SetTtlPagesE  ENDSR
      *
      *****************************************************************
      *                                                               *
      * OutputRec - Output record to file CBSPLFPD                    *
      *                                                               *
      * Called by:  ProcListEntry                                     *
      *                                                               *
      * Calls: none                                                   *
      *                                                               *
      *****************************************************************
     C     OutputRec     BEGSR
      *
     C                   EVAL      SPJOB  = P0Job
     C                   EVAL      SPJUSR = P0JobUser
     C                   EVAL      SPJNBR = P0JobNbr
      *
     C                   WRITE     CBSPLFD0
      *
     C     OutputRecE    ENDSR
      *
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: none                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST                                                  Parm list
     C                   PARM                    P0Job            10
     C                   PARM                    P0JobUser        10
     C                   PARM                    P0JobNbr          6
      *
      * Set up qualified job name.
     C                   EVAL      W0Job     = P0Job
     C                   EVAL      W0JobUser = P0JobUser
     C                   EVAL      W0JobNbr  = P0JobNbr
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Base rate codes interface controller')
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  SDBSRTVU - Base rate codes validate and update               *
      *                                                               *
      *  Function: This program validates base rate codes for         *
      *            input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22152           Date 14Jan09               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BG4816             Date 15Nov04               *
      *                 BUG4469            Date 06Oct04               *
      *                 BUG3124            Date 18Aug04               *
      *                 CSC022             Date 24Feb04               *
      *                 222373             Date 24Oct03               *
      *                 CAP084  *CREATE    Date 16Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG22152 - Missing authorization field in repository.        *
      *  BG4816 - Buffer length incorrect                             *
      *  BUG4469- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time by    *
      *           passing the Timestamp out to API.                   *
      *  BUG3124 - Do not allow blank entry in base rate code.        *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      * Base rate codes (Keyed by currency code and base rate code)
     FSDBSRTL0  IF   E           K DISK    RENAME(@BAREDG:SDBSRTCHK)
     F                                     INFSR(*pssr)

      * Private banking Base rate code details (Keyed by base rate code)
     FPBTOBSL0  IF   E           K DISK
     F                                     INFSR(*pssr)

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
      **-----------------------------------------------------------------------

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

      ** +--------------------------------------+                                             CSD103
      ** ¦ Named constants                      ¦                                             CSD103
      ** ¦ ===============                      ¦                                             CSD103
      ** +--------------------------------------+                                             CSD103
      ** Alpha Num Base Rate Code                                                             CSD103
     D AlphaBSRC       C                   Const('ALPHABASRATCOD')                            CSD103
                                                                                              CSD103
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
     D                                     PREFIX(@_)

      * Incoming base rate in screen format
     D BaseRateIn    E DS                  EXTNAME(SDBSRSPD)

      * Valid file layout
     D ValdBasRat    E DS                  EXTNAME(SDVBSRTPD)
     D                                     PREFIX(V_)

      * Current base rate record in file format
     D BasRFilFmt    E DS                  EXTNAME(SDBSRTPD)

      * SD Extra data in file (D/B) format
     D ExtData       E DS                  EXTNAME(SDBSEXPD)

      * Current transaction in screen format
     D CurTrBSRT     E DS                  EXTNAME(SDBSRSPD)
     D                                     PREFIX(@)

      * Error indicators
     D OKTrBSRT      E DS                  EXTNAME(SDEBSRTPD)

      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)

      ** External DS for Midas modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitjobs             4    103                                                       CSC022
      ** External DS for Commitment Control Data Area                                         CSC022
                                                                                              CSC022
     D wComitarr       S             10A   DIM(10)                                            CSC022
      ** Commitment Control Array                                                             CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      * Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      * Index for arrays of error message ids etc in amend validation
     D AmIdx           S              3P 0 INZ(0)

      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)

      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)

      ** Field (500A) to receive the incoming base rate
     D BaseR500        S            500A

      * Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      * Indices for arrays used to set up corresponding
      * sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      * Fields defined for CSD012
     D CSD012          S              1A
     D SVALKK          C                   CONST('AuthReqBaseRateMaint')

      **  Data Structure for AOSVALR0 string
     DSVAL1            DS           200
     DSVAL11                   1      1
                                                                                              CSC022
      ** Commitment Control Variables                                                         CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wSkip           S              1A   INZ('N')                                           CSC022
                                                                                             BUG3124
     D #1TESTN         S              1A                                                     BUG3124

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      * Incoming base rate is in a 500A field.
      * This module needs to break the 500A field by loading it into
      * the appropriate (externally described) data structure.

      * Copy the header into the screen format
     C                   Eval      BaseRateIn = BaseR500
     C                   MOVEL     Extdata500    Extdata
      *
      * If private banking is installed, the Java browser will only return
      * the base rate code; we need to get the base rate name separately.
     C                   If        BGN4ST = 'Y' and
     C                             DDACTN <> 'I'
     C     BABSRC        CHAIN     PBTOBSL0
     C                   Eval      BABSRN = AOBANA
     C                   EndIf

      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE

      *  If insert, check if valid base rate code exists
     C                   If        DDACTN = 'I'
     C                   EXSR      CheckBSRT
     C                   EndIf
      *
      *  If valid base rate does exist (even after delay), fail this input
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   EndIf

      * Reset variables again in case the details have been corrupted
      * by previous chain to valid base rate file.
     C                   EXSR      RESETCYCLE

      * Validate action code
     C                   Eval      APRespMode = 'S'
     C                   EXSR      ValidateAc
      *
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

      * Processing depends upon action code
     C                   SELECT

      * Processing for inserts
     C                   WHEN         DDACTN = 'I'
     C                   EXSR      ValidateBr

      * Processing for amends or changes
     C                   WHEN         DDACTN = 'A'
     C                   EXSR      ValidateBr

      * Processing for deletes
     C                   WHEN         DDACTN = 'D'
     C                   CLEAR                   ValdBasRat
     C                   MOVEL     BasRFilFmt    ValdBasRat
     C                   EVAL      V_BVTYLC = DDACTN
     C                   EVAL      V_BVLCD  = RunDayNbr

     C                   ENDSL
      *
     C     INVALID       TAG

      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      UpdateDB
     C                   ENDIF

     C                   SETON                                        LR

      * Remerge buffer with all relevant data structures
     C*****************  EVAL                    Buffer = BaseRateIn + ExtData               BUG4469
     C                   EVAL                    Buffer = BaseRateIn                         BUG4469
     C                                                    + @TimeStamp                       BUG4469
     C                                                    + ExtData                          BUG4469
     C                                                    + DDBLRT                            CSD103
     C                                                    + DDLBDY                            CSD103
     C                                                    + DDLODY                            CSD103
     C                                                    + DDPDLY                            CSD103
     C                                                    + DDBADJ                            CSD103
     C                                                    + DDAVOP                            CSD103
     C                                                    + DDBRAC                            CSD103
     C                                                    + DDWGHT                            CSD103
     C                                                    + DDLBAC                            CSD103

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    BaseR500
     C                   PARM                    ExtData500
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C**********         PARM                    Buffer         3000                          BG4816
     C                   PARM                    Buffer         6000                          BG4816
     C                   PARM                    APIRetc           1
     C                   PARM                    @TimeStamp       26                         BUG4469
     C                   PARM                    AAuth             1                        BUG22152
     C                   PARM                    DDBLRT            1                          CSD103
     C                   PARM                    DDLBDY            2                          CSD103
     C                   PARM                    DDLODY            2                          CSD103
     C                   PARM                    DDPDLY            2                          CSD103
     C                   PARM                    DDBADJ           14                          CSD103
     C                   PARM                    DDAVOP            1                          CSD103
     C                   PARM                    DDBRAC            2                          CSD103
     C                   PARM                    DDWGHT            1                          CSD103
     C                   PARM                    DDLBAC            2                          CSD103

      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'

      * Hook to enable non-core Message files to be included
     D/COPY WNCPYSRC,SDBSRTVM01
      *
      * Access bank details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      * Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Access Modules details
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM                    @RTCD
     C                   PARM                    @OPTN
     C     SDMMOD        PARM                    DSFDY

      ** Check whether MDF is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD006'      @SARD             6
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSD006            1
     C                   ELSE
     C                   MOVEL     'N'           CSD006
     C                   ENDIF

      ** MT34* MT36* Message Generation for FRA/IRS
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW005'      @SARD
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSW005            1
     C                   ELSE
     C                   MOVEL     'N'           CSW005
     C                   ENDIF

      ** MT34* Message Generation
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW011'      @SARD
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSW011            1
     C                   ELSE
     C                   MOVEL     'N'           CSW011
     C                   ENDIF

      ** SWIFT 2000 Changes
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW200'      @SARD
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSW200            1
     C                   ELSE
     C                   MOVEL     'N'           CSW200
     C                   ENDIF

      ** Check if CSC011 is installed
     C                   CLEAR                   CSC011            1

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error
     C                   IF        (@RTCD <> *BLANKS) and
     C                             (@RTCD <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
      *
      * If CSC011 is installed and in switchover mode, use
      * S1DATE from DTAARA/SC24x7 as the run day number.
     C     S1SUPP        IFEQ      LIBR
     C                   Z-ADD     S1DATE        RunDayNbr         5 0
     C                   ELSE
     C                   Z-ADD     BJRDNB        RunDayNbr
     C                   ENDIF
     C                   ENDIF

      ** Check if CSD012 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD012'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD012
     C                   ELSE
     C                   MOVE      'N'           CSD012
     C                   ENDIF

      ** If CSD012 is ON, check if base rate authorisation is ON
 B1  C     CSD012        IFEQ      'Y'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM      SVALKK        SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
      *
     C     @RTCD         IFNE      *BLANKS
     C     SVAL11        IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF

     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'SDBSRTR'     DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If base rate authorisation is On set to authorise
     C     SVAL1         IFEQ      'Y'
     C                   MOVE      'Y'           AUTHRQ            1
     C                   ELSE
     C                   MOVE      'N'           AUTHRQ
     C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Access SAR details file to determine if CSC022 is on.                                CSC022
      *                                                                                       CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
      ** Database Error                                                                       CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> *BLANKS and                                       CSC022
     C                             @RTCD <> '*NRF   '                                         CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBASE = 2                                                  CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *BLANK                                             CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        Comitnum > 0                                               CSC022
     C                   MoveA     wComitjobs    wComitarr                                    CSC022
     C     psJobname     Lookup    wComitarr                              10                  CSC022
     C                   If        *IN10                                                      CSC022
     C                   Eval      wSkip = 'Y'                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CSC022
      ** Check for Alpha Num Base Rate Code system value                                      CSD103
     C                   CALLB     'AOSVALR0'                                                 CSD103
     C                   PARM      *BLANKS       @RTCD                                        CSD103
     C                   PARM      AlphaBSRC     SVAL1           200                          CSD103
     C                   PARM      *BLANKS       SVALK2           20                          CSD103
     C                   PARM      *BLANKS       SVAL2           200                          CSD103
     C                   PARM      *BLANKS       SVALK3           20                          CSD103
     C                   PARM      *BLANKS       SVAL3           200                          CSD103
     C                   PARM      *BLANKS       SVALK4           20                          CSD103
     C                   PARM      *BLANKS       SVAL4           200                          CSD103
     C                   PARM      *BLANKS       SVALK5           20                          CSD103
     C                   PARM      *BLANKS       SVAL5           200                          CSD103
     C                   PARM      *BLANKS       SVALK6           20                          CSD103
     C                   PARM      *BLANKS       SVAL6           200                          CSD103
     C                   PARM      *BLANKS       SVALK7           20                          CSD103
     C                   PARM      *BLANKS       SVAL7           200                          CSD103
     C                   PARM      *BLANKS       SVALK8           20                          CSD103
     C                   PARM      *BLANKS       SVAL8           200                          CSD103
     C                   PARM      *BLANKS       SVALK9           20                          CSD103
     C                   PARM      *BLANKS       SVAL9           200                          CSD103
     C                   PARM      *BLANKS       SVALK0           20                          CSD103
     C                   PARM      *BLANKS       SVAL10          200                          CSD103
                                                                                              CSD103
     C                   IF        @RTCD <> *BLANKS                                           CSD103
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CSD103
     C                   EVAL      DBASE = 906                                                CSD103
     C                   EVAL      DBKEY = '*KEY    '                                         CSD103
     C                   EXSR      *PSSR                                                      CSD103
     C                   ENDIF                                                                CSD103
     C                   MOVEL     SVAL1         AlphaCode         1                          CSD103
      * Key list
     C     SDBSRT        KLIST
     C                   KFLD                    DDCYCD
     C                   KFLD                    DDBSRC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CheckBSRT  - Routine to check if base rate code exists        *
      *                                                               *
      *****************************************************************

     C     CheckBSRT     BEGSR

     C     DDCYCD        IFNE      *BLANKS
     C     DDBSRC        ANDNE     *BLANKS

      * Check for currency code/base rate code combination on file
     C     SDBSRT        CHAIN     SDBSRTCHK                          99

      * If record found...
     C     *IN99         IFEQ      '0'

      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'

     C     SDBSRT        CHAIN     SDBSRTCHK                          99

      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBSRC'
     C                   EVAL      MsgIDArr(Idx) = 'USR4447'
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
                                                                                             BUG3124
     ** Used MOVE to validate Base Rate Code                                                 BUG3124
                                                                                             BUG3124
     C     AlphaCode     IFNE      'Y'                                                        CSD103
     C                   MOVE      DDBSRC        #1TESTN                                     BUG3124
     C     DDBSRC        IFLE      '00'                                                      BUG3124
     C     DDBSRC        ORGT      '99'                                                      BUG3124
     C     #1TESTN       ORLT      '0'                                                       BUG3124
     C     #1TESTN       ORGT      '9'                                                       BUG3124
     C                   ADD       1             Idx                                         BUG3124
     C                   EVAL      *IN98 = *ON                                               BUG3124
     C                   EVAL      *IN33 = *ON                                               BUG3124
     C                   EVAL      FldNameArr(Idx) = 'DDBSRC'                                BUG3124
     C                   EVAL      MsgIDArr(Idx) = 'USR4572'                                 BUG3124
     C                   END                                                                 BUG3124
     C                   ENDIF                                                                CSD103
                                                                                             BUG3124
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              base rate details supplied                       *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus transaction IDs supplied
      * This function will set the Midas base rate code
      * The base rate in file format from the SD database is retrieved
      * as well.
     C                   RESET                   ReturnCode

     C                   CALLB     'SDBSRTRTV'

      * Inputs
      * Return code
     C                   PARM                    ReturnCode

      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE        1

      * Action code
     C                   PARM                    DDACTN            1

      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20

      * Currency code
     C                   PARM                    DDCYCD

      * Base rate code
     C                   PARM                    DDBSRC

      * Outputs
      * Current base rate in file format
     C                   PARM                    BasRFilFmt

      * OK - Action code
     C                   PARM                    DDActnOK

      * OK - Currency code
     C                   PARM                    DDCycdOK

      * OK - Base rate code
     C                   PARM                    DDBsrcOK

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * ICD - Private banking
     C                   PARM                    BGN4ST

      * Base rate shortname
     C                   PARM                    DDBSRS
      *
      * Base rate name
     C                   PARM                    DDBSRN

      * Base rate authorisation required
     C                   PARM                    AUTHRQ            1

      * Authorisation mode
     C                   PARM                    AUTHMD            1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateBr - Routine to validate the base rate details        *
      *                                                               *
      *****************************************************************

     C     ValidateBr    BEGSR

     C                   CLEAR                   ValdBasRat
      *
      * Initialise valid file with format output by the RTV API
      * Some fields may be overwritten by the validation.
     C                   MOVEL     BasRFilFmt    ValdBasRat
      *
     C                   CALLB     'SDBSRTVAL'

      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode

      * Base rate information (DS) from source system
     C                   PARM                    BaseRateIn

      * Base rate extra data
     C                   PARM                    ExtData

      * Field OK flags (DS) from/to caller
     C                   PARM                    OKTrBSRT

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Valid base rate layout (DS) from/to caller
     C                   PARM                    ValdBasRat

      * Switchable features
     C                   PARM                    CSD006
     C                   PARM                    CSW005
     C                   PARM                    CSW011
     C                   PARM                    CSW200

      * Array index (3P0) from/to caller
     C                   PARM                    WIdx

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
                                                                                              CSD103
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    DDBLRT                                       CSD103
     C                   PARM                    DDLBDY                                       CSD103
     C                   PARM                    DDLODY                                       CSD103
     C                   PARM                    DDPDLY                                       CSD103
     C                   PARM                    DDBADJ                                       CSD103
     C                   PARM                    DDAVOP                                       CSD103
     C                   PARM                    DDBRAC                                       CSD103
     C                   PARM                    DDWGHT                                       CSD103
     C                   PARM                    DDLBAC                                       CSD103

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *             updated during each run of this program           *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx

     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx

     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx


     C                   RESET                   FldNoArr

     C                   CLEAR                   CurTrBSRT

     C                   MOVE      *ALL'Y'       OKTrBSRT

     C                   CLEAR                   ValdBasRat

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************

     C     UPDATEDB      BEGSR
                                                                                             BUG4469
      * Restore Timestamp from the original record                                           BUG4469
     C                   IF        DDACTN <> 'I'                                             BUG4469
     C                             and @TimeStamp <> *BLANKs                                 BUG4469
     C                   MOVEL     @TimeStamp    V_BVTMESTMP                                 BUG4469
     C                   ENDIF                                                               BUG4469
                                                                                             BUG4469
      *
      * Update
     C                   CALLB     'SDBSRTUPD'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    ValdBasRat
      * Base Rate Auth req                                                                    222373
     C                   PARM                    AUTHRQ                                       222373
      * Authorisation Mode                                                                    222373
     C                   PARM                    AUTHMD                                       222373
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     ReturnCode    IFNE      *BLANK
     C     ReturnCode    ANDNE     '*RECUPD'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
     C                   Commit
     C                   EndIf                                                                CSC022
     C                   EndIf
      *
      * If update not done due to record being updated by another
      * workstation send message to screen.

     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'USR0015'     MsgIdArr(1)

     C                   EndIf

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   MOVEL     '0'           APIRetc                                      CSC022
     C                   RETURN
     C**********         MOVEL     '0'           APIRetc                                      CSC022
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003

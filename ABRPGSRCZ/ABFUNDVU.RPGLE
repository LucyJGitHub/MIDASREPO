     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal funding deals interface control')    *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABFUNDVU - Internal Funding Deals validate and update        *
      *                                                               *
      *  Function: This program validates internal funding deals for  *
      *            input into the Midas database.                     *
      *            The action code determines which processes are     *
      *            executed as follows:                               *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the transaction details fields        *
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
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 261910             Date 18Sep09               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26950A          Date 26Jan10               *
      *                 BUG26950           Date 22Jan10               *
      *                 261140             Date 16Sep09               *
      *                 CAP191             Date 12May09               *
      *                 BUG24144           Date 12May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8550            Date 16Jun06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8259            Date 26Aug05               *
      *                 CDL038             Date 10May05               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CAP084  *CREATE    Date 05Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  261910 - Amended so that fix of 259924A will still work after*
      *           incorporation of SC261140.                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG26950A - Reapply 262001 fix due to incomplete delivery    *
      *  BUG26950 - No FOTID and AFOTID for the Internal Deposit      *
      *             Applied fix 262001                                *
      *  262001 - Front Office ID and Assoc Front Office ID of Assoc  *
      *           Deal is not populated. Populate the Front Office ID *
      *           and Assoc Front Office ID of Associated Deal.       *
      *  261140 - Missing Front Office ID / Assoc Front Office ID     *
      *  CAP191 - MQ Enabling of FUND and EXTR APIs                   *
      *  BUG24144 - Missing Parameters in call to MMLDNIUPM           *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8259- Serious Midas Error occurred (Recompile)            *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FSDBRTDL1  IF A E           K DISK    INFSR(*PSSR)
      ** BRT Control Data
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming transaction in screen format
     D TranInFUND    E DS                  EXTNAME(ABFUNDPD)
 
      * Incoming FUND extra data layout                                                       CAP191
     D ExtData       E DS                  EXTNAME(ABFUEXPD)                                  CAP191
                                                                                              CAP191
      ** Current Deal in File Format of main deal
     D CrDlFilFmt1   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D1:2)
     D QQDORI1       E                     EXTFLD(QQDORI)                                     CGL029
     D QQMORI1       E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOPI1       E                     EXTFLD(QQDOPI)                                     CGL029
     D QQRONS1       E                     EXTFLD(QQRONS)                                     CGL029
     D QQPONS1       E                     EXTFLD(QQPONS)                                     CGL029
     D QQINSA1       E                     EXTFLD(QQINSA)                                     CGL029
     D QQMOPI1       E                     EXTFLD(QQMOPI)                                     CGL029
 
      ** Current Deal in File Format of associated deal
     D CrDlFilFmt2   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D2:2)
     D QQDORI2       E                     EXTFLD(QQDORI)                                     CGL029
     D QQMORI2       E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOPI2       E                     EXTFLD(QQDOPI)                                     CGL029
     D QQRONS2       E                     EXTFLD(QQRONS)                                     CGL029
     D QQPONS2       E                     EXTFLD(QQPONS)                                     CGL029
     D QQINSA2       E                     EXTFLD(QQINSA)                                     CGL029
     D QQMOPI2       E                     EXTFLD(QQMOPI)                                     CGL029
 
      ** New Deal in File Format of main deal
     D NwDlFilFmt1   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N1:2)
     D QQDORI3       E                     EXTFLD(QQDORI)                                     CGL029
     D QQMORI3       E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOPI3       E                     EXTFLD(QQDOPI)                                     CGL029
     D QQRONS3       E                     EXTFLD(QQRONS)                                     CGL029
     D QQPONS3       E                     EXTFLD(QQPONS)                                     CGL029
     D QQINSA3       E                     EXTFLD(QQINSA)                                     CGL029
     D QQMOPI3       E                     EXTFLD(QQMOPI)                                     CGL029
 
      ** New Deal in File Format of associated deal
     D NwDlFilFmt2   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N2:2)
     D QQDORI4       E                     EXTFLD(QQDORI)                                     CGL029
     D QQMORI4       E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOPI4       E                     EXTFLD(QQDOPI)                                     CGL029
     D QQRONS4       E                     EXTFLD(QQRONS)                                     CGL029
     D QQPONS4       E                     EXTFLD(QQPONS)                                     CGL029
     D QQINSA4       E                     EXTFLD(QQINSA)                                     CGL029
     D QQMOPI4       E                     EXTFLD(QQMOPI)                                     CGL029
 
      ** Deal file format use for update
     D UpdDlFilFmt   E DS                  EXTNAME(MMVLDNIPD)
 
      ** Current Deal in Screen Format
     D CrDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     PREFIX(DC:2)
 
      ** New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     PREFIX(DD:2)
 
      ** Internal Funding Deals Error Indicator File
     D OkFlags       E DS                  EXTNAME(ABEFUNDPD)
 
      * 24X7 Data area structure
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Trading ICD
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
 
      ** External DS for general ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External DS for dealing details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D QQACCD2       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * Payment Further Settlement Instructions in file format                              BUG24144
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                BUG24144
                                                                                            BUG24144
      * Receive Further Settlement Instructions in file format                              BUG24144
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                BUG24144
                                                                                            BUG24144
      ** YYYYMMDD date format of Deal Date
     D PDateOutZ9      DS
     D  DDATYr                 1      4  0
     D  DDATMn                 5      6  0
     D  DDATDy                 7      8  0
                                                                                              CSC022
      ** Jobs Handling Commitment Control                                                     CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITARR               4    103                                                       CSC022
                                                                                              CSC022
      ** Array of Commitment Job Names                                                        CSC022
     D COMITJOB        S             10A   DIM(10)                                            CSC022
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Data structure for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10A
     D  PDBRN                 11     13A
     D  PDPPT                 14     16A
 
      ** Data structure for RUNDAT details
     D RUNDAT          DS            13
     D  PAGMRDT                1      7A
     D  PAGRDNB                8     10  0
     D  PAGSUC                11     11A
     D  PAGDFF                12     12A
     D  PAGMBIN               13     13A
 
      ** Midas Run Date
     D                 DS
     D WkBJMRDT                1      7
     D WkDLUP                  1      2  0
     D WkMLUP                  3      5
     D WkYLUP                  6      7  0
 
      * Index for arrays of error message ids etc in amend validation
     D AmIdx           S              3P 0 INZ(0)
 
      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
      * Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
 
      * Indices for arrays used to set up corresponding
      * sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
     D PKey            S              1A
     D PMsgId          S              7A
     D PReDsp          S              1A
     D PValFlg         S              1A
     D WSetFld         S              1A
     D PDayNoIn        S              5P 0
     D PRetCode        S              1  0
     D CSC011          S              1A
     D CAS004          S              1A
     D CDL019          S              1A                                                      CDL019
     D CDL020          S              1A                                                      CDL020
     D WRunDay         S                   LIKE(BJRDNB)
 
      ** Generated Deal Number
     D PDealNum        S              6S 0
     D ADealNum        S              6A
 
      ** Parameters for MM1010
     D PMTTI           S             15P 0
     D PINTD           S             13P 0
     D PIPFQ           S              1A
     D PNIPD           S              5P 0
     D PDVSD           S              5P 0
     D PICMT           S              1A
     D PAMNP           S             15P 0
     D PINTR           S             11P 7
     D PRDFC           S              1A
     D PMTAX           S              1A
     D PDeal           S              6  0
     D PBRMD           S              5P 0
     D S01383          S              1A
     D*PCNUM****       S              6  0                                                    CSD027
     D PCNUM           S              6A                                                      CSD027
     D PZCCY           S              3A
     D PZLOC           S              3A
     D PIMAT           S             15  0
     D CSC022          S              1A   INZ('N')                                           CSC022
     D CNT             S              3  0                                                    CSC022
     D COMITSKIP       S              1A                                                      CSC022
                                                                                              CAP191
      ** Incoming parameters                                                                  CAP191
     D PExtData500     S            500A                                                      CAP191
     D @TimeStamp      S             26A                                                      CAP191
     D AAuth           S              1A                                                      CAP191
     D FRNT            S             20A                                                      261140
     D AFRT            S             20A                                                      261140
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Retrieve ZMUSER details                                                             BUG8550
                                                                                             BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
                                                                                             BUG8550
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInFUND
     C                   MOVEL     PExtData500   ExtData                                      CAP191
     C                   EVAL      PFrntId = FRNT                                             261910
     C                   EVAL      PFrntAsId = AFRT                                           261910
 
      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE
 
      * Validate action code
     C                   EXSR      ValidateAc
      *
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      * Processing depends upon action code
     C                   EXSR      RESETCYCLE
     C                   MOVEL     CrDlFilFmt1   NwDlFilFmt1
     C                   MOVEL     CrDlFilFmt2   NwDlFilFmt2
 
     C                   SELECT
 
      * Processing for inserts
     C                   WHEN         #1ACTN = 'I'
     C                   EXSR      ValidateTr
 
      * Processing for amends or changes
     C                   WHEN         #1ACTN = 'A'
     C                   EXSR      SetupAmd
     C                   EXSR      ValidateTr
     C                   EXSR      ValAmd                                                     CDL038
 
     C                   ENDSL
 
      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
      *
     C                   IF        #1ACTN = 'I' OR #1ACTN = 'A'
     C                   EVAL      WSetFld = '1'
     C                   EXSR      SETUPVALID
     C                   ENDIF
      *
     C                   IF        #1ACTN = 'D'
     C                   EVAL      N1DDLT = 'D'
     C                   EVAL      N2DDLT = 'D'
     C                   EVAL      N1LACT = 'D'
     C                   EVAL      N2LACT = 'D'
     C                   EVAL      IKLUID = PUSRID
     C                   ENDIF
      *
     C                   EXSR      UpdateDB
     C                   ENDIF
 
      * Remerge buffer with all relevant data structures
     C**********         EVAL      Buffer = TranInFUND + PDDSTS                               CAP191
     C                   EVAL      Buffer = TranInFUND + PDDSTS + @TimeStamp +                CAP191
     C**********                   ExtData + AAuth                                     CAP191 261140
     C                             ExtData + AAuth + FRNT + AFRT                              261140
 
     C     INVALID       TAG
     C                   SETON                                        LR
 
     C                   RETURN
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
     C                   PARM                    Trans5001
     C                   PARM                    PExtData500                                  CAP191
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1
     C                   PARM                    @TimeStamp                                   CAP191
     C                   PARM                    AAUTH                                        CAP191
     C                   PARM                    FRNT                                         261140
     C                   PARM                    AFRT                                         261140
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'ABUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'
 
      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,ABFUNDM01
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDBANKPD'                         * DBERR 01 *
     C                   EVAL      DBASE  =  001                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger Details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Database Error
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDGELRPD'                         * DBERR 02 *
     C                   EVAL      DBASE  =  002                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Dealing Data Details
 
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDDEALPD'                         * DBERR 03 *
     C                   EVAL      DBASE  =  003                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Module Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDMMODPD'                         * DBERR 04 *
     C                   EVAL      DBASE  =  004                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Trading Details
 
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDTRADPD'                         * DBERR 05 *
     C                   EVAL      DBASE  =  005                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if S01383 is installed
 
     C                   EVAL      S01383 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'S01383'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RtCd = *Blanks
     C                   EVAL      S01383 = 'Y'
     C                   ENDIF
 
      ** Check if CAS004 is installed
 
     C                   EVAL      CAS004 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CAS004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RtCd = *Blanks
     C                   EVAL      CAS004 = 'Y'
     C                   ENDIF
                                                                                              CDL019
      ** Check if CDL019 is installed                                                         CDL019
                                                                                              CDL019
     C                   EVAL      CDL019 = 'N'                                               CDL019
     C                   CALL      'AOSARDR0'                                                 CDL019
     C                   PARM      *Blanks       @RtCd                                        CDL019
     C                   PARM      '*VERIFY'     @Optn                                        CDL019
     C                   PARM      'CDL019'      @SARD                                        CDL019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL019
                                                                                              CDL019
     C                   IF        @RtCd = *Blanks                                            CDL019
     C                   EVAL      CDL019 = 'Y'                                               CDL019
     C                   ENDIF                                                                CDL019
                                                                                              CDL020
      ** Check if CDL020 is installed                                                         CDL020
                                                                                              CDL020
     C                   EVAL      CDL020 = 'N'                                               CDL020
     C                   CALL      'AOSARDR0'                                                 CDL020
     C                   PARM      *Blanks       @RtCd                                        CDL020
     C                   PARM      '*VERIFY'     @Optn                                        CDL020
     C                   PARM      'CDL020'      @SARD                                        CDL020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL020
                                                                                              CDL020
     C                   IF        @RtCd = *Blanks                                            CDL020
     C                   EVAL      CDL020 = 'Y'                                               CDL020
     C                   ENDIF                                                                CDL020
 
      ** Access SD BRT Control Data
 
     C                   IF        S01383 = 'Y'
     C                   EVAL      PKey = 'D'
     C     PKey          CHAIN     SDBRTDL1                           02
 
      ** Database error.
 
     C                   IF        *IN02 = *On  OR
     C                             RECI <> 'D'
     C                   EVAL      DBKEY = PKey                                 ************
     C                   EVAL      DBFILE = 'SDBRTDPD'                          * DBERR 06 *
     C                   EVAL      DBASE  =  006                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      *  is switched on                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RtCd                                        CSC022
     C                   PARM      '*VERIFY'     @Optn                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        @RtCd = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   IN        SCCMTJOB                                                   CSC022
     C                   Z-ADD     1             CNT                                          CSC022
     C                   MOVEL     *BLANKS       COMITSKIP                                    CSC022
     C                   MOVEA     COMITARR      COMITJOB                                     CSC022
     C     COMITNUM      IFGT      0                                                          CSC022
     C     CNT           DOWLE     COMITNUM                                                   CSC022
     C     PSJOBNAME     IFEQ      COMITJOB(CNT)                                              CSC022
     C                   MOVEL     'Y'           COMITSKIP                                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ADD       1             CNT                                          CSC022
     C                   ENDDO                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
      ** Database error                                                                       CSC022
                                                                                              CSC022
     C                   IF        @RtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 009                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
 
      ** Retrieve ZMUSER details
 
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
 
      ** Retrieve RUNDAT details.
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Check if CSC011 is installed
      ** If CSC011 is installed and in switchover mode, use
      ** S1DATE from DTAARA/SC24x7 as the rundate.
 
     C                   EVAL      WRunDay = BJRDNB
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RtCd = *Blanks
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   IF        LIBR = S1SUPP
     C                   EVAL      WRunDay = S1DATE
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   IF        @RtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'                             ************
     C                   EVAL      DBFILE = 'SCSARDPD'                          * DBERR 07 *
     C                   EVAL      DBASE = 007                                  ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Convert Midas Day Number to YYYYMMDD format
 
     C                   CALLB     'ZDATE9'
     C                   PARM      WRunDay       PDayNoIn
     C                   PARM      *ZERO         PDateOutZ9
     C                   PARM                    PRetCode
 
      *  Hook to enable non-core initial processing to be included
     D/COPY WNCPYSRC,ABFUND01
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              Internal Funding Deal supplied                   *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus transaction Internal Funding Deal supplied.
      * The Internal Funding Deal in file format from the database is retrieved
      * as well.
     C                   RESET                   ReturnCode
 
     C                   CALLB     'ABFUNDRTV'
 
      ** Input Parameters
      ** ================
      * Return code
 
     C                   PARM                    RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
 
     C                   PARM      '*SIN  '      PModeOfOp         6
 
      ** Response mode
 
     C                   PARM      'S'           PRespMode         1
 
      ** Action Code
      ** Front Office Transaction ID
      ** Front Office Associated Transaction Id
      ** (Midas) Deal Number
      ** (Midas) Associated Deal Number
      ** (Midas) Booking Branch
      ** (Midas) Booking Branch for Associated Deal
      ** Linked maintenance flag
 
     C                   PARM                    #1ACTN            1
     C                   PARM                    PFrntId          20
     C                   PARM                    PFrntAsId        20
     C                   PARM                    #1DLNO            6
     C                   PARM                    #1DADN            6
     C                   PARM                    #1BRC1            3
     C                   PARM                    #1BRC2            3
     C                   PARM                    PLnkFlag          1
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    BJSBRC
 
      ** SDGELRPD
      ** ========
 
     C                   PARM                    BKOBUV
 
      ** ZMUSER
      ** ========
 
     C                   PARM                    PDBRN
 
      ** Output Parameters
      ** =================
      ** (Current) deal in file format of deal
      ** (Current) deal in file format of deal of associated deal
      ** OK - Action code
      ** OK - Deal Number
      ** OK - Booking branch
      ** OK - Booking branch for associated deal number
 
     C                   PARM                    CrDlFilFmt1
     C                   PARM                    CrDlFilFmt2
     C                   PARM      *BLANK        OKACTN            1
     C                   PARM      *BLANK        OKDLNO            1
     C                   PARM      *BLANK        OKBRC1            1
     C                   PARM      *BLANK        OKBRC2            1
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      *ZERO         Idx
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *            of amendments.                                     *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For Amends, convert the Internal Funding Deal transaction to screen format
 
     C                   CALLB     'ABFUNDCVT'
 
      ** Input Parameter
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action Code
 
     C                   PARM                    #1ACTN
 
      ** Deal in file format of deal
      ** Deal in file format of associated deal
 
     C                   PARM                    CrDlFilFmt1
     C                   PARM                    CrDlFilFmt2
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    BJDFIN
 
      ** SDDEALPD
      ** ========
 
     C                   PARM                    BNDCSP
 
     C                   PARM                    CAS004
 
     C                   PARM                    CDL019                                    CDL019
                                                                                           CDL019
     C                   PARM                    CDL020                                    CDL020
                                                                                           CDL020
      ** Output Parameters
      ** =================
      ** Deal in screen format
 
     C                   PARM                    CrDlScnFmt
 
      ** Deal Status
 
     C                   PARM                    PDDSTS            7
 
      ** Profit Centre Description 1
      ** Profit Centre Description 2
 
     C                   PARM                    PPRF1D           30
     C                   PARM                    PPRF2D           30
 
      ** Front Office Transaction ID                                                          261140
      ** Associated Front Office Transaction ID                                               261140
     C                   PARM                    FRNT                                         261140
     C                   PARM                    AFRT                                         261140
                                                                                              261140
     C                   ENDSR
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Internal Funding Deal details
 
     C                   RESET                   RetCodeOut
 
     C                   CALLB     'ABFUNDVAL'
 
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
 
     C                   PARM                    PModeOfOp
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
 
     C                   PARM      'S'           PRespMode
 
      ** AB Internal Funding Deal screen details from incoming
      ** transaction - screen format
 
     C                   PARM                    TranInFUND
 
      ** Current Screen Format
      ** Current File Format 1
      ** Current File Format 2
 
     C                   PARM                    CrDlScnFmt
     C                   PARM                    CrDlFilFmt1
     C                   PARM                    CrDlFilFmt2
 
      ** STANDING DATA
      ** =============
 
      ** SDBANKPD
      ** ========
 
      ** Date Format Indicator
      ** Currency Code
      ** Single Branch Code
      ** System Location Code
      ** Local Currency Code
      ** Customer Number
      ** Run Day Number
      ** Back Value Period in Days
 
     C                   PARM                    BJDFIN
     C                   PARM                    BJCYCD
     C                   PARM                    BJSBRC
     C                   PARM                    BJSLCD
     C                   PARM                    BJLCCY
     C                   PARM                    BJCUST
     C                   PARM                    WRunDay
     C                   PARM                    BJBVPD
 
      ** SDGELRPD
      ** ========
 
      ** Profit Centres Used
      ** Originating Branch Used
      ** Originating Branch/User Valid
      ** Profit Centres Amendable
      ** Profit Centre Deafults Used
 
     C                   PARM                    BKPRCU
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
     C                   PARM                    BKPRCA
     C                   PARM                    BKPCDU
 
      ** SDDEALPD
      ** ========
 
      ** Decimal Separator
 
     C                   PARM                    BNDCSP
 
      ** SDMMODPD
      ** ========
 
      ** Leo Letters of Credit
 
     C                   PARM                    BGNOST
 
      ** SDTRADPD
      ** ========
 
      ** Base Rate Change Facility
 
     C                   PARM                    BLBRCF
 
      ** RUNDAT
      ** ======
 
      ** Multibranching Indicator
     C                   PARM                    PAGMBIN
 
      ** ZMUSER
      ** ======
 
      ** Default Branch
      ** Department Code
 
     C                   PARM                    PDBRN
     C                   PARM                    PDPPT
 
     C                   PARM                    CAS004
                                                                                           CDL019
     C                   PARM                    CDL019                                    CDL019
                                                                                           CDL020
     C                   PARM                    CDL020                                    CDL020
 
      ** Output Parameters
      ** =================
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning flds/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** AB Internal Funding Deal screen error indicators
 
     C                   PARM                    OkFlags
 
      ** AB Internal Funding Deal for file update - file format 1
 
     C                   PARM                    NwDlFilFmt1
 
      ** AB Internal Funding Deal for file update - file format 2
 
     C                   PARM                    NwDlFilFmt2
 
      ** Redisplay Flag
 
     C                   PARM      *BLANK        PReDsp
 
      ** Profit Centre Description 1
      ** Profit Centre Description 2
 
     C                   PARM                    PPRF1D
     C                   PARM                    PPRF2D
 
      ** Amended by validation module flag
 
     C                   PARM                    PValFlg
 
     C                   ENDSR
      /EJECT                                                                                  CDL038
      *****************************************************************                       CDL038
      * ValAmd   - Check whether the fields amended are amendable     *                       CDL038
      *****************************************************************                       CDL038
     C     ValAmd        BEGSR                                                                CDL038
                                                                                              CDL038
      ** Amend Checking                                                                       CDL038
                                                                                              CDL038
     C                   RESET                   ReturnCode                                   CDL038
     C                   EVAL      NwDlScnFmt = TranInFUND                                    CDL038
     C                   CALLB     'ABFUNDAMD'                                                CDL038
                                                                                              CDL038
      ** Inputs                                                                               CDL038
      ** ======                                                                               CDL038
      ** Return Code                                                                          CDL038
      ** New Deal in Screen Format (Incoming Transaction)                                     CDL038
      ** Current Deal in Screen Format                                                        CDL038
      ** Reset of Fields in Error Required (Y/N)                                              CDL038
      ** Originating Branch Used                                                              CDL038
      ** Decimal Separator                                                                    CDL038
                                                                                              CDL038
     C                   PARM                    ReturnCode                                   CDL038
     C                   PARM                    NwDlScnFmt                                   CDL038
     C                   PARM                    CrDlScnfmt                                   CDL038
     C                   PARM      'N'           ResetErrs         1                          CDL038
     C                   PARM                    BKOBRU                                       CDL038
     C                   PARM                    BNDCSP                                       CDL038
     C                   PARM                    CDL019                                       CDL038
     C                   PARM                    CDL020                                       CDL038
                                                                                              CDL038
      ** Outputs                                                                              CDL038
      ** =======                                                                              CDL038
      ** Field OK flags (DS) from/to caller                                                   CDL038
                                                                                              CDL038
     C                   PARM                    OKFlags                                      CDL038
                                                                                              CDL038
      ** Error fields/message IDs/message data (arrays) from/to caller                        CDL038
                                                                                              CDL038
     C                   PARM                    AmFldNamAr                                   CDL038
     C                   PARM                    AmMsgIdArr                                   CDL038
     C                   PARM                    AmMsgDtaAr                                   CDL038
                                                                                              CDL038
      ** Array index (3P0) from/to caller                                                     CDL038
                                                                                              CDL038
     C                   PARM                    AmIdx             3 0                        CDL038
                                                                                              CDL038
      ** Amendments OK                                                                        CDL038
                                                                                              CDL038
     C                   PARM      'Y'           AmendOK           1                          CDL038
                                                                                              CDL038
      ** Amended by validation module flag                                                    CDL038
                                                                                              CDL038
     C                   PARM                    PValFlg                                      CDL038
                                                                                              CDL038
      ** If any errors overwrite previous error information                                   CDL038
                                                                                              CDL038
     C                   IF        AmIdx <> 0                                                 CDL038
     C                   EVAL      MsgidArr = AmMsgIdArr                                      CDL038
     C                   EVAL      FldNameArr = AmFldNamAr                                    CDL038
     C                   EVAL      MsgDtaArr = AmMsgDtaAr                                     CDL038
     C                   EVAL      Idx = AmIdx                                                CDL038
     C                   ENDIF                                                                CDL038
                                                                                              CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
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
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   CLEAR                   CrDlScnFmt
     C                   CLEAR                   NwDlFilFmt1
     C                   CLEAR                   NwDlFilFmt2
 
     C                   EVAL      OkFlags = *ALL'Y'
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *              valid file record.                               *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
      **                                                                                      CAP191
     C**********         EVAL      IKFRNT = APFOTRANID                                 CAP191 261140
     C**********         EVAL      IKAFRT = APFOASOCID                                 CAP191 261140
     C**********         EVAL      IKREPA = APRPRLOCN                                  CAP191 261140
     C                   EVAL      N1FRNT = FRNT                                              261140
     C                   EVAL      N1AFRT = AFRT                                              261140
     C                   EVAL      N2FRNT = AFRT                                              262001
     C                   EVAL      N2AFRT = FRNT                                              262001
     C                   EVAL      N1REPA = ' '                                               261140
     C                   IF        DDACTN <> 'I' AND @TimeStamp <> *BLANKS                    CAP191
     C                   MOVEL     @TimeStamp    IKTMESTMP                                    CAP191
     C                   ENDIF                                                                CAP191
                                                                                              CAP191
      ** If Insert and deal number not defined,
      ** get next available deal number
 
     C                   IF        #1ACTN = 'I' AND #1DLNO = *BLANK
 
     C                   EXSR      SRGetNxtDl
     C                   MOVE      ADealNum      #1DLNO
     C                   EVAL      N1DN38 = PDealNum
     C                   MOVE      PDealNum      N1PCDN
     C                   MOVE      PDealNum      N2DADN
     C                   ELSE
     C                   MOVE      #1DLNO        N1DN38
     C                   MOVE      #1DLNO        N1PCDN
     C                   MOVE      #1DLNO        N2DADN
 
     C                   ENDIF
 
      ** If Insert deal associated number not defined ,
      ** get next available deal associated number
 
     C                   IF        #1ACTN = 'I' AND #1DADN = *BLANK
 
     C                   EXSR      SRGetNxtDl
     C                   MOVE      ADealNum      #1DADN
     C                   EVAL      N2DN38 = PDealNum
     C                   MOVE      PDealNum      N2PCDN
     C                   MOVE      PDealNum      N1DADN
     C                   ELSE
     C                   MOVE      #1DADN        N2DN38
     C                   MOVE      #1DADN        N2PCDN
     C                   MOVE      #1DADN        N1DADN
 
     C                   ENDIF
 
      ** Setup other fields prior to update.
 
     C                   DOW       WSetFld <> 'N'
 
     C                   IF        WSetFld = '1'
 
     C                   EVAL      UpdDlFilFmt = NwDlFilFmt1
     C                   EVAL      IKMTYP = 'IL'
     C                   EVAL      IKTYPE = 'IL'
     C                   EVAL      IKPOBR = N2BRCA
     C                   EVAL      IKROBR = N2BRCA
     C                   Z-SUB     IKAMNP        IKAMNP
     C                   ELSE
     C                   EVAL      UpdDlFilFmt = NwDlFilFmt2
     C                   EVAL      IKMTYP = 'ID'
     C                   EVAL      IKTYPE = 'ID'
     C                   EVAL      IKPOBR = N1BRCA
     C                   EVAL      IKROBR = N1BRCA
     C                   Z-SUB     IKMTTI        IKMTTI
     C                   ENDIF
 
      ** Time of Input
 
     C                   TIME                    IKTIME
 
      ** Record Identifier
 
     C                   EVAL      IKRCID = 'HK'
 
      ** Logical Delete Flag
 
     C                   EVAL      IKDLTF = ' '
 
      ** Date and Time of Last Update
 
     C                   EVAL      IKDLUP = WkDLUP
     C                   EVAL      IKMLUP = WkMLUP
     C                   EVAL      IKYLUP = WkYLUP
     C                   TIME                    IKTLUP
 
      ** Type of last change
 
     C                   IF        #1ACTN <> 'E'
     C                   EVAL      IKCHTP = #1ACTN
     C                   ENDIF
 
      ** Last Change Date
 
     C                   EVAL      IKLCD  = WRunDay
 
      ** Last Update User ID
 
     C                   EVAL      IKLUID = PUSRID
 
      ** Broker Code
 
     C                   EVAL      IKBKCD = 'PHON'
 
      ** Deal Transaction Date
 
     C                   EVAL      IKDTYY = DDATYr
     C                   EVAL      IKDTMM = DDATMn
     C                   EVAL      IKDTDD = DDATDy
 
      ** Deal Deleted indicator
 
     C                   EVAL      IKDDLT = ' '
 
      ** Deal Status Indicator
 
     C                   EVAL      IKDSTS = 'A'
 
      ** Rollover indicator
 
     C                   EVAL      IKRBSI = ' '
 
      ** Deal PC Transaction number
 
     C                   EVAL      IKPCTN = *Zeros
 
      ** Deal last action
 
     C                   EVAL      IKLACT = #1ACTN
 
      ** Deal Brokerage
 
     C                   MOVE      *ALL'9'       IKBRKG
 
      ** Deal User Code
      ** Deal authorisation officer
 
     C                   EVAL      IKDUSC = PUSRID
     C                   EVAL      IKAOFR = PUSRID
 
      ** Deal action date
 
     C                   MOVE      PDateOutZ9    IKLDAT
 
      ** Start/Last interest date = Deal value date
 
     C                   EVAL      IKSLYY = IKVDYY
     C                   EVAL      IKSLMM = IKVDMM
     C                   EVAL      IKSLDD = IKVDDD
 
      ** Input interest rate
 
     C                   Z-ADD     IKINTR        IKIIRT
 
      ** Account Sequence Number
 
     C                   EVAL      IKACSQ = 1
 
      ** Negative Interest Indicator
 
     C                   IF        IKINTR < 0
     C                   EVAL      IKNGVI = 'Y'
     C                   ENDIF
 
      ** Midas Taxable Indicator
 
     C                   EVAL      IKMTAX = 'N'
 
      ** Interest accrual contr year = Deal value date
 
     C                   EVAL      IKIAYY = IKVDYY
     C                   EVAL      IKIAMM = IKVDMM
     C                   EVAL      IKIADD = IKVDDD
 
      ** Interest at maturity
 
     C                   EXSR      SRSetIMAT
 
      ** If Amount is negative
 
     C                   IF        IKAMNP < 0
 
     C                   IF        PIMAT < 0
     C                   Z-SUB     PIMAT         IKIMAT
     C                   ELSE
     C                   Z-ADD     PIMAT         IKIMAT
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PIMAT < 0
     C                   Z-ADD     PIMAT         IKIMAT
     C                   ELSE
     C                   Z-SUB     PIMAT         IKIMAT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Ensure Interest at Maturity is same sign as amt if -VE INT.
 
     C                   IF        IKNGVI = 'Y'
     C                   IF        IKAMNP < 0
 
     C                   IF        PIMAT < 0
     C                   Z-ADD     PIMAT         IKIMAT
     C                   ELSE
     C                   Z-SUB     PIMAT         IKIMAT
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PIMAT < 0
     C                   Z-SUB     PIMAT         IKIMAT
     C                   ELSE
     C                   Z-ADD     PIMAT         IKIMAT
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Set automatic authorisation flag to 'Y'
 
     C                   EVAL      IKAUTH = 'Y'
 
      ** If first time around setup WSetFld to '2'
      ** If WSetFld = '2' set it to 'N'
 
     C                   IF        WSetFld = '1'
     C                   EVAL      NwDlFilFmt1 = UpdDlFilFmt
     C                   EVAL      WSetFld = '2'
     C                   ELSE
     C                   EVAL      NwDlFilFmt2 = UpdDlFilFmt
     C                   EVAL      WSetFld = 'N'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetNxtDl - Get next deal number                             *
      *                                                               *
      *****************************************************************
     C     SRGetNxtDl    BEGSR
 
      ** Get next deal number
 
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       PMsgId
     C                   PARM      *BLANKS       ADealNum
     C                   PARM      *ZERO         PDealNum
 
      ** Database error
 
     C                   IF        PMsgId <> *BLANK
     C                   EVAL      DBKEY = #1DLNO                               ************
     C                   EVAL      DBFILE = 'CAGTNXDL'                          * DBERR 08 *
     C                   EVAL      DBASE = 008                                  ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetIMAT - Calulate Interest at Maturity                     *
      *                                                               *
      * Called by: SRSetValid                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRSetIMAT     BEGSR
 
     C                   CALLB     'MM1010'
 
      ** Input Parameters
      ** ================
      ** Total Interest
      ** Interest to date
      ** Interest Payment Frequency
      ** Next interest payment date
      ** Value Date
      ** Interest Calculation Method
      ** Deal Amount
      ** Effective Interest rate
      ** Round Down Interest Indicator
      ** Taxable Indicator
      ** Deal Number
 
     C                   PARM      IKMTTI        PMTTI
     C                   PARM                    PINTD
     C                   PARM      IKIPFQ        PIPFQ
     C                   PARM      IKNIPD        PNIPD
     C                   PARM      IKDVSD        PDVSD
     C                   PARM      IKICMT        PICMT
     C                   PARM      IKAMNP        PAMNP
     C                   PARM      IKINTR        PINTR
     C                   PARM      IKRDFC        PRDFC
     C                   PARM      IKMTAX        PMTAX
     C                   PARM      IKDN38        PDeal
 
      ** Maturity Date for BRT Calculation
 
     C                   PARM                    PBRMD
 
      **  Hong Kong Tax Rate from Dealing ICD
 
     C                   PARM                    BNHKTR
     C                   PARM                    S01383
 
      ** SDBRTDPD
      ** ========
      ** BRT Rate
      ** Date Effective From
      ** BRT Rate - Previous
 
     C                   PARM                    BRTR
     C                   PARM                    DEFF
     C                   PARM                    PBRTR
 
      ** Customer Number
 
     C                   PARM      IKCNUM        PCNUM
 
      ** Currency Code
      ** Location Code
 
     C                   PARM                    PZCCY
     C                   PARM                    PZLOC
 
      ** Interest at Maturity
 
     C                   PARM                    PIMAT
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
 
      ** Update deal
      ** Money Market updates
 
     C                   CALLB     'MMLDNIUPM'
     C                   PARM      *BLANK        @RtCd
     C                   PARM                    NwDlFilFmt1
     C                   PARM      *BLANKS       #FPAYF                                     BUG24144
     C                   PARM      *BLANKS       #FRECF                                     BUG24144
     C                   PARM      *BLANKS       PBFRCD          100                        BUG24144
     C                   PARM      *BLANKS       PAFRCD          100                        BUG24144
 
      ** Deals updates
 
     C                   IF        @RtCd = *BLANK
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    @RtCd
     C                   PARM                    NwDlFilFmt1
     C                   PARM      *BLANKS       #FPAYF                                     BUG24144
     C                   PARM      *BLANKS       #FRECF                                     BUG24144
     C                   PARM      *BLANKS       PBFRCD          100                        BUG24144
     C                   PARM      *BLANKS       PAFRCD          100                        BUG24144
     C                   ENDIF
 
      ** Update associated deal
 
     C                   IF        @RtCd = *BLANK
 
      ** Money Market updates for associated deal
 
     C                   CALLB     'MMLDNIUPM'
     C                   PARM      *BLANK        @RtCd
     C                   PARM                    NwDlFilFmt2
     C                   PARM      *BLANKS       #FPAYF                                     BUG24144
     C                   PARM      *BLANKS       #FRECF                                     BUG24144
     C                   PARM      *BLANKS       PBFRCD          100                        BUG24144
     C                   PARM      *BLANKS       PAFRCD          100                        BUG24144
 
      ** Deals updates for associated deal
 
     C                   IF        @RtCd = *BLANK
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    @RtCd
     C                   PARM                    NwDlFilFmt2
     C                   PARM      *BLANKS       #FPAYF                                     BUG24144
     C                   PARM      *BLANKS       #FRECF                                     BUG24144
     C                   PARM      *BLANKS       PBFRCD          100                        BUG24144
     C                   PARM      *BLANKS       PAFRCD          100                        BUG24144
     C                   ENDIF
 
     C                   ENDIF
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.  Otherwise, commit the updates
 
     C                   IF        @RtCd <> *BLANK AND @RtCd <> '*RECUPD'
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   IF        @RtCd = '*RECUPD'
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ELSE
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   COMMIT
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   COMMIT                                                               CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF
 
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C
     C                   IF        @RtCd = '*RECUPD'
     C
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1)   = 'MMM1023'
     C
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal amendments DL database update')          *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMDEAMUPD - DEAL AMENDMENTS DL DATABASE UPDATE               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 30May14               *
      *                 MD024110           Date 13Dec13               *
      *                 MD020388           Date 23Apr13               *
      *                 MD020071           Date 23Apr13               *
      *                 CRE073             Date 06Dec10               *
      *                 AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG12989           Date 12Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAS009             Date 04May04               *
      *                 BUG6979            Date 04May05               *
      *                 BUG4092            Date 28Sep04               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 12Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 136431             Date 10Jun98               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *  MD024110 - Wrong update of actual interest rate in DEAM      *
      *             for CDL020                                        *
      *  MD020388 - A serious Midas error has occurred upon hitting   *
      *             confirm authorise Insert button                   *
      *  MD020071 - Wrong details of the Confirmation generated       *
      *             after COB                                         *
      *  CRE073 - Interest Rate Rounding                              *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,MMH00002                                 *
      *             WNCPYSRC,MMH00003                                 *
      *             WNCPYSRC,MMH00004                                 *
      *             WNCPYSRC,MMH00005                                 *
      *  BUG12989 - Incorrect EIR rate and amortised F/D/P due to     *
      *             early maturity.                                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  BUG4092- Settlement Instrucstions are not updated            *
      *           correctly when processing an Early Maturity         *
      *  CDL022 - Deal Amendment Changes                              *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDEAMPP               *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  136431 - Trailer wrongly updated                             *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FMMDEMULL  UF A E           K DISK
     F                                     COMMIT
     F                                     IGNORE(DEAMSDHF)
     F*******                              IGNORE(DEAMSDJF)
     FSDTIX     UF A E           K DISK
     F                                     COMMIT
                                                                                              CRE020
     FREADVCL2  UF   E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref/Seq No                     CRE020
                                                                                              CRE020
     FMMEIRDL0  UF   E           K DISK                                                       CAS009
     F                                     COMMIT                                             CAS009
     F/COPY WNCPYSRC,MMDEAMDF01
 
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** Data Structure for SAR Details                                                       CAS009
     D CAS009          S              1A                                                      CAS009
     D PRetCode        S              7A                                                      CAS009
     D POption         S              7A                                                      CAS009
                                                                                              CAS009
     D TABTYP          S              2    DIM(7) CTDATA PERRCD(7)
     D TABSEQ          S              1    DIM(7) ALT(TABTYP)
     D/COPY WNCPYSRC,MMDEAMDD01
     D*
     D**  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID DEAL AMENDMENTS
     D MMVDEM        E DS                  EXTNAME(MMVDEAMPD)
     D  @MMREC               300    368
     D  @MMPY1               369    574
     D  @MMPY2               575    717
     D  @MMPY3               718    927
     D*
     D**  DEAMS FILE - DEAL AMENDMENTS
     D DEAMS         E DS                  EXTNAME(DEAMSDI)
     D  @DLREC               201    269
     D  @DLPY1               270    475
     D  @DLPY2               476    618
     D  @DLPY3               619    828
     D*
     D**  Time data structure for DTRIX.
     D                 DS
     D  @XTIME                 1      6  0
     D  DXTIM                  1      4  0
                                                                                              CRE020
      ** CRE020 Variables                                                                     CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KSeqNo          S              3A                                                      CRE020
     D KPrgMn          S             10A   INZ('MMDEAMUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('DealAmendments      ')                        CRE020
     D PCurSet01       S            200A                                                      CRE020
     D PSysVal02       S             20A                                                      CRE020
     D PCurSet02       S            200A                                                      CRE020
     D PSysVal03       S             20A                                                      CRE020
     D PCurSet03       S            200A                                                      CRE020
     D PSysVal04       S             20A                                                      CRE020
     D PCurSet04       S            200A                                                      CRE020
     D PSysVal05       S             20A                                                      CRE020
     D PCurSet05       S            200A                                                      CRE020
     D PSysVal06       S             20A                                                      CRE020
     D PCurSet06       S            200A                                                      CRE020
     D PSysVal07       S             20A                                                      CRE020
     D PCurSet07       S            200A                                                      CRE020
     D PSysVal08       S             20A                                                      CRE020
     D PCurSet08       S            200A                                                      CRE020
     D PSysVal09       S             20A                                                      CRE020
     D PCurSet09       S            200A                                                      CRE020
     D PSysVal10       S             20A                                                      CRE020
     D PCurSet10       S            200A                                                      CRE020
     D PRtCd           S              7A                                                      CRE020
     D POptn           S              7A                                                      CRE020
     D PSARD           S              6A                                                      CRE020
     D WSysVal01       S              1A                                                      CRE020
     D WEvent          S              8A                                                      CRE020
     D WNew            S              1A                                                      CRE020
     D CRE073          S              1A                                                      CRE073
     D*
     D* DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D* DATA STRUCTURE FOR BANK DETAILS
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D** External DS for TRADE Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D** External DS for CURRENCY Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE020
     D  SCLCD        E                     EXTFLD(LCD)                                        CRE020
      ** External DS for Switchable Feature Details                                           CRE020
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* DATA STRUCTURE FOR BASE RATE                                                        MD020071
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                                MD020071
     D/COPY WNCPYSRC,MMH00002
                                                                                              CDL017
     D ZMUSER          DS            17                                                       CDL017
     D  ZUSER                  1     10                                                       CDL017
     D  BRC                   11     13                                                       CDL017
     D  DEPT                  14     16                                                       CDL017
                                                                                              CDL017
     IDTRIXDF
     I              RECI                        DXRECI
     I              RCDT                        DXRCDT
     I              DLNO                        DXDLNO
     I              VDAT                        DXVDAT
     I              DASN                        DXDASN
     I              CHTP                        DXCHTP
     I              CNRQ                        DXCNRQ
     I              CNPR                        DXCNPR
     I              REPR                        DXREPR
     I              TIM                         DXTIM
     I              DADI                        DXDADI
     I              PRI1                        DXPRI1
     I              PRI2                        DXPRI2
     I              PRI3                        DXPRI3
     I              ICIN                        DXICIN
     I              BRCA                        DXBRCA
     I              TNLU                        DXTNLU
     IDTRIXHF
     I              RECI                        DXRECI
     I              RCDT                        DXRCDT
     I              DLNO                        DXDLNO
     I              NDLR                        DXNDLR
     I              NDAR                        DXNDAR
     I* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     I/SPACE 5
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
      *
      * EXIT IF NOT INSERTION, AMENDMENT OR REVERSAL
      *
     C     IGCHTP        IFNE      'I'
     C     IGCHTP        ANDNE     'A'
     C     IGCHTP        ANDNE     'R'
     C                   RETURN
     C                   END
      *
      * SRINIT - INITIAL PROCESSING
      *
     C                   EXSR      SRINIT
      *
      * INSERT, AMEND, OR REVERSE THE DEAL AMENDMENT
      *
     C     IGCHTP        CASEQ     'I'           DEMINS
     C     IGCHTP        CASEQ     'A'           DEMAMD
     C     IGCHTP        CASEQ     'R'           DEMDEL
     C                   END
      *
      * SET PAY/RECEIVE INDICATORS TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      PYRCIN
      *
      * WRITE A DTRIX RECORD
      *
     C                   EXSR      WRTDTX
      *
      * UPDATE THE DTRIX HEADER RECORD
      *
     C                   EXSR      UPDDTH
      *
      ** UPDATE THE DEAMS FILE TRAILER
      ** ON INSERTS AND REVERSALS
      *
     C     IGCHTP        IFEQ      'I'
     C     IGCHTP        OREQ      'R'
     C                   EXSR      UPDTRL
     C                   END
      *
      * EXIT FROM PROGRAM
      *
     C                   RETURN
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* DEMINS - INSERT A DEAL AMENDMENT                             *
     C*                                                              *
     C****************************************************************
     C     DEMINS        BEGSR
      *
      * UPDATE DEAL AMENDMENT RECORD LINKAGES
      *
     C                   EXSR      UPLINK
      *
      * INITIALIZE DEAL AMENDMENT
      *
     C                   CLEAR                   DEAMS
      *
      * RECORD ID
      *
     C                   MOVEL     'D'           RECI
      *
      * DEAL NUMBER
     C                   Z-ADD     IGDA38        DLNO
      *
      * VALUE DATE
     C                   Z-ADD     IGDVSD        VDAT
      *
      * DEAL AMEND SEQ
     C                   Z-ADD     IGDS38        DASN
      *
      * DEAL TYPE
     C                   MOVE      IGOMDT        DTYP
      *
      * DEAL SUB-TYPE
     C                   MOVE      IGOSTP        DLST
      *
      * AMENDMENT TYPE
     C                   MOVE      IGMTYP        AMTP
      *
      ** PROCESSING SEQUENCE
     C                   Z-ADD     *ZERO         PSEQ
     C/COPY WNCPYSRC,MMDEAMDC01
     C     AMTP          LOOKUP    TABTYP        TABSEQ                   99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     TABSEQ        PSEQ
     C                   ENDIF
     C/COPY WNCPYSRC,MMDEAMDC02
      *
      ** BASE RATE CODE
     C                   Z-ADD     *ZERO         BRTT
      *
      ** RATE/SPREAD
     C                   Z-ADD     IGINTR        RTSP
      *
      ** CURRENCY
     C                   MOVE      IGCCY         CCY
      *
      ** AMOUNT
     C     IGAMNP        IFLT      *ZERO
     C                   Z-SUB     IGAMNP        DAAM
     C                   ELSE
     C                   Z-ADD     IGAMNP        DAAM
     C                   END
      *
      ** MANUAL OR GENERATED
     C                   MOVE      'M'           MOGI
      *
      ** CUSTOMER
     C**********         Z-ADD     IGCNUM        CNUM                                         CSD027
     C                   EVAL      CNUM = IGCNUM                                              CSD027
      **
      ** IF PRINCIPAL DECREASE OF DEPOSIT TAKEN
      ** OR PRINCIPAL INCREASE OF DEPOSIT PLACED
      ** OR SETTLE INTEREST OF DEPOSIT TAKEN
      **
     C     IGTYPE        IFEQ      'PD'
     C     W#LOD         ANDEQ     'D'
     C     IGTYPE        OREQ      'PI'
     C     W#LOD         ANDEQ     'L'
     C     IGTYPE        OREQ      'SI'
     C     W#LOD         ANDEQ     'D'
     C     IGTYPE        OREQ      'EM'                                         BUG4092
     C     IGPENP        ANDEQ     'P'                                          BUG4092
      *
      ** PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   Z-ADD     IGMOPM        SETP
     C                   MOVE      IGMOPI        OSAC
     C                   MOVE      IGMCRI        TSEN
     C                   MOVE      IGMFAO        FACO
     C                   MOVE      IGSPEC        SPI
      **
      ** IF PRINCIPAL DECREASE OF DEPOSIT PLACED
      ** OR PRINCIPAL INCREASE OF DEPOSIT TAKEN
      ** OR SETTLE INTEREST OF DEPOSIT PLACED
      **
     C                   ELSE
     C     IGTYPE        IFEQ      'PD'
     C     W#LOD         ANDEQ     'L'
     C     IGTYPE        OREQ      'PI'
     C     W#LOD         ANDEQ     'D'
     C     IGTYPE        OREQ      'SI'
     C     W#LOD         ANDEQ     'L'
     C     IGTYPE        OREQ      'EM'                                         BUG4092
     C     IGPENP        ANDEQ     'R'                                          BUG4092
      *
      ** RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   Z-ADD     IGORCM        SETP
     C                   MOVE      IGMORI        OSAC
     C                   MOVE      IGMCPI        TSEN
     C                   END
     C                   END
      *
      ** OUR SETTLEMENT BRANCH
     C                   MOVEL     IGOSBR        OSBR
      *
      ** BRANCH
     C                   MOVEL     IGBRCA        BRCA
      *
      ** NEXT AMENDMENT ACTION DATE & SEQ
      *
     C                   Z-ADD     @@NAAD        NAAD
     C                   Z-ADD     @@NASN        NASN
      *
      ** INDICATORS
     C                   BITOFF    '01234567'    DAIN
      *
      ** LAST SWIFT CONF SEQ
     C                   Z-ADD     *ZERO         LSWC
      *
      ** ORIGINAL ENTRY DATE, LAST CHANGE DATE & CHANGETYPE
      *
     C                   Z-ADD     BJRDNB        ORED
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'I'           CHTP
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMREC        @DLREC
     C                   MOVEL     IGRONS        RONS                                         CGL029
      *
      * Enhanced Receive Settlement Instructions                                              CDL094
     C                   MOVEL     IGRBB1        RBTB1                                        CDL094
     C                   MOVEL     IGRBB2        RBTB2                                        CDL094
     C                   MOVEL     IGRBB3        RBTB3                                        CDL094
     C                   MOVEL     IGRBB4        RBTB4                                        CDL094
     C                   MOVEL     IGRBB5        RBTB5                                        CDL094
     C                   MOVEL     IGRBB6        RBTB6                                        CDL094
      *                                                                                       CDL094
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMPY1        @DLPY1
     C                   MOVEL     @MMPY2        @DLPY2
     C                   MOVEL     @MMPY3        @DLPY3
     C                   MOVEL     IGPONS        PONS                                         CGL029
      *
      ** COVER MESSAGE
     C     IGCVMR        IFNE      'Y'
     C                   MOVE      'N'           CVMR
     C                   ELSE
     C                   MOVE      'Y'           CVMR
     C                   END
      *
      **  Funding details
      *
     C                   Z-ADD     IGFSRP        FSRP
     C                   MOVE      IGIRCF        IRCF
     C                   MOVE      IGFRCF        FRCF
      *
      ** EMU Settlement fields
      *
     C                   MOVEL     IGSTCY        STCY
     C                   MOVEL     IGIC72        IC72
      *                                                                         CAP051
      ** Automatic Authorisation                                                CAP051
      *                                                                         CAP051
     C                   MOVEL     IGAUTH        AUTH                           CAP051
                                                                                CDL006
      ** Fiduciary charge details                                               CDL006
      ** - Fiduciary charge code                                                CDL006
                                                                                CDL006
     C                   MoveL     IGFCGC        FCGC                           CDL006
                                                                                CDL006
      ** - Fiduciary charge code description                                    CDL006
                                                                                CDL006
     C                   MoveL     IGFCGD        FCGD                           CDL006
                                                                                CDL006
      ** - Fiduciary charge amount                                              CDL006
                                                                                CDL006
     C                   Z-Add     IGFXGA        FCGA                           CDL006
                                                                                CDL017
      ** - Penalty Pay/Receive                                                  CDL017
                                                                                CDL017
     C                   MoveL     IGPENP        PENLTY                         CDL017
                                                                                CDL017
      ** - Early Maturity Date                                                  CDL017
                                                                                CDL017
     C                   Z-Add     IGEMDT        EMDAT                          CDL017
                                                                                CDL017
      ** - Input User                                                           CDL017
                                                                                CDL017
     C                   MoveL     IGUSER        INPUSR                         CDL017
                                                                                CDL017
      ** - Authorising User                                                     CDL017
                                                                                CDL017
     C     IGDSTS        IFEQ      'A'                                          CDL017
     C                   MoveL     ZUSER         AUTUSR                         CDL017
     C                   ENDIF                                                  CDL017
                                                                                CDL022
      ** - Base Rate Code                                                       CDL022
                                                                                CDL022
     C                   MoveL     IGBSRT        BRTT                           CDL022
                                                                                CDL020
      ** - Base Rate                                                            CDL020
                                                                                CDL020
     C**********         Z-Add     IGBRTE        BRTE                                CDL020 MD020071
     C                   IF        IGBRTE = *ZEROS                                          MD024110
     C                   IF        IGBSRT <> *Blanks                                        MD020388
     C                   EXSR      ACSBRT                                                   MD020071
     C                   ENDIF                                                              MD020388
     C                   ELSE                                                               MD024110
     C                   Z-ADD     IGBRTE        BRTE                                       MD024110
     C                   ENDIF                                                              MD024110
      *                                                                                       CDL038
      * DEAL CLASS                                                                            CDL038
     C                   MOVE      IGCLAS        CLAS                                         CDL038
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   EVAL      CNSP = IGCNSP                                              CRE073
     C                   EVAL      CNSG = 'A'                                                 CRE073
     C                   EVAL      RDMT = IGRDMT                                              CRE073
     C                   EVAL      RDFD = IGRDFD                                              CRE073
     C                   ENDIF                                                                CRE073
      *
      * WRITE DEAL AMENDMENT
      *
     C                   WRITE     DEAMSDIF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CAS009
     C                   IF        CAS009 = 'Y'                                               CAS009
     C     DLNO          CHAIN     MMEIRDL0                                                   CAS009
     C                   IF        %FOUND(MMEIRDL0)                                           CAS009
     C                   IF        VDAT <= EIENDT                                             CAS009
     C                             AND EIRCAL <> 'Y'                                          CAS009
     C                   EVAL      EIRCAL = 'Y'                                               CAS009
      ** If early maturity, update Adjust EIR Period indicator                              BUG12989
      *                                                                                     BUG12989
     C                   IF        IGTYPE = 'EM'                                            BUG12989
     C                   EVAL      EIADJP = 'Y'                                             BUG12989
     C                   ENDIF                                                              BUG12989
      *                                                                                     BUG12989
     C                   UPDATE    MMEIRDD0                                                   CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C                   ENDIF                                                                CAS009
     C                   ENDIF                                                                CAS009
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* DEMAMD - AMEND A DEAL AMENDMENT                              *
     C*                                                              *
     C****************************************************************
     C     DEMAMD        BEGSR
      *
      * ACCESS DEAL AMENDMENT
      *
     C     DEAMK         CHAIN     DEAMSDIF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IGDA38        DBKEY
     C                   MOVEL     'DEAMSDI '    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   EXSR      SRERR                                        ************
     C                   END
      **
      ** IF PRINCIPAL DECREASE OF DEPOSIT TAKEN
      ** OR PRINCIPAL INCREASE OF DEPOSIT PLACED
      ** OR SETTLE INTEREST OF DEPOSIT TAKEN
      **
     C     IGTYPE        IFEQ      'PD'
     C     W#LOD         ANDEQ     'D'
     C     IGTYPE        OREQ      'PI'
     C     W#LOD         ANDEQ     'L'
     C     IGTYPE        OREQ      'SI'
     C     W#LOD         ANDEQ     'D'
     C     IGTYPE        OREQ      'EM'                                         BUG4092
     C     IGPENP        ANDEQ     'P'                                          BUG4092
      *
      ** PAY SETTLEMENT INSTRUCTIONS
      *
     C                   Z-ADD     IGMOPM        SETP
     C                   MOVE      IGMOPI        OSAC
     C                   MOVE      IGMCRI        TSEN
     C                   MOVE      IGMFAO        FACO
     C                   MOVE      IGSPEC        SPI
      **
      ** IF PRINCIPAL DECREASE OF DEPOSIT PLACED
      ** OR PRINCIPAL INCREASE OF DEPOSIT TAKEN
      ** OR SETTLE INTEREST OF DEPOSIT PLACED
      **
     C                   ELSE
     C     IGTYPE        IFEQ      'PD'
     C     W#LOD         ANDEQ     'L'
     C     IGTYPE        OREQ      'PI'
     C     W#LOD         ANDEQ     'D'
     C     IGTYPE        OREQ      'SI'
     C     W#LOD         ANDEQ     'L'
     C     IGTYPE        OREQ      'EM'                                         BUG4092
     C     IGPENP        ANDEQ     'R'                                          BUG4092
      *
      ** RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   Z-ADD     IGORCM        SETP
     C                   MOVE      IGMORI        OSAC
     C                   MOVE      IGMCPI        TSEN
     C                   END
     C                   END
      *
      ** OUR SETTLEMENT BRANCH
     C                   MOVEL     IGOSBR        OSBR
      *
      ** IF SETTLEMENT DETAILS HAVE CHANGED
      ** PRODUCE A TELEX
      *
     C     @MMREC        IFNE      @DLREC
     C     IGRONS        ANDNE     RONS                                                       CGL029
     C     @MMPY1        ORNE      @DLPY1
     C     IGPONS        ANDNE     PONS                                                       CGL029
     C                   BITOFF    '1'           DAIN
     C                   END
      *
      ** LAST CHANGE DATE & CHANGE TYPE
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'A'           CHTP
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMREC        @DLREC
     C                   MOVEL     IGRONS        RONS                                         CGL029
      *
      * Enhanced Receive Settlement Instructions                                              CDL094
     C                   MOVEL     IGRBB1        RBTB1                                        CDL094
     C                   MOVEL     IGRBB2        RBTB2                                        CDL094
     C                   MOVEL     IGRBB3        RBTB3                                        CDL094
     C                   MOVEL     IGRBB4        RBTB4                                        CDL094
     C                   MOVEL     IGRBB5        RBTB5                                        CDL094
     C                   MOVEL     IGRBB6        RBTB6                                        CDL094
      *                                                                                       CDL094
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMPY1        @DLPY1
     C                   MOVEL     @MMPY2        @DLPY2
     C                   MOVEL     @MMPY3        @DLPY3
     C                   MOVEL     IGPONS        PONS                                         CGL029
      *
      ** COVER MESSAGE
     C     IGCVMR        IFNE      'Y'
     C                   MOVE      'N'           CVMR
     C                   ELSE
     C                   MOVE      'Y'           CVMR
     C                   END
      *
      **  Funding details
      *
     C                   Z-ADD     IGFSRP        FSRP
     C                   MOVE      IGIRCF        IRCF
     C                   MOVE      IGFRCF        FRCF
      *
      ** EMU Settlement fields
      *
     C                   MOVEL     IGSTCY        STCY
     C                   MOVEL     IGIC72        IC72
      *                                                                         CAP051
      ** Automatic Authorisation                                                CAP051
      *                                                                         CAP051
     C                   MOVEL     IGAUTH        AUTH                           CAP051
                                                                                CDL006
      ** Fiduciary charge details                                               CDL006
      ** - Fiduciary charge code                                                CDL006
                                                                                CDL006
     C                   MoveL     IGFCGC        FCGC                           CDL006
                                                                                CDL006
      ** - Fiduciary charge code description                                    CDL006
                                                                                CDL006
     C                   MoveL     IGFCGD        FCGD                           CDL006
                                                                                CDL006
      ** - Fiduciary charge amount                                              CDL006
                                                                                CDL006
     C                   Z-Add     IGFXGA        FCGA                           CDL006
                                                                                CDL017
      ** - Penalty Pay/Receive                                                  CDL017
                                                                                CDL017
     C                   MoveL     IGPENP        PENLTY                         CDL017
                                                                                CDL017
      ** - Early Maturity Date                                                  CDL017
                                                                                CDL017
     C                   Z-Add     IGEMDT        EMDAT                          CDL017
                                                                                CDL017
      ** - Input User                                                           CDL017
                                                                                CDL017
     C                   MoveL     IGUSER        INPUSR                         CDL017
                                                                                CDL017
      ** - Authorising User                                                     CDL017
                                                                                CDL017
     C     IGDSTS        IFEQ      'A'                                          CDL017
     C                   MoveL     ZUSER         AUTUSR                         CDL017
     C                   ENDIF                                                  CDL017
                                                                                CDL022
      ** - Base Rate Code                                                       CDL022
                                                                                CDL022
     C                   MoveL     IGBSRT        BRTT                           CDL022
                                                                                CDL020
      ** - Base Rate                                                            CDL020
                                                                                CDL020
     C**********         Z-Add     IGBRTE        BRTE                                CDL020 MD020071
     C                   IF        IGBRTE = *ZEROS                                          MD024110
     C                   IF        IGBSRT <> *Blanks                                        MD020388
     C                   EXSR      ACSBRT                                                   MD020071
     C                   ENDIF                                                              MD020388
     C                   ELSE                                                               MD024110
     C                   Z-ADD     IGBRTE        BRTE                                       MD024110
     C                   ENDIF                                                              MD024110
      *
      * UPDATE DEAL AMENDMENT
      *
     C                   UPDATE    DEAMSDIF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* DEMDEL - DELETE A DEAL AMENDMENT                             *
     C*                                                              *
     C****************************************************************
     C     DEMDEL        BEGSR
      *
      * ACCESS DEAL AMENDMENT
      *
     C     DEAMK         CHAIN     DEAMSDIF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IGDA38        DBKEY
     C                   MOVEL     'DEAMSDI '    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * SET RECORD ID TO 'REVERSED'
      *
     C                   MOVE      'R'           RECI
      *
      ** LAST CHANGE DATE & TYPE
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'R'           CHTP
     C                   BITOFF    '01234567'    DAIN
      *
     C                   UPDATE    DEAMSDIF
      *
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      * UPDATE DEAL AMENDMENT RECORD LINKAGES
      *
     C                   Z-ADD     NAAD          @@TAAD
     C                   Z-ADD     NASN          @@TASN
     C                   EXSR      UPLINK
      *                                                                                       CAS009
     C                   IF        CAS009 = 'Y'                                               CAS009
     C     DLNO          CHAIN     MMEIRDL0                                                   CAS009
     C                   IF        %FOUND(MMEIRDL0)                                           CAS009
     C                                                                                        CAS009
     C                   IF        VDAT <= EIENDT                                             CAS009
     C                             AND EIRCAL <> 'Y'                                          CAS009
     C                   EVAL      EIRCAL = 'Y'                                               CAS009
     C                   UPDATE    MMEIRDD0                                                   CAS009
     C                   ENDIF                                                                CAS009
     C                   ENDIF                                                                CAS009
     C                   ENDIF                                                                CAS009
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* PYRCIN - DETERMINE PAY/RECEIVE INDICATORS                    *
     C*                                                              *
     C****************************************************************
     C     PYRCIN        BEGSR
      *
     C                   Z-ADD     *ZERO         @@PRI1            1 0
     C                   Z-ADD     *ZERO         @@PRI2            1 0
     C                   Z-ADD     *ZERO         @@PRI3            1 0
      *
      * BYPASS IF NO SETTLEMENT IS OCCURRING
      *
     C     IGMTYP        IFNE      'PI'
     C     IGMTYP        ANDNE     'PD'
     C     IGMTYP        ANDNE     'SI'
     C                   GOTO      EPYRCI
     C                   END
      *
      ** PAY/RECEIVE INDICATOR 1 = VALUE DATE OF DEAL AMENDMENT
      *  ------------------------------------------------------
      *
      ** Determine if local or deal currency to be used
      ** in holiday checking
      *
     C                   MOVEL     'L'           @DLOLC
     C                   MOVEL     *BLANK        @NOSTR
      **
      ** IF PRINCIPAL DECREASE OF DEPOSIT TAKEN
      ** OR PRINCIPAL INCREASE OF DEPOSIT PLACED
      ** OR SETTLE INTEREST OF DEPOSIT TAKEN
      **
     C     IGTYPE        IFEQ      'PD'
     C     W#LOD         ANDEQ     'D'
     C     IGTYPE        OREQ      'PI'
     C     W#LOD         ANDEQ     'L'
     C     IGTYPE        OREQ      'SI'
     C     W#LOD         ANDEQ     'D'
      *
      ** A PAYMENT IS DUE
      *
     C     IGPSTM        IFEQ      01
     C     IGPSTM        OREQ      07
     C     IGPSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IGPONS        @NOSTR
     C                   END
      *
      ** ELSE A RECEIPT IS DUE
      *
     C                   ELSE
     C     IGRSTM        IFEQ      01
     C     IGRSTM        OREQ      07
     C     IGRSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IGRONS        @NOSTR
     C                   END
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      * Set PRI1 if value date is within telex notice period
      *
     C     IGDVSD        IFGE      BJRDNB
     C     IGDVSD        ANDLE     @TLXDU
     C/COPY WNCPYSRC,MMDEAMDC03
     C     IGMTYP        IFEQ      'PI'                                         136431
     C                   Z-ADD     1             @@PRI1
     C                   END                                                    136431
     C     IGMTYP        IFEQ      'SI'                                         136431
     C                   Z-ADD     1             @@PRI2                         136431
     C                   END                                                    136431
     C     IGMTYP        IFEQ      'PD'                                         136431
     C                   Z-ADD     1             @@PRI3                         136431
     C                   END                                                    136431
     C                   END
      *
     C     EPYRCI        ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* WRTDTX - WRITE A DTRIX RECORD                                *
     C*                                                              *
     C****************************************************************
     C     WRTDTX        BEGSR
      *
      **  SET FIELDS ON RECORD TO BE WRITTEN TO DTRIXDD
      *
     C                   MOVE      'D'           DXRECI
     C                   MOVE      'A'           DXRCDT
     C                   Z-ADD     IGDA38        DXDLNO
     C                   Z-ADD     IGDVSD        DXVDAT
     C                   Z-ADD     IGDS38        DXDASN
     C                   MOVE      IGCHTP        DXCHTP
     C                   MOVE      'N'           DXCNRQ
     C                   MOVE      'N'           DXCNPR
     C                   MOVE      ' '           DXREPR
     C                   TIME                    @XTIME
     C                   MOVE      @@PRI1        DXPRI1
     C                   MOVE      @@PRI2        DXPRI2
     C                   MOVE      @@PRI3        DXPRI3
     C                   Z-ADD     0             DXICIN
     C                   MOVEL     IGBRCA        DXBRCA
     C                   Z-ADD     *ZERO         DXTNLU
     C*
     C                   WRITE     DTRIXDF
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDDTH - UPDATE THE DTRIX HEADER RECORD                      *
     C*                                                              *
     C****************************************************************
     C     UPDDTH        BEGSR
      *
      ** Access the header record
      *
     C                   Z-ADD     *ZERO         DXDLNO
     C     DXDLNO        CHAIN     DTRIXHF                            99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     DXDLNO        DBKEY
     C                   MOVEL     'DTRIXHF '    DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * Add 1 to number of deal amendment records (on DTRIXDD)
      *
     C                   ADD       1             DXNDAR
      *
     C                   UPDATE    DTRIXHF
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDTRL- UPDATE THE DEAMS FILE TRAILER                        *
     C*                                                              *
     C****************************************************************
     C     UPDTRL        BEGSR
      *
     C                   CALLB     'ZADMTRLRUD'
      *
      ** Return Code
     C                   PARM      *BLANKS       @@RTCD            7
      *
      ** Change Type
     C                   PARM      IGCHTP        @@CHTP            1
      *                                                                         136431
      ** Deal Amendment Type                                                    136431
     C                   PARM      IGTYPE        @@TYPE            2            136431
      *
      ** Amount
     C                   PARM      IGAMNP        @@AMNP           15 0
      *
      ** Run Date
     C                   PARM                    BJRDNB            5 0
      *
      ** DATABASE ERROR
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C                   MOVEL     '999999'      DBKEY
     C                   MOVEL     'DEAMSDJ '    DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 004*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* TLXDUE - DETERMINE TELEX DUE DATE                            *
     C*                                                              *
     C****************************************************************
     C     TLXDUE        BEGSR
      *
      * EFFECTIVE SETTLEMENT CURRENCY
      *
     C     IGSTCY        IFNE      *BLANKS
     C                   MOVEL     IGSTCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     IGCCY         EffSetCcy         3
     C                   ENDIF
     C/COPY WNCPYSRC,MMH00003
      *
     C                   CALLB     'ZATLXDUEDT'
      *
      ** Deal or local Currency
     C                   PARM                    @DLOLC            1
      *
      ** Currency
     C                   PARM      EffSetCcy     @CCY              3
      *
      ** Nostro
     C                   PARM                    @NOSTR            2
      *
      ** Date of Next Working Day
     C                   PARM                    BJDNWD            5 0
      *
      ** Local Currency
     C                   PARM                    BJLCCY            3
      *
      ** System Location
     C                   PARM                    BJSLCD            3
      *
      ** Telex Due Date
     C                   PARM      *ZERO         @TLXDU            5 0
     C/COPY WNCPYSRC,MMH00004
     C                   ENDSR
     C****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* UPLINK - UPDATE DEAL AMENDMENT RECORD LINKAGES                *
     C*                                                               *
     C*****************************************************************
     C     UPLINK        BEGSR
      *
      * CALLED ON:
      * INSERT   - RETURNS VALUE DATE & SEQ LINKAGE FOR NEW DEAL AMENDMENT
      * REVERSAL - VALUE DATE & SEQ LINKAGE OF REVERSED DEAL AMENDMENT
      *            PASSED TO IT
      *
     C                   CALLB     'ZADMLINKUD'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM                    IGCHTP
     C                   PARM                    IGDA38
     C                   PARM                    IGDVSD
     C                   PARM                    IGDS38
     C                   PARM                    IGMTYP
     C                   PARM                    @@TAAD            5 0
     C                   PARM                    @@TASN            3 0
     C                   PARM      *ZERO         @@NAAD            5 0
     C                   PARM      *ZERO         @@NASN            3 0
      *
      * ERROR
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C                   MOVEL     IGDA38        DBKEY
     C                   MOVEL     'ZADMLINKUD'  DBFILE                         ************
     C                   MOVEL     '005'         DBASE                          * DBERR 005*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SRINIT - INITIAL PROCESSING                                   *
     C*                                                               *
     C*****************************************************************
     C     SRINIT        BEGSR
                                                                                             BUG6979
      **  GET ZMUSER to access User for Authorisation                                        BUG6979
                                                                                             BUG6979
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG6979
     C                   IN        ZMUSER                                                    BUG6979
     C                   UNLOCK    ZMUSER                                                    BUG6979
      *
      * LOAN OR DEPOSIT TYPE DEAL?
      *
     C     IGOMDT        IFEQ      'IT'
     C     IGOMDT        OREQ      'TD'
     C     IGOMDT        OREQ      'CI'
     C     IGOMDT        OREQ      'CD'
     C                   MOVEL     'D'           W#LOD             1
     C                   ELSE
     C                   MOVEL     'L'           W#LOD
     C                   END
      *
     C                   ENDSR
      *****************************************************************                       CRE020
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
      *             transaction.                                      *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRIdxTrn      BEGSR                                                                CRE020
                                                                                              CRE020
      ** Initialise key values.                                                               CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       KRefNo                                       CRE020
     C                   MOVE      *BLANKS       KSeqNo                                       CRE020
     C                   MOVEL     DLNO          KRefNo                                       CRE020
     C                   MOVEL     DASN          KSeqNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   MOVE      *BLANK        WNew                                         CRE020
                                                                                              CRE020
     C                   OPEN      READVCL2                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL2                                                   CRE020
     C     KADVC         READE     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF                                                   CRE020
                                                                                              CRE020
      ** Check first if this is a new advice index.                                           CRE020
                                                                                              CRE020
     C                   IF        WNew = *BLANK                                              CRE020
     C                   IF        RCHTYP = 'I' AND                                           CRE020
     C                             RSAPIN = 'N'                                               CRE020
     C                   MOVE      'Y'           WNew                                         CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'N'           WNew                                         CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Set default values if the advice indicator is equal to blank.                        CRE020
                                                                                              CRE020
     C                   IF        RSAPIN = ' '                                               CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       WEvent                                       CRE020
     C                   MOVEL     RENARR        WEvent                                       CRE020
                                                                                              CRE020
      ** Change type is always 'I' for newly inserted value records. 'A'                      CRE020
      ** otherwise.                                                                           CRE020
                                                                                              CRE020
     C                   IF        WEvent = 'VALUE'                                           CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'A'           RCHTYP                                       CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute reversal processing if necessary.                                            CRE020
                                                                                              CRE020
     C                   IF        CHTP = 'R'                                                 CRE020
                                                                                              CRE020
      ** Delete the advice index if the current record is a new deal                          CRE020
      ** amendment. Reverse it otherwise.                                                     CRE020
                                                                                              CRE020
     C                   MOVE      'R'           RCHTYP                                       CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
                                                                                              CRE020
     C                   IF        WNew = 'Y'                                                 CRE020
     C                   MOVE      'Y'           RSAPIN                                       CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute amend processing.                                                            CRE020
                                                                                              CRE020
     C                   IF        WNew = 'Y'                                                 CRE020
     C                   MOVE      *BLANKS       WEvent                                       CRE020
     C                   MOVEL     RENARR        WEvent                                       CRE020
                                                                                              CRE020
     C                   IF        WEvent = 'VALUE'                                           CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'A'           RCHTYP                                       CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Change field values only if the authorise indicator is equal to 'N'.                 CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   MOVE      CHTP          RCHTYP                                       CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C     KADVC         READE     READVCL2                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    MMVDEM
      **********                                                                      CDL017 BUG6979
      ****GET*ZMUSER*to*access*User*for*Authorisation                                 CDL017 BUG6979
      **********                                                                      CDL017 BUG6979
     C******DTAARA       DEFINE                  ZMUSER                               CDL017 BUG6979
     C**********         IN        ZMUSER                                             CDL017 BUG6979
     C**********         UNLOCK    ZMUSER                                             CDL017 BUG6979
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
      ** ACCESS TRADING DETAILS
      *
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDTRADPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      SRERR                                        *************
     C                   END
                                                                                              CRE020
      ** Check if CRE020 is enabled.                                                          CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM      '*VERIFY'     POptn                                        CRE020
     C                   PARM      'CRE020'      PSARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBase = 902                                                CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Check if a System Value exists for this maintenance.                                 CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
                                                                                              CRE020
     C                   CALLB     'AOSVALR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM                    PSysVal01                                    CRE020
     C                   PARM                    PCurSet01                                    CRE020
     C                   PARM                    PSysVal02                                    CRE020
     C                   PARM                    PCurSet02                                    CRE020
     C                   PARM                    PSysVal03                                    CRE020
     C                   PARM                    PCurSet03                                    CRE020
     C                   PARM                    PSysVal04                                    CRE020
     C                   PARM                    PCurSet04                                    CRE020
     C                   PARM                    PSysVal05                                    CRE020
     C                   PARM                    PCurSet05                                    CRE020
     C                   PARM                    PSysVal06                                    CRE020
     C                   PARM                    PCurSet06                                    CRE020
     C                   PARM                    PSysVal07                                    CRE020
     C                   PARM                    PCurSet07                                    CRE020
     C                   PARM                    PSysVal08                                    CRE020
     C                   PARM                    PCurSet08                                    CRE020
     C                   PARM                    PSysVal09                                    CRE020
     C                   PARM                    PCurSet09                                    CRE020
     C                   PARM                    PSysVal10                                    CRE020
     C                   PARM                    PCurSet10                                    CRE020
                                                                                              CRE020
     C                   EVAL      WSysVal01 = 'N'                                            CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   MOVEL     PCurSet01     WSysVal01                                    CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBase = 903                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
      *
      * KEY LISTS
      *
     C     DEAMK         KLIST
     C                   KFLD                    IGDA38
     C                   KFLD                    IGDVSD
     C                   KFLD                    IGDS38
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
     C                   KFLD                    KSeqNo                                       CRE020
     C*
      *
      ** Check if CAS009 is installed                                                         CAS009
      *                                                                                       CAS009
     C                   EVAL      CAS009 = 'N'                                               CAS009
     C                   CALLB     'AOSARDR0'                                                 CAS009
     C                   PARM      *BLANKS       PRetCode                                     CAS009
     C                   PARM      '*VERIFY'     POption                                      CAS009
     C                   PARM      'CAS009'      PSard                                        CAS009
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS009
      *                                                                                       CAS009
      ** Database error                                                                       CAS009
      *                                                                                       CAS009
     C                   IF        PRetCode <> *BLANKS AND                                    CAS009
     C                             PRetCode <> '*NRF   '                                      CAS009
     C                   EVAL      DBKEY = 'CAS009'                                           CAS009
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS009
     C                   EVAL      DBASE = 6                                                  CAS009
     C                   EXSR      SRERR                                                      CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   IF        PRetCode = *BLANKS                                         CAS009
     C                   EVAL      CAS009 = 'Y'                                               CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      *                                                                                       CRE073
      ** Check if CRE073 is installed                                                         CRE073
      *                                                                                       CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRetCode                                     CRE073
     C                   PARM      '*VERIFY'     POption                                      CRE073
     C                   PARM      'CRE073'      PSard                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
      *                                                                                       CRE073
      ** Database error                                                                       CRE073
      *                                                                                       CRE073
     C                   IF        PRetCode <> *BLANKS AND                                    CRE073
     C                             PRetCode <> '*NRF   '                                      CRE073
     C                   EVAL      DBKEY = 'CRE073'                                           CRE073
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBASE = 7                                                  CRE073
     C                   EXSR      SRERR                                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   IF        PRetCode = *BLANKS                                         CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C/COPY WNCPYSRC,MMH00005
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'MMDEAMUPD'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT                                                                                MD020071
     C****************************************************************                      MD020071
     C*                                                              *                      MD020071
     C* ACSBRT - ACCESS BASE RATE                                    *                      MD020071
     C*                                                              *                      MD020071
     C****************************************************************                      MD020071
     C     ACSBRT        BEGSR                                                              MD020071
      *                                                                                     MD020071
      ** Access base rate record                                                            MD020071
      *                                                                                     MD020071
     C                   CALLB     'AOBSRTR0'                                               MD020071
     C                   PARM      '*MSG   '     @RTCD             7                        MD020071
     C                   PARM      '*KEY   '     @OPTN             7                        MD020071
     C                   PARM      IGCCY         @ICCY             3                        MD020071
     C                   PARM      IGBSRT        @BSRT             2                        MD020071
     C     SDBSRT        PARM      SDBSRT        DSSDY                                      MD020071
      *                                                                                     MD020071
      ** DATABASE ERROR                                                                     MD020071
      *                                                                                     MD020071
     C     @RTCD         IFNE      *BLANK                                                   MD020071
     C                   MOVEL     IGCCY         @DBFD             8                        MD020071
     C                   MOVE      IGBSRT        @DBFD                                      MD020071
     C                   MOVEL     @DBFD         DBKEY                                      MD020071
     C                   MOVEL     'SDBSRTPD'    DBFILE                                     MD020071
     C                   MOVEL     '904'         DBASE                                      MD020071
     C                   EXSR      SRERR                                                    MD020071
     C                   ELSE                                                               MD020071
     C                   Z-ADD     BACBSR        BRTE                                       MD020071
     C                   END                                                                MD020071
     C*                                                                                     MD020071
     C                   ENDSR                                                              MD020071
     C****************************************************************                      MD020071
      /EJECT
**  CPY@
(c) Finastra International Limited 2001
** TABTYP/TABSEQ Amendment types/processing sequence
CI1SI1PI2PD3SC4BR5CO9

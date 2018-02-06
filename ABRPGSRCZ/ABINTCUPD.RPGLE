     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal contract database update')
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABINTCUPD - INTERNAL CONTRACT DATABASE UPDATE                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 13Jan06               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 08Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Recompiled due to PF changes.                       *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP004 - API's Phase 3.                                      *
      *                                                               *
      *****************************************************************
 
     FABCOMPLL  IF A E           K DISK
     F                                     COMMIT
     F/COPY WNCPYSRC,ABINTCDF01
 
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
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR DEAL
     D ABVINTC       E DS                  EXTNAME(ABVINTCPD)
     D  @JUCTL                 1     23
 
      **  DEALS FILE - FX DEALS
     D ABDEAL        E DS                  EXTNAME(ABDEALPP)
     D  @JPCTL                 1     23
     D  ABDEAL1                1    219
     D  ABDEAL2              220    306
     D  ABDEAL3              307    319
 
     D ABSTDL        E DS                  EXTNAME(ABSTDDPP)
     D                                     PREFIX(S_)
      * Standard Deals format data structure
     D  ABSTDL1                1    219
     D  ABSTDL3              250    262
     D  ABSTDL2              263    349
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * DATA STRUCTURE FOR MODULE DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** APHEADPD Data Structure                                                              CSC011
     D HeadIn        E DS                  EXTNAME(APHEADPD)                                  CSC011
                                                                                              CSC011
      ** External DS Fof SAR Details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
      *                                                                                       CSC011
      ** DEFINE FIELDS FOR ZDATE9
     D @DAYN           S              5P 0
     D                 DS
     D @YMD                    1      8  0
     D @YYYY                   1      4  0
     D @MM                     5      6  0
     D @DD                     7      8  0
     D @RETN           S              1A
 
      * RUN DATE & MULTI-BRANCHING INDICATOR
     D RUNDAT          DS
     D  @DLUP                  1      2  0
     D  @MLUP                  3      5
     D  @YLUP                  6      7  0
     D  @MBIN                 13     13
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      *                                                                                       CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      *                                                                                       CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PTimeStamp      S             26A                                                      CSC011
     D***PDealNo         S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PSARD           S              6A                                                      CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PAction         S              1A                                                      CSC011
     D WDealNo         S              6A                                                      CSC011
                                                                                              CSC011
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
      *
      * SET CONTROL FIELDS
      *
     C                   EXSR      SETCTL
      *
      * DO INSERT OR DELETE PROCESSING
      *
     C     JULACT        CASEQ     'I'           INSERT
     C     JULACT        CASEQ     'D'           DELETE
     C                   END
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed, write to the standard                       CSC011
      ** log file when support system is active                                               CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
                                                                                              CSC011
     C                   CALLB     'ABINTCLOG'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM      JULACT        PAction                                      CSC011
     C                   PARM                    ABDEAL                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** Write to support database log file                                                   CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *BLANKS                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'ABINTC'                                       CSC011
     C                   EVAL      APUSERID = PSUser                                          CSC011
     C                   EVAL      APRPRLOCN = JUREPA                                         CSC011
     C                   MOVEL     JUFRNT        APFOTRANID                                   CSC011
     C                   MOVEL     JUAFRT        APFOASOCID                                   CSC011
     C                   MOVEL     JUFD38        PDealNo                                      CSC011
     C                   MOVEL     JUSD38        PADealNo                                     CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PtimeStamp                                   CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM                    PADealNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If error occured,                                                                    CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
                                                                                              CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
      * EXIT FROM PROGRAM
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* INSERT - Internal Contract Inserts                            *
     C*                                                               *
     C*****************************************************************
     C     INSERT        BEGSR
     C*
     C**  UPDATE DEAL
     C*
     C                   MOVEL     ABVINTC       ABDEAL
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   MOVE      JPFD38        WDealNo                                      CSC011
     C                   IF        JPFRNT = *BLANKS                                           CSC011
     C                   EVAL      JPFRNT = 'MD' + WDealNo                                    CSC011
     C                   ENDIF                                                                CSC011
     C                   IF        JPAFRT = *BLANKS                                           CSC011
     C                   EVAL      JPAFRT = 'MD' + WDealNo                                    CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C*
     C*  WRITE NEW DEAL
     C*
     C                   WRITE     ABDEALP0
     C/COPY WNCPYSRC,ABINTCDC01
      *
      * COMPLETE THE DEAL DETAILS FOR INSERTION
      * =======================================
      *
      ** Deal transaction date - yyyy
      ** Deal transaction date - mm
      ** Deal transaction date - dd
      *
     C                   Z-ADD     JPDDYY        JPDTYY
     C                   Z-ADD     JPDDMM        JPDTMM
     C                   Z-ADD     JPDDDD        JPDTDD
      *
      ** Deal status indicator
      *
     C                   MOVE      'A'           JPDSTS
      *
      ** Deal user code
      *
     C                   MOVEL     PSUser        JPDUSC
      *
      ** Deal Last Action Date - YYYY
      ** Deal Last Action Date - MM
      ** Deal Last Action Date - DD
      *
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YYYY         JPLAYY
     C                   Z-ADD     @MM           JPLAMM
     C                   Z-ADD     @DD           JPLADD
      *
      ** Deal Entered Time
      *
     C                   TIME                    JPDDTM
      *
      ** Deal last action date
      *
     C                   Z-ADD     BJRDNB        JPDLAD
      *
      ** Midas action code
      *
     C                   MOVE      'I'           JPMACT
      *
      ** Update Database
      *
     C                   EXSR      UPDDATA
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* DELETE - Internal Contract Deletes                            *
     C*                                                               *
     C*****************************************************************
     C     DELETE        BEGSR
     C*
     C**  ACCESS DEAL
     C*
     C     JUFD38        CHAIN     ABDEALP0                           99
     C*
     C**  DATA BASE ERROR IF NOT FOUND
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     JUFD38        DBKEY
     C                   MOVEL     'ABDEALP0'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      * COMPLETE THE DEAL DETAILS FOR DELETION
      * ======================================
      *
      ** Deal deleted indicator
      *
     C                   MOVE      'D'           JPDDLT
      *
      ** Deal user code
      *
     C                   MOVEL     PSUser        JPDUSC
      *
      ** Deal Last Action Date - YYYY
      ** Deal Last Action Date - MM
      ** Deal Last Action Date - DD
      *
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YYYY         JPLAYY
     C                   Z-ADD     @MM           JPLAMM
     C                   Z-ADD     @DD           JPLADD
      *
      ** Deal last action date
      *
     C                   Z-ADD     BJRDNB        JPDLAD
      *
      ** Midas action code
      *
     C                   MOVE      'R'           JPMACT
      *
      ** Update Database
      *
     C                   EXSR      UPDDATA
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* UPDDATA  - Update Database                                    *
     C*                                                               *
     C*****************************************************************
     C     UPDDATA       BEGSR
      *
      * Move AB deal format to Standard deal format
      *
     C                   MOVE      ABDEAL1       ABSTDL1
     C                   MOVE      ABDEAL2       ABSTDL2
     C                   MOVE      ABDEAL3       ABSTDL3
     C                   MOVE      JUCLAS        S_JUCLAS                                     CDL038
      *
      * Update AB Databases
      *
     C                   CALL      'AB0200'                             90
     C                   PARM                    @TERM             1
     C                   PARM                    ABSTDL
     C     *IN90         IFEQ      '1'
     C     @TERM         ORNE      *BLANK
     C                   MOVEL     JUFD38        DBKEY
     C                   MOVEL     'AB0200  '    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      * Update Midas Databases
      *
     C                   CALL      'AB0230'                             90
     C                   PARM                    @TERM             1
     C                   PARM                    ABSTDL
     C     *IN90         IFEQ      '1'
     C     @TERM         ORNE      *BLANK
     C                   MOVEL     JUFD38        DBKEY
     C                   MOVEL     'AB0230  '    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** If Treasury Management is present
      *
     C     BGTRMG        IFEQ      'Y'
      *
      * Update FX Forward Book
      *
     C                   CALL      'AB0250'                             90
     C                   PARM                    @TERM
     C                   PARM                    ABSTDL
     C     *IN90         IFEQ      '1'
     C     @TERM         ORNE      *BLANK
     C                   MOVEL     JUFD38        DBKEY
     C                   MOVEL     'AB0250  '    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      * Update FX Positions & Profits file
      *
     C                   CALL      'AB0260'                             90
     C                   PARM                    @TERM
     C                   PARM                    ABSTDL
     C     *IN90         IFEQ      '1'
     C     @TERM         ORNE      *BLANK
     C                   MOVEL     JUFD38        DBKEY
     C                   MOVEL     'AB0260  '    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      * Update MM Forward Book
      *
     C                   CALL      'AB0270'                             90
     C                   PARM                    @TERM
     C                   PARM                    ABSTDL
     C     *IN90         IFEQ      '1'
     C     @TERM         ORNE      *BLANK
     C                   MOVEL     JUFD38        DBKEY
     C                   MOVEL     'AB0270  '    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      * Update MM Positions & profits file
      *
     C                   CALL      'AB0280'                             90
     C                   PARM                    @TERM
     C                   PARM                    ABSTDL
     C     *IN90         IFEQ      '1'
     C     @TERM         ORNE      *BLANK
     C                   MOVEL     JUFD38        DBKEY
     C                   MOVEL     'AB0280  '    DBFILE
     C                   MOVEL     '007'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      * Update Liquidity Exposure
      *
     C                   CALL      'AB0290'                             90
     C                   PARM                    @TERM
     C                   PARM                    ABSTDL
     C     *IN90         IFEQ      '1'
     C     @TERM         ORNE      *BLANK
     C                   MOVEL     JUFD38        DBKEY
     C                   MOVEL     'AB0290  '    DBFILE
     C                   MOVEL     '008'         DBASE
     C                   EXSR      SRERR
     C                   END
 
     C                   END
 
     C                   ENDSR
     C*****************************************************************
     C*                                                               *
     C* SETCTL - SET CONTROL FIELDS                                   *
     C*                                                               *
     C*****************************************************************
     C     SETCTL        BEGSR
      **
      ** Record identifier
      **
     C                   MOVEL     'JP'          JURCID
      **
      ** Logical delete flag
      **
     C                   MOVEL     *BLANK        JUDLTF
      **
      ** Day of last update
      **
     C                   Z-ADD     @DLUP         JUDLUP
      **
      ** Month of last update
      **
     C                   MOVEL     @MLUP         JUMLUP
      **
      ** Year of last update
      **
     C                   Z-ADD     @YLUP         JUYLUP
      **
      ** Time of last update
      **
     C                   TIME                    JUTLUP
      **
      ** Type of last change (set later in this program)
      **
     C                   MOVEL     JUCHTP        JUCHTP
      **
      ** Last change date
      **
     C                   Z-ADD     BJRDNB        JULCD
      **
      ** Last update user id
      **
     C                   MOVEL     PSUser        JULUID
      **
     C                   ENDSR
     C*****************************************************************
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
      ** PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    ABVINTC
     C*
     C** ACCESS BANK DETAILS
     C*
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C* DATABASE ERROR
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*
     C** ACCESS MIDAS MODULE DETAILS
     C*
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C*
     C* DATABASE ERROR
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      SRERR
     C                   END
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 902                                                CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C/COPY WNCPYSRC,ABINTCDC02
     C*
     C**  READ DTAARA/RUNDAT to access MULTI-BRANCHING flag.
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************
     C*                                                   *
     C* SRERR - EXCEPTION ERRORS                          *
     C*                                                   *
     C*****************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'ABINTCUPD'   DBPGM            10
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
     C*****************************************************
     C/EJECT
      *********************************************************************
      ** FIELD LOG
      *********************************************************************
      **                                      SET IN     SET IN
      **                                    VALIDATION    THIS    AMENDABLE
      **                                     FUNCTION   FUNCTION
      *********************************************************************
      ** Record identifier            JURCID              YES       YES
      ** Logical delete flag          JUDLTF              YES       YES
      ** Day of last update           JUDLUP              YES       YES
      ** Month of last update         JUMLUP              YES       YES
      ** Year of last update          JUYLUP              YES       YES
      ** Time of last update          JUTLUP              YES       YES
      ** Type of last change          JUCHTP              YES       YES
      ** Last change date             JULCD               YES       YES
      ** Last update user id          JULUID              YES       YES
      ** Deal number pc               JUPCDN-------------------------------
      ** S/38 First Deal Number       JUFD38   YES
      ** S/38 Second Deal Number      JUSD38   YES
      ** Deal transaction date - yyyy JUDTYY
      ** Deal transaction date - mm   JUDTMM
      ** Deal transaction date - dd   JUDTDD
      ** Deal pc transation number    JUPCTN-------------------------------
      ** Deal status indicator        JUDSTS
      ** Deal deleted indicator       JUDDLT
      ** Deal user code               JUDUSC
      ** Deal last action             JULACT   YES
      ** Deal Last Action Date - YYYY JULAYY
      ** Deal Last Action Date - MM   JULAMM
      ** Deal Last Action Date - DD   JULADD
      ** Deal Entered Time            JUDDTM
      ** Deal First Currency          JUDFCY   YES
      ** Deal First Ccy Decimal Place JUCDPF   YES
      ** Deal mult/div first amnt ind JUDMD1   YES
      ** Deal First Ccy Near Date Amo JUNDA1   YES
      ** Deal Near Date Exchange Rate JUNDXR   YES
      ** Deal Second Currency         JUDSCY   YES
      ** Deal Second Ccy Decimal Plac JUCDPS   YES
      ** Deal Second Ccy Near Date Am JUNDA2   YES
      ** Deal branch code             JUDBRC   YES
      ** Branch code (alpha)          JUMBCA   YES
      ** Deal done date - yyyy        JUDDYY   YES
      ** Deal done date - mm          JUDDMM   YES
      ** Deal done date - dd          JUDDDD   YES
      ** Deal First Ccy Interest Calc JUICM1   YES
      ** Deal First Ccy Interest Rate JUIRT1   YES
      ** Deal First Ccy Interest Amou JUINA1   YES
      ** Deal Second Ccy Interest Cal JUICM2   YES
      ** Deal Second Ccy Interest Rat JUIRT2   YES
      ** Deal Second Ccy Interest Amo JUINA2   YES
      ** Deal forward points          JUFWPP   YES
      ** Deal Near Date Base Ccy for  JUNBCA   YES
      ** Deal Far Date Base Ccy for A JUFBCA   YES
      ** Deal Near Date - YYYY        JUNDYY   YES
      ** Deal Near Date - MM          JUNDMM   YES
      ** Deal Near Date - DD          JUNDDD   YES
      ** Deal Far Date - YYYY         JUFDYY   YES
      ** Deal Far Date - MM           JUFDMM   YES
      ** Deal Far Date - DD           JUFDDD   YES
      ** Deal First Ccy Far Date Amou JUFDA1   YES
      ** Deal Second Ccy Far Date Amo JUFDA2   YES
      ** Deal Far Date Exchange Rate  JUFDXR   YES
      ** MIDAS deal type              JUMDTY   YES
      ** Deal sub type                JUSTYP   YES
      ** Deal customer number         JUDCNO   YES
      ** Deal Near Date Dealt Base Cc JUNBCD   YES
      ** Deal Far Date Dealt Base Ccy JUFBCD   YES
      ** Deal Near Date Spot Base Ccy JUNSBC   YES
      ** Deal Far Date Spot Base Ccy  JUFSBC   YES
      ** Deal Near Date Buy Amount    JUNDBA   YES
      ** Deal Near Date Sell Amount   JUNDSA   YES
      ** Deal Far Date Buy Amount     JUFDBA   YES
      ** Deal Far Date Sell Amount    JUFDSA   YES
      ** LINKED DEAL NUMBER           JULNKN   YES
      ** Originating branch           JUORBR   YES
      ** Foreign Exchange book code   JUFXBC   YES
      ** Money Market book code       JUMMBC   YES
      ** FX Profit Centre             JUPRFC   YES
      ** Loan round-down int          JULRDF   YES
      ** Deposit round-down int       JUDRDF   YES
      ** MM Profit Centre             JUMMPC   YES
      ** Deal date                    JUDDAT   YES
      ** Deal Near Date (MIDAS Day Nu JUNDAT   YES
      ** Deal Far Date (MIDAS Day Num JUFDAT   YES
      ** Deal last action date        JUDLAD
      ** Midas action code            JUMACT
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2001

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio Defn Support Log Setup Module')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDMLOG - Portfolio Definition Support Log Setup Module    *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             Portfolio Definition file into screen format      *
      *             to be used in writing records to the log file.    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Externally described DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Externally described DS for Custody Fees
     D SDSCFE        E DS                  EXTNAME(SDSCFEPD)
 
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Valid Portfolio Definitions File Format
     D PFDMVFilFmt   E DS                  EXTNAME(PMVPFDMPD)
 
      ** Portfolio Definitions Screen Format
     D PFDMScnFmt    E DS                  EXTNAME(PMPFDMPD)
 
      ** Incoming Extra Data
     D PFDMExtDta    E DS                  EXTNAME(PMPFEXPD)
 
     D PCurInvestI     DS             4
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D TRANSDTL        S           5800A
     D PACTN           S              1A
     D PMCUST          S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D S01464          S              1A
     D CAC003          S              1A
     D PDDDOP          S              6A
     D PDDDELT         S             16A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRPROC
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRPROC - Detail Processing                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   EVAL      TRANSDTL = *Blanks
     C                   EVAL      DDACTN = PACTN
 
     C                   CALLB     'PMPFDM2CT'
     C                   PARM                    RetCodeOut
     C                   PARM                    PFDMVFilFmt
     C                   PARM                    PACTN
     C                   PARM                    PMCUST
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    BGN0ST
     C                   PARM                    FBFGCP
     C                   PARM                    BGFUOP
     C                   PARM                    S01464
     C                   PARM                    CAC003
     C                   PARM                    PFDMScnFmt
     C                   PARM                    PCurInvestI
     C                   PARM                    PDDDOP
     C                   PARM                    PDDDELT
 
     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*Error'
     C                   ELSE
 
     C                   EVAL      TRANSDTL = PFDMScnFmt + PFDMExtDta
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PFDMVFilFmt
     C                   PARM                    PACTN
     C                   PARM                    PMCUST
     C                   PARM                    TRANSDTL
 
      ** Access Bank details.
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Midas Modules details.
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSSDY
 
     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Safe Custody Details
 
     C                   CALL      'AOSCFER0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDSCFE        PARM      SDSCFE        DSSDY
 
     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDSCFEPD'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CAC003 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CAC003'      PSard
     C     SCSARD        PARM      SCSARD        DSSDY
 
     C                   IF        (PRtCd <> *Blanks) AND (PRtCd <> '*NRF')
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CAC003'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *Blanks
     C                   EVAL      CAC003 = 'Y'
     C                   ELSE
     C                   EVAL      CAC003 = 'N'
     C                   ENDIF
 
      ** Check if S01464 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01464'      PSard
     C     SCSARD        PARM      SCSARD        DSSDY
 
     C                   IF        (PRtCd <> *Blanks) AND (PRtCd <> '*NRF')
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'S01464'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *Blanks
     C                   EVAL      S01464 = 'Y'
     C                   ELSE
     C                   EVAL      S01464 = 'N'
     C                   ENDIF
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001

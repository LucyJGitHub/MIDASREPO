     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Build SE Prices Historic     - take on')   *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1480 - Build SE Prices Historic                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. AR970292           Date 14May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 14Dec00               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Ensure numeric fields set to 0 to avoid crash     *
      *             of synchronisation job GO_ONL_SYN ...             *
      *             (Child: AR970293)                                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSNDEVD    IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(SN)
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SE)
 
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
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D FormatDetail  E DS                  EXTNAME(PRICED)
 
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
     C**********         Z-ADD     *ZEROS        PCNM                           Customer N°   CSD027
     C                   EVAL      PCNM=*BLANKS                                 Customer N°   CSD027
     C                   MOVE      *BLANKS       PMKT                           Market
     C                   MOVE      *BLANKS       PBRA                           Branch
     C                   MOVE      *BLANKS       PBOK                           Book
     C                   MOVE      *BLANKS       PNTV                           Narrative
     C                   Z-ADD     *ZEROS        TNLU                           Trans.no last Change
     C                   MOVE      *BLANKS       PSRC                           EXTEL Price source
     C                   MOVE      *BLANKS       PBWN                           EXTEL Price Bound.
     C                   MOVE      *BLANKS       PTFR                           Portfolio Reference
     C                   Z-ADD     *ZEROS        NPXR                           Exchange Rate
     C                   MOVE      *BLANKS       NPMD                           Nominal OPortf. M/D
                                                                                            AR970292
     C                   Z-ADD     *ZEROS        PRDFTS                                     AR970292
     C                   Z-ADD     *ZEROS        PRBDPR                                     AR970292
     C                   Z-ADD     *ZEROS        PROFPR                                     AR970292
     C                   Z-ADD     *ZEROS        PRCLPR                                     AR970292
     C                   Z-ADD     *ZEROS        PRCRSK                                     AR970292
     C                   Z-ADD     *ZEROS        PRLQPR                                     AR970292
     C                   Z-ADD     *ZEROS        PEXI                                       AR970292
 
     C                   MOVE      'D'           RECI                           Record Id
     C                   MOVE      'V '          PPRT                           Price Type
     C                   Z-ADD     BJRDNB        LCD                            Last change date
     C                   MOVE      'I'           CHTP                           Type of last change
     C                   MOVE      'N'           PPWN                           EXTEL Price % Allow
      *
      * Issue rollback to clear any possible updates in window functions
      *
     C     1             SETLL     SNDEVD
     C                   READ      SNDEVD                                 80
 
     C     *IN80         DOWEQ     '0'
 
     C     PALLSE        IFEQ      'Y'
     C     PALLSE        ORNE      'Y'
     C     PONESE        ANDEQ     SNSNSN
 
      *
     C     SNSNDT        IFGE      FROMDATE
     C     SNSNDT        ANDLE     TODATE
     C     SNSNET        ANDEQ     'PR'
     C     SNRECI        ANDEQ     'D'
     C     SNSNSN        CHAIN     SECTY                              89
      *
     C     *IN89         IFEQ      '0'
     C     SERECI        ANDEQ     'D'
     C                   MOVE      SNSNSN        PSSN                           Security Shortname
     C                   Z-ADD     SNSNDT        PVDT                           Value Date
     C                   Z-ADD     SNSNPR        PPRC                           Price
      *
     C                   MOVEL     *BLANKS       WENTRY
     C                   MOVEL     *BLANKS       WFILE
     C                   CALL      'RPC1482'
     C                   PARM      FormatDetail  WENTRY         3000
     C                   PARM      'PRICED'      WFILE            10
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      SNDEVD                                 80
     C                   ENDDO
      *
      ** Terminate program
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFDATE            5
     C                   PARM                    PTDATE            5
     C                   PARM                    PALLSE            1
     C                   PARM                    PONESE           10
      *
     C                   MOVE      PFDATE        FROMDATE          5 0
     C                   MOVE      PTDATE        TODATE            5 0
      *
      ** Initialize program name
      *
     C                   MOVEL     'RP1480'      DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
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

     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Build Base Rate Historic     - take on')   *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1481 - Build Base Rate Historic                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002   *CREATE   Date 14Dec00               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDBSHSPD  IF   E             DISK    INFSR(*PSSR)
 
     FPBTOBSL0  IF   E           K DISK    INFSR(*PSSR)
 
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
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D FormatDetail  E DS                  EXTNAME(SDBSRTPD)
 
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
 
     C                   Z-ADD     *ZEROS        BACBSR                         Current Base Rate
     C                   Z-ADD     *ZEROS        BAVDRC                         Value Date of Rate C
     C                   Z-ADD     BJRDNB        BALCD                          Last Change Date
     C                   MOVE      'I'           BATYLC                         Type of Last Change
     C                   MOVE      'Y'           BADLLC                         Dealing Letters Chan
     C                   MOVE      *BLANKS       BASYLL                         CL Letters (REDUNDAN
     C                   MOVE      'Y'           BACSLL                         Customer Lending Let
     C                   MOVE      *BLANKS       BABSCD                         Midas Export Value B
     C                   MOVE      'Y'           BAACLT                         Account Letters
     C                   MOVE      'Y'           BAACRC                         Account Records
     C                   MOVE      'Y'           BADLRC                         Dealing Records Chan
     C                   MOVE      *BLANKS       BASYLR                         CL Records (REDUNDAN
     C                   MOVE      'Y'           BACSLR                         Customer Lending Rec
     C                   MOVE      *BLANKS       BASCDD                         ISDA Definition of B
     C                   MOVE      *BLANKS       BADGMA                         Designated Maturity
     C                   MOVE      *BLANKS       BAOMD1                         Other Maturity Desc.
     C                   MOVE      *BLANKS       BAOMD2                         Other Maturity Desc.
 
     C     1             SETLL     SDBSHSPD
     C                   READ      SDBSHSPD                               80
 
     C     *IN80         DOWEQ     '0'
 
     C     PALLCU        IFEQ      'Y'
     C     PALLCU        ORNE      'Y'
     C     PONECU        ANDEQ     G0CYCD
 
     C     G0HIDT        IFGE      FROMDATE
     C     G0HIDT        ANDLE     TODATE
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      G0CYCD        @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      G0BSRC        WWBSRC            2
     C     WWBSRC        CHAIN     PBTOBSL0                           89
 
     C     *IN89         IFEQ      '0'
     C                   MOVE      G0CYCD        BACYCD                         Currency Code
     C                   MOVE      G0BSRC        BABSRC                         Base Rate Code
     c                   MOVE      AOBANA        BABSRN                         Base Rate Name
     C                   Z-ADD     G0CBSR        BANBRT                         New Base Rate
     C                   Z-ADD     G0HIDT        BAVDNR                         Value Date for New R
     C                   MOVEL     BACYCD        BABSRS
     C                   MOVE      BABSRC        BABSRS                         Base Rate Shortname
 
     C                   MOVEL     *BLANKS       WENTRY
     C                   MOVEL     *BLANKS       WFILE
     C                   CALL      'RPC1482'
     C                   PARM      FormatDetail  WENTRY         3000
     C                   PARM      'SDBSRTPD'    WFILE            10
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      SDBSHSPD                               80
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
     C                   PARM                    PALLCU            1
     C                   PARM                    PONECU            3
      *
     C                   MOVE      PFDATE        FROMDATE          5 0
     C                   MOVE      PTDATE        TODATE            5 0
      *
      ** Initialize program name
      *
     C                   MOVEL     'RP1481'      DBPGM
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

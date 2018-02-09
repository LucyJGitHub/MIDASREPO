     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM Interest Rates Convert Module')
      *****************************************************************
      *                                                               *
      *  Midas - FD ILE Module                                        *
      *                                                               *
      *  FDINTRCVT - Interest Rate Details Conversion:                *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of an Interest    *
      *             Rate Details from file to screen format           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CAP058  *CREATE    Date 13Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP058 - Full API for Money Market Interest Rates            *
      *                                                               *
      *****************************************************************
 
      ** MDF Request Details by Request Id
     FSDMDFRL1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *      FUNCTION OF INDICATORS                                   *
      *                                                               *
      *       81  CHAIN indicator                                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      SUBROUTINE DESCRIPTION                                   *
      *                                                               *
      *      *INZSR        - Program Initilisation                    *
      *      SrSAVARR      - Saves Interest Details in an array       *
      *      SrSCREEN      - Set Screen Fields                        *
      *      SrFMTDET      - Format Interest Rate Details             *
      *      SrMOVDET      - Move Data from File to Screen DS         *
      *      SrFMTTMESTMP  - Format Timestamp for Display             *
      *      SrINIT        - Initialisation                           *
      *      *PSSR         - Standard Error Subroutine                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      PROCEDURES AND PROGRAMS CALLED                           *
      *                                                               *
      *      AOBANKR0      - Access Object for Bank Details           *
      *      AOMAPCR0      - Access Object for Mapping Codes          *
      *      ZA0920        - Format Amount for Output                 *
      *                                                               *
      *****************************************************************
 
 
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
 
     D @BORROW         S             11  7 DIM(21)
     D @LEND           S             11  7 DIM(21)
     D @EXTRA          S              4A   DIM(21)
 
     D IRVDets       E DS                  EXTNAME(FDVINTRPD)
      ** Interest Rate Details in File Format
 
     D IRDets        E DS                  EXTNAME(FDINTRPD)
      ** Interest Rate Details in Screen Format
 
     D ValWrkFlds    E DS                  EXTNAME(FDWINTRPD)
      ** Interest Rates Validation Workfields
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDMAPC        E DS                  EXTNAME(SDMAPCPD)
      ** External DS for Market Data Feed Mapping Codes
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D TimeStmpDS      DS
      ** Timestamp data structure (Century, Year, Month, Day, Hour, Minute and Second)
     D WCENT                   1      2
     D WYEAR                   3      4
     D WMONTH                  5      6
     D WDAY                    7      8
     D WHOUR                   9     10
     D WMINUT                 11     12
     D WSECON                 13     14
     D WTIME                   9     14
 
     D TStmpDspDS      DS
      ** Timestamp data structure for Display
     D WCNTD                   1      2
     D WDATE                   3      8
     D  WDAT1                         2    OVERLAY (WDATE:1)
     D  WDAT2                         2    OVERLAY (WDATE:3)
     D  WYRD                          2    OVERLAY (WDATE:5)
     D WTMED                   9     14
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Counter/Index
     D @X              S              3  0
     D @Y              S              3  0
     D @Z              S              3  0
 
      ** Workfields used by ZA0920 in formatting rates
     D WRTCD           S             10
     D WAMTNUM         S             13  0
     D WNODEC          S              1  0
     D WSEPA           S              1
     D WBORROW         S             14
     D WLEND           S             14
     D WEXTRA          S              4
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialization
 
     C                   EXSR      SrINIT
 
      ** Save file fields to an array (Borrow, Lending and Extra Data)
 
     C                   EXSR      SrSAVARR
 
      ** Set screen fields
 
     C                   EXSR      SrSCREEN
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSAVARR  - Saves Interest Details in an array                *
      *                                                               *
      *****************************************************************
     C     SrSAVARR      BEGSR
 
     C                   EVAL      @BORROW(1) = FYBR01
     C                   EVAL      @BORROW(2) = FYBR02
     C                   EVAL      @BORROW(3) = FYBR03
     C                   EVAL      @BORROW(4) = FYBR04
     C                   EVAL      @BORROW(5) = FYBR05
     C                   EVAL      @BORROW(6) = FYBR06
     C                   EVAL      @BORROW(7) = FYBR07
     C                   EVAL      @BORROW(8) = FYBR08
     C                   EVAL      @BORROW(9) = FYBR09
     C                   EVAL      @BORROW(10) = FYBR10
     C                   EVAL      @BORROW(11) = FYBR11
     C                   EVAL      @BORROW(12) = FYBR12
     C                   EVAL      @BORROW(13) = FYBR13
     C                   EVAL      @BORROW(14) = FYBR14
     C                   EVAL      @BORROW(15) = FYBR15
     C                   EVAL      @BORROW(16) = FYBR16
     C                   EVAL      @BORROW(17) = FYBR17
     C                   EVAL      @BORROW(18) = FYBR18
     C                   EVAL      @BORROW(19) = FYBR19
     C                   EVAL      @BORROW(20) = FYBR20
     C                   EVAL      @BORROW(21) = FYBR21
 
     C                   EVAL      @LEND(1) = FYLR01
     C                   EVAL      @LEND(2) = FYLR02
     C                   EVAL      @LEND(3) = FYLR03
     C                   EVAL      @LEND(4) = FYLR04
     C                   EVAL      @LEND(5) = FYLR05
     C                   EVAL      @LEND(6) = FYLR06
     C                   EVAL      @LEND(7) = FYLR07
     C                   EVAL      @LEND(8) = FYLR08
     C                   EVAL      @LEND(9) = FYLR09
     C                   EVAL      @LEND(10) = FYLR10
     C                   EVAL      @LEND(11) = FYLR11
     C                   EVAL      @LEND(12) = FYLR12
     C                   EVAL      @LEND(13) = FYLR13
     C                   EVAL      @LEND(14) = FYLR14
     C                   EVAL      @LEND(15) = FYLR15
     C                   EVAL      @LEND(16) = FYLR16
     C                   EVAL      @LEND(17) = FYLR17
     C                   EVAL      @LEND(18) = FYLR18
     C                   EVAL      @LEND(19) = FYLR19
     C                   EVAL      @LEND(20) = FYLR20
     C                   EVAL      @LEND(21) = FYLR21
 
     C                   EVAL      @EXTRA(1) = FYEX01
     C                   EVAL      @EXTRA(2) = FYEX02
     C                   EVAL      @EXTRA(3) = FYEX03
     C                   EVAL      @EXTRA(4) = FYEX04
     C                   EVAL      @EXTRA(5) = FYEX05
     C                   EVAL      @EXTRA(6) = FYEX06
     C                   EVAL      @EXTRA(7) = FYEX07
     C                   EVAL      @EXTRA(8) = FYEX08
     C                   EVAL      @EXTRA(9) = FYEX09
     C                   EVAL      @EXTRA(10) = FYEX10
     C                   EVAL      @EXTRA(11) = FYEX11
     C                   EVAL      @EXTRA(12) = FYEX12
     C                   EVAL      @EXTRA(13) = FYEX13
     C                   EVAL      @EXTRA(14) = FYEX14
     C                   EVAL      @EXTRA(15) = FYEX15
     C                   EVAL      @EXTRA(16) = FYEX16
     C                   EVAL      @EXTRA(17) = FYEX17
     C                   EVAL      @EXTRA(18) = FYEX18
     C                   EVAL      @EXTRA(19) = FYEX19
     C                   EVAL      @EXTRA(20) = FYEX20
     C                   EVAL      @EXTRA(21) = FYEX21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSCREEN - Set Screen Fields                                 *
      *                                                               *
      *****************************************************************
     C     SrSCREEN      BEGSR
 
      ** Initialise index
 
     C                   EVAL      @X = *ZERO
     C                   EVAL      WAPIT = *BLANK
 
      ** Data Request Id
 
     C                   EVAL      DDDTFR = FYDTFR
 
      ** If Data Request Id is blank, blank out timestamp
 
     C                   IF        DDDTFR = *BLANK
     C                   EVAL      DDDFTS = *BLANK
     C                   ELSE
 
      ** Check if Data Request Id exists from the Request details
 
 
     C     DDDTFR        CHAIN     SDMDFRL1                           81
 
      ** Access Market Data Feed Mapping Code to get Request type
 
     C     *IN81         IFEQ      FALSE
     C                   CALL      'AOMAPCR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      MRMAPC        PMAPCD           32
     C     SDMAPC        PARM      SDMAPC        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMAPCPD'    DBFILE
     C                   Z-ADD     7             DBASE
     C                   MOVEL     MRMAPC        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Data Request Id is found, check if its a borrow or a lending request
      ** otherwise blank out timestamp
 
     C     @RTCD         IFEQ      *BLANK
     C                   SELECT
     C     MCAPIT        WHENEQ    'B'
     C                   MOVE      FYBOTS        TimeStmpDS
     C     MCAPIT        WHENEQ    'L'
     C                   MOVE      FYLETS        TimeStmpDS
     C                   OTHER
     C                   MOVE      *BLANK        DDDFTS
     C                   ENDSL
     C                   EVAL      WAPIT = MCAPIT
     C                   ENDIF
     C                   ELSE
 
      ** Data Request Id not found, blank out timestamp
 
     C                   EVAL      DDDFTS = *BLANK
     C                   ENDIF
 
      ** Format timestamp for display if its not blank
 
     C     TimeStmpDS    IFNE      *BLANK
     C                   EXSR      SrFMTTMESTMP
     C                   EVAL      DDDFTS = TStmpDspDS
     C                   ENDIF
     C                   ENDIF
 
      ** Format interest details (Borrow, Lending and Extra Data)
 
     C     @X            DOWLT     21
     C                   EVAL      @X = @X + 1
     C                   EXSR      SrFMTDET
     C                   EXSR      SrMOVDET
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFMTDET - Format Interest Rate Details                       *
      *                                                               *
      *****************************************************************
     C     SrFMTDET      BEGSR
 
      ** Format Borrow/Lending Rates
 
     C                   MOVE      @BORROW(@X)   WAMTNUM
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        WRTCD
     C                   PARM                    WAMTNUM
     C                   PARM      7             WNODEC
     C                   PARM      '.'           WSEPA
     C                   PARM      *BLANK        WBORROW
 
      ** Error calling module
 
     C                   IF        WRTCD <> *BLANK
     C                   MOVEL     'ZA0920  '    DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVEL     '*CALL   '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      @LEND(@X)     WAMTNUM
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        WRTCD
     C                   PARM                    WAMTNUM
     C                   PARM      7             WNODEC
     C                   PARM      '.'           WSEPA
     C                   PARM      *BLANK        WLEND
 
      ** Error calling module
 
     C                   IF        WRTCD <> *BLANK
     C                   MOVEL     'ZA0920  '    DBFILE
     C                   Z-ADD     5             DBASE
     C                   MOVEL     '*CALL   '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Extra Data
 
     C                   MOVEL     @EXTRA(@X)    WEXTRA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMOVDET  - Move Data from File to Screen DS                  *
      *                                                               *
      *****************************************************************
     C     SrMOVDET      BEGSR
 
     C                   SELECT
 
     C     @X            WHENEQ    1
     C                   MOVE      WBORROW       DDBR01
     C                   MOVE      WLEND         DDLR01
     C                   MOVE      WEXTRA        DDEX01
 
     C     @X            WHENEQ    2
     C                   MOVE      WBORROW       DDBR02
     C                   MOVE      WLEND         DDLR02
     C                   MOVE      WEXTRA        DDEX02
 
     C     @X            WHENEQ    3
     C                   MOVE      WBORROW       DDBR03
     C                   MOVE      WLEND         DDLR03
     C                   MOVE      WEXTRA        DDEX03
 
     C     @X            WHENEQ    4
     C                   MOVE      WBORROW       DDBR04
     C                   MOVE      WLEND         DDLR04
     C                   MOVE      WEXTRA        DDEX04
 
     C     @X            WHENEQ    5
     C                   MOVE      WBORROW       DDBR05
     C                   MOVE      WLEND         DDLR05
     C                   MOVE      WEXTRA        DDEX05
 
     C     @X            WHENEQ    6
     C                   MOVE      WBORROW       DDBR06
     C                   MOVE      WLEND         DDLR06
     C                   MOVE      WEXTRA        DDEX06
 
     C     @X            WHENEQ    7
     C                   MOVE      WBORROW       DDBR07
     C                   MOVE      WLEND         DDLR07
     C                   MOVE      WEXTRA        DDEX07
 
     C     @X            WHENEQ    8
     C                   MOVE      WBORROW       DDBR08
     C                   MOVE      WLEND         DDLR08
     C                   MOVE      WEXTRA        DDEX08
 
     C     @X            WHENEQ    9
     C                   MOVE      WBORROW       DDBR09
     C                   MOVE      WLEND         DDLR09
     C                   MOVE      WEXTRA        DDEX09
 
     C     @X            WHENEQ    10
     C                   MOVE      WBORROW       DDBR10
     C                   MOVE      WLEND         DDLR10
     C                   MOVE      WEXTRA        DDEX10
 
     C     @X            WHENEQ    11
     C                   MOVE      WBORROW       DDBR11
     C                   MOVE      WLEND         DDLR11
     C                   MOVE      WEXTRA        DDEX11
 
     C     @X            WHENEQ    12
     C                   MOVE      WBORROW       DDBR12
     C                   MOVE      WLEND         DDLR12
     C                   MOVE      WEXTRA        DDEX12
 
     C     @X            WHENEQ    13
     C                   MOVE      WBORROW       DDBR13
     C                   MOVE      WLEND         DDLR13
     C                   MOVE      WEXTRA        DDEX13
 
     C     @X            WHENEQ    14
     C                   MOVE      WBORROW       DDBR14
     C                   MOVE      WLEND         DDLR14
     C                   MOVE      WEXTRA        DDEX14
 
     C     @X            WHENEQ    15
     C                   MOVE      WBORROW       DDBR15
     C                   MOVE      WLEND         DDLR15
     C                   MOVE      WEXTRA        DDEX15
 
     C     @X            WHENEQ    16
     C                   MOVE      WBORROW       DDBR16
     C                   MOVE      WLEND         DDLR16
     C                   MOVE      WEXTRA        DDEX16
 
     C     @X            WHENEQ    17
     C                   MOVE      WBORROW       DDBR17
     C                   MOVE      WLEND         DDLR17
     C                   MOVE      WEXTRA        DDEX17
 
     C     @X            WHENEQ    18
     C                   MOVE      WBORROW       DDBR18
     C                   MOVE      WLEND         DDLR18
     C                   MOVE      WEXTRA        DDEX18
 
     C     @X            WHENEQ    19
     C                   MOVE      WBORROW       DDBR19
     C                   MOVE      WLEND         DDLR19
     C                   MOVE      WEXTRA        DDEX19
 
     C     @X            WHENEQ    20
     C                   MOVE      WBORROW       DDBR20
     C                   MOVE      WLEND         DDLR20
     C                   MOVE      WEXTRA        DDEX20
 
     C     @X            WHENEQ    21
     C                   MOVE      WBORROW       DDBR21
     C                   MOVE      WLEND         DDLR21
     C                   MOVE      WEXTRA        DDEX21
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFMTTMESTMP - Format Timestamp for Display                   *
      *                                                               *
      *****************************************************************
     C     SrFMTTMESTMP  BEGSR
 
      ** Format date according to midas date format indicator
 
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      WDAY          WDAT1
     C                   MOVE      WMONTH        WDAT2
     C                   ELSE
     C                   MOVE      WMONTH        WDAT1
     C                   MOVE      WDAY          WDAT2
     C                   ENDIF
 
     C                   EVAL      WCNTD = WCENT
     C                   EVAL      WYRD  = WYEAR
     C                   EVAL      WTMED = WTIME
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrINIT - Initialization                                       *
      *                                                               *
      *****************************************************************
     C     SrINIT        BEGSR
 
      ** Blank outputs excluding action code and currency
 
     C                   EVAL      %SUBST(IRDets:37) = *BLANKS
 
      ** Initialise timestamp data structure
 
     C                   EVAL      TimeStmpDS = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Program Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    IRVDets
     C                   PARM                    IRDets
     C                   PARM                    ValWrkFlds
 
      ** Initialize program name
 
     C                   MOVEL     'FDINTRCVT'   DBPGM
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001

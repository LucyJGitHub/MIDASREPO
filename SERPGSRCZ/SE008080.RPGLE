     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Average Fiscal Price on Cposnd Init')         *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE008080 - SE Average Fiscal Price on Cposnd                 *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 233615 *CREATE     Date 16May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD027A - Conversion Of Customer Number to Alpha (Recompile) *
      *  233615 - Takeon programs for CGL031                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *  90 - End of file for TRADS                                   *
      *  91 - Record not found in SDSECSL1                            *
      *  92 - Record not found in SECTY                               *
      *  93 - Record not found in INVTP                               *
      *  94 - End of file for PRICM                                   *
      *  99 - Error in update for TRADS                               *
      *                                                               *
      *  LR - Last record indicator (program termination)             *
      *  U7 and U8 - DB error processing indicator                    *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
      *                                                               *
      *  Subroutine Index                                             *
      *                                                               *
      *  SRFilter   - Determines if the fiscal price should be input  *
      *  SRFndBnd   - Determines if the security is a bond or fund    *
      *  SRFunds    - Calculate the Fund fiscal price                 *
      *  SRBonds    - Calculate the Bond fiscal price                 *
      *  SRPercent  - Convert the yield into percentage               *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *  SRERR      - File error                                      *
      *                                                               *
      *****************************************************************
 
      ** Midas SE Securities
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SE Prices
     FPRICM     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(P_)
 
      ** Midas SE Customer Position
     FCPOSS     UF A E           K DISK
     F                                     IGNORE(DPOSNDF)
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
 
     ** +--------------------------------------+
     ** ¦ Arrays and Data Structures           ¦
     ** ¦ ==========================           ¦
     ** +--------------------------------------+
 
      ** Array for manipulating decimal positions
     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)
 
      ** External DS for bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for Location Details
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
 
      ** External DS for Securities Clients
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
 
      ** External DS for Currency Codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters
     D PRtcd           S              7A
     D POptn           S              7A
     D PCust           S             10A
 
      ** Working Variables
     D WrkCSSC         S             10A   INZ(*BLANKS)
     D WrkCSBA         S              3A   INZ(*BLANKS)
     D ZCDP            S              1  0
     D ZNOML           S             15  0
     D ZPRC            S             16  9
     D ZCONS           S             15  0
 
     D PCURR           S              3A
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
 
     C                   Z-ADD     *ZEROS        WrkCSPI
      ** Set file pointer to start of file
 
     C     *LOVAL        SETLL     CPOSS
     C                   READ      CPOSS
     C
     C                   DOW       Not%EOF(CPOSS)
 
     C     WrkCSBA       IFNE      CSBA
     C                   EXSR      SRBranch
     C                   ENDIF
 
     C     WrkCSSC       IFNE      CSSC
     C                   EXSR      SRSecty
     C                   ENDIF
 
     C     SETX          IFEQ      'Y'
 
      ** Read the Securities Prices
 
     C                   Z-ADD     EWEDT1        WPdat
     C                   MOVEL     SESN          WSesn
 
     C     KEYPT         SETLL     PRICM
     C     KEYPT         READE     PRICM                                  94
 
     C     *IN94         IFEQ      '0'
     C     P_PEXI        ANDNE     *ZEROS
 
     C                   Z-ADD     P_PEXI        AVFP
 
     C                   EVAL      ZNOML = CSNT
     C                   EVAL      ZPRC  = P_PEXI
     C                   EXSR      SRZCNSD
     C                   EVAL      CSAT = ZCONS
 
     C                   EVAL      ZNOML = CSNV
     C                   EVAL      ZPRC  = P_PEXI
     C                   EXSR      SRZCNSD
     C                   EVAL      CSAV = ZCONS
 
     C                   UPDATE    CPOSNDF                              12
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      CPOSS
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSecty - Access Security Details                             *
      *                                                               *
      *****************************************************************
     C     SRSecty       BEGSR
 
      ** Check for Security Shortname
 
     C     CSSC          CHAIN     SECTY
 
     C                   IF        NOT%FOUND(SECTY)
     C                   EVAL      DBKEY = CSSC
     C                   EVAL      DBFILE = 'SECTYD'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      CSSC          WrkCSSC
 
      ** Retrieve Number of Nominal Currency Decimal Places
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      NMCY          PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = PCURR
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      ZCDP = A6NBDP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBranch - Access Branch Details                              *
      *                                                               *
      *****************************************************************
     C     SRBranch      BEGSR
 
     C                   MOVEL     CSBA          @BRCH             3
     C                   CALLB     'AOBRCHR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @BRCH
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = CSBA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      CSBA          WrkCSBA
 
     C                   MOVEL     A8LCCD        @LCCD             3
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @LCCD
     C     SDLOCN        PARM      SDLOCN        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = A8LCCD
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DVCNCD        PCtrt             2
     C                   PARM      *BLANKS       PCtrr             2
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = DVCNCD
     C                   EVAL      DBFILE = 'SDCTTXPD'
     C                   EVAL      DBASE = 5
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRZCNSD - Subroutine to calculate for the consideration       *
      *****************************************************************
     C     SRZCNSD       BEGSR
 
     C                   CALLB     'ZCNSD'
     C                   PARM                    ZNOML
     C                   PARM                    ZPRC
     C                   PARM                    SPBS
     C                   PARM                    NMDP
     C                   PARM                    ZCDP
     C                   PARM                    ZCONS
 
     C                   ENDSR
      *****************************************************************
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
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Define key list for file
 
     C     KEYPT         KLIST
     C                   KFLD                    WSesn            10
     C                   KFLD                    WPdat             5 0
 
     C     *LIKE         DEFINE    CSPI          WrkCSPI
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRERR - EXCEPTION ERRORS                                     *
      *                                                              *
      ****************************************************************
     C     SRERR         BEGSR
 
     C                   MOVEL     '*ERROR '     PRtcd
     C                   MOVEL     'SE008080'    DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
 
      ** TERMINATE THE PROGRAM
 
     C                   EXSR      *PSSR
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      ****************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2005
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION                                          233774
00000001                                                                                      233774
00000010                                                                                      233774
00000100                                                                                      233774
00001000                                                                                      233774
00010000                                                                                      233774
00100000                                                                                      233774
01000000                                                                                      233774
10000000                                                                                      233774

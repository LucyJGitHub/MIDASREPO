     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB Module conditions maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Module                             *
      *                                                               *
      *  CB0420M - COB Module Conditions Maintenance.                 *
      *                                                               *
      *  Function:  This program allows the user to maintain the      *
      *             module conditions file.                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055891           Date 01Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CPB001             Date 02Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CCB008             Date 27OCT97               *
      *                 CTI001             Date 04SEP97               *
      *                 CAC001             Date 04SEP96               *
      *                 090416             Date 14JUL95               *
      *                 S01522             Date 19OCT94               *
      *                 S01486             Date 17AUG94               *
      *                 S01493             Date 20JUL94               *
      *                 S01459             Date 20JUL94               *
      *                 S01417             Date 24AUG93               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CPB001 - Amend validation processing for modules to allow    *
      *           'Private Banking' Module                            *
      *  CPL002 - Midas-Plato Interface.                              *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - Program removed from CB model.                    *
      *  CTI001 - Amend validation processing for modules to allow    *
      *           'TI' (Trade Innovation Interface).                  *
      *  CAC001 - Profit Centre Accounting Development:               *
      *           Introduction of new Analytical Accounting module.   *
      *  090416 - 1. Standardise the header/footer.                   *
      *           2. Remove 'components unique no.' from the          *
      *              screen and generate it in the background.        *
      *           3. Remove the validation from the display file      *
      *              for the module fields.                           *
      *           4. Addition of help.                                *
      *  S01522 - Amend validation processing for modules to allow    *
      *           'CF' (Confirmation Matching) and 'CG' (User Defined *
      *           Correspomdence) as module IDs.                      *
      *  S01486 - Amend validation processing for modules to allow    *
      *           'LB' (Portfolio Lending) and 'PM' (Portfolio        *
      *           Management) as module IDs.                          *
      *  S01493 - Amend validation processing for modules to allow    *
      *           'ED' to be recognised as the 'EUREKA Interface'     *
      *           module ID.                                          *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *  S01417 - Add 1A function input parameter to indicate         *
      *           successful update made to master file.              *
      *                                                               *
      *****************************************************************
     FCB0420M#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas CB Module conditions maintenance subfile
      *
     F*CBMDCNL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(INFDS1)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Module Conditions         Retrieval index
      *
     F*CBCMPNL2* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0001)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Midas CB Components with complex module conds
      *
     F*CBMDCNL0* UF A E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0002)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * UPD : Module Conditions         Update index
      *
     F*CBCMPNL0* UF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0003)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * UPD : Midas CB Components update
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D*@1DBRC**      E DS                  EXTNAME(CBMDCNL0)                                MD055891
     D @1DBRC        E DS                  EXTNAME(CBMDCJW0)                                MD055891
     D                                     PREFIX(@)                                        MD055891
      * UPD : Module Conditions         Update index
      * Current/previous master file format fields for change control
      *
     D*QCBCM1***     E DS                  EXTNAME(CBCMPNL0)                                MD055891
     D QCBCM1        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     D                                     PREFIX(X)                                        MD055891
      * UPD : Midas CB Components update
     D YARDCS          DS           262
     D YBRDCS          DS            47
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D ID0003          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * B :  Successful Update Made
     D  P1SUPD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Member Name
     D  ZA0001                 1     10
      * Message data for 'Module No 1 must be entrd'
      * Module 01
     D  ZA0002                 1      2
      * Message data for 'Module 01 is invalid'
      * Module 01
     D  ZA0003                 1      2
      * Message data for 'Module 01 status flag req'
      * Module be/not be present
     D  ZA0004                 1      1
      * Message data for 'Module 01 stat flag invld'
      * Module be/not be present
     D  ZA0005                 1      1
      * Message data for 'Module 02 is invalid'
      * Module 02
     D  ZA0006                 1      2
      * Message data for 'Module 02 stat flag invld'
      * Mod 02 be/not be present
     D  ZA0007                 1      1
      * Message data for 'Module 03 is invalid'
      * Module 03
     D  ZA0008                 1      2
      * Message data for 'Module 03 stat flag invld'
      * Mod 03 be/not be present
     D  ZA0009                 1      1
      * Message data for 'Module 04 is invalid'
      * Module 04
     D  ZA0010                 1      2
      * Message data for 'Module 04 stat flag invld'
      * Mod 04 be/not be present
     D  ZA0011                 1      1
      * Message data for 'Module 05 is invalid'
      * Module 05
     D  ZA0012                 1      2
      * Message data for 'Module 05 stat flag invld'
      * Mod 05 be/not be present
     D  ZA0013                 1      1
      * Message data for 'Module 06 is invalid'
      * Module 06
     D  ZA0014                 1      2
      * Message data for 'Module 06 stat flag invld'
      * Mod 06 be/not be present
     D  ZA0015                 1      1
      * Message data for 'Module 07 is invalid'
      * Module 07
     D  ZA0016                 1      2
      * Message data for 'Module 07 stat flag invld'
      * Mod 07 be/not be present
     D  ZA0017                 1      1
      * Message data for 'Module 08 is invalid'
      * Module 08
     D  ZA0018                 1      2
      * Message data for 'Module 08 stat flag invld'
      * Mod 08 be/not be present
     D  ZA0019                 1      1
      * Message data for 'Module 09 is invalid'
      * Module 09
     D  ZA0020                 1      2
      * Message data for 'Module 09 stat flag invld'
      * Mod 09 be/not be present
     D  ZA0021                 1      1
      * Message data for 'Module 10 is invalid'
      * Module 10
     D  ZA0022                 1      2
      * Message data for 'Module 10 stat flag invld'
      * Mod 10 be/not be present
     D  ZA0023                 1      1
      * Message data for 'Mod ID n blank, rest also'
      * Module 01
     D  ZA0024                 1      2
      * Module 02
     D  ZA0025                 3      4
      * Module 03
     D  ZA0026                 5      6
      * Module 04
     D  ZA0027                 7      8
      * Module 05
     D  ZA0028                 9     10
      * Module 06
     D  ZA0029                11     12
      * Module 07
     D  ZA0030                13     14
      * Module 08
     D  ZA0031                15     16
      * Module 09
     D  ZA0032                17     18
      * Module 10
     D  ZA0033                19     20
      * Message data for 'No duplicate Mod ID'
      * Module 01
     D  ZA0034                 1      2
      * Module 02
     D  ZA0035                 3      4
      * Module 03
     D  ZA0036                 5      6
      * Module 04
     D  ZA0037                 7      8
      * Module 05
     D  ZA0038                 9     10
      * Module 06
     D  ZA0039                11     12
      * Module 07
     D  ZA0040                13     14
      * Module 08
     D  ZA0041                15     16
      * Module 09
     D  ZA0042                17     18
      * Module 10
     D  ZA0043                19     20
      * Message data for 'IF Mod ID then also flag'
      * Module be/not be present
     D  ZA0044                 1      1
      * Message data for 'IF Mod ID then also flag'
      * Module be/not be present
     D  ZA0045                 1      1
      * Message data for 'IF Mod ID then also flag'
      * Module be/not be present
     D  ZA0046                 1      1
      * Message data for 'IF Mod ID then also flag'
      * Module be/not be present
     D  ZA0047                 1      1
      * Message data for 'IF Mod ID then also flag'
      * Module be/not be present
     D  ZA0048                 1      1
      * Message data for 'IF Mod ID then also flag'
      * Module be/not be present
     D  ZA0049                 1      1
      * Message data for 'IF Mod ID then also flag'
      * Module be/not be present
     D  ZA0050                 1      1
      * Message data for 'IF Mod ID then also flag'
      * Module be/not be present
     D  ZA0051                 1      1
      * Message data for 'IF Mod ID then also flag'
      * Module be/not be present
     D  ZA0052                 1      1
      * Message data for 'If Flag then also Mod ID'
      * Module 01
     D  ZA0053                 1      2
      * Message data for 'If Flag then also Mod ID'
      * Module 01
     D  ZA0054                 1      2
      * Message data for 'If Flag then also Mod ID'
      * Module 01
     D  ZA0055                 1      2
      * Message data for 'If Flag then also Mod ID'
      * Module 01
     D  ZA0056                 1      2
      * Message data for 'If Flag then also Mod ID'
      * Module 01
     D  ZA0057                 1      2
      * Message data for 'If Flag then also Mod ID'
      * Module 01
     D  ZA0058                 1      2
      * Message data for 'If Flag then also Mod ID'
      * Module 01
     D  ZA0059                 1      2
      * Message data for 'If Flag then also Mod ID'
      * Module 01
     D  ZA0060                 1      2
      * Message data for 'If Flag then also Mod ID'
      * Module 01
     D  ZA0061                 1      2
     D CBMDCN        E DS                  EXTNAME(CBMDCJW0)                                MD055891
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1SUPD        PARM      P1SUPD        WP0001            1            Successful Upda
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      * Initialise and load subfile page
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested
     C     W0RSF         DOWEQ     'N'
      * Display screen
     C                   EXSR      CAEXFM
      * Process response
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * HOME: Request subfile reload
     C   05              CAS                     FBRQRL
      * Display next SFL page
     C   27              CAS                     BBLDSF
      * Process screen input
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END
     C                   END
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise & load subfile page
      *================================================================
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialize subfile header
      * Start of 090416
      * Footer for edit file - Module Conditions  *
     C*  Sets up the function key footer text for edit files.
     C*
     C                   MOVEL     'CBUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If program mode is ADD:
     C*
     C     W0PMD         IFEQ      'ADD'
     C*
     C* Setup footer text:
     C* F3=Main Menu   F5=Refresh   F9=Go to 'Change' Mode
     C                   MOVEL     'CBM0197'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   ELSE
     C*
     C* Setup footer text:
     C* D=Delete   F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode
     C                   MOVEL     'CBM0198'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
      * End of 090416
      *................................................................
      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    #2COTT        WZCOTT
     C                   MOVEL     #2COTT        WZCOTT                         Component Name
     C     *LIKE         DEFINE    #2CSEQ        WZCSEQ
     C                   MOVEL     #2CSEQ        WZCSEQ                         Component Seque
     C     KPOS          KLIST
     C                   KFLD                    DJCOTT                         Component Name
     C                   KFLD                    DJCSEQ                         Component Seque
     C                   KFLD                    DJMCUN                         Module Conds Un
      * Setup key
     C                   MOVEL     #2COTT        DJCOTT                         Component Name
     C                   MOVEL     #2CSEQ        DJCSEQ                         Component Seque
     C                   MOVEL     #2MCUN        DJMCUN                         Module Conds Un
      * 82=EOF
     C*****KPOS*         SETLL     @DJREGN                            82        *           MD055891
      * 82=EOF
     C**N82*****         READ      @DJREGN                              9182    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ACursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBMDCJW0                                                              MD055891
     C+ where DJCOTT >= :DJCOTT and DJCSEQ >= :DJCSEQ and DJMCUN >= :DJMCUN                 MD055891
     C+ order by DJCOTT, DJCSEQ, DJMCUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close ACursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open ACursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMDCN                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   SETOFF                                       82                    MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        82                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C                   ELSE
     C                   SETOFF                                       82        *
     C                   END
      * Load subfile page
     C                   EXSR      BBLDSF
      * If no records (first time only), switch to add mode and load agai
     C     W0APM         IFEQ      'Y'
     C     ##RR          ANDEQ     *ZERO
     C                   MOVEL     'ADD'         W0PMD
     C                   SETOFF                                       82        *
     C                   EXSR      BBLDSF
     C                   END
     C                   MOVEL     'N'           W0APM             1
      *................................................................
      * If no records found, display error message
     C   82##RR          IFEQ      *ZERO                                        IF
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page (write empty page if add mode)
      *================================================================
     C                   SETOFF                                       84        No SFLNXTCHG
      * Re-establish fields in read-ahead record
     C   27W0PMD         IFNE      'ADD'
     C**N82*****         READP     @DJREGN                                90    *           MD055891
     C**N82*****         READ      @DJREGN                                90    *           MD055891
     C     *IN82         IFEQ      '0'                                                      MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch prior from ACursor into :CBMDCN                                               MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMDCN                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0           23
     C                   MOVE      *ALL'1'       WKIND1           23
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
     C                   Z-ADD     *ZERO         ##RROK            5 0
      * Set required pages based on *Set Cursor or *Subfile Pages
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   END
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
      * Compute lines required based on pages
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   END
      *................................................................
      * Load next subfile page
     C**N82##RROK        DOWLT     ##SFLN                                       DO          MD055891
     C                   DOW       SQLCODE = 0                                              MD055891
     C                             and ##RROK < ##SFLN                                      MD055891
     C                   ADD       1             ##RR
     C                   MOVEA     WKIND0        *IN(33)
     C                   SETOFF                                       87        *
      * Clear subfile fields
     C                   EXSR      MAIZ#1
      * If CHANGE mode, load subfile fields
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
      * Validate subfile record and calculate derived fields
     C                   EXSR      DFV2RC
     C                   END
      * Output to subfile
     C                   ADD       1             ##RROK               81        *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   WRITE     #SFLRCD
     C     W0PMD         IFNE      'ADD'
      * 82=EOF
     C**********         READ      @DJREGN                                82    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMDCN                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   END
     C  N82              END
      *................................................................
      * Save highest SFL record load can continue at end point
     C     ##RR          IFGT      ##RRMX
      * Calculate top line
     C     ##RROK        DIV       ##SFPG        ##SPG
     C                   MVR                     ##SLIN
     C     ##SLIN        IFGT      0
     C     ##RR          SUB       ##SLIN        ##SFRC
     C                   ELSE
     C     ##RR          SUB       ##SFPG        ##SFRC
     C                   END
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GBDSA2
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN89         IFNE      CAIN89
     C     *IN81         ORNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN89         CAIN89            1
     C                   MOVE      *IN81         CAIN81            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
      * Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input
      *================================================================
      *
     C     W0PMD         IFNE      'ADD'
      * Check Component Sequence Number is numeric
     C                   MOVEL     *IN90         XG90              1
     C                   TESTN                   #2CSEQ               90  90    *
     C   90              MOVE      #2CSEQ        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90    *
      * All blank is OK
     C  N90#2CSEQ        COMP      *BLANKS                                90    *
      * '?' is OK
     C  N90              MOVEL     #2CSEQ        XGX1
     C  N90XGX1          COMP      '?'                                    90    *
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   MOVEL     'Y2U0010'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
     C                   END
     C                   MOVEL     XG90          *IN90
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      *................................................................
      * Change of position specified
     C     WZCOTT        CASNE     #2COTT        FBRQRL                         Component Name
     C     WZCSEQ        CASNE     #2CSEQ        FBRQRL                         Component Seque
     C                   END
     C                   END
      * Quit if reload requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
      *
     C   81              DO
      * No data entered as yet
     C                   MOVEL     'N'           WKIPIN            1
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * Process subfile records
     C                   EXSR      DBPRSF
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * If data entered
     C     WKIPIN        IFEQ      'Y'
      * Update DBF from subfile
     C                   EXSR      EAPRSF
      * If error during update, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END                                                    WKIPIN
     C                   END
      * Switch between *ADD/*CHANGE modes
     C   09              EXSR      FACHMD
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
     C                   EXSR      DCPRSR
     C                   SETOFF                                       87        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Set off error indicators
     C                   MOVEA     WKIND0        *IN(33)
      * No errors
     C                   SETOFF                                       98
      * No SFLNXTCHG
     C                   SETOFF                                       84
     C     W0PMD         IFEQ      'ADD'
      * Check for null record
     C                   EXSR      DDNLRC
     C     W0NLR         IFEQ      'Y'
     C                   GOTO      DCEXIT
     C                   END
      * If not null record, continue
     C                   END
      * Data entered
     C                   MOVEL     'Y'           WKIPIN
      * SFLNXTCHG
     C                   SETON                                        84
      * If delete request, bypass validation
     C     #1SEL         IFEQ      'D'
     C                   GOTO      DCEXIT
     C                   END
      * Validate subfile record
     C                   EXSR      DEV1RC
      * If SFLRCD invalid, note the fact
     C   98
     CANN99              Z-ADD     ##RR          ##SFRC               99        *
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   DDNLRC        BEGSR
      *================================================================
      * Check for null record
      *================================================================
     C                   MOVEL     'N'           W0NLR             1
     C     #1COTT        CABNE     *BLANK        DDEXIT                         Component Name
     C     #1CSEQ        CABNE     *BLANK        DDEXIT                         Component Seque
     C     #1MD01        CABNE     *BLANK        DDEXIT                         Module 01
     C     #1MP01        CABNE     *BLANK        DDEXIT                         Module be/not b
     C     #1MD02        CABNE     *BLANK        DDEXIT                         Module 02
     C     #1MP02        CABNE     *BLANK        DDEXIT                         Mod 02 be/not b
     C     #1MD03        CABNE     *BLANK        DDEXIT                         Module 03
     C     #1MP03        CABNE     *BLANK        DDEXIT                         Mod 03 be/not b
     C     #1MD04        CABNE     *BLANK        DDEXIT                         Module 04
     C     #1MP04        CABNE     *BLANK        DDEXIT                         Mod 04 be/not b
     C     #1MD05        CABNE     *BLANK        DDEXIT                         Module 05
     C     #1MP05        CABNE     *BLANK        DDEXIT                         Mod 05 be/not b
     C     #1MD06        CABNE     *BLANK        DDEXIT                         Module 06
     C     #1MP06        CABNE     *BLANK        DDEXIT                         Mod 06 be/not b
     C     #1MD07        CABNE     *BLANK        DDEXIT                         Module 07
     C     #1MP07        CABNE     *BLANK        DDEXIT                         Mod 07 be/not b
     C     #1MD08        CABNE     *BLANK        DDEXIT                         Module 08
     C     #1MP08        CABNE     *BLANK        DDEXIT                         Mod 08 be/not b
     C     #1MD09        CABNE     *BLANK        DDEXIT                         Module 09
     C     #1MP09        CABNE     *BLANK        DDEXIT                         Mod 09 be/not b
     C     #1MD10        CABNE     *BLANK        DDEXIT                         Module 10
     C     #1MP10        CABNE     *BLANK        DDEXIT                         Mod 10 be/not b
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      * Check Component Sequence Number is numeric
     C                   MOVEL     *IN90         XG90              1
     C                   TESTN                   #1CSEQ               90  90    *
     C   90              MOVE      #1CSEQ        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90    *
      * All blank is OK
     C  N90#1CSEQ        COMP      *BLANKS                                90    *
      * '?' is OK
     C  N90              MOVEL     #1CSEQ        XGX1
     C  N90XGX1          COMP      '?'                                    90    *
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   MOVEL     'Y2U0010'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9835      *
     C                   END
     C                   MOVEL     XG90          *IN90
      * Validate Module 01
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MD01        W0NSRQ            1            Module 01
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100620       Y2LSNO            7 0
     C     #1MD01        PARM      #1MD01        W0EXVL           20            Module 01
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Module be/not be present
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MP01        W0NSRQ            1            Module be/not b
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100688       Y2LSNO            7 0
     C     #1MP01        PARM      #1MP01        W0EXVL           20            Module be/not b
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Module 02
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MD02        W0NSRQ            1            Module 02
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100620       Y2LSNO            7 0
     C     #1MD02        PARM      #1MD02        W0EXVL           20            Module 02
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Mod 02 be/not be present
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MP02        W0NSRQ            1            Mod 02 be/not b
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100688       Y2LSNO            7 0
     C     #1MP02        PARM      #1MP02        W0EXVL           20            Mod 02 be/not b
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Module 03
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MD03        W0NSRQ            1            Module 03
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100620       Y2LSNO            7 0
     C     #1MD03        PARM      #1MD03        W0EXVL           20            Module 03
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Mod 03 be/not be present
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MP03        W0NSRQ            1            Mod 03 be/not b
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100688       Y2LSNO            7 0
     C     #1MP03        PARM      #1MP03        W0EXVL           20            Mod 03 be/not b
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Module 04
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MD04        W0NSRQ            1            Module 04
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100620       Y2LSNO            7 0
     C     #1MD04        PARM      #1MD04        W0EXVL           20            Module 04
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Mod 04 be/not be present
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MP04        W0NSRQ            1            Mod 04 be/not b
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100688       Y2LSNO            7 0
     C     #1MP04        PARM      #1MP04        W0EXVL           20            Mod 04 be/not b
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Module 05
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MD05        W0NSRQ            1            Module 05
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100620       Y2LSNO            7 0
     C     #1MD05        PARM      #1MD05        W0EXVL           20            Module 05
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Mod 05 be/not be present
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MP05        W0NSRQ            1            Mod 05 be/not b
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100688       Y2LSNO            7 0
     C     #1MP05        PARM      #1MP05        W0EXVL           20            Mod 05 be/not b
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Module 06
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MD06        W0NSRQ            1            Module 06
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100620       Y2LSNO            7 0
     C     #1MD06        PARM      #1MD06        W0EXVL           20            Module 06
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Mod 06 be/not be present
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MP06        W0NSRQ            1            Mod 06 be/not b
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100688       Y2LSNO            7 0
     C     #1MP06        PARM      #1MP06        W0EXVL           20            Mod 06 be/not b
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Module 07
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MD07        W0NSRQ            1            Module 07
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100620       Y2LSNO            7 0
     C     #1MD07        PARM      #1MD07        W0EXVL           20            Module 07
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Mod 07 be/not be present
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MP07        W0NSRQ            1            Mod 07 be/not b
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100688       Y2LSNO            7 0
     C     #1MP07        PARM      #1MP07        W0EXVL           20            Mod 07 be/not b
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Module 08
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MD08        W0NSRQ            1            Module 08
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100620       Y2LSNO            7 0
     C     #1MD08        PARM      #1MD08        W0EXVL           20            Module 08
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Mod 08 be/not be present
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MP08        W0NSRQ            1            Mod 08 be/not b
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100688       Y2LSNO            7 0
     C     #1MP08        PARM      #1MP08        W0EXVL           20            Mod 08 be/not b
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Module 09
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MD09        W0NSRQ            1            Module 09
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100620       Y2LSNO            7 0
     C     #1MD09        PARM      #1MD09        W0EXVL           20            Module 09
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Mod 09 be/not be present
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MP09        W0NSRQ            1            Mod 09 be/not b
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100688       Y2LSNO            7 0
     C     #1MP09        PARM      #1MP09        W0EXVL           20            Mod 09 be/not b
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Module 10
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MD10        W0NSRQ            1            Module 10
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100620       Y2LSNO            7 0
     C     #1MD10        PARM      #1MD10        W0EXVL           20            Module 10
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Mod 10 be/not be present
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MP10        W0NSRQ            1            Mod 10 be/not b
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100688       Y2LSNO            7 0
     C     #1MP10        PARM      #1MP10        W0EXVL           20            Mod 10 be/not b
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * USER: Validate subfile record fields
      * Validate ? in Key Fields
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     #1COTT        WUJ8ST                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUJ8ST        IFEQ      '?'                                          *IF
      * Select Particular Compnts - Components  *
     C                   CALL      'CB0403S'                            90      Select Particul
     C                   PARM      *BLANK        W0RTN             7
     C     #1COTT        PARM      #1COTT        WQ0001           10            Component Name
     C     #1CSEQ        PARM      #1CSEQ        WQ0002            5            Component Seque
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CB0403S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983435    *
     C                   END
     C                   END                                                    *FI
     C                   MOVEL     #1MCUN        WUJ8ST                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUJ8ST        IFEQ      '?'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1COTT        ZA0001                         Component Name
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Start of 090416
      * Module 01
      * CASE: RCD.Module 01 is blank
     C     #1MD01        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MD01        ZA0002                         Module 01
      * Send message 'Module No 1 must be entrd'
     C                   MOVEL     'CBM0151'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9836      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Module 01 is Valid values
     C     #1MD01        IFEQ      'RC'                                         *IF
     C     #1MD01        OREQ      'LE'
     C     #1MD01        OREQ      'DL'
     C     #1MD01        OREQ      'AB'
     C     #1MD01        OREQ      'CA'
     C     #1MD01        OREQ      'CM'
     C     #1MD01        OREQ      'FM'
     C     #1MD01        OREQ      'FX'
     C     #1MD01        OREQ      'MM'
     C     #1MD01        OREQ      'FD'
     C     #1MD01        OREQ      'EM'
     C     #1MD01        OREQ      'FF'
     C     #1MD01        OREQ      'FT'
     C     #1MD01        OREQ      'GL'
     C     #1MD01        OREQ      'IA'
     C     #1MD01        OREQ      'MS'
     C     #1MD01        OREQ      '#K'
     C     #1MD01        OREQ      '#I'
     C     #1MD01        OREQ      '#J'
     C     #1MD01        OREQ      'MT'
     C     #1MD01        OREQ      'NM'
     C     #1MD01        OREQ      'RE'
     C     #1MD01        OREQ      'SE'
     C     #1MD01        OREQ      '#D'
     C     #1MD01        OREQ      '#C'
     C     #1MD01        OREQ      '#F'
     C     #1MD01        OREQ      '#B'
     C     #1MD01        OREQ      '#A'
     C     #1MD01        OREQ      '#E'
     C     #1MD01        OREQ      'SD'
     C     #1MD01        OREQ      'MF'
     C     #1MD01        OREQ      'IR'
     C     #1MD01        OREQ      '#G'
     C     #1MD01        OREQ      'MQ'
     C     #1MD01        OREQ      'RM'
     C     #1MD01        OREQ      'ST'
     C     #1MD01        OREQ      'TK'
     C     #1MD01        OREQ      'TM'
     C     #1MD01        OREQ      'HF'
     C     #1MD01        OREQ      'MC'
     C     #1MD01        OREQ      'OD'
     C     #1MD01        OREQ      'ED'
     C     #1MD01        OREQ      'CF'
     C     #1MD01        OREQ      'LB'
     C     #1MD01        OREQ      'PM'
     C     #1MD01        OREQ      'ME'
     C     #1MD01        OREQ      'CG'
     C     #1MD01        OREQ      'MG'
     C     #1MD01        OREQ      'AA'
     C     #1MD01        OREQ      'PL'                                                        CPL00
     C     #1MD01        OREQ      'TI'
     C     #1MD01        OREQ      'PB'                                                        CPB00
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MD01        ZA0003                         Module 01
      * Send message 'Module 01 is invalid'
     C                   MOVEL     'CBM0152'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9836      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 01 status flag.
      * CASE: RCD.Module be/not be present is Blank
     C     #1MP01        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MP01        ZA0004                         Module be/not b
      * Send message 'Module 01 status flag req'
     C                   MOVEL     'CBM0153'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9837      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Module be/not be present is Non-blank Values
     C     #1MP01        IFEQ      'N'                                          *IF
     C     #1MP01        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MP01        ZA0005                         Module be/not b
      * Send message 'Module 01 stat flag invld'
     C                   MOVEL     'CBM0154'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9837      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 02
      * CASE: RCD.Module 02 is blank
     C     #1MD02        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Module 02 is Valid values
     C     #1MD02        IFEQ      'RC'                                         *IF
     C     #1MD02        OREQ      'LE'
     C     #1MD02        OREQ      'DL'
     C     #1MD02        OREQ      'AB'
     C     #1MD02        OREQ      'CA'
     C     #1MD02        OREQ      'CM'
     C     #1MD02        OREQ      'FM'
     C     #1MD02        OREQ      'FX'
     C     #1MD02        OREQ      'MM'
     C     #1MD02        OREQ      'FD'
     C     #1MD02        OREQ      'EM'
     C     #1MD02        OREQ      'FF'
     C     #1MD02        OREQ      'FT'
     C     #1MD02        OREQ      'GL'
     C     #1MD02        OREQ      'IA'
     C     #1MD02        OREQ      'MS'
     C     #1MD02        OREQ      '#K'
     C     #1MD02        OREQ      '#I'
     C     #1MD02        OREQ      '#J'
     C     #1MD02        OREQ      'MT'
     C     #1MD02        OREQ      'NM'
     C     #1MD02        OREQ      'RE'
     C     #1MD02        OREQ      'SE'
     C     #1MD02        OREQ      '#D'
     C     #1MD02        OREQ      '#C'
     C     #1MD02        OREQ      '#F'
     C     #1MD02        OREQ      '#B'
     C     #1MD02        OREQ      '#A'
     C     #1MD02        OREQ      '#E'
     C     #1MD02        OREQ      'SD'
     C     #1MD02        OREQ      'MF'
     C     #1MD02        OREQ      'IR'
     C     #1MD02        OREQ      '#G'
     C     #1MD02        OREQ      'MQ'
     C     #1MD02        OREQ      'RM'
     C     #1MD02        OREQ      'ST'
     C     #1MD02        OREQ      'TK'
     C     #1MD02        OREQ      'TM'
     C     #1MD02        OREQ      'HF'
     C     #1MD02        OREQ      'MC'
     C     #1MD02        OREQ      'OD'
     C     #1MD02        OREQ      'ED'
     C     #1MD02        OREQ      'CF'
     C     #1MD02        OREQ      'LB'
     C     #1MD02        OREQ      'PM'
     C     #1MD02        OREQ      'ME'
     C     #1MD02        OREQ      'CG'
     C     #1MD02        OREQ      'MG'
     C     #1MD02        OREQ      'AA'
     C     #1MD02        OREQ      'PL'                                                        CPL00
     C     #1MD02        OREQ      'TI'
     C     #1MD02        OREQ      'PB'                                                        CPB00
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MD02        ZA0006                         Module 02
      * Send message 'Module 02 is invalid'
     C                   MOVEL     'CBM0156'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9838      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 02 status flag.
      * CASE: RCD.Mod 02 be/not be present is Blank
     C     #1MP02        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Mod 02 be/not be present is Non-blank Values
     C     #1MP02        IFEQ      'N'                                          *IF
     C     #1MP02        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MP02        ZA0007                         Mod 02 be/not b
      * Send message 'Module 02 stat flag invld'
     C                   MOVEL     'CBM0158'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9839      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 03
      * CASE: RCD.Module 03 is blank
     C     #1MD03        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Module 03 is Valid values
     C     #1MD03        IFEQ      'RC'                                         *IF
     C     #1MD03        OREQ      'LE'
     C     #1MD03        OREQ      'DL'
     C     #1MD03        OREQ      'AB'
     C     #1MD03        OREQ      'CA'
     C     #1MD03        OREQ      'CM'
     C     #1MD03        OREQ      'FM'
     C     #1MD03        OREQ      'FX'
     C     #1MD03        OREQ      'MM'
     C     #1MD03        OREQ      'FD'
     C     #1MD03        OREQ      'EM'
     C     #1MD03        OREQ      'FF'
     C     #1MD03        OREQ      'FT'
     C     #1MD03        OREQ      'GL'
     C     #1MD03        OREQ      'IA'
     C     #1MD03        OREQ      'MS'
     C     #1MD03        OREQ      '#K'
     C     #1MD03        OREQ      '#I'
     C     #1MD03        OREQ      '#J'
     C     #1MD03        OREQ      'MT'
     C     #1MD03        OREQ      'NM'
     C     #1MD03        OREQ      'RE'
     C     #1MD03        OREQ      'SE'
     C     #1MD03        OREQ      '#D'
     C     #1MD03        OREQ      '#C'
     C     #1MD03        OREQ      '#F'
     C     #1MD03        OREQ      '#B'
     C     #1MD03        OREQ      '#A'
     C     #1MD03        OREQ      '#E'
     C     #1MD03        OREQ      'SD'
     C     #1MD03        OREQ      'MF'
     C     #1MD03        OREQ      'IR'
     C     #1MD03        OREQ      '#G'
     C     #1MD03        OREQ      'MQ'
     C     #1MD03        OREQ      'RM'
     C     #1MD03        OREQ      'ST'
     C     #1MD03        OREQ      'TK'
     C     #1MD03        OREQ      'TM'
     C     #1MD03        OREQ      'HF'
     C     #1MD03        OREQ      'MC'
     C     #1MD03        OREQ      'OD'
     C     #1MD03        OREQ      'ED'
     C     #1MD03        OREQ      'CF'
     C     #1MD03        OREQ      'LB'
     C     #1MD03        OREQ      'PM'
     C     #1MD03        OREQ      'ME'
     C     #1MD03        OREQ      'CG'
     C     #1MD03        OREQ      'MG'
     C     #1MD03        OREQ      'AA'
     C     #1MD03        OREQ      'PL'                                                        CPL00
     C     #1MD03        OREQ      'TI'
     C     #1MD03        OREQ      'PB'                                                        CPB00
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MD03        ZA0008                         Module 03
      * Send message 'Module 03 is invalid'
     C                   MOVEL     'CBM0160'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9840      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 03 status flag.
      * CASE: RCD.Mod 03 be/not be present is Blank
     C     #1MP03        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Mod 03 be/not be present is Non-blank Values
     C     #1MP03        IFEQ      'N'                                          *IF
     C     #1MP03        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MP03        ZA0009                         Mod 03 be/not b
      * Send message 'Module 03 stat flag invld'
     C                   MOVEL     'CBM0162'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9841      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 04
      * CASE: RCD.Module 04 is blank
     C     #1MD04        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Module 04 is Valid values
     C     #1MD04        IFEQ      'RC'                                         *IF
     C     #1MD04        OREQ      'LE'
     C     #1MD04        OREQ      'DL'
     C     #1MD04        OREQ      'AB'
     C     #1MD04        OREQ      'CA'
     C     #1MD04        OREQ      'CM'
     C     #1MD04        OREQ      'FM'
     C     #1MD04        OREQ      'FX'
     C     #1MD04        OREQ      'MM'
     C     #1MD04        OREQ      'FD'
     C     #1MD04        OREQ      'EM'
     C     #1MD04        OREQ      'FF'
     C     #1MD04        OREQ      'FT'
     C     #1MD04        OREQ      'GL'
     C     #1MD04        OREQ      'IA'
     C     #1MD04        OREQ      'MS'
     C     #1MD04        OREQ      '#K'
     C     #1MD04        OREQ      '#I'
     C     #1MD04        OREQ      '#J'
     C     #1MD04        OREQ      'MT'
     C     #1MD04        OREQ      'NM'
     C     #1MD04        OREQ      'RE'
     C     #1MD04        OREQ      'SE'
     C     #1MD04        OREQ      '#D'
     C     #1MD04        OREQ      '#C'
     C     #1MD04        OREQ      '#F'
     C     #1MD04        OREQ      '#B'
     C     #1MD04        OREQ      '#A'
     C     #1MD04        OREQ      '#E'
     C     #1MD04        OREQ      'SD'
     C     #1MD04        OREQ      'MF'
     C     #1MD04        OREQ      'IR'
     C     #1MD04        OREQ      '#G'
     C     #1MD04        OREQ      'MQ'
     C     #1MD04        OREQ      'RM'
     C     #1MD04        OREQ      'ST'
     C     #1MD04        OREQ      'TK'
     C     #1MD04        OREQ      'TM'
     C     #1MD04        OREQ      'HF'
     C     #1MD04        OREQ      'MC'
     C     #1MD04        OREQ      'OD'
     C     #1MD04        OREQ      'ED'
     C     #1MD04        OREQ      'CF'
     C     #1MD04        OREQ      'LB'
     C     #1MD04        OREQ      'PM'
     C     #1MD04        OREQ      'ME'
     C     #1MD04        OREQ      'CG'
     C     #1MD04        OREQ      'MG'
     C     #1MD04        OREQ      'AA'
     C     #1MD04        OREQ      'PL'                                                        CPL00
     C     #1MD04        OREQ      'TI'
     C     #1MD04        OREQ      'PB'                                                        CPB00
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MD04        ZA0010                         Module 04
      * Send message 'Module 04 is invalid'
     C                   MOVEL     'CBM0164'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9842      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 04 status flag.
      * CASE: RCD.Mod 04 be/not be present is Blank
     C     #1MP04        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Mod 04 be/not be present is Non-blank Values
     C     #1MP04        IFEQ      'N'                                          *IF
     C     #1MP04        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MP04        ZA0011                         Mod 04 be/not b
      * Send message 'Module 04 stat flag invld'
     C                   MOVEL     'CBM0166'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9843      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 05
      * CASE: RCD.Module 05 is blank
     C     #1MD05        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Module 05 is Valid values
     C     #1MD05        IFEQ      'RC'                                         *IF
     C     #1MD05        OREQ      'LE'
     C     #1MD05        OREQ      'DL'
     C     #1MD05        OREQ      'AB'
     C     #1MD05        OREQ      'CA'
     C     #1MD05        OREQ      'CM'
     C     #1MD05        OREQ      'FM'
     C     #1MD05        OREQ      'FX'
     C     #1MD05        OREQ      'MM'
     C     #1MD05        OREQ      'FD'
     C     #1MD05        OREQ      'EM'
     C     #1MD05        OREQ      'FF'
     C     #1MD05        OREQ      'FT'
     C     #1MD05        OREQ      'GL'
     C     #1MD05        OREQ      'IA'
     C     #1MD05        OREQ      'MS'
     C     #1MD05        OREQ      '#K'
     C     #1MD05        OREQ      '#I'
     C     #1MD05        OREQ      '#J'
     C     #1MD05        OREQ      'MT'
     C     #1MD05        OREQ      'NM'
     C     #1MD05        OREQ      'RE'
     C     #1MD05        OREQ      'SE'
     C     #1MD05        OREQ      '#D'
     C     #1MD05        OREQ      '#C'
     C     #1MD05        OREQ      '#F'
     C     #1MD05        OREQ      '#B'
     C     #1MD05        OREQ      '#A'
     C     #1MD05        OREQ      '#E'
     C     #1MD05        OREQ      'SD'
     C     #1MD05        OREQ      'MF'
     C     #1MD05        OREQ      'IR'
     C     #1MD05        OREQ      '#G'
     C     #1MD05        OREQ      'MQ'
     C     #1MD05        OREQ      'RM'
     C     #1MD05        OREQ      'ST'
     C     #1MD05        OREQ      'TK'
     C     #1MD05        OREQ      'TM'
     C     #1MD05        OREQ      'HF'
     C     #1MD05        OREQ      'MC'
     C     #1MD05        OREQ      'OD'
     C     #1MD05        OREQ      'ED'
     C     #1MD05        OREQ      'CF'
     C     #1MD05        OREQ      'LB'
     C     #1MD05        OREQ      'PM'
     C     #1MD05        OREQ      'ME'
     C     #1MD05        OREQ      'CG'
     C     #1MD05        OREQ      'MG'
     C     #1MD05        OREQ      'AA'
     C     #1MD05        OREQ      'PL'                                                        CPL00
     C     #1MD05        OREQ      'TI'
     C     #1MD05        OREQ      'PB'                                                        CPB00
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MD05        ZA0012                         Module 05
      * Send message 'Module 05 is invalid'
     C                   MOVEL     'CBM0168'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9844      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 05 status flag.
      * CASE: RCD.Mod 05 be/not be present is Blank
     C     #1MP05        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Mod 05 be/not be present is Non-blank Values
     C     #1MP05        IFEQ      'N'                                          *IF
     C     #1MP05        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MP05        ZA0013                         Mod 05 be/not b
      * Send message 'Module 05 stat flag invld'
     C                   MOVEL     'CBM0170'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9845      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 06
      * CASE: RCD.Module 06 is blank
     C     #1MD06        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Module 06 is Valid values
     C     #1MD06        IFEQ      'RC'                                         *IF
     C     #1MD06        OREQ      'LE'
     C     #1MD06        OREQ      'DL'
     C     #1MD06        OREQ      'AB'
     C     #1MD06        OREQ      'CA'
     C     #1MD06        OREQ      'CM'
     C     #1MD06        OREQ      'FM'
     C     #1MD06        OREQ      'FX'
     C     #1MD06        OREQ      'MM'
     C     #1MD06        OREQ      'FD'
     C     #1MD06        OREQ      'EM'
     C     #1MD06        OREQ      'FF'
     C     #1MD06        OREQ      'FT'
     C     #1MD06        OREQ      'GL'
     C     #1MD06        OREQ      'IA'
     C     #1MD06        OREQ      'MS'
     C     #1MD06        OREQ      '#K'
     C     #1MD06        OREQ      '#I'
     C     #1MD06        OREQ      '#J'
     C     #1MD06        OREQ      'MT'
     C     #1MD06        OREQ      'NM'
     C     #1MD06        OREQ      'RE'
     C     #1MD06        OREQ      'SE'
     C     #1MD06        OREQ      '#D'
     C     #1MD06        OREQ      '#C'
     C     #1MD06        OREQ      '#F'
     C     #1MD06        OREQ      '#B'
     C     #1MD06        OREQ      '#A'
     C     #1MD06        OREQ      '#E'
     C     #1MD06        OREQ      'SD'
     C     #1MD06        OREQ      'MF'
     C     #1MD06        OREQ      'IR'
     C     #1MD06        OREQ      '#G'
     C     #1MD06        OREQ      'MQ'
     C     #1MD06        OREQ      'RM'
     C     #1MD06        OREQ      'ST'
     C     #1MD06        OREQ      'TK'
     C     #1MD06        OREQ      'TM'
     C     #1MD06        OREQ      'HF'
     C     #1MD06        OREQ      'MC'
     C     #1MD06        OREQ      'OD'
     C     #1MD06        OREQ      'ED'
     C     #1MD06        OREQ      'CF'
     C     #1MD06        OREQ      'LB'
     C     #1MD06        OREQ      'PM'
     C     #1MD06        OREQ      'ME'
     C     #1MD06        OREQ      'CG'
     C     #1MD06        OREQ      'MG'
     C     #1MD06        OREQ      'AA'
     C     #1MD06        OREQ      'PL'                                                        CPL00
     C     #1MD06        OREQ      'TI'
     C     #1MD06        OREQ      'PB'                                                        CPB00
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MD06        ZA0014                         Module 06
      * Send message 'Module 06 is invalid'
     C                   MOVEL     'CBM0172'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9846      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 06 status flag.
      * CASE: RCD.Mod 06 be/not be present is Blank
     C     #1MP06        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Mod 06 be/not be present is Non-blank Values
     C     #1MP06        IFEQ      'N'                                          *IF
     C     #1MP06        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MP06        ZA0015                         Mod 06 be/not b
      * Send message 'Module 06 stat flag invld'
     C                   MOVEL     'CBM0174'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9847      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 07
      * CASE: RCD.Module 07 is blank
     C     #1MD07        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Module 07 is Valid values
     C     #1MD07        IFEQ      'RC'                                         *IF
     C     #1MD07        OREQ      'LE'
     C     #1MD07        OREQ      'DL'
     C     #1MD07        OREQ      'AB'
     C     #1MD07        OREQ      'CA'
     C     #1MD07        OREQ      'CM'
     C     #1MD07        OREQ      'FM'
     C     #1MD07        OREQ      'FX'
     C     #1MD07        OREQ      'MM'
     C     #1MD07        OREQ      'FD'
     C     #1MD07        OREQ      'EM'
     C     #1MD07        OREQ      'FF'
     C     #1MD07        OREQ      'FT'
     C     #1MD07        OREQ      'GL'
     C     #1MD07        OREQ      'IA'
     C     #1MD07        OREQ      'MS'
     C     #1MD07        OREQ      '#K'
     C     #1MD07        OREQ      '#I'
     C     #1MD07        OREQ      '#J'
     C     #1MD07        OREQ      'MT'
     C     #1MD07        OREQ      'NM'
     C     #1MD07        OREQ      'RE'
     C     #1MD07        OREQ      'SE'
     C     #1MD07        OREQ      '#D'
     C     #1MD07        OREQ      '#C'
     C     #1MD07        OREQ      '#F'
     C     #1MD07        OREQ      '#B'
     C     #1MD07        OREQ      '#A'
     C     #1MD07        OREQ      '#E'
     C     #1MD07        OREQ      'SD'
     C     #1MD07        OREQ      'MF'
     C     #1MD07        OREQ      'IR'
     C     #1MD07        OREQ      '#G'
     C     #1MD07        OREQ      'MQ'
     C     #1MD07        OREQ      'RM'
     C     #1MD07        OREQ      'ST'
     C     #1MD07        OREQ      'TK'
     C     #1MD07        OREQ      'TM'
     C     #1MD07        OREQ      'HF'
     C     #1MD07        OREQ      'MC'
     C     #1MD07        OREQ      'OD'
     C     #1MD07        OREQ      'ED'
     C     #1MD07        OREQ      'CF'
     C     #1MD07        OREQ      'LB'
     C     #1MD07        OREQ      'PM'
     C     #1MD07        OREQ      'ME'
     C     #1MD07        OREQ      'CG'
     C     #1MD07        OREQ      'MG'
     C     #1MD07        OREQ      'AA'
     C     #1MD07        OREQ      'PL'                                                        CPL00
     C     #1MD07        OREQ      'TI'
     C     #1MD07        OREQ      'PB'                                                        CPB00
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MD07        ZA0016                         Module 07
      * Send message 'Module 07 is invalid'
     C                   MOVEL     'CBM0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9848      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 07 status flag.
      * CASE: RCD.Mod 07 be/not be present is Blank
     C     #1MP07        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Mod 07 be/not be present is Non-blank Values
     C     #1MP07        IFEQ      'N'                                          *IF
     C     #1MP07        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MP07        ZA0017                         Mod 07 be/not b
      * Send message 'Module 07 stat flag invld'
     C                   MOVEL     'CBM0178'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9849      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 08
      * CASE: RCD.Module 08 is blank
     C     #1MD08        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Module 08 is Valid values
     C     #1MD08        IFEQ      'RC'                                         *IF
     C     #1MD08        OREQ      'LE'
     C     #1MD08        OREQ      'DL'
     C     #1MD08        OREQ      'AB'
     C     #1MD08        OREQ      'CA'
     C     #1MD08        OREQ      'CM'
     C     #1MD08        OREQ      'FM'
     C     #1MD08        OREQ      'FX'
     C     #1MD08        OREQ      'MM'
     C     #1MD08        OREQ      'FD'
     C     #1MD08        OREQ      'EM'
     C     #1MD08        OREQ      'FF'
     C     #1MD08        OREQ      'FT'
     C     #1MD08        OREQ      'GL'
     C     #1MD08        OREQ      'IA'
     C     #1MD08        OREQ      'MS'
     C     #1MD08        OREQ      '#K'
     C     #1MD08        OREQ      '#I'
     C     #1MD08        OREQ      '#J'
     C     #1MD08        OREQ      'MT'
     C     #1MD08        OREQ      'NM'
     C     #1MD08        OREQ      'RE'
     C     #1MD08        OREQ      'SE'
     C     #1MD08        OREQ      '#D'
     C     #1MD08        OREQ      '#C'
     C     #1MD08        OREQ      '#F'
     C     #1MD08        OREQ      '#B'
     C     #1MD08        OREQ      '#A'
     C     #1MD08        OREQ      '#E'
     C     #1MD08        OREQ      'SD'
     C     #1MD08        OREQ      'MF'
     C     #1MD08        OREQ      'IR'
     C     #1MD08        OREQ      '#G'
     C     #1MD08        OREQ      'MQ'
     C     #1MD08        OREQ      'RM'
     C     #1MD08        OREQ      'ST'
     C     #1MD08        OREQ      'TK'
     C     #1MD08        OREQ      'TM'
     C     #1MD08        OREQ      'HF'
     C     #1MD08        OREQ      'MC'
     C     #1MD08        OREQ      'OD'
     C     #1MD08        OREQ      'ED'
     C     #1MD08        OREQ      'CF'
     C     #1MD08        OREQ      'LB'
     C     #1MD08        OREQ      'PM'
     C     #1MD08        OREQ      'ME'
     C     #1MD08        OREQ      'CG'
     C     #1MD08        OREQ      'MG'
     C     #1MD08        OREQ      'AA'
     C     #1MD08        OREQ      'PL'                                                        CPL00
     C     #1MD08        OREQ      'TI'
     C     #1MD08        OREQ      'PB'                                                        CPB00
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MD08        ZA0018                         Module 08
      * Send message 'Module 08 is invalid'
     C                   MOVEL     'CBM0180'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9850      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 08 status flag.
      * CASE: RCD.Mod 08 be/not be present is Blank
     C     #1MP08        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Mod 08 be/not be present is Non-blank Values
     C     #1MP08        IFEQ      'N'                                          *IF
     C     #1MP08        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MP08        ZA0019                         Mod 08 be/not b
      * Send message 'Module 08 stat flag invld'
     C                   MOVEL     'CBM0182'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9851      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 09
      * CASE: RCD.Module 09 is blank
     C     #1MD09        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Module 09 is Valid values
     C     #1MD09        IFEQ      'RC'                                         *IF
     C     #1MD09        OREQ      'LE'
     C     #1MD09        OREQ      'DL'
     C     #1MD09        OREQ      'AB'
     C     #1MD09        OREQ      'CA'
     C     #1MD09        OREQ      'CM'
     C     #1MD09        OREQ      'FM'
     C     #1MD09        OREQ      'FX'
     C     #1MD09        OREQ      'MM'
     C     #1MD09        OREQ      'FD'
     C     #1MD09        OREQ      'EM'
     C     #1MD09        OREQ      'FF'
     C     #1MD09        OREQ      'FT'
     C     #1MD09        OREQ      'GL'
     C     #1MD09        OREQ      'IA'
     C     #1MD09        OREQ      'MS'
     C     #1MD09        OREQ      '#K'
     C     #1MD09        OREQ      '#I'
     C     #1MD09        OREQ      '#J'
     C     #1MD09        OREQ      'MT'
     C     #1MD09        OREQ      'NM'
     C     #1MD09        OREQ      'RE'
     C     #1MD09        OREQ      'SE'
     C     #1MD09        OREQ      '#D'
     C     #1MD09        OREQ      '#C'
     C     #1MD09        OREQ      '#F'
     C     #1MD09        OREQ      '#B'
     C     #1MD09        OREQ      '#A'
     C     #1MD09        OREQ      '#E'
     C     #1MD09        OREQ      'SD'
     C     #1MD09        OREQ      'MF'
     C     #1MD09        OREQ      'IR'
     C     #1MD09        OREQ      '#G'
     C     #1MD09        OREQ      'MQ'
     C     #1MD09        OREQ      'RM'
     C     #1MD09        OREQ      'ST'
     C     #1MD09        OREQ      'TK'
     C     #1MD09        OREQ      'TM'
     C     #1MD09        OREQ      'HF'
     C     #1MD09        OREQ      'MC'
     C     #1MD09        OREQ      'OD'
     C     #1MD09        OREQ      'ED'
     C     #1MD09        OREQ      'CF'
     C     #1MD09        OREQ      'LB'
     C     #1MD09        OREQ      'PM'
     C     #1MD09        OREQ      'ME'
     C     #1MD09        OREQ      'CG'
     C     #1MD09        OREQ      'MG'
     C     #1MD09        OREQ      'AA'
     C     #1MD09        OREQ      'PL'                                                        CPL00
     C     #1MD09        OREQ      'TI'
     C     #1MD09        OREQ      'PB'                                                        CPB00
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MD09        ZA0020                         Module 09
      * Send message 'Module 09 is invalid'
     C                   MOVEL     'CBM0184'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9852      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 09 status flag.
      * CASE: RCD.Mod 09 be/not be present is Blank
     C     #1MP09        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Mod 09 be/not be present is Non-blank Values
     C     #1MP09        IFEQ      'N'                                          *IF
     C     #1MP09        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MP09        ZA0021                         Mod 09 be/not b
      * Send message 'Module 09 stat flag invld'
     C                   MOVEL     'CBM0186'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9853      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 10
      * CASE: RCD.Module 10 is blank
     C     #1MD10        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Module 10 is Valid values
     C     #1MD10        IFEQ      'RC'                                         *IF
     C     #1MD10        OREQ      'LE'
     C     #1MD10        OREQ      'DL'
     C     #1MD10        OREQ      'AB'
     C     #1MD10        OREQ      'CA'
     C     #1MD10        OREQ      'CM'
     C     #1MD10        OREQ      'FM'
     C     #1MD10        OREQ      'FX'
     C     #1MD10        OREQ      'MM'
     C     #1MD10        OREQ      'FD'
     C     #1MD10        OREQ      'EM'
     C     #1MD10        OREQ      'FF'
     C     #1MD10        OREQ      'FT'
     C     #1MD10        OREQ      'GL'
     C     #1MD10        OREQ      'IA'
     C     #1MD10        OREQ      'MS'
     C     #1MD10        OREQ      '#K'
     C     #1MD10        OREQ      '#I'
     C     #1MD10        OREQ      '#J'
     C     #1MD10        OREQ      'MT'
     C     #1MD10        OREQ      'NM'
     C     #1MD10        OREQ      'RE'
     C     #1MD10        OREQ      'SE'
     C     #1MD10        OREQ      '#D'
     C     #1MD10        OREQ      '#C'
     C     #1MD10        OREQ      '#F'
     C     #1MD10        OREQ      '#B'
     C     #1MD10        OREQ      '#A'
     C     #1MD10        OREQ      '#E'
     C     #1MD10        OREQ      'SD'
     C     #1MD10        OREQ      'MF'
     C     #1MD10        OREQ      'IR'
     C     #1MD10        OREQ      '#G'
     C     #1MD10        OREQ      'MQ'
     C     #1MD10        OREQ      'RM'
     C     #1MD10        OREQ      'ST'
     C     #1MD10        OREQ      'TK'
     C     #1MD10        OREQ      'TM'
     C     #1MD10        OREQ      'HF'
     C     #1MD10        OREQ      'MC'
     C     #1MD10        OREQ      'OD'
     C     #1MD10        OREQ      'ED'
     C     #1MD10        OREQ      'CF'
     C     #1MD10        OREQ      'LB'
     C     #1MD10        OREQ      'PM'
     C     #1MD10        OREQ      'ME'
     C     #1MD10        OREQ      'CG'
     C     #1MD10        OREQ      'MG'
     C     #1MD10        OREQ      'AA'
     C     #1MD10        OREQ      'PL'                                                        CPL00
     C     #1MD10        OREQ      'TI'
     C     #1MD10        OREQ      'PB'                                                        CPB00
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MD10        ZA0022                         Module 10
      * Send message 'Module 10 is invalid'
     C                   MOVEL     'CBM0188'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9854      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Module 10 status flag.
      * CASE: RCD.Mod 10 be/not be present is Blank
     C     #1MP10        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Mod 10 be/not be present is Non-blank Values
     C     #1MP10        IFEQ      'N'                                          *IF
     C     #1MP10        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MP10        ZA0023                         Mod 10 be/not b
      * Send message 'Module 10 stat flag invld'
     C                   MOVEL     'CBM0190'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9855      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of 090416
      * CASE: RCD.Module 01 is Non-blank Values
     C     #1MD01        IFEQ      'RC'                                         *IF
     C     #1MD01        OREQ      'LE'
     C     #1MD01        OREQ      'DL'
     C     #1MD01        OREQ      'AB'
     C     #1MD01        OREQ      'CA'
     C     #1MD01        OREQ      'CM'
     C     #1MD01        OREQ      'FM'
     C     #1MD01        OREQ      'FX'
     C     #1MD01        OREQ      'MM'
     C     #1MD01        OREQ      'FD'
     C     #1MD01        OREQ      'EM'
     C     #1MD01        OREQ      'FF'
     C     #1MD01        OREQ      'FT'
     C     #1MD01        OREQ      'GL'
     C     #1MD01        OREQ      'IA'
     C     #1MD01        OREQ      'MS'
     C     #1MD01        OREQ      '#K'
     C     #1MD01        OREQ      '#I'
     C     #1MD01        OREQ      '#J'
     C     #1MD01        OREQ      'MT'
     C     #1MD01        OREQ      'NM'
     C     #1MD01        OREQ      'RE'
     C     #1MD01        OREQ      'SE'
     C     #1MD01        OREQ      '#D'
     C     #1MD01        OREQ      '#C'
     C     #1MD01        OREQ      '#F'
     C     #1MD01        OREQ      '#B'
     C     #1MD01        OREQ      '#A'
     C     #1MD01        OREQ      '#E'
     C     #1MD01        OREQ      'SD'
     C     #1MD01        OREQ      'MF'
     C     #1MD01        OREQ      'IR'
     C     #1MD01        OREQ      '#G'
     C     #1MD01        OREQ      'MQ'
     C     #1MD01        OREQ      'RM'
     C     #1MD01        OREQ      'ST'
     C     #1MD01        OREQ      'TK'
     C     #1MD01        OREQ      'TM'
     C     #1MD01        OREQ      'HF'
     C     #1MD01        OREQ      'MC'
     C     #1MD01        OREQ      'OD'
     C     #1MD01        OREQ      'ED'
     C     #1MD01        OREQ      'CF'
     C     #1MD01        OREQ      'LB'
     C     #1MD01        OREQ      'PM'
     C     #1MD01        OREQ      'ME'
     C     #1MD01        OREQ      'CG'
     C     #1MD01        OREQ      'MG'
     C     #1MD01        OREQ      'AA'
     C     #1MD01        OREQ      'PL'                                                        CPL00
     C     #1MD01        OREQ      'TI'
     C     #1MD01        OREQ      'PB'                                                        CPB00
      * Validate Module ID - Module Conditions  *
     C*
     C*****************************************************************
     C     ENTER         PLIST                                                  ENTRY PARAMETERS
     C                   PARM                    W0RTN             7            RETURN CODE
     C                   PARM                    #1MD01                         MODULE ID 1
     C                   PARM                    #1MD02                         MODULE ID 2
     C                   PARM                    #1MD03                         MODULE ID 3
     C                   PARM                    #1MD04                         MODULE ID 4
     C                   PARM                    #1MD05                         MODULE ID 5
     C                   PARM                    #1MD06                         MODULE ID 6
     C                   PARM                    #1MD07                         MODULE ID 7
     C                   PARM                    #1MD08                         MODULE ID 8
     C                   PARM                    #1MD09                         MODULE ID 9
     C                   PARM                    #1MD10                         MODULE ID 10
     C*****************************************************************
     C                   MOVE      *BLANKS       W0RTN
     C*
     C     #1MD01        IFEQ      *BLANKS
     C     #1MD02        ANDNE     *BLANKS
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C*
     C     #1MD02        IFEQ      *BLANKS
     C     #1MD03        ANDNE     *BLANKS
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C*
     C     #1MD03        IFEQ      *BLANKS
     C     #1MD04        ANDNE     *BLANKS
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C*
     C     #1MD04        IFEQ      *BLANKS
     C     #1MD05        ANDNE     *BLANKS
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C*
     C     #1MD05        IFEQ      *BLANKS
     C     #1MD06        ANDNE     *BLANKS
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C*
     C     #1MD06        IFEQ      *BLANKS
     C     #1MD07        ANDNE     *BLANKS
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C*
     C     #1MD07        IFEQ      *BLANKS
     C     #1MD08        ANDNE     *BLANKS
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C*
     C     #1MD08        IFEQ      *BLANKS
     C     #1MD09        ANDNE     *BLANKS
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C*
     C     #1MD09        IFEQ      *BLANKS
     C     #1MD10        ANDNE     *BLANKS
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C*
      * CASE: PGM.*Return code is Error
     C     W0RTN         IFEQ      '**ERR**'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1MD01        ZA0024                         Module 01
     C                   MOVEL     #1MD02        ZA0025                         Module 02
     C                   MOVEL     #1MD03        ZA0026                         Module 03
     C                   MOVEL     #1MD04        ZA0027                         Module 04
     C                   MOVEL     #1MD05        ZA0028                         Module 05
     C                   MOVEL     #1MD06        ZA0029                         Module 06
     C                   MOVEL     #1MD07        ZA0030                         Module 07
     C                   MOVEL     #1MD08        ZA0031                         Module 08
     C                   MOVEL     #1MD09        ZA0032                         Module 09
     C                   MOVEL     #1MD10        ZA0033                         Module 10
      * Send message 'Mod ID n blank, rest also'
     C                   MOVEL     'USR0527'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        983638    *
     C                   SETON                                        404244    *
     C                   SETON                                        464850    *
     C                   SETON                                        5254      *
      *
     C                   END                                                    *FI
      * Validate duplicate Mod ID - Module Conditions  *
     C*
     C*****************************************************************
     C     ENTRY         PLIST                                                  ENTRY PARAMETERS
     C                   PARM                    W0RTN             7            RETURN CODE
     C                   PARM                    #1MD01                         MODULE ID 1
     C                   PARM                    #1MD02                         MODULE ID 2
     C                   PARM                    #1MD03                         MODULE ID 3
     C                   PARM                    #1MD04                         MODULE ID 4
     C                   PARM                    #1MD05                         MODULE ID 5
     C                   PARM                    #1MD06                         MODULE ID 6
     C                   PARM                    #1MD07                         MODULE ID 7
     C                   PARM                    #1MD08                         MODULE ID 8
     C                   PARM                    #1MD09                         MODULE ID 9
     C                   PARM                    #1MD10                         MODULE ID 10
     C*****************************************************************
     C                   MOVE      *BLANKS       W0RTN
     C*
     C     #1MD01        IFEQ      #1MD02
     C     #1MD01        OREQ      #1MD03
     C     #1MD01        OREQ      #1MD04
     C     #1MD01        OREQ      #1MD05
     C     #1MD01        OREQ      #1MD06
     C     #1MD01        OREQ      #1MD07
     C     #1MD01        OREQ      #1MD08
     C     #1MD01        OREQ      #1MD09
     C     #1MD01        OREQ      #1MD10
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C*
     C     #1MD02        IFNE      *BLANKS
     C     #1MD02        IFEQ      #1MD03
     C     #1MD02        OREQ      #1MD04
     C     #1MD02        OREQ      #1MD05
     C     #1MD02        OREQ      #1MD06
     C     #1MD02        OREQ      #1MD07
     C     #1MD02        OREQ      #1MD08
     C     #1MD02        OREQ      #1MD09
     C     #1MD02        OREQ      #1MD10
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C                   END
     C*
     C     #1MD03        IFNE      *BLANKS
     C     #1MD03        IFEQ      #1MD04
     C     #1MD03        OREQ      #1MD05
     C     #1MD03        OREQ      #1MD06
     C     #1MD03        OREQ      #1MD07
     C     #1MD03        OREQ      #1MD08
     C     #1MD03        OREQ      #1MD09
     C     #1MD03        OREQ      #1MD10
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C                   END
     C*
     C     #1MD04        IFNE      *BLANKS
     C     #1MD04        IFEQ      #1MD05
     C     #1MD04        OREQ      #1MD06
     C     #1MD04        OREQ      #1MD07
     C     #1MD04        OREQ      #1MD08
     C     #1MD04        OREQ      #1MD09
     C     #1MD04        OREQ      #1MD10
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C                   END
     C*
     C     #1MD05        IFNE      *BLANKS
     C     #1MD05        IFEQ      #1MD06
     C     #1MD05        OREQ      #1MD07
     C     #1MD05        OREQ      #1MD08
     C     #1MD05        OREQ      #1MD09
     C     #1MD05        OREQ      #1MD10
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C                   END
     C*
     C     #1MD06        IFNE      *BLANKS
     C     #1MD06        IFEQ      #1MD07
     C     #1MD06        OREQ      #1MD08
     C     #1MD06        OREQ      #1MD09
     C     #1MD06        OREQ      #1MD10
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C                   END
     C*
     C     #1MD07        IFNE      *BLANKS
     C     #1MD07        IFEQ      #1MD08
     C     #1MD07        OREQ      #1MD09
     C     #1MD07        OREQ      #1MD10
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C                   END
     C*
     C     #1MD08        IFNE      *BLANKS
     C     #1MD08        IFEQ      #1MD09
     C     #1MD08        OREQ      #1MD10
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C                   END
     C*
     C     #1MD09        IFNE      *BLANKS
     C     #1MD09        IFEQ      #1MD10
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C                   END
     C*
      * CASE: PGM.*Return code is Error
     C     W0RTN         IFEQ      '**ERR**'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1MD01        ZA0034                         Module 01
     C                   MOVEL     #1MD02        ZA0035                         Module 02
     C                   MOVEL     #1MD03        ZA0036                         Module 03
     C                   MOVEL     #1MD04        ZA0037                         Module 04
     C                   MOVEL     #1MD05        ZA0038                         Module 05
     C                   MOVEL     #1MD06        ZA0039                         Module 06
     C                   MOVEL     #1MD07        ZA0040                         Module 07
     C                   MOVEL     #1MD08        ZA0041                         Module 08
     C                   MOVEL     #1MD09        ZA0042                         Module 09
     C                   MOVEL     #1MD10        ZA0043                         Module 10
      * Send message 'No duplicate Mod ID'
     C                   MOVEL     'USR0531'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        983638    *
     C                   SETON                                        404244    *
     C                   SETON                                        464850    *
     C                   SETON                                        5254      *
      *
     C                   END                                                    *FI
      * Validate Module ID Flag - Module Conditions  *
     C*
     C*****************************************************************
     C     LIST          PLIST                                                  ENTRY PARAMETERS
     C                   PARM                    W0RTN             7            RETURN CODE
     C                   PARM                    #1MD01                         MODULE ID 1
     C                   PARM                    #1MP01                         MODULE ID 1
     C                   PARM                    #1MD02                         MODULE ID 2
     C                   PARM                    #1MP02                         MODULE ID 2
     C                   PARM                    #1MD03                         MODULE ID 3
     C                   PARM                    #1MP03                         MODULE ID 3
     C                   PARM                    #1MD04                         MODULE ID 4
     C                   PARM                    #1MP04                         MODULE ID 4
     C                   PARM                    #1MD05                         MODULE ID 5
     C                   PARM                    #1MP05                         MODULE ID 5
     C                   PARM                    #1MD06                         MODULE ID 6
     C                   PARM                    #1MP06                         MODULE ID 6
     C                   PARM                    #1MD07                         MODULE ID 7
     C                   PARM                    #1MP07                         MODULE ID 7
     C                   PARM                    #1MD08                         MODULE ID 8
     C                   PARM                    #1MP08                         MODULE ID 8
     C                   PARM                    #1MD09                         MODULE ID 9
     C                   PARM                    #1MP09                         MODULE ID 9
     C                   PARM                    #1MD10                         MODULE ID 10
     C                   PARM                    #1MP10                         MODULE ID 10
     C*****************************************************************
     C                   MOVE      *BLANKS       W0RTN
     C*
     C     #1MD01        IFNE      *BLANKS
     C     #1MP01        ANDEQ     *BLANKS
     C     #1MD02        ORNE      *BLANKS
     C     #1MP02        ANDEQ     *BLANKS
     C     #1MD03        ORNE      *BLANKS
     C     #1MP03        ANDEQ     *BLANKS
     C     #1MD04        ORNE      *BLANKS
     C     #1MP04        ANDEQ     *BLANKS
     C     #1MD05        ORNE      *BLANKS
     C     #1MP05        ANDEQ     *BLANKS
     C     #1MD06        ORNE      *BLANKS
     C     #1MP06        ANDEQ     *BLANKS
     C     #1MD07        ORNE      *BLANKS
     C     #1MP07        ANDEQ     *BLANKS
     C     #1MD08        ORNE      *BLANKS
     C     #1MP08        ANDEQ     *BLANKS
     C     #1MD09        ORNE      *BLANKS
     C     #1MP09        ANDEQ     *BLANKS
     C     #1MD10        ORNE      *BLANKS
     C     #1MP10        ANDEQ     *BLANKS
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C*
      * Val Mod Id Flags
      * CASE: PGM.*Return code is Error
     C     W0RTN         IFEQ      '**ERR**'                                    *IF
      * CASE: RCD.Module 02 is blank
     C     #1MD02        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Mod 02 be/not be present is Blank
     C     #1MP02        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MP02        ZA0044                         Mod 02 be/not b
      * Send message 'IF Mod ID then also flag'
     C                   MOVEL     'USR0528'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9839      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Module 03 is blank
     C     #1MD03        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Mod 03 be/not be present is Blank
     C     #1MP03        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MP03        ZA0045                         Mod 03 be/not b
      * Send message 'IF Mod ID then also flag'
     C                   MOVEL     'USR0528'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9841      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Module 04 is blank
     C     #1MD04        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Mod 04 be/not be present is Blank
     C     #1MP04        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MP04        ZA0046                         Mod 04 be/not b
      * Send message 'IF Mod ID then also flag'
     C                   MOVEL     'USR0528'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9843      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Module 05 is blank
     C     #1MD05        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Mod 05 be/not be present is Blank
     C     #1MP05        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MP05        ZA0047                         Mod 05 be/not b
      * Send message 'IF Mod ID then also flag'
     C                   MOVEL     'USR0528'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9845      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Module 06 is blank
     C     #1MD06        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Mod 06 be/not be present is Blank
     C     #1MP06        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MP06        ZA0048                         Mod 06 be/not b
      * Send message 'IF Mod ID then also flag'
     C                   MOVEL     'USR0528'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9847      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Module 07 is blank
     C     #1MD07        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Mod 07 be/not be present is Blank
     C     #1MP07        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MP07        ZA0049                         Mod 07 be/not b
      * Send message 'IF Mod ID then also flag'
     C                   MOVEL     'USR0528'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9849      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Module 08 is blank
     C     #1MD08        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Mod 08 be/not be present is Blank
     C     #1MP08        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MP08        ZA0050                         Mod 08 be/not b
      * Send message 'IF Mod ID then also flag'
     C                   MOVEL     'USR0528'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9851      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Module 09 is blank
     C     #1MD09        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Mod 09 be/not be present is Blank
     C     #1MP09        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MP09        ZA0051                         Mod 09 be/not b
      * Send message 'IF Mod ID then also flag'
     C                   MOVEL     'USR0528'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9853      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Module 10 is blank
     C     #1MD10        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Mod 10 be/not be present is Blank
     C     #1MP10        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MP10        ZA0052                         Mod 10 be/not b
      * Send message 'IF Mod ID then also flag'
     C                   MOVEL     'USR0528'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9855      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate Mod ID if Flag - Module Conditions  *
     C*
     C*****************************************************************
     C     LST           PLIST                                                  ENTRY PARAMETERS
     C                   PARM                    W0RTN             7            RETURN CODE
     C                   PARM                    #1MD01                         MODULE ID 1
     C                   PARM                    #1MP01                         MODULE ID 1
     C                   PARM                    #1MD02                         MODULE ID 2
     C                   PARM                    #1MP02                         MODULE ID 2
     C                   PARM                    #1MD03                         MODULE ID 3
     C                   PARM                    #1MP03                         MODULE ID 3
     C                   PARM                    #1MD04                         MODULE ID 4
     C                   PARM                    #1MP04                         MODULE ID 4
     C                   PARM                    #1MD05                         MODULE ID 5
     C                   PARM                    #1MP05                         MODULE ID 5
     C                   PARM                    #1MD06                         MODULE ID 6
     C                   PARM                    #1MP06                         MODULE ID 6
     C                   PARM                    #1MD07                         MODULE ID 7
     C                   PARM                    #1MP07                         MODULE ID 7
     C                   PARM                    #1MD08                         MODULE ID 8
     C                   PARM                    #1MP08                         MODULE ID 8
     C                   PARM                    #1MD09                         MODULE ID 9
     C                   PARM                    #1MP09                         MODULE ID 9
     C                   PARM                    #1MD10                         MODULE ID 10
     C                   PARM                    #1MP10                         MODULE ID 10
     C*****************************************************************
     C                   MOVE      *BLANKS       W0RTN
     C*
     C     #1MP01        IFNE      *BLANKS
     C     #1MD01        ANDEQ     *BLANKS
     C     #1MP02        ORNE      *BLANKS
     C     #1MD02        ANDEQ     *BLANKS
     C     #1MP03        ORNE      *BLANKS
     C     #1MD03        ANDEQ     *BLANKS
     C     #1MP04        ORNE      *BLANKS
     C     #1MD04        ANDEQ     *BLANKS
     C     #1MP05        ORNE      *BLANKS
     C     #1MD05        ANDEQ     *BLANKS
     C     #1MP06        ORNE      *BLANKS
     C     #1MD06        ANDEQ     *BLANKS
     C     #1MP07        ORNE      *BLANKS
     C     #1MD07        ANDEQ     *BLANKS
     C     #1MP08        ORNE      *BLANKS
     C     #1MD08        ANDEQ     *BLANKS
     C     #1MP09        ORNE      *BLANKS
     C     #1MD09        ANDEQ     *BLANKS
     C     #1MP10        ORNE      *BLANKS
     C     #1MD10        ANDEQ     *BLANKS
     C                   MOVEL     '**ERR**'     W0RTN
     C                   END
     C*
      * Val Mod Id If Flag
      * CASE: PGM.*Return code is Error
     C     W0RTN         IFEQ      '**ERR**'                                    *IF
      * CASE: RCD.Mod 02 be/not be present is Blank
     C     #1MP02        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Module 02 is blank
     C     #1MD02        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MD02        ZA0053                         Module 02
      * Send message 'If Flag then also Mod ID'
     C                   MOVEL     'USR0642'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9838      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Mod 03 be/not be present is Blank
     C     #1MP03        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Module 03 is blank
     C     #1MD03        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MD03        ZA0054                         Module 03
      * Send message 'If Flag then also Mod ID'
     C                   MOVEL     'USR0642'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9840      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Mod 04 be/not be present is Blank
     C     #1MP04        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Module 04 is blank
     C     #1MD04        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MD04        ZA0055                         Module 04
      * Send message 'If Flag then also Mod ID'
     C                   MOVEL     'USR0642'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9842      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Mod 05 be/not be present is Blank
     C     #1MP05        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Module 05 is blank
     C     #1MD05        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MD05        ZA0056                         Module 05
      * Send message 'If Flag then also Mod ID'
     C                   MOVEL     'USR0642'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9844      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Mod 06 be/not be present is Blank
     C     #1MP06        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Module 06 is blank
     C     #1MD06        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MD06        ZA0057                         Module 06
      * Send message 'If Flag then also Mod ID'
     C                   MOVEL     'USR0642'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9846      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Mod 07 be/not be present is Blank
     C     #1MP07        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Module 07 is blank
     C     #1MD07        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MD07        ZA0058                         Module 07
      * Send message 'If Flag then also Mod ID'
     C                   MOVEL     'USR0642'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9848      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Mod 08 be/not be present is Blank
     C     #1MP08        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Module 08 is blank
     C     #1MD08        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MD08        ZA0059                         Module 08
      * Send message 'If Flag then also Mod ID'
     C                   MOVEL     'USR0642'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9850      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Mod 09 be/not be present is Blank
     C     #1MP09        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Module 09 is blank
     C     #1MD09        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MD09        ZA0060                         Module 09
      * Send message 'If Flag then also Mod ID'
     C                   MOVEL     'USR0642'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9852      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Mod 10 be/not be present is Blank
     C     #1MP10        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: RCD.Module 10 is blank
     C     #1MD10        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1MD10        ZA0061                         Module 10
      * Send message 'If Flag then also Mod ID'
     C                   MOVEL     'USR0642'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9854      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate subfile record relations
     C                   EXSR      DFV2RC
      * Component Name required
     C     #1COTT        IFEQ      *BLANK                                       IF
     C                   SETON                                        9834      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Component Sequence Number required
     C     #1CSEQ        IFEQ      *BLANK                                       IF
     C                   SETON                                        9835      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *================================================================
     CSR   DEEXIT        ENDSR
      /EJECT
     CSR   DFV2RC        BEGSR
      *================================================================
      * Validate subfile record relations
      *================================================================
      * Check reference to Components
     C                   EXSR      VACKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983435    *
     C                   END
      *================================================================
     CSR   DFEXIT        ENDSR
      /EJECT
     CSR   EAPRSF        BEGSR
      *================================================================
      * Update DBF from subfile
      *================================================================
      * Initialise subfile reload flag
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
     C                   MOVEL     'N'           W0RSF
     C                   END
      * Process all modified subfile records
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process modified subfile record
     C                   EXSR      EBPRSR
     C                   MOVEL     *BLANK        #1SEL
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      * If any errors, cancel reload
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           W0RSF             1
     C                   END
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   EBPRSR        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Set off error indicators
     C                   MOVEA     WKIND0        *IN(33)
     C                   SETOFF                                       98
      *
     C     W0PMD         IFEQ      'ADD'
      * Process add request
     C     #1SEL         IFNE      'D'
     C                   EXSR      DDNLRC
     C     W0NLR         IFNE      'Y'
     C                   EXSR      ECADRQ
     C                   END
     C                   END
     C                   ELSE
     C     #1SEL         IFEQ      'D'
      * Process delete request
     C                   EXSR      EDDLRQ
     C                   ELSE
      * Process change request
     C                   EXSR      EECHRQ
     C                   END
     C                   END
      * If error occurred on update, note the fact
     C     *IN98         IFEQ      '1'
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     ##RR          ##SFRC               99        *
     C                   END
     C                   ELSE
      * USER: Extra processing after DBF update
      * Start of 090416
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   Z-ADD     *ZERO         WUMCXN                         Module Conds un
     C                   MOVEL     '01'          WUMCUN                         Module Conds Un
      * Create recrd & gen uqe no - Module Conditions  *
      *
     C     *IN98         IFNE      '1'
     C                   SETOFF                                         9190
      *
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DJCOTT        WQCOTT                         Component Name
     C     *LIKE         DEFINE    DJCSEQ        WQCSEQ                         Component Seque
      *
      * Define keylist
     C     KCRSA         KLIST
     C                   KFLD                    WQCOTT                         Component Name
     C                   KFLD                    WQCSEQ                         Component Seque
      *
      * Move fields to key list
     C                   MOVEL     #1COTT        WQCOTT                         Component Name
     C                   MOVEL     #1CSEQ        WQCSEQ                         Component Seque
      *
     C/EXEC SQL                                                                             MD055891
     C+ close C1Cursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C*****KCRSA         SETLL     @DJREGN                                      *           MD055891
     C*****KCRSA         READE     @DJREGN                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare C1Cursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMDCJW0                                                              MD055891
     C+ where DJCOTT = :WQCOTT and DJCSEQ = :WQCSEQ                                         MD055891
     C+ order by DJCOTT, DJCSEQ, DJMCUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open C1Cursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from C1Cursor into :CBMDCN                                               MD055891
     C/END-EXEC                                                                             MD055891
      *
     C                   SETOFF                                       90                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
      * Processing if Data record not found
     C                   Z-ADD     01            WUSUNB            2 0
      * Move all fields to @DHREGM
     C                   MOVEL     #1COTT        DJCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DJCSEQ                         Component Seque
     C                   MOVEL     WUSUNB        DJMCUN                         Module Conds Un
     C                   MOVEL     #1MD01        DJMD01                         Module 01
     C                   MOVEL     #1MP01        DJMP01                         Module be/not b
     C                   MOVEL     #1MD02        DJMD02                         Module 02
     C                   MOVEL     #1MP02        DJMP02                         Mod 02 be/not b
     C                   MOVEL     #1MD03        DJMD03                         Module 03
     C                   MOVEL     #1MP03        DJMP03                         Mod 03 be/not b
     C                   MOVEL     #1MD04        DJMD04                         Module 04
     C                   MOVEL     #1MP04        DJMP04                         Mod 04 be/not b
     C                   MOVEL     #1MD05        DJMD05                         Module 05
     C                   MOVEL     #1MP05        DJMP05                         Mod 05 be/not b
     C                   MOVEL     #1MD06        DJMD06                         Module 06
     C                   MOVEL     #1MP06        DJMP06                         Mod 06 be/not b
     C                   MOVEL     #1MD07        DJMD07                         Module 07
     C                   MOVEL     #1MP07        DJMP07                         Mod 07 be/not b
     C                   MOVEL     #1MD08        DJMD08                         Module 08
     C                   MOVEL     #1MP08        DJMP08                         Mod 08 be/not b
     C                   MOVEL     #1MD09        DJMD09                         Module 09
     C                   MOVEL     #1MP09        DJMP09                         Mod 09 be/not b
     C                   MOVEL     #1MD10        DJMD10                         Module 10
     C                   MOVEL     #1MP10        DJMP10                         Mod 10 be/not b
      *
     C**********         WRITE     @DJREGM                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMDCBTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DJCOTT                                                                            MD055891
     C+ , DJCSEQ                                                                            MD055891
     C+ , DJMCUN                                                                            MD055891
     C+ , DJMD01                                                                            MD055891
     C+ , DJMP01                                                                            MD055891
     C+ , DJMD02                                                                            MD055891
     C+ , DJMP02                                                                            MD055891
     C+ , DJMD03                                                                            MD055891
     C+ , DJMP03                                                                            MD055891
     C+ , DJMD04                                                                            MD055891
     C+ , DJMP04                                                                            MD055891
     C+ , DJMD05                                                                            MD055891
     C+ , DJMP05                                                                            MD055891
     C+ , DJMD06                                                                            MD055891
     C+ , DJMP06                                                                            MD055891
     C+ , DJMD07                                                                            MD055891
     C+ , DJMP07                                                                            MD055891
     C+ , DJMD08                                                                            MD055891
     C+ , DJMP08                                                                            MD055891
     C+ , DJMD09                                                                            MD055891
     C+ , DJMP09                                                                            MD055891
     C+ , DJMD10                                                                            MD055891
     C+ , DJMP10                                                                            MD055891
     C+ , DJMODE                                                                            MD055891
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :DJCOTT                                                                           MD055891
     C+ , :DJCSEQ                                                                           MD055891
     C+ , :DJMCUN                                                                           MD055891
     C+ , :DJMD01                                                                           MD055891
     C+ , :DJMP01                                                                           MD055891
     C+ , :DJMD02                                                                           MD055891
     C+ , :DJMP02                                                                           MD055891
     C+ , :DJMD03                                                                           MD055891
     C+ , :DJMP03                                                                           MD055891
     C+ , :DJMD04                                                                           MD055891
     C+ , :DJMP04                                                                           MD055891
     C+ , :DJMD05                                                                           MD055891
     C+ , :DJMP05                                                                           MD055891
     C+ , :DJMD06                                                                           MD055891
     C+ , :DJMP06                                                                           MD055891
     C+ , :DJMD07                                                                           MD055891
     C+ , :DJMP07                                                                           MD055891
     C+ , :DJMD08                                                                           MD055891
     C+ , :DJMP08                                                                           MD055891
     C+ , :DJMD09                                                                           MD055891
     C+ , :DJMP09                                                                           MD055891
     C+ , :DJMD10                                                                           MD055891
     C+ , :DJMP10                                                                           MD055891
     C+ , 'B'                                                                               MD055891
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMDCXTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DJCOTT                                                                            MD055891
     C+ , DJCSEQ                                                                            MD055891
     C+ , DJMCUN                                                                            MD055891
     C+ , DJMODE                                                                            MD055891
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :DJCOTT                                                                           MD055891
     C+ , :DJCSEQ                                                                           MD055891
     C+ , :DJMCUN                                                                           MD055891
     C+ , 'B'                                                                               MD055891
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
      *
     C******IN91         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
      *
     C                   ELSE
      *
      *
      * Move 'Y' into parameter if DBF update complete
      *
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      *
     C                   END
     C                   END
      *
      *
     C                   MOVE      WUMCUN        WUMCXN
      *
     C     *IN90         DOWEQ     '0'
      *
      * Process Data record
      *
     C     WUMCUN        IFEQ      DJMCUN                                       *IF
      *
     C                   ADD       01            WUMCXN
     C                   MOVE      WUMCXN        WUMCUN
     C                   MOVE      DJMCUN        WUSUNB
     C                   ADD       01            WUSUNB
     C                   MOVEL     'Y'           WUCRRC            1            Create record f
      *
     C                   END                                                    *FI
     C*****KCRSA         READE     @DJREGN                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from C1Cursor into :CBMDCN                                               MD055891
     C/END-EXEC                                                                             MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
      *
     C                   END                                                    *FI
      *
     C     WUCRRC        IFEQ      'Y'
      * Move all fields to @DJREGM
     C                   MOVEL     #1COTT        DJCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DJCSEQ                         Component Seque
     C                   MOVEL     WUSUNB        DJMCUN                         Module Conds Un
     C                   MOVEL     #1MD01        DJMD01                         Module 01
     C                   MOVEL     #1MP01        DJMP01                         Module be/not b
     C                   MOVEL     #1MD02        DJMD02                         Module 02
     C                   MOVEL     #1MP02        DJMP02                         Mod 02 be/not b
     C                   MOVEL     #1MD03        DJMD03                         Module 03
     C                   MOVEL     #1MP03        DJMP03                         Mod 03 be/not b
     C                   MOVEL     #1MD04        DJMD04                         Module 04
     C                   MOVEL     #1MP04        DJMP04                         Mod 04 be/not b
     C                   MOVEL     #1MD05        DJMD05                         Module 05
     C                   MOVEL     #1MP05        DJMP05                         Mod 05 be/not b
     C                   MOVEL     #1MD06        DJMD06                         Module 06
     C                   MOVEL     #1MP06        DJMP06                         Mod 06 be/not b
     C                   MOVEL     #1MD07        DJMD07                         Module 07
     C                   MOVEL     #1MP07        DJMP07                         Mod 07 be/not b
     C                   MOVEL     #1MD08        DJMD08                         Module 08
     C                   MOVEL     #1MP08        DJMP08                         Mod 08 be/not b
     C                   MOVEL     #1MD09        DJMD09                         Module 09
     C                   MOVEL     #1MP09        DJMP09                         Mod 09 be/not b
     C                   MOVEL     #1MD10        DJMD10                         Module 10
     C                   MOVEL     #1MP10        DJMP10                         Mod 10 be/not b
      *
     C**********         WRITE     @DJREGM                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMDCBTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DJCOTT                                                                            MD055891
     C+ , DJCSEQ                                                                            MD055891
     C+ , DJMCUN                                                                            MD055891
     C+ , DJMD01                                                                            MD055891
     C+ , DJMP01                                                                            MD055891
     C+ , DJMD02                                                                            MD055891
     C+ , DJMP02                                                                            MD055891
     C+ , DJMD03                                                                            MD055891
     C+ , DJMP03                                                                            MD055891
     C+ , DJMD04                                                                            MD055891
     C+ , DJMP04                                                                            MD055891
     C+ , DJMD05                                                                            MD055891
     C+ , DJMP05                                                                            MD055891
     C+ , DJMD06                                                                            MD055891
     C+ , DJMP06                                                                            MD055891
     C+ , DJMD07                                                                            MD055891
     C+ , DJMP07                                                                            MD055891
     C+ , DJMD08                                                                            MD055891
     C+ , DJMP08                                                                            MD055891
     C+ , DJMD09                                                                            MD055891
     C+ , DJMP09                                                                            MD055891
     C+ , DJMD10                                                                            MD055891
     C+ , DJMP10                                                                            MD055891
     C+ , DJMODE                                                                            MD055891
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :DJCOTT                                                                           MD055891
     C+ , :DJCSEQ                                                                           MD055891
     C+ , :DJMCUN                                                                           MD055891
     C+ , :DJMD01                                                                           MD055891
     C+ , :DJMP01                                                                           MD055891
     C+ , :DJMD02                                                                           MD055891
     C+ , :DJMP02                                                                           MD055891
     C+ , :DJMD03                                                                           MD055891
     C+ , :DJMP03                                                                           MD055891
     C+ , :DJMD04                                                                           MD055891
     C+ , :DJMP04                                                                           MD055891
     C+ , :DJMD05                                                                           MD055891
     C+ , :DJMP05                                                                           MD055891
     C+ , :DJMD06                                                                           MD055891
     C+ , :DJMP06                                                                           MD055891
     C+ , :DJMD07                                                                           MD055891
     C+ , :DJMP07                                                                           MD055891
     C+ , :DJMD08                                                                           MD055891
     C+ , :DJMP08                                                                           MD055891
     C+ , :DJMD09                                                                           MD055891
     C+ , :DJMP09                                                                           MD055891
     C+ , :DJMD10                                                                           MD055891
     C+ , :DJMP10                                                                           MD055891
     C+ , 'B'                                                                               MD055891
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMDCXTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DJCOTT                                                                            MD055891
     C+ , DJCSEQ                                                                            MD055891
     C+ , DJMCUN                                                                            MD055891
     C+ , DJMODE                                                                            MD055891
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :DJCOTT                                                                           MD055891
     C+ , :DJCSEQ                                                                           MD055891
     C+ , :DJMCUN                                                                           MD055891
     C+ , 'B'                                                                               MD055891
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
      *
     C******IN91         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
      *
     C                   ELSE
      *
      * Move 'Y' into parameter if DBF update complete
      *
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      *
     C                   END
     C                   END                                                    *FI
      *
     C                   END
     C                   END                                                    *FI
      * End of 090416
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Module Conditions - Module Conditions  *
     C                   EXSR      SACRRC
     C     W0RTN         IFNE      *BLANK
      * Write error detected
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
     C                   ELSE
      * DBF write successful
      * disable entry
     C                   SETON                                        87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Module Conditions - Module Conditions  *
     C                   EXSR      SBDLRC
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
      * If record altered, reset subfile record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF delete successful
      * Blank out record and protect from entry
     C                   EXSR      MAIZ#1
      * disable entry
     C                   SETON                                        87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
      * Reload subfile
     C                   MOVEL     'Y'           W0RSF             1
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Module Conditions - Module Conditions  *
     C                   EXSR      SFCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
      * Reset subfile record if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF update successful
      * Enable entry
     C                   SETOFF                                       87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACHMD        BEGSR
      *================================================================
      * Switch between *ADD/*CHANGE modes
      *================================================================
     C     W0PMD         IFNE      'ADD'
     C                   MOVEL     'ADD'         W0PMD
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   EXSR      FBRQRL
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   GADSA1        BEGSR
      *================================================================
      * Set display attributes for Subfile record
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect keys if change mode or updated record
     C                   SETON                                        88        *
     C   89
     CANN87              SETOFF                                       88        *
     C                   MOVEL     *IN87         *IN79
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise subfile record
      *================================================================
      * Previous values
     C                   MOVEL     *BLANK        #1DBRC
     C                   MOVEL     *BLANK        #1MCUN                         Module Conds Un
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1COTT                         Component Name
     C                   MOVEL     *BLANK        #1CSEQ                         Component Seque
     C                   MOVEL     *BLANK        #1MD01                         Module 01
     C                   MOVEL     *BLANK        #1MP01                         Module be/not b
     C                   MOVEL     *BLANK        #1MD02                         Module 02
     C                   MOVEL     *BLANK        #1MP02                         Mod 02 be/not b
     C                   MOVEL     *BLANK        #1MD03                         Module 03
     C                   MOVEL     *BLANK        #1MP03                         Mod 03 be/not b
     C                   MOVEL     *BLANK        #1MD04                         Module 04
     C                   MOVEL     *BLANK        #1MP04                         Mod 04 be/not b
     C                   MOVEL     *BLANK        #1MD05                         Module 05
     C                   MOVEL     *BLANK        #1MP05                         Mod 05 be/not b
     C                   MOVEL     *BLANK        #1MD06                         Module 06
     C                   MOVEL     *BLANK        #1MP06                         Mod 06 be/not b
     C                   MOVEL     *BLANK        #1MD07                         Module 07
     C                   MOVEL     *BLANK        #1MP07                         Mod 07 be/not b
     C                   MOVEL     *BLANK        #1MD08                         Module 08
     C                   MOVEL     *BLANK        #1MP08                         Mod 08 be/not b
     C                   MOVEL     *BLANK        #1MD09                         Module 09
     C                   MOVEL     *BLANK        #1MP09                         Mod 09 be/not b
     C                   MOVEL     *BLANK        #1MD10                         Module 10
     C                   MOVEL     *BLANK        #1MP10                         Mod 10 be/not b
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @DJREGN fields to subfile
      *================================================================
     C                   MOVEL     DJMCUN        #1MCUN                         Module Conds Un
     C                   MOVEL     DJCOTT        #1COTT                         Component Name
     C                   MOVEL     DJCSEQ        #1CSEQ                         Component Seque
     C                   MOVEL     DJMD01        #1MD01                         Module 01
     C                   MOVEL     DJMP01        #1MP01                         Module be/not b
     C                   MOVEL     DJMD02        #1MD02                         Module 02
     C                   MOVEL     DJMP02        #1MP02                         Mod 02 be/not b
     C                   MOVEL     DJMD03        #1MD03                         Module 03
     C                   MOVEL     DJMP03        #1MP03                         Mod 03 be/not b
     C                   MOVEL     DJMD04        #1MD04                         Module 04
     C                   MOVEL     DJMP04        #1MP04                         Mod 04 be/not b
     C                   MOVEL     DJMD05        #1MD05                         Module 05
     C                   MOVEL     DJMP05        #1MP05                         Mod 05 be/not b
     C                   MOVEL     DJMD06        #1MD06                         Module 06
     C                   MOVEL     DJMP06        #1MP06                         Mod 06 be/not b
     C                   MOVEL     DJMD07        #1MD07                         Module 07
     C                   MOVEL     DJMP07        #1MP07                         Mod 07 be/not b
     C                   MOVEL     DJMD08        #1MD08                         Module 08
     C                   MOVEL     DJMP08        #1MP08                         Mod 08 be/not b
     C                   MOVEL     DJMD09        #1MD09                         Module 09
     C                   MOVEL     DJMP09        #1MP09                         Mod 09 be/not b
     C                   MOVEL     DJMD10        #1MD10                         Module 10
     C                   MOVEL     DJMP10        #1MP10                         Mod 10 be/not b
      * Hold current record image for change detection
     C                   eval      @1DBRC = CBMDCN                                          MD055891
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2MCUN                         Module Conds Un
     C                   MOVEL     *BLANK        #2COTT                         Component Name
     C                   MOVEL     *BLANK        #2CSEQ                         Component Seque
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Module Conditions - Module Conditions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @DJREGM
     C                   MOVEL     #1COTT        DJCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DJCSEQ                         Component Seque
     C                   MOVEL     #1MCUN        DJMCUN                         Module Conds Un
     C                   MOVEL     #1MD01        DJMD01                         Module 01
     C                   MOVEL     #1MP01        DJMP01                         Module be/not b
     C                   MOVEL     #1MD02        DJMD02                         Module 02
     C                   MOVEL     #1MP02        DJMP02                         Mod 02 be/not b
     C                   MOVEL     #1MD03        DJMD03                         Module 03
     C                   MOVEL     #1MP03        DJMP03                         Mod 03 be/not b
     C                   MOVEL     #1MD04        DJMD04                         Module 04
     C                   MOVEL     #1MP04        DJMP04                         Mod 04 be/not b
     C                   MOVEL     #1MD05        DJMD05                         Module 05
     C                   MOVEL     #1MP05        DJMP05                         Mod 05 be/not b
     C                   MOVEL     #1MD06        DJMD06                         Module 06
     C                   MOVEL     #1MP06        DJMP06                         Mod 06 be/not b
     C                   MOVEL     #1MD07        DJMD07                         Module 07
     C                   MOVEL     #1MP07        DJMP07                         Mod 07 be/not b
     C                   MOVEL     #1MD08        DJMD08                         Module 08
     C                   MOVEL     #1MP08        DJMP08                         Mod 08 be/not b
     C                   MOVEL     #1MD09        DJMD09                         Module 09
     C                   MOVEL     #1MP09        DJMP09                         Mod 09 be/not b
     C                   MOVEL     #1MD10        DJMD10                         Module 10
     C                   MOVEL     #1MP10        DJMP10                         Mod 10 be/not b
      *
      * USER: Processing before Data update
      * Start of 090416
     C                   GOTO      SAEXIT                                       *QUIT
      * End of 090416
     C     KLCRSA        KLIST
     C                   KFLD                    DJCOTT                         Component Name
     C                   KFLD                    DJCSEQ                         Component Seque
     C                   KFLD                    DJMCUN                         Module Conds Un
      * Check for duplicate primary key
     C*****KLCRSA        SETLL     @DJREGM                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT * into :CBMDCN                                                               MD055891
     C+ from CBMDCJW0                                                                       MD055891
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   SETOFF                                       9091                  MD055891
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
     C                   IF        SQLCODE = 0                                              MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0502'     W0RTN             7
      * Send message 'Module Conditions      EX'
     C                   MOVEL     'USR0502'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   END
      *
     C*********          WRITE     @DJREGM                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMDCBTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DJCOTT                                                                            MD055891
     C+ , DJCSEQ                                                                            MD055891
     C+ , DJMCUN                                                                            MD055891
     C+ , DJMD01                                                                            MD055891
     C+ , DJMP01                                                                            MD055891
     C+ , DJMD02                                                                            MD055891
     C+ , DJMP02                                                                            MD055891
     C+ , DJMD03                                                                            MD055891
     C+ , DJMP03                                                                            MD055891
     C+ , DJMD04                                                                            MD055891
     C+ , DJMP04                                                                            MD055891
     C+ , DJMD05                                                                            MD055891
     C+ , DJMP05                                                                            MD055891
     C+ , DJMD06                                                                            MD055891
     C+ , DJMP06                                                                            MD055891
     C+ , DJMD07                                                                            MD055891
     C+ , DJMP07                                                                            MD055891
     C+ , DJMD08                                                                            MD055891
     C+ , DJMP08                                                                            MD055891
     C+ , DJMD09                                                                            MD055891
     C+ , DJMP09                                                                            MD055891
     C+ , DJMD10                                                                            MD055891
     C+ , DJMP10                                                                            MD055891
     C+ , DJMODE                                                                            MD055891
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :DJCOTT                                                                           MD055891
     C+ , :DJCSEQ                                                                           MD055891
     C+ , :DJMCUN                                                                           MD055891
     C+ , :DJMD01                                                                           MD055891
     C+ , :DJMP01                                                                           MD055891
     C+ , :DJMD02                                                                           MD055891
     C+ , :DJMP02                                                                           MD055891
     C+ , :DJMD03                                                                           MD055891
     C+ , :DJMP03                                                                           MD055891
     C+ , :DJMD04                                                                           MD055891
     C+ , :DJMP04                                                                           MD055891
     C+ , :DJMD05                                                                           MD055891
     C+ , :DJMP05                                                                           MD055891
     C+ , :DJMD06                                                                           MD055891
     C+ , :DJMP06                                                                           MD055891
     C+ , :DJMD07                                                                           MD055891
     C+ , :DJMP07                                                                           MD055891
     C+ , :DJMD08                                                                           MD055891
     C+ , :DJMP08                                                                           MD055891
     C+ , :DJMD09                                                                           MD055891
     C+ , :DJMP09                                                                           MD055891
     C+ , :DJMD10                                                                           MD055891
     C+ , :DJMP10                                                                           MD055891
     C+ , 'B'                                                                               MD055891
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMDCXTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DJCOTT                                                                            MD055891
     C+ , DJCSEQ                                                                            MD055891
     C+ , DJMCUN                                                                            MD055891
     C+ , DJMODE                                                                            MD055891
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :DJCOTT                                                                           MD055891
     C+ , :DJCSEQ                                                                           MD055891
     C+ , :DJMCUN                                                                           MD055891
     C+ , 'B'                                                                               MD055891
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
      *
     C******IN91         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
      * Start of S01417
      * Move 'Y' into parameter if DBF update complete
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      * End of S01417
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBDLRC        BEGSR
      *================================================================
      * Delete Module Conditions - Module Conditions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
     C                   MOVEL     #1COTT        WUCOTT                         Component Name
     C                   MOVEL     #1CSEQ        WUCSEQ                         Component Seque
      * Move key fields to @DJREGM
     C                   MOVEL     #1COTT        DJCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DJCSEQ                         Component Seque
     C                   MOVEL     #1MCUN        DJMCUN                         Module Conds Un
      *
     C     KLDLSB        KLIST
     C                   KFLD                    DJCOTT                         Component Name
     C                   KFLD                    DJCSEQ                         Component Seque
     C                   KFLD                    DJMCUN                         Module Conds Un
     C*****KLDLSB        CHAIN     @DJREGM                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT * into :CBMDCN                                                               MD055891
     C+ from CBMDCJW0                                                                       MD055891
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   SETOFF                                       9091                  MD055891
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
                                                                                            MD055891
      * Do not allow deletion of core module conditions                                     MD055891
     C     DJMODE        IFEQ      'C'                                                      MD055891
      * Send message 'Deletion of Core component is not allowed'                            MD055891
     C                   MOVEL     'USR0542'     ZAMSID                                     MD055891
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                     MD055891
     C                   EXSR      ZASNMS                                                   MD055891
     C                   MOVEL     'USR0542'     W0RTN             7                        MD055891
     C                   GOTO      SBEXIT                                       *QUIT       MD055891
     C                   ENDIF                                                  *QUIT       MD055891
                                                                                            MD055891
      *
      * Check for changed record
     C                   eval      @1DBRC = CBMDCN                                          MD055891
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C*****KLDLSB        SETLL     @DJREGM                            9091      *           MD055891
     C                   GOTO      SBEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C**********         DELETE    @DJREGM                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ delete CBMDCBTD                                                                     MD055891
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ delete CBMDCXTD                                                                     MD055891
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C******IN91         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * Check Mod Cons Exists - Module Conditions  *
     C                   EXSR      SCRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Retrieve for Mod Cons Dlt - Components  *
     C                   EXSR      SDRVGN
     C                   MOVEL     'N'           WUCEMI                         Complex Module
      * change comps for mod cons - Components  *
     C                   EXSR      SECHRC
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        W0RTN                          *Return code
      * Start of S01417
      * Move 'Y' into parameter if DBF update complete
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      * End of S01417
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * Check Mod Cons Exists - Module Conditions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DJCOTT        WQSC01                         Component Name
     C     *LIKE         DEFINE    DJCSEQ        WQSC02                         Component Seque
      * Define keylist
     C     KRSSC         KLIST
     C                   KFLD                    WQSC01                         Component Name
     C                   KFLD                    WQSC02                         Component Seque
      * Move fields to key list
     C                   MOVEL     WUCOTT        WQSC01                         Component Name
     C                   MOVEL     WUCSEQ        WQSC02                         Component Seque
     C*****KRSSC         SETLL     @DJREGN                                      *           MD055891
     C*****KRSSC         READE     @DJREGN                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ECursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBMDCJW0                                                              MD055891
     C+ where DJCOTT = :WQSC01 and DJCSEQ = :WQSC02                                         MD055891
     C+ order by DJCOTT, DJCSEQ, DJMCUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open ECursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ECursor into :CBMDCN                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C******IN90         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE = 100                                            MD055891
      * Data record not found
     C                   MOVEL     'USR0501'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SCEXIT
     C                   END
      *
     C******IN90         DOWEQ     '0'                                                      MD055891
     C     SQLCODE       DOWEQ     0                                                        MD055891
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C*****KRSSC         READE     @DJREGN                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ECursor into :CBMDCN                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   END
     C/EXEC SQL                                                                             MD055891
     C+ close ECursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDRVGN        BEGSR
      *================================================================
      * Retrieve for Mod Cons Dlt - Components  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSD         KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
      * Move fields to key list
     C                   MOVEL     DJCOTT        DHCOTT                         Component Name
     C                   MOVEL     DJCSEQ        DHCSEQ                         Component Seque
     C*****KRSSD         CHAIN     @CMPNGX                            90        *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :DJCOTT and DHCSEQ = :DJCSEQ                                         MD055891
     C+ and DHCEMI = 'Y'                                                                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       90                    MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0497'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     'RECORD'      W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     DHCOTT        WUCOTT                         Component Name
     C                   MOVEL     DHCSEQ        WUCSEQ                         Component Seque
     C                   MOVEL     DHCSTS        WUCSTS                         Component Statu
     C                   Z-ADD     DHCSHP        WUCSHP                         Scheduling Prio
     C                   Z-ADD     DHCEPY        WUCEPY                         Execution Prior
     C                   Z-ADD     DHCTSL        WUCTSL                         Timeslice
     C                   MOVEL     DHCFOB        WUCFOB                         FCOOB Error Acc
     C                   MOVEL     DHCTXT        WUCTXT                         Component Text
     C                   MOVEL     DHCPRM        WUCPRM                         Execution Param
     C                   MOVEL     DHCRQD        WUCRQD                         Sel for Today's
     C                   MOVEL     DHCMOD        WUCMOD                         Module
     C                   MOVEL     DHCEMI        WUCEMI                         Complex Module
     C                   MOVEL     DHCRES        WUCRES                         Restart Flag
     C                   Z-ADD     DHCODP        WUCODP                         No.Outstndng De
     C                   MOVEL     DHCMEF        WUCMEF                         Mut.Exclusive C
     C                   MOVEL     DHCFRQ        WUCFRQ                         Run Conditions
     C                   Z-ADD     DHCSDE        WUCSDE                         Start Date
     C                   Z-ADD     DHCSTI        WUCSTI                         Start Time
     C                   Z-ADD     DHCEDE        WUCEDE                         End Date
     C                   Z-ADD     DHCETI        WUCETI                         End Time
     C                   MOVEL     DHCHTB        WUCHTB                         Halt Before
     C                   MOVEL     DHCHTA        WUCHTA                         Halt After
     C                   MOVEL     DHCFAL        WUCFAL                         Component Faile
     C                   Z-ADD     DHEODT        WUEODT                         End of Day Run
     C                   Z-ADD     DHEOMT        WUEOMT                         End of Month Ru
     C                   Z-ADD     DHBOMT        WUBOMT                         Begin of Month
     C                   Z-ADD     DHEOYT        WUEOYT                         End of Year Run
     C                   Z-ADD     DHEODC        WUEODC                         End of Day CPU
     C                   Z-ADD     DHEOMC        WUEOMC                         End of Month CP
     C                   Z-ADD     DHBOMC        WUBOMC                         Begin of Month
     C                   Z-ADD     DHEOYC        WUEOYC                         End of Year CPU
     C                   MOVEL     DHABIC        WUABIC                         Allow Bypass in
     C                   MOVEL     DHCBSN        WUCBSN                         COB Stream Name
     C                   MOVEL     DHTASK        WUTASK                         Task Split Job
     C                   Z-ADD     DHTSNO        WUTSNO                         Number of Task
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * change comps for mod cons - Components  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @DHREGG
     C                   MOVEL     WUCOTT        DHCOTT                         Component Name
     C                   MOVEL     WUCSEQ        DHCSEQ                         Component Seque
      *
     C     KLCHSE        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
     C*****KLCHSE        CHAIN     @DHREGG                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :WUCOTT and DHCSEQ = :WUCSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   SETOFF                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SEEXIT
     C                   END
      *
      * Store record data for null update check
     C                   eval      QCBCM1  = CBCMPN                                         MD055891
     C                   MOVE      QCBCM1        YARDCS
      * Move non-key fields to @DHREGG
     C                   MOVEL     WUCSTS        DHCSTS                         Component Statu
     C                   Z-ADD     WUCSHP        DHCSHP                         Scheduling Prio
     C                   Z-ADD     WUCEPY        DHCEPY                         Execution Prior
     C                   Z-ADD     WUCTSL        DHCTSL                         Timeslice
     C                   MOVEL     WUCFOB        DHCFOB                         FCOOB Error Acc
     C                   MOVEL     WUCTXT        DHCTXT                         Component Text
     C                   MOVEL     WUCPRM        DHCPRM                         Execution Param
     C                   MOVEL     WUCRQD        DHCRQD                         Sel for Today's
     C                   MOVEL     WUCMOD        DHCMOD                         Module
     C                   MOVEL     WUCEMI        DHCEMI                         Complex Module
     C                   MOVEL     WUCRES        DHCRES                         Restart Flag
     C                   Z-ADD     WUCODP        DHCODP                         No.Outstndng De
     C                   MOVEL     WUCMEF        DHCMEF                         Mut.Exclusive C
     C                   MOVEL     WUCFRQ        DHCFRQ                         Run Conditions
     C                   Z-ADD     WUCSDE        DHCSDE                         Start Date
     C                   Z-ADD     WUCSTI        DHCSTI                         Start Time
     C                   Z-ADD     WUCEDE        DHCEDE                         End Date
     C                   Z-ADD     WUCETI        DHCETI                         End Time
     C                   MOVEL     WUCHTB        DHCHTB                         Halt Before
     C                   MOVEL     WUCHTA        DHCHTA                         Halt After
     C                   MOVEL     WUCFAL        DHCFAL                         Component Faile
     C                   Z-ADD     WUEODT        DHEODT                         End of Day Run
     C                   Z-ADD     WUEOMT        DHEOMT                         End of Month Ru
     C                   Z-ADD     WUBOMT        DHBOMT                         Begin of Month
     C                   Z-ADD     WUEOYT        DHEOYT                         End of Year Run
     C                   Z-ADD     WUEODC        DHEODC                         End of Day CPU
     C                   Z-ADD     WUEOMC        DHEOMC                         End of Month CP
     C                   Z-ADD     WUBOMC        DHBOMC                         Begin of Month
     C                   Z-ADD     WUEOYC        DHEOYC                         End of Year CPU
     C                   MOVEL     WUABIC        DHABIC                         Allow Bypass in
     C                   MOVEL     WUCBSN        DHCBSN                         COB Stream Name
     C                   MOVEL     WUTASK        DHTASK                         Task Split Job
     C                   Z-ADD     WUTSNO        DHTSNO                         Number of Task
      *
      * Set PGM.*Record Data Changed flag
     C                   eval      QCBCM1  = CBCMPN                                         MD055891
     C     QCBCM1        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C**********         UPDATE    @DHREGG                              91      *           MD055891
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    CBCMPNL0                             91      *           MD055891
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFCHRC        BEGSR
      *================================================================
      * Change Module Conditions - Module Conditions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @DJREGM
     C                   MOVEL     #1COTT        DJCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DJCSEQ                         Component Seque
     C                   MOVEL     #1MCUN        DJMCUN                         Module Conds Un
      *
     C     KLCHSF        KLIST
     C                   KFLD                    DJCOTT                         Component Name
     C                   KFLD                    DJCSEQ                         Component Seque
     C                   KFLD                    DJMCUN                         Module Conds Un
     C*****KLCHSF        CHAIN     @DJREGM                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT * into :CBMDCN                                                               MD055891
     C+ from CBMDCJW0                                                                       MD055891
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   SETOFF                                       9091                  MD055891
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SFEXIT
     C                   END
                                                                                            MD055891
      * Do not allow amendment of core module conditions                                    MD055891
     C     DJMODE        IFEQ      'C'                                                      MD055891
      * Send message 'Deletion of Core component is not allowed'                            MD055891
     C                   MOVEL     'USR0543'     ZAMSID                                     MD055891
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                     MD055891
     C                   EXSR      ZASNMS                                                   MD055891
     C                   MOVEL     'USR0543'     W0RTN             7                        MD055891
     C                   GOTO      SFEXIT                                       *QUIT       MD055891
     C                   ENDIF                                                  *QUIT       MD055891
                                                                                            MD055891
      *
      * Check for changed record
     C                   eval      @1DBRC = CBMDCN                                          MD055891
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C*********          UNLOCK    CBMDCNL0                             91      *           MD055891
     C                   GOTO      SFEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YBRDCS
      * Move non-key fields to @DJREGM
     C                   MOVEL     #1MD01        DJMD01                         Module 01
     C                   MOVEL     #1MP01        DJMP01                         Module be/not b
     C                   MOVEL     #1MD02        DJMD02                         Module 02
     C                   MOVEL     #1MP02        DJMP02                         Mod 02 be/not b
     C                   MOVEL     #1MD03        DJMD03                         Module 03
     C                   MOVEL     #1MP03        DJMP03                         Mod 03 be/not b
     C                   MOVEL     #1MD04        DJMD04                         Module 04
     C                   MOVEL     #1MP04        DJMP04                         Mod 04 be/not b
     C                   MOVEL     #1MD05        DJMD05                         Module 05
     C                   MOVEL     #1MP05        DJMP05                         Mod 05 be/not b
     C                   MOVEL     #1MD06        DJMD06                         Module 06
     C                   MOVEL     #1MP06        DJMP06                         Mod 06 be/not b
     C                   MOVEL     #1MD07        DJMD07                         Module 07
     C                   MOVEL     #1MP07        DJMP07                         Mod 07 be/not b
     C                   MOVEL     #1MD08        DJMD08                         Module 08
     C                   MOVEL     #1MP08        DJMP08                         Mod 08 be/not b
     C                   MOVEL     #1MD09        DJMD09                         Module 09
     C                   MOVEL     #1MP09        DJMP09                         Mod 09 be/not b
     C                   MOVEL     #1MD10        DJMD10                         Module 10
     C                   MOVEL     #1MP10        DJMP10                         Mod 10 be/not b
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   END
      * If changed update record otherwise release record
     C     YBRDC         IFEQ      'Y'
     C*********          UPDATE    @DJREGM                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBMDCBTD                                                                     MD055891
     C+ set DJMD01 = :DJMD01                                                                MD055891
     C+   , DJMP01 = :DJMP01                                                                MD055891
     C+   , DJMD02 = :DJMD02                                                                MD055891
     C+   , DJMP02 = :DJMP02                                                                MD055891
     C+   , DJMD03 = :DJMD03                                                                MD055891
     C+   , DJMP03 = :DJMP03                                                                MD055891
     C+   , DJMD04 = :DJMD04                                                                MD055891
     C+   , DJMP04 = :DJMP04                                                                MD055891
     C+   , DJMD05 = :DJMD05                                                                MD055891
     C+   , DJMP05 = :DJMP05                                                                MD055891
     C+   , DJMD06 = :DJMD06                                                                MD055891
     C+   , DJMP06 = :DJMP06                                                                MD055891
     C+   , DJMD07 = :DJMD07                                                                MD055891
     C+   , DJMP07 = :DJMP07                                                                MD055891
     C+   , DJMD08 = :DJMD08                                                                MD055891
     C+   , DJMP08 = :DJMP08                                                                MD055891
     C+   , DJMD09 = :DJMD09                                                                MD055891
     C+   , DJMP09 = :DJMP09                                                                MD055891
     C+   , DJMD10 = :DJMD10                                                                MD055891
     C+   , DJMP10 = :DJMP10                                                                MD055891
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   ELSE
      * Release record lock
     C*********          UNLOCK    CBMDCNL0                             91      *           MD055891
     C                   END
     C******IN91         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   eval      @1DBRC = CBMDCN                                          MD055891
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
      * USER: Processing after Data update
      * Start of S01417
      * Move 'Y' into parameter if DBF update complete
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      * End of S01417
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Check reference to Components
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Name search required?
     C                   MOVEL     #1COTT        WK1X01            1
     C                   MOVEL     #1CSEQ        WK1X02            1
     C     WK1X01        IFEQ      '?'                                          Component Name
     C     WK1X02        OREQ      '?'                                          Component Seque
     W* Y2W0053 - One or more arguments defaulted to available contexts
      * Field '(RCD) #1COTT' defaulted for 'Component Name'.
      * Field '(RCD) #1CSEQ' defaulted for 'Component Sequence Number'.
     C                   CALL      'CB0403S'                            90      Select Particul
     C                   PARM      *BLANK        W0RTN             7
     C     #1COTT        PARM      #1COTT        WQ0003           10            Component Name
     C     #1CSEQ        PARM      #1CSEQ        WQ0004            5            Component Seque
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CB0403S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'Y2U0016'
     C                   SETON                                        983435    *
     C                   END
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
      * No value selected, exit
     C     W0RTN         IFNE      *BLANK
     C                   GOTO      VAEXIT
     C                   END
     C                   END
      *................................................................
      * If all low order keys not entered, exit
     C     #1COTT        IFEQ      *BLANK                                       Component Name
     C     #1CSEQ        ANDEQ     *BLANK                                       Component Seque
     C                   GOTO      VAEXIT
     C                   END
      *
     C     KLVADH        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
      * Setup key
     C                   MOVEL     #1COTT        DHCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DHCSEQ                         Component Seque
     C*****KLVADH        CHAIN     @CMPNGX                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :#1COTT and DHCSEQ = :#1CSEQ                                         MD055891
     C+ and DHCEMI = 'Y'                                                                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 0 and SQLCODE <> 100                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VAEXIT
     C                   END
      * Send message 'Components             NF'
     C                   MOVEL     'USR0497'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'USR0497'     W0RTN
      *================================================================
     CSR   VAEXIT        ENDSR
      /EJECT
     CSR   Y0SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y0EXIT        ENDSR
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
      *================================================================
     CSR   Y8EXIT        ENDSR
      /EJECT
     CSR   Y9CLR         BEGSR
      *================================================================
      * Clear *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y9EXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text
      *================================================================
      * Signal help request
     C                   MOVEL     'Y'           W0HLP             1
      *
      * Extract cursor row and column
     C     @#RWCL        DIV       256           ZHCSRW            5 0          Row
     C                   MVR                     ZHCSCL            5 0          Column
      *
      * Save cursor position for redisplay
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0          Row
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0          Column
      *
      *
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Help text sourc
     C                   PARM      *BLANK        YYHPFL           10            Help text file
     C                   PARM      *BLANK        YYHPLB           10            Help text libra
     C                   PARM                    W0RTN             7
     C                   PARM      '*START'      YYHLVN           10            Help label
     C                   PARM      '*NORMAL'     YYUSOP           10            Options
     C                   PARM      ZHCSRW        YYRW              5 0          Row
     C                   PARM      ZHCSCL        YYCL              5 0          Column
     C                   PARM      *ZERO         YYLGCT            5 0          # of grps
     C                   PARM      *BLANK        YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program: Normal
      *================================================================
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
     C/EXEC SQL                                                                             MD055891
     C+ close ACursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUJ8ST            1
      * Obtain default message file
     C     *DTAARA       DEFINE    CBMGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Module Conds unique numrc
     C                   Z-ADD     *ZERO         WUMCXN            2 0
      * Define work field Module Conds Unique No
     C                   MOVEL     *BLANK        WUMCUN            2
      * Define work field Component Name
     C                   MOVEL     *BLANK        WUCOTT           10
      * Define work field Component Sequence Number
     C                   MOVEL     *BLANK        WUCSEQ            5
      * Define work field Component Status
     C                   MOVEL     *BLANK        WUCSTS            1
      * Define work field Scheduling Priority
     C                   Z-ADD     *ZERO         WUCSHP            1 0
      * Define work field Execution Priority
     C                   Z-ADD     *ZERO         WUCEPY            2 0
      * Define work field Timeslice
     C                   Z-ADD     *ZERO         WUCTSL           11 0
      * Define work field FCOOB Error Acceptability
     C                   MOVEL     *BLANK        WUCFOB            1
      * Define work field Component Text
     C                   MOVEL     *BLANK        WUCTXT           60
      * Define work field Execution Parameters
     C                   MOVEL     *BLANK        WUCPRM          100
      * Define work field Sel for Today's COB Flag
     C                   MOVEL     *BLANK        WUCRQD            1
      * Define work field Module
     C                   MOVEL     *BLANK        WUCMOD            2
      * Define work field Complex Module Conds Flag
     C                   MOVEL     *BLANK        WUCEMI            1
      * Define work field Restart Flag
     C                   MOVEL     *BLANK        WUCRES            1
      * Define work field No.Outstndng Dependencies
     C                   Z-ADD     *ZERO         WUCODP            5 0
      * Define work field Mut.Exclusive Comps.Flag
     C                   MOVEL     *BLANK        WUCMEF            1
      * Define work field Run Conditions
     C                   MOVEL     *BLANK        WUCFRQ            2
      * Define work field Start Date
     C                   Z-ADD     *ZERO         WUCSDE            5 0
      * Define work field Start Time
     C                   Z-ADD     *ZERO         WUCSTI            6 0
      * Define work field End Date
     C                   Z-ADD     *ZERO         WUCEDE            5 0
      * Define work field End Time
     C                   Z-ADD     *ZERO         WUCETI            6 0
      * Define work field Halt Before
     C                   MOVEL     *BLANK        WUCHTB            1
      * Define work field Halt After
     C                   MOVEL     *BLANK        WUCHTA            1
      * Define work field Component Failed Today Fl
     C                   MOVEL     *BLANK        WUCFAL            1
      * Define work field End of Day Run Time
     C                   Z-ADD     *ZERO         WUEODT            6 0
      * Define work field End of Month Run Time
     C                   Z-ADD     *ZERO         WUEOMT            6 0
      * Define work field Begin of Month Run Time
     C                   Z-ADD     *ZERO         WUBOMT            6 0
      * Define work field End of Year Run Time
     C                   Z-ADD     *ZERO         WUEOYT            6 0
      * Define work field End of Day CPU Time
     C                   Z-ADD     *ZERO         WUEODC            6 0
      * Define work field End of Month CPU Time
     C                   Z-ADD     *ZERO         WUEOMC            6 0
      * Define work field Begin of Month CPU Time
     C                   Z-ADD     *ZERO         WUBOMC            6 0
      * Define work field End of Year CPU Time
     C                   Z-ADD     *ZERO         WUEOYC            6 0
      * Define work field Allow Bypass in COB
     C                   MOVEL     *BLANK        WUABIC            1
      * Define work field COB Stream Name
     C                   MOVEL     *BLANK        WUCBSN            8
      * Define work field Task Split Job Indicator
     C                   MOVEL     *BLANK        WUTASK            1
      * Define work field Number of Task Split Jobs
     C                   Z-ADD     *ZERO         WUTSNO            3 0
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WUAANA            7
      * Define work field run day number
     C                   Z-ADD     *ZERO         WUAKTX            5 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUAUST            1
      * Define work field date format flag
     C                   MOVEL     *BLANK        WUE3ST            1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUF1ST            1
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Define *Synon program work fields
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
      * Open files
     C                   OPEN      CB0420M#
     C**********         OPEN      CBMDCNL1                                                 MD055891
     C**********         OPEN      CBCMPNL2                                                 MD055891
     C**********         OPEN      CBMDCNL0                                                 MD055891
     C**********         OPEN      CBCMPNL0                                                 MD055891
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     05            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      * Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      * Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      * Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
      *................................................................
      * Set to *CHANGE mode
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     'Y'           W0APM             1
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Start of change S01459.
      * CB0420M Precompiler - Module Conditions  *
      * Remove Last Amend Box and Creation Parameters functions.
      * End of change S01459.
      * Copyright Statement 1988 - Standard functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##AANA            7
     C                   MOVE      MRDT          WUAANA
     C                   MOVE      RDNB          WUAKTX
     C                   MOVE      SUC           WUAUST
     C                   MOVE      DFF           WUE3ST
     C                   MOVE      MBIN          WUF1ST
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      * Core function specific processing.
      *
     C/COPY WNCPYSRC,CB0420MPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0420MPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINS                                                              MD055891
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055891
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0420MPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001

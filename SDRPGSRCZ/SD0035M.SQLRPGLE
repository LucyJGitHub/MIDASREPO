     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas SD Trade innovation a/c type maint subfile')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0035M - Midas-Trade Innovation Account Type                *
      *            Subfile Maintenance                                *
      *                                                               *
      *  Function:  This program allows the user to maintain the      *
      *             Midas-Trade Innovation account types file.        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061008           Date 31Dec21               *
      *  Prev Amend No. MD058085           Date 11May21               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG4529            Date 21Oct04               *
      *                 BUG3761            Date 22Jul04               *
      *                 BUG3403            Date 25Jun04               *
      *                 BUG2808            Date 31May04               *
      *                 CTI004             Date 12Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CTI099             Date 01Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD003             Date 27OCT97               *
      *                 CTI001  *CREATE    Date 28JUL97               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD061008 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG4529 - Overchecking uniqueness for basic number.          *
      *  BUG3761 - Ensure that basic number is unique on a TI A/C.    *
      *  BUG3403 - Valid for Funds Movement indicator still           *
      *            not updated. (Recompile over changed SDTIACL0)     *
      *  BUG2808 - Make sure Valid For Funds Movement field (GDVFFM)  *
      *            is updated in file when amended by user.           *
      *  CTI004 - MidasPlus-TI Integration Enchancement               *
      *           Account Codes Integration                           *
      *  CTI099 - Utility to open accounts for Midas/TI Interface     *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  CTI001 - Midas-Trade Innovation Interface:                   *
      *           - New program.                                      *
      *                                                               *
      *****************************************************************
     F/COPY WNCPYSRC,SD0035MFPG
     FSD0035M#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Trade Innovation a/c type maint subfile
      *
     F*SDTIACL2* IF   E           K DISK                                            BUG3761 MD058085
     F**********                           RENAME(@TIACL1:@TIACL2)                  BUG3761 MD058085
     F**********                           INFSR(*PSSR)                             BUG3761 MD058085
      ** RTV : Midas SD Trade innovation basic number retrieval                              BUG3761
      *                                                                                      BUG3761
     F*SDTIACL1* IF   E           K DISK    USROPN                                          MD058085
     F**********                           INFDS(INFDS1)                                    MD058085
     F**********                           INFSR(*PSSR)                                     MD058085
      * RTV : Midas SD Trade innovation account types retrieval
      *
     F*SDTIACL0* UF A E           K DISK    USROPN                                          MD058085
     F**********                           COMMIT                                           MD058085
     F**********                           INFDS(ID0001)                                    MD058085
     F**********                           INFSR(*PSSR)                                     MD058085
      * UPD : Midas SD Trade innovation account types update
      *
     F*SDFCTLL0* UF   E           K DISK    USROPN                                          MD061008
     F**********                           COMMIT                                           MD061008
     F**********                           INFDS(ID0002)                                    MD061008
     F**********                           INFSR(*PSSR)                                     MD061008
      * UPD : Midas SD Standing data controls update
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D/COPY WNCPYSRC,SD0035MEPG
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D/COPY WNCPYSRC,SD0035MIPG
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
     D*@1DBRC***     E DS                  EXTNAME(SDTIACL0)
     D @1DBRC        E DS                  EXTNAME(SDTIAJW0)                                MD058085
     D                                     PREFIX(X)                                        MD058085
     D SDTIAC        E DS                  EXTNAME(SDTIAJW0)                                MD058085
      * UPD : Midas SD Trade innovation account types update
      * Current/previous master file format fields for change control
      *
     D*QSDFC1***     E DS                  EXTNAME(SDFCTLL0)                                MD061008
     D QSDFC1          DS                                                                   MD061008
     D  AHFLNM                 1     10                                                     MD061008
     D  AHNORC                11     13P 0                                                  MD061008
     D  AHNOIN                14     16P 0                                                  MD061008
     D  AHNOAM                17     19P 0                                                  MD061008
     D  AHNODL                20     22P 0                                                  MD061008
      * UPD : Midas SD Standing data controls update
     D YARDCS          DS            22
     D WUDELR          DS
     D  WUDR01                 1    250
     D  WUDR02               251    500
     D  WUDR03               501    750
     D  WUDR04               751   1000
     D  WUDR05              1001   1250
     D  WUDR06              1251   1500
     D  WUDR07              1501   1750
     D  WUDR08              1751   2000
     D  WUDR09              2001   2250
     D  WUDR00              2251   2500
     D  WUDR11              2501   2750
     D  WUDR12              2751   3000
      * Data structure for checking for blanks in Basic Number                                CTI099
     D                 DS
     D  WBCNO                  1      6
     D  P1                     1      1
     D  P2                     2      2
     D  P3                     3      3
     D  P4                     4      4
     D  P5                     5      5
     D  P6                     6      6
      * Outward parameters
     D PARC            DS          3064
      * RCD : Midas SD Deleted records file retrieval
      * I :  File name
     D  PAFNME                 1     10
      * I :  Long Key
     D  PALKEY                11     60
      * I :  Deleted Data Record Pt1
     D  PADR01                61    310
      * I :  Deleted Data Record Pt2
     D  PADR02               311    560
      * I :  Deleted Data Record Pt3
     D  PADR03               561    810
      * I :  Deleted Data Record Pt4
     D  PADR04               811   1060
      * I :  Deleted Data Record Pt5
     D  PADR05              1061   1310
      * I :  Deleted Data Record Pt6
     D  PADR06              1311   1560
      * I :  Deleted Data Record Pt7
     D  PADR07              1561   1810
      * I :  Deleted Data Record Pt8
     D  PADR08              1811   2060
      * I :  Deleted Data Record Pt9
     D  PADR09              2061   2310
      * I :  Deleted Data Record Pt10
     D  PADR00              2311   2560
      * I :  Deleted Data Record Pt11
     D  PADR11              2561   2810
      * I :  Deleted Data Record Pt12
     D  PADR12              2811   3060
      * I :  Last Change Date
     D  PALCD               3061   3063P 0
      * I :  Type of Last Change
     D  PATYLC              3064   3064
      *
     D YBRDCS          DS            22
     D*YCRDCS******DS                             41                                          CTI099
     D*YCRDCS***       DS            47                                                     MD058085
     D YCRDCS          DS            48                                                     MD058085
     D YDRDCS          DS            22
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'TI A/c Type Not Entered'
      * Description (35A)
     D  ZA0001                 1     35
      * Basic Number                                                                          CTI099
     D  ZA0002                 1      6
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
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
     C                   MOVEL     *BLANK        WUZAFF           16
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialize subfile header
     C                   MOVEL     'N'           WUDELA                         Deletion Allowe
      * CASE: WRK.Set Up Complete is No
     C     WUSUC         IFEQ      'N'                                          *IF
      * CASE: PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      'CHG'                                        *IF
     C                   MOVEL     'Y'           WUDELA                         Deletion Allowe
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Set up Edit File Footer - Standard Functions  *
     C*****************************************************************
     C*
     C*  Sets up the function key footer text for edit files in which
     C*  records may not be deleted after the system set up flag has
     C*  been set on
     C*
     C*****************************************************************
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If program mode is ADD:
     C*
     C     W0PMD         IFEQ      'ADD'
     C* Setup footer text:
     C* F3=Main Menu   F5=Refresh   F9=Go to 'Change' Mode
     C                   MOVEL     'USR3349'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
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
     C*  If set up is not complete:
     C*
     C     WUSUC         IFEQ      'N'
     C* Setup footer text:
     C* D=Delete   F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode
     C                   MOVEL     'USR3348'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
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
     C* Setup footer text:
     C* F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode
     C                   MOVEL     'USR3354'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
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
     C                   END
      * 00/Copy member SD0035MISH - Trade Innov A/c Types  *
     C/COPY WNCPYSRC,SD0035MISH
      *................................................................
      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    #2C5AT        WZC5AT
     C                   MOVEL     #2C5AT        WZC5AT                         A/c Type
     C     KPOS          KLIST
     C                   KFLD                    GDC5AT                         A/c Type
      * Setup key
     C                   MOVEL     #2C5AT        GDC5AT                         A/c Type
      * 82=EOF
     C*****KPOS*         SETLL     @TIACL1                            82        *           MD058085
      * 82=EOF
     C**N82*****         READ      @TIACL1                              9182    *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ close ACursor                                                                       MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ declare ACursor insensitive scroll cursor for                                       MD058085
     C+ select * from SDTIAJW0                                                              MD058085
     C+ where GDC5AT >= :GDC5AT                                                             MD058085
     C+ order by GDC5AT                                                                     MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ open ACursor                                                                        MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDTIAC                                                MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C                   setoff                                       82                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   seton                                        82                    MD058085
     C                   Endif                                                              MD058085
                                                                                            MD058085
     C                   ELSE
     C                   SETOFF                                       82        *
     C                   END
      * Load subfile page
     C                   EXSR      BBLDSF
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
     C**N82*****         READP     @TIACL1                                90    *           MD058085
     C**N82*****         READ      @TIACL1                                90    *           MD058085
     C                   If        *IN82 = '0'                                              MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch prior from ACursor into :SDTIAC                                               MD058085
     C/END-EXEC                                                                             MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDTIAC                                                MD058085
     C/END-EXEC                                                                             MD058085
     C                   Endif                                                              MD058085
     C                   END
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0            3
     C                   MOVE      *ALL'1'       WKIND1            3
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
     C     W0PMD         IFEQ      'ADD'                                                    MD058085
     C                   eval      SQLCODE = 0                                              MD058085
     C                   ENDIF                                                              MD058085
      * Load next subfile page
     C**N82##RROK        DOWLT     ##SFPG                                       DO          MD058085
     C                   DOW       SQLCODE = 0                                              MD058085
     C                             and ##RROK < ##SFPG                                      MD058085
     C                   ADD       1             ##RR
     C                   MOVEA     WKIND0        *IN(32)
     C                   SETOFF                                       3599
     C                   SETOFF                                       87        *
      * Clear subfile fields
     C                   EXSR      MAIZ#1
      * If CHANGE mode, load subfile fields
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
      * Calculate function fields
     C                   EXSR      DG#2FN
      * Record will be selected unless overridden
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Initialize subfile record (existing record)
     C                   MOVEL     'CHG'         WUPMD                          *Program mode
      * 00/Copy member SD0035MIRE - Trade Innov A/c Types  *
     C/COPY WNCPYSRC,SD0035MIRE
      * If record dropped...
     C                   SUB       1             ##RR
     C     W0RSL         CABNE     'Y'           BB020
     C                   ADD       1             ##RR
      * Validate subfile record and calculate derived fields
     C                   EXSR      DFV2RC
     C                   ELSE
      * USER: Initialize subfile record (new record)
     C                   MOVEL     'ADD'         WUPMD                          *Program mode
      * 00/Copy member SD0035MIRN - Trade Innov A/c Types  *
     C/COPY WNCPYSRC,SD0035MIRN
     C                   END
      * Output to subfile
     C                   ADD       1             ##RROK               81        *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   WRITE     #SFLRCD
     C     BB020         TAG
     C     W0PMD         IFNE      'ADD'
      * 82=EOF
     C**********         READ      @TIACL1                                82    *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDTIAC                                                MD058085
     C/END-EXEC                                                                             MD058085
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
     C                   setoff                                       82                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   seton                                        82                    MD058085
     C                   Endif                                                              MD058085
                                                                                            MD058085
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
      * CALC: Subfile control function fields
      * 00/Copy member SD0035MSFF - Trade Innov A/c Types  *
     C/COPY WNCPYSRC,SD0035MSFF
     C     W0PMD         IFNE      'ADD'
      * Change of position specified
     C     WZC5AT        CASNE     #2C5AT        FBRQRL                         A/c Type
     C                   END
     C                   END
      * USER: Validate subfile control
      * 00/Copy member SD0035MVSC - Trade Innov A/c Types  *
     C/COPY WNCPYSRC,SD0035MVSC
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
      * USER: Process command keys
      * 00/Copy member SD0035MPCK - Trade Innov A/c Types  *
     C/COPY WNCPYSRC,SD0035MPCK
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
     C                   MOVEA     WKIND0        *IN(32)
     C                   SETOFF                                       3599
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
     C     #1C5AT        CABNE     *BLANK        DDEXIT                         A/c Type
     C     #1C5DS        CABNE     *BLANK        DDEXIT                         Description (35
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      * USER: Validate subfile record fields
      * CASE: RCD.Description (35A) is Blank
     C     #1C5DS        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1C5DS        ZA0001                         Description (35
      * Send message 'TI A/c Type Not Entered'
     C                   MOVEL     'USR3512'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
      * 00/Copy member SD0035MVSU - Trade Innov A/c Types  *
     C/COPY WNCPYSRC,SD0035MVSU
      * Validate subfile record relations
     C                   EXSR      DFV2RC
      * A/c Type required
     C     #1C5AT        IFEQ      *BLANK                                       IF
     C                   SETON                                        9833      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *                                                                                       CTI099
      * Validate Basic Number                                                                 CTI099
     C                   MOVEL     #1BCNO        WBCNO
     C                   SETOFF                                       35
     C     #1BCNO        IFNE      *BLANK
      * Check if there are any blanks and report error if there is                            CTI099
     C     P1            IFEQ      *BLANK
     C     P2            OREQ      *BLANK
     C     P3            OREQ      *BLANK
     C     P4            OREQ      *BLANK
     C     P5            OREQ      *BLANK
     C     P6            OREQ      *BLANK
     C                   MOVEL     #1BCNO        ZA0002
     C                   MOVEL     'USR0009'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935
      *                                                                                       CTI099
     C                   ELSE
      *                                                                                       CTI099
     C     W0PMD         IFEQ      'CHG'
     C                   MOVE      #1C5AT        GDCSAV            2
     C                   ENDIF
      ** Check if the basic number used is already allocated to other TI                     BUG3761
      ** account                                                                             BUG3761
      *                                                                                      BUG3761
     C*****WBCNO         SETLL     @TIACL2                                                  MD058085
     C*****WBCNO         CHAIN(N)  @TIACL2                            83                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDTIAC                                                                        MD058085
     C+ from SDTIAJW0                                                                       MD058085
     C+ where GDBCNO = :WBCNO                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       83                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        83                    MD058085
     C                   ENDIF                                                              MD058085
      *                                                                                      BUG4529
      ** Check basic number found is not the one you are amending if in change mode.         BUG4529
      ** otherwise in 'ADD' mode there should be none there already.                         BUG4529
      *                                                                                      BUG4529
     C     W0PMD         IFEQ      'CHG'
     C     GDC5AT        IFEQ      GDCSAV
     C                   SETON                                        83
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG3761
      ** if found then error, else continue with ZALIGN processing                           BUG3761
      *                                                                                      BUG3761
     C     *IN83         IFEQ      '0'
     C                   SETON                                        9935
     C                   MOVEL     'Y2U1032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
      *                                                                                      BUG3761
     C                   MOVEL     *BLANK        WUZASF           16
     C                   MOVEL     #1BCNO        WUZASF                         ZALIGN Screen F
      * Call ZALIGN                                                                           CTI099
      * ZALIGN Screen Field - Standard Functions  *                                           CTI099
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0056            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0057           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0058            1 0          ZALIGN No Of De
     C                   PARM      6             WQ0059            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0060           16            ZALIGN File Fie
      *                                                                                       CTI099
      * Call to program ended in error                                                        CTI099
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'ZALIGN'      W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *                                                                                       CTI099
      * Error detected?                                                                       CTI099
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99
     C                   END
      * CASE: PGM.*Return code is Old Table Error                                             CTI099
     C     W0RTN         IFEQ      '*ERROR*'
     C                   MOVEL     'Y'           WUERCD            1
     C                   ELSE
     C                   MOVEL     'N'           WUERCD
     C                   END
      * CASE: WRK.Err Code is Error Found                                                     CTI099
     C     WUERCD        IFEQ      'Y'
      * Setup message data for message                                                        CTI099
     C                   MOVEL     #1BCNO        ZA0002
     C                   MOVEL     'USR0009'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935
      *                                                                                       CTI099
     C                   ELSE
     C                   Z-ADD     6             YRSW03            5 0
     C                   Z-ADD     14            ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00016
     C     ZQ            ORGT      00016
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  WUZASF:ZQ     #1BCNO                 90
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
     C                   MOVE      WUZAFF        #1BCNO
      *                                                                                       CTI099
      * Is SP101 Basic Number between 0 and 999 ?                                             CTI099
     C     #1BCNO        IFLE      '000000'
     C     #1BCNO        ORGT      '999999'
      *                                                                                       CTI099
      * Setup message data for message                                                        CTI099
     C                   MOVEL     #1BCNO        ZA0002
     C                   MOVEL     'USR0009'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935
      *                                                                                       CTI099
     C                   END
     C                   END
     C                   ENDIF
     C                   END
     C                   END
      * Validate Valid Fund Movement                                                          CTI004
     C                   SETOFF                                       36
     C     #1VLFD        IFNE      'Y'
     C     #1VLFD        ANDNE     'N'
     C                   MOVEL     'USR4177'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936
     C                   END
      *================================================================
     CSR   DEEXIT        ENDSR
      /EJECT
     CSR   DFV2RC        BEGSR
      *================================================================
      * Validate subfile record relations
      *================================================================
      * Calculate function fields
     C                   EXSR      DG#2FN
      * USER: Validate subfile record relations
      * 00/Copy member SD0035MVRR - Trade Innov A/c Types  *
     C/COPY WNCPYSRC,SD0035MVRR
      *================================================================
     CSR   DFEXIT        ENDSR
      /EJECT
     CSR   DG#2FN        BEGSR
      *================================================================
      * Calculate subfile record function fields
      *================================================================
      * CALC: Subfile record function fields
      * 00/Copy member SD0035MRFF - Trade Innov A/c Types  *
     C/COPY WNCPYSRC,SD0035MRFF
      *================================================================
     CSR   DGEXIT        ENDSR
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
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes
     C                   ROLBK
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C                   COMMIT
     C                   END
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
     C                   MOVEA     WKIND0        *IN(32)
     C                   SETOFF                                       3599
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
      * 00/Copy member SD0035MEPA - Trade Innov A/c Types  *
     C/COPY WNCPYSRC,SD0035MEPA
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Trade Innov A/c Ty - Trade Innov A/c Types  *
     C                   EXSR      SACRRC
     C     W0RTN         IFNE      *BLANK
      * Write error detected
      * Screen errors
     C                   MOVEA     WKIND1        *IN(32)
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
      * Delete Trade Innov A/c Ty - Trade Innov A/c Types  *
     C                   EXSR      SCDLRC
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful
      * Screen errors
     C                   MOVEA     WKIND1        *IN(32)
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
      * Change Trade Innov A/c Ty - Trade Innov A/c Types  *
     C                   EXSR      SECHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Screen errors
     C                   MOVEA     WKIND1        *IN(32)
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
     C     WUPMD         IFEQ      'ADD'                                        *IF
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
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1C5AT                         A/c Type
     C                   MOVEL     *BLANK        #1C5DS                         Description (35
     C                   MOVEL     *BLANK        #1BCNO                         Basic Number
     C                   MOVEL     'N'           #1VLFD                         Valid Funds Movement
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @TIACL1 fields to subfile
      *================================================================
     C                   MOVEL     GDTYLC        #1TYLC                         Type of Last Ch
     C                   Z-ADD     GDLCD         #1LCD                          Last Change Dat
     C                   MOVEL     GDC5AT        #1C5AT                         A/c Type
     C                   MOVEL     GDC5DS        #1C5DS                         Description (35
     C     GDBCNO        IFEQ      '000000'
     C                   MOVEL     *BLANKS       #1BCNO                         Basic Number
     C                   ELSE
     C                   MOVEL     GDBCNO        #1BCNO                         Basic Number
     C                   ENDIF
     C                   MOVEL     GDVFFM        #1VLFD                         Valid Funds Movement
      * Hold current record image for change detection
     C                   eval      @1DBRC = SDTIAC                                          MD058085
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2C5AT                         A/c Type
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Trade Innov A/c Ty - Trade Innov A/c Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @TIACL0
     C                   MOVEL     #1C5AT        GDC5AT                         A/c Type
     C                   MOVEL     #1C5DS        GDC5DS                         Description (35
     C                   MOVEL     #1BCNO        GDBCNO                         Basic Number
     C                   MOVEL     #1VLFD        GDVFFM                         Valid Funds Movement
     C                   MOVEL     'I'           GDTYLC                         Type of Last Ch
     C                   Z-ADD     WURDNB        GDLCD                          Last Change Dat
      *
     C     KLCRSA        KLIST
     C                   KFLD                    GDC5AT                         A/c Type
      * Check for duplicate primary key
     C*****KLCRSA        SETLL     @TIACL0                                90    *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDTIAC                                                                        MD058085
     C+ from SDTIAJW0                                                                       MD058085
     C+ where GDC5AT = :GDC5AT                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       90                    MD058085
     C                   If        SQLCODE =  0                                             MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR3505'     W0RTN             7
      * Send message 'Trade Innov A/c Types  EX'
     C                   MOVEL     'USR3505'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   END
      *
     C**********         WRITE     @TIACL0                              91      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ insert into SDTIABTD                                                                MD058085
     C+ (                                                                                   MD058085
     C+   GDC5AT                                                                            MD058085
     C+  ,GDC5DS                                                                            MD058085
     C+  ,GDTYLC                                                                            MD058085
     C+  ,GDLCD                                                                             MD058085
     C+  ,GDBCNO                                                                            MD058085
     C+  ,GDVFFM                                                                            MD058085
     C+  ,GDMODE                                                                            MD058085
     C+ )                                                                                   MD058085
     C+ Values                                                                              MD058085
     C+ (                                                                                   MD058085
     C+   :GDC5AT                                                                           MD058085
     C+  ,:GDC5DS                                                                           MD058085
     C+  ,:GDTYLC                                                                           MD058085
     C+  ,:GDLCD                                                                            MD058085
     C+  ,:GDBCNO                                                                           MD058085
     C+  ,:GDVFFM                                                                           MD058085
     C+  ,'B'                                                                               MD058085
     C+ )                                                                                   MD058085
     C/END-EXEC                                                                             MD058085
     C/EXEC SQL                                                                             MD058085
     C+ insert into SDTIAXTD                                                                MD058085
     C+ (                                                                                   MD058085
     C+   GDC5AT                                                                            MD058085
     C+  ,GDC5DS                                                                            MD058085
     C+  ,GDTYLC                                                                            MD058085
     C+  ,GDLCD                                                                             MD058085
     C+  ,GDBCNO                                                                            MD058085
     C+  ,GDVFFM                                                                            MD058085
     C+  ,GDMODE                                                                            MD058085
     C+ )                                                                                   MD058085
     C+ Values                                                                              MD058085
     C+ (                                                                                   MD058085
     C+   :GDC5AT                                                                           MD058085
     C+  ,:GDC5DS                                                                           MD058085
     C+  ,:GDTYLC                                                                           MD058085
     C+  ,:GDLCD                                                                            MD058085
     C+  ,:GDBCNO                                                                           MD058085
     C+  ,:GDVFFM                                                                           MD058085
     C+  ,'B'                                                                               MD058085
     C+ )                                                                                   MD058085
     C/END-EXEC                                                                             MD058085
      *
     C******IN91         IFEQ      '1'                                                      MD058085
     C     SQLCODE       IFNE      0                                                        MD058085
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SBCHRC
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDTIACPD'    AHFLNM                         Filename
      *
     C     KLCHSB        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSB        CHAIN     @AHREAU                            9091      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*RTV'        ZMODE             4                        MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM      0             AHNORC                                     MD061008
     C                   PARM      0             AHNOIN                                     MD061008
     C                   PARM      0             AHNOAM                                     MD061008
     C                   PARM      0             AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN           10                        MD061008
      *                                                                                     MD061008
     C                   SETOFF                                       9091                  MD061008
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061008
     C                   SETON                                        90                    MD061008
     C                   ENDIF                                                              MD061008
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
      *                                                                                     MD061008
      *
     C     *IN90         IFEQ      '1'
      * Record not found
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
     C                   GOTO      SBEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YARDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*UPD'        ZMODE                                      MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM                    AHNORC                                     MD061008
     C                   PARM                    AHNOIN                                     MD061008
     C                   PARM                    AHNOAM                                     MD061008
     C                   PARM                    AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN                                     MD061008
                                                                                            MD061008
     C                   SETOFF                                       91                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
                                                                                            MD061008
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061008
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCDLRC        BEGSR
      *================================================================
      * Delete Trade Innov A/c Ty - Trade Innov A/c Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @TIACL0
     C                   MOVEL     #1C5AT        GDC5AT                         A/c Type
      *
     C     KLDLSC        KLIST
     C                   KFLD                    GDC5AT                         A/c Type
     C*****KLDLSC        CHAIN     @TIACL0                            9091      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDTIAC                                                                        MD058085
     C+ from SDTIAJW0                                                                       MD058085
     C+ where GDC5AT = :GDC5AT                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9091                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        91                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
      * Check for changed record
     C                   eval      @1DBRC = SDTIAC                                          MD058085
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C*****KLDLSC        SETLL     @TIACL0                            9091      *           MD058085
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C     GDMODE        IFEQ      'C'                                                      MD058085
     C                   MOVEL     'USR0551'     ZAMSID                                     MD058085
     C                   MOVEL     'USR0551'     W0RTN                                      MD058085
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                     MD058085
     C                   EXSR      ZASNMS                                                   MD058085
     C                   GOTO      SCEXIT                                                   MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C**********         DELETE    @TIACL0                              91      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ delete from SDTIABTD                                                                MD058085
     C+ where GDC5AT = :GDC5AT                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C/EXEC SQL                                                                             MD058085
     C+ delete from SDTIAXTD                                                                MD058085
     C+ where GDC5AT = :GDC5AT                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C******IN91         IFEQ      '1'                                                      MD058085
     C     SQLCODE       IFNE      0                                                        MD058085
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDTIACPD'    PAFNME                         File name
     C                   MOVEL     #1C5AT        PALKEY                         Long Key
     C                   MOVEL     WUDR01        PADR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PADR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PADR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PADR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PADR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PADR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PADR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PADR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PADR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PADR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PADR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PADR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PALCD                          Last Change Dat
     C                   MOVEL     'D'           PATYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           RCD: SD Deleted
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0520X'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9833      *
     C                   END
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SDCHRC
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDTIACPD'    AHFLNM                         Filename
      *
     C     KLCHSD        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSD        CHAIN     @AHREAU                            9091      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*RTV'        ZMODE             4                        MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM      0             AHNORC                                     MD061008
     C                   PARM      0             AHNOIN                                     MD061008
     C                   PARM      0             AHNOAM                                     MD061008
     C                   PARM      0             AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN           10                        MD061008
      *                                                                                     MD061008
     C                   SETOFF                                       9091                  MD061008
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061008
     C                   SETON                                        90                    MD061008
     C                   ENDIF                                                              MD061008
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
      *                                                                                     MD061008
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SDEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YBRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   END
      * If changed update record otherwise release record
     C     YBRDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*UPD'        ZMODE                                      MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM                    AHNORC                                     MD061008
     C                   PARM                    AHNOIN                                     MD061008
     C                   PARM                    AHNOAM                                     MD061008
     C                   PARM                    AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN                                     MD061008
                                                                                            MD061008
     C                   SETOFF                                       91                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
                                                                                            MD061008
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061008
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * Change Trade Innov A/c Ty - Trade Innov A/c Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @TIACL0
     C                   MOVEL     #1C5AT        GDC5AT                         A/c Type
      *
     C     KLCHSE        KLIST
     C                   KFLD                    GDC5AT                         A/c Type
     C*****KLCHSE        CHAIN     @TIACL0                            9091      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDTIAC                                                                        MD058085
     C+ from SDTIAJW0                                                                       MD058085
     C+ where GDC5AT = :GDC5AT                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9091                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        91                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
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
      * Check for changed record
     C                   eval      @1DBRC = SDTIAC                                          MD058085
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C**********         UNLOCK    SDTIACL0                             91      *           MD058085
     C                   GOTO      SEEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YCRDCS
      * Move non-key fields to @TIACL0
     C                   MOVEL     #1C5DS        GDC5DS                         Description (35
     C                   MOVEL     #1BCNO        GDBCNO                         Basic Number
     C                   MOVEL     #1VLFD        GDVFFM                         Valid Funds Movement
     C                   MOVEL     'A'           GDTYLC                         Type of Last Ch
     C                   Z-ADD     WURDNB        GDLCD                          Last Change Dat
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
     C**********         UPDATE    @TIACL0                              91      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ update SDTIAXTD set                                                                 MD058085
     C+   GDC5DS = :GDC5DS                                                                  MD058085
     C+  ,GDTYLC = :GDTYLC                                                                  MD058085
     C+  ,GDLCD  = :GDLCD                                                                   MD058085
     C+  ,GDBCNO = :GDBCNO                                                                  MD058085
     C+  ,GDVFFM = :GDVFFM                                                                  MD058085
     C+ where GDC5AT = :GDC5AT                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       91                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        91                    MD058085
     C                   ENDIF                                                              MD058085
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDTIACL0                             91      *           MD058085
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
      * USER: Processing after Data update
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SFCHRC
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YDRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDTIACPD'    AHFLNM                         Filename
      *
     C     KLCHSF        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSD        CHAIN     @AHREAU                            9091      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*RTV'        ZMODE             4                        MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM      0             AHNORC                                     MD061008
     C                   PARM      0             AHNOIN                                     MD061008
     C                   PARM      0             AHNOAM                                     MD061008
     C                   PARM      0             AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN           10                        MD061008
      *                                                                                     MD061008
     C                   SETOFF                                       9091                  MD061008
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061008
     C                   SETON                                        90                    MD061008
     C                   ENDIF                                                              MD061008
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
      *                                                                                     MD061008
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
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YDRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YDRDCS
     C                   MOVE      'Y'           YDRDC
     C                   END
      * If changed update record otherwise release record
     C     YDRDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*UPD'        ZMODE                                      MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM                    AHNORC                                     MD061008
     C                   PARM                    AHNOIN                                     MD061008
     C                   PARM                    AHNOAM                                     MD061008
     C                   PARM                    AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN                                     MD061008
                                                                                            MD061008
     C                   SETOFF                                       91                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
                                                                                            MD061008
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061008
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
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
     C                   PARM      'SDUJEFR'     W0HPMB           10            Help text sourc
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
      * USER: Exit program processing
      * 00/Copy member SD0035MEPP - Trade Innov A/c Types  *
     C/COPY WNCPYSRC,SD0035MEPP
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
     C/EXEC SQL                                                                             MD058085
     C+ close ACursor                                                                       MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
      *
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
      * Define work field Deletion Allowed
     C                   MOVEL     *BLANK        WUDELA            1
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field *Program mode
     C                   MOVEL     *BLANK        WUPMD             3
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field Deleted Data Record Pt1
     C                   MOVEL     *BLANK        WUDR01          250
      * Define work field Deleted Data Record Pt2
     C                   MOVEL     *BLANK        WUDR02          250
      * Define work field Deleted Data Record Pt3
     C                   MOVEL     *BLANK        WUDR03          250
      * Define work field Deleted Data Record Pt4
     C                   MOVEL     *BLANK        WUDR04          250
      * Define work field Deleted Data Record Pt5
     C                   MOVEL     *BLANK        WUDR05          250
      * Define work field Deleted Data Record Pt6
     C                   MOVEL     *BLANK        WUDR06          250
      * Define work field Deleted Data Record Pt7
     C                   MOVEL     *BLANK        WUDR07          250
      * Define work field Deleted Data Record Pt8
     C                   MOVEL     *BLANK        WUDR08          250
      * Define work field Deleted Data Record Pt9
     C                   MOVEL     *BLANK        WUDR09          250
      * Define work field Deleted Data Record Pt10
     C                   MOVEL     *BLANK        WUDR00          250
      * Define work field Deleted Data Record Pt11
     C                   MOVEL     *BLANK        WUDR11          250
      * Define work field Deleted Data Record Pt12
     C                   MOVEL     *BLANK        WUDR12          250
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Open files
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
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
     C                   OPEN      SD0035M#
     C**********         OPEN      SDTIACL1                                                 MD058085
     C**********         OPEN      SDTIACL0                                                 MD058085
     C**********         OPEN      SDFCTLL0                                                 MD061008
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     14            ##SFPG            3 0          SFLPAG
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
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * SD0035M Precompiler - Trade Innov A/c Types  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Copyright Statement 1997 - Standard Functions  * copyright
      * 00/Copy member SD0035MFPG - Trade Innov A/c Types  *
      * 00/Copy member SD0035MEPG - Trade Innov A/c Types  *
      * 00/Copy member SD0035MIPG - Trade Innov A/c Types  *
      * 00/Copy member SD0035MCPG - Trade Innov A/c Types  *
     C/COPY WNCPYSRC,SD0035MCPG
      * 00/Copy member SD0035MOPG - Trade Innov A/c Types  *
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
     C/COPY WNCPYSRC,SD0035MPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0035MPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD058085
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058085
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0035MPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O/COPY WNCPYSRC,SD0035MOPG
**CTDATA CPY@
(c) Finastra International Limited 2001

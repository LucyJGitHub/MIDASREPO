     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas SD Tag Description Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD2040M - Message Tag Descriptions Maintenance Subfile       *
      *                                                               *
      *  Function:  This program alows users to maintain              *
      *             message tag descriptions.                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD060008           Date 11May21               *
      *  Prev Amend No. MD056560           Date 31Aug20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG2145            Date 28Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSW098             Date 02Jul98               *
      *                 CSD003             Date 02Jul98               *
      *                 S01459             Date 02JUL98               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD060008 - Deliverable Data Split for Standing Data 2        *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG2145 - Use variables to hold the values of the subfile    *
      *            record text since MSGID keyword is not allowed in  *
      *            SFLRCD when compiling this display file with       *
      *            multi-language support.                            *
      *  CSW098 - SWIFT 1998 Changes                                  *  *
      *           - New field Message Sequence added.                 *  *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  S01459 - Addition of Midas Headerbox.                        *
      *                                                               *
      *****************************************************************
     FSD2040M#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Message tag descriptions maint subfile
      *
     F*SDMTAGL1* IF   E           K DISK    USROPN                                          MD056560
     F**********                           INFDS(INFDS1)                                    MD056560
     F**********                           INFSR(*PSSR)                                     MD056560
      * RTV : Midas SD Message field tag description retrieval
      *
     F*SDMTPYL1* IF   E           K DISK    USROPN                                          MD060008
     F**********                           INFDS(ID0001)                                    MD060008
     F**********                           INFSR(*PSSR)                                     MD060008
      * RTV : Midas¦ABS SD Message type descriptions retrieval
      *
     F*SDMTAGL0* UF A E           K DISK    USROPN                                          MD056560
     F**********                           COMMIT                                           MD056560
     F**********                           INFDS(ID0002)                                    MD056560
     F**********                           INFSR(*PSSR)                                     MD056560
      * UPD : Midas SD Message field tag description update
      *
     FSDFCTLL0  UF   E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0003)
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Standing data controls update
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
     D*@1DBRC***     E DS                  EXTNAME(SDMTAGL0)                                MD056560
     D @1DBRC        E DS                  EXTNAME(SDMTGJW0)                                MD056560
     D                                     PREFIX(@)                                        MD056560
      * UPD : Midas SD Message field tag description update
      * Current/previous master file format fields for change control
      *
     D QSDFC1        E DS                  EXTNAME(SDFCTLL0)
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
     D YCRDCS          DS           125
     D YDRDCS          DS            22
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D YRSW0A          DS          9999
     D YRSW0B          DS          9999
     D YRSW0C          DS          9999
     D YRSW0D          DS          9999
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D ID0003          DS           528
      * File information data structure
      *
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Key Field
     D  ZA0001                 1     10
      * Message data for 'Key Field Invalid Value'
      * If value in key field
     D  ZA0002                 1      1
      * Key Field
     D  ZA0003                 2     11
      * Message data for 'Screen field descrip mand'
      * Screen Field Description
     D  ZA0004                 1     20
      * Message data for 'ISO field descrip mand'
      * ISO Field Description
     D  ZA0005                 1     30
      * Message data for 'Report field descrip mand'
      * Report/Telex Field Desc.
     D  ZA0006                 1     60
     D SDMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
     D SDMTPY        E DS                  EXTNAME(SDMTYJW0)                                MD060008
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
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      *................................................................
      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    #2MTAG        WZMTAG
     C                   MOVEL     #2MTAG        WZMTAG                         Message Field T
     C     *LIKE         DEFINE    #2MTPY        WZMTPY
     C                   MOVEL     #2MTPY        WZMTPY                         Message Type
     C     *LIKE         DEFINE    #2MSEQ        WZMSEQ                                        CSW09
     C                   MOVEL     #2MSEQ        WZMSEQ                                        CSW09
     C     KPOS          KLIST
     C                   KFLD                    EFMTAG                         Message Field T
     C                   KFLD                    EFMTPY                         Message Type
     C                   KFLD                    EFMSEQ                                        CSW09
      * Setup key
     C                   MOVEL     #2MTAG        EFMTAG                         Message Field T
     C                   MOVEL     #2MTPY        EFMTPY                         Message Type
     C                   MOVEL     #2MSEQ        EFMSEQ                                        CSW09
      * 82=EOF
     C*****KPOS*         SETLL     @EFREJ5                            82        *           MD056560
      * 82=EOF
     C**N82*****         READ      @EFREJ5                              9182    *           MD056560
     C/EXEC SQL                                                                             MD056560
     C+ declare ACursor insensitive scroll cursor for                                       MD056560
     C+ select * from SDMTGJW0                                                              MD056560
     C+ where EFMTAG >= :EFMTAG and EFMTPY >= :EFMTPY and EFMSEQ >= :EFMSEQ                 MD056560
     C+ order by EFMTAG, EFMTPY, EFMSEQ                                                     MD056560
     C/END-EXEC                                                                             MD056560
                                                                                            MD056560
     C/EXEC SQL                                                                             MD056560
     C+ close ACursor                                                                       MD056560
     C/END-EXEC                                                                             MD056560
                                                                                            MD056560
     C/EXEC SQL                                                                             MD056560
     C+ open ACursor                                                                        MD056560
     C/END-EXEC                                                                             MD056560
                                                                                            MD056560
     C/EXEC SQL                                                                             MD056560
     C+ fetch next from ACursor into :SDMTAG                                                MD056560
     C/END-EXEC                                                                             MD056560
                                                                                            MD056560
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
     C**N82*****         READP     @EFREJ5                                90    *           MD056560
     C**N82*****         READ      @EFREJ5                                90    *           MD056560
     C     *IN82         IFEQ      '0'                                                      MD056560
     C/EXEC SQL                                                                             MD056560
     C+ fetch prior from ACursor into :SDMTAG                                               MD056560
     C/END-EXEC                                                                             MD056560
     C/EXEC SQL                                                                             MD056560
     C+ fetch next from ACursor into :SDMTAG                                                MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF                                                              MD056560
     C                   END
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0            7
     C                   MOVE      *ALL'1'       WKIND1            7
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
     C**N82##RROK        DOWLT     ##SFLN                                       DO          MD056560
     C                   DOW       SQLCODE = 0                                              MD056560
     C                             and ##RROK < ##SFLN                                      MD056560
     C                   ADD       1             ##RR
     C                   MOVEA     WKIND0        *IN(33)
     C                   MOVE      *OFF          *IN28                                  CSW098
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
     C**********         READ      @EFREJ5                                82    *           MD056560
     C/EXEC SQL                                                                             MD056560
     C+ fetch next from ACursor into :SDMTAG                                                MD056560
     C/END-EXEC                                                                             MD056560
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
      * Change of position specified
     C     WZMTAG        CASNE     #2MTAG        FBRQRL                         Message Field T
     C     WZMTPY        CASNE     #2MTPY        FBRQRL                         Message Type
     C     WZMSEQ        CASNE     #2MSEQ        FBRQRL                                        CSW09
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
     C                   MOVE      *OFF          *IN28                                         CSW09
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
     C     #1MTAG        CABNE     *BLANK        DDEXIT                         Message Field T
     C     #1MTPY        CABNE     *BLANK        DDEXIT                         Message Type
     C     #1MSEQ        CABNE     *BLANK        DDEXIT                                        CSW09
     C     #1SCFD        CABNE     *BLANK        DDEXIT                         Screen Field De
     C     #1ISFD        CABNE     *BLANK        DDEXIT                         ISO Field Descr
     C     #1RPFD        CABNE     *BLANK        DDEXIT                         Report/Telex Fi
     C     #1TAGF        CABNE     *BLANK        DDEXIT                         Tag Format
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      * Validate Tag Format
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1TAGF        W0NSRQ            1            Tag Format
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1157848       Y2LSNO            7 0
     C     #1TAGF        PARM      #1TAGF        W0EXVL           20            Tag Format
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * USER: Validate subfile record fields
     C                   MOVEL     #1MTAG        WUTQKF                         Test ? in Key F
     C                   MOVEL     #1MTAG        WUIVKF                         If value in key
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1MTAG        ZA0001                         Message Field T
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   ELSE
      * CASE: WRK.Test ? in Key Field is Asterisk
     C     WUTQKF        IFEQ      '*'                                          *IF
      * Setup message data for message
     C                   MOVEL     WUIVKF        ZA0002                         If value in key
     C                   MOVEL     #1MTAG        ZA0003                         Message Field T
      * Send message 'Key Field Invalid Value'
     C                   MOVEL     'USR0849'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *                                                                   CSW098
      ** ? not allowed for Message Sequence                               CSW098
     C                   MOVEL     #1MSEQ        WUTQKF                                        CSW09
     C     WUTQKF        IFEQ      '?'                                                         CSW09
     C                   MOVEL     #1MSEQ        ZA0001                                        CSW09
     C                   MOVEL     'USR0380'     ZAMSID                                        CSW09
     C                   EXSR      ZASNMS                                                      CSW09
     C                   SETON                                        9828                     CSW09
     C                   ENDIF                                                                 CSW09
     C*
      * CASE: RCD.Screen Field Description is blank
     C     #1SCFD        IFEQ      '*blank'                                     *IF
      * Setup message data for message
     C                   MOVEL     #1SCFD        ZA0004                         Screen Field De
      * Send message 'Screen field descrip mand'
     C                   MOVEL     'USR1559'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9836      *
      *
     C                   END                                                    *FI
      * CASE: RCD.ISO Field Description is blank
     C     #1ISFD        IFEQ      '*blank'                                     *IF
      * Setup message data for message
     C                   MOVEL     #1ISFD        ZA0005                         ISO Field Descr
      * Send message 'ISO field descrip mand'
     C                   MOVEL     'USR1560'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9837      *
      *
     C                   END                                                    *FI
      * CASE: RCD.Report/Telex Field Desc. is blank
     C     #1RPFD        IFEQ      '*blank'                                     *IF
      * Setup message data for message
     C                   MOVEL     #1RPFD        ZA0006                         Report/Telex Fi
      * Send message 'Report field descrip mand'
     C                   MOVEL     'USR1561'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9838      *
      *
     C                   END                                                    *FI
      * Validate subfile record relations
     C                   EXSR      DFV2RC
      * Message Field Tag required
     C     #1MTAG        IFEQ      *BLANK                                       IF
     C                   SETON                                        9834      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Message Type required
     C     #1MTPY        IFEQ      *BLANK                                       IF
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
      * Check reference to Message Type Descriptions
     C                   EXSR      VACKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9835      *
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
     C                   MOVEA     WKIND0        *IN(33)
     C                   MOVE      *OFF          *IN28                                         CSW09
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
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Message Field Tag - Message Field Tag Desc  *
     C                   EXSR      SACRRC
     C     W0RTN         IFNE      *BLANK
      * Write error detected
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
     C     *IN78         IFEQ      *ON                                                         CSW09
     C                   MOVE      *ON           *IN28                                         CSW09
     C                   ENDIF                                                                 CSW09
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
      * Delete Message Field Tag - Message Field Tag Desc  *
     C                   EXSR      SCDLRC
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
     C     *IN78         IFEQ      *ON                                                         CSW09
     C                   MOVE      *ON           *IN28                                         CSW09
     C                   ENDIF                                                                 CSW09
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
      * Change Message Field Tag - Message Field Tag Desc  *
     C                   EXSR      SECHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
     C     *IN78         IFEQ      *ON                                                         CSW09
     C                   MOVE      *ON           *IN28                                         CSW09
     C                   ENDIF                                                                 CSW09
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
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1MTAG                         Message Field T
     C                   MOVEL     *BLANK        #1MTPY                         Message Type
     C                   MOVEL     *BLANK        #1MSEQ                                        CSW09
     C                   MOVEL     *BLANK        #1SCFD                         Screen Field De
     C                   MOVEL     *BLANK        #1ISFD                         ISO Field Descr
     C                   MOVEL     *BLANK        #1RPFD                         Report/Telex Fi
     C                   MOVEL     *BLANK        #1TAGF                         Tag Format
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @EFREJ5 fields to subfile
      *================================================================
     C                   Z-ADD     EFLCD         #1LCD                          Last Change Dat
     C                   MOVEL     EFTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     EFMTAG        #1MTAG                         Message Field T
     C                   MOVEL     EFMTPY        #1MTPY                         Message Type
     C                   MOVEL     EFMSEQ        #1MSEQ                                        CSW09
     C                   MOVEL     EFSCFD        #1SCFD                         Screen Field De
     C                   MOVEL     EFISFD        #1ISFD                         ISO Field Descr
     C                   MOVEL     EFRPFD        #1RPFD                         Report/Telex Fi
     C                   MOVEL     EFTAGF        #1TAGF                         Tag Format
     C                   MOVEL     EFMODE        #1MODE                                     MD056560
      * Hold current record image for change detection
     C                   eval      @1DBRC = SDMTAG                                          MD056560
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2MTAG                         Message Field T
     C                   MOVEL     *BLANK        #2MTPY                         Message Type
     C                   MOVEL     *BLANK        #2MSEQ                                        CSW09
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Message Field Tag - Message Field Tag Desc  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @EFREJ4
     C                   MOVEL     #1MTAG        EFMTAG                         Message Field T
     C                   MOVEL     #1MTPY        EFMTPY                         Message Type
     C                   MOVEL     #1MSEQ        EFMSEQ                                        CSW09
     C                   MOVEL     #1SCFD        EFSCFD                         Screen Field De
     C                   MOVEL     #1RPFD        EFRPFD                         Report/Telex Fi
     C                   MOVEL     #1ISFD        EFISFD                         ISO Field Descr
     C                   MOVEL     #1TAGF        EFTAGF                         Tag Format
     C                   Z-ADD     WURDNB        EFLCD                          Last Change Dat
     C                   MOVEL     'I'           EFTYLC                         Type of Last Ch
      *
     C     KLCRSA        KLIST
     C                   KFLD                    EFMTAG                         Message Field T
     C                   KFLD                    EFMTPY                         Message Type
     C                   KFLD                    EFMSEQ                                        CSW09
      * Check for duplicate primary key
     C*****KLCRSA        SETLL     @EFREJ4                                90    *           MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN90         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 0                                              MD056560
     C                   MOVEL     'USR1542'     W0RTN             7
      * Send message 'Message Field Tag Desc EX'
     C                   MOVEL     'USR1542'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   END
      *
     C**********         WRITE     @EFREJ4                              91      *           MD056560
     C/EXEC SQL                                                                             MD056560
     C+ insert into SDMTGBTD                                                                MD056560
     C+ (                                                                                   MD056560
     C+   EFMTAG                                                                            MD056560
     C+ , EFMTPY                                                                            MD056560
     C+ , EFSCFD                                                                            MD056560
     C+ , EFRPFD                                                                            MD056560
     C+ , EFISFD                                                                            MD056560
     C+ , EFTAGF                                                                            MD056560
     C+ , EFLCD                                                                             MD056560
     C+ , EFTYLC                                                                            MD056560
     C+ , EFMSEQ                                                                            MD056560
     C+ , EFMODE                                                                            MD056560
     C+ )                                                                                   MD056560
     C+ Values                                                                              MD056560
     C+ (                                                                                   MD056560
     C+   :EFMTAG                                                                           MD056560
     C+ , :EFMTPY                                                                           MD056560
     C+ , :EFSCFD                                                                           MD056560
     C+ , :EFRPFD                                                                           MD056560
     C+ , :EFISFD                                                                           MD056560
     C+ , :EFTAGF                                                                           MD056560
     C+ , :EFLCD                                                                            MD056560
     C+ , :EFTYLC                                                                           MD056560
     C+ , :EFMSEQ                                                                           MD056560
     C+ , 'B'                                                                               MD056560
     C+ )                                                                                   MD056560
     C/END-EXEC                                                                             MD056560
     C/EXEC SQL                                                                             MD056560
     C+ insert into SDMTGXTD                                                                MD056560
     C+ (                                                                                   MD056560
     C+   EFMTAG                                                                            MD056560
     C+ , EFMTPY                                                                            MD056560
     C+ , EFSCFD                                                                            MD056560
     C+ , EFRPFD                                                                            MD056560
     C+ , EFISFD                                                                            MD056560
     C+ , EFTAGF                                                                            MD056560
     C+ , EFLCD                                                                             MD056560
     C+ , EFTYLC                                                                            MD056560
     C+ , EFMSEQ                                                                            MD056560
     C+ , EFMODE                                                                            MD056560
     C+ )                                                                                   MD056560
     C+ Values                                                                              MD056560
     C+ (                                                                                   MD056560
     C+   :EFMTAG                                                                           MD056560
     C+ , :EFMTPY                                                                           MD056560
     C+ , :EFSCFD                                                                           MD056560
     C+ , :EFRPFD                                                                           MD056560
     C+ , :EFISFD                                                                           MD056560
     C+ , :EFTAGF                                                                           MD056560
     C+ , :EFLCD                                                                            MD056560
     C+ , :EFTYLC                                                                           MD056560
     C+ , :EFMSEQ                                                                           MD056560
     C+ , 'B'                                                                               MD056560
     C+ )                                                                                   MD056560
     C/END-EXEC                                                                             MD056560
      *
     C******IN91         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE <> 0                                             MD056560
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
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
     C                   MOVEL     'SDMTAGPD'    AHFLNM                         Filename
      *
     C     KLCHSB        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSB        CHAIN     @AHREAU                            9091      *
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
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
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
      * Delete Message Field Tag - Message Field Tag Desc  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @EFREJ4
     C                   MOVEL     #1MTAG        EFMTAG                         Message Field T
     C                   MOVEL     #1MTPY        EFMTPY                         Message Type
     C                   MOVEL     #1MSEQ        EFMSEQ                                        CSW09
      *
     C     KLDLSC        KLIST
     C                   KFLD                    EFMTAG                         Message Field T
     C                   KFLD                    EFMTPY                         Message Type
     C                   KFLD                    EFMSEQ                                        CSW09
     C*****KLDLSC        CHAIN     @EFREJ4                            9091      *           MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN90         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
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
      * Do not allow deletion of core record                                                MD056560
     C     EFMODE        IFEQ      'C'                                                      MD056560
     C                   MOVEL     'USR0545'     ZAMSID                                     MD056560
     C                   MOVEL     'USR0545'     W0RTN                                      MD056560
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                     MD056560
     C                   EXSR      ZASNMS                                                   MD056560
     C                   GOTO      SCEXIT                                                   MD056560
     C                   ENDIF                                                              MD056560
                                                                                            MD056560
      * Check for changed record
     C                   eval      @1DBRC = SDMTAG                                          MD056560
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C*****KLDLSC        SETLL     @EFREJ4                            9091      *           MD056560
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C**********         DELETE    @EFREJ4                              91      *           MD056560
     C/EXEC SQL                                                                             MD056560
     C+ delete from SDMTGBTD                                                                MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C/EXEC SQL                                                                             MD056560
     C+ delete from SDMTGXTD                                                                MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN91         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE <> 0                                             MD056560
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   eval      @1DBRC = SDMTAG                                          MD056560
     C                   MOVEL     @1DBRC        WUDELR
      * Concat the two part key into one field
     C     #1MTAG        CAT(P)    #1MTPY        WULKEY                         Long Key
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDMTAGPD'    PAFNME                         File name
     C                   MOVEL     WULKEY        PALKEY                         Long Key
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
     C                   SETON                                        98        *
     C                   END
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     1             WUNODL                         No. of Deletes
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
     C                   MOVEL     'SDMTAGPD'    AHFLNM                         Filename
      *
     C     KLCHSD        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSD        CHAIN     @AHREAU                            9091      *
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
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
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
      * Change Message Field Tag - Message Field Tag Desc  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @EFREJ4
     C                   MOVEL     #1MTAG        EFMTAG                         Message Field T
     C                   MOVEL     #1MTPY        EFMTPY                         Message Type
     C                   MOVEL     #1MSEQ        EFMSEQ                         Message Type   CSW09
      *
     C     KLCHSE        KLIST
     C                   KFLD                    EFMTAG                         Message Field T
     C                   KFLD                    EFMTPY                         Message Type
     C                   KFLD                    EFMSEQ                                        CSW09
     C*****KLCHSF        CHAIN     @EFREJ4                            9091      *           MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
      *
     C******IN90         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
      *
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
     C                   eval      @1DBRC = SDMTAG                                          MD056560
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C**********         UNLOCK    SDMTAGL0                             91      *           MD056560
     C                   GOTO      SEEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YCRDCS
      * Move non-key fields to @EFREJ4
     C                   MOVEL     #1SCFD        EFSCFD                         Screen Field De
     C                   MOVEL     #1RPFD        EFRPFD                         Report/Telex Fi
     C                   MOVEL     #1ISFD        EFISFD                         ISO Field Descr
     C                   MOVEL     #1TAGF        EFTAGF                         Tag Format
     C                   Z-ADD     WURDNB        EFLCD                          Last Change Dat
     C                   MOVEL     'A'           EFTYLC                         Type of Last Ch
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
     C**********         UPDATE    @EFREJ4                              91      *           MD056560
     C/EXEC SQL                                                                             MD056560
     C+ update SDMTGXTD                                                                     MD056560
     C+  SET EFSCFD = :EFSCFD                                                               MD056560
     C+  ,   EFRPFD = :EFRPFD                                                               MD056560
     C+  ,   EFISFD = :EFISFD                                                               MD056560
     C+  ,   EFTAGF = :EFTAGF                                                               MD056560
     C+  ,   EFLCD  = :EFLCD                                                                MD056560
     C+  ,   EFTYLC = :EFTYLC                                                               MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDMTAGL0                             91      *           MD056560
     C                   END
     C******IN91         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE <> 0                                             MD056560
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   eval      @1DBRC = SDMTAG                                          MD056560
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
     C                   MOVEL     'SDMTAGPD'    AHFLNM                         Filename
      *
     C     KLCHSF        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSF        CHAIN     @AHREAU                            9091      *
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
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
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
     CSR   VACKRL        BEGSR
      *================================================================
      * Check reference to Message Type Descriptions
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Name search required?
     C                   MOVEL     #1MTPY        WK1X01            1
     C     WK1X01        IFEQ      '?'                                          Message Type
     C                   CALL      'SD2030S'                            90      Select Message
     C                   PARM      *BLANK        W0RTN             7
     C     #1MTPY        PARM      #1MTPY        WQ0001            3            Message Type
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD2030S'     W0CLPG
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
     C                   SETON                                        9835      *
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
     C     #1MTPY        IFEQ      *BLANK                                       Message Type
     C                   GOTO      VAEXIT
     C                   END
      *
     C     KLVAEE        KLIST
     C                   KFLD                    EEMTPY                         Message Type
      * Setup key
     C                   MOVEL     #1MTPY        EEMTPY                         Message Type
     C*****KLVAEE        CHAIN     @EEREJ2                            9091      *           MD060008
     C/EXEC SQL                                                                             MD060008
     C+ SELECT *                                                                            MD060008
     C+ into :SDMTPY                                                                        MD060008
     C+ from SDMTYJW0                                                                       MD060008
     C+ where EEMTPY = :EEMTPY                                                              MD060008
     C/END-EXEC                                                                             MD060008
     C******IN90         IFEQ      '0'                                                      MD060008
     C     SQLCODE       IFEQ      0                                                        MD060008
      * Record found - move back any virtuals
     C                   GOTO      VAEXIT
     C                   END
      * Send message 'Message Type Descripti NF'
     C                   MOVEL     'USR1539'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'USR1539'     W0RTN
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
     C/EXEC SQL                                                                             MD060008
     C+ close ACursor                                                                       MD060008
     C/END-EXEC                                                                             MD060008
                                                                                            MD060008
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
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field If value in key field
     C                   MOVEL     *BLANK        WUIVKF            1
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field Long Key
     C                   MOVEL     *BLANK        WULKEY           50
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
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
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
     C                   Z-ADD     *ZEROS        YRSW00            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW01            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW02            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW03            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW04            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW05            5 0          *Synon (5,0) wo
     C                   MOVEL     *BLANKS       YRSW06            1            *String work fi
     C                   MOVEL     *BLANKS       YRSW07            1            *String work fi
     C                   MOVEL     *BLANKS       YRSW08            7            *Return code
     C                   MOVEL     *BLANKS       YRSW09            1            *String work fi
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0A                         *Synon (9999) w
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0B                         *Synon (9999) w
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0C                         *Synon (9999) w
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0D                         *Synon (9999) w
     C                   MOVEL     *BLANKS       YRSW0E            1            *String work fi
     C                   MOVEL     *BLANKS       YRSW0F            1            *String work fi
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
     C                   OPEN      SD2040M#
     C**********         OPEN      SDMTAGL1                                                 MD056560
     C**********         OPEN      SDMTPYL1                                                 MD060008
     C**********         OPEN      SDMTAGL0                                                 MD056560
     C                   OPEN      SDFCTLL0
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     04            ##SFPG            3 0          SFLPAG
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
      * SD2040M Precompiler - Message Field Tag Desc  *
      * Copyright Statement 1988 - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
     C*                                                                   CSW098
     C                   CALL      'SWIFT98'                                                   CSW09
     C                   PARM                    SWRTN             7                           CSW09
     C     SWRTN         IFEQ      'CSW098 '                                                   CSW09
     C                   MOVE      *ON           *IN78                                         CSW09
     C                   ENDIF                                                                 CSW09
     C*                                                                   CSW098
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      *                                                                                      BUG2145
     C                   MOVEL     'USR9880'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        RPTDSC
      *                                                                                      BUG2145
     C                   MOVEL     'USR9881'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        TAGFMT
      *                                                                                      BUG2145
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
      *****************************************************************                      BUG2145
      * SRTEXT  -  Set up text from message file                      *                      BUG2145
      * Called by: All subroutines setting of texts                   *                      BUG2145
      * Calls    : None                                               *                      BUG2145
      *****************************************************************                      BUG2145
     C     SRTEXT        BEGSR
      *                                                                                      BUG2145
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM                    ZAMSID                         Message Id.
     C                   PARM                    ZAMSGF                         Message file.
     C                   PARM                    ZAMSDA                         Message data.
     C                   PARM                    ZAMSTX          132            Messge text
      *                                                                                      BUG2145
     C                   ENDSR
      /EJECT                                                                                 BUG2145
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
     C/COPY WNCPYSRC,SD2040MPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD2040MPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD056560
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD056560
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD2040MPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001

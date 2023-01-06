     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058755
/*STD *  RPGSQLBND                                                    *                     MD058755
/*EXI *  TEXT('Midas SD Retail transaction types maint subfile')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0130M - Midas SD Retail Transactions Types Maintenance     *
      *                                                               *
      *  Function:  This sub-file program allows the user to maintain *
      *             from a list of retail transactions                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058755           Date 01Sep21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD003             Date 01Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01413             Date 29MAR94               *
      *                 S01459             Date 29MAR94               *
      *                 031807             Date 22SEP92               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058755 - Deliverable Data Split for SDRETRPD and TABLETZ   *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  S01413 - Retail 3 incorporation:                             *
      *           - Add Account Commissions Indicator.                *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *  031807 - The Return Code should be specified in Factor 1     *
      *           of the parameter field, else the program will not   *
      *           detect an error in the Background Update program.   *
      *                                                               *
      *****************************************************************
     FSD0130M#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Retail transaction types maint
      *
     F*SDRETRL1* IF   E           K DISK    USROPN                                          MD058755
     F**********                           INFDS(INFDS1)                                    MD058755
     F**********                           INFSR(*PSSR)                                     MD058755
      * RTV : Retail Transaction Types  Retrieval index
      *
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas modules retrieval file
      *
     F*SDRETRL0* UF A E           K DISK    USROPN                                          MD058755
     F**********                           COMMIT                                           MD058755
     F**********                           INFDS(ID0002)                                    MD058755
     F**********                           INFSR(*PSSR)                                     MD058755
      * UPD : Retail Transaction Types  Update index
      *
     FSDFCTLL0  UF   E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0003)
     F                                     INFSR(*PSSR)
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
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D*@1DBRC***     E DS                  EXTNAME(SDRETRL0)                                MD058755
     D @1DBRC        E DS                  EXTNAME(SDRTRJW0)                                MD058755
     D                                     PREFIX(X)                                        MD058755
     D SDRETR        E DS                  EXTNAME(SDRTRJW0)                                MD058755
      * UPD : Retail Transaction Types  Update index
      * Current/previous master file format fields for change control
      *
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
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     array
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
      * Message data for 'Account Comm ind invalid'
      * Account Commission Ind
     D  ZA0001                 1      1
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0002                 1     10
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0003                 1     10
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
      * USER: Initialize subfile header
     C                   MOVEL     'N'           WUDELA                         Deletion Allowe
      * CASE: WRK.Set Up Complete is No
     C     WUSUC         IFEQ      'N'                                          *IF
      * CASE: PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      'CHG'                                        *IF
     C                   MOVEL     'Y'           WUDELA                         Deletion Allowe
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Set Up Function Key Text - Standard Functions  *
     C*
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
     C     W0PMD         IFEQ      'CHG'
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
     C                   END
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
     C                   END
      *................................................................
      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    #2RTTY        WZRTTY
     C                   MOVEL     #2RTTY        WZRTTY                         Retail Transact
     C     KPOS          KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Setup key
     C                   MOVEL     #2RTTY        A1RTTY                         Retail Transact
      * 82=EOF
     C*****KPOS*         SETLL     @A1RECX                            82        *           MD058755
      * 82=EOF
     C**N82*****         READ      @A1RECX                              9182    *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ close ACursor                                                                       MD058755
     C/END-EXEC                                                                             MD058755
                                                                                            MD058755
     C/EXEC SQL                                                                             MD058755
     C+ declare ACursor insensitive scroll cursor for                                       MD058755
     C+ select * from SDRTRJW0                                                              MD058755
     C+ where A1RTTY >= :A1RTTY                                                             MD058755
     C+ order by A1RTTY                                                                     MD058755
     C/END-EXEC                                                                             MD058755
                                                                                            MD058755
     C/EXEC SQL                                                                             MD058755
     C+ open ACursor                                                                        MD058755
     C/END-EXEC                                                                             MD058755
                                                                                            MD058755
     C/EXEC SQL                                                                             MD058755
     C+ fetch next from ACursor into :SDRETR                                                MD058755
     C/END-EXEC                                                                             MD058755
                                                                                            MD058755
     C                   setoff                                       82                    MD058755
     C                   If        SQLCODE = 100                                            MD058755
     C                   seton                                        82                    MD058755
     C                   Endif                                                              MD058755
                                                                                            MD058755
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
     C**N82*****         READP     @A1RECX                                90    *           MD058755
     C**N82*****         READ      @A1RECX                                90    *           MD058755
     C                   If        *IN82 = '0'                                              MD058755
     C/EXEC SQL                                                                             MD058755
     C+ fetch prior from ACursor into :SDRETR                                               MD058755
     C/END-EXEC                                                                             MD058755
     C/EXEC SQL                                                                             MD058755
     C+ fetch next from ACursor into :SDRETR                                                MD058755
     C/END-EXEC                                                                             MD058755
     C                   Endif                                                              MD058755
     C                   END
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0            8
     C                   MOVE      *ALL'1'       WKIND1            8
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
     C**N82##RROK        DOWLT     ##SFLN                                       DO          MD058755
     C                   DOW       SQLCODE = 0                                              MD058755
     C                             and ##RROK < ##SFLN                                      MD058755
     C                   ADD       1             ##RR
     C                   MOVEA     WKIND0        *IN(32)
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
     C**********         READ      @A1RECX                                82    *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ fetch next from ACursor into :SDRETR                                                MD058755
     C/END-EXEC                                                                             MD058755
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
     C                   setoff                                       82                    MD058755
     C                   If        SQLCODE = 100                                            MD058755
     C                   seton                                        82                    MD058755
     C                   Endif                                                              MD058755
                                                                                            MD058755
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
     C     WZRTTY        CASNE     #2RTTY        FBRQRL                         Retail Transact
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
     C                   MOVEA     WKIND0        *IN(32)
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
     C     #1RTTY        CABNE     *BLANK        DDEXIT                         Retail Transact
     C     #1RTNM        CABNE     *BLANK        DDEXIT                         Retail Transact
     C     #1COIN        CABNE     *BLANK        DDEXIT                         Customer Origin
     C     #1DCIN        CABNE     *BLANK        DDEXIT                         Debit/Credit In
     C     #1RVIN        CABNE     *BLANK        DDEXIT                         Reversal Indica
     C     #1PADI        CABNE     *BLANK        DDEXIT                         Print Advices I
     C     #1ACOM        CABNE     *BLANK        DDEXIT                         Account Commiss
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      * Check Retail Transaction Type is numeric
     C                   MOVEL     *IN90         XG90              1
     C                   TESTN                   #1RTTY               90  90    *
     C   90              MOVE      #1RTTY        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90    *
      * All blank is OK
     C  N90#1RTTY        COMP      *BLANKS                                90    *
      * '?' is OK
     C  N90              MOVEL     #1RTTY        XGX1
     C  N90XGX1          COMP      '?'                                    90    *
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   MOVEL     'Y2U0010'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
     C                   END
     C                   MOVEL     XG90          *IN90
      * Validate Customer Originated Ind.
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1COIN        W0NSRQ            1            Customer Origin
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1136213       Y2LSNO            7 0
     C     #1COIN        PARM      #1COIN        W0EXVL           20            Customer Origin
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      * Validate Debit/Credit Indicator
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1DCIN        W0NSRQ            1            Debit/Credit In
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100774       Y2LSNO            7 0
     C     #1DCIN        PARM      #1DCIN        W0EXVL           20            Debit/Credit In
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      * Validate Reversal Indicator
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1RVIN        W0NSRQ            1            Reversal Indica
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1102174       Y2LSNO            7 0
     C     #1RVIN        PARM      #1RVIN        W0EXVL           20            Reversal Indica
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      * Validate Print Advices Indicator
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1PADI        W0NSRQ            1            Print Advices I
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1136213       Y2LSNO            7 0
     C     #1PADI        PARM      #1PADI        W0EXVL           20            Print Advices I
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      * Validate Account Commission Ind
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1ACOM        W0NSRQ            1            Account Commiss
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1170047       Y2LSNO            7 0
     C     #1ACOM        PARM      #1ACOM        W0EXVL           20            Account Commiss
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      * USER: Validate subfile record fields
      * start S01413
      * Validate Account Commissions indicator if displayed
      * CASE: WRK.Account Comm. Ind.display is Yes
     C     WUACID        IFEQ      'Y'                                          *IF
      * CASE: RCD.Account Commission Ind is Blank
     C     #1ACOM        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           #1ACOM                         Account Commiss
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Account Commission Ind is Valid values
     C     #1ACOM        IFEQ      'N'                                          *IF
     C     #1ACOM        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1ACOM        ZA0001                         Account Commiss
      * Send message 'Account Comm ind invalid'
     C                   MOVEL     'USR1958'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9839      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * end S01413
      * Validate subfile record relations
     C                   EXSR      DFV2RC
      * Retail Transaction Type required
     C     #1RTTY        IFEQ      *BLANK                                       IF
     C                   SETON                                        9833      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Retail Transaction Name required
     C     #1RTNM        IFEQ      *BLANK                                       IF
     C                   SETON                                        9834      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Customer Originated Ind. required
     C     #1COIN        IFEQ      *BLANK                                       IF
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
     C                   MOVEA     WKIND0        *IN(32)
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
      * One or more parameters have been defaulted.
      * Field '(RCD) #1ACOM' defaulted for 'Account Commission Ind'.
      * Create Retail Transaction - Retail Transaction Types  *
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
      * Delete Retail Transaction - Retail Transaction Types  *
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
      * One or more parameters have been defaulted.
      * Field '(RCD) #1ACOM' defaulted for 'Account Commission Ind'.
      * Change Retail Transaction - Retail Transaction Types  *
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
     C                   MOVEL     *IN87         *IN78
     C     WUDELA        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   MOVEL     *IN87         *IN77
     C     WUCRIN        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN77
     C                   END                                                    *FI
     C                   MOVEL     *IN87         *IN76
     C     WUACID        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN76
     C                   END                                                    *FI
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
     C                   MOVEL     '0'           *IN79
     C     WUACID        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
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
     C                   MOVEL     *BLANK        #1RTTY                         Retail Transact
     C                   MOVEL     *BLANK        #1RTNM                         Retail Transact
     C                   MOVEL     *BLANK        #1COIN                         Customer Origin
     C                   MOVEL     *BLANK        #1DCIN                         Debit/Credit In
     C                   MOVEL     *BLANK        #1RVIN                         Reversal Indica
     C                   MOVEL     *BLANK        #1PADI                         Print Advices I
     C                   MOVEL     *BLANK        #1ACOM                         Account Commiss
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @A1RECX fields to subfile
      *================================================================
     C                   Z-ADD     A1LCD         #1LCD                          Last Change Dat
     C                   MOVEL     A1TYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     A1RTTY        #1RTTY                         Retail Transact
     C                   MOVEL     A1RTNM        #1RTNM                         Retail Transact
     C                   MOVEL     A1COIN        #1COIN                         Customer Origin
     C                   MOVEL     A1DCIN        #1DCIN                         Debit/Credit In
     C                   MOVEL     A1RVIN        #1RVIN                         Reversal Indica
     C                   MOVEL     A1PADI        #1PADI                         Print Advices I
     C                   MOVEL     A1ACOM        #1ACOM                         Account Commiss
      * Hold current record image for change detection
     C                   eval      @1DBRC = SDRETR                                          MD058755
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2RTTY                         Retail Transact
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Retail Transaction - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @A1RECW
     C                   MOVEL     #1RTTY        A1RTTY                         Retail Transact
     C                   Z-ADD     WURDNB        A1LCD                          Last Change Dat
     C                   MOVEL     'I'           A1TYLC                         Type of Last Ch
     C                   MOVEL     #1RTNM        A1RTNM                         Retail Transact
     C                   MOVEL     #1COIN        A1COIN                         Customer Origin
     C                   MOVEL     #1DCIN        A1DCIN                         Debit/Credit In
     C                   MOVEL     #1RVIN        A1RVIN                         Reversal Indica
     C                   MOVEL     #1PADI        A1PADI                         Print Advices I
     C                   MOVEL     #1ACOM        A1ACOM                         Account Commiss
      *
     C     KLCRSA        KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Check for duplicate primary key
     C*****KLCRSA        SETLL     @A1RECW                                90    *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ SELECT *                                                                            MD058755
     C+ into :SDRETR                                                                        MD058755
     C+ from SDRTRJW0                                                                       MD058755
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
     C                   SETOFF                                       90                    MD058755
     C                   If        SQLCODE =  0                                             MD058755
     C                   SETON                                        90                    MD058755
     C                   ENDIF                                                              MD058755
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0062'     W0RTN             7
      * Send message 'Retail Transaction Typ EX'
     C                   MOVEL     'USR0062'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   END
      *
     C**********         WRITE     @A1RECW                              91      *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ insert into SDRTRBTD                                                                MD058755
     C+ (                                                                                   MD058755
     C+   A1RTTY                                                                            MD058755
     C+  ,A1LCD                                                                             MD058755
     C+  ,A1TYLC                                                                            MD058755
     C+  ,A1RTNM                                                                            MD058755
     C+  ,A1COIN                                                                            MD058755
     C+  ,A1DCIN                                                                            MD058755
     C+  ,A1RVIN                                                                            MD058755
     C+  ,A1PADI                                                                            MD058755
     C+  ,A1ACOM                                                                            MD058755
     C+  ,A1CPTC                                                                            MD058755
     C+  ,A1PFMC                                                                            MD058755
     C+  ,A1ATRA                                                                            MD058755
     C+  ,QQASGL                                                                            MD058755
     C+  ,A1PASB                                                                            MD058755
     C+  ,A1CIND                                                                            MD058755
     C+  ,A1CLIN                                                                            MD058755
     C+  ,A1ASGL                                                                            MD058755
     C+  ,A1FTPT                                                                            MD058755
     C+  ,A1MODE                                                                            MD058755
     C+ )                                                                                   MD058755
     C+ Values                                                                              MD058755
     C+ (                                                                                   MD058755
     C+   :A1RTTY                                                                           MD058755
     C+  ,:A1LCD                                                                            MD058755
     C+  ,:A1TYLC                                                                           MD058755
     C+  ,:A1RTNM                                                                           MD058755
     C+  ,:A1COIN                                                                           MD058755
     C+  ,:A1DCIN                                                                           MD058755
     C+  ,:A1RVIN                                                                           MD058755
     C+  ,:A1PADI                                                                           MD058755
     C+  ,:A1ACOM                                                                           MD058755
     C+  ,:A1CPTC                                                                           MD058755
     C+  ,:A1PFMC                                                                           MD058755
     C+  ,:A1ATRA                                                                           MD058755
     C+  ,:QQASGL                                                                           MD058755
     C+  ,:A1PASB                                                                           MD058755
     C+  ,:A1CIND                                                                           MD058755
     C+  ,:A1CLIN                                                                           MD058755
     C+  ,:A1ASGL                                                                           MD058755
     C+  ,:A1FTPT                                                                           MD058755
     C+  ,'B'                                                                               MD058755
     C+ )                                                                                   MD058755
     C/END-EXEC                                                                             MD058755
     C/EXEC SQL                                                                             MD058755
     C+ insert into SDRTRXTD                                                                MD058755
     C+ (                                                                                   MD058755
     C+   A1RTTY                                                                            MD058755
     C+  ,A1LCD                                                                             MD058755
     C+  ,A1TYLC                                                                            MD058755
     C+  ,A1RTNM                                                                            MD058755
     C+  ,A1COIN                                                                            MD058755
     C+  ,A1DCIN                                                                            MD058755
     C+  ,A1RVIN                                                                            MD058755
     C+  ,A1PADI                                                                            MD058755
     C+  ,A1ACOM                                                                            MD058755
     C+  ,A1CPTC                                                                            MD058755
     C+  ,A1PFMC                                                                            MD058755
     C+  ,A1ATRA                                                                            MD058755
     C+  ,QQASGL                                                                            MD058755
     C+  ,A1PASB                                                                            MD058755
     C+  ,A1CIND                                                                            MD058755
     C+  ,A1CLIN                                                                            MD058755
     C+  ,A1ASGL                                                                            MD058755
     C+  ,A1FTPT                                                                            MD058755
     C+  ,A1MODE                                                                            MD058755
     C+ )                                                                                   MD058755
     C+ Values                                                                              MD058755
     C+ (                                                                                   MD058755
     C+   :A1RTTY                                                                           MD058755
     C+  ,:A1LCD                                                                            MD058755
     C+  ,:A1TYLC                                                                           MD058755
     C+  ,:A1RTNM                                                                           MD058755
     C+  ,:A1COIN                                                                           MD058755
     C+  ,:A1DCIN                                                                           MD058755
     C+  ,:A1RVIN                                                                           MD058755
     C+  ,:A1PADI                                                                           MD058755
     C+  ,:A1ACOM                                                                           MD058755
     C+  ,:A1CPTC                                                                           MD058755
     C+  ,:A1PFMC                                                                           MD058755
     C+  ,:A1ATRA                                                                           MD058755
     C+  ,:QQASGL                                                                           MD058755
     C+  ,:A1PASB                                                                           MD058755
     C+  ,:A1CIND                                                                           MD058755
     C+  ,:A1CLIN                                                                           MD058755
     C+  ,:A1ASGL                                                                           MD058755
     C+  ,:A1FTPT                                                                           MD058755
     C+  ,'B'                                                                               MD058755
     C+ )                                                                                   MD058755
     C/END-EXEC                                                                             MD058755
      *
     C******IN91         IFEQ      '1'                                                      MD058755
     C     SQLCODE       IFNE      0                                                        MD058755
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
      * Start of SAR S01117
      * Change File Control Filename from RETRAN to SDRETRPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SBCHRC
      * End of SAR S01117
      * Start of 031807
      * Update TABLETZ - Retail Transaction Types  *
     C                   CALL      'TABLETZ'                            90      Update TABLETZ
     C     W0RTN         PARM      W0RTN         WQ0001            7            *Return code
     C                   PARM      A1RTTY        WQ0002            5            Retail Transact
     C                   PARM      A1RTNM        WQ0003           30            Retail Transact
     C                   PARM      A1COIN        WQ0004            1            Customer Origin
     C                   PARM      A1DCIN        WQ0005            1            Debit/Credit In
     C                   PARM      A1RVIN        WQ0006            1            Reversal Indica
     C                   PARM      A1PADI        WQ0007            1            Print Advices I
     C                   PARM      A1ACOM        WQ0008            1            Account Commiss
     C                   PARM      A1TYLC        WQ0009            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0010            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLETZ'     W0CLPG
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
      * End of 031807
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDRETRPD'    AHFLNM                         Filename
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
     C                   UPDATE    @AHREAU                              91      *
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
      * Delete Retail Transaction - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @A1RECW
     C                   MOVEL     #1RTTY        A1RTTY                         Retail Transact
      *
     C     KLDLSC        KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
     C*****KLDLSC        CHAIN     @A1RECW                            9091      *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ SELECT *                                                                            MD058755
     C+ into :SDRETR                                                                        MD058755
     C+ from SDRTRJW0                                                                       MD058755
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
     C                   SETOFF                                       9091                  MD058755
     C                   If        SQLCODE = 100                                            MD058755
     C                   SETON                                        90                    MD058755
     C                   ENDIF                                                              MD058755
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058755
     C                   SETON                                        91                    MD058755
     C                   ENDIF                                                              MD058755
                                                                                            MD058755
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
     C                   eval      @1DBRC = SDRETR                                          MD058755
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C*****KLDLSC        SETLL     @A1RECW                            9091      *           MD058755
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
      * Do not allow deletion of core record                                                MD058755
     C     A1MODE        IFEQ      'C'                                                      MD058755
     C                   MOVEL     'USR0553'     ZAMSID                                     MD058755
     C                   MOVEL     'USR0553'     W0RTN                                      MD058755
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                     MD058755
     C                   EXSR      ZASNMS                                                   MD058755
     C                   GOTO      SCEXIT                                                   MD058755
     C                   ENDIF                                                              MD058755
                                                                                            MD058755
     C**********         DELETE    @A1RECW                              91      *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ delete from SDRTRBTD                                                                MD058755
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
     C/EXEC SQL                                                                             MD058755
     C+ delete from SDRTRXTD                                                                MD058755
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
     C******IN91         IFEQ      '1'                                                      MD058755
     C     SQLCODE       IFNE      0                                                        MD058755
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDRETRPD'    PAFNME                         File name
     C                   MOVEL     #1RTTY        PALKEY                         Long Key
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
     C                   SETON                                        99        *
     C                   END
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
      * Start of SAR S01117
      * Change File Control Filename from RETRAN to SDRETRPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SDCHRC
      * End of SAR S01117
     C                   MOVEL     'D'           WUTYLC                         Type of Last Ch
      * Start of 031807
      * Update TABLETZ - Retail Transaction Types  *
     C                   CALL      'TABLETZ'                            90      Update TABLETZ
     C     W0RTN         PARM      W0RTN         WQ0011            7            *Return code
     C                   PARM      A1RTTY        WQ0012            5            Retail Transact
     C                   PARM      A1RTNM        WQ0013           30            Retail Transact
     C                   PARM      A1COIN        WQ0014            1            Customer Origin
     C                   PARM      A1DCIN        WQ0015            1            Debit/Credit In
     C                   PARM      A1RVIN        WQ0016            1            Reversal Indica
     C                   PARM      A1PADI        WQ0017            1            Print Advices I
     C                   PARM      A1ACOM        WQ0018            1            Account Commiss
     C                   PARM      WUTYLC        WQ0019            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0020            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLETZ'     W0CLPG
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
      * End of 031807
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDRETRPD'    AHFLNM                         Filename
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
     C                   UPDATE    @AHREAU                              91      *
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
      * Change Retail Transaction - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @A1RECW
     C                   MOVEL     #1RTTY        A1RTTY                         Retail Transact
      *
     C     KLCHSE        KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
     C*****KLCHSE        CHAIN     @A1RECW                            9091      *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ SELECT *                                                                            MD058755
     C+ into :SDRETR                                                                        MD058755
     C+ from SDRTRJW0                                                                       MD058755
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
     C                   SETOFF                                       9091                  MD058755
     C                   If        SQLCODE = 100                                            MD058755
     C                   SETON                                        90                    MD058755
     C                   ENDIF                                                              MD058755
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058755
     C                   SETON                                        91                    MD058755
     C                   ENDIF                                                              MD058755
                                                                                            MD058755
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
     C                   eval      @1DBRC = SDRETR                                          MD058755
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C*****KLCHSE        SETLL     @A1RECW                            9091      *           MD058755
     C                   GOTO      SEEXIT
     C                   END                                                    FI #1DBRC
      * Move non-key fields to @A1RECW
     C                   Z-ADD     WURDNB        A1LCD                          Last Change Dat
     C                   MOVEL     'A'           A1TYLC                         Type of Last Ch
     C                   MOVEL     #1RTNM        A1RTNM                         Retail Transact
     C                   MOVEL     #1COIN        A1COIN                         Customer Origin
     C                   MOVEL     #1DCIN        A1DCIN                         Debit/Credit In
     C                   MOVEL     #1RVIN        A1RVIN                         Reversal Indica
     C                   MOVEL     #1PADI        A1PADI                         Print Advices I
     C                   MOVEL     #1ACOM        A1ACOM                         Account Commiss
      *
     C**********         UPDATE    @A1RECW                              91      *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ update SDRTRXTD set                                                                 MD058755
     C+   A1LCD  = :A1LCD                                                                   MD058755
     C+  ,A1TYLC = :A1TYLC                                                                  MD058755
     C+  ,A1RTNM = :A1RTNM                                                                  MD058755
     C+  ,A1COIN = :A1COIN                                                                  MD058755
     C+  ,A1DCIN = :A1DCIN                                                                  MD058755
     C+  ,A1RVIN = :A1RVIN                                                                  MD058755
     C+  ,A1PADI = :A1PADI                                                                  MD058755
     C+  ,A1ACOM = :A1ACOM                                                                  MD058755
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
     C******IN91         IFEQ      '1'                                                      MD058755
     C                   If        SQLCODE <> 0                                             MD058755
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
      * Start of SAR S01117
      * Change File Control Filename from RETRAN to SDRETRPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SFCHRC
      * End of SAR S01117
      * Start of 031807
      * Update TABLETZ - Retail Transaction Types  *
     C                   CALL      'TABLETZ'                            90      Update TABLETZ
     C     W0RTN         PARM      W0RTN         WQ0021            7            *Return code
     C                   PARM      A1RTTY        WQ0022            5            Retail Transact
     C                   PARM      A1RTNM        WQ0023           30            Retail Transact
     C                   PARM      A1COIN        WQ0024            1            Customer Origin
     C                   PARM      A1DCIN        WQ0025            1            Debit/Credit In
     C                   PARM      A1RVIN        WQ0026            1            Reversal Indica
     C                   PARM      A1PADI        WQ0027            1            Print Advices I
     C                   PARM      A1ACOM        WQ0028            1            Account Commiss
     C                   PARM      A1TYLC        WQ0029            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0030            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLETZ'     W0CLPG
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
      * End of 031807
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDRETRPD'    AHFLNM                         Filename
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
     C                   UPDATE    @AHREAU                              91      *
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
     CSR   SGRVGN        BEGSR
      *================================================================
      * Get Retail Indicator - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KPSSG         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KPSSG         SETLL     @BGREC8                                      *
     C                   READ      @BGREC8                                90    *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0096'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDMMODPD'    ZA0002                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      SGEXIT                                       *QUIT
     C                   GOTO      SGEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
     C                   MOVEL     *BLANK        W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     BGRTBN        WUCRIN                         Retail Banking
     C                   READ      @BGREC8                                90    *
     C                   END
      *================================================================
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHRVGN        BEGSR
      *================================================================
      * Get Retail 3/IOA indic - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KPSSH         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KPSSH         SETLL     @BGREC8                                      *
     C                   READ      @BGREC8                                90    *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0096'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDMMODPD'    ZA0003                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      SHEXIT                                       *QUIT
     C                   GOTO      SHEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
     C                   MOVEL     *BLANK        W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     BGNXST        WUNXST                         Retail 3
     C                   MOVEL     BGNYST        WUNYST                         Interest on Acc
     C                   READ      @BGREC8                                90    *
     C                   END
      *================================================================
     CSR   SHEXIT        ENDSR
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
     C/EXEC SQL                                                                             MD058755
     C+ close ACursor                                                                       MD058755
     C/END-EXEC                                                                             MD058755
                                                                                            MD058755
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
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Define work field Deletion Allowed
     C                   MOVEL     *BLANK        WUDELA            1
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Account Comm. Ind.display
     C                   MOVEL     *BLANK        WUACID            1
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
      * Define work field Type of Last Change
     C                   MOVEL     *BLANK        WUTYLC            1
      * Define work field Check Retail Indicator
     C                   MOVEL     *BLANK        WUCRIN            1
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field Retail 3
     C                   MOVEL     *BLANK        WUNXST            1
      * Define work field Interest on Accounts 3
     C                   MOVEL     *BLANK        WUNYST            1
      * Define work field Commission on Debit Turn
     C                   MOVEL     *BLANK        WUCODT            1
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
     C                   OPEN      SD0130M#
     C**********         OPEN      SDRETRL1                                                 MD058755
     C                   OPEN      SDMMODL1
     C**********         OPEN      SDRETRL0                                                 MD058755
     C                   OPEN      SDFCTLL0
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
      * Start of change S01459.
      * SD0130M Precompiler - Retail Transaction Types  *
      * Remove creation parameters and last amend box functions.
      * End of change S01459.
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT                         RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Copyright Statement - Standard Functions  * copyright
      * Get Retail Indicator - MIDAS Modules  *
     C                   EXSR      SGRVGN
      * start S01413
      * Get Retail 3/IOA indic - MIDAS Modules  *
     C                   EXSR      SHRVGN
      * Get Comm on Debit Turnovr - Retail Details  *
     C                   CALL      'SD9342'                             90      Get Comm on Deb
     C     W0RTN         PARM      W0RTN         WQ0031            7            *Return code
     C     WUCODT        PARM      *BLANK        WQ0032            1            Commission on D
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD9342'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
     C                   MOVEL     'N'           WUACID                         Account Comm. I
      * CASE: WRK.Retail 3 is Yes
     C     WUNXST        IFEQ      'Y'                                          *IF
      * CASE: WRK.Commission on Debit Turn is Yes
     C     WUCODT        IFEQ      'Y'                                          *IF
     C                   MOVEL     'Y'           WUACID                         Account Comm. I
     C                   END                                                    *FI
     C                   END                                                    *FI
      * end S01413
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
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0130MPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD058755
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058755
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0130MPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001

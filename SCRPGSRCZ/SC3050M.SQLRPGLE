     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas SC Switchable features by rep compnt')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC3050M - Switchable Features by Report Component            *
      *                                                               *
      *  Function:  This program allows the user to maintain the      *
      *             switchable report component data                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD055265           Date 10Feb20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSC007             Date 05Nov98               *
      *                 CCB008             Date 12Oct98               *
      *                 S01459             Date 12Oct98               *
      *                 S01407             Date 20Jan93               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC007 - Enable Swithchable Features to be maintained        *
      *           irrespective of on or off                           *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - File removed from CB model.                       *
      *  S01459 - Addition of Midas Headerbox.                        *
      *  S01407 - Switchability Enhancements.                         *
      *                                                               *
      *****************************************************************
     FSC3050M#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SC Switchable features by report component
      *
     FSCSARML1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Midas SC Switchable features - report comp retriev
      *
     F*SCSARDL1IF**E***********K        DISK                           UC      CSC007
     F*SCSARSL1* IF   E           K DISK    USROPN                                          MD055681
     F**********                           INFDS(ID0001)                                    MD055681
     F**********                           INFSR(*PSSR)                                     MD055681
      * RTV : Midas SC Switchable features in system retrieval
      *
     FSCSARML0  UF A E           K DISK    USROPN
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * UPD : Midas SC Switchable features - report comp update
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
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
     D @1DBRC        E DS                  EXTNAME(SCSARML0)
      * UPD : Midas SC Switchable features - report comp update
      * Current/previous master file format fields for change control
      *
     D P@CMPN        E DS                  EXTNAME(CBCMPNPD)
      *
     D*P@RCOM*** E DSFCRCOMPD                                                               MD055265
     D P@RCOM        E DS                  EXTNAME(FCRCOCTD)                                      MD
      *
     D YARDCS          DS            36
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
     D P@FMT         E DS                  EXTNAME(DSFDY)
     D*
     D* 200 Byte Data Structure for Incoming Data from Access Program
     D*
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : RST Switchable Feature Number
     D  P1SARN                 1      6
     D P2PARM          DS
      * I : RST Description
     D  P2SARD                 1     50
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Switch F Rept - Rep Comp'
      * Switchable Feature Number
     D  ZA0001                 1      6
      * Message data for 'Report Comp doesn't exist'
      * Report Name
     D  ZA0002                 1     10
      * Component Name
     D  ZA0003                11     20
      * Component Sequence Number
     D  ZA0004                21     25
      * Message data for 'Allow RepC must be 'Y/N''
      * Avail if feature present?
     D  ZA0005                 1      1
     D SCSARS        E DS                  EXTNAME(SCSRSJW0)                                MD055681
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1SARN        PARM                    WP0001            6            Switchable Feat
     C     P2SARD        PARM                    WP0002           50            Description
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
     C     *LIKE         DEFINE    #2RNAM        WZRNAM
     C                   MOVEL     #2RNAM        WZRNAM                         Report Name
     C     *LIKE         DEFINE    #2COTT        WZCOTT
     C                   MOVEL     #2COTT        WZCOTT                         Component Name
     C     *LIKE         DEFINE    #2CSEQ        WZCSEQ
     C                   MOVEL     #2CSEQ        WZCSEQ                         Component Seque
     C     KPOS          KLIST
     C                   KFLD                    AESARN                         Switchable Feat
     C                   KFLD                    AERNAM                         Report Name
     C                   KFLD                    AECOTT                         Component Name
     C                   KFLD                    AECSEQ                         Component Seque
      * Setup key
     C                   MOVEL     #2SARN        AESARN                         Switchable Feat
     C                   MOVEL     #2RNAM        AERNAM                         Report Name
     C                   MOVEL     #2COTT        AECOTT                         Component Name
     C                   MOVEL     #2CSEQ        AECSEQ                         Component Seque
      * 82=EOF
     C     KPOS          SETLL     @SARML1                            82        *
      * 82=EOF
     C     KRST          KLIST
     C                   KFLD                    AESARN                         Switchable Feat
      * Setup key
     C                   MOVEL     #2SARN        AESARN                         Switchable Feat
     C  N82KRST          READE     @SARML1                              9182    *
     C                   ELSE
     C                   SETOFF                                       82        *
     C                   END
      * Load subfile page
     C                   EXSR      BBLDSF
      * If no records (first time only), switch to add mode and load agai
     C     W0APM         IFEQ      'Y'
     C     ##RR          ANDEQ     *ZERO
     C                   MOVEL     'ADD'         W0PMD
     C                   SETON                                        51
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
     C  N82              READP     @SARML1                                90    *
     C  N82              READ      @SARML1                                90    *
     C                   END
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0            5
     C                   MOVE      *ALL'1'       WKIND1            5
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
     C  N82##RROK        DOWLT     ##SFLN                                       DO
     C                   ADD       1             ##RR
     C                   MOVEA     WKIND0        *IN(34)
     C                   SETOFF                                       87        *
      * Clear subfile fields
     C                   EXSR      MAIZ#1
      * If CHANGE mode, load subfile fields
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
      * Record will be selected unless overridden
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Initialize subfile record (existing record)
      * Retrieve the Report component text via access program to COB
      * components (text only retrieved if report component is a COB comp
     C                   MOVEL     *BLANK        WURTCD                         Access Obj Retu
     C                   MOVEL     *BLANK        WUOPTN                         Access Obj Acce
     C                   MOVEL     '*KEY'        WUOPTN                         Access Obj Acce
     C                   MOVEL     #1COTT        WUCOTT                         Component Name
     C                   MOVEL     #1CSEQ        WUCSEQ                         Component Seque
      * Get COB Component -->DSPF - Standard functions  *
      *
     C*
     C** Move Synon work fields into parameters
     C*
     C                   CALL      'AOCMPNR0'
     C                   PARM                    WURTCD                         B:Return code
     C                   PARM                    WUOPTN                         I:Option
     C                   PARM                    WUCOTT                         Compnt name
     C                   PARM                    WUCSEQ                         Compnt seq no
     C     P@CMPN        PARM      P@CMPN        P@FMT                          O:Format
     C*
     C** If record found, copy component description to screen field
     C*
     C     WUOPTN        IFNE      '*FREE'
     C                   MOVEL     *BLANKS       #RTXTC
     C     WURTCD        IFEQ      *BLANKS
     C                   MOVEL     DHCTXT        #RTXTC
     C                   END
     C                   END
     C                   MOVEL     #RTXTC        #RTXUC                         Descr of Compon
      * If record dropped...
     C                   SUB       1             ##RR
     C     W0RSL         CABNE     'Y'           BB020
     C                   ADD       1             ##RR
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
     C     BB020         TAG
     C     W0PMD         IFNE      'ADD'
      * 82=EOF
     C     KRST          READE     @SARML1                                82    *
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
     C     WZRNAM        CASNE     #2RNAM        FBRQRL                         Report Name
     C     WZCOTT        CASNE     #2COTT        FBRQRL                         Component Name
     C     WZCSEQ        CASNE     #2CSEQ        FBRQRL                         Component Seque
     C                   END
     C                   END
      * USER: Validate subfile control
      * F12=Previous Pressed
      * CASE: CTL.*CMD key is *Cancel
     C     *IN12         IFEQ      '1'                                          *IF
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * F11=Print Pressed
      * CASE: CTL.*CMD key is CF11
     C     *IN11         IFEQ      '1'                                          *IF
      * Print  Switchable F - Rep - Switchable F - Rep Compnt  *
     C                   CALL      'SC3050P'                            90      Print  Switchab
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      P1SARN        WQ0001            6            Switchable Feat
     C                   PARM      P2SARD        WQ0002           50            Description
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3050P'     W0CLPG
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
      * Setup message data for message
     C                   MOVEL     P1SARN        ZA0001                         Switchable Feat
      * Send message 'Switch F Rept - Rep Comp'
     C                   MOVEL     'CBM0040'     ZAMSID
     C                   MOVEL     '*INFO  '     ZAMSTP                         Message type
     C                   EXSR      ZASNMS
      *
     C                   END                                                    *FI
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
     C                   MOVEA     WKIND0        *IN(34)
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
     C     #1RNAM        CABNE     *BLANK        DDEXIT                         Report Name
     C     #1COTT        CABNE     *BLANK        DDEXIT                         Component Name
     C     #1CSEQ        CABNE     *BLANK        DDEXIT                         Component Seque
     C     #1AVAL        CABNE     *BLANK        DDEXIT                         Avail if featur
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
     C                   SETON                                        9837      *
     C                   END
     C                   MOVEL     XG90          *IN90
      * Validate Avail if feature present?
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1AVAL        W0NSRQ            1            Avail if featur
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1101426       Y2LSNO            7 0
     C     #1AVAL        PARM      #1AVAL        W0EXVL           20            Avail if featur
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * USER: Validate subfile record fields
      * Validate Report Component (and retrieve description if COB compon
      * (only in add mode)
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
      * Check Report Component via Access Program
     C                   MOVEL     *BLANK        WURTCD                         Access Obj Retu
     C                   MOVEL     *BLANK        WUOPTN                         Access Obj Acce
     C                   MOVEL     '*KEY'        WUOPTN                         Access Obj Acce
     C                   MOVEL     #1RNAM        WURNAM                         Report Name
     C                   MOVEL     #1COTT        WUCOTT                         Component Name
     C                   MOVEL     #1CSEQ        WUCSEQ                         Component Seque
      * Get Report Compnt -->DSPF - Standard functions  *
      *
     C*
     C** Move Synon work fields into parameters
     C*
     C                   CALL      'AORCOMR0'
     C                   PARM                    WURTCD                         B:Return code
     C                   PARM                    WUOPTN                         I:Option
     C                   PARM                    WURNAM                         Report name
     C                   PARM                    WUCOTT                         Compnt name
     C                   PARM                    WUCSEQ                         Compnt seq no
     C     P@RCOM        PARM      P@RCOM        P@FMT                          O:Format
     C*
     C* WURTCD is the return code used in Synon program
      * CASE: WRK.Access Obj Return Code is Normal - no errors found
     C     WURTCD        IFEQ      *BLANK                                       *IF
      * Retrieve the Report component description for a COB component
     C                   MOVEL     *BLANK        WURTCD                         Access Obj Retu
     C                   MOVEL     *BLANK        WUOPTN                         Access Obj Acce
     C                   MOVEL     '*KEY'        WUOPTN                         Access Obj Acce
     C                   MOVEL     #1COTT        WUCOTT                         Component Name
     C                   MOVEL     #1CSEQ        WUCSEQ                         Component Seque
      * Get COB Component -->DSPF - Standard functions  *
     C*
     C** Move Synon work fields into parameters
     C*
     C                   CALL      'AOCMPNR0'
     C                   PARM                    WURTCD                         B:Return code
     C                   PARM                    WUOPTN                         I:Option
     C                   PARM                    WUCOTT                         Compnt name
     C                   PARM                    WUCSEQ                         Compnt seq no
     C     P@CMPN        PARM      P@CMPN        P@FMT                          O:Format
     C*
     C** If record found, copy component description to screen field
     C*
     C     WUOPTN        IFNE      '*FREE'
     C                   MOVEL     *BLANKS       #RTXTC
     C     WURTCD        IFEQ      *BLANKS
     C                   MOVEL     DHCTXT        #RTXTC
     C                   END
     C                   END
      * If the Report component text on the screen is different from the
      * hidden screen field, then redisplay screen
      * CASE: RCD.Description of Component NE RCD.Descr of Component (Hid
     C     #RTXTC        IFNE      #RTXUC                                       *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
      * If the access to Get COB Component is successful, then copy the
      * Report (COB) component text to the screen hidden field
      * CASE: WRK.Access Obj Return Code is Normal - no errors found
     C     WURTCD        IFEQ      *BLANK                                       *IF
     C                   MOVEL     #RTXTC        #RTXUC                         Descr of Compon
     C                   END                                                    *FI
      * Close files in access program
     C                   MOVEL     *BLANK        WURTCD                         Access Obj Retu
     C                   MOVEL     *BLANK        WUOPTN                         Access Obj Acce
     C                   MOVEL     '*FREE'       WUOPTN                         Access Obj Acce
     C                   MOVEL     #1COTT        WUCOTT                         Component Name
     C                   MOVEL     #1CSEQ        WUCSEQ                         Component Seque
      * Get COB Component -->DSPF - Standard functions  *
     C*
     C** Move Synon work fields into parameters
     C*
     C                   CALL      'AOCMPNR0'
     C                   PARM                    WURTCD                         B:Return code
     C                   PARM                    WUOPTN                         I:Option
     C                   PARM                    WUCOTT                         Compnt name
     C                   PARM                    WUCSEQ                         Compnt seq no
     C     P@CMPN        PARM      P@CMPN        P@FMT                          O:Format
     C*
     C** If record found, copy component description to screen field
     C*
     C     WUOPTN        IFNE      '*FREE'
     C                   MOVEL     *BLANKS       #RTXTC
     C     WURTCD        IFEQ      *BLANKS
     C                   MOVEL     DHCTXT        #RTXTC
     C                   END
     C                   END
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1RNAM        ZA0002                         Report Name
     C                   MOVEL     #1COTT        ZA0003                         Component Name
     C                   MOVEL     #1CSEQ        ZA0004                         Component Seque
      * Send message 'Report Comp doesn't exist'
     C                   MOVEL     'CBM0053'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        983536    *
     C                   SETON                                        37        *
      *
     C                   END                                                    *FI
      * Close files in access program
     C                   MOVEL     *BLANK        WURTCD                         Access Obj Retu
     C                   MOVEL     *BLANK        WUOPTN                         Access Obj Acce
     C                   MOVEL     '*FREE'       WUOPTN                         Access Obj Acce
     C                   MOVEL     #1RNAM        WURNAM                         Report Name
     C                   MOVEL     #1COTT        WUCOTT                         Component Name
     C                   MOVEL     #1CSEQ        WUCSEQ                         Component Seque
      * Get Report Compnt -->DSPF - Standard functions  *
     C*
     C** Move Synon work fields into parameters
     C*
     C                   CALL      'AORCOMR0'
     C                   PARM                    WURTCD                         B:Return code
     C                   PARM                    WUOPTN                         I:Option
     C                   PARM                    WURNAM                         Report name
     C                   PARM                    WUCOTT                         Compnt name
     C                   PARM                    WUCSEQ                         Compnt seq no
     C     P@RCOM        PARM      P@RCOM        P@FMT                          O:Format
     C*
     C* WURTCD is the return code used in Synon program
     C                   END                                                    *FI
      * Validate Allow Report Component to Run ?
      * CASE: RCD.Avail if feature present? is Valid values
     C     #1AVAL        IFEQ      'N'                                          *IF
     C     #1AVAL        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1AVAL        ZA0005                         Avail if featur
      * Send message 'Allow RepC must be 'Y/N''
     C                   MOVEL     'CBM0030'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9838      *
      *
     C                   END                                                    *FI
      * Validate subfile record relations
     C                   EXSR      DFV2RC
      * Report Name required
     C     #1RNAM        IFEQ      *BLANK                                       IF
     C                   SETON                                        9835      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Component Name required
     C     #1COTT        IFEQ      *BLANK                                       IF
     C                   SETON                                        9836      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Component Sequence Number required
     C     #1CSEQ        IFEQ      *BLANK                                       IF
     C                   SETON                                        9837      *
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
     C                   MOVEA     WKIND0        *IN(34)
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
      * Create Switchable F - Rep - Switchable F - Rep Compnt  *
     C                   EXSR      SACRRC
     C     W0RTN         IFNE      *BLANK
      * Write error detected
      * Screen errors
     C                   MOVEA     WKIND1        *IN(34)
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
      * Delete object - Switchable F - Rep Compnt  *
     C                   EXSR      SBDLRC
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful
      * Screen errors
     C                   MOVEA     WKIND1        *IN(34)
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
      * Change Switchable F - Rep - Switchable F - Rep Compnt  *
     C                   EXSR      SCCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Screen errors
     C                   MOVEA     WKIND1        *IN(34)
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
     C                   SETON                                        51
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   SETOFF                                       51
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
     C                   MOVEL     P1SARN        #1SARN                         Switchable Feat
     C                   MOVEL     *BLANK        #RTXUC                         Descr of Compon
     C                   Z-ADD     *ZERO         #1LCD                          Last change dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of the Las
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1RNAM                         Report Name
     C                   MOVEL     *BLANK        #1COTT                         Component Name
     C                   MOVEL     *BLANK        #1CSEQ                         Component Seque
     C                   MOVEL     *BLANK        #1AVAL                         Avail if featur
     C                   MOVEL     *BLANK        #RTXTC                         Description of
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @SARML1 fields to subfile
      *================================================================
     C                   MOVEL     AESARN        #1SARN                         Switchable Feat
     C                   Z-ADD     AELCD         #1LCD                          Last change dat
     C                   MOVEL     AETYLC        #1TYLC                         Type of the Las
     C                   MOVEL     AERNAM        #1RNAM                         Report Name
     C                   MOVEL     AECOTT        #1COTT                         Component Name
     C                   MOVEL     AECSEQ        #1CSEQ                         Component Seque
     C                   MOVEL     AEAVAL        #1AVAL                         Avail if featur
      * Hold current record image for change detection
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     P1SARN        #2SARN                         Switchable Feat
     C                   MOVEL     P2SARD        #PSARD                         Description
     C                   MOVEL     *BLANK        #2RNAM                         Report Name
     C                   MOVEL     *BLANK        #2COTT                         Component Name
     C                   MOVEL     *BLANK        #2CSEQ                         Component Seque
      * Check restriction within
     C                   EXSR      VACKRL
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Switchable F - Rep - Switchable F - Rep Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @SARML0
     C                   MOVEL     P1SARN        AESARN                         Switchable Feat
     C                   MOVEL     #1RNAM        AERNAM                         Report Name
     C                   MOVEL     #1COTT        AECOTT                         Component Name
     C                   MOVEL     #1CSEQ        AECSEQ                         Component Seque
     C                   MOVEL     #1AVAL        AEAVAL                         Avail if featur
     C                   Z-ADD     WUAKTX        AELCD                          Last change dat
     C                   MOVEL     'I'           AETYLC                         Type of the Las
      *
     C     KLCRSA        KLIST
     C                   KFLD                    AESARN                         Switchable Feat
     C                   KFLD                    AERNAM                         Report Name
     C                   KFLD                    AECOTT                         Component Name
     C                   KFLD                    AECSEQ                         Component Seque
      * Check for duplicate primary key
     C     KLCRSA        SETLL     @SARML0                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CBM0011'     W0RTN             7
      * Send message 'Switchable F - Rep Com EX'
     C                   MOVEL     'CBM0011'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   END
      *
     C                   WRITE     @SARML0                              91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBDLRC        BEGSR
      *================================================================
      * Delete object - Switchable F - Rep Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @SARML0
     C                   MOVEL     #1SARN        AESARN                         Switchable Feat
     C                   MOVEL     #1RNAM        AERNAM                         Report Name
     C                   MOVEL     #1COTT        AECOTT                         Component Name
     C                   MOVEL     #1CSEQ        AECSEQ                         Component Seque
      *
     C     KLDLSB        KLIST
     C                   KFLD                    AESARN                         Switchable Feat
     C                   KFLD                    AERNAM                         Report Name
     C                   KFLD                    AECOTT                         Component Name
     C                   KFLD                    AECSEQ                         Component Seque
     C     KLDLSB        CHAIN     @SARML0                            9091      *
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
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C     KLDLSB        SETLL     @SARML0                            9091      *
     C                   GOTO      SBEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C                   DELETE    @SARML0                              91      *
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Change Switchable F - Rep - Switchable F - Rep Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @SARML0
     C                   MOVEL     #1SARN        AESARN                         Switchable Feat
     C                   MOVEL     #1RNAM        AERNAM                         Report Name
     C                   MOVEL     #1COTT        AECOTT                         Component Name
     C                   MOVEL     #1CSEQ        AECSEQ                         Component Seque
      *
     C     KLCHSC        KLIST
     C                   KFLD                    AESARN                         Switchable Feat
     C                   KFLD                    AERNAM                         Report Name
     C                   KFLD                    AECOTT                         Component Name
     C                   KFLD                    AECSEQ                         Component Seque
     C     KLCHSC        CHAIN     @SARML0                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
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
     C                   GOTO      SCEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C                   UNLOCK    SCSARML0                             91      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YARDCS
      * Move non-key fields to @SARML0
     C                   MOVEL     #1AVAL        AEAVAL                         Avail if featur
     C                   Z-ADD     WUAKTX        AELCD                          Last change dat
     C                   MOVEL     'A'           AETYLC                         Type of the Las
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C                   UPDATE    @SARML0                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SCSARML0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Check restriction within
      *================================================================
      *
     C     KLVAAB        KLIST
     C*********************KFLD***********ABSARN           Switchable Feat      CSC007
     C                   KFLD                    AXSARN                         Switchable Feat
      * Setup key
     C*********************MOVEL#2SARN    ABSARN           Switchable Feat      CSC007
     C                   MOVEL     #2SARN        AXSARN                         Switchable Feat
     C***********KLVAAB****CHAIN@SARDL1              9091  *                    CSC007
     C*****KLVAAB        CHAIN     SCSARSD0                           9091      *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARS                                                                        MD055681
     C+ from SCSRSJW0                                                                       MD055681
     C+ where AXSARN = :AXSARN                                                              MD055681
     C/END-EXEC                                                                             MD055681
     C******IN90         IFEQ      '0'                                                      MD055681
     C                   IF        SQLCODE = 0                                              MD055681
      * Record found - move back any virtuals
     C                   GOTO      VAEXIT
     C                   END
      * Restrictor relation not satisfied
      * Send message 'Switchable Features    NF'
     C                   MOVEL     'CBM0004'     ZAMSID
     C                   MOVEL     '*PRV '       ZAPGRL                         Rel queue
     C                   EXSR      ZASNMS
     C                   MOVEL     'CBM0004'     P0RTN
     C                   EXSR      ZYEXPG
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
      * USER: Exit program processing
      * CASE: CTL.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
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
      * Define work field Access Obj Return Code
     C                   MOVEL     *BLANK        WURTCD            7
      * Define work field Access Obj Access Option
     C                   MOVEL     *BLANK        WUOPTN            7
      * Define work field Component Name
     C                   MOVEL     *BLANK        WUCOTT           10
      * Define work field Component Sequence Number
     C                   MOVEL     *BLANK        WUCSEQ            5
      * Define work field Access Obj Rec Fmt (200)
     C                   MOVEL     *BLANK        WUFMT           200
      * Obtain default message file
     C     *DTAARA       DEFINE    CBMGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Report Name
     C                   MOVEL     *BLANK        WURNAM           10
      * Define work field run day number
     C                   Z-ADD     *ZERO         WUAKTX            5 0
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WUAANA            7
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
     C                   OPEN      SC3050M#
     C                   OPEN      SCSARML1
     C*********************OPEN SCSARDL1                                        CSC007
     C**********         OPEN      SCSARSL1                                                 MD055681
     C                   OPEN      SCSARML0
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     03            ##SFPG            3 0          SFLPAG
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
      * SC3050M Precompiler - Switchable F - Rep Compnt  *
      * Copyright Statement 1993 - Standard functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##AANA            7
     C                   MOVE      MRDT          WUAANA
     C                   MOVE      RDNB          WUAKTX
     C                   MOVE      SUC           WUAUST
     C                   MOVE      DFF           WUE3ST
     C                   MOVE      MBIN          WUF1ST
      * Define 200 byte DS for AP - Standard functions  *
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
     C/COPY WNCPYSRC,SC3050MPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SC3050MPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINS                                                              MD055681
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055681
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SC3050MPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001

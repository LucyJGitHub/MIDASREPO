     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas SC Switchable features by menu items')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC3060M - Switchable Menu Items Maintenance                  *
      *                                                               *
      *  Function:  This program allows the user to maintain the      *
      *             switchable menu items data                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGP009             Date 22Dec04               *
      *                 CSF002             Date 11Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *               . CSC007             Date 05Nov98               *
      *                 CCB008             Date 12Oct98               *
      *                 094059             DATE 03OCT95               *
      *                 CAAA01             DATE 09AUG95               *
      *                 S01459             DATE 09AUG95               *
      *                 S01407             DATE 20JAN93               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  CSF002 - Global Processing SPF changes                       *
      *  CSC007 - Enable Swithchable Features to be maintained        *
      *           irrespective of on or off                           *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - File removed from CB model.                       *
      *  094059 - Remove the processing that prevents a blank         *
      *           being entered into the item code field.             *
      *  CAAA01 - Increase the length of the AOMITMR0 return          *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *  S01407 - Switchability enhancements.                         *
      *                                                               *
      *****************************************************************
     FSC3060M#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SC Switchable features by menu items
      *
     F***SCSARIL2IF**E           K        DISK                           UC                   CSF002
     FGPMTXTL3  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RSQ : Midas SC Switchable menu items
      *
     F*SCSARDL1IF**E***********K        DISK                           UC      CSC007
     F*SCSARSL1* IF   E           K DISK    USROPN                                          MD055681
     F**********                           INFDS(ID0001)                                    MD055681
     F**********                           INFSR(*PSSR)                                     MD055681
      * RTV : Midas SC Switchable features in system retrieval
      *
     F***SCSARIL0UF**E         K        DISK                      A    UC                     CSF002
     FSCSARIL4  UF A E           K DISK    USROPN
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * UPD : Midas SC Switchable menu items update
      *
     FGPZONEL2  IF   E           K DISK    USROPN
     F                                     INFDS(ID0003)
     F                                     INFSR(*PSSR)
      ** Midas GP Zones by zone system prefix                                                 CSF002
      *                                                                                       CSF002
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
     D***@1DBRC****E DSSCSARIL0                                                               CSF002
     D @1DBRC        E DS                  EXTNAME(SCSARIL4)
      * UPD : Midas SC Switchable menu items update
      * Current/previous master file format fields for change control
      *
     D WUA800          DS           800
     D***P@MITM****E DSMITEMDD                                                                CSF002
      *
     D YARDCS          DS            65
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
     D SDSTAT        E DS
     D P@FMT         E DS                  EXTNAME(DSSDY)
     D*
     D* 800 Byte Data Structure for Incoming Data from Access Program
     D*
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D ID0003          DS           528
      ** File information data structure                                                      CSF002
      *                                                                                       CSF002
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
      * Message data for 'Switch F Rept - Menu Item'
      * Switchable Feature Number
     D  ZA0001                 1      6
      * Message data for 'Menu Item doesn't exist'
      **Menu*Group*Code***********************************************                        CSF002
     D**********                              1   4 ZA0002                                    CSF002
      **Short*code*for*DSPF*******************************************                        CSF002
     D**********                              5   8 ZA0003                                    CSF002
      ** Menu Item Short Code                                                                 CSF002
     D  ZA0002                 1     20
      * Message data for 'Disply Item must be 'Y/N''
      * Avail if feature present?
     D  ZA0004                 1      1
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
     C********** *LIKE     DEFN #2MGRP    WZMGRP                                              CSF002
     C**********           MOVEL#2MGRP    WZMGRP           Menu Group Code                    CSF002
      *                                                                                       CSF002
      ** Menu Item Short Code                                                                 CSF002
      *                                                                                       CSF002
     C     *LIKE         DEFINE    #2SNAM        WZSNAM
     C                   MOVEL     #2SNAM        WZSNAM
     C     KPOS          KLIST
     C**********           KFLD           ADSARN           Switchable Feat                    CSF002
     C**********           KFLD           ADMGRP           Menu Group Code                    CSF002
     C                   KFLD                    MISNAM
      * Setup key
     C**********           MOVEL#2SARN    ADSARN           Switchable Feat                    CSF002
     C**********           MOVEL#2MGRP    ADMGRP           Menu Group Code                    CSF002
      *                                                                                       CSF002
      ** Menu Item Short Code                                                                 CSF002
      *                                                                                       CSF002
     C                   MOVEL     #2SNAM        MISNAM
      * 82=EOF
     C********** KPOS      SETLL@SARIL2              82    *                                  CSF002
     C     KPOS          SETLL     GPMTXTD0                           82        *
      * 82=EOF
     C     KRST          KLIST
     C**********           KFLD           ADSARN           Switchable Feat                    CSF002
     C                   KFLD                    KSARN             6
     C                   KFLD                    KINDX            10
      * Setup key
     C**********           MOVEL#2SARN    ADSARN           Switchable Feat                    CSF002
     C**N82***** KRST      READE@SARIL2                9182*                                  CSF002
     C                   MOVE      *BLANK        WZONE
     C                   MOVE      *OFF          *IN38
     C     *IN82         DOWEQ     *OFF
     C     WZONE         ANDNE     LIBR
     C     *IN38         ANDEQ     *OFF
     C     *IN82         OREQ      *OFF
     C     WZONE         ANDEQ     LIBR
     C     *IN36         ANDEQ     *ON
     C     *IN82         OREQ      *OFF
     C     *IN38         ANDEQ     *ON
     C     *IN36         ANDEQ     *ON
     C                   READ      GPMTXTL3                               82
     C     2             SUBST     MIINDX:1      WZONE             2
     C**********         MOVEL     WZONE         WZONEN            3 0                      MD055681
     C**********         MOVEL     WZONEN        WZONEA            2                        MD055681
     C                   MOVE      *OFF          *IN38
     C*****WZONE         IFEQ      WZONEA                                                   MD055681
     C**********         MOVE      *ON           *IN38                                      MD055681
     C**********         ENDIF                                                              MD055681
     C                   TESTN                   WZONE                38                    MD055681
     C                   MOVE      MIINDX        KINDX
     C                   MOVE      #2SARN        KSARN
     C     KRST          CHAIN     SCSARIL4                           36
     C                   ENDDO
      *                                                                                       CSF002
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
     C**N82*****           READP@SARIL2                  90*                                  CSF002
     C**N82*****           READ @SARIL2                  90*                                  CSF002
     C     *IN82         IFEQ      *OFF
     C                   READP     GPMTXTL3                               90    *
     C                   READ      GPMTXTL3                               90    *
     C                   ENDIF
     C                   END
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0            4
     C                   MOVE      *ALL'1'       WKIND1            4
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
     C                   MOVEA     WKIND0        *IN(32)
     C                   SETOFF                                       87        *
      * Clear subfile fields
     C                   EXSR      MAIZ#1
      * If CHANGE mode, load subfile fields
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
      * Record will be selected unless overridden
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Initialize subfile record (existing record)
      * CASE: DB1.Record id is Live
     C     ADRECI        IFEQ      'D'                                          *IF
     C                   MOVEL     'Y'           W0RSL                          *Record selecte
     C**********           MOVELADICDE    #RICDF           Short code for                     CSF002
      * Copy the menu narrative from DBF to hidden screen field
     C                   MOVEL     ADINAR        #RNARI                         Narrative for M
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           W0RSL                          *Record selecte
     C                   END                                                    *FI
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
     C********** KRST      READE@SARIL2                  82*                                  CSF002
     C                   MOVE      *BLANK        WZONE
     C                   MOVE      *OFF          *IN38
     C     *IN82         DOWEQ     *OFF
     C     WZONE         ANDNE     LIBR
     C     *IN38         ANDEQ     *OFF
     C     *IN82         OREQ      *OFF
     C     WZONE         ANDEQ     LIBR
     C     *IN36         ANDEQ     *ON
     C     *IN82         OREQ      *OFF
     C     *IN38         ANDEQ     *ON
     C     *IN36         ANDEQ     *ON
     C                   READ      GPMTXTL3                               82
     C     2             SUBST     MIINDX:1      WZONE             2
     C                   MOVEL     WZONE         WZONEN            3 0
     C                   MOVEL     WZONEN        WZONEA            2
     C                   MOVE      *OFF          *IN38
     C     WZONE         IFEQ      WZONEA
     C                   MOVE      *ON           *IN38
     C                   ENDIF
     C                   MOVE      MIINDX        KINDX
     C                   MOVE      #2SARN        KSARN
     C     KRST          CHAIN     SCSARIL4                           36
     C                   ENDDO
      *                                                                                       CSF002
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
      ** Menu Item Short Code                                                                 CSF002
      *                                                                                       CSF002
     C********** WZMGRP    CASNE#2MGRP    FBRQRL           Menu Group Code                    CSF002
     C     WZSNAM        CASNE     #2SNAM        FBRQRL
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
      * Print  Switchable F - Men - Switchable F - Menu Items  *
     C                   CALL      'SC3060P'                            90      Print  Switchab
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      P1SARN        WQ0001            6            Switchable Feat
     C                   PARM      P2SARD        WQ0002           50            Description
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3060P'     W0CLPG
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
      * Send message 'Switch F Rept - Menu Item'
     C                   MOVEL     'CBM0041'     ZAMSID
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
     C********** #1MGRP    CABNE*BLANK    DDEXIT           Menu Group Code                    CSF002
     C     #1SNAM        CABNE     *BLANK        DDEXIT
     C********** #RICDF    CABNE*BLANK    DDEXIT           Short code for                     CSF002
     C     #1AVAL        CABNE     *BLANK        DDEXIT                         Avail if featur
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      **Check*Menu*Group*Code*is*numeric******************************                        CSF002
     C**********           MOVEL*IN90     XG90    1                                           CSF002
     C**********           TESTN          #1MGRP     90  90*                                  CSF002
     C***90*****           MOVE #1MGRP    XGX1    1                                           CSF002
     C***90*****           TESTB'0123'    XGX1           90*                                  CSF002
     C**All*blank*is*OK***********************************************                        CSF002
     C**N90***** #1MGRP    COMP *BLANKS                  90*                                  CSF002
     C**'?'*is*OK*****************************************************                        CSF002
     C**N90*****           MOVEL#1MGRP    XGX1                                                CSF002
     C**N90***** XGX1      COMP '?'                      90*                                  CSF002
     C********** *IN90     IFEQ '0'                                                           CSF002
     C**Send*message*'*Field*must*be*numeric'*************************                        CSF002
     C**********           MOVEL'Y2U0010' ZAMSID                                              CSF002
     C**********           MOVEL'Y2USRMSG'ZAMSGF                                              CSF002
     C**********           EXSR ZASNMS                                                        CSF002
     C**********           SETON                     9833  *                                  CSF002
     C**********           END                                                                CSF002
     C**********           MOVELXG90      *IN90                                               CSF002
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
      * Validate Menu Item (and retrieve narrative) (only in add mode)
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
      * Validate Menu item
     C                   MOVEL     *BLANK        WURTCD                         Access Obj Retu
     C                   MOVEL     *BLANK        WUOPTN                         Access Obj Acce
     C                   MOVEL     '*KEY'        WUOPTN                         Access Obj Acce
     C**********           MOVEL#1MGRP    WUMGRP           Menu Group Code                    CSF002
     C**********           MOVEL#RICDF    WUICDE           Menu Item Short                    CSF002
     C                   MOVEL     #1SNAM        WUSNAM
      * Get Menu Item Narr ->DSPF - Standard functions  *
      *
     C*
     C** Move Synon work fields into parameters
     C*
     C     WUSNAM        CHAIN     GPMTXTL3                           37
     C     2             SUBST     MIINDX:1      WZONE             2
     C                   MOVEL     WZONE         WZONEN            3 0
     C                   MOVEL     WZONEN        WZONEA            2
     C     WZONE         IFNE      WZONEA
     C     WZONE         ANDNE     LIBR
     C     *IN37         ANDEQ     *OFF
     C                   MOVE      *ON           *IN37
     C                   ENDIF
     C**********           CALL 'AOMITMR0'                                                    CSF002
     C**********           PARM           WURTCD           B:Return code                      CSF002
     C**********           PARM           WUOPTN           I:Option                           CSF002
     C**********           PARM           WUMGRP           Group Code                         CSF002
     C**********           PARM           WUICDE           Short Code                         CSF002
     C********** P@MITM    PARM P@MITM    P@FMT            O:Format                           CSF002
     C*
     C** If record found, copy menu item narrative to screen field
     C*
     C********** WUOPTN    IFNE '*FREE'                                                       CSF002
     C     *IN37         IFEQ      *OFF
     C                   MOVEL     *BLANKS       #1INAR
     C********** WURTCD    IFEQ *BLANKS                                                       CSF002
     C**********           MOVELINAR      #1INAR                                              CSF002
     C**********           END                                                                CSF002
     C                   MOVEL     MIINAR        #1INAR
     C                   END
      * If menu item access is successful :
      * (i)  If the menu item narrative on screen is different from
      *      hidden screen field, then redisplay screen
      * (ii) copy the menu item narrative to the screen hidden field
      * CASE: WRK.Access Obj Return Code is Normal - no errors found
     C********** WURTCD    IFEQ *BLANK                     *IF                                CSF002
     C     *IN37         IFEQ      *OFF
      * CASE: RCD.Menu Item Narrative NE RCD.Narrative for Menu Item
     C     #1INAR        IFNE      #RNARI                                       *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   MOVEL     #1INAR        #RNARI                         Narrative for M
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C**********           MOVEL#1MGRP    ZA0002           Menu Group Code                    CSF002
     C**********           MOVEL#RICDF    ZA0003           Short code for                     CSF002
     C                   MOVEL     #1SNAM        ZA0002
      * Send message 'Menu Item doesn't exist'
     C                   MOVEL     'CBM0049'     ZAMSID
     C                   EXSR      ZASNMS
     C**********           SETON                     983334*                                  CSF002
     C                   SETON                                        9833
      *
     C                   END                                                    *FI
     C**Close*files*in*access*programs********************************                        CSF002
     C**********           MOVEL*BLANK    WURTCD           Access Obj Retu                    CSF002
     C**********           MOVEL*BLANK    WUOPTN           Access Obj Acce                    CSF002
     C**********           MOVEL'*FREE'   WUOPTN           Access Obj Acce                    CSF002
     C**********           MOVEL#1MGRP    WUMGRP           Menu Group Code                    CSF002
     C**********           MOVEL#RICDF    WUICDE           Menu Item Short                    CSF002
      **Get*Menu*Item*Narr*->DSPF*-*Standard functions****************                        CSF002
     C****************************************************************                        CSF002
     C***Move*Synon*work*fields*into*parameters***********************                        CSF002
     C****************************************************************                        CSF002
     C**********           CALL 'AOMITMR0'                                                    CSF002
     C**********           PARM           WURTCD           B:Return code                      CSF002
     C**********           PARM           WUOPTN           I:Option                           CSF002
     C**********           PARM           WUMGRP           Group Code                         CSF002
     C**********           PARM           WUICDE           Short Code                         CSF002
     C********** P@MITM    PARM P@MITM    P@FMT            O:Format                           CSF002
     C****************************************************************                        CSF002
     C***If*record*found,*copy*menu*item*narrative*to*screen*field****                        CSF002
     C****************************************************************                        CSF002
     C********** WUOPTN    IFNE '*FREE'                                                       CSF002
     C**********           MOVEL*BLANKS   #1INAR                                              CSF002
     C********** WURTCD    IFEQ *BLANKS                                                       CSF002
     C**********           MOVELINAR      #1INAR                                              CSF002
     C**********           END                                                                CSF002
     C**********           END                                                                CSF002
     C                   END                                                    *FI
      * Validate Display Item ?
      * CASE: RCD.Avail if feature present? is Valid values
     C     #1AVAL        IFEQ      'N'                                          *IF
     C     #1AVAL        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1AVAL        ZA0004                         Avail if featur
      * Send message 'Disply Item must be 'Y/N''
     C                   MOVEL     'CBM0031'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9835      *
      *
     C                   END                                                    *FI
      * Validate subfile record relations
     C                   EXSR      DFV2RC
     C**Menu*Group*Code*required**************************************                        CSF002
      ** Menu Item Short Code Required                                                        CSF002
     C********** #1MGRP    IFEQ *BLANK                     IF                                 CSF002
     C     #1SNAM        IFEQ      *BLANK
     C                   SETON                                        9833      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Avail if feature present? required
     C     #1AVAL        IFEQ      *BLANK                                       IF
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
      * USER: Validate subfile record relations
     C**********           MOVEL#RICDF    #1ICDE           Menu Item Short                    CSF002
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
      * Create Switchable F - Men - Switchable F - Menu Items  *
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
      * Delete object - Switchable F - Menu Items  *
     C                   EXSR      SBDLRC
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
      * Change Switchable F - Men - Switchable F - Menu Items  *
     C                   EXSR      SCCHRC
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
     C                   MOVEL     *IN87         *IN79
     C     W0PMD         IFEQ      'CHG'                                        *IF
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
     C                   MOVEL     *BLANK        #RNARI                         Narrative for M
     C                   MOVEL     P1SARN        #1SARN                         Switchable Feat
     C**********           MOVEL*BLANK    #1ICDE           Menu Item Short                    CSF002
     C                   MOVEL     *BLANK        #1RECI                         Record id
     C                   Z-ADD     *ZERO         #1LCD                          Last change dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of the Las
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C**********           MOVEL*BLANK    #1MGRP           Menu Group Code                    CSF002
     C**********           MOVEL*BLANK    #RICDF           Short code for                     CSF002
     C                   MOVEL     *BLANK        #1INDX
     C                   MOVEL     *BLANK        #1SNAM
     C                   MOVEL     *BLANK        #1AVAL                         Avail if featur
     C                   MOVEL     *BLANK        #1INAR                         Menu Item Narra
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      **Move*@SARIL2*fields*to*subfile********************************                        CSF002
      ** Move GPMTXTPD and SCSARIPD fields to subfile                                         CSF002
      *================================================================
     C                   MOVEL     ADSARN        #1SARN                         Switchable Feat
     C**********           MOVELADICDE    #1ICDE           Menu Item Short                    CSF002
     C                   MOVEL     ADRECI        #1RECI                         Record id
     C                   Z-ADD     ADLCD         #1LCD                          Last change dat
     C                   MOVEL     ADTYLC        #1TYLC                         Type of the Las
     C**********           MOVELADMGRP    #1MGRP           Menu Group Code                    CSF002
     C                   MOVEL     ADINDX        #1INDX
     C                   MOVEL     MISNAM        #1SNAM
     C                   MOVEL     ADAVAL        #1AVAL                         Avail if featur
     C                   MOVEL     ADINAR        #1INAR                         Menu Item Narra
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
     C**********           MOVEL*BLANK    #2MGRP           Menu Group Code                    CSF002
     C                   MOVEL     *BLANK        #2SNAM
      * Check restriction within
     C                   EXSR      VACKRL
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Switchable F - Men - Switchable F - Menu Items  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      **Move*all*fields*to*@SARIL0************************************                        CSF002
      * Move all fields to SCSARID0                                                           CSF002
     C                   MOVEL     P1SARN        ADSARN                         Switchable Feat
     C**********           MOVEL#1MGRP    ADMGRP           Menu Group Code                    CSF002
     C**********           MOVEL#1ICDE    ADICDE           Menu Item Short                    CSF002
     C                   MOVEL     MIINDX        ADINDX
     C                   MOVEL     'D'           ADRECI                         Record id
     C                   MOVEL     #1AVAL        ADAVAL                         Avail if featur
     C                   MOVEL     #1INAR        ADINAR                         Menu Item Narra
     C                   Z-ADD     WUAKTX        ADLCD                          Last change dat
     C                   MOVEL     'I'           ADTYLC                         Type of the Las
      *
     C     KLCRSA        KLIST
     C                   KFLD                    ADSARN                         Switchable Feat
     C**********           KFLD           ADMGRP           Menu Group Code                    CSF002
     C**********           KFLD           ADICDE           Menu Item Short                    CSF002
     C                   KFLD                    ADINDX
      * Check for duplicate primary key
     C********** KLCRSA    SETLL@SARIL0                  90*                                  CSF002
     C     KLCRSA        SETLL     SCSARID0                               90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CBM0009'     W0RTN             7
      * Send message 'Switchable F - Menu It EX'
     C                   MOVEL     'CBM0009'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   END
      *
     C**********           WRITE@SARIL0                91  *                                  CSF002
     C                   WRITE     SCSARID0                             91      *
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
      * Delete object - Switchable F - Menu Items  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      **Move*key*fields*to*@SARIL0************************************                        CSF002
      ** Move key fields to SCSARID0                                                          CSF002
     C                   MOVEL     #1SARN        ADSARN                         Switchable Feat
     C**********           MOVEL#1MGRP    ADMGRP           Menu Group Code                    CSF002
     C**********           MOVEL#1ICDE    ADICDE           Menu Item Short                    CSF002
     C                   MOVEL     #1INDX        ADINDX
      *
     C     KLDLSB        KLIST
     C                   KFLD                    ADSARN                         Switchable Feat
     C**********           KFLD           ADMGRP           Menu Group Code                    CSF002
     C**********           KFLD           ADICDE           Menu Item Short                    CSF002
     C                   KFLD                    ADINDX
     C********** KLDLSB    CHAIN@SARIL0              9091  *                                  CSF002
     C     KLDLSB        CHAIN     SCSARID0                           9091      *
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
     C********** KLDLSB    SETLL@SARIL0              9091  *                                  CSF002
     C     KLDLSB        SETLL     SCSARID0                           9091      *
     C                   GOTO      SBEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C**********           DELET@SARIL0                91  *                                  CSF002
     C                   DELETE    SCSARID0                             91      *
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Change Switchable F - Men - Switchable F - Menu Items  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      **Move*key*fields*to*@SARIL0************************************                        CSF002
      ** Move key fields to SCSARID0                                                          CSF002
     C                   MOVEL     #1SARN        ADSARN                         Switchable Feat
     C**********           MOVEL#1MGRP    ADMGRP           Menu Group Code                    CSF002
     C**********           MOVEL#1ICDE    ADICDE           Menu Item Short                    CSF002
     C                   MOVEL     #1INDX        ADINDX
      *
     C     KLCHSC        KLIST
     C                   KFLD                    ADSARN                         Switchable Feat
     C**********           KFLD           ADMGRP           Menu Group Code                    CSF002
     C**********           KFLD           ADICDE           Menu Item Short                    CSF002
     C                   KFLD                    ADINDX
     C********** KLCHSC    CHAIN@SARIL0              9091  *                                  CSF002
     C     KLCHSC        CHAIN     SCSARID0                           9091      *
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
     C**********           UNLCKSCSARIL0               91  *                                  CSF002
     C                   UNLOCK    SCSARIL4                             91      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YARDCS
      **Move*non-key*fields*to*@SARIL0********************************                        CSF002
      ** Move non-key fields to SCSARID0                                                      CSF002
     C                   MOVEL     #1RECI        ADRECI                         Record id
     C                   MOVEL     #1AVAL        ADAVAL                         Avail if featur
     C                   MOVEL     #1INAR        ADINAR                         Menu Item Narra
     C                   Z-ADD     WUAKTX        ADLCD                          Last change dat
     C                   MOVEL     'A'           ADTYLC                         Type of the Las
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C**********           UPDAT@SARIL0                91  *                                  CSF002
     C                   UPDATE    SCSARID0                             91      *
     C                   ELSE
      * Release record lock
     C**********           UNLCKSCSARIL0               91  *                                  CSF002
     C                   UNLOCK    SCSARIL4                             91      *
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
      * Obtain default message file
     C     *DTAARA       DEFINE    CBMGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Access Obj Return Code
     C                   MOVEL     *BLANK        WURTCD            7
      * Define work field Access Obj Access Option
     C                   MOVEL     *BLANK        WUOPTN            7
      **Define*work*field*Menu*Group*Code*****************************                        CSF002
     C**********           MOVEL*BLANK    WUMGRP  4                                           CSF002
      **Define*work*field*Menu*Item*Short*Code************************                        CSF002
     C**********           MOVEL*BLANK    WUICDE  4                                           CSF002
      ** Define work field Menu Item Short Code                                               CSF002
     C                   MOVEL     *BLANK        WUSNAM           20
      * Define work field Access obj rcd fmt (800)
     C                   MOVEL     *BLANK        WUA800
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
     C                   OPEN      SC3060M#
     C**********           OPEN SCSARIL2                                                      CSF002
     C                   OPEN      GPMTXTL3
     C*********************OPEN SCSARDL1                                        CSC007
     C**********         OPEN      SCSARSL1                                                 MD055681
     C**********           OPEN SCSARIL0                                                      CSF002
     C                   OPEN      SCSARIL4
     C                   OPEN      GPZONEL2
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     08            ##SFPG            3 0          SFLPAG
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
      * SC3060M Precompiler - Switchable F - Menu Items  *
      * Copyright Statement 1993 - Standard functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      * Get System Prefix                                                                     CSF002
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
     C                   MOVE      MRDT          ##AANA            7
     C                   MOVE      MRDT          WUAANA
     C                   MOVE      RDNB          WUAKTX
     C                   MOVE      SUC           WUAUST
     C                   MOVE      DFF           WUE3ST
     C                   MOVE      MBIN          WUF1ST
      *                                                                                       CSF002
      ** Get the zone name.                                                                   CSF002
      *                                                                                       CSF002
     C     LIBR          CHAIN     GPZONEL2                           39
     C     *IN39         IFEQ      *OFF
     C                   MOVE      ZOZONE        ##ZONE
     C                   ENDIF
      *                                                                                       CSF002
      * Start of change CAAA01 - Increase access object rtn code to 800.
      * Define 800 byte DS for AP - Standard functions  *
      * End of change CAAA01
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
     C/COPY WNCPYSRC,SC3060MPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SC3060MPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINS                                                              MD055681
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055681
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SC3060MPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001

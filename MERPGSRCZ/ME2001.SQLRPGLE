     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/**** *  TEXT('Midas ME Outgoing msgs settled in 'In' ccy list')      *                     MD058081
/*EXI *  TEXT('Midas ME Outgoing msgs settled in  In  ccy list')      *                     MD058081
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME2001 - Outgoing Messages Settled in 'In' Currency List     *
      *                                                               *
      *  Function:   This program will list outgoing messages that    *
      *  (I/C & COB) are bound to be 'NAKed' by SWIFT as a result of  *
      *              using 'In' currencies in settling amounts after  *
      *              the EMU Transition Period End Date defined on    *
      *              the currencies table.                            *
      *                                                               *
      *  Called By: MEC0201 - Outgoing Messages Settled in 'In'       *
      *                       Currency List                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058081           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CPK024             Date 12Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 199092             Date 18Oct01               *
      *                 198208             Date 25Sep01               *
      *                 197580             Date 05Sep01               *
      *                 CSW201  *CREATE    Date 02May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by    *
      *           UTC0012.                                            *
      *  199092 - SWIFT2001:  ME2001 dbase error when SWIFT ccy <>    *
      *           Midas Currency Code                                 *
      *  198208 - Multiple messages MT203/210/580 should include      *
      *           undeleted parts in the list.                        *
      *           Also correction on 197580.  It should be CEU002,    *
      *           and not CEU001.                                     *
      *  197580 - Program should access CEU001 and not CFT007.        *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *                                                               *
      *****************************************************************
     FMGOREFLU  IF   E           K DISK
     FMGOMSGLA  IF   E           K DISK
     FMGOMSGLB  IF   E           K DISK
     F                                     RENAME(MGOMSGD0:MGOMSGDA)
     F*MEINCYPD* IF   E           K DISK                                                    MD058081
     FSDCURRLD  IF   E           K DISK
     FME2001AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
     FME2001P1  O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   86  - READE Indicator for LF/MGOMSGLB                       *
      *   87  - OPEN ME2001P1 Indicator                               *
      *   88  - READE Indicator for LF/MGOMSGLA                       *
      *   89  - End of File                                           *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Program Initialisation                              *
      *  SRPROC - Detail Processing                                   *
      *  SRREPT - Process Report Lines                                *
      *  SRWRIT - Format and Write a Detail Record to the Report      *
      *  SREND  - Write End of Report                                 *
      *  SRAUDT - Produce Audit Report and End Program                *
      *  RCFP1  - RCF Processing for P1 Report                        *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
     D/EJECT
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D SPOOL1          DS
      ** File Information Data Structure for ME2001P1
      *
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      ** File Information Data Structure for ME2001AU
      *
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D LDA           E DS           256
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Short Data Structure used by Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Long Data Structure used by Access Programs
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structures for Currency Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External data structures for Switchable features
      *
     D*COPY*ZSRSRC,ZDAT10Z1                                                                 MD058081
     D/COPY ZSRSRC,ZDAT10Z1LE                                                               MD058081
      *
     D WCNNUM          C                   CONST('0123456789')
      ** Array containing Copyright statement
     D MEINCY        E DS                  EXTNAME(MEINCJW0)                                MD058081
      *
     I*COPY*ZSRSRC,ZDATE2Z1                                                                 MD058081
     D/COPY ZSRSRC,ZDATE2Z1LE                                                               MD058081
     I*COPY*ZSRSRC,ZDATE9Z1                                                                 MD058081
     D/COPY ZSRSRC,ZDATE9Z1LE                                                               MD058081
     I*COPY*ZSRSRC,ZALIGNZ1                                               S01117            MD058081
     D/COPY ZSRSRC,ZALIGNZ1LE                                                               MD058081
      *****************************************************************
      /SPACE 3
      *****************************************************************
     IMGOMSGD0
     I              TRNO                        OTRNO
      *
     IMGOMSGDA
     I              MTAG                        PMTAG
     I              MFLD                        PMFLD
     I              CTRC                        PCTRC
     I              TRNO                        PTRNO
     I              PTDL                        PPTDL
     I              MSEQ                        PMSEQ
      ** Numeric constants
      *
      *****************************************************************
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform Initialisation
      *
     C                   EXSR      SRINIT
      *
      ** Perform Detail Processing
      *
     C                   EXSR      SRPROC
      *
      ** Output Audit Report and End Program
      *
     C                   EXSR      SRAUDT
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do Program Initialisation             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: RCFAU - RCF Processing for Audit Report               *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Receive Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ              5
      *
      ** Initialise LDA field
      *
     C                   MOVEL     'ME2001'      DBPGM
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      **                           MMDDYY (*IN98 on)
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Check if EMU switchable feature is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C**********           PARM 'CFT007'  @SARD   6                                           197580
     C**********           PARM 'CEU001'  @SARD   6                                    197580 198208
     C                   PARM      'CEU002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C**********           MOVE 'Y'       CFT007  1                                           197580
     C**********           MOVE 'Y'       CEU001  1                                    197580 198208
     C                   MOVE      'Y'           CEU002            1
     C                   ELSE
     C**********           MOVE 'N'       CFT007                                              197580
     C**********           MOVE 'N'       CEU001                                       197580 198208
     C                   MOVE      'N'           CEU002
     C                   ENDIF
      *
      ** RCF Processing for Audit File
      *
     C                   EXSR      RCFAU
      *
      ** Report Work fields
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRPROC
      *****************************************************************
      *                                                               *
      *  SRPROC - Subroutine to do the Detail Processing              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: SRAUDT - Produce Audit Report and End Program         *
      *         SRREPT - Process Report Lines                         *
      *         SREND  - Write End of Report                          *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
      ** Read first record from File
      *
     C                   READ      MGOREFLU                               89
      *
      ** If End of Records, (*IN89), Perform: Audit Reporting (No
      ** Records)
      *
     C     *IN89         IFEQ      *ON
     C                   EXSR      SRAUDT
     C                   ENDIF
      *
      ** Do Until End of File
      *
     C     *IN89         DOUEQ     *ON
      *
      ** Process Report Lines
      *
     C                   EXSR      SRREPT
      *
      ** Read next record
      *
     C                   READ      MGOREFLU                               89
      *
      ** End of Do Until End of Valid Records
      *
     C                   ENDDO
      *
      ** Write final records and Totals to Report
      *
     C                   EXSR      SREND
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRREPT
      *****************************************************************
      *                                                               *
      *  SRREPT - Process Report Lines                                *
      *                                                               *
      *  Called By: SRPROC                                            *
      *                                                               *
      *  Calls: SRCURR - Subroutine to Check for 'In' Currency        *
      *                                                               *
      *****************************************************************
      *
     C     SRREPT        BEGSR
     C*                                                                                       198208
      * Ignore cancelled messages                                                             198208
     C     CARQ          IFEQ      'Y'
     C                   GOTO      ENDRPT
     C                   ENDIF
      *                                                                                       198208
      **  Process multiple messages first (including single MT210)                            198208
     C     MTPY          IFEQ      '203'
     C     MTPY          OREQ      '210'
     C     MTPY          OREQ      '580'
      *                                                                                       198208
      ** Ignore first MT210 record                                                            198208
     C     MTPY          IFEQ      '210'
     C     TRNF          ANDEQ     *BLANKS
     C     TRNM          ANDNE     *BLANKS
     C                   GOTO      ENDRPT
     C                   ENDIF
      *                                                                                       198208
      ** Ignore part deleted or sent but cancelled                                            198208
      *                                                                                       198208
     C     PTST          IFEQ      'D'
     C                   GOTO      ENDRPT
     C                   ENDIF
      *                                                                                       198208
      ** Else process........just take currency and date from MGOREFPD record                 198208
      *                                                                                       198208
     C                   MOVEL     SVDT          WVDAT
     C                   MOVEL     CCY           WCCY
     C                   MOVEL     TRNO          OTRNO
     C                   EXSR      SRCURR
      *                                                                                       198208
     C                   GOTO      ENDRPT
      *                                                                                       198208
     C                   ENDIF
      *                                                                                       198208
      **  Process other messages                                                              198208
      *
     C     TRNO          SETLL     MGOMSGLA
     C     TRNO          READE     MGOMSGLA                               88
      *
     C     *IN88         DOWEQ     *OFF
      *
     C                   MOVE      *BLANK        WINDV             1
     C                   Z-ADD     0             Y                 2 0
      *
      ** Format MT730/MT768/MT769 messages
      *
     C     MTPY          IFEQ      '730'
     C     MTPY          OREQ      '768'
     C     MTPY          OREQ      '769'
      *
     C     MTAG          IFEQ      ':32D:'
     C                   MOVEL     MFLD          WCDAT             9
     C                   MOVE      WCDAT         WCCY              3
     C                   MOVEL     WCDAT         WVDAT             6
     C                   EXSR      SRCURR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Format MT455 messages
      *
     C     MTPY          IFEQ      '455'
      *
     C     MTAG          IFEQ      ':32A:'
     C     MTAG          OREQ      ':33C:'
     C     MTAG          OREQ      ':33D:'
     C                   MOVEL     MFLD          WCDAT
     C                   MOVE      WCDAT         WCCY
     C                   MOVEL     WCDAT         WVDAT
     C                   EXSR      SRCURR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Format MT100/MT103/MT200/MT202/MT450 messages
      *
     C     MTPY          IFEQ      '100'
     C     MTPY          OREQ      '103'
     C     MTPY          OREQ      '200'
     C     MTPY          OREQ      '202'
     C     MTPY          OREQ      '450'
      *
     C     MTAG          IFEQ      ':32A:'
     C                   MOVEL     MFLD          WCDAT
     C                   MOVE      WCDAT         WCCY
     C                   MOVEL     WCDAT         WVDAT
     C                   EXSR      SRCURR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Format MT400/MT734/MT752 messages
      *
     C     MTPY          IFEQ      '400'
     C     MTPY          OREQ      '734'
     C     MTPY          OREQ      '752'
      *
     C     MTAG          IFEQ      ':33A:'
     C                   MOVEL     MFLD          WCDAT
     C                   MOVE      WCDAT         WCCY
     C                   MOVEL     WCDAT         WVDAT
     C                   EXSR      SRCURR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Format MT742/MT554 messages
      *
     C     MTPY          IFEQ      '742'
     C     MTPY          OREQ      '554'
      *
     C     MTAG          IFEQ      ':34A:'
     C                   MOVEL     MFLD          WCDAT
     C                   MOVE      WCDAT         WCCY
     C                   MOVEL     WCDAT         WVDAT
     C                   EXSR      SRCURR
     C                   ENDIF
      *
     C                   ENDIF
      * Separate multiple messages                                                            198208
      ***********                                                                             198208
      ***Format*MT203/MT210/MT580 messages                                                    198208
      ***********                                                                             198208
     C***********MTPY      IFEQ '203'                                                         198208
     C***********MTPY      OREQ '210'                                                         198208
     C***********MTPY      OREQ '580'                                                         198208
      ***********                                                                             198208
     C***********MTAG      IFEQ ':32B:'                                                       198208
      ***********                                                                             198208
     C***********TRNO      IFEQ PTRNO                                                         198208
     C***********          ADD  1         X       20                                          198208
     C***********          ELSE                                                               198208
     C***********          Z-ADD1         X                                                   198208
     C***********          ENDIF                                                              198208
      ***********                                                                             198208
     C***********          MOVE TRNO      PTRNO                                               198208
     C***********          MOVELMFLD      WCCY                                                198208
      ***********                                                                             198208
     C***********PTRNO     SETLLMGOMSGDA                                                      198208
     C***********PTRNO     READEMGOMSGDA                 86                                   198208
      ***********                                                                             198208
     C************IN86     DOUEQ*ON                                                           198208
     C***********WINDV     OREQ 'Y'                                                           198208
      ***********                                                                             198208
     C***********PMTAG     IFEQ ':30:'                                                        198208
     C***********          ADD  1         Y                                                   198208
      ***********                                                                             198208
     C***********X         IFEQ Y                                                             198208
     C***********          MOVELPMFLD     WVDAT                                               198208
     C***********          MOVE 'Y'       WINDV                                               198208
     C***********          ENDIF                                                              198208
      ***********                                                                             198208
     C***********          ENDIF                                                              198208
      ***********                                                                             198208
     C***********PTRNO     READEMGOMSGDA                 86                                   198208
      ***********                                                                             198208
     C***********          ENDDO                                                              198208
      ***********                                                                             198208
     C***********          EXSR SRCURR                                                        198208
      ***********                                                                             198208
     C***********          ENDIF                                                              198208
      ***********                                                                             198208
     C***********          ENDIF                                                              198208
      *
      ** Format MT456 messages
      *
     C     MTPY          IFEQ      '456'
     C     MTAG          ANDEQ     ':33D:'
     C                   MOVEL     MFLD          WCDAT
     C                   MOVE      WCDAT         WCCY
     C                   MOVEL     WCDAT         WVDAT
     C                   EXSR      SRCURR
     C                   ENDIF
      *
      ** Format MT101 messages
      *
     C     MTPY          IFEQ      '101'
      *
     C     MTAG          IFEQ      ':32B:'
      *
     C                   MOVE      TRNO          PTRNO
     C                   MOVEL     MFLD          WCCY
      *
     C     PTRNO         SETLL     MGOMSGDA
     C     PTRNO         READE     MGOMSGDA                               86
      *
     C     *IN86         DOUEQ     *ON
     C     WINDV         OREQ      'Y'
      *
     C     PMTAG         IFEQ      ':30:'
     C                   MOVEL     PMFLD         WVDAT
     C                   MOVE      'Y'           WINDV
     C                   ENDIF
      *
     C     PTRNO         READE     MGOMSGDA                               86
      *
     C                   ENDDO
      *
     C                   EXSR      SRCURR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Format MT102 messages
      *
     C     MTPY          IFEQ      '102'
     C     MTAG          ANDEQ     ':32A:'
     C                   MOVEL     MFLD          WCDAT
     C                   MOVE      WCDAT         WCCY
     C                   MOVEL     WCDAT         WVDAT
     C                   EXSR      SRCURR
     C                   ENDIF
      *
      ** Format MT405 messages
      *
     C     MTPY          IFEQ      '405'
     C     MTAG          ANDEQ     ':32C:'
     C                   MOVEL     MFLD          WCDAT
     C                   MOVE      WCDAT         WCCY
     C                   MOVEL     WCDAT         WVDAT
     C                   EXSR      SRCURR
     C                   ENDIF
      *
      ** Format MT521/MT523 messages
      *
     C     MTPY          IFEQ      '521'
     C     MTPY          OREQ      '523'
      *
     C     MTAG          IFEQ      ':32B:'
      *
     C                   MOVE      TRNO          PTRNO
     C                   MOVEL     MFLD          WCCY
      *
     C     PTRNO         SETLL     MGOMSGDA
     C     PTRNO         READE     MGOMSGDA                               86
      *
     C     *IN86         DOUEQ     *ON
     C     WINDV         OREQ      'Y'
      *
     C     PMTAG         IFEQ      ':30:'
     C                   MOVEL     PMFLD         WVDAT
     C                   MOVE      'Y'           WINDV
     C                   ENDIF
      *
     C     PTRNO         READE     MGOMSGDA                               86
      *
     C                   ENDDO
      *
     C                   EXSR      SRCURR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Format MT515 messages
      *
     C     MTPY          IFEQ      '515'
      *
     C                   MOVEL     MFLD          WSETT             7
      *
     C     MTAG          IFEQ      ':98A:'
     C     MSEQ          ANDEQ     'C'
     C     WSETT         ANDEQ     ':SETT//'
     C     MTAG          OREQ      ':98C:'
     C     MSEQ          ANDEQ     'C'
     C     WSETT         ANDEQ     ':SETT//'
      *
     C                   MOVEL     MFLD          WSDAT            15
      *
     C                   MOVE      WSDAT         WRK98             8
     C                   MOVE      WRK98         ZZDTIN
     C                   EXSR      ZDAT10
     C                   Z-ADD     ZZMDNO        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         WNEWD
      *
     C                   MOVE      TRNO          PTRNO
      *
     C     PTRNO         SETLL     MGOMSGDA
     C     PTRNO         READE     MGOMSGDA                               86
      *
     C     *IN86         DOUEQ     *ON
      *
     C                   MOVEL     PMFLD         WSETT
      *
     C     PMTAG         IFEQ      ':19A:'
     C     PMSEQ         ANDEQ     'C'
     C     WSETT         ANDEQ     ':SETT//'
     C     PMTAG         OREQ      ':19A:'
     C     PMSEQ         ANDEQ     'D3'
     C     WSETT         ANDEQ     ':SETT//'
      *
     C     3             SUBST     PMFLD:8       WCCY
      *
     C     1             SUBST     PMFLD:8       WSIGN             1
     C     WSIGN         IFEQ      'N'
     C     1             SUBST     PMFLD:11      WFAM              1
     C     WCNNUM        CHECK     WFAM          WALPFL            1 0
     C     WALPFL        IFNE      *ZERO
     C     3             SUBST     PMFLD:9       WCCY
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      SRCURR
     C                   ENDIF
      *
     C     PTRNO         READE     MGOMSGDA                               86
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Format MT518 messages
      *
     C     MTPY          IFEQ      '518'
      *
     C                   MOVEL     MFLD          WSETT
      *
     C     MTAG          IFEQ      ':98A:'
     C     MSEQ          ANDEQ     'B'
     C     WSETT         ANDEQ     ':SETT//'
     C     MTAG          OREQ      ':98C:'
     C     MSEQ          ANDEQ     'B'
     C     WSETT         ANDEQ     ':SETT//'
      *
     C                   MOVEL     MFLD          WSDAT
      *
     C                   MOVE      WSDAT         WRK98
     C                   MOVE      WRK98         ZZDTIN
     C                   EXSR      ZDAT10
     C                   Z-ADD     ZZMDNO        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         WNEWD
      *
     C                   MOVE      TRNO          PTRNO
      *
     C     PTRNO         SETLL     MGOMSGDA
     C     PTRNO         READE     MGOMSGDA                               86
      *
     C     *IN86         DOUEQ     *ON
      *
     C                   MOVEL     PMFLD         WSETT
      *
     C     PMTAG         IFEQ      ':19A:'
     C     PMSEQ         ANDEQ     'B'
     C     WSETT         ANDEQ     ':SETT//'
     C     PMTAG         OREQ      ':19A:'
     C     PMSEQ         ANDEQ     'C3'
     C     WSETT         ANDEQ     ':SETT//'
      *
     C     3             SUBST     PMFLD:8       WCCY
      *
     C     1             SUBST     PMFLD:8       WSIGN
     C     WSIGN         IFEQ      'N'
     C     1             SUBST     PMFLD:11      WFAM
     C     WCNNUM        CHECK     WFAM          WALPFL
     C     WALPFL        IFNE      *ZERO
     C     3             SUBST     PMFLD:9       WCCY
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      SRCURR
     C                   ENDIF
      *
     C     PTRNO         READE     MGOMSGDA                               86
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next message
      *
     C     TRNO          READE     MGOMSGLA                               88
      *
     C                   ENDDO
      *
     C     ENDRPT        TAG
     C*                                                                                      198208
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRCURR
      *****************************************************************
      *                                                               *
      *  SRCURR - Subroutine to Check for 'In' Currency               *
      *                                                               *
      *  Called By: SRREPT                                            *
      *                                                               *
      *  Calls: SRWRIT - Format & Write a Detail Record to the Report *
      *                                                               *
      *****************************************************************
      *
     C     SRCURR        BEGSR
      *
     C                   MOVE      *BLANKS       WEMUD
      *
      ** Check if EMU feature is switched on. If yes, process
      ** using the Midas currency file.
      *
     C********** CFT007    IFEQ 'Y'                                                           197580
     C********** CEU001    IFEQ 'Y'                                                    197580 198208
     C     CEU002        IFEQ      'Y'
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCCY          @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
      *                                                                                       199092
      * Access SDCURRLD keyed by SWIFT currency code, incase this is different from           199092
      * Midas currency code.                                                                  199092
      *                                                                                       199092
     C     WCCY          CHAIN     SDCURRLD                           88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   MOVEL     @OPTN         DBOPTN            7
     C                   MOVEL     @CCY          DBKEY            29
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     A6INCY        IFEQ      'Y'
     C                   Z-ADD     A6TPED        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         WEMUD
     C                   ENDIF
     C                   ENDIF
      *
      ** Otherwise, retrieve currency details in ME In currency file.
      *
     C                   ELSE
      *
     C*****WCCY          CHAIN     MEINCYPD                           01                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEINCY                                                                        MD058081
     C+ from MEINCJW0                                                                       MD058081
     C+ where M1CCY  = :WCCY                                                                MD058081
     C/END-EXEC                                                                             MD058081
     C******IN01         IFEQ      *OFF                                                     MD058081
     C     SQLCODE       IFEQ      0                                                        MD058081
     C                   Z-ADD     MEEDT         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         WEMUD             6
     C                   ENDIF
     C                   ENDIF
      *
      ** Format EMU Transition End Date for comparison with Value Date
      *
     C     WEMUD         IFNE      *BLANKS
      *
     C     MTPY          IFNE      '515'
     C     MTPY          ANDNE     '518'
     C                   EXSR      SRVDAT
     C                   ENDIF
      *
     C                   MOVE      WNEWD         ZDATE
     C                   EXSR      ZDATE1
     C                   MOVE      ZDAYNO        WNEWD2            5 0
      *
     C********** CFT007    IFEQ 'Y'                                                           197580
     C********** CEU001    IFEQ 'Y'                                                    197580 198208
     C     CEU002        IFEQ      'Y'
     C     WNEWD2        ANDGT     A6TPED
     C********** CFT007    OREQ 'N'                                                           197580
     C********** CEU001    OREQ 'N'                                                    197580 198208
     C     CEU002        OREQ      'N'
     C     WNEWD2        ANDGT     MEEDT
     C                   EXSR      SRWRIT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRVDAT
      *****************************************************************
      *                                                               *
      *  SRVDAT - Subroutine to Process Value Date                    *
      *                                                               *
      *  Called By: SRCURR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRVDAT        BEGSR
      *
      ** Change date format from YYMMDD to MMDDYY
      *
     C     *IN98         IFEQ      *ON
     C                   MOVE      WVDAT         WMMDD             4
     C                   MOVEL     WVDAT         WYEAR             2
     C     WMMDD         CAT       WYEAR         WNEWD             6
     C                   ELSE
     C                   MOVE      WVDAT         WMMDD
     C                   MOVEL     WVDAT         WYEAR
     C                   MOVEL     WMMDD         WMONTH            2
     C                   MOVE      WMMDD         WDAY              2
     C     WDAY          CAT       WMONTH        WMMDD
     C     WMMDD         CAT       WYEAR         WNEWD
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRWRIT
      *****************************************************************
      *                                                               *
      *  SRWRIT - Subroutine to Write a Detail record to the Report   *
      *                                                               *
      *  Called By: SRPROC                                            *
      *                                                               *
      *  Calls: RCFP1                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRWRIT        BEGSR
      *
     C     *IN87         IFEQ      *OFF
     C                   OPEN      ME2001P1
     C                   EXSR      RCFP1
     C                   MOVE      *ON           *IN87
     C                   ENDIF
      *
      ** Move fields for report
      *
     C                   MOVE      WNEWD         ZDATE
     C                   EXSR      ZDATE1
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        RVDAT
      *
     C                   MOVE      OTRNO         TRNO
     C                   MOVE      WCCY          RCCY
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out Detail Record
      *
     C                   WRITE     DETAIL
      *
      ** Count records written
      *
     C                   ADD       1             RCOUNT
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SREND
      *****************************************************************
      *                                                               *
      *  SREND  - Subroutine to Write End of Report                   *
      *                                                               *
      *  Called By: SRPROC                                            *
      *                                                               *
      *  Calls: RCFP1                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
     C     *IN87         IFEQ      *OFF
     C                   OPEN      ME2001P1
     C                   EXSR      RCFP1
     C                   MOVE      *ON           *IN87
     C                   ENDIF
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page
      *
     C     RCOUNT        IFNE      0
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out Total Format
      *
     C                   WRITE     TRAILP1
      *
     C                   ENDIF
      *
     C                   CLOSE     ME2001P1
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRAUDT
      *****************************************************************
      *                                                               *
      *  SRAUDT - Subroutine to Output Audit Report and End Program   *
      *                                                               *
      *  Called By: Main Processing, SRPROC, *PSSR                    *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRAUDT        BEGSR
      *
      ** Output Report Header and File Controls
      *
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ** If there is a DB Error, Output the DB Error Information
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message
      *
     C     RCOUNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
      *
      ** End Program and Return
      *
     C                   CLOSE     ME2001AU
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/RCFP1
      *****************************************************************
      *                                                               *
      *  RCFP1  - Subroutine to register the P1 Printer File via RCF  *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BEGSR
      *
      ** Ensure Report Spool File recorded by RCF
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ               5
     C                   PARM                    SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
      *
     C     ZSERR         IFEQ      'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/RCFAU
      *****************************************************************
      *                                                               *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF  *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
      *
     C     ZSERR         IFEQ      'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   EXSR      SRAUDT
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/ZDATE1
     C*COPY*ZSRSRC,ZDATE1Z2                                                                 MD058081
     C/COPY ZSRSRC,ZDATE1Z2LE                                                               MD058081
      /TITLE SR/ZDATE2
     C*COPY*ZSRSRC,ZDATE2Z2                                                                 MD058081
     C/COPY ZSRSRC,ZDATE2Z2LE                                                               MD058081
      /TITLE SR/ZDATE10
     C*COPY*ZSRSRC,ZDAT10Z2                                                                 MD058081
     C/COPY ZSRSRC,ZDAT10Z2LE                                                               MD058081
      /TITLE SR/ZDATE1
     C***COPY*ZSRSRC,ZDAT1Z2*                                                                 CPK024
      /TITLE SR/ZALIGN
     C*COPY*ZSRSRC,ZALIGNZ2                                                                 MD058081
     C/COPY ZSRSRC,ZALIGNZ2LE                                                               MD058081
**  CPY@
(c) Finastra International Limited 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365

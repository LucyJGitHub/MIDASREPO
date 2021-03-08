     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas SC Switchable features by objects')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC3040M - Switchable Features by Object                      *
      *                                                               *
      *  Function:  This program allows the user to maintain the      *
      *             switchable objects data                           *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CCB008             Date 12Oct98               *
      *                 S01459             Date 12Oct98               *
      *                 S01407             Date 20Jan93               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - File removed from CB model.                       *
      *  S01459 - Addition of Midas Headerbox.                        *
      *  S01407 - Switchability Enhancements.                         *
      *                                                               *
      *****************************************************************
     FSC3040M#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SC Switchable features by objects
      *
     FSCSAROL1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Midas SC Switchable features - objects retrieval
      *
     F*SCSARDL1* IF   E           K DISK    USROPN                                          MD055681
     F**********                           INFDS(ID0001)                                    MD055681
     F**********                           INFSR(*PSSR)                                     MD055681
      * RTV : Midas SC Switchable features in system retrieval
      *
     FSCSAROL0  UF A E           K DISK    USROPN
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * UPD : Midas SC Switchable features - objects update
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
     D @1DBRC        E DS                  EXTNAME(SCSAROL0)
      * UPD : Midas SC Switchable features - objects update
      * Current/previous master file format fields for change control
      *
     D YARDCS          DS            89
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
      * Message data for 'Switch F Rept - Objects'
      * Switchable Feature Number
     D  ZA0001                 1      6
      * Message data for 'Object attribute invalid'
      * Object Attribute
     D  ZA0002                 1     10
      * Message data for 'Object attribute required'
      * Object Attribute
     D  ZA0003                 1     10
      * Message data for 'Object attri/type invalid'
      * Object Attribute
     D  ZA0004                 1     10
      * Object Type
     D  ZA0005                11     18
      * Message data for 'Run Object must be 'Y''
      * Avail if feature present?
     D  ZA0006                 1      1
      * Message data for 'Object attribute required'
      * Object Attribute
     D  ZA0007                 1     10
      * Message data for 'Object attri/type invalid'
      * Object Attribute
     D  ZA0008                 1     10
      * Object Type
     D  ZA0009                11     18
      * Message data for 'Object attribute required'
      * Object Attribute
     D  ZA0010                 1     10
      * Message data for 'Object attri/type invalid'
      * Object Attribute
     D  ZA0011                 1     10
      * Object Type
     D  ZA0012                11     18
      * Message data for 'Object attribute required'
      * Object Attribute
     D  ZA0013                 1     10
      * Message data for 'Object attri/type invalid'
      * Object Attribute
     D  ZA0014                 1     10
      * Object Type
     D  ZA0015                11     18
      * Message data for 'Object attribute required'
      * Object Attribute
     D  ZA0016                 1     10
      * Message data for 'Object attri/type invalid'
      * Object Attribute
     D  ZA0017                 1     10
      * Object Type
     D  ZA0018                11     18
      * Message data for 'Object attri not required'
      * Object Attribute
     D  ZA0019                 1     10
      * Object Type
     D  ZA0020                11     18
      * Message data for 'Object type invalid'
      * Object Type
     D  ZA0021                 1      8
      * Message data for 'Object attribute invalid'
      * Object Attribute
     D  ZA0022                 1     10
      * Message data for 'Allow Sel must be 'Y/N''
      * Avail if feature present?
     D  ZA0023                 1      1
      * Message data for 'Object Descr not entered'
      * Object Description
     D  ZA0024                 1     50
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D                                     PREFIX(AB)                                       MD055681
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
     C     *LIKE         DEFINE    #2OBNM        WZOBNM
     C                   MOVEL     #2OBNM        WZOBNM                         Object Name
     C     *LIKE         DEFINE    #2OBTP        WZOBTP
     C                   MOVEL     #2OBTP        WZOBTP                         Object Type
     C     KPOS          KLIST
     C                   KFLD                    AFSARN                         Switchable Feat
     C                   KFLD                    AFOBNM                         Object Name
     C                   KFLD                    AFOBTP                         Object Type
      * Setup key
     C                   MOVEL     #2SARN        AFSARN                         Switchable Feat
     C                   MOVEL     #2OBNM        AFOBNM                         Object Name
     C                   MOVEL     #2OBTP        AFOBTP                         Object Type
      * 82=EOF
     C     KPOS          SETLL     @SAROL1                            82        *
      * 82=EOF
     C     KRST          KLIST
     C                   KFLD                    AFSARN                         Switchable Feat
      * Setup key
     C                   MOVEL     #2SARN        AFSARN                         Switchable Feat
     C  N82KRST          READE     @SAROL1                              9182    *
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
     C  N82              READP     @SAROL1                                90    *
     C  N82              READ      @SAROL1                                90    *
     C                   END
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0            6
     C                   MOVE      *ALL'1'       WKIND1            6
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
     C     KRST          READE     @SAROL1                                82    *
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
      * Validate Object Type
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #2OBTP        W0NSRQ            1            Object Type
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1101943       Y2LSNO            7 0
     C     #2OBTP        PARM      #2OBTP        W0EXVL           20            Object Type
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      *................................................................
      * Change of position specified
     C     WZOBNM        CASNE     #2OBNM        FBRQRL                         Object Name
     C     WZOBTP        CASNE     #2OBTP        FBRQRL                         Object Type
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
      * Print  Switchable F - Obj - Switchable F - Objects  *
     C                   CALL      'SC3040P'                            90      Print  Switchab
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      P1SARN        WQ0001            6            Switchable Feat
     C                   PARM      P2SARD        WQ0002           50            Description
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3040P'     W0CLPG
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
      * Send message 'Switch F Rept - Objects'
     C                   MOVEL     'CBM0039'     ZAMSID
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
     C     #1OBNM        CABNE     *BLANK        DDEXIT                         Object Name
     C     #1OBTP        CABNE     *BLANK        DDEXIT                         Object Type
     C     #1OBAT        CABNE     *BLANK        DDEXIT                         Object Attribut
     C     #1AVAL        CABNE     *BLANK        DDEXIT                         Avail if featur
     C     #1OBTX        CABNE     *BLANK        DDEXIT                         Object Descript
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      * Validate Object Type
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1OBTP        W0NSRQ            1            Object Type
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1101943       Y2LSNO            7 0
     C     #1OBTP        PARM      #1OBTP        W0EXVL           20            Object Type
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Object Attribute
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1OBAT        W0NSRQ            1            Object Attribut
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1101927       Y2LSNO            7 0
     C     #1OBAT        PARM      #1OBAT        W0EXVL           20            Object Attribut
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
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
      * Validate Object type
      * CASE: RCD.Object Type is *ALL values
     C     #1OBTP        IFEQ      '*CMD'                                       *IF
     C     #1OBTP        OREQ      '*DOC'
     C     #1OBTP        OREQ      '*DTAARA'
     C     #1OBTP        OREQ      '*DTAQ'
     C     #1OBTP        OREQ      '*FLR'
     C     #1OBTP        OREQ      '*JOBD'
     C     #1OBTP        OREQ      '*JRN'
     C     #1OBTP        OREQ      '*LIB'
     C     #1OBTP        OREQ      '*MENU'
     C     #1OBTP        OREQ      '*MSGF'
     C     #1OBTP        OREQ      '*OUTQ'
     C     #1OBTP        OREQ      '*QRYDFN'
     C     #1OBTP        OREQ      '*SBSD'
     C     #1OBTP        OREQ      '*CLS'
     C     #1OBTP        OREQ      '*FILE'
     C     #1OBTP        OREQ      '*JOBQ'
     C     #1OBTP        OREQ      '*JRNRCV'
     C     #1OBTP        OREQ      '*MSGQ'
     C     #1OBTP        OREQ      '*PGM'
     C     #1OBTP        OREQ      *BLANK
      * Validate Object Attribute
      * CASE: RCD.Object Attribute is *ALL values
     C     #1OBAT        IFEQ      'RPG'                                        *IF
     C     #1OBAT        OREQ      'CLP'
     C     #1OBAT        OREQ      'PRTF'
     C     #1OBAT        OREQ      'DSPF'
     C     #1OBAT        OREQ      'SAVF'
     C     #1OBAT        OREQ      'PF'
     C     #1OBAT        OREQ      'LF'
     C     #1OBAT        OREQ      *BLANK
     C     #1OBAT        OREQ      'CMD'
     C     #1OBAT        OREQ      'MNU'
     C     #1OBAT        OREQ      'QRY'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1OBAT        ZA0002                         Object Attribut
      * Send message 'Object attribute invalid'
     C                   MOVEL     'CBM0045'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9836      *
      *
     C                   GOTO      DEEXIT                                       *QUIT
     C                   END                                                    *FI
      * Validate attributes for object type *PGM
      * CASE: RCD.Object Type is Program
     C     #1OBTP        IFEQ      '*PGM'                                       *IF
      * CASE: RCD.Object Attribute is Valid Program Attributes
     C     #1OBAT        IFEQ      'CLP'                                        *IF
     C     #1OBAT        OREQ      'RPG'
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Object Attribute is Blank
     C     #1OBAT        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1OBAT        ZA0003                         Object Attribut
      * Send message 'Object attribute required'
     C                   MOVEL     'CBM0034'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9836      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1OBAT        ZA0004                         Object Attribut
     C                   MOVEL     #1OBTP        ZA0005                         Object Type
      * Send message 'Object attri/type invalid'
     C                   MOVEL     'CBM0027'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        983635    *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate attributes for object type *FILE
      * CASE: RCD.Object Type is File
     C     #1OBTP        IFEQ      '*FILE'                                      *IF
      * CASE: RCD.Object Attribute is Valid File Attributes
     C     #1OBAT        IFEQ      'DSPF'                                       *IF
     C     #1OBAT        OREQ      'LF'
     C     #1OBAT        OREQ      'PF'
     C     #1OBAT        OREQ      'PRTF'
     C     #1OBAT        OREQ      'SAVF'
      * If PF or LF, then Run Object must be 'Y'
      * CASE: RCD.Object Attribute is Database File Attributes
     C     #1OBAT        IFEQ      'LF'                                         *IF
     C     #1OBAT        OREQ      'PF'
      * CASE: RCD.Avail if feature present? is No
     C     #1AVAL        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1AVAL        ZA0006                         Avail if featur
      * Send message 'Run Object must be 'Y''
     C                   MOVEL     'CBM0046'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9837      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Else Invalid Attribute for *FILE
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Object Attribute is Blank
     C     #1OBAT        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1OBAT        ZA0007                         Object Attribut
      * Send message 'Object attribute required'
     C                   MOVEL     'CBM0034'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9836      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1OBAT        ZA0008                         Object Attribut
     C                   MOVEL     #1OBTP        ZA0009                         Object Type
      * Send message 'Object attri/type invalid'
     C                   MOVEL     'CBM0027'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        983635    *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate attributes for object type *QRYDFN
      * CASE: RCD.Object Type is Query Definition
     C     #1OBTP        IFEQ      '*QRYDFN'                                    *IF
      * CASE: RCD.Object Attribute is Query
     C     #1OBAT        IFEQ      'QRY'                                        *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Object Attribute is Blank
     C     #1OBAT        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1OBAT        ZA0010                         Object Attribut
      * Send message 'Object attribute required'
     C                   MOVEL     'CBM0034'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9836      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1OBAT        ZA0011                         Object Attribut
     C                   MOVEL     #1OBTP        ZA0012                         Object Type
      * Send message 'Object attri/type invalid'
     C                   MOVEL     'CBM0027'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        983635    *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate attributes for object type *CMD
      * CASE: RCD.Object Type is Command
     C     #1OBTP        IFEQ      '*CMD'                                       *IF
      * CASE: RCD.Object Attribute is Command
     C     #1OBAT        IFEQ      'CMD'                                        *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Object Attribute is Blank
     C     #1OBAT        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1OBAT        ZA0013                         Object Attribut
      * Send message 'Object attribute required'
     C                   MOVEL     'CBM0034'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9836      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1OBAT        ZA0014                         Object Attribut
     C                   MOVEL     #1OBTP        ZA0015                         Object Type
      * Send message 'Object attri/type invalid'
     C                   MOVEL     'CBM0027'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        983635    *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate attributes for object type *CMD
      * CASE: RCD.Object Type is menu
     C     #1OBTP        IFEQ      '*MENU'                                      *IF
      * CASE: RCD.Object Attribute is Menu
     C     #1OBAT        IFEQ      'MNU'                                        *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.Object Attribute is Blank
     C     #1OBAT        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1OBAT        ZA0016                         Object Attribut
      * Send message 'Object attribute required'
     C                   MOVEL     'CBM0034'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9836      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1OBAT        ZA0017                         Object Attribut
     C                   MOVEL     #1OBTP        ZA0018                         Object Type
      * Send message 'Object attri/type invalid'
     C                   MOVEL     'CBM0027'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        983635    *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate attributes for object types not requiring attributes
      * CASE: RCD.Object Type is Non-attribute object type
     C     #1OBTP        IFEQ      '*CLS'                                       *IF
     C     #1OBTP        OREQ      '*DTAARA'
     C     #1OBTP        OREQ      '*DTAQ'
     C     #1OBTP        OREQ      '*DOC'
     C     #1OBTP        OREQ      '*FLR'
     C     #1OBTP        OREQ      '*JOBD'
     C     #1OBTP        OREQ      '*JOBQ'
     C     #1OBTP        OREQ      '*JRN'
     C     #1OBTP        OREQ      '*JRNRCV'
     C     #1OBTP        OREQ      '*LIB'
     C     #1OBTP        OREQ      '*MSGF'
     C     #1OBTP        OREQ      '*MSGQ'
     C     #1OBTP        OREQ      '*OUTQ'
     C     #1OBTP        OREQ      '*SBSD'
      * CASE: RCD.Object Attribute is Blank
     C     #1OBAT        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1OBAT        ZA0019                         Object Attribut
     C                   MOVEL     #1OBTP        ZA0020                         Object Type
      * Send message 'Object attri not required'
     C                   MOVEL     'CBM0044'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        983635    *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Invalid object type
      * Setup message data for message
     C                   MOVEL     #1OBTP        ZA0021                         Object Type
      * Send message 'Object type invalid'
     C                   MOVEL     'CBM0026'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9835      *
      *
     C                   END                                                    *FI
      * CASE: RCD.Object Attribute is *ALL values
     C     #1OBAT        IFEQ      'RPG'                                        *IF
     C     #1OBAT        OREQ      'CLP'
     C     #1OBAT        OREQ      'PRTF'
     C     #1OBAT        OREQ      'DSPF'
     C     #1OBAT        OREQ      'SAVF'
     C     #1OBAT        OREQ      'PF'
     C     #1OBAT        OREQ      'LF'
     C     #1OBAT        OREQ      *BLANK
     C     #1OBAT        OREQ      'CMD'
     C     #1OBAT        OREQ      'MNU'
     C     #1OBAT        OREQ      'QRY'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1OBAT        ZA0022                         Object Attribut
      * Send message 'Object attribute invalid'
     C                   MOVEL     'CBM0045'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9836      *
      *
     C                   END                                                    *FI
      * Validate Run object
      * CASE: RCD.Avail if feature present? is Valid values
     C     #1AVAL        IFEQ      'N'                                          *IF
     C     #1AVAL        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1AVAL        ZA0023                         Avail if featur
      * Send message 'Allow Sel must be 'Y/N''
     C                   MOVEL     'CBM0029'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9837      *
      *
     C                   END                                                    *FI
      * Validate Object description
      * CASE: RCD.Object Description is Not entered
     C     #1OBTX        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1OBTX        ZA0024                         Object Descript
      * Send message 'Object Descr not entered'
     C                   MOVEL     'CBM0028'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9838      *
      *
     C                   END                                                    *FI
      * Validate subfile record relations
     C                   EXSR      DFV2RC
      * Object Name required
     C     #1OBNM        IFEQ      *BLANK                                       IF
     C                   SETON                                        9834      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Object Type required
     C     #1OBTP        IFEQ      *BLANK                                       IF
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
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Switchable F - Obj - Switchable F - Objects  *
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
      * Delete object - Switchable F - Objects  *
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
      * Change Switchable F - Obj - Switchable F - Objects  *
     C                   EXSR      SCCHRC
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
     C                   Z-ADD     *ZERO         #1LCD                          Last change dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of the Las
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1OBNM                         Object Name
     C                   MOVEL     *BLANK        #1OBTP                         Object Type
     C                   MOVEL     *BLANK        #1OBAT                         Object Attribut
     C                   MOVEL     *BLANK        #1AVAL                         Avail if featur
     C                   MOVEL     *BLANK        #1OBTX                         Object Descript
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @SAROL1 fields to subfile
      *================================================================
     C                   MOVEL     AFSARN        #1SARN                         Switchable Feat
     C                   Z-ADD     AFLCD         #1LCD                          Last change dat
     C                   MOVEL     AFTYLC        #1TYLC                         Type of the Las
     C                   MOVEL     AFOBNM        #1OBNM                         Object Name
     C                   MOVEL     AFOBTP        #1OBTP                         Object Type
     C                   MOVEL     AFOBAT        #1OBAT                         Object Attribut
     C                   MOVEL     AFAVAL        #1AVAL                         Avail if featur
     C                   MOVEL     AFOBTX        #1OBTX                         Object Descript
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
     C                   MOVEL     *BLANK        #2OBNM                         Object Name
     C                   MOVEL     *BLANK        #2OBTP                         Object Type
      * Check restriction within
     C                   EXSR      VACKRL
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Switchable F - Obj - Switchable F - Objects  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @SAROL0
     C                   MOVEL     P1SARN        AFSARN                         Switchable Feat
     C                   MOVEL     #1OBNM        AFOBNM                         Object Name
     C                   MOVEL     #1OBTP        AFOBTP                         Object Type
     C                   MOVEL     #1OBAT        AFOBAT                         Object Attribut
     C                   MOVEL     #1AVAL        AFAVAL                         Avail if featur
     C                   MOVEL     #1OBTX        AFOBTX                         Object Descript
     C                   Z-ADD     WUAKTX        AFLCD                          Last change dat
     C                   MOVEL     'I'           AFTYLC                         Type of the Las
      *
     C     KLCRSA        KLIST
     C                   KFLD                    AFSARN                         Switchable Feat
     C                   KFLD                    AFOBNM                         Object Name
     C                   KFLD                    AFOBTP                         Object Type
      * Check for duplicate primary key
     C     KLCRSA        SETLL     @SAROL0                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CBM0013'     W0RTN             7
      * Send message 'Switchable F - Objects EX'
     C                   MOVEL     'CBM0013'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   END
      *
     C                   WRITE     @SAROL0                              91      *
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
      * Delete object - Switchable F - Objects  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @SAROL0
     C                   MOVEL     #1SARN        AFSARN                         Switchable Feat
     C                   MOVEL     #1OBNM        AFOBNM                         Object Name
     C                   MOVEL     #1OBTP        AFOBTP                         Object Type
      *
     C     KLDLSB        KLIST
     C                   KFLD                    AFSARN                         Switchable Feat
     C                   KFLD                    AFOBNM                         Object Name
     C                   KFLD                    AFOBTP                         Object Type
     C     KLDLSB        CHAIN     @SAROL0                            9091      *
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
     C     KLDLSB        SETLL     @SAROL0                            9091      *
     C                   GOTO      SBEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C                   DELETE    @SAROL0                              91      *
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Change Switchable F - Obj - Switchable F - Objects  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @SAROL0
     C                   MOVEL     #1SARN        AFSARN                         Switchable Feat
     C                   MOVEL     #1OBNM        AFOBNM                         Object Name
     C                   MOVEL     #1OBTP        AFOBTP                         Object Type
      *
     C     KLCHSC        KLIST
     C                   KFLD                    AFSARN                         Switchable Feat
     C                   KFLD                    AFOBNM                         Object Name
     C                   KFLD                    AFOBTP                         Object Type
     C     KLCHSC        CHAIN     @SAROL0                            9091      *
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
     C                   UNLOCK    SCSAROL0                             91      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YARDCS
      * Move non-key fields to @SAROL0
     C                   MOVEL     #1OBAT        AFOBAT                         Object Attribut
     C                   MOVEL     #1AVAL        AFAVAL                         Avail if featur
     C                   MOVEL     #1OBTX        AFOBTX                         Object Descript
     C                   Z-ADD     WUAKTX        AFLCD                          Last change dat
     C                   MOVEL     'A'           AFTYLC                         Type of the Las
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C                   UPDATE    @SAROL0                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SCSAROL0                             91      *
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
     C                   KFLD                    ABSARN                         Switchable Feat
      * Setup key
     C                   MOVEL     #2SARN        ABSARN                         Switchable Feat
     C*****KLVAAB        CHAIN     @SARDL1                            9091      *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = :ABSARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   SETOFF                                       90                    MD055681
     C                   IF        SQLCODE = 0                                              MD055681
     C                   SETON                                        90                    MD055681
     C                   ENDIF                                                              MD055681
     C     *IN90         IFEQ      '0'
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
     C                   OPEN      SC3040M#
     C                   OPEN      SCSAROL1
     C**********         OPEN      SCSARDL1                                                 MD055681
     C                   OPEN      SCSAROL0
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
      * SC3040M Precompiler - Switchable F - Objects  *
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
     C/COPY WNCPYSRC,SC3040MPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SC3040MPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINS                                                              MD055681
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055681
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SC3040MPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001

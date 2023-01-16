     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058769
/*STD *  RPGSQLBND                                                    *                     MD058769
/*EXI *  TEXT('Midas SD Narrative codes enquiry subfile')             *
      *****************************************************************
      *                                                               *
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0080D - Midas SD Display Narrative Codes                   *
      *                                                               *
      *  Function:  This program allows the user to enquire from a    *
      *             list of Narrative Codes                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058769           Date 21Sep21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE098             Date 02Dec13               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13143           Date 25Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAAA03             Date 28Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSD003             Date 01Jul99               *
      *                    S01459         Date 01Jul99                *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                    LN0168         DATE 26JUN90                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058769 - Deliverable Data Split for SDNARRPD and TABLETP   *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE098 - User-Defined Retail Transaction Types on Postings   *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  BUG13143 - Selection field not required.                     *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *     CAAA03 - Webfacing Changes (recompile).                   *
      *     CSD003 - Synon Closedown Project (SD):                    *
      *              - Program removed from SD model.                 *
      *     S01459 - Addition of Midas Headerbox.                     *
     F*     LN0168 - SET SCAN LIMIT TO 99999.                         *
     F*                                                               *
     F*****************************************************************
     FSD0080D#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Display Narrative Codes
      *
     F*SDNARRL1* IF   E           K DISK    USROPN                                          MD058769
     F**********                           INFDS(INFDS1)                                    MD058769
     F**********                           INFSR(*PSSR)                                     MD058769
      * RTV : Midas SD Narrative codes retrieval
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
     D LDA             DS           256
      ** Local data area for database error details                                           CSD031
      *                                                                                       CSD031
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * DS for Access Programs, short data structure.                                         CSD031
     D DSSARD        E DS                  EXTNAME(SCSARDPD)
      * Definition: Switchable Features Accessed Via Access Program.                          CSD031
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DS for Bank details                                                                   CSD031
     D SDNARR        E DS                  EXTNAME(SDNARJW0)                                MD058769
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
      * Initialise & load subfile page
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
     C                   END                                                    OD W0RSF
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise and load subfile page
      *================================================================
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    ALNVCD                         Narrative Code
      * Setup key
     C                   MOVEL     #2NVCD        ALNVCD                         Narrative Code
     C*****KPOS*         SETLL     @ALREC0                                                  MD058769
     C**********         READ      @ALREC0                              8782    *82=EOF     MD058769
     C/EXEC SQL                                                                             MD058769
     C+ declare ACursor insensitive scroll cursor for                                       MD058769
     C+ select * from SDNARJW0                                                              MD058769
     C+ where ALNVCD >= :ALNVCD                                                             MD058769
     C+ order by ALNVCD                                                                     MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
     C/EXEC SQL                                                                             MD058769
     C+ close ACursor                                                                       MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
     C/EXEC SQL                                                                             MD058769
     C+ open ACursor                                                                        MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
     C/EXEC SQL                                                                             MD058769
     C+ fetch next from ACursor into :SDNARR                                                MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
     C                   setoff                                       82                    MD058769
     C                   If        SQLCODE = 100                                            MD058769
     C                   seton                                        82                    MD058769
     C                   Endif                                                              MD058769
                                                                                            MD058769
      * Save previous selector values
     C     *LIKE         DEFINE    #2LCD         WZLCD
     C                   MOVEL     #2LCD         WZLCD                          Last Change Dat
     C     *LIKE         DEFINE    #2TYLC        WZTYLC
     C                   MOVEL     #2TYLC        WZTYLC                         Type of Last Ch
     C     *LIKE         DEFINE    #2NVCD        WZNVCD
     C                   MOVEL     #2NVCD        WZNVCD                         Narrative Code
     C     *LIKE         DEFINE    #2DON         WZDON
     C                   MOVEL     #2DON         WZDON                          Description of
     C     CSD044        IFEQ      'Y'
     C     *LIKE         DEFINE    #2GPDT        WZGPDT
     C                   MOVEL     #2GPDT        WZGPDT
     C     *LIKE         DEFINE    #2EACC        WZEACC
     C                   MOVEL     #2EACC        WZEACC
     C                   ENDIF
     C     *LIKE         DEFINE    D2RTTY        WZRTTY
     C                   MOVEL     D2RTTY        WZRTTY
      * Translate search mask for text field
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2DON         WQDON                          Description of
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      30            WQA5N             5 0
     C                   PARM      #2DON         WQDON                          Description of
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
      * Load subfile page
     C                   Z-ADD     0             ##RROK            5 0
     C                   EXSR      BBLDSF
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page
      *================================================================
      * Re-establish fields in read-ahead record
     C   27              DO
     C**N82*****         READP     @ALREC0                                90    *           MD058769
     C**N82*****         READ      @ALREC0                                90    *           MD058769
     C     *IN82         IFEQ      '0'                                                      MD058769
     C/EXEC SQL                                                                             MD058769
     C+ fetch prior from ACursor into :SDNARR                                               MD058769
     C/END-EXEC                                                                             MD058769
     C/EXEC SQL                                                                             MD058769
     C+ fetch next from ACursor into :SDNARR                                                MD058769
     C/END-EXEC                                                                             MD058769
     C                   ENDIF                                                              MD058769
     C                   END
      *
      * Setof record error indicators
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(33)
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
      * Reset count of DBF records read
     C                   Z-ADD     0             ##RRRD            5 0
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
      * Load next SFL page until SFL page full, or
      * Scan limit reached
     C******IN82         DOWEQ     '0'                                          DO          MD058769
     C     SQLCODE       DOWEQ     0                                            DO          MD058769
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
      * Check selection fields - if fail, read next record
     C     #2LCD         IFNE      *ZERO                                        Last Change Dat
     C     ALLCD         CABNE     #2LCD         BB020                          Last Change Dat
     C                   END
     C     #2TYLC        IFNE      *BLANK                                       Type of Last Ch
     C     ALTYLC        CABNE     #2TYLC        BB020                          Type of Last Ch
     C                   END
     C     #2DON         IFNE      *BLANK                                       Description of
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    ALDON                          Description of
      * Length
     C                   PARM      30            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    WQDON
      * Length
     C                   PARM      30            WQC3N             3 0
      * Translate
     C                   PARM      '1'           WQD1              1
      * Trim
     C                   PARM      '1'           WQE1              1
      * Wild
     C                   PARM      '?'           WQF1              1
      * Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         CABLT     1             BB020
     C                   END
     C     CSD044        IFEQ      'Y'
     C     #2GPDT        IFNE      *BLANK
     C     ALGPDT        CABNE     #2GPDT        BB020
     C                   ENDIF
     C     #2EACC        IFNE      *BLANK
     C     CSD044        IFEQ      'Y'
      *                                                                                       CSD031
      *** Convert Effective Date to screen format                                             CSD031
      *                                                                                       CSD031
     C                   CALL      'ZDATE2'
     C                   PARM                    ALEACC
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    DATEB             7
     C                   ENDIF
     C     DATEB         CABNE     #2EACC        BB020
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER030
      ** Check the Selected Transaction Type With The File Field                              CER030
      *                                                                                       CER030
     C     CGL013        IFEQ      'Y'
     C     CER030        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C     D2RTTY        IFNE      *BLANKS
      *                                                                                       CER030
     C     ALRTTY        CABNE     D2RTTY        BB020
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
      * Load SFL fields
     C                   EXSR      MBFL#1
      * Output to subfile
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81        *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
     C                   WRITE     #SFLRCD
     C     BB020         TAG
      * Increment scan check count
     C                   ADD       1             ##RRRD
     C**********         READ      @ALREC0                                82    *82=EOF     MD058769
     C/EXEC SQL                                                                             MD058769
     C+ fetch next from ACursor into :SDNARR                                                MD058769
     C/END-EXEC                                                                             MD058769
     C                   END                                                    OD 1 - ##SFPG
      *................................................................
     C     BB900         TAG
      *................................................................
      * If no DBF records found, display error message
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI ##RR = *ZERO
      *
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
      * If scan limit reached, display error message
     C     ##RRRD        IFGE      W0SLM
      * Send message '*Scan limit reached'
     C                   MOVEL     'Y2U0017'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     0             ##RROK
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen
      *================================================================
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * Update screen time
     C                   TIME                    ##TME
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
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
     C                   SETOFF                                         8392    *
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
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * Change of position specified
     C     WZNVCD        CASNE     #2NVCD        FBRQRL
     C     WZDON         CASNE     #2DON         FBRQRL
     C                   END
     C     CSD044        IFEQ      'Y'
     C     WZGPDT        CASNE     #2GPDT        FBRQRL
     C     WZEACC        CASNE     #2EACC        FBRQRL
     C                   END
     C                   ENDIF
      *                                                                                       CER030
     C     CGL013        IFEQ      'Y'
     C     CER030        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C     WZRTTY        CASNE     D2RTTY        FBRQRL
     C                   END
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @ALREC0 fields to subfile
      *================================================================
     C**********           MOVEL*BLANK    #1SEL                                             BUG13143
     C                   Z-ADD     ALLCD         #1LCD                          Last Change Dat
     C                   MOVEL     ALTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     ALNVCD        #1NVCD                         Narrative Code
     C                   MOVEL     ALDON         #1DON                          Description of
     C**********           MOVEL*BLANK    #1SEL            *SFLSEL                          BUG13143
     C     CSD044        IFEQ      'Y'
     C                   MOVE      ALGPDT        #1GPDT
      *                                                                                       CSD031
      *** Convert Effective Date to screen format                                             CSD031
      *                                                                                       CSD031
     C                   CALL      'ZDATE2'
     C                   PARM                    ALEACC
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    DATEB             7
     C                   MOVEL     DATEB         #1EACC
     C                   ENDIF
      *                                                                                       CER030
     C     CGL013        IFEQ      'Y'
     C     CER030        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C                   MOVEL     ALRTTY        D1RTTY
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   Z-ADD     *ZERO         #2LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #2TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #2NVCD                         Narrative Code
     C                   MOVEL     *BLANK        #2DON                          Description of
     C     CSD044        IFEQ      'Y'
     C                   MOVE      *BLANK        #2GPDT
     C                   MOVE      *BLANKS       #2EACC
     C                   ENDIF
      *                                                                                       CER030
     C     CGL013        IFEQ      'Y'
     C     CER030        OREQ      'Y'
     C     CRE098        OREQ      'Y'
      *                                                                                       CER030
     C                   MOVEL     *BLANKS       D2RTTY
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
      *================================================================
     CSR   MEEXIT        ENDSR
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
      * Cancel & exit program
      *================================================================
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
     C/EXEC SQL                                                                             MD058769
     C+ close ACursor                                                                       MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
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
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
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
     C                   OPEN      SD0080D#
     C**********         OPEN      SDNARRL1                                                 MD058769
     C                   MOVEL     'N'           W0PMT             1
     C                   Z-ADD     13            ##SFPG            3 0          SFLPAG
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
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * SD0080D PRECOMPILER - Narrative Codes  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Copyright Statement 1988 - Standard Functions  * copyright
      * Start of Fix LN0168
     C                   Z-ADD     99999         W0SLM                          *Scan limit
      * End of Fix LN0168
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *================================================================
     C                   MOVE      'N'           CSD044            1
     C                   MOVE      *OFF          *IN50
      *                                                                                       CSD031
      ** Access SAR details to see if CSD044 is switched on                                   CSD031
      *                                                                                       CSD031
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSD044'      PSARD             6
     C     DSSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CSD031
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD044
     C                   MOVE      *ON           *IN50
      *                                                                                       CSD031
      ** Access bank details                                                                  CSD031
      *                                                                                       CSD031
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                                       CSD031
      ** Database error                                                                       CSD031
      *                                                                                       CSD031
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBKEY
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSD031
      *                                                                                       CER030
      ** Check if CER030 is On                                                                CER030
      *                                                                                       CER030
     C                   MOVE      *OFF          *IN51
      *                                                                                       CER030
     C                   MOVE      'N'           CER030            1
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CER030'      PSARD             6
     C     DSSARD        PARM      DSSARD        DSFDY
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CER030
     C                   MOVE      'Y'           CER030
     C                   MOVE      *ON           *IN51
     C                   ELSE
      *                                                                                       CER030
     C     PRTCD         IFNE      '*NRF   '
      *                                                                                       CER030
     C                   EXSR      *PSSR
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
      ** Check if CGL013 is On                                                                CER030
      *                                                                                       CER030
     C                   MOVE      'N'           CGL013            1
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL013'      PSARD
     C     DSSARD        PARM      DSSARD        DSFDY
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CER030
     C                   MOVE      'Y'           CGL013
     C                   MOVE      *ON           *IN51
     C                   ELSE
      *                                                                                       CER030
     C     PRTCD         IFNE      '*NRF   '
      *                                                                                       CER030
     C                   EXSR      *PSSR
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CRE098
      ** Check if CRE098 is On                                                                CRE098
      *                                                                                       CRE098
     C                   MOVE      'N'           CRE098            1
      *                                                                                       CRE098
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CRE098'      PSARD
     C     DSSARD        PARM      DSSARD        DSFDY
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CRE098
     C                   MOVE      'Y'           CRE098
     C                   MOVE      *ON           *IN51
     C                   ELSE
      *                                                                                       CRE098
     C     PRTCD         IFNE      '*NRF   '
      *                                                                                       CRE098
     C                   EXSR      *PSSR
      *                                                                                       CRE098
     C                   ENDIF
      *                                                                                       CRE098
     C                   ENDIF
      *                                                                                       CRE098
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
     C/COPY WNCPYSRC,SD0080DPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0080DPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINS                                                              MD058769
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058769
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0080DPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001

     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas SD Display tag description')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD2040D - Message Tag Descriptions Enquiry Subfile.          *
      *                                                               *
      *  Function:  This program alows users to enquire on            *
      *             message tag descriptions.                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056560           Date 31Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
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
      *                 044373             Date 16NOV92               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG2145 - Use variables to hold the values of the subfile    *
      *            record text since MSGID keyword is not allowed in  *
      *            SFLRCD when compiling this display file with       *
      *            multi-language support.                            *
      *  CSW098 - SWIFT 1998 Changes                                  *  *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  S01459 - Addition of Midas Headerbox.                        *
      *  044373 - Regenerated and compiled over SD2040D# after        *
      *           currecting help tags.                               *
      *                                                               *
      *****************************************************************
     FSD2040D#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Message tag descriptions enquiry subfile
      *
     F*SDMTAGL1* IF   E           K DISK    USROPN                                          MD056560
     F**********                           INFDS(INFDS1)                                    MD056560
     F**********                           INFSR(*PSSR)                                     MD056560
      * RTV : Midas SD Message field tag description retrieval
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
     D SDMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
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
     C                   KFLD                    EFMTAG                         Message Field T
     C                   KFLD                    EFMTPY                         Message Type
     C                   KFLD                    EFMSEQ                         Message Seq    CSW09
      * Setup key
     C                   MOVEL     #2MTAG        EFMTAG                         Message Field T
     C                   MOVEL     #2MTPY        EFMTPY                         Message Type
     C                   MOVEL     #2MSEQ        EFMSEQ                                        CSW09
     C*****KPOS*         SETLL     @EFREJ5                                                  MD056560
     C**********         READ      @EFREJ5                              8782    *82=EOF     MD056560
     C/EXEC SQL                                                                             MD056560
     C+ declare ACursor insensitive scroll cursor for                                       MD056560
     C+ select * from SDMTGJW0                                                              MD056560
     C+ where EFMTAG >= :EFMTAG and EFMTPY >= :EFMTPY and EFMSEQ >= :EFMSEQ                 MD056560
     C+ order by EFMTAG, EFMTPY, EFMSEQ                                                     MD056560
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
      * Save previous selector values
     C     *LIKE         DEFINE    #2RPFD        WZRPFD
     C                   MOVEL     #2RPFD        WZRPFD                         Report/Telex Fi
     C     *LIKE         DEFINE    #2TAGF        WZTAGF
     C                   MOVEL     #2TAGF        WZTAGF                         Tag Format
     C     *LIKE         DEFINE    #2LCD         WZLCD
     C                   MOVEL     #2LCD         WZLCD                          Last Change Dat
     C     *LIKE         DEFINE    #2TYLC        WZTYLC
     C                   MOVEL     #2TYLC        WZTYLC                         Type of Last Ch
     C     *LIKE         DEFINE    #2MTAG        WZMTAG
     C                   MOVEL     #2MTAG        WZMTAG                         Message Field T
     C     *LIKE         DEFINE    #2MTPY        WZMTPY
     C                   MOVEL     #2MTPY        WZMTPY                         Message Type
     C     *LIKE         DEFINE    #2MSEQ        WZMSEQ                                        CSW09
     C                   MOVEL     #2MSEQ        WZMSEQ                         Message Seq    CSW09
     C     *LIKE         DEFINE    #2SCFD        WZSCFD
     C                   MOVEL     #2SCFD        WZSCFD                         Screen Field De
     C     *LIKE         DEFINE    #2ISFD        WZISFD
     C                   MOVEL     #2ISFD        WZISFD                         ISO Field Descr
      * Translate search mask for text field
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2RPFD        WQRPFD                         Report/Telex Fi
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      60            WQA5N             5 0
     C                   PARM      #2RPFD        WQRPFD                         Report/Telex Fi
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
     C     *LIKE         DEFINE    #2SCFD        WQSCFD                         Screen Field De
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      20            WQA5N             5 0
     C                   PARM      #2SCFD        WQSCFD                         Screen Field De
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
     C     *LIKE         DEFINE    #2ISFD        WQISFD                         ISO Field Descr
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      30            WQA5N             5 0
     C                   PARM      #2ISFD        WQISFD                         ISO Field Descr
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
     C******IN82         DOWEQ     '0'                                          DO          MD056560
     C     SQLCODE       DOWEQ     0                                            DO          MD056560
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
      * Check selection fields - if fail, read next record
     C     #2RPFD        IFNE      *BLANK                                       Report/Telex Fi
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    EFRPFD                         Report/Telex Fi
      * Length
     C                   PARM      60            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    WQRPFD
      * Length
     C                   PARM      60            WQC3N             3 0
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
     C     #2TAGF        IFNE      *BLANK                                       Tag Format
     C     EFTAGF        CABNE     #2TAGF        BB020                          Tag Format
     C                   END
     C     #2LCD         IFNE      *ZERO                                        Last Change Dat
     C     EFLCD         CABNE     #2LCD         BB020                          Last Change Dat
     C                   END
     C     #2TYLC        IFNE      *BLANK                                       Type of Last Ch
     C     EFTYLC        CABNE     #2TYLC        BB020                          Type of Last Ch
     C                   END
     C     #2MTAG        IFEQ      *BLANK                                       Message Field T
     C     #2MTPY        IFNE      *BLANK                                       Message Type
     C     EFMTPY        CABNE     #2MTPY        BB020                          Message Type
     C                   END
     C                   END
     C     #2MTAG        IFEQ      *BLANK                                                      CSW09
     C     #2MTPY        ANDEQ     *BLANK                                                      CSW09
     C     #2MSEQ        ANDNE     *BLANK                                                      CSW09
     C     EFMSEQ        CABNE     #2MSEQ        BB020                                         CSW09
     C                   END                                                                   CSW09
     C     #2SCFD        IFNE      *BLANK                                       Screen Field De
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    EFSCFD                         Screen Field De
      * Length
     C                   PARM      20            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    WQSCFD
      * Length
     C                   PARM      20            WQC3N             3 0
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
     C     #2ISFD        IFNE      *BLANK                                       ISO Field Descr
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    EFISFD                         ISO Field Descr
      * Length
     C                   PARM      30            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    WQISFD
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
     C**********         READ      @EFREJ5                                82    *82=EOF     MD056560
     C/EXEC SQL                                                                             MD056560
     C+ fetch next from ACursor into :SDMTAG                                                MD056560
     C/END-EXEC                                                                             MD056560
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
     C     WZMTAG        CASNE     #2MTAG        FBRQRL
     C     WZMTPY        CASNE     #2MTPY        FBRQRL
     C     WZMSEQ        CASNE     #2MSEQ        FBRQRL                                        CSW09
     C     WZSCFD        CASNE     #2SCFD        FBRQRL
     C     WZISFD        CASNE     #2ISFD        FBRQRL
     C                   END
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
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2RPFD                         Report/Telex Fi
     C                   MOVEL     *BLANK        #2TAGF                         Tag Format
     C                   Z-ADD     *ZERO         #2LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #2TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #2MTAG                         Message Field T
     C                   MOVEL     *BLANK        #2MTPY                         Message Type
     C                   MOVEL     *BLANK        #2MSEQ                                        CSW09
     C                   MOVEL     *BLANK        #2SCFD                         Screen Field De
     C                   MOVEL     *BLANK        #2ISFD                         ISO Field Descr
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
     C                   OPEN      SD2040D#
     C**********         OPEN      SDMTAGL1                                                 MD056560
     C                   MOVEL     'N'           W0PMT             1
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
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * SD2040D Precompiler - Message Field Tag Desc  *
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
     C                   Z-ADD     99999         W0SLM                          *Scan limit
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
     C/COPY WNCPYSRC,SD2040DPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD2040DPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD056560
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD056560
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD2040DPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001

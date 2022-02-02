/**** *  RPGBASE                                                      *                     MD058068
/*STD *  RPGSQLBND                                                    *                     MD058068
/*EXI *  TEXT('Midas BoE Selection screen for product codes')         *
     H DATEDIT(*YMD)
      *****************************************************************
      *                                                               *
      *  Midas - Bank of England                                      *
      *                                                               *
      *  BY9220 - Selection screen for product codes                  *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 1997                      *
      *                                                               *
      *    SYNOPSIS :                                                 *
      *  - Displays the records from DBF as a subfile.                *
      *  - Loads the SFL from the DBF a page at a time.               *
      *  - The DBF record at which the SFL display starts may be      *
      *    controlled by positioning fields on the SFL header.        *
      *  - Any key fields on the SFL header will be used as           *
      *    positioning values.                                        *
      *  - Any non-key fields on the SFL header will be used as       *
      *    selection values: a maximum of ##RCMX records will be      *
      *    read from the DBF before giving up.                        *
      *  - A record may be selected from those displayed in the       *
      *    subfile. The master key data will be returned to the       *
      *    calling program                                            *
      *                                                               *
      *                                                               *
      *  Last Amend No. MD058068           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 LLN022             Date 03Apr05               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058068 - Deliverable Data Split for Bank of England        *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *                                                               *
      *****************************************************************
     F*                                                               *
     FBY9220DF  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
      * DSP: Select BOE country codes  Select record
      *
     F*BYPRODPP* IF   E           K DISK                                                    MD058068
     F**********                           INFDS(INFDS1)                                    MD058068
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              BIS Copyright
      /EJECT
      * Data structures:-
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure.
     D JBDTTM          DS
      * Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure.
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure.
      *
     D BYPROD        E DS                  EXTNAME(BYPRDJW0)                                MD058068
      /EJECT
      * Parameter declarations.
     D P1PARM          DS
      * FLD: BOE product codes
      * B:MAP product code
     D  P1PCOD                 1      4
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C     P1PCOD        PARM      P1PCOD        WP0001            4            Product code
      *****************************************************************
      * Initialise
     C                   MOVEA     CPY@          @BIS             80
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL                                       DO
      * Initialise & load subfile page.
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested:
     C     W0RSF         DOWEQ     'N'                                          DOW
      * Display screen.
     C                   EXSR      CAEXFM
      *   Process response:
      * Cancel & exit program.
     C   03              CAS                     ZXEXPG
      *   Display next SFL page.
     C   27              CAS                     BBLDSF
      *   Process screen input.
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END                                                    OD W0RSF
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise & Load subfile page.
      *================================================================
      * Clear subfile.
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile.
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      *................................................................
      * Position DBF file:
     C     KPOS          KLIST
     C                   KFLD                    LDPCOD                         Product code
      * Setup key.
     C                   MOVEL     #2PCOD        LDPCOD                         Product code
     C*****KPOS*         SETLL     BYPRODD0                                                 MD058068
     C**********         READ      BYPRODD0                             8782    *82=EOF     MD058068
     C/EXEC SQL                                                                             MD058068
     C+ close ACursor                                                                       MD058068
     C/END-EXEC                                                                             MD058068
                                                                                            MD058068
     C/EXEC SQL                                                                             MD058068
     C+ declare ACursor insensitive scroll cursor for                                       MD058068
     C+ select * from BYPRDJW0                                                              MD058068
     C+ where LDPCOD >= :LDPCOD                                                             MD058068
     C+ order by LDPCOD                                                                     MD058068
     C/END-EXEC                                                                             MD058068
                                                                                            MD058068
     C/EXEC SQL                                                                             MD058068
     C+ open ACursor                                                                        MD058068
     C/END-EXEC                                                                             MD058068
                                                                                            MD058068
     C/EXEC SQL                                                                             MD058068
     C+ fetch next from ACursor into :BYPROD                                                MD058068
     C/END-EXEC                                                                             MD058068
                                                                                            MD058068
     C                   setoff                                       82                    MD058068
     C                   If        SQLCODE = 100                                            MD058068
     C                   seton                                        82                    MD058068
     C                   Endif                                                              MD058068
                                                                                            MD058068
      * Save previous selector values.
     C     *LIKE         DEFINE    #2PCOD        WZPCOD
     C                   MOVEL     #2PCOD        WZPCOD                         Product code
     C     *LIKE         DEFINE    #2PCNA        WZPCNA
     C                   MOVEL     #2PCNA        WZPCNA                         Prod code narrative
      * Translate search mask for text field.
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2PCNA        WQPCNA                         Prod code narrative
     C                   CALL      'QDCXLATE'
     C                   PARM      50            WQA5N             5 0          Len
     C                   PARM      #2PCNA        WQPCNA                         Prod code narrative
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
      * Load SFL page.
     C                   Z-ADD     *ZERO         ##RROK            5 0
     C                   EXSR      BBLDSF
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page.
      *================================================================
      * Re-establish fields in read-ahead record.
     C   27              DO
     C**N82*****         READP     BYPRODD0                               90    *           MD058068
     C**N82*****         READ      BYPRODD0                               90    *           MD058068
     C                   If        *IN82 = '0'                                              MD058068
     C/EXEC SQL                                                                             MD058068
     C+ fetch prior from ACursor into :BYPROD                                               MD058068
     C/END-EXEC                                                                             MD058068
     C/EXEC SQL                                                                             MD058068
     C+ fetch next from ACursor into :BYPROD                                                MD058068
     C/END-EXEC                                                                             MD058068
     C                   Endif                                                              MD058068
     C                   END
      *
      * Setof record error indicators.
     C                   MOVE      *ALL'0'       WKINDS            1
     C                   MOVEA     WKINDS        *IN(33)
      * Start at previous highest record in SFL.
     C                   Z-ADD     ##RRMX        ##RR              5 0
      * Reset count of DBF records read.
     C                   Z-ADD     *ZERO         ##RRRD            5 0
      *................................................................
      * Load next SFL page until SFL page full,
      * or scan limit reached,
      * or end of file reached.
     C******IN82         DOWEQ     '0'                                          DO          MD058068
     C*****##RROK        ANDLT     ##SFPG                                                   MD058068
     C*****##RRRD        ANDLT     W0SLM                                                    MD058068
     C                   DOW       SQLCODE = 0                                              MD058068
     C                             and ##RROK < ##SFPG                                      MD058068
     C                             and ##RRRD < W0SLM                                       MD058068
      * Check selection fields - if fail, read next record.
     C     #2PCNA        IFNE      *BLANK                                       Prod code narrative
      * Scan for search string.
     C                   CALL      'QCLSCAN'
     C*                    PARM           DMPCNA           Prod code narrative
     C                   PARM                    LDDESC                         Prod code narrative
     C                   PARM      50            WQA3N             3 0          Length
     C                   PARM      1             WQB3N             3 0          Start
     C                   PARM                    WQPCNA                         Mask
     C                   PARM      50            WQC3N             3 0          Length
     C                   PARM      '1'           WQD1              1            Translate
     C                   PARM      '1'           WQE1              1            Trim
     C                   PARM      '?'           WQF1              1            Wild
     C                   PARM                    WQG3N             3 0          Result
     C     WQG3N         CABLT     1             CD020
     C                   END
      * Load SFL fields.
     C                   EXSR      MBFL#1
      * Output to subfile.
     C                   ADD       1             ##RR                 81        *
     C                   ADD       1             ##RROK
     C                   WRITE     #SFLRCD
      *
     C     CD020         TAG
      * Increment scan check count.
     C                   ADD       1             ##RRRD
      * Read next record.
     C**********         READ      BYPRODD0                             8782    *82=EOF     MD058068
     C/EXEC SQL                                                                             MD058068
     C+ fetch next from ACursor into :BYPROD                                                MD058068
     C/END-EXEC                                                                             MD058068
     C                   END                                                    WOD
      *................................................................
      * If no DBF records found, display error message.
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END
      *
      * Save highest SFL record load can continue at end point.
     C     ##RR          IFGT      ##RRMX
     C     ##RRMX        ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
      *
      * If scan limit reached, display error message.
     C     ##RRRD        IFGE      W0SLM
      * Send message '*Scan limit reached'
     C                   MOVEL     'Y2U0017'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   Z-ADD     *ZERO         ##RROK            5 0
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen.
      *================================================================
      * Update screen time.
     C                   TIME                    ##TME                          Screen time.
     C     W0HLP         DOUEQ     'N'
      * PUTOVR unless conditioned fields change.
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
     C                   MOVEL     'N'           W0HLP             1            Reset help requ
      * If help requested, display help text.
     C   25              EXSR      ZHHPKY                                       Display help te
     C                   END
      * Update job time.
     C                   TIME                    ##JTM                          Job time.
      * Clear messages from program message queue.
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag.
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C                   SETOFF                                         8883    *
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input.
      *================================================================
      * Maintain subfile position where possible.
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      *
     C     *IN81         IFEQ      '1'
      * Process subfile records.
     C                   EXSR      DBPRSF
      * If error, exit subroutine:
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END
      * Change of position specified.
     C     WZPCOD        CASNE     #2PCOD        FBRQRL                         Product code
     C     WZPCNA        CASNE     #2PCNA        FBRQRL                         Prod code narrative
     C                   END
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile records.
      *================================================================
      * Read first changed record (if any).
     C                   READC     #SFLRCD                                88    *
     C     *IN88         DOWEQ     '0'
     C                   EXSR      DCSFRC
     C                   MOVEL     *BLANK        #1SEL
     C                   UPDATE    #SFLRCD
      * Read next record.
     C                   READC     #SFLRCD                                88    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCSFRC        BEGSR
      *================================================================
      * Process subfile record.
      *================================================================
      * Setof error indicators and SFLNXTCHG.
     C                   MOVEA     WKINDS        *IN(33)
     C                   SETOFF                                       84        *
      * Check selection option
     C     #1SEL         CASEQ     '1'           DESLRC
     C                   END
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   DESLRC        BEGSR
      *================================================================
      * Select record & return to calling program
      *================================================================
      * Move record values to parameters.
     C                   MOVEL     #1PCOD        P1PCOD                         Product code
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   DEEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload.
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @CNTYG5 fields to #SFLRCD
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     LDPCOD        #1PCOD                         Product code
     C                   MOVEL     LDDESC        #1PCNA                         Prod code narrative
     C                   MOVE      LDFXNT        #1FXNT
     C                   MOVE      LDMMNT        #1MMNT
     C                   MOVE      LDLENT        #1LENT
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control.
      *================================================================
     C                   MOVEL     P1PCOD        #2PCOD                         Product code
     C                   MOVEL     *BLANK        #2PCNA                         Prod code narrative
      * Drop ? from positioning key fields.
     C                   MOVEL     #2PCOD        W0X1              1
     C     W0X1          IFEQ      '?'
     C     *LIKE         DEFINE    #2PCOD        W0PCOD          - 1
     C                   MOVE      #2PCOD        W0PCOD
     C                   MOVEL     W0PCOD        #2PCOD                         Product code
     C                   MOVE      ' '           #2PCOD
     C                   END
      *
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      * Clear all fields for default mechanism next time.
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text.
      *================================================================
     C                   MOVEL     'Y'           W0HLP             1            Signal help req
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Member name.
     C                   PARM      *BLANK        YYHPFL           10            *DFT text file.
     C                   PARM      *BLANK        YYHPLB           10            Help text lib.
     C                   PARM                    W0RTN             7            Return Code.
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel & exit program.
      *================================================================
      * Send message '*No value selected'
     C                   MOVEL     'Y2U0016'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   MOVEL     '*PRV '       ZAPGRL                         Pgmq rel.
     C                   EXSR      ZASNMS                                       Send message
     C                   MOVEL     'Y2U0016'     P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct.
      *================================================================
      * Terminate program.
     C                   SETON                                        LR
      *
      * Exit program.
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation.
      *================================================================
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      * Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
     C                   MOVEL     'SEL'         W0PMD             3            Program Mode
      *
     C                   Z-ADD     12            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
     C                   Z-ADD     *ZERO         ##RRMX                         MAX RECNO
     C                   Z-ADD     500           W0SLM             5 0          SCAN LIMIT
      * Clear subfile control fields.
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
** CPY@ - Copyright notice for inclusion in all ACT programs
(c) COPYRIGHT ACT INTERNATIONAL LTD. 1995.

     H DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056567
/*STD *  RPGSQLBND                                                    *                     MD056567
/*EXI *  TEXT('Y2 R2.1.1 Values list name search')
      *****************************************************************
      *                                                               *
      *  Midas - Synon-supplied objects                               *
      *                                                               *
      *  MIVLLSR - Display records from condition values list         *
      *            This program is a copy of Y2VLLSR.                 *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056567           Date 20Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                         *CREATE    Date 11Jan96               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056567 - Deliverable Data Split for Validation Lists       *
      *  MD046248 - Finastra Rebranding                               *
      *  098230 - Introduction of standard header box.                *
      *                                                               *
      *****************************************************************
     FY2VLLSR#  CF   E             WORKSTN INFDS(INFDS#)
     F                                     USROPN
     F                                     SFILE(#SFLRCD:##RR)
      * Values list name search   Select record
      *
     F*Y2VLLSL0* IF   E           K DISK    INFDS(INFDS1)                                   MD056567
     F**********                           USROPN                                           MD056567
      * Values list               Retrieval index
      *
      /EJECT
     D @OV             S              2    DIM(20) CTDATA PERRCD(20)
     D @OD             S              2    DIM(20) CTDATA PERRCD(20)
      * Override to correct values list file.
      /EJECT
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure.
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure.
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure.
      /EJECT
      * Parameter declarations.
     D P1PARM          DS
      * FLD: Values list               Retrieval index
      * List number
     D  P1LSNO                 1      4P 0
      * External value.
     D  P1EXVL                 5     24
     D  W0EXVL                 6     24
     D Y2VLLS        E DS                  EXTNAME(MIVLLJW0)                                MD056567
     D  Y2LSNO       E                     EXTFLD(@@CND)                                    MD056567
     D  Y2CNTP       E                     EXTFLD(CNDTYP)                                   MD056567
     D  Y2EXVL       E                     EXTFLD(EXTVAL)                                   MD056567
     D  Y2INVL       E                     EXTFLD(INTVAL)                                   MD056567
     D  Y2CNTX       E                     EXTFLD(CNDTXT)                                   MD056567
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C     P1LSNO        PARM                    WP0001            7 0          List number
     C     P1EXVL        PARM      P1EXVL        WP0002           20            External value
      *****************************************************************
     C                   MOVE      *BLANK        P0RTN                          Return code
      * Initialise
     C                   EXSR      ZZINIT
      * Initialise & load subfile
     C                   EXSR      BAIZSF
      *................................................................
      * Conduct screen conversation:
     C                   DO        *HIVAL
      * Display screen.
     C                   EXSR      CAEXFM
      *   Process response:
      * CK01: Cancel & exit program.
     C   01              CAS                     ZXEXPG
      *   HELP: Display help text.
     C   25              CAS                     ZHHPKY
      *   HOME Reload subfile.
     C   30              CAS                     BAIZSF
      *   Changed start position
     C     #2STVL        CASNE     W0STVL        BAIZSF
      *   Process screen input.
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise & Load subfile.
      *================================================================
      * Clear subfile.
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       8081
      *................................................................
      * Position DBF file to list details.
     C     KRST          KLIST
     C                   KFLD                    Y2LSNO                         List number
     C                   Z-ADD     P1LSNO        Y2LSNO                         List number
     C*****KRST*         SETLL     @Y2LSDA                                                  MD056567
     C*****KRST*         READE     @Y2LSDA                              7182    *82=EOF     MD056567
     C/EXEC SQL                                                                             MD056567
     C+ SELECT *                                                                            MD056567
     C+ into :Y2VLLS                                                                        MD056567
     C+ from Y2VLLJW0                                                                       MD056567
     C+ where @@CND   = :Y2LSNO and CNDTYP = 'LST'                                          MD056567
     C/END-EXEC                                                                             MD056567
     C                   setoff                                       7182                  MD056567
     C                   If        SQLCODE = 100                                            MD056567
     C                   seton                                        82                    MD056567
     C                   Endif                                                              MD056567
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD056567
     C                   seton                                        71                    MD056567
     C                   Endif                                                              MD056567
                                                                                            MD056567
      * Load LST details into #SFLCTL.
     C  N82              EXSR      MAFL#2
      * Position to user start
     C     KPOS          KLIST
     C                   KFLD                    Y2LSNO                         List number
     C                   KFLD                    Y2EXVL                         EXT value
     C**N82#2STVL        IFNE      *BLANK                                                   MD056567
     C     *IN82         IFEQ      '0'                                                      MD056567
     C                   MOVEL     #2STVL        Y2EXVL
     C*****KPOS          SETLL     @Y2EXIN                                                  MD056567
     C/EXEC SQL                                                                             MD056567
     C+ declare BCursor insensitive scroll cursor for                                       MD056567
     C+ select * from Y2VLLJW0                                                              MD056567
     C+ where @@CND   = :Y2LSNO and EXTVAL >= :#2STVL and CNDTYP = 'VAL'                    MD056567
     C+ order by @@CND, EXTVAL                                                              MD056567
     C/END-EXEC                                                                             MD056567
                                                                                            MD056567
     C/EXEC SQL                                                                             MD056567
     C+ close BCursor                                                                       MD056567
     C/END-EXEC                                                                             MD056567
                                                                                            MD056567
     C/EXEC SQL                                                                             MD056567
     C+ open BCursor                                                                        MD056567
     C/END-EXEC                                                                             MD056567
     C                   END
      * Save start position
     C                   MOVE      #2STVL        W0STVL
     C**N82KRST*         READE     @Y2EXIN                              7182    *82=EOF     MD056567
     C/EXEC SQL                                                                             MD056567
     C+ fetch next from BCursor into :Y2VLLS                                                MD056567
     C/END-EXEC                                                                             MD056567
     C                   setoff                                       7182                  MD056567
     C                   If        SQLCODE = 100                                            MD056567
     C                   seton                                        82                    MD056567
     C                   Endif                                                              MD056567
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD056567
     C                   seton                                        71                    MD056567
     C                   Endif                                                              MD056567
                                                                                            MD056567
      * Load SFL.
     C                   EXSR      BBLDSF
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile.
      *================================================================
      * Setof record error indicators.
     C                   MOVE      *ALL'0'       WKINDS            1
     C                   MOVEA     WKINDS        *IN(31)
      * Reset highest record in SFL.
     C                   Z-ADD     0             ##RR              5 0
      *................................................................
      * Load SFL until full
     C  N821             DO        *HIVAL        W0LNNO            5 0          DO
      * Load SFL fields.
     C                   EXSR      MBFL#1
      * Output to subfile.
     C                   ADD       1             ##RR                 81        *
     C                   WRITE     #SFLRCD
     C     W0LNNO        IFEQ      1
     C                   Z-ADD     1             ##SFRC
     C                   END
     C*****KRST*         READE     @Y2EXIN                                82    *82=EOF     MD056567
     C/EXEC SQL                                                                             MD056567
     C+ fetch next from BCursor into :Y2VLLS                                                MD056567
     C/END-EXEC                                                                             MD056567
     C                   setoff                                         82                  MD056567
     C                   If        SQLCODE = 100                                            MD056567
     C                   seton                                        82                    MD056567
     C                   Endif                                                              MD056567
                                                                                            MD056567
     C  N82              END                                                    OD 1 - *HIVAL
      *................................................................
      * If no DBF records found, display error message.
     C   82##RR          IFEQ      *ZERO                                        IF
     C                   MOVE      'Y2U0008'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI ##RR = *ZERO
      *
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen.
      *================================================================
     C     *IN25         DOUEQ     '0'
     C                   WRITE     #MSGCTL                                       MESSAGES
     C                   WRITE     #CMDKEYS                                      MESSAGES
     C                   EXFMT     #SFLCTL                                       SFL CTL
      * Display help text.
     C   25              EXSR      ZHHPKY                                        HELP TEXT
     C                   END
      * Clear messages from program message queue.
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag.
     C                   MOVE      'Y'           ZAFSMS            1      99    *
     C                   SETOFF                                         8883    *
      * Save change SFLRCDNBR if ROLL keys used.
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process subfile records.
      *================================================================
     C   81              DO        *HIVAL
     C                   READC     #SFLRCD                                72    *
      * If SFL record changed, process it:
     C  N72              DO
     C                   EXSR      DCSFRC
     C                   MOVE      *BLANK        #1SEL
     C                   UPDATE    #SFLRCD
     C                   END
     C  N72              END
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DCSFRC        BEGSR
      *================================================================
      * Process subfile record.
      *================================================================
      * Setof error indicators and SFLNXTCHG.
     C                   MOVEA     WKINDS        *IN(31)
     C                   SETOFF                                       84        *
      * Check selection option
     C     #1SEL         IFEQ      'X'
     C     #1SEL         OREQ      '1'
     C     #1EXVL        IFEQ      '*BLANK'
     C                   MOVE      *BLANK        P1EXVL                         External value
     C                   ELSE
     C                   MOVE      #1EXVL        P1EXVL                         External value
     C                   END
     C                   RETURN
     C                   END
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   MAFL#2        BEGSR
      *================================================================
      * Initialise subfile control.
      *================================================================
     C                   MOVE      Y2EXVL        #2EXVL                         External value
     C                   MOVE      Y2CNTX        #2CNTX                         Condition text
     C                   Z-ADD     P1LSNO        #2LSNO                         List number
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @Y2EXIN    fields to #SFLRCD.
      *================================================================
     C                   MOVE      *BLANK        #1SEL
     C     Y2EXVL        IFEQ      *BLANK
     C                   MOVE      *BLANK        #1EXVL                         External value
     C                   MOVEL     '*BLANK'      #1EXVL
     C                   ELSE
     C                   MOVEL     Y2EXVL        #1EXVL                         External value
     C                   END
     C                   MOVEL     Y2CNTX        #1CNTX                         Condition text
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
      * Send first message only.
     C     ZAFSMS        IFEQ      'Y'
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVE      ##PGM         ZAPGM
     C                   END
     C                   MOVE      'N'           ZAFSMS            1
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
     C                   END
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text.
      *================================================================
     C                   CALL      'YDDSHPR'
     C                   PARM                    ##PGM                          Program name
     C                   PARM      *BLANK        YYHPFL           10            *DFT text file.
     C                   PARM      *BLANK        YYHPLB           10            Help text lib.
     C     ZAMSID        PARM                    WWRTVM            7            Retun MSGID.
      * Send return message.
      * ACT - Change message file
     C                   MOVEL     'Y1USRMSG'    ZAMSGF                         MSGF for help
     C                   EXSR      ZASNMS
      * ACT - Reset message file for error messages
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         MSGF for errors
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program by request
      *================================================================
      * Send message '*No value selected'
     C                   MOVE      'Y2U0016'     ZAMSID                         Message id.
     C                   MOVE      '*PRV '       ZAPGRL                         Pgmq rel.
     C                   EXSR      ZASNMS                                       Send message
     C                   MOVE      'Y2U0016'     P0RTN                          No value selected
     C                   MOVE      *BLANK        P1EXVL                         No value
     C                   RETURN                                                 Exit
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation.
      *================================================================
      * First time processing.
     C     ZZ1ST         IFEQ      *BLANK
     C                   MOVE      'N'           ZZ1ST             1
      * *DTAARA = *COMPANY NAME
     C     *DTAARA       DEFINE    YYCOTXA       ##CMP
     C                   IN        *DTAARA
      * Open file xxVLLSL0 where xx is 1st 2 char of program name.
     C                   MOVEL     ##PGM         @OV(9)
      * OVRDBF to correct file name.
     C**********         CALL      'QCAEXEC'                                                MD056567
     C**********         PARM                    @OV                                        MD056567
     C**********         PARM      40            WKOVLN           15 5                      MD056567
     C**********         OPEN      Y2VLLSL0                             90                  MD056567
     C******IN90         IFEQ      '1'                                                      MD056567
     C**********         MOVEL     @1MSID        P0RTN                          Exception msMD056567
     C**********         RETURN                                                             MD056567
     C**********         END                                                                MD056567
      * Open file xxVLLSR# where xx is 1st 2 char of program name.
     C                   MOVEL     ##PGM         @OD(10)
      * OVRDSPF to correct file name.
     C                   CALL      'QCAEXEC'
     C                   PARM                    @OD
     C                   PARM      40            WKOVLN           15 5
     C                   OPEN      Y2VLLSR#                             90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     @1MSID        P0RTN                          Exception msgid
     C                   RETURN
     C                   END
     C                   END
      *................................................................
     C                   Z-ADD     1             ##SFRC                         SFLRCDNBR
      *................................................................
     C                   MOVE      *BLANK        W0STVL           20            PRV START
     C                   MOVEL     W0EXVL        #2STVL                         PRV START
      *................................................................
     C                   MOVEL     'Y2USRMSG'    ZAMSGF           10            MSGF for errors
      *================================================================
     CSR   ZZEXIT        ENDSR
** @OV4 5 6 7 8 9
OVRDBF Y2VLLSL0 ??VLLSL0 SECURE(*YES)
** @OD4 5 6 7 8 9 10
OVRDSPF Y2VLLSR#  ??VLLSR# SECURE(*YES)

     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas GP SAR maintenance insert feature screen')       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP0430S - Insert Switchable Features with passwords.         *
      *                                                               *
      *  Function:  This program is similar to SC0340S                *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD056555 *CREATE   Date 31Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *                                                               *
      *****************************************************************
     FGP0430S#  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
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
      /EJECT
      * Parameter declarations.
     D P1PARM          DS
      * FLD: Mutually Exclusive Compnt
      * B:MAP Switchable feature description
     D  P1SARD                 1     50
      * B:MAP Switchable feature ID
     D  P1SARN                51     56
     D GPSARD        E DS                  EXTNAME(GPSRAJW0)
     D NullInds        s              5i 0 dim(6)
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C     P1SARD        PARM      P1SARD        WP0002           50            SF ID          CSC00
     C     P1SARN        PARM      P1SARN        WP0001            6            SF Descript ionCSC00
      *****************************************************************
      * Initialise
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
      * HOME: Request subfile reload.
     C   05              CAS                     FBRQRL
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
     C/EXEC SQL
     C+ close ACursor
     C/END-EXEC
      *................................................................
      * Position DBF file:
     C                   MOVEL     #2SARN        AXSARN                         Component Name
      *
      * Read GPSRAJW0, which contains all the SFs which the client
      * may switch on at their current release level.
      *
     C/EXEC SQL
     C+ declare ACursor insensitive scroll cursor for
     C+ select * from GPSRAJW0
     C+ where AXSARN >= :#2SARN
     C+ order by AXSARN
     C/END-EXEC

     C/EXEC SQL
     C+ open ACursor
     C/END-EXEC

     C/EXEC SQL
     C+ fetch next from ACursor into :GPSARD :NullInds
     C/END-EXEC

     C                   SETOFF                                       82
     C                   If        SQLCODE = 100
     C                   SETON                                        82
     C                   Endif
      *
      * Save previous selector values.
     C     *LIKE         DEFINE    #2RSTS        WZRSTS
     C                   MOVEL     #2RSTS        WZRSTS
     C     *LIKE         DEFINE    #2SARN        WZSARN
     C                   MOVEL     #2SARN        WZSARN
     C     *LIKE         DEFINE    #2SARD        WZSARD
     C                   MOVEL     #2SARD        WZSARD
     C     *LIKE         DEFINE    #2RELL        WZRELL
     C                   MOVEL     #2RELL        WZRELL
     C     *LIKE         DEFINE    #2IREL        WZIREL
     C                   MOVEL     #2IREL        WZIREL
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
     C     *IN82         IFEQ      '0'
     C/EXEC SQL
     C+ fetch prior from ACursor into :GPSARD :NullInds
     C/END-EXEC
     C/EXEC SQL
     C+ fetch next from ACursor into :GPSARD :NullInds
     C/END-EXEC
     C                   ENDIF
     C                   END
      *
      * Setof record error indicators.
     C                   MOVE      *ALL'0'       WKINDS            1
     C                   MOVEA     WKINDS        *IN(35)
      * Start at previous highest record in SFL.
     C                   Z-ADD     ##RRMX        ##RR              5 0
      * Reset count of DBF records read.
     C                   Z-ADD     *ZERO         ##RRRD            5 0
      *................................................................
      * Load next SFL page until SFL page full,
      * or scan limit reached,
      * or end of file reached.
     C     SQLCODE       DOWEQ     0                                            DO          MD055681
     C     ##RROK        ANDLT     ##SFPG
     C     ##RRRD        ANDLT     W0SLM
      * Check selection fields - if fail, read next record.
     C     #2SARN        IFEQ      *BLANK                                       Component Name CSC00
     C     #2SARD        OREQ      *BLANK                                       Component SequeCSC00
     C     #2RSTS        IFNE      *BLANK                                       Mutually Excl.
     C     AXRSTS        CABNE     #2RSTS        CD020                          Mutually Excl.
     C                   END
     C                   END
     C     #2SARN        IFEQ      *BLANK                                       Component Name CSC00
     C     #2SARD        IFNE      *BLANK                                       Component SequeCSC00
     C     AXSARD        CABNE     #2SARD        CD020                          Component SequeCSC00
     C                   END
     C                   END
     C     #2RELL        IFNE      *BLANK                                       Mut. Excl. Comp
     C     AXRELL        CABNE     #2RELL        CD020                          Mut. Excl. Comp
     C                   END
     C     #2IREL        IFNE      *BLANK                                       Mut. Excl. Comp
     C     AXIREL        CABNE     #2IREL        CD020                          Mut. Excl. Comp
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
      *
      * Read GPSRAJW0, which contains all the SFs which the client
      * may switch on at their current release level.
      *
     C/EXEC SQL
     C+ fetch next from ACursor into :GPSARD :NullInds
     C/END-EXEC
     C                   END                                                    WOD
      *................................................................
      * If no DBF records found, display error message.
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file
     C                   MOVEL     '*PRV'        ZAPGRL            5
     C                   EXSR      ZASNMS                                       Send message
     C                   EXSR      ZYEXPG
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
     C                   PARM      '*PRV'        ZAPGRL            5
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
     C     WZRSTS        CASNE     #2RSTS        FBRQRL                         Mutually Excl.
     C     WZSARN        CASNE     #2SARN        FBRQRL                         Component Name CSC00
     C     WZSARD        CASNE     #2SARD        FBRQRL                         Component SequeCSC00
     C     WZRELL        CASNE     #2RELL        FBRQRL                         Mut. Excl. Comp
     C     WZIREL        CASNE     #2IREL        FBRQRL                         Mut. Excl. Comp
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
     C                   MOVEA     WKINDS        *IN(35)
     C                   SETOFF                                       84        *
      * Check selection option
     C     #1SEL         CASEQ     'X'           DESLRC
     C                   END
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   DESLRC        BEGSR
      *================================================================
      * Select record & return to calling program
      *================================================================
      * Move record values to parameters.
     C                   MOVEL     #1SARN        P1SARN                         Component Name CSC00
     C                   MOVEL     #1SARD        P1SARD                         Component SequeCSC00
     C                   MOVEL     *BLANK        P0RTN
      *
      * At this point the user has selected a SAR for insertion.
      * First, the dependency checking program SC3010X is called
      * to see if this SAR requires another SAR to be active before
      * it can be switched on. If the SAR passes the dependency
      * checking, the window program GP0430W0 is called so a
      * password may be entered. If the password is valid, the blank
      * return code is returned below or an error message is displayed
      * on the main screen.
      *
      * call dependency checking program
      *
     C*                  CALL      'SC3010X'
      *
      * Dependency checking OK so call the window program and
      * prompt for the password.
      *
     C                   CALL      'GP0430W0'
      * Return code
     C                   PARM                    P0RTN
      * KEYP defines whether F3 or F12 has been pressed in GP0430W0
     C                   PARM                    KEYP              6
      * Switchable Feature number
     C                   PARM                    P1SARN
      *
      * Return code if equals blanks, then insertion is successful.
      * Error case is handled in window program (GP0430W0).
      *
     C     P0RTN         IFEQ      *BLANKS

     C                   MOVEL     'GP0430S'     ZAPGM
     C                   MOVEL     'CBUSRMSG'    ZAMSGF

      * Display message that SAR inserted successfully.
      *
     C                   MOVE      'CBM0230'     ZAMSID
     C                   MOVEL     P1SARN        ZAMSDA                                        CSC01
     C                   EXSR      ZASNMS
     C                   ENDIF
     C     KEYP          IFEQ      '*F12'
      *
      * If F12 pressed process subfile reload.
      *
     C                   EXSR      FBRQRL
     C                   ELSE
      *
      * If F3 pressed or password entry successful return to SC3010M
      * (main screen)
      *
     C                   EXSR      ZYEXPG
     C                   ENDIF
     C                   MOVE      *BLANKS       KEYP
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
      * Move SCSARAJF fields to #SFLRCD
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     AXSARN        #1SARN                         Component Name CSC00
     C                   MOVEL     AXSARD        #1SARD                         Component SequeCSC00
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control.
      *================================================================
     C                   MOVEL     *BLANK        #2RSTS                         Mutually Excl.
     C                   MOVEL     P1SARN        #2SARN                         Component Name CSC00
     C                   MOVEL     P1SARD        #2SARD                         Component SequeCSC00
     C                   MOVEL     *BLANK        #2RELL                         Mut. Excl. Comp
     C                   MOVEL     *BLANK        #2IREL                         Mut. Excl. Comp
     C*
     C                   MOVEL     #2SARN        W0X1              1                           CSC00
     C     W0X1          IFEQ      '?'
     C     *LIKE         DEFINE    #2SARN        W0SARN          - 1
     C                   MOVE      #2SARN        W0SARN
     C                   MOVEL     W0SARN        #2SARN                         Component Name CSC00
     C                   MOVE      ' '           #2SARN
     C                   END
      *
     C                   MOVEL     #2SARD        W0X1              1                           CSC00
     C     W0X1          IFEQ      '?'                                                         CSC00
     C     *LIKE         DEFINE    #2SARD        W0SARD          - 1                           CSC00
     C                   MOVE      #2SARD        W0SARD                                        CSC00
     C                   MOVEL     W0SARD        #2SARD                         Component SequeCSC00
     C                   MOVE      ' '           #2SARD                                        CSC00
     C                   END                                                                   CSC00
      *
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
      * Send if first error message or not an error message.
     C     ZAMSTP        IFNE      *BLANK
     C     ZAFSMS        ORNE      'N'
     C     ZAMSTP        IFEQ      *BLANK
      * Signal first error message sent.
     C                   MOVEL     'N'           ZAFSMS
     C                   END
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
     C                   END
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
     C/EXEC SQL                                                                             MD055681
     C+ close ACursor                                                                       MD055681
     C/END-EXEC                                                                             MD055681
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
     C     P0RTN         IFEQ      'B'                                                         CSC00
     C                   MOVE      *ON           *IN46                                         CSC00
     C                   ENDIF                                                                 CSC00
     C     P0RTN         IFEQ      'C'                                                         CSC00
     C                   MOVE      *ON           *IN45                                         CSC00
     C                   ENDIF                                                                 CSC00
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      * Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
      * Signal first error message outstanding.
     C                   MOVEL     'Y'           ZAFSMS            1
     C                   MOVEL     'SEL'         W0PMD             3            Program Mode
      *
     C                   Z-ADD     13            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
     C                   Z-ADD     *ZERO         ##RRMX                         MAX RECNO
     C                   Z-ADD     500           W0SLM             5 0          SCAN LIMIT
      * Clear subfile control fields.
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR

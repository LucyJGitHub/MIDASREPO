     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Midas WIP config subfile')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP009620 - Midas GP WIP configuration subfile                *
      *                                                               *
      *  Function: This program displays a subfile of all available   *
      *            API for WIP configuration maintenance or           *
      *            enquiry. All zones records are shown.              *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD054733           Date 02Dec19               *
      *  Prev Amend No. MD054209 *CREATE   Date 31Aug19               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054209 - Deliverable Data Split                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       03         F3 has been pressed (Exit program).          *
      *       05         F5 has been pressed (Refresh screen).        *
      *       11         F11 has been pressed (Display Description    *
      *                  or Current Setting).                         *
      *       27         On to display next subfile page.             *
      *       31         Invalid API Name.                            *
      *       32         Invalid New BO Writing Workflow.             *
      *       33         Invalid Amend BO Writing Workflow.           *
      *       34         Invalid Authorization Level.                 *
      *       38         Invalid Selection.                           *
      *       70         Maintenance mode.                            *
      *       75         Empty file SDBANKL1.                         *
      *       80         Clear subfile.                               *
      *       82         End of file.                                 *
      *       84         Subfile next change.                         *
      *       86         Subfile next change.                         *
      *       90         Error when calling program.                  *
      *       99         Global error flag.                           *
      *                                                               *
      *****************************************************************
     FGP009620DFCF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     SFILE(#SFLRCE:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas GP WIP Configuration screens
      *
      *
     FSDBANKL1  IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Bank Details ICD File
      *
      * Copyright notice for inclusion in all programs
      *
      ********************************************************************
      * Copyright array
     D A@CPY           DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
      *
     D PGM@            S             10    DIM(1) CTDATA PERRCD(1)              Programs to call
      *
      /EJECT
      * Data structures:
      * Program data structure
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
      * Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      *
      *
     D GPWIP         E DS                  EXTNAME(GPWIPJW0)
     D NullInds        s              5i 0 dim(23)
     D WWC_ID          S              9  0
     D POS             S              5  0
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *
      /EJECT
     D                 DS
     D  ZAMSDA                 1    132

      ** Declare the message file
     D WUMSGF          S             10    INZ('SDUSRMSG')

      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    MODE              1
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      *
      * Initialise & load subfile page
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      *
      * Display screen until reload requested
     C     W0RSF         DOWEQ     'N'
      *
      * Display screen
     C                   EXSR      CAEXFM
      *
      * Process response
      * Cancel & exit program
     C   03              CAS                     ZYEXPG
      *
      * Request subfile reload
     C   05              CAS                     FBRQRL
      *
      * Display next SFL page
     C   27              CAS                     BBLDSF
      *
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
      *
      * Clear subfile
     C                   SETON                                        80
      * Maintenance mode
     C   70              WRITE     #SFLCTL
      * Enquiry mode
     C  N70              WRITE     #SFLCTE
     C                   SETOFF                                       80
      *
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      *
      * Setup key
     C                   MOVEL     #2UNII        WWC_ID                         Unique Id

      ** Display all records if #2UNII is blank
     C/EXEC SQL
     C+ declare ACursor insensitive scroll cursor for
     C+ select * from GPWIPJW0
     C+ where WC_ID = :WWC_ID   or WC_ID > :WWC_ID
     C+ and WC_ZONE <> '*REFZONE'
     C+ order by WC_API, WC_ZONE
     C/END-EXEC

     C/EXEC SQL
     C+ close ACursor
     C/END-EXEC

     C/EXEC SQL
     C+ open ACursor
     C/END-EXEC

     C/EXEC SQL
     C+ fetch next from ACursor into :GPWIP :NullInds
     C/END-EXEC
     C                   If        SQLCODE = 100
     C                   SETON                                        82
     C                   ELSE
     C                   SETOFF                                       82
     C                   ENDIF
      *
      * Save previous selector values
     C     *LIKE         DEFINE    #2UNII        WZUNII
     C                   eval      WZUNII = #2UNII
     C     *LIKE         DEFINE    #2APIN        WZAPIN
     C                   MOVEL     #2APIN        WZAPIN                         API Name
     C     *LIKE         DEFINE    #2NBOW        WZNBOW
     C                   MOVEL     #2NBOW        WZNBOW                         New Back Off Workflo
     C     *LIKE         DEFINE    #2ABOW        WZABOW
     C                   MOVEL     #2ABOW        WZABOW                         Amend Back Off Workf
     C     *LIKE         DEFINE    #2AUTL        WZAUTL
     C                   MOVEL     #2AUTL        WZAUTL                         Authorization level
     C     *LIKE         DEFINE    #2ZONE        WZZONE
     C                   MOVEL     #2ZONE        WZZONE                         Authorization level
      *
      *
      * Translate search mask for text field (Current Setting)
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2AUTL        WQAUTL                         Midas Desc.
     C                   CALL      'QDCXLATE'
      *
      * Length
     C                   PARM      48            WQA5N             5 0
     C                   PARM      #2AUTL        WQAUTL                         Midas Desc.
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
      *
      *
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
      *
      * Re-establish fields in read-ahead record
     C   27              DO
     C                   If        *IN82 = '0'
     C/EXEC SQL
     C+ fetch prior from ACursor into :GPWIP :NullInds
     C/END-EXEC
     C/EXEC SQL
     C+ fetch next from ACursor into :GPWIP :NullInds
     C/END-EXEC
     C                   Endif
     C                   END
      *
      * Setof record error indicators
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(38)
      *
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
      *
      * Reset count of DBF records read
     C                   Z-ADD     0             ##RRRD            5 0
      *
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
      *
      * Compute lines required based on pages
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   END
      *
      * Load next SFL page until SFL page full, or
      * Scan limit reached
     C                   DOW       SQLCODE = 0
     C                             and ##RROK < ##SFLN
     C                             and ##RRRD < W0SLM
      *
      * Check selection fields - if fail, read next record :
      *
      * Check API Name
     C     #2APIN        IFNE      *BLANK
     C                   eval      pos = %SCAN(%TRIM(#2APIN):%TRIM(WC_API):1)
     C     pos           CABEQ     0             BB020
     C                   END
      *
      * Check New Back Office Writing Workflow
     C     #2NBOW        IFNE      *BLANK
     C                   eval      pos = %SCAN(%TRIM(#2NBOW):%TRIM(WC_BONSTP):1)
     C     pos           CABEQ     0             BB020
     C                   END
      *
      * Check Amend Back Office Writing Workflow
     C     #2ABOW        IFNE      *BLANK
     C                   eval      pos = %SCAN(%TRIM(#2ABOW):%TRIM(WC_BOASTP):1)
     C     pos           CABEQ     0             BB020
     C                   END
      *
      * Check Authorization Level
     C     #2AUTL        IFNE      *BLANK
     C                   eval      pos = %SCAN(%TRIM(#2AUTL):%TRIM(WC_AUTLVL):1)
     C     pos           CABEQ     0             BB020
     C                   END
      *
      * Check Zone
     C     #2ZONE        IFNE      *BLANK
     C                   eval      pos = %SCAN(%TRIM(#2ZONE):%TRIM(WC_ZONE):1)
     C     pos           CABEQ     0             BB020
     C                   END
      *
      *
      * Load SFL fields
     C                   EXSR      MBFL#1
      *
      * Output to subfile
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81        *
      *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
      * Maintenance mode
     C   70              WRITE     #SFLRCD
      * Enquiry mode
     C  N70              WRITE     #SFLRCE
      *
     C     BB020         TAG
      *
      * Increment scan check count
     C                   ADD       1             ##RRRD
      *
     C/EXEC SQL
     C+ fetch next from ACursor into :GPWIP :NullInds
     C/END-EXEC
     C                   If        SQLCODE = 100
     C                   SETON                                        82
     C                   ELSE
     C                   SETOFF                                       82
     C                   ENDIF
      *
     C                   END                                                    OD 1 - ##SFPG
      *
      *................................................................
     C     BB900         TAG
      *................................................................
      *
      * If no DBF records found, display error message
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      *
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI ##RR = *ZERO
      *
      * Save highest SFL record load can continue at end point
     C     ##RR          IFGT      ##RRMX
      *
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
      *
      * If scan limit reached, display error message
     C     ##RRRD        IFGE      W0SLM
      *
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
      *
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      *
      * Update screen time
     C                   TIME                    ##TME
      *
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN81         CAIN81            1
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
      * Maintenance mode
     C   70              EXFMT     #SFLCTL
      * Enquiry mode
     C  N70              EXFMT     #SFLCTE
      *
      * Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      *
      * Test cursor
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW             5 0
     C                   MVR                     W0CCL
      *
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
      *
     C                   MOVE      *BLANK        WCSRLC
     C                   END
      *
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C                   SETOFF                                         8392    *
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
      *
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      *
      * Change of position specified
     C     WZAPIN        CASNE     #2APIN        FBRQRL
     C     WZNBOW        CASNE     #2NBOW        FBRQRL
     C     WZABOW        CASNE     #2ABOW        FBRQRL
     C     WZAUTL        CASNE     #2AUTL        FBRQRL
     C     WZZONE        CASNE     #2ZONE        FBRQRL
     C                   END
      *
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      *
      * Process subfile records
     C                   EXSR      DBPRSF
     C                   END
      *
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      *
      *
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Maintenance mode
     C   70              READC     #SFLRCD                                92    *
      * Enquiry mode
     C  N70              READC     #SFLRCE                                92    *
     C     *IN92         DOWEQ     '0'
      *
      * Process subfile record
     C                   EXSR      DCPRSR
      * Maintenance mode
     C   70              UPDATE    #SFLRCD
     C   70              READC     #SFLRCD                                92    *
      * Enquiry mode
     C  N70              UPDATE    #SFLRCE
     C  N70              READC     #SFLRCE                                92    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      *
      * Setof error indicators and SFLNXTCHG
     C                   MOVEA     WKIND0        *IN(38)
     C                   SETOFF                                       98        *
      *
      * Enquire processing
     C     #1SEL         IFEQ      'E'                                          *IF
      *
      * WIP Config API display
     C                   CALL      'GP009621'                           90
      *
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #1APID        WQ0004            9 0
     C                   PARM      'E'           WQ0005            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      *
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'GP009621'    W0CLPG
      *
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
      *
     C                   END                                                    *FI
      *
      *
      * Amend processing
     C     #1SEL         IFEQ      'A'                                          *IF
      *
     C                   CALL      'GP009621'                           90
      *
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #1APID        WQ0004
     C                   PARM      'A'           WQ0005            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      *
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'GP009621'    W0CLPG
      *
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   ENDIF
      *
      * Error detected?
     C     W0RTN         IFEQ      'USR7009'
     C                   MOVEL     'USR7009'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     #1APID        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   ELSE
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
     C                   ENDIF
      *
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
      *
     C                   ELSE
      * CASE: *Otherwise
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     'Y'           W0DCF                          *Defer Confirm
     C                   END                                                    *FI
      *
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
      *
     C     *IN98         IFEQ      '1'
      *
      * SFLRCD invalid
     C  N99              Z-ADD     ##RR          ##SFRC               99        *
      * SFLNXTCHG
     C                   SETON                                        84
     C                   ELSE
      *
      * SFLRCD valid
      * SFLNXTCHG
     C                   SETOFF                                       84
     C                   MOVEL     *BLANK        #1SEL
     C                   END                                                    FI *IN98
      *================================================================
     CSR   DCEXIT        ENDSR
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
      * Move GPWIG fields to subfile
      *================================================================
     C                   eval      #1APID = WC_ID
     C                   eval      #1APIN = WC_API
     C                   eval      #1NBOW = WC_BONSTP
     C                   eval      #1ABOW = WC_BOASTP
     C                   eval      #1AUTL = WC_AUTLVL
     C                   eval      #1ZONE = WC_ZONE
      *
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *
      *
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2UNII
     C                   MOVEL     *BLANK        #2APIN
     C                   MOVEL     *BLANK        #2NBOW
     C                   MOVEL     *BLANK        #2ABOW
     C                   MOVEL     *BLANK        #2AUTL
     C                   MOVEL     *BLANK        #2ZONE
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      *
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     WUMSGF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      *
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
      *
      * If called in maintenance mode then set on *IN70
     C     MODE          IFEQ      'M'
     C                   SETON                                        70
     C                   ENDIF
      *
      * If in maintenance mode then allow an'A' to be entered in the
      * subfile selection
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSF             1
      *
      *
      * Flag no *SET CURSOR in the program
     C                   MOVE      *BLANK        WCSRLC            3
      *
      * Define program work fields
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      *
      *
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
      *
      * Create qualified 'library/file' name
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
      *
      * Open files
     C                   OPEN      GP009620DF
     C                   Z-ADD     13            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      *
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      *
      * Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      *
      * Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      *
      * Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
      *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
      *
      * Set-up Dsp. file footer - Standard Functions  *
     C                   MOVE      *BLANKS       WUMTXT           80
      *
      * Setup footer text:
      * A=Amend  E=Enquire  F3=Main Menu  F5=Refresh
     C   70              MOVEL     'USR7010'     WUMSID            7            Message Identifier
      * E=Enquire  F3=Main Menu  F5=Refresh
     C  N70              MOVEL     'USR3006'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *
     C     *IN90         IFEQ      '1'
      *
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      *
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
      *
     C                   ELSE
     C                   END
      *
     C                   Z-ADD     99999         W0SLM                          *Scan limit
      *
      * Get System Set up flag from SDBANKPD file.
     C                   OPEN      SDBANKL1
     C     *LOVAL        SETLL     SDBANKL1                           75
     C  N75              READ      SDBANKL1                               75
     C     *LIKE         DEFINE    BJSUC         WSETUP
     C  N75              MOVEL     BJSUC         WSETUP
     C                   CLOSE     SDBANKL1
      *
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
      * Standard Midas PSSR processing.
      *
     C/COPY SDCPYSRC,SDPSSRINTI
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2019
**CTDATA PGM@
SDC009520

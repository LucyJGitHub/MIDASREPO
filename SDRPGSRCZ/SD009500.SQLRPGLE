     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD054605
/*STD *  RPGSQLBND                                                    *                     MD054605
/*EXI *  TEXT('Midas SD Midas system values subfile')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009500 - Midas SD Midas System Values subfile              *
      *                                                               *
      *  Function: This program displays a subfile of all available   *
      *            system values for users to select for maintenance/ *
      *            enquiry.                                           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR796650           Date 27Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG7330            Date 03Jun05               *
      *                 216378 *CREATE     Date 06Mar03               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054605 - Deliverable Data Split                            *
      *  MD046248 - Finastra Rebranding                               *
      *  AR796650 - Use of data area Y2MGFLA is redundant             *
      *  BUG7330 - Cannot amend RolloverDays system value             *
      *  216378 - Convert to RPGLE type                               *
      *         - When System Setup is On and GISUPP is 'SYSTEMSETUP',*
      *           the system value record can now be enquired but not *
      *           be amended.                                         *
      *         - Add program id as parameter when calling SDC009520. *
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
      *       31         Invalid System Value selection.              *
      *       32         Invalid Module selection.                    *
      *       33         Invalid Description selection.               *
      *       34         Invalid Current Setting selection.           *
      *       38         Invalid Subfile Selection entry.             *
      *       42         ON, display Description.                     *
      *                  OFF, display Current Setting.                *
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
     FSD009500DFCF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     SFILE(#SFLRCD2:##RR)
     F                                     SFILE(#SFLRCE:##RR)
     F                                     SFILE(#SFLRCE2:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Display System Values
      *
     F*SDSVALJ0* IF   E           K DISK    USROPN                                          MD054605
     F**********                           INFDS(INFDS1)                                    MD054605
     F**********                           INFSR(*PSSR)                                     MD054605
      * RTV : Midas SD System Values retrieval
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
      *
     D PGM@            S             10    DIM(1) CTDATA PERRCD(1)              Programs to call
      *
      * Programs to call
      *
      /EJECT
      * Data structures:
      * Program data structure
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
      * Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      *
      * File information data structure
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      *
     D SDSVAL        E DS                  EXTNAME(SDSVLJW1)                                MD054605
     D NullInds        s              5i 0 dim(21)                                          MD054605
     D WGISVAL         S             20                                                     MD054605
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
                                                                                             BUG7330
      ** Declare the message file                                                            BUG7330
     D WUMSGF          S             10    INZ('GBSDUSRMSG')                                 BUG7330
                                                                                             BUG7330
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
     C   42
     CAN 70              WRITE     #SFLCTL
     C  N42
     CAN 70              WRITE     #SFLCTL2
      * Enquiry mode
     C   42
     CANN70              WRITE     #SFLCTE
     C  N42
     CANN70              WRITE     #SFLCTE2
     C                   SETOFF                                       80
      *
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      *
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    GISVAL                         System Value
      * Setup key
     C                   MOVEL     #2SVAL        GISVAL                         System Value
     C                   If        MODE = 'B'                                               MD054605
     C/EXEC SQL                                                                             MD054605
     C+ close UCursor                                                                       MD054605
     C/END-EXEC                                                                             MD054605
     C                   Else                                                               MD054605
     C/EXEC SQL                                                                             MD054605
     C+ close ACursor                                                                       MD054605
     C/END-EXEC                                                                             MD054605
     C                   Endif                                                              MD054605
                                                                                            MD054605
                                                                                            MD054605
      ** Display all records if #2SVAL is blank                                             MD054605
     C                   IF        GISVAL = *BLANKS                                         MD054605
     C                   EVAL      WGISVAL = '%'                                            MD054605
     C                   ELSE                                                               MD054605
     C                   EVAL      WGISVAL = %TRIMR(GISVAL) + '%'                           MD054605
     C                   ENDIF                                                              MD054605
     C                   EVAL      WGISVAL = GISVAL                                         MD054605
     C*****KPOS*         SETLL     @SVALJ0                                                  MD054605
     C**********         READ      @SVALJ0                                82    *82=EOF     MD054605
      ** If program is called by UPC100001, UPSVALJ0 must be used                           MD054605
     C                   If        MODE = 'B'                                               MD054605
     C/EXEC SQL                                                                             MD054605
     C+ declare UCursor insensitive scroll cursor for                                       MD054605
     C+ select * from UPSVALJ0                                                              MD054605
     C+ where GISVAL = :WGISVAL  or GISVAL > :WGISVAL                                       MD054605
     C+ order by GISVAL                                                                     MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ open UCursor                                                                        MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ fetch next from UCursor into :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   Else                                                               MD054605
     C/EXEC SQL                                                                             MD054605
     C+ declare ACursor insensitive scroll cursor for                                       MD054605
     C+ select * from SDSVLJW1                                                              MD054605
     C+ where GISVAL = :WGISVAL  or GISVAL > :WGISVAL                                       MD054605
     C+ order by GISVAL                                                                     MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ open ACursor                                                                        MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ fetch next from ACursor into :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   Endif                                                              MD054605
     C                   If        SQLCODE = 100                                            MD054605
     C                   SETON                                        82                    MD054605
     C                   ELSE                                                               MD054605
     C                   SETOFF                                       82                    MD054605
     C                   ENDIF                                                              MD054605
      *
      * Save previous selector values
     C     *LIKE         DEFINE    #2SVAL        WZSVAL
     C                   MOVEL     #2SVAL        WZSVAL                         System Value
     C     *LIKE         DEFINE    #2MMOD        WZMMOD
     C                   MOVEL     #2MMOD        WZMMOD                         Midas Module
     C     *LIKE         DEFINE    #2DESC        WZDESC
     C                   MOVEL     #2DESC        WZDESC                         Description
     C     *LIKE         DEFINE    #2VA48        WZVA48
     C                   MOVEL     #2VA48        WZVA48                         Cur. Setting
      *
      * If Midas description is displayed.
     C     *IN42         IFEQ      '1'
      * Translate search mask for text field (Midas Description)
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2DESC        WQDESC                         Midas Desc.
     C                   CALL      'QDCXLATE'
      *
      * Length
     C                   PARM      50            WQA5N             5 0
     C                   PARM      #2DESC        WQDESC                         Midas Desc.
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
      *
     C                   ELSE
      *
      * Translate search mask for text field (Current Setting)
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2VA48        WQVA48                         Midas Desc.
     C                   CALL      'QDCXLATE'
      *
      * Length
     C                   PARM      48            WQA5N             5 0
     C                   PARM      #2VA48        WQVA48                         Midas Desc.
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
      *
     C                   END
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
     C**N82*****         READP     @SVALJ0                                90    *           MD054605
     C**N82*****         READ      @SVALJ0                                90    *           MD054605
     C                   If        *IN82 = '0'                                              MD054605
     C                   If        MODE = 'B'                                               MD054605
     C/EXEC SQL                                                                             MD054605
     C+ fetch prior from UCursor into :SDSVAL :NullInds                                     MD054605
     C/END-EXEC                                                                             MD054605
     C/EXEC SQL                                                                             MD054605
     C+ fetch next from UCursor into :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   Else                                                               MD054605
     C/EXEC SQL                                                                             MD054605
     C+ fetch prior from ACursor into :SDSVAL :NullInds                                     MD054605
     C/END-EXEC                                                                             MD054605
     C/EXEC SQL                                                                             MD054605
     C+ fetch next from ACursor into :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   Endif                                                              MD054605
     C                   Endif                                                              MD054605
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
     C******IN82         DOWEQ     '0'                                          DO          MD054605
     C*****##RROK        ANDLT     ##SFLN                                                   MD054605
     C*****##RRRD        ANDLT     W0SLM                                                    MD054605
     C                   DOW       SQLCODE = 0                                              MD054605
     C                             and ##RROK < ##SFLN                                      MD054605
     C                             and ##RRRD < W0SLM                                       MD054605
      *
      * Check selection fields - if fail, read next record :
      *
      * Not display record if Suupress Update field is 'HIDE'
     C     GISUPP        IFEQ      'HIDE'
     C                   GOTO      BB020
     C                   END
      *
      * Check Midas module
     C     #2MMOD        IFNE      *BLANK                                       Midas Module
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    GIMMOD                         Description
      *
      * Length
     C                   PARM      2             WQA3N             3 0
      *
      * Start
     C                   PARM      1             WQB3N             3 0
      *
      * Mask
     C                   PARM                    #2MMOD
      *
      * Length
     C                   PARM      2             WQC3N             3 0
      *
      * Translate
     C                   PARM      '1'           WQD1              1
      *
      * Trim
     C                   PARM      '1'           WQE1              1
      *
      * Wild
     C                   PARM      '?'           WQF1              1
      *
      * Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
     C     *IN42         IFEQ      '1'
      * Check description
     C     #2DESC        IFNE      *BLANK                                       Description
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    GIDESC                         Description
      *
      * Length
     C                   PARM      50            WQA3N             3 0
      *
      * Start
     C                   PARM      1             WQB3N             3 0
      *
      * Mask
     C                   PARM                    WQDESC
      *
      * Length
     C                   PARM      50            WQC3N             3 0
      *
      * Translate
     C                   PARM      '1'           WQD1              1
      *
      * Trim
     C                   PARM      '1'           WQE1              1
      *
      * Wild
     C                   PARM      '?'           WQF1              1
      *
      * Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
     C                   ELSE
      * Check Current Setting
     C     #2VA48        IFNE      *BLANK                                       Cur. Setting
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    GIVAL                          Cur. Setting
      *
      * Length
     C                   PARM      200           WQA3N             3 0
      *
      * Start
     C                   PARM      1             WQB3N             3 0
      *
      * Mask
     C                   PARM                    WQVA48
      *
      * Length
     C                   PARM      48            WQC3N             3 0
      *
      * Translate
     C                   PARM      '1'           WQD1              1
      *
      * Trim
     C                   PARM      '1'           WQE1              1
      *
      * Wild
     C                   PARM      '?'           WQF1              1
      *
      * Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
     C                   END
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
     C   42
     CAN 70              WRITE     #SFLRCD
     C  N42
     CAN 70              WRITE     #SFLRCD2
      * Enquiry mode
     C   42
     CANN70              WRITE     #SFLRCE
     C  N42
     CANN70              WRITE     #SFLRCE2
      *
     C     BB020         TAG
      *
      * Increment scan check count
     C                   ADD       1             ##RRRD
      *
      * Read next records until different system value.
     C                   MOVEL     GISVAL        LSVAL
      *
     C     GISVAL        DOWEQ     LSVAL
     C******IN82         ANDEQ     '0'                                                      MD054605
     C     SQLCODE       ANDEQ     0                                                        MD054605
     C**********         READ      @SVALJ0                                82    *82=EOF     MD054605
     C                   If        MODE = 'B'                                               MD054605
     C/EXEC SQL                                                                             MD054605
     C+ fetch next from UCursor into :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   Else                                                               MD054605
     C/EXEC SQL                                                                             MD054605
     C+ fetch next from ACursor into :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   Endif                                                              MD054605
     C                   If        SQLCODE = 100                                            MD054605
     C                   SETON                                        82                    MD054605
     C                   ELSE                                                               MD054605
     C                   SETOFF                                       82                    MD054605
     C                   ENDIF                                                              MD054605
     C                   ENDDO
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
     C   42
     CAN 70              EXFMT     #SFLCTL
     C  N42
     CAN 70              EXFMT     #SFLCTL2
      * Enquiry mode
     C   42
     CANN70              EXFMT     #SFLCTE
     C  N42
     CANN70              EXFMT     #SFLCTE2
      *
      * Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      *
      * Test cursor
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
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
     C     WZSVAL        CASNE     #2SVAL        FBRQRL
     C     WZMMOD        CASNE     #2MMOD        FBRQRL
     C   42WZDESC        CASNE     #2DESC        FBRQRL
     C  N42WZVA48        CASNE     #2VA48        FBRQRL
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
      *                                                                                     MD054605
      *CASE:     CTL.*CMD key is *Go to 'Add' mode                                          MD054605
     C     *IN09         IFEQ      '1'                                          *IF         MD054605
     C** ESTABLISH LOOP FOR CALLING SUITE OF PROGRAMS                                       MD054605
     C*                                                                                     MD054605
     C                   MOVE      'Y'           CONTLP            1                        MD054605
     C                   MOVE      '1'           PGMCAL            1                        MD054605
     C                   MOVE      'I'           WUJTST            1                        MD054605
     C*                                                                                     MD054605
     C     CONTLP        DOUEQ     'N'                                                      MD054605
     C*                                                                                     MD054605
     C** CALL FIRST PROGRAM IN SUITE                                                        MD054605
     C*                                                                                     MD054605
     C*    PGMCAL        IFEQ      '1'                                                      MD054605
     C                   CALL      'SD009501'                           90      System ValueMD054605
     C                   PARM      *BLANK        W0RTN             7                        MD054605
     C                   PARM      *BLANKS       WQ0004           20            System ValueMD054605
     C                   PARM      'I'           WQ0005            1            Action Code MD054605
      *                                                                                     MD054605
     C     *IN90         IFEQ      '1'                                                      MD054605
      * Call to program ended in error.                                                     MD054605
     C                   MOVEL     'Y2U0021'     W0RTN             7                        MD054605
     C                   END                                                                MD054605
      *                                                                                     MD054605
     C** HANDLE F3 PROCESSFING FOR LOOP                                                     MD054605
     C*                                                                                     MD054605
     C     W0RTN         IFEQ      'Y2U9999'                                                MD054605
     C                   EXSR      ZYEXPG                                                   MD054605
     C                   END                                                                MD054605
     C*                                                                                     MD054605
     C                   MOVE      '2'           PGMCAL            1                        MD054605
     C                   MOVE      'N'           CONTLP                                     MD054605
     C** CALL SECOND PROGRAM IN SUITE                                                       MD054605
     C*                                                                                     MD054605
     C     PGMCAL        IFEQ      '2'                                                      MD054605
     C*                                                                                     MD054605
      * Edit Report Components - Report Components  *                                       MD054605
     C*                  MOVEL     *BLANK        PBRC                                       MD054605
     C*                  MOVEL     WURNAM        PBRNAM                         Report name MD054605
      *                                                                                     MD054605
     C                   CALL      'SD009502'                           90      System ValueMD054605
     C                   PARM      *BLANK        W0RTN             7                        MD054605
     C                   PARM                    WQ0004           20            System ValueMD054605
     C                   PARM      'I'           WQ0005                         Action Code MD054605
      *                                                                                     MD054605
     C     *IN90         IFEQ      '1'                                                      MD054605
      * Call to program ended in error.                                                     MD054605
     C                   MOVEL     'Y2U0021'     W0RTN             7                        MD054605
     C                   END                                                                MD054605
      *                                                                                     MD054605
      * Error detected ?                                                                    MD054605
     C     W0RTN         IFEQ      '         '                                              MD054605
     C                   MOVE      '1'           PGMCAL                                     MD054605
     C                   MOVE      'A'           WUJTST                                     MD054605
     C                   ELSE                                                               MD054605
     C     W0RTN         IFEQ      *BLANK                                                   MD054605
     C                   MOVE      '3'           PGMCAL                                     MD054605
     C                   END                                                                MD054605
     C                   END                                                                MD054605
     C                   END                                                                MD054605
     C** END OF LOOP FOR CALLING SUITE OF PROGRAMS                                          MD054605
     C*                                                                                     MD054605
     C                   END                                                                MD054605
     C                   END                                                                MD054605
      *                                                                                     MD054605
      * USER: Process command keys
      * If F11 is pressed, set on/off display description indicator.
     C     *IN11         IFEQ      '1'                                          *IF
      *
     C     *IN42         IFEQ      '1'
     C                   SETOFF                                       42
     C                   ELSE
     C                   SETON                                        42
      *
     C                   END
      *
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
     C                   END                                                    *FI
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Maintenance mode
     C   42
     CAN 70              READC     #SFLRCD                                92    *
     C  N42
     CAN 70              READC     #SFLRCD2                               92    *
      * Enquiry mode
     C   42
     CANN70              READC     #SFLRCE                                92    *
     C  N42
     CANN70              READC     #SFLRCE2                               92    *
     C     *IN92         DOWEQ     '0'
      *
      * Process subfile record
     C                   EXSR      DCPRSR
      * Maintenance mode
     C   42
     CAN 70              UPDATE    #SFLRCD
     C  N42
     CAN 70              UPDATE    #SFLRCD2
     C   42
     CAN 70              READC     #SFLRCD                                92    *
     C  N42
     CAN 70              READC     #SFLRCD2                               92    *
      * Enquiry mode
     C   42
     CANN70              UPDATE    #SFLRCE
     C  N42
     CANN70              UPDATE    #SFLRCE2
     C   42
     CANN70              READC     #SFLRCE                                92    *
     C  N42
     CANN70              READC     #SFLRCE2                               92    *
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
      * System Value display - System Values  *
     C                   CALL      'SD009501'                           90      System Value di
      *
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #1SVAL        WQ0004           20            System Value
     C                   PARM      'E'           WQ0005            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      *
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD009501'    W0CLPG
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
      * Help processing                                                                       213557
     C     #1SEL         IFEQ      'H'                                          *IF
      *                                                                                       213557
      * System Value display - System Values  *                                               213557
     C                   MOVEA     PGM@(1)       CALPGM           10
     C                   CALL      CALPGM                               90      Display help
     C                   PARM      #3EMSG        WQ0006            7            Error message
     C                   PARM      ZAMSGF        WQ0007           10            Message file
     C                   PARM      '2'           WQ0008            1            Second level text
     C                   PARM      'SD009500'    WQ0009           10            Calling Pgm
      *
     C     *IN90         IFEQ      '1'
      *
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     CALPGM        W0CLPG
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
      * Amend processing
     C     #1SEL         IFEQ      'A'                                          *IF
      *
      * Initialise a shared variable for possible suppressed records
     C   42              MOVEL     #1SUPP        SUPRES            8
     C  N42              MOVEL     #3SUPP        SUPRES
      *
      * If the record is suppressed send a message to the user
     C     SUPRES        IFEQ      'SUPPRESS'
     C                   MOVEL     'USR4625'     ZAMSID
     C**********         MOVEL     'SDUSRMSG'    ZAMSGF                                      BUG7330
     C                   MOVEL     'GBSDUSRMSG'  ZAMSGF                                      BUG7330
     C                   MOVEL     #1SVAL        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      * Initialise a shared variable for possible System Set Up records
     C   42              MOVEL     #1SUPP        SYSSETUP         11
     C  N42              MOVEL     #3SUPP        SYSSETUP
      *
      * If the record is SYSTEMSETUP and the System Set Up flag is ON, send a message
     C     WSETUP        IFNE      'N'
     C     SYSSETUP      ANDEQ     'SYSTEMSETUP'
     C                   MOVEL     'N'           ALWAMEND          1
     C                   MOVEL     'USR4629'     ZAMSID
     C**********         MOVEL     'SDUSRMSG'    ZAMSGF                                      BUG7330
     C                   MOVEL     'GBSDUSRMSG'  ZAMSGF                                      BUG7330
     C                   MOVEL     #1SVAL        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVEL     'Y'           ALWAMEND
     C                   ENDIF
      *
      * System Value Edit - System Values  *
     C     SUPRES        IFNE      'SUPPRESS'
     C     ALWAMEND      ANDEQ     'Y'
     C                   CALL      'SD009501'                           90      System Value Ed
      *
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #1SVAL        WQ0004           20            System Value
     C                   PARM      'A'           WQ0005            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      *
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD009501'    W0CLPG
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
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
      *
     C                   END                                                    *FI
      *
      * Delete processing                                                                   MD054605
     C     #1SEL         IFEQ      'D'                                          *IF         MD054605
      *                                                                                     MD054605
     C/EXEC SQL                                                                             MD054605
     C+ SELECT *                                                                            MD054605
     C+ into :SDSVAL :NullInds                                                              MD054605
     C+ from SDSVLJW1                                                                       MD054605
     C+ where GISVAL = :#1SVAL                                                              MD054605
     C/END-EXEC                                                                             MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   SETON                                        90                    MD054605
     C                   Else                                                               MD054605
     C                   SETOFF                                       90                    MD054605
     C                   ENDIF                                                              MD054605
                                                                                            MD054605
      * Delete is only allowed for Bespoke records                                          MD054605
      *                                                                                     MD054605
     C     GIMODE        IFNE      'B'                                                      MD054605
     C                   MOVEL     'USR7983'     ZAMSID                                     MD054605
     C                   MOVEL     'GBSDUSRMSG'  ZAMSGF                                     MD054605
     C                   MOVEL     #1SVAL        ZAMSDA                         Message dataMD054605
     C                   EXSR      ZASNMS                                                   MD054605
     C                   ELSE                                                               MD054605
      *                                                                                     MD054605
     C                   CALL      'SD009501'                           90      System ValueMD054605
      *                                                                                     MD054605
     C                   PARM      *BLANK        W0RTN             7                        MD054605
     C                   PARM      #1SVAL        WQ0004           20            System ValueMD054605
     C                   PARM      'D'           WQ0005            1            Action Code MD054605
      *                                                                                     MD054605
     C     *IN90         IFEQ      '1'                                                      MD054605
      *                                                                                     MD054605
      * Call to program ended in error                                                      MD054605
     C                   MOVEL     'Y2U0032'     W0RTN                                      MD054605
     C                   MOVEL     *BLANKS       W0CLPG           10                        MD054605
     C                   MOVEL     'SD009501'    W0CLPG                                     MD054605
      *                                                                                     MD054605
      * Send message '*Error occured on CALL...'                                            MD054605
     C                   MOVEL     'Y2U0032'     ZAMSID                                     MD054605
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                     MD054605
     C                   MOVEL     W0CLPG        ZAMSDA                         Message dataMD054605
     C                   EXSR      ZASNMS                                                   MD054605
     C                   END                                                                MD054605
     C                   ENDIF                                                              MD054605
     C                   ENDIF                                                              MD054605
      * Access Validation Reference                                                         MD054605
     C     #1SEL         IFEQ      'V'                                          *IF         MD054605
      *                                                                                     MD054605
     C/EXEC SQL                                                                             MD054605
     C+ SELECT *                                                                            MD054605
     C+ into :SDSVAL :NullInds                                                              MD054605
     C+ from SDSVLJW1                                                                       MD054605
     C+ where GISVAL = :#1SVAL                                                              MD054605
     C/END-EXEC                                                                             MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   SETON                                        90                    MD054605
     C                   Else                                                               MD054605
     C                   SETOFF                                       90                    MD054605
     C                   ENDIF                                                              MD054605
                                                                                            MD054605
      *                                                                                     MD054605
     C                   CALL      'SD009502'                           90      System ValueMD054605
      *                                                                                     MD054605
     C                   PARM      *BLANK        W0RTN             7                        MD054605
     C                   PARM      #1SVAL        WQ0004           20            System ValueMD054605
     C                   PARM      'E'           WQ0005            1            Action Code MD054605
      *                                                                                     MD054605
     C     *IN90         IFEQ      '1'                                                      MD054605
      *                                                                                     MD054605
      * Call to program ended in error                                                      MD054605
     C                   MOVEL     'Y2U0032'     W0RTN                                      MD054605
     C                   MOVEL     *BLANKS       W0CLPG           10                        MD054605
     C                   MOVEL     'SD009501'    W0CLPG                                     MD054605
      *                                                                                     MD054605
      * Send message '*Error occured on CALL...'                                            MD054605
     C                   MOVEL     'Y2U0032'     ZAMSID                                     MD054605
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                     MD054605
     C                   MOVEL     W0CLPG        ZAMSDA                         Message dataMD054605
     C                   EXSR      ZASNMS                                                   MD054605
     C                   ENDIF                                                              MD054605
      *                                                                                     MD054605
      * Error detected?                                                                     MD054605
     C     W0RTN         IFNE      *BLANK                                                   MD054605
     C                   SETON                                        98        *           MD054605
     C                   END                                                                MD054605
      *                                                                                     MD054605
     C                   END                                                    *FI         MD054605
      *                                                                                     MD054605
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
      * Move @SVALJ0 fields to subfile
      *================================================================
     C                   MOVEL     GISVAL        #1SVAL                         System Value
     C                   MOVEL     GIMMOD        #1MMOD                         Midas Module
     C                   MOVEL     GIDESC        #1DESC                         Description
     C   42              MOVEL     GISUPP        #1SUPP                         Suppress Update
     C  N42              MOVEL     GISUPP        #3SUPP                         Suppress Update
     C                   MOVEL     GIVAL         #1VA48                         System Value
     C                   MOVEL     GIEMSG        #3EMSG                         Error message
      *
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *
      * If Current Setting is displayed,
     C     *IN42         IFEQ      '0'
      * Determine if GIVAL has value after position 48, display '+'.
     C                   MOVE      GIVAL         WVA152          152
     C     WVA152        IFNE      *BLANK
     C                   MOVE      '+'           #1PLUS
     C                   ELSE
     C                   MOVE      ' '           #1PLUS
     C                   END
     C                   END
      *
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2SVAL                         System Value
     C                   MOVEL     *BLANK        #2MMOD                         Midas Module
     C                   MOVEL     *BLANK        #2DESC                         Description
     C                   MOVEL     *BLANK        #2VA48                         System Value
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
     C**********         MOVEL     ZADFMF        ZAMSGF                                      BUG7330
     C                   MOVEL     WUMSGF        ZAMSGF                                      BUG7330
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
     C                   If        MODE = 'B'                                               MD054605
     C/EXEC SQL                                                                             MD054605
     C+ close UCursor                                                                       MD054605
     C/END-EXEC                                                                             MD054605
     C                   Else                                                               MD054605
     C/EXEC SQL                                                                             MD054605
     C+ close ACursor                                                                       MD054605
     C/END-EXEC                                                                             MD054605
     C                   Endif                                                              MD054605
                                                                                            MD054605
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
     C     MODE          OREQ      'B'                                                      MD054605
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
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
      *
      * Update screen time
     C                   TIME                    ##TME             6 0
      *
      **Obtain*default*message*file*                                                        AR796650
     C******DTAARA       DEFINE    Y2MGFLA       ZADFMF           10                        AR796650
     C**********         IN        ZADFMF                                                   AR796650
      *
      * Define work field System Value
     C                   MOVEL     *BLANK        WUSVAL            4
      *
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      *
      * Define program work fields
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      *
     C     *LIKE         DEFINE    GISVAL        LSVAL                          Last system valu
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
     C                   OPEN      SD009500DF
     C**********         OPEN      SDSVALJ0                                                 MD054605
     C                   MOVEL     'N'           W0PMT             1
     C                   Z-ADD     14            ##SFPG            3 0          SFLPAG
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
     C                   MOVEL     *BLANK        W0GRP             1
      *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
      *
      * Set-up Dsp. file footer - Standard Functions  *
     C**********         MOVEL     'SDUSRMSG'    WUMSGF           10                         BUG7330
     C                   MOVE      *BLANKS       WUMTXT           80
      *
      * Setup footer text:
      * A=Amend  E=Enquire  F3=Main Menu  F5=Refresh F11=Desc/Current Setting
     C   70              MOVEL     'USR4613'     WUMSID            7            Message Identifier
      * E=Enquire  F3=Main Menu  F5=Refresh F11=Desc/Current Setting
     C  N70              MOVEL     'USR4624'     WUMSID            7            Message Identifier
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
      * Set on indicator for display description.
     C                   SETON                                        42
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
(c) Finastra International Limited 2003
**CTDATA PGM@
SDC009520

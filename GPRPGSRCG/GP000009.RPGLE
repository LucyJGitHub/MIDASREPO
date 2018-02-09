     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Menu items maintenance/enquiry subfile')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP000009 - Midas GP Global Menu Items Program                *
      *                                                               *
      *  Function:  New sub-file program to allow users to select     *
      *             on the Menu Items file.                           *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG2287            Date 28Apr04               *
      *                 CGP001  *CREATE    Date 01Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG2287- Show consolidated global view (Recompile)           *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
     FGP000009DFCF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      ** DSP: Midas GP Display Menu Items
      *
     FGPMTXTL3  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
     FGPMENUL0  IF   E           K DISK
      *****************************************************************
      * ID           Function of Indicators                           *
      *****************************************************************
      * 03           Exit                                             *
      * 05           Reset                                            *
      * 09           Go to 'Add' mode                                 *
      * 25           SFLEND                                           *
      * 27           Next Page                                        *
      * 29           Valid Command Key                                *
      * 32           GPMENUPD No Record Found                         *
      * 34           Invalid Selection                                *
      * 40           Maintainance Mode                                *
      * 41           Enquiry Mode                                     *
      * 45           Readc Subfile Record - No Record Found           *
      * 80           Clear Subfile                                    *
      * 81           Displays subfile                                 *
      * 82           End of subfile                                   *
      * 84           Subfile next change                              *
      * 86           Enable PUTOVR                                    *
      * 90           Program Ended in Error                           *
      * 94           Clear Set Cursor                                 *
      * 98           Force Input Format                               *
      * 99           Global Error Flag                                *
      *****************************************************************
      ** Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      ** Program data structure
     D JBDTTM          DS
      ** Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
      *
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I :  Display file mode
     D  P1DFMD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'value for field not valid'
      * *SFLSEL
     D  ZA0001                 1      1
      * Message data for 'value for field not valid'
      * *SFLSEL
     D  ZA0002                 1      1
      * Message data for 'value for field not valid'
      * *SFLSEL
     D  ZA0003                 1      1
 
     D @RUN            S              1
     D                 DS
     D  SVAL1                  1    200
     D  SVAL02                 1      2
      * Data structure to hold output parameter for GPAOSVALR0
      *
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      * Local Data Area for Database Error Details
      *
     I*
     I* Description     : Copyright notice for inclusion in all programs
     I*
     ISFMENUD0
      ** Rename field
     I              MIAAC10                     MIAA10
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1DFMD        PARM                    WP0001            1
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      ** Initialise & load subfile page
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      ** Display screen until reload requested
     C     W0RSF         DOWEQ     'N'
      ** Display screen
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
      * Initialise and load subfile page
      *================================================================
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081
      * USER: Initialize subfile control
     C*Display Menu Items Initialise Subf Control
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    MISNAM
      * Setup key
     C                   MOVEL     #2SNAM        MISNAM
     C     KPOS          SETLL     GPMTXTD0
     C                   MOVE      *OFF          *IN82
     C                   MOVE      *BLANK        WZONE
     C     *IN82         DOWEQ     *OFF
     C     WZONE         ANDNE     PRFX
     C     WZONE         ANDNE     '*G'
     C                   READ      GPMTXTD0                               82
     C     2             SUBST     MIINDX:1      WZONE             2
     C                   ENDDO
     C     MIINDX        CHAIN     SFMENUD0                           32
      * Save previous selector values
     C     *LIKE         DEFINE    #2SNAM        WZSNAM
     C                   MOVEL     #2SNAM        WZSNAM
     C     *LIKE         DEFINE    #2MODC        WZMODC
     C                   MOVEL     #2MODC        WZMODC
     C     *LIKE         DEFINE    #2INAR        WZINAR
     C                   MOVEL     #2INAR        WZINAR
     C     *LIKE         DEFINE    #2SECL        WZSECL
     C                   MOVEL     #2SECL        WZSECL
      * Translate search mask for Display Module
     C                   MOVEL     'QSYST'       WQB12X           10
     C                   MOVE      'RNTBL'       WQB12X
     C     *LIKE         DEFINE    #2MODC        WQMODC
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      2             WQA7N             5 0
     C                   PARM      #2MODC        WQMODC
     C                   PARM                    WQB12X
     C                   PARM      'QSYS'        WQC12X           10
      * Translate search mask for Item Narrative
     C                   MOVEL     'QSYST'       WQB13X           10
     C                   MOVE      'RNTBL'       WQB13X
     C     *LIKE         DEFINE    #2INAR        WQINAR
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      45            WQA8N             5 0
     C                   PARM      #2INAR        WQINAR
     C                   PARM                    WQB13X
     C                   PARM      'QSYS'        WQC13X           10
      * Translate search mask for Security Level
     C                   MOVEL     'QSYST'       WQB14X           10
     C                   MOVE      'RNTBL'       WQB14X
     C     *LIKE         DEFINE    #2SECL        WQSECL
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      4             WQA9N             5 0
     C                   PARM      #2SECL        WQSECL
     C                   PARM                    WQB14X
     C                   PARM      'QSYS'        WQC14X           10
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
     C  N82              READP     GPMTXTD0                               90
     C                   MOVE      *BLANK        WZONE
     C     *IN82         DOWEQ     *OFF
     C     WZONE         ANDNE     PRFX
     C     WZONE         ANDNE     '*G'
     C                   READ      GPMTXTD0                               82
     C     2             SUBST     MIINDX:1      WZONE
     C                   ENDDO
     C     MIINDX        CHAIN     SFMENUD0                           32
     C                   END
     C                   MOVEL     MISECL        SECL1             4
      *
      * Setof record error indicators
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(34)
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
     C     *IN82         DOWEQ     '0'
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
      * Check selection field - if fail, read next record
     C     #2MODC        IFNE      *BLANK
      *
      * Ensure no blanks at beginning of search field
     C                   Z-ADD     0             F1                2 0
     C                   MOVE      WQMODC        F5                2
     C     ' '           CHECK     F5:1          F1                       30
     C                   SUBST     WQMODC:F1     WQMOD1            2
     C                   MOVEL(P)  WQMOD1        WQMODC
      * Scan for Display Module search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    MIMODC
      * Length
     C                   PARM      2             WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    WQMODC
      * Length
     C                   PARM      2             WQC3N             3 0
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
      * Check selection field - if fail, read next record
     C     #2INAR        IFNE      *BLANK
      *
      * Ensure no blanks at beginning of search field
     C                   Z-ADD     0             F1                2 0
     C                   MOVE      WQINAR        F3               45
     C     ' '           CHECK     F3:1          F1                       30
     C                   SUBST     WQINAR:F1     WQNAR1           45
     C                   MOVEL(P)  WQNAR1        WQINAR
      * Scan for Item Narrative search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    MIINAR
      * Length
     C                   PARM      45            WQA4N             3 0
      * Start
     C                   PARM      1             WQB4N             3 0
      * Mask
     C                   PARM                    WQINAR
      * Length
     C                   PARM      45            WQC4N             3 0
      * Translate
     C                   PARM      '1'           WQD1              1
      * Trim
     C                   PARM      '1'           WQE1              1
      * Wild
     C                   PARM      '?'           WQF1              1
      * Result
     C                   PARM                    WQG4N             3 0
     C     WQG4N         CABLT     1             BB020
     C                   END
      * Check selection field - if fail, read next record
     C     #2SECL        IFNE      *BLANK
      *
      * Ensure no blanks at beginning of search field
     C                   Z-ADD     0             F1                2 0
     C                   MOVE      WQSECL        F2                4
     C     ' '           CHECK     F2:1          F1                       30
     C                   SUBST     WQSECL:F1     WQSEC1            4
     C                   MOVEL(P)  WQSEC1        WQSECL
      * Scan for Security Level search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    SECL1
      * Length
     C                   PARM      4             WQA0N             3 0
      * Start
     C                   PARM      1             WQB0N             3 0
      * Mask
     C                   PARM                    WQSECL
      * Length
     C                   PARM      4             WQC0N             3 0
      * Translate
     C                   PARM      '1'           WQD1              1
      * Trim
     C                   PARM      '1'           WQE1              1
      * Wild
     C                   PARM      '?'           WQF1              1
      * Result
     C                   PARM                    WQG0N             3 0
     C     WQG0N         CABLT     1             BB020
     C                   END
      * Load SFL fields
     C                   EXSR      MBFL#1
      * Allow for possible *Set Cursor processing
     C                   ADD       1             ##RR
     C                   EXSR      MC#1FN
     C                   SUB       1             ##RR
     C                   MOVEL     'Y'           W0RSL             1
      * Allow for possible *Set Cursor processing
     C                   ADD       1             ##RR
     C*Display Menu Items Initialise Subfile Rcd
     C                   SUB       1             ##RR
      * DBF record not selected
     C     W0RSL         CABNE     'Y'           BB020
      * Output to subfile
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99
     C                   WRITE     #SFLRCD
     C     BB020         TAG
      * Increment scan check count
     C                   ADD       1             ##RRRD
     C                   MOVE      *OFF          *IN82
     C                   MOVE      *BLANK        WZONE
     C     *IN82         DOWEQ     *OFF
     C     WZONE         ANDNE     PRFX
     C     WZONE         ANDNE     '*G'
     C                   READ      GPMTXTD0                               82
     C     2             SUBST     MIINDX:1      WZONE
     C                   ENDDO
     C     MIINDX        CHAIN     SFMENUD0                           32
     C                   MOVEL     MISECL        SECL1
     C                   END
      *................................................................
     C     BB900         TAG
      *................................................................
      * If no DBF records found, display error message
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      * Send message '*No data to display'
     C                   MOVEL     'GPM0029'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
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
     C                   MOVEL     'GPM0030'     ZAMSID
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
     C                   SETOFF                                       94
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
     C                   MOVEL     'Y'           ZAFSMS            1      99
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
      * CALC: Subfile control function fields
     C*Display Menu Items Calculate Control Fields
      * Change of position specified
     C     WZSNAM        CASNE     #2SNAM        FBRQRL
     C     WZINAR        CASNE     #2INAR        FBRQRL
     C     WZMODC        CASNE     #2MODC        FBRQRL
     C     WZSECL        CASNE     #2SECL        FBRQRL
     C                   END
     C*Display Menu Items Process Subfile Control
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records
     C                   EXSR      DBPRSF
     C                   END
      *
      ** Goes to the Main Menu when F3 is done in GP000010
      *
     C     PKEY          IFEQ      '03'
     C                   EXSR      ZXEXPG
     C                   ENDIF
      *
     C*Display Menu Items Final Processing
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * USER: Process command keys
     C*Display Menu Items Process Command Keys
      * CASE: PAR.Display file mode is Maintenance mode
     C     P1DFMD        IFEQ      'M'
      * CASE: CTL.*CMD key is *Go to 'Add' mode
     C     *IN09         IFEQ      '1'
      * Edit Menu Item *
     C                   MOVEL     *BLANK        PASNAM           20
     C                   MOVEL     *BLANK        PAINDX           10
      *
     C                   CALL      'GP000010'                           90
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PASNAM
     C                   PARM                    PAINDX
     C                   PARM      'I'           WQ0001            1
     C                   PARM      *BLANKS       PKEY              2
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'GP000010'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'GPM0031'     ZAMSID
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99
     C                   END
     C                   MOVEL     'Y'           W0RSF
      *
      ** Goes to the Main Menu when F3 is done in GP000010
      *
     C     PKEY          IFEQ      '03'
     C                   EXSR      ZXEXPG
     C                   ENDIF
      *
     C                   END
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: CTL.*CMD key is *Go to 'Add' mode
     C     *IN09         IFEQ      '1'
      * Send message 'Function key not allowed'
     C                   MOVEL     'GPM0001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
      *
     C                   GOTO      DAEXIT
     C                   END
     C                   END
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
     C                   READC     #SFLRCD                                45
     C     *IN45         DOWEQ     '0'
      * Process subfile record
     C     #1SEL         IFNE      ' '
     C     2             SUBST     #1INDX:1      WPRFX             2
     C     #1SEL         IFEQ      'A'
     C     WPRFX         ANDEQ     '*G'
     C     #1SEL         OREQ      'D'
     C     WPRFX         ANDEQ     '*G'
     C                   MOVEL     'GPM0002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
     C                   EXSR      DCPRSR
     C                   UPDATE    #SFLRCD
     C                   ENDIF
     C                   ENDIF
     C                   READC     #SFLRCD                                45
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Setof error indicators and SFLNXTCHG
     C                   MOVEA     WKIND0        *IN(34)
     C                   SETOFF                                       98
     C                   EXSR      MC#1FN
      * USER: Process subfile record (Pre-confirm)
      * User Requests E - Enquire
      * CASE: RCD.*SFLSEL is *Enquire
     C     #1SEL         IFEQ      'E'
      * Display Menu Items - Menu Group, Item Code *
     C                   MOVEL     #1SNAM        PBSNAM           20
     C                   MOVEL     #1INDX        PBINDX           10
     C                   MOVEL     #1SEL         PBSEL             1
      *
     C                   CALL      'GP000010'                           90
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PBSNAM
     C                   PARM                    PBINDX
     C                   PARM                    PBSEL
     C                   PARM      *BLANKS       PKEY
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'GP000010'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'GPM0031'     ZAMSID
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98
     C                   END
     C                   MOVEL     'Y'           W0RSF
     C                   END
      * User Requests File Maintenance
      * CASE: PAR.Display file mode is Maintenance mode
     C     P1DFMD        IFEQ      'M'
     C     #1SEL         ANDNE     'E'
      * CASE: RCD.*SFLSEL is *Amend
     C     #1SEL         IFEQ      'A'
      * Edit Menu Items - Menu Group *
     C                   MOVEL     #1SNAM        PASNAM
     C                   MOVEL     #1INDX        PAINDX
     C                   MOVEL     #1SEL         PASEL             1
      *
     C                   CALL      'GP000010'                           90
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PASNAM
     C                   PARM                    PAINDX
     C                   PARM                    PASEL
     C                   PARM      *BLANKS       PKEY
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'GP000010'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'GPM0031'     ZAMSID
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98
     C                   END
     C                   ELSE
      * CASE: RCD.*SFLSEL is *Delete
     C     #1SEL         IFEQ      'D'
      * Edit Menu Item *
     C                   MOVEL     #1SNAM        PASNAM
     C                   MOVEL     #1INDX        PAINDX
     C                   MOVEL     #1SEL         PASEL             1
      *
     C                   CALL      'GP000010'                           90
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PASNAM
     C                   PARM                    PAINDX
     C                   PARM                    PASEL
     C                   PARM      *BLANKS       PKEY
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'GP000010'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'GPM0031'     ZAMSID
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98
     C                   END
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1SEL         ZA0001
      * Send message 'value for field not valid'
     C                   MOVEL     'GPM0003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834
      *
     C                   END
     C                   END
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.*SFLSEL is *Delete
     C     #1SEL         IFEQ      'D'
      * Setup message data for message
     C                   MOVEL     #1SEL         ZA0002
      * Send message 'value for field not valid'
     C                   MOVEL     'GPM0003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834
      *
     C                   GOTO      DCEXIT
     C                   ELSE
      * CASE: RCD.*SFLSEL is *Amend
     C     #1SEL         IFEQ      'A'
      * Setup message data for message
     C                   MOVEL     #1SEL         ZA0003
      * Send message 'value for field not valid'
     C                   MOVEL     'GPM0003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834
      *
     C                   GOTO      DCEXIT
     C                   END
     C                   END
     C                   END
     C*Display Menu Items Process Subfile Record
      * Fast Exit Processing
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'
     C                   MOVEL     W0RTN         P0RTN
     C                   EXSR      ZYEXPG
     C                   END
     C     *IN98         IFEQ      '1'
      * SFLRCD invalid
     C  N99              Z-ADD     ##RR          ##SFRC               99
      * SFLNXTCHG
     C                   SETON                                        84
     C                   ELSE
      * SFLRCD valid
      * SFLNXTCHG
     C                   SETOFF                                       84
     C                   MOVEL     *BLANK        #1SEL
     C                   END
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
      * Move SFMENUD0 fields to subfile
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     MIINDX        #1INDX
     C                   MOVEL     MISNAM        #1SNAM
     C                   MOVEL     MIINAR        #1INAR
     C                   MOVEL     MIMODC        #1MODC
     C                   MOVEL     MISECL        #1SECL
     C                   MOVEL     *BLANK        #1SEL
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MC#1FN        BEGSR
      *================================================================
      * CALC: Subfile record function fields
      *================================================================
      * CALC: Subfile record function fields
     C*Display Menu Items Calculate Record Funcs
      *================================================================
     CSR   MCEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2SNAM
     C                   MOVEL     *BLANK        #2MODC
     C                   MOVEL     *BLANK        #2INAR
     C                   MOVEL     *BLANK        #2SECL
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   UASUBR        BEGSR
      *================================================================
      * Set Up Hdr & Ftr
      *================================================================
      * CASE: PAR.Display file mode is Enquiry mode
     C     P1DFMD        IFEQ      'E'
     C                   MOVE      *ON           *IN41
     C                   MOVE      *OFF          *IN40
     C                   ELSE
     C     P1DFMD        IFEQ      'M'
     C                   MOVE      *ON           *IN40
     C                   MOVE      *OFF          *IN41
     C                   ENDIF
     C                   ENDIF
      * Setup message data for message
      * Set Screen Hdr to Message - Standard Functions  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'GPUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C     P1DFMD        IFEQ      'E'
     C* Setup footer text:
     C* E=Enquire   F3=Main Menu   F5=Refresh
     C                   MOVEL     'GPM0004'     WUMSID            7
     C                   CALL      'SDRTVTXT'                           90
     C     WUMSID        PARM      WUMSID        KE0286            7
     C     WUMSGF        PARM      WUMSGF        KE0287           10
     C     WUMTXT        PARM      WUMTXT        KE0288           80
     C                   MOVEL     WUMTXT        ##CTX1
     C                   END
     C     P1DFMD        IFEQ      'M'
     C* Setup footer text:
     C* A=Amend  D=Delete  E=Enquire  F3=Main Menu  F5=Refresh  F9=Go to 'Add' Mode
     C                   MOVEL     'GPM0005'     WUMSID            7
     C                   CALL      'SDRTVTXT'                           90
     C     WUMSID        PARM      WUMSID        KE0286            7
     C     WUMSGF        PARM      WUMSGF        KE0287           10
     C     WUMTXT        PARM      WUMTXT        KE0288           80
     C                   MOVEL     WUMTXT        ##CTX1
     C                   END
      *
      *====================================================
     CSR   UAEXIT        ENDSR
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
     C                   MOVEL     'GPUSRMSG'    ZAMSGF
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
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
     C     @#RWCL        DIV       256           ZHCSRW            5 0
     C                   MVR                     ZHCSCL            5 0
      *
      * Save cursor position for redisplay
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0
      *
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10
     C                   PARM      *BLANK        YYHPFL           10
     C                   PARM      *BLANK        YYHPLB           10
     C                   PARM                    W0RTN             7
     C                   PARM      '*START'      YYHLVN           10
     C                   PARM      '*NORMAL'     YYUSOP           10
     C                   PARM      ZHCSRW        YYRW              5 0
     C                   PARM      ZHCSCL        YYCL              5 0
     C                   PARM      *ZERO         YYLGCT            5 0
     C                   PARM      *BLANK        YYLGVN           10
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel & exit program
      *================================================================
      * USER: Exit program processing
     C*Display Menu Items Exit Program Processing
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
     C                   MOVEL     'Y'           W0ICL             1
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field User Report Title
     C                   MOVEL     *BLANK        WUURPT           53
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Define *Synon program work fields
     C                   MOVEL     *BLANKS       W0CFL            10
     C                   Z-ADD     *ZEROS        W0CRW             5 0
     C                   Z-ADD     *ZEROS        W0CCL             5 0
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10
     C                   MOVE      @1FLB         ZZFLB            10
     C                   MOVE      @1FMB         ZZFMB            10
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21
      * Open files
     C                   OPEN      GP000009DF
     C                   OPEN      GPMTXTL3
     C                   MOVEL     'N'           W0PMT             1
     C                   Z-ADD     14            ##SFPG            3 0
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
      *
      ** Get Global system prefix
      ** Check system value for global system prefix
      *
     C                   EVAL      SVALK1 = 'GlobalSystemPrefix'
     C                   CALL      'GPAOSVALR0'
     C                   PARM                    RTNCDE            7
     C                   PARM                    SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
      *
      ** If the system value is not found then issue a database error
      *
     C                   IF        RTNCDE <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'GPSVALPD'
     C                   EVAL      DBase = 01
     C                   EVAL      DBKey = SVALK1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     SVAL02        PRFX              2
     C                   ENDIF
      *
      * USER: Initialize program
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB
     C                   MOVE      SUC           WUSUC
     C                   MOVE      DFF           WUDFF
     C                   MOVE      MBIN          WUMBIN
      * Copyright Statement 1988 - Standard Functions  * copyright
      * Set Up Hdr & Ftr
     C                   EXSR      UASUBR
     C                   Z-ADD     99999         W0SLM
     C*Display Menu Item Initialise Program C-Spec
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *

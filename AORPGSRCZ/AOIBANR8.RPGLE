     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO IBAN calculate number of accounts')
      *****************************************************************
      *                                                               *
      *  Midas - Access Object                                        *
      *                                                               *
      *  AOIBANR8M - IBAN Calculate Number of Account                 *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004  *CREATE    Date 20Jul99               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CFT004 - International Bank Account Number                   *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      * GL Account Master Detail ( Branch, Customer, Currency)
     FACCNTL7   IF   E           K DISK
     F                                     RENAME(ACCNTABF:@ACCL7)
      * GL Account Master Detail ( Branch, Customer)
     FACCNTL8   IF   E           K DISK
     F                                     RENAME(ACCNTABF:@ACCL8)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  30  - LOOKUP                                                 *
      *  70  - READ Indicator (ACCNTL7/ACCNTL8)                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D                 DS
      * Customer Number ( Character/ Numeric)
     D  W1CNUM                 1      6
     D**W2CNUM**               1      6  0                                                    CSD027
     D  W2CNUM                 1      6A                                                      CSD027
     D                 DS
      * Sequence Number ( Output Parameter)
     D  WSEQUEN                1      3
     D  WFDA                   1      1
     D  WMDA                   2      2
     D  WLDA                   3      3
      *
     D                 DS
      * New Sequence Number
     D  WNEWSQN                1      6  0
     D  WNEWFD                 1      2  0
     D  WNEWMD                 3      4  0
     D  WNEWLD                 5      6  0
      *
     D  ALPHA          S              1    DIM(36) CTDATA PERRCD(36)
      * Alphanumeric
      *
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      /SPACE 3
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  CONVERT   - Split Sequence Number and convert to Numeric     *
      *  INCREMENT - Increment Last Digit and cope with overflows     *
      *  INIT      - Initialisation Routine                           *
      *  SEARCH    - Search for 'spaces' within the Character Sequence*
      *                                                               *
      *****************************************************************
      *MAIN
      *
     C                   EXSR      INIT
      *
      * Check wich File to use
     C     ICCY          IFNE      *BLANKS
     C                   MOVE      'Y'           WCCYFG            1
     C     KACC6         SETGT     ACCNTL7
     C     KACC6         READPE    ACCNTL7                                70
     C                   ELSE
     C                   MOVE      'N'           WCCYFG
     C     KACC7         SETGT     ACCNTL8
     C     KACC7         READPE    ACCNTL8                                70
     C                   ENDIF
      *
      * No previous Account with Combination
     C     *IN70         IFEQ      *ON
     C                   MOVE      'AAB'         OSEQN
     C                   RETURN
     C                   ENDIF
      *
      * Split Sequence Number and convert to Numeric
     C                   EXSR      CONVERT
      *
      * Increment Last Digit and cope with overflows
     C                   EXSR      INCREMENT
      *
      * Initiate Search if reached limit
     C     WFD           IFGT      36
     C     WCCYFG        ANDNE     'Y'
     C     WMD           ORGT      36
     C     WCCYFG        ANDEQ     'Y'
     C                   EXSR      SEARCH
     C                   ENDIF
      *
      * If valid number, convert back to alpha and set the Sequence Nbr
     C     WLD           IFLE      36
     C     WMD           ANDLE     36
     C     WFD           ANDLE     36
      *
      *
     C                   MOVE      ALPHA(WFD)    WFDA
      *
     C                   MOVE      ALPHA(WMD)    WMDA
      *
     C                   MOVE      ALPHA(WLD)    WLDA
      *
     C                   ENDIF
      *
     C                   MOVE      WSEQUEN       OSEQN
      *
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *
      *    SEARCH - Search for any 'spaces' within the char. sequence
      *
      *    CALLED BY: MAIN      - Main Processing
      *
      *    CALLS    : CONVERT   - Split Sequ. Nbr and convert to Numer.
      *             : INCREMENT - Incr. Last Digit and cope with Ovfws
      *
      ********************************************************************
      *
     C     SEARCH        BEGSR
      *
      * Read intitial record
     C     WCCYFG        IFEQ      'Y'
     C     KACC6         SETLL     ACCNTL7
     C     KACC6         READE     ACCNTL7                                70
     C                   ELSE
     C     KACC7         SETLL     ACCNTL8
     C     KACC7         READE     ACCNTL8                                70
     C                   ENDIF
      *
      * Split Sequence Number and convert to Numeric
     C                   EXSR      CONVERT
      *
      * Set up New Sequence Number
     C                   Z-ADD     WFD           WNEWFD
     C                   Z-ADD     WMD           WNEWMD
     C                   Z-ADD     WLD           WNEWLD
     C                   Z-ADD     0             WDIFFR            6 0
      *
      * Reach each record to find a gap
     C     *IN70         DOWEQ     *OFF
     C     WDIFFR        ANDLE     1
      *
      *   Set up Old Sequence Number
     C                   Z-ADD     WNEWSQN       WOLDSQN           6 0
      *
      *   Read Record
     C     WCCYFG        IFEQ      'Y'
     C     KACC6         READE     ACCNTL7                                70
     C                   ELSE
     C     KACC7         READE     ACCNTL8                                70
     C                   ENDIF
      *
      *   Split Sequence Number and convert to Numeric
     C                   EXSR      CONVERT
      *
      *   Set up New Sequence Number
     C                   Z-ADD     WFD           WNEWFD
     C                   Z-ADD     WMD           WNEWMD
     C                   Z-ADD     WLD           WNEWLD
      *
      *   Compare Old and New Sequence Numbers
     C     WNEWSQN       SUB       WOLDSQN       WDIFFR
      *
     C                   ENDDO
      *
      * Increment Last Digit and cope with overflows
     C     WDIFFR        IFGT      1
     C                   EXSR      INCREMENT
     C                   ELSE
     C                   MOVE      '*NOMORE'     P@RTCD
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *
      *    CONVERT- Split Sequence Number and convert to numeric
      *
      *    CALLED BY: MAIN      - Main Processing
      *             : SEARCH    - Search Gap
      *
      *    CALLS    :
      *
      ********************************************************************
      *
     C     CONVERT       BEGSR
      *
      * Split Sequence Number acquired from file into consistuent parts
      * WSEQUEN = WFDA(1A) + WMDA(1A) + WLDA(1A)
     C                   MOVE      IBSEQN        WSEQUEN
      *
      * Convert Alpha to Numeric
     C                   Z-ADD     1             WFD               2 0
     C     WFDA          LOOKUP    ALPHA(WFD)                             30
      *
     C                   Z-ADD     1             WMD               2 0
     C     WMDA          LOOKUP    ALPHA(WMD)                             30
      *
     C                   Z-ADD     1             WLD               2 0
     C     WLDA          LOOKUP    ALPHA(WLD)                             30
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *
      *    INCREMENT - Incr. Last Digit Number and cope with overflows
      *
      *    CALLED BY: MAIN      - Main Processing
      *             : SEARCH    - Search Gap
      *
      *    CALLS    :
      *
      ********************************************************************
      *
     C     INCREMENT     BEGSR
      *
      * Increment Last Digit
     C                   ADD       1             WLD
      *
      * Cope with overflows
     C     WLD           IFGT      36
     C                   ADD       1             WMD
     C                   SUB       36            WLD                      30
     C                   ENDIF
      *
     C     WCCYFG        IFNE      'Y'
     C     WMD           IFGT      36
     C                   ADD       1             WFD
     C                   SUB       36            WMD                      30
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     1             WFD
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *
      *    INIT  - Initialisation Sub-routine.
      *
      *    CALLED BY: MAIN      - Main Processing
      *
      *    CALLS    :
      *
      ********************************************************************
      *
     C     INIT          BEGSR
      *
     C                   MOVE      *BLANKS       P@RTCD
     C                   MOVE      ICNUM         W1CNUM
      *
      * Input and Output parameter
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD            7            O:Return code
     C                   PARM                    IBRCA             3            I:Branch Code
     C                   PARM                    ICNUM             6            I:Customer Nb
     C                   PARM                    ICCY              3            I:Currency
     C                   PARM                    OSEQN             3            O:Sequence Nb
      *
      * KEY LISTS
      *
      * Key list to read ACCNTL7
     C     KACC6         KLIST
     C                   KFLD                    IBRCA
     C                   KFLD                    W2CNUM
     C                   KFLD                    ICCY
      *
      * Key list to read ACCNTL8
     C     KACC7         KLIST
     C                   KFLD                    IBRCA
     C                   KFLD                    W2CNUM
      *
     C                   ENDSR
      /EJECT
      ********************************************************************
** ALPHA
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
** CPY@
(c) Finastra International Limited 2001

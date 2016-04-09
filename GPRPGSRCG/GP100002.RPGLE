     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Global User Security - Booking Branches')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GP100002 - Global User Security - Booking Branches           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGP001  *CREATE    Date 26May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
     FGP100002DFCF   E             WORKSTN
     F                                     SFILE(GP100002F1:RRN)
     FGZSDBRCHL0IF   E           K DISK
     FGPMBRBS   UF A E           K DISK
     FGPMACBR1  UF   E           K DISK
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *   01  - HELP KEY                                              *
      *   10  - SUBFILE DISPLAY                                       *
      *   11  - SUBFILE END                                           *
      *   12  - SFLNXTCHG                                             *
      *                                                               *
      *   20  - DISPLAY SCREEN                                        *
      *                                                               *
      *   21  - INSERT                                                *
      *   22  - AMEND                                                 *
      *   23  - ENQUIRE                                               *
      *   24  - DELETE                                                *
      *                                                               *
      *   26  - ENQUIRY ON A DELETED RECORD                           *
      *                                                               *
      *   30  - GENERAL ERROR INDICATOR                               *
      *   31  - SELECT IN ERROR - NOT 'Y' OR BLANK                    *
      *                                                               *
      *   40  - GPMBRBS - CHAIN FAIL                                  *
      *   41  - GPMBRBS - RECORD NOT LIVE (IE. RECIBB NOT 'D')        *
      *   42  - GPMACBR1 - END OF FILE FOR USER PROFILE               *
      *                                                               *
      *   50  - GZSDBRCHL1/BRANCH CODES - END OF FILE                 *
      *   52  - BR. CODE IS ON USER'S BR. CODES ARRAY                 *
      *   60  - NO MORE 'READ CHANGED' RECORDS ON SUBFILE             *
      *                                                               *
      *****************************************************************
     D BRU             S              3    DIM(900)
      *
     D                 DS
      ** REDEFINE BRANCH FILE KEY
      *
     D  KEYBR                  1     12
     D  BRCA                  10     12
      ** HOLDS DISPLAY SCREEN ERROR CODES
      *
     D ARRDS           DS
     D  SERCD                  1     78
     D  ARR                    1     76
     D                                     DIM(19)
      ** HOLDS WORKSTATION ID
      *
     D PSDS           SDS
     D  SWSID                244    253
     D  USRID                254    263
     I/SPACE 2
     IMBRBSDDF
      ** USER'S BOOKING BRANCHES
      *
     I              RECI                        RECIBB
      /EJECT
      *
      ** RECEIVE USER PROFILE, ACTION CODE, RETURN CODE, UPDATE
      ** AND  RUN-DATE(2)  PARAMETERS FROM CALLING PROGRAM (GP100001).
      *
     C     *ENTRY        PLIST
     C                   PARM                    USRPRF           10
     C                   PARM                    ACTCDE            1
     C                   PARM                    RTCDE             1 0
     C                   PARM                    UPDATE            1
     C                   PARM                    SRUNA             7
     C                   PARM                    RUNDD             5 0
     C/SPACE 2
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** KEY TO ACCESS LF/GPMACBR1 (USER'S VALID ACTION CODES BY BRANCH)
      *
     C     ACBRKY        KLIST
     C                   KFLD                    USRPK            10
     C                   KFLD                    BRCAK             3
     C                   KFLD                    INDXK            10
      *
      ** Determine Action Code
      *
     C     ACTCDE        COMP      'I'                                    21
     C     ACTCDE        COMP      'A'                                    22
     C     ACTCDE        COMP      'E'                                    23
     C     ACTCDE        COMP      'D'                                    24
      *
      ** Setup User Profile's Array of Valid Branch Codes
      *
     C     USRPRF        CHAIN     GPMBRBS                            40
     C  N40RECIBB        COMP      'D'                                4141
      *
     C     *IN40         IFEQ      '0'
     C     *IN41         ANDEQ     '0'
     C                   MOVEA     VBRX          BRU
     C                   END
      *
      ** Enquiry on a deleted record
      *
     C     *IN23         IFEQ      '1'
     C     RECIBB        ANDEQ     'C'
     C                   SETON                                        26
     C                   MOVEA     VBRX          BRU
     C                   END
      *
      ** SETUP SUBFILE CONTROL AND HEADING FIELDS
      *
     C                   Z-ADD     0             RRN               3 0
     C                   Z-ADD     1             SDREC
     C                   MOVE      USRPRF        SUSER
     C                   MOVE      ACTCDE        SACTN
      *
      ** SET ON SUBFILE AND DISPLAY SCREEN INDICATORS
      *
     C                   SETON                                        1011
     C                   SETON                                        20
      *
      ** LOAD SUBFILE
      *
     C                   EXSR      LODSBF
      *
      ** DISPLAY SCREEN :-
      *
     C     *IN20         DOWEQ     '1'
      *
      ** - HEADINGS
      *
     C                   WRITE     GP100002F3
      *
      ** - SUBFILE
      *
     C                   EXFMT     GP100002F2
     C                   SETOFF                                       2030
      *
      ** CHECK CMD/KEY PRESSED + ACTION CODE ON EXITING DISPLAY
      *
     C     *INKC         CASEQ     '1'           EXIT
     C     *INKL         CASEQ     '1'           INITSC
     C     *IN10         CASEQ     '0'           ENDPGM
      *
     C     ACTCDE        CASEQ     'I'           INSAMD
     C     ACTCDE        CASEQ     'A'           INSAMD
     C     ACTCDE        CASEQ     'D'           DELETE
     C                   END
      *
     C                   END
      *
      ** END PROGRAM
      *
     C                   EXSR      ENDPGM
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * LODSBF    - LOAD SUBFILE WITH BRANCH CODE RECORDS.            *
      *                                                               *
      *****************************************************************
     C     LODSBF        BEGSR
      *
     C                   MOVE      *BLANK        BRKEY             3
      *
     C     BRKEY         SETLL     GZSDBRCHL0
      *
     C                   READ      GZSDBRCHL0                             50
      *
     C     *IN50         DOWEQ     '0'
      *
     C                   ADD       1             RRN
      *
     C                   MOVE      A8BRCD        SBRCA
     C                   MOVE      A8BRNM        SBRNM
      *
     C     A8BRCD        LOOKUP    BRU                                    52
      *
     C     *IN52         IFEQ      '1'
     C                   SETON                                        12
     C                   MOVE      'Y'           SSLCT
     C                   ELSE
     C                   MOVE      ' '           SSLCT
     C                   END
      *
     C                   WRITE     GP100002F1
      *
     C                   SETOFF                                       12
      *
     C                   READ      GZSDBRCHL0                             50
      *
     C                   END
      *
      ** NO RECORDS IN SUBFILE
      *
     C     RRN           IFEQ      0
     C                   SETOFF                                       10
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INSAMD    - TO HANDLE INSERTS + AMENDMENTS                    *
      *                                                               *
      *****************************************************************
     C     INSAMD        BEGSR
      *
      ** RESET ARRAYS AND SUBFILE CONTROL FIELDS
      *
     C                   Z-ADD     0             X                 2 0
     C                   MOVE      *BLANK        ARR
     C                   Z-ADD     0             N                 3 0
     C                   MOVE      *BLANK        BRU
      *
     C                   Z-ADD     0             RRN
     C                   Z-ADD     1             SDREC
      *
      ** VALIDATE SELECTION ENTRIES :-
      *
     C     *IN60         DOUEQ     '1'
      *
     C                   SETOFF                                       31
     C                   SETON                                        12
      *
     C                   READC     GP100002F1                             60
      *
     C     *IN60         IFEQ      '0'
      *
      ** - INVALID ENTRY
      *
     C     SSLCT         IFNE      ' '
     C     SSLCT         ANDNE     'Y'
      *
     C                   SETON                                        31
      *
     C     *IN30         IFEQ      '0'
     C     X             ADD       1             X
     C                   MOVE      '030'         ARR(X)
      *
     C                   Z-ADD     RRN           SDREC
     C                   SETON                                        30
     C                   END
      *
     C                   ELSE
      *
      ** - VALID ENTRY
      *
     C     SSLCT         IFEQ      'Y'
     C                   ADD       1             N
     C                   MOVE      SBRCA         BRU(N)
     C                   ELSE
     C                   SETOFF                                       12
     C                   END
      *
     C                   END
      *
     C                   UPDATE    GP100002F1
      *
     C                   END
      *
     C                   END
      *
      ** IF ANY ERRORS, SET ON SCREEN INDICATOR
      *
     C     *IN30         IFEQ      '1'
      *
     C                   SETON                                        20
      *
     C                   ELSE
      *
      ** IF VALID, UPDATE FILES :-
      *
     C                   SORTA     BRU
     C                   MOVEA     BRU           VBRX
     C                   MOVE      N             NOBR
     C                   Z-ADD     RUNDD         LCD
     C                   MOVE      ACTCDE        CHTP
     C                   TIME                    TIMEP             6 0
     C                   Z-ADD     TIMEP         LCT
      *
      ** UPDATE GPMBRBS (USER'S VALID BRANCHES)
      *
     C     *IN40         IFEQ      '1'
      *
     C     NOBR          IFNE      0
      *
      ** - INSERT (NEW)
      *
     C                   MOVE      'D'           RECIBB
     C                   MOVE      USRPRF        USRP
     C                   WRITE     MBRBSDDF
     C                   MOVE      'Y'           UPDATE
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   UPDATE    MBRBSDDF
     C                   MOVE      'Y'           UPDATE
     C                   EXSR      UDMAB
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DELETE    - TO HANDLE DELETIONS                               *
      *                                                               *
      *****************************************************************
     C     DELETE        BEGSR
      *
      ** CMD/10 PRESSED - UPDATE GPMBRBS RECORD TO 'NON-LIVE'
      *
     C     *INKJ         IFEQ      '1'
      *
     C     *IN40         IFEQ      '0'
     C     *IN41         ANDEQ     '0'
      *
     C                   DELETE    MBRBSDDF
     C                   MOVE      'Y'           UPDATE
     C                   EXSR      UDMAB
     C                   END
      *
     C                   ELSE
      *
      ** 'ENTER' PRESSED - REDISPLAY SCREEN
      *
     C                   SETON                                        20
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UDMAB     - DELETE ANY UNWANTED RECORDS ON GPMACBR1           *
      *                                                               *
      *****************************************************************
     C     UDMAB         BEGSR
      *
     C                   SETOFF                                       4041
      *
     C     USRPRF        CHAIN     GPMBRBS                            40
     C  N40RECIBB        COMP      'D'                                4141
      *
     C                   MOVE      *BLANK        BRU
     C  N41              MOVEA     VBRX          BRU
      *
     C                   MOVE      USRPRF        USRPK
     C                   MOVE      '    '        BRCAK
     C                   MOVE      *BLANKS       INDXK
      *
     C     ACBRKY        SETLL     GPMACBR1
      *
     C     *IN42         DOWEQ     '0'
      *
     C                   READ      GPMACBR1                               42
     C  N42USRPK         COMP      USRP                               4242
      *
     C     *IN42         IFEQ      '0'
     C     BRCB          LOOKUP    BRU                                    52
      *
     C     *IN52         IFEQ      '0'
     C     *IN24         OREQ      '1'
     C                   DELETE    MACBRDDF
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * EXIT      - CMD/3 TAKEN TO EXIT  "MIDAS USER'S MAINTENACE"    *
      *                                                               *
      *****************************************************************
     C     EXIT          BEGSR
      *
     C                   Z-ADD     1             RTCDE
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INITSC    - CMD/12 TAKEN TO DISPLAY INITIAL SCREEN            *
      *                                                               *
      *****************************************************************
     C     INITSC        BEGSR
      *
     C                   Z-ADD     5             RTCDE
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ENDPGM    - RETURNS TO CALLING PROGRAM                        *
      *                                                               *
      *****************************************************************
     C     ENDPGM        BEGSR
      *
     C                   Z-ADD     0             RTCDE
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************

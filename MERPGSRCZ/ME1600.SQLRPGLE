     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas ME message repair')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1600 - ME Message Repair                                   *
      *                                                               *
      *  Function:  This program allows the user to enter and update  *
      *  the user process file MEURPRL0                               *
      *                                                               *
      *  Called By: On Request                                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056560           Date 31Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD022652           Date 07Oct13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 17Jul00               *
      *                 191624             Date 05Apr01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT007             Date 16Nov99               *
      *                 CFT006             Date 17DEC99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT005             Date 07Jul99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 162075             Date 26AUG99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 162428             Date 18JUN99               *
      *                 162562             Date 17JUN99               *
      *                 162233             Date 14JUN99               *
      *                 162073             Date 08JUN99               *
      *                 CFT002  *CREATE    Date 25Mar99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022652 - Excluded Phase Processing                         *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CFT009 - FT Fees and Charge Development-Recompiled           *
      *  191624 - Problem with CFT006 coding. If message type is not  *
      *           MT101/2 program still demands that you input        *
      *           tag header and repair tag header even though fields *
      *           are not displayed on screen.                        *
      *  CFT007 - BIC Database Plus Integration                       *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *  CFT005 - Straight Through Processing Phase 2                 *
      *           Auto-authorisation of STP payments (Recompile)      *
      *  162075 - Correct cursor positioning                          *
      *  162428 - Locking  record                                     *
      *  162562 - Recompile over ME1600DF                             *
      *  162233 - Recompile over ME1600DF                             *
      *  162073 - Error fix : F12 behaves as F3                       *
      *  CFT002 - Straight Through Processing Phase 1                 *
      *                                                               *
      *****************************************************************
     FME1600DF  CF   E             WORKSTN
     F                                     SFILE(REPDTL:RRN)
     FMEURPRL0  UF A E           K DISK
     F                                     COMMIT
     FMEGNCRL0  IF   E           K DISK    USROPN
     FMEUPGML0  IF   E           K DISK
     F*SDMTAGL1* IF   E           K DISK                                                    MD056560
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   03  - Function key                                          *
      *   05  - Function key                                          *
      *   09  - Function key                                          *
      *   10  - Function key                                          *
      *   12  - Function key                                          *
      *                                                               *
      *   25  - Message subfile                                       *
      *   26  - SFLDSP                                                *
      *   27  - SFLDSPCTL                                             *
      *   28  - SFLCLR                                                *
      *   29  - SFLEND                                                *
      *   30  - SFLNXTCHG                                             *
      *   31  - Protect and hide flag header tag                      *   CFT006
      *                                                               *
      *   49  - Protect sequence number for amend mode                *
      *   50  - Delete mode                                           *
      *   51  - Insert, Amend mode                                    *
      *   52  - No records found                                      *
      *   53  - Chain MEURPRL0                                        *
      *   54  - Chain MEUPGML0                                        *
      *   55  - Chain SDMTAGL1                                        *
      *                                                               *
      *   60  - Selection in error                                    *
      *   61  - Sequence no. in error                                 *
      *   62  - Process Value in error                                *
      *   63  - Input Tag in error                                    *
      *   64  - Repair Tag in error                                   *
      *   65  - Screen 1 in error                                     *
      *   66  - Screen 2 in error                                     *
      *   67  - Position cursor on input tag field                    *   162075
      *   68  - Position cursor on repair tag field                   *   162075
      *   69  - Flag header input tag in error                        *   CFT006
      *   70  - Flag header repair tag in error                       *   CFT006
      *                                                               *
      *   80  - READE MEURPRL0                                        *
      *   81  - READC REPDTL                                          *
      *   88  - Error indicator                                       *
      *                                                               *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  INIT   - Program Initialisation                              *
      *  SCRN1  - Subroutine to display screen 1                      *
      *  FILSC1 - Subroutine to fill screen 1                         *
      *  PROC1  - Subroutine to process screen 1                      *
      *  VALSEL - Validate selection                                  *
      *  NOREC  - Subroutine to display screen 1, if there are no     *
      *           records                                             *
      *  SCRN2  - Subroutine to display screen 2                      *
      *  DELREC - Subroutine to delete a record                       *
      *  ADDREC - Subroutine to insert/amend a record                 *
      *  PROC2  - Subroutine to process screen 2  (Amend/Insert)      *
      *  VALID  - Validate screen 2                                   *
      *  SAVE   - Update user repair file                             *
      *  ZASNMS - Send Message on subfile message queue               *
      *  CLRMSG - Clear message subfile                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      **  Array of QCMDEXC commands                                                           162428
      *                                                                                       162428
     D EDT             S              1    DIM(80)
      **  Array of QCMDEXC command to edit                                                    162428
      *                                                                                       162428
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  ##PGM                  1     10
     D  WSID                 244    253
     D  USER                 254    263
      *                                                                   162428
     D @1URPR          DS                                                       162428
     D  W2MTPY                 1      3                                         162428
     D  W2MSEQ                 4      6  0                                      162428
     D  W2SQNO                 7     11  0                                      162428
     D  W2KVAL                12     16  0                                      162428
     D  W2ITAG                17     21                                         162428
     D  W2RTAG                22     26                                         162428
     D  W2ITGH                27     27                                         CFT006
     D  W2RTGH                28     28                                         CFT006
      * Current/previous master file format fields for change control     162428
      *                                                                   162428
     D**********#1URPR      DS                             26      162428 CFT006
     D #1URPR          DS            28                                         CFT006
      * Stored master file format fields                                  162428
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CFT007
      *
      **  Data Structures used by Access Programs, Short Data Structure
      *
     D SDMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ***  Perform Initialisation.
      *
     C                   EXSR      INIT
      *
      ***  Display screen 1
      *
     C     SC1           DOWEQ     'Y'
     C                   EXSR      SCRN1
      *
      ***  Display screen 2
      *
     C     SC2           DOWEQ     'Y'
     C                   EXSR      SCRN2
     C                   ENDDO
      *
     C                   ENDDO
      *
     C                   SETON                                        LR
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  INIT - Subroutine to do Program Initialisation.              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Receive entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    WMTPY             3
     C                   PARM                    WMSET             3
     C                   PARM                    WFKEY             3
      *
     C                   MOVE      WMSET         W2MSET            3 0
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   END
      *
      **  Key list
      *
     C     KEY           KLIST
     C                   KFLD                    WMTPY
     C                   KFLD                    W2MSET
      *
     C     KEY2          KLIST
     C                   KFLD                    WMTPY
     C                   KFLD                    W2MSET
     C                   KFLD                    WSENO             5 0
      *                                                                                       CSW209
     C     KLVDEF        KLIST
     C                   KFLD                    EFMTAG                         Message Field T
     C                   KFLD                    EFMTPY                         Message type
     C                   KFLD                    EFMSEQ
      *                                                                   CFT006
      ** If message type is not 101/102, hide and protect flag header     CFT006
      ** tags                                                             CFT006
      *                                                                   CFT006
     C     WMTPY         IFEQ      '101'                                                       CFT00
     C     WMTPY         OREQ      '102'                                                       CFT00
     C                   MOVE      *OFF          *IN31                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVE      *ON           *IN31                                         CFT00
     C                   ENDIF                                                                 CFT00
      *
      *** Moving program details to screen fields
      *
     C                   MOVE      AGMRDT        SRUNA
     C                   MOVE      USER          SUSER
     C                   MOVE      WSID          SWSID
     C                   MOVE      WMTPY         SMTPY
     C                   MOVE      WMSET         SMSET
      *
      *** Clear message subfile
      *
     C                   EXSR      CLRMSG
      *
      *** Set indicators to display initial screen
      *
     C                   MOVE      'Y'           SC1               1
     C                   MOVE      'N'           SC2               1
      *                                                                                       162073
      *** Function key pressed when we quit the program                                       162073
      *
     C                   MOVE      *BLANK        WFKEY
      *                                                                                       162428
     C**  Open files                                                                          162428
      *                                                                                       162428
      * Open file MEGNCRL0                                                                    162428
      *                                                                                       162428
     C     FIL001        IFEQ      *BLANKS
      *                                                                                       162428
      *  Override file METAGTV1 to share(*NO)                                                 162428
      *                                                                                       162428
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'MEGNCRL0'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *                                                                                       162428
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     013           DBASE                          ***************
     C                   MOVEL(P)  'MEURPRL0'    DBFILE                         *DB ERROR 011 *
     C                   MOVEL(P)  'QCMDEXC '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *                                                                                       162428
     C                   OPEN      MEGNCRL0
     C                   MOVEL     'Y'           FIL001            1
     C                   END
      *                                                                   CFT007
      *  Access SAR details file to see if CFT007 is installed.           CFT007
      *                                                                   CFT007
     C                   CALL      'AOSARDR0'                                                  CFT00
     C                   PARM      *BLANKS       P@RTCD            7                           CFT00
     C                   PARM      '*VERIFY'     P@OPTN            7                           CFT00
     C                   PARM      'CFT007'      @SARD             6                           CFT00
     C     SCSARD        PARM      *BLANKS       DSFDY                                         CFT00
      *                                                                   CFT007
      *  Allow BIC Database Plus Integration                              CFT007
      *                                                                   CFT007
     C     P@RTCD        IFEQ      *BLANKS                                                     CFT00
     C                   MOVE      *ON           CFT007            1                           CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT007
      ** Check if SWIFT 2009 is installed                                                     CSW209
      *                                                                                       CSW209
     C                   CALL      'SWIF2009'
     C                   PARM                    P@RTCD
     C     P@RTCD        IFEQ      'CSW2009'
     C                   MOVE      'Y'           CSW209            1
     C                   SETOFF                                       56
     C                   ELSE
     C                   MOVE      'N'           CSW209
     C                   SETON                                        56
     C                   ENDIF
      *                                                                                       162428
      *                                                                                     MD022652
      ** Access SAR details file to see if CFT050 is installed.                             MD022652
      *                                                                                     MD022652
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CFT050'      PSARD             6
     C     SCSARD        PARM      *BLANKS       DSFDY
      *                                                                                     MD022652
      ** CFT007 process will take place when CFT050 is switched on                          MD022652
      *                                                                                     MD022652
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      *ON           CFT007
     C                   ENDIF
      *                                                                                     MD022652
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SCRN1  - Subroutine to display screen 1                      *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     SCRN1         BEGSR
      *
      ***  Fill screen
      *
     C                   EXSR      FILSC1
      *
     C                   MOVE      *BLANK        SACTC
     C                   MOVE      *ON           *IN26
     C                   MOVE      *ON           *IN27
     C                   MOVE      *ON           *IN29
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *OFF          *IN51
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *ON           *IN65
     C                   MOVE      *OFF          *IN12
      *
      ***  No records
      *
     C     RRN           IFEQ      1
     C                   EXSR      NOREC
     C                   ENDIF
      *
     C                   Z-ADD     1             REC
      *
      *** Loop until there are no errors
      *
     C     *IN65         DOWEQ     *ON
      *
      *** Write error messages
      *
     C                   WRITE     #MSGCTL
      *
      *** Display command keys
      *
     C                   WRITE     CMDKEY
      *
      *** Display header
      *
     C                   WRITE     HEADER
      *
      *** Display screen 1
      *
     C                   EXFMT     RDCTL
      *
      *** Clear message subfile
      *
     C                   EXSR      CLRMSG
      *
      *** Process screen 1
      *
     C                   EXSR      PROC1
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  FILSC1 - Subroutine to fill screen 1                         *
      *                                                               *
      *  Called By: SCRN1                                             *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     FILSC1        BEGSR
      *
      *** Clear subfile
      *
     C                   MOVE      *ON           *IN28
     C                   WRITE     RDCTL
     C                   MOVE      *OFF          *IN28
      *
      *** Read user repair file
      *
     C     KEY           SETLL     MEURPRL0
     C     KEY           READE     MEURPRL0                             8880
     C                   UNLOCK    MEURPRL0
      *
      ***  Handle Database Error.
      *
     C     *IN88         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     001           DBASE                          ***************
     C                   MOVEL     'MEURPRL0'    DBFILE                         *DB ERROR 001 *
     C                   OUT       LDA                                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     1             RRN               3 0
      *
     C     *IN80         DOWEQ     *OFF
      *
      ***  Write to the subfile all the records
      *
     C                   MOVE      RPSQNO        S1SENO
     C                   MOVE      RPKVAL        S1PVAL
     C                   MOVE      RPITAG        S1ITAG
     C                   MOVE      RPRTAG        S1RTAG
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     RPIMSQ        S1IMSQ
     C                   MOVEL     RPRMSQ        S1RMSQ
     C                   ENDIF
      *                                                                                       CSW209
     C                   MOVEL     RPITGH        H1ITGH
     C                   MOVEL     RPRTGH        H1RTGH
     C                   MOVE      *BLANKS       S1AMD
     C                   WRITE     REPDTL
     C                   ADD       1             RRN
      *
     C     KEY           READE     MEURPRL0                             8880
     C                   UNLOCK    MEURPRL0
      *
      ***  Handle Database Error.
      *
     C     *IN88         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     002           DBASE                          ***************
     C                   MOVEL     'MEURPRL0'    DBFILE                         *DB ERROR 002 *
     C                   OUT       LDA                                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  PROC1  - Subroutine to process screen 1                      *
      *                                                               *
      *  Called By: SCRN1                                             *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     PROC1         BEGSR
      *
     C                   SELECT
      *
      ****If*F3*is*pressed,*quit***********                                                   162073
      *** If F3 is pressed, quit menu CRIT (exit ME1540)                                      162073
      *
     C     *IN03         WHENEQ    *ON
     C                   MOVE      *OFF          *IN65
     C                   MOVE      'N'           SC2
     C                   MOVE      'N'           SC1
     C                   MOVE      'F03'         WFKEY
      *                                                                                       162073
      *** If F12 is pressed, quit (return to ME1540)                                          162073
      *                                                                                       162073
     C     *IN12         WHENEQ    *ON
     C                   MOVE      *OFF          *IN65
     C                   MOVE      'N'           SC2
     C                   MOVE      'N'           SC1
     C                   MOVE      'F12'         WFKEY
      *
      *** If F5 is pressed, refresh
      *
     C     *IN05         WHENEQ    *ON
     C                   MOVE      *OFF          *IN65
     C                   MOVE      'N'           SC2
     C                   MOVE      'Y'           SC1
      *
      *** If F9 is pressed, insert record (screen 2)
      *
     C     *IN09         WHENEQ    *ON
     C                   MOVE      *OFF          *IN65
     C                   MOVE      *OFF          *IN49
     C                   MOVE      *BLANKS       S1AMD
     C                   MOVE      'Y'           SC2
     C                   MOVE      'N'           SC1
     C                   OTHER
      *
      *** Validate selection
      *
     C                   EXSR      VALSEL
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * VALSEL - Validate selection                                   *
      *                                                               *
      * Called by: PROC1                                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     VALSEL        BEGSR
      *
     C                   Z-ADD     0             ERRCNT            1 0
      *
      *** Read changes to subfile
      *
     C                   READC     REPDTL                                 81
      *
     C     *IN81         DOWEQ     *OFF
      *
     C                   SELECT
      *
      *** Selection is 'A' or 'D'
      *
     C     S1AMD         WHENEQ    'A'
     C     S1AMD         OREQ      'D'
     C                   MOVE      *ON           *IN30
     C                   UPDATE    REPDTL
     C                   MOVE      *OFF          *IN30
     C                   READC     REPDTL                                 81
      *
      *** Selection is not 'A' and not 'D' and not blank
      *
     C     S1AMD         WHENNE    'A'
     C     S1AMD         ANDNE     'D'
     C     S1AMD         ANDNE     *BLANKS
      *
     C                   ADD       1             ERRCNT
      *
     C     ERRCNT        IFEQ      1
     C                   Z-ADD     RRN           REC
     C                   ENDIF
      *
     C                   MOVE      *ON           *IN30
     C                   MOVE      *ON           *IN60
     C                   UPDATE    REPDTL
     C                   MOVE      *OFF          *IN30
     C                   MOVE      *OFF          *IN60
      *
      *** Error message
      *
     C                   MOVEL     'MEM7000'     ZAMSID
     C                   EXSR      ZASNMS
     C                   READC     REPDTL                                 81
      *
     C                   OTHER
      *
      *** Selection is  blank
      *
     C                   MOVE      *OFF          *IN30
     C                   UPDATE    REPDTL
     C                   READC     REPDTL                                 81
      *
     C                   ENDSL
     C                   ENDDO
      *
      *** If there are no errors and a selection has been made turn
      *** on indicators to display screen 2
      *
     C     ERRCNT        IFEQ      0
     C                   READC     REPDTL                                 81
     C     *IN81         IFEQ      *OFF
     C                   MOVE      *OFF          *IN65
     C                   MOVE      *ON           *IN49
     C                   MOVE      'N'           SC1
     C                   MOVE      'Y'           SC2
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  NOREC  - Subroutine to display screen 1, if there are no     *
      *           records                                             *
      *                                                               *
      *  Called By: SCRN1                                             *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     NOREC         BEGSR
      *
     C                   MOVE      *OFF          *IN03
     C                   MOVE      *OFF          *IN09
     C                   MOVE      *OFF          *IN26
     C                   MOVE      *ON           *IN27
     C                   MOVE      *ON           *IN52
     C                   MOVE      *OFF          *IN65
      *
      *** Write error messages
      *
     C                   WRITE     #MSGCTL
      *
      *** Display header
      *
     C                   WRITE     HEADER
      *
      *** Display command keys
      *
     C                   WRITE     CMDKEY
      *
     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
     C     *IN09         ANDEQ     *OFF
      *
      *** Display screen 1
      *
     C                   EXFMT     RDCTL
     C                   ENDDO
      *
      *** Clear message subfile
      *
     C                   EXSR      CLRMSG
      *
      *** If F3 is pressed, quit
      *
     C     *IN03         IFEQ      *ON
     C                   MOVE      'N'           SC1
     C                   MOVE      'N'           SC2
     C                   MOVE      'F03'         WFKEY
     C                   ELSE
      *                                                                                       162073
      *** If F12 is pressed, previous screen                                                  162073
      *                                                                                       162073
     C     *IN12         IFEQ      *ON
     C                   MOVE      'N'           SC1
     C                   MOVE      'N'           SC2
     C                   MOVE      'F12'         WFKEY
     C                   ELSE
      *
      *** If F9 is pressed, insert record (screen 2)
      *
     C                   MOVE      *OFF          *IN49
     C                   MOVE      *BLANKS       S1AMD
     C                   MOVE      'N'           SC1
     C                   MOVE      'Y'           SC2
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       162073
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SCRN2  - Subroutine to display screen 2                      *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     SCRN2         BEGSR
      *
      *** Insert mode
      *
     C     S1AMD         IFEQ      *BLANKS
     C                   EXSR      ADDREC
     C                   ELSE
     C                   MOVE      *OFF          *IN03
     C                   MOVE      *OFF          *IN12
      *
     C     *IN81         DOWEQ     *OFF
     C     *IN03         ANDEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C     S1AMD         IFEQ      'D'
      *
      *** Delete mode
      *
     C                   EXSR      DELREC
     C                   ELSE
      *
      *** Amend mode
      *
     C                   EXSR      ADDREC
     C                   ENDIF
      *
      *** Read next record to be deleted or amended
      *
     C     *IN03         IFEQ      *OFF
     C     *IN12         ANDEQ     *OFF
     C                   READC     REPDTL                                 81
     C                   ENDIF
      *
     C                   ENDDO
      *
      *** Display screen 1 when all deletes and amends have been
      *** completed
      *
     C     *IN81         IFEQ      *ON
     C                   MOVE      'Y'           SC1
     C                   MOVE      'N'           SC2
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  DELREC - Subroutine to delete a record                       *
      *                                                               *
      *  Called By: SCRN2                                             *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     DELREC        BEGSR
      *
      *** Fill screen 2
      *
     C                   MOVE      'D'           SACTC
     C                   MOVE      S1SENO        S2SENO
     C                   MOVE      S1PVAL        S2PVAL
     C                   MOVE      S1ITAG        S2ITAG
     C                   MOVE      S1RTAG        S2RTAG
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     S1IMSQ        S2IMSQ
     C                   MOVEL     S1RMSQ        S2RMSQ
     C                   ENDIF
      *                                                                                       CSW209
     C                   MOVEL     H1ITGH        S2ITGH                                        CFT00
     C                   MOVEL     H1RTGH        S2RTGH                                        CFT00
      *
     C                   MOVE      *OFF          *IN03
     C                   MOVE      *OFF          *IN10
     C                   MOVE      *OFF          *IN12
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN51
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN64
     C                   MOVE      *OFF          *IN69                                         CFT00
     C                   MOVE      *OFF          *IN70                                         CFT00
      *
      *** Write error messages
      *
     C                   WRITE     #MSGCTL
      *
      *** Display header
      *
     C                   WRITE     HEADER
      *
      *** Display command keys
      *
     C                   WRITE     CMDKEY
      *
     C     *IN03         DOWEQ     *OFF
     C     *IN10         ANDEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
      *** Display screen 2
      *
     C                   EXFMT     REPDT2
     C                   ENDDO
      *
      *** Clear message subfile
      *
     C                   EXSR      CLRMSG
      *
     C                   SELECT
      *
      *** If F3 is pressed, quit
      *
     C     *IN03         WHENEQ    *ON
     C                   MOVE      'N'           SC1
     C                   MOVE      'N'           SC2
     C                   MOVE      'F03'         WFKEY
      *
      *** If F12 is pressed, display screen 1
      *
     C     *IN12         WHENEQ    *ON
     C                   MOVE      'Y'           SC1
     C                   MOVE      'N'           SC2
     C                   MOVE      'F12'         WFKEY
      *
      *** If F10 is pressed, delete record
      *
     C     *IN10         WHENEQ    *ON
     C                   Z-ADD     S2SENO        WSENO
      *
     C     KEY2          CHAIN     MEURPRL0                           5388
      *
      ***  Handle Database Error.
      *
     C     *IN88         IFEQ      *ON
     C     *IN53         OREQ      *ON
     C************LOCK     IN   LDA                                                           162428
     C*********************SETON                       U7U8                                   162428
     C*********************Z-ADD003       DBASE            ***************                    162428
     C*********************MOVEL'MEURPRL0'DBFILE           *DB ERROR 003 *                    162428
     C*********************OUT  LDA                        ***************                    162428
     C*********************EXSR *PSSR                                                         162428
      * Change error detected                                                                 162428
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   UNLOCK    MEURPRL0
     C                   GOTO      ENDDEL
     C                   ENDIF
      *
     C                   DELETE    MEURPRL0                             88
      *
      ***  Handle Database Error.
      *
     C     *IN88         IFEQ      *ON
     C************LOCK     IN   LDA                                                          162428
     C*********************SETON                       U7U8                                  162428
     C*********************Z-ADD004       DBASE            ***************                   162428
     C*********************MOVEL'MEURPRL0'DBFILE           *DB ERROR 004 *                   162428
     C*********************OUT  LDA                        ***************                   162428
     C*********************EXSR *PSSR                                                        162428
      * Change error detected                                                                 162428
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   UNLOCK    MEURPRL0
     C                   ROLBK
     C                   GOTO      ENDDEL
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
      *
     C                   ENDSL
      *
     C*********************ENDSR                                                             162428
     C     ENDDEL        ENDSR
      *
      *****************************************************************
      *                                                               *
      *  ADDREC - Subroutine to insert/amend a record                 *
      *                                                               *
      *  Called By: SCRN2                                             *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     ADDREC        BEGSR
      *
      *** Fill screen 2
      *
     C     S1AMD         IFEQ      'A'
     C                   MOVE      'A'           SACTC
     C                   MOVE      S1SENO        S2SENO
     C                   MOVE      S1PVAL        S2PVAL
     C                   MOVE      S1ITAG        S2ITAG
     C                   MOVE      S1RTAG        S2RTAG
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     S1IMSQ        S2IMSQ
     C                   MOVEL     S1RMSQ        S2RMSQ
     C                   ENDIF
      *                                                                                       CSW209
     C                   MOVEL     H1ITGH        S2ITGH                                        CFT00
     C                   MOVEL     H1RTGH        S2RTGH                                        CFT00
     C** Hold existing image                                                                  162428
     C                   MOVE      WMTPY         W2MTPY
     C                   MOVE      WMSET         W2MSEQ
     C                   MOVE      S1SENO        W2SQNO
     C                   MOVE      S1PVAL        W2KVAL
     C                   MOVE      S1ITAG        W2ITAG
     C                   MOVE      S1RTAG        W2RTAG
     C                   MOVEL     H1ITGH        W2ITGH                                        CFT00
     C                   MOVEL     H1RTGH        W2RTGH                                        CFT00
     C                   MOVE      @1URPR        #1URPR
     C                   ELSE
     C                   MOVE      'I'           SACTC
     C                   Z-ADD     0             S2SENO
     C                   MOVE      *BLANKS       S2PVAL
     C                   MOVE      *BLANKS       S2ITAG
     C                   MOVE      *BLANKS       S2RTAG
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     *BLANKS       S2IMSQ
     C                   MOVEL     *BLANKS       S2RMSQ
     C                   ENDIF
      *                                                                                       CSW209
     C                   MOVEL     'N'           S2ITGH                                        CFT00
     C                   MOVEL     'N'           S2RTGH                                        CFT00
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *ON           *IN51
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN64
     C                   MOVE      *ON           *IN66
     C                   MOVE      *OFF          *IN69                                         CFT00
     C                   MOVE      *OFF          *IN70                                         CFT00
      *
      *** Loop until there are no errors
      *
     C     *IN66         DOWEQ     *ON
      *
      *** Write error messages
      *
     C                   WRITE     #MSGCTL
      *
      *** Display command keys
      *
     C                   WRITE     CMDKEY
      *
      *** Display header
      *
     C                   WRITE     HEADER
      *
      *** Display screen 2
      *
     C                   EXFMT     REPDT2
      *
      *** Clear message subfile
      *
     C                   EXSR      CLRMSG
      *
      *** Process screen 2
      *
     C                   EXSR      PROC2
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  PROC2  - Subroutine to process screen 2  (Amend/Insert)      *
      *                                                               *
      *  Called By: ADDREC                                            *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     PROC2         BEGSR
      *
     C                   SELECT
      *
      *** If F3 is pressed, quit
      *
     C     *IN03         WHENEQ    *ON
     C                   MOVE      *OFF          *IN66
     C                   MOVE      'N'           SC2
     C                   MOVE      'N'           SC1
     C                   MOVE      'F03'         WFKEY
      *
      *** If F12 is pressed, display screen 1
      *
     C     *IN12         WHENEQ    *ON
     C                   MOVE      *OFF          *IN66
     C                   MOVE      'N'           SC2
     C                   MOVE      'Y'           SC1
     C                   MOVE      'F12'         WFKEY
      *
      *** If F5 is pressed, refresh
      *
     C     *IN05         WHENEQ    *ON
      *
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN64
     C                   MOVE      *OFF          *IN69                                         CFT00
     C                   MOVE      *OFF          *IN70                                         CFT00
      *
     C     S1AMD         IFEQ      'A'
     C                   MOVE      S1SENO        S2SENO
     C                   MOVE      S1PVAL        S2PVAL
     C                   MOVE      S1ITAG        S2ITAG
     C                   MOVE      S1RTAG        S2RTAG
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     S1IMSQ        S2IMSQ
     C                   MOVEL     S1RMSQ        S2RMSQ
     C                   ENDIF
      *                                                                                       CSW209
     C                   MOVEL     H1ITGH        S2ITGH                                        CFT00
     C                   MOVEL     H1RTGH        S2RTGH                                        CFT00
     C                   ELSE
     C                   Z-ADD     0             S2SENO
     C                   MOVE      *BLANKS       S2PVAL
     C                   MOVE      *BLANKS       S2ITAG
     C                   MOVE      *BLANKS       S2RTAG
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     *BLANKS       S2IMSQ
     C                   MOVEL     *BLANKS       S2RMSQ
     C                   ENDIF
      *                                                                                       CSW209
     C                   MOVEL     'N'           S2ITGH                                        CFT00
     C                   MOVEL     'N'           S2RTGH                                        CFT00
     C                   ENDIF
      *
     C                   OTHER
      *
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN64
     C                   MOVE      *OFF          *IN67                                         16207
     C                   MOVE      *OFF          *IN68                                         16207
     C                   MOVE      *OFF          *IN69                                         CFT00
     C                   MOVE      *OFF          *IN70                                         CFT00
      *
      *** ? processing
      *
     C     S2ITAG        IFEQ      '?'
     C     S2RTAG        OREQ      '?'
      *
     C     S2ITAG        DOWEQ     '?'
     C     S2RTAG        OREQ      '?'
      *
      *** Access message tag file
      *
     C                   CALL      'AOMTAGR0'
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      '?'           P@MTAG            5            I:Key field
     C                   PARM      *BLANKS       P@MTPY            3            I:Key field
     C                   PARM      *BLANKS       DSFDY                          O:Format
      *
      ***  Handle Database Error.
      *
     C     P@RTCD        IFNE      *BLANKS
     C     P@RTCD        ANDNE     '*NOSEL'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     012           DBASE                          ***************
     C                   MOVEL     'AOMTAGR0'    DBFILE                         *DB ERROR 012 *
     C                   OUT       LDA                                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     S2ITAG        IFEQ      '?'
     C                   MOVE      P@MTAG        S2ITAG
     C                   MOVE      *ON           *IN67                                         16207
     C                   ELSE
     C                   MOVE      P@MTAG        S2RTAG
     C                   MOVE      *ON           *IN68                                         16207
     C                   ENDIF
      *
     C                   ENDDO
     C                   ELSE
      *
      *** Validate screen 2
      *
     C                   EXSR      VALID
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * VALID  - Validate screen 2                                    *
      *                                                               *
      * Called by: PROC2                                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     VALID         BEGSR
      *
      *** Validate sequence number (insert mode)
      *
     C     *IN49         IFEQ      *OFF
      *
     C     S2SENO        IFEQ      0
     C                   MOVE      *ON           *IN61
     C                   MOVEL     'MEM7005'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     S2SENO        IFLT      0
     C                   MOVE      *ON           *IN61
     C                   MOVEL     'MEM7030'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     S2SENO        WSENO
     C     KEY2          CHAIN     MEURPRL0                           5388
      *
      ***  Handle Database Error.
      *
     C     *IN88         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     005           DBASE                          ***************
     C                   MOVEL     'MEURPRL0'    DBFILE                         *DB ERROR 005 *
     C                   OUT       LDA                                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN53         IFEQ      *OFF
     C                   MOVE      *ON           *IN61
     C                   MOVEL     'MEM7025'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      *** Validate process value
      *
     C     S2PVAL        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN62
     C                   MOVEL     'MEM7005'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *                                                                   CFT007
      * *BICP is valid if BIC DB+ is on and input tag is blank            CFT007
      *                                                                   CFT007
     C     S2PVAL        IFEQ      '*BICP'                                                     CFT00
     C     CFT007        ANDEQ     *ON                                                         CFT00
     C     S2ITAG        IFNE      *BLANK                                                      CFT00
     C                   MOVE      *ON           *IN63                                         CFT00
     C                   MOVEL     'MEM3000'     ZAMSID                                        CFT00
     C                   EXSR      ZASNMS                                                      CFT00
     C                   ENDIF                                                                 CFT00
     C                   ELSE                                                                  CFT00
     C     S2PVAL        CHAIN     MEUPGML0                           5488
     C                   ENDIF                                                                 CFT00
      *
      ***  Handle Database Error.
      *
     C     *IN88         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     006           DBASE                          ***************
     C                   MOVEL     'MEUPGML0'    DBFILE                         *DB ERROR 006 *
     C                   OUT       LDA                                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN54         IFEQ      *ON
     C                   MOVE      *ON           *IN62
     C                   MOVEL     'MEM7010'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ENDIF
      *
      *** Validate input tag
      *
     C     S2ITAG        IFNE      *BLANKS
     C*****S2ITAG        CHAIN     SDMTAGL1                           5588                  MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :S2ITAG                                                              MD056560
     C/END-EXEC                                                                             MD056560
     C                   setoff                                       5588                  MD056560
     C                   IF        SQLCODE < 0                                              MD056560
     C                   seton                                        88                    MD056560
     C                   ENDIF                                                              MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   seton                                        55                    MD056560
     C                   ENDIF                                                              MD056560
      *
      ***  Handle Database Error.
      *
     C     *IN88         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     007           DBASE                          ***************
     C                   MOVEL     'SDMTAGL1'    DBFILE                         *DB ERROR 007 *
     C                   OUT       LDA                                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN55         IFEQ      *ON
     C                   MOVE      *ON           *IN63
     C                   MOVEL     'MEM7015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C     *IN55         ANDNE     *ON
     C     *IN88         ANDNE     *ON
      *                                                                                       CSW209
      * If all low order keys not entered, exit                                               CSW209
      *                                                                                       CSW209
     C                   MOVEL     SMTPY         EFMTPY
     C                   MOVEL     S2ITAG        EFMTAG
     C                   MOVEL     S2IMSQ        EFMSEQ
      *                                                                                       CSW209
     C*****KLVDEF        CHAIN     @EFREJ5                            55
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN55         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     'ALL'         EFMTPY
     C*****KLVDEF        CHAIN     @EFREJ5                            55
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN55         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     SMTPY         EFMTPY
     C                   MOVEL     *BLANKS       EFMSEQ
     C*****KLVDEF        CHAIN     @EFREJ5                            55
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN55         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     'ALL'         EFMTPY
     C*****KLVDEF        CHAIN     @EFREJ5                            55
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C******IN55         IFNE      '0'                                                      MD056560
     C                   IF        SQLCODE <> 0                                             MD056560
      * Send message 'Midas Message  NF'                                                      CSW209
     C                   MOVEL     'MIN0059'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                    CFT006
      *** Validate flag input header tag                                   CFT006
      *                                                                    CFT006
     C     WMTPY         IFEQ      '101'                                                        1916
     C     WMTPY         OREQ      '102'                                                        1916
     C     S2ITGH        IFNE      'Y'                                                          CFT0
     C     S2ITGH        ANDNE     'N'                                                          CFT0
     C**  Send message value required Y or N                               CFT006
     C                   MOVEL     'MIN0330'     ZAMSID                                         CFT0
     C                   EXSR      ZASNMS                                                       CFT0
     C                   MOVE      '1'           *IN69                                          CFT0
     C                   ENDIF                                                                  CFT0
     C                   ELSE                                                                   1916
     C                   MOVE      'N'           S2ITGH                                         1916
     C                   ENDIF                                                                  1916
      *
      *** Validate repair tag
      *
     C     S2RTAG        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN64
     C                   MOVEL     'MEM7005'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C*****S2RTAG        CHAIN     SDMTAGL1                           5588                  MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :S2RTAG                                                              MD056560
     C/END-EXEC                                                                             MD056560
     C                   setoff                                       5588                  MD056560
     C                   IF        SQLCODE < 0                                              MD056560
     C                   seton                                        88                    MD056560
     C                   ENDIF                                                              MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   seton                                        55                    MD056560
     C                   ENDIF                                                              MD056560
      *
      ***  Handle Database Error.
      *
     C     *IN88         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     008           DBASE                          ***************
     C                   MOVEL     'SDMTAGL1'    DBFILE                         *DB ERROR 008 *
     C                   OUT       LDA                                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN55         IFEQ      *ON
     C                   MOVE      *ON           *IN64
     C                   MOVEL     'MEM7015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C     *IN55         ANDNE     *ON
     C     *IN88         ANDNE     *ON
      *                                                                                       CSW209
      * If all low order keys not entered, exit                                               CSW209
      *                                                                                       CSW209
     C                   MOVEL     SMTPY         EFMTPY
     C                   MOVEL     S2RTAG        EFMTAG
     C                   MOVEL     S2RMSQ        EFMSEQ
      *                                                                                       CSW209
     C*****KLVDEF        CHAIN     @EFREJ5                            55                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN55         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     'ALL'         EFMTPY
     C*****KLVDEF        CHAIN     @EFREJ5                            55                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN55         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     SMTPY         EFMTPY
     C                   MOVEL     *BLANKS       EFMSEQ
     C*****KLVDEF        CHAIN     @EFREJ5                            55                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN55         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     'ALL'         EFMTPY
     C*****KLVDEF        CHAIN     @EFREJ5                            55                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C******IN55         IFNE      '0'                                                      MD056560
     C                   IF        SQLCODE <> 0                                             MD056560
      * Send message 'Midas Message  NF'                                                      CSW209
     C                   MOVEL     'MIN0059'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                    CFT006
      *** Validate flag repair header tag                                  CFT006
      *                                                                    CFT006
     C     WMTPY         IFEQ      '101'                                                        1916
     C     WMTPY         OREQ      '102'                                                        1916
     C     S2RTGH        IFNE      'Y'                                                          CFT0
     C     S2RTGH        ANDNE     'N'                                                          CFT0
     C**  Send message value required Y or N                               CFT006
     C                   MOVEL     'MIN0330'     ZAMSID                                         CFT0
     C                   EXSR      ZASNMS                                                       CFT0
     C                   MOVE      '1'           *IN70                                          CFT0
     C                   ENDIF                                                                  CFT0
     C                   ELSE                                                                   1916
     C                   MOVE      'N'           S2RTGH                                         1916
     C                   ENDIF                                                                  1916
      *
      *** Validate message tags
      *
     C     S2RTAG        IFNE      *BLANKS
     C     S2ITAG        ANDNE     *BLANKS
     C     S2RTAG        IFEQ      S2ITAG
     C     CSW209        ANDEQ     'N'
     C     S2RTAG        OREQ      S2ITAG
     C     S2IMSQ        ANDEQ     S2RMSQ
     C     CSW209        ANDEQ     'Y'
     C                   MOVE      *ON           *IN63
     C                   MOVE      *ON           *IN64
     C                   MOVEL     'MEM7020'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ENDIF
      *
      *** If there are no errors
      *
     C     *IN61         IFEQ      *OFF
     C     *IN62         ANDEQ     *OFF
     C     *IN63         ANDEQ     *OFF
     C     *IN64         ANDEQ     *OFF
     C     *IN69         ANDEQ     *OFF                                                        CFT00
     C     *IN70         ANDEQ     *OFF                                                        CFT00
      *
     C                   MOVE      *OFF          *IN66
      *
      *** Turn on indicators to display screen 1 (Insert)
      *
     C     S1AMD         IFEQ      *BLANKS
     C                   MOVE      'N'           SC2
     C                   MOVE      'Y'           SC1
     C                   ENDIF
      *
      *** Update user repair file
      *
     C                   EXSR      SAVE
      *
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SAVE - Update user repair file                                *
      *                                                               *
      * Called by: VALID                                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     SAVE          BEGSR
      *
      *** Insert mode, write record to file
      *
     C     S1AMD         IFEQ      *BLANKS
      *                                                                                       162428
      * Check header record has not been deleted by another user                              162428
     C     KEY           SETLL     MEGNCRL0                               88
     C     *IN88         IFEQ      '0'
      * Change error detected                                                                 162428
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        88
     C                   GOTO      ENDSAV
     C                   ELSE
     C                   SETOFF                                       88
     C                   END
      *                                                                                       162428
     C                   MOVE      WMTPY         RPMTPY
     C                   Z-ADD     W2MSET        RPMSET
     C                   Z-ADD     S2SENO        RPSQNO
     C                   MOVE      S2PVAL        RPKVAL
     C                   MOVE      S2ITAG        RPITAG
     C                   MOVE      S2RTAG        RPRTAG
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     S2IMSQ        RPIMSQ
     C                   MOVEL     S2RMSQ        RPRMSQ
     C                   ENDIF
      *                                                                                       CSW209
     C                   MOVEL     S2ITGH        RPITGH                                        CFT00
     C                   MOVEL     S2RTGH        RPRTGH                                        CFT00
     C                   WRITE     @URPRPD                              88
      *
      ***  Handle Database Error.
      *
     C     *IN88         IFEQ      *ON
     C************LOCK     IN   LDA                                                           162428
     C*********************SETON                       U7U8                                   162428
     C*********************Z-ADD009       DBASE            ***************                    162428
     C*********************MOVEL'MEURPRL0'DBFILE           *DB ERROR 009 *                    162428
     C*********************OUT  LDA                        ***************                    162428
     C*********************EXSR *PSSR                                                         162428
      * Change error detected                                                                 162428
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      ENDSAV
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
      *
     C                   ELSE
      *
      *** Amend mode, update record on file
      *
      *                                                                                       162428
     C                   Z-ADD     S2SENO        WSENO
     C     KEY2          CHAIN     MEURPRL0                           5388
      *
      ***  Handle Database Error.
      *
     C     *IN88         IFEQ      *ON
     C************LOCK     IN   LDA                                                           162428
     C*********************SETON                       U7U8                                   162428
     C*********************Z-ADD010       DBASE            ***************                    162428
     C*********************MOVEL'MEURPRL0'DBFILE           *DB ERROR 010 *                    162428
     C*********************OUT  LDA                        ***************                    162428
     C*********************EXSR *PSSR                                                         162428
      * Change error detected                                                                 162428
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   UNLOCK    MEURPRL0
     C                   GOTO      ENDSAV
     C                   ENDIF
      *                                                                                       162428
     C                   MOVE      RPMTPY        W2MTPY
     C                   MOVE      RPMSET        W2MSEQ
     C                   MOVE      RPSQNO        W2SQNO
     C                   MOVE      RPKVAL        W2KVAL
     C                   MOVE      RPITAG        W2ITAG
     C                   MOVE      RPRTAG        W2RTAG
      ** Check for changed record                                                             162428
     C     #1URPR        IFNE      @1URPR
      ** Send message '*Update not accepted'                                                  162428
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   UNLOCK    MEURPRL0
     C                   GOTO      ENDSAV
     C                   END
      *
     C                   MOVE      S2PVAL        RPKVAL
     C                   MOVE      S2ITAG        RPITAG
     C                   MOVE      S2RTAG        RPRTAG
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     S2IMSQ        RPIMSQ
     C                   MOVEL     S2RMSQ        RPRMSQ
     C                   ENDIF
      *                                                                                       CSW209
     C                   MOVEL     S2ITGH        RPITGH                                        CFT00
     C                   MOVEL     S2RTGH        RPRTGH                                        CFT00
     C                   UPDATE    @URPRPD                              88
      *
      ***  Handle Database Error.
      *
     C     *IN88         IFEQ      *ON
     C************LOCK     IN   LDA                                                           162428
     C*********************SETON                       U7U8                                   162428
     C*********************Z-ADD011       DBASE            ***************                    162428
     C*********************MOVEL'MEURPRL0'DBFILE           *DB ERROR 011 *                    162428
     C*********************OUT  LDA                        ***************                    162428
     C*********************EXSR *PSSR                                                         162428
      * Change error detected                                                                 162428
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   UNLOCK    MEURPRL0
     C                   ROLBK
     C                   GOTO      ENDSAV
     C                   ELSE
     C** Update saved record image                                                            162428
     C                   MOVE      @1URPR        #1URPR
     C                   COMMIT
     C                   ENDIF
      *
     C                   ENDIF
     C*********************ENDSR                                                             162428
     C     ENDSAV        ENDSR
      *
      *****************************************************************
      *                                                               *
      * ZASNMS - Send Message on subfile message queue                *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: Y2SNMGC                                                *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
     C                   MOVEL     *BLANK        ZAMSGF
      *
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  CLRMSG     : Clear message subfile                           *
      *                                                               *
      *  Called by  :                                                 *
      *                                                               *
      *  Calls      : Y2CLMSC                                         *
      *                                                               *
      *****************************************************************
      *
     C     CLRMSG        BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   ENDSR
      *****************************************************************
      *
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
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ***************
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ******************
      *
     C                   CALL      'DBERRCTL'
      *
      ********************************************************************
     C                   END
      *
      ************ END PROGRAM IF DBERRCTL NOT CALLED ********************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** Command Array                                                      162428
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)

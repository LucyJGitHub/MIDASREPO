     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Automatic Trade Numbers Maintenance')
     F****************************************************************
     F*                                                              *
     F*  Midas - Standing Data Module
     F*                                                              *
     F*     APTRDNOMNT - Automatic Trade Number Maintenance (SE & FF)*
     F*                                                              *
      *  Function:  This module allows the maintenance of the        *
      *             automatic trade numbers used by the Securities   *
      *             (trades and depot movements) and Futures/Options *
      *             modules.                                         *
     F*
      *  (c) Finastra International Limited 2001                      *
     F*                                                              *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 222393             Date 25May16               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006  *CREATE    Date 21Jan99               *
      *                                    Date ddmmmyy               *
     F*                                                              *
     F****************************************************************
     F*                                                              *
      *  MD046248 - Finastra Rebranding                               *
      *  222393 - Automatic security trade numbers maintenance shows  *
      *           data fields but the text descriptions are missing.  *
      *           The same with depot movement numbers and futures    *
      *           trade numbers maintenances. Fix is to pass the      *
      *           message ID value of the hidden fields introduced by *
      *           amendment CAP040 in display file APTRDNODF.         *
      *         - Applied for MD-35060.                               *
      *  CAP006 - Conversion of Midas inputs to modular API structure *
     F****************************************************************
     F*
     F**  Indicator Function Summary
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     F*       10       SUBFILE END CONDITIONING INDICATOR
     F*
     F*       11       SCREEN BUILD 1 - INITIAL SCREEN.
     F*       12       SCREEN BUILD 2 - ENQUIRE SCREEN.
     F*       13       SCREEN BUILD 3 - AMEND SCREEN.
     F*       14       SCREEN BUILD 4 - CONFIRM AMENDMENT SCREEN.
     F*       15       SCREEN BUILD 5 - AMEND WARNING NUMBER SCREEN.
     F*
     F*       20       INPUT ERROR ON SCREEN BUILD 1 - ACTION CODE.
     F*       21       INPUT ERROR ON SCREEN BUILD 3 - RESERVE DEAL NO.
     F*       22       INPUT ERROR ON SCREEN BUILD 5 - WARNING DEAL NO.
     F*
     F*       30       FUTURES & OPTIONS MODE
     F*       31       SECURITY TRADES MODE
     F*       32       SECURITY DEPOT MOVEMENTS MODE
     F*
     F*       60       EOF/BEGINNING OF FILE ON READ COMMAND.
     F*
     F*       KC       CA03 INDICATOR
     F*       KL       CA12 INDICATOR
     F*       KN       CA14 INDICATOR
     F*
     F*       70       FILE PF/ZATNRGPD IS EMPTY.
     F*       71       RECORD ZATNRGP0 IS LOCKED EXTERNAL TO PROGRAM
     F*       72       FILE PF/ZAAV**PD IS EMPTY.
     F*
     F*       80
     F*       |        USED IN STANDARD SUBROUTINES
     F*       89
     F*
     F*          U7    SET ON WITH U8 IF A DATABASE ERROR OCCURS.
     F*          U8    FILE OUT OF BALANCE IF ON ON ITS OWN.
     F*                                                               *
      /EJECT
     F*****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZAAVFFL0  IF   E           K DISK    INFSR(*PSSR)
 
     FZAAVSDL0  IF   E           K DISK    INFSR(*PSSR)
 
     FZAAVSTL0  IF   E           K DISK    INFSR(*PSSR)
 
     FZATNRGL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ZATNRGD0:ZATNRG)
     FZATNRGL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FAPTRDNODF CF   E             WORKSTN INFSR(*PSSR)
     D*
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D**
     D DNATN           DS             5
     D**  DATA STRUCTURE TO UPDATE LAST TRANSACTION NUMBER DTARA.
     D  FNATN                  1      5  0
     D*
     D**
     D CMTTXT          DS            81
     D**  DATA STRUCTURE TO PROVIDE TEXT ON COMIT ENTRY IN JOURNAL.
     D  NATN                   1      5  0
     D  MDID                   6      7
     D  PGMN                   8     15
     D  WSIDX                 16     18
     D  MTIME                 19     24  0
     D  ACTCDX                25     25
     D  USRIDX                26     35
     D  SCRNX                 51     75
     D**  FIELDS COMPRISING SCRNX.
     D**  FIELD CONTAINING ACTION CODE.
     D  DDACTN                51     51
     D**  Field containing next trade number to be used
     D  DDNDLN                52     57  0
     D**  Field containing RESERVE trade number on file
     D**  (1st manual trade number)
     D  DDRDLN                58     63  0
     D**  Field containing next trade number to be generated
     D  DDTNBF                64     69  0
     D**  FIELD CONTAINING AMENDED RESERVE TRADE NO.
     D  DDARDN                70     75  0
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D** BANK DETAILS ACCESSED VIA ACCESS PROGRAM
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D RUNDAT          DS
     D** DATA STRUCTURE FOR MULTIBRANCH INDICATOR USING RUNDAT.
     D  @MBIN                 13     13
     D*
     D ZMUSER          DS            17
     D  DBRN                  11     13
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C*
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
     C**  INITIAL PROCESSING
     C                   EXSR      #A
     C*
     C**  MAIN PROCESSING
     C                   EXSR      #B
     C*
     C**  TERMINATION PROCESSING
     C                   EXSR      #C
     C*
     C     ENDPGM        TAG                                                    **ENDPGM**
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  INDEX TO SUBROUTINES - ORDER OF LISTING DUE TO FREQUENCY OF  *
     C*                         OF USAGE.                             *
     C*                                                               *
     C*   1. #B     - MAIN PROCESSING - OUTPUT AND AMENDMENT OF DATA. *
     C*   2. #BB    - PROCESS ENQUIRE - ENQUIRY ON DATA.              *
     C*   3. #BC    - HANDLE ERRORS ON INITIAL SCREEN.                *
     C*   4. #BA    - PROCESS AMEND - AMENDMENT OF DATA.              *
     C*   6. #BAB   - OUTPUT ERROR FOR PROCESS AMEND SCREEN.          *
     C*   8. #ZA    - CHAIN TO DEAL NO.RANGE MAINTENANCE FILE.        *
     C*   9. #ZAA   - CHAIN TO DEAL NO. RANGE MAINTENANCE FILE.       *
     C*  10. #ZAB   - READ  DEAL NO. RANGE MAINTENANCE FILE.          *
     C*  12. #ZC    - UPDATE DEAL NO. RANGE MAINTENANCE FILE.         *
     C*  13. #A     - INITIAL PROCESSING.                             *
     C*  14. #AA    - INITIALISATION.                                 *
     C*  15. #AB    - RETRIEVE INSTALLATION CONTROL DATA.             *
     C*  16. #AC    - ACCESS AVAILABLE TRANSACTION NUMBERS FILE       *
     C*  17. #C     - TERMINATION PROCESSING.                         *
     C*  18. *PSSR  - ERROR HANDLING SUBROUTINE.                      *
     C*                                                               *
     C*  PROGRAMS AND EXTERNAL SUBROUTINES CALLED.                    *
     C*                                                               *
     C*      ZA0240 - SENDS ERROR MSG TO PGMMSGQ  - CL PROGRAM        *
     C*      ZA0250 - CLEARS PGMMSGQ              - CL PROGRAM        *
     C*                                                               *
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #B     - MAIN PROCESSING; OUTPUT OF SCREENS AND  *
     C*                       AMENDMENT OF DEAL NO. RANGE MAINTENANCE *
     C*                       FILE.                                   *
     C*                                                               *
     C*  FIELDS DEFINED:      @RET  (1 BYTE ALPHA) IF = Y THEN RETURN *
     C*                             THE INITIAL SCREEN IS REQUIRED.   *
     C*                       @EPRM (10 BYTE ALPHA) ERROR MESSAGE ID  *
     C*                             PASSED TO EXT CL PGM ZA0240.      *
     C*                       @RLS  EXCEPTION NAME. USED TO RELEASE   *
     C*                             INTERNALLY LOCKED UPDATE FILE.    *
     C*                       @LOCK (1 BYTE ALPHA) 'Y' IF RECORD      *
     C*                             ZATNRGD0 LOCKED BY PROGRAM.       *
     C*                                                               *
     C*  CALLED BY : MAIN PROGRAM                                     *
     C*  CALLS     : #BA #BB #BC ZA0250                               *
     C*                                                               *
     C*****************************************************************
     C*
     C     #B            BEGSR
     C*
     C**  MAIN PROCESSING IS CARRIED OUT WHILST CMD3 IS NOT PRESSED
     C**  AND WHILST NO DATA BASE ERROR HAS OCCURRED
     C     *INKC         DOWEQ     '0'
     C     *INU7         ANDEQ     '0'
     C*
     C*
     C**  RETRIEVE CURRENT TIME, AND PLACE IN SCREEN FIELD
     C                   TIME                    DDTIME
     C*
     C**  IF NO ERROR ON ACTION CODE, BLANK OUT SCREEN FIELD.
     C     *IN20         IFEQ      '0'
     C*
     C                   MOVE      *BLANK        DDACTN
     C*
     C                   END
     C*
     C**  WRITE AND READ FIRST SCREEN
     C                   MOVE      '1'           *IN11
     C                   WRITE     APTRDNOD1
     C                   WRITE     APTRDNOD2
     C                   READ      APTRDNOD1                              60
     C*
     C**  VALIDATE SCREEN INPUT
     C*
     C**  IF CMD3 PRESSED GO TO END OF ROUTINE
     C     *INKC         CABEQ     '1'           #B9
     C*
     C**  IF CMD12 PRESSED GO TO END OF ROUTINE
     C     *INKL         CABEQ     '1'           #B9
     C*
     C**  RESET SCREEN INDICATOR  AND CALL EXTERNAL CL PGM ZA0250
     C**  TO CLEAR PROGRAM MESSAGE QUEUE.
     C                   MOVE      '0'           *IN11
     C                   MOVE      '0'           *IN20
     C                   CALL      'ZA0250'
     C*
     C**  IF CMD3 OR CMD12 NOT PRESSED, CHECK ACTION CODE ENTRY. IF NOT
     C**  'A' OR 'E', OUTPUT ERROR MESSAGE.
     C*
     C**  IF ACTION CODE IS TYPE 'A', EXECUTE #BA, PROCESS AMEND
     C     DDACTN        CASEQ     'A'           #BA
     C*
     C**  IF ACTION CODE IS TYPE 'E', EXECUTE #BB, PROCESS ENQUIRE
     C     DDACTN        CASEQ     'E'           #BB
     C**  IF ANY OTHER INPUT, EXECUTE #BC
     C                   CAS                     #BC
     C*
     C                   END
     C*
     C*
     C**  SET OFF LOGICAL FLAG @RET, WHICH CAUSES RETURN TO INITIAL
     C**  SCREEN FROM FILE UPDATE.
     C                   MOVE      'N'           @RET
     C*
     C                   END
     C*
     C     #B9           ENDSR                                                  **#B9**
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #BB    - PROCESS ENQUIRE; DISPLAYS CURRENT       *
     C*                       STATUS OF DEAL NUMBER RANGE MAINTENANCE *
     C*                       FILE.                                   *
     C*                                                               *
     C*  FIELDS DEFINED:                                              *
     C*                                                               *
     C*  CALLED BY : #B                                               *
     C*  CALLS     : #ZA                                              *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BB           BEGSR
     C*
      ** If multibranching, -
     C     @MBIN         IFEQ      'Y'
      **
      ** - check the action and default branch security
      **
     C                   CALL      'ZVACTBU'
     C                   PARM                    DDACTN
     C                   PARM                    DBRN
     C                   PARM                    @ERR
      **
     C     @ERR          IFNE      0
      ** Set code and message if ZVACTBU ended in error.
     C                   MOVE      '1'           *IN20
     C                   MOVEL     'FXM0290'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   GOTO      #BB9
     C                   END
      **
     C                   ELSE
      **
      ** If not multibranching check the user's action code
     C                   CALL      'ZVACTU'
     C                   PARM                    DDACTN
     C                   PARM                    @ERR              1 0
      **
     C     @ERR          IFNE      0
     C                   MOVE      '1'           *IN20
     C                   MOVEL     'FXM0292'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   GOTO      #BB9
     C                   END
      **
     C                   END
     C*
     C**  READ ENQUIRY LOGICAL VIEW OF DEAL NO. FILE, LF/ZATNRGL1
     C                   EXSR      #ZA
     C*
     C**  IF *INU7 IS ON, GO TO END OF SUBROUTINE
     C     *INU7         CABEQ     '1'           #BB9
     C*
     C**  SET UP SCREEN FIELDS FOR OUTPUT TO SCREEN
     C                   MOVE      'E'           DDACTN
     C                   Z-ADD     FNOR          DDRDLN
     C                   Z-ADD     TNBF          DDTNBF
     C*
     C**  RETRIEVE CURRENT TIME, AND PLACE IN SCREEN FIELD
     C                   TIME                    DDTIME
     C*
     C**  WRITE AND READ ENQUIRE SCREEN
     C                   MOVE      '1'           *IN12
     C                   WRITE     APTRDNOD1
     C                   READ      APTRDNOD1                              60
     C*
     C**  RESET SCREEN INDICATOR
     C                   MOVE      '0'           *IN12
     C*
     C**  IF CMD12 PRESSED ON SUBSEQUENT SCREEN, NO EXIT IS REQUIRED
     C**  THEREFORE SET OFF *INKL.
     C                   MOVE      '0'           *INKL
     C*
     C     #BB9          ENDSR                                                  **#BB9**
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #BC    - ROUTINE TO HANDLE ERROR ON INPUT TO     *
     C*                       INITIAL SCREEN.                         *
     C*                                                               *
     C*                                                               *
     C*  FIELDS DEFINED:      @EPRM (10 BYTE ALPHA) ERROR MESSAGE ID  *
     C*                             PASSED TO EXT CL PGM ZA0240.      *
     C*                                                               *
     C*  CALLED BY : #B                                               *
     C*  CALLS     : ZA0240                                           *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BC           BEGSR
     C*
     C*
     C**  THE ACTION CODE HAS BEEN INCORRECTLY ENTERED; INDICATOR
     C**  *IN20 IS SET ON AND THE ERROR ID IS MOVED INTO THE PARAMETER
     C**  OF ZA0240, THE EXTERNAL PROGRAM WHICH  FILLS THE MESSAGE
     C**  SUBFILE.
     C                   MOVE      '1'           *IN20
     C                   MOVEL     'FDM0101'     @EPRM            10
     C                   CALL      'ZA0240'
     C                   PARM                    @EPRM
     C*
     C     #BC9          ENDSR                                                  **#BC9**
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #BA    - PROCESS AMEND; ALLOWS CHANGE OF RESERVE *
     C*                       DEAL NO., AND, IF REQUIRED, WARNING DEAL*
     C*                       NO.                                     *
     C*                                                               *
     C*  FIELDS DEFINED:      @EPRM (10 BYTE ALPHA) ERROR MESSAGE ID  *
     C*                             PASSED TO EXT CL PGM ZA0240.      *
     C*                       @RLS  EXCEPTION NAME. USED TO RELEASE   *
     C*                             INTERNALLY LOCKED UPDATE FILE.    *
     C*                     @LOCK  - (1 BYTE ALPHA) 'Y' IF RECORD     *
     C*                              ZATNRGD0 LOCKED BY PROGRAM.      *
     C*                                                               *
     C*  CALLED BY : #B                                               *
     C*  CALLS     : #BAA #BAB #ZA #ZC ZA0250                         *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BA           BEGSR
     C*
      ** If multibranching, -
     C     @MBIN         IFEQ      'Y'
      **
      ** - check the action and default branch security
      **
     C                   CALL      'ZVACTBU'
     C                   PARM                    DDACTN
     C                   PARM                    DBRN
     C                   PARM                    @ERR
      **
     C     @ERR          IFNE      0
      ** Set code and message if ZVACTBU ended in error.
     C                   MOVE      '1'           *IN20
     C                   MOVEL     'FXM0290'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   GOTO      #BA9
     C                   END
      **
     C                   ELSE
      **
      ** If not multibranching check the user's action code
     C                   CALL      'ZVACTU'
     C                   PARM                    DDACTN
     C                   PARM                    @ERR              1 0
      **
     C     @ERR          IFNE      0
     C                   MOVE      '1'           *IN20
     C                   MOVEL     'FXM0292'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   GOTO      #BA9
     C                   END
      **
     C                   END
     C*
     C**  AMEND PROCESSING IS CARRIED OUT WHILST CMD3 IS NOT PRESSED
     C**  AND WHILST NO DATA BASE ERROR HAS OCCURRED
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C     *INU7         ANDEQ     '0'
     C*
     C**  IF RECORD NOT ALREADY CHAINED TO, CHAIN TO DEAL NO. FILE.
     C     @LOCK         IFEQ      'N'
     C*
     C                   EXSR      #ZA
     C*
     C**  IF *INU7 IS ON, GO TO END OF SUBROUTINE
     C     *INU7         CABEQ     '1'           #BA9
     C*
     C**  IF *IN71 IS ON, THEN THE RECORD IS LOCKED EXTERNALLY.
     C     *IN71         IFEQ      '1'
     C*
     C*
     C**  CALL EXTERNAL CL PGM ZA0250
     C**  TO CLEAR PROGRAM MESSAGE QUEUE.
     C                   MOVE      '0'           *IN21
     C                   CALL      'ZA0250'
     C                   MOVEL     'FDM0120'     @EPRM
     C*
     C**  OUTPUT MESSAGE TO SCREEN TO INDICATE RECORD LOCKED EXTERNALLY
     C                   CALL      'ZA0240'
     C                   PARM                    @EPRM
     C*
     C                   GOTO      #BA9
     C*
     C                   END
     C*
     C                   END
     C*
     C**  SET UP SCREEN FIELDS FOR OUTPUT TO SCREEN
     C                   MOVE      'A'           DDACTN
     C                   Z-ADD     FNOR          DDRDLN
     C                   Z-ADD     FNOR          DDARDN
     C                   Z-ADD     TNBF          DDTNBF
     C*
     C**  RETRIEVE CURRENT TIME, AND PLACE IN SCREEN FIELD
     C                   TIME                    DDTIME
     C*
     C****IF RESERVE DEAL NO. NOT INCORRECT, BLANK OUT SCREEN FIELD.
     C**** *IN21         IFEQ      '0'
     C*
     C*******            Z-ADD     *ZEROS        DDARDN
     C*
     C*******            END
     C*
     C**  WRITE AND READ AMEND SCREEN
     C                   MOVE      '1'           *IN13
     C                   WRITE     APTRDNOD1
     C                   WRITE     APTRDNOD2
     C                   READ      APTRDNOD1                              60
     C*
     C**  VALIDATE SCREEN INPUT
     C*
     C**  IF CMD3 PRESSED GO TO END OF ROUTINE
     C     *INKC         CABEQ     '1'           #BA9
     C*
     C**  CALL EXTERNAL CL PGM ZA0250
     C**  TO CLEAR PROGRAM MESSAGE QUEUE.
     C                   MOVE      '0'           *IN21
     C                   CALL      'ZA0250'
     C*
     C**  IF EXIT TO PREVIOUS SCREEN REQUIRED UPDATE OPERATION IS ENDED
     C**  - RELEASE UPDATE FILE LF/ZATNRGL0
     C     *INKL         IFEQ      '1'
     C*
     C**  RESET SCREEN INDICATOR
     C                   MOVE      '0'           *IN13
     C*
     C                   EXCEPT    @RLS
     C*
     C**  SET FLAG @LOCK TO 'N' TO SHOW RECORD NOT LOCKED.
     C                   MOVE      'N'           @LOCK
     C*
     C                   END
     C*
     C**  IF CMD12 PRESSED GO TO END OF ROUTINE
     C     *INKL         CABEQ     '1'           #BA9
     C*
     C**  DEPENDING ON THE INPUT VALUE FOR THE AMENDED RESERVE DEAL
     C**  NO., CALL THE RELEVANT SUBROUTINE.
     C*
     C**  If the amended first manual trade number is greater than the
     C**  next trade no. to be generated (or used) update the file
     C     DDARDN        IFGT      TNBF
     C     DDARDN        ANDGT     TNBR
     C                   EXSR      #ZC
     C*
     C**  If the amended first manual trade number is equal to or less
     C**  than thenext trade no. to be generated then error message is
     C**  output.
     C                   ELSE
     C                   EXSR      #BAB
     C                   END
     C*
     C**  RESET SCREEN INDICATOR
     C                   MOVE      '0'           *IN13
     C*
     C**  IF CMD12 PRESSED ON SUBSEQUENT SCREEN, NO EXIT IS REQUIRED
     C**  UNLESS LOGICAL FLAG @RET = 'Y'
     C     @RET          IFEQ      'N'
     C*
     C                   MOVE      '0'           *INKL
     C*
     C                   END
     C*
     C                   END
     C*
     C     #BA9          ENDSR                                                  **#BA9**
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #BAB   - OUTPUT ERROR MESSAGE IF INVALID DATA    *
     C*                       ENTERED ON AMEND SCREEN.                *
     C*                                                               *
     C*                                                               *
     C*  FIELDS DEFINED:      @EPRM (10 BYTE ALPHA) ERROR MESSAGE ID  *
     C*                             PASSED TO EXT CL PGM ZA0240.      *
     C*                                                               *
     C*  CALLED BY : #BA                                              *
     C*  CALLS     : ZA0240                                           *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BAB          BEGSR
     C*
     C**  SET UP PARAMETER FOR ERROR MESSAGE AND CALL CL PGM ZA0240
     C                   MOVE      '1'           *IN21
     C                   MOVEL     'FDM0069'     @EPRM
     C                   CALL      'ZA0240'
     C                   PARM                    @EPRM
     C*
     C     #BAB9         ENDSR                                                  **#BAB9**
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #ZA    - ACCESS DEAL NO. RANGE MAINTENANCE FILE  *
     C*                                              LF/ZATNRGL0      *
     C*                                                               *
     C*                                                               *
     C*  FIELDS DEFINED:                                              *
     C*                                                               *
     C*  CALLED BY : #BA #BB                                          *
     C*  CALLS     : #ZAA #ZAB                                        *
     C*                                                               *
     C*****************************************************************
     C*
     C     #ZA           BEGSR
     C*
     C**  CALL SUBROUTINE TO READ FILE
     C*
     C**  IF ACTION CODE IS 'A', ACCESS LF/ZATNRGL0.
     C     DDACTN        CASEQ     'A'           #ZAA
     C*
     C**  IF ACTION CODE IS 'E', ACCESS LF/ZATNRGL1.
     C     DDACTN        CASEQ     'E'           #ZAB
     C*
     C                   END
     C*
     C     #ZA9          ENDSR                                                  **#ZA9**
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #ZAA - CHAIN TO DEAL NO. RANGE MAINTENANCE FILE  *
     C*                                              LF/ZATNRGL0      *
     C*                                                               *
     C*  FIELDS DEFINED:                                              *
     C*                     @KEY   - (1 BYTE NUMERIC) KEY USED TO     *
     C*                              ACCESS LF/ZATNRGL0               *
     C*                     @LOCK  - (1 BYTE ALPHA) 'Y' IF RECORD     *
     C*                              ZATNRGD0 LOCKED BY PROGRAM.      *
     C*                                                               *
     C*  CALLED BY : #ZA                                              *
     C*  CALLS     :                                                  *
     C*                                                               *
     C*****************************************************************
     C*
     C     #ZAA          BEGSR
     C*
     C**  Access record on file LF/ZATNRGL0
     C*
     C     @KEY          CHAIN     ZATNRGL0                           7071
     C*
     C** DEAL WITH DATA BASE ERROR
     C     *IN70         IFEQ      '1'                                          ***************
     C                   MOVEL     'ZATNRGL0'    DBFILE                         *             *
     C                   MOVE      *BLANKS       DBKEY                          * DBERROR 910 *
     C                   MOVEL     '910'         DBASE                          *             *
     C                   END                                                    ***************
     C*
     C**  IF *IN71 IS '0' THE RECORD HAS BEEN CHAINED TO AND LOCKED BY
     C**  THE PROGRAM.
     C     *IN71         IFEQ      '0'
     C*
     C                   MOVE      'Y'           @LOCK
     C*
     C                   END
     C*
     C     #ZAA9         ENDSR                                                  **#ZAA9**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #ZAB - READ DEAL NO. RANGE MAINTENANCE FILE      *
     C*                                              LF/ZATNRGL1      *
     C*                                                               *
     C*  FIELDS DEFINED:                                              *
     C*                     @KEY   - (1 BYTE NUMERIC) KEY USED TO     *
     C*                              ACCESS LF/ZATNRGL1               *
     C*                                                               *
     C*  CALLED BY : #ZA                                              *
     C*  CALLS     :                                                  *
     C*                                                               *
     C*****************************************************************
     C*
     C     #ZAB          BEGSR
     C*
     C**  Access record on file LF/ZATNRGL1
     C**  NOTE THAT RECORD NAME USED IS ZATNRG DUE TO RENAME OPERATION
     C**  IN FILE SPECS.
     C*
     C     @KEY          CHAIN     ZATNRGL1                           70
     C*
     C** DEAL WITH DATA BASE ERROR
     C     *IN70         IFEQ      '1'                                          ***************
     C                   MOVEL     'ZATNRGL1'    DBFILE                         *             *
     C                   MOVE      *BLANKS       DBKEY                          * DBERROR 910 *
     C                   MOVEL     '910'         DBASE                          *             *
     C                   END                                                    ***************
     C*
     C     #ZAB9         ENDSR                                                  **#ZAB9**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #ZC    - UPDATE DEAL NO. FILE; UPDATES DEAL NO.  *
     C*                       RANGE FILE,CHAINS TO FILE AGAIN IN CASE *
     C*                       FURTHER PROCESSING IS REQUIRED.         *
     C*                                                               *
     C*  FIELDS DEFINED:      @RET  (1 BYTE ALPHA) IF = Y THEN RETURN *
     C*                             TO THE INITIAL SCREEN IS REQUIRED.*
     C*                       @LOCK (1 BYTE ALPHA) 'Y' IF RECORD      *
     C*                             ZATNRGD0 LOCKED BY PROGRAM.       *
     C*                                                               *
     C*  CALLED BY : #B                                               *
     C*  CALLS     : ZTNLU1                                           *
     C*                                                               *
     C*****************************************************************
     C*
     C     #ZC           BEGSR
     C*
     C**  UPDATE DEAL NO. RANGE MAINTENANCE FILE - CLEAR FIELDS
     C                   Z-ADD     *ZEROS        LCD
     C                   MOVE      *BLANKS       CHTP
     C                   Z-ADD     *ZEROS        TNLU
     C*
     C**  IF NEXT MANUAL TRADE NO. HAS BEEN AMENDED SET UP THAT
     C**  FIELD.
     C     *IN13         IFEQ      '1'
     C                   Z-ADD     DDARDN        FNOR
     C                   END
     C*
     C*  LOAD DATE FIELDS.
     C                   Z-ADD     BJRDNB        LCD
     C*
     C**  IF *INU7 IS ON, GO TO END OF SUBROUTINE
     C     *INU7         CABEQ     '1'           #ZC9
     C*
     C** SET UP REMAINING FIELDS
     C                   MOVE      DDACTN        CHTP
     C*
     C**  IF NO PROBLEMS IN SETTING UP FOR UPDATE,
     C**  UPDATE FILE.
     C*
     C**  OBTAIN LAST TRANSACTION NUMBER AND PREPARE STANDARD
     C**  INFORMATION FOR CMTTXT DATA STRUCTURE.
     C                   EXSR      ZTNLU1
     C                   MOVE      'FD'          MDID
     C                   MOVEL     'APTRDNOMNT'  PGMN
     C                   TIME                    MTIME             6 0
     C                   MOVE      DDACTN        ACTCDX
     C                   MOVE      PSUser        USRIDX
     C*
     C**  UPDATE FILE
     C                   UPDATE    ZATNRGD0
     C                   MOVEL     'FDM0904'     @MSGID           10
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C*
     C**  END OF COMMITTMENT CYCLE
     C     CMTTXT        COMMIT
     C*
     C**  SET FLAG @LOCK TO 'N' TO INDICATE THAT RECORD HAS BEEN RELEASED
     C                   MOVE      'N'           @LOCK
     C*
     C**  SETON CMD12 INDICATOR TO RETURN CONTROL TO THE INITIAL SCREEN
     C**  ALSO SET ON LOGICAL FLAG TO ALLOW RETURN THROUGH ALL LEVELS
     C**  OF PROCESSING.
     C                   MOVE      'Y'           @RET              1
     C                   MOVE      '1'           *INKL
     C*
     C     #ZC9          ENDSR                                                  **#ZC9**
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE:  #A  - INITIAL PROCESSING; INITIALISATION AND    *
     C*                     RETRIEVAL OF ICD AND USER DATA.           *
     C*                                                               *
     C*  FIELDS DEFINED:                                              *
     C*                                                               *
     C*                                                               *
     C*                                                               *
     C*  CALLED BY :  MAIN PROGRAM                                    *
     C*  CALLS     :  #AA #AB #AC                                     *
     C*                                                               *
     C*****************************************************************
     C*
     C     #A            BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    ModuleID          2
     C                   PARM                    TransType         1
     C*
     C     @KEY          KLIST
     C                   KFLD                    @ModuleID         2
     C                   KFLD                    @TransType        1
     C*
     C**  Set up Key to chain to Transaction range file
     C                   MOVE      ModuleID      @ModuleID
     C                   MOVE      TransType     @TransType
     C*
     C**  MOVE PROGRAM NAME INTO LDA IN CASE OF DATABASE ERROR
     C                   MOVEL     'APTRDNOMNT'  DBPGM
      *                                                                                       222393
      ** Setup the values of the message IDs to be retrieved in                               222393
      ** message file ZZGBMSGF.                                                               222393
      *                                                                                       222393
     C                   MOVEL     'APA1045'     NXTAUTOUSE                                   222393
     C                   MOVEL     'APA1046'     RNGSTRT                                      222393
     C                   MOVEL     'APA1047'     NXTAUTOGEN                                   222393
     C                   MOVEL     'APA1051'     SCNHEAD                                      222393
     C*
     C**  INITIALISE PROGRAM VARIABLES AND INDICATORS
     C                   EXSR      #AA
     C*
     C**  RETRIEVE INSTALLATION CONTROL DATA
     C                   EXSR      #AB
     C*
     C**  IF *INU7 IS ON, GO TO END OF SUBROUTINE
     C     *INU7         CABEQ     '1'           #A9
     C*
     C**  RETRIEVE USER INFORMATION
     C**  - MOVE USER AND WORKSTATION ID INTO SCREEN
     C                   MOVEL     PSJobName     DDWID
     C*
     C** READ DATA AREA - RUNDAT
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C**  GET ZMUSER to access default branch.
     C**
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
     C*
     C** Access Available Transactions File
     C                   EXSR      #AC
     C*
     C     #A9           ENDSR                                                  **#A9**
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #AA  - INITIALISATION; PROGRAM VARIABLES AND     *
     C*                     INDICATORS INITIALISED.                   *
     C*                                                               *
     C*                                                               *
     C*  FIELDS DEFINED:      @RET   (1 BYTE ALPHA) IF = Y THEN RETURN*
     C*                              THE INITIAL SCREEN IS REQUIRED.  *
     C*                       @LOCK (1 BYTE ALPHA) 'Y' IF RECORD      *
     C*                             ZATNRGD0 LOCKED BY PROGRAM.       *
     C*                                                               *
     C*  CALLED BY : #A                                               *
     C*  CALLS     :                                                  *
     C*                                                               *
     C*****************************************************************
     C*
     C     #AA           BEGSR
     C*
     C**  SETON INDICATOR FOR SFLEND FOR MESSAGE SUBFILE
     C                   MOVE      '1'           *IN10
     C*
     C**  SETUP PROGRAM MESSAGE QUEUE FIELD FOR MESSAGE SUBFILE
     C                   MOVEL     '*'           PGMQ
     C*
     C**  INITIALISE NUMERIC FIELDS IN DATA STRUCTURES TO PREVENT
     C**  DECIMAL DATA ERRORS.
     C                   Z-ADD     0             NATN
     C                   Z-ADD     0             MTIME
     C                   Z-ADD     0             DDNDLN
     C                   Z-ADD     0             DDRDLN
     C                   Z-ADD     0             DDARDN
     C                   Z-ADD     0             DDTNBF
     C*
     C                   MOVE      '0'           *IN30
     C                   MOVE      '0'           *IN31
     C                   MOVE      '0'           *IN32
     C*
     C**  INITIALISE LOGICAL FLAG FOR RECORDS PRESENT ON FILE
     C**  AND RETURN TO INITIAL SCREEN REQUIRED.
     C                   MOVE      'N'           @RET
     C*
     C**  INITIALISE FLAG INDICATING WHETHER RECORD ZATNRGD0 LOCKED.
     C                   MOVE      'N'           @LOCK             1
     C*
     C     #AA9          ENDSR                                                   **#AA9**
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #AB  - RETRIEVE INSTALLATION CONTROL DATA; READ  *
     C*                     PF/SDBANKPD.                              *
     C*                                                               *
     C*                                                               *
     C*  FIELDS DEFINED:                                              *
     C*                                                               *
     C*                                                               *
     C*  CALLED BY : #A                                               *
     C*  CALLS     : NONE                                             *
     C*                                                               *
     C*****************************************************************
     C*
     C     #AB           BEGSR
     C*
     C*   Call AOBANKR0 to access installation control data.
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C     #AB9          ENDSR                                                  **#AB9**
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #AC  - Access Available Transactions file        *
     C*                                                               *
     C*                                                               *
     C*  FIELDS DEFINED:                                              *
     C*                                                               *
     C*                                                               *
     C*  CALLED BY : #A                                               *
     C*  CALLS     : NONE                                             *
     C*                                                               *
     C*****************************************************************
     C*
     C     #AC           BEGSR
     C*
     C** File to be accessed depends on parameters passed.
     C*
     C** Futures & Options
     C     ModuleID      IFEQ      'FF'
     C     *LOVAL        SETLL     ZAAVFFL0
     C                   READ      ZAAVFFL0                               72
     C                   MOVE      '1'           *IN30
     C                   END
     C*
     C** Security Trades
     C     ModuleID      IFEQ      'SE'
     C     TransType     ANDEQ     'T'
     C     *LOVAL        SETLL     ZAAVSTL0
     C                   READ      ZAAVSTL0                               72
     C                   MOVE      '1'           *IN31
     C                   END
     C*
     C** Security Depot Movements
     C     ModuleID      IFEQ      'SE'
     C     TransType     ANDEQ     'D'
     C     *LOVAL        SETLL     ZAAVSDL0
     C                   READ      ZAAVSDL0                               72
     C                   MOVE      '1'           *IN32
     C                   END
     C*
     C** Set up Next Trade Number to be used.
     C** (if no records on file default to 1)
     C     *IN72         IFEQ      '0'
     C                   Z-ADD     TNBR          DDNDLN
     C                   ELSE
     C                   Z-ADD     1             DDNDLN
     C                   END
     C*
     C     #AC9          ENDSR                                                  **#AB9**
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #C     - TERMINATION PROCESSING;  OUTPUTS DATA   *
     C*                       BASE ERROR IF APPROPRIATE AND PRINTS    *
     C*                       FINAL AUDIT REPORT FORMAT.              *
     C*                                                               *
     C*  FIELDS DEFINED:                                              *
     C*                                                               *
     C*  CALLED BY : MAIN PROGRAM                                     *
     C*  CALLS     :                                                  *
     C*                                                               *
     C*****************************************************************
     C*
     C     #C            BEGSR
     C*
     C**  SET ON *INLR TO TERMINATE THE PROGRAM.
     C                   MOVE      '1'           *INLR
     C*
     C     #C9           ENDSR                                                  **#C9**
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: ZTNLU1 - SR TO LOCK, UPDATE AND RELEASE THE     *
     C*                       TRANSACTION NUMBER DATA AREA.           *
     C*                                                               *
     C*  FIELDS DEFINED:                                              *
     C*                                                               *
     C*  CALLED BY : #ZC                                              *
     C*  CALLS :                                                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     ZTNLU1        BEGSR
     C*
     C     *DTAARA       DEFINE    MNATN         DNATN
     C     *LOCK         IN        DNATN
     C                   MOVE      FNATN         NATN              5 0
     C                   MOVE      FNATN         ZZWK05            5 0
     C                   ADD       1             ZZWK05
     C                   MOVE      ZZWK05        FNATN
     C                   OUT       DNATN
     C*
     C     ZTNLU9        ENDSR                                                   **ZTNLU9**
      /EJECT
      ****************************************************************
      **------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------------
      ****************************************************************
      /EJECT
     OZATNRGD0  E            @RLS
** CPY@
(c) Finastra International Limited 2001

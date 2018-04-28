     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Authority Types Maintenance')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000115 - Midas Authority Types Maintenance                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. AR797240           Date 30Jun11               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR797240 - New standing data tables available in the         *
      *             maintenance menu are not available in the         *
      *             enquiry menu                                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT031 Last change date is incorrect.                *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  USE OF INDICATORS                                            *
      *                                                               *
      *    U7+U8 - Database error occurs                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRLoad - Load Subfile                                        *
      *  SREndKy  - Update end keys and variables for file/subfilel   *
      *  SRReset - Clear/Reset Subfile                                *
      *  SRRepos - Reposition file                                    *
      *  SRPgdn - Subfile page down                                   *
      *  SREntKy - Process enter key after subfile display            *
      *  SRF03sr - F03 key subroutine                                 *
      *  SRF05sr - F05 key subroutine                                 *
      *  SRF09sr - F09 key subroutine - toggle between add and        *
      *            change mode                                        *
      *  SRSfLrc - Process subfile records after enter                *
      *  SRDelet - Delete subroutine                                  *
      *  SRRmvMs - Remove program messages                            *
      *  SRSndMs - Send program messages                              *
      *  SRValid - Perform Validation                                 *
      *  *PSSR - Program exception error routine                      *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Display file
      *
     FSD000115DFCF   E             WORKSTN INFDS(WSDS)
     F                                     SFILE(SD000115S0:SFLRN)
      *
      ** Authority Types - Update Index
      *
     FSDAUTPL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDAUTPD0:UPDAT)
      *
      ** Authority Types - Retrieval Index
      *
     FSDAUTPL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDAUTPD0:RETRIV)
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      ** Alpha-numeric array
      *
     D ArrChk          S             36A   DIM(1) CTDATA PERRCD(1)
      *
      ** Standard include for interactive programs
      ** Named hexadecimal constants for function keys
      *
     D WF01            C                   CONST(X'31')
     D WF02            C                   CONST(X'32')
     D WF03            C                   CONST(X'33')
     D WF04            C                   CONST(X'34')
     D WF05            C                   CONST(X'35')
     D WF06            C                   CONST(X'36')
     D WF07            C                   CONST(X'37')
     D WF08            C                   CONST(X'38')
     D WF09            C                   CONST(X'39')
     D WF10            C                   CONST(X'3A')
     D WF11            C                   CONST(X'3B')
     D WF12            C                   CONST(X'3C')
     D WF13            C                   CONST(X'B1')
     D WF14            C                   CONST(X'B2')
     D WF15            C                   CONST(X'B3')
     D WF16            C                   CONST(X'B4')
     D WF17            C                   CONST(X'B5')
     D WF18            C                   CONST(X'B6')
     D WF19            C                   CONST(X'B7')
     D WF20            C                   CONST(X'B8')
     D WF21            C                   CONST(X'B9')
     D WF22            C                   CONST(X'BA')
     D WF23            C                   CONST(X'BB')
     D WF24            C                   CONST(X'BC')
     D WCLEAR          C                   CONST(X'BD')
     D WENTER          C                   CONST(X'F1')
     D WHELP           C                   CONST(X'F3')
     D WPAGUP          C                   CONST(X'F4')
     D WPAGDN          C                   CONST(X'F5')
      *
      ** Program Constants
      *
     D WALL            C                   CONST('*ALL')
     D WDIAG           C                   CONST('*DIAG')
     D WCUSTK          C                   CONST(0)
     D WCUQUE          C                   CONST('*')
      *                                                                                     AR797240
      ** Parameters                                                                         AR797240
      *                                                                                     AR797240
     D PMode           S              1A                                                    AR797240
      *
      ** Message Related Fields
      *
     D  PMsgId         S              7A
     D  PMsgF          S             10A
     D  PMsgTxt        S            132A
     D  PaPgrl         S              5A
     D  PMsgTyp        S              7A
     D  PMsgq          S             10A
      *
      ** Standard include for all interactive programs
      ** Display file information data structure
      *
     D WSDS            DS
      *
      ** Identifies the Key Pressed
      *
     D  KEY                  369    369
      *
      ** Identifies the Subfile Page RRN
      *
     D  PAGRRN               378    379B 0
      *
      ** Run Date
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Work Fields
      *
     D WPos            S              5U 0
     D WExit           S              1A
     D WMode           S              3A
     D WErr            S              1A
     D SFLRN           S              4P 0
     D WEndRn          S              4P 0
     D WCount          S              2P 0
     D WErrn           S              3P 0
     D WDFlag          S              6A
     D WDesc           S             30A
     D WAutyp          S              2A
     D WAlpha          S             36A
     D WTemp           S              2P 0
      *
      *****************************************************************
      * Reset variables and clear subfile                             *
      * In case program called again after *INLR = *OFF               *
      * ensures that program starts again properly                    *
      *****************************************************************
      *
     C                   RESET                   WExit
     C                   EXSR      SRReset
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C                   EXSR      SRLoad
      *
      ** Perform until Exit requested Using F03
      *
     C     WExit         DOUEQ     *ON
      *
      ** Set Time
      *
     C                   TIME                    DDTME
      *
     C                   WRITE     SD000115F0
     C                   WRITE     SD000115M1
     C                   EXFMT     SD000115C0
      *
     C                   Z-ADD     PAGRRN        DDSFRC
      *
      ** Process Response
      *
     C     KEY           CASEQ     WF03          SRF03sr
     C     KEY           CASEQ     WF05          SRF05sr
     C     KEY           CASEQ     WF09          SRF09sr
     C     KEY           CASEQ     WPAGDN        SRPgdn
     C                   CAS                     SREntKy
     C                   ENDCS
      *
     C                   ENDDO
      *
      ** End of program
      *
     C                   EVAL(R)   *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *                                                                                     AR797240
      ** Entry Parameter                                                                    AR797240
      *                                                                                     AR797240
     C     *ENTRY        PLIST                                                              AR797240
     C                   PARM                    PMode                                      AR797240
      *
      ** Retrieve run date from data area RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   EVAL(R)   DDMRDT = AGMRDT
      *
      ** Create program exit flag and set value to off
      *
     C                   EVAL(R)   WExit = *OFF
      *
      ** Miscellaneous subfile program variables
      *
     C                   Z-ADD     0             SFLRN
     C                   Z-ADD     0             WEndRn
     C                   Z-ADD     0             WCount
     C                   Z-ADD     1             DDSFRC
      *
     C                   EVAL(R)   WMode = 'CHG'
      *
     C                   EVAL      DDUSR = PSUser
     C                   EVAL      DDPGM = PSProcName
     C                   EVAL      DDJOB = PSJobName
      *
     C     *LIKE         DEFINE    AUATYP        EATYP
      *
      ** End key for repositioning subfile
      *
     C     KLEndKey      KLIST
     C                   KFLD                    EATYP
      *
      ** Update key for updating and deleting - use hidden fields
      *
     C     KLUpdKey      KLIST
     C                   KFLD                    D1HIDA
      *
      ** Key to Prevent duplicate keys being written
      *
     C     KLPrvKey      KLIST
     C                   KFLD                    D1ATYP
      *
      ** Display the screen according to Mode ('M' Maintenance 'E' Enquiry)                 AR797240
      *                                                                                     AR797240
     C                   IF        PMode = 'E'                                              AR797240
     C                   EVAL      *In80 = *On                                              AR797240
     C                   ENDIF                                                              AR797240
      *                                                                                     AR797240
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoad - Load Subfile                                        *
      *                                                               *
      *  Called by: MAIN processing, SRRepos, SRPgdn                  *
      *                                                               *
      *  Calls: SREndKy, SRSndMs                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRLoad        BEGSR
      *
     C                   Z-ADD     0             WCount
      *
     C                   IF        WMode = 'CHG'
      *
      ** Read a page of records or until EOF
      *
     C                   EXSR      SRReset
     C     WCount        DOWLT     14
     C                   READ      SDAUTPL1                               99
      *
     C                   IF        %EOF(SDAUTPL1)
     C                   LEAVE
     C                   ELSE
      *
      ** If selection check whether record wanted
      ** Authority Description
      *
     C                   IF        D2DESC <> *BLANKS
     C                   EVAL      WPos = %SCAN(%TRIM(D2DESC):AUDESC)
     C     WPos          CABLT     1             NEXT
     C                   ENDIF
      *
      ** Move Database contents into subfile fields
      *
     C                   EVAL(R)   D1SEL = *BLANKS
     C                   EVAL(R)   D1ATYP = AUATYP
     C                   EVAL(R)   D1ATYD = AUATYP
     C                   EVAL(R)   D1DESC = AUDESC
      *
      ** Populate hidden fields in subfile record
      *
     C                   EVAL(R)   D1HIDA = AUATYP
      *
     C                   ADD       1             WCount
     C                   ADD       1             SFLRN
     C                   WRITE     SD000115S0
     C                   ENDIF
      *
     C     NEXT          TAG
      *
     C                   ENDDO
      *
      ** Set endkey values
      *
     C                   EXSR      SREndKy
      *
      ** If not EOF, read one more record to make sure.
      *
     C                   IF        NOT %EOF(SDAUTPL1)
     C                   READ      SDAUTPL1                               99
     C                   ENDIF
      *
     C                   ELSE
      *
      ** In 'ADD' mode initialise the subfile with blank records
      *
     C                   DO        42
     C                   CLEAR                   SD000115S0
     C                   ADD       1             SFLRN
     C                   WRITE     SD000115S0
     C                   ENDDO
     C                   Z-ADD     SFLRN         WEndRn
      *
     C                   ENDIF
      *
      ** If no records were added to subfile, set error indicators.
      *
     C                   IF        SFLRN = *ZEROS
     C                   EVAL(R)   *IN42 = *OFF
     C                   EVAL      PMsgId = 'Y2U0008'
     C                   EVAL      PMsgF = 'Y2USRMSG'
     C                   EXSR      SRSndMs
     C                   ELSE
      *
      ** Else, set indicators to display subfile.
      *
     C                   EVAL(R)   *IN42 = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndKy - Update end keys and variables for file/subfile     *
      *                                                               *
      *  Called by: SRLoad                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SREndKy       BEGSR
      *
     C                   EVAL(R)   EATYP = AUATYP
     C                   Z-ADD     SFLRN         WEndRn
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReset - Clear/Reset Subfile                                *
      *                                                               *
      *  Called by: MAIN processing, SRRepos                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRReset       BEGSR
      *
      ** Clear subfile and reset subfile display indicator.
      *
     C                   EVAL(R)   *IN40 = *ON
     C                   WRITE     SD000115C0
     C                   EVAL(R)   *IN40 = *OFF
     C                   EVAL(R)   *IN42 = *OFF
     C                   EVAL(R)   *IN33 = *OFF
     C                   EVAL(R)   *IN32 = *OFF
     C                   EXSR      SRRmvMs
      *
      ** Reset subfile record number and subfile position fields.
      *
     C                   RESET                   SFLRN
     C                   RESET                   WEndRn
     C                   RESET                   DDSFRC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRepos - Reposition file                                    *
      *                                                               *
      *  Called by: SREntKy, SRF05sr, SRF09sr                         *
      *                                                               *
      *  Calls: SRReset, SRLoad                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRRepos       BEGSR
      *
      ** Clear subfile
      *
     C                   EXSR      SRReset
      *
      ** Reposition file to beginning
      *
     C     D2ATYP        SETLL     SDAUTPL1
     C                   EXSR      SRLoad
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPgdn - Subfile page down                                   *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: SRLoad                                                *
      *                                                               *
      *****************************************************************
      *
     C     SRPgdn        BEGSR
      *
      ** Only do if not EOF
      *
     C                   IF        *IN99 = *OFF
      *
      ** Continue with record after the last one read.
      *
     C     KLEndKey      SETGT     SDAUTPL1
     C                   Z-ADD     WEndRn        SFLRN
     C                   EXSR      SRLoad
      *
      ** Set cursor position to first record on next page
      *
     C                   IF        WMode = 'CHG'
     C     SFLRN         SUB       WCount        DDSFRC
     C     DDSFRC        ADD       1             DDSFRC
     C                   ELSE
     C     SFLRN         SUB       41            DDSFRC
     C                   ENDIF
      *
      ** Page down beyond end of subfile
      *
     C                   ELSE
     C                   EVAL(R)   *IN60 = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREntKy - Process enter key after subfile display            *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: SRSfLrc, SRRepos                                      *
      *                                                               *
      *****************************************************************
      *
     C     SREntKy       BEGSR
      *
      ** Process subfile records
      *
     C                   EXSR      SRSfLrc
      *
      ** Reposition the subfile if no errors
      *
     C                   IF        WErrn = *ZEROS
     C                   EXSR      SRRepos
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF03sr - F03 key subroutine                                 *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRF03sr       BEGSR
      *
      ** Set exit program flag
      *
     C                   EVAL(R)   WExit = *ON
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF05sr - F05 key subroutine                                 *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: SRRmvMs, SRRepos                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRF05sr       BEGSR
      *
      ** Remove previous error messages
      *
     C                   EXSR      SRRmvMs
     C                   RESET                   WErrn
      *
      ** Set off error indicators
      *
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
      *
      ** Reposition subfile
      *
     C                   EXSR      SRRepos
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF09sr - F09 key subroutine - toggle between add and        *
      *            change mode                                        *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: SRRepos                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRF09sr       BEGSR
      *
     C                   IF        WMode = 'CHG'
     C                   EVAL(R)   WMode = 'ADD'
     C                   EVAL(R)   *IN89 = *ON
     C                   ELSE
     C                   EVAL(R)   WMode = 'CHG'
     C                   EVAL(R)   *IN89 = *OFF
     C                   ENDIF
      *
      ** Clear and reload the subfile
      *
     C                   EXSR      SRRepos
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSfLrc - Process subfile records after enter                *
      *                                                               *
      *  Called by: SREntKy                                           *
      *                                                               *
      *  Calls: SRRmvMs, SR1Delet, SRValid                            *
      *                                                               *
      *****************************************************************
      *
     C     SRSfLrc       BEGSR
      *
      ** Remove previous error messages
      *
     C                   EXSR      SRRmvMs
     C                   RESET                   WErrn
      *
      ** Set off error indicators
      *
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
      *
      ** Read changed subfile records to end if sub file not empty
      *
     C     SFLRN         IFGT      0
     C                   READC     SD000115S0                             98
     C     *IN98         DOWEQ     *OFF
      *
     C                   EVAL(R)   WErr = *OFF
     C                   IF        D1SEL = 'D'
     C                   EXSR      SRDelet
     C                   GOTO      LOOP
     C                   ENDIF
      *
      ** Do validation
      *
     C                   EXSR      SRValid
      *
      ** Change Mode
      *
     C                   IF        WMode = 'CHG'
      *
     C                   IF        ((D1SEL = *BLANKS) AND
     C                             (WErr = *OFF))
     C     KLUpdKey      CHAIN     SDAUTPL0
     C                   IF        %FOUND(SDAUTPL0)
     C                   EVAL(R)   AUATYP = D1ATYP
     C                   EVAL(R)   AUDESC = D1DESC
     C**********         MOVE      AGMRDT        AULCHD                                       CER059
     C**********         EVAL(R)   AUCHTP = 'C'                                               CER059
      *
      ** Reset hidden fields
      *
     C                   EVAL(R)   D1HIDA = D1ATYP
      *
      ** Check for duplicate Authority Type
      *
     C                   EXSR      SRChkd
      *
     C                   IF        WDFlag = *BLANKS AND
     C                             D1ATYP <> *BLANKS
     C                   MOVE      AGRDNB        AULCHD                                       CER059
     C                   EVAL(R)   AUCHTP = 'C'                                               CER059
     C                   UPDATE    UPDAT
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Add mode
      *
     C                   ELSE
     C                   IF        WErr = *OFF
     C                   EVAL(R)   AUATYP = D1ATYP
     C                   EVAL(R)   AUDESC = D1DESC
     C**********         MOVE      AGMRDT        AULCHD                                       CER059
     C**********         EVAL(R)   AUCHTP = 'I'                                               CER059
      *
      ** Check for duplicate Authority Type
      *
     C                   EXSR      SRChkd
      *
     C                   IF        WDFlag = *BLANKS AND
     C                             D1ATYP <> *BLANKS
     C                   MOVE      AGRDNB        AULCHD                                       CER059
     C                   EVAL(R)   AUCHTP = 'I'                                               CER059
     C                   WRITE     UPDAT
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        WErr = *ON
     C                   IF        WErrn = *ZEROS
     C                   Z-ADD     SFLRN         WErrn
     C                   ENDIF
     C                   EVAL(R)   *IN15 = *ON
     C                   ENDIF
      *
     C                   UPDATE    SD000115S0
     C                   EVAL(R)   *IN15 = *OFF
      *
     C     LOOP          TAG
     C                   READC     SD000115S0                             98
     C                   ENDDO
     C                   ENDIF
      *
     C     WErrn         IFNE      0
     C                   Z-ADD     WErrn         DDSFRC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelet - Delete subroutine                                  *
      *                                                               *
      *  Called by: SRSfLrc                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDelet       BEGSR
      *
      ** Retrieve relevant record to be deleted
      *
     C     KLUpdKey      CHAIN     SDAUTPL0
     C                   IF        %FOUND(SDAUTPL0)
      *
      ** Delete record
      *
     C                   DELETE    UPDAT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRmvMs - Remove program messages                            *
      *                                                               *
      *  Called by: SRF05sr, SRSfLrc                                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRmvMs       BEGSR
      *
     C                   MOVEL     DDPGM         PMsgq
      *
      ** Initialize program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM                    PMsgq
     C                   PARM      '*SAME'       PaPgrl
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMs - Send program messages                              *
      *                                                               *
      *  Called by: SRLoad, SRValid                                   *
      *                                                               *
      *  Calls: QMHSNDPM                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRSndMs       BEGSR
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PMsgq
     C                   PARM                    PaPgrl
     C                   PARM                    PMsgId
     C                   PARM                    PMsgF
     C                   PARM                    PMsgTxt
     C                   PARM                    PMsgTyp
      *
      ** Clear all fields for default mechanism next time.
      *
     C                   EVAL      PMsgq   = *BLANKS
     C                   EVAL      PaPgrl  = *ZEROS
     C                   EVAL      PMsgId  = *BLANKS
     C                   EVAL      PMsgF   = *BLANKS
     C                   EVAL      PMsgTxt = *BLANKS
     C                   EVAL      PMsgTyp = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValid - Perform Validation                                 *
      *                                                               *
      *  Called by: SRSfLrc                                           *
      *                                                               *
      *  Calls: SRSndMs                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRValid       BEGSR
      *
     C                   EVAL(R)   *IN33 = *OFF
     C                   EVAL(R)   *IN32 = *OFF
      *
      ** Only action codes 'D' allowed
      *
     C                   RESET                   WTemp
     C                   IF        D1SEL <> 'D' AND D1SEL <> *BLANKS
     C                   EVAL      PMsgId = 'USR9014'
     C                   EVAL      PMsgF = 'SDUSRMSG'
     C                   EXSR      SRSndMs
     C                   EVAL(R)   WErr = *ON
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
      *
     C                   IF        D1ATYP = *BLANKS AND
     C                             D1DESC = *BLANKS
     C                   EVAL      *IN33 = *OFF
     C                   LEAVESR
      *
     C                   ELSEIF    D1ATYP = *BLANKS AND
     C                             D1DESC <> *BLANKS
      *
     C                   EVAL      WDFlag = '*ERROR'
     C                   EVAL      PMsgId = 'USR8032'
     C                   EVAL      PMsgF = 'SDUSRMSG'
      *
     C                   EXSR      SRSndMs
      *
     C                   EVAL(R)   WErr = *ON
     C                   EVAL      *IN33 = *ON
     C                   ENDIF
      *
     C                   IF        D1ATYP <> *BLANKS
      *
     C                   MOVE      ArrChk(1)     WAlpha
     C                   EVAL      WTemp = %CHECK(WAlpha:D1ATYP)
      *
     C                   IF        WTemp  <> *ZEROS
      *
     C                   EVAL      WDFlag = '*ERROR'
     C                   EVAL      PMsgId = 'USR8032'
     C                   EVAL      PMsgF = 'SDUSRMSG'
      *
     C                   EXSR      SRSndMs
      *
     C                   EVAL(R)   WErr = *ON
     C                   EVAL      *IN33 = *ON
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   IF        RunBefore = *BLANKS
     C                   EVAL      RunBefore = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkD - Check for duplicate Authority Type                  *
      *                                                               *
      *  Called by: SRSfLrc                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRChkd        BEGSR
      *
     C                   EVAL(R)   *IN33 = *OFF
      *
     C                   EVAL(R)   WDesc = AUDESC
     C                   EVAL(R)   WAutyp = AUATYP
      *
      ** Retrieve relevant record to be deleted
      *
     C     KLPrvKey      CHAIN     SDAUTPL1
     C                   IF        %FOUND(SDAUTPL1) AND WMode = 'ADD'
      *
      ** Prevention flag
      *
     C                   EVAL      WDFlag = '*ERROR'
     C                   EVAL      PMsgId = 'USR8033'
     C                   EVAL      PMsgF = 'SDUSRMSG'
      *
     C                   EXSR      SRSndMs
      *
     C                   EVAL(R)   WErr = *ON
     C                   EVAL      *IN33 = *ON
     C                   ELSE
     C                   EVAL      WDFlag = *BLANKS
      *
     C                   EVAL(R)   AUDESC = WDesc
     C                   EVAL(R)   AUATYP = WAutyp
      *
     C                   ENDIF
      *
     C                   IF        %FOUND(SDAUTPL1) AND WMode = 'CHG'
      *
      ** Prevention flag
      *
     C                   IF        D1ATYD <> D1ATYP
     C                   EVAL      WDFlag = '*ERROR'
     C                   EVAL      PMsgId = 'USR8033'
     C                   EVAL      PMsgF = 'SDUSRMSG'
      *
     C                   EXSR      SRSndMs
      *
     C                   EVAL(R)   WErr = *ON
     C                   EVAL      *IN33 = *ON
     C                   ELSE
     C                   EVAL      WDFlag = *BLANKS
      *
     C                   ENDIF
      *
     C                   EVAL(R)   AUDESC = WDesc
     C                   EVAL(R)   AUATYP = WAutyp
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2008
** Array Check
 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ

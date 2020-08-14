     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Link Types Maintenance')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000116 - Midas Link Types Maintenance                      *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. CER074             Date 14Aug17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR798548           Date 04Jul11               *
      *                 AR797240           Date 30Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22521 *CREATE   Date 25Mar09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER074 - New Authority Holder Link Types but Exclude from KWG*
      *           24c Reporting                                       *      
      *  MD046248 - Finastra Rebranding                               *
      *  AR798548 - Title consistency with menu option (Recompile)    *
      *  AR797240 - New standing data tables available in the         *
      *             maintenance menu are not available in the         *
      *             enquiry menu                                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT030 Last change date is incorrect.                *
      *  BUG22521 - Cannot navigate to Link Types Maintenance         *
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
     FSD000116DFCF   E             WORKSTN INFDS(WSDS)
     F                                     SFILE(SD000116S0:SFLRN)
      *
      ** Link Types - Update Index
      *
     FSDLINKL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDLINKD0:UPDAT)
      *
      ** Link Types - Retrieval Index
      *
     FSDLINKL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDLINKD0:RETRIV)
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
     D ArrChk          S             37A   DIM(1) CTDATA PERRCD(1)
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
      *                                                                                       CER074
      ** DS for switchable features                                                           CER074
      *                                                                                       CER074
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER074
      *                                                                                       CER074
      ** First DS for Access programs - short data structure                                  CER074
      *                                                                                       CER074
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER074
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
     D WLntyp          S              2A
     D WLKGE           S              1A                                                      CER074
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
     C                   WRITE     SD000116F0
     C                   WRITE     SD000116M1
     C                   EXFMT     SD000116C0
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
     C     *LIKE         DEFINE    LKLTYP        ELTYP
      *
      ** End key for repositioning subfile
      *
     C     KLEndKey      KLIST
     C                   KFLD                    ELTYP
      *
      ** Update key for updating and deleting - use hidden fields
      *
     C     KLUpdKey      KLIST
     C                   KFLD                    D1HIDA
      *
      ** Key to Prevent duplicate keys being written
      *
     C     KLPrvKey      KLIST
     C                   KFLD                    D1LTYP
      *                                                                                       CER074
      ** Access SAR details file to determine if CER074 is ON                                 CER074
      *                                                                                       CER074
     C                   MOVE      'N'           CER074            1                          CER074
     C                   MOVE      '0'           *IN36             1                          CER074
     C                   CALLB     'AOSARDR0'                                                 CER074
     C                   PARM      *BLANKS       PRTCD             7                          CER074
     C                   PARM      '*VERIFY'     POPTN             7                          CER074
     C                   PARM      'CER074'      PSARD             6                          CER074
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER074
      *                                                                                       CER074
      ** Switchable Feature CER074 is *ON                                                     CER074
      *                                                                                       CER074
     C                   IF        PRTCD = *Blanks                                            CER074
     C                   EVAL      CER074 = 'Y'                                               CER074
     C                   MOVE      '1'           *IN36                                        CER074
     C                   ENDIF                                                                CER074
      *                                                                                     AR797240
      ** Display the screen according to Mode ('M' Maintenance 'E' Enquiry)                 AR797240
      *                                                                                     AR797240
     C                   IF        PMode = 'E'                                              AR797240
     C                   EVAL      *In80 = *On                                              AR797240
     C                   ENDIF                                                              AR797240
      *                                                                                     AR797240
      *
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
     C                   READ      SDLINKL1                               99
      *
     C                   IF        %EOF(SDLINKL1)
     C                   LEAVE
     C                   ELSE
      *
      ** If selection check whether record wanted
      ** Link Description
      *
     C                   IF        D2DESC <> *BLANKS
     C                   EVAL      WPos = %SCAN(%TRIM(D2DESC):LKDESC)
     C     WPos          CABLT     1             NEXT
     C                   ENDIF
      *
      ** Move Database contents into subfile fields
      *
     C                   EVAL(R)   D1SEL = *BLANKS
     C                   EVAL(R)   D1LTYP = LKLTYP
     C                   EVAL(R)   D1LTYD = LKLTYP
     C                   EVAL(R)   D1DESC = LKDESC
     C                   If        CER074 ='Y'                                                CER074
     C                   EVAL(R)   D1KWGE = LKKWGE                                            CER074
     C                   Endif                                                                CER074
      *
      ** Populate hidden fields in subfile record
      *
     C                   EVAL(R)   D1HIDA = LKLTYP
      *
     C                   ADD       1             WCount
     C                   ADD       1             SFLRN
     C                   WRITE     SD000116S0
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
     C                   IF        NOT %EOF(SDLINKL1)
     C                   READ      SDLINKL1                               99
     C                   ENDIF
      *
     C                   ELSE
      *
      ** In 'ADD' mode initialise the subfile with blank records
      *
     C                   DO        42
     C                   CLEAR                   SD000116S0
     C                   ADD       1             SFLRN
     C                   WRITE     SD000116S0
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
     C                   EVAL(R)   ELTYP = LKLTYP
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
     C                   WRITE     SD000116C0
     C                   EVAL(R)   *IN40 = *OFF
     C                   EVAL(R)   *IN42 = *OFF
     C                   EVAL(R)   *IN33 = *OFF
     C                   EVAL(R)   *IN32 = *OFF
     C                   If        CER074 = 'Y'                                               CER074
     C                   EVAL(R)   *IN35 = *OFF                                               CER074
     C                   Endif                                                                CER074
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
     C     D2LTYP        SETLL     SDLINKL1
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
     C     KLEndKey      SETGT     SDLINKL1
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
     C                   If        CER074 = 'Y'                                               CER074
     C                   Eval      *IN35 = *OFF                                               CER074
     C                   Endif                                                                CER074
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
     C                   READC     SD000116S0                             98
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
     C     KLUpdKey      CHAIN     SDLINKL0
     C                   IF        %FOUND(SDLINKL0)
     C                   EVAL(R)   LKLTYP = D1LTYP
     C                   EVAL(R)   LKDESC = D1DESC
     C**********         MOVE      AGMRDT        LKLCHD                                       CER059
     C                   MOVE      AGRDNB        LKLCHD                                       CER059
     C                   EVAL(R)   LKCHTP = 'C'
      *                                                                                       CER074
     C                   IF        CER074 = 'Y'                                               CER074
     C                   EVAL(R)   LKKWGE = D1KWGE                                            CER074
     C                   Endif                                                                CER074
      *
      ** Reset hidden fields
      *
     C                   EVAL(R)   D1HIDA = D1LTYP
      *
      ** Check for duplicate Link Type
      *
     C                   EXSR      SRChkd
      *
     C                   IF        WDFlag = *BLANKS AND
     C                             D1LTYP <> *BLANKS
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
     C                   EVAL(R)   LKLTYP = D1LTYP
     C                   EVAL(R)   LKDESC = D1DESC
     C**********         MOVE      AGMRDT        LKLCHD                                       CER059
     C                   MOVE      AGRDNB        LKLCHD                                       CER059
     C                   EVAL(R)   LKCHTP = 'I'
      *
     C                   IF        CER074 = 'Y'                                               CER074
     C                   EVAL(R)   LKKWGE = D1KWGE                                            CER074
     C                   Endif                                                                CER074
      *                                                                                       CER074
      ** Check for duplicate Link Type
      *
     C                   EXSR      SRChkd
      *
     C                   IF        WDFlag = *BLANKS AND
     C                             D1LTYP <> *BLANKS
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
     C                   UPDATE    SD000116S0
     C                   EVAL(R)   *IN15 = *OFF
      *
     C     LOOP          TAG
     C                   READC     SD000116S0                             98
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
     C     KLUpdKey      CHAIN     SDLINKL0
     C                   IF        %FOUND(SDLINKL0)
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
     C                   If        CER074 = 'Y'                                               CER074
     C                   EVAL(R)   *IN35 = *OFF                                               CER074
     C                   Endif                                                                CER074
      *
      ** Only action codes 'D' allowed
      *
     C                   RESET                   WTemp
     C                   IF        D1SEL <> 'D' AND D1SEL <> *BLANKS
     C                   EVAL      PMsgId = 'USR8325'
     C                   EVAL      PMsgF = 'SDUSRMSG'
     C                   EXSR      SRSndMs
     C                   EVAL(R)   WErr = *ON
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
      *
     C**********         IF        D1LTYP = *BLANKS AND                                       CER074
     C**********                   D1DESC = *BLANKS                                           CER074
     C                   IF        (D1LTYP = *BLANKS AND                                      CER074
     C                             D1DESC = *BLANKS) OR                                       CER074
     C                             (D1LTYP = *BLANKS AND                                      CER074
     C                             D1DESC = *BLANKS AND                                       CER074
     C                             D1KWGE = *BLANKS AND                                       CER074
     C                             CER074 = 'Y')                                              CER074
     C                   EVAL      *IN33 = *OFF
     C                   LEAVESR
      *
     C**********         ELSEIF    D1LTYP = *BLANKS AND                                       CER074
     C**********                   D1DESC <> *BLANKS                                          CER074
     C                   ELSEIF    (D1LTYP = *BLANKS AND                                      CER074
     C                             D1DESC <> *BLANKS)                                         CER074
     C                             OR (D1LTYP = *BLANKS AND                                   CER074
     C                             D1KWGE <> *BLANKS and                                      CER074
     C                             CER074 = 'Y')                                              CER074
      *
     C                   EVAL      WDFlag = '*ERROR'
     C                   EVAL      PMsgId = 'USR8326'
     C                   EVAL      PMsgF = 'SDUSRMSG'
      *
     C                   EXSR      SRSndMs
      *
     C                   EVAL(R)   WErr = *ON
     C                   EVAL      *IN33 = *ON
     C                   ENDIF
      *
     C                   IF        D1LTYP <> *BLANKS
      *
     C                   MOVE      ArrChk(1)     WAlpha
     C                   EVAL      WTemp = %CHECK(WAlpha:D1LTYP)
      *
     C                   IF        WTemp  <> *ZEROS
      *
     C                   EVAL      WDFlag = '*ERROR'
     C                   EVAL      PMsgId = 'USR8326'
     C                   EVAL      PMsgF = 'SDUSRMSG'
      *
     C                   EXSR      SRSndMs
      *
     C                   EVAL(R)   WErr = *ON
     C                   EVAL      *IN33 = *ON
      *
     C                   ENDIF
      *
     C                   IF        CER074 = 'Y'                                               CER074
     C                   IF        D1KWGE <> 'Y' and                                          CER074
     C                             D1KWGE <> 'N'                                              CER074
      *                                                                                       CER074
     C                   EVAL      WDFlag = '*ERROR'                                          CER074
     C                   EVAL      PMsgId = 'USR8444'                                         CER074
     C                   EVAL      PMsgF = 'SDUSRMSG'                                         CER074
      *                                                                                       CER074
     C                   EXSR      SRSndMs                                                    CER074
      *                                                                                       CER074
     C                   EVAL(R)   WErr = *ON                                                 CER074
     C                   EVAL      *IN35 = *ON                                                CER074
     C                   ENDIF                                                                CER074
     C                   ENDIF                                                                CER074
      *                                                                                       CER074
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
      *  SRChkD - Check for duplicate Link Type                       *
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
     C                   EVAL(R)   WDesc = LKDESC
     C                   EVAL(R)   WLntyp = LKLTYP
     C                   If        CER074 = 'Y'                                               CER074
     C                   Eval(R)   WLKGE  = LKKWGE                                            CER074
     C                   Endif                                                                CER074
      *
      ** Retrieve relevant record to be deleted
      *
     C     KLPrvKey      CHAIN     SDLINKL1
     C                   IF        %FOUND(SDLINKL1) AND WMode = 'ADD'
      *
      ** Prevention flag
      *
     C                   EVAL      WDFlag = '*ERROR'
     C                   EVAL      PMsgId = 'USR8327'
     C                   EVAL      PMsgF = 'SDUSRMSG'
      *
     C                   EXSR      SRSndMs
      *
     C                   EVAL(R)   WErr = *ON
     C                   EVAL      *IN33 = *ON
     C                   ELSE
     C                   EVAL      WDFlag = *BLANKS
      *
     C                   EVAL(R)   LKDESC = WDesc
     C                   EVAL(R)   LKLTYP = WLntyp
     C                   If        CER074 = 'Y'                                               CER074
     C                   Eval(R)   LKKWGE = WLKGE                                             CER074
     C                   Endif                                                                CER074
      *
     C                   ENDIF
      *
     C                   IF        %FOUND(SDLINKL1) AND WMode = 'CHG'
      *
      ** Prevention flag
      *
     C                   IF        D1LTYD <> D1LTYP
     C                   EVAL      WDFlag = '*ERROR'
     C                   EVAL      PMsgId = 'USR8327'
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
     C                   EVAL(R)   LKDESC = WDesc
     C                   EVAL(R)   LKLTYP = WLntyp
     C                   If        CER074 = 'Y'                                               CER074
     C                   Eval(R)   LKKWGE = WLKGE                                             CER074
     C                   Endif                                                                CER074
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2009
** Array Check
 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ

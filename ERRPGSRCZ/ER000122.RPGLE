     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas @24 KWG display transmitted authority')          *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000122 - Midas @24 KWG display transmitted authority       *
      *             holders                                           *
      *                                                               *
      *  Function : This program displays the transmitted authority   *
      *             holders for an account.                           *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CER076             Date 02Jul19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD041464           Date 23Sep16               *
      *                 CER068             Date 25Feb14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24101           Date 27May09               *
      *                 BUG23947           Date 20May09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER076 - Update to KWG § 24c interface specification         *
      *           (BaFin version 3.3)  (Recompile)                    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD041464 - Non-account holder numbers truncated.  Increase   *
      *             D1CUS to 10. (Recompile)                          *
      *  CER068 - Upgrade CER047 to be compatible with BaFin 3.2.2    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24101 - KWG Extract does not capture non-account holders  *
      *             (Recompile)                                       *
      *  BUG23947 - Menu Item should show correct symbol "§"          *
      *             ReCompile Due to DSPF Modification                *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRLodSF1 - Fill Subfile 1                                    *
      *  SRSetVal - Set Subfile Values                                *
      *  SRClrSF1 - Clear Subfile 1                                   *
      *  SRSndMg - Send a message to the program                      *
      *  SRClrMg - Clear program messages                             *
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
      ** Midas §24 KWG display transmitted auth.Holders
      *
     FER000122DFCF   E             WORKSTN SFILE(ER000122S0:RRN1)
      *
      ** Midas @24 KWG account record persons by account
      *
     FERACEPL0  IF   E           K DISK
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the DB error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D WYes            C                   CONST('Y')
     D WNo             C                   CONST('N')
     D WAllof          C                   CONST('000000000')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Data structure for data area RUNDAT
      *
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *
      ** Data structure to format separate dates into a 8N number
      *
     D DSFmt           DS
     D  WYear                  1      4  0
     D  WMnth                  5      6  0
     D  WDay                   7      8  0
     D  WDate                  1      8  0
     D  WDay2                  9     10  0
     D  WMnth2                11     12  0
     D  WYear2                13     16  0
     D  WDate2                 9     16  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Entry Parameters
      *
     D*PAcc*****       S             20A                                                      CER068
     D PAcc            S             50A                                                      CER068
     D PRef            S             12A
     D PVdt            S              8P 0
     D PVtm            S              6P 0
     D PIN03           S              1A
      *
      ** Parameters to call Y2SNMGC, Y2CLMSC
      *
     D PZaPgmQ         S             10A
     D PZaPgrl         S              5A
     D PZaMsId         S              7A
     D PZaMsgF         S             10A
     D PZaMsda         S            132A
     D PZaMstp         S              7A
      *
      ** Work variables
      *
     D RRN1            S              4P 0
     D WErr            S              1A   INZ(WNo)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing ------------------------------+
      ** ¦                                                           ¦
      ** ¦ Initial processing is performed automatically: the *INZ   ¦
      ** ¦ executed at program activation.                           ¦
      ** ¦                                                           ¦
      ** +-----------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Main Loop
      *
     C                   WRITE     ER000122F0
     C                   WRITE     ER000122C1
     C  N61              WRITE     ER000122F1
     C                   EXFMT     ER000122C0
     C                   EXSR      SRClrMg
      *
     C                   SETON                                        LR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLodSF1 - Fill Subfile 1                                    *
      *                                                               *
      *  Called by : *INZSR                                           *
      *                                                               *
      *  Calls : SRSetVal                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRLodSF1      BEGSR
      *
     C                   EVAL      RRN1 = 1
     C                   EVAL      DDSFR1 = 1
      *
      ** Fill Subfile
      *
     C                   DOU       *IN63
      *
      ** Read from file ERACEXV2
      *
     C     KLerac        READE     ERACEPD0                               63
     C                   IF        NOT(*IN63)
      *
      ** Set subfile values
      *
     C                   EXSR      SRSetVal
      *
      ** Write subfile record
      *
     C                   WRITE     ER000122S0
     C                   EVAL      RRN1 = RRN1 + 1
      *
     C                   ENDIF
     C                   ENDDO
      *
      ** Display Subfile if records read
      *
     C                   IF        RRN1 > 1
     C                   SETON                                        61
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetVal - Set Subfile Values                                *
      *                                                               *
      *  Called by : SRLodSF1                                         *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRSetVal      BEGSR
      *
     C                   EVAL      D1PTP = F13PTP
     C                   EVAL      D1CUS = F13CUS
      *
     C                   EVAL      D1NAM = %TRIM(F13SNM)
     C                   IF        %TRIM(F13FNM) <> ' '
     C                   EVAL      D1NAM = %TRIM(D1NAM) + ', '
     C                                   + %TRIM(F13FNM)
     C                   ENDIF
      *
     C                   EVAL      WDate = F13BDT
     C                   Z-ADD     WYear         WYear2
     C                   Z-ADD     WMnth         WMnth2
     C                   Z-ADD     WDay          WDay2
     C                   Z-ADD     WDate2        D1BDT
      *
     C                   EVAL      D1STR = %TRIM(F13STR)
     C                   EVAL      D1TWN = %TRIM(F13ZIP) + ' ' +
     C                             %TRIM(F13TWN) + ' ' + %TRIM(F13CTY)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrSF1 - Clear Subfile 1                                   *
      *                                                               *
      *  Called by : *INZSR                                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRClrSF1      BEGSR
      *
     C                   SETON                                        62
     C                   WRITE     ER000122C0
     C                   SETOFF                                       616263
      *
      ** Postion to record
      *
     C     KLerac        SETLL     ERACEPL0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMg - Send a message to the program                      *
      *                                                               *
      *  Called by : None                                             *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
     C     SRSndMg       BEGSR
      *
     C                   IF        PZaPgmQ = *BLANKS
     C                   MOVEL     DDPGM         PZaPgmQ
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PZaPgmQ
     C                   PARM                    PZaPgrl
     C                   PARM                    PZaPgrl
     C                   PARM                    PZaMsgF
     C                   PARM                    PZaMsda
     C                   PARM                    PZaMstp
      *
     C                   EVAL      WErr = WYes
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrMg - Clear program messages                             *
      *                                                               *
      *  Called by : MAIN Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRClrMg       BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         PZaPgmQ
     C                   PARM      '*SAME'       PZaPgrl
      *
     C                   EVAL      WErr = WNo
     C                   SETOFF                                       6869
     C                   MOVEA     WAllof        *IN(71)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialization routine                      *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *  Calls : SRClrMg,SRClrSF1,SRLodSF1                            *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Define *ENTRY parameter list
      *
     C     *ENTRY        PLIST
     C                   PARM                    PAcc
     C                   PARM                    PRef
     C                   PARM                    PVdt
     C                   PARM                    PVtm
     C                   PARM      *IN03         PIN03
      *
      ** Set program and job name
      *
     C                   EVAL      DDPGM = PSProcName
     C                   EVAL      DDJOB = PSJobName
      *
      ** Set MIDAS rundate
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          DDMRDT
      *
      ** Messages file
      *
     C                   MOVEL     'STUSRMSG'    PZaMsgF
      *
      ** Clear program messages
      *
     C                   EXSR      SRClrMg
      *
      ** Init the Subfile
      *
     C                   EXSR      SRClrSF1
     C                   EXSR      SRLodSF1
      *
      ** Defining KeyLists
      *
     C     KLerac        KLIST
     C                   KFLD                    PAcc
     C                   KFLD                    PRef
     C                   KFLD                    PVdt
     C                   KFLD                    PVtm
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Program, module and procedure names for DB error processing.
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008

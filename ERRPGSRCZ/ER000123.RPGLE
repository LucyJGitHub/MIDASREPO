     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas @24 KWG display transmission response')          *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000123 - Midas @24 KWG display transmission response       *
      *                                                               *
      *  Function : This program displays the response to a           *
      *             transmitted file.                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. MD027196           Date 19Aug14               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG23947           Date 20May09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027196 - Missing Error Codes for BankVerlag missinng in    *
      *             BFM.                                              *
      *           - Recompiled due to CER068 changes in ERTRSPPD.     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23947 - Menu Item should show correct symbol "§"          *
      *             ReCompile Due to DSPF Modification                *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRLodSF1 - Fill Subfile 1                                    *
      *  SRSndMg - Send A Message To The Program                      *
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
      ** Midas §24 KWG display transmission file Response
      *
     FER000123DFCF   E             WORKSTN
      *
      ** Midas @24 KWG file info detail by file number
      *
     FERTRSPL0  IF   E           K DISK
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
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
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Entry Parameters
      *
     D PFnr            S              8P 0
     D PIN03           S              1A
      *
      ** Parameters to call Y2SNMGC, Y2CLMSC
      *
     D PZaPgmQ         S             10A
     D PZaPgrl         S              5A
     D PZaMsId         S              7A
     D PZaMsgF         S             10A
     D PZaMsda         S            132A
     D PZaMsTp         S              7A
      *
      ** Work variables
      *
     D WEcde           S              4A
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
     C                   WRITE     ER000123F0
     C                   WRITE     ER000123C0
     C                   EXFMT     ER000123H0
     C                   EXSR      SRClrMg
      *
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLodSF1 - Fill Subfile 1                                    *
      *                                                               *
      *  Called by : *INZSR                                           *
      *                                                               *
      *  Calls : SRSndMg                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRLodSF1      BEGSR
      *
      ** Postion to record
      *
     C     PFnr          SETLL     ERTRSPL0
      *
      ** Fill Subfile
      *
     C                   DOU       %EOF
      *
      ** Read from file ERTRSPL0
      *
     C     PFnr          READE     ERTRSPD0
     C                   IF        NOT(%EOF)
      *
      ** Set message ID
      *
     C                   MOVEL     F11ECL        WEcde
     C                   MOVE      F11ETP        WEcde
     C                   EVAL      PZaMsId = 'ERE' + WEcde
     C                   EVAL      PZaMsda = F11ACC + F11REF
     C                   EXSR      SRSndMg
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMg - Send A Message To The Program                      *
      *                                                               *
      *  Called by: SRLodSF1                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRSndMg       BEGSR
      *
     C                   IF        PZaPgmQ = *BLANKS
     C                   MOVEL     DDPGM         PZaPgmQ
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PZaPgmQ
     C                   PARM                    PZaPgrl
     C                   PARM                    PZaMsId
     C                   PARM                    PZaMsgF
     C                   PARM                    PZaMsda
     C                   PARM                    PZaMsTp
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrMg - Clear program messages                             *
      *                                                               *
      *  Called by : MAIN Processing,*INZSR                           *
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
      *  Calls : SRClrMg,SRLodSF1                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** *ENTRY parameter list
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFnr
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
     C                   EXSR      SRLodSF1
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
(c) Misys International Banking Systems Ltd. 2008

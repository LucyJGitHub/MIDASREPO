     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Threshold Amount Update Prompt')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000815 - Threshold Amount Update Prompt                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. AR656988           Date 14Oct10               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG24196A          Date 26Jun08               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR656988 - Use core message IDs instead of XXXnnnn format    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24196A - Correct processing of Increase/Decrease of       *
      *             Threshold                                         *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRSndEMsg - Send Error Message                               *
      *  SRClrEMsg - Clear Error Message                              *
      *  *INZSR   - Program initialization routine                    *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialization only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Threshold Amount Update Prompt Screen
      *
     FSD000815DFCF   E             WORKSTN INFDS(INFDS1)
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,and the following
      ** named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes the definitions
      ** for error and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS for Access programs - short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Externally described DS for Bank details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                               BUG24196A
      *                                                                                    BUG24196A
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                               BUG24196A
      *                                                                                    BUG24196A
      ** Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I#DSP)
      *
     D PParm           DS            17
     D PRtcd                   1     10
     D PThtu                  11     11
     D PPerc                  12     16
     D PInrd                  17     17
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PSeq            S              5A
     D PLev            S              1A
     D PEnt            S              3A
     D PAct            S              1A
     D PCmd            S              1A
     D WErrF           S              1A
     D WRun            S              1A
     D WPercI          S              5P 0
     D WPercC          S              5A
     D Idx             S              1P 0
      *
      ** Message file workfields - Parameters list for ZA0350
      *
     D PZMsgFile       S             10A
     D PZMsgID         S             10A
     D PZMsgDta        S             45A
      *
      ** Parameter for AOBRCHR0
      *
     D PRtCod          S              7A
     D POptn           S              7A
     D PBrch           S              3A
      *
      ** Parameters for ZALIGN/ZEDIT
      *
     D ZAlignOk        S              1A
     D ZField          S             16A
     D ZADec           S              1P 0
     D ZADig           S              2P 0
      *                                                                                    BUG24196A
     D WYrEndD         S              6A                                                   BUG24196A
     D WYrEndP         S              5  0                                                 BUG24196A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *inzsr is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialise the Variables
      *
     C                   EVAL      DDTHTU = 'B'
     C                   EVAL      DDPERC = *BLANKS
     C                   EVAL      DDINRD = *BLANKS
     C                   EVAL      PRtcd = *BLANKS
     C                   EVAL      SPGMQ = '*'
     C                   EVAL      WErrF = 'Y'
     C                   EXSR      SRClrEMsg
     C                   EVAL      *IN10 = *OFF
     C                   EVAL      *IN11 = *OFF
     C                   EVAL      *IN12 = *OFF
     C                   EVAL      *IN30 = *OFF
      *
      ** Main Processing
      *
     C                   DOW       *IN03 <> *ON AND
     C                             WErrF = 'Y'
      *
     C                   WRITE     SD000815C0
     C                   WRITE     SD000815F0
     C                   EXFMT     SD000815D0
      *
      ** Initialise Screen Variable to Re-Validate
      *
     C                   EVAL      WErrF = 'N'
     C                   EXSR      SRClrEMsg
     C                   EVAL      *IN10 = *OFF
     C                   EVAL      *IN11 = *OFF
     C                   EVAL      *IN12 = *OFF
     C                   EVAL      *IN30 = *OFF
      *
      ** Check if F3 is pressed
      *
     C                   IF        *IN03 = *ON
     C                   EVAL      PRtcd = 'NoProcess'
     C                   EVAL      PCmd = 'E'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *                                                                                    BUG24196A
     C     WYrEndP       IFGE      BJRDNB                                                  BUG24196A
     C     WYrEndP       ANDLT     BJDNWD                                                  BUG24196A
      *
      ** Validate Thresholds to be updated
      *
     C                   IF        DDTHTU = *BLANKS
      *
     C                   EVAL      DDTHTU = 'B'
     C                   EVAL      PThtu = DDTHTU
      *
     C                   ELSEIF    DDTHTU = 'I' OR DDTHTU = 'J' OR
     C                             DDTHTU = 'B'
      *
     C                   EVAL      PThtu = DDTHTU
      *
     C                   ELSE
      *
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrF = 'Y'
     C                   EVAL      *IN10 = *ON
     C                   EVAL      MsgIDArr(Idx) = 'USR8243'
     C                   EVAL      MsgDtaArr(Idx) = DDTHTU
      *
     C                   ENDIF
      *
      ** Validate Percentage
      *
     C                   IF        DDPERC <> *BLANKS
      *
      ** Align Screen Field.
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM      DDPERC        ZField
     C                   PARM      3             ZADec
     C                   PARM      2             ZADig
      *
      ** If In-correct percentage entered
      *
     C                   IF        ZAlignOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrF = 'Y'
     C                   EVAL      *IN11 = *ON
     C**********         EVAL      MsgIDArr(Idx) = 'XXX9014'                                AR656988
     C                   EVAL      MsgIDArr(Idx) = 'USR9021'                                AR656988
     C                   MOVEL     DDPERC        MsgDtaArr(Idx)
      *
     C                   ELSE
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZField
     C                   PARM      3             ZADec
     C                   MOVE      ZField        DDPERC
      *
      ** Check for Zero
      *
     C                   EVAL      WPercC = %SUBST(DDPERC:1:2) +
     C                                      %SUBST(DDPERC:4:3)
     C                   MOVE      WPercC        WPercI
      *
     C                   IF        WPercI > 0
     C                   MOVE      WPercI        PPerc
     C                   ELSE
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrF = 'Y'
     C                   EVAL      *IN11 = *ON
     C******             EVAL      MsgIDArr(Idx) = 'XXX9015'                                AR656988
     C                   EVAL      MsgIDArr(Idx) = 'USR9022'                                AR656988
     C                   MOVEL     DDPERC        MsgDtaArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrF = 'Y'
     C                   EVAL      *IN11 = *ON
     C                   EVAL      MsgIDArr(Idx) = 'USR0261'
     C                   MOVEL     DDPERC        MsgDtaArr(Idx)
      *
     C                   ENDIF
      *
      ** Validate Increase/Reduce Field
      *
     C                   IF        DDINRD = *BLANKS
      *
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      *IN12 = *ON
     C                   EVAL      WErrF = 'Y'
     C                   EVAL      MsgIDArr(Idx) = 'USR0261'
     C                   EVAL      MsgDtaArr(Idx) = DDINRD
      *
     C                   ELSEIF    DDINRD = 'I' OR DDINRD = 'R'
      *
     C                   EVAL      PInrd = DDINRD
      *
     C                   ELSE
      *
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      *IN12 = *ON
     C                   EVAL      WErrF = 'Y'
     C                   EVAL      MsgIDArr(Idx) = 'USR8244'
     C                   EVAL      MsgDtaArr(Idx) = DDINRD
      *
     C                   ENDIF
      *                                                                                    BUG24196A
     C                   ELSE                                                              BUG24196A
      *                                                                                    BUG24196A
     C                   EVAL      Idx = Idx + 1                                           BUG24196A
     C                   EVAL      WErrF = 'Y'                                             BUG24196A
     C                   EVAL      MsgIDArr(Idx) = 'USR9941'                               BUG24196A
     C                   EVAL      MsgDtaArr(Idx) = *BLANKS                                BUG24196A
      *                                                                                    BUG24196A
     C                   ENDIF                                                             BUG24196A
      *
      ** Send Error Message ,if any
      *
     C                   EXSR      SRSndEMsg
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndEMsg - Send Error Message                               *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRSndEMsg     BEGSR
      *
     C                   EVAL      Idx = 1
     C                   DOW       MsgIdArr(Idx) <> *BLANKS
      *
     C                   CALL      'ZA0350'
     C                   PARM      'SDUSRMSG'    PZMsgFile
     C                   PARM      MsgIdArr(Idx) PZMsgID
     C                   PARM      MsgDtaArr(Idx)PZMsgDta
      *
     C                   EVAL      Idx = Idx + 1
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrEMsg - Clear Error Message                              *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRClrEMsg     BEGSR
      *
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   EVAL      Idx = 0
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLev
     C                   PARM                    PEnt
     C                   PARM                    PParm
     C                   PARM                    PAct
     C                   PARM                    PCmd
      *
     C                   EVAL      DBPGM = 'SD000815'
     C                   EVAL      DBMOD =  PSProcMod
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCod
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBASE  = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                    BUG24196A
      ** Access Location Code Details                                                      BUG24196A
      *                                                                                    BUG24196A
     C                   CALL      'AOLOCNR0'                                              BUG24196A
     C                   PARM      *BLANKS       PRtCod                                    BUG24196A
     C                   PARM      '*KEY'        POptn                                     BUG24196A
     C                   PARM      BJSLCD        PLoCod            3                       BUG24196A
     C     SDLOCN        PARM      SDLOCN        DSFDY                                     BUG24196A
      *                                                                                    BUG24196A
     C                   IF        PRtCod <> *BLANKS                                       BUG24196A
     C     *LOCK         IN        LDA                                                     BUG24196A
     C                   EVAL      DBFILE = 'SDLOCNPD'                                     BUG24196A
     C                   EVAL      DBKEY  = PLoCod                                         BUG24196A
     C                   EVAL      DBASE  = 002                                            BUG24196A
     C                   OUT       LDA                                                     BUG24196A
     C                   EXSR      *PSSR                                                   BUG24196A
     C                   ENDIF                                                             BUG24196A
      *                                                                                    BUG24196A
      ** Access Country Code Details                                                       BUG24196A
      *                                                                                    BUG24196A
     C                   CALL      'AOCTRYR0'                                              BUG24196A
     C                   PARM      *BLANKS       PRtCod                                    BUG24196A
     C                   PARM      '*KEY'        POptn                                     BUG24196A
     C                   PARM      DVCNCD        PCtCod            2                       BUG24196A
     C     SDCTRY        PARM      SDCTRY        DSFDY                                     BUG24196A
      *                                                                                    BUG24196A
     C                   IF        PRtCod <> *BLANKS                                       BUG24196A
     C     *LOCK         IN        LDA                                                     BUG24196A
     C                   EVAL      DBFILE = 'SDCTRYPD'                                     BUG24196A
     C                   EVAL      DBKEY  = PCtCod                                         BUG24196A
     C                   EVAL      DBASE  = 003                                            BUG24196A
     C                   OUT       LDA                                                     BUG24196A
     C                   EXSR      *PSSR                                                   BUG24196A
     C                   ELSE                                                              BUG24196A
     C                   IF        A4ETXY <> *ZERO                                         BUG24196A
     C     2             SUBST     BJMRDT:6      WYear             2                       BUG24196A
     C                   MOVE      WYear         WYearP            2 0                     BUG24196A
     C                   MOVE      WYearP        WYrEndD                                   BUG24196A
     C                   MOVEL     A4ETXY        WYrEndD                                   BUG24196A
      *                                                                                    BUG24196A
     C                   CALLB     'ZDATE1'                                                BUG24196A
     C                   PARM                    WYrEndD                                   BUG24196A
     C                   PARM      *ZEROS        PZDAYNO           5 0                     BUG24196A
     C                   PARM                    BJDFIN                                    BUG24196A
     C                   PARM      *BLANKS       PERR              1                       BUG24196A
     C                   Z-ADD     PZDAYNO       WYrEndP                                   BUG24196A
      *                                                                                    BUG24196A
     C                   IF        WYrEndP < BJRDNB                                        BUG24196A
      *                                                                                    BUG24196A
     C                   ADD       1             WYearP                                    BUG24196A
     C                   MOVE      WYearP        WYrEndD                                   BUG24196A
      *                                                                                    BUG24196A
     C                   CALLB     'ZDATE1'                                                BUG24196A
     C                   PARM                    WYrEndD                                   BUG24196A
     C                   PARM      *ZEROS        PZDAYNO           5 0                     BUG24196A
     C                   PARM                    BJDFIN                                    BUG24196A
     C                   PARM      *BLANKS       PERR              1                       BUG24196A
     C                   Z-ADD     PZDAYNO       WYrEndP                                   BUG24196A
      *                                                                                    BUG24196A
     C                   ENDIF                                                             BUG24196A
      *                                                                                    BUG24196A
     C                   ENDIF                                                             BUG24196A
     C                   ENDIF                                                             BUG24196A
      *
      ** Populate Screen Header Fields
      *
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWID = PSJObName
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
      ** Call DBERRCTL if Interactive program
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
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2008

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits display screen 2')             *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIDS2 - Loans/Deposits & NAS Issued Display Screen 2     *
      *                                                               *
      *  Function:  This module displays the main details screen 2    *
      *             of the loans and deposits screen input function.  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016  *CREATE    Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FMMLDNID2F CF   E             WORKSTN
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       93  Collateral Status field displayed                   *
      *       70  Protect deal detail fields                          *
      *       71  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       73  Enable CF10                                         *
      *       74  Enable CF14                                         *
      *       75  Enable CF15                                         *
      *       76  Enable CF19                                         *
      *       79  Highlight deal status                               *
      *                                                               *
      *       80  Autumatic Rollover not installed                    *
      *       81  Allow Base Rate Changes not installed               *                       CDL019
      *       82  Apply Base Rate at Value Date not installed         *                       CDL020
      *       83  Non-display of screen fields introduced by CDL033   *                       CDL033
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      *****************************************************************
      /EJECT
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------------
 
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
 
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @NAR            S             40    DIM(1) CTDATA PERRCD(1)
 
     D @EI             S              1    DIM(60)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D MMLDNI        E DS                  EXTNAME(MMLDNIPD)
     D MMELDN2       E DS                  EXTNAME(MMELDN2PD)
 
     D                 DS
     D  DDFOTX                 1     40
     D  DDSIDN                10     15
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Switchable Feature                                                                   CDL033
     D CDL033          S              1A                                                      CDL033
                                                                                              CDL033
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Main processing
      *
     C                   EXSR      MAIN
      *
      ** Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      ** Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     MMELDN2       @EI
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
      *
      ** Do While Error Messages Found
      ** Write Error Messages (With or Without Data) to Subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C     MsgIdArr(C)   ANDNE     'MMM1030'
     C                   MOVEL     MsgIdArr(C)   @MSGID            7
     C                   MOVEL     MsgDtaArr(C)  @MSGDT           45
     C     @MSGDT        IFEQ      *BLANKS
     C                   EXSR      ERRWOD
     C                   ELSE
     C                   EXSR      ERRWID
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO
      *
      ** Do While Warning Messages Found
      ** Write Warning Messages (With or Without Data) to Subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  @MSGID            7
     C                   MOVEL     WMsgDtaArr(C) @MSGDT           45
     C     @MSGDT        IFEQ      *BLANKS
     C                   EXSR      ERRWOD
     C                   ELSE
     C                   EXSR      ERRWID
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO
      *
      ** Write MSG Id MMM1030 (If There is) to Subfile
      *
     C     MsgIdArr(1)   IFEQ      'MMM1030'
     C                   MOVEL     MsgIdArr(1)   @MSGID            7
     C                   MOVEL     MsgDtaArr(1)  @MSGDT           45
     C     @MSGDT        IFEQ      *BLANKS
     C                   EXSR      ERRWOD
     C                   ELSE
     C                   EXSR      ERRWID
     C                   ENDIF
     C                   ENDIF
      *
      ** Enable Detail Fields (All Fields Except Action Code & Deal Number)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      ** Enable Function Keys
      *
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
     C     @EINKJ        COMP      'Y'                                    73
     C     @EINKN        COMP      'Y'                                    74
     C     @EINKP        COMP      'Y'                                    75
     C     @EINKT        COMP      'Y'                                    76
      *
      ** Deal Status
      *
     C     DDSTS         COMP      *BLANK                             7979
      *
      ** Text = Successful Insert
      *
     C     @SIDN         IFNE      *BLANK
     C                   MOVEL     @NAR(1)       DDFOTX
     C                   MOVEL     @SIDN         DDSIDN
     C                   MOVEL     *BLANK        @SIDN
     C                   ENDIF
      *
      * Display the Blocked/Unblock Action
     C     CDL016        IFEQ      'Y'
     C     DDACTN        ANDEQ     'A'
      *
     C     BUACT         IFEQ      'B'
     C     BUACT         OREQ      'U'
     C                   MOVE      BUACT         DDACTN
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       CDL033
     C                   EVAL      *IN83 = *OFF                                               CDL033
     C                   IF        CDL033 <> 'Y' AND                                          CDL033
     C                             DDTYPE <> 'CF'                                             CDL033
     C                   EVAL      *IN83 = *ON                                                CDL033
     C                   ENDIF                                                                CDL033
      *
      ** Write Message Subfile, Details and Footer Screen
      *
     C                   TIME                    DDTIME
     C                   WRITE     MMLDNIS0
     C                   WRITE     MMLDNID1
     C                   WRITE     MMLDNIF1
      *
      ** READ DETAILS SCREEN,
      *
      ** If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      MMLDNID1                               99
     C                   ENDIF
      *
      * Revert back to the original Action code
     C     CDL016        IFEQ      'Y'
      *
     C     DDACTN        IFEQ      'B'
     C     DDACTN        OREQ      'U'
     C                   MOVE      DDACTN        BUACT
     C                   MOVE      'A'           DDACTN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Clear message subfile
      *
     C                   CALL      'ZA0250'
      *
      ** Set Screen Error Indicators Off
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      ** Set Return Keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKN         @INKN
     C                   MOVE      *INKP         @INKP
     C                   MOVE      *INKT         @INKT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ERRWOD  - OUTPUT ERROR MESSAGES WITHOUT DATA                  *
      *                                                               *
      *****************************************************************
     C     ERRWOD        BEGSR
      *
      ** Display error message
      *
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     @MSGID        ZAMSID
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID           10
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ERRWID  - OUTPUT ERROR MESSAGES WITH DATA                     *
      *                                                               *
      *****************************************************************
     C     ERRWID        BEGSR
      *
      ** Display error message
      *
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     @MSGID        ZAMSID
     C                   CALL      'ZA0440'
     C                   PARM                    ZAMSID           10
     C                   PARM      @MSGDT        ZAMDTA           45
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      ** ================
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Deal (In Screen Format)
     C                   PARM                    MMLDNI
      *
      ** Deal Status
     C                   PARM                    DDSTS            24
      *
      ** Fields in Error
     C                   PARM                    MMELDN2
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enabled Key & Detail Fields
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ** Enabled Function Keys
      ** KG = COMMAND KEY 07 = READ PREVIOUS
      ** KH = COMMAND KEY 08 = READ NEXT
      ** KJ = COMMAND KEY 10 = CONFIRM DELETE
      ** KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      ** KP = COMMAND KEY 15 = BROWSE
      ** KT = COMMAND KEY 19 = FUNDING INFO
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKT            1
      *
      ** Succesful Insert Deal
     C                   PARM                    @SIDN             6
      *
      ** Calling PGM
     C                   PARM                    CPGM             10
      *
      * Blocked/Unblock Action
     C                   PARM                    BUACT             1
      *
      * Autumatic Rollover of Fixed Term Loan/Deposit
     C                   PARM                    CDL016            1
      *                                                                                       CDL019
      * Allow Base Rate Changes on Fixed Deposits/Loans                                       CDL019
     C                   PARM                    CDL019            1                          CDL019
      *                                                                                       CDL020
      * Apply Base Rate at Value Date                                                         CDL020
     C                   PARM                    CDL020            1                          CDL020
      *
      ** OUTPUT PARAMETERS
      ** =================
      *
      ** Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKP             1
     C                   PARM                    @INKT             1
      *
      ** Write screen with no read indicator
     C                   PARM                    WriteOnly         1
     C                   PARM                    RepoFlag          1
 
      *
      ** Initialize program name
     C                   MOVEL     'MMLDNIDS2'   DBPGM
 
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
      *
      ** Check if Repurchase Agreement Enhancements is installed
      *
     C                   CallB     'AOSARDR0'
     C                   Parm      *BLANKS       PRTCD             7
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      'CSE006'      PSARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
      *
     C                   Move      'N'           CSE006            1
     C                   If        PRTCD = *Blanks
     C                   Eval      CSE006 = 'Y'
     C                   Endif
      *
      * If RepoFlag is on set indicator to display transaction type
      * field.
      *
     C     RepoFlag      IFEQ      'Y'
     C                   MOVE      '1'           *IN78
     C                   ELSE
      *
      * Non-Display Repo Details if this is input through Loans and
      * Deposits and switch is on.
      *
     C                   IF        CSE006 = 'Y'
     C                   MOVE      '1'           *IN77
     C                   ENDIF
     C                   ENDIF
      *
      ** Autumatic Rollover of Fixed Term Loan/Deposit not installed
      ** (Protect Source of Funds)
      *
     C     CDL016        IFNE      'Y'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
      *                                                                                       CDL019
      ** Allow Base Rate Changes on Fixed Deposits/Loans                                      CDL019
      ** (Protect Fix Base Rate)                                                              CDL019
      *                                                                                       CDL019
     C     CDL019        IFNE      'Y'                                                        CDL019
     C                   EVAL      *IN81 = *ON                                                CDL019
     C                   ENDIF                                                                CDL019
      *                                                                                       CDL020
      ** Apply Base Rate at Value Date                                                        CDL020
      ** (Protect Actual Interest Rate)                                                       CDL020
      *                                                                                       CDL020
     C     CDL020        IFNE      'Y'                                                        CDL020
     C                   EVAL      *IN82 = *ON                                                CDL020
     C                   ENDIF                                                                CDL020
 
      ** Check if CDL033 feature is installed                                                 CDL033
                                                                                              CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       PRTCD                                        CDL033
     C                   PARM      '*VERIFY'     POPTN                                        CDL033
     C                   PARM      'CDL033'      PSARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
                                                                                              CDL033
     C                   EVAL      CDL033 = 'N'                                               CDL033
     C                   IF        PRTCD = *BLANKS                                            CDL033
     C                   EVAL      CDL033 = 'Y'                                               CDL033
     C                   ENDIF                                                                CDL033
      *
      ** Message subfile control
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Deal No. 999999 successfully inserted.

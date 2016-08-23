     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Multicash Narratives')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  GLVEXTNARR - Midas GL Validate Multicash Narratives          *
      *                                                               *
      *  Function:  This module validates the Multicash Narratives    *
      *             on the new Details screen                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG23742 *CREATE   Date 09May09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVCOTP - Validate Correspondent Type                        *
      *  *INZSR  - Program Initialisation Routine                     *
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
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields
      ** in the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
      *
     D/COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
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
      ** DS for extended narratives
      *
     D PDetails        DS          1000
     D DDEX1                   1     35
     D DDEX2                  36     70
     D DDEX3                  71    105
     D DDEX4                 106    140
     D DDEX5                 141    175
     D DDEX6                 176    210
     D DDEX7                 211    245
     D DDEX8                 246    280
     D DDEX9                 281    315
     D DDEX10                316    350
     D DDEX11                351    385
     D DDEX12                386    420
     D DDEX13                421    455
     D DDEX14                456    490
     D DDEX15                491    525
     D DDEX16                526    560
     D DDEX17                561    595
     D DDEX18                596    630
     D DDEX19                631    665
     D DDEX20                666    700
     D DDEX21                701    735
     D DDEX22                736    770
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
      *
     D PArrExt22       S             35A   DIM(22)
      *
     D Idx             S              3P 0
     D PRtcd           S              7A
     D POptn           S              7A
     D PNwrk           S              6A
     D PMsgTyp         S              3A
     D PBrca           S              3A
     D*PCNum****       S              6  0                                                    CER059
     D PCNum           S              6A                                                      CER059
     D PCcy            S              3A
     D PAccd           S             10S 0
     D PAcsq           S              2S 0
     D PDCInd          S              1A
     D PTranTp         S              5A
     D PFormL1         S             70A
     D PFormL2         S             70A
     D PFormL3         S             70A
     D PFormL4         S             70A
     D PFormL5         S             70A
     D PFormL6         S             70A
     D PFormL7         S             70A
     D PFormL8         S             70A
     D PFormL9         S             70A
     D PFormL10        S             70A
     D PFormL11        S             70A
     D PFormL12        S             70A
     D PFormL13        S             70A
     D PFormL14        S             70A
     D PFormL15        S             70A
     D PFormL16        S             70A
     D PFormL17        S             70A
     D PFormL18        S             70A
     D PFormL19        S             70A
     D PFormL20        S             70A
     D PFormL21        S             70A
     D PFormL22        S             70A
      *
     D WIdx            S              2S 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      *  MAIN PROCEDURE                                               *
      *****************************************************************
      *
      ** Initialization
      *
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      Idx = *ZEROS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
      *
      ** Validate Additional Narrative Details
      *
     C                   EXSR      SRVMNARR
      *
      ** Return from program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVMNARR - Validate Additional Narrative Details             *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRVMNARR      BEGSR
      *
      ** Call the validation program
      *
     C                   EVAL      PArrExt22(1) = DDEX1
     C                   EVAL      PArrExt22(2) = DDEX2
     C                   EVAL      PArrExt22(3) = DDEX3
     C                   EVAL      PArrExt22(4) = DDEX4
     C                   EVAL      PArrExt22(5) = DDEX5
     C                   EVAL      PArrExt22(6) = DDEX6
     C                   EVAL      PArrExt22(7) = DDEX7
     C                   EVAL      PArrExt22(8) = DDEX8
     C                   EVAL      PArrExt22(9) = DDEX9
     C                   EVAL      PArrExt22(10) = DDEX10
     C                   EVAL      PArrExt22(11) = DDEX11
     C                   EVAL      PArrExt22(12) = DDEX12
     C                   EVAL      PArrExt22(13) = DDEX13
     C                   EVAL      PArrExt22(14) = DDEX14
     C                   EVAL      PArrExt22(15) = DDEX15
     C                   EVAL      PArrExt22(16) = DDEX16
     C                   EVAL      PArrExt22(17) = DDEX17
     C                   EVAL      PArrExt22(18) = DDEX18
     C                   EVAL      PArrExt22(19) = DDEX19
     C                   EVAL      PArrExt22(20) = DDEX20
     C                   EVAL      PArrExt22(21) = DDEX21
     C                   EVAL      PArrExt22(22) = DDEX22
      *
     C                   CALL      'MG001901'
      *
     C                   PARM      *BLANKS       RetCodeIn
     C                   PARM      '*VALID'      POptn
     C                   PARM                    PNwrk
     C                   PARM                    PMsgTyp
     C                   PARM                    PBrca
     C                   PARM                    PCNum
     C                   PARM                    PCcy
     C                   PARM                    PAccd
     C                   PARM                    PAcsq
     C                   PARM                    PDCInd
     C                   PARM                    PTranTp
      *
      ** Extended Narratives of length 22 * 35
      *
     C                   PARM                    PArrExt22
      *
      ** Narratives format 20 * 70
      *
     C                   PARM                    PFormL1
     C                   PARM                    PFormL2
     C                   PARM                    PFormL3
     C                   PARM                    PFormL4
     C                   PARM                    PFormL5
     C                   PARM                    PFormL6
     C                   PARM                    PFormL7
     C                   PARM                    PFormL8
     C                   PARM                    PFormL9
     C                   PARM                    PFormL10
     C                   PARM                    PFormL11
     C                   PARM                    PFormL12
     C                   PARM                    PFormL13
     C                   PARM                    PFormL14
     C                   PARM                    PFormL15
     C                   PARM                    PFormL16
     C                   PARM                    PFormL17
     C                   PARM                    PFormL18
     C                   PARM                    PFormL19
     C                   PARM                    PFormL20
     C                   PARM                    PFormL21
     C                   PARM                    PFormL22
      *
     C                   PARM                    Idx
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      *
     C                   ENDSR
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
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Branch code
      *
     C                   PARM                    PBrca
      *
      ** Customer Number
      *
     C                   PARM                    PCNum
      *
      ** Currency
      *
     C                   PARM                    PCcy
      *
      ** Account Number
      *
     C                   PARM                    PAccd
      *
      ** Account sequence
      *
     C                   PARM                    PAcsq
      *
      ** Details
      *
     C                   PARM                    PDetails
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************

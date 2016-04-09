     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX CLS Pay-in Schedule Read - Detail')
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  FXCLSPRE2 - CLS Pay-in Schedule Detail read                  *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the CLS Pay-in Schedule Details file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BUG5671            Date 31Jan05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG5671- Add Sequence number to detail record                *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** CLS Pay-in Schedule Detals file - keyed
     FFXCLSPSDL3IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
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
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Dealing details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PCcy_In         S              3A
     D PNost_In        S              2A
     D PVDat_In        S              6A
     D PSeq_In         S              2A
     D PTime_In        S              4A
      *PAmt_In*********S             18A                                                     BUG5671
     D PRdFwd          S              1A
     D PRdBck          S              1A
     D PErrMsg         S              7A
     D PCcy_Out        S              3A
     D PNost_Out       S              2A
     D PVDat_Out       S              6A
     D PSeq_Out        S              2A
     D PTime_Out       S              4A
      *PAmt_Out********S             18A                                                     BUG5671
     D PDSeq_In        S              2A                                                     BUG5671
     D PDSeq_Out       S              2A                                                     BUG5671
 
      ** Parameters for ZVACTU
     D PZAction        S              1A
     D PErrCode        S              1P 0
 
      ** Parameters for ZDATE2
     D PZDayNo         S              5P 0
     D PZDateN         S              6P 0
     D PZADate         S              7A
 
      ** Parameter for ZAVDATE
     D PZDate          S              6A
 
      ** Parameters for ZA0840
      *P_ALPH          S             16A                                                     BUG5671
      *P_MTID          S              1A                                                     BUG5671
      *P_AMT           S             15P 0                                                   BUG5671
      *P_ERCD          S              1P 0                                                   BUG5671
      *P_IDP           S              3P 0                                                   BUG5671
      *P_IINT          S              3P 0                                                   BUG5671
      *W1stTwo         S              2A                                                     BUG5671
 
      ** Parameters for ZA0921
     D PZAmount        S             15P 0
     D PZDecPl         S              1P 0
     D PZAmtP          S             16A
     D PZAmtD          S             17A
 
      ** Key fields
     D KCcy            S              3A
     D KNost           S              2A
     D KVDate          S              5P 0
     D KSeq            S              2S 0
     D KTime           S              4A
     D KAmt            S             17P 0
     D KDSeq           S              2S 0                                                   BUG5671
 
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
 
      ** Initialise outputs
 
     C                   EVAL      PErrMsg = *BLANKS
     C                   EVAL      PCcy_Out = *BLANKS
     C                   EVAL      PNost_Out = *BLANKS
     C                   EVAL      PVDat_Out = *BLANKS
     C                   EVAL      PSeq_Out = *BLANKS
     C                   EVAL      PTime_Out = *BLANKS
      *******************EVAL      PAmt_Out = *BLANKS                                        BUG5671
     C                   EVAL      PDSeq_Out = *BLANKS                                       BUG5671
 
      ** Check for user authority to browse if not multi-branching
 
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SrChckAut
     C                   ENDIF
 
      ** Initialise key fields
 
     C                   IF        PCcy_In <> *BLANKS AND
     C                             PNost_In <> *BLANKS AND
     C                             PVDat_In <> *BLANKS AND
     C                             PSeq_In <> *BLANKS
     C                   MOVEL     PCcy_In       KCcy
     C                   MOVEL     PNost_In      KNost
     C                   MOVE      PVDat_In      PZDate
     C                   EXSR      SrZAVDate
     C                   Z-ADD     PZDayNo       KVDate
     C                   MOVEL     PSeq_In       KSeq
     C                   MOVEL     PTime_In      KTime
      *******************EXSR      SrZA0840                                                  BUG5671
      *******************Z-ADD     P_AMT         KAmt                                        BUG5671
     C                   MOVEL     PDSeq_In      KDSeq                                       BUG5671
     C                   ENDIF
 
      ** Read forwards
 
     C                   IF        PRdFwd = 'Y'
     C                   EXSR      SrRdFwd
     C                   ELSE
 
      ** Read backwards
 
     C                   IF        PRdBck = 'Y'
     C                   EXSR      SrRdBck
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrRdFwd - Read forwards through CLS Pay-in Schedule Detail    *
      *****************************************************************
     C     SrRdFwd       BEGSR
 
      ** Position to current record on file
 
     C     KDetail       SETGT     FXCLSPSDL3
 
      ** Read next detail record
 
     C                   READ      FXCLSPSDL3                             87
 
      ** If end of file was encountered, report this fact
 
     C                   IF        *IN87 = '1'
     C                   EVAL      PErrMsg = 'MMM1002'
 
      ** Else, return the transaction reference read
 
     C                   ELSE
     C                   MOVEL     PYCCY         PCcy_Out
     C                   MOVEL     PYNOST        PNost_Out
     C                   Z-ADD     PYVDAT        PZDayNo
     C                   EXSR      SrZDate2
     C                   MOVE      PZDateN       PVDat_Out
     C                   MOVEL     PYSEQN        PSeq_Out
     C                   MOVEL     PYLTIM        PTime_Out
      *******************Z-ADD     PYAMT         PZAmount                                    BUG5671
      *******************EXSR      SrZA0921                                                  BUG5671
      *******************MOVE      PZAmtD        PAmt_Out                                    BUG5671
     C                   MOVEL     PYDSEQ        PDSeq_Out                                   BUG5671
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrRdBck - Read backwards through CLS Pay-in Schedule Detail   *
      *****************************************************************
     C     SrRdBck       BEGSR
 
      ** Position to current record on file
 
     C     KDetail       SETLL     FXCLSPSDL3
 
      ** Read previous detail record
 
     C                   READP     FXCLSPSDL3                             87
 
      ** If start of file was encountered, report this fact
 
     C                   IF        *IN87 = '1'
     C                   EVAL      PErrMsg = 'MMM1003'
 
      ** Else, return the transaction reference read
 
     C                   ELSE
     C                   MOVEL     PYCCY         PCcy_Out
     C                   MOVEL     PYNOST        PNost_Out
     C                   Z-ADD     PYVDAT        PZDayNo
     C                   EXSR      SrZDate2
     C                   MOVE      PZDateN       PVDat_Out
     C                   MOVEL     PYSEQN        PSeq_Out
     C                   MOVEL     PYLTIM        PTime_Out
      *******************Z-ADD     PYAMT         PZAmount                                    BUG5671
      *******************EXSR      SrZA0921                                                  BUG5671
      *******************MOVE      PZAmtD        PAmt_Out                                    BUG5671
     C                   MOVEL     PYDSEQ        PDSeq_Out                                   BUG5671
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrChckAut - Check for user authority if not multi-branching   *
      *****************************************************************
     C     SrChckAut     BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PZAction
     C                   PARM                    PErrCode
 
     C                   IF        PErrCode = 1
     C                   EVAL      PErrMsg = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZDate2 - Format a date for output                          *
      *****************************************************************
     C     SrZDate2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDateN
     C                   PARM      *BLANKS       PZADate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZAVDate - Format a date for output                         *
      *****************************************************************
     C     SrZAVDate     BEGSR
 
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PZDate
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDayNo
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZA0840 - Validate amount field                             *
      *****************************************************************
      *****SrZA0840      BEGSR                                                               BUG5671
      *****                                                                                  BUG5671
      *****              CALL      'AOCURRR0'                                                BUG5671
      *****              PARM      *BLANKS       @RtCd                                       BUG5671
      *****              PARM      '*KEY   '     @Optn                                       BUG5671
      *****              PARM      PCcy_In       @AJCD             3                         BUG5671
      *****SDCURR        PARM      SDCURR        DSSDY                                       BUG5671
      *****                                                                                  BUG5671
      *****              Z-ADD     A6NBDP        P_IDP                                       BUG5671
      *****15            SUB       A6NBDP        P_IINT                                      BUG5671
      *****              EVAL      P_MTID = 'Y'                                              BUG5671
      *****              EVAL      P_ALPH = *BLANKS                                          BUG5671
      *****              MOVEL     PAmt_In       W1stTwo                                     BUG5671
      *****                                                                                  BUG5671
      *****              IF        W1stTwo = *BLANKS                                         BUG5671
      *****              MOVE      PAmt_In       P_ALPH                                      BUG5671
      *****              ELSE                                                                BUG5671
      *****              EVAL      P_ALPH = PAmt_In                                          BUG5671
      *****              ENDIF                                                               BUG5671
      *****                                                                                  BUG5671
      *****              CALLB     'ZA0840'                                                  BUG5671
      *****              PARM                    RetCodeIn                                   BUG5671
      *****              PARM                    P_ALPH                                      BUG5671
      *****              PARM                    P_IDP                                       BUG5671
      *****              PARM                    P_IINT                                      BUG5671
      *****              PARM                    P_MTID                                      BUG5671
      *****              PARM                    P_ERCD                                      BUG5671
      *****              PARM                    P_AMT                                       BUG5671
      *****              PARM                    BNDCSP                                      BUG5671
      *****                                                                                  BUG5671
      *****              IF        PAmt_In = *BLANKS                                         BUG5671
      *****              EVAL      P_AMT = *ZERO                                             BUG5671
      *****              ENDIF                                                               BUG5671
      *****                                                                                  BUG5671
      *****ESrZA0840     ENDSR                                                               BUG5671
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZA0921 - Format Amount for Display                         *
      *****************************************************************
     C     SrZA0921      BEGSR
 
     C                   CALLB     'ZA0921'
     C                   PARM                    RetCodeOut
     C                   PARM                    PZAmount
     C                   PARM      A6NBDP        PZDecPl
     C                   PARM                    BNDCSP
     C                   PARM      *BLANKS       PZAmtP
     C                   PARM      *BLANKS       PZAmtD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input parameters :
 
      ** Return code
     C                   PARM                    RetCodeIn
      ** Action code
     C                   PARM                    ActionCode
      ** Currency
     C                   PARM                    PCcy_In
      ** Nostro code
     C                   PARM                    PNost_In
      ** Value date
     C                   PARM                    PVDat_In
      ** Sequence number
     C                   PARM                    PSeq_In
      ** Time (CET)
     C                   PARM                    PTime_In
      ** CLS Amount
      *******************PARM                    PAmt_In                                     BUG5671
      ** Detail Sequence number                                                              BUG5671
     C                   PARM                    PDSeq_In                                    BUG5671
      ** Read forwards
     C                   PARM                    PRdFwd
      ** Read backwards
     C                   PARM                    PRdBck
 
      ** Output Parameters :
 
      ** Error meassage
     C                   PARM                    PErrMsg
      ** Currency read
     C                   PARM                    PCcy_Out
      ** Nostro Number read
     C                   PARM                    PNost_Out
      ** Value Date read
     C                   PARM                    PVDat_Out
      ** CLS Sequence Number read
     C                   PARM                    PSeq_Out
      ** Time (CET) read
     C                   PARM                    PTime_Out
      ** CLS Amount read
      *******************PARM                    PAmt_Out                                    BUG5671
      ** CLS Detail Sequence Number read                                                     BUG5671
     C                   PARM                    PDSeq_Out                                   BUG5671
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'FXCLSPRE2'
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = @Optn
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Dealing details
 
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = @Optn
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise key fields
 
     C     KDetail       KLIST
     C                   KFLD                    KCcy
     C                   KFLD                    KNost
     C                   KFLD                    KVDate
     C                   KFLD                    KSeq
     C                   KFLD                    KTime
      *******************KFLD                    KAmt                                        BUG5671
     C                   KFLD                    KDSeq                                       BUG5671
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003

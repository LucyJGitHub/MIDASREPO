     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX CLS pay-in schedule Retrieve - Detail')
      *****************************************************************
      *                                                               *
      *  Midas - API Wrapper Project                                  *
      *                                                               *
      *  FXCSLPRT2 - CLS Pay-in Schedule Retrieve (Detail)            *
      *                                                               *
      *  Function:  This module retrieves the Pay-in Schedule Details *
      *             from the database.                                *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG5671            Date 07Mar05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG5671- Add Sequence number to detail record                *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFXCLSPSDL3IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the follocing variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      **---------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------------
 
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
 
      ** CLS Pay-in Schedule Detail in file format
     D CLSPFilFmt    E DS                  EXTNAME(FXCLSPSD)
 
      ** Error indicators - Detail
     D OKTrCLSP      E DS                  EXTNAME(FXECLSPDPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Dealing Details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  NOSTACCD     E                     EXTFLD(QQACCD)                                     CGL029
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D RespMode        S              1A
     D PCcy_In         S              3A
     D PNost_In        S              2A
     D PVDate_In       S              6A
     D PSeq_In         S              2A
     D PTime_In        S              4A
      *PAmt_In*********S             18A                                                     BUG5671
     D PDSeq_In        S              2A                                                     BUG5671
     D Ix              S              3P 0
 
      ** Parameters for AONOSTR0
     D PACCD           S              4A
     D PACSN           S              2A
     D PBRCD           S              3A
     D PCSSN           S             10A
     D PCUST           S              6A
     D PCYCD           S              3A
     D PNONB           S              2A
     D PPNOI           S              1A
 
      ** Parameter for AOBRCHR0
     D PBrca           S              3A
 
      ** Parameters for ZVACTU/ZVACTBU
     D PZAction        S              1A
     D PZBranch        S              3A
     D PErrCode        S              1P 0
 
      ** Parameter for ZAVDATE
     D PZDate          S              6A
     D PZDayNo         S              5P 0
 
      ** Parameters for ZA0840
      *P_ALPH          S             16A                                                     BUG5671
      *P_MTID          S              1A                                                     BUG5671
      *P_AMT           S             15P 0                                                   BUG5671
      *P_ERCD          S              1P 0                                                   BUG5671
      *P_IDP           S              3P 0                                                   BUG5671
      *P_IINT          S              3P 0                                                   BUG5671
      *W1stTwo         S              2A                                                     BUG5671
 
      ** Key list
     D KeyCcy          S              3A
     D KeyNost         S              2A
     D KeyVDate        S              5P 0
     D KeySeq          S              2S 0
     D KeyTime         S              4A
     D KeyAmt          S             17P 0
     D KeyDSeq         S              2S 0                                                   BUG5671
                                                                                             BUG5671
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Perform initialisation to clear outputs
 
     C                   CLEAR                   CLSPFilFmt
     C                   MOVEL     *ALL'Y'       OKTrCLSP
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      Ix = *ZERO
     C                   MOVE      *BLANKS       FldNameArr
     C                   MOVE      *BLANKS       MsgIdArr
     C                   MOVE      *BLANKS       MsgDtaArr
 
      ** Retrieve Detail record
 
     C                   EXSR      SrRtv
 
      ** Access Security Checking - single or multi-branching
 
     C                   IF        RespMode= 'S'
 
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SrChkAutS
     C                   ELSE
     C                   EXSR      SrChkAutM
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRtv - Retrieve detail record                               *
      *****************************************************************
     C     SrRtv         BEGSR
 
      ** Check record exists on LF/FXCLSPSDL3
 
     C                   EVAL      KeyCcy = PCcy_In
     C                   EVAL      KeyNost = PNost_In
     C                   MOVEL     PVDate_In     PZDate
     C                   EXSR      SrZAVDate
     C                   Z-ADD     PZDayNo       KeyVDate
     C                   MOVE      PSeq_In       KeySeq
     C                   EVAL      KeyTime = PTime_In
      *******************EXSR      SrZA0840                                                  BUG5671
      *******************Z-ADD     P_AMT         KeyAmt                                      BUG5671
     C                   MOVE      PDSeq_In      KeyDSeq                                     BUG5671
 
     C     KDetail       CHAIN     FXCLSPSDL3                         81
 
     C                   IF        *IN81 = *ON
     C                   EVAL      CLSCCYOK = 'N'
     C                   EVAL      CLSNSTOK = 'N'
     C                   EVAL      CLSVDTOK = 'N'
     C                   EVAL      CLSSEQOK = 'N'
     C                   EVAL      CLSTIMOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNAmeArr(Ix) = 'CLSACT'
     C                   EVAL      MsgIdArr(Ix) = 'FXM3019'
     C                   ENDIF
 
     C     ESrRtv        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrChkAutS - Check for user authority if not multi-branching  *
      *****************************************************************
     C     SrChkAutS     BEGSR
 
      ** Validate action codes for user
 
     C                   CALL      'ZVACTU'
     C                   PARM      ActionCode    PZAction
     C                   PARM                    PErrCode
 
     C                   IF        PErrCode = 1
     C                   EVAL      CLSACTOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'CLSACT'
     C                   EVAL      MsgIdArr(Ix) = 'FXM3023'
     C                   ENDIF
 
     C     ESrChkAutS    ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SrChkAutM - Check for user authority if multi-branching      *
      *****************************************************************
     C     SrChkAutM     BEGSR
 
      ** If insertion, set up the booking branch with the default value
 
     C                   IF        ActionCode = 'I'
     C                   MOVE      BRC           PZBranch
     C                   ELSE
 
     C                   IF        CLSCCYOK = 'Y' AND CLSNSTOK = 'Y'
     C                   EXSR      SrAONost
 
     C                   IF        @RtCd = *BLANKS
     C                   MOVE      A7BRCD        PZBranch
     C                   ELSE
     C                   EVAL      CLSNSTOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'CLSNST'
     C                   EVAL      MsgIdArr(Ix) = 'FXM3005'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the branch code exists on SDBRCHPD
 
     C                   IF        ActionCode = 'I'
     C                   EXSR      SrAONost
 
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      A7BRCD        PBrca
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   IF        @RtCd = *BLANKS
     C                   EVAL      PZBranch = A8BRCD
     C                   ELSE
     C                   EVAL      CLSACTOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'CLSACT'
     C                   EVAL      MsgIdArr(Ix) = 'FXM3023'
     C                   ENDIF
 
     C                   ENDIF
 
      ** If valid branch on insert then check user authority to
      ** action/branch, also if not insert.
 
     C                   IF        ActionCode = 'I' AND
     C                             @RtCd = *BLANKS OR
     C                             ActionCode <> 'I'
 
     C                   CALL      'ZVACTBU'
     C                   PARM      ActionCode    PZAction
     C                   PARM                    PZBranch
     C                   PARM                    PErrCode
 
      ** No valid action codes for user/branch combination
 
     C                   IF        PErrCode = 1
     C                   EVAL      CLSACTOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'CLSACT'
     C                   EVAL      MsgIdArr(Ix) = 'FXM3023'
     C                   ENDIF
 
      ** This action code invalid for user/branch combination
 
     C                   IF        PErrCode = 2
     C                   EVAL      CLSACTOK = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'CLSACT'
     C                   EVAL      MsgIdArr(Ix) =   'FXM3023'
     C                   ENDIF
 
     C                   ENDIF
 
     C     ESrChkAutM    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrAONost - Call access object for Nostro details             *
      *****************************************************************
     C     SrAONost      BEGSR
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      *BLANKS       PCUST
     C     PCcy_In       PARM      PCcy_In       PCYCD
     C                   PARM      *BLANKS       PACCD
     C                   PARM      *BLANKS       PACSN
     C     PNost_In      PARM      PNost_In      PNONB
     C                   PARM      *BLANKS       PBRCD
     C                   PARM      *BLANKS       PCSSN
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C     ESrAONost     ENDSR
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
 
     C     ESrZAVDate    ENDSR
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
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
      ** Input parameters:
      ** Return code
     C                   PARM                    RetCodeIn
      * Response mode
     C                   PARM                    RespMode
      ** Action Code
     C                   PARM                    ActionCode
      ** Ccy code
     C                   PARM                    PCcy_In
      ** Nostro Code
     C                   PARM                    PNost_In
      ** Value date
     C                   PARM                    PVDate_In
      ** Sequence number
     C                   PARM                    PSeq_In
      ** Time (CET)
     C                   PARM                    PTime_In
      ** CLS Amount
      *******************PARM                    PAmt_In                                     BUG5671
      ** Detail Sequence number                                                              BUG5671
     C                   PARM                    PDSeq_In                                    BUG5671
      ** Output Parameters:
      ** CLS Pay-in schedule in file format - Detail
     C                   PARM                    CLSPFilFmt
      ** OK Flags
     C                   PARM                    OKTrCLSP
      ** Error Array Index
     C                   PARM                    Ix
      ** Error Field Name Array
     C                   PARM                    FldNameArr
      ** Error Message ID Array
     C                   PARM                    MsgIdArr
      ** Error Message Data Array
     C                   PARM                    MsgDtaArr
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'FXCLSPRT2'
 
      ** Key List
 
     C     KDetail       KLIST
     C                   KFLD                    KeyCcy
     C                   KFLD                    KeyNost
     C                   KFLD                    KeyVDate
     C                   KFLD                    KeySeq
     C                   KFLD                    KeyTime
      *******************KFLD                    KeyAmt                                      BUG5671
     C                   KFLD                    KeyDSeq                                     BUG5671
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFILE = 'SDBANKPD'
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
     C                   EVAL      DBASE = 002
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBKEY = @Optn
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2003

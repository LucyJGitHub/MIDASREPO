     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments margins info display')      *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTIPAY3DP - Incoming Payments Margins Info Display           *
      *                                                               *
      *  Function:  This API module will serve as the screen display/ *
      *             input module of Margins Informations. This fields *
      *             were previously being displayed in FTIPAY3DP and  *
      *             validated by FTIPAY3VL but were moved here to act *
      *             as an additional information screen for outgoing  *
      *             maintenance when Analytical Accounting is switched*
      *             on and Margin Info details is not blank.          *
      *                                                               *
      *  Called By: FTIPAY2SN                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD027047           Date 19Aug14               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CAP084             Date 25Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027047 - Avoid HATS issue with redisplaying previous screen*
      *             on the stack. End program with SETON LR with no   *
      *             RETURN.                                           *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Recompiled over changed FTIPY6PD.                   *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTIPAY5DF CF   E             WORKSTN INFDS(INFDS#)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       68  Position cursor on action code (if it is blank)     *
      *       77  Enable CF04, BIC DB+ Prompt                         *
      *       78  Enable CF16, BIC DB+ Search                         *
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      *                                                               *
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------
 
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
 
     D @EI             S              1    DIM(60)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
 
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      ** Screen fields (Screen 1)
 
     D NwIP6ScnFmt   E DS                  EXTNAME(FTIPY6PD)
      ** Screen fields (Margin Info Screen)
      *                                                                                       CER030
     D NwIP6AScnFmt  E DS                  EXTNAME(FTIPY6APD)                                 CER030
      *                                                                                       CER030
      ** External DS for Extended Narratives                                                  CER030
      *                                                                                       CER030
 
     D FTEIPY5       E DS                  EXTNAME(FTEIPY5PD)
      ** Error Indicators (Margin Info Screen)
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER030
      *                                                                                       CER030
      ** Externally described DS for Midas Modules details                                    CER030
      *                                                                                       CER030
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER030
      *                                                                                       CER030
      ** External DS for SAR Details                                                          CER030
      *                                                                                       CER030
     D  FuncText       DS            33
     D  F3text                 1      9
     D  F5text                10     21
     D  F12text               22     33
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D #MSDTA          S            132
     D #MSTX1          S            132
     D #MSTX2          S            512
      *                                                                                       CER030
      ** Fields added for CER030                                                              CER030
      *                                                                                       CER030
     D PRtcd           S              7A                                                      CER030
     D POptn           S              7A                                                      CER030
     D PSard           S              6A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CER030          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Main processing
 
     C                   ExSr      SrMain
 
      ** Command F3 pressed, exit
 
     C**********         If        @INKC = *On                                              MD027047
     C                   Eval      *INLR = *On
     C**********         EndIf                                                              MD027047
 
     C**********         Return                                                             MD027047
 
      *****************************************************************
      /Title Sr/SrMain
      *****************************************************************
      *                                                               *
      * SR/SrMain    - Main processing                                *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrMain        BegSr
 
      ** Move 'OK' flags into array for checking
 
     C                   MoveA     FTEIPY5       @EI
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-Add     1             C                 2 0
     C                   Z-Add     10            E                 2 0
 
     C                   DoU       C > 60
     C                   If        (@EI(C) = 'N') Or (@EI(C) = 'W')
     C                   Eval      *IN(E) = *On
     C                   EndIf
     C                   Eval      C = C + 1
     C                   Eval      E = E + 1
     C                   Enddo
 
      ** Set up the payment reference to be used by the message handler
 
     C                   Eval      TranRef = DDPREF
     C                   Eval      ActionCode = DDACTN
 
      **---------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
 
      ** Position cursor on action code if it is blank
 
     C     DDACTN        Comp      *BLANK                                 68
 
      ** Enable detail fields (all fields except action code & payment
      ** Reference
 
     C     @EDTFD        Comp      'Y'                                7070
 
      ** Set up function key footer text
 
     C                   Eval      SCCMDTXT = *Blanks
     C                   Eval      %SUBST(SCCMDTXT:1:9) = F3text
     C                   Eval      %SUBST(SCCMDTXT:22:12) = F12text
 
      ** Disable F5 key if detail fields not amendable,
 
     C                   If        *IN70 = True
     C                   Eval      *IN71 = False
     C                   Eval      %SUBST(SCCMDTXT:10:12) = *Blank
     C                   Else
     C                   Eval      *IN71 = True
     C                   Eval      %SUBST(SCCMDTXT:10:12) = F5text
     C                   EndIf
      *                                                                                       CER030
      ** Conditioning display of margin info fields                                           CER030
      *                                                                                       CER030
     C                   EVAL      *IN74 = *OFF                                               CER030
      *                                                                                       CER030
     C                   IF        BGN0ST = 'Y'                                               CER030
     C                   IF        (DDSMCY = DDPCCY)                                          CER030
     C                             AND (DDMBSI = *BLANKS)                                     CER030
     C                             AND (DDMSIG = *BLANKS)                                     CER030
     C                   EVAL      *IN74 = *OFF                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      *IN74 = *ON                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
 
      ** Write message subfile, details and footer screen
 
     C                   Time                    DDTime
     C                   Write     FTIPAY5S0
     C                   Write     FTIPAY5D1
     C                   Write     FTIPAY5F1
 
      ** Read details screen
 
     C                   If        WriteOnly <> 'Y'
     C                   Read      FTIPAY5D1                              01
     C                   EndIf
 
      ** Clear message subfile
 
     C                   Call      'ZA0250'
 
      ** Set screen error indicators off
 
     C                   MoveA     @Z0           *IN(10)
 
      ** Set return keys
 
     C                   Move      *INKC         @INKC
     C                   Move      *INKL         @INKL
     C                   Move      *INKE         @INKE
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/*InzSr
      *****************************************************************
      *                                                               *
      * SR/*InzSr     - Initial Processing                            *
      *                                                               *
      * Called By: Automatically executed when program starts         *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
      ** Receive input parameters
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   PARM                    NwIP1ScnFmt
     C                   PARM                    NwIP6ScnFmt
     C                   PARM                    NwIP6AScnFmt                                 CER030
     C                   PARM                    FTEIPY5
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EDTFD            1
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKE             1
     C                   PARM                    WriteOnly         1
     C                   PARM      @#RWCL        CursorLoc         5 0
 
      ** Initialise program name
 
     C                   Eval      DBPGM = 'FTIPAY5DP'
 
      ** Workstation ID
 
     C                   Eval      DDWID = PsJobName
 
      ** Access Bank Details via Access Object AOBANKR0
 
     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RTCD         IfNe      *BLANKS
     C                   MoveL     'SDBANKPD'    DBFILE
     C                   Z-Add     1             DBASE
     C                   MoveL     @Optn         DBKEY
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Retrieve the text for footer function keys using MEC1150
 
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTM2627'     #MSGID
     C                   Parm      'FTUSRMSG'    #MsgFile
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
 
     C                   Movel     #MSTX1        FuncText
 
      ** Message subfile control
 
     C                   Move      True          *IN97
     C                   Movel     '*'           DDPGMQ
      *                                                                                       CER030
      ** Check the switchable feature CER031                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   EVAL      *IN72 = *ON                                                CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 002                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CER030                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   EVAL      *IN73 = *ON                                                CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 003                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CGL013                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CGL013'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CGL013 = 'Y'                                               CER030
     C                   EVAL      *IN73 = *ON                                                CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 004                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Access Midas Modules details.                                                        CER030
      *                                                                                       CER030
     C                   CALLB     'AOMMODR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*FIRST '     POptn                                        CER030
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER030
      *                                                                                       CER030
      ** Database error.                                                                      CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> *BLANKS                                           CER030
     C                   EVAL      DBFILE = 'SDMMODPD'                                        CER030
     C                   EVAL      DBASE = 005                                                CER030
     C                   EVAL      DBKEY = POptn                                              CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
 
      **---------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for FT *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     C/COPY FTCPYSRC,MSGHNDDATA
      **---------------------------------------------------------------
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      **---------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  @Z0
000000000000000000000000000000000000000000000000000000000000

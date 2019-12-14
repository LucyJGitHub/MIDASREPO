     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Validate and Update')   *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLRPIFVU - Midas DL Reporting Information Validate/Update    *
      *                                                               *
      *  Function: This program validates DL RPIF user input.         *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD054604           Date 19Nov19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSW216             Date 14Mar16               *
      *                 MD030858A          Date 25Nov14               *
      *                 MD030858           Date 25Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 MD024185           Date 19Dec13               *
      *                 MD023922           Date 11Dec13               *
      *                 MD023734           Date 30Nov13               *
      *                 MD023037           Date 21Nov13               *
      *                 MD022981           Date 12Nov13               *
      *                 MD023169           Date 03Nov13               *
      *                 MD022370           Date 18Sep13               *
      *                 CSW213 *CREATE     Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054604 - A Serious Midas Error Occurred whilst inputting   *
      *             FX Swap                                           *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  MD030858A - Execution timestamp (Date) is not generated when *
      *             the RPIF fields were populated via Interface      *
      *             (Reopen)                                          *
      *  MD030858 - Execution timestamp (Date) is not generated when  *
      *             the RPIF fields were populated via Interface      *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD024185 - Serious midas error encountered when link swap id *
      *             of first leg swap is blank and non-blank for the  *
      *             second leg swap.                                  *
      *  MD023922 - If the link swap ID is input on the second leg,   *
      *             it will be amended on the first leg.              *
      *  MD023734 - Clearing Threshold Indicator not defaulted.       *
      *  MD023037 - Date and time should not be defaulted if only     *
      *             Trade Repository details are present.             *
      *  MD022981 - Seq 15E without succeeding field tags generated   *
      *  MD023169 - Link Swap ID, UTI Namespace, and Trans ID of the  *
      *             2nd leg swap deal not defaulted from first leg    *
      *             when not found in SDRPIFPD.                       *
      *  MD022370 - Execution timestamp date not defaulted if         *
      *             reporting info default is not defined.            *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
                                                                                            MD023169
      ** DL Reporting Information (For SWAP Deals)                                          MD023169
     F***DLRPIFL0  IF   E           K DISK    RENAME(DLRPIFD0:DLRPIF00)            MD023169 MD023922
     F***DLRPIFL0  UF   E           K DISK    RENAME(DLRPIFD0:DLRPIF00)            MD023922 MD024185
     FDLRPIFL0  IF   E           K DISK    RENAME(DLRPIFD0:DLRPIF00)                        MD024185
     F                                     PREFIX(SW_)                                      MD023169
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D****/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
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
 
      ** Array of Fields in error.
     D @FldNameArr     S             10A   DIM(ArrayMax)
 
      ** Array of error message IDs
     D @MsgIDArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      ** Array of error message data.
     D @MsgDtaArr      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
 
      ** Array of message files to check
     D @MsgFArray      S             10A   DIM(MsgFArrMax)
 
      * Transaction Reporting File Format
     D DLRPIFFileFmt E DS                  EXTNAME(DLRPIFPD)
 
      * Transaction Reporting Screen (1) - Input
     D DLRIS1PDIn    E DS                  EXTNAME(DLRIS1PD)
     D DLRIS1Flds             52    449                                                     MD023037
 
      * Transaction Reporting Screen (2) - Input
     D DLRIS2PDIn    E DS                  EXTNAME(DLRIS2PD)
 
      * Transaction Reporting Screen (3) - Input
     D DLRIS3PDIn    E DS                  EXTNAME(DLRIS3PD)
     D DLRIS3Flds              1     38                                                     MD030858
                                                                                              CSW214
      ** Transaction Reporting Screen (4) - Input                                             CSW214
     D DLRIS4PDIn    E DS                  EXTNAME(DLRIS4PD)                                  CSW214
                                                                                              CSW214
     D***DLRIS3Flds              1    721                                            MD022981 CSW214
     D***DLRIS3Flds              1     38                                            CSW214 MD030858
 
      * Transaction Reporting Screen (1) - Output
     D DLRIS1PDOut   E DS                  EXTNAME(DLRIS1PD)
     D                                     PREFIX(OUT)
 
      * Transaction Reporting Screen (2) - Output
     D DLRIS2PDOut   E DS                  EXTNAME(DLRIS2PD)
     D                                     PREFIX(OUT)
 
      * Transaction Reporting Screen (3) - Output
     D DLRIS3PDOut   E DS                  EXTNAME(DLRIS3PD)
     D                                     PREFIX(OUT)
                                                                                              CSW214
      ** Transaction Reporting Screen (4) - Output                                            CSW214
     D DLRIS4PDOut   E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D                                     PREFIX(OUT)                                        CSW214
 
      * Valid RPIF File Format
     D DLVRPIFileFmt E DS                  EXTNAME(DLVRPIPD)
 
      * RPIF Link File
     D DLRILKPDIn    E DS                  EXTNAME(DLRILKPD)
 
      * RPIF Error File - Screen 1
     D DLERI1OKFlag  E DS                  EXTNAME(DLERI1PD)
 
      * RPIF Error File - Screen 2
     D DLERI2OKFlag  E DS                  EXTNAME(DLERI2PD)
 
      * RPIF Error File - Screen 3
     D DLERI3OKFlag  E DS                  EXTNAME(DLERI3PD)
                                                                                              CSW214
      ** RPIF Error File - Screen 4                                                           CSW214
     D DLERI4OKFlag  E DS                  EXTNAME(DLERI4PD)                                  CSW214
 
      * First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
     D WErrFlag        S              1
     D ErrFlag1        S              1
     D ErrFlag2        S              1
     D ErrFlag3        S              1
     D ErrFlag4        S              1                                                       CSW214
     D PRetCode        S              7
     D PRtCd           S              7
     D POptn           S              7
     D PCurr           S              3
     D UpdateYn        S              1
     D APIRetc         S              1
     D ValScrnNo       S              1P 0
     D DftFound        S              1A                                                    MD022981
     D WTime           S              6  0                                                  MD023037
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      * Reset error fields
 
     C                   EXSR      ResetCycle
 
     C                   IF        UpdateYN = 'Y'
      *
      ** Validate fields only when in insert or amend mode (For SOAP)
      *
     C                   IF        RLACTN = 'I' OR RLACTN = 'A' OR
     C                             RLACTN = 'X'
 
     C                   EXSR      SRDftRecords
     C                   ENDIF
      *
      ** If already for update, revalidate fields
      ** before calling update program.
      *
     C                   EXSR      SRValScrn1
     C                   EVAL      ErrFlag1 = WErrFlag
     C                   EXSR      SRValScrn2
     C                   EVAL      ErrFlag2 = WErrFlag
     C                   EXSR      SRValScrn3
     C                   EVAL      ErrFlag3 = WErrFlag
     C                   EXSR      SRValScrn4                                                 CSW214
     C                   EVAL      ErrFlag4 = WErrFlag                                        CSW214
 
     C                   IF        ErrFlag1 = 'N' AND ErrFlag2 = 'N'
     C                             AND ErrFlag3 = 'N'
     C                             AND ErrFlag4 = 'N'                                         CSW214
     C                   EXSR      SRUpdate
     C                   ENDIF
 
     C                   ELSE
      *
      ** Validate fields only when in insert or amend mode
      *
     C                   IF        RLACTN = 'I' OR RLACTN = 'A' OR
     C                             RLACTN = 'X'
 
     C                   EXSR      SRDftRecords
 
     C                   SELECT
     C                   WHEN      ValScrnNo = 0
     C                   EXSR      SRValScrn1
     C                   EXSR      SRValScrn2
     C                   EXSR      SRValScrn3
     C                   EXSR      SRValScrn4                                                 CSW214
     C                   WHEN      ValScrnNo = 1
     C                   EXSR      SRValScrn1
     C                   WHEN      ValScrnNo = 2
     C                   EXSR      SRValScrn2
     C                   WHEN      ValScrnNo = 3
     C                   EXSR      SRValScrn3
     C                   WHEN      ValScrnNo = 4                                              CSW214
     C                   EXSR      SRValScrn4                                                 CSW214
     C                   ENDSL
 
     C                   ENDIF
 
     C                   IF        RLACTN = 'D'
     C                   EVAL      DLRIS1PDOut = DLRIS1PDIn
     C                   EVAL      DLRIS2PDOut = DLRIS2PDIn
     C                   EVAL      DLRIS3PDOut = DLRIS3PDIn
     C                   EVAL      DLRIS4PDOut = DLRIS4PDIn                                   CSW214
     C                   ENDIF
     C
     C                   ENDIF
 
     C                   SETON                                        LR                    MD054604
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDftRecords - Call DLRPIFDFT to check if default record in   *
      *    SDRPIFPD is available when called from CTL program         *
      *                                                               *
      *****************************************************************
 
     C     SRDftRecords  BEGSR
      *
      ** If any of the 3 screens have values, bypass this routine
      **  otherwise, call the defaulting program
      *
     C                   IF        DLRIS1PDIn = *BLANKS AND
     C                             DLRIS2PDIn = *BLANKS AND
     C                             DLRIS3PDIn = *BLANKS AND
     C                             DLRIS4PDIn = *BLANKS AND                                   CSW214
     C                             ValScrnNo = 0
 
     C                   CALLB     'DLRPIFDFT'
 
     C                   PARM      *BLANKS       PRetCode
 
     C                   PARM                    DLRILKPDIn
      ** Transaction Reporting screen 1
     C                   PARM      *BLANKS       DLRIS1PDIn
      ** Transaction Reporting screen 2
     C                   PARM      *BLANKS       DLRIS2PDIn
      ** Transaction Reporting screen 3
     C                   PARM      *BLANKS       DLRIS3PDIn
      ** Transaction Reporting screen 4                                                       CSW214
     C                   PARM      *BLANKS       DLRIS4PDIn                                   CSW214
      ** Pay Amount                                                                         MD023734
     C                   PARM                    PayAmount                                  MD023734
 
     C                   IF        PRetCode = '*NRF'                                        MD022981
     C                   EVAL      DftFound = 'N'                                           MD022981
     C                   ELSE                                                               MD022981
     C                   EVAL      DftFound = 'Y'                                           MD022981
     C                   ENDIF                                                              MD022981
                                                                                            MD022981
     C                   IF        PRetCode = '*NRF' AND                                    MD023169
     C                             RLAPID = 'FXDL' AND                                      MD023169
     C                             RLDTYP = 'SW' AND                                        MD023169
     C                             RLLTRF <> *BLANKS AND                                    MD023169
     C                             RLACTN = 'I'                                             MD023169
                                                                                            MD023169
     C     RPIFKey       CHAIN     DLRPIFL0                                                 MD023169
     C                   IF        %FOUND                                                   MD023169
     C                   EVAL      R1LSID = SW_RILSID                                       MD023169
     C                   EVAL      R2UTI1 = SW_RIUT01                                       MD023169
     C                   EVAL      R2TRI1 = SW_RITNI1                                       MD023169
     C                   IF        R2UTI1 <> *BLANKS AND                                    MD023169
     C                             R2TRI1 <> *BLANKS                                        MD023169
     C                   EVAL      R2TTY1 = '0'                                             MD023169
     C                   EVAL      R2EVT1 = '0'                                             MD023169
     C                   ENDIF                                                              MD023169
     C                   ENDIF                                                              MD023169
                                                                                            MD023169
     C                   ENDIF                                                              MD023169
                                                                                            MD023169
     C                   ELSEIF    RLFOID <> *BLANKS                                       MD030858A
     C                   EVAL      DftFound = 'N'                                          MD030858A
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValScrn1 - Validate inputs from screen 1                    *
      *                                                               *
      *****************************************************************
 
     C     SRValScrn1    BEGSR
 
     C                   CALLB     'DLRIS1VAL'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    DLRILKPDIn
     C                   PARM                    DLRIS1PDIn
     C                   PARM      *BLANKS       DLERI1OKFlag
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    DLVRPIFileFmt
 
     C                   EVAL      WErrFlag = 'N'
     C                   EVAL      DLRIS1PDOut = DLRIS1PDIn
 
     C     Idx           IFNE      0
     C                   EVAL      WErrFlag = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValScrn2 - Validate inputs from screen 2                    *
      *                                                               *
      *****************************************************************
 
     C     SRValScrn2    BEGSR
 
     C                   CALLB     'DLRIS2VAL'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    DLRILKPDIn
     C                   PARM                    DLRIS1PDIn
     C                   PARM                    DLRIS2PDIn
     C                   PARM      *BLANKS       DLERI2OKFlag
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    DLVRPIFileFmt
 
     C                   EVAL      WErrFlag = 'N'
     C                   EVAL      DLRIS2PDOut = DLRIS2PDIn
 
     C     Idx           IFNE      0
     C                   EVAL      WErrFlag = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValScrn3 - Validate inputs from screen 3                    *
      *                                                               *
      *****************************************************************
 
     C     SRValScrn3    BEGSR
 
     C                   IF        R3TSDT = *BLANKS AND                                     MD022370
     C**********                    (DLRIS1PDIn <> *BLANKS OR                      MD022370 MD023037
     C                              (DLRIS1Flds <> *BLANKS OR                               MD023037
     C                               DLRIS2PDIn <> *BLANKS OR                               MD022370
     C**********                     DLRIS3PDIn <> *BLANKS)                        MD022370 MD022981
     C**********                     DLRIS3Flds <> *BLANKS) AND                      MD022981 CSW214
     C                               DLRIS3Flds <> *BLANKS OR                                 CSW214
     C                               DLRIS4PDIn <> *BLANKS) AND                               CSW214
     C***********                    DftFound = 'N' AND                            MD022981 MD030858
     C***********                    (DftFound = 'N' OR                           MD030858 MD030858A
     C***********                    DftFound = *BLANKS AND                       MD030858 MD030858A
     C***********                    RLFOID <> *BLANKS) AND                       MD030858 MD030858A
     C                               DftFound = 'N' AND                                    MD030858A
     C                               RLACTN <> 'X'                                          MD022981
                                                                                            MD030858
     C                   IF        RLFOID = *BLANKS                                         MD030858
     C                   EVAL      DftFound = 'Y'                                           MD022981
     C                   ENDIF                                                              MD030858
                                                                                            MD030858
     C                   IF        RLVALD <> *BLANKS AND                                    MD023037
     C                              R3TSTM = *BLANKS                                        MD023037
     C                   TIME                    WTime                                      MD023037
     C                   MOVEL     WTime         R3TSTM                                     MD023037
     C                   ENDIF                                                              MD023037
     C                   EVAL      R3TSDT = RLVALD                                          MD022370
     C                   ENDIF                                                              MD022370
                                                                                            MD022370
     C                   CALLB     'DLRIS3VAL'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    DLRILKPDIn
     C                   PARM                    DLRIS1PDIn
     C                   PARM                    DLRIS2PDIn
     C                   PARM                    DLRIS3PDIn
     C                   PARM      *BLANKS       DLERI3OKFlag
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    DLVRPIFileFmt
 
     C                   EVAL      WErrFlag = 'N'
     C                   EVAL      DLRIS3PDOut = DLRIS3PDIn
 
     C     Idx           IFNE      0
     C                   EVAL      WErrFlag = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSW214
      *****************************************************************                       CSW214
      *                                                               *                       CSW214
      * SRValScrn4 - Validate inputs from screen 4                    *                       CSW214
      *                                                               *                       CSW214
      *****************************************************************                       CSW214
                                                                                              CSW214
     C     SRValScrn4    BEGSR                                                                CSW214
                                                                                              CSW214
     C                   CALLB     'DLRIS4VAL'                                                CSW214
     C                   PARM      *BLANKS       PRetCode                                     CSW214
     C                   PARM                    DLRILKPDIn                                   CSW214
     C                   PARM                    DLRIS1PDIn                                   CSW214
     C                   PARM                    DLRIS2PDIn                                   CSW214
     C                   PARM                    DLRIS3PDIn                                   CSW214
     C                   PARM                    DLRIS4PDIn                                   CSW214
     C                   PARM      *BLANKS       DLERI4OKFlag                                 CSW214
     C                   PARM                    FldNameArr                                   CSW214
     C                   PARM                    MsgIdArr                                     CSW214
     C                   PARM                    MsgDtaArr                                    CSW214
     C                   PARM                    Idx                                          CSW214
     C                   PARM                    WFldNamArr                                   CSW214
     C                   PARM                    WMsgIdArr                                    CSW214
     C                   PARM                    WMsgDtaArr                                   CSW214
     C                   PARM                    WIdx                                         CSW214
     C                   PARM                    DLVRPIFileFmt                                CSW214
                                                                                              CSW214
     C                   EVAL      WErrFlag = 'N'                                             CSW214
     C                   EVAL      DLRIS4PDOut = DLRIS4PDIn                                   CSW214
                                                                                              CSW214
     C     Idx           IFNE      0                                                          CSW214
     C                   EVAL      WErrFlag = 'Y'                                             CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDSR                                                                CSW214
      *****************************************************************                       CSW214
      /EJECT
      *****************************************************************
      *                                                               *
      * ResetCycle- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************
 
     C     ResetCycle    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update Reporting Information File                  *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
     C                   EVAL      RVAPID = RLAPID
     C                   EVAL      RVTRRF = RLTRRF
     C                   EVAL      RVBRCA = RLBRCA
     C                   EVAL      RVLNRF = RLLTRF
     C                   EVAL      RVCPID = RLCNUM
     C                   EVAL      RVDTYP = RLDTYP
     C                   EVAL      RVDLST = RLDLST
     C                   EVAL      RVFOID = RLFOID
     C                   EVAL      RVAFOI = RLAFOI
     C                   EVAL      RVBCCY = RLBCCY
     C                   EVAL      RVSCCY = RLSCCY
     C                   EVAL      RVCHTP = RLACTN
      *
      ** Retrieve precious metal indicator of buy currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      RVBCCY        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      RVBPMI = A6PMRT
     C                   ENDIF
      *
      ** Retrieve precious metal indicator of sell currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      RVSCCY        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      RVSPMI = A6PMRT
     C                   ENDIF
 
     C                   CALLB     'DLRPIFUPD'
     C                   PARM      *BLANKS       PrtCd
     C                   PARM                    DLVRPIFileFmt
 
     C                   IF        PRtCd = '*ERROR'
     C                   EVAL      APIRetc = '0'
     C                   ELSE
     C                   EVAL      APIRetc = '1'
     C**********         IF        RLAPID = 'FXDL' AND                             MD023922 MD024185
     C**********                   RLDTYP = 'SW' AND                               MD023922 MD024185
     C**********                   RLLTRF <> *BLANKS AND                           MD023922 MD024185
     C**********                   RLACTN = 'I' AND                                MD023922 MD024185
     C**********                   RVLSID <> *BLANKS                               MD023922 MD024185
     C*****RPIFKey       CHAIN     DLRPIFL0                                        MD023922 MD024185
     C**********         IF        %FOUND AND SW_RILSID <> RVLSID                  MD023922 MD024185
     C**********         EVAL      SW_RILSID = RVLSID                              MD023922 MD024185
     C**********         UPDATE    DLRPIF00                                        MD023922 MD024185
     C**********         ENDIF                                                     MD023922 MD024185
     C**********         ENDIF                                                     MD023922 MD024185
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    DLRILKPDIn
     C                   PARM                    DLRIS1PDIn
     C                   PARM                    DLRIS2PDIn
     C                   PARM                    DLRIS3PDIn
     C                   PARM                    DLRIS4PDIn                                   CSW214
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    MsgFArray
     C                   PARM                    DLRIS1PDOut
     C                   PARM                    DLRIS2PDOut
     C                   PARM                    DLRIS3PDOut
     C                   PARM                    DLRIS4PDOut                                  CSW214
     C                   PARM                    UpdateYN
     C                   PARM                    APIRetc
     C                   PARM                    ValScrnNo
     C                   PARM                    DLVRPIFileFmt
     C                   PARM                    DLERI1OKFlag
     C                   PARM                    DLERI2OKFlag
     C                   PARM                    DLERI3OKFlag
     C                   PARM                    DLERI4OKFlag                                 CSW214
     C                   PARM                    PayAmount        14                        MD023734
 
      *
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
     C     RPIFKey       KLIST                                                              MD023169
     C                   KFLD                    RLAPID                                     MD023169
     C                   KFLD                    RLLTRF                                     MD023169
                                                                                            MD023169
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT

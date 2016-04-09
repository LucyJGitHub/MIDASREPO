     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('MIDAS SD Network Transaction Code')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD009680 - MIDAS SD Validate Network Transaction Code  *
      *                                                               *
      *  Function : This module validates *GVC Network transaction    *
      *             code for AWVGVCDefault system value.              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CGL152             Date 02Dec13               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER044  *CREATE    Date 19May08               *
      *                                                               *
      *****************************************************************
      *  CGL152 - Include Transaction Type Identification Code on     *
      *           MT940/MT950 (Recompile)                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER044 - German Features - LF035-00 Reporting - AWV          *
      *           (Upgrade to Midas Plus)                             *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrChkNtrCde - Check/Validate Network Transaction Code        *
      *  *INZSR - Initialisation Subroutine                           *
      *  *PSSR  - Error processing                                    *
      *                                                               *
      *****************************************************************
      *  F-specs                                                      *
      *****************************************************************
      *
      **  Midas Network Transaction code
     FSDNTCDL0  IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  D-specs                                                      *
      *  Declared variables                                           *
      *                                                               *
      *****************************************************************
      *
      ** Array of error message IDs
     D MsgIDXArr       S              7A   DIM(99)
      *
      ** System Value entered by user
     D SystemValData   DS           200
      *
      ** Data structure for Network Transaction Code
     D SysValIntCd     S                           LIKE(NTTRCD)
      *
      ** System value to be processed
     D SystemValue     S             20A
      *
      ** Processing mode
     D ProcMode        S            190A
      *
      ** Error message id in GBSDUSRMSG
     D GenError        S              1A
      *
      ** Index for arrays of error message ids
     D Idx             S              2P 0
      *
      ** Network
     D PNtnWrk         S              6A
      *
      ** Network transaction code
     D PNtrCd          S             10A
      *
      ** Error flag
     D WRun            S              1A
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : SrChkNtrCde                                       *
      *                                                               *
      *****************************************************************
      *
      ** Main Processing
      *
     C                   EXSR      SrChkNtrCde
      *
      *  Exit program
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkNtrCde - Check and Validate Network Transaction Code    *
      *                                                               *
      *  Called By   : Main Processing                                *
      *                                                               *
      *****************************************************************
      *
     C     SrChkNtrCde   BEGSR
      *
      ** Check *GVC Network transaction code from SDNTCDL0 file
     C                   EVAL      SysValIntCd =  SystemValData
     C                   EVAL      PNtnWrk =  '*GVC'
     C                   EVAL      PNtrCd  =  SysValIntCd
      *
      ** Else, if not existing, return with an error
     C     KNtCd         Chain     SDNTCDL0
     C                   IF        Not%FOUND(SDNTCDL0)
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   MOVEL     'USR8274'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR    - Program Initialisation routine                   *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    SystemValue
     C                   PARM                    SystemValData
     C                   PARM                    ProcMode
     C                   PARM                    GenError
     C                   PARM                    Idx
     C                   PARM                    MsgIDXArr
      *
      ** Key List used for file, SDNTCDL0
      *
     C     KNtCd         KLIST
     C                   KFLD                    PNtnWrk
     C                   KFLD                    PNtrCd
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
      * Invoke program dump at once when error occurs
      *
     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *

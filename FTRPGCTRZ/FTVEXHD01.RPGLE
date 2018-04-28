     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Exchange Rate-Header')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVEXHD01  - Validate Exchange Rate - Header                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 17Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                                             CSW202
      ** ¦ F-specs                              ¦                                             CSW202
      ** ¦ =======                              ¦                                             CSW202
      ** +--------------------------------------+                                             CSW202
                                                                                              CSW202
     FFT102DL1  IF   E           K DISK    INFSR(*PSSR)                                       CSW202
      ** Midas FT Customer Credit Transfer details                                            CSW202
 
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD) PREFIX(D)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * OK Flags for first screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
     D GenOkFlag2      S              1    Import
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Numeric version of Exchange Rate
     D wexrate         S             13P 0
 
     D CFT004          S              1    INZ('N')
                                                                                              CSW202
     D CSW202          S              1                                                       CSW202
     D PRTCD           S              7                                                       CSW202
     D WOkay           S              1                                                       CSW202
 
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
 
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      Idx        = 0
     C                   Eval      WIdx       = 0
     C                   Eval      GenOkFlag2 = 'Y'
     C                   EVAL      WOkay = 'Y'                                                CSW202
 
     C                   If        PCCTRTE <> *Blanks
 
      ** Reset work fields
     C                   Eval      ZALIGNok = 'Y'
     C                   Eval      ZFIELD = *Blanks
     C                   Eval      ZADEC = *Zero
     C                   Eval      ZADIG = *Zero
     C                   Move      PCCTRTE       ZFIELD
 
     C                   CallB     'ZALIGN'
     C                   Parm                    ZALIGNok          1
     C                   Parm                    ZFIELD           16
     C                   Parm      8             ZADEC             1 0
     C                   Parm      5             ZADIG             2 0
 
     C                   If        ZALIGNok = 'N'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx =  Idx + 1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0158'
     C                   Else
 
      ** If no error in exchange rate, ensure it is greater than zero
     C                   Move      ZFIELD        wexrate
     C                   If        wexrate <= 0
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0249'
     C                   Else
                                                                                              CSW202
      ** If SWIFT 2002 is on, there must be at least one detail record                        CSW202
      ** with transfer currency not equal to payment currency.                                CSW202
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      WOkay = 'N'                                                CSW202
                                                                                              CSW202
     C     PCCTID        SETLL     FT102DL1                                                   CSW202
     C     PCCTID        READE     FT102DL1                                                   CSW202
                                                                                              CSW202
     C                   DOW       NOT %EOF(FT102DL1)                                         CSW202
     C                   IF        CCTCCY <> PAYCCY                                           CSW202
     C                   EVAL      WOkay = 'Y'                                                CSW202
     C                   LEAVE                                                                CSW202
     C                   ENDIF                                                                CSW202
     C     PCCTID        READE     FT102DL1                                                   CSW202
     C                   ENDDO                                                                CSW202
                                                                                              CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
     C                   IF        WOkay = 'N'                                                CSW202
     C                   EVAL      GenOkFlag2 = 'N'                                           CSW202
     C                   EVAL      Idx = Idx + 1                                              CSW202
     C                   EVAL      RetCodeIn = 'Error'                                        CSW202
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0900'                                  CSW202
     C                   ELSE                                                                 CSW202
 
      ** If exchange rate is OK format entry to aprropriate decimal places.
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD
     C                   Parm      8             ZADEC
 
     C                   Move      ZFIELD        PCCTRTE
     C                   Endif
     C                   Endif
     C                   Endif
     C                   ENDIF                                                                CSW202
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        Begsr
 
     C     *Entry        PLIST
 
      ** INPUTS
 
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1
 
      **  Screen fields
     C                   Parm                    HdrRcdIn
     C                   Parm                    DtlRcdIn
     C                   PARM                    OKFlagHS1
 
      ** OUTPUTS
      **  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
                                                                                              CSW202
      ** Check if SWIFT 2002 is installed                                                     CSW202
                                                                                              CSW202
     C                   CALL      'SWIF2002'                                                 CSW202
     C                   PARM      *BLANKS       PRTCD                                        CSW202
                                                                                              CSW202
     C                   IF        PRTCD = 'CSW2002'                                          CSW202
     C                   EVAL      CSW202 = 'Y'                                               CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      CSW202 = 'N'                                               CSW202
     C                   ENDIF                                                                CSW202
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   Endsr                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001

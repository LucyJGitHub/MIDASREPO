     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Sum of Amounts')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVAMAM01  - Validate Sum of Amounts                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
      *                                                               *
      *****************************************************************
 
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
 
      ** Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD) PREFIX(D)
 
      ** External data structure for Currency standing data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * OK Flags for first screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
     D GenOkFlag2      S              1    Import
 
      ** Numeric version of Transfer Amount
     D NumTRNAMT       S             15P 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
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
     C                   Eval      WIx        = 0
     C                   Eval      GenOkFlag2 = 'Y'
 
      ** Access currency file
     C                   CallB     'AOCURRR0'
     C                   Parm      *Blanks       PRTCD             7
     C                   Parm      '*KEY'        POPTN             7
     C                   Parm      PCCTCCY       PCCY              3
     C     SDCURR        Parm      SDCURR        Dssdy
 
     C                   If        PRTCD = *Blanks and
     C                             PSUMCCT <> *Blanks
 
      ** Reset work fields
     C                   Eval      ZALIGNok = 'Y'
     C                   Eval      ZFIELD = *Blanks
     C                   Eval      ZADEC = *Zero
     C                   Eval      ZADIG = *Zero
     C                   Eval      NumTRNAMT = *Zero
     C                   Eval      ZADIG = 15 - A6NBDP                          ************
     C                   Move      PSUMCCT       ZFIELD
 
     C                   CallB     'ZALIGN'
     C                   Parm                    ZALIGNok          1
     C                   Parm                    ZFIELD           16
     C                   Parm      A6NBDP        ZADEC             1 0
     C                   Parm                    ZADIG             2 0
 
      ** Transfer Amount must be in correct format for this currency
     C                   If        ZALIGNok = 'N'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx =  Idx + 1
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0254'
     C                   Else
 
      ** If no error in Amount, ensure it is greater than zero
     C                   Move      ZFIELD        NumTRNAMT
     C                   If        NumTRNAMT <= 0
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0255'
     C                   Else
 
      ** If Amount is OK format entry to aprropriate decimal places.
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD
     C                   Parm      A6NBDP        ZADEC
 
     C                   Move      ZFIELD        PSUMCCT
     C                   Endif
 
     C                   Endif
 
     C                   Endif
      *
     C                   Return
      *
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
 
      ** Screen fields
     C                   Parm                    HdrRcdIn
     C                   Parm                    DtlRcdIn
     C                   PARM                    OKFlagHS1
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
 
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
(c) Finastra International Limited 2001

     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate file reference - header')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVRFHD01 - Validate File Reference Header                   *
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
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178751             Date 09May00               *
      *                 177995             Date 19Apr00               *
      *                 CFT008  *CREATE    Date 17Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW201 - SWIFT 2001 Standards Update 2001 (Recompile)        *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  178751 - Auto generation of references                       *
      *  177995 - Use sender's id from the screen format              *
      *           as it gets defaulted from the validation API        *
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
      *                                                               *
      *****************************************************************
     FFT102HL7  IF   E           K DISK    PREFIX(H_)
      * FT102HPD Keyed by Sender and File Reference : Rename fields as NOT
      *  used.  Do not overwrite current values in FT102HPD
 
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
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD) PREFIX(D)
 
     D A1              S              1    DIM(16)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * OK Flags for first screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
     D GenOkFlag2      S              1    Import
     D i               S              3  0
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** External data structure for branch codes file
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
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
 
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      Idx        = 0
     C                   Eval      WIdx       = 0
     C                   Eval      GenOkFlag2 = 'Y'
      *****************************************************************         178751
      ***Mandatory*****************************************************         178751
      *****************************************************************         178751
     C*******************If        PFILREF =  Blanks                            178751
     C*******************Eval      Idx            =   Idx+1                     178751
     C*******************Eval      RetCodeIn      =   'Error'                   178751
     C*******************Eval      MsgIdXAr(Idx)  =   'RFV0190'                 178751
     C*******************Eval      FldNamXAr(Idx) =   DDSName                   178751
     C*******************Eval      GenOkFlag2 = 'N'                             178751
     C*******************Return                                                 178751
     C*******************Endif                                                  178751
      *******************                                                       178751
     C*******************If        ActionCode = 'I'                             178751
     C                   If        ActionCode = 'I' and                         178751
     C                             PFILREF <> *blanks                           178751
      *
      * Ensure that unique within Sender Id across file FT102HPD
      **Get*Sender*ID*from*branch*file***********************                   177995
      ****************************************                                  177995
     C*******************CALLB     'AOBRCHR0'                                   177995
     C*******************Parm      *Blanks       P@RTCD            7            177995
     C*******************Parm      '*KEY   '     P@OPTN            7            177995
     C*******************Parm      PBRCA         P@BRCA            3            177995
     C*****SDBRCH        Parm      SDBRCH        DSFDY                          177995
 
     C*******************Eval      H_STID = A8BTID                              177995
 
 
     C     KeyCCTL1      Chain     FT102HL7                           99        Not Found
 
      * If record found, send message
     C                   If        *IN99 = *Off
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0338'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag2 = 'N'
     C                   Else
 
      ** Must contain characters valid for the Swift network.
 
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RtnCde           10
     C                   Parm      PFILREF       Swift_Text       50
 
     C                   If        RtnCde <> *Blanks
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0191'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag2 = 'N'
     C                   Endif
 
     C                   Movea     PFILREF       A1
     C                   Eval      i = 16
     C                   DoW       i > 1         And
     C                             A1(i) = ' '
     C                   Eval      i = i - 1
     C                   Enddo
 
      * must not contain '//'
 
     C     '//'          Scan      PFILREF                                90
 
      * Must not begin or end with a '/'
 
     C                   If        %subst(PFILREF:1:1)  = '/'  or
     C                             A1(i)                = '/'  or
     C                             *In90 = *On
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0192'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag2 = 'N'
     C                   Endif
      *
     C                   Endif
      *
     C                   Endif
 
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
 
      * INPUTS
 
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1
 
      *  Screen fields
     C                   Parm                    HdrRcdIn
     C                   Parm                    DtlRcdIn
     C                   PARM                    OKFlagHS1
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
 
      * Key list for file FT102HL7
     C     KeyCCTL1      Klist
     C*******************Kfld                    H_STID                         177995
     C                   KFLD                    PStid                          177995
     C                   KFLD                    PFilRef
 
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

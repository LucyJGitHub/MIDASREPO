     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
 
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Senders Reference')
 
 
      *  Midas - Standard subprograms                                 *
 
      *  FTVSERF01 - Validate Senders Reference                       *
 
      *  (c) Misys International Banking Systems Ltd. 2001            *
 
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
 
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
 
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 221761             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178751             Date 09May00               *
      *                 177995             Date 19Apr00               *
      *                 CFT006  *CREATE    Date 15Jul99               *
      * Midas DBA 3.00 -----------------------------------------------*
 
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  178751 - Auto generation of references                       *
      *  177995 - Use sender's id from the screen format              *
      *           as it gets defaulted from the validation API        *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
      *                                                               *
      *****************************************************************
     FFT101HL4  IF   E           K DISK    PREFIX(H_)
      * FT101H Keyed by Sender and Senders Reference : Rename fields as NOT
      *  used.  Do not overwrite current values in FT101H.
 
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
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D  A1             S              1    DIM(16)
 
     D i               S              3  0
     D GenOkFlag       S              1    Import
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
 
     C                   Eval      RetCodeIn  = *BlankS
     C                   Eval      Idx        = 0
     C                   Eval      WIdx       = 0
 
     C                   Eval      GenOkFlag = 'Y'
      *******************************************************************       178751
      **Mandatory********************************************************       178751
     C*******************If        PSNDREF = *Blanks                            178751
     C*******************Eval      Idx            =   Idx+1                     178751
     C*******************Eval      RetCodeIn      =   'Error'                   178751
     C*******************Eval      MsgIdXAr(Idx)  =   'RFV0002'                 178751
     C*******************Eval      FldNamXAr(Idx) =   DDSName                   178751
     C*******************Eval      GenOkFlag = 'N'                              178751
     C*******************Return                                                 178751
     C*******************Endif                                                  178751
      *
      * Ensure that unique within Sender Id across file FT101H
     C*******************If        ActionCode = 'I'                             178751
     C                   If        ActionCode = 'I' and                         178751
     C                             PSNDREF <> *blanks                           178751
 
      **Get*Sender*ID*from*branch*file                                          177995
     C*******************CALLB     'AOBRCHR0'                                   177995
     C*******************Parm      *Blanks       P@RTCD            7            177995
     C*******************Parm      '*KEY   '     P@OPTN            7            177995
     C*******************Parm      PBRCA         P@BRCA            3            177995
     C*****SDBRCH        Parm      SDBRCH        DSFDY                          177995
 
     C*******************Eval      H_STID = A8BTID
 
 
     C     KeyRftL1      Chain     FT101HL4                           99        Not Found
 
      * If record found, send message
     C                   If        *IN99 = *Off
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0003'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Endif
      *
      * Must contain characters valid for the Swift network.
      *
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RtnCde           10
     C                   Parm      PSNDREF       Swift_Text       50
     C                   If        RtnCde <> *Blanks
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0004'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Endif
      *
     C                   Movea     PSNDREF       A1
     C                   Eval      i = 16
     C                   DoW       i > 1         And
     C                             A1(i) = ' '
     C                   Eval      i = i - 1
     C                   Enddo
 
      * must not contain '//'
     C     '//'          Scan      PSNDREF                                90
      *
      * Must not begin or end with a '/'
     C                   If        %subst(PSNDREF:1:1)  = '/'  or
     C                             A1(i)                = '/'  or
     C                             *In90 = *On
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0005'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag = 'N'
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
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
      * INPUTS
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1
 
      *  Screen fields
     C                   PARM                    HdrRcdIn
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
 
      * Key list for file FT101HL4
     C     KeyRftL1      Klist
     C*******************Kfld                    H_STID                         177995
     C                   KFLD                    PSTID                          177995
     C                   KFLD                    PSNDREF                        177995
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001

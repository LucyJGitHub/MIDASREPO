     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Transaction Reference')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVTRRF01 - Validate Transaction Reference                   *
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
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 221761             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178751             Date 09May00               *
      *                 178183             Date 26Apr00               *
      *                 CFT006  *CREATE    Date 10Sep99               *
      *                                    Date ddmmmyy               *
      * Midas DBA 3.00 -----------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  178751 - Auto generation of references                       *
      *  178183 - Reassign a duplicate record                         *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
      *                                                               *
      *****************************************************************
 
      * RFT Detail file (keyed on RFTID/TRNSID)
     FFT101DL0  IF   E           K Disk
 
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
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
     D  PSNDREF_H    E                     EXTFLD(PSNDREF)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      * OK Flags for first screen
     D OKFlags       E DS                  EXTNAME(FTE101S1PD)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array to break TRNSID into individual characters
     D TrnRefArr       S              1    DIM(16)
 
      ** Array to return characters of TRNSID that contain a '/'
     D ScanTRNSID      S              2  0 DIM(16)
 
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
 
      ** Index for TrnRefArr array
     D X               S              2P 0
 
      ** Index for ScanTRNSID array
     D Y               S              2P 0
 
      ** Work index
     D Z               S              2P 0
 
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
 
      ** Initialise
     C                   EVAL      Idx       = 0
     C                   EVAL      WIdx      = 0
     C                   EVAL      OKTDTR    = 'Y'
     C                   EVAL      X         = 0
     C                   EVAL      Y         = 0
     C                   EVAL      Z         = 0
 
      ** Main processing
     C                   EXSR      VALIDATE
 
      ** Return
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALIDATE - Main validation processing                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     VALIDATE      BEGSR
      ***************************************************************           178751
      ***Transaction*Reference*must*be*entered.**********************           178751
      *******************                                                       178751
     C*******************IF        PTRNSID = *Blanks                            178751
     C*******************MOVE      'N'           OKTDTR                         178751
     C*******************ADD       1             Idx                            178751
     C*******************MOVEL     DDSName       FldNamXAr(Idx)                 178751
     C*******************MOVEL     'RFV0102'     MsgIdXAr(Idx)                  178751
      *******************                                                       178751
     C*******************ELSE                                                   178751
      *                                                                         178751
     C                   IF        PTRNSID <> *Blanks                           178751
      *
      ** If Insert mode, ensure Transaction Reference does not already
      ** exist for this RFT Id.  For all other modes, the Transaction
      ** Reference must exist on file.
     C     DtlKey        CHAIN     FT101DL0                           80
      *
     C                   IF        *IN80 = *Off
      *
     C*******************IF        ActionCode = 'I'                             178183
     C*******************IF        ActionCode = 'I' or ActionCode = 'R'   178183178751
     C                   IF        ActionCode = 'I'                             178751
     C                   MOVE      'N'           OKTDTR
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0101'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
     C*******************IF        ActionCode <> 'I'                            178183
     C*******************IF        ActionCode <> 'I' and                  178183178751
     C*******************          ActionCode <> 'R'                      178183178751
     C                   IF        ActionCode <> 'I'                            178751
     C                   MOVE      'N'           OKTDTR
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0100'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Must not begin with '/'.
      ** Leading blanks are not allowed.
     C                   MOVEA     PTRNSID       TrnRefArr
      *
     C                   IF        TrnRefArr(1) = '/' or TrnRefArr(1) = ' '
     C                   MOVE      'N'           OKTDTR
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0103'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Must not end with '/'.
     C     '/'           SCAN      PTRNSID       ScanTRNSID
     C                   EVAL      Y = 1
      *
      ** (Determine the position of the last '/' and put it in X)
     C     *Zeros        LOOKUP    ScanTRNSID(Y)                          89
     C                   IF        *IN89 = *On  and  Y > 1
     C                   EVAL      Z = (Y - 1)
     C                   EVAL      X = ScanTRNSID(Z)
     C                   EVAL      X = (X + 1)
      *
      ** (Check characters after last '/'.  If all are blank - error.)
     C                   DOW       X < 17
     C                   IF        TrnRefArr(X) = *Blanks
     C                   EVAL      X = (X + 1)
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        X = 17
     C                   MOVE      'N'           OKTDTR
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0104'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C*******************ENDIF                                                  178751
      *
      ** Must not contain the string '//'.
     C     '//'          SCAN      PTRNSID:2                              81
      *
     C                   IF        *IN81 = *On
     C                   MOVE      'N'           OKTDTR
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0105'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Must contain characters valid for the Swift network.
     C                   CALLB     'FTVSFTX01'
     C                   PARM                    RtnCde           10
     C                   PARM      PTRNSID       Swift_Text       50
      *
     C                   IF        RtnCde <> *Blanks
     C                   MOVE      'N'           OKTDTR
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0181'     MsgIdXAr(Idx)
     C                   Endif
      *
     C                   ENDIF                                                  178751
      *
     C                   ENDSR
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
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode        1
      *  Screen fields
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OKFlags
 
      ** Define key lists
     C     DtlKey        KLIST
     C*******************KFLD                    PRFTID                         178183
     C                   KFLD                    PRFTHDR                        178183
     C                   KFLD                    PTRNSID
 
      *  Program, module and procedure names for database error processing.*
      *  The following /COPY sets these values, and also defines LDA as    *
      *  an external data area                                             *
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      **********************************************************************
 
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001

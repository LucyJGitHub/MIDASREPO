     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Deal Number')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market ILE Module                              *
      *                                                               *
      *  MMVFLDNO - Validate Deal Number                              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 237063             Date 20Nov05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CDL028             Date 07Feb05               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905  *CREATE    Date 25Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  209905 - Fiduciary API Enhancement                           *
      *                                                               *
      *****************************************************************
     FMMWFIDDL0 IF   E           K DISK    INFSR(*PSSR)
     FFDDLNMLL  IF   E             DISK    INFSR(*PSSR)
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D DealNoARR       S              6A   DIM(88)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Idx             S              3P 0
     D X               S              3P 0
     D WTEST           S              1A
     D OKDealNo        S              1A
     D WWDLNO          S              6S 0
     D PDealNo         S              6A
     D PTDealNo        S              6A
 
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
 
     C                   EVAL      Idx = 1
     C                   EVAL      OKDealNo = 'Y'
 
     C                   SELECT
 
     C                   WHEN      PTDealNo <> *BLANKS
 
      ** Test if deal entered is numeric
 
     C                   TESTN                   PTDealNo             21
     C                   MOVE      PTDealNo      WTEST
     C                   TESTZ                   WTEST                    22
 
     C                   IF        PTDealNo <> *BLANKS and *IN21 = *OFF or
     C                             PTDealNo <> *BLANKS and *IN22 = *OFF
     C                   EVAL      OKDealNo = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFDLNO'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0568'
     C                   EVAL      MsgDtaArr(Idx) = PTDealNo
     C                   ELSE
 
     C                   MOVE      PTDealNo      WWDLNO
     C     WWDLNO        CHAIN     MMWFIDDL0                          23
 
     C                   IF        *IN23 = *OFF
     C                   EVAL      OKDealNo = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFDLNO'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0569'
     C                   EVAL      MsgDtaArr(Idx) = PTDealNo
     C                   ELSE
 
     C     WWDLNO        SETLL     DEALSALL                               24
 
     C                   IF        *IN24 = *ON
     C                   EVAL      OKDealNo = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFDLNO'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0569'
     C                   EVAL      MsgDtaArr(Idx) = PTDealNo
     C                   ELSE
 
      ** Check that the deal number is in the allowed range
 
     C                   IF        WWDLNO < NORDLN  or WWDLNO = 999999
     C                   EVAL      OKDealNo = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFDLNO'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0570'
     C                   EVAL      MsgDtaArr(Idx) = PTDealNo
     C                   ELSE
 
      ** Deal number cannot be equal
 
     C                   IF        PTDealNo = PDealNo
     C                   EVAL      OKDealNo = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFDLNO'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0582'
     C                   EVAL      MsgDtaArr(Idx) = PTDealNo
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Copy deal number to the array after passing the validation
 
     C                   IF        OKDealNo = 'Y'
     C     PTDealNo      LOOKUP    DealNoARR                              24
     C                   IF        *IN24 = *ON
     C                   EVAL      OKDealNo = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFDLNO'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0569'
     C                   EVAL      MsgDtaArr(Idx) = PTDealNo
     C                   ELSE
     C                   ADD       1             X
     C                   MOVEA     PTDealNo      DealNoARR(X)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** INPUTS
      ** Return Code
      ** Deal Number (Placing)
      ** Work Deal Number
      ** Valid Deal Number Array
     C                   PARM                    RetCodeIn
     C                   PARM                    PDealNo
     C                   PARM                    PTDealNo
     C                   PARM                    DealNoARR
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** OK Flag
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    OKDealNo
 
      ** Retrieve Deal Numbers Record
 
     C     1             Chain     FDDLNMLL                           25
 
     C                   IF        *IN25 = *ON or NODLTF = '*'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'FDDLNMLL'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************

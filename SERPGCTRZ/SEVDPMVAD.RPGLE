     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate DPMV Associated Deal')               *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SEVDPMVAD  - Validate DPMV Associated Deal.                  *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Depot Movement Associated Deal.                   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 BUG8910            Date 10Oct05               *
      *                 BUG8769            Date 03Oct05               *
      *                 CAP087  *CREATE    Date 31Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  BUG8910 - Make Repo Indicator and Associated Deal optional   *
      *            for Bond Borrowing / Bond Lending. Amend field     *
      *            highlighted for message ID to point to Repo Ind    *
      *            instead of Associated Deal.                        *
      *  BUG8769 - WARNING arrays/index fields must be initialised    *
      *            to prevent array index error.                      *
      *  CAP087 - Depot Movement - Java Wrapper in MidasPlus.         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     F                                     IGNORE(MMDENSP0)
     F                                     IGNORE(MMDENBP0)
     FINVTP     IF   E           K DISK    INFSR(*PSSR)
 
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
 
     D INFDS           DS
      **  Data structure for file status of MM deals file.
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields in Warning
     D WFldNamXA       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D WMsgIDXA        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D WMsgDtXA        S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
 
     ** Screen fields
     D DDDPAD          S              6A
     D DDSWRF          S              3A
     D DDRPIN          S              1A
     D DDDPRN          S              6A
 
      ** System Info and other inputs parms
 
     D DealPreInd      S              1A
     D NomCcy          S              3A
     D InvTyp          S              3A
     D SecMatD         S              5P 0
     D OutDate         S              5P 0
     D InDate          S              5P 0
     D DepBrch         S              3A
     D*DepBene**       S              6S 0                                                   CSD027A
     D DepBene         S              6A                                                     CSD027A
 
      ** Output fields
      ** -------------
 
     D DDDPADOk        S              1A
     D DPAD            S              6S 0
     D DealCcy         S              3A
 
      ** Work fields
      ** -----------
 
     D WORK6A          S              6A
     D LaterDate       S              5P 0
     D EarlyDate       S              5P 0
     D LateDate        S              5P 0
 
      ** Index for arrays of Error and Warning message IDs
     D Idx             S              3P 0
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
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNamXA                                   BUG8769
     C                   MOVE      *BLANK        WMsgIDXA                                    BUG8769
     C                   MOVE      *BLANK        WMsgDtXA                                    BUG8769
     C                   Z-ADD     0             WIx                                         BUG8769
 
     C                   Z-ADD     0             DPAD
      *
      ** Validation
      *
     C                   EXSR      SDPAD
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDPADOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SDPAD - Validation Routine for Associated Deal                *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SDPAD         BEGSR
 
      *
      ** Dealing Module should be present
      *
     C     DealPreInd    IFEQ      'Y'
      *
      ** Associated Deal
      *
      **  Must be entered if Repo/Pledge Indicator = 'R', 'P' or 'B'.
      *
     C     DDRPIN        IFEQ      'P'
     C     DDRPIN        OREQ      'R'
     C     DDRPIN        OREQ      'B'
      *
     C     DDDPAD        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPAD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0208'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPADOK
     C                   ENDIF
 
     C                   ELSE
 
      ** Deal number must be blank if the Repo/Pledge Indicator is blank
     C     DDDPAD        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPAD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0209'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPADOK
     C                   END
 
     C                   END
 
      ** If entered, it must reference an active deal on PF/MMDELDPP
      ** with R/P Indicator = R/P Indicator on this depot movement &
      ** if R/P number on deal is non-zero it must equal Depot
      ** Movement Reference on this depot movement when the Switch
      ** Reference is blank.
 
     C     DDDPAD        IFNE      *BLANKS
     C                   MOVE      DDDPAD        DPAD
     C                   MOVE      *BLANKS       DealCcy
     C     DPAD          CHAIN     MMDELDP0                           65
      *
      ** Retrieve the Deal Ccy for output and later use.
     C                   MOVE      *BLANKS       DealCcy
     C     *IN65         IFEQ      '0'
     C                   MOVE      HKCCY         DealCcy
     C                   END
      * Error if :
      *       (1) Deal is not found in file
      *       (2) Repo Indicator in associated deal and depot does not match
     C     *IN65         IFEQ      '1'
     C     HKDRID        ORNE      DDRPIN
     C     HKDDLT        ANDEQ     *BLANK
     C                   ADD       1             Idx
     C***********        MOVEL     'DDDPAD'      FldNamXAr(Idx)                              BUG8910
     C                   MOVEL     'DDRPIN'      FldNamXAr(Idx)                              BUG8910
     C                   MOVEL     'MMA2042'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPADOK
     C                   ELSE
 
      * Error if Deal is deleted.
     C     HKDDLT        IFNE      *BLANK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPAD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2021'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPADOK
     C                   END
      * If Depot Movement Reference and Switch Reference are both non-blanks,
      * Depot Movement Ref of the deal must be same as Depot Movement Ref of this
      * transaction, otherwise error.
     C     HKDDMR        IFNE      *BLANKS
     C     DDSWRF        ANDEQ     *BLANKS
     C                   MOVE      HKDDMR        WORK6A
     C     WORK6A        IFNE      DDDPRN
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPAD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2043'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPADOK
     C                   END
     C                   END
 
     C                   END
 
      * If DATE IN is less than DATE OUT, deal type must be IP, TI or CL.
 
     C     InDate        IFLT      OutDate
     C     HKMTYP        ANDNE     'IP'
     C     HKMTYP        ANDNE     'TI'
     C     HKMTYP        ANDNE     'CL'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPAD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0211'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPADOK
     C                   END
 
      * If DATE IN is greater than DATE OUT, deal type must be IT, TD or CD.
 
     C     InDate        IFGT      OutDate
     C     HKMTYP        ANDNE     'IT'
     C     HKMTYP        ANDNE     'TD'
     C     HKMTYP        ANDNE     'CD'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPAD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0212'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPADOK
     C                   END
 
      * Branch Code must be same as deal's branch.
 
     C     DepBrch       IFNE      HKBRCA
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPAD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0213'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPADOK
     C                   END
 
      * The later of DATE IN or DATE OUT must not be after maturity date of the Security.
 
     C                   Z-ADD     InDate        LaterDate
     C     OutDate       IFGT      LaterDate
     C                   Z-ADD     OutDate       LaterDate
     C                   END
 
     C     LaterDate     IFGT      SecMatD
     C     LaterDate     ANDNE     99999
     C     SecMatD       ANDNE     0
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPAD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0214'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPADOK
     C                   END
 
      * Beneficiary customer must be equal to the customer of the associated deal.
 
     C     DepBene       IFNE      HKCNUM
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPAD'      WFldNamXA(WIx)
     C                   MOVEL     'MMA0215'     WMsgIDXA(WIx)
     C                   MOVE      'W'           DDDPADOK
     C                   END
 
      * DATE IN and DATE OUT must match value and maturity dates (if present)
      * i.e. Earlier = Value Date / Later = Maturity Date
 
      * Fetch earlier
 
     C                   Z-ADD     InDate        EarlyDate
     C     OutDate       IFLT      EarlyDate
     C                   Z-ADD     OutDate       EarlyDate
     C                   END
      * Fetch later
 
     C                   Z-ADD     InDate        LateDate
     C     OutDate       IFGT      LateDate
     C                   Z-ADD     OutDate       LateDate
     C                   END
 
     C     EarlyDate     IFNE      HKDVSD
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPAD'      WFldNamXA(WIx)
     C                   MOVEL     'MMA0216'     WMsgIDXA(WIx)
     C                   MOVE      'W'           DDDPADOK
     C                   END
 
     C     HKMATD        IFNE      0
     C     LateDate      ANDNE     HKMATD
     C     LateDate      ANDNE     99999
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPAD'      WFldNamXA(WIx)
     C                   MOVEL     'MMA0218'     WMsgIDXA(WIx)
     C                   MOVE      'W'           DDDPADOK
     C                   END
 
      * Collateral value must not be less than the deal's principal.
      * Access investment type file for collateral margin.
     C     INVKey        CHAIN     INVTPDF                            65
 
      ***** ADD COLLATERAL PROCESSING HERE *******************************************************
 
     C                   END
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      ** Return Code Error Indicator
     C                   PARM                    RetCodeIn
 
      ** Received parameters
      ** -------------------
 
      ** Screen Fields **
      ** Switch Reference Screen field (3A)
      ** Repo/Pledge Indicator (1A)
      ** Depot Reference (6A)
     C                   PARM                    DDDPAD
     C                   PARM                    DDSWRF
     C                   PARM                    DDRPIN
     C                   PARM                    DDDPRN
     C                   PARM                    OutDate
     C                   PARM                    InDate
     C                   PARM                    DepBrch
     C                   PARM                    DepBene
 
      ** System Details
      ** Dealing module indicator (1A)
     C                   PARM                    DealPreInd
      ** Nominal Currency (3A)
     C                   PARM                    NomCcy
      ** Security Investment Type (3A)
     C                   PARM                    InvTyp
      ** Security Maturity Date
     C                   PARM                    SecMatD
 
      ** Returned parameters
      ** -------------------
 
     ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
     ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamXA
     C                   PARM                    WMsgIDXA
     C                   PARM                    WMsgDtXA
 
      ** Associated Deal Ok Indicator (1A)
      ** Associated Deal (6N)
      ** Associated Deal Currency Code (3A)
     C                   PARM                    DDDPADOk
     C                   PARM                    DPAD
     C                   PARM                    DealCcy
 
     C     INVKey        KLIST
     C                   KFLD                    NomCcy
     C                   KFLD                    InvTyp
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001

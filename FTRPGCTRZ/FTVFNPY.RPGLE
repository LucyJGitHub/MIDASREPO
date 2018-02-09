     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate final payment date')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVFNPY  - Validate Final Payment Date                       *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 06Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT. (Recompiled)            *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** Array of Warning in error.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of Warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of Warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D #DATE           DS
     D  ODD                    1      2
     D  OMM                    3      4
     D  OYY                    5      6
 
     D                 DS
     D ZDATE                   1      6  0
     D  ZDD                    1      2
     D  ZMM                    3      4
     D  ZYY                    5      6
     D  ZYN                    5      6  0
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
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
      * This prog only
     D WDATE           S              6P 0
     D ZDATIN          S              6A
     D ZDAYNO          S              5P 0
     D ZLOC            S              3A
     D ZCCY            S              3A
     D ZERR            S              1A
     D ZHIND           S              1A
 
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
 
      ** Initialization
 
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      WFldNmXAr = *Blanks
     C                   Eval      WMsgIDXAr  = *Blanks
     C                   Eval      WMsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0
 
      * Validate Final Payment date
     C                   Exsr      VFINDAT
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKFind = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
      * RETURN
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFINDAT - FINAL PAYMENT DATE VALIDATION
      *****************************************************************
     C*
     C* MANDATORY IF A REGULAR PAYMENT
     C* MUST BE GREATER THAN SETTLE DATE
     C*
     C     VFINDAT       BEGSR
 
     C                   If        SPYTP = 'RP'
 
     C                   If        SFIND = *Blanks or
     C                             SFIND = *ALL'0'
      * Send error to screen
     C                   Move      'N'           OKFind
     C                   Add       1             Idx
     C                   Movel     'SFIND'       FldNamXAr(Idx)
     C                   Movel     'MMA1000'     MsgIdXAr(Idx)
 
     C                   Else
     C                   Eval      @FIND = SFIND
 
     C                   CALLB     'ZDATE1'
     C                   Parm      SFIND         ZDATIN
     C                   Parm      0             ZDAYNO
     C                   Parm                    BJDFIN
     C                   Parm      'N'           ZERR
 
      * The final payment date must not be a holiday in local currency
     C                   Eval      ZCCY = BJLCCY
     C                   CALLB     'ZCHKH'
     C                   Parm                    ZDAYNO
     C                   Parm                    ZCCY
     C                   Parm      @PLOC         ZLOC
     C                   Parm      ' '           ZHIND
 
      ** if ZIND = 'H' then the date is a holiday display warning
     C                   If        ZHIND = 'H'
     C                   Move      'W'           OKFind
     C                   Add       1             WIx
     C                   Movel     'SFIND'       WFldNmXAr(WIx)
     C                   Movel     'MMA1001'     WMsgIdXAr(WIx)
     C                   End
      *
     C                   If        ZERR = 'Y'
      * Send error to screen
     C                   Move      'N'           OKFind
     C                   Add       1             Idx
     C                   Movel     'SFIND'       FldNamXAr(Idx)
     C                   Movel     'MMA1002'     MsgIdXAr(Idx)
     C                   Else
 
     C                   If        ZDAYNO <= @SLDT
      * Send error to screen
     C                   Move      'N'           OKFind
     C                   Add       1             Idx
     C                   Movel     'SFIND'       FldNamXAr(Idx)
     C                   Movel     'MMA1003'     MsgIdXAr(Idx)
     C                   End
     C                   End
 
     C                   If        OKFind <> 'N'
     C                   Move      ZDATIN        ZDATE
     C                   Eval      @FDATD1 = ZDATE
     C                   Eval      @FDAT = ZDAYNO
      * Format Date for D3
     C                   If        BJDFIN <> 'M'
     C                   Eval      OYY = ZDD
     C                   Eval      OMM = ZMM
     C                   Eval      ODD = ZYY
     C                   Else
     C                   Eval      OMM = ZDD
     C                   Eval      OYY = ZMM
     C                   Eval      ODD = ZYY
     C                   End
 
     C                   Move      #DATE         WDATE
     C                   Eval      @FDATD3 = WDATE
 
      * Find Century
     C                   If        ZYN < 72
     C                   Eval      @FDATD2 = 20
     C                   Else
     C                   Eval      @FDATD2 = 19
     C                   End
     C                   End
     C                   End
 
     C                   Else
     C                   If        SPYTP = 'OP'
     C                   If        SFIND <> *Blanks and
     C                             SFIND <> *All'0'
      * Send error to screen
     C                   Move      'N'           OKFind
     C                   Add       1             Idx
     C                   Movel     'SFIND'       FldNamXAr(Idx)
     C                   Movel     'MMA1004'     MsgIdXAr(Idx)
 
     C                   Else
     C                   CLEAR                   @FDAT
     C                   CLEAR                   @FDATD1
     C                   CLEAR                   @FDATD2
     C                   CLEAR                   @FDATD3
      *
     C                   End
 
     C                   End
     C                   End
 
     C                   ENDSR
     C*
     C************************************************************
     C* END OF FINAL PAYMENT DATE VALIDATION
     C************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
 
      *  Screen fields
     C                   Parm                    TranInPrim
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001

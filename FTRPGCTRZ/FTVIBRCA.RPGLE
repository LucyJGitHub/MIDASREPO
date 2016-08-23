     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP booking branch')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIBRCA - Validate Booking Branch                           *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 257673             Date 14Nov08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247277             Date 24May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 241002             Date 18Jul06               *
      *                 CDL049             Date 06Jul06               *
      *                 220180             Date 06Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 25Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  257673 - Remove checking of action code 'X' for the user who *
      *           routes an incoming message.                         *
      *  247277 - Allow for native JDBC driver as well as toolbox.    *
      *  CFT032 - Account line in field 50k in MT103 (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  241002 - Cannot amend booking branch. Applied 227458.        *
      *           This fix is already catered by fix 220180.          *
      *  227458 - Allow booking branch to be amendable. Applied part  *
      *           of 219713.                                          *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  220180 - Remove FTA0090. Checking will be done by FTIPAY1VL. *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Also perform extra branch validation if module      *
      *           is called from Midas Plus interface.                *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments retrieved from file - file format
     D CrIPFilFmt    E DS                  EXTNAME(INPAYDD)
      *
      ** Externally described DS for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise work variable.
      *
     C                   EVAL      Idx = 0
      *
      ** Validate Booking Branch.
      *
     C                   EXSR      SRValBkBr
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File field.
      *
     C                   IF        OKBRCA = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        OKBRCA <> 'N'
     C                   MOVE      DDBRCA        IPBRCA
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALBKBR - Booking Branch Validation                        *
      *                                                               *
      *****************************************************************
      *
     C     SRValBkBr     BEGSR
      *
      ** Entry is prohibited if Action is not Insert and
      ** module has been called from screen input function.
      *
     C**********         IF        DDBRCA <> *BLANKS and                                      220180
     C**********                   DDACTN <> 'I' and                                          220180
     C**********                   PMODE = '*SIN  '                                           220180
      *
     C**********         MOVE      'N'           OKBRCA                                       220180
     C**********         ADD       1             Idx                                          220180
     C**********         MOVEL     'DDBRCA'      FldNamXAr(Idx)                               220180
     C**********         MOVEL     'FTA0090'     MsgIdXAr(Idx)                                220180
     C**********         GOTO      EValBkBr                                                   220180
      *
     C**********         ENDIF                                                                220180
      *
      ** Check for question mark.
      *
     C     '?'           SCAN      DDBRCA                                 01
      *
      ** Question mark is invalid on *CTL function.
      *
     C                   IF        PMODE = '*FRONT' and
     C                             *IN01 = *On
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRCA'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0091'     MsgIdXAr(Idx)
     C                   GOTO      EValBkBr
     C                   ENDIF
      *
     C                   IF        PMODE <> '*FRONT'
      *
      ** In repair and screen-input functions, bypass
      ** further validation if Action Code or Payment
      ** Reference is invalid.
      *
     C                   IF        OKACTN = 'N' or
     C                             OKPREF = 'N'
     C                   GOTO      EValBkBr
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If Booking Branch is blank and Action is Insert, use User Branch.
      *
     C                   IF        DDBRCA = *BLANKS and
     C                             DDACTN = 'I'
     C                   MOVE      PDBRN         DDBRCA
     C                   ENDIF
      *
      ** Display Branch Code kept in file if Branch code is
      ** still blank up to this poin.
      *
     C                   IF        DDBRCA = *BLANKS and
     C                             DDACTN <> 'I' and
     C                             OKACTN <> 'N' and
     C                             OKPREF <> 'N'
     C                   MOVE      BRCA          DDBRCA
     C                   ENDIF
      *
      ** Check if Booking Branch is existing.
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd             7
     C                   PARM      '*KEY   '     POptn             7
     C                   PARM      DDBRCA        PBrCd             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C                   IF        PRtCd <> *Blanks
      *
      ** Blank out entry if question mark has been entered
      ** and no selection has been made.
      *
     C                   IF        *IN01 = *On
     C                   MOVE      *BLANKS       DDBRCA
     C                   ENDIF
      *
      ** Default Branch Code to User Branch if Action is Insert,
      ** entry is question mark and no selection has been made.
      *
     C                   IF        DDACTN = 'I' and
     C                             *IN01 = *On
     C                   MOVE      PDBRN         DDBRCA
      *
     C                   ELSE
      *
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRCA'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0091'     MsgIdXAr(Idx)
     C                   GOTO      EValBkBr
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   EVAL      DDBRCA = A8BRCD
     C                   ENDIF
      *
      ** Access Security Checking.
      *
     C     PResponse     IFEQ      'S'
     C                   EXSR      SRAcsSec
     C                   ENDIF
      *
     C     EValBkBr      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcsSec - Access Security Checking                          *
      *                                                               *
      *****************************************************************
      *
     C     SRAcsSec      BEGSR
      *
     C     WLinkPgm      IFNE      'GL4442    '
     C     WLinkPgm      ANDNE     'GL0090    '
     C     OKACTN        ANDNE     'N'
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        PACTN             1
     C                   PARM      DDBRCA        PBR               3
     C                   PARM      *ZERO         PError            1 0
      *
      ** User is not authorised to any actions for this menu item
      ** and branch combination.
      *
     C     PError        IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             IDx
     C                   EVAL      FldNamXAr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdXAr(IDx) = 'FTA0079'
     C                   ENDIF
      *
      ** User is not authorised to the specific action
      ** code entered for this branch and menu item.
      *
     C     PError        IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             IDx
     C                   EVAL      FldNamXAr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdXAr(IDx) = 'FTA0080'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***If*action*code*is*'I',*a*SWIFT*reference*has*been*entered*and*                       257673
      ***no*errors*so*far,*check*that*the*user*is*also*authorised*to***                       257673
      ***action*code*'X'.**This*check*allows*restriction*that*only*****                       257673
      ***nominated*branches*may*process*electronic*messages*i.e.*only**                       257673
      ***those*branches*authorised*to*action*code*'X'.*****************                       257673
      *
     C*****PMode         IFEQ      '*SIN  '                                                   257673
     C*****DDACTN        ANDEQ     'I'                                                        257673
     C*****DDSWTN        ANDNE     *BLANKS                                                    257673
     C*****OKACTN        ANDNE     'N'                                                        257673
     C*****PSJobName     OREQ      'QZDASOINIT'                                        CAP084 257673
     C*****DDACTN        ANDEQ     'I'                                                 CAP084 257673
     C*****DDSWTN        ANDNE     *BLANKS                                             CAP084 257673
     C*****OKACTN        ANDNE     'N'                                                 CAP084 257673
     C*****PSJobName     OREQ      'QSQSRVR'                                           247277 257673
     C*****DDACTN        ANDEQ     'I'                                                 247277 257673
     C*****DDSWTN        ANDNE     *BLANKS                                             247277 257673
     C*****OKACTN        ANDNE     'N'                                                 247277 257673
      *
     C**********         CALL      'ZVACTBU'                                                  257673
     C**********         PARM      'X'           PACTN                                        257673
     C**********         PARM      DDBRCA        PBR                                          257673
     C**********         PARM      *ZERO         PError                                       257673
      *
     C*****PError        IFEQ      2                                                          257673
     C**********         MOVE      'N'           OKACTN                                       257673
     C**********         MOVE      'N'           OKBRCA                                       257673
     C**********         ADD       1             IDx                                          257673
     C**********         EVAL      FldNamXAr(IDx) = 'DDACTN'                                  257673
     C**********         EVAL      MsgIdXAr(IDx) = 'FTA0081'                                  257673
     C**********         ENDIF                                                                257673
      *
     C**********         ENDIF                                                                257673
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Action Code
     C                   PARM                    DDACTN            1
      *
      ** Booking Branch
     C                   PARM                    DDBRCA            3
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN           28
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR    (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** Response Mode
     C                   PARM                    PResponse         1
      *
      ** Linked Program
     C                   PARM                    WLinkPgm         10
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN             3
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK Action Code
     C                   PARM                    OKACTN            1
      *
      ** OK Payment Reference
     C                   PARM                    OKPREF            1
      *
      ** OK Booking Branch
     C                   PARM                    OKBRCA            1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IRS Addtnl Interest Details')                    *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IR000170 - Midas IRS Addtnl Interest Details                 *
      *                                                               *
      *  Function:  This program will display additional interest     *
      *             details for IRS deals                             *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 MD037890           Date 25May16               *
      *                 CGL165             Date 17Feb15               *
      *                 MD030928           Date 03Dec14               *
      *                 CDL096             Date 25Nov14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR859056A          Date 10Apr13               *
      *                 AR859056 *CREATE   Date 10Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  MD037890 - Display negative amounts correctly. (Recompile)   *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD030928 - Repository ID field text incorrectly displayed in *
      *             additional details screen for IRS deals           *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR859056A - Set Accrued Interest Not Posted to ZERO for      *
      *              reversed and matured deals.                      *
      *  AR859056 - Additional interest details for IRS deals.        *
      *             (Child: AR859981)                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FDEALSALL  IF   E           K DISK
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(MMDELDP0)
     F                                     IGNORE(MMDENBP0)
     F                                     IGNORE(MMDENSP0)
     F                                     IGNORE(FXDEALP0)
     F                                     IGNORE(DLBHISD0)
     F                                     IGNORE(DLCHISD0)
     F                                     IGNORE(DLDHISD0)
     F                                     IGNORE(DLEHISD0)
     FDL0170FA  CF   E             WORKSTN
 
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
 
     D Dlnum           S                   LIKE(DLNO)
     D PFuncKey        S              2A
     D UNDec           S                   LIKE(A6NBDP)
     D TNDec           S                   LIKE(A6NBDP)
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PAmtOutU        S             17A
     D PBNDCSP         S              1
     D PBNTHSP         S              1
     D PKey            S              3A
     D Exit            S              1N
     D PInAmt          S             15  0
     D PNoOfChar       S              2  0
     D PCcyDecPl       S              1  0
     D PDspAmt         S             21A
     D WDivide         S              5  0
     D WANP            S             21  0
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Short Data Structure for Access Programs
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    Dlnum
     C                   PARM                    PFuncKey
 
     C                   EXSR      SrInzr
 
      * Prepare data
 
     C     Dlnum         CHAIN     DEALSALL
     C                   IF        %FOUND(DEALSALL)
 
      * Get currency decimal places
     C                   MOVE      Dlnum         SDLNM
     C                   MOVE      UCUCY         DUCCY
     C                   EXSR      SRGetDec
 
     C                   EVAL      DUAIP = *BLANKS
     C                   EVAL      PInAmt = UAIPD
     C                   EVAL      PCcyDecpl  = UNDec
     C                   EXSR      SRFmtAmt
     C                   EVAL      DUAIP = PDspAmt
 
     C                   EVAL      DUANP = *BLANKS
     C                   SELECT
     C                   WHEN      UICBS = 1 OR UICBS = 4
     C                   EVAL      WDivide = 36500
     C                   WHEN      UICBS = 2 OR UICBS = 3
     C                             OR UICBS = 5
     C                   EVAL      WDivide = 36000
     C                   WHEN      UICBS = 6
     C                   EVAL      WDivide = 36600
     C                   ENDSL
     C     UPAMT         MULT      UEINR         WANP
     C                   DIV       WDivide       WANP
                                                                                           AR859056A
      * Set WANP to zero for Reversed and Matured deals                                    AR859056A
     C                   IF        RECI <> 'D'                                             AR859056A
     C                   EVAL      WANP = 0                                                AR859056A
     C                   ENDIF                                                             AR859056A
                                                                                           AR859056A
     C                   EVAL      PInAmt = WANP
     C                   EVAL      PCcyDecpl  = UNDec
     C                   EXSR      SRFmtAmt
     C                   EVAL      DUANP = PDspAmt
 
     C                   EVAL      DUIPR = *BLANKS
     C                   EVAL      PInAmt = UIPRD
     C                   EVAL      PCcyDecpl  = UNDec
     C                   EXSR      SRFmtAmt
     C                   EVAL      DUIPR = PDspAmt
 
     C                   MOVE      TCUCY         DTCCY
     C                   EVAL      DTAIP = *BLANKS
     C                   EVAL      PInAmt = TAIPD
     C                   EVAL      PCcyDecpl  = TNDec
     C                   EXSR      SRFmtAmt
     C                   EVAL      DTAIP = PDspAmt
 
     C                   EVAL      DTANP = *BLANKS
     C                   SELECT
     C                   WHEN      TICBS = 1 OR TICBS = 4
     C                   EVAL      WDivide = 36500
     C                   WHEN      TICBS = 2 OR TICBS = 3
     C                             OR TICBS = 5
     C                   EVAL      WDivide = 36000
     C                   WHEN      TICBS = 6
     C                   EVAL      WDivide = 36600
     C                   ENDSL
     C     TPAMT         MULT      TEINR         WANP
     C                   DIV       WDivide       WANP
                                                                                           AR859056A
      * Set WANP to zero for Reversed and Matured deals                                    AR859056A
     C                   IF        RECI <> 'D'                                             AR859056A
     C                   EVAL      WANP = 0                                                AR859056A
     C                   ENDIF                                                             AR859056A
                                                                                           AR859056A
     C                   EVAL      PInAmt = WANP
     C                   EVAL      PCcyDecpl  = TNDec
     C                   EXSR      SRFmtAmt
     C                   EVAL      DTANP = PDspAmt
 
     C                   EVAL      DTIPR = *BLANKS
     C                   EVAL      PInAmt = TIPRD
     C                   EVAL      PCcyDecpl  = TNDec
     C                   EXSR      SRFmtAmt
     C                   EVAL      DTIPR = PDspAmt
 
      * Display data until exit
     C                   EVAL      Exit = *OFF
 
     C                   DOW       Exit = *OFF
     C                   EVAL      *IN03 = *OFF
     C                   EVAL      *IN08 = *OFF
     C                   EVAL      *IN12 = *OFF
 
     C                   TIME                    STIME
     C**********         WRITE     DL0170F1                                                 MD030928
     C**********         READ      DL0170F1                                                 MD030928
     C                   WRITE     DL0170FA1                                                MD030928
     C                   READ      DL0170FA1                                                MD030928
 
     C                   SELECT
 
     C                   WHEN      *INKC = '1'
     C                   EVAL      Exit = *ON
     C                   EVAL      PFuncKey = '03'
 
     C                   WHEN      *INKH = '1'
     C                   EVAL      PFuncKey = '08'
     C                   EVAL      Exit = *ON
 
     C                   WHEN      *INKL = '1'
     C                   EVAL      Exit = *ON
     C                   EVAL      PFuncKey = '12'
 
     C                   ENDSL
     C                   ENDDO
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      ** SRFmtAmt - Format amount for display                         *
      *****************************************************************
     C     SRFmtAmt      BEGSR
 
     C                   EVAL      PNoOfChar = 17
     C                   EVAL      PBNTHSP = ','
     C                   CALLB     'ZA1020'
     C                   PARM                    PInAmt
     C                   PARM                    PNoOfChar
     C                   PARM                    PCcyDecPl
     C                   PARM      BNDCSP        PBNDCSP
     C                   PARM                    PBNTHSP
     C                   PARM      *BLANKS       PDspAmt
 
     C                   ENDSR
      *****************************************************************
      ** SRGetDec - Get Ccy Decimal Places                            *
      *****************************************************************
     C     SRGetDec      BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      UCUCY         PKey
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   EVAL      UNDec = A6NBDP
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      TCUCY         PKey
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   EVAL      TNDec = A6NBDP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrInzr        BEGSR
 
     C                   MOVEL     PSJobName     SWSID
     C                   MOVEL     PsUser        SUSER
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      SRUNA = BJMRDT
     C                   ENDIF
 
     C                   CALLB     'AODEALR1'
     C                   PARM      '*BLANKS'     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDDEAL        PARM      SDDEAL        DSSDY
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2013

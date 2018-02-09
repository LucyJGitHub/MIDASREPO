     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate exchg rte/ovrrde ind - detail')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVEXRT02 - Validate Exchange Rate, Exchange Rate Override   *
      *               Indicator                                       *
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
      *  Prev Amend No. MD030708A          Date 29Sep14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 25Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030708A - A Serious Midas error occurred when entering     *
      *              an invalid character                             *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      * CFT008 - Funds Transfer addition of MT102 messages            *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Data Structure for P#INDC of FT0010
      *
     DIndc             DS
     DWindc1                   1      1
     DWindc2                   2      2
     DWindc3                   3      3
     DWindc4                   4      4
     DWindc5                   5      5
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions parameter list
      ** for call to FT0010.
     D/COPY FTCPYSRC,FT0010D001
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
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      ** Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      ** External data structure for Bank standing data
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Currency standing data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for Funds Transfer ICD
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** OK Flags for First screen
     D OKFlagDs1     E DS                  EXTNAME(FTE102S1PD)
 
      ** OK Flag for second screen
     D OKFlagDs2     E DS                  EXTNAME(FTE102S2PD)
 
      ** OK Flags for First screen - header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
      ** OK Flag for second screen - header
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)
 
 
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
     D WIx             S              3P 0
 
     D CFT004          S              1    INZ('N')
 
      ** Numeric version of Payment Amount
     D NumPAYAMT       S             13P 0
 
      ** Numeric version of Transfer Amount
     D NumCCTAMT       S             13P 0
 
      ** Exchange Rate calculated by the system/numeric version of PXRATE
     D CalcXrate       S             13P 8 Export
 
      ** DayNumber from debit value date
     D DayNum          S              5  0 Import
 
      ** DayNumber from Credit value date
     D DayNoOut        S              5  0 Import
 
      ** Exchange Rate from screen but in numeric format
     D ScrnXRATE       S                   LIKE(CalcXRATE)
 
      ** Limit of exchange rate discrepancy
     D RateLimit       S                   LIKE(CalcXRATE)
 
      ** Work field for % rate discrepancy
     D WBtpcrd         S              5  2
 
      ** Work field for numeric exchange rate
     D WPcctRte        S             13P 8
 
      ** Work field for numeric exchange rate
     D WPXRate         S             13P 8
 
      ** Work field for numeric exchange rate
     D Zfield          S             16
 
     D ValPCCy         S              1
     D ValCCCy         S              1
     D ValPAmt         S              1
     D ValCAmt         S              1
     D Default         S              1    INZ('N')
     D CSW202          S              1                                                       CSW202
     D PRTCD           S              7                                                       CSW202
 
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
 
      *
      ** Initial Processing - Initialise fields
      *
     C                   EVAL      RtCd       = *Blanks
     C                   EVAL      Idx        = 0
     C                   EVAL      WIx        = 0
     C                   EVAL      OKRate     = 'Y'
     C                   EVAL      OKRteO     = 'Y'
     C                   EVAL      ZALIGNok   = 'Y'
     C                   EVAL      CalcXRATE  = *Zeros
     C                   EVAL      ScrnXRATE  = *Zeros
     C                   EVAL      RateLimit  = *Zeros
     C                   EVAL      NumCCtAMT  = 0
     C                   EVAL      NumPAYAMT  = 0
     C                   EVAL      CctAmtDP  = 0
     C                   EVAL      PayAmtDP  = 0
     C                   EVAL      ValPccy  = 'Y'
     C                   EVAL      ValCccy  = 'Y'
     C                   EVAL      ValPamt  = 'Y'
     C                   EVAL      ValCamt  = 'Y'
     C                   EVAL      WBtpcrd  = *Zeros
     C                   EVAL      Default = 'N'
     C                   EVAL      WPCCtRte = *Zeros
     C                   EVAL      WPXRate = *Zeros
      *
      ** Get initialisation data
      *
     C                   EXSR      INIT
      *
      ** Validate Exchange rate override indicator
      *
     C                   EXSR      ValOvrRdIn
      *
      ** If exchange rate is entered in the header then default it          g
      ** to detail but still give error message (unless override set to yes)g
      *
     C                   IF        PXrate <> *Blanks
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      PXRate        Zfield
     C                   Z-ADD     8             Zadec
     C                   Z-ADD     5             Zadig
     C                   CALLB     'ZALIGN'
     C                   PARM                    Zalignok
     C                   PARM                    Zfield
     C                   PARM                    Zadec
     C                   PARM                    Zadig
      ** Database Error
     C                   IF        Zalignok = 'N'
     C                   MOVEL     'ZALIGN  '    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     ZFIELD        DBKEY
     C                   MOVEL     '*ERROR'      RetCodeIn
     C**********         EXSR      *PSSR                                                   MD030708A
     C                   EVAL      Idx = Idx + 1                                           MD030708A
     C                   EVAL      FldNamXAr(Idx) = 'PXRate'                               MD030708A
     C                   EVAL      MsgIdxAr(Idx) = 'RFV0158'                               MD030708A
     C                   ENDIF
     C                   MOVE      Zfield        WPXrate
     C                   ELSE
     C                   EVAL      WPXrate = *Zeros
     C                   ENDIF
      *
     C                   IF        HPCctRte <> *Blanks
     C                   MOVE      *BLANKS       Zfield
     C                   MOVE      HPCctRte      Zfield
     C                   Z-ADD     8             Zadec
     C                   Z-ADD     5             Zadig
     C                   CALLB     'ZALIGN'
     C                   PARM                    Zalignok
     C                   PARM                    Zfield
     C                   PARM                    Zadec
     C                   PARM                    Zadig
      ** Database Error
     C                   IF        Zalignok = 'N'
     C                   MOVEL     'ZALIGN  '    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     ZFIELD        DBKEY
     C                   MOVEL     '*ERROR'      RetCodeIn
     C**********         EXSR      *PSSR                                                   MD030708A
     C                   EVAL      Idx = Idx + 1                                           MD030708A
     C                   EVAL      FldNamXAr(Idx) = 'PXRate'                               MD030708A
     C                   EVAL      MsgIdxAr(Idx) = 'RFV0158'                               MD030708A
     C                   ENDIF
     C                   MOVE      Zfield        WPCCtRte
     C                   ELSE
     C                   EVAL      WPCctRte = *Zeros
     C                   ENDIF
      *
      *
     C                   IF        HPcctRte <> *Blanks
     C                   IF        PXRate = *Blanks
     C                             AND  CSW202 = 'N'                                          CSW202
     C                             OR   PXRate = *BLANKS                                      CSW202
     C                             AND  CSW202 = 'Y'                                          CSW202
     C                             AND  PCCTCCY <> PPAYCCY                                    CSW202
     C                   EVAL      PXRate = HPCctRte
     C                   EVAL      Default = 'Y'
     C                   ELSE
     C                   IF        WPXrate <> WPCCtRte
     C                             AND  CSW202 = 'N'                                          CSW202
     C                             OR   WPXrate <> WPCCtRte                                   CSW202
     C                             AND  CSW202 = 'Y'                                          CSW202
     C                             AND  PCCTCCY <> PPAYCCY                                    CSW202
     C                   EVAL      OKRate = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PXRate'
     C                   EVAL      MsgIdxAr(Idx) = 'RFV0342'
     C                   EVAL      CalcXRate = *Zeros
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate both fields, depending on whether incoming or out going msg
      *
     C                   SELECT
      *
     C                   WHEN      HPCcttyp = 'BO'
     C                   EXSR      ValidateO
      *
     C                   WHEN      HPCcttyp = 'BI'
     C                   EXSR      ValidateI
     C                   ENDSL
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValOvrRdIn - Validate Override Indicator                      *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     ValOvrRdIn    BEGSR
      *
      ** If entered Exchange Rate Override Indicator can only be 'Y' or 'N'.
      *
     C                   IF        PXRateO <> *Blanks
      *
     C                   IF        PXRateO <> 'Y' AND PXRateO <> 'N'
     C                   EVAL      OKRteO = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PXRateO'
     C                   EVAL      MsgIdxAr(Idx) = 'RFV0155'
     C                   ENDIF
      *
      ** If not entered, default to 'N'.
      *
     C                   ELSE
     C                   EVAL      PXRateO = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ConvAmts - Convert payment amount and transfer amounts to dec *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     ConvAmts      BEGSR
      *
      ** Obtain Transfer Amount in numeric format
      *
     C                   IF        PCCtCcy <> *Blanks
     C                   EVAL      @Ccy = PCCtCcy
     C                   EXSR      AOCURR
     C                   ELSE
     C                   EVAL      ValCccy = 'N'
     C                   ENDIF
      *
     C                   IF        ValCccy <> 'N'
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      ValCccy = 'N'
      *
     C                   ELSE
      *
     C                   MOVEL     A6NBDP        CCtAmtDP          1 0
      *
     C                   IF        PPayCcy <> *Blanks
     C                   EVAL      @Ccy = PPayCcy
     C                   EXSR      AOCURR
     C                   ELSE
     C                   EVAL      ValPccy = 'N'
     C                   ENDIF
      *
     C                   IF        ValPccy <> 'N'
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      ValPccy = 'N'
     C                   ELSE
     C                   MOVEL     A6NBDP        PayAmtDP          1 0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateO - Validate outgoing field                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     ValidateO     BEGSR
      *
      ** Calculate Exchange Rate whether the user has entered it or not.
      ** It can only be calculated if Transfer Ccy AND Payment Ccy are
      ** both valid.
      ** The value is either defaulted or checked against % rate discrepancy
      *
     C                   EXSR      ConvAmts
      *
     C                   IF        ValPCcy = 'N' OR ValCCCY = 'N'
     C                   IF        PXRate  <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PXRate'
     C                   EVAL      MsgIdxAr(Idx) = 'RFV0156'
     C                   EVAL      CalcXRate = *Zeros
     C                   EVAL      OKRate     = 'N'
     C                   ENDIF
     C                   ELSE
      *
     C                   CLEAR                   P#0010
     C                   MOVEL     *Blanks       P#NDCY
     C                   Z-ADD     *Zeros        P#NDAM
     C                   MOVEL     PCctCcy       P#CrCy
     C                   Z-ADD     *Zeros        P#Crdt
     C                   MOVEL     PPayCcy       P#DbCY
     C                   Z-ADD     DayNum        P#Dbdt
     C                   MOVEL     PXRateO       P#OVRT
     C                   Z-ADD     *Zeros        P#PDAM
     C                   Z-ADD     WBTPCRD       P#RTDS
     C                   MOVEL     'Y'           P#SDIN
     C                   Z-ADD     1             P#CrAm
     C                   Z-ADD     1             P#DbAm
      *
      ** If not entered, default Exchange Rate to screen using calc. value
      *
     C                   IF        PXRate = *Blanks
      *
     C                   Z-ADD     *Zeros        P#RATE
      *
     C                   CALLB     'FT0010'
     C                   PARM                    P#0010
      *
     C                   MOVEL     P#Indc        Indc
      *
     C                   EVAL      CalcXRATE = P#Rate
      *
     C                   MOVE (P)  CalcXRate     ZFIELD
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADECP            2 0
      *
     C                   MOVE      *Blanks       PXRate
     C                   MOVE      ZFIELD        PXRate
      *
      ** Else the Exchange Rate has been entered...
      *
     C                   ELSE
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZALIGNok = 'Y'
     C                   MOVE (P)  PXRATE        ZFIELD
      *
      ** ... ensure Exchange Rate is in a valid format
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   PARM      5             ZADIG             2 0
      *
     C                   IF        ZALIGNok <> 'Y'
     C                             AND Idx = 0                                             MD030708A
     C                   MOVE      'N'           OKRate
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0158'     MsgIdXAr(Idx)
      *
     C                   ELSE
     C                   EVAL      ScrnXRATE = *Zeros
     C                   MOVE      ZFIELD        ScrnXRATE
      *
     C                   Z-ADD     ScrnXRate     P#RATE
      *
     C                   CALLB     'FT0010'
     C                   PARM                    P#0010
      *
     C                   MOVEL     P#Indc        Indc
      *
      ** ... ensure Exchange Rate falls within the percentage rate discrep-
      **  ancy of the calculated rate (unless ex. rate override = 'Y')
      *
     C                   IF        Windc5 = '1'
     C                   IF        HPCctRte <> *Blanks
     C                             AND  CSW202 = 'N'                                          CSW202
     C                             OR   HPCctRte <> *BLANKS                                   CSW202
     C                             AND  CSW202 = 'Y'                                          CSW202
     C                             AND  PCCTCCY <> PPAYCCY                                    CSW202
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PXRate'
     C                   EVAL      MsgIdxAr(Idx) = 'RFV0331'
     C                   EVAL      CalcXRate = *Zeros
     C                   EVAL      OKRate     = 'N'
     C                   ELSE
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PXRate'
     C                   EVAL      MsgIdxAr(Idx) = 'RFV0159'
     C                   EVAL      CalcXRate = *Zeros
     C                   EVAL      OKRate     = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** If the Exchange Rate is valid move the screen value into calc-t
      ** XRate in case Pay. amount needs to be defaulted.              e
      *
     C                   IF        OKRate = 'Y'
     C                   EVAL      CalcXRATE = ScrnXRATE
     C                   ENDIF
      *
      ** If value is in valid format ensure screen field is 13,8 format
      *
     C                   IF        ZALIGNok <> 'N'
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      8             ZADEC
      *
     C                   MOVE      *Blanks       PXRate
     C                   MOVE      ZFIELD        PXRate
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateI - Validate Incoming fields                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     ValidateI     BEGSR
      *
      ** Calculate Exchange Rate whether the user has entered it or not.
      ** It can only be calculated if Transfer Ccy AND Payment Ccy are
      ** both valid.
      ** The value is either defaulted or checked against % rate discrepancy
      *
     C                   EXSR      ConvAmts
      *
     C                   IF        ValPCcy = 'N' OR ValCCCY = 'N'
     C                   IF        PXRate  <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PXRate'
     C                   EVAL      MsgIdxAr(Idx) = 'RFV0156'
     C                   EVAL      CalcXRate = *Zeros
     C                   EVAL      OKRate = 'N'
     C                   ENDIF
     C                   ELSE
      *
     C                   CLEAR                   P#0010
     C                   MOVEL     *Blanks       P#NDCY
     C                   Z-ADD     *Zeros        P#NDAM
     C                   MOVEL     PCctCcy       P#DbCy
     C                   Z-ADD     *Zeros        P#Dbdt
     C                   MOVEL     PPayCcy       P#CrCY
     C                   Z-ADD     DayNoOut      P#Crdt
     C                   MOVEL     PXRateO       P#OVRT
     C                   Z-ADD     *Zeros        P#PDAM
     C                   Z-ADD     WBTPCRD       P#RTDS
     C                   MOVEL     'Y'           P#SDIN
     C                   Z-ADD     1             P#CrAm
     C                   Z-ADD     1             P#DbAM
      *
      ** If not entered, default Exchange Rate to screen using calc value
      *
     C                   IF        PXRate = *Blanks
      *
     C                   Z-ADD     *Zeros        P#RATE
      *
     C                   CALLB     'FT0010'
     C                   PARM                    P#0010
      *
     C                   MOVEL     P#Indc        Indc
      *
     C                   EVAL      CalcXRATE = P#Rate
      *
     C                   MOVE (P)  CalcXRate     ZFIELD
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADECP            2 0
      *
     C                   MOVE      *Blanks       PXRate
     C                   MOVE      ZFIELD        PXRate
      *
      ** Else the Exchange Rate has been entered...
      *
     C                   ELSE
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZALIGNok = 'Y'
     C                   MOVE (P)  PXRATE        ZFIELD
      *
      ** ... ensure Exchange Rate is in a valid format
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   PARM      5             ZADIG             2 0
      *
     C                   IF        ZALIGNok <> 'Y'
     C                             AND Idx = 0                                             MD030708A
     C                   MOVE      'N'           OKRATE
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0158'     MsgIdXAr(Idx)
      *
     C                   ELSE
      *
     C                   EVAL      ScrnXRATE = *Zeros
     C                   MOVE      ZFIELD        ScrnXRATE
      *
     C                   Z-ADD     ScrnXRate     P#RATE
      *
     C                   CALLB     'FT0010'
     C                   PARM                    P#0010
      *
     C                   MOVEL     P#Indc        Indc
      *
     C                   IF        Windc5 = '1'
     C                   IF        HPCctRte <> *Blanks
     C                             AND  CSW202 = 'N'                                          CSW202
     C                             OR   HPCctRte <> *BLANKS                                   CSW202
     C                             AND  CSW202 = 'Y'                                          CSW202
     C                             AND  PCCTCCY <> PPAYCCY                                    CSW202
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PXRate'
     C                   EVAL      MsgIdxAr(Idx) = 'RFV0331'
     C                   EVAL      CalcXRate = *Zeros
     C                   EVAL      OKRate     = 'N'
     C                   ELSE
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PXRate'
     C                   EVAL      MsgIdxAr(Idx) = 'RFV0159'
     C                   EVAL      CalcXRate = *Zeros
     C                   EVAL      OKRate     = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** If the Exchange Rate is valid move the screen value into calc-
      ** XRate in case Pay. amount needs to be defaulted
      *
     C                   IF        OKRate = 'Y'
     C                   EVAL      CalcXRATE = ScrnXRATE
     C                   ENDIF
      *
      ** If value is in valid format ensure screen field is 13,8 format
      *
     C                   IF        ZALIGNok <> 'N'
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      8             ZADEC
      *
     C                   MOVE      *Blanks       PXRate
     C                   MOVE      ZFIELD        PXRate
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AOCURR - Access currency details                              *
      *                                                               *
      * Called by: ConvAmts                                           *
      *                                                               *
      * Calls: AOCURRR0                                               *
      *                                                               *
      *****************************************************************
      *
     C     AOCURR        BEGSR
      *
     C                   IF        @CCY <> *Blanks
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       RTCD              7
     C                   PARM      '*KEY'        OPTN              7
     C                   PARM                    @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   ENDIF
      *
     C                   ENDSR                                                  *** InzEnd ***
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT - Program Initialisation routine-done every time        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
      ** Access object for Bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       RTCD              7
     C                   PARM      '*FIRST'      OPTN              7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     RTCD          IFNE      *Blanks
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 902*
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access object for FT ICD
      *
     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR'      RTCD              7
     C                   PARM      '*FIRST'      OPTN              7
     C     SDFTFR        PARM      SDFTFR        DSFDY
      *
      ** Database error
      *
     C     RTCD          IFNE      *Blanks
     C                   MOVEL     'SDFTFRPD'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 902*
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WBtPcrd = BTPcrd / 100
     C                   ENDIF
      *
      ** Check for CFT004 enhancement
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       RTCD              7
     C                   PARM      '*VERIFY'     OPTN              7
     C                   PARM      'CFT004'      SARD              6
     C                   PARM                    DSFDY
      *
     C                   IF        RTCD = *Blanks
     C                   EVAL      CFT004 = 'Y'                                 ************
     C                   ELSE                                                   * DBERR 902*
     C                   EVAL      CFT004 = 'N'
     C                   ENDIF
      *
     C                   ENDSR                                                  *** InzEnd ***
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
      *
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode        1
      *
      ** Screen fields
      *
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      ** OUTPUTS
      *
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OKFlagDs1
     C                   PARM                    OKFlagDs2
     C                   PARM                    OKFlagHs1
     C                   PARM                    OKFlagHs2
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
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
      *
     C                   ENDSR                                                  *** InzEnd ***
      *
      ********************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001

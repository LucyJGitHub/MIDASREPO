     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Default Sender's Charges in Pay. Ccy')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVSECH01 - Default Sender's Charges in Payment Currency     *
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
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 03Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer addition of MT102 messages           *
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
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      * OK Flags for second screen
     D OKFlagDs2     E DS                  EXTNAME(FTE102S2PD)
 
      * OK Flags for First screen
     D OKFlagDs1     E DS                  EXTNAME(FTE102S1PD)
 
      * OK Flags for second screen - header
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)
 
      * OK Flags for First screen - header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
      ** External data structure for Currency standing data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for ICd
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Objects - long data structure                                          220004
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     220004
                                                                                              220004
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Numeric version of Sender's Charges in Sender's Ccy
     D NumSNdCHG       S             13P 0
 
      ** Numeric version of Sender's Charges in Payment Ccy
     D NumChgPay       S             13P 0
 
      ** Work field for % rate discrepancy
     D WBtPcrd         S              5  2
 
     D*CalcXRate****   S             13P 8 Import
      *                                                                                       CSW201
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
     D PRtCd           S              7A                                                      CSW201
 
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
      ** Initialise fields
      *
     C                   EVAL      RetCodeIn  = *Blanks
     C                   EVAL      PSpyCcy    = *Blanks
     C                   EVAL      PSndOcg    = *Blanks
      *
      ** Default Senders Currency and Charges converted into payment CCy
      ** Can only do this if the Senders Currency and Charges are already
      ** valid, and payment currency is valid.
      *
     C                   IF        OKSCcy <> 'N'  and
     C                             OKSChg <> 'N'
     C                   EXSR      Default
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Default - Calculate and load screen fields for Senders        *
      *           charges in Payment Currency.  This can only be      *
      *           done if Payment Currency and Sender's Charges       *
      *           fields are already entered and valid.               *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: ConvAmt                                                *
      *                                                               *
      *****************************************************************
      *
     C     Default       BEGSR
      *
      ** Extract Fund Transfer Details
      *
     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR '     Rtcd              7
     C                   PARM      '*FIRST '     Optn              7
     C     SDFTFR        PARM      SDFTFR        Dsfdy
      *
     C                   IF        Rtcd <> *BLANKS
     C                   Z-ADD     001           Dbase
     C                   MOVEL     'SDFTFRPD'    DBfile
     C                   MOVEL     'CFT006'      DbKey
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WBtPcrd = BtPcrd / 100
     C                   ENDIF
      *
      ** If valid, move Payment Currency from first screen to the currency
      ** field here.
      *
     C                   IF        OKPCCY  <> 'N'  AND
     C                             PPAYCCY <> *Blanks
      *
     C                   EVAL      PSpyCcy = PPAYCCY
      *                                                                                       CSW201
      ** If enhancement 'SWIFT 2001 standard update' is installed                             CSW201
      ** default the 5 sets of payment charges and currency.                                  CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
      *                                                                                       CSW201
      ** Convert charge 1 screen field to numeric.                                            CSW201
     C                   IF        PSNDCCY <> *BLANKS                                         CSW201
     C                   MOVEL     PSNDCCY       @CCY                                         CSW201
     C                   MOVEL     *BLANKS       ZFIELD                                       CSW201
     C                   MOVE (P)  PSNDCHG       ZFIELD                                       CSW201
     C                   EXSR      ConvAmt2                                                   CSW201
     C                   MOVE      ZFIELD        NumSndCHG                                    CSW201
                                                                                              CSW201
     C                   MOVEL     PSNDCCY       P#FRCY                                       CSW201
     C                   EXSR      CalcChg                                                    CSW201
     C                   MOVE      ZFIELD        PSNDOCG                                      CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Convert charge 2 screen field to numeric.                                            CSW201
     C                   IF        PSNDCCY2 <> *BLANKS                                        CSW201
     C                   MOVEL     PSNDCCY2      @CCY                                         CSW201
     C                   MOVEL     *BLANKS       ZFIELD                                       CSW201
     C                   MOVE (P)  PSNDCHG2      ZFIELD                                       CSW201
     C                   EXSR      ConvAmt2                                                   CSW201
     C                   MOVE      ZFIELD        NumSndCHG                                    CSW201
                                                                                              CSW201
     C                   MOVEL     PSNDCCY2      P#FRCY                                       CSW201
     C                   EXSR      CalcChg                                                    CSW201
     C                   MOVE      ZFIELD        PSNDOCG2                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Convert charge 3 screen field to numeric.                                            CSW201
     C                   IF        PSNDCCY3 <> *BLANKS                                        CSW201
     C                   MOVEL     PSNDCCY3      @CCY                                         CSW201
     C                   MOVEL     *BLANKS       ZFIELD                                       CSW201
     C                   MOVE (P)  PSNDCHG3      ZFIELD                                       CSW201
     C                   EXSR      ConvAmt2                                                   CSW201
     C                   MOVE      ZFIELD        NumSndCHG                                    CSW201
                                                                                              CSW201
     C                   MOVEL     PSNDCCY3      P#FRCY                                       CSW201
     C                   EXSR      CalcChg                                                    CSW201
     C                   MOVE      ZFIELD        PSNDOCG3                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Convert charge 4 screen field to numeric.                                            CSW201
     C                   IF        PSNDCCY4 <> *BLANKS                                        CSW201
     C                   MOVEL     PSNDCCY4      @CCY                                         CSW201
     C                   MOVEL     *BLANKS       ZFIELD                                       CSW201
     C                   MOVE (P)  PSNDCHG4      ZFIELD                                       CSW201
     C                   EXSR      ConvAmt2                                                   CSW201
     C                   MOVE      ZFIELD        NumSndCHG                                    CSW201
                                                                                              CSW201
     C                   MOVEL     PSNDCCY4      P#FRCY                                       CSW201
     C                   EXSR      CalcChg                                                    CSW201
     C                   MOVE      ZFIELD        PSNDOCG4                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Convert charge 5 screen field to numeric.                                            CSW201
     C                   IF        PSNDCCY5 <> *BLANKS                                        CSW201
     C                   MOVEL     PSNDCCY5      @CCY                                         CSW201
     C                   MOVEL     *BLANKS       ZFIELD                                       CSW201
     C                   MOVE (P)  PSNDCHG5      ZFIELD                                       CSW201
     C                   EXSR      ConvAmt2                                                   CSW201
     C                   MOVE      ZFIELD        NumSndCHG                                    CSW201
                                                                                              CSW201
     C                   MOVEL     PSNDCCY5      P#FRCY                                       CSW201
     C                   EXSR      CalcChg                                                    CSW201
     C                   MOVE      ZFIELD        PSNDOCG5                                     CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
      *
      ** Convert screen fields to numeric.
      *
     C                   EXSR      ConvAmt
      *
      ** Calculate charges in Payment Currency.
      *
     C                   MOVEL     *Blanks       P#NDCY
     C                   Z-ADD     *Zeros        P#NDAM
     C                   MOVEL     PSndCcy       P#FRCY
     C                   Z-ADD     NumSndCHG     P#FRAM
     C                   Z-ADD     *Zeros        P#FRDT
     C                   MOVEL     PSpyCcy       P#TOCY
     C                   Z-ADD     *Zeros        P#TOAM
     C                   Z-ADD     *Zeros        P#TODT
     C                   MOVEL     PXRateO       P#OVRT
     C                   Z-ADD     *Zeros        P#PDAM
     C                   Z-ADD     *Zeros        P#RATE
     C                   Z-ADD     WBTPCRD       P#RTDS
     C                   MOVEL     'Y'           P#SDIN
      *
     C                   CALLB     'FT0010'
     C                   PARM                    P#0010
      *
      ** Convert numeric amount to screen format
      *
     C                   MOVE (P)  P#TOAM        ZFIELD
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PSpyCCY       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '100'         DBASE
     C                   MOVEL     PSpyCCY       DBKEY
     C                   EXSR      *PSSR
     C                   ELSE
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADECP            2 0
      *
     C                   MOVE      ZFIELD        PSndOcg
     C                   ENDIF
      *
     C                   ENDIF                                                                CSW201
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ConvAmt - Convert screen fields for Senders Charges to        *
      *           numeric format.                                     *
      *                                                               *
      * Called by: Default                                            *
      *                                                               *
      * Calls: ZALIGN                                                 *
      *                                                               *
      *****************************************************************
      *
     C     ConvAmt       BEGSR
      *
      ** Determine currency details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PSndCCY       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '200'         DBASE
     C                   MOVEL     PSndCCY       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Obtain Receiver's Charges in Payment Ccy in numeric format
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   MOVE (P)  PSndCHG       ZFIELD
      *
     C                   EVAL      ZaDig = 15 - A6NBDP
     C                   EVAL      ZaDec = A6NBDP
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   MOVE      ZFIELD        NumSndCHG
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                                  CSW201
      *****************************************************************                       CSW201
      *                                                               *                       CSW201
      * ConvAmt2 - Convert screen fields for Senders Charges to       *                       CSW201
      *           numeric format.                                     *                       CSW201
      *                                                               *                       CSW201
      *****************************************************************                       CSW201
     C     ConvAmt2      BEGSR                                                                CSW201
      *                                                                                       CSW201
      ** Determine currency details                                                           CSW201
      *                                                                                       CSW201
     C                   CALL      'AOCURRR0'                                                 CSW201
     C                   PARM      *Blanks       @RTCD                                        CSW201
     C                   PARM      '*KEY'        @OPTN                                        CSW201
     C                   PARM                    @CCY                                         CSW201
     C*****SDCURR        PARM      SDCURR        DSFDY                                 CSW201 220004
     C     SDCURR        PARM      SDCURR        DSSDY                                 CSW201 220004
      *                                                                                       CSW201
     C                   IF        @RTCD <> *Blanks                                           CSW201
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CSW201
     C                   MOVEL     '201'         DBASE                                        CSW201
     C                   MOVEL     @CCY          DBKEY                                        CSW201
     C                   EXSR      *PSSR                                                      CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Obtain Receiver's Charges in Payment Ccy in numeric format                           CSW201
      *                                                                                       CSW201
     C                   EVAL      ZaDig = 15 - A6NBDP                                        CSW201
     C                   EVAL      ZaDec = A6NBDP                                             CSW201
      *                                                                                       CSW201
     C                   CALLB     'ZALIGN'                                                   CSW201
     C                   PARM                    ZALIGNok                                     CSW201
     C                   PARM                    ZFIELD                                       CSW201
     C                   PARM                    ZADEC                                        CSW201
     C                   PARM                    ZADIG                                        CSW201
      *                                                                                       CSW201
     C                   ENDSR                                                                CSW201
      *                                                                                       CSW201
      *****************************************************************                       CSW201
      /EJECT                                                                                  CSW201
      *****************************************************************                       CSW201
      *                                                               *                       CSW201
      * CalcChg - Calculate charges in Payment Currency               *                       CSW201
      *                                                               *                       CSW201
      *****************************************************************                       CSW201
     C     CalcChg       BEGSR                                                                CSW201
                                                                                              CSW201
     C                   MOVEL     *Blanks       P#NDCY                                       CSW201
     C                   Z-ADD     *Zeros        P#NDAM                                       CSW201
     C                   Z-ADD     NumSndCHG     P#FRAM                                       CSW201
     C                   Z-ADD     *Zeros        P#FRDT                                       CSW201
     C                   MOVEL     PSPYCCY       P#TOCY                                       CSW201
     C                   Z-ADD     *Zeros        P#TOAM                                       CSW201
     C                   Z-ADD     *Zeros        P#TODT                                       CSW201
     C                   MOVEL     PXRateO       P#OVRT                                       CSW201
     C                   Z-ADD     *Zeros        P#PDAM                                       CSW201
     C                   Z-ADD     *Zeros        P#RATE                                       CSW201
     C                   Z-ADD     WBTPCRD       P#RTDS                                       CSW201
     C                   MOVEL     'Y'           P#SDIN                                       CSW201
      *                                                                                       CSW201
     C                   CALLB     'FT0010'                                                   CSW201
     C                   PARM                    P#0010                                       CSW201
      *                                                                                       CSW201
      ** Convert numeric amount to screen format                                              CSW201
      *                                                                                       CSW201
     C                   MOVE (P)  P#TOAM        ZFIELD                                       CSW201
      *                                                                                       CSW201
     C                   CALL      'AOCURRR0'                                                 CSW201
     C                   PARM      *Blanks       @RTCD                                        CSW201
     C                   PARM      '*KEY'        @OPTN                                        CSW201
     C                   PARM      PSPYCCY       @CCY                                         CSW201
     C*****SDCURR        PARM      SDCURR        DSFDY                                 CSW201 220004
     C     SDCURR        PARM      SDCURR        DSSDY                                 CSW201 220004
      *                                                                                       CSW201
     C                   IF        @RTCD <> *Blanks                                           CSW201
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CSW201
     C                   MOVEL     '101'         DBASE                                        CSW201
     C                   MOVEL     PSPYCCY       DBKEY                                        CSW201
     C                   EXSR      *PSSR                                                      CSW201
     C                   ELSE                                                                 CSW201
      *                                                                                       CSW201
     C                   CALLB     'ZAEDITM'                                                  CSW201
     C                   PARM                    ZFIELD                                       CSW201
     C                   PARM      A6NBDP        ZADECP                                       CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDSR                                                                CSW201
      *                                                                                       CSW201
      *****************************************************************                       CSW201
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
      *  Screen fields
      *
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      ** OUTPUTS
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OKFlagDS1
     C                   PARM                    OKFlagDS2
     C                   PARM                    OKFlagHS1
     C                   PARM                    OKFlagHS2
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       PRtCd                                        CSW201
      *                                                                                       CSW201
     C                   IF        PRtCd = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR                                                  *** InzEnd ***
      *
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001

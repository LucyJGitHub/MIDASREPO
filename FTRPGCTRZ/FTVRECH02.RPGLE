     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Default receivers charges in trans. ccy')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVRECH02  - Default Receiver's Charges in Transfer Currency *
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
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
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
      *                 CFT008  *CREATE    Date 02Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
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
 
      ** External data structure for Bank details ICD
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for ICd
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Objects - long data structure                                          220004
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     220004
                                                                                              220004
      * OK Flags for second screen
     D OKFlagDs2     E DS                  EXTNAME(FTE102S2PD)
 
      * OK Flags for First screen
     D OKFlagDs1     E DS                  EXTNAME(FTE102S1PD)
 
      * OK Flags for second screen - header
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)
 
      * OK Flags for First screen  - header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Numeric version of Receiver's Charges in Receiver's Ccy
     D NumRCVCHG       S             13P 0
 
      ** Work field for % rate discrepancy
     D WBtPcrd         S              5  2
 
     D*CalcXRate****   S             13P 8 Import
 
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
     C                   EVAL      PRTRCCY    = *Blanks
     C                   EVAL      PRCVCTF    = *Blanks
      *
      ** Default Transfer Currency and Receiver's Charges converted into
      ** Transfer Currency.
      ** Can only do this if the Receiver's Currency and Charges are already
      ** valid, and transfer currency is valid
      *
     C                   IF        OKRCCY <> 'N'  AND
     C                             OKRCHG <> 'N'
     C                   EXSR      Default
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Default - Calculate and load screen fields for Receiver's     *
      *           charges in Transfer Currency. This can only be      *
      *           done if Transfer Currency and Receiver's Charges    *
      *           fields are already entered and valid.               *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: ConvAmts                                               *
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
     C                   EVAL      WBtpcrd = Btpcrd / 100
     C                   ENDIF
      *
      *
      ** If valid, move Transfer Currency from top of screen to the currency
      ** field here.
      *
     C                   IF        OKTCcy  <> 'N' AND
     C                             PCCTCCY <> *Blanks
      *
     C                   EVAL      PRTrCcy = PCCtCcy
      *
      ** Convert amounts to numeric.
      *
     C                   EXSR      ConvAmt
      *
      ** Calculate charges in Transfer Currency.
      *
     C                   MOVEL     *Blanks       P#NDCY
     C                   Z-ADD     *Zeros        P#NDAM
     C                   MOVEL     PRcvCcy       P#FRCY
     C                   Z-ADD     NumRCVCHG     P#FRAM
     C                   Z-ADD     *Zeros        P#FRDT
     C                   MOVEL     PRTrCcy       P#TOCY
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
     C                   PARM      PRTRCCY       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @Rtcd <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '200'         DBASE
     C                   MOVEL     PRTRCCY       DBKEY
     C                   EXSR      *PSSR
     C                   ELSE
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADECP            2 0
      *
     C                   MOVE      ZFIELD        PRcvCtf
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
      * ConvAmt - Convert screen field for Receiver's Charges to      *
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
     C                   PARM      PRCvCcy       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @Rtcd <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '100'         DBASE
     C                   MOVEL     PRcvCcy       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Obtain Receiver's Charges in numeric format
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   MOVE (P)  PRCVCHG       ZFIELD
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
     C                   MOVE      ZFIELD        NumRCVCHG
      *
     C                   ENDSR
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
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
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
(c) Finastra International Limited 2001

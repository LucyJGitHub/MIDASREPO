     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Default receivers charges in pay. ccy')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVCHPY01 - Default Receiver's Charges in Payment Currency   *
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
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. 221761             Date 01Apr04               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 01Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
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
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
     D  PSNDREF_H    E                     EXTFLD(PSNDREF)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      * OK Flags for second screen
     D OKFlags       E DS                  EXTNAME(FTE101S2PD)
 
      ** External data structure for Currency standing data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Objects - long data structure                                          220004
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     220004
                                                                                              220004
      ** External data structure for ICd
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
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
 
      ** Numeric version of Receiver's Charges in Payment Ccy
     D NumChgPay       S             13P 0
 
     D WBtpcrd         S              5  2
 
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
 
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      PRCPCHG    = *Blanks
     C                   Eval      PRCPCCY    = *Blanks
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
     C                   EVAL      WBtPcRd = BtPcRd / 100
     C                   ENDIF
      *
 
      ** Default Transfer Currency and Receiver's Charges converted into
      ** Receiver's Currency.  These fields are only displayed for incoming
      ** RFTs.
      ** Can only do this if the Receiver's Currency and Charges are already
      ** valid.
     C                   IF        OKRVCH <> 'N'  and
     C                             OKRVCY <> 'N'  and
     C                             PPTYP  =  'RI'
     C                   EXSR      Default
     C                   ENDIF
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Default - Calculate and load screen fields for Receiver's     *
      *           charges in Paymrnt Currency.  This can only be      *
      *           done if Payment Currency and Receiver's Charges     *
      *           fields are already entered and valid.               *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: ConvAmt                                                *
      *                                                               *
      *****************************************************************
     C     Default       BEGSR
      *
      ** If valid, move Transfer Currency from top of screen to the currency
      ** field here.
     C                   IF        OKPYCY  = 'Y'        and
     C                             PPAYCCY <> *Blanks   and
     C                             OKRVCH  = 'Y'        and
     C                             PRCVCHG <> *Blanks   AND
     C                             OKRVCY  = 'Y'        and
     C                             PRCHCCY <> *Blanks
      *
     C                   EVAL      PRCPCCY = PPAYCCY
      *
      ** Convert screen fields to numeric.
     C                   EXSR      ConvAmt
      *
      ** Calculate charges in Transfer Currency.
     C                   MOVEL     *Blanks       P#NDCY
     C                   Z-ADD     *Zeros        P#NDAM
     C                   MOVEL     PRCHCCY       P#FRCY
     C                   Z-ADD     NumRCVCHG     P#FRAM
     C                   Z-ADD     *Zeros        P#FRDT
     C                   MOVEL     PRCPCCY       P#TOCY
     C                   Z-ADD     *Zeros        P#TOAM
     C                   Z-ADD     *Zeros        P#TODT
     C                   MOVEL     *Blanks       P#OVRT
     C                   Z-ADD     *Zeros        P#PDAM
     C                   Z-ADD     *Zeros        P#RATE
     C                   Z-ADD     Wbtpcrd       P#RTDS
     C                   MOVEL     'Y'           P#SDIN
      *
     C                   CALLB     'FT0010'
     C                   PARM                    P#0010
      *
      ** Convert numeric amount to screen format
     C                   MOVE (P)  P#TOAM        ZFIELD
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PRCPCCY       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '100'         DBASE                          * DBERR 902*
     C                   MOVEL     PRCPCCY       DBKEY                          * DBERR 902*
     C                   EXSR      *PSSR
     C                   ELSE
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADECP            2 0
      *
     C                   MOVE      ZFIELD        PRCPCHG
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ConvAmt - Convert screen fields for Receiver's Charges to     *
      *           numeric format.                                     *
      *                                                               *
      * Called by: Default                                            *
      *                                                               *
      * Calls: ZALIGN                                                 *
      *                                                               *
      *****************************************************************
     C     ConvAmt       BEGSR
      *
      ** Determine currency details
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PRCHCCY       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '200'         DBASE                          * DBERR 902*
     C                   MOVEL     PRCHCCY       DBKEY                          * DBERR 902*
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Obtain Receiver's Charges in Payment Ccy in numeric format
     C                   EVAL      ZFIELD = *Blanks
     C                   MOVE (P)  PRCVCHG       ZFIELD                         ************
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM      13            ZADIG             2 0
      *
     C                   MOVE      ZFIELD        NumRCVCHG
      *
     C                   ENDSR                                                  *** InzEnd ***
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
     C                   Parm                    HdrRcdIn
     C                   PARM                    DtlRcdIn
 
      * OUTPUTS
 
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
     C                   PARM                    OKFlags
 
 
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

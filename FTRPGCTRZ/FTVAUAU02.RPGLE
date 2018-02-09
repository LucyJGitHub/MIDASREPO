     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Dual Authorisation')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVAUAU02 - Validate Dual Authorisation                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
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
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 10Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer :  MT102 messages                    *
      *                                                               *
      *****************************************************************
     FFT102DL0  IF   E           K DISK
     FFT102HL3  UF   E           K DISK
 
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
     D/COPY ZACPYSRC,ERR_ARRAYS
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H_)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      * External DS for General Ledger details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (Long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Header record datastructure
     D FileRcd       E DS                  EXTNAME(FT102HPD)
     D HdrScreen     E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D Idx             S              3P 0
     D OldCctid        S                   Like(Pcctid)
     D OldTransId      S                   Like(PTRNSID)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D  OldDual        S                   Like(H_PCDUAL)
     D  TransAmt       S                   Like(CCTAMT)
     D  ZFIELD         S                   Like(PCCTAMT)
     D  ZADEC          S              1  0
     D  ZALIGNok       S              1A
     D  ZADIG          S              2P 0
 
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
 
      ** Initialization
     C                   Eval      RetCodeIn  = *BlankS
     C                   Eval      OldDual = H_PCDUAL
 
      *
      ** Access object for FT ICD
      *
     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY
      *
      * Database error
     C     @RTCD         IFNE      *Blanks
     C                   MOVEL     'SDFTFRPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *  Sum all records for this RFTID.  If sum of transaction amounts
      *  in BASE currency >= Audit Threshold (BTAUDT), set dual flag = 'Y',
      *  else set to 'N'.
 
     C     PCCTID        Setll     FT102DL0
     C     PCCTID        Reade     FT102DL0                               99
     C                   Dow       *IN99 = *OFF
 
     C                   Select
     C                   When      BJLCCY <> CCTCCY
 
     C                   Callb     'AOCURRR0'
     C                   Parm      *BLANK        @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    CCTCCY
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Z-Add     CCTAMT        InputAmnt
     C                   Z-Add     A6SPRT        ExchRate
     C                   Movel     A6MDIN        MultDivInd
     C                   Movel     CCTCCY        FrCurrency
     C                   Movel     BJLCCY        ToCurrency
     C                   Z-Add     A6NBDP        FrDecPlace
 
     C                   Callb     'AOCURRR0'
     C                   Parm      *BLANK        @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    BJLCCY
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Z-Add     A6NBDP        ToDecPlace
 
     C                   CallB     'ZCONVZ1'
     C                   Parm                    InputAmnt        15 0
     C                   Parm                    ExchRate         13 8
     C                   Parm                    MultDivInd        1
     C                   Parm                    FrCurrency        3
     C                   Parm                    ToCurrency        3
     C                   Parm                    FrDecPlace        1 0
     C                   Parm                    ToDecPlace        1 0
     C                   Parm      *Zeros        OutputAmnt       15 0
 
     C                   Eval      TransAmt = TransAmt + OutputAmnt
 
     C                   OTHER
     C                   Eval      TransAmt = Transamt + CCTAMT
 
     C                   Endsl
 
     C     PCCTID        Reade     FT102DL0                               99
     C                   Enddo
 
      * Add this transaction amount !
     C                   CallB     'AOCURRR0'
     C                   Parm      *BLANK        @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    PCCTCCY
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Move      *Blanks       zfield
     C                   Move      PCCTAMT       zfield
 
     C                   Eval      zadec = A6NBDP
     C                   Eval      zadig = 15 - A6NBDP
 
     C                   CallB     'ZALIGN'
     C                   Parm      'Y'           ZALIGNOk
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Parm                    ZADIG
 
     C                   If        BJLCCY <> PCCTCCY
 
     C                   Movel     ZFIELD        InputAmnt
     C                   Z-Add     A6SPRT        ExchRate
     C                   Movel     A6MDIN        MultDivInd
     C                   Movel     PCCTCCY       FrCurrency
     C                   Movel     BJLCCY        ToCurrency
     C                   Z-Add     A6NBDP        FrDecPlace
 
     C                   Callb     'AOCURRR0'
     C                   Parm      *BLANK        @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    BJLCCY
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Z-Add     A6NBDP        ToDecPlace
 
     C                   CallB     'ZCONVZ1'
     C                   Parm                    InputAmnt        15 0
     C                   Parm                    ExchRate         13 8
     C                   Parm                    MultDivInd        1
     C                   Parm                    FrCurrency        3
     C                   Parm                    ToCurrency        3
     C                   Parm                    FrDecPlace        1 0
     C                   Parm                    ToDecPlace        1 0
     C                   Parm      *Zeros        OutputAmnt       15 0
 
     C                   Eval      TransAmt = TransAmt + OutputAmnt
 
     C                   Else
     C                   Move      ZFIELD        InputAmnt
     C                   Eval      TransAmt = Transamt + InputAmnt
     C                   Endif
 
     C                   If        TransAmt >= BTAUDT
     C                   Eval      H_PCDUAL = 'Y'
     C                   Else
     C                   Eval      H_PCDUAL = 'N'
     C                   Endif
 
      * Only update if necessary
     C                   If        OldDual <> H_PCDUAL
     C     PCCTID        Chain     FT102HL3                           12
     C                   If        *IN12 = *Off
     C                   If        TransAmt >= BTAUDT
     C                   Eval      H_PCDUAL = 'Y'
     C                   Eval      CDUAL = 'Y'
     C                   Else
     C                   Eval      H_PCDUAL = 'N'
     C                   Eval      CDUAL = 'N'
     C                   Endif
 
     C                   Endif
     C                   Endif
 
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
      * INPUTS
     C                   Parm                    RetCodeIn
      *  Screen fields
     C                   Parm                    HdrRcdIn
     C                   Parm                    DtlRcdIn
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
      * Access bank details
     C                   CallB     'AOBANKR0'
     C                   PARM                    @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBPgm = 'FTV102HSIN'
     C                   EVAL      DBase = 1
     C                   EVAL      DBMod = 'FTVAUAU02'
     C                   EVAL      DBProc = '*INZSR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001

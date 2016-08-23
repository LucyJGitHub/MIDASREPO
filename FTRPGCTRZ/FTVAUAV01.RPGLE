     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Dual Authorisation')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVAUAU01 - Validate Dual Authorisation                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. 221761             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 10Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer : MT101 messages                     *
      *                                                               *
      *****************************************************************
     FFT101DL0  IF   E           K DISK
     FFT101HL3  IF   E           K DISK
 
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
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
     D  PSNDREF1     E                     EXTFLD(PSNDREF)
 
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
     D FileRcd       E DS                  EXTNAME(FT101HPD)
     D HdrScreen     E DS                  EXTNAME(FT101HSPD) PREFIX(H)
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D Idx             S              3P 0
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D  OldDual        S                   Like(PRDUAL)
     D  TransAmt       S                   Like(TRNAMT)
     D  ZFIELD         S                   Like(PTRNAMT)
     D  ZADEC          S              1  0
     D  ZALIGNok       S              1A
     D  ZADIG          S              2P 0
     D OldRftid        S                   Like(Prftid)
     D OldTransId      S                   Like(PTRNSID)
 
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
     C                   Eval      OldDual = PRDUAL
 
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
 
     C     PRFTID        Setll     FT101DL0
     C     PRFTID        Reade     FT101DL0                               99
     C                   Dow       *IN99 = *OFF
 
     C                   Select
     C                   When      BJLCCY <> TRNCCY
 
     C                   Callb     'AOCURRR0'
     C                   Parm      *BLANK        @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    TRNCCY
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Z-Add     TRNAMT        InputAmnt
     C                   Z-Add     A6SPRT        ExchRate
     C                   Movel     A6MDIN        MultDivInd
     C                   Movel     TRNCCY        FrCurrency
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
     C                   Eval      TransAmt = Transamt + TRNAMT
 
     C                   Endsl
 
     C     PRFTID        Reade     FT101DL0                               99
     C                   Enddo
 
      * Add this transaction amount !
     C                   CallB     'AOCURRR0'
     C                   Parm      *BLANK        @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    PTRNCCY
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Move      *Blanks       zfield
     C                   Move      PTRNAMT       zfield
 
     C                   Eval      zadec = A6NBDP
     C                   Eval      zadig = 15 - A6NBDP
 
     C                   CallB     'ZALIGN'
     C                   Parm      'Y'           ZALIGNOk
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Parm                    ZADIG
 
     C                   If        BJLCCY <> PTRNCCY
 
     C                   Movel     ZFIELD        InputAmnt
     C                   Z-Add     A6SPRT        ExchRate
     C                   Movel     A6MDIN        MultDivInd
     C                   Movel     PTRNCCY       FrCurrency
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
     C                   Eval      PRDUAL = 'Y'
     C                   Else
     C                   Eval      PRDUAL = 'N'
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
     C                   EVAL      DBPgm = 'FTV101HSIN'
     C                   EVAL      DBase = 1
     C                   EVAL      DBMod = 'FTVAUAU01'
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
(c) Misys International Banking Systems Ltd. 2001

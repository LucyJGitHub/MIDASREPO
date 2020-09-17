     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlements details update')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRSMUPD - Security Trade Settlement database update        *
      *                                                               *
      *  Function: This module will perform the update of the Midas   *
      *            database for the Security Trade Settlement.        *
      *                                                               *
      *  Component of: SETRSMSIN                                      *
      *                SETRSMRPR                                      *
      *                SETRSMUPP                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13456           Date 09Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAP182  *CREATE    Date 24Feb03               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG13456 - Warning message on Manual Full Settlement Trade   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01-02      Use for chaining to file                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrSetRecTot - Setup total for the record.                    *
      *  SrChkOthUpd - Check for update by another workstation        *
      *  SrInsert - Insert Trade Settlement record                    *
      *  SrAmend - Amend Trade Settlement                             *
      *  SrDelete - Delete Trade Settlement                           *
      *  SrZDate2   - Convert Midas Date into DDMMYY or MMDDYY        *
      *  SRErr - Routine for Exception Errors                         *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Security Trade Settlement Maintenance
     FSETLED    O  A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Security Trade Settlements - Audit
     FSETLEA    UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(SA_)
      *
      ** Trade Details Maintenance
     FSETRADL3  UF A E           K DISK    COMMIT
     F                                     PREFIX(T_)
      *
      ** Midas SE Client Depot Positions - Details
     FCDEPP     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(C_)
      *
      ** Midas SE Client Depot Positions - Audit
     FCDEPPA    UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(CA_)
      *
      ** Midas SE User Depot Positions - Details
     FUDEPP     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(U_)
      *
      ** Midas SE User Depot Positions - Audit
     FUDEPPA    UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(UA_)
      *
      ** Security Trade Movments Status
     FSEMVTSL6  O  A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEMVTSD0:SEMVTSD06)
     F                                     COMMIT
      *
      ** Security Trade Movments Status
     FSEMVTSL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(MV_)
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
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
      ** SE Trade Settlement Details for file update - file format
     D NwTSFilFmt    E DS                  EXTNAME(SEVTRSMPD)
      *
      ** SE Trade Details information retrieved from file - file format
     D CrTDFilFmt    E DS                  EXTNAME(TRADS)
     D                                     PREFIX(TD_)
      *
      ** SE Trade Settlement Details for file update - Midas file format
     D SetledupdF    E DS                  EXTNAME(SETLED)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(SE_)
      *
      ** Externally described DS for Securities Customers
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             01     01
     D  EndOfFile             02     02
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Work variables
      *
      ** Work parameters
     D OKTRDR          S              1A
     D OKMVDT          S              1A
     D OKFSET          S              1A
     D OKREVE          S              1A
     D PTRDR           S              6A
     D PMVDT           S              6A
     D PFSET           S              1A
     D PREVE           S              1A
     D PDBRN           S              3A
     D BJSBRC          S              3A
     D PNatn           S              5P 0
     D BJRDNB          S              5P 0
     D PMode           S              6A
     D PFRNT           S             20A
     D PTimeStamp      S             26Z
     D PRtCd           S              7A
     D POptn           S              7A
     D WType           S              1A
     D PEdtFld         S              1A
      *
     D KTRRF           S                   LIKE(TMTRRF)
     D KTRTY           S                   LIKE(TMTRTY)
     D KNTDT           S                   LIKE(TMNTDT)
      *
      ** Parameters for ZARTVJOBA
     D PReturn         S              6A
     D PType           S              1A
      *
      ** Parameter list for ZDATE2
     D PDateIn         S              5P 0
     D BJDFIN          S              1A
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** Parameter list for ZAMSGTOOPR
     D PMsgSndRtn      S             10A
     D PDBError        S            132A
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
     D Wc              S              2P 0
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
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Retrieve next available transaction number.
     C                   CallB     'ZTNLU1'
     C                   Parm                    RetCodeOut
     C                   Parm                    PNATN
      *
      *
      ** Update Trade Details File
      *  -------------------------
      *
     C                   Exsr      SrTrads
      *
      *
      ** Update Trade Settlement Details File
      *  ------------------------------------
      *
     C                   Exsr      SrSetled
      *
      *
      ** Update Trade Settlement Audit File
      *  ------------------------------------
      *
     C                   Exsr      SrSetledA
      *
      *
      ** Update Client Depot Positions Details File
      *  ------------------------------------------
      ** If trade is with a portfolio customer and settlement is for
      *  nominal(or reversal), update Client positions
      *
     C                   Movel     T_TCNR        WCust             6
     C                   Call      'AOSECSR0'
     C                   Parm      '*DBERR'      PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      WCust         CUST              6
     C     SDSECS        Parm      SDSECS        DSSDY
      *
     C                   If        BFCLAS = 'S' Or BFCLAS = 'D'
     C                   If        VTSSNMS <> *Zeros Or VTSSRIN = 'Y'
     C                   Exsr      SrCDeppd
     C                   EndIf
     C                   EndIf
      *
      *
      ** Update User Depot Positions Details File
      *  ----------------------------------------
      ** If settlement is for nominal (or reversal), update User positions
     C                   If        VTSSNMS <> *Zeros Or VTSSRIN = 'Y'
     C                   Exsr      SrUDeppd
     C                   EndIf
      *
      ** Write record to the Movement Status file
      *  ----------------------------------------
      *
     C                   Exsr      SrMovement
      *
      ** Return.
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTrads - Update Trade Details                               *
      *                                                               *
      *****************************************************************
     C     SrTrads       BEGSR
      *
      ** Retrieve Trade Details for update
     C     VTSSTDR       Chain     TRADSDF                            01
      *
      ** Error if it does not exists.
     C                   If        RecNotFnd = True
     C     *LOCK         IN        LDA
     C                   Eval      DBKEY  = VTSSTDR
     C                   Eval      DBFILE = 'TRADSD'
     C                   Eval      DBASE  =  002
     C                   OUT       LDA
     C                   Exsr      *PSSR
 
     C                   Else
      *
      ** Generate Timestamp.
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
      *
     C                   Eval      T_TMST = PTimestamp
     C                   Z-Add     BJRDNB        T_LCD
     C                   Z-Add     PNATN         T_TNLU
      *
      ** Increase settlement sequence number
     C                   Add       1             T_TSSQ
      *
      ** Date fully settled - write if blank and now fully settled
     C                   If        T_TDFS = *Zeros And VTSSFSI = 'Y'
     C                   Z-Add     BJRDNB        T_TDFS
     C                   EndIf
      *
      ** OR make blank if reversal indicated
     C                   If        VTSSRIN = 'Y'
     C                   Z-Add     *Zeros        T_TDFS
      *
      ** If reversing fully-settled trade, make RECI 'D'
     C                   If        T_RECI = 'S'
     C                   Eval      T_RECI = 'D'
     C                   EndIf
     C                   EndIf
      *
      ** Outstanding nominal: If reversal, add - else subtract
     C                   If        VTSSRIN = 'Y'
     C                   Add       VTSSNMS       T_TOSN
     C                   Else
     C                   Sub       VTSSNMS       T_TOSN
     C                   EndIf
                                                                                            BUG13456
      ** Nominal fully settled indicator                                                    BUG13456
                                                                                            BUG13456
     C                   Select                                                             BUG13456
     C     T_TOSN        WhenGt    0                                                        BUG13456
     C                   Eval      VTSSNFS = 'P'                                            BUG13456
     C     T_TOSN        WhenLt    0                                                        BUG13456
     C                   Eval      VTSSNFS = 'O'                                            BUG13456
     C     T_TOSN        Wheneq    0                                                        BUG13456
     C                   Eval      VTSSNFS = 'F'                                            BUG13456
     C                   Endsl                                                              BUG13456
      *
      ** Outstanding value: If reversal, add - else subtract
     C                   If        VTSSRIN = 'Y'
     C                   Add       VTSSVLS       T_TOSV
     C                   Else
     C                   Sub       VTSSVLS       T_TOSV
     C                   EndIf
                                                                                            BUG13456
      ** Value Fully Settled Indicator                                                      BUG13456
                                                                                            BUG13456
     C                   Select                                                             BUG13456
     C     T_TOSV        WhenGt    0                                                        BUG13456
     C                   Eval      VTSSFSL = 'P'                                            BUG13456
     C     T_TOSV        WhenLt    0                                                        BUG13456
     C                   Eval      VTSSFSL = 'O'                                            BUG13456
     C     T_TOSV        Wheneq    0                                                        BUG13456
     C                   Eval      VTSSFSL = 'F'                                            BUG13456
     C                   Endsl                                                              BUG13456
      *
      ** Nominal settled not posted - subtract if reversal, else add
     C                   If        VTSSRIN = 'Y'
     C                   Sub       VTSSNMS       T_TNSN
     C                   Else
     C                   Add       VTSSNMS       T_TNSN
     C                   EndIf
      *
      ** Value settled not posted - subtract if reversal, else add
     C                   If        VTSSRIN = 'Y'
     C                   Sub       VTSSVLS       T_TVSN
     C                   Else
     C                   Add       VTSSVLS       T_TVSN
     C                   EndIf
      *
      ** Discrepancy not posted
      *
      ** For full settlement:
     C                   If        VTSSFSI = 'Y'
     C                   Z-Add     VTSSDAM       T_TDSN
     C                   EndIf
      *
      ** For reversal:
     C                   If        VTSSRIN = 'Y'
     C                   Z-SUB     T_TDSP        T_TDSN
     C                   EndIf
      *
      ** Update record
      *                 *******************
     C                   UPDATE    TRADSDF                              99
      *                 *******************
      *
      ** DBError processing when error occurred during update.
     C                   If        *IN99 = *ON
     C     *LOCK         IN        LDA
     C                   Eval      DBKEY  = VTSSTDR
     C                   Eval      DBFILE = 'TRADSD'
     C                   Eval      DBASE  =  003
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   EndIf
      *
     C                   EndIf
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetled - Output a record to Trades Settlement File         *
      *                                                               *
      *****************************************************************
     C     SrSetled      BEGSR
      *
      ** Generate Timestamp.
     C                   CallB     'ZAGENTMSTM'
     C                   Parm                    PTimestamp
      *
      * Time Stamp
     C                   Eval      VTSTMST = PTimestamp
      * No of Last Update
     C                   Eval      VTSTNLU = PNATN
      *
      ** Move valid file fields to fields for update
     C                   Movel     NwTSFilFmt    SetledupdF
      *
      *                 *******************
     C                   Write     SETLEDF                              99
      *                 *******************
      *
      ** DBError processing when error occurred during write.
     C                   If        *IN99 = *ON
     C     *LOCK         IN        LDA
     C                   Eval      DBKEY  = VTSSTDR
     C                   Eval      DBFILE = 'SETLED'
     C                   Eval      DBASE  =  001
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   EndIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetledA - Settlement Audit Record                          *
      *                                                               *
      *****************************************************************
     C     SrSetledA     BEGSR
      *
      ** Retrieve Settlement Audit record
     C     1             Chain     SETLEAF                            01
      *
      ** Error if it does not exists.
     C                   If        RecNotFnd = True
     C     *LOCK         IN        LDA
     C                   Eval      DBKEY  = '1'
     C                   Eval      DBFILE = 'SETLEA'
     C                   Eval      DBASE  =  004
     C                   OUT       LDA
     C                   Exsr      *PSSR
      *
     C                   Else
      *
     C                   Add       1             SA_SINS
     C                   Add       1             SA_NORE
      *
     C                   Z-Add     BJRDNB        SA_LCD
     C                   Z-Add     PNATN         SA_TNLU
      *
      *                 *******************
     C                   UPDATE    SETLEAF                              99
      *                 *******************
      *
      ** DBError processing when error occurred during update.
     C                   If        *IN99 = *ON
     C     *LOCK         IN        LDA
     C                   Eval      DBKEY  = '1'
     C                   Eval      DBFILE = 'SETLEA'
     C                   Eval      DBASE  =  005
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   EndIf
      *
     C                   EndIf
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCDeppd - Update Client Depot Positions Details File        *
      *                                                               *
      *****************************************************************
     C     SrCDeppd      BEGSR
      *
     C     KeyCDEPP      KLIST
     C                   KFLD                    KCDPA             3            Branch
     C**********         KFLD                    KCDCN             6 0          Customer      CSD027
     C                   KFLD                    KCDCN             6            Customer      CSD027
     C                   KFLD                    KCDSN            10            Security Shortname
     C**********         KFLD                    KCDPT             6 0          Depot         CSD027
     C                   KFLD                    KCDPT             6            Depot         CSD027
     C                   KFLD                    KCDMK             1            Market
      *
      ** Setup keylist
     C                   Move      T_TDBA        KCDPA
     C**********         Z-Add     T_TCNR        KCDCN                                        CSD027
     C                   Eval      KCDCN = T_TCNR                                             CSD027
     C                   Move      T_TDSS        KCDSN
     C                   Move      T_TDMI        KCDMK
      *
     C                   If        T_TDTP = 'TP'
     C**********         Z-Add     T_DELF        KCDPT                                        CSD027
     C                   Eval      KCDPT = T_DELF                                             CSD027
     C                   Else
     C                   If        T_TDTP = 'TS'
     C**********         Z-Add     T_DELT        KCDPT                                        CSD027
     C                   Eval      KCDPT = T_DELT                                             CSD027
     C                   EndIf
     C                   EndIf
      *
     C     KeyCDEPP      Chain     CDEPPDF                            01
      *
     C                   Eval      C_Reci = 'D'
      *
      ** Branch
     C                   Move      T_TDBA        C_CDPA
      ** Customer
     C**********         Z-Add     T_TCNR        C_CDCN                                       CSD027
     C                   Eval      C_CDCN = T_TCNR                                            CSD027
      ** Security Shortname
     C                   Move      T_TDSS        C_CDSN
      ** Depot
     C**********         Z-Add     KCDPT         C_CDPT                                       CSD027
     C                   Eval      C_CDPT = KCDPT                                             CSD027
      ** Market
     C                   Move      T_TDMI        C_CDMK
      *
      ** Nominal Settled (I/C)
     C                   If        VTSSRIN <> 'Y'
     C                   If        T_TDTP = 'TP'
     C                   Sub       VTSSNMS       C_CNSI
     C                   Else
     C                   Add       VTSSNMS       C_CNSI
     C                   EndIf
     C                   Else
     C                   If        T_TDTP = 'TP'
     C                   Add       VTSSNMS       C_CNSI
     C                   Else
     C                   Sub       VTSSNMS       C_CNSI
     C                   EndIf
     C                   EndIf
      *
      ** Sum Nominals and A P Numerators
      *
     C     *IN01         Ifeq      '1'
     C                   Z-Add     *Zeros        C_CDNT
     C                   Z-Add     *Zeros        C_CDNV
     C                   Z-Add     *Zeros        C_CDNS
     C                   Z-Add     *Zeros        C_SNPT
     C                   Z-Add     *Zeros        C_CDST
     C                   Z-Add     *Zeros        C_SAPP
     C                   Z-Add     *Zeros        C_SAPS
     C                   Z-Add     *Zeros        C_CNPV
     C                   Z-Add     *Zeros        C_CNSV
     C                   Z-Add     *Zeros        C_SAPV
     C                   Z-Add     *Zeros        C_SPSV
     C                   EndIf
      *
     C                   Z-Add     PNATN         C_TNLU
      *
     C     *IN01         Ifeq      *OFF
      *                 *******************
     C                   UPDATE    CDEPPDF
      *                 *******************
     C                   Else
      *                 *******************
     C                   WRITE     CDEPPDF
      *                 *******************
      *
      ** Also update the trailer file
     C     1             Chain     CDEPPAF                            01
      *
      ** Error if it does not exists.
     C                   If        RecNotFnd = True
     C     *LOCK         IN        LDA
     C                   Eval      DBKEY  = '1'
     C                   Eval      DBFILE = 'CDEPPA'
     C                   Eval      DBASE  =  006
     C                   OUT       LDA
     C                   Exsr      *PSSR
      *
     C                   Else
      *
     C                   Z-Add     PNATN         CA_TNLU
     C                   Add       1             CA_NORE
      *
      *                 *******************
     C                   UPDATE    CDEPPAF                              99
      *                 *******************
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUDeppd - Update User Depot Positions Details File          *
      *                                                               *
      *****************************************************************
     C     SrUDeppd      BEGSR
      *
     C     KeyUDEPP      KLIST
     C                   KFLD                    KUDBA             3            Branch
     C                   KFLD                    KUDSN            10            Customer
     C**********         KFLD                    KUDPT             6 0          Depot         CSD027
     C                   KFLD                    KUDPT             6            Depot         CSD027
     C                   KFLD                    KUDBK             2            Security Shortname
     C                   KFLD                    KUDMK             1            Market
      *
      ** Setup keylist
     C                   Move      T_TDBA        KUDBA
     C                   Move      T_TDSS        KUDSN
     C                   Move      T_TDBK        KUDBK
     C                   Move      T_TDMI        KUDMK
      *
     C                   If        T_TDTP = 'TP'
     C**********         Z-Add     T_DELT        KUDPT                                        CSD027
     C                   Eval      KUDPT = T_DELT                                             CSD027
     C                   Else
     C                   If        T_TDTP = 'TS'
     C**********         Z-Add     T_DELF        KUDPT                                        CSD027
     C                   Eval      KUDPT = T_DELF                                             CSD027
     C                   EndIf
     C                   EndIf
      *
     C     KeyUDEPP      Chain     UDEPPDF                            01
      *
     C                   Eval      U_Reci = 'D'
      *
      ** Branch
     C                   Move      T_TDBA        U_UDBA
      ** Security Shortname
     C                   Move      T_TDSS        U_UDSN
      ** Book
     C                   Move      T_TDBK        U_UDBK
      ** Depot
     C**********         Z-Add     KUDPT         U_UDPT                                       CSD027
     C                   Eval      U_UDPT = KUDPT                                             CSD027
      ** Market
     C                   Move      T_TDMI        U_UDMK
      *
      ** Nominal Settled (I/C)
     C                   If        VTSSRIN <> 'Y'
     C                   If        T_TDTP = 'TP'
     C                   Add       VTSSNMS       U_UNSI
     C                   Else
     C                   Sub       VTSSNMS       U_UNSI
     C                   EndIf
     C                   Else
     C                   If        T_TDTP = 'TP'
     C                   Sub       VTSSNMS       U_UNSI
     C                   Else
     C                   Add       VTSSNMS       U_UNSI
     C                   EndIf
     C                   EndIf
      *
      ** Sum Nominals
      *
     C     *IN01         Ifeq      '1'                                                         S0115
     C                   Z-Add     *Zeros        U_UDNT                                        S0115
     C                   Z-Add     *Zeros        U_UDNV                                        S0115
     C                   Z-Add     *Zeros        U_UDNS                                        S0115
     C                   Z-Add     *Zeros        U_UDTP                                        S0115
     C                   Z-Add     *Zeros        U_UDTS                                        S0115
     C                   Z-Add     *Zeros        U_UDPV                                        S0115
     C                   Z-Add     *Zeros        U_UDSV                                        S0115
     C                   Z-Add     *Zeros        U_UNRT                                        S0115
     C                   Z-Add     *Zeros        U_UNRV                                        S0115
     C                   Z-Add     *Zeros        U_USNT                                        S0115
     C                   Z-Add     *Zeros        U_USNR                                        S0115
     C                   Z-Add     *Zeros        U_USNV                                        S0115
     C                   Z-Add     *Zeros        U_USRV                                        S0115
     C                   EndIf                                                                 S0115
      *
     C                   Z-Add     PNATN         U_TNLU
      *
     C     *IN01         Ifeq      *OFF
      *                 *******************
     C                   UPDATE    UDEPPDF
      *                 *******************
     C                   Else
      *                 *******************
     C                   WRITE     UDEPPDF
      *                 *******************
      *
      ** Also update the trailer file
     C     1             Chain     UDEPPAF                            01
      *
      ** Error if it does not exists.
     C                   If        RecNotFnd = True
     C     *LOCK         IN        LDA
     C                   Eval      DBKEY  = '1'
     C                   Eval      DBFILE = 'UDEPPA'
     C                   Eval      DBASE  =  007
     C                   OUT       LDA
     C                   Exsr      *PSSR
      *
     C                   Else
      *
     C                   Add       1             UA_NORE
     C                   Z-Add     PNATN         UA_TNLU
      *
      *                 *******************
     C                   UPDATE    UDEPPAF
      *                 *******************
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMovement - Movement Status Record                          *
      *                                                               *
      *****************************************************************
     C     SrMovement    BEGSR
      *
      ** Key list to access Movement Status file
     C     KeyMove       KLIST
     C                   KFLD                    KTRRF
     C                   KFLD                    KTRTY
     C                   KFLD                    KNTDT
      *
      ** Transaction Reference
     C                   Eval      TMTRRF = VTSSTDR
     C                   Eval      KTRRF = VTSSTDR
      *
      ** Transaction Type
     C                   Eval      TMTRTY = 'T'
     C                   Eval      KTRTY = 'T'
      *
      ** Notification Date
     C                   Z-Add     BJRDNB        TMNTDT
     C                   Z-Add     BJRDNB        KNTDT
      *
      ** Sequence Number
     C     KeyMove       Chain     SEMVTSL0                           80
     C                   If        *IN80 = '1'
     C                   Z-Add     1             TMSQNR
     C                   Else
     C     MV_TMSQNR     Add       1             TMSQNR
     C                   EndIf
      *
      ** Notification Method: From Interface
     C                   Eval      TMNTMT = VTSNOTM
      *
      ** SWIFT Status Code
     C                   Select
     C                   When      VTSSRIN = 'Y'
     C                   Movel     'RVS'         TMSWSC
     C                   When      VTSSFSI = 'Y'
     C                   Movel     'SET'         TMSWSC
     C                   Other
     C                   Movel     'PST'         TMSWSC
     C                   EndSl
      *
      ** SWIFT Reason Code
     C                   Eval      TMSWRC = *Blanks
      *
      ** Message Key: From Interface
     C                   Eval      TMMSGK = VTSMSGK
      *
      ** Narrative
     C                   Eval      TMNARR = *Blanks
      *
      ** Input Origin
     C                   Eval      TMINOR = 'Midas'
      *
      ** Transaction booking Branch
     C                   Eval      TMTRBB = VTSSBCA
      *
      ** Settlement Confirmation Required
     C                   Eval      TMSCRQ = 'N'
     C                   If        BFCLAS = 'S' Or BFCLAS = 'D'
     C                   If        BFSARQ = 'Y'
     C                   Eval      TMSCRQ = 'Y'
     C                   EndIf
     C                   EndIf
      *
      ** Settlement Message Generated
     C                   Eval      TMSTMG = *Blanks
      *
      ** Settlement Sequence number
     C                   Z-Add     VTSSSQN       TMSSQN
      *
      ** Front Office Id
     C                   Eval      TMFRNT = VTSFRNT
      *
      ** Associated Front Office Id
     C                   Eval      TMAFRT = VTSAFRT
      *
      ** Repair Location
     C                   Eval      TMREPA = VTSREPA
      *
      ** Time Stamp
     C                   CallB     'ZAGENTMSTM'
     C                   Parm                    PTimestamp
     C                   Eval      TMTMST = PTimestamp
      *
      ** Last Change Type
     C                   Eval      TMLCTP = 'I'
      *
      ** Last Change Date
     C                   Z-Add     BJRDNB        TMLCDT
      *
      ** Last Change User
     C                   Eval      TMLCUS = PsUser
      *
      ** Output a record to the Trade Movement Status File
      *
      *                 ********************
     C                   Write     SEMVTSD06                            99
      *                 ********************
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDate2 - Convert Midas Date into DDMMYY or MMDDYY          *
      *                                                               *
      *****************************************************************
     C     SrZDate2      BEGSR
      *
     C                   CallB     'ZDATE2'
     C                   Parm                    PDateIn
     C                   Parm                    BJDFIN
     C                   Parm      *ZERO         PDateOut
     C                   Parm      *Blanks       PADateOut
      *
     C                   ENDSR
      *
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
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** Input
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** SE Trade Settlement details for file update - file format
     C                   PARM                    NwTSFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Run day number
     C                   PARM                    BJRDNB
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2003

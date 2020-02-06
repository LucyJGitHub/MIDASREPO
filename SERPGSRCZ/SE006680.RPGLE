     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE EU Customer Position Backvaluation update')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE006680 - EU TAX Customer Position - add records back in    *
      *              due to back valuations                           *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *    This program reads all records from temporary file         *
      *    ETCPOSTEMP in timestamp order. For each record, calls      *
      *    SEETCPUPD to add a record onto ETCPOSND. For trades,       *
      *    SEVTRADTAX is called to update the record on SDCSINPD      *
      *    and the trade is set to 'changed' to get accounting and    *
      *    confirmations producd in close of business.                *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 236125 (reopen)    Date 23Sep05               *
      *                 236125             Date 22Sep05               *
      *                 235546 (reopen)    Date 23Aug05               *
      *                 235546  *CREATE    Date 27Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027A - Conversion Of Customer Number to Alpha (Recompile) *
      *  236125 - Reopen - change call of SEVTRADTAX from calling     *
      *           the module to calling the program                   *
      *  236125 - Program is not using QTEMP version of file          *
      *  235546 - Must take account of authorisation and set up RECI  *
      *           correctly for changed trades + update TRADSA +      *
      *           re-calculate countervalue + delete any settlements  *
      *           + update online files + do not overwrite trade dtls *
      *           in calling pgm + change of value date of trade      *
      *           was causing corruption                              *
      *  235546 - EU Tax backvaluations                               *
      *                                                               *
      *****************************************************************
 
     F*ETCPOSTEMPIF*A*E***********K DISK    INFSR(*PSSR)                                      235546
     F*ETCPOSTEMPUF*A*E***********K DISK    INFSR(*PSSR)                                235546236125
     FETCPOSTEMPUF A E           K DISK    INFSR(*PSSR) USROPN                                236125
     FTRADS     UF   E           K DISK    INFSR(*PSSR) COMMIT USROPN
     FTRADSA    UF   E             DISK    INFSR(*PSSR) COMMIT USROPN                         235546
     FTRAUTD    O    E             DISK    INFSR(*PSSR) COMMIT                                235546
     FSETLE     UF   E           K DISK    INFSR(*PSSR) COMMIT USROPN                         235546
     FSETLEA    UF   E             DISK    INFSR(*PSSR) COMMIT USROPN                         235546
 
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
 
      ** Include the SE standard declares
     D/COPY SECPYSRC,STDDECLARE
      ** The following /COPY includes the currency details data structures                    235546
     D/COPY SECPYSRC,SE_CCYDT                                                                 235546
      ** The following /COPY line includes the definitions for error and                      235546
      ** warning message arrays.                                                              235546
      ** The following /COPY includes the customer details data structure                     235546
     D/COPY ZACPYSRC,ERR_ARRAYS                                                               235546
     D/COPY ZACPYSRC,ERR_XARRYS                                                               235546
                                                                                              235546
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D*Security******E DS                  EXTNAME(SECTYD) PREFIX(SEC_)                       235546
     D Security      E DS                  EXTNAME(SECTYD)                                    235546
     D SEC_RECI      E                     EXTFLD(RECI)                                       235546
     D SEC_ZZ005     E                     EXTFLD(ZZ005)                                      235546
     D SEC_LCD       E                     EXTFLD(LCD)                                        235546
     D SEC_CHTP      E                     EXTFLD(CHTP)                                       235546
     D SEC_TNLU      E                     EXTFLD(TNLU)                                       235546
     D SEC_FRNT      E                     EXTFLD(FRNT)                                       235546
     D SEC_REPA      E                     EXTFLD(REPA)                                       235546
     D SEC_TMST      E                     EXTFLD(TMST)                                       235546
     D SEC_REPI      E                     EXTFLD(REPI)                                       235546
     D WTMST         E                     EXTFLD(TMST)                                       235546
     D*ValidTrade****E DS                  EXTNAME(SEVTRADPD)                                 235546
     D*T_REC*********E                     EXTFLD(RECI)                                       235546
     D ValidDpmv     E DS                  EXTNAME(SEVDPMVPD) PREFIX(D_)                      235546
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Securities Trading ICD                                               235546
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)                                  235546
      ** External DS for Currencies                                                           235546
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  235546
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  PROJECTED ACCOUNT MOVEMENTS UPDATES                                                 235546
     D Z#BSTS        E DS                  EXTNAME(Z#BST)                                     235546
     D Z#ASTS        E DS                  EXTNAME(Z#AST)                                     235546
      **  TRADES FILE                                                                         235546
     D TRADSF        E DS                  EXTNAME(TRADSD)                                    235546
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D KSesn           S                   LIKE(TDSS)
     D KBrca           S                   LIKE(TDBA)
     D KCust           S                   LIKE(TCNR)
     D KDate           S                   LIKE(TDVD)
     D TDate           S                   LIKE(TDVD)
     D WKEUTX          S                   LIKE(EUTX)
     D WKEUTS          S                   LIKE(EUTS)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
      *                                                                                       236125
     D Command         S             48                                                       236125
      ** OVRDBF command for QCMDEXC to run                                                    236125
     D  Command1       S             23    INZ('OVRDBF FILE(ETCPOSTEMP)')                     236125
     D  Command2       S             25    INZ(' TOFILE(QTEMP/ETCPOSTEMP)')                   236125
      *                                                                                       236125
      ** Command length for QCMDEXC                                                           236125
     D CommandLen      S             15P 5 INZ(48)                                            236125
                                                                                              236125
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
     ISETLEDF                                                                                 235546
     I              RECI                        RECIS                                         235546
     I              CHTP                        CHTPS                                         235546
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
 
      *                                                                                       236125
      ** Override ETCPOSTEMP to version in QTEMP                                              236125
      *                                                                                       236125
     C                   EVAL      Command = Command1 + Command2                              236125
     C                   CALL      'QCMDEXC'                                                  236125
     C                   PARM                    Command                                      236125
     C                   PARM                    CommandLen                                   236125
     C                   OPEN      ETCPOSTEMP                                                 236125
      *                                                                                       236125
     C     *LOVAL        SETLL     ETCPOSTEMP
     C                   READ      ETCPOSTEMP                             60
     C*
     C     *IN60         DOWEQ     '0'
 
     C     PTDVD         IFNE      0                                                          235546
     C     TDATE         IFGT      PTDVD                                                      235546
     C     TDATE         OREQ      PTDVD                                                      235546
     C     WTMST         ANDGT     TMST                                                       235546
     C                   CLOSE     ETCPOSTEMP                                                 236125
     C                   SETON                                        LR                      235546
     C                   RETURN                                                               235546
     C                   ENDIF                                                                235546
     C                   ENDIF                                                                235546
                                                                                              235546
     C                   CALL      'SE006690'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      TTYPE         PType             1
     C                   PARM      TREF          PTRef             6
 
     C* Trade records
 
     C                   IF        PType = 'T'
 
     C                   IF        WOpen <> 'Y'
     C                   OPEN      TRADS
     C                   MOVEL     'Y'           WOpen             1
     C                   ENDIF
 
     C     PTRef         CHAIN     TRADS                              89
 
      ** CALCULATE EU TAX
 
     C*****************  CALLB     'SEVTRADTAX'                                               236125
     C                   CALL      'SEVTRADTAX'                                               236125
 
      * INPUTS
     C                   PARM                    RespMode
     C****************   PARM                    ValidTrade                                   235546
     C                   PARM                    TRADSF                                       235546
     C                   PARM                    Security
     C                   PARM      'E'           ProcFlag          1
 
      * OUTPUTS
 
     C                   PARM                    DDEUTX           16
     C                   PARM                    WKEUTX
     C                   PARM                    WKEUTS
     C*
     C* If tax amount is different, need to process the trade
     C*
     C     EUTX          IFNE      WKEUTX
 
     C                   MOVEL     TRADSF        Z#BSTS                                       235546
     C                   MOVEL     RECI          PREVREC           1                          235546
      ** CALCULATE EU TAX
 
     C*****************  CALLB     'SEVTRADTAX'                                               236125
     C                   CALL      'SEVTRADTAX'                                               236125
 
      * INPUTS
     C                   PARM                    RespMode
     C****************   PARM                    ValidTrade                                   235546
     C                   PARM                    TRADSF                                       235546
     C                   PARM                    Security
     C                   PARM      'C'           ProcFlag
 
      * OUTPUTS
 
     C                   PARM                    DDEUTX
     C                   PARM                    EUTX
     C                   PARM                    EUTS
     C
     C                   BITOFF    '01234567'    TACI
                                                                                              235546
      * CalcTrCVAL - Calculate Trade Countervalue                                             235546
                                                                                              235546
     C                   EXSR      CalcTrCVAL                                                 235546
     C*                                                                                       235546
     C*   ... update Trade settlement details                                                 235546
     C                   EXSR      WSETTL                                                     235546
     C                   Z-ADD     NOML          TOSN                                         235546
     C                   Z-ADD     *ZEROS        TDFS                                         235546
     C                   Z-ADD     *ZEROS        TNSN                                         235546
     C                   Z-ADD     *ZEROS        TNSP                                         235546
     C                   Z-ADD     *ZEROS        TVSN                                         235546
     C                   Z-ADD     *ZEROS        TVSP                                         235546
     C                   Z-ADD     *ZEROS        TDSN                                         235546
     C                   Z-ADD     *ZEROS        TDSP                                         235546
      *                                                                                       235546
      * Convert countervalue in nominal currency to settlement currency                       235546
      *                                                                                       235546
     C                   CALLB     'ZCONV'                                                    235546
     C                   PARM      TCTR          ZAMTCI           15 0                        235546
     C                   PARM      TDER          ZEXCH            13 8                        235546
     C                   PARM      TMDI          ZMD               1                          235546
     C                   PARM      NMCY          ZCCYI             3                          235546
     C                   PARM      SETC          ZCCYO             3                          235546
     C                   PARM      NomCcyDec     ZCDPI             1 0                        235546
     C                   PARM      SetCcyDec     ZCDPO             1 0                        235546
     C                   PARM      *ZERO         ZAMTCO           15 0                        235546
     C*                                                                                       235546
     C                   Z-ADD     ZAMTCO        TOSV                                         235546
     C*                                                                                       235546
     C     BVAUTH        IFEQ      '00'                                                       235546
     C*                                                                                       235546
     C                   MOVE      'A'           RECI                                         235546
     C*                                                                                       235546
     C                   ELSE                                                                 235546
     C     RECI          IFNE      'L'                                      1269              235546
     C                   MOVE      'P'           RECI                       1269              235546
     C                   ENDIF                                              1269              235546
     C                   ENDIF                                              1269              235546
     C*                                                                                       235546
     C                   MOVE      'Y'           TCFR
     C                   MOVE      'N'           PRPC
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVEL     'C'           CHTP
     C                   UPDATE    TRADSDF
     C                   ADD       1             W#TCNT            5 0                        235546
                                                                                              235546
      **  ... update on-line balances                                                         235546
                                                                                              235546
     C                   MOVEL     TRADSF        Z#ASTS                                       235546
     C                   EXSR      ONLNUP                                                     235546
     C*                                                                                       235546
     C     BVAUTH        IFNE      '00'                                                       235546
      **  ... write to trade authorisation file                                               235546
     C                   EXSR      WTRAUT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   DELETE    ETCPOSTMF                                                  235546
 
     C                   READ      ETCPOSTEMP                             60
     C                   ENDDO
      *                                                                                       235546
      *  Access SETTL audit record and update                                                 235546
      *                                                                                       235546
     C     W#SCNT        IFGT      0                                                          235546
     C                   OPEN      SETLEA                                                     235546
     C     1             CHAIN     SETLEAF                            99                      235546
     C     *IN99         IFEQ      '0'                                                        235546
     C                   ADD       W#SCNT        SDEL                                         235546
     C                   UPDATE    SETLEAF                                                    235546
     C                   ENDIF                                                                235546
     C                   ENDIF                                                                235546
      *                                                                                       235546
      *  Access TRADS audit record and update                                                 235546
     C     W#TCNT        IFGT      0                                                          235546
     C                   OPEN      TRADSA                                                     235546
     C     1             CHAIN     TRADSAF                            99                      235546
     C     *IN99         IFEQ      '0'                                                        235546
     C                   ADD       W#TCNT        TRDA                                         235546
     C                   UPDATE    TRADSAF                                                    235546
     C                   ENDIF                                                                235546
     C                   ENDIF                                                                235546
 
     C                   CLOSE     ETCPOSTEMP                                                 236125
     C                   SETON                                        LR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
     C                   PARM                    PType
     C************       PARM                    ValidTrade                                   235546
     C************       PARM                    ValidDpmv                                    235546
     C                   PARM                    Security
     C                   PARM                    PROT                                         235546
     C                   PARM                    Classif           1                          235546
     C                   PARM                    NCDec             1 0                        235546
     C                   PARM                    CSE023            1                          235546
     C                   PARM                    PTDVD             5 0                        235546
     C                   PARM                    PTMST            26                          235546
     C                   MOVE      Classif       CustClass                                    235546
     C                   Z-ADD     NCDec         NomCcyDec                                    235546
     C                   MOVE      PTMST         WTMST                                        235546
 
      ** Get Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   END
                                                                                              235546
      ** Get Securities Trading ICD                                                           235546
                                                                                              235546
     C                   CALL      'AOSTRDR0'                                                 235546
     C                   PARM      *BLANKS       @RTCD                                        235546
     C                   PARM      '*FIRST  '    @OPTN                                        235546
     C     SDSTRD        PARM      SDSTRD        DSSDY                                        235546
                                                                                              235546
      ** Database Error                                                                       235546
                                                                                              235546
     C     @RTCD         IFNE      *BLANKS                                                    235546
     C                   MOVEL     '*FIRST '     DBKEY                                        235546
     C                   MOVEL     'SDSTRDPD'    DBFILE                                       235546
     C                   EVAL      DBASE = 2                                                  235546
     C                   EXSR      *PSSR                                                      235546
     C                   END                                                                  235546
                                                                                              235546
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
     C*                                                                                       235546
     C* Define key list for file SETLE                                                        235546
     C*                                                                                       235546
     C     KLSETT        KLIST                                                                235546
     C                   KFLD                    SBCA                                         235546
     C                   KFLD                    STDR                                         235546
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  235546
      *****************************************************************                       235546
      *                                                               *                       235546
      *  WSETTL - Subroutine to Update Trade Settlement Details.      *                       235546
      *                                                               *                       235546
      *****************************************************************                       235546
      *                                                                                       235546
     C     WSETTL        BEGSR                                                                235546
     C*                                                                                       235546
     C                   IF        WOpen1 <> 'Y'                                              235546
     C                   OPEN      SETLE                                                      235546
     C                   MOVEL     'Y'           WOpen1            1                          235546
     C                   ENDIF                                                                235546
      *                                                                                       235546
      * Update all settlement records for the trade                                           235546
      *                                                                                       235546
     C                   MOVE      TDBA          SBCA                                         235546
     C                   MOVE      TDRF          STDR                                         235546
                                                                                              235546
     C     KLSETT        SETLL     SETLEDF                                                    235546
     C     KLSETT        READE     SETLEDF                                44                  235546
      *                                                                                       235546
      ** Do while records found                                                               235546
      *                                                                                       235546
     C     *IN44         DOWEQ     '0'                                                        235546
      *                                                                                       235546
      ** Live settlements only                                                                235546
      *                                                                                       235546
     C     RECIS         IFNE      'C'                                                        235546
     C     RECIS         ANDNE     '*'                                                        235546
                                                                                              235546
      ** Distinguish between historic and input today                                         235546
                                                                                              235546
     C     RECIS         IFEQ      'H'                                                        235546
     C                   MOVE      'X'           CHTPS                                        235546
     C                   ELSE                                                                 235546
     C                   MOVE      'D'           CHTPS                                        235546
     C                   END                                                                  235546
                                                                                              235546
     C     RECIS         IFEQ      'D'                                                        235546
     C                   MOVE      '*'           RECIS                                        235546
     C                   ELSE                                                                 235546
     C                   MOVE      'C'           RECIS                                        235546
     C                   END                                                                  235546
                                                                                              235546
     C                   Z-ADD     BJRDNB        LCD                                          235546
     C                   ADD       1             W#SCNT            5 0                        235546
     C                   UPDATE    SETLEDF                                                    235546
     C                   END                                                                  235546
                                                                                              235546
     C     KLSETT        READE     SETLEDF                                44                  235546
                                                                                              235546
     C                   END                                                                  235546
     C*                                                                                       235546
     C                   ENDSR                                                                235546
      *****************************************************************                       235546
      /EJECT                                                                                  235546
      *****************************************************************                       235546
      *                                                               *                       235546
      * CalcTrCVAL - Calculate Trade Countervalue                     *                       235546
      *                                                               *                       235546
      *****************************************************************                       235546
     C     CalcTrCVAL    BEGSR                                                                235546
                                                                                              235546
      *                                                                                       235546
      ** GET NOMINAL CURRENCY DECIMAL PLACES                                                  235546
      *                                                                                       235546
     C                   MOVE      SETC          @AJCD                                        235546
     C                   EXSR      AOCURR                                                     235546
     C                   Z-ADD     A6NBDP        SetCcyDec         1 0                        235546
      *                                                                                       235546
      ** If enhancement (CSE023) Treaty withholding tax exist, validate                       235546
      ** withholding tax customer details.                                                    235546
      *                                                                                       235546
     C                   MOVE      *BLANKS       PDRBW             2                          235546
     C                   IF        CSE023 = 'Y' AND CRTT <> *BLANKS                           235546
                                                                                              235546
     C                   IF        CustClass = 'S' or CustClass = 'D'                         235546
     C                   CALLB     'SEVWHTCDET'                                               235546
      *                                                                                       235546
      ** INPUTS                                                                               235546
      *                                                                                       235546
      ** Return Code                                                                          235546
      *                                                                                       235546
     C                   PARM                    RetCodeOut                                   235546
      *                                                                                       235546
      ** Trade type                                                                           235546
      *                                                                                       235546
     C                   PARM                    TDTP                                         235546
      *                                                                                       235546
      ** Security shortname                                                                   235546
      *                                                                                       235546
     C                   PARM                    SESN                                         235546
      *                                                                                       235546
      ** Customer number                                                                      235546
      *                                                                                       235546
     C                   PARM                    TCNR                                         235546
      *                                                                                       235546
      ** Investment type from PF/SECTYD                                                       235546
      *                                                                                       235546
     C                   PARM                    SITP                                         235546
      *                                                                                       235546
      ** Country of location from PF/SDCUSTPD                                                 235546
      *                                                                                       235546
     C                   PARM                    CustCOLC                                     235546
      *                                                                                       235546
      ** Country of treaty from PF/SECTYD                                                     235546
      *                                                                                       235546
     C                   PARM                    CRTT                                         235546
      *                                                                                       235546
      ** OUTPUTS                                                                              235546
      *                                                                                       235546
      ** Error fields/message IDs/message data (arrays) from/to caller                        235546
      *                                                                                       235546
     C                   PARM                    WFldNmXAr                                    235546
     C                   PARM                    WMsgIDXAr                                    235546
     C                   PARM                    WMsgDtXAr                                    235546
      *                                                                                       235546
      ** Default basket for backup withholding                                                235546
      *                                                                                       235546
     C                   PARM                    PDRBW             2                          235546
     C                   ENDIF
     C                   ENDIF
      *                                                                                       235546
      ** CALCULATE COUNTERVALUE                                                               235546
                                                                                              235546
     C                   CALLB     'SETCVALCAL'                                               235546
                                                                                              235546
      * INPUTS                                                                                235546
                                                                                              235546
      ** Trade details                                                                        235546
     C                   PARM                    TDTP                                         235546
     C                   PARM                    NOML                                         235546
     C                   PARM                    PRIC                                         235546
     C                   PARM                    RALL                                         235546
     C                   PARM                    ITRA                                         235546
     C                   PARM                    TBCA                                         235546
     C                   PARM                    TCCA                                         235546
     C                   PARM                    TCA1                                         235546
     C                   PARM                    TCA2                                         235546
     C                   PARM                    TCA3                                         235546
     C                   PARM                    TCA4                                         235546
     C                   PARM                    TCA5                                         235546
     C                   PARM                    TCA6                                         235546
     C                   PARM                    TCA7                                         235546
     C                   PARM                    TAXA                                         235546
     C                   PARM                    TDER                                         235546
     C                   PARM                    TMDI                                         235546
     C                   PARM                    SETC                                         235546
     C                   PARM                    TDVD                                         235546
                                                                                              235546
      ** Security details                                                                     235546
     C                   PARM                    PROT              1                          235546
     C                   PARM                    SPBS                                         235546
     C                   PARM                    CFCT                                         235546
     C                   PARM                    NMCY                                         235546
     C                   PARM                    NMDP                                         235546
     C                   PARM                    SESN                                         200459
                                                                                              235546
      ** Nominal Currency Details                                                             235546
      ** Settlement Currency Details                                                          235546
     C                   PARM                    NomCcyDts                                    235546
     C                   PARM                    SetCcyDts                                    235546
                                                                                              235546
      ** Customer classification                                                              235546
     C                   PARM                    CustClass         1                          235546
                                                                                              235546
      ** Country of treaty from PF/SECTYD                                                     235546
     C                   PARM                    CRTT                                         235546
                                                                                              235546
      ** Default basket for backup withholding                                                235546
     C                   PARM                    PDRBW                                        235546
                                                                                              235546
      ** Value date                                                                           235546
     C                   PARM                    TDVD                                         235546
      ** EU Tax                                                                               233881
     C                   PARM                    EUTX                                         233881
                                                                                              235546
      * OUTPUTS                                                                               235546
                                                                                              235546
      * Trade consideration in nominal currency                                               235546
      * Trade countervalue in nominal currency                                                235546
      * Withholding tax                                                                       235546
      * Trade countervalue in settlement currency in screen format                            235546
      * Withholding tax in screen format                                                      235546
     C                   PARM                    V_TCSR           15 0                        235546
     C                   PARM                    TCTR                                         235546
     C                   PARM                    WHTX                                         235546
     C                   PARM                    DDTCTR           21                          235546
     C                   PARM                    DDWTAX           21                          235546
                                                                                              235546
     C                   ENDSR                                                                235546
      *****************************************************************                       235546
      /EJECT                                                                                  235546
     C****************************************************************                        235546
     C*                                                              *                        235546
     C* AOCURR - ACCESS CURRENCY DETAILS                             *                        235546
     C*                                                              *                        235546
     C****************************************************************                        235546
     C     AOCURR        BEGSR                                                                235546
      *                                                                                       235546
      ** Access currency details using currency.                                              235546
      *                                                                                       235546
     C                   CALLB     'AOCURRR0'                                                 235546
     C                   PARM      '*MSG   '     @RTCD             7                          235546
     C                   PARM      '*KEY   '     @OPTN             7                          235546
     C                   PARM                    @AJCD             3                          235546
     C     SDCURR        PARM      SDCURR        DSSDY                                        235546
     C                   ENDSR                                                                235546
     C****************************************************************                        235546
      /EJECT                                                                                  235546
     C*****************************************************************                       235546
     C*                                                               *                       235546
     C* ONLNUP - ON-LINE UPDATES (MEMOS, PRONO, OLPOS, RSACMTPD)      *                       235546
     C*                                                               *                       235546
     C*****************************************************************                       235546
     C     ONLNUP        BEGSR                                                                235546
      *                                                                                       235546
     C                   CALL      'AOOUTRU0'                                                 235546
     C                   PARM      *BLANK        @RTCD                                        235546
     C                   PARM                    Z#BSTS                                       235546
     C                   PARM                    Z#ASTS                                       235546
     C     @RTCD         IFEQ      '*ERROR*'                                                  235546
     C                   MOVEL     *BLANK        DBKEY                                        235546
     C                   MOVEL     'AOOUTRU0'    DBFILE                         ************* 235546
     C                   MOVEL     '991'         DBASE                          * DBERR 991 * 235546
     C                   EXSR      SRERR                                        ************* 235546
     C                   END                                                                  235546
      *                                                                                       235546
     C                   ENDSR                                                                235546
     C*****************************************************************                       235546
      /EJECT                                                                                  235546
     C****************************************************************                        235546
     C*                                                              *                        235546
     C* SRERR - EXCEPTION ERRORS                                     *                        235546
     C*                                                              *                        235546
     C****************************************************************                        235546
     C     SRERR         BEGSR                                                                235546
     C*                                                                                       235546
     C                   MOVEL     '*ERROR '     @@RTCD            7                          235546
     C                   MOVEL     'SE06680'     DBPGM            10                          235546
     C                   MOVE      '1'           *INU7                                        235546
     C                   MOVE      '1'           *INU8                                        235546
     C                   MOVE      '1'           *INLR                                        235546
     C                   CLOSE     ETCPOSTEMP                                                 236125
     C                   DUMP                                                                 235546
     C*                                                                                       235546
     C**  TERMINATE THE PROGRAM                                                               235546
     C*                                                                                       235546
     C                   RETURN                                                               235546
     C*                                                                                       235546
     C                   ENDSR                                                                235546
     C****************************************************************                        235546
      /EJECT                                                                                  235546
      *****************************************************************                       235546
      *                                                               *                       235546
      *  WTRAUT - Subroutine to write a record to Trade authorisation file                    235546
      *                                                               *                       235546
      *****************************************************************                       235546
     C     WTRAUT        BEGSR                                                                235546
     C**                                                                                      235546
     C                   MOVE      'D'           RECI                                         235546
     C** Trade Ref.                                                                           235546
     C                   MOVE      TDRF          TRDRF                                        235546
     C**                                                                                      235546
     C** Last Action Type                                                                     235546
     C                   MOVE      'CH'          TATYP                                        235546
     C** User                                                                                 235546
     C                   MOVE      PSUser        TAUSR                                        235546
     C** Date                                                                                 235546
     C                   Z-ADD     BJRDNB        TADT                                         235546
     C** Time                                                                                 235546
     C                   TIME                    TATM                                         235546
     C**                                                                                      235546
     C* File TRAUTD should retain details of the trades previous RECI.                        235546
     C*                                                                                       235546
     C                   MOVE      PREVREC       TDRI                                         235546
     C*                                                                                       235546
     C                   WRITE     TRAUTDF                                                    235546
     C**                                                                                      235546
     C                   ENDSR                                                                235546
      *****************************************************************                       235546
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2005

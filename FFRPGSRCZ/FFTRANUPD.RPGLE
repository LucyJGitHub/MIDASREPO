     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Trades database updater')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFTRANUPD - Trades database updater                          *
      *                                                               *
      *  Function:  This module updates the database for both         *
      *             exchange-traded futures and options and currency  *
      *             over-the-counter trades.  It receives a record    *
      *             format containing the details of the appropriate  *
      *             trade.  Both formats are identical, though not    *
      *             all the fields apply to both.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      *  Prev Amend No. CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26920           Date 21Jan10
      *                 BUG26902           Date 20Jan10               *
      *                 CAP191             Date 26Nov09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247471             Date 01May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BG9042             Date 26Oct05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 28Oct03               *
      *                 CDE005             Date 19Aug03               *
      *                 215528             Date 21Mar03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 205075             Date 22Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166             Date 15Oct01               *
      *                 CSC011             Date 18Sep01               *
      *                 CAS002             Date 14Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 189015             Date 06Jun01               *
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 191169             Date 19Mar01               *
      *                 180497             DATE 26JUN00               *
      *                 CFF006             Date 28Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001             Date 12Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP013             Date 07Sep99               *
      *                 168345             Date 14Oct99               *
      * Midas DBA 3.01 Patch E ---------------------------------------*
      *                 171172             Date 23Nov99               *
      *                 170520             Date 19Nov99               *
      * Midas DBA 3.00 -----------------Base--------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 23Feb99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  BUG26920 - A serious Midas error has occurred" encountered   *
      *             when reversing OTCO transaction                   *
      *  BUG26902 - Amendment in EXTR is not working                  *
      *  CAP191 - MQ Enabling of FUND and EXTR APIs                   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247471 - Calculate Premium Amount based on Premium currency. *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BG9042 - FFC0760 failed due to attempt to write duplicate    *
      *           record in FF0355. Applied 219148 & 221374.          *
      *           Delete the close-out transaction generated by the   *
      *           system (negative transaction number) if it exists,  *
      *           when a transaction is deleted.                      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls.                *
      *  CDE005 - Data Export - Reservation ID                        *
      *  215528 - System is associating a wrong premium amount.       *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  205075 - Instrument should be sent before the transaction.   *
      *  CAP166 - API for Non-Currency OTC (no update processing for  *
      *           PF/INTYPD, also no processing for  PLATO fields)    *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  189015 - Use original margins from LF/TRSET to update        *
      *           total margin override.  Pattern fix after margin    *
      *           amendment processing by PGM/FF0020.                 *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  191169 - Only update Midas-Plato Spot rate if Midas-Plato    *
      *           is ON (decimal data error due to NTPLSPTP = blank)  *
      *  180497 - Validate Month and Year for Close Out reversal      *
      *  CFF006 - Fractional Ticks Processing.                        *
      *  CDE001 - Data Export - CCRM Limits                           *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the tran-
      *           saction and convert it into a  another Midas Deal . *
      *  171172 - Recompile over changed POSTNCD, POSTNKD in 163444.  *
      *  170520 - Recompile over changed TRANSD file                  *
      *  CPL002 - Midas-Plato Interface                               *
      *  CAP006 - Check for deal being updated by another workstation *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to APIs.                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Transaction details (audit) (opened under user control to ensure
      ** that the override applied in the caller takes effect).
     FTRANSA    UF   E             DISK    COMMIT  USROPN
 
      ** Book positions (opened under user control to ensure
      ** that the override applied in the caller takes effect).
     FPOSTNK    UF A E           K DISK    COMMIT  USROPN
 
      ** Customer/broker positions (opened under user control to ensure
      ** that the override applied in the caller takes effect).
     FPOSTNC    UF A E           K DISK    COMMIT  USROPN
 
      ** Projected nostro balances (opened under user control to ensure that
      ** the override applied in the caller takes effect).
     FPRONOM    UF A E           K DISK    COMMIT  USROPN
 
      ** Retail shadow balances (opened under user control to ensure that
      ** the override applied in the caller takes effect).
     FMEMOSM    UF A E           K DISK    COMMIT  USROPN
 
      ** FF Account movements (opened under user control to ensure that
      ** the override applied in the caller takes effect).
     FFFACMVD   O  A E           K DISK    COMMIT  USROPN
 
      ** Close out sets (opened under user control to ensure that
      ** the override applied in the caller takes effect).
     FCLOST     UF   E           K DISK    COMMIT  USROPN
     FCLOST2    IF   E           K DISK    INFSR(*pssr)  USROPN
 
     FPRONO     UF   E           K DISK    COMMIT                                             CFF007
     F                                     IGNORE(PRONOHHF)                                   CFF007
                                                                                              CFF007
      ** Transaction details (opened under user control to ensure that
      ** the override applied in the caller takes effect).
     FTRANS     UF A E           K DISK    COMMIT  USROPN
     F                                     INFDS(INFDS)
     F                                     INFSR(*pssr)
 
      ** Instrument types (detail)
     F***INTYPD*   O    E           K DISK    COMMIT PREFIX(IT)                               CAP166
     FINTYP1    UF A E           K DISK    COMMIT PREFIX(IT)                                  CAP166
     F                                     RENAME(INTYPDF : INTYPWRT)
     F                                     INFSR(*PSSR)                                       CAP166
 
      ** Instrument types (audit)
     FINTYPA    UF   E             DISK    COMMIT
 
      ** Confirmations/telex report file
     FCNFRPD    O    E           K DISK    COMMIT
 
      ** Customer/broker positions profit centre
     FFOPCC     UF A E           K DISK    COMMIT
     F                                     USROPN
     F                                     INFDS(INFD1)
     F                                     PREFIX(CC)
 
      ** Book positions profit centre
     FFOPCK     UF A E           K DISK    COMMIT
     F                                     USROPN
     F                                     INFDS(INFD2)
     F                                     PREFIX(CK)
 
      ** Market control details
     FMKCTL     IF   E           K DISK    PREFIX(MC)
 
      ** Settlement instructions (old versions required for amends)
      ** This file is opened and closed under user control to prevent
      ** clashes with the settlement instructions updater, and to ensure
      ** that the overrides applied in the caller take effect.
     FTRSET     IF   E           K DISK    PREFIX(OS) USROPN
                                                                                              CSD015
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD015
 
     FREADVCL1  UF A E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
      * MIDAS RE Settled Transaction Index file                                               CRE020
                                                                                              CRE020
     F/COPY WNCPYSRC,FFTRANDF01
      ** Instrument types extension for CAD                                                   CER001
     FFFITX2L0  UF A E           K DISK    COMMIT  USROPN                                     CER001
     F                                     INFSR(*pssr)                                       CER001
      ** Midas ER Luxembourg I.C.D. - physic. file                                            CER001
     FERLUICL1  IF   E           K DISK    INFSR(*pssr)  USROPN                               CER001
      ** Instrument types extension for IBLC 2002 Reporting                                   CER001
     FFFITX1L0  UF A E           K DISK    COMMIT  USROPN                                     CER001
     F                                     INFSR(*pssr)                                       CER001
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **------------------------------------------------------------------------CAP006 -------------
      ** The following /COPY line includes the definitions for error and        CAP006
      ** warning message arrays.                                                CAP006
     D/COPY ZACPYSRC,ERR_ARRAYS                                                 CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and #MsgData, and so require
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the named constants
      ** used specifically in FF.
     D/COPY FFCPYSRC,NAMEDCONST
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for FF-specific
      ** variables.
     D/COPY FFCPYSRC,DECLAREVAR
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
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                |
      ** ¦ Map variable names to indicators to allow use of names instead |
      ** ¦ of numbers; base the following data structure on a pointer to  |
      ** ¦ the indicator array.                                           |
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                |
     D  NoRcdFound            99     99
      ** ¦                                                                |
      ** ¦ Set the indicator array pointer                                |
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                |
      ** +----------------------------------------------------------------+
 
      ** Watch List Checking Details                                                          CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** Watch List Transaction Details                                                       CSD015
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
                                                                                              CSD015
      ** Compliance Watch Configuration Data File                                             CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
                                                                                              CSD015
      ** External DS for SAR Details                                                          CSD015
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD015
     D  WLCD         E                     EXTFLD(LCD)                                        CSD015
                                                                                              CSD015
      ** SD data area                                                                         CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
                                                                                              CSD015
      ** 24X7 status data area                                                                CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
                                                                                              CSD015
      ** Customer details                                                                     CSD015
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
                                                                                              CSD015
      ** Long data structure for access objects                                               CSD015
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD015
                                                                                              CSD015
      ** Compliance Engine XML Format String Parameter                                        CSD015
     D PXMLCode        S          30000A                                                      CSD015
                                                                                              CSD015
      ** Array Size Definition for Compliance Watch XML tags                                  CSD015
     D CWLArrSize      C                   CONST(6)                                           CSD015
                                                                                              CSD015
      ** XML Opening Tags for the Compliance Engine                                           CSD015
     D XOT             S             27A   DIM(CWLArrSize) PERRCD(1) CTDATA                   CSD015
                                                                                              CSD015
      ** XML Closing Tags for the Compliance Engine                                           CSD015
     D XCT             S             28A   DIM(CWLArrSize) PERRCD(1) CTDATA                   CSD015
                                                                                              CSD015
      ** Watch List Fields Array                                                              CSD015
     D WLF             S             18A   DIM(CWLArrSize)                                    CSD015
                                                                                              CSD015
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General ledger details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * Module details
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Layout for the RUNDAT data area
 
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
      ** Parameter data structures for enquiry update program AOOUTU0
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
     D Z#XSTS        E DS                  EXTNAME(Z#XST)
 
 
     D ValidTrans    E DS                  EXTNAME(FFVTRANPD) PREFIX(NT)
      ** Valid transaction data from the caller.
 
     D ValidSettl    E DS                  EXTNAME(FFVSETLPD) PREFIX(NS)
      ** Valid transaction settlement details from the caller.
 
     D InstType      E DS                  EXTNAME(INTYPD) PREFIX(IT)
      ** The instrument details from the caller
 
     D WInstType     E DS                  EXTNAME(INTYPD) PREFIX(WT)                         CAP166
      ** The instrument details from the caller                                               CAP166
                                                                                              CAP166
     D F_Trans       E DS                  EXTNAME(TRANSD)
      ** Transaction data on file TRANSD.
 
     D F_Settl       E DS                  EXTNAME(TRSETD) PREFIX(OS)
      ** Transaction settlement details on file TRSETD.
 
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** Nostro details
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
 
     D MarketDS      E DS                  EXTNAME(MARKT) PREFIX(MK)
      ** Market details DS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects
 
     D ChkTranFmt    E DS                  EXTNAME(TRANSD) PREFIX(CH)           CAP006
      ** Rename fields for Timestamp checking                                   CAP006
                                                                                CAP006
     D ChkTrstfil    E DS                  EXTNAME(TRSETD) PREFIX(C1)           CAP006
      ** Rename fields for Timestamp checking                                   CAP006
                                                                                CAP006
     D ChkInstTyp    E DS                  EXTNAME(INTYPD) PREFIX(C2)           CAP006
      ** Rename fields for Timestamp checking                                   CAP006
                                                                                CAP006
     D FFEXTR        E DS                  EXTNAME(FFEEXTRPD)                   CAP006
      * Error indicators                                                        CAP006
 
     D INFDS           DS
      ** For File Exception/Error Handling on LF/TRANS
     D  STATUS           *STATUS
 
     D INFD1           DS
      ** For File Exception/Error Handling on PF/FOPCCD
     D  STATS1           *STATUS
 
     D INFD2           DS
      ** For File Exception/Error Handling on PF/FOPCKD
     D  STATS2           *STATUS
 
     D CMTTXT          DS           367
      ** To provide Text on COMIT Entry in journal
     D  NATNZoned              1      5  0
     D  MDID                   6      7
     D  PGMN                   8     15
     D  WSIDX                 16     18
     D  MTIME                 19     24  0
     D  SACTNX                25     25
     D  USRIDX                26     35
     D  SAMK                  51     73
 
     D                 DS                                                       073714
      ** Data structure for breaking up/constructing instrument name
     D  InstName               1     20                                         073714
     D  ISTN01                 1      3                                         073714
     D  ISTN02                 4      4                                         073714
     D  ISTN03                 5      7                                         073714
     D  ISTN04                 9     15                                         073714
 
     D PSTNCK          DS            34                                         CFF004
      ** Key to LF/POSTNC
     D  KBRCAC                 1      3                                         S01117
     D**KCBCDC**               4      9  0                                                    CSD027
     D  KCBCDC                 4      9                                                       CSD027
     D  KISTTC                10     14
     D  KYRNOC                15     16  0
     D  KMTHNC                17     18  0
     D  KPCALC                19     19
     D  KSTRPC                20     34  8                                      CFF004
 
     D PSTNKK          DS            30                                         CFF004
      ** Key to LF/POSTNK
     D  KBRCAK                 1      3                                         S01117
     D  KBOKCK                 4      5
     D  KISTTK                 6     10
     D  KYRNOK                11     12  0
     D  KMTHNK                13     14  0
     D  KPCALK                15     15
     D  KSTRPK                16     30  8                                      CFF004
 
     D  PRONOK         DS             5                                                       CFF007
      ** Key to PRONO                                                                         CFF007
     D  CCYD                                                                                  CFF007
     D  FFNOSN                                                                                CFF007
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Timestamp for the transaction                                          CAP006
     D TimeStamp       S               Z                                        CAP006
                                                                                CAP006
      ** Flag to indicate that the FFxxxxRTV is not being called                CAP006
      ** as a linked enquiry.                                                   CAP006
     D LinkEnq         S              1A   INZ('N')                             CAP006
                                                                                CAP006
      ** Next available transaction number
     D NATN            S              5P 0
 
      ** Month number
     D Month           S              2S 0
 
      ** Current trading date
     D CTDATE          S                   LIKE(MCBUSD)
 
      ** Transaction value
     D FFTNVL          S             13P 0
 
      ** Strike Price                                                                         215528
     D FFSTRP          S                   LIKE(NTSTRP)                                       215528
 
      ** Numeric date field returned by ZDATE2
     D NumDate         S              6P 0
 
      ** Alpha date field returned by ZDATE2
     D AlphaDate       S              7A
 
      ** Work version of the ledger balance field
     D WLDBL           S                   LIKE(LDBL)
 
      ** Work version of the projectected nostro balance field
     D WPNBL           S                   LIKE(PNBL)
 
      ** Customer and broker nostro numbers
     D XXBNOS          S              2S 0
     D XXCNOS          S                   LIKE(XXBNOS)
 
      ** Customer, account code and sequence for passing to submodules
      ** and accessing MEMOS.
     D*MMCNUM***       S              6S 0                                                    CSD027
     D MMCNUM          S              6A                                                      CSD027
     D***MMACOD*         S              4S 0                                                  CGL029
     D MMACOD          S             10S 0                                                    CGL029
     D MMACSQ          S              2S 0
 
      ** Flags to indicate whether or not MEMOS and PRONO updates
      ** are required
     D FFMIND          S              1A
     D FFPIND          S              1A
 
      ** Flag to indicate whether the enhanced OTCs feature is on
     D CFF003          S              1A
 
      ** Old version of last change type field
     D OldChgType      S              1A
 
      ** Old version of last change date field
     D OldChgDate      S              5P 0
 
      ** Settlement type
     D SettleType      S              2S 0
 
      ** Settlement account
     D***SettleAcc       S             12A                                                    CGL029
     D SettleAcc       S             18A                                                      CGL029
 
      ** Dummy message ID and message file fields for use on the calls to       CAP006
      ** ZAMSGTOOPR                                                             CAP006
     D DummyMsgID      S                   LIKE(#MsgID)                         CAP006
     D DummyMsgF       S             10A                                        CAP006
                                                                                CAP006
      ** Flag for Fractional Ticks Enhancement                                                CFF006
     D CFF006          S              1A                                                      CFF006
                                                                                              CFF006
      ** CFF007 enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
                                                                                              CFF007
      ** Array of dates and balances retrieved from PRONOPN                                   CFF007
     D                 DS                                                                     CFF007
     D PNB                     1     40                                                       CFF007
     D ArrBalance              1     40P 0 DIM(5)                                             CFF007
     D PND                    41     55                                                       CFF007
     D Arr_Date               41     58P 0 DIM(6)                                             CFF007
     D SVProNosBal            61    100                                                       CFF007
     D OldArrDate             61    100P 0 DIM(5)                                             CFF007
                                                                                              CFF007
     D ZDAYNO                         5P 0                                                    CFF007
     D ZCCY                           3                                                       CFF007
     D ZLOC                           3                                                       CFF007
     D ZIND                           1                                                       CFF007
     D Z2                             2  0                                                    CFF007
     D Z                              2  0                                                    CFF007
                                                                                              CSC011
      ** Define work fields for CSC011                                                        CSC011
     D CSC011          S              1A                                                      CSC011
     D WDealNo         S              6A                                                      CSC011
                                                                                              CSC011
      ** Define work fields for CSD015                                                        CSD015
     D CSD015          S              1A   INZ('N')                                           CSD015
     D CCF001          S              1A   INZ('N')                                           CSD015
     D WFuncType       S              8A                                                      CSD015
     D WIdntifier      S             40A                                                      CSD015
     D WBranch         S              3A                                                      CSD015
     D WLChgFlg        S              1A   INZ('N')                                           CSD015
     D WLOKFlg         S              1A   INZ('N')                                           CSD015
     D WXMLPacket      S            300A                                                      CSD015
     D WData           S            145A                                                      CSD015
     D Ctr             S              2P 0                                                    CSD015
                                                                                              CSD015
      ** Parameters for SDCWLFMT                                                              CSD015
     D PWLIN1          S             35A                                                      CSD015
     D PWLIN2          S             35A                                                      CSD015
     D PWLIN3          S             35A                                                      CSD015
     D PWLIN4          S             35A                                                      CSD015
     D PWLIN5          S             35A                                                      CSD015
     D PWLIN6          S             35A                                                      CSD015
     D PWLOP2          S              6A                                                      CSD015
     D PWLCCY          S              3A                                                      CSD015
                                                                                              CSD015
      ** Parameter for ZACVTDATE                                                              CSD015
     D PInDate         S              5                                                       CSD015
     D POutDate        S               D                                                      CSD015
     D PCvtdDate       S             10                                                       CSD015
                                                                                              CSD015
      ** Parameter for ZACVTAMT                                                               CSD015
     D PAMFlot         S             18  3                                                    CSD015
     D PCurr           S              3A                                                      CSD015
     D PInAmt          S             15A                                                      CSD015
     D POutAmt         S             16A                                                      CSD015
     D PRtnCode        S              7A                                                      CSD015
     D WFPDT           S              8F                                                      CSD015
                                                                                              CSD015
      ** Parameter for AOCUSTR0                                                               CSD015
     D PCust           S             10A                                                      CSD015
     D PSTKey          S              7A                                                      CSD015
                                                                                              CSD015
      ** Parameter for AOWLCCR0                                                               CSD015
     D PFunc           S              8A                                                      CSD015
                                                                                              CSD015
      ** Switchable Features Flags                                                            CRE020
     D CRE020          S              1A   INZ('N')                                           CRE020
                                                                                              CRE020
      ** Key Fields                                                                           CRE020
     D KAdvcRef        S             30A                                                      CRE020
     D KAdvcPGM        S             10A                                                      CRE020
                                                                                              CRE020
      ** Parameters for System Values Access Object                                           CRE020
     D PRtCd           S              7A                                                      CRE020
     D PSValOTC        S             20A   INZ('OTCTransactions')                             CRE020
     D PSysVOTC        S            200A   INZ(' ')                                           CRE020
     D PSValNonOTC     S             20A   INZ('NoncurrencyOTCs')                             CRE020
     D PSysVNonOtc     S            200A   INZ(' ')                                           CRE020
     D PSValExTr       S             20A   INZ('ExchangeTradedInstr')                         CRE020
     D PSysVExTr       S            200A   INZ(' ')                                           CRE020
     D PSValOptB       S             20A   INZ(' ')                                           CRE020
     D PSysValB        S            200A   INZ(' ')                                           CRE020
                                                                                              CRE020
      ** Working Flag for amendment changes (OTC)                                             CRE020
     D WUpdAdvcFlg     S              1A   INZ('N')                                           CRE020
                                                                                              CRE020
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                |
      ** ¦ Initial processing is performed automatically: the *inzsr is   |
      ** ¦ executed at program activation.                                |
      ** ¦                                                                |
      ** +----------------------------------------------------------------+
 
      ** Open the files which are under user control
     C                   EXSR      OpenFiles
 
      ** Perform transaction-specific initial functions (*inzsr is only
      ** done first time through).
     C                   EXSR      TransInit
 
      ** Initialise 'COMIT' text
     C                   EXSR      ICOMIT
 
      ** Ensure transaction has not been updated by another workstation         CAP006
      ** - if so, bypass updating and return to calling program.                CAP006
     C                   IF        TransType = ExchTrade                        CAP006
      ** EXTR Processing                                                        CAP006
     C                   EXSR      CHKOTHUPDE                                   CAP006
     C                   ELSE                                                   CAP006
      ** OTCC Processing                                                        CAP006
     C                   EXSR      CHKOTHUPDO                                   CAP006
     C                   ENDIF                                                  CAP006
                                                                                CAP006
     C     ReturnCode    IFNE      *BLANKS                                      CAP006
     C                   GOTO      EXIT                                         CAP006
     C                   END                                                    CAP006
 
      ** Perform insert, amend or deletion processing, as appropriate
     C                   SELECT
 
     C                   WHEN      NTCHTP = 'I'
     C                   EXSR      UINSRT
     C
     C/COPY WNCPYSRC,FFTRANDC01
     C                   WHEN      NTCHTP = 'A'
     C                   EXSR      UTRANS
     C                   EXSR      OthUpdAmd
     C
     C                   WHEN      NTCHTP = 'D'
     C                   EXSR      UTRANS
     C                   EXSR      OthUpdDel
     C                   EXSR      DELCLOS                                                    BG9042
 
     C                   ENDSL
     C/COPY WNCPYSRC,FFTRANDC11
 
     C     EXIT          TAG                                                    CAP006
                                                                                CAP006
      ** Close the files which are under user control
     C                   EXSR      CloseFiles
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      ********************************************************************
      /EJECT
     C*****************************************************************         CAP006
     C*                                                               *         CAP006
     C* CHKOTHUPDE - Check for update by another workstation - EXTR   *         CAP006
     C*                                                               *         CAP006
     C*****************************************************************         CAP006
     C     CHKOTHUPDE    BEGSR                                                  CAP006
                                                                                CAP006
      ** Retrieve current transaction details                                   CAP006
                                                                                CAP006
     C                   MOVE      NTTNBR        MidasDlNum        6            CAP006
                                                                                CAP006
      ** Determine whether program is running interactively or in batch         CAP006
      **  ( 0 = batch   1 = interactive)                                        CAP006
      *                                                                         CAP006
     C                   CALLB     'ZARTVJOBA'                                  CAP006
     C                   PARM                    @Return           6            CAP006
     C                   PARM                    @type             1            CAP006
      *                                                                         CAP006
      * Allow access to transaction record by Front-Office ID when in Repair    168345
      * mode for inserts .Set  *RTV module  parameter  @@MODE  to   *FRONT      168345
      * if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~      168345
      * and             b) action code is Insert - 'I'                          168345
      * and             c) Front-Office Id is NOT Blank                         168345
      *                                                                         168345
     C     @Type         IFEQ      '1'                                          168345
     C     NTCHTP        ANDEQ     'I'                                          168345
     C     NTFRNT        ANDNE     *BLANKS                                      168345
      *                                                                         168345
     C                   MOVE      '*FRONT'      @@MODE                         168345
      *                                                                         168345
     C                   ELSE                                                   168345
      *                                                                         168345
      * Otherwise, if running in batch use Front-Office ID                      168345
      *            (if insert)                                                  CAP013
      *            else, use Midas Deal Number                                  168345
      *                                                                         168345
     C     @Type         IFEQ      '0'                                          CAP006
     C     NTCHTP        ANDEQ     'I'                                          CAP013
     C                   MOVE      '*FRONT'      @@MODE                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      *BLANKS       @@MODE                         CAP006
     C                   END                                                    CAP006
      *                                                                         168345
     C                   END                                                    168345
                                                                                CAP006
     C                   CALLB     'FFEXTRRTV'                                  CAP006
      * INPUTS                                                                  CAP006
      *                                                                         CAP006
      * Return code                                                             CAP006
     C                   PARM      *BLANK        ReturnCode                     CAP006
      *                                                                         CAP006
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP006
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP006
      *                                                                         CAP006
     C                   PARM                    @@MODE            6            CAP006
      *                                                                         CAP006
      * Response mode                                                           CAP006
     C                   PARM      ' '           @@RSMD            1            CAP006
      *                                                                         CAP006
      * Action Code                                                             CAP006
     C                   PARM                    NTCHTP                         CAP006
      *                                                                         CAP006
      * Front Office Transaction ID                                             CAP006
     C                   PARM      NTFRNT        FOTRID           20            CAP006
      *                                                                         CAP006
      * (Midas) Transaction Number                                              CAP006
     C                   PARM                    MidasDlNum                     CAP006
      *                                                                         CAP006
      * (Midas) Market (1A)                                                     CAP006
     C                   PARM                    MKMRKT                         CAP006
      ** Module being called as linked enquiry (1A)                             CAP006
     C                   PARM                    LinkEnq                        CAP006
      * Bank details ICD                                                        CAP006
     C                   PARM                    SDBANK                         CAP006
      * General Ledger ICD                                                      CAP006
     C                   PARM                    SDGELR                         CAP006
      * Multibranching indicator                                                CAP006
     C                   PARM                    BGMBIN                         CAP006
      * Outputs                                                                 CAP006
      * ~~~~~~~                                                                 CAP006
      ** Current transaction in file format                                     CAP006
     C                   PARM                    ChkTranFmt                     CAP006
      ** Current settlements in file format                                     CAP006
     C                   PARM                    ChkTrstFil                     CAP006
      ** Instrument types                                                       CAP006
     C                   PARM                    CHKInstTyp                     CAP006
      * OK - Action code (1A)                                                   CAP006
     C                   PARM      *BLANK        OKACTN                         CAP006
      * OK - Transaction Number (1A)                                            CAP006
     C                   PARM      *BLANK        OKTNBR                         CAP006
      * OK - Market (1A)                                                        CAP006
     C                   PARM                    OKMRKT            1            CAP006
      * Error fields/message IDs/message data (arrays) from/to caller           CAP006
     C                   PARM                    FldNameArr                     CAP006
     C                   PARM                    MsgIdArr                       CAP006
     C                   PARM                    MsgDtaArr                      CAP006
      * Array index (3P0) from/to caller                                        CAP006
     C                   PARM      *ZERO         Idx               3 0          CAP006        222373
      ******                                                                    CAP006        222373
      ******                                                                    CAP006        222373
      **OUTPUTS                                                                 CAP006        222373
      ******                                                                    CAP006        222373
      **(Current) deal in file format                                           CAP006        222373
     C*****              PARM                    ChkTranFmt                     CAP006        222373
      *****                                                                     CAP006        222373
      **OK*- Action code                                                        CAP006        222373
     C*****              PARM      *BLANK        OKACTN                         CAP006        222373
      ******                                                                    CAP006        222373
      **OK*- Deal Number                                                        CAP006        222373
     C*****              PARM      *BLANK        OKTNBR                         CAP006        222373
      *****                                                                     CAP006        222373
      **Error fields/message IDs/message data (arrays) from/to caller           CAP006        222373
     C*****              PARM      *BLANK        FldNameArr                     CAP006        222373
     C*****              PARM      *BLANK        MsgIdArr                       CAP006        222373
     C*****              PARM      *BLANK        MsgDtaArr                      CAP006        222373
      ******                                                                    CAP006        222373
      **Array index (3P0) from/to caller                                        CAP006        222373
     C*****              PARM      *ZERO         Idx               3 0          CAP006        222373
      *                                                                         CAP006
     C                   EXSR      CHKOTHERR                                    CAP006
      *                                                                         CAp006
     C                   ENDSR                                                  CAp006
     C*****************************************************************         CAP006
      /EJECT                                                                    CAP006
     C*****************************************************************         CAP006
     C*                                                               *         CAP006
     C* CHKOTHUPDO - Check for update by another workstation - OTCC   *         CAP006
     C*                                                               *         CAP006
     C*****************************************************************         CAP006
     C     CHKOTHUPDO    BEGSR                                                  CAP006
                                                                                CAP006
     C                   If        TransType <> 'OTCC'                                        CAP191
     C                   EVAL      ChkTranFmt = *BLANKS                                     BUG26902
     C                   LeaveSr                                                              CAP191
     C                   EndIf                                                                CAP191
                                                                                              CAP191
      ** Retrieve current transaction details                                   CAP006
                                                                                CAP006
     C                   MOVE      NTTNBR        MidasDlNum        6            CAP006
                                                                                CAP006
      ** Determine whether program is running interactively or in batch         CAP006
      **  ( 0 = batch   1 = interactive)                                        CAP006
      *                                                                         CAP006
     C                   CALLB     'ZARTVJOBA'                                  CAP006
     C                   PARM                    @Return           6            CAP006
     C                   PARM                    @type             1            CAP006
      *                                                                         CAP006
      * Allow access to transaction record by Front-Office ID when in Repair    168345
      * mode for inserts .Set  *RTV module  parameter  @@MODE  to   *FRONT      168345
      * if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~      168345
      * and             b) action code is Insert - 'I'                          168345
      * and             c) Front-Office Id is NOT Blank                         168345
      *                                                                         168345
     C     @Type         IFEQ      '1'                                          168345
     C     NTCHTP        ANDEQ     'I'                                          168345
     C     NTFRNT        ANDNE     *BLANKS                                      168345
      *                                                                         168345
     C                   MOVE      '*FRONT'      @@MODE                         168345
      *                                                                         168345
     C                   ELSE                                                   168345
      *                                                                         168345
      * Otherwise, if running in batch use Front-Office ID                      168345
      *            (if insert)                                                  CAP013
      *            else, use Midas Deal Number                                  168345
      *                                                                         168345
     C     @Type         IFEQ      '0'                                          CAP006
     C     NTCHTP        ANDEQ     'I'                                          CAP013
     C                   MOVE      '*FRONT'      @@MODE                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      *BLANKS       @@MODE                         CAP006
     C                   END                                                    CAP006
      *                                                                         168345
     C                   END                                                    168345
                                                                                CAP006
     C                   CALLB     'FFOTCCRTV'                                  CAP006
      * INPUTS                                                                  CAP006
      *                                                                         CAP006
      * Return code                                                             CAP006
     C                   PARM      *BLANK        ReturnCode                     CAP006
      *                                                                         CAP006
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP006
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP006
      *                                                                         CAP006
     C                   PARM                    @@MODE            6            CAP006
      *                                                                         CAP006
      * Response mode                                                           CAP006
     C                   PARM      ' '           @@RSMD            1            CAP006
      *                                                                         CAP006
      * Action Code                                                             CAP006
     C                   PARM                    NTCHTP                         CAP006
      *                                                                         CAP006
      * Front Office Transaction ID                                             CAP006
     C                   PARM      NTFRNT        FOTRID           20            CAP006
      *                                                                         CAP006
      * (Midas) Transaction Number                                              CAP006
     C                   PARM                    MidasDlNum                     CAP006
      ** Module being called as linked enquiry (1A)                             CAP006
     C                   PARM                    LinkEnq                        CAP006
      * Bank details ICD                                                        CAP006
     C                   PARM                    SDBANK                         CAP006
      * General Ledger ICD                                                      CAP006
     C                   PARM                    SDGELR                         CAP006
      * Multibranching indicator                                                CAP006
     C                   PARM                    BGMBIN                         CAP006
                                                                                              CAP166
      ** Transaction Type                                                                     CAP166
                                                                                              CAP166
     C                   PARM                    TransType                                    CAP166
                                                                                              CAP166
      * Outputs                                                                 CAP006
      * ~~~~~~~                                                                 CAP006
      ** Current transaction in file format                                     CAP006
     C                   PARM                    ChkTranFmt                     CAP006
      ** Current settlements in file format                                     CAP006
     C                   PARM                    ChkTrstFil                     CAP006
      ** Instrument types                                                       CAP006
     C                   PARM                    CHKInstTyp                     CAP006
      * OK - Action code (1A)                                                   CAP006
     C                   PARM      *BLANK        OKACTN                         CAP006
      * OK - Transaction Number (1A)                                            CAP006
     C                   PARM      *BLANK        OKTNBR                         CAP006
      * Error fields/message IDs/message data (arrays) from/to caller           CAP006
     C                   PARM                    FldNameArr                     CAP006
     C                   PARM                    MsgIdArr                       CAP006
     C                   PARM                    MsgDtaArr                      CAP006
      * Array index (3P0) from/to caller                                        CAP006
     C                   PARM      *ZERO         Idx               3 0          CAP006        222373
      *****                                                                     CAP006        222373
      *****                                                                     CAP006        222373
      **OUTPUTS                                                                 CAP006        222373
      *****                                                                     CAP006        222373
      **(Current) deal in file format                                           CAP006        222373
     C*****              PARM                    ChkTranFmt                     CAP006        222373
      *****                                                                     CAP006        222373
      **OK*- Action code                                                        CAP006        222373
     C*****              PARM      *BLANK        OKACTN                         CAP006        222373
      *****                                                                     CAP006        222373
      **OK*- Transaction Number                                                 CAP006        222373
     C*****              PARM      *BLANK        OKTNBR                         CAP006        222373
      *****                                                                     CAP006        222373
      **Error fields/message IDs/message data (arrays) from/to caller           CAP006        222373
     C*****              PARM      *BLANK        FldNameArr                     CAP006        222373
     C*****              PARM      *BLANK        MsgIdArr                       CAP006        222373
     C*****              PARM      *BLANK        MsgDtaArr                      CAP006        222373
      ******                                                                    CAP006        222373
      **Array index (3P0) from/to caller                                        CAP006        222373
     C*****              PARM      *ZERO         Idx               3 0          CAP006        222373
      *                                                                         CAP006
     C                   EXSR      CHKOTHERR                                    CAP006
      *                                                                         CAP006
     C                   ENDSR                                                  CAP006
     C*****************************************************************         CAP006
      /EJECT                                                                    CAP006
     C*****************************************************************         CAP006
     C*                                                               *         CAP006
     C* CHKOTHERR - Check retrieved details for errors                *         CAP006
     C*                                                               *         CAP006
     C*****************************************************************         CAP006
     C     CHKOTHERR     BEGSR                                                  CAP006
                                                                                CAP006
      ** Error if Timestamp is not the same (record has been changed            CAP006
      **  by another workstation)                                               CAP006
                                                                                CAP006
      ** Processing varies according to mode program is running in.             CAP006
      ** In interacive mode simply check whether the timestamp field            CAP006
      ** has been updated since the original deal was fetched by this           CAP006
      ** program.                                                               CAP006
      ** In batch (API input) check return parameters from Retrieve             CAP006
      ** module for errors, and send message to system operator.                CAP006
                                                                                CAP006
      ** Interactive mode:                                                      CAP006
                                                                                CAP006
     C     @TYPE         IFEQ      '1'                                          CAP006
                                                                                CAP006
     C     CHTMST        IFNE      NTTMST                                       CAP006
     C                   MOVEL     '*RECUPD'     ReturnCode                     CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      ** Batch mode:                                                            CAP006
     C                   ELSE                                                   CAP006
     C     OKACTN        IFEQ      'N'                                          CAP006
     C     OKTNBR        OREQ      'N'                                          CAP006
     C                   MOVEL     '*RECUPD'     ReturnCode                     CAP006
     C                   Z-ADD     1             C                 2 0          CAP006
                                                                                CAP006
     C     C             DOWLE     ArrayMax                                     CAP006
     C     FldNameArr(C) ANDNE     *BLANKS                                      CAP006
     C*******************MOVEL     *BLANKS       DBError          28     CAP006 CAP013
     C*******************MOVEL     MsgIDArr(C)   DBError                 CAP006 CAP013
     C                   CLEAR                   DBError         132            CAP013
     C                   EVAL      DBerror = 'Update error: ' + FOTRID          CAP013
     C                   CALLB     'ZAMSGTOOPR'                                 CAP006
     C                   PARM                    MsgSndRtn        10            CAP006
     C                   PARM                    DBError                        CAP006
     C                   PARM                    DummyMsgID                     CAP006
     C                   PARM                    DummyMsgF                      CAP006
     C                   ADD       1             C                              CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   ENDSR                                                  CAP006
     C*****************************************************************         CAP006
      /EJECT                                                                    CAP006
      ********************************************************************
      **                                                                 *
      **   UINSRT SR. -  Update  Insert Control                          *
      **   ~~~~~~~~~                                                     *
      **                                                                 *
      ********************************************************************
 
     C     UINSRT        BEGSR
 
                                                                                CAP006
      **   LF/TRANS main
      **   ~~~~~~~~~~~~~
     C**********         EXSR      WTRANS                                                     205075
 
     C/COPY WNCPYSRC,FFTRANDC02
      **   PF/INTYPD - for insertions of O.T.C.s
      **   ~~~~~~~~~
     C     *IN73         IFEQ      '0'
     C     MKMRKT        ANDEQ     '  '
     C*****NewOTCInst    ANDEQ     'Y'                                                        CAP166
 
     C                   IF        NewOTCInst = 'Y'                                           CAP166
     C                   EXSR      WINTYP
     C                   ELSE                                                                 CAP166
     C                   EXSR      SRUpdIntypd                                                CAP166
     C                   ENDIF                                                                CAP166
 
     C                   ENDIF
                                                                                              205075
     C                   EXSR      WTRANS                                                     205075
 
      **   If write failed:
     C                   IF        *in73
 
     C                   EXSR      ErrorExit
 
     C                   ENDIF
 
 
     C/COPY WNCPYSRC,FFTRANDC03
      **   PF/CNFRPD - to produce O.T.C. confirmations
      **   ~~~~~~~~~
      **   (if Enhanced OTC is present)
     C     MKMRKT        IFEQ      '  '
     C     CFF001        ANDEQ     'Y'
     C                   EXSR      WCNFRP
     C                   ENDIF
 
     C/COPY WNCPYSRC,FFTRANDC04
     C/SPACE 2
      **
      **   LF/MEMOSM + LF/PRONOM - only updated for Exch.Traded Options
      **   ~~~~~~~~~~~~~~~~~~~~~  with a Premium Up Front Ind. = 'Y'.
      **                          (Premiums are not paid on Futures)
 
     C     ITISPT        IFGE      4
     C     ITISPT        ANDNE     7
     C     ITISTI        ANDEQ     'N'
     C     ITPUPF        ANDEQ     'Y'
     C                   EXSR      INS_ACMOVE
     C                   ENDIF
 
      **   LF/FOPCC + LF/FOPCK - Positions Profit Centre
      **   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     BKPRCU        IFEQ      'Y'
     C                   EXSR      UAPRFC
     C                   END
 
     C     ITISTI        IFEQ      'Y'
     C                   EXSR      OTCACM
     C                   END
 
     C/SPACE 2
      **   LF/POSTN - Positions
      **   ~~~~~~~~~~~~~~~~~~~~
      **   - Calculate  Total Transaction Value
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFTVCL'
     C                   PARM                    FFTNVL
     C                   PARM                    NTNUCO
     C                   PARM                    NTCOPR
     C                   PARM                    ITTKDM
     C                   PARM                    ITMNPF
     C                   Z-ADD     FFTNVL        A_FFTNVL         13 0
 
 
      **   LF/POSTNC (apply)
      **   ~~~~~~~~~
      **   - Customer
     C*****NTCUSC        IFNE      0                                                          CSD027
     C     NTCUSC        IFNE      *BLANKS                                                    CSD027
     C                   EXSR      UPSTNC
     C                   END
      **   - Broker
     C*****NTBOCO        IFNE      0                                                          CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
     C                   EXSR      UPSTNB
     C                   END
 
      **   LF/POSTNK (apply)
      **   ~~~~~~~~~
      **   - Book
     C*****NTBOCO        IFNE      0                                                          CSD027
     C*****NTCUSC        ANDEQ     0                                                          CSD027
     C*****NTBOCO        OREQ      0                                                          CSD027
     C*****NTCUSC        ANDNE     0                                                          CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
     C     NTCUSC        ANDEQ     *BLANKS                                                    CSD027
     C     NTBOCO        OREQ      *BLANKS                                                    CSD027
     C     NTCUSC        ANDNE     *BLANKS                                                    CSD027
     C                   EXSR      UPSTNK
     C                   END
 
      **   PF/TRANSA
      **   ~~~~~~~~~
     C                   EXSR      UTRNSA
 
      ** If value date is greater than or equal to run date,
      ** call program FF1706
     C     CFF003        IFEQ      'Y'
 
     C                   IF        NTVALD > BJRDNB
 
     C                   CALL      'FF1706'
     C                   PARM                    F_Trans
     C                   PARM                    ValidSettl
     C                   PARM      *BLANK        @RTCD
     C                   PARM      *BLANK        @ERRF             8
     C                   PARM      *BLANK        @ERRK            29
     C                   PARM      'I'           @MODE             1
 
      ** Check for return code of '*ERROR'
     C     @RTCD         IFEQ      '*ERROR'
     C                   ROLBK
     C                   Z-ADD     28            DBASE                          *************
     C                   MOVEL     @ERRF         DBFILE                         *DB ERROR 28*
     C                   MOVEL     @ERRK         DBKEY                          *************
     C                   EXSR      ErrorExit
     C                   ENDIF
 
      ** Check for return code of 'NO DEAL' or 'NO TRAD'
     C     @RTCD         IFEQ      'NO DEAL'
     C     @RTCD         OREQ      'NO TRAD'
     C                   ROLBK
     C                   Z-ADD     29            DBASE                          *************
     C                   MOVEL     'FF1706'      DBFILE                         *DB ERROR 29*
     C                   MOVEL     @RTCD         DBKEY                          *************
     C                   EXSR      ErrorExit
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
     C/COPY WNCPYSRC,FFTRANDC05
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   WTRANS SR. -  Write record to  LF/TRANS                       *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
 
     C     WTRANS        BEGSR
 
      ** Copy the input data to the trade format
 
     C                   EVAL      F_Trans = ValidTrans
 
     C                   MOVE      'D'           RECI
 
     C                   MOVE      ' '           ULTT
     C                   Z-ADD     NUCO          NOCO
 
      ** If multibranching indicator is off or originating branches not
      ** used, set originating branch to booking branch.
     C     BGMBIN        IFEQ      'N'
     C     BKOBRU        OREQ      'N'
     C                   MOVE      BRCA          ORBR
     C                   ENDIF
 
     C                   Z-ADD     0             CLSR
     C                   MOVE      'N'           ECPI
     C                   MOVE      'N'           CBPI
     C                   Z-ADD     0             FCDA
     C                   MOVE      'N'           FCIN
 
      ** Move Run date into original entry date
     C                   Z-ADD     BJRDNB        ORED
 
     C                   Z-ADD     NATN          TNLU
 
      **   - Market Instrument
     C     MCMRKT        IFNE      '  '
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   Z-ADD     NUCO          NOBO
     C                   MOVE      'N'           FBIN
     C                   ELSE
     C                   Z-ADD     0             NOBO
     C                   MOVE      'Y'           FBIN
     C                   ENDIF
 
      **   - O.T.C.
     C                   ELSE
     C                   Z-ADD     0             NOBO
     C                   MOVE      'Y'           FBIN
 
      ** Update pay/receiver indicator
     C     CFF003        IFEQ      'Y'
     C                   MOVE      'N'           PYRC
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVE      'N'           ACNI
     C                   Z-ADD     0             MABK
     C                   Z-ADD     0             MACU
     C                   Z-ADD     0             CUUN
     C                   Z-ADD     0             UNPL
     C                   Z-ADD     0             UPLS
 
     C                   MOVE      *BLANKS       MHEX
 
     C                   EVAL      LCD = CTDATE
      *                                                                         CDE001
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                             AND TransType = OTCCurr                      CDE001
      *                                                                         CDE001
     C                   MOVEL     TNBR          T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF           26                          CGL029
     C                   PARM      'OTCC'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
     C                   ENDIF                                                  CDE001
 
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
     C                   EVAL      TMST  = TimeStamp                            CAP006
                                                                                              CFF007
      ** Set up value of value date with trade date                                           CFF007
     C     CFF007        IFEQ      'N'                                                        CFF007
     C     CFF001        ANDEQ     'N'                                                        CFF007
     C                   Z-ADD     TRSD          VALD                                         CFF007
     C                   ENDIF                                                                CFF007
                                                                                CAP006
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        FRNT = *BLANKS                                             CSC011
     C                   MOVE      TNBR          WDealNo                                      CSC011
     C                   EVAL      FRNT = 'MD' + WDealNo                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Perform compliance watch processing before writing new record                        CSD015
      ** if compliance watch is installed and entry watch list checking                       CSD015
      ** is set to 'Y'                                                                        CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
     C                   IF        CSC011 <> 'Y' OR                                           CSD015
     C                             CSC011 = 'Y' AND  S1MAIN = LIBR                            CSD015
                                                                                              CSD015
     C                   EVAL      WLOKFlg = 'N'                                              CSD015
     C                   MOVEA     *Blanks       WLF(1)                                       CSD015
     C                   MOVEL     NSBSLA        WLF(1)                                       CSD015
     C                   MOVEL     NSBFAO        WLF(2)                                       CSD015
     C                   MOVEL     NSBCPN        WLF(3)                                       CSD015
     C                   MOVEL     NSCSLA        WLF(4)                                       CSD015
     C                   MOVEL     NSCFAO        WLF(5)                                       CSD015
     C                   MOVEL     NSCCPN        WLF(6)                                       CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
     C                   DOU       Ctr > CWLArrSize                                           CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
     C                   EVAL      WLOKFlg = 'Y'                                              CSD015
     C                   LEAVE                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
     C                   ENDDO                                                                CSD015
                                                                                              CSD015
      ** Check if watch list fields are not blanks. See also if 24x7 is                       CSD015
      ** not installed, or if it is, it should be in the main system                          CSD015
                                                                                              CSD015
     C                   IF        WLOKFlg = 'Y'                                              CSD015
     C                   EXSR      SrWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **   Write new record
     C                   WRITE     TRANSDF                              73
 
 
      ** Update 'after' status of trade
 
     C                   MOVEL     F_Trans       Z#ASTS
 
      ** If Online Printing of Advice is on and is set in the system,                         CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND PSysVOTC = 'Y'                            CRE020
     C                             AND TransType = 'OTCC'                                     CRE020
     C                             OR CRE020 = 'Y' AND PSysVNonOTC = 'Y'                      CRE020
     C                             AND TransType = 'OTCO'                                     CRE020
     C                             OR CRE020 = 'Y' AND PSysVExTr = 'Y'                        CRE020
     C                             AND TransType = 'EXTR'                                     CRE020
                                                                                              CRE020
      ** Check if system value for the maintenance is on                                      CRE020
      ** if so, update READVCPD                                                               CRE020
                                                                                              CRE020
     C                   SELECT                                                               CRE020
                                                                                              CRE020
     C                   WHEN      TransType = 'OTCC'                                         CRE020
     C                   EVAL      RPRGMN = 'FFOTCCSIN'                                       CRE020
                                                                                              CRE020
     C                   WHEN      TransType = 'OTCO'                                         CRE020
     C                   EVAL      RPRGMN = 'FFOTCOSIN'                                       CRE020
                                                                                              CRE020
     C                   WHEN      TransType = 'EXTR'                                         CRE020
     C                   EVAL      RPRGMN = 'FFEXTRSIN'                                       CRE020
                                                                                              CRE020
     C                   ENDSL                                                                CRE020
                                                                                              CRE020
     C                   EXSR      SrUpdAdvice                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   ICOMIT SR. -  Initialise 'COMIT' text                         *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
 
     C     ICOMIT        BEGSR
 
      **   Access/Update  Next Available Transaction No.
     C                   Reset                   ReturnCode
     C                   CALLB     'ZTNLU1'
     C                   PARM                    ReturnCode
     C                   PARM                    NATN
 
     C                   EVAL      NATNZoned = NATN
 
      **   Setup standard information for COMIT text d.s.
     C                   MOVE      'FF'          MDID
     C                   MOVEL     PSProcPgm     PGMN
     C                   MOVE      PSJobName     WSIDX
     C                   TIME                    MTIME
     C                   MOVE      NTCHTP        SACTNX
     C                   MOVE      PSUser        USRIDX
     C                   EVAL      SAMK = NTCHTP + MKMRKT + MKMKTN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   WINTYP SR. -  Write record to  PF/INTYPD                      *
      **   ~~~~~~~~~~                                                    *
      **      Called From                  Calls                         *
      **       SR. UINSRT                                                *
      **                                                                 *
      ********************************************************************
 
     C     WINTYP        BEGSR
 
     C                   MOVE      'D'           ITRECI
     C                   MOVE      NTISTT        ITISTT
 
      ** Instrument Type
     C                   MOVEL     'Y'           ITISTI
 
      ** Instrument Name
     C                   MOVEL     ITOTHC        ISTN01
     C     ITISPT        IFEQ      5
     C                   MOVEL     '/'           ISTN02
     C                   MOVEL     ITCTCY        ISTN03
      *                                                                                       CFF006
      ** If CFF006 is installed, default value of the Fractional Ticks                        CFF006
      ** Processed field to 'N' only if the ticks denominator is 100.                         CFF006
     C                   IF        CFF006 = 'Y' AND ITTKDM = 100                              CFF006
     C                   EVAL      ITFRTK = 'N'                                               CFF006
     C                   ELSE                                                                 CFF006
     C                   EVAL      ITFRTK = ' '                                               CFF006
     C                   ENDIF                                                                CFF006
                                                                                              CFF006
     C                   END
 
      ** Instrument currency
     C                   EVAL      ITISCY = NTISCY
 
      ** Convert the final transaction date into a 7A format.
     C                   CALLB     'ZDATE2'
     C                   PARM                    ITFTDT
     C                   PARM                    BJDFIN
     C                   PARM                    NumDate
     C                   PARM                    AlphaDate
 
     C                   MOVEL     AlphaDate     ISTN04
 
     C                   EVAL      ITISTN = InstName
 
     C**********         Z-ADD     0             ITDBRK                                       CSD027
     C                   EVAL      ITDBRK = *BLANKS                                           CSD027
     C                   MOVE      *BLANK        ITBCPT
     C                   Z-ADD     0             ITBCMC
     C                   Z-ADD     0             ITBCMS
     C                   Z-ADD     0             ITBCGP
     C                   Z-ADD     0             ITBCGS
     C                   MOVE      *BLANK        ITCCPT
     C                   Z-ADD     0             ITCCMC
     C                   Z-ADD     0             ITCCMS
     C                   Z-ADD     0             ITCCGP
     C                   Z-ADD     0             ITCCGS
     C                   MOVE      *BLANK        ITSTRC
     C                   MOVE      *BLANK        ITPRRF
     C                   Z-ADD     0             ITULPD
     C                   MOVE      *BLANK        ITFTRF
     C                   MOVE      *BLANK        ITFTDF
     C                   MOVE      *BLANK        ITSEDF
     C                   MOVE      *BLANK        ITSPMF
     C                   Z-ADD     ITFTDT        ITSPDT
     C                   Z-ADD     0             ITTFPD
     C                   Z-ADD     0             ITFSPM
     C                   MOVE      *BLANK        ITISMQ
 
     C                   Z-ADD     BJRDNB        ITLCD
     C                   MOVE      'I'           ITCHTP
     C                   Z-ADD     NATN          ITTNLU
 
      ** If Midas-Plato Interface Installed, then don't initialise                            CAP166
      ** Plato fields                                                                         CAP166
                                                                                              CAP166
     C                   IF        BGN2ST = 'Y' and MKMRKT = ' '                              CAP166
                                                                                              CAP166
     C                   IF        ITISPT = 6                                                 CAP166
                                                                                              CAP166
     C                   EVAL      ITPLMIIT = *BLANKS                                         CAP166
     C                   EVAL      ITPLMITM = *BLANKS                                         CAP166
     C                   EVAL      ITPLMIMD = 0                                               CAP166
     C                   EVAL      ITPLMICP = 0                                               CAP166
     C                   EVAL      ITPLMICF = *BLANKS                                         CAP166
     C                   EVAL      ITPLMIPC = *BLANKS                                         CAP166
                                                                                              CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
     C                   ELSE                                                                 CAP166
                                                                                              CAP166
      **  Initialise Plato fields                                               CPL002
      *                                                                         CPL002
     C                   Z-ADD     0             ITPLMIMD                       CPL002
     C                   Z-ADD     0             ITPLMICP                       CPL002
     C                   MOVE      *BLANK        ITPLMIIT                       CPL002
     C                   MOVE      *BLANKS       ITPLMITM                       CPL002
     C                   MOVE      *BLANK        ITPLMICF                       CPL002
     C                   MOVE      *BLANK        ITPLMIPC                       CPL002
     C                   MOVE      *BLANK        ITPLMIVT                       CPL002
     C                   MOVE      *BLANK        ITPLMIPM                       CPL002
     C                   MOVE      *BLANKS       ITPLMIPG                       CPL002
     C                   MOVE      *BLANKS       ITPLMIRG                       CPL002
     C                   MOVE      *BLANKS       ITPLMICR                       CPL002
                                                                                CPL002
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
      **   Write new record
     C                   WRITE     INTYPWRT                             73
      *                                                                                       CER001
      ** When FF API for Luxembourg and IBC 2002 Reporting                                    CER001
      ** default an instrument in FF OTC transaction                                          CER001
      *                                                                                       CER001
     C     ULX605        IFEQ      'Y'                                                        CER001
     C     ULX043        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
      ** Convert Instrument Type to upper case                                                CER001
      *                                                                                       CER001
     C     NTISTT        CHAIN     FFITX1L0                                                   CER001
      *                                                                                       CER001
     C                   IF        %FOUND(FFITX1L0)                                           CER001
     C                   MOVE      'O'           INMRKT                                       CER001
     C                   UPDATE    INTYPDDL                                                   CER001
     C                   ELSE                                                                 CER001
     C                   MOVE      NTISTT        INISTT                                       CER001
     C                   MOVE      'O'           INMRKT                                       CER001
     C                   WRITE     INTYPDDL                                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ULX605        IFEQ      'Y'                                                        CER001
     C     ULX004        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
      ** Convert Instrument Type to upper case                                                CER001
      *                                                                                       CER001
     C     NTISTT        CHAIN     FFITX2L0                                                   CER001
      *                                                                                       CER001
     C     'LU'          CHAIN     ERLUICL1                           98                      CER001
     C     *IN98         IFEQ      *OFF                                                       CER001
     C                   MOVE      VPOPCM        CBOPCM                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        %FOUND(FFITX2L0)                                           CER001
     C                   UPDATE    INTYPDD6                                                   CER001
     C                   ELSE                                                                 CER001
     C                   MOVE      NTISTT        CBISTT                                       CER001
     C                   MOVE      *BLANKS       CBSESN                                       CER001
     C                   MOVE      *ZEROS        CBBBIX                                       CER001
     C                   WRITE     INTYPDD6                                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
     C     *IN73         IFEQ      '0'
     C     1             CHAIN     INTYPAF                            73
     C     *IN73         IFEQ      '0'
     C                   ADD       1             NINS
     C                   ADD       1             NORE
     C                   UPDATE    INTYPAF
     C                   END
     C                   END
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   WCNFRP SR. -  Write record to  PF/CNFRPD                      *
      **   ~~~~~~~~~~                                                    *
      **      Called From                  Calls                         *
      **       SR. UINSRT                                                *
      **                                                                 *
      ********************************************************************
 
     C     WCNFRP        BEGSR
 
     C                   MOVE      'D'           RECI
     C                   MOVE      NTBRCA        BRCA
     C                   MOVE      CUSC          CBCD
     C                   Z-ADD     0             YRNO
     C                   Z-ADD     0             MTHN
     C                   MOVE      TRSD          POCD
     C                   MOVE      '0'           PAYI
     C                   Z-ADD     0             REVI
     C                   Z-ADD     NUCO          TOCN
     C                   Z-ADD     NSCCMA        TOCM
     C                   Z-ADD     NSCCHA        TOCG
     C                   Z-ADD     NSPRMP        TOPR
     C                   MOVE      NSCSLT        SETP
     C                   MOVE      NSCSLA        SETA
     C                   MOVE      NSCFAO        FACO
     C                   MOVE      NSCCPN        CNOS
 
      **   Write new record
     C                   WRITE     CNFRPDF
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   WACMVD SR. -  Write record to PF/FFACMVD                      *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
 
     C     WACMVD        BEGSR
 
      **   Set up fields for output to PF/FFACMVD
 
      **   Branch Code
     C                   MOVE      FOBRCA        BRCA
 
      **   Customer Number
     C**********         Z-ADD     FOCNUM        CUSN                                         CSD027
     C                   EVAL      CUSN = FOCNUM                                              CSD027
 
      **   Account Code
     C                   Z-ADD     FOACOD        ACDE
 
      **   Account Sequence
     C                   Z-ADD     FOACSQ        ASNC
 
      **   Nostro Code
     C                   Z-ADD     FONOSN        NOSN
 
      **   Posting Date
     C                   Z-ADD     BJRDNB        PTDT
 
      **   Value Date
     C     CFF007        IFNE      'Y'                                                        CFF007
     C     CFF001        OREQ      'Y'                                                        CFF007
     C     MKMRKT        ANDEQ     *BLANKS                                                    CFF007
     C                   Z-ADD     NTVALD        VUDT                                         CFF007
     C                   ELSE                                                                 CFF007
     C                   Z-ADD     BJRDNB        VUDT
     C                   ENDIF                                                                CFF007
 
      **   Transaction Type
     C                   MOVE      NTTRTY        TRYP
 
      **   Narrative Code
     C                   Z-ADD     0             NRTC
 
      **   Narrative Description
     C                   MOVEL     ITISTN        NRTD
 
      **   Transaction Number
      **   Take the value in field screen otherwise when linked ref
      **   is specified, TNBR contains the linked ref (read TRANSIN)
     C                   MOVE      NTTNBR        TNMR
 
      **   Cheque Number
     C                   Z-ADD     *ZERO         CQNR
 
      **   Movement Amount
 
     C     Premium       IFGT      *ZERO
     C                   Z-ADD     Premium       MVAM
     C                   ELSE
     C                   Z-SUB     Premium       MVAM
     C                   END
 
      **   Debit or Credit
     C     MPIND         IFEQ      'M'
     C     LDBL          IFGE      WLDBL
     C                   Z-ADD     0             DORC
     C                   ELSE
     C                   Z-ADD     1             DORC
     C                   END
     C                   END
 
      **  If Nostro Code is Zero then Settlement Instructions are Blank
 
     C     MPIND         IFEQ      'P'
 
     C     NOSN          IFNE      0
 
     C                   MOVE      NOSN          FFNOSN
     C                   MOVE      FFNOSN        @NONB
     C                   MOVE      CCYD          @CYCD
 
      **  Access PF/SDNOSTPD for Customer Number, Account Code, Account
      **  Sequence
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUST             6
     C                   PARM                    @CYCD             3
     C**********         PARM      *BLANKS       @ACCD             4                          CGL029
     C                   PARM      *BLANKS       @ACCD            10                          CGL029
     C                   PARM      *BLANKS       @ACSN             2
     C                   PARM                    @NONB             2
     C                   PARM      *BLANKS       @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   MOVE      A7CUST        CUSN
     C                   MOVE      A7ACCD        ACDE
     C                   Z-ADD     A7ACSN        ASNC
 
     C                   ELSE
     C                   MOVE      *BLANKS       BRCA
     C**********         Z-ADD     0             CUSN                                         CSD027
     C                   EVAL      CUSN = *BLANKS                                             CSD027
     C                   Z-ADD     0             ACDE
     C                   Z-ADD     0             ASNC
     C                   ENDIF
 
     C     CFF007        IFNE      'Y'                                                        CFF007
     C     CFF001        OREQ      'Y'                                                        CFF007
     C     MKMRKT        ANDEQ     *BLANKS                                                    CFF007
                                                                                              CFF007
     C     PNBL          IFGE      WPNBL
     C                   Z-ADD     0             DORC
     C                   ELSE
     C                   Z-ADD     1             DORC
     C                   ENDIF
                                                                                              CFF007
     C                   ELSE                                                                 CFF007
     C     PNB           IFGE      SvProNosBal                                                CFF007
     C                   Z-ADD     0             DORC                                         CFF007
     C                   ELSE                                                                 CFF007
     C                   Z-ADD     1             DORC                                         CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF
 
      **  Write record to PF/FFACMVD
     C                   WRITE     FFACMVDF
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   UAPRFC SR. -  Update  LF/FOPCC + LF/FOPCK                     *
      **   ~~~~~~~~~~              Apply Profit Centre                   *
      **                                                                 *
      ********************************************************************
 
     C     UAPRFC        BEGSR
 
      **   - open LF/FOPCC and LF/FOPCK
     C     @FOPCC        IFNE      'Y'
     C                   OPEN      FOPCC
     C                   MOVE      'Y'           @FOPCC            1
     C                   END
 
     C     @FOPCK        IFNE      'Y'
     C                   OPEN      FOPCK
     C                   MOVE      'Y'           @FOPCK            1
     C                   END
 
      **   - set up key fields to chain LF/FOPCC for customer
      ** If a valid customer was entered
     C**********         IF        CUSC <> 0                                                  CSD027
     C                   IF        CUSC <> *BLANKS                                            CSD027
 
     C                   MOVE      NTBRCA        KBRCAO
     C                   MOVE      NTCUSC        KCBCDO
     C                   MOVE      NTISTT        KISTTO
 
     C     KFPCC         CHAIN     FOPCC                              71
 
      **   - set up fields for LF/FOPCC
     C                   MOVE      'D'           CCRECI
     C                   MOVE      NTBRCA        CCBRCA
     C                   MOVE      NTCUSC        CCCBCD
     C                   MOVE      NTISTT        CCISTT
 
     C                   IF        CAC003 = 'Y'
     C                   MOVE      NTTPRC        CCPCCB
     C                   ELSE
     C                   MOVE      NTPRFC        CCPCCB
     C                   ENDIF
 
     C                   MOVE      BJRDNB        CCLCD
     C                   MOVE      'I'           CCCHTP
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZTNLU1'
     C                   PARM                    ReturnCode
     C                   PARM                    CCTNLU
 
      **   - new position
     C     *IN71         IFEQ      '1'
     C                   WRITE     FOPCCDF                              69
     C                   END
 
      **   If WRITE fail :-
     C     *IN69         IFEQ      '1'
 
     C     STATS1        IFEQ      01021
      **   - 'Rec Upd by Another Wrkstn' - discontinue updates/Rollback
     C                   EXSR      ErrorExit
     C                   Z-ADD     0             STATS1            5 0
     C                   GOTO      UAPRE
     C                   ELSE
      **   - cancel program
     C                   EXSR      ErrorExit
     C                   END
 
     C                   END
     C                   END
 
      **   - set up key fields to chain LF/FOPCC for broker
     C**********         IF        BOCO <> 0                                                  CSD027
     C                   IF        BOCO <> *BLANKS                                            CSD027
 
     C                   MOVE      NTBRCA        KBRCAO
     C                   MOVE      NTBOCO        KCBCDO
     C                   MOVE      NTISTT        KISTTO
 
     C     KFPCC         CHAIN     FOPCC                              71
 
      **   - set up fields for LF/FOPCC
     C                   MOVE      'D'           CCRECI
     C                   MOVE      NTBRCA        CCBRCA
     C                   MOVE      NTBOCO        CCCBCD
     C                   MOVE      NTISTT        CCISTT
     C                   MOVE      NTPRFC        CCPCCB
 
     C                   MOVE      BJRDNB        CCLCD
     C                   MOVE      'I'           CCCHTP
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZTNLU1'
     C                   PARM                    ReturnCode
     C                   PARM                    CCTNLU
 
 
      **   - new position
 
     C     *IN71         IFEQ      '1'
     C                   WRITE     FOPCCDF                              69
     C                   END
 
      **   If WRITE fail :-
     C     *IN69         IFEQ      '1'
 
     C     STATS1        IFEQ      01021
      **   - 'Rec Upd by Another Wrkstn' - discontinue updates/Rollback
     C                   EXSR      ErrorExit
     C                   Z-ADD     0             STATS1            5 0
     C                   GOTO      UAPRE
     C                   ELSE
      **   - cancel program
     C                   EXSR      ErrorExit
     C                   END
 
     C                   END
 
     C                   END
 
      ** Write to FOPCKD for a New Book Position Profit Centre
      **   - set up fields for LF/FOPCK
     C                   MOVE      'D'           CKRECI
     C                   MOVE      NTBRCA        CKBRCA
     C                   MOVE      NTBOKC        CKBOKC
     C                   MOVE      NTISTT        CKISTT
 
     C                   IF        CAC003 = 'Y'
     C                   MOVE      NTBPRC        CKPCBK
     C                   ELSE
     C                   MOVE      NTPRFC        CKPCBK
     C                   ENDIF
 
     C                   MOVE      BJRDNB        CKLCD
     C                   MOVE      'I'           CKCHTP
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZTNLU1'
     C                   PARM                    ReturnCode
     C**********         PARM                    TNLU                                         CAP166
     C                   PARM                    CKTNLU                                       CAP166
 
      ** Check for existence of record...
     C                   EVAL      KBRCAF = NTBRCA
     C                   EVAL      KBOKCF = NTBOKC
     C                   EVAL      KISTTF = NTISTT
     C     KFPCK         CHAIN     FOPCK                              71                       FO002
 
      ** If no record, write new position
     C                   IF        *in71 = *on
     C                   WRITE     FOPCKDF                              69
     C                   ENDIF
 
      **   If WRITE fail :-
     C     *IN69         IFEQ      '1'
      **
     C     STATS2        IFEQ      01021
      **   - 'Rec Upd by Another Wrkstn' - discontinue updates/Rollback
     C                   EXSR      ErrorExit
     C                   Z-ADD     0             STATS2            5 0
     C                   GOTO      UAPRE
     C                   ELSE
 
      **   - cancel program
     C                   EXSR      ErrorExit
     C                   ENDIF
 
     C                   ENDIF
 
     C     UAPRE         ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   OTCACM SR. -  Updates enquiry files for OTC's                 *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
 
     C     OTCACM        BEGSR
 
      **   Call new program AOOUOTU0 to update enquiry files.
     C                   CALL      'AOOUOTU0'
     C                   PARM                    ##RTCD            7
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C                   PARM                    Z#XSTS
     C     ##RTCD        IFEQ      '*ERROR*'
     C     *LOCK         IN        LDA
     C                   Z-ADD     25            DBASE
     C                   MOVE      'AOOUOTU0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      ErrorExit
     C                   END
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   UPSTNC SR. -  Update  LF/POSTNC : Customer Position           *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
 
     C     UPSTNC        BEGSR
 
      **   Access  Customer Position off LF/POSTNC
     C                   MOVE      NTBRCA        KBRCAC
     C                   MOVE      NTCUSC        KCBCDC
     C                   MOVE      NTISTT        KISTTC
     C                   MOVE      NTYRNO        KYRNOC
     C                   MOVE      NTMTHN        KMTHNC
     C                   MOVE      NTPCAL        KPCALC
     C                   MOVE      NTSTRP        KSTRPC
 
     C     KPSTNC        CHAIN     POSTNC                             71
 
      **   1. Record must exist (if Action not an insert)
      **   2. Must be a live record if a record exists.
     C     *IN71         IFEQ      '1'
     C     NTCHTP        ANDNE     'I'
     C     *IN71         OREQ      '0'
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     18            DBASE
     C                   MOVE      'PSTNC'       DBFILE
     C                   MOVEL     PSTNCK        DBKEY
     C                   OUT       LDA
     C                   EXSR      ErrorExit
     C                   END
 
      **   1. 'Reverse out' updates due to the old trade  (not Insert)
 
     C     NTCHTP        IFNE      'I'
 
      **   - a) Broker involved
 
     C*****NTBOCO        IFNE      0                                                          CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
 
      **    - Purchase
     C     NTTRTY        IFEQ      'P'
     C     LOPC          SUB       X_NUCO        LOPC
     C     CUTV          SUB       R_FFTNVL      CUTV
      **    - Sale
     C                   ELSE
     C     SOPC          SUB       X_NUCO        SOPC
     C     CUTV          ADD       R_FFTNVL      CUTV
     C                   END
 
      **    Margin
     C*****NSCMAR        IFEQ      0                                                          189015
     C     OSCMAR        IFEQ      0                                                          189015
      **    - Purchase
     C     NTTRTY        IFEQ      'P'
     C     LOCO          SUB       X_NUCO        LOCO
      **    - Sale
     C                   ELSE
     C     SOCO          SUB       X_NUCO        SOCO
     C                   END
 
     C                   ELSE
 
     C*****NSCMAR        IFGT      0                                                          189015
     C*****TOTM          SUB       NSCMAR        TOTM                                         189015
     C     OSCMAR        IFGT      0                                                          189015
     C     TOTM          SUB       OSCMAR        TOTM                                         189015
     C                   END
 
     C                   END
 
      **   - b) Broker not involved
 
     C                   ELSE
 
      **    - Purchase
     C     NTTRTY        IFEQ      'P'
     C     SOPC          SUB       X_NUCO        SOPC
     C     CUTV          ADD       R_FFTNVL      CUTV
      **    - Sale
     C                   ELSE
     C     LOPC          SUB       X_NUCO        LOPC
     C     CUTV          SUB       R_FFTNVL      CUTV
     C                   END
 
      **    Margin
     C*****NSCMAR        IFEQ      0                                                          189015
     C     OSCMAR        IFEQ      0                                                          189015
      **    - Purchase
     C     NTTRTY        IFEQ      'P'
     C     SOCO          SUB       X_NUCO        SOCO
      **    - Sale
     C                   ELSE
     C     LOCO          SUB       X_NUCO        LOCO
     C                   END
 
     C                   ELSE
 
     C*****NSCMAR        IFGT      0                                                          189015
     C*****TOTM          SUB       NSCMAR        TOTM                                         189015
     C     OSCMAR        IFGT      0                                                          189015
     C     TOTM          SUB       OSCMAR        TOTM                                         189015
     C                   END
 
     C                   END
 
     C                   END
 
     C                   END
     C/SPACE 2
      **   2. 'Apply' updates due to the new trade  (not for Delete)
 
     C     NTCHTP        IFNE      'D'
 
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     0             LOPC
     C                   Z-ADD     0             SOPC
     C                   Z-ADD     0             CUTV
     C                   Z-ADD     0             TOTM
     C                   Z-ADD     0             LOCO
     C                   Z-ADD     0             SOCO
     C                   END
 
      **   - a) Broker involved
 
     C*****NTBOCO        IFNE      0                                                          CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
 
      **    - Purchase
     C     NTTRTY        IFEQ      'P'
     C     LOPC          ADD       NTNUCO        LOPC
     C     CUTV          ADD       A_FFTNVL      CUTV
      **    - Sale
     C                   ELSE
     C     SOPC          ADD       NTNUCO        SOPC
     C     CUTV          SUB       A_FFTNVL      CUTV
     C                   END
 
      **    Margin
     C     NSCMAR        IFEQ      0
      **    - Purchase
     C     NTTRTY        IFEQ      'P'
     C     LOCO          ADD       NTNUCO        LOCO
      **    - Sale
     C                   ELSE
     C     SOCO          ADD       NTNUCO        SOCO
     C                   END
 
     C                   ELSE
 
     C     NSCMAR        IFGT      0
     C     TOTM          ADD       NSCMAR        TOTM
     C                   END
 
     C                   END
 
      **   - b) Broker not involved
 
     C                   ELSE
 
      **    - Purchase
     C     NTTRTY        IFEQ      'P'
     C     SOPC          ADD       NTNUCO        SOPC
     C     CUTV          SUB       A_FFTNVL      CUTV
      **    - Sale
     C                   ELSE
     C     LOPC          ADD       NTNUCO        LOPC
     C     CUTV          ADD       A_FFTNVL      CUTV
     C                   END
 
      **    Margin
     C     NSCMAR        IFEQ      0
      **    - Purchase
     C     NTTRTY        IFEQ      'P'
     C     SOCO          ADD       NTNUCO        SOCO
      **    - Sale
     C                   ELSE
     C     LOCO          ADD       NTNUCO        LOCO
     C                   END
 
     C                   ELSE
 
     C     NSCMAR        IFGT      0
     C     TOTM          ADD       NSCMAR        TOTM
     C                   END
 
     C                   END
 
     C                   END
 
     C                   END
 
      **   Update  Customer's Instrument Position
 
     C     *IN71         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   MOVE      KBRCAC        BRCA
     C                   MOVE      KCBCDC        CBCD
     C                   MOVE      KISTTC        ISTT
     C                   MOVE      KYRNOC        YRNO
     C                   MOVE      KMTHNC        MTHN
     C                   MOVE      KPCALC        PCAL
     C                   Z-ADD     KSTRPC        STRP
     C                   MOVE      'N'           BRKI
 
     C                   Z-ADD     0             LSPO
     C                   Z-ADD     0             LSCP
     C                   Z-ADD     0             LSDA
     C                   Z-ADD     0             LTPO
     C                   Z-ADD     0             LTCP
     C                   Z-ADD     0             LTDA
     C                   Z-ADD     0             LOPE
     C                   Z-ADD     0             SOPE
     C                   Z-ADD     0             CUPL
     C                   Z-ADD     0             UPLP
     C                   Z-ADD     0             UPSP
     C                   Z-ADD     0             RPLD
     C                   Z-ADD     0             RPLY
     C                   Z-ADD     0             UPLY
     C                   Z-ADD     0             TOPL
     C                   Z-ADD     0             CMTM
     C                   Z-ADD     0             CHTM
     C                   Z-ADD     0             PMTM
     C                   Z-ADD     0             UPLM
     C                   Z-ADD     0             RPLM
 
     C                   WRITE     POSTNCDF
 
     C                   ELSE
 
     C                   UPDATE    POSTNCDF
 
     C                   END
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   UPSTNB SR. -  Update  LF/POSTNC : Broker Position             *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
 
     C     UPSTNB        BEGSR
 
      **   Access  Broker Position off LF/POSTNC
     C                   MOVE      NTBRCA        KBRCAC
     C                   MOVE      NTBOCO        KCBCDC
     C                   MOVE      NTISTT        KISTTC
     C                   MOVE      NTYRNO        KYRNOC
     C                   MOVE      NTMTHN        KMTHNC
     C                   MOVE      NTPCAL        KPCALC
     C                   MOVE      NTSTRP        KSTRPC
 
     C     KPSTNC        CHAIN     POSTNC                             71
 
      **   1. Record must exist (if Action not an insert)
      **   2. Must be a live record if a record exists.
     C     *IN71         IFEQ      '1'
     C     NTCHTP        ANDNE     'I'
     C     *IN71         OREQ      '0'
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     19            DBASE
     C                   MOVE      'PSTNC'       DBFILE
     C                   MOVEL     PSTNCK        DBKEY
     C                   OUT       LDA
     C                   EXSR      ErrorExit
     C                   END
 
      **   1. 'Reverse out' updates due to the old trade  (not Insert)
 
     C     NTCHTP        IFNE      'I'
 
      **    - Purchase
     C     NTTRTY        IFEQ      'P'
     C     SOPC          SUB       X_NUCO        SOPC
     C     CUTV          ADD       R_FFTNVL      CUTV
      **    - Sale
     C                   ELSE
     C     LOPC          SUB       X_NUCO        LOPC
     C     CUTV          SUB       R_FFTNVL      CUTV
     C                   END
 
      **    Margin
     C*****NSBMAR        IFEQ      0                                                          189015
     C     OSBMAR        IFEQ      0                                                          189015
      **    - Purchase
     C     NTTRTY        IFEQ      'P'
     C     SOCO          SUB       X_NUCO        SOCO
      **    - Sale
     C                   ELSE
     C     LOCO          SUB       X_NUCO        LOCO
     C                   END
 
     C                   ELSE
 
     C*****NSBMAR        IFGT      0                                                          189015
     C*****TOTM          SUB       NSBMAR        TOTM                                         189015
     C     OSBMAR        IFGT      0                                                          189015
     C     TOTM          SUB       OSBMAR        TOTM                                         189015
     C                   END
 
     C                   END
 
     C                   END
 
      **   2. 'Apply' updates due to the new trade  (not for Delete)
 
     C     NTCHTP        IFNE      'D'
 
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     0             LOPC
     C                   Z-ADD     0             SOPC
     C                   Z-ADD     0             CUTV
     C                   Z-ADD     0             TOTM
     C                   Z-ADD     0             LOCO
     C                   Z-ADD     0             SOCO
     C                   END
 
      **    - Purchase
     C     NTTRTY        IFEQ      'P'
     C     SOPC          ADD       NTNUCO        SOPC
     C     CUTV          SUB       A_FFTNVL      CUTV
      **    - Sale
     C                   ELSE
     C     LOPC          ADD       NTNUCO        LOPC
     C     CUTV          ADD       A_FFTNVL      CUTV
     C                   END
 
      **    Margin
     C     NSBMAR        IFEQ      0
      **    - Purchase
     C     NTTRTY        IFEQ      'P'
     C     SOCO          ADD       NTNUCO        SOCO
      **    - Sale
     C                   ELSE
     C     LOCO          ADD       NTNUCO        LOCO
     C                   END
 
     C                   ELSE
 
     C     NSBMAR        IFGT      0
     C     TOTM          ADD       NSBMAR        TOTM
     C                   END
 
     C                   END
 
     C                   END
 
      **   Update  Broker's Instrument Position
 
     C     *IN71         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   MOVE      KBRCAC        BRCA
     C                   MOVE      KCBCDC        CBCD
     C                   MOVE      KISTTC        ISTT
     C                   MOVE      KYRNOC        YRNO
     C                   MOVE      KMTHNC        MTHN
     C                   MOVE      KPCALC        PCAL
     C                   Z-ADD     KSTRPC        STRP
     C                   MOVE      'Y'           BRKI
 
     C                   Z-ADD     0             LSPO
     C                   Z-ADD     0             LSCP
     C                   Z-ADD     0             LSDA
     C                   Z-ADD     0             LTPO
     C                   Z-ADD     0             LTCP
     C                   Z-ADD     0             LTDA
     C                   Z-ADD     0             LOPE
     C                   Z-ADD     0             SOPE
     C                   Z-ADD     0             CUPL
     C                   Z-ADD     0             UPLP
     C                   Z-ADD     0             UPSP
     C                   Z-ADD     0             RPLD
     C                   Z-ADD     0             RPLY
     C                   Z-ADD     0             UPLY
     C                   Z-ADD     0             TOPL
     C                   Z-ADD     0             CMTM
     C                   Z-ADD     0             CHTM
     C                   Z-ADD     0             PMTM
     C                   Z-ADD     0             UPLM
     C                   Z-ADD     0             RPLM
 
     C                   WRITE     POSTNCDF
 
     C                   ELSE
 
     C                   UPDATE    POSTNCDF
 
     C                   END
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   UPSTNK SR. -  Update  LF/POSTNK  : Book Position              *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
 
     C     UPSTNK        BEGSR
 
      **   Access  Book Position off LF/POSTNK
     C                   MOVE      NTBRCA        KBRCAK
     C                   MOVE      NTBOKC        KBOKCK
     C                   MOVE      NTISTT        KISTTK
     C                   MOVE      NTYRNO        KYRNOK
     C                   MOVE      NTMTHN        KMTHNK
     C                   MOVE      NTPCAL        KPCALK
     C                   MOVE      NTSTRP        KSTRPK
 
     C     KPSTNK        CHAIN     POSTNK                             71
 
      **   1. Record must exist (if Action not an insert)
      **   2. Must be a live record if a record exists.
     C     *IN71         IFEQ      '1'
     C     NTCHTP        ANDNE     'I'
     C     *IN71         OREQ      '0'
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     20            DBASE
     C                   MOVE      'PSTNK'       DBFILE
     C                   MOVEL     PSTNKK        DBKEY
     C                   OUT       LDA
     C                   EXSR      ErrorExit
     C                   END
 
      **   1. 'Reverse out' updates due to the old trade  (not Insert)
 
     C     NTCHTP        IFNE      'I'
 
      **   - Purchase
     C     NTTRTY        IFEQ      'P'
     C     LOPC          SUB       X_NUCO        LOPC
     C     CUTV          SUB       R_FFTNVL      CUTV
      **   - Sale
     C                   ELSE
     C     SOPC          SUB       X_NUCO        SOPC
     C     CUTV          ADD       R_FFTNVL      CUTV
     C                   END
 
     C                   END
 
      **   2. 'Apply' updates due to the new trade  (not for Delete)
 
     C     NTCHTP        IFNE      'D'
 
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     0             LOPC
     C                   Z-ADD     0             SOPC
     C                   Z-ADD     0             CUTV
     C                   END
 
      **   - Purchase
     C     NTTRTY        IFEQ      'P'
     C     LOPC          ADD       NTNUCO        LOPC
     C     CUTV          ADD       A_FFTNVL      CUTV
      **   - Sale
     C                   ELSE
     C     SOPC          ADD       NTNUCO        SOPC
     C     CUTV          SUB       A_FFTNVL      CUTV
     C                   END
 
     C                   END
 
      **   Update  Book's Instrument Position
 
     C     *IN71         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   MOVE      KBRCAK        BRCA
     C                   MOVE      KBOKCK        BOKC
     C                   MOVE      KISTTK        ISTT
     C                   MOVE      KYRNOK        YRNO
     C                   MOVE      KMTHNK        MTHN
     C                   MOVE      KPCALK        PCAL
     C                   Z-ADD     KSTRPK        STRP
 
     C                   Z-ADD     0             LOPE
     C                   Z-ADD     0             SOPE
     C                   Z-ADD     0             POSM
     C                   Z-ADD     0             CUPL
     C                   Z-ADD     0             UPLP
     C                   Z-ADD     0             UPSP
     C                   Z-ADD     0             RPLD
     C                   Z-ADD     0             RPLY
     C                   Z-ADD     0             UPLY
     C                   Z-ADD     0             TOPL
     C                   Z-ADD     0             TOTP
     C                   Z-ADD     0             TOTS
     C                   Z-ADD     0             CMSP
     C                   Z-ADD     0             CMSR
     C                   Z-ADD     0             CPTM
     C                   Z-ADD     0             CRTM
     C                   Z-ADD     0             PMTM
     C                   Z-ADD     0             UPLM
     C                   Z-ADD     0             RPLM
 
     C                   WRITE     POSTNKDF
 
     C                   ELSE
 
     C                   UPDATE    POSTNKDF
 
     C                   END
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   UTRNSA SR. -  Update  Transaction Audit file                  *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
 
     C     UTRNSA        BEGSR
 
     C/COPY WNCPYSRC,FFTRANDC06
      **   Access audit record
 
     C     1             CHAIN     TRANSA                             71
 
      **   - not found
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     21            DBASE
     C                   MOVE      'TRANS'       DBFILE
     C                   MOVEL     'AUDIT'       DBKEY
     C                   OUT       LDA
     C                   EXSR      ErrorExit
     C                   END
 
      **   Insert
     C     NTCHTP        IFEQ      'I'
     C                   ADD       1             NORE
     C                   ADD       1             NINS
 
     C                   ELSE
      **   Amend
     C     NTCHTP        IFEQ      'A'
 
     C     OldChgDate    IFNE      CTDATE
     C                   ADD       1             NAMD
     C                   END
 
     C                   ELSE
      **   Delete
     C                   SUB       1             NORE
     C                   ADD       1             NDEL
 
     C     OldChgDate    IFEQ      CTDATE
 
     C     OldChgType    IFEQ      'I'
     C                   SUB       1             NINS
     C                   END
 
     C     OldChgType    IFEQ      'A'
     C                   SUB       1             NAMD
     C                   END
 
     C                   END
 
     C                   END
 
     C                   END
 
      **   Update audit record
 
     C                   UPDATE    TRANSAF
 
     C/COPY WNCPYSRC,FFTRANDC07
     C                   ENDSR
 
      ********************************************************************073714
      /EJECT                                                              073714
      ********************************************************************
      **                                                                 *
      **   UTRANS SR. -  Update  LF/TRANS main                           *
      **   ~~~~~~~~~~                                                    *
      ********************************************************************
 
     C     UTRANS        BEGSR
 
 
      **   Save Old Number of Open Contracts + Contract Price
 
     C                   Z-ADD     NUCO          X_NUCO            5 0
     C                   Z-ADD     COPR          X_COPR           15 8
 
     C                   Z-ADD     CTDATE        LCD
     C                   Z-ADD     NATN          TNLU
      **   Amend
     C     NTCHTP        IFEQ      'A'
 
      ** If End of centre processed is no and number of contracts equals
      ** number of open contracts:
     C                   IF        ECPI = 'N'
     C                             AND ( NUCO =  NOCO AND
     C**********                       ( BOCO = 0 OR  NUCO =  NOBO))                          CSD027
     C                                 ( BOCO = *BLANKS OR  NUCO =  NOBO))                    CSD027
 
     C                   Z-ADD     NTTRSD        TRSD
     C                   Z-ADD     NTVALD        VALD                                         CFF007
 
     C                   Z-ADD     NTNUCO        NUCO
     C                   Z-ADD     NTNUCO        NOCO
 
     C*****NTBOCO        IFNE      0                                                          CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
     C                   Z-ADD     NTNUCO        NOBO
     C                   ELSE
     C                   Z-ADD     0             NOBO
     C                   END
 
      ** Update outstanding open contracts on valid transaction
 
     C                   Z-ADD     NOCO          NTNOCO
     C                   Z-ADD     NOBO          NTNOBO
 
     C                   Z-ADD     NTCOPR        COPR
     C                   END
 
      ** Only update Midas-Plato Spot Price if Midas-Plato Interface is on      191169
      *                                                                         191169
     C                   IF        BGN2ST = 'Y'                                 191169
     C                   Z-ADD     NTPLSPTP      PLSPTP                         CPL002
     C                   END                                                    191169
     C                   MOVE      NTTNAR        TNAR
     C                   MOVE      NTTBLO        TBLO
     C                   MOVE      NTLNKR        LNKR
     C                   MOVE      NTCOVE        COVE                                         CFF007
     C                   MOVE      NTHETR        HETR                                         CFF007
     C                   MOVE      NTBLUP        BLUP                                         CFF007
 
     C     BGMBIN        IFEQ      'Y'
     C     BKOBRU        ANDEQ     'Y'
     C                   MOVE      NTORBR        ORBR
     C                   ELSE
 
      **   For MBIN = 'N' or BKOBRU = 'N', originating branch changes with
      **   booking branch.
 
     C                   MOVE      NTBRCA        ORBR
     C                   END
 
     C                   MOVE      NTPTFR        PTFR
 
      **   Delete (NTCHTP <> 'A')
     C                   ELSE
 
     C                   MOVE      '*'           RECI
 
     C                   END
 
 
      ** Set the change type to the action code (ie change type from the
      ** valid transaction file) unless the record was inserted today and
      ** the current transaction is an amend, in which case the change
      ** type should stay as 'I', to prevent problems with audit checking
      ** in the CoB.
     C                   IF        NOT ( NTCHTP = 'A' AND
     C                                   OldChgDate = CTDATE )
     C                   EVAL      CHTP = NTCHTP
     C                   ENDIF
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     NTFRNT        FRNT                           CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     NTAFRT        AFRT                           CAP013
      *                                                                         CDE001
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                             AND TransType = OTCCurr                      CDE001
      *                                                                         CDE001
     C                   MOVEL     TNBR          T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF           26                          CGL029
     C                   PARM      'OTCC'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
     C                   ENDIF                                                  CDE001
 
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
     C                   EVAL      TMST  = TimeStamp                            CAP006
 
      ** Set up value of value date with trade date                                           CFF007
     C     CFF007        IFEQ      'N'                                                        CFF007
     C     CFF001        ANDEQ     'N'                                                        CFF007
     C                   Z-ADD     TRSD          VALD                                         CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      ** Perform compliance watch processing before updating record                           CSD015
      ** if compliance watch is installed and entry watch list checking                       CSD015
      ** is set to 'Y'                                                                        CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
     C                   IF        CSC011 <> 'Y' OR                                           CSD015
     C                             CSC011 = 'Y' AND S1MAIN = LIBR                             CSD015
                                                                                              CSD015
     C                   EVAL      WLChgFlg = 'N'                                             CSD015
     C                   MOVEA     *Blanks       WLF(1)                                       CSD015
                                                                                              CSD015
     C                   MOVEL     'TRANSD'      WFuncType                                    CSD015
     C                   MOVEL     TNBR          WIdntifier                                   CSD015
     C                   MOVEL     BRCA          WBranch                                      CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
      ** For UNCONFIRMED statuses, send all watch list fields that are                        CSD015
      ** not blank                                                                            CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1)                                           CSD015
     C                   IF        W3UNCF = 'Y'                                               CSD015
     C                   EVAL      WLF(1) = NSBSLA                                            CSD015
     C                   EVAL      WLF(2) = NSBFAO                                            CSD015
     C                   EVAL      WLF(3) = NSBCPN                                            CSD015
     C                   EVAL      WLF(4) = NSCSLA                                            CSD015
     C                   EVAL      WLF(5) = NSCFAO                                            CSD015
     C                   EVAL      WLF(6) = NSCCPN                                            CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
     C                   DOU       Ctr > CWLArrSize                                           CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   LEAVE                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
     C                   ENDDO                                                                CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
      ** Otherwise, send only watch list fields that have changed and                         CSD015
      ** are not blank                                                                        CSD015
                                                                                              CSD015
     C                   IF        NSBSLA <> OSBSLA AND                                       CSD015
     C                             NSBSLA <> *Blanks                                          CSD015
     C                   EVAL      WLF(1) = NSBSLA                                            CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        NSBFAO <> OSBFAO AND                                       CSD015
     C                             NSBFAO <> *Blanks                                          CSD015
     C                   EVAL      WLF(2) = NSBFAO                                            CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        NSBCPN <> OSBCPN AND                                       CSD015
     C                             NSBCPN <> *Blanks                                          CSD015
     C                   EVAL      WLF(3) = NSBCPN                                            CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        NSCSLA <> OSCSLA AND                                       CSD015
     C                             NSCSLA <> *Blanks                                          CSD015
     C                   EVAL      WLF(4) = NSCSLA                                            CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        NSCFAO <> OSCFAO AND                                       CSD015
     C                             NSCFAO <> *Blanks                                          CSD015
     C                   EVAL      WLF(5) = NSCFAO                                            CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        NSCCPN <> OSCCPN AND                                       CSD015
     C                             NSCCPN <> *Blanks                                          CSD015
     C                   EVAL      WLF(6) = NSCCPN                                            CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** If conditions above are met, check if 24x7 is not installed.                         CSD015
      ** If it is installed, system should be in the main system                              CSD015
                                                                                              CSD015
     C                   IF        WLChgFlg = 'Y'                                             CSD015
     C                   EXSR      SrWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   UPDATE    TRANSDF
 
      ** If Online Printing of Advice is on and is set in the system,                         CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND PSysVOTC = 'Y'                          BUG26920
     C                             AND TransType = 'OTCC'                                   BUG26920
     C                             OR CRE020 = 'Y' AND PSysVNonOTC = 'Y'                    BUG26920
     C                             AND TransType = 'OTCO'                                   BUG26920
     C                             OR CRE020 = 'Y' AND PSysVExTr = 'Y'                      BUG26920
     C                             AND TransType = 'EXTR'                                   BUG26920
                                                                                            BUG26920
      ** Check for changes on the transaction (for Currency and Non                           CRE020
      ** Currency OTCs projections). Then,                                                    CRE020
                                                                                              CRE020
     C                   IF        NTNUCO <> CHNUCO OR NTCOPR <> CHCOPR                       CRE020
     C                             OR NTTRSD <> CHTRSD OR NSCSLT <> OSCSLT                    CRE020
     C                             OR NSCSLA <> OSCSLA OR NSBRSC <> OSBRSC                    CRE020
     C                             OR NSCCPN <> OSCCPN OR NSCFAO <> OSCFAO                    CRE020
     C                   EVAL      WUpdAdvcFlg = 'Y'                                          CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ***Check*if*system*value*for*the*maintenance*is*on******************           CRE020 BUG26920
      ***if*so,*update*READVCPD*******************************************           CRE020 BUG26920
      **********                                                                     CRE020 BUG26920
     C**********         IF        CRE020 = 'Y' AND PSysVOTC = 'Y'                   CRE020 BUG26920
     C**********                   AND TransType = 'OTCC'                            CRE020 BUG26920
     C**********                   OR CRE020 = 'Y' AND PSysVNonOTC = 'Y'             CRE020 BUG26920
     C**********                   AND TransType = 'OTCO'                            CRE020 BUG26920
     C**********                   OR CRE020 = 'Y' AND PSysVExTr = 'Y'               CRE020 BUG26920
     C**********                   AND TransType = 'EXTR'                            CRE020 BUG26920
                                                                                              CRE020
      ** Check if system value for the maintenance is on                                      CRE020
      ** if so, update READVCPD                                                               CRE020
                                                                                              CRE020
     C                   SELECT                                                               CRE020
                                                                                              CRE020
     C                   WHEN      TransType = 'OTCC'                                         CRE020
     C                   EVAL      RPRGMN = 'FFOTCCSIN'                                       CRE020
                                                                                              CRE020
     C                   WHEN      TransType = 'OTCO'                                         CRE020
     C                   EVAL      RPRGMN = 'FFOTCOSIN'                                       CRE020
                                                                                              CRE020
     C                   WHEN      TransType = 'EXTR'                                         CRE020
     C                   EVAL      RPRGMN = 'FFEXTRSIN'                                       CRE020
                                                                                              CRE020
     C                   ENDSL                                                                CRE020
                                                                                              CRE020
     C                   EXSR      SrUpdAdvice                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
 
     C/COPY WNCPYSRC,FFTRANDC08
      ** Update 'after' status of trade
 
     C                   MOVEL     F_Trans       Z#ASTS
 
      ** If Midas-Plato Interface Installed, then set up fields introduced                    CAP166
      ** by this module                                                                       CAP166
                                                                                              CAP166
     C                   IF        BGN2ST = 'Y' and MKMRKT = ' '                              CAP166
     C                   EXSR      SRUpdIntypd                                                CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   OthUpdAmd. -  Other updates for amends                        *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
 
     C     OthUpdAmd     BEGSR
 
     C/COPY WNCPYSRC,FFTRANDC09
      **   PF/CNFRPD - to produce O.T.C. confirmations
      **   ~~~~~~~~~
      **   (if Enhanced OTC is present)
     C     MKMRKT        IFEQ      '  '
     C     CFF001        ANDEQ     'Y'
 
      **   If premium payable or settlement instructions have changed
 
     C     NSPRMP        IFNE      OSPRMP
     C     NSCSLT        ORNE      OSCSLT
     C     NSCSLA        ORNE      OSCSLA
     C     NSBRSC        ORNE      OSBRSC
     C                   EXSR      WCNFRP
     C                   END
     C                   END
 
     C/COPY WNCPYSRC,FFTRANDC10
      **
      **   LF/MEMOSM + LF/PRONOM - only updated for Exch Traded Options
      **   ~~~~~~~~~~~~~~~~~~~~~  with a Premium Up Front ind. = 'Y'.
      **                          (Premiums are not paid on Futures)
      **                          and if EOC processed ind. = 'N'
 
     C     ITISPT        IFGE      4
     C     ITISPT        ANDNE     7
     C     ITISTI        ANDEQ     'N'
     C     ITPUPF        ANDEQ     'Y'
     C     NTECPI        ANDEQ     'N'
     C                   EXSR      AMD_ACMOVE
     C                   END
 
      **   LF/FOPCC + LF/FOPCK - Positions Profit Centre
      **   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     BKPRCU        IFEQ      'Y'
     C     BKPRCA        ANDEQ     'Y'
     C     BXTBRC        ANDEQ     'N'
     C                   EXSR      UAPRFC
     C                   END
 
     C     ITISTI        IFEQ      'Y'
     C                   EXSR      OTCACM
     C                   END
 
 
      **   LF/POSTN - Positions
      **   ~~~~~~~~~~~~~~~~~~~~
      **   - Calculate  Total Transaction Value
      **    - old
     C                   RESET                   ReturnCode
     C                   CALLB     'FFTVCL'
     C                   PARM                    FFTNVL
     C                   PARM                    X_NUCO
     C                   PARM                    X_COPR
     C                   PARM                    ITTKDM
     C                   PARM                    ITMNPF
     C                   Z-ADD     FFTNVL        R_FFTNVL         13 0
 
      **    - new
     C                   RESET                   ReturnCode
     C                   CALLB     'FFTVCL'
     C                   PARM                    FFTNVL
     C                   PARM                    NTNUCO
     C                   PARM                    NTCOPR
     C                   PARM                    ITTKDM
     C                   PARM                    ITMNPF
     C                   Z-ADD     FFTNVL        A_FFTNVL         13 0
 
      **   LF/POSTNC
      **   ~~~~~~~~~
      **   - Customer
     C*****NTCUSC        IFNE      0                                                          CSD027
     C     NTCUSC        IFNE      *BLANKS                                                    CSD027
     C                   EXSR      UPSTNC
     C                   END
      **   - Broker
     C*****NTBOCO        IFNE      0                                                          CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
     C                   EXSR      UPSTNB
     C                   END
 
      **   LF/POSTNK
      **   ~~~~~~~~~
      **   - Book
     C*****NTBOCO        IFNE      0                                                          CSD027
     C*****NTCUSC        ANDEQ     0                                                          CSD027
     C*****NTBOCO        OREQ      0                                                          CSD027
     C*****NTCUSC        ANDNE     0                                                          CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
     C     NTCUSC        ANDEQ     *BLANKS                                                    CSD027
     C     NTBOCO        OREQ      *BLANKS                                                    CSD027
     C     NTCUSC        ANDNE     *BLANKS                                                    CSD027
     C                   EXSR      UPSTNK
     C                   END
 
      **   PF/TRANSA
      **   ~~~~~~~~~
     C                   EXSR      UTRNSA
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   OthUpdDel. -  Other updates for deletes                       *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
 
     C     OthUpdDel     BEGSR
 
      **   LF/CLOST
      **   ~~~~~~~~
      ** If number of contracts <> number of open contracts
     C                   IF        NTNUCO <> NTNOBO
     C                   EXSR      UCLOST
     C                   ENDIF
 
      **   LF/MEMOSM + LF/PRONOM - only updated for Exch Traded Options
      **   ~~~~~~~~~~~~~~~~~~~~~  with a Premium Up Front ind. = 'Y'.
      **                          (Premiums are not paid on Futures)
     C     ITISPT        IFGE      4
     C     ITISPT        ANDNE     7
     C     ITISTI        ANDEQ     'N'
     C     ITPUPF        ANDEQ     'Y'
     C                   EXSR      DEL_ACMOVE
     C                   END
 
     C     ITISTI        IFEQ      'Y'
     C                   EXSR      OTCACM
     C                   END
 
     C/SPACE 2
      **   LF/POSTN - Positions
      **   ~~~~~~~~~~~~~~~~~~~~
      **   - Calculate  Total Transaction Value (Customer/Book)
     C                   RESET                   ReturnCode
     C                   CALLB     'FFTVCL'
     C                   PARM                    FFTNVL
     C                   PARM                    NUCO
     C                   PARM                    COPR
     C                   PARM                    ITTKDM
     C                   PARM                    ITMNPF
     C                   Z-ADD     FFTNVL        R_FFTNVL         13 0
 
 
      **   LF/POSTNC (Reverse)
      **   ~~~~~~~~~
      **   - Customer
     C*****NTCUSC        IFNE      0                                                          CSD027
     C     NTCUSC        IFNE      *BLANKS                                                    CSD027
     C                   EXSR      UPSTNC
     C                   END
      **   - Broker
     C*****NTBOCO        IFNE      0                                                          CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
     C                   EXSR      UPSTNB
     C                   END
 
      **   LF/POSTNK (Reverse)
      **   ~~~~~~~~~
      **   - Book
     C*****NTBOCO        IFNE      0                                                          CSD027
     C*****NTCUSC        ANDEQ     0                                                          CSD027
     C*****NTBOCO        OREQ      0                                                          CSD027
     C*****NTCUSC        ANDNE     0                                                          CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
     C     NTCUSC        ANDEQ     *BLANKS                                                    CSD027
     C     NTBOCO        OREQ      *BLANKS                                                    CSD027
     C     NTCUSC        ANDNE     *BLANKS                                                    CSD027
     C                   EXSR      UPSTNK
     C                   END
 
      **   PF/TRANSA
      **   ~~~~~~~~~
     C                   EXSR      UTRNSA
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT                                                             *
      ********************************************************************
      **                                                                 *
      **   INS_ACMOVE -  Account Movements Update on INSERT              *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
     C     INS_ACMOVE    BEGSR
 
      **
      **   LF/MEMOSM (Apply)
      **   ~~~~~~~~~
      **   - CUSTOMER
      **     --------
 
     C*****NTCUSC        IFNE      *ZERO                                                      CSD027
     C     NTCUSC        IFNE      *BLANKS                                                    CSD027
 
      ** Set up inputs for ZAGETSETAC - customer settlement details
 
     C                   EVAL      MMCNUM     = NTCUSC
     C                   EVAL      MMCURR     = NTISCY
 
     C                   EVAL      MMBRCA     = NSCBID
     C                   EVAL      SettleType = NSCSLT
     C                   EVAL      SettleAcc  = NSCSLA
 
      ** Convert the settlement details into account number fields
 
     C                   EXSR      GETSETAC
 
      ** Set customer memos and prono update indicators
 
     C                   MOVEL     FFMIND        CustMIND          1
     C                   MOVEL     FFPIND        CustPIND          1
 
      ** Do customer memos updates (if required)
 
     C     CustMIND      IFEQ      'Y'
 
      ** Premium Payable
 
     C**********         IF        NTBOCO <> 0                                                CSD027
     C                   IF        NTBOCO <> *BLANKS                                          CSD027
     C                   Z-SUB     NSPRMP        Premium          13 0
     C                   ELSE
     C                   Z-ADD     NSPRMP        Premium
     C                   ENDIF
 
      **     Set Reverse/Apply Indicator to 'A' and MEMOSM/PRONOM
      **     Update Indicator to 'M' (used in SR. WACMVD)
 
     C                   MOVE      'A'           RAIND             1
     C                   MOVE      'M'           MPIND             1
 
     C                   EXSR      UMEMOS
 
      **     SET UP A/C ID FOR UPDATE OF PF/FFACMVD
 
     C                   MOVE      MMBRCA        FOBRCA            3
     C**********         Z-ADD     MMCNUM        FOCNUM            6 0                        CSD027
     C                   MOVE      MMCNUM        FOCNUM            6                          CSD027
     C                   MOVE      MMCURR        CCYD
     C**********         Z-ADD     MMACOD        FOACOD            4 0                        CGL029
     C                   Z-ADD     MMACOD        FOACOD           10 0                        CGL029
     C                   Z-ADD     MMACSQ        FOACSQ            2 0
     C                   Z-ADD     0             FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   ENDIF
     C                   ENDIF
 
      **   - BROKER
      **     ------
 
     C*****NTBOCO        IFNE      *ZERO                                                      CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
 
      ** Set up inputs for ZAGETSETAC - broker settlement details
 
     C                   EVAL      MMCNUM     = NTBOCO
     C                   EVAL      MMCURR     = NTISCY
 
     C                   EVAL      MMBRCA     = NSBBID
     C                   EVAL      SettleType = NSBSLT
     C                   EVAL      SettleAcc  = NSBSLA
 
      ** Convert the settlement details into account number fields
 
     C                   EXSR      GETSETAC
 
      ** Set broker memos and prono update indicators
 
     C                   MOVEL     FFMIND        BrokMIND          1
     C                   MOVEL     FFPIND        BrokPIND          1
 
      ** Do broker memos updates (if required)
 
     C     BrokMIND      IFEQ      'Y'
 
      ** Premium Payable
 
     C                   Z-ADD     NSPRMP        Premium
 
      **     Set Reverse/Apply Indicator to 'A' and MEMOSM/PRONOM
      **     Update Indicator to 'M' (used in SR. WACMVD)
 
     C                   MOVE      'A'           RAIND
     C                   MOVE      'M'           MPIND
 
     C                   EXSR      UMEMOS
 
      **     SET UP A/C ID FOR UPDATE OF PF/FFACMVD
 
     C                   MOVE      MMBRCA        FOBRCA
     C**********         Z-ADD     MMCNUM        FOCNUM                                       CSD027
     C                   EVAL      FOCNUM = MMCNUM                                            CSD027
     C                   MOVE      MMCURR        CCYD
     C                   Z-ADD     MMACOD        FOACOD
     C                   Z-ADD     MMACSQ        FOACSQ
     C                   Z-ADD     0             FONOSN
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   ENDIF
     C                   ENDIF
 
      **   LF/PRONOM (Apply)
      **   ~~~~~~~~~
      **   - CUSTOMER
      **     --------
 
     C*****NTCUSC        IFNE      *ZERO                                                      CSD027
     C     NTCUSC        IFNE      *BLANKS                                                    CSD027
     C     CustPIND      ANDEQ     'Y'
 
      ** Set up customer nostro ID
 
     C                   MOVE      NTISCY        CCYD
     C                   MOVEL     NSCSLA        XXCNOS
     C                   MOVE      XXCNOS        FFNOSN
 
      ** Premium Payable
 
     C**********         IF        NTBOCO <> 0                                                CSD027
     C                   IF        NTBOCO <> *BLANKS                                          CSD027
     C                   Z-SUB     NSPRMP        Premium
     C                   ELSE
     C                   Z-ADD     NSPRMP        Premium
     C                   ENDIF
 
      **     Set Reverse/Apply Indicator to 'A' and MEMOSM/PRONOM
      **     Update Indicator to 'P' (used in SR. WACMVD)
 
     C                   MOVE      'A'           RAIND
     C                   MOVE      'P'           MPIND
 
     C                   EXSR      UPRONO
 
     C     CustMIND      IFNE      'Y'
 
      **     SET UP FIELDS FOR UPDATE OF PF/FFACMVD (A/C DERIVED FROM NOSTRO)
 
     C                   MOVE      NSCBID        FOBRCA
     C                   MOVE      NTISCY        CCYD
     C                   MOVE      XXCNOS        FONOSN            2 0
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   ENDIF
     C                   ENDIF
 
      **   - BROKER
      **     ------
 
     C*****NTBOCO        IFNE      *ZERO                                                      CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
     C     BrokPIND      ANDEQ     'Y'
 
      ** Set up broker nostro ID
 
     C                   MOVE      NTISCY        CCYD
     C                   MOVEL     NSBSLA        XXBNOS
     C                   MOVE      XXBNOS        FFNOSN
 
      ** Premium Payable
 
     C                   Z-ADD     NSPRMP        Premium
 
      **     Set Reverse/Apply Indicator to 'A' and MEMOSM/PRONOM
      **     Update Indicator to 'P' (used in SR. WACMVD)
 
     C                   MOVE      'A'           RAIND
     C                   MOVE      'P'           MPIND
 
     C                   EXSR      UPRONO
 
     C     BrokMIND      IFNE      'Y'
 
      **     SET UP FIELDS FOR UPDATE OF PF/FFACMVD (A/C DERIVED FROM NOSTRO)
 
     C                   MOVE      NSBBID        FOBRCA
     C                   MOVE      NTISCY        CCYD
     C                   MOVE      XXBNOS        FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /EJECT                                                             *
      ********************************************************************
      **                                                                 *
      **   AMD_ACMOVE -  Account Movements Update on AMEND               *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
     C     AMD_ACMOVE    BEGSR
      **
      **   LF/MEMOSM
      **   ~~~~~~~~~
      **   - CUSTOMER
      **     --------
 
     C*****NTCUSC        IFNE      0                                                          CSD027
     C     NTCUSC        IFNE      *BLANKS                                                    CSD027
 
      **     - Reverse
 
      ** Set up inputs for ZAGETSETAC - OLD customer settlement details
 
     C                   EVAL      MMCNUM     = NTCUSC
     C                   EVAL      MMCURR     = NTISCY
 
     C                   EVAL      MMBRCA     = OSCBID
     C                   EVAL      SettleType = OSCSLT
     C                   EVAL      SettleAcc  = OSCSLA
 
      ** Convert the settlement details into account number fields
 
     C                   EXSR      GETSETAC
 
      ** Set OLD customer memos and prono update indicators
 
     C                   MOVEL     FFMIND        O_CustMIND        1
     C                   MOVEL     FFPIND        O_CustPIND        1
 
      ** Do customer memos updates (if required)
 
     C     O_CustMIND    IFEQ      'Y'
 
      ** Premium Payable
 
     C**********         IF        NTBOCO <> 0                                                CSD027
     C                   IF        NTBOCO <> *BLANKS                                          CSD027
     C                   Z-SUB     OSPRMP        Premium
     C                   ELSE
     C                   Z-ADD     OSPRMP        Premium
     C                   ENDIF
 
      **     Set Reverse/Apply Indicator to 'R' and MEMOSM/PRONOM
      **     Update Indicator to 'M' (used in SR. WACMVD)
 
     C                   MOVE      'R'           RAIND
     C                   MOVE      'M'           MPIND
 
     C                   EXSR      UMEMOS
 
      **     SET UP A/C ID FOR UPDATE OF PF/FFACMVD
 
     C                   MOVE      MMBRCA        FOBRCA
     C                   MOVE      MMCNUM        FOCNUM
     C                   MOVE      MMCURR        CCYD
     C                   MOVE      MMACOD        FOACOD
     C                   MOVE      MMACSQ        FOACSQ
     C                   Z-ADD     0             FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   END
 
      **     - Apply
 
      ** Set up inputs for ZAGETSETAC - NEW customer settlement details
 
     C                   EVAL      MMCNUM     = NTCUSC
     C                   EVAL      MMCURR     = NTISCY
 
     C                   EVAL      MMBRCA     = NSCBID
     C                   EVAL      SettleType = NSCSLT
     C                   EVAL      SettleAcc  = NSCSLA
 
      ** Convert the settlement details into account number fields
 
     C                   EXSR      GETSETAC
 
      ** Set NEW customer memos and prono update indicators
 
     C                   MOVEL     FFMIND        N_CustMIND        1
     C                   MOVEL     FFPIND        N_CustPIND        1
 
      ** Do customer memos updates (if required)
 
     C     N_CustMIND    IFEQ      'Y'
 
      ** Premium Payable
 
     C**********         IF        NTBOCO <> 0                                                CSD027
     C                   IF        NTBOCO <> *BLANKS                                          CSD027
     C                   Z-SUB     NSPRMP        Premium
     C                   ELSE
     C                   Z-ADD     NSPRMP        Premium
     C                   ENDIF
 
      **     Set Reverse/Apply Indicator to 'A' and MEMOSM/PRONOM
      **     Update Indicator to 'M' (used in SR. WACMVD)
 
     C                   MOVE      'A'           RAIND
     C                   MOVE      'M'           MPIND
 
     C                   EXSR      UMEMOS
 
      **     SET UP A/C ID FOR UPDATE OF PF/FFACMVD
 
     C                   MOVE      MMBRCA        FOBRCA
     C                   MOVE      MMCNUM        FOCNUM
     C                   MOVE      MMCURR        CCYD
     C                   MOVE      MMACOD        FOACOD
     C                   MOVE      MMACSQ        FOACSQ
     C                   Z-ADD     0             FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   END
     C                   END
 
      **   - BROKER
      **     ------
 
     C*****NTBOCO        IFNE      0                                                          CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
 
      **     - Reverse
 
      ** Set up inputs for ZAGETSETAC - OLD broker settlement details
 
     C                   EVAL      MMCNUM     = NTCUSC
     C                   EVAL      MMCURR     = NTISCY
 
     C                   EVAL      MMBRCA     = OSBBID
     C                   EVAL      SettleType = OSBSLT
     C                   EVAL      SettleAcc  = OSBSLA
 
      ** Convert the settlement details into account number fields
 
     C                   EXSR      GETSETAC
 
      ** Set OLD broker memos and prono update indicators
 
     C                   MOVEL     FFMIND        O_BrokMIND        1
     C                   MOVEL     FFPIND        O_BrokPIND        1
 
      ** Do broker memos updates (if required)
 
     C     O_BrokMIND    IFEQ      'Y'
 
      ** Premium Payable
 
     C                   Z-ADD     OSPRMP        Premium
 
      **     Set Reverse/Apply Indicator to 'R' and MEMOSM/PRONOM
      **     Update Indicator to 'M' (used in SR. WACMVD)
 
     C                   MOVE      'R'           RAIND
     C                   MOVE      'M'           MPIND
 
     C                   EXSR      UMEMOS
 
      **     SET UP A/C ID FOR UPDATE OF PF/FFACMVD
 
     C                   MOVE      MMBRCA        FOBRCA
     C                   MOVE      MMCNUM        FOCNUM
     C                   MOVE      MMCURR        CCYD
     C                   MOVE      MMACOD        FOACOD
     C                   MOVE      MMACSQ        FOACSQ
     C                   Z-ADD     0             FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   END
 
      **     - Apply
 
      ** Set up inputs for ZAGETSETAC - NEW broker settlement details
 
     C                   EVAL      MMCNUM     = NTCUSC
     C                   EVAL      MMCURR     = NTISCY
 
     C                   EVAL      MMBRCA     = NSBBID
     C                   EVAL      SettleType = NSBSLT
     C                   EVAL      SettleAcc  = NSBSLA
 
      ** Convert the settlement details into account number fields
 
     C                   EXSR      GETSETAC
 
      ** Set NEW broker memos and prono update indicators
 
     C                   MOVEL     FFMIND        N_BrokMIND        1
     C                   MOVEL     FFPIND        N_BrokPIND        1
 
      ** Do broker memos updates (if required)
 
     C     N_BrokMIND    IFEQ      'Y'
 
      ** Premium Payable
 
     C                   Z-ADD     NSPRMP        Premium
 
      **     Set Reverse/Apply Indicator to 'A' and MEMOSM/PRONOM
      **     Update Indicator to 'M' (used in SR. WACMVD)
 
     C                   MOVE      'A'           RAIND
     C                   MOVE      'M'           MPIND
 
     C                   EXSR      UMEMOS
 
      **     SET UP A/C ID FOR UPDATE OF PF/FFACMVD
 
     C                   MOVE      MMBRCA        FOBRCA
     C                   MOVE      MMCNUM        FOCNUM
     C                   MOVE      MMCURR        CCYD
     C                   MOVE      MMACOD        FOACOD
     C                   MOVE      MMACSQ        FOACSQ
     C                   Z-ADD     0             FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   END
 
     C                   END
 
      **   LF/PRONOM
      **   ~~~~~~~~~
      **   - CUSTOMER
      **     --------
 
     C*****NTCUSC        IFNE      0                                                          CSD027
     C     NTCUSC        IFNE      *BLANKS                                                    CSD027
 
      **     - Reverse
 
      ** Do customer pronos updates (if required)
 
     C     O_CustPIND    IFEQ      'Y'
 
      ** Set up customer nostro ID
 
     C                   MOVE      NTISCY        CCYD
     C                   MOVEL     OSCSLA        XXCNOS
     C                   MOVE      XXCNOS        FFNOSN
 
      ** Premium Payable
 
     C**********         IF        NTBOCO <> 0                                                CSD027
     C                   IF        NTBOCO <> *BLANKS                                          CSD027
     C                   Z-SUB     OSPRMP        Premium
     C                   ELSE
     C                   Z-ADD     OSPRMP        Premium
     C                   ENDIF
 
      **     Set Reverse/Apply Indicator to 'R' and MEMOSM/PRONOM
      **     Update Indicator to 'P' (used in SR. WACMVD)
 
     C                   MOVE      'R'           RAIND
     C                   MOVE      'P'           MPIND
 
     C                   EXSR      UPRONO
 
     C     O_CustMIND    IFNE      'Y'
 
      **     SET UP FIELDS FOR UPDATE OF PF/FFACMVD (A/C DERIVED FROM NOSTRO)
 
     C                   MOVE      OSCBID        FOBRCA
     C                   MOVE      NTISCY        CCYD
     C                   MOVE      XXCNOS        FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   END
     C                   END
 
      **     - Apply
 
      ** Do customer pronos updates (if required)
 
     C     N_CustPIND    IFEQ      'Y'
 
      ** Set up customer nostro ID
 
     C                   MOVE      NTISCY        CCYD
     C                   MOVEL     NSCSLA        XXCNOS
     C                   MOVE      XXCNOS        FFNOSN
 
      ** Premium Payable
 
     C**********         IF        NTBOCO <> 0                                                CSD027
     C                   IF        NTBOCO <> *BLANKS                                          CSD027
     C                   Z-SUB     NSPRMP        Premium
     C                   ELSE
     C                   Z-ADD     NSPRMP        Premium
     C                   ENDIF
 
      **     Set Reverse/Apply Indicator to 'A' and MEMOSM/PRONOM
      **     Update Indicator to 'P' (used in SR. WACMVD)
 
     C                   MOVE      'A'           RAIND
     C                   MOVE      'P'           MPIND
 
     C                   EXSR      UPRONO
 
     C     N_CustMIND    IFNE      'Y'
 
      **     SET UP FIELDS FOR UPDATE OF PF/FFACMVD (A/C DERIVED FROM NOSTRO)
 
     C                   MOVE      NSCBID        FOBRCA
     C                   MOVE      NTISCY        CCYD
     C                   MOVE      XXCNOS        FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   END
     C                   END
 
     C                   END
 
      **   - BROKER
      **     ------
 
     C*****NTBOCO        IFNE      0                                                          CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
 
      **     - Reverse
 
      ** Do broker pronos updates (if required)
 
     C     O_BrokPIND    IFEQ      'Y'
 
      ** Set up broker nostro ID
 
     C                   MOVE      NTISCY        CCYD
     C                   MOVEL     OSBSLA        XXBNOS
     C                   MOVE      XXBNOS        FFNOSN
 
      ** Premium Payable
 
     C                   Z-ADD     OSPRMP        Premium
 
      **     Set Reverse/Apply Indicator to 'R' and MEMOSM/PRONOM
      **     Update Indicator to 'P' (used in SR. WACMVD)
 
     C                   MOVE      'R'           RAIND
     C                   MOVE      'P'           MPIND
 
     C                   EXSR      UPRONO
 
     C     O_BrokMIND    IFNE      'Y'
 
      **     SET UP FIELDS FOR UPDATE OF PF/FFACMVD (A/C DERIVED FROM NOSTRO)
 
     C                   MOVE      OSBBID        FOBRCA
     C                   MOVE      NTISCY        CCYD
     C                   MOVE      XXBNOS        FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   END
     C                   END
 
      **     - Apply
 
      ** Do broker pronos updates (if required)
 
     C     N_BrokPIND    IFEQ      'Y'
 
      ** Set up broker nostro ID
 
     C                   MOVE      NTISCY        CCYD
     C                   MOVEL     NSBSLA        XXBNOS
     C                   MOVE      XXBNOS        FFNOSN
 
      ** Premium Payable
 
     C                   Z-ADD     NSPRMP        Premium
 
      **     Set Reverse/Apply Indicator to 'A' and MEMOSM/PRONOM
      **     Update Indicator to 'P' (used in SR. WACMVD)
 
     C                   MOVE      'A'           RAIND
     C                   MOVE      'P'           MPIND
 
     C                   EXSR      UPRONO
 
     C     N_BrokMIND    IFNE      'Y'
 
      **     SET UP FIELDS FOR UPDATE OF PF/FFACMVD (A/C DERIVED FROM NOSTRO)
 
     C                   MOVE      NSBBID        FOBRCA
     C                   MOVE      NTISCY        CCYD
     C                   MOVE      XXBNOS        FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   END
     C                   END
 
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /EJECT                                                             *
      ********************************************************************
      **                                                                 *
      **   DEL_ACMOVE -  Account Movements Update on DELETE              *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
     C     DEL_ACMOVE    BEGSR
      **
      **   LF/MEMOSM (Reverse)
      **   ~~~~~~~~~
      **   - CUSTOMER
      **     --------
 
     C*****NTCUSC        IFNE      0                                                          CSD027
     C     NTCUSC        IFNE      *BLANKS                                                    CSD027
 
      ** Set up inputs for ZAGETSETAC - customer settlement details
 
     C                   EVAL      MMCNUM     = NTCUSC
     C                   EVAL      MMCURR     = NTISCY
 
     C                   EVAL      MMBRCA     = OSCBID
     C                   EVAL      SettleType = OSCSLT
     C                   EVAL      SettleAcc  = OSCSLA
 
      ** Convert the settlement details into account number fields
 
     C                   EXSR      GETSETAC
 
      ** Set customer memos and prono update indicators
 
     C                   MOVEL     FFMIND        CustMIND          1
     C                   MOVEL     FFPIND        CustPIND          1
 
      ** Do customer memos updates (if required)
 
     C     CustMIND      IFEQ      'Y'
 
      ** Premium Payable
 
     C**********         IF        NTBOCO <> 0                                                CSD027
     C                   IF        NTBOCO <> *BLANKS                                          CSD027
     C                   Z-SUB     OSPRMP        Premium
     C                   ELSE
     C                   Z-ADD     OSPRMP        Premium
     C                   ENDIF
 
      **     Set Reverse/Apply Indicator to 'R' and MEMOSM/PRONOM
      **     Update Indicator to 'M' (used in SR. WACMVD)
 
     C                   MOVE      'R'           RAIND
     C                   MOVE      'M'           MPIND
 
     C                   EXSR      UMEMOS
 
      **     SET UP A/C ID FOR UPDATE OF PF/FFACMVD
 
     C                   MOVE      MMBRCA        FOBRCA
     C                   MOVE      MMCNUM        FOCNUM
     C                   MOVE      MMCURR        CCYD
     C                   MOVE      MMACOD        FOACOD
     C                   MOVE      MMACSQ        FOACSQ
     C                   Z-ADD     0             FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   END
     C                   END
 
      **   - BROKER
      **     ------
 
     C*****NTBOCO        IFNE      0                                                          CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
 
      ** Set up inputs for ZAGETSETAC - broker settlement details
 
     C                   EVAL      MMCNUM     = NTBOCO
     C                   EVAL      MMCURR     = NTISCY
 
     C                   EVAL      MMBRCA     = OSBBID
     C                   EVAL      SettleType = OSBSLT
     C                   EVAL      SettleAcc  = OSBSLA
 
      ** Convert the settlement details into account number fields
 
     C                   EXSR      GETSETAC
 
      ** Set broker memos and prono update indicators
 
     C                   MOVEL     FFMIND        BrokMIND          1
     C                   MOVEL     FFPIND        BrokPIND          1
 
      ** Do broker memos updates (if required)
 
     C     BrokMIND      IFEQ      'Y'
 
      ** Premium Payable
 
     C                   Z-ADD     OSPRMP        Premium
 
      **     Set Reverse/Apply Indicator to 'R' and MEMOSM/PRONOM
      **     Update Indicator to 'M' (used in SR. WACMVD)
 
     C                   MOVE      'R'           RAIND
     C                   MOVE      'M'           MPIND
 
     C                   EXSR      UMEMOS
 
      **     SET UP A/C ID FOR UPDATE OF PF/FFACMVD
 
     C                   MOVE      MMBRCA        FOBRCA
     C                   MOVE      MMCNUM        FOCNUM
     C                   MOVE      MMCURR        CCYD
     C                   MOVE      MMACOD        FOACOD
     C                   MOVE      MMACSQ        FOACSQ
     C                   Z-ADD     0             FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   END
     C                   END
 
      **
      **   LF/PRONOM (Reverse)
      **   ~~~~~~~~~
      **   - CUSTOMER
      **     --------
 
     C*****NTCUSC        IFNE      0                                                          CSD027
     C     NTCUSC        IFNE      *BLANKS                                                    CSD027
     C     CustPIND      ANDEQ     'Y'
 
      ** Set up customer nostro ID
 
     C                   MOVE      NTISCY        CCYD
     C                   MOVEL     OSCSLA        XXCNOS
     C                   MOVE      XXCNOS        FFNOSN
 
      ** Premium Payable
 
     C**********         IF        NTBOCO <> 0                                                CSD027
     C                   IF        NTBOCO <> *BLANKS                                          CSD027
     C                   Z-SUB     OSPRMP        Premium
     C                   ELSE
     C                   Z-ADD     OSPRMP        Premium
     C                   ENDIF
 
      **     Set Reverse/Apply Indicator to 'R' and MEMOSM/PRONOM
      **     Update Indicator to 'P' (used in SR. WACMVD)
 
     C                   MOVE      'R'           RAIND
     C                   MOVE      'P'           MPIND
 
     C                   EXSR      UPRONO
 
     C     CustMIND      IFNE      'Y'
 
      **     SET UP FIELDS FOR UPDATE OF PF/FFACMVD (A/C DERIVED FROM NOSTRO)
 
     C                   MOVE      OSCBID        FOBRCA
     C                   MOVE      NTISCY        CCYD
     C                   MOVE      XXCNOS        FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   END
     C                   END
 
      **   - BROKER
      **     ------
 
     C*****NTBOCO        IFNE      0                                                          CSD027
     C     NTBOCO        IFNE      *BLANKS                                                    CSD027
     C     BrokPIND      ANDEQ     'Y'
 
      ** Set up broker nostro ID
 
     C                   MOVE      NTISCY        CCYD
     C                   MOVEL     OSBSLA        XXBNOS
     C                   MOVE      XXBNOS        FFNOSN
 
      ** Premium Payable
 
     C                   Z-ADD     OSPRMP        Premium
 
      **     Set Reverse/Apply Indicator to 'R' and MEMOSM/PRONOM
      **     Update Indicator to 'P' (used in SR. WACMVD)
 
     C                   MOVE      'R'           RAIND
     C                   MOVE      'P'           MPIND
 
     C                   EXSR      UPRONO
 
     C     BrokMIND      IFNE      'Y'
 
      **     SET UP FIELDS FOR UPDATE OF PF/FFACMVD (A/C DERIVED FROM NOSTRO)
 
     C                   MOVE      OSBBID        FOBRCA
     C                   MOVE      NTISCY        CCYD
     C                   MOVE      XXBNOS        FONOSN
 
      **     Write record to PF/FFACMVD
     C                   EXSR      WACMVD
 
     C                   END
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   UMEMOS SR. -  Update  LF/MEMOSM :                             *
      **   ~~~~~~~~~~                                                    *
      ********************************************************************
 
     C     UMEMOS        BEGSR
 
      **   Access  LF/MEMOSM
     C     KMEMOS        CHAIN     MEMOSM                             71
 
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     0             LDBL
     C                   Z-ADD     0             CLBL
     C                   END
 
      **   Store Ledger Balance in a work field for use in SR. WACMVD
     C                   Z-ADD     LDBL          WLDBL
 
      **   'APPLY' updates due to the new trade
 
     C     RAIND         IFEQ      'A'
 
      ** - Purchase
     C                   IF        NTTRTY = 'P'
     C                   SUB       Premium       LDBL
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     NTVALD        ANDLE     BJRDNB                                                     CFF007
     C     CFF001        OREQ      'Y'                                                        CFF007
     C     MKMRKT        ANDEQ     *BLANKS                                                    CFF007
     C     NTVALD        ANDLE     BJRDNB                                                     CFF007
     C                   SUB       Premium       CLBL
     C                   ENDIF                                                                CFF007
     C                   ELSE
     C                   ADD       Premium       LDBL
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     NTVALD        ANDLE     BJRDNB                                                     CFF007
     C     CFF001        OREQ      'Y'                                                        CFF007
     C     MKMRKT        ANDEQ     *BLANKS                                                    CFF007
     C     NTVALD        ANDLE     BJRDNB                                                     CFF007
     C                   ADD       Premium       CLBL
     C                   ENDIF                                                                CFF007
     C                   ENDIF
 
     C                   ELSE
 
      **   'REVERSE' updates due to the old trade
 
      ** - Purchase
     C                   IF        NTTRTY = 'P'
     C                   ADD       Premium       LDBL
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     NTVALD        ANDLE     BJRDNB                                                     CFF007
     C     CFF001        OREQ      'Y'                                                        CFF007
     C     MKMRKT        ANDEQ     *BLANKS                                                    CFF007
     C     NTVALD        ANDLE     BJRDNB                                                     CFF007
     C                   ADD       Premium       CLBL
     C                   ENDIF                                                                CFF007
     C                   ELSE
     C                   SUB       Premium       LDBL
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     NTVALD        ANDLE     BJRDNB                                                     CFF007
     C     CFF001        OREQ      'Y'                                                        CFF007
     C     MKMRKT        ANDEQ     *BLANKS                                                    CFF007
     C     NTVALD        ANDLE     BJRDNB                                                     CFF007
     C                   SUB       Premium       CLBL
     C                   ENDIF                                                                CFF007
     C                   ENDIF
 
     C                   ENDIF
 
      **   Update  LF/MEMOSM
     C     *IN71         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   MOVE      MMBRCA        BRCA
     C**********         Z-ADD     MMCNUM        CNUM                                         CSD027
     C                   EVAL      CNUM = MMCNUM                                              CSD027
     C                   MOVE      MMCURR        CCY
     C                   Z-ADD     MMACOD        ACOD
     C                   Z-ADD     MMACSQ        ACSQ
     C                   WRITE     MEMOSMEF
 
     C                   ELSE
     C                   UPDATE    MEMOSMEF
     C                   END
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      **                                                                 *
      **   UPRONO SR. -  Update  LF/PRONOM :                             *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
 
     C     UPRONO        BEGSR
 
     C     CFF007        IFNE      'Y'                                                        CFF007
     C     CFF001        OREQ      'Y'                                                        CFF007
     C     MKMRKT        ANDEQ     *BLANKS                                                    CFF007
                                                                                              CFF007
      **   Access  LF/PRONOM
     C     KPRONO        CHAIN     PRONOM                             71
 
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     0             PNBL
     C                   END
 
      **   Store Projected Nostro Balance in a work field for use
      **   in SR. WACMVD
     C                   Z-ADD     PNBL          WPNBL
 
      **   'APPLY' updates due to the new trade
 
     C     RAIND         IFEQ      'A'
 
      **   - Purchase
     C                   IF        NTTRTY = 'P'
     C                   SUB       Premium       PNBL
     C                   ELSE
     C                   ADD       Premium       PNBL
     C                   ENDIF
 
     C                   ELSE
 
      **   'REVERSE' updates due to the old trade
 
      **   - Purchase
     C                   IF        NTTRTY = 'P'
     C                   ADD       Premium       PNBL
     C                   ELSE
     C                   SUB       Premium       PNBL
     C                   ENDIF
     C                   ENDIF
 
      **   Update  LF/PRONOM
     C     *IN71         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   MOVE      CCYD          CCY
     C                   MOVE      FFNOSN        NOSN
     C                   WRITE     PRONOMEF
     C                   ELSE
     C                   UPDATE    PRONOMEF
     C                   END
                                                                                              CFF007
     C                   ELSE                                                                 CFF007
     C     KPRONO        CHAIN     PRONO                              71                      CFF007
                                                                                              CFF007
     C     *IN71         IFEQ      '1'                                                        CFF007
     C     *IN71         OREQ      '0'                                                        CFF007
     C     RECI          ANDNE     'D'                                                        CFF007
     C     *LOCK         IN        LDA                                                        CFF007
     C                   Z-ADD     30            DBASE                                        CFF007
     C                   MOVEL     'PRONO'       DBFILE                                       CFF007
     C                   MOVEL     PRONOK        DBKEY                                        CFF007
     C                   OUT       LDA                                                        CFF007
     C                   EXSR      *PSSR                                                      CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      ** Calculate next next working day after the fifth date in the                          CFF007
      ** array in PRONOPN and store as the sixth date                                         CFF007
      ** Also, store balances to detect if  change is made                                    CFF007
     C                   Z-ADD     ArrBalance    OldArrDate                                   CFF007
                                                                                              CFF007
      ** Check if holiday                                                                     CFF007
     C                   Z-ADD     Arr_Date(5)   ZDAYNO                                       CFF007
     C                   MOVE      CCYD          ZCCY                                         CFF007
     C                   MOVE      *BLANKS       ZLOC                                         CFF007
                                                                                              CFF007
     C                   CALLB     'ZCHKH'                                                    CFF007
     C                   PARM                    ZDAYNO                                       CFF007
     C                   PARM                    ZCCY                                         CFF007
     C                   PARM                    ZLOC                                         CFF007
     C                   PARM                    ZIND                                         CFF007
                                                                                              CFF007
     C                   Z-ADD     ZDAYNO        Arr_Date(6)                                  CFF007
                                                                                              CFF007
      ** Update the five balances in turn according to whether the                            CFF007
      ** test date is before the cut-off date for each balance                                CFF007
     C     1             DO        5             Z                                            CFF007
                                                                                              CFF007
     C     Z             ADD       1             Z2                                           CFF007
                                                                                              CFF007
     C     NTVALD        IFLT      Arr_Date(Z2)                                               CFF007
                                                                                              CFF007
      ** 'APPLY' updates due to new trade                                                     CFF007
     C     RAIND         IFEQ      'A'                                                        CFF007
                                                                                              CFF007
      ** Purchase                                                                             CFF007
     C     NTTRTY        IFEQ      'P'                                                        CFF007
     C                   SUB       Premium       ArrBalance(Z)                                CFF007
     C                   ELSE                                                                 CFF007
     C                   ADD       Premium       ArrBalance(Z)                                CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ELSE                                                                 CFF007
                                                                                              CFF007
      ** 'REVERSE' updates due to old trade                                                   CFF007
      ** Purchase                                                                             CFF007
     C     NTTRTY        IFEQ      'P'                                                        CFF007
     C                   ADD       Premium       ArrBalance(Z)                                CFF007
     C                   ELSE                                                                 CFF007
     C                   SUB       Premium       ArrBalance(Z)                                CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ENDDO                                                                CFF007
                                                                                              CFF007
      ** Write results to Nostro balance file                                                 CFF007
     C     SvProNosBal   IFNE      PNB                                                        CFF007
     C                   UPDATE    PRONOPNF                                                   CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ENDIF                                                                CFF007
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT                                                             *
      ********************************************************************
      **                                                                 *
      **   UCLOST SR. -  Update  LF/CLOST                                *
      **   ~~~~~~~~~~                                                    *
      **                                                                 *
      ********************************************************************
 
     C     UCLOST        BEGSR
 
      **   Identify Close-Outs which reference this transaction
      **    by reading LF/CLOST2
     C                   Z-ADD     NTTNBR        KTNBR
     C                   Z-ADD     0             KCLON
 
     C     KCLST2        SETLL     CLOSTTF
     C                   READ      CLOSTTF                                71
 
     C     TNBR          DOWEQ     KTNBR
     C     *IN71         ANDEQ     '0'
 
      **   Access LF/CLOST
     C     CLON          CHAIN     CLOST                              71
 
      **   - not found
     C     *IN71         IFEQ      '1'
     C                   EXSR      ErrorExit
     C                   ENDIF
 
     C** Validate Close Out is for same instrument as Trade                                   180497
     C     NTISTT        IFEQ      ISTT                                                       180497
     C     NTMTHN        ANDEQ     MTHN                                                       180497
     C     NTYRNO        ANDEQ     YRNO                                                       180497
      **   If not already flagged for reversal
     C     CORI          IFNE      'Y'
     C                   MOVE      'Y'           CORI
     C                   MOVE      'N'           SHPI
     C                   Z-ADD     CTDATE        LCD
     C                   MOVE      'A'           CHTP
     C                   Z-ADD     NATN          TNLU
 
      **   - Close Out Reversal
     C                   UPDATE    CLOSTDF
 
     C                   END
 
     C                   END                                                                  180497
                                                                                              180497
     C                   READ      CLOSTTF                                71
 
     C                   END
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      * OpenFiles - Open the files which are under user control       *
      *                                                               *
      *****************************************************************
 
     C     OpenFiles     BEGSR
 
     C                   OPEN      TRANSA
     C                   OPEN      TRANS
     C                   OPEN      POSTNK
     C                   OPEN      POSTNC
     C                   OPEN      PRONOM
     C                   OPEN      MEMOSM
     C                   OPEN      CLOST
     C                   OPEN      CLOST2
     C                   OPEN      FFACMVD
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      * CloseFiles - Close the files which are under user control     *
      *                                                               *
      *****************************************************************
 
     C     CloseFiles    BEGSR
 
     C                   CLOSE     TRANSA                               99
     C                   CLOSE     TRANS                                99
     C                   CLOSE     POSTNK                               99
     C                   CLOSE     POSTNC                               99
     C                   CLOSE     PRONOM                               99
     C                   CLOSE     MEMOSM                               99
     C                   CLOSE     CLOST                                99
     C                   CLOSE     CLOST2                               99
     C                   CLOSE     FFACMVD                              99
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      * TransInit - Transaction-specific initialisation               *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     TransInit     BEGSR
 
 
      ** -------------------------------------------------------------------------------------------
      ** Get the market centre details for the transaction
      ** -------------------------------------------------
     C                   RESET                   ReturnCode
     C                   CALLB     'FFGETMKT'
      ** Parameters returned from called module
      ** --------------------------------------
      ** Return code (10A)
     C                   PARM                    ReturnCode
      ** Market centre data structure
     C                   PARM                    MarketDS
 
      ** Parameters sent to called module
      ** --------------------------------
      ** Month number (2,0S)
     C                   PARM                    NTMTHN
      ** Instrument type (5A)
     C                   PARM                    NTISTT
 
      ** If the called module returned a database error, end in error
     C                   IF        ReturnCode = 'DBError'
     C                   EXSR      *pssr
     C                   ENDIF
      ** -------------------------------------------------------------------------------------------
 
      ** -------------------------------------------------------------------------------------------
      ** Access the Market Control details file for the business date
      ** ------------------------------------------------------------
     C                   IF        TransType = ExchTrade
 
     C     MKMRKT        CHAIN     MKCTL                              99
 
     C                   IF        NoRcdFound = True
     C                   EXSR      *pssr
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVEL     *BLANK        MCMRKT
     C                   Z-ADD     *ZERO         MCBUSD
 
     C                   ENDIF
      ** -------------------------------------------------------------------------------------------
 
      ** -------------------------------------------------------------------------------------------
      ** Set up the current trading date
      ** -------------------------------
     C                   IF        MCBUSD = 0
     C                   EVAL      CTDATE = BJRDNB
     C                   ELSE
     C                   EVAL      CTDATE = MCBUSD
     C                   ENDIF
 
      ** -------------------------------------------------------------------------------------------
 
      ** -------------------------------------------------------------------------------------------
 
 
      ** -------------------------------------------------------------------------------------------
      ** Set up the parameters for AOOUOTU0 (accessing the old transaction
      ** record if necessary)
      ** --------------------                                               ------------------------
 
      ** If action is insert, clear the 'before' parameters for both
      ** transaction and settlement details
     C                   IF        NTCHTP = 'I'
 
     C                   CLEAR                   Z#BSTS
     C                   CLEAR                   Z#WSTS
 
      ** Otherwise set the 'before's to the old versions of the
      ** transaction.
     C                   ELSE
 
     C     NTTNBR        CHAIN     TRANS                              99
     C                   EVAL      Z#BSTS = F_Trans
 
      ** Save the old version of the last change type  and date
     C                   EVAL      OldChgType = CHTP
     C                   EVAL      OldChgDate = LCD
 
     C                   OPEN      TRSET
     C     NTTNBR        CHAIN     TRSET                              99
     C                   CLOSE     TRSET
     C                   EVAL      Z#WSTS = F_Settl
 
     C                   ENDIF
 
      ** Set 'after' status of settlement instructions
 
     C                   EVAL      Z#XSTS = ValidSettl
 
      ** -------------------------------------------------------------------------------------------
 
 
      ** ----------------------------------------------------------------   ----
      ** If the transaction is an option, calculate its current premium
      ** ----------------------------------------------------------------
 
     C     ITISPT        IFGE      4
     C     ITISPT        ANDNE     7
     C                   EXSR      CalcPrem
     C                   ELSE
     C                   Z-ADD     *ZERO         NSPRMP
     C                   ENDIF
 
      ** -----------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CalcPrem - Calculate (Option) Premium                         *
      *                                                               *
      *****************************************************************
 
     C     CalcPrem      BEGSR
 
      **   Use the strike price in the Premium calculation.
      **   for processing type 8
 
     C     ITISPT        IFEQ      8
     C                   Z-ADD     NTSTRP        FFPRIC
 
      **   for other types of options use the contract price
 
     C                   ELSE
     C                   Z-ADD     NTCOPR        FFPRIC
     C                   END
 
     C                   CALLB     'FFPMCL'
      ** Outputs
      ** -------
      **                              Premium (13,0P)
     C                   PARM                    NSPRMP
      ** Inputs
      ** ------
      **                              Number of contracts (5,0P)
     C                   PARM                    NTNUCO
      **                              Price (15,8P)
     C                   PARM                    FFPRIC           15 8
      **                              Ticks denominator (3,0P)
     C                   PARM                    ITTKDM
      **                              Minimum price fluctuation (15,8P)
     C                   PARM                    ITMNPF
      **                              Tick Value (14,5P)
     C                   PARM                    ITTKVL
      **                              Instrument type (1,0S)
     C                   PARM                    ITISPT
      **                              Contract type (1,0S, from INTYPD)
     C                   PARM                    ITCNTT
      **                              Contingent amount (13,0P), from INTYPD)
     C                   PARM                    ITCTAM
      **                              Strike Price (15,8P)                                    215528
     C                   PARM      NTSTRP        FFSTRP                                       215528
 
      *                                                                                       247471
     C     ITISPT        IFEQ      5                                                          247471
     C     ITISCY        IFEQ      ITCTCY                                                     247471
     C     NSPRMP        MULT      NTSTRP        NSPRMP                                       247471
     C                   END                                                                  247471
     C     ITISCY        IFNE      ITCTCY                                                     247471
     C     ITISCY        ANDNE     ITOTHC                                                     247471
     C                   Z-ADD     0             NSPRMP                                       247471
     C                   END                                                                  247471
     C                   END                                                                  247471
      *                                                                                       247471
 
      **   For processing type 8, multiply the amount calculated
      **   by the contract price.
 
     C     ITISPT        IFEQ      8
     C                   MULT      NTCOPR        NSPRMP
     C                   END
 
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetSetAc - Get Settlement Account details                     *
      *                                                               *
      *****************************************************************
 
     C     GetSetAc      BEGSR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZAGETSETAC'
      ** Outputs
      ** -------                         Return code
     C                   PARM                    ReturnCode
      **                                 Account code
     C                   PARM                    MMACOD
      **                                 Account sequence
     C                   PARM                    MMACSQ
      **                                 MEMOS update required
     C                   PARM                    FFMIND
      **                                 PRONO update required
     C                   PARM                    FFPIND
      ** Input/output
      ** ------------
      **                                 Branch
     C                   PARM                    MMBRCA
      **                                 Customer
     C                   PARM                    MMCNUM
      **                                 Currency
     C                   PARM                    MMCURR
      ** Inputs
      ** ------
      **                                 Settlement type
     C                   PARM                    SettleType
      **                                 Settlement account
     C                   PARM                    SettleAcc
 
     C                   ENDSR
      ********************************************************************
      /EJECT                                                                                  CAP166
      *****************************************************************                       CAP166
      *                                                               *                       CAP166
      * SRUpdIntypd - Update Plato fields in PF/INTYPD                *                       CAP166
      *                                                               *                       CAP166
      *****************************************************************                       CAP166
                                                                                              CAP166
     C     SRUpdIntypd   BEGSR                                                                CAP166
                                                                                              CAP166
      ** Backup InstType to WInstType so that fields processed will not be                    CAP166
      ** discarded by the chain operation                                                     CAP166
                                                                                              CAP166
     C                   EVAL      WInstType = InstType                                       CAP166
                                                                                              CAP166
      ** Access record                                                                        CAP166
                                                                                              CAP166
     C                   EVAL      KISTI = 'Y'                                                CAP166
     C                   EVAL      KISTT = NTISTT                                             CAP166
     C     KINTY1        CHAIN     INTYPWRT                           73                      CAP166
                                                                                              CAP166
     C                   IF        *IN73 = False                                              CAP166
                                                                                              CAP166
      ** Update Plato Fields                                                                  CAP166
                                                                                              CAP166
     C                   EVAL      ITCHTP = 'A'                                               CAP166
     C                   EVAL      ITLCD = CTDATE                                             CAP166
     C                   Z-ADD     NATN          ITTNLU                                       CAP166
                                                                                              CAP166
      ** Update only if instrument processing type is equal to '4'                            CAP166
                                                                                              CAP166
     C                   IF        ITISPT = 4                                                 CAP166
                                                                                              CAP166
     C                   EVAL      ITPLMIIT = WTPLMIIT                                        CAP166
     C                   EVAL      ITPLMITM = WTPLMITM                                        CAP166
     C                   EVAL      ITPLMIMD = WTPLMIMD                                        CAP166
     C                   EVAL      ITPLMICP = WTPLMICP                                        CAP166
     C                   EVAL      ITPLMICF = WTPLMICF                                        CAP166
     C                   EVAL      ITPLMIPC = WTPLMIPC                                        CAP166
                                                                                              CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
      ** Update other plato fields                                                            CAP166
                                                                                              CAP166
     C                   EVAL      ITPLMIVT = WTPLMIVT                                        CAP166
     C                   EVAL      ITPLMIPM = WTPLMIPM                                        CAP166
     C                   EVAL      ITPLMIPG = WTPLMIPG                                        CAP166
     C                   EVAL      ITPLMIRG = WTPLMIRG                                        CAP166
     C                   EVAL      ITPLMICR = WTPLMICR                                        CAP166
                                                                                              CAP166
      ** Update record                                                                        CAP166
                                                                                              CAP166
     C                   UPDATE    INTYPWRT                             73                    CAP166
                                                                                              CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
      ** Update trailer                                                                       CAP166
                                                                                              CAP166
     C                   IF        *IN73 = False                                              CAP166
     C     1             CHAIN     INTYPAF                            73                      CAP166
     C                   IF        *IN73 = False                                              CAP166
     C                   EVAL      NAMD = NAMD + 1                                            CAP166
     C                   UPDATE    INTYPAF                                                    CAP166
     C                   ENDIF                                                                CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
     C                   ENDSR                                                                CAP166
      *****************************************************************                       CAP166
      /EJECT
      *****************************************************************
      *                                                               *                       CSD015
      * SrWatch - Set-up parameters for compliance engine program and *                       CSD015
      *           sends transaction details by calling SDCWLCHK.      *                       CSD015
      *                                                               *                       CSD015
      * Called by: WTRANS, UTRANS                                     *                       CSD015
      *                                                               *                       CSD015
      * Calls: SDCWLCHK, SDCWLFMT                                     *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
                                                                                              CSD015
     C     SrWatch       BEGSR                                                                CSD015
                                                                                              CSD015
      ** Initialise then set-up 1st parameter for SDCWLCHK                                    CSD015
                                                                                              CSD015
     C                   CLEAR                   SDWLTD                                       CSD015
                                                                                              CSD015
      ** Set item type code depending on transaction type                                     CSD015
     C                   IF        TransType = OTCCurr                                        CSD015
     C                   MOVEL     'FFOTC'       W4ITEM                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        TransType = OTCOvar                                        CSD015
     C                   MOVEL     'FFOTCO'      W4ITEM                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        TransType = ExchTrade                                      CSD015
     C                   MOVEL     'FFEFO'       W4ITEM                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   MOVEL     TNBR          W4IDEN                                       CSD015
     C                   EVAL      W4BRCH = BRCA                                              CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      W4FUNT = 'TRANSD'                                          CSD015
                                                                                              CSD015
      ** Format Deal date                                                                     CSD015
     C                   MOVE      TRSD          PInDate                                      CSD015
     C                   EXSR      SrCvtDate                                                  CSD015
     C                   EVAL      W4DDAT = PoutDate                                          CSD015
                                                                                              CSD015
      ** Format Value date                                                                    CSD015
     C                   MOVE      VALD          PInDate                                      CSD015
     C                   EXSR      SrCvtDate                                                  CSD015
     C                   EVAL      W4VDAT = PoutDate                                          CSD015
                                                                                              CSD015
      ** Format Maturity date                                                                 CSD015
     C                   EVAL      PInDate = '00000'                                          CSD015
     C                   EXSR      SrCvtDate                                                  CSD015
     C                   EVAL      W4MDAT = PoutDate                                          CSD015
                                                                                              CSD015
     C                   EVAL      W4DEN1 = ISCY                                              CSD015
     C                   MOVE      NUCO          PInAmt                                       CSD015
     C                   EVAL      PCurr = *BLANKS                                            CSD015
     C                   EXSR      SrCvtAmt                                                   CSD015
     C                   EVAL      W4AMT1 = PAMFlot                                           CSD015
     C                   EVAL      W4DEN2 = *Blanks                                           CSD015
     C                   EVAL      W4AMT2 = 0                                                 CSD015
      *                                                                                       CSD015
      ** Access customer details file for Counterparty details                                CSD015
      *                                                                                       CSD015
     C                   MOVEL     CUSC          PCust                                        CSD015
     C                   CALLB     'AOCUSTR0'                                                 CSD015
     C                   PARM      *Blanks       @RTCD                                        CSD015
     C                   PARM      '*KEY   '     @OPTN                                        CSD015
     C                   PARM                    PCust                                        CSD015
     C                   PARM      *Blanks       PSTKey                                       CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RTCD = *Blanks                                            CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   MOVE      'C'           W4CTYP                                       CSD015
     C                   ELSE                                                                 CSD015
     C                   MOVE      'I'           W4CTYP                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        BBLICD <> *BLANKS AND                                      CSD015
     C                             BBLICD <> W1IND1 AND                                       CSD015
     C                             BBLICD <> W1IND2 AND                                       CSD015
     C                             BBLICD <> W1IND3 AND                                       CSD015
     C                             BBLICD <> W1IND4 AND                                       CSD015
     C                             BBLICD <> W1IND5                                           CSD015
     C                   MOVE      'C'           W4CTYP                                       CSD015
     C                   ELSE                                                                 CSD015
     C                   MOVE      'I'           W4CTYP                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C     BBCRNM        CAT       BBCRTN        W4CUST                                       CSD015
     C                   MOVEL     BBCUST        W4CNUM                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Initialise then set-up 2nd parameter for SDCWLCHK                                    CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
     C                   EVAL      PXMLCode = *BLANKS                                         CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
                                                                                              CSD015
     C                   DOU       Ctr > CWLArrSize                                           CSD015
                                                                                              CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM      *Blanks       @RTCD                                        CSD015
     C                   PARM      WLF(Ctr)      PWLIN1                                       CSD015
     C                   PARM      *Blanks       PWLIN2                                       CSD015
     C                   PARM      *Blanks       PWLIN3                                       CSD015
     C                   PARM      *Blanks       PWLIN4                                       CSD015
     C                   PARM      *Blanks       PWLIN5                                       CSD015
     C                   PARM      *Blanks       PWLIN6                                       CSD015
     C                   PARM      ISCY          PWLCCY                                       CSD015
     C                   PARM                    WData                                        CSD015
     C                   PARM                    PWLOP2                                       CSD015
                                                                                              CSD015
     C                   IF        WData <> *BLANKS                                           CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WData:0       WXMLPacket                                   CSD015
     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WXMLPacket:0  PXMLCode                                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
     C                   ENDDO                                                                CSD015
                                                                                              CSD015
      ** Call compliance watch list engine                                                    CSD015
                                                                                              CSD015
     C                   IF        PXMLCode <> *BLANKS                                        CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    SDWLTD                                       CSD015
     C                   PARM                    PXMLCode                                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SrCvtDate - Convert dates to be used for Watch Engine Program *                       CSD015
      *                                                               *                       CSD015
      * Called by: SrWatch                                            *                       CSD015
      *                                                               *                       CSD015
      * Calls: ZaCvtDate                                              *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrCvtDate     BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALLB     'ZACVTDATE'                                                CSD015
     C                   PARM      *Blanks       Returncode                                   CSD015
     C                   PARM                    PInDate                                      CSD015
     C                   PARM                    POutDate                                     CSD015
     C                   PARM                    PCvtdDate                                    CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SrCvtAmt - Convert amounts for Watch Engine Program          *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrCvtAmt      BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALL      'ZACVTAMT'                                                 CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM                    PCurr                                        CSD015
     C                   PARM                    PInAmt                                       CSD015
     C                   PARM      0E0           PAMFLOT                                      CSD015
     C                   PARM      *ZEROS        POutAmt                                      CSD015
      *                                                                                       CSD015
     C                   EVAL      WFPDT = PAMFLot                                            CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CRE020
      **********************************************************************                  CRE020
      *                                                                    *                  CRE020
      * SrUpdAdvice - Update the Retail File Index Advice                  *                  CRE020
      *                                                                    *                  CRE020
      **********************************************************************                  CRE020
     C     SrUpdAdvice   BEGSR                                                                CRE020
                                                                                              CRE020
      ** Set Reference Key                                                                    CRE020
                                                                                              CRE020
     C                   MOVEL     NTTNBR        RREFNO                                       CRE020
     C                   EVAL      KAdvcRef = RREFNO                                          CRE020
     C                   EVAL      KAdvcPGM = RPRGMN                                          CRE020
     C                   EVAL      RTRTYP = NTTRTY                                            CRE020
                                                                                              CRE020
      ** Check READVCL1 if an entry already exists                                            CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
     C     KAdvc         CHAIN     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   IF        %FOUND(READVCL1)                                           CRE020
                                                                                              CRE020
     C                   SELECT                                                               CRE020
                                                                                              CRE020
     C                   WHEN      NTCHTP = 'A' AND TransType = 'EXTR'                        CRE020
     C                             OR NTCHTP = 'A' AND TransType <> 'EXTR'                    CRE020
     C                             AND WUpdAdvcFlg = 'Y'                                      CRE020
                                                                                              CRE020
      ** If the Transaction was just inserted, print an insert advice instead                 CRE020
      ** of an amendment to advice                                                            CRE020
                                                                                              CRE020
     C                   IF        RCHTYP <>'I' AND RSAPIN <>'N'                              CRE020
     C                             OR RCHTYP = 'I' AND RSAPIN = 'Y'                           CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   EVAL      RCHTYP = 'A'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   WHEN      NTCHTP = 'D'                                               CRE020
                                                                                              CRE020
      ** If the Transaction was just deleted before quiting maintenance,                      CRE020
      ** delete record from advice file, else, setup for a delete advice                      CRE020
                                                                                              CRE020
     C                   IF        RCHTYP = 'I' AND RSAPIN = 'N'                              CRE020
     C                   EVAL      RSAPIN = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   EVAL      RCHTYP = 'D'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C                   ENDSL                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   EVAL      RCHTYP = 'I'                                               CRE020
     C                   EVAL      RSEQNO = *BLANKS                                           CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   WRITE     READVCD0                                                   CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      **********************************************************************                  CRE020
      /EJECT                                                                                  CRE020
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the error handling subroutine,
      ** which sets a suitable return code and exits the module.
     C/COPY FFCPYSRC,ERROREXIT
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      /EJECT                                                                                  BG9042
      *****************************************************************                       BG9042
      *                                                               *                       BG9042
      * DELCLOS -  Delete corresponding close-out transaction when    *                       BG9042
      *            delete action is taken                             *                       BG9042
      *                                                               *                       BG9042
      * Calls: UTRANS                                                 *                       BG9042
      *        Otherdel                                               *                       BG9042
      *****************************************************************                       BG9042
                                                                                              BG9042
     C     DELCLOS       BEGSR                                                                BG9042
                                                                                              BG9042
     C                   Z-SUB     NTTNBR        NTTNBR                                       BG9042
     C     NTTNBR        CHAIN     TRANS                              99                      BG9042
     C     *IN99         IFEQ      '0'                                                        BG9042
     C                   EVAL      Z#BSTS = F_Trans                                           BG9042
                                                                                              BG9042
      ** Save the old version of the last change type  and date                               BG9042
     C                   EVAL      OldChgType = CHTP                                          BG9042
     C                   EVAL      OldChgDate = LCD                                           BG9042
                                                                                              BG9042
     C                   OPEN      TRSET                                                      BG9042
     C     NTTNBR        CHAIN     TRSET                              99                      BG9042
     C                   CLOSE     TRSET                                                      BG9042
     C                   EVAL      Z#WSTS = F_Settl                                           BG9042
                                                                                              BG9042
     C                   EXSR      UTRANS                                                     BG9042
     C                   EXSR      OthUpdDel                                                  BG9042
                                                                                              BG9042
     C                   END                                                                  BG9042
                                                                                              BG9042
     C                   Z-SUB     NTTNBR        NTTNBR                                       BG9042
     C                   ENDSR                                                                BG9042
      *****************************************************************                       BG9042
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Parameters returned to caller
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
 
      ** Parameters received from caller
      ** -------------------------------
      ** The format containing the valid transaction (data structure)
     C                   PARM                    ValidTrans
      ** The instrument details (data structure)
     C                   PARM                    InstType
      ** The format containing the valid settlement details (data structure)
     C                   PARM                    ValidSettl
      ** A code to indicate whether the trade is an OTC or an exchange-
      ** traded one.
     C                   PARM                    TransType
      ** New OTC instrument Y/N
     C                   PARM                    NewOTCInst        1
      ** Whether switchable feature CFF001 (Enhanced OTCs) is on in the
      ** system (1A, from SCSARDPD)
     C                   PARM                    CFF001            1
      ** General Ledger ICD (SDGELRPD data structure)
     C                   PARM                    SDGELR
      ** Midas modules (DS, from SDMMODPD)
     C                   PARM                    SDMMOD
      ** Trade and book positions reconcilable flag (1A, from SDFODAPD)
     C                   PARM                    BXTBRC            1
 
 
      ** Get the run date, date format indicator, and anything else
      ** needed from SDBANKPD
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                                       CER001
      ** Access SAR Details to determine if ULX605 is switched ON                             CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX605            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      '       '     @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX605'      @SARD                                        CER001
                                                                                              CER001
     C     @RTCD         IFEQ      *BLANK                                                     CER001
     C                   MOVEL     'Y'           ULX605                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Access SAR Details to determine if ULX004 is switched ON                             CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX004            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      '       '     @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
                                                                                              CER001
     C     @RTCD         IFEQ      *BLANK                                                     CER001
     C                   MOVEL     'Y'           ULX004                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Access SAR Details to determine if ULX043 is switched ON                             CER001
      ** ULX043 - IBLC 2002 Reporting                                                         CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX043            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      '       '     @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
                                                                                              CER001
     C     @RTCD         IFEQ      *BLANK                                                     CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** When FF API for Luxembourg and IBLC 2002 Reporting are on                            CER001
      *                                                                                       CER001
     C     ULX605        IFEQ      'Y'                                                        CER001
     C     ULX043        ANDEQ     'Y'                                                        CER001
     C                   OPEN      FFITX1L0                                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ULX605        IFEQ      'Y'                                                        CER001
     C     ULX004        ANDEQ     'Y'                                                        CER001
     C                   OPEN      FFITX2L0                                                   CER001
     C                   OPEN      ERLUICL1                                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
 
      ** Access SAR Details to determine if OTC enhancement is present
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFF003'      @SARD
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFF003
     C                   ENDIF
 
      *                                                                         CDE001
      ** Determine if Data Export for CCRM Limits is active                     CDE001
     C                   CALL      'AOSARDR0'                                   CDE001
     C                   PARM      *BLANKS       @RTCD                          CDE001
     C                   PARM      '*VERIFY'     @OPTN                          CDE001
     C                   PARM      'CDE001'      @SARD                          CDE001
      *                                                                         CDE001
     C     @RTCD         IFEQ      *BLANK                                       CDE001
     C                   MOVEL     'Y'           CDE001            1            CDE001
     C                   ENDIF                                                  CDE001
                                                                                              CFF006
      ** Access SAR Details to determine whether FF Fractional Ticks                          CFF006
      ** enhancement is installed                                                             CFF006
     C                   CALLB     'AOSARDR0'                                                 CFF006
     C                   PARM      '       '     @RTCD                                        CFF006
     C                   PARM      '*VERIFY'     @OPTN                                        CFF006
     C                   PARM      'CFF006'      @SARD                                        CFF006
                                                                                              CFF006
     C                   IF        @RTCD = *blank                                             CFF006
     C                   EVAL      CFF006 = 'Y'                                               CFF006
     C                   ELSE                                                                 CFF006
     C                   EVAL      CFF006 = 'N'                                               CFF006
     C                   ENDIF                                                                CFF006
                                                                                              CFF006
      ** Access SAR Details to determine if CFF007 is installed                               CFF007
     C                   CALLB     'AOSARDR0'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD                                        CFF007
     C                   PARM      '*VERIFY'     @OPTN                                        CFF007
     C                   PARM      'CFF007'      @SARD                                        CFF007
                                                                                              CFF007
     C                   IF        @RTCD = *blank                                             CFF007
     C                   EVAL      CFF007 = 'Y'                                               CFF007
     C                   ELSE                                                                 CFF007
     C                   EVAL      CFF007 = 'N'                                               CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CSC011
      ** Check if 24x7 Midas Availability is switched on                                      CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       @RTCD                                        CSC011
     C                   PARM      '*VERIFY'     @OPTN                                        CSC011
     C                   PARM      'CSC011'      @SARD                                        CSC011
                                                                                              CSC011
     C                   IF        @RTCD = *blank                                             CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
 
      ** Access data area SC24X7 and SDSTAT                                                   CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ENDIF                                                                CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      ** Check if Compliance Watch Enhancement (CSD015) is on                                 CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blanks       @RTCD                                        CSD015
     C                   PARM      '*VERIFY'     @OPTN                                        CSD015
     C                   PARM      'CSD015'      @SARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RTCD <> *Blanks AND                                       CSD015
     C                             @RTCD <> '*NRF   '                                         CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CSD015'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 31                                                 CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        @RTCD = *Blanks                                            CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if Concord Interface Development (CCF001) is on.                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blanks       @RTCD                                        CSD015
     C                   PARM      '*VERIFY'     @OPTN                                        CSD015
     C                   PARM      'CCF001'      @SARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank nor *NRF, then issue database error                         CSD015
                                                                                              CSD015
     C                   IF        @RTCD <> *Blanks AND                                       CSD015
     C                             @RTCD <> '*NRF   '                                         CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CCF001'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 34                                                 CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        @RTCD = *Blanks                                            CSD015
     C                   EVAL      CCF001 = 'Y'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      CCF001 = 'N'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if function code is being monitored by the compliance watch                    CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *Blanks       @RTCD                                        CSD015
     C                   PARM      '*KEY   '     @OPTN                                        CSD015
     C                   PARM      'FUTURES '    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank nor *NRF, then issue database error                         CSD015
                                                                                              CSD015
     C                   IF        @RTCD <> *Blanks AND                                       CSD015
     C                             @RTCD <> '*NRF   '                                         CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'FUTURES '                                         CSD015
     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBase = 32                                                 CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Access compliance watch configuration.                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RTCD                                        CSD015
     C                   PARM      '*FIRST '     @OPTN                                        CSD015
     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database error                                  CSD015
                                                                                              CSD015
     C                   IF        @RTCD <> *Blanks                                           CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBFILE = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBASE = 33                                                 CSD015
     C                   EVAL      DBKEY = @OPTN                                              CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if On Line Printing of Advice is on                                            CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       @RTCD                                        CRE020
     C                   PARM      '*VERIFY'     @OPTN                                        CRE020
     C                   PARM      'CRE020'      @SARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   IF        @RTCD = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
                                                                                              CRE020
      ** Check if system value for the maintenance is on                                      CRE020
                                                                                              CRE020
     C                   CALL      'AOSVALR0'                                                 CRE020
     C                   PARM                    PRtCd                                        CRE020
     C                   PARM                    PSValOTC                                     CRE020
     C                   PARM                    PSysVOTC                                     CRE020
     C                   PARM                    PSValNonOTC                                  CRE020
     C                   PARM                    PSysVNonOTC                                  CRE020
     C                   PARM                    PSValExTr                                    CRE020
     C                   PARM                    PSysVExTr                                    CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
                                                                                              CRE020
      ** Database Error for System Values File                                                CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> *Blanks AND                                       CRE020
     C                             PRtCd <> '*NRF'                                            CRE020
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBASE = 036                                                CRE020
     C                   EVAL      DBKEY = 'CRE020'                                           CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Database Error for SAR File                                                          CRE020
                                                                                              CRE020
     C                   IF        @RTCD <> *BLANKS AND                                       CRE020
     C                             @RTCD <> '*NRF'                                            CRE020
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBASE = 035                                                CRE020
     C                   EVAL      DBKEY = 'CRE020'                                           CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       @RTCD                                        CSD083
     C                   PARM      '*VERIFY'     @OPTN                                        CSD083
     C                   PARM      'CSD083'      @SARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        @RTCD <> *BLANKS AND                                       CSD083
     C                             @RTCD <> '*NRF   '                                         CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 37                                                 CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        @RTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
      **--------------------------------------------------------------------------------------------
      ** The following /COPY determines whether the Profit-Centre Accounting
      ** feature is on.  CAC003 is set to 'Y' if CAC003 is on and the
      ** Analytical Accounting module is on (BGN0ST = 'Y').
     C/COPY FFCPYSRC,CAC003CHEK
      **--------------------------------------------------------------------------------------------
 
 
      ** Key lists
      ** ---------
 
      **   LF/MEMOSM
     C     KMEMOS        KLIST
     C                   KFLD                    MMBRCA            3
     C                   KFLD                    MMCNUM
     C                   KFLD                    MMCURR            3
     C                   KFLD                    MMACOD
     C                   KFLD                    MMACSQ
 
      **   LF/PRONOM
     C     KPRONO        KLIST
     C                   KFLD                    CCYD
     C                   KFLD                    FFNOSN            2 0
 
      **   LF/POSTNC
     C     KPSTNC        KLIST
     C                   KFLD                    KBRCAC            3
     C**********         KFLD                    KCBCDC            6 0                        CSD027
     C                   KFLD                    KCBCDC            6                          CSD027
     C                   KFLD                    KISTTC            5
     C                   KFLD                    KYRNOC            2 0
     C                   KFLD                    KMTHNC            2 0
     C                   KFLD                    KPCALC            1
     C                   KFLD                    KSTRPC
 
      **   LF/POSTNK
     C     KPSTNK        KLIST
     C                   KFLD                    KBRCAK            3                           S0111
     C                   KFLD                    KBOKCK            2
     C                   KFLD                    KISTTK            5
     C                   KFLD                    KYRNOK            2 0
     C                   KFLD                    KMTHNK            2 0
     C                   KFLD                    KPCALK            1
     C                   KFLD                    KSTRPK                                        CFF00
 
      **   LF/FOPCC                                                       S01117
     C     KFPCC         KLIST                                                                 S0111
     C                   KFLD                    KBRCAO            3                           S0111
     C**********         KFLD                    KCBCDO            6 0                  S0111 CSD027
     C                   KFLD                    KCBCDO            6                          CSD027
     C                   KFLD                    KISTTO            5                           S0111
 
      **   LF/FOPCK                                                       S01117
     C     KFPCK         KLIST                                                                 S0111
     C                   KFLD                    KBRCAF            3                           S0111
     C                   KFLD                    KBOKCF            2                           S0111
     C                   KFLD                    KISTTF            5                           S0111
 
      **   LF/CLOST2
     C     KCLST2        KLIST
     C                   KFLD                    KTNBR             6 0
     C                   KFLD                    KCLON             6 0
 
      **   LF/INTYP1                                                                          CAP166
     C     KINTY1        KLIST                                                                CAP166
     C                   KFLD                    KISTI             1                          CAP166
     C                   KFLD                    KISTT             5                          CAP166
                                                                                              CAP166
      **   LF/SDCWHTL1                                                                        CSD015
     C     KCwFld        KLIST                                                                CSD015
     C                   KFLD                    WFuncType                                    CSD015
     C                   KFLD                    WIdntifier                                   CSD015
     C                   KFLD                    WBranch                                      CSD015
                                                                                              CSD015
     C     KAdvc         KLIST                                                                CRE020
     C                   KFLD                    KAdvcRef                                     CRE020
     C                   KFLD                    KAdvcPGM                                     CRE020
                                                                                              CRE020
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      ** This is the version without an ENDSR, because additional
      ** processing is added.
     C/COPY ZACPYSRC,PSSR_ILENE
 
      ** Set the return code to indicate to the caller that an
      ** error returned; do NOT call DBERRCTL, as the caller will
      ** handle rollback processing.  Also close the files which were
      ** opened under user control.
     C                   EXSR      CloseFiles
     C                   EVAL      ReturnCode = 'Error'
     C                   RETURN
 
     C                   ENDSR
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** XOT - Array for watch list fields' Opening XML Tags                                        CSD015
<Broker Settlement Account>                                                                   CSD015
<Broker For Account of>                                                                       CSD015
<Broker Counterparty>                                                                         CSD015
<Customer Settlmnt Account>                                                                   CSD015
<Customer For Account of>                                                                     CSD015
<Customer Counterparty>                                                                       CSD015
** XCT - Array for watch list fields' Closing XML Tags                                        CSD015
</Broker Settlement Account>                                                                  CSD015
</Broker For Account of>                                                                      CSD015
</Broker Counterparty>                                                                        CSD015
</Customer Settlmnt Account>                                                                  CSD015
</Customer For Account of>                                                                    CSD015
</Customer Counterparty>                                                                      CSD015

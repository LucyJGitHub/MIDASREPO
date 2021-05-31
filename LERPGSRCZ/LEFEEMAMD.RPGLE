     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee details amend checking')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFEEMAMD - Fee Amend Checking                               *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended Fee against those currently on file.      *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             It can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD031692           Date 12Mar20               *
      *  Prev Amend No. MD030856           Date 06Nov19               *
      *                 MD025529           Date 06Nov19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD022378           Date 12Sep13               *
      *                 253753             Date 16Nov12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE139             Date 06Dec10               *
      *                 262581             Date 16Jan09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CLE122             Date 05Apr07               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CAS019             Date 20Apr07               *
      *                 246405             Date 14Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245099             Date 19Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 238963             Date 28Sep06               *
      *                 BUG8896            Date 04Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9496            Date 06Dec05               *
      *                 BUG8762            Date 01Oct05               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG8086            Date 03Aug05               *
      *                 CAP084             Date 29Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031692 - Incorrect accrual when fee rate is changed on     *
      *             payment date. Issue warning message if fee rate   *
      *             change is done on payment day, which is stored in *
      *             FELPDT as fee payment is processed one day ahead. *      
      *  MD030856 - Introduce reject processing to FEEM               *
      *  MD025529 - Allow change of fee period end date if            *
      *             Advice/Confirmed = 'N'.                           *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022378 - Impossible to amend Amount/Precent Indicator      *
      *  253753 - CAS019 - additional condition on LER1217            *
      *           Applied for AR1053732 (Child: AR1053733)            *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  262581 - Redevelop CAS016 to achieve the following:          *
      *           - protect new fields when fee amortisation started; *
      *  CLE122 - Permit Early Maturity Of Non-Calculated Fees        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
      *  246405 - Not able to change a fee from non-shared to shared  *
      *  245099 - Do not validate Shared Fees Indicator flag when     *
      *           CLE006 is off.                                      *
      *  238963 - Limit issue of LER2012 for fees with payment on     *
      *           start date.  Change of autosettle indicator for fees*
      *           with payment on end should be allowed within the    *
      *           life of the fee or after if it has gone past due.   *
      *  BUG8896 - Cannot change non-auto settle to autosettle for    *
      *            non-calculated fee.                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9496- Include CAS011 changes in GZLEFEED to align valids  *
      *           file format.(Recompile)                             *
      *  BUG8762 - Amounts and rates should be amendable              *
      *  CLE031 - Lending Enhancements                                *
      *  BUG8086- Indicators are not reset, problem if same           *
      *           QZDASOINIT job is used for more than one transaction*
      *  CAP084 - Midas Plus API development.                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
     D CAS016          S              1    INZ('N')                                           CAS019
 
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
 
      * New Fee in Screen Format
     D NwFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
 
      * (Current) Fee in Screen Format
     D CrFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
     D                                     PREFIX(@@)
      * Valid Fee layout
     D ValidFeem     E DS                  EXTNAME(LEVFEEMPD)
     D                                     PREFIX(V_)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS019
      ** External DS for SAR details                                                          CAS019
      ** RUNDAT DATA AREA
     D RUNDAT          DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      *                                                                                     MD031692
     D JNSTAT          DS           200                                                     MD031692
     D  PRUN                 103    105P 0                                                  MD031692
      *                                                                                     MD031692
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D CLE122          S              1                                                       CLE122
     D PSARD           S              6                                                       CLE122
 
      ** Index for arrays of of warning message ids etc                                     MD031692
     D WIdx            S              3P 0                                                  MD031692
                                                                                            MD031692
      ** Flags to indicate whether transaction fields are valid
     D OkFee         E DS                  EXTNAME(LEEFEEMPD)
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
      *
      **  Compare fields with amended values.
      *
     C     DRejFlg       IFNE      'Y'                                                      MD030856
     C                   EXSR      COMPFLDS
     C                   ENDIF                                                              MD030856
      *
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
      *
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
      *
      *  If any errors were found:
      *  - and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLDS
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * COMPFLDS  - Compare certain fields on the current Fee         *
      *             with those amended.                               *
      *****************************************************************
     C     COMPFLDS      BEGSR
      *
      ** Set indicators used as protects in display file
      ** *IN71 = Profit centre is amendable
     C     BKPRCA        IFNE      'Y'
     C                   MOVE      *OFF          *IN71
     C                   ELSE
     C                   MOVE      *ON           *IN71
     C                   ENDIF
      *
      ** *IN77 = Start date has been reached and calc type entered
      ** *IN79 = Start date has been reached and confirmation ind is on
      ** *IN84 = Start date has been reached and pay on = S
      ** *IN85 = Start date has been reached and pay on = E
      ** *IN86 = End date has been reached.
     C     V_VFPSTD      IFLT      BJRDNB
     C     V_VFORED      ANDNE     BJRDNB
     C     V_VFAUTO      IFEQ      'Y'
     C     V_VFCALT      ANDEQ     *BLANKS
     C                   MOVE      '1'           *IN79
     C                   ELSE                                                                BUG8086
     C                   MOVE      '0'           *IN79                                       BUG8086
     C                   ENDIF
     C     V_VFPYON      IFEQ      'S'
     C                   MOVE      '1'           *IN84
     C                   ELSE                                                                BUG8086
     C                   MOVE      '0'           *IN84                                       BUG8086
     C                   ENDIF
     C     V_VFPYON      IFEQ      'E'
     C                   MOVE      '1'           *IN85
     C                   ELSE                                                                BUG8086
     C                   MOVE      '0'           *IN85                                       BUG8086
     C                   ENDIF
     C     V_VFCALT      IFNE      *BLANKS
     C                   MOVE      '1'           *IN77
     C                   ELSE                                                                BUG8086
     C                   MOVE      '0'           *IN77                                       BUG8086
     C                   ENDIF
     C     V_VFPEND      IFLT      BJRDNB
     C     V_VFAUTO      ANDNE     'N'                                                      MD025529
     C                   MOVE      '1'           *IN86
     C                   ELSE                                                                BUG8086
     C                   MOVE      '0'           *IN86                                       BUG8086
     C                   ENDIF
                                                                                              CLE122
      * For non-calculated fees and switch CLE122 is on                                       CLE122
                                                                                              CLE122
     C                   If        CLE122 = 'Y'                                               CLE122
     C                             and DDCALT = *blanks                                       CLE122
     C                   Eval      *IN86 = *Off                                               CLE122
     C                   Endif                                                                CLE122
                                                                                              CLE122
     C                   ENDIF
      *
      ** Compare Customer
     C     DDCSSN        IFNE      @@DDCSSN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCSSN'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2001'                                CAP084
     C                   EVAL      DDCSSNOK        = 'N'
     C                   ENDIF
      *
      * Compare Facility
     C     DDFACT        IFNE      @@DDFACT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFACT'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2002'                                CAP084
     C                   EVAL      DDFACTOK        = 'N'
     C                   ENDIF
 
     C     DDFCNO        IFNE      @@DDFCNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFCNO'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2003'                                CAP084
     C                   EVAL      DDFCNOOK        = 'N'
     C                   ENDIF
      *
      * Compare Loan number
     C     DDLNRF        IFNE      @@DDLNRF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLNRF'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2004'                                CAP084
     C                   EVAL      DDLNRFOK        = 'N'
     C                   ENDIF
      *
      * Compare Fee Code
     C     *IN77         IFEQ      *ON
     C     *IN84         OREQ      *ON
     C     *IN85         OREQ      *ON
     C     DDECOD        IFNE      @@DDECOD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDECOD'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2005'                                CAP084
     C                   EVAL      DDECODOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Compare Fee currency
     C     *IN77         IFEQ      *ON
     C     *IN84         OREQ      *ON
     C     *IN85         OREQ      *ON
     C     DDECUR        IFNE      @@DDECUR
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDECUR'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2006'                                CAP084
     C                   EVAL      DDECUROK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Compare Fee amount
     C     *IN77         IFEQ      *ON
     C     *IN84         OREQ      *ON
                                                                                              CAP084
     C                   CALLB     'ZCMPAMTS'                                                 CAP084
     C                   PARM      DDEAMT        ZCMPAMT1         25                          CAP084
     C                   PARM      @@DDEAMT      ZCMPAMT2         25                          CAP084
     C                   PARM      'N'           ZCMPAMTDif        1                          CAP084
                                                                                              CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                                        CAP084
     C*****DDEAMT        IFNE      @@DDEAMT                                                   CAP084
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEAMT'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2007'                                CAP084
     C                   EVAL      DDEAMTOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Compare Fee sign
     C     *IN77         IFEQ      *ON
     C     *IN84         OREQ      *ON
     C     DDESGN        IFNE      @@DDESGN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDESGN'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2008'                                CAP084
     C                   EVAL      DDESGNOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Compare Fee period start
     C     *IN77         IFEQ      *ON
     C     *IN84         OREQ      *ON
     C     *IN85         OREQ      *ON
     C     DDEPSD        IFNE      @@DDEPSD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEPSD'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2009'                                CAP084
     C                   EVAL      DDEPSDOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Compare Fee period end
     C     *IN86         IFEQ      *ON
     C     DDEPED        IFNE      @@DDEPED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEPED'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2010'                                CAP084
     C                   EVAL      DDEPEDOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Compare Payment on
     C     *IN77         IFEQ      *ON
     C     *IN84         OREQ      *ON
     C     *IN85         OREQ      *ON
     C     DDEPON        IFNE      @@DDEPON
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEPON'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2011'                                CAP084
     C                   EVAL      DDEPONOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Compare Advice confirmation indicator
     C******IN77         IFEQ      *OFF                                                      BUG8896
     C******IN79         ANDEQ     *ON                                                       BUG8896
     C     V_VFPSTD      IFLT      BJRDNB                                                    BUG8896
     C     V_VFORED      ANDNE     BJRDNB                                                    BUG8896
     C     V_VFCALT      ANDEQ     *BLANKS                                                   BUG8896
     C*****@@DDEPON      ANDNE     'N'                                                 CLE031 238963
     C     @@DDEPON      ANDEQ     'S'                                                        238963
     C     DDEADV        IFNE      @@DDEADV
     C     @@DDEADV      ANDEQ     'Y'                                                       BUG8896
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEADV'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2012'                                CAP084
     C                   EVAL      DDEADVOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Compare Shared fee
     C     CLE006        IFEQ      'Y'                                                        245099
     C     *IN77         IFEQ      *ON
     C     *IN84         OREQ      *ON
     C     *IN85         OREQ      *ON
     C     DDESHR        IFNE      @@DDESHR
      *                                                                                       246405
      * Allow amendment of shared fee indicator                                               246405
      * only if change is from 'N' or BLANKS to 'Y'                                           246405
     C     @@DDESHR      IFEQ      'Y'                                                        246405
     C     DDESHR        IFEQ      *BLANKS                                                    246405
     C     DDESHR        OREQ      'N'                                                        246405
      *                                                                                       246405
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDESHR'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2013'                                CAP084
     C                   EVAL      DDESHROK        = 'N'
      *                                                                                       246405
     C                   ENDIF                                                                246405
     C                   ENDIF                                                                246405
      *                                                                                       246405
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                245099
      *
      * Compare Calculation type
     C     *IN77         IFEQ      *ON
     C     *IN84         OREQ      *ON
     C     *IN85         OREQ      *ON
     C     DDCALT        IFNE      @@DDCALT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCALT'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2014'                                CAP084
     C                   EVAL      DDCALTOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Compare Rate 1
                                                                                              CAP084
     C**********         CALLB     'ZCMPAMTS'                                         CAP084 BUG8762
     C**********         PARM      DDRTE1        ZCMPAMT1         25                  CAP084 BUG8762
     C**********         PARM      @@DDRTE1      ZCMPAMT2         25                  CAP084 BUG8762
     C**********         PARM      'N'           ZCMPAMTDif        1                  CAP084 BUG8762
                                                                                              CAP084
     C*****ZCMPAMTDif    IFEQ      'Y'                                                CAP084 BUG8762
     C*****DDRTE1        IFNE      @@DDRTE1                                           CAP084 BUG8762
     C**********         ADD       1             Idx                                         BUG8762
     C**********         EVAL      FldNameArr(Idx) = 'DDRTE1'                                BUG8762
     C**********         EVAL      MsgIDArr(Idx)   = 'LER2015'                        CAP084 BUG8762
     C**********         EVAL      DDRTE1OK        = 'N'                                     BUG8762
     C**********         ENDIF                                                               BUG8762
      *                                                                                     MD031692
     C                   CALLB     'ZCMPAMTS'                                               MD031692
     C                   PARM      DDRTE1        ZCMPAMT1         25                        MD031692
     C                   PARM      @@DDRTE1      ZCMPAMT2         25                        MD031692
     C                   PARM      'N'           ZCMPAMTDif        1                        MD031692
      *                                                                                     MD031692
     C     ZCMPAMTDif    IFEQ      'Y'                                                      MD031692
     C     V_VFLPDT      IFEQ      BJRDNB                                                   MD031692
     C     V_VFORED      ANDLT     BJRDNB                                                   MD031692
     C     V_VFLPDT      ORGT      PRUN                                                     MD031692
     C     V_VFLPDT      ANDLT     BJDNWD                                                   MD031692
     C     V_VFORED      ANDLT     BJRDNB                                                   MD031692
     C     BKANWD        ANDEQ     '2'                                                      MD031692
     C                   ADD       1             WIdx                                       MD031692
     C                   EVAL      WFldNamArr(WIdx) = 'DDRTE1'                              MD031692
     C                   EVAL      WMsgIDArr(WIdx) = '5049999'                              MD031692
     C                   EVAL      DDRTE1OK = 'W'                                           MD031692
     C                   ENDIF                                                              MD031692
     C                   ENDIF                                                              MD031692
      *
      * Compare Amount 1
                                                                                              CAP084
     C**********         CALLB     'ZCMPAMTS'                                         CAP084 BUG8762
     C**********         PARM      DDFAMT1       ZCMPAMT1         25                  CAP084 BUG8762
     C**********         PARM      @@DDFAMT1     ZCMPAMT2         25                  CAP084 BUG8762
     C**********         PARM      'N'           ZCMPAMTDif        1                  CAP084 BUG8762
                                                                                              CAP084
     C*****ZCMPAMTDif    IFEQ      'Y'                                                CAP084 BUG8762
     C*****DDFAMT1       IFNE      @@DDFAMT1                                          CAP084 BUG8762
     C**********         ADD       1             Idx                                         BUG8762
     C**********         EVAL      FldNameArr(Idx) = 'DDFAMT1'                               BUG8762
     C**********         EVAL      MsgIDArr(Idx)   = 'LER2016'                        CAP084 BUG8762
     C**********         EVAL      DDFAMT1OK       = 'N'                                     BUG8762
     C**********         ENDIF                                                               BUG8762
      *
      * Compare Rate 2
                                                                                              CAP084
     C**********         CALLB     'ZCMPAMTS'                                         CAP084 BUG8762
     C**********         PARM      DDRTE2        ZCMPAMT1         25                  CAP084 BUG8762
     C**********         PARM      @@DDRTE2      ZCMPAMT2         25                  CAP084 BUG8762
     C**********         PARM      'N'           ZCMPAMTDif        1                  CAP084 BUG8762
                                                                                              CAP084
     C*****ZCMPAMTDif    IFEQ      'Y'                                                CAP084 BUG8762
     C*****DDRTE2        IFNE      @@DDRTE2                                           CAP084 BUG8762
     C**********         ADD       1             Idx                                         BUG8762
     C**********         EVAL      FldNameArr(Idx) = 'DDRTE2'                                BUG8762
     C**********         EVAL      MsgIDArr(Idx)   = 'LER2015'                        CAP084 BUG8762
     C**********         EVAL      DDRTE2OK        = 'N'                                     BUG8762
     C**********         ENDIF                                                               BUG8762
      *                                                                                     MD031692
     C                   CALLB     'ZCMPAMTS'                                               MD031692
     C                   PARM      DDRTE2        ZCMPAMT1                                   MD031692
     C                   PARM      @@DDRTE2      ZCMPAMT2                                   MD031692
     C                   PARM      'N'           ZCMPAMTDif                                 MD031692
      *                                                                                     MD031692
     C     ZCMPAMTDif    IFEQ      'Y'                                                      MD031692
     C     V_VFLPDT      IFEQ      BJRDNB                                                   MD031692
     C     V_VFORED      ANDLT     BJRDNB                                                   MD031692
     C     V_VFLPDT      ORGT      PRUN                                                     MD031692
     C     V_VFLPDT      ANDLT     BJDNWD                                                   MD031692
     C     V_VFORED      ANDLT     BJRDNB                                                   MD031692
     C     BKANWD        ANDEQ     '2'                                                      MD031692
     C                   ADD       1             WIdx                                       MD031692
     C                   EVAL      WFldNamArr(WIdx) = 'DDRTE2'                              MD031692
     C                   EVAL      WMsgIDArr(WIdx) = '5049999'                              MD031692
     C                   EVAL      DDRTE2OK = 'W'                                           MD031692
     C                   ENDIF                                                              MD031692
     C                   ENDIF                                                              MD031692
      *
      * Compare Amount 2
                                                                                              CAP084
     C**********         CALLB     'ZCMPAMTS'                                         CAP084 BUG8762
     C**********         PARM      DDFAMT2       ZCMPAMT1         25                  CAP084 BUG8762
     C**********         PARM      @@DDFAMT2     ZCMPAMT2         25                  CAP084 BUG8762
     C**********         PARM      'N'           ZCMPAMTDif        1                  CAP084 BUG8762
                                                                                              CAP084
     C*****ZCMPAMTDif    IFEQ      'Y'                                                CAP084 BUG8762
     C*****DDFAMT2       IFNE      @@DDFAMT2                                          CAP084 BUG8762
     C**********         ADD       1             Idx                                         BUG8762
     C**********         EVAL      FldNameArr(Idx) = 'DDFAMT2'                               BUG8762
     C**********         EVAL      MsgIDArr(Idx)   = 'LER2016'                        CAP084 BUG8762
     C**********         EVAL      DDFAMT2OK       = 'N'                                     BUG8762
     C**********         ENDIF                                                               BUG8762
      *
      * Compare Rate 3
                                                                                              CAP084
     C**********         CALLB     'ZCMPAMTS'                                         CAP084 BUG8762
     C**********         PARM      DDRTE3        ZCMPAMT1         25                  CAP084 BUG8762
     C**********         PARM      @@DDRTE3      ZCMPAMT2         25                  CAP084 BUG8762
     C**********         PARM      'N'           ZCMPAMTDif        1                  CAP084 BUG8762
                                                                                              CAP084
     C*****ZCMPAMTDif    IFEQ      'Y'                                                CAP084 BUG8762
     C*****DDRTE3        IFNE      @@DDRTE3                                           CAP084 BUG8762
     C**********         ADD       1             Idx                                         BUG8762
     C**********         EVAL      FldNameArr(Idx) = 'DDRTE3'                                BUG8762
     C**********         EVAL      MsgIDArr(Idx)   = 'LER2015'                        CAP084 BUG8762
     C**********         EVAL      DDRTE3OK        = 'N'                                     BUG8762
     C**********         ENDIF                                                               BUG8762
      *                                                                                     MD031692
     C                   CALLB     'ZCMPAMTS'                                               MD031692
     C                   PARM      DDRTE3        ZCMPAMT1                                   MD031692
     C                   PARM      @@DDRTE3      ZCMPAMT2                                   MD031692
     C                   PARM      'N'           ZCMPAMTDif                                 MD031692
      *                                                                                     MD031692
     C     ZCMPAMTDif    IFEQ      'Y'                                                      MD031692
     C     V_VFLPDT      IFEQ      BJRDNB                                                   MD031692
     C     V_VFORED      ANDLT     BJRDNB                                                   MD031692
     C     V_VFLPDT      ORGT      PRUN                                                     MD031692
     C     V_VFLPDT      ANDLT     BJDNWD                                                   MD031692
     C     V_VFORED      ANDLT     BJRDNB                                                   MD031692
     C     BKANWD        ANDEQ     '2'                                                      MD031692
     C                   ADD       1             WIdx                                       MD031692
     C                   EVAL      WFldNamArr(WIdx) = 'DDRTE3'                              MD031692
     C                   EVAL      WMsgIDArr(WIdx) = '5049999'                              MD031692
     C                   EVAL      DDRTE3OK = 'W'                                           MD031692
     C                   ENDIF                                                              MD031692
     C                   ENDIF                                                              MD031692
      *
      * Compare Amount 3
                                                                                              CAP084
     C**********         CALLB     'ZCMPAMTS'                                         CAP084 BUG8762
     C**********         PARM      DDFAMT3       ZCMPAMT1         25                  CAP084 BUG8762
     C**********         PARM      @@DDFAMT3     ZCMPAMT2         25                  CAP084 BUG8762
     C**********         PARM      'N'           ZCMPAMTDif        1                  CAP084 BUG8762
                                                                                              CAP084
     C*****ZCMPAMTDif    IFEQ      'Y'                                                CAP084 BUG8762
     C*****DDFAMT3       IFNE      @@DDFAMT3                                          CAP084 BUG8762
     C**********         ADD       1             Idx                                         BUG8762
     C**********         EVAL      FldNameArr(Idx) = 'DDFAMT3'                               BUG8762
     C**********         EVAL      MsgIDArr(Idx)   = 'LER2016'                        CAP084 BUG8762
     C**********         EVAL      DDFAMT3OK       = 'N'                                     BUG8762
     C**********         ENDIF                                                               BUG8762
      *
      * Compare Rate 4
                                                                                              CAP084
     C**********         CALLB     'ZCMPAMTS'                                         CAP084 BUG8762
     C**********         PARM      DDRTE4        ZCMPAMT1         25                  CAP084 BUG8762
     C**********         PARM      @@DDRTE4      ZCMPAMT2         25                  CAP084 BUG8762
     C**********         PARM      'N'           ZCMPAMTDif        1                  CAP084 BUG8762
                                                                                              CAP084
     C*****ZCMPAMTDif    IFEQ      'Y'                                                CAP084 BUG8762
     C*****DDRTE4        IFNE      @@DDRTE4                                           CAP084 BUG8762
     C**********         ADD       1             Idx                                         BUG8762
     C**********         EVAL      FldNameArr(Idx) = 'DDRTE4'                                BUG8762
     C**********         EVAL      MsgIDArr(Idx)   = 'LER2015'                        CAP084 BUG8762
     C**********         EVAL      DDRTE4OK        = 'N'                                     BUG8762
     C**********         ENDIF                                                               BUG8762
      *                                                                                     MD031692
     C                   CALLB     'ZCMPAMTS'                                               MD031692
     C                   PARM      DDRTE4        ZCMPAMT1                                   MD031692
     C                   PARM      @@DDRTE4      ZCMPAMT2                                   MD031692
     C                   PARM      'N'           ZCMPAMTDif                                 MD031692
      *                                                                                     MD031692
     C     ZCMPAMTDif    IFEQ      'Y'                                                      MD031692
     C     V_VFLPDT      IFEQ      BJRDNB                                                   MD031692
     C     V_VFORED      ANDLT     BJRDNB                                                   MD031692
     C     V_VFLPDT      ORGT      PRUN                                                     MD031692
     C     V_VFLPDT      ANDLT     BJDNWD                                                   MD031692
     C     V_VFORED      ANDLT     BJRDNB                                                   MD031692
     C     BKANWD        ANDEQ     '2'                                                      MD031692
     C                   ADD       1             WIdx                                       MD031692
     C                   EVAL      WFldNamArr(WIdx) = 'DDRTE4'                              MD031692
     C                   EVAL      WMsgIDArr(WIdx) = '5049999'                              MD031692
     C                   EVAL      DDRTE4OK = 'W'                                           MD031692
     C                   ENDIF                                                              MD031692
     C                   ENDIF                                                              MD031692
      *
      * Compare Amount 4
                                                                                              CAP084
     C**********         CALLB     'ZCMPAMTS'                                         CAP084 BUG8762
     C**********         PARM      DDFAMT4       ZCMPAMT1         25                  CAP084 BUG8762
     C**********         PARM      @@DDFAMT4     ZCMPAMT2         25                  CAP084 BUG8762
     C**********         PARM      'N'           ZCMPAMTDif        1                  CAP084 BUG8762
                                                                                              CAP084
     C*****ZCMPAMTDif    IFEQ      'Y'                                                CAP084 BUG8762
     C*****DDFAMT4       IFNE      @@DDFAMT4                                          CAP084 BUG8762
     C**********         ADD       1             Idx                                         BUG8762
     C**********         EVAL      FldNameArr(Idx) = 'DDFAMT4'                               BUG8762
     C**********         EVAL      MsgIDArr(Idx)   = 'LER2016'                        CAP084 BUG8762
     C**********         EVAL      DDFAMT4OK       = 'N'                                     BUG8762
     C**********         ENDIF                                                               BUG8762
      *
      * Compare Rate 5
                                                                                              CAP084
     C**********         CALLB     'ZCMPAMTS'                                         CAP084 BUG8762
     C**********         PARM      DDRTE5        ZCMPAMT1         25                  CAP084 BUG8762
     C**********         PARM      @@DDRTE5      ZCMPAMT2         25                  CAP084 BUG8762
     C**********         PARM      'N'           ZCMPAMTDif        1                  CAP084 BUG8762
                                                                                              CAP084
     C*****ZCMPAMTDif    IFEQ      'Y'                                                CAP084 BUG8762
     C*****DDRTE5        IFNE      @@DDRTE5                                           CAP084 BUG8762
     C**********         ADD       1             Idx                                         BUG8762
     C**********         EVAL      FldNameArr(Idx) = 'DDRTE5'                                BUG8762
     C**********         EVAL      MsgIDArr(Idx)   = 'LER2015'                        CAP084 BUG8762
     C**********         EVAL      DDRTE5OK        = 'N'                                     BUG8762
     C**********         ENDIF                                                               BUG8762
      *                                                                                     MD031692
     C                   CALLB     'ZCMPAMTS'                                               MD031692
     C                   PARM      DDRTE5        ZCMPAMT1                                   MD031692
     C                   PARM      @@DDRTE5      ZCMPAMT2                                   MD031692
     C                   PARM      'N'           ZCMPAMTDif                                 MD031692
      *                                                                                     MD031692
     C     ZCMPAMTDif    IFEQ      'Y'                                                      MD031692
     C     V_VFLPDT      IFEQ      BJRDNB                                                   MD031692
     C     V_VFORED      ANDLT     BJRDNB                                                   MD031692
     C     V_VFLPDT      ORGT      PRUN                                                     MD031692
     C     V_VFLPDT      ANDLT     BJDNWD                                                   MD031692
     C     V_VFORED      ANDLT     BJRDNB                                                   MD031692
     C     BKANWD        ANDEQ     '2'                                                      MD031692
     C                   ADD       1             WIdx                                       MD031692
     C                   EVAL      WFldNamArr(WIdx) = 'DDRTE5'                              MD031692
     C                   EVAL      WMsgIDArr(WIdx) = '5049999'                              MD031692
     C                   EVAL      DDRTE5OK = 'W'                                           MD031692
     C                   ENDIF                                                              MD031692
     C                   ENDIF                                                              MD031692
      *
      * Compare Amount 5
                                                                                              CAP084
     C**********         CALLB     'ZCMPAMTS'                                         CAP084 BUG8762
     C**********         PARM      DDFAMT5       ZCMPAMT1         25                  CAP084 BUG8762
     C**********         PARM      @@DDFAMT5     ZCMPAMT2         25                  CAP084 BUG8762
     C**********         PARM      'N'           ZCMPAMTDif        1                  CAP084 BUG8762
                                                                                              CAP084
     C*****ZCMPAMTDif    IFEQ      'Y'                                                CAP084 BUG8762
     C*****DDFAMT5       IFNE      @@DDFAMT5                                          CAP084 BUG8762
     C**********         ADD       1             Idx                                         BUG8762
     C**********         EVAL      FldNameArr(Idx) = 'DDFAMT5'                               BUG8762
     C**********         EVAL      MsgIDArr(Idx)   = 'LER2016'                        CAP084 BUG8762
     C**********         EVAL      DDFAMT5OK        = 'N'                                    BUG8762
     C**********         ENDIF                                                               BUG8762
      *
      * Compare Percentage indicator
      *                                                                                     MD022378
     C                   MOVEL     'N'           W@SKIPC           1                        MD022378
     C                   IF        (DDCALT = '03' OR                                        MD022378
     C                             DDCALT  = '06' OR                                        MD022378
     C                             DDCALT  = '13' OR                                        MD022378
     C                             DDCALT  = '16' OR                                        MD022378
     C                             DDCALT  = '21' OR                                        MD022378
     C                             DDCALT  = '22') AND                                      MD022378
     C                             (DDPIND = 'A' OR                                         MD022378
     C                             DDPIND = *BLANKS) AND                                    MD022378
     C                             (@@DDPIND = 'A' OR                                       MD022378
     C                             @@DDPIND  = *BLANKS)                                     MD022378
     C                   MOVEL     'Y'           W@SKIPC                                    MD022378
     C                   ENDIF                                                              MD022378
                                                                                            MD022378
     C                   IF        W@SKIPC <> 'Y'                                           MD022378
     C     DDPIND        IFNE      @@DDPIND
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPIND'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2017'                                CAP084
     C                   EVAL      DDPINDOK        = 'N'
     C                   ENDIF
     C                   ENDIF                                                              MD022378
      *
      * Compare Calculation basis
     C     *IN77         IFEQ      *ON
     C     DDCALC        IFNE      @@DDCALC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCALC'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2018'                                CAP084
     C                   EVAL      DDCALCOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Compare Exchange rate
     C     *IN77         IFEQ      *ON
                                                                                              CAP084
     C                   CALLB     'ZCMPAMTS'                                                 CAP084
     C                   PARM      DDEXRT        ZCMPAMT1         25                          CAP084
     C                   PARM      @@DDEXRT      ZCMPAMT2         25                          CAP084
     C                   PARM      'N'           ZCMPAMTDif        1                          CAP084
                                                                                              CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                                        CAP084
     C*****DDEXRT        IFNE      @@DDEXRT                                                   CAP084
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEXRT'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2019'                                CAP084
     C                   EVAL      DDEXRTOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Compare Mult/Div indicator
     C     *IN77         IFEQ      *ON
     C     DDMDIN        IFNE      @@DDMDIN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDIN'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2020'                                CAP084
     C                   EVAL      DDMDINOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Compare Next payment date
     C     *IN84         IFEQ      *ON
     C     DDNPYD        IFNE      @@DDNPYD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNPYD'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2021'                                CAP084
     C                   EVAL      DDNPYDOK        = 'N'
     C                   ENDIF
      *
      * Compare Frequency
     C     DDFREQ        IFNE      @@DDFREQ
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFREQ'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2022'                                CAP084
     C                   EVAL      DDFREQOK        = 'N'
     C                   ENDIF
      *
      * Compare Day in month
     C     DDDYIM        IFNE      @@DDDYIM
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDYIM'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2023'                                CAP084
     C                   EVAL      DDDYIMOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Compare Profit centre
     C     *IN71         IFEQ      *OFF
     C     DDPRFC        IFNE      @@DDPRFC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPRFC'
     C                   EVAL      MsgIDArr(Idx)   = 'LER2024'                                CAP084
     C                   EVAL      DDPRFCOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ***If*Error*set-up*error*message*&*write*details*to*Invalid*file*                       CAP084
     C*****Idx**         IFNE      0                                                          CAP084
     C**********         EVAL      MsgIDArr(Idx)   = 'LEA1043'                                CAP084
     C**********         ENDIF                                                                CAP084
      *                                                                                       CAS019
     C                   IF        (CAS016 = 'Y')                                             CAS019
                                                                                              CAS019
     C     V_VFPSTD      IFLT      BJRDNB                                                     CAS019
     C     V_VFORED      ANDNE     BJRDNB                                                     CAS019
      * Compare Amortised Seperately Indicator                                                CAS019
     C     DDAMRI        IFEQ      'N'                                                        253753
     C     @@DDAMRI      ANDEQ     *BLANKS                                                    253753
      * Don't do this check as BLANKS and N are the same                                      253753
     C                   ELSE                                                                 253753
      *                                                                                       253753
     C     DDAMRI        IFNE      @@DDAMRI                                                   CAS019
     C                   ADD       1             Idx                                          CAS019
     C                   EVAL      FldNameArr(Idx) = 'DDAMRI'                                 CAS019
     C                   EVAL      MsgIDArr(Idx)   = 'LER1217'                                CAS019
     C                   EVAL      DDAMRIOK        = 'N'                                      CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                253753
      * Compare Amortise Start Period                                                         262581
     C     DDSTPD        IFNE      @@DDSTPD                                                   262581
     C                   ADD       1             Idx                                          262581
     C                   EVAL      FldNameArr(Idx) = 'DDSTPD'                                 262581
     C                   EVAL      MsgIDArr(Idx)   = 'LER1217'                                262581
     C                   EVAL      DDSTPDOK        = 'N'                                      262581
     C                   ENDIF                                                                262581
      * Compare Amortise End Period                                                           262581
     C     DDENPD        IFNE      @@DDENPD                                                   262581
     C                   ADD       1             Idx                                          262581
     C                   EVAL      FldNameArr(Idx) = 'DDENPD'                                 262581
     C                   EVAL      MsgIDArr(Idx)   = 'LER1217'                                262581
     C                   EVAL      DDENPDOK        = 'N'                                      262581
     C                   ENDIF                                                                262581
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C                   ENDIF                                                                CAS019
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLDS - Reset fields in Error                             *
      *****************************************************************
     C     RESETFLDS     BEGSR
      *
      * Reset fields in error to 'current' values
      *
      * Customer
     C     DDCSSNOK      IFEQ      'N'
     C                   MOVEL     @@DDCSSN      DDCSSN
     C                   ENDIF
      *
      * Facility
     C     DDFACTOK      IFEQ      'N'
     C                   MOVEL     @@DDFACT      DDFACT
     C                   ENDIF
 
     C     DDFCNOOK      IFEQ      'N'
     C                   MOVEL     @@DDFCNO      DDFCNO
     C                   ENDIF
 
      * Loan number
     C     DDLNRFOK      IFEQ      'N'
     C                   MOVEL     @@DDLNRF      DDLNRF
     C                   ENDIF
 
      * Fee Code
     C     DDECODOK      IFEQ      'N'
     C                   MOVEL     @@DDECOD      DDECOD
     C                   ENDIF
 
      * Fee currency
     C     DDECUROK      IFEQ      'N'
     C                   MOVEL     @@DDECUR      DDECUR
     C                   ENDIF
 
      * Fee amount
     C     DDEAMTOK      IFEQ      'N'
     C                   MOVEL     @@DDEAMT      DDEAMT
     C                   ENDIF
 
      * Fee sign
     C     DDESGNOK      IFEQ      'N'
     C                   MOVEL     @@DDESGN      DDESGN
     C                   ENDIF
 
      * Fee period start
     C     DDEPSDOK      IFEQ      'N'
     C                   MOVEL     @@DDEPSD      DDEPSD
     C                   ENDIF
 
      * Fee period end
     C     DDEPEDOK      IFEQ      'N'
     C                   MOVEL     @@DDEPED      DDEPED
     C                   ENDIF
 
      * Payment on
     C     DDEPONOK      IFEQ      'N'
     C                   MOVEL     @@DDEPON      DDEPON
     C                   ENDIF
 
      * Advice confirmation indicator
     C     DDEADVOK      IFEQ      'N'
     C                   MOVEL     @@DDEADV      DDEADV
     C                   ENDIF
 
      * Shared fee
     C     DDESHROK      IFEQ      'N'
     C                   MOVEL     @@DDESHR      DDESHR
     C                   ENDIF
 
      * Calculation type
     C     DDCALTOK      IFEQ      'N'
     C                   MOVEL     @@DDCALT      DDCALT
     C                   ENDIF
 
      * Rate 1
     C     DDRTE1OK      IFEQ      'N'
     C                   MOVEL     @@DDRTE1      DDRTE1
     C                   ENDIF
 
      * Amount 1
     C     DDFAMT1OK     IFEQ      'N'
     C                   MOVEL     @@DDFAMT1     DDFAMT1
     C                   ENDIF
 
      * Rate 2
     C     DDRTE2OK      IFEQ      'N'
     C                   MOVEL     @@DDRTE2      DDRTE2
     C                   ENDIF
 
      * Amount 2
     C     DDFAMT2OK     IFEQ      'N'
     C                   MOVEL     @@DDFAMT2     DDFAMT2
     C                   ENDIF
 
      * Rate 3
     C     DDRTE3OK      IFEQ      'N'
     C                   MOVEL     @@DDRTE3      DDRTE3
     C                   ENDIF
 
      * Amount 3
     C     DDFAMT3OK     IFEQ      'N'
     C                   MOVEL     @@DDFAMT3     DDFAMT3
     C                   ENDIF
 
      * Rate 4
     C     DDRTE4OK      IFEQ      'N'
     C                   MOVEL     @@DDRTE4      DDRTE4
     C                   ENDIF
 
      * Amount 4
     C     DDFAMT4OK     IFEQ      'N'
     C                   MOVEL     @@DDFAMT4     DDFAMT4
     C                   ENDIF
 
      * Rate 5
     C     DDRTE5OK      IFEQ      'N'
     C                   MOVEL     @@DDRTE5      DDRTE5
     C                   ENDIF
 
      * Amount 5
     C     DDFAMT5OK     IFEQ      'N'
     C                   MOVEL     @@DDFAMT5     DDFAMT5
     C                   ENDIF
 
      * Percentage indicator
     C     DDPINDOK      IFEQ      'N'
     C                   MOVEL     @@DDPIND      DDPIND
     C                   ENDIF
 
      * Calculation basis
     C     DDCALCOK      IFEQ      'N'
     C                   MOVEL     @@DDCALC      DDCALC
     C                   ENDIF
 
      * Exchange rate
     C     DDEXRTOK      IFEQ      'N'
     C                   MOVEL     @@DDEXRT      DDEXRT
     C                   ENDIF
 
      * Mult/Div indicator
     C     DDMDINOK      IFEQ      'N'
     C                   MOVEL     @@DDMDIN      DDMDIN
     C                   ENDIF
 
      * Next payment date
     C     DDNPYDOK      IFEQ      'N'
     C                   MOVEL     @@DDNPYD      DDNPYD
     C                   ENDIF
 
      * Frequency
     C     DDFREQOK      IFEQ      'N'
     C                   MOVEL     @@DDFREQ      DDFREQ
     C                   ENDIF
 
      * Day in month
     C     DDDYIMOK      IFEQ      'N'
     C                   MOVEL     @@DDDYIM      DDDYIM
     C                   ENDIF
 
      * Profit centre
     C     DDPRFCOK      IFEQ      'N'
     C                   MOVEL     @@DDPRFC      DDPRFC
     C                   ENDIF
                                                                                              CAS019
      ** Reset fields affected by CAS019                                                      CAS019
     C                   IF        (CAS016 = 'Y')                                             CAS019
                                                                                              CAS019
                                                                                              CAS019
      * Amortise seperately indicator                                                         CAS019
     C                   IF        (DDAMRIOK = 'N')                                           CAS019
     C                   EVAL      DDAMRI = @@DDAMRI                                          CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
      * Amortisation Start Period                                                             CAS019
     C                   IF        (DDSTPDOK = 'N')                                           CAS019
     C                   EVAL      DDSTPD = @@DDSTPD                                          CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
      * Amortisation End Period                                                               CAS019
     C                   IF        (DDENPDOK = 'N')                                           CAS019
     C                   EVAL      DDENPD = @@DDENPD                                          CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C                   ENDIF                                                                CAS019
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * New Fee in Screen Format
     C                   PARM                    NwFeScnFmt
      *
      * Current Fee in Screen Format
     C                   PARM                    CrFeScnFmt
      *
      * Fee in file format
     C                   PARM                    ValidFeem
      *
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OkFee
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
                                                                                              245099
     C                   PARM                    CLE006            1                          245099
     C                   PARM                    DRejFlg           1                        MD030856
      *                                                                                     MD031692
      ** Warning fields/message IDs/message data (arrays) from/to caller                    MD031692
      *                                                                                     MD031692
     C                   PARM                    WFldNamArr                                 MD031692
     C                   PARM                    WMsgIDArr                                  MD031692
     C                   PARM                    WMsgDtaArr                                 MD031692
      *                                                                                     MD031692
      ** Array index (3P0) from/to caller                                                   MD031692
      *                                                                                     MD031692
     C                   PARM                    WIdx                                       MD031692     
      *
      ** Initialize program name
      *
     C                   MOVEL     'LEFEEMAMD'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      *PSSR                                        *************
     C                   END
                                                                                              CLE122
      **  Access SAR details to see if CLE122 is switched on.                                 CLE122
                                                                                              CLE122
     C                   Eval      CLE122 = 'N'                                               CLE122
     C                   Call      'AOSARDR0'                                                 CLE122
     C                   Parm      *BLANKS       @RTCD                                        CLE122
     C                   Parm      '*VERIFY'     @OPTN                                        CLE122
     C                   Parm      'CLE122'      PSARD                                        CLE122
     C     SCSARD        Parm      SCSARD        DSFDY                                        CLE122
                                                                                              CLE122
     C                   If        @RTCD = *BLANKS                                            CLE122
     C                   Eval      CLE122 = 'Y'                                               CLE122
     C                   Else                                                                 CLE122
                                                                                              CLE122
      ** Database error                                                                       CLE122
                                                                                              CLE122
     C                   If        @RTCD <> '*NRF'                                            CLE122
     C                   Eval      DBKEY = 'CLE122'                                           CLE122
     C                   Eval      DBFILE = 'SCSARDPD'                                        CLE122
     C                   Eval      DBASE = 902                                                CLE122
     C                   Exsr      *PSSR                                                      CLE122
     C                   Endif                                                                CLE122
     C                   Endif                                                                CLE122
                                                                                              CAS019
      **  Access SAR details to see if CAS016 is switched on.                                 CAS019
                                                                                              CAS019
     C                   CALL      'AOSARDR0'                                                 CAS019
     C                   PARM      *BLANKS       @RTCD                                        CAS019
     C                   PARM      '*VERIFY'     @OPTN                                        CAS019
     C                   PARM      'CAS016'      PSARD             6                          CAS019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS019
                                                                                              CAS019
     C                   IF        (@RTCD = *BLANKS)                                          CAS019
     C                   EVAL      CAS016 = 'Y'                                               CAS019
     C                   ELSE                                                                 CAS019
                                                                                              CAS019
      ** Database error                                                                       CAS019
                                                                                              CAS019
     C                   IF        (@RTCD <> '*NRF')                                          CAS019
     C     *LOCK         IN        LDA                                                        CAS019
     C                   EVAL      DBKey = 'CAS016'                                           CAS019
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS019
     C                   EVAL      DBase = 912                                                CAS019
     C                   EXSR      *PSSR                                                      CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C                   ENDIF                                                                CAS019
      *
     C     *DTAARA       DEFINE                  RUNDAT
      *
      **  GET MBIN FROM DTAARA/RUNDAT
     C                   IN        RUNDAT
      *                                                                                     MD031692
      ** Get PRUN from data area JNSTAT                                                     MD031692
      *                                                                                     MD031692
     C     *DTAARA       DEFINE                  JNSTAT                                     MD031692
     C                   IN        JNSTAT                                                   MD031692
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL New FCCY IN/EX Trans Extract')                *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  RPGLE/GL201001 - Midas GL New FCCY Income/Expense            *
      *                   Transfer Extract                            *
      *                                                               *
      *  Called from: Program GLC201001                               *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. CGL201 *Create     Date 22Sep23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL201 - New Reports for Daily Transfer of Foreign Exchange  *
      *                                                               *
      *****************************************************************
      * Midas GL Transfer of foreign currency i/e to base
     FGEXFPD    IF   E             DISK    INFSR(*PSSR)
      * Midas GL Today's Transfer Postings
     FGLTFRPL0  UF A E           K DISK    INFSR(*PSSR)
      * Midas GL Daily Transfer Postings
     FGLACTPPD  O    E             DISK    INFSR(*PSSR)
      * Midas GL Month/Year to date Balances
     FGLMTDBL0  UF A E           K DISK    INFSR(*PSSR)

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

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+

      *****************************************************************

      ** Access Object parameter fields
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * External data structure for currency codes

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      ** Paramaters for ZCONVZ1
     D ZAMTCI          S             15  0
     D ZEXCH           S             13  8
     D ZMD             S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0

      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+

      /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      * Main Processing                                               *
      *                                                               *
      *---------------------------------------------------------------*

      *
      **  Reset Month to Date Balance if first working day of the month
     C                   Exsr      SrResetBal
      *
      **  Update Today's Transfer Postings
     C                   Exsr      SrUpdToday
      *
      **  Update Month/Year to Date Balances
     C                   Exsr      SrUpdMTD
      *
      **  Update Daily Transfer Postings
     C                   Exsr      SrUpdDaily
      * Exit from Program
     C                   Seton                                        LR
     C                   Return

       /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      * SrResetBal - Reset Balance and Clear Daily Posting File       *
      * Called by: Main                                               *
      * Calls: None                                                   *
      *                                                               *
      *---------------------------------------------------------------*
     C     SrResetBal    Begsr
      *
      ** Check if first working day of the month
     C                   Eval      BOM = *Blanks
     C                   Call      'CB0812'
     C                   Parm      ' '           BOM               1
     C                   Parm      'F'           RTN               1
      *
      ** Check if first working day of the year
     C                   Eval      BOY = *Blanks
     C                   Call      'CB000201'
     C                   Parm      ' '           BOY               1
     C                   Parm      'F'           RTN
      *
      ** Clear files and reset balances if beginning of the month or year
     C                   If        BOM = 'Y' or BOY = 'Y'
      *
      ** Reset Month/Year to Date Balances
     C     *loval        Setll     GLMTDBL0
     C                   Read      GLMTDBL0
     C                   Dow       Not(%EOF(GLMTDBL0))
      *
      ** If Beginning of Month, reset MTD balances
     C                   If        BOM = 'Y'
     C                   Eval      TMMTDA = *Zeros
     C                   Endif
      *
      ** If Beginning of Year, reset YTD balances
     C                   If        BOY = 'Y'
     C                   Eval      TMYTDA = *Zeros
     C                   Endif
      *
     C                   Update    GLMTDBD0
     C                   Read      GLMTDBL0
     C                   Enddo
     C                   Endif
      *
     C                   Endsr

      /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      * SrUpdToday - Update Today's Transfer Postings                 *
      * Called by: Main                                               *
      * Calls: None                                                   *
      *                                                               *
      *---------------------------------------------------------------*
     C     SrUpdToday    Begsr
      *
      ** Read all IN/EX transfer Posting for Today
     C     1             Setll     GEXFPD
     C                   Read      GEXFPD
     C                   Dow       Not(%EOF(GEXFPD))
      *
      ** If it is a foreign currency and an Income/Expense Account
     C                   If        CCY <> BJCYCD
     C                             and (ACSC ='IN' or ACSC = 'EX')
      *
      ** If it is a Credit Posting, it means it a debit posting since the GEXFPD record is
      ** the opposite of the balance.
     C                   If        DRCR = 1
     C                   Z-Sub     PSTA          PSTA
     C                   Endif
     C                   Eval      TDBRCA = BRCA
     C                   Eval      TDCCY  = CCY
     C                   Eval      TDACOD = ACOD
      *
     C     K_GLTFRP      Chain     GLTFRPL0
     C                   If        %Found(GLTFRPL0)
     C                   Eval      TDPSTA = TDPSTA + PSTA
     C                   Update    GLTFRPD0
      *
     C                   Else
     C                   Eval      TDBRCA = BRCA
     C                   Eval      TDCCY  = CCY
     C                   Eval      TDACOD = ACOD
     C                   Eval      TDPSTA = PSTA
     C                   Write     GLTFRPD0
     C                   Endif
     C                   Endif
     C                   Read      GEXFPD
     C                   Enddo
      *
     C                   Endsr
      /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      * SrUpdMTD - Update Month/Year to Date Balances                 *
      * Called by: Main                                               *
      * Calls: None                                                   *
      *                                                               *
      *---------------------------------------------------------------*
     C     SrUpdMTD      Begsr
      *
      ** Read all IN/EX transfer Posting for Today
     C     *loval        Setll     GLTFRPL0
     C                   Read      GLTFRPL0
     C                   Dow       Not(%EOF(GLTFRPL0))
      *
     C                   If        TDCCY <> BJCYCD
      *
     C     K_GLTFRP      Chain     GLMTDBL0
     C                   If        %Found(GLMTDBL0)
     C                   Eval      TMMTDA = TMMTDA + TDPSTA
     C                   Eval      TMYTDA = TMYTDA + TDPSTA
     C                   Update    GLMTDBD0
     C                   Else
     C                   Eval      TMBRCA = TDBRCA
     C                   Eval      TMCCY  = TDCCY
     C                   Eval      TMACOD = TDACOD
     C                   Eval      TMMTDA = TDPSTA
     C                   Eval      TMYTDA = TDPSTA
     C                   Write     GLMTDBD0
     C                   Endif
      *
     C                   Endif
      *
     C                   Read      GLTFRPL0
     C                   Enddo
     C                   Endsr
      /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      * SrUpdDaily - Update Daily Transfer Postings                   *
      * Called by: Main                                               *
      * Calls: None                                                   *
      *                                                               *
      *---------------------------------------------------------------*
     C     SrUpdDaily    Begsr
      *
      ** Read all IN/EX transfer Posting for Today
     C     *loval        Setll     GLTFRPL0
     C                   Read      GLTFRPL0
     C                   Dow       Not(%EOF(GLTFRPL0))
      *
     C                   If        TDCCY <> BJCYCD
      *
      ** Get Posting Currency Details
     C                   Call      'AOCURRR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      TDCCY         @AJD              3
     C     SDCurr        Parm      SDCurr        DSSDY
      *
     C                   Move      A6MDIN        ZMD
     C                   Move      A6NBDP        ZCDPI
     C                   Z-Add     A6SPRT        ZEXCH
     C                   Z-Add     TDPSTA        ZAMTCI
      *
      ** Call ZCONVZ1 to convert amounts
     C                   Call      'ZCONVZ1'
     C                   Parm                    ZAMTCI
     C                   Parm                    ZEXCH
     C                   Parm                    ZMD
     C                   Parm      TDCCY         ZCCYI
     C                   Parm      BJCYCD        ZCCYO
     C                   Parm                    ZCDPI
     C                   Parm                    ZCDPO
     C                   Parm                    ZAMTCO
      *
     C                   Move      TDBRCA        TFBRCA
     C                   Move      TDCCY         TFCCY
     C                   Move      TDACOD        TFACOD
     C                   Z-Add     BJRDNB        TFVALD
     C                   Z-Add     TDPSTA        TFPSTA
     C                   Z-Add     *Zeros        TFMTDA
     C                   Z-Add     *Zeros        TFYTDA
     C                   Z-Add     ZAMTCO        TFBSTA
     C                   Z-Add     A6SPRT        TFSPOT
      *
     C     K_GLTFRP      Chain     GLMTDBL0
     C                   If        %Found(GLMTDBL0)
     C                   Z-Add     TMMTDA        TFMTDA
     C                   Z-Add     TMYTDA        TFYTDA
     C                   Endif
      *
     C                   Write     GLACTPD0
      *
     C                   Endif
      *
     C                   Read      GLTFRPL0
     C                   Enddo
     C                   Endsr
      /EJECT
      *
      *---------------------------------------------------------------*
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      * Called by: Main processing                                    *
      * Calls: None                                                   *
      *                                                               *
      *---------------------------------------------------------------*
     C     *Inzsr        Begsr

     C     K_GLTFRP      KList
     C                   KFLD                    TDBRCA
     C                   KFLD                    TDCCY
     C                   KFLD                    TDACOD

      ** Access Bank Details
      *
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C                   If         @RTCD <> *BLANKS
     C                   Movel     'SDBANKPD'    DBFILE
     C                   Movel     '901'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   Call      'AOCURRR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      BJCYCD        @AJD              3
     C     SDCurr        Parm      SDCurr        DSSDY
     C                   Move      A6NBDP        ZCDPO

     C                   Endsr
     C****************************************************************
      /EJECT
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound Call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILEB
      /EJECT
**  CPY@
(c) Finastra International Limited 2023

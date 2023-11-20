     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Today's Base CCY IN/EX Postings Extract')     *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  RPGLE/GL201004 - Midas GL Today's Base CCY IN/EX Postings    *
      *                   Extract                                     *
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
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *  60 - End of File                                             *
      *                                                               *
      *****************************************************************
      /EJECT
      ** Midas GL Account journal postings 1
     FGLAPSTL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL Today's Transfer Postings
     FGLTFRPL0  UF A E           K DISK    INFSR(*PSSR)

      ** Midas GL Daily Transfer Postings
     FGLACTPPD  O    E             DISK    INFSR(*PSSR)

      ** Midas GL Month/Year to date Balances
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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the dbase err
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+

      *****************************************************************

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank ICD details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure

      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+

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
      ** Update Today's Transfer Postings
     C                   Exsr      SrUpdToday
      *
      ** Update Month/Year to Date Balances
     C                   Exsr      SrUpdMTD
      *
      ** Update Daily Transfer Postings
     C                   Exsr      SrUpdDaily
      *
      ** Exit from Program
     C                   Seton                                        LR
     C                   Return

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
     C     *Loval        Setll     GLAPSTL1
     C                   Read      GLAPSTL1
      *
     C                   Dow       Not(%EOF(GLAPSTL1))
      *
      ** If it is base currency and an Income/Expense Account
     C                   If        CCY = BJCYCD
     C                             and (ACSC ='IN' or ACSC = 'EX')
      *
     C                   If        DRCR = 0
     C                   Z-Sub     PSTA          PSTA
     C                   Endif
      *
     C                   Eval      TDBRCA = BRCA
     C                   Eval      TDCCY  = CCY
     C                   Eval      TDACOD = ACOD
      *
     C     K_GLTFRP      Chain     GLTFRPL0
     C                   If        %Found(GLTFRPL0)
     C                   Eval      TDPSTA = TDPSTA + PSTA
     C                   Update    GLTFRPD0
     C                   Else
     C                   Eval      TDBRCA = BRCA
     C                   Eval      TDCCY  = CCY
     C                   Eval      TDACOD = ACOD
     C                   Eval      TDPSTA = PSTA
     C                   Write     GLTFRPD0
     C                   Endif
      *
     C                   Endif
      *
     C                   Read      GLAPSTL1
      *
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
      *
     C                   Dow       Not(%EOF(GLTFRPL0))
      *
     C                   If        TDCCY = BJCYCD
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
      *
     C                   Enddo
      *
     C                   Endsr
      /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      *  SrUpdDaily - Update Daily Transfer Postings                  *
      *  Called by: Main                                              *
      *  Calls: None                                                  *
      *                                                               *
      *---------------------------------------------------------------*
     C     SrUpdDaily    Begsr
      *
      ** Read all IN/EX transfer Posting for Today
     C     *loval        Setll     GLTFRPL0
     C                   Read      GLTFRPL0
      *
     C                   Dow       Not(%EOF(GLTFRPL0))
      *
     C                   If        TDCCY = BJCYCD
      *
     C                   Move      TDBRCA        TFBRCA
     C                   Move      TDCCY         TFCCY
     C                   Move      TDACOD        TFACOD
     C                   Z-Add     BJRDNB        TFVALD
     C                   Z-Add     TDPSTA        TFPSTA
     C                   Z-Add     *Zeros        TFMTDA
     C                   Z-Add     *Zeros        TFYTDA
     C                   Z-Add     TDPSTA        TFBSTA
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
      *
     C                   Enddo
      *
     C                   Endsr
      /EJECT
      *
      *---------------------------------------------------------------*
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *  Called by: Main processing                                   *
      *  Calls: None                                                  *
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
      ** Database error
     C                   If         @RTCD <> *BLANKS
     C                   Movel     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   Call      'AOCURRR0'
     C                   Parm      *BLANKS       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      BJCYCD        @AJD              3
     C     SDCurr        Parm      SDCurr        DSSDY
      *
     C                   If         @RTCD <> *BLANKS
     C                   Movel     'SDCURRPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   Endif

     C                   Endsr
      *****************************************************************
      /EJECT
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound Call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILEB
      /EJECT
** CPY@
(c) Finastra International Limited 2023

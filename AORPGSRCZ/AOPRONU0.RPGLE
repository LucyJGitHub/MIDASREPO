     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Update Prono file')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects Module                                *
      *                                                               *
      *  AOPRONU0 - Update Prono file                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD031382           Date 11Dec14               *
      *  Prev Amend No. MD026169  *REWRITE Date 09Apr14               *
      *                 MD025679B          Date 26Mar14               *
      *                 AR868380           Date 10Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 193403             Date 17Jul01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002             Date 01May98               *
      *                 058129             Date 19JUL93               *
      *                 041693             DATE 05JAN93               *
      *                 045014             DATE 01DEC92               *
      *                 031876             DATE 03NOV92               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031382 - Amount is reflected on the Projected Mov. Column  *
      *             (Recompile)                                       *
      *  MD026169 - GO_ONL_OLP background job is processing           *
      *             full receiver chain                               *
      *  MD025679B- Rewrite. Optimized code was move to AOPRONU1.     *
      *           - API - PRONO Locking Issue.                        *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  193403 - Reverse deal that value/mature on holiday, amounts  *
      *           are taken from the wrong day causing incorrect      *
      *           projected closing balance.                          *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
      *                                                               *
      *  058129 - Correct parameters to SZDATE3 and error proc.       *
      *                                                               *
      *  041693 - Delivered as part of fix.                           *
      *                                                               *
      *  045014 - Add call to AOCNTLR0 for access control             *
      *                                                               *
      *  031876 - New program to update Prono file for shadow         *
      *           post.                                               *
      *                                                               *
      *****************************************************************
     FGLPRONL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *****************************************************************
      **
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **----------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **----------------------------------------------------------------
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      *
      ** Entry parameter
      *
     D W0RTN           S              7A
     D W0KEY#          S                         LIKE( PRKEY )
     D W0VDAT          S                         LIKE( PRVDAT )
     D W0AMT           S                         LIKE( PRAMT )
      /EJECT
      *****************************************************************
      * MAIN - Main body                                              *
      *****************************************************************
      *
     C                   MOVE      W0KEY#        PRKEY
     C                   Z-ADD     W0VDAT        PRVDAT
     C                   Z-ADD     W0AMT         PRAMT
      *
     C                   WRITE(E)  GLPRONT0
      *
     C                   IF        %ERROR
     C                   EVAL      W0RTN = '*ERROR'
     C                   EVAL      DBFILE = 'GLPRONL0'
     C                   EVAL      DBKEY = PRKEY
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
      * *INZSR - Program Initialisation routine
      ************************************************************
     C     *INZSR        BEGSR
      *
      ** Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Return Code
     C                   PARM                    W0RTN
      *
      ** Nostro key
     C                   PARM                    W0KEY#
      *
      ** VDate
     C                   PARM                    W0VDAT
      *
      ** Amount
     C                   PARM                    W0AMT
      *
     C                   ENDSR
     ****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2014

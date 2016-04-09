     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Retrieve Selected Customers')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000799 - Midas SD Retrieve Selected Customers              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER070             Date 19Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26719           Date 12Nov09               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26719 - Limit Utilisation Report (SD000798P1) threshold   *
      *           for all members should be clear                     *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *  ===========================================                  *
      *                                                               *
      *  *INLR  -  End processing                                     *
      *  *INU7  -  Data-base                                          *
      *  *INU8  -  Error control                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *  ===============================                              *
      *                                                               *
      *  *PSSR  - Error subroutine                                    *
      *  *INZSR - Program Initialisation                              *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Query file for Limit Utlisation file
      *
     FSDCUATJ0  IF   E           K DISK    INFSR (*PSSR)
      *
      ** Joint Account Member file
      *
     FSDJACCL4  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Customer by Country of Tax file
      *
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Selected customers for Limit Utlisation file
      *
     FSDLMUTPD  O    E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,and the following
      ** named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes the definitions
      ** for error and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Externally described DS for Additional Customer
      *
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      *
      ** Externally described DS for Customer
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Externally described DS for Branch
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D CUST_DFAC     E                     EXTFLD(QQDFAC)
      *
      ** Externally described DS for Location
      *
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      *
      ** Dummy Data Structures used by Access Programs.
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - very long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Dummy Data Structures used by Access Programs.
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** Parameters
      *
     D PSel            S              4A
      *
      ** Parameter for AOACUSR0
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PAcus           S              6A
     D PCnum           S             10A
     D PCnst           S              7A
     D PBrch           S              3A
     D PLocn           S              3A
      *
      ** Work Variable
      *
     D WkCpy           S              1A
     D WRun            S              1A
     D WCust           S              6A
     D WCust1          S              6A
     D WColc           S              2A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Read first record in file
      *
     C     *LOVAL        SETLL     SDCUATJ0
     C                   READ      SDCUATJ0
      *
      ** Do Until End of File.
      *
     C                   DOW       NOT %EOF(SDCUATJ0)
      *
     C                   EVAL      FCUST = BBCUST
     C                   EVAL      FCTAX = AXETXS
      *
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      FCUST         PAcus
     C     SDACUS        PARM      SDACUS        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      E5JATP = *BLANKS
     C                   ENDIF
      *
     C                   EVAL      FJATP = E5JATP
      *                                                                                     BUG26719
     C                   IF        E5JATP = 'Y'                                             BUG26719
      *
      ** Write record in the selected customer file
      *
     C                   WRITE     SDLMUTD0
      *                                                                                     BUG26719
     C                   ENDIF                                                              BUG26719
      *                                                                                     BUG26719
      ***If*a*join exists, add the join customer in the                                     BUG26719
      ***selected customer file according to the selection                                  BUG26719
      **********                                                                            BUG26719
     C**********         IF        *IN50 = *OFF                                             BUG26719
      **********                                                                            BUG26719
     C**********         IF        E5JATP = 'Y'                                             BUG26719
      *
     C                   EVAL      WCust = FCUST
      *
     C     WCUST         CHAIN     SDJACCL4                                                 BUG26719
      *                                                                                     BUG26719
     C                   IF        %FOUND                                                   BUG26719
      *
     C*****WCust         SETLL     SDJACCL4                                                 BUG26719
     C*****WCust         READE     SDJACCL4                                                 BUG26719
     ***********                                                                            BUG26719
     C**********         DOW       NOT %EOF(SDJACCL4)                                       BUG26719
      *
     C                   IF        PSEL = 'CUSN'                                            BUG26719
      *                                                                                     BUG26719
     C                   EVAL      FCUST = JCJANO
     C                   EVAL      WCust1 = JCJANO
      *
      ** Call AOCUSTR0 for Country of Location
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      FCUST         PCnum
     C                   PARM                    PCnst
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C                   IF        PRtcd = *BLANKS
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BBBRCD        PBrch
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 005
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBrch
     C                   EVAL      DBPGM = 'SD000799'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      A8LCCD        PLocn
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 006
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   EVAL      DBKEY = PLocn
     C                   EVAL      DBPGM = 'SD000799'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      WColc  = DVCNCD
      *
     C                   ELSE
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = 'FCUST'
     C                   EVAL      DBPGM = 'SD000799'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Get the European Tax Status
      *
     C     KList1        CHAIN     SDACTXL1
      *
     C                   IF        %FOUND(SDACTXL1)
      *
     C                   EVAL      FCTAX = AXETXS
      *
     C                   ELSE
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDACTXPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = 'FCUST'
     C                   EVAL      DBPGM = 'SD000799'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      FCUST         PAcus
     C     SDACUS        PARM      SDACUS        DSLDY
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      E5JATP = *BLANKS
     C                   ENDIF
      *
     C                   EVAL      FJATP = E5JATP
      *
     C                   WRITE     SDLMUTD0
      *
      **********                                                                            BUG26719
     C*****WCust         READE     SDJACCL4                                                 BUG26719
      **********                                                                            BUG26719
     C**********         ENDDO                                                              BUG26719
      *
     C                   ENDIF
      *
      ** not found in SDJACCL4                                                              BUG26719
     C                   ELSE                                                               BUG26719
     C                   WRITE     SDLMUTD0                                                 BUG26719
      *                                                                                     BUG26719
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      SDCUATJ0
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          WkCpy
      *
      ** Receive Parameters from calling pgm
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSel
      *
     C     KList1        KLIST
     C                   KFLD                    WCust1
     C                   KFLD                    WColc
      *
      ** Only one page must be printed :
      ** if the selection is by Customer number
      *
     C                   IF        PSel = 'CUSN'
     C                   EVAL      *IN50 = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *  Called by: None                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
      ** Call DBERRCTL if Interactive program
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
      ** End program if DBERRCTL not called
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2008

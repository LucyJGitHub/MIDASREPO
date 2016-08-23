     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Validate Dealing Fees SWIFT Confirmation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009650 - Validate a Midas System Value                     *
      *                                                               *
      *  Function:  This function validate Dealing Fees               *
      *             SWIFT Confirmation                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR    - Error Processing                                  *
      *  *INZSR   - Program Initialisation Routine                    *
      *                                                               *
      *    The *INZSR subroutine will only get Called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
     D  CAS009         S              1A   INZ('N')
     D  WRun           S              1A   INZ('N')
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
      ** External DS for SAR detailsle Format
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7
 
      ** Entry variables
     D SystemValue     S             20A
     D NewValue        S              1A
     D ProcMode        S             10A
     D GenError        S              1A
     D Idx             S              2P 0
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (If necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   IF        (CAS009 = 'N') AND (NewValue = 'Y')
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXArr(Idx) = 'USR8200'
     C                   ELSE
     C                   IF        (NewValue <> 'Y') AND (NewValue <> 'N')
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXArr(Idx) = 'SDM0015'
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Parameters
     C     *Entry        Plist
     C                   PARM                    SystemValue
     C                   PARM                    NewValue
     C                   PARM                    ProcMode
     C                   PARM                    GenError
     C                   PARM                    Idx
     C                   PARM                    MsgIDXarr
      *
      ** Initialize program name
     C                   EVAL      Dbpgm  = 'SD009650'
     C                   EVAL      Dbase  = *ZEROS
     C                   EVAL      Dbfile = *BLANKS
     C                   EVAL      Dbkey  = *BLANKS
     C                   EVAL      Dbmod  = *BLANKS
     C                   EVAL      Dbproc = *BLANKS
      *
      ** Call AOSARDR0 to check if CAS009 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAS009'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        (@RTCD <> *Blanks AND @RTCD <> '*NRF   ')
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'SCSARDPD'
     C                   EVAL      Dbkey  = 'CAS009'
     C                   EVAL      Dbase = 01
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
 
     C                   ELSEIF    (@RTCD = '*NRF   ')
 
     C                   IF        (NewValue = 'Y')
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXArr(Idx) = 'USR8200'
     C                   ENDIF
 
     C                   ELSEIF    (@RTCD = *BLANKS)
 
     C                   EVAL      CAS009 = 'Y'
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically If a program error occurs,          *
      *             or directly by the program code using Exsr.       *
      *             This subroutine Dumps the program just once.      *
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
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
      *
     C                   ENDSR
      *

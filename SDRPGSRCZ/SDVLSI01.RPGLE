     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate live SWIFT Identification')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVLSI01 - Validate live SWIFT Identification                *
      *                                                               *
      *  Function:  This function validate if the inputted customer   *
      *             number or shortname is live and has a SWIFT       *
      *             identification.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW213 - SWIFT Changes 2013                                  *
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
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry variables
     D SystemValue     S             20A
     D CurSetting      S            200A
     D ProgMode        S             10A
     D ErrorInd        S              1A
     D Idx             S              2P 0
     D MsgIDXarr       S              7    DIM(99)
      *
     D P@Rtcd          S              7
     D P@Optn          S              7
     D PCusn           S             10A
     D PKySt           S              7A
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
     C                   IF        CurSetting <> *BLANK
      *
      ** Check if the system value entered is a valid customer
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@Rtcd
     C                   PARM      '*KEY'        P@Optn
     C                   PARM      CurSetting    PCusn
     C                   PARM      *BLANKS       PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** If valid customer number/shortname, check if customer
      ** is a SWIFT financial institution and with SWIFT ID
      *
     C                   IF        P@Rtcd = *BLANKS  AND
     C                             (PKyST = '*CSHT'  OR
     C                              PKyST = '*CNUM')
      *
     C                   EVAL      CurSetting = BBCUST
 
     C                   SELECT
     C                   WHEN      BBSWFI = 'Y'
     C                   IF        BBCSID = *BLANKS
     C                   EXSR      SRSndErrorMsg
     C                   ENDIF
     C                   OTHER
     C                   EXSR      SRSndErrorMsg
     C                   ENDSL
 
     C                   ELSE
 
     C                   EXSR      SRSndErrorMsg
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndErrorMsg - Send Error Message for Invalid Entry         *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSndErrorMsg BEGSR
 
     C                   SELECT
 
     C                   WHEN      SystemValue = 'DLSWIFTCtpyNonSWIFT'
     C                   EVAL      ErrorInd = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXArr(Idx) = 'USR0012'
 
     C                   WHEN      SystemValue = 'DLSWIFTCtpySWIFT'
     C                   EVAL      ErrorInd = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXArr(Idx) = 'USR0016'
 
     C                   ENDSL
 
     C                   ENDSR
 
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
 
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *Entry        Plist
     C                   PARM                    SystemValue
     C                   PARM                    CurSetting
     C                   PARM                    ProgMode
     C                   PARM                    ErrorInd
     C                   PARM                    Idx
     C                   PARM                    MsgIDXarr
      *
      ** Initialize program name
      *
     C                   EVAL      Dbpgm  = 'SDVLSI01'
     C                   EVAL      Dbase  = *ZEROS
     C                   EVAL      Dbfile = *BLANKS
     C                   EVAL      Dbkey  = *BLANKS
     C                   EVAL      Dbmod  = *BLANKS
     C                   EVAL      Dbproc = *BLANKS
 
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
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
 
     C                   EVAL      WRun = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR

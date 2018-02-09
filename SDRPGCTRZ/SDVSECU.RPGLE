     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Securities Customer')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVSECU- SD Additional Customer Validate Securities Customer *
      *                                                               *
      *  Function:  This module validates the Securities Customer     *
      *             on the new Details screen                         *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVSecu  - Validate Securities Customer                      *
      *  SRSecChk - Check if Securities Customer                      *
      *  *INZSR    - Program Initialisation Routine                   *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line include (among others) the LDA layout
      ** and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
      *
     D/COPY ZACPYSRC,ERR_XARRYS
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
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Other External DS
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External DS based on Securities File
      *
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
      *
     D Idx             S              3P 0
      *
      ** Index for arrays of of warning message ids etc
      *
     D WIdx            S              3P 0
      *
      ** Securities Customer
      *
     D DDSECU          S              1A
      *
      ** OK Flag for Securities Customer
      *
     D OKSECU          S              1A
      *
      ** Customer
      *
     D DDCUST          S              6A
      *
      ** Parameters
      *
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
     C                   EVAL      Idx = *ZEROS
     C                   EVAL      WIdx = *ZEROS
      *
      ** Securities Customer Validation
      *
     C                   EXSR      SRVSecu
      *
      ** Incase of an Error
      *
     C                   IF        OKSECU = 'N' OR OKSECU = 'W'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
      *
      ** Return from program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVSecu:  Securities Customer Validation                     *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRSecChk                                              *
      *                                                               *
      *****************************************************************
     C     SRVSecu       BEGSR
      *
      ** Validate Securities Customer
      *
     C                   IF        DDSECU = *BLANKS
     C                   EVAL      DDSECU = 'N'
     C                   ENDIF
      *
      ** Security Customer Flag can be only Y/N
      *
     C                   IF        DDSECU <> 'Y' AND
     C                             DDSECU <> 'N'
      *
     C                   EVAL      OKSECU = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDSECU'
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5954'
      *
     C                   ELSE
      *
      ** Access Securities Details for the Customer
      *
     C                   EXSR      SRSecChk
      *
     C                   ENDIF
      *
      ** If Security Customer Flag is 'N'
      *
     C                   IF        DDSECU = 'N'
      *
      ** If customer is a Security Client, issue a warning
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      OKSECU = 'W'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WFldNmXAr(WIdx) = 'DDCUST'
     C                   EVAL      WMsgIDXAr(WIdx) = 'USR5955'
     C                   ENDIF
      *
      ** Else If Security Customer Flag is 'Y'
      *
     C                   ELSEIF    DDSECU = 'Y'
      *
      ** If customer is not a Security Client, issue a warning
      *
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      OKSECU = 'W'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WFldNmXAr(WIdx) = 'DDCUST'
     C                   EVAL      WMsgIDXAr(WIdx)  = 'USR5956'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSecChk: Securities Customer Check                          *
      *                                                               *
      *  Called by: SRVSecu                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRSecChk      BEGSR
      *
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    DDCUST
     C     SDSECS        PARM      SDSECS        DSSDY
      *
     C                   IF        PRtCd <> *BLANKS  AND
     C                             PRtCd <> '*NRF'
      *
     C                   EVAL      DBKEY  = 'DDCUST'
     C                   EVAL      DBFILE = 'SDSECSPD'
     C                   EVAL      DBASE  = 901
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Securities Customer
      *
     C                   PARM                    DDSECU
      *
      ** Customer
      *
     C                   PARM                    DDCUST
      *
      ** Outputs
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Ok Flag for Securities Customer
      *
     C                   PARM                    OKSECU
      *
      ** Program, module and procedure names for database error
      ** processing.
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************

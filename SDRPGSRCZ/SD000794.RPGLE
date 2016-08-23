     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Cust. Exempt. Threshold Enquiry - Select')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD000794 - Customer Exemption Threshold Enquiry - Select     *
      *                                                               *
      *  Function:  This new screen selects the customer for which    *
      *             Exemption Threshold details have to be shown.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG22982           Date 19Feb09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22982 - Title should be 'Exemption Threshold Enquiry'     *
      *             Recompiled due to changes in SD000794DF           *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         Exit                                            *
      *    25         Invalid Customer                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRValCust - Validate Customere                                *
      * SRDispEnq - Call Program SD000795 for Enquiry                 *
      * SRSndEMsg - Send Error Message                                *
      * SRClrEMsg - Clear Error Message                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Customer Exemption Threshold Enquiry - Select(Display)
      *
     FSD000794DFCF   E             WORKSTN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =========================            ¦
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
      ** Long DS for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External DS for Customer Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter for Access Object
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PKeySt          S              7A
     D PReturn         S              7A
      *
      ** Message file workfields - Parameters list for ZA0350
      *
     D PZMsgFile       S             10A
     D PZMsgID         S             10A
     D PZMsgDta        S             45A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: The *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Loop While EXIT not taken from screen
      ** Display Main Screen
      *
     C                   DOW       *IN03 = *OFF
      *
     C                   TIME                    DDTIME
      *
     C                   WRITE     SD000794C0
     C                   EXFMT     SD000794D0
      *
     C                   EXSR      SRClrEMsg
      *
      ** Terminate, If Exit Requested
      *
     C                   IF        *IN03 = *ON
     C                   ITER
     C                   ENDIF
      *
     C                   EXSR      SRValCust
      *
      ** If It is a Valid customer
      *
     C                   IF        *IN25 = *OFF AND DDCUST <> *BLANKS
      *
      ** If '?' than redisplay main screen with selected Customer
      *
     C                   IF        %SCAN('?' : DDCUST) > 0
     C                   EVAL      DDCUST = BBCUST
      *
      ** Else call Enquiry Program
      *
     C                   ELSE
     C                   EXSR      SRDispEnq
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndEMsg - Send Error Message                               *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRSndEMsg     BEGSR
      *
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
     C                   PARM                    PZMsgDta
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrEMsg - Clear Error Message                              *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRClrEMsg     BEGSR
      *
     C                   EVAL       *IN25 = *OFF
      *
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValCust - Validate Customer                                *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRValcust     BEGSR
      *
      ** Validate Customer
      *
     C                   IF        DDCUST <> *BLANKS
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDCUST        PCust
     C                   PARM      *BLANKS       PKeySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Error in accessing customer file
      *
     C                   IF        (PRtcd <> *BLANKS)
     C                              AND (PRtcd <> '*NRF')
     C                              AND (PRtcd <> '*NOSEL')
     C                              AND (PRtcd <> '*KEY')
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = DDCUST
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBPGM = 'SD000794'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRtcd = '*NRF'  OR
     C                             PRtcd = '*KEY'
      *
     C                   EVAL      *IN25 = *ON
     C                   EVAL      PZMsgID = 'USR8264'
     C                   EXSR      SRSndEMsg
      *
     C                   ENDIF
      *
     C                   IF        PRtcd = '*NOSEL '
     C                   EVAL      DDCUST = *BLANKS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDispEnq - Call Program SD000795 for Enquiry                *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRDispEnq     BEGSR
      *
      ** Call Exemption Threshold Enquiry if additional customer
      ** details found
      *
     C                   CALL      'SD000795'
     C                   PARM      *BLANKS       PReturn
     C                   PARM                    PCust
      *
     C                   SELECT
      *
     C                   WHEN      PReturn = 'Y2U9999'
      *
     C                   EVAL      *IN03 = *ON
      *
     C                   WHEN      PReturn = 'F12'
      *
     C                   EVAL      DDCUST = *BLANKS
      *
     C                   WHEN      PReturn = '*NRF'
      *
     C                   EVAL      *IN25 = *ON
     C                   EVAL      PZMsgID = 'USR8271'
     C                   EXSR      SRSndEMsg
      *
     C                   ENDSL
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
     C                   EVAL      DBPGM = 'SD000794'
     C                   EVAL      DBMOD =  PSProcMod
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Populate Static Screen fields
      *
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      SPGMQ = '*'
     C                   EVAL      DDWID = PsJobName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2008

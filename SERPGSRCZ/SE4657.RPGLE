     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statement - Send data to MMMM')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE4657   - Midas SE Statement - Send data to MMMM            *
      *                                                               *
      *  Function:  This program sends the Statements in XML format   *
      *             to MMM.                                           *
      *                                                               *
      *  Called By   : SEC4651 - SE Statement Processing              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 221616             Date 23Sep03               *
      *                 CSE040  *CREATE    Date 18Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  221616 - Avoid sending empty message in data queue.          *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
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
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FCGUXMLPD  IP   E             DISK    INFSR(*PSSR)
     ** Midas CG UDC XML Merged Data
 
     FSDSESTPD  IF   E             DISK    INFSR(*PSSR)
     ** Midas SD ICD for Securities Statement
 
     FSES2MMPD  O    E             DISK    INFSR(*PSSR)
     ** Midas SE MT535/536/537 Data send to MMM
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The standard SWIFT conversion translate SWIFT Invalid character in XML Invalid character
      ** To avoid problem, the invalid character is replaced by ' '.
 
     D InvChr          C                   '&;"{}ò!$¢%*@\#|¬`~_?<=>'            Invalid Character
     D RepChr          C                   '                       '            Replace Character
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WkMsgDta        S          64512
      ** Message Data
 
     D MaxLength       S              5  0 INZ(%SIZE(WkMsgDta))
      ** Maximum message Length
 
     D WkLenMsg        S              5  0 INZ(0)
      ** Current message Length
 
     D WkLenData       S              5  0 INZ(0)
      ** Current Data Length
 
     D WkData          S            200
      ** Extract Data from file
 
     D WkTagValue      S                   LIKE(XMTAGV)
      ** Tag Value
 
     D @RUN            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     ICGUXMLD0      01
     I                                          XMITEM        L1                Item Identifier
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Concatenate tags and data
 
      ** Update Message Header for Meridian
 
     C                   SELECT
     C                   WHEN      XMTAGN = '<SEStatementHolding>'
     C                   EVAL      WkData = '<MeridianMessage MessageType= +
     C                                      "SEStatementHolding">'
 
     C                   WHEN      XMTAGN = '<SEStatementTransaction>'
     C                   EVAL      WkData = '<MeridianMessage MessageType= +
     C                                      "SEStatementTransaction">'
 
      ** Update Message Trailer for Meridian
 
     C                   WHEN      XMTAGN = '</SEStatementHolding>'
     C                   EVAL      WkData = '</MeridianMessage>'
 
     C                   WHEN      XMTAGN = '</SEStatementTransaction>'
     C                   EVAL      WkData = '</MeridianMessage>'
 
     C                   OTHER
 
      ** Convert Invalid Characters
 
     C     InvChr:RepChr XLATE     XMTAGV        WkTagValue
 
      ** Update Message Detail for Meridian
 
     C                   EVAL      WkData = %TRIM(XMTAGN)                       Tag Name
     C                                    + %TRIM(WkTagValue)                   Tag Value
     C                                    + %TRIM(XMENDT)                       End Tag
     C                   ENDSL
 
      ** Add details to audit file
 
     C                   EVAL      SNDATA = WkData
     C                   WRITE     SES2MMD0
 
      ** Check if the maximum length will be reached
 
     C                   EVAL      WkLenData = %LEN(%TRIM(WkData))
 
     C                   IF        WkLenMsg + WkLenData > MaxLength
 
      ** If maximum lenght reached, send the current message data
 
     C                   EXSR      $SndMsg
 
     C                   ENDIF
 
      ** Add the extracted data to current message data
 
     C                   EVAL      %SUBST(WkMsgDta:WkLenMsg+1) =
     C                             WkData
     C                   EVAL      WkLenMsg = WkLenMsg + WkLenData
 
      ** If new message, send the current message data
 
     CL1                 EXSR      $SndMsg
 
     CLR                 RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      * $SndMsg - Send message to Data Queue                          *
      *****************************************************************
 
     C     $SndMsg       BEGSR
      *    -------       -----
 
     C                   IF        WkMsgDta <> *Blanks                                        221616
 
     C                   CALL      'QSNDDTAQ'
     C                   PARM                    SDDTAQ                         Data Queue
     C                   PARM                    SDLIB                          Library
     C                   PARM                    MaxLength                      Message Length
     C                   PARM                    WkMsgDta                       Message Data
 
     C                   ENDIF                                                                221616
 
      ** Clear Message Data
 
     C                   EVAL      WkMsgDta = *BLANKS                           Message Data
     C                   EVAL      WkLenMsg = *ZEROS                            Message Length
 
      *                  -----
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Read in Installation Data for Securities Statement
      *
     C     1             CHAIN     SDSESTPD
      *
     C                   IF        NOT %FOUND(SDSESTPD)
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDSESTPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSProcName
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003

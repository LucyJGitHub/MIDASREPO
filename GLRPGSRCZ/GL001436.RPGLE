     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Generation of Today's Message Requests')      *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001436 - Midas GL Generation of Today's Message Requests.  *
      *                                                               *
      *  Function:  This module generates the Message Requests.       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013  *CREATE    Date 31Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
 
     FGLGS94L1  IF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL MT941/942 Generation Schedules - Retrieve
 
     FGLNW94L1  IF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL Network Accounts - MT94x - Retrieval
 
      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 27 - Access to Midas GL MT941/942 Generation Schedules (LF/GLGS94L1)   *
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*
 
      *========================================================================*
      ** Automatically included D-specs
      ** ==============================
 
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Manually included D-specs
      ** =========================
 
      ** Named constants
      ** ---------------
 
      ** Arrays and Data Structures
      ** --------------------------
 
     D SchRcd        E DS                  EXTNAME(GLGS94PD)
      ** Generation Schedule File Record
 
      ** Declared variables
      ** ------------------
 
     D CallerIn        S             10A                                        Calling program
     D Wk942FLD        S                   LIKE(N42FLD)                         Floor limit debit
     D Wk942FLC        S                   LIKE(N42FLC)                         Floor limit credit
 
      ** Input Specs
      ** -----------
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
     C     *LOVAL        SETLL     GLGS94L1
 
     C                   DOU       *IN27
 
      ** Read each MT941/942 Generation Schedules
 
     C                   READ      GLGS94L1                               27
 
     C                   IF        NOT *IN27
     C                             AND GSSTUS = 'ACTIVE'
 
      ** Reset floor Limit Debit and credit
 
     C                   EVAL      Wk942FLD = *ZEROS                            Floor limit debit
     C                   EVAL      Wk942FLC = *ZEROS                            Floor limit credit
 
      ** For MT942 request, retrieve the floor Debit and Credit on the Network Account.
 
     C                   IF        GSMTPY = '942'
     C     KeyNwrkAc     CHAIN     GLNW94L1                           99
     C  N99N4RECI        COMP      'D'                                9999
     C   99              ITER
     C                   EVAL      Wk942FLD = N42FLD                            Floor limit debit
     C                   EVAL      Wk942FLC = N42FLC                            Floor limit credit
     C                   ENDIF
 
      ** Generate Message Resquest.
 
     C                   CALLB     'ME002561'                           99
     C                   PARM      *BLANKS       ReturnCode                     Return Code
     C                   PARM      PSProcPgm     CallerIn         10            Calling Program
     C                   PARM                    SchRcd                         Message Request Dtl
     C                   PARM                    Wk942FLD                       Floor limit debit
     C                   PARM                    Wk942FLC                       Floor limit credit
 
     C                   IF        ReturnCode <> *BLANKS
     C                             OR *IN99 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDDO
 
     C                   COMMIT
 
     C                   EVAL      *INLR = *On
     C                   RETURN
 
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *------------------------------------------------------------------------*
 
     C     *INZSR        BEGSR
      *    ------        -----
 
      ** Initialise Copyright Array
     C                   MOVEA     CPY@          CPY@@            80
 
      ** Initialise LDA
 
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBpgm
     C                   OUT       LDA
 
      ** Key to access Network Account.
 
     C     KeyNwrkAc     KLIST
     C                   KFLD                    GSNWRK                         Network
     C                   KFLD                    GSBRCA                         Branch Code - Alpha
     C                   KFLD                    GSCNUM                         Customer number
     C                   KFLD                    GSCCY                          Currency code
     C                   KFLD                    GSACCD                         Account code
     C                   KFLD                    GSACSQ                         Account sequence num
     C                   KFLD                    GSNATY                         Network Account Type
     C                   KFLD                    GSDSTN                         Destination
 
      *    ------        -----
     C     @INZSR        ENDSR
 
      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
 
     C     *PSSR         BEGSR
      *    ----------    ------
 
     C                   DUMP
     C                   ROLBK
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
 
     C                   RETURN
 
      *    ----------    ------
     C     @PSSR         ENDSR
 
      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002

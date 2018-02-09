     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL MT941/MT942 Message Generation')              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001415 - Midas MT941/MT942 Message Generation              *
      *                                                               *
      *  Function:  This module controls the extraction of Shadow     *
      *             postings and the generation MT941 or MT942        *
      *             messages.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD027367           Date 04Jun14               *
      *                 MD025973           Date 25Mar14               *
      *                 CGL146A            Date 10Jul13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013  *CREATE    Date 09May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027367 - Generate MT940 on Transit Accounts.               *
      *             Ensure not flagged as Duplicate.                  *
      *  MD025973 - Intermitent Generation of Movement in MT940       *
      *  CGL146A - MT940/MT950 Production in Input Cycle              *
      *            Added hooks: CGL146_020, CGL146_024, CGL146_124    *
      *                         CGL146_125, CGL146_126, CGL146_127    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
 
     FGLMR94L2  IF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL MT941/942 Messages Requests - "SUBMITTED"
 
     FGLMR94L0  UF   E           K DISK    PREFIX(Up)     INFSR(*PSSR)
     F                                     RENAME(GLMR94D0:UpGLMR94D0)
     F                                     COMMIT
      ** Midas GL MT941/942 Messages Requests - Update
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_124                                                             CGL146A
 
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      * 27 - Access Network Account (LF/GLMR94L2)                     *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************
 
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
 
     D GLMR94        E DS                  EXTNAME(GLMR94PD)
      **  Data Structure for GL MT941/942 Messages Requests.
     D***WkRequest                   39    OVERLAY(GLMR94:1)                    Request Ref MD027367
 
     D MMOD          E DS                  EXTNAME(MMODF)    DTAARA(MMOD)
      **  Data Structure for Midas SD Module
     D/COPY WNCPYSRC,GLH00377
 
      ** Declared variables
      ** ------------------
 
     D WkRequest       S             45                                                     MD027367
     D WkPrvReq        S                   LIKE(WkRequest)                      Prev. Request Ref.
 
     D MsgGenDate      S              5  0                                      Msg Generation Date
     D MsgGenTime      S              6  0                                      Msg Generation Time
      /COPY OFCPYSRCZ,CGL146_020                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_125                                                             CGL146A
 
      ** Input Specs
      ** -----------
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
      ** Read each request with a status 'SUBMITTED'
 
     C     *LOVAL        SETLL     GLMR94L2
     C                   READ      GLMR94L2                               27
 
     C                   DOW       NOT *IN27
                                                                                            MD027367
     C                   EVAL      WkRequest = %Subst(GLMR94:1:18)                          MD027367
     C                                        + %EditC(MRACCD:'X')                          MD027367
     C                                        + %Subst(GLMR94:23:17)                        MD027367
                                                                                            MD027367
                                                                                            CGL146A
      /COPY OFCPYSRCZ,CGL146_126                                                            CGL146A
 
      ** Process the request only if Network Account,
      **                             Destination,
      **                            and Message Type,
      ** are different than the previous one.
 
     C                   IF        WkPrvReq <> WkRequest
 
     C                   EVAL      MsgGenDate = *ZEROS                          Msg Generation Date
     C                   EVAL      MsgGenTime = *ZEROS                          Msg Generation Time
 
      ** Extract Shadow Postings
 
     C                   CALLB     'GL001416'                           99
     C                   PARM      *BLANKS       ReturnCode                     Return code
     C                   PARM                    GLMR94                         Request Detail
 
     C                   IF        ReturnCode = 'PSSR_Error'
     C                             OR *IN99 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Extract FF Shadow Postings
 
     C                   IF        FFFL = 'Y'
     C                             AND ReturnCode = *BLANKS
 
     C                   CALLB     'GL001417'                           99
     C                   PARM      *BLANKS       ReturnCode                     Return code
     C                   PARM                    GLMR94                         Request Detail
 
     C                   IF        ReturnCode = 'PSSR_Error'
     C                             OR *IN99 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CGL146
      /COPY OFCPYSRCZ,CGL146_127                                                              CGL146
 
     C                   IF        ReturnCode = *BLANKS
 
     C                   SELECT
 
      ** Generate MT941
 
     C                   WHEN      MRMTPY = '941'
     C/COPY WNCPYSRC,GLH00378
 
     C                   CALLB     'GL001420'                           99
     C                   PARM      *BLANKS       ReturnCode                     Return code
     C                   PARM                    GLMR94                         Request Detail
     C                   PARM                    MsgGenDate                     Msg Generation Date
     C                   PARM                    MsgGenTime                     Msg Generation Time
 
     C                   IF        ReturnCode = 'PSSR_Error'
     C                             OR *IN99 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Generate MT942
 
     C                   WHEN      MRMTPY = '942'
     C/COPY WNCPYSRC,GLH00379
 
     C                   CALLB     'GL001421'                           99
     C                   PARM      *BLANKS       ReturnCode                     Return code
     C                   PARM                    GLMR94                         Request Detail
     C                   PARM                    MsgGenDate                     Msg Generation Date
     C                   PARM                    MsgGenTime                     Msg Generation Time
 
     C                   IF        ReturnCode = 'PSSR_Error'
     C                             OR *IN99 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
     C                   ENDIF
 
     C*****KeyMsgRqt     CHAIN     GLMR94L0                           99                    MD025973
     C**********         IF        NOT *IN99                                                MD025973
 
     C     KeyMsgRqt     SETLL     GLMR94L0                                                 MD025973
     C     KeyMsgRqt     READE     GLMR94L0                                                 MD025973
                                                                                            MD025973
     C                   DOW       NOT %EOF                                                 MD025973
                                                                                            MD025973
      ** Update Request Status
 
     C                   SELECT
 
      **   Duplicate
 
     C                   WHEN      WkPrvReq = WkRequest
     C                   EVAL      UpMRSTAT = 'DUPLICATE'                       Request Status
 
      **   Error
 
     C                   WHEN      ReturnCode <> *BLANKS
     C                   EVAL      UpMRSTAT = ReturnCode                        Request Status
 
      **   Generated
 
     C                   OTHER
     C                   EVAL      UpMRSTAT = 'GENERATED'                       Request Status
     C                   EVAL      UpMRMGDT = MsgGenDate                        Msg Generation Date
     C                   EVAL      UpMRMGTM = MsgGenTime                        Msg Generation Time
     C                   EVAL      WkPrvReq = WkRequest                         Prev. Request ref.
     C                   ENDSL
 
     C                   UPDATE    UpGLMR94D0
 
      ** Commit all modification.
 
      ** In GL001416, the COMMIT is done at each RSACMTPD processed. It avoids to extract twice
      ** the same information.
      ** In GL001420 and GL001421, there is a Roll back if a problem occurs, but not Commit.
 
     C                   COMMIT
 
     C**********         ELSE                                                               MD025973
 
      ** Reverse all modification.
 
     C**********         ROLBK                                                              MD025973
 
     C**********         ENDIF                                                              MD025973
                                                                                            MD025973
     C     KeyMsgRqt     READE     GLMR94L0                                                 MD025973
     C                   ENDDO                                                              MD025973
 
      ** Read next request with a status 'SUBMITTED'
 
     C                   READ      GLMR94L2                               27
 
     C                   ENDDO
 
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
 
      ** Retrieve MIDAS Modules
 
     C                   IN        MMOD
                                                                                             CGL146A
     C/COPY OFCPYSRCZ,CGL146_024                                                             CGL146A
 
      ** Key to access Message Request
 
     C     KeyMsgRqt     KLIST
     C                   KFLD                    MRNWRK                         Network
     C                   KFLD                    MRBRCA                         Account Branch
     C                   KFLD                    MRCNUM                         Account Customer
     C                   KFLD                    MRCCY                          Account Currency
     C                   KFLD                    MRACCD                         Account Code
     C                   KFLD                    MRACSQ                         Account Sequence
     C                   KFLD                    MRNATY                         Network Account type
     C                   KFLD                    MRDSTN                         MT94x Destination
     C                   KFLD                    MRMTPY                         Message type
     C                   KFLD                    MRSORQ                         Source of Request
     C                   KFLD                    MRSDTE                         Schedule Start Date
     C                   KFLD                    MRSTIM                         Schedule Start Time
     C                   KFLD                    MRRDTE                         Request Date
     C                   KFLD                    MRSRTIM                        Request Time
     C/COPY WNCPYSRC,GLH00380
 
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

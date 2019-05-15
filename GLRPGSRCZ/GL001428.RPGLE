     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Network Account Re-organisation')             *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001428 - Midas GL Network Account Re-organisation.         *
      *                                                               *
      *  Function:  This module reset the Network Account:            *
      *             - Deletion of expired Schedules,                  *
      *             - Deletion of expired Requests,                   *
      *             - Deletion of Network account,                    *
      *             - Flag message generation from Y to N.            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD023885           Date 02Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 216937             Date 28Apr03               *
      *                 CRE008             Date 31May02               *
      *                 CGL013  *CREATE    Date 31Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD023885 - Technical drop of deleted accounting rules        *
      *             Added hooks: CGL146_135, CGL146_136, CGL146_137,  *
      *                         CGL146_138                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  216937 - If GA account, include source account (recompile)   *
      *  CRE008 - Cash Management  (Recompile Only)                   *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
 
     FGLGS94L0  UF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL MT941/942 Generation Schedules - Update.
 
     FGLMR94L0  UF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL MT941/942 Messages Requests - Update
 
     FGLNWACL0  UF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL Network Accounts - Update
 
     FGLNW94L0  UF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL Network Accounts - MT94x - Update
 
     FGLPOSTL0  UF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL Postings for MT94x Messages.
 
     F/COPY OFCPYSRCZ,CGL146_135                                                            MD023885
      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 27 - Access Network Account MT950 Details (LF/GLNWACL0)                *
      * 28 - Access Network Account MT94x Details (LF/GLNW94L0)                *
      * 29 - Access MT94x Postings file (LF/GLPOSTL0)                          *
      * 30 - Access MT941/942 Generation Schedules file (LF/GLGS94L0)          *
      * 31 - Access MT941/942 Messages Requests file (LF/GLMR94L0)             *
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
 
     D ArNWRK          S              6A   DIM(999)                             Network
     D ArRCDT          S              5P 0 DIM(999)                             Retention Control Dt
      **  Array to keep Retention Control Date by Newtwork.
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data Structure for Bank Details.
 
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      **  Data Structure for Network details.
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  First DS for access programs, long data structure.
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Second DS for access programs, short data structure.
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      **  Third DS for access programs, very long data structure.
     D/COPY OFCPYSRCZ,CGL146_136                                                            MD023885
 
      ** Declared variables
      ** ------------------
 
     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option
     D P@NWRK          S              6A                                        Network
 
     D IdNWRK          S              5U 0                                      Network Index
     D LstNWRK         S                   LIKE(NwAcNWRK)                       Last Network
     D WkRTCD          S                   LIKE(BJRDNB)                         Ret. Ctl. Date
 
     D KeyNWRK         S                   LIKE(NwAcNWRK)                       Network
     D KeyBRCA         S                   LIKE(NwAcBRCH)                       Branch Code
     D KeyCNUM         S                   LIKE(NwAcCNUM)                       Customer number
     D KeyCCY          S                   LIKE(NwAcCCY)                        Currency code
     D KeyACOD         S                   LIKE(NwAcACOD)                       Account code
     D KeyACSQ         S                   LIKE(NwAcACSQ)                       Account sequence num
     D KeyNATY         S                   LIKE(NwAcNATY)                       Network Account Type
     D KeyDSTN         S                   LIKE(NwAcDSTN)                       Destination
     D KeyMTPY         S                   LIKE(MGMTPY)                         Message Type
 
      ** Input Specs
      ** -----------
 
     IGLNWACD0      01
      ** Rename key fields
     I              NANWRK                      NwAcNWRK                        Network
     I              NABRCH                      NwAcBRCH                        Branch
     I              NACNUM                      NwAcCNUM                        Customer Number
     I              NACCY                       NwAcCCY                         Currency
     I              NAACOD                      NwAcACOD                        Account code
     I              NAACSQ                      NwAcACSQ                        Account sequence
     I              NANATY                      NwAcNATY                        Network account type
 
     IGLNW94D0      02
      ** Rename key fields
     I              N4NWRK                      NwAcNWRK                        Network
     I              N4BRCA                      NwAcBRCH                        Branch
     I              N4CNUM                      NwAcCNUM                        Customer Number
     I              N4CCY                       NwAcCCY                         Currency
     I              N4ACCD                      NwAcACOD                        Account code
     I              N4ACSQ                      NwAcACSQ                        Account sequence
     I              N4NATY                      NwAcNATY                        Network account type
     I              N4DSTN                      NwAcDSTN                        MT94x Destination
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine.
 
      ** Retrieve Network retention Period.
 
     C                   EXSR      $RtvNWRK
 
      ** Reorganize Schedules.
 
     C                   EXSR      $RgzSchd
 
      ** Reorganize Requests.
 
     C                   EXSR      $RgzRqst
 
      ** Reorganize MT940 details.
 
     C                   EXSR      $RgzMT940
 
      ** Reorganize MT950 details.
 
     C                   EXSR      $RgzMT950
 
     C                   EVAL      *INLR = *On
     C                   RETURN
 
      *========================================================================*
      * $RtvNWRK  : Retrieve Network details.                                  *
      *------------------------------------------------------------------------*
 
     C     $RtvNWRK      BEGSR
      *    --------      -----
 
      ** Retrieve Network retention period.
 
     C                   EVAL      IdNWRK  = *ZEROS
     C                   EVAL      P@OPTN  = '*FIRST'                           Option
 
     C                   DOU       P@RTCD <> *BLANKS
 
     C                   CALLB     'AONWRKR1'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM                    P@OPTN                         Option
     C                   PARM      NwAcNWRK      P@NWRK                         Network
     C     SDNWRK        PARM      SDNWRK        DSLDY
 
     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      IdNWRK = IdNWRK + 1
     C                   EVAL      ArNWRK(IdNWRK) = EDNWRK                      Network
     C                   EVAL      ArRCDT(IdNWRK) = BJRDNB - EDRPSR             Retention Period
     C                   ENDIF
 
     C                   ENDDO
 
      *    ------        -----
     C     @RtvNWRK      ENDSR
 
      *========================================================================*
      * $RgzSchd  : Reorganize Schedules.                                      *
      *------------------------------------------------------------------------*
 
     C     $RgzSchd      BEGSR
      *    --------      -----
 
     C                   EVAL      LstNWRK = *BLANKS
 
      ** Read Schedules.
 
     C     *LOVAL        SETLL     GLGS94D0
     C                   READ      GLGS94D0                               30
 
     C                   DOW       NOT *IN30
 
      ** If new Network, retrieve the corresponding Retention Control Date.
 
     C                   IF        LstNWRK <> GSNWRK
     C                   EVAL      IdNWRK = 1
     C     GSNWRK        LOOKUP    ArNWRK(IdNWRK)                         99
     C   99              EVAL      WkRTCD = ArRCDT(IdNWRK)                      Network Ret. Ctl Dt.
     C  N99              EVAL      WkRTCD = BJRDNB                              Default = Run date
     C                   EVAL      LstNWRK = GSNWRK
     C                   ENDIF
 
      ** Delete the Schedule if Schedule End Date is less than Retention date.
 
     C                   IF        GSEDTE <> *ZEROS
     C                             AND GSEDTE < WkRTCD
     C                   DELETE    GLGS94D0
     C                   ENDIF
 
      ** Read Next Schedule.
 
     C                   READ      GLGS94D0                               30
 
     C                   ENDDO
 
      *    --------      -----
     C     @RgzSchd      ENDSR
 
      *========================================================================*
      * $RgzRqst  : Reorganize Request.                                        *
      *------------------------------------------------------------------------*
 
     C     $RgzRqst      BEGSR
      *    --------      -----
 
     C                   EVAL      LstNWRK = *BLANKS
 
      ** Read Request.
 
     C     *LOVAL        SETLL     GLMR94D0
     C                   READ      GLMR94D0                               31
 
     C                   DOW       NOT *IN31
 
      ** If new Network, retrieve the corresponding Retention Control Date.
 
     C                   IF        LstNWRK <> MRNWRK
     C                   EVAL      IdNWRK = 1
     C     GSNWRK        LOOKUP    ArNWRK(IdNWRK)                         99
     C   99              EVAL      WkRTCD = ArRCDT(IdNWRK)                      Network Ret. Ctl Dt.
     C  N99              EVAL      WkRTCD = BJRDNB                              Default = Run date
     C                   EVAL      LstNWRK = MRNWRK
     C/COPY OFCPYSRCZ,CGL146_137                                                            MD023885
     C                   ENDIF
 
      ** Delete the Request if Request Date is less than Retention date.
 
     C                   IF        MRRDTE < WkRTCD
     C                   DELETE    GLMR94D0
     C                   ENDIF
 
      ** Read Next Schedule.
 
     C                   READ      GLMR94D0                               31
 
     C                   ENDDO
 
      *    --------      -----
     C     @RgzRqst      ENDSR
 
      *========================================================================*
      * $RgzMT940 : Reorganize MT940 details.                                  *
      *------------------------------------------------------------------------*
 
     C     $RgzMT940     BEGSR
      *    ---------     -----
 
     C                   EVAL      *IN01 = *OFF                                 GLNWACPD
     C                   EVAL      *IN02 = *OFF                                 GLNW94PD
 
      ** Read each Network Account for MT94x.
 
     C     *LOVAL        SETLL     GLNW94L0
     C                   READ      GLNW94L0                               28
 
     C                   DOW       NOT *IN28
 
     C                   SELECT
 
      ** The Network Account has been logically deleted.
 
     C                   WHEN      N4RECI <> 'D'
 
      ** Removed records corresponding to the Network Account.
 
     C                   EVAL      KeyMTPY = '940'                              Message Type
 
     C                   EXSR      $RmvPost                                     Remove Postings
 
     C                   EVAL      KeyMTPY = '941'                              Message Type
 
     C                   EXSR      $RmvPost                                     Remove Postings
 
     C                   EXSR      $RmvSchd                                     Remove Schedule
 
     C                   EXSR      $RmvRqst                                     Remove Request
 
     C                   EVAL      KeyMTPY = '942'                              Message Type
 
     C                   EXSR      $RmvPost                                     Remove Postings
 
     C                   EXSR      $RmvSchd                                     Remove Schedule
 
     C                   EXSR      $RmvRqst                                     Remove Request
 
      ** Delete physically the Network Account.
 
     C                   Delete    GLNW94D0
 
      ** If the Network Account has been modified today.
 
     C                   WHEN      N4LCDT = BJRDNB                              Updated today
 
     C                   SELECT
 
      ** No MT940 is required.
 
     C                   WHEN      N4G940 <> 'Y'
 
      ** Removed records corresponding to the Network Account.
 
     C                   EVAL      KeyMTPY = '940'                              Message Type
 
     C                   EXSR      $RmvPost                                     Remove Postings
 
      ** Reset last generation details
 
     C                   EVAL      N40LSD = *ZEROS                              Last statement date
     C                   EVAL      N40LST = *ZEROS                              Last statement time
     C                   EVAL      N40LCA = *ZEROS                              Last closing avail.
 
      ** No MT941 is required.
 
     C                   WHEN      N4G941 <> 'Y'                                No more MT941
 
      ** Removed records corresponding to the Network Account.
 
     C                   EVAL      KeyMTPY = '941'                              Message Type
 
     C                   EXSR      $RmvPost                                     Remove Postings
 
     C                   EXSR      $RmvSchd                                     Remove Schedule
 
     C                   EXSR      $RmvRqst                                     Remove Request
 
      ** Reset last generation details.
 
     C                   EVAL      N41LSD = *ZEROS                              Last statement date
     C                   EVAL      N41LST = *ZEROS                              Last statement time
     C                   EVAL      N41LDN = *ZEROS                              Last sum debit numb.
     C                   EVAL      N41LDA = *ZEROS                              Last sum debit amnt
     C                   EVAL      N41LCN = *ZEROS                              Last sum credit nb.
     C                   EVAL      N41LCA = *ZEROS                              Last sum credit amnt
     C                   EVAL      N41LCB = *ZEROS                              Last closing balance
 
      ** No MT942 is required.
 
     C                   WHEN      N4G942 <> 'Y'                                No more MT942
 
      ** Removed records corresponding to the Network Account.
 
     C                   EVAL      KeyMTPY = '942'                              Message Type
 
     C                   EXSR      $RmvPost                                     Remove Postings
 
     C                   EXSR      $RmvSchd                                     Remove Schedule
 
     C                   EXSR      $RmvRqst                                     Remove Request
 
      ** Reset last generation details
 
     C                   EVAL      N42LSD = *ZEROS                              Last statement date
     C                   EVAL      N42LST = *ZEROS                              Last statement time
     C                   EVAL      N42LDN = *ZEROS                              Last sum debit numb
     C                   EVAL      N42LDA = *ZEROS                              Last sum debit amnt
     C                   EVAL      N42LCN = *ZEROS                              Last sum credit nb.
     C                   EVAL      N42LCA = *ZEROS                              Last sum credit amnt
 
     C                   ENDSL
 
     C                   UPDATE    GLNW94D0
 
     C                   ENDSL
 
      ** Read next GL Posting.
 
     C                   READ      GLNW94L0                               28
 
     C                   ENDDO
 
      *    ---------     -----
     C     @RgzMT940     ENDSR
 
      *========================================================================*
      * $RgzMT950 : Reorganize MT950 details.                                  *
      *------------------------------------------------------------------------*
 
     C     $RgzMT950     BEGSR
      *    ---------     -----
 
     C                   EVAL      *IN01 = *OFF                                 GLNWACPD
     C                   EVAL      *IN02 = *OFF                                 GLNW94PD
 
      ** Read each Network Account for MT950.
 
     C     *LOVAL        SETLL     GLNWACL0
     C                   READ      GLNWACL0                               27
 
     C                   DOW       NOT *IN27
 
     C                   SELECT
 
      ** The Network Account has been logically deleted.
 
     C                   WHEN      NARECI <> 'D'
 
      ** Removed records corresponding to the Network Account.
 
     C                   EVAL      KeyMTPY = '950'                              Message Type
 
     C                   EXSR      $RmvPost                                     Remove Postings
 
      ** Delete physically the Network Account.
 
     C                   Delete    GLNWACD0
 
      ** If the Network Account has been modified today
 
     C                   WHEN      NALCDT = BJRDNB                              Updated today
     C                             AND NAG950 <> 'Y'                            No more MT950
 
      ** Removed records corresponding to the Network Account.
 
     C                   EVAL      KeyMTPY = '950'                              Message Type
 
     C                   EXSR      $RmvPost                                     Remove Postings
 
      ** Reset last generation details
 
     C                   EVAL      NA5LCB = *ZEROS                              Last closing balance
     C                   EVAL      NA5LSD = *ZEROS                              Last statement date
     C                   EVAL      NA5LST = *ZEROS                              Last statement time
 
     C                   UPDATE    GLNWACD0
 
     C                   ENDSL
 
      ** Read next GL Posting.
 
     C                   READ      GLNWACL0                               27
 
     C                   ENDDO
 
      *    ---------     -----
     C     @RgzMT950     ENDSR
 
      *========================================================================*
      * $RmvPost  : Remove the postings for this Network Account.              *
      *------------------------------------------------------------------------*
 
     C     $RmvPost      BEGSR
      *    --------      -----
 
     C                   EVAL      KeyNWRK = NwAcNWRK                           Network
     C                   EVAL      KeyBRCA = NwAcBRCH                           Branch Code
     C                   EVAL      KeyCNUM = NwAcCNUM                           Customer number
     C                   EVAL      KeyCCY  = NwAcCCY                            Currency code
     C                   EVAL      KeyACOD = NwAcACOD                           Account code
     C                   EVAL      KeyACSQ = NwAcACSQ                           Account sequence num
     C                   EVAL      KeyNATY = NwAcNATY                           Network Account Type
     C   01              EVAL      KeyDSTN = *BLANKS                            Destination
     C   02              EVAL      KeyDSTN = NwAcDSTN                           Destination
     C
 
      ** Read Postings for this Network Account.
 
     C     KeyPost       SETLL     GLPOSTD0
     C     KeyPost       READE     GLPOSTD0                               29
 
     C                   DOW       NOT *IN29
 
      ** Delete the posting.
 
     C                   DELETE    GLPOSTD0
 
      ** Read Next Posting for this Network Account.
 
     C     KeyPost       READE     GLPOSTD0                               29
 
     C                   ENDDO
 
      *    ------        -----
     C     @RmvPost      ENDSR
 
      *========================================================================*
      * $RmvSchd  : Remove MT941/942 Generation Schedules for Network Account. *
      *------------------------------------------------------------------------*
 
     C     $RmvSchd      BEGSR
      *    --------      -----
 
     C                   EVAL      KeyNWRK = NwAcNWRK                           Network
     C                   EVAL      KeyBRCA = NwAcBRCH                           Branch Code
     C                   EVAL      KeyCNUM = NwAcCNUM                           Customer number
     C                   EVAL      KeyCCY  = NwAcCCY                            Currency code
     C                   EVAL      KeyACOD = NwAcACOD                           Account code
     C                   EVAL      KeyACSQ = NwAcACSQ                           Account sequence num
     C                   EVAL      KeyNATY = NwAcNATY                           Network Account Type
     C                   EVAL      KeyDSTN = NwAcDSTN                           Destination
     C
 
      ** Read Schedules for this Network Account.
 
     C     KeyPost       SETLL     GLGS94D0
     C     KeyPost       READE     GLGS94D0                               30
 
     C                   DOW       NOT *IN30
 
      ** Delete the Schedule.
 
     C                   DELETE    GLGS94D0
 
      ** Read Next Schedule for this Network Account.
 
     C     KeyPost       READE     GLGS94D0                               30
 
     C                   ENDDO
 
      *    --------      -----
     C     @RmvSchd      ENDSR
 
      *========================================================================*
      * $RmvRqst  : Remove MT941/942 Message Requests for Network Account.     *
      *------------------------------------------------------------------------*
 
     C     $RmvRqst      BEGSR
      *    --------      -----
 
     C                   EVAL      KeyNWRK = NwAcNWRK                           Network
     C                   EVAL      KeyBRCA = NwAcBRCH                           Branch Code
     C                   EVAL      KeyCNUM = NwAcCNUM                           Customer number
     C                   EVAL      KeyCCY  = NwAcCCY                            Currency code
     C                   EVAL      KeyACOD = NwAcACOD                           Account code
     C                   EVAL      KeyACSQ = NwAcACSQ                           Account sequence num
     C                   EVAL      KeyNATY = NwAcNATY                           Network Account Type
     C                   EVAL      KeyDSTN = NwAcDSTN                           Destination
     C
 
      ** Read Requests for this Network Account.
 
     C     KeyPost       SETLL     GLMR94D0
     C     KeyPost       READE     GLMR94D0                               31
 
     C                   DOW       NOT *IN31
 
      ** Delete the requests.
 
     C                   DELETE    GLMR94D0
 
      ** Read Next Request for this Network Account.
 
     C     KeyPost       READE     GLMR94D0                               31
 
     C                   ENDDO
 
      *    --------      -----
     C     @RmvRqst      ENDSR
 
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
 
      ** Retrieve Bank details.
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Key to access posting and schedule files.
 
     C     KeyPost       KLIST
     C                   KFLD                    KeyNWRK                        Network
     C                   KFLD                    KeyBRCA                        Branch Code - Alpha
     C                   KFLD                    KeyCNUM                        Customer number
     C                   KFLD                    KeyCCY                         Currency code
     C                   KFLD                    KeyACOD                        Account code
     C                   KFLD                    KeyACSQ                        Account sequence num
     C                   KFLD                    KeyNATY                        Network Account Type
     C                   KFLD                    KeyDSTN                        Destination
     C                   KFLD                    KeyMTPY                        Message Type
     C/COPY OFCPYSRCZ,CGL146_138                                                            MD023885
 
      *    ------        -----
     C     @INZSR        ENDSR
 
      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
 
     C     *PSSR         BEGSR
      *    ----------    ------
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
 
     C                   RETURN
 
      *    ----------    ------
     C     @PSSR         ENDSR
 
      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002

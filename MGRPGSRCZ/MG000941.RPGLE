     H DEBUG
     H FTRANS
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MG Balance Report message')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  RPGLE/MG000941 - Midas MG Balance Report.                    *
      *                                                               *
      *  Function:  This module generates the MT941 messages for the  *
      *             Message Generation Module                         *
      *                                                               *
      *  Component of: GLC001415                                      *
      *                                                               *
      *  Remark: This module uses prototyped procedures.              *
      *          Their names start by #                               *
      *          They are written in MOD/MGCMNFCT                     *
      *          #SWIFTDt : Convert Midas date to Swift Date.         *
      *          #SWIFTAm : Convert Midas Amount in SWIFT Amount.     *
      *          #RtvTRNO : Retrieve the Transaction Reference.       *
      *          #RtvACID : Retrieve the Account Identifier.          *
      *          #RtvDtTm : Retrieve Date/Time Indication.            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CMG006             Date 15Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL146             Date 10Jul13               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 21May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG006 - MT940, 941, 942 & 950 Field 25 Account              *
      *           Identification.                                     *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *           Added hooks: CGL146_001, CGL146_059, CGL146_060     *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation.                           *
      *                                                               *
      *****************************************************************
 
     FMGF941PD  UF   E             DISK    COMMIT
      ** Midas MG MT941 Gen. Extract File - Account detail
 
     FMGY941L0  UF   E           K DISK    COMMIT
      ** Midas MG MT941 Gen. Extract File - Forwards Balances
 
     FMEP920L0  UF   E           K DISK    COMMIT
      ** Midas ME Incoming MT920 Parts file
 
     FGLNW94L5  IF   E           K DISK
      ** Midas GL Network Accounts - MT94x - Live/Accnt+Dst
 
     FSDCUSTL7  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Customers by unique SWIFT ID
 
     FMGOMSGPD  O    E             DISK    COMMIT  PREFIX(Mo_)
      ** Midas MG Master Message Data file
 
     FMGOREFPD  O    E             DISK    COMMIT  PREFIX(Mr_)
      ** Midas MG Master Messages Reference file
 
     FMG000941AUO    E             PRINTER USROPN
      ** Midas MG Interim Transaction Report - Audit
 
      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 27 - Access MT941 Extract File - Account detail (PF/MGF941PD)          *
      * 28 - Access MT941 Extract File - Forward Balance (LF/MGY941L0)         *
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
 
     D CRLF            C                   CONST(X'0D25')                       CRLF Control Charact
 
      ** Arrays and Data Structures
      ** --------------------------
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data Structure for Bank Details.
 
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      **  Data structure for message management data.
 
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      **  Data Structure for Network Details.
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  Data Structure for Branch details.
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  Data Structure for Currency Details.
 
     D GLACCNT       E DS                  EXTNAME(ACCNTAB)  PREFIX(Gl_)
      **  Data Structure for Account Details.
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
      **  Data Structure for Customer Details.
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(Sc_)
      **  External data structures for Switchable Features Details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  First DS for access programs, long data structure.
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Second DS for access programs, short data structure.
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      **  Third DS for access programs, very long data structure.
 
     D MGAccDetl     E DS                  EXTNAME(MGF941PD)
      **  Data structure for MT942 Account details.
     D**MGNetAcc                     25           OVERLAY(MGAccDetl:1)                        CGL029
      ****Define*the*Network*Account.**********************************                       CGL029
     D**MGAccnt*                     18           OVERLAY(MGAccDetl:7)                        CGL029
      ****Define*the*full*account*number.******************************                       CGL029
     D  ArMGMIO                      65A   DIM(6) OVERLAY(MGAccDetl:139)
      **  Array containing the Manual Prod. Messages from 1 to 6
 
     D MGNetAcc        DS                                                                     CGL029
     D  MGAccnt                      24A   OVERLAY(MGNetAcc:7)                                CGL029
     D  WkNWRK                             LIKE(MGNWRK)                                       CGL029
     D  WkBRCA                             LIKE(MGBRCA)                                       CGL029
     D  WkCUST                             LIKE(MGCNUM)                                       CGL029
     D  WkCCY                              LIKE(MGCCY)                                        CGL029
     D  WkACCD                             LIKE(MGACCD)                                       CGL029
     D  WkACSQ                             LIKE(MGACSQ)                                       CGL029
     D  WkNATY                             LIKE(MGNATY)                                       CGL029
      ** Network and Full Account Data Structure                                              CGL029
                                                                                              CGL029
     D MULT            DS                  OCCURS(200)
      **  Multiple occurrence data structure for message
     D  MTAG                   1      5                                         Tag
     D  MFLD                   6     55                                         Message Field Detail
     D  CTRC                  56     57                                         CR/LF field
 
     D  M              S              5U 0                                      Multi Occurence Idx
     D  P              S              5U 0                                      Previous Occure Idx
     D  L              S              5U 0                                      Last Occurence Idx
 
     D DsMsgRef      E DS                  OCCURS(100)
      **  Data structure to receive Master Messages Reference.
     D                                     EXTNAME(MGOREFPD) PREFIX(Mr_)
 
     D  Mr             S              5U 0                                      Multi Occurence Idx
 
     D DsResult        DS
      **  Data structure to receive result greater than 50 Characters.
     D  WkMult1                      50A                                        Fisrt 50 characters
     D  WkMult2                      50A                                        Last 50 characters
 
      ** Declared variables
      ** ------------------
 
     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option
     D P@NWRK          S              6A                                        Network Code
     D P@SARD          S              6A                                        Feature
     D P@BRCD          S              3A                                        Branch Code
     D P@CNUM          S              6A                                        Customer
     D P@CCY           S              3A                                        Currency Code
     D***P@ACCD*         S              4A                                      Account code  CGL029
     D P@ACCD          S             10A                                                      CGL029
     D P@ACSQ          S              2A                                        Account Sequence
     D P@RETL          S             10A                                        Retail Number
     D P@KEY1          S             10A
     D P@KYST          S              7A
     D KeyIMIR         S                   LIKE(MPIMIR)                         Network
     D KeyMSGR         S                   LIKE(MPMSGR)                         Branch Code - Alpha
     D KeyACTR         S                   LIKE(MPACTR)                         Customer number
 
     D MaxLength       S                   LIKE(ED2MXL)                         Maximum Length
     D CurLength       S                   LIKE(ED2MXL)                         Current Length
     D CurPagSeq       S              5U 0                                      Curr. Page Sequence
     D CurTRNO         S                   LIKE(Mr_TRNO)                        Curr. Transact. Ref.
     D SavNWRK         S                   LIKE(MGNWRK)                         Saved Network
     D SavBRCA         S                   LIKE(MGBRCA)                         Saved Branch code
     D SavCCY          S                   LIKE(MGCCY )                         Saved Currency
     D SavMULT         S             57A                                        Save MULT
 
     D CSW020          S              1    INZ('N')                             SWIFT Decimal Places
     D CMG006          S              1    INZ('N')                                           CMG006
 
     D  X              S              5U 0                                      Working index
     D  WkMGDE         S              6A                                        Working MGDE
     D  WkDRCR         S              1A                                        Working DR/CR sign
     D  WkCnum         S              7
     D  WSwiftId       S             12
     D ACFMTPGM        S             10A                                                      CMG006
     D FldDstn         S             20    INZ('MT94xFld25Dstn')                              CMG006
     D KDstn           S             10A                                                      CMG006
 
     D/COPY MGCPYSRC,MGCMNFCTDC
     D/COPY OFCPYSRCZ,CGL146_001                                                              CGL146
 
      ** Input Specs
      ** -----------
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
      ** Read the first record from the MT941 extract file
 
     C                   READ      MGF941D0                               27
 
      ** Format Message Control.
 
      ** Do While records found on the MT941 extract file
 
     C                   DOW       NOT *IN27
 
      ** Initialize Working fields.
 
     C                   EXSR      $InitWkFld
 
      ** Retrieve Network details.
 
     C                   EXSR      $RtvNwrk
 
      ** Retrieve Branch details.
 
     C                   EXSR      $RtvBrch
 
      ** Retrieve Currency details.
 
     C                   EXSR      $RtvCCY
 
      ** Retrieve Network Account Details.
 
     C                   EXSR      $RtvNWAc
 
      ** Calculate the number of available characters by message.
 
     C                   EXSR      $RtvNbChar
 
      ** Retrieve Message Definition (Tag 20, 21, 25, 28, 13D, 60F, 90D, 90C, 62F, 64)
 
     C                   EXSR      $RtvMsgDfn
 
     C     Key           SETLL     MGY941L0
     C     Key           READE     MGY941D0                               28
     C                   DOW       NOT *IN28
 
      ** If MT941 Forward available balances is required.
      ** The program should at least delete the MGY941PD record.
 
     C                   IF        N41FAB = 'Y'
 
      ** Check the maximun of occurence.
 
      **  The maximum of occurence before to process a new items is:
      **    the number of occurence
      **    - 6 (tag 86 could be on 6 lines)
 
     C                   IF        M >= %ELEM(MULT) - 6
 
      **   Create Message Details.
 
     C                   EXSR      $CrtMsgDtl
 
     C                   ENDIF
 
      ** Save the Previous number of occurence
 
     C                   EVAL      P = M
 
      ** Format field :65:
 
     C                   EXSR      $FMT65
 
      ** Check the maximum length.
 
     C                   IF        CurLength > MaxLength
 
      **   Save the Last number of occurence.
      **   Load M with the previous occurence.
 
     C                   EVAL      L = M
     C                   EVAL      M = P
 
      **   By this way, M contains the occurences to unload on MGOMSGPD,
      **                P contains the last occurence processed,
      **                L contains the last occurence to process.
 
      **   Create Message Details.
 
     C                   EXSR      $CrtMsgDtl
 
      **   Load Master Messages Reference data structure.
 
     C                   EXSR      $LdMsgRef
 
      **   Retrieve Message Definition (Tag 20, 21, 25, 28, 13D, 60F, 90D, 90C, 62F, 64)
 
     C                   EXSR      $RtvMsgDfn
 
      **   Shift the items not process to the correct occurence.
 
     C                   EXSR      $ShiftItem
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Delete Forward Balances.
 
     C                   DELETE    MGY941D0                             99
 
      ** If Error,
 
     C                   IF        *IN99
     C     *LOCK         IN        LDA
     C                   EXSR      SRAccnt                                                    CGL029
     C                   EVAL      DBASE  = 006                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGNetAcc                            *  DBERR 006  *
     C                   EVAL      DBFILE = 'MGY941PD'                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Next Forward Balances.
 
     C     Key           READE     MGY941D0                               28
     C                   ENDDO
 
      ** Format field :86: (additional information for the whole message)
 
     C                   EXSR      $FMT86F
 
      ** Create Message Details
 
     C                   EXSR      $CrtMsgDtl
 
      ** Load Master Messages Reference data structure.
 
     C                   EXSR      $LdMsgRef
 
      ** Create Message Reference.
 
     C                   EXSR      $CrtMsgRef
 
      ** Delete the Message.
 
     C                   DELETE    MGF941D0                             99
 
      ** If Error,
 
     C                   IF        *IN99
     C     *LOCK         IN        LDA
     C                   EXSR      SRAccnt                                                    CGL029
     C                   EVAL      DBASE  = 007                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGNetAcc                            *  DBERR 007  *
     C                   EVAL      DBFILE = 'MGF941PD'                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** COMMIT all changes.
 
     C                   COMMIT
 
      ** Read next messages.
 
     C                   READ      MGF941D0                               27
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *On
     C                   RETURN
 
      *========================================================================*
      * $InitWkFld: Initialize working fields.                                 *
      *------------------------------------------------------------------------*
 
     C     $InitWkFld    BEGSR
      *    ----------    -----
 
     C                   EVAL      MaxLength = *ZEROS                           Maximum Length
     C                   EVAL      Curlength = *ZEROS                           Current Length
     C                   EVAL      CurPagSeq = *ZEROS                           Curr. Page Sequence
     C                   EVAL      CurTRNO   = *BLANKS                          Curr. Transact. Ref.
 
      **  Clear Multi-Occurence for message details (MGOMSGPD)
 
     C     1             DO        200           X
     C     X             OCCUR     MULT
     C                   CLEAR                   MULT
     C                   ENDDO
     C                   EVAL      M = 0
     C     1             OCCUR     MULT
 
      **  Clear Multi-Occurence for message reference (MGOREFPD)
 
     C     1             DO        100           X
     C     X             OCCUR     DsMsgRef
     C                   CLEAR                   DsMsgRef
     C                   ENDDO
     C                   EVAL      Mr = 0
     C     1             OCCUR     DsMsgRef
 
     C     @InitWkFld    ENDSR
      *    --------      -----
 
      *========================================================================*
      * $RtvNwrk: Retrieve Network details.                                    *
      *------------------------------------------------------------------------*
 
     C     $RtvNwrk      BEGSR
      *    --------      -----
 
     C                   IF        SavNWRK <> MGNWRK
 
     C                   CALLB     'AONWRKR1'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      MGNWRK        P@NWRK                         Network
     C     SDNWRK        PARM      SDNWRK        DSLDY
 
      ** If error,
 
     C                   IF        P@RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 001                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGNWRK                              *  DBERR 001  *
     C                   EVAL      DBFILE = 'SDNWRKPD'                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SAvNWRK = MGNWRK
 
     C                   ENDIF
 
      *    --------      -----
     C     @ChkNwrk      ENDSR
 
      *========================================================================*
      * $RtvBrch: Retrieve Branch details.                                     *
      *------------------------------------------------------------------------*
 
     C     $RtvBrch      BEGSR
      *    --------      -----
 
     C                   IF        SavBRCA <> MGBRCA
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      MGBRCA        P@BRCD                         Branch Code
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** If error,
 
     C                   IF        P@RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 002                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGBRCA                              *  DBERR 002  *
     C                   EVAL      DBFILE = 'SDBRCHPD'                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SAvBRCA = MGBRCA
 
     C                   ENDIF
 
      *    --------      -----
     C     @RtvBrch      ENDSR
 
      *========================================================================*
      * $RtvCCY: Retrieve Currency details.                                    *
      *------------------------------------------------------------------------*
 
     C     $RtvCCY       BEGSR
      *    -------       -----
 
     C                   IF        SavCCY  <> MGCCY
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      MGCCY         P@CCY                          Currency
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** If Error,
 
     C                   IF        P@RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 003                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGCCY                               *  DBERR 003  *
     C                   EVAL      DBFILE = 'SDCURRPD'                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SAvCCY  = MGCCY
 
     C                   ENDIF
 
      *    -------       -----
     C     @RtvCCY       ENDSR
 
      *========================================================================*
      * $RtvNwAc: Retrieve Network Account Details.                            *
      *------------------------------------------------------------------------*
 
     C     $RtvNwAc      BEGSR
      *    --------      -----
 
     C     Key           CHAIN     GLNW94D0                           99
 
      ** If Error,
 
     C                   IF        *IN99
     C     *LOCK         IN        LDA
     C                   EXSR      SRAccnt                                                    CGL029
     C                   EVAL      DBASE  = 004                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGNetAcc                            *  DBERR 004  *
     C                   EVAL      DBFILE = 'GLNW94PD'                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve account details (Account Type)
 
     C                   MOVEL     MGCNUM        P@CNUM                         Customer
     C                   MOVEL     MGACCD        P@ACCD                         Account code
     C                   MOVEL     MGACSQ        P@ACSQ                         Account Sequence
 
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      *BLANKS       P@RETL                         Retail Number
     C                   PARM                    P@CNUM                         Customer
     C                   PARM      MGCCY         P@CCY                          Currency
     C                   PARM                    P@ACCD                         Account code
     C                   PARM                    P@ACSQ                         Account Sequence
     C                   PARM      MGBRCA        P@BRCD                         Branch Code
     C     GLACCNT       PARM      GLACCNT       DSSDY
 
      ** Add the issue on the audit report.
 
     C                   IF        P@RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EXSR      SRAccnt                                                    CGL029
     C                   EVAL      DBASE  = 005                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGAccnt                             *  DBERR 005  *
     C                   EVAL      DBFILE = 'ACCNTAB'                           * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Exsr      SrGetDs                                                    CMG006
 
      *    --------      -----
     C     @RtvNwAc      ENDSR
 
      *========================================================================*
      * $RtvNbChar: Calculate the number of available characters by message.   *
      *------------------------------------------------------------------------*
 
     C     $RtvNbChar    BEGSR
      *    ----------    -----
 
     C                   EVAL      MaxLength = ED1MXL                           MT941 maximum length
 
      ** Information to Account Owner.
 
     C     1             DO        6             X
 
      ** If the current Add. Info. is empty, the next one also.
      ** So,we can stop this processing.
 
     C                   IF        ArMGMIO(X) = *BLANKS
     C                   LEAVE
     C                   ENDIF
     C
     C                   IF        X = 1
     C                   EVAL      MaxLength = MaxLength                        Max. Length
     C                                         - 4                              :86:
     C                   ENDIF
 
     C                   EVAL      MaxLength = MaxLength                        Max. Length
     C                                         - %LEN(%TRIM(ArMGMIO(X)))        Msg Level Info 1-6
     C                                         - 2                              CRLF
     C                   ENDDO
 
      *    --------      -----
     C     @RtvNbChar    ENDSR
 
      *========================================================================*
      * $RtvMsgDfn: Retrieve Message Definition:                               *
      *             Tag 20, 21, 25, 28, 13D, 60F, 90D, 90C, 62F, 64            *
      *------------------------------------------------------------------------*
 
     C     $RtvMsgDfn    BEGSR
      *    ----------    -----
 
      ** Format field :20:
 
     C                   EXSR      $FMT20
 
      ** Format field :21:
 
     C                   EXSR      $FMT21
 
      ** Format field :25:
 
     C                   EXSR      $FMT25
 
      ** Format field :28:
 
     C                   EXSR      $FMT28
 
      ** Format field :13D:
 
     C                   EXSR      $FMT13D
 
      ** Format field :60F:
 
     C                   EXSR      $FMT60F
 
      ** Format field :90D:
 
     C                   EXSR      $FMT90D
 
      ** Format field :90C:
 
     C                   EXSR      $FMT90C
 
      ** Format field :62F:
 
     C                   EXSR      $FMT62F
 
      ** Format field :64:
 
     C                   EXSR      $FMT64
 
      *    ----------    -----
     C     @RtvMsgDfn    ENDSR
 
      *========================================================================*
      * $FMT20  : Transaction Reference Number.                                *
      *------------------------------------------------------------------------*
 
     C     $FMT20        BEGSR
      *    ------        -----
 
      ** The Transaction reference is 'GL' + Rundate in format YYMMDD + Sequence hold
      ** in DTAARA/MGMT94DA.
 
     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
 
     C                   EVAL      MTAG = ':20:'                                Tag
     C                   EVAL      MFLD = #RtvTRNO('GL':#SWIFTDt(BJRDNB))       Build TRNO
     C                   EVAL      CTRC = CRLF                                  CR/LF field
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
 
      ** Load the current Transaction Ref.
 
     C                   EVAL      CurTRNO = MFLD                               Curr. Transac. Ref
 
      ** Update 920 parts details
 
     C     MGFL25        IFNE      *BLANKS
     C                   EXSR      $MEP920
     C                   ENDIF
 
      *    ------        -----
     C     @FMT20        ENDSR
 
      *========================================================================*
      * $FMT21  : Related Reference.                                           *
      *------------------------------------------------------------------------*
 
     C     $FMT21        BEGSR
      *    ------        -----
 
      ** If a related Reference exists.
 
     C                   IF        MGRREF <> *BLANKS
 
     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
 
     C                   EVAL      MTAG = ':21:'                                Tag
     C                   EVAL      MFLD = MGRREF                                Related Reference
     C                   EVAL      CTRC = CRLF                                  CR/LF field
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
     C                   ENDIF
 
      *    -------       -----
     C     @FMT21        ENDSR
 
      *========================================================================*
      * $FMT25  : Account Identification.                                      *
      *------------------------------------------------------------------------*
 
     C     $FMT25        BEGSR
      *    ------        -----
 
      ** The Account Identifier is:
      **   - MT920 Account Identifier if exist,
      **   - else, the IBAN if exist,
      **   - else, the Retail Account if exist,
      **   - else, the Full Account with the branch if multi-branching environment,
 
     C                   If        CMG006 = 'Y'                                               CMG006
     C                   CLEAR                   ACFMTPGM                                     CMG006
     C                   Endif                                                                CMG006
 
     C                   IF        CMG006  = 'Y' and P@NWRK = 'SWIFT'                         CMG006
     C                                           and WDstn =  KDstn                           CMG006
     C                   EVAL      ACFMTPGM = 'MGFLD25'                                       CMG006
     C                   Endif                                                                CMG006
     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
 
     C                   EVAL      MTAG = ':25:'                                Tag
     C                   EXSR      SRAccnt                                                    CGL029
     C                   EVAL      MFLD = #RtvACID(MGAccnt:                     Full Account
     C                                             MGACNO:                      Retail Account
     C                                             MGIBAN:                      IBAN
     C**********                                   MGFL25)                      MT920 Acc. IdeCMG006
     C                                             MGFL25:                      MT920 Acc. IdeCMG006
     C                                             ACFMTPGM)                    Format Pgm    CMG006
     C
     C                   EVAL      CTRC = CRLF                                  CR/LF field
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
      *    -------       -----
     C     @FMT25        ENDSR
 
      *========================================================================*
      * $FMT28  : Page Number/Continuation Identifier.                         *
      *------------------------------------------------------------------------*
 
     C     $FMT28        BEGSR
      *    ------        -----
 
     C                   EVAL      CurPagSeq = CurPagSeq + 1                    Current Page Seq
 
     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
 
     C                   EVAL      MTAG = ':28:'                                Tag
     C                   EVAL      MFLD = %CHAR(MGSTNO)                         Statement Page Numb
     C                                    + '/'                                 /
     C                                    + %CHAR(CurPagSeq)                    Current Page Seq
     C
     C                   EVAL      CTRC = CRLF                                  CR/LF field
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
      *    ------        -----
     C     @FMT28        ENDSR
 
      *========================================================================*
      * $FMT13D : Date/Time Indicator.                                         *
      *------------------------------------------------------------------------*
 
     C     $FMT13D       BEGSR
      *    -------       -----
 
      ** IF MT941 Date/Time is required.
 
     C                   IF        N41DTI = 'Y'
 
     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
 
     C                   EVAL      MTAG = ':13D:'                               Tag
     C                   EVAL      MFLD = #RtvDtTm(N42LSD:                      Last statement date
     C                                             N42LST:                      Last statement time
     C                                             A8TMOF:                      Time Offset against
     C                                             A8SIGN:                      Time Offset Sign
     C                                             A8STOF:                      System Time Offset
     C                                             A8SSIN)                      System Time Offset S
 
     C                   EVAL      CTRC = CRLF                                  CR/LF field
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
 
     C                   ENDIF
 
      *    -------       -----
     C     @FMT13D       ENDSR
 
      *========================================================================*
      * $FMT60F  : Opening Balance.                                            *
      *------------------------------------------------------------------------*
 
     C     $FMT60F       BEGSR
      *    -------       -----
 
      ** Opening Balance
      **   D/C mark
      **   Date
      **   SWIFT Currency Code
      **   Amount
 
      **  If MT941 Opening balance information is required.
 
     C                   IF        N41OBI = 'Y'
 
      ** Retrieve the sign of the amount.
 
     C                   IF        MGOBAL > *ZEROS
     C                   EVAL      WkDRCR = 'D'                                 Debit
     C                   ELSE
     C                   EVAL      WkDRCR = 'C'                                 Credit
     C                   ENDIF
 
     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
 
     C                   EVAL      MTAG = ':60F:'                               Tag
     C                   EVAL      MFLD = WkDRCR +                              Debit / Credit
     C                                    #SWIFTDt(MGLSDT) +                    Last Statement Date
     C                                    A6SWCY +                              SWIFT Currency Code
     C                                    #SWIFTAm(%ABS(MGOBAL):                Openning Balance
     C                                             A6NBDP:                      Number of Decimal Pl
     C                                             A6SWDP:                      SWIFT Number of Deci
     C                                             CSW020)                      Feature
 
     C                   EVAL      CTRC = CRLF                                  CR/LF field
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
 
     C                   ENDIF
 
      *    -------       -----
     C     @FMT60F       ENDSR
 
      *========================================================================*
      * $FMT90D  : Number and Sum of Entries.                                  *
      *------------------------------------------------------------------------*
 
     C     $FMT90D       BEGSR
      *    -------       -----
 
      ** Number and Sum of entres
      **   Number of Debit
      **   SWIFT Currency Code
      **   Sum of Debit Posting
 
      **  If MT941 Number and sum of fields are required.
 
     C                   IF        N41LSF = 'Y'
 
     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
 
     C                   EVAL      MTAG = ':90D:'                               Tag
     C                   EVAL      MFLD = %TRIM(%CHAR(MGNBDB)) +                Number of Debit
     C                                    A6SWCY +                              SWIFT Currency Code
     C                                    #SWIFTAm(MGSMDB:                      Sum of Debit Posting
     C                                             A6NBDP:                      Number of Decimal Pl
     C                                             A6SWDP:                      SWIFT Number of Deci
     C                                             CSW020)                      Feature
 
     C                   EVAL      CTRC = CRLF                                  CR/LF field
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
 
     C                   ENDIF
 
      *    -------       -----
     C     @FMT90D       ENDSR
 
      *========================================================================*
      * $FMT90C  : Number and Sum of Entries.                                  *
      *------------------------------------------------------------------------*
 
     C     $FMT90C       BEGSR
      *    -------       -----
 
      ** Number and Sum of entres
      **   Number of Credit
      **   SWIFT Currency Code
      **   Sum of credit Posting
 
      **  If MT941 Number and sum of fields are required.
 
     C                   IF        N41LSF = 'Y'
 
     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
 
     C                   EVAL      MTAG = ':90C:'                               Tag
     C                   EVAL      MFLD = %TRIM(%CHAR(MGNBCR)) +                Number of Credit
     C                                    A6SWCY +                              SWIFT Currency Code
     C                                    #SWIFTAm(MGSMCR:                      Sum of Crebit Postin
     C                                             A6NBDP:                      Number of Decimal Pl
     C                                             A6SWDP:                      SWIFT Number of Deci
     C                                             CSW020)                      Feature
 
     C                   EVAL      CTRC = CRLF                                  CR/LF field
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
 
     C                   ENDIF
 
      *    -------       -----
     C     @FMT90C       ENDSR
 
      *========================================================================*
      * $FMT62F  : Closing Balance (Booked Funds).                             *
      *------------------------------------------------------------------------*
 
     C     $FMT62F       BEGSR
      *    -------       -----
 
      ** Closing Balance (Booked Funds)
      **   D/C mark
      **   Date
      **   SWIFT Currency Code
      **   Amount
 
      ** Retrieve the sign of the amount.
 
     C                   IF        MGCBBF > *ZEROS
     C                   EVAL      WkDRCR = 'D'                                 Debit
     C                   ELSE
     C                   EVAL      WkDRCR = 'C'                                 Credit
     C                   ENDIF
 
     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
 
     C                   EVAL      MTAG = ':62F:'                               Tag
     C                   EVAL      MFLD = WkDRCR +                              Debit / Credit
     C                                    #SWIFTDt(N41LSD) +                    Last Statement Date
     C                                    A6SWCY +                              SWIFT Currency Code
     C                                    #SWIFTAm(%ABS(MGCBBF):                Closing Bal. Booked
     C                                             A6NBDP:                      Number of Decimal Pl
     C                                             A6SWDP:                      SWIFT Number of Deci
     C                                             CSW020)                      Feature
 
     C                   EVAL      CTRC = CRLF                                  CR/LF field
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
      *    -------       -----
     C     @FMT62F       ENDSR
 
      *========================================================================*
      * $FMT64   : Closing Balance (Available Funds).                          *
      *------------------------------------------------------------------------*
 
     C     $FMT64        BEGSR
      *    ------        -----
 
      ** Closing Balance (Available Funds)
      **   D/C mark
      **   Date
      **   SWIFT Currency Code
      **   Amount
 
      **  If MT941 Closing available balance is required and available.
      *******-> Retail account or Nostro.***********************
 
     C                   IF        N41CAB = 'Y'
     C*******                      AND Gl_ATYP = 'R'
     C*******                      OR N41CAB = 'Y'
     C*******                      AND Gl_ATYP = 'N'
 
      ** Retrieve the sign of the amount.
 
     C                   IF        MGCBAF > *ZEROS
     C                   EVAL      WkDRCR = 'D'                                 Debit
     C                   ELSE
     C                   EVAL      WkDRCR = 'C'                                 Credit
     C                   ENDIF
 
     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
 
     C                   EVAL      MTAG = ':64:'                                Tag
     C                   EVAL      MFLD = WkDRCR +                              Debit / Credit
     C                                    #SWIFTDt(N41LSD) +                    Last Statement Date
     C                                    A6SWCY +                              SWIFT Currency Code
     C                                    #SWIFTAm(%ABS(MGCBAF):                Closing Bal. Availab
     C                                             A6NBDP:                      Number of Decimal Pl
     C                                             A6SWDP:                      SWIFT Number of Deci
     C                                             CSW020)                      Feature
 
     C                   EVAL      CTRC = CRLF                                  CR/LF field
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
 
     C                   ENDIF
 
      *    ------        -----
     C     @FMT64        ENDSR
 
      *========================================================================*
      * $FMT65   : Forward Available Balance.                                  *
      *------------------------------------------------------------------------*
 
     C     $FMT65        BEGSR
      *    ------        -----
 
      ** Forward Available Balance
      **   D/C mark
      **   Date
      **   SWIFT Currency Code
      **   Amount
 
      ** Retrieve the sign of the amount.
 
     C                   IF        MGFAMT > *ZEROS
     C                   EVAL      WkDRCR = 'D'                                 Debit
     C                   ELSE
     C                   EVAL      WkDRCR = 'C'                                 Credit
     C                   ENDIF
 
     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
 
     C                   EVAL      MTAG = ':65:'                                Tag
     C                   EVAL      MFLD = WkDRCR +                              Debit / Credit
     C                                    #SWIFTDt(MGFVDT) +                    Forward Value Date
     C                                    A6SWCY +                              SWIFT Currency Code
     C                                    #SWIFTAm(%ABS(MGFAMT):                Forward Available Ba
     C                                             A6NBDP:                      Number of Decimal Pl
     C                                             A6SWDP:                      SWIFT Number of Deci
     C                                             CSW020)                      Feature
 
     C                   EVAL      CTRC = CRLF                                  CR/LF field
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
      *    ------        -----
     C     @FMT65        ENDSR
 
      *========================================================================*
      * $FMT86F : Information to Account Owner for whole message.              *
      *------------------------------------------------------------------------*
 
     C     $FMT86F       BEGSR
      *    -------       -----
 
     C     1             DO        6             X
 
      ** If the current Add. Info. is empty, the next one also.
      ** So,we can stop this processing.
 
     C                   IF        ArMGMIO(X) = *BLANKS
     C                   LEAVE
     C                   ENDIF
 
      ** Retrieve Field 86 details.
 
     C                   EVAL      DsResult = %TRIM(ArMGMIO(X))                 Additional Info.
 
      ** For Field 86 the maximum length is 65 characters,
      ** So, the result could be divided in 2 Occurances.
 
     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
 
     C                   IF        X = 1
     C                   EVAL      MTAG = ':86:'                                Tag
     C                   ENDIF
 
      ** Load the first 50 Characters
 
     C                   EVAL      MFLD = WkMult1                               First 50 Characters
 
      ** If the result is greater than 50 characters,
 
     C                   IF        WkMult2 <> *BLANKS
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
 
     C                   EVAL      M = M + 1                                    Next Occurance
     C     M             OCCUR     MULT
 
     C                   EVAL      MFLD = WkMult2                               Last 50 Characters
 
     C                   ENDIF
 
     C                   EVAL      CTRC = CRLF                                  CR/LF field
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
 
     C                   ENDDO
 
      *    -------       -----
     C     @FMT86F       ENDSR
 
      *========================================================================*
      * $CrtMsgDtl : Create Message details.                                   *
      *------------------------------------------------------------------------*
 
     C     $CrtMsgDtl    BEGSR
      *    ----------    -----
 
      ** Unload multi-occurence MULT in PF/MGOMSGPD.
 
     C     1             DO        M             X
 
     C     X             OCCUR     MULT
     C                   CLEAR                   MGOMSGD0
     C                   EVAL      Mo_MTAG = MTAG                               Message field Tag
     C                   EVAL      Mo_MFLD = MFLD                               Message Field Data
     C                   EVAL      Mo_CTRC = CTRC                               CRLF Control Charact
     C                   EVAL      Mo_TRNO = CurTRNO                            Transaction referenc
     C                   WRITE     MGOMSGD0
     C                   CLEAR                   MULT
 
     C                   ENDDO
 
      ** Position to the beginning of the Multi-Ocurrance
 
     C                   EVAL      M = 0
     C     1             OCCUR     MULT
 
      *    ----------    -----
     C     @CrtMsgDtl    ENDSR
 
      *========================================================================*
      * $LdMsgRef : Load Master Messages Reference data structure.             *
      *------------------------------------------------------------------------*
 
     C     $LdMsgRef     BEGSR
      *    ---------     -----
 
     C                   ADD       1             Mr
 
     C     Mr            OCCUR     DsMsgRef
 
     C                   EVAL      Mr_MODI = 'GL'                               General Ledger
     C                   EVAL      Mr_TRNO = CurTRNO                            Transaction referenc
     C                   IF        MGRNWK <> *BLANKS
     C                   EVAL      Mr_NWRK = MGRNWK                             Requested Network
     C                   ELSE
     C                   EVAL      Mr_NWRK = MGNWRK                             Network
     C                   ENDIF
     C/COPY OFCPYSRCZ,CGL146_059                                                              CGL146
     C                   MOVE      A8BICN        Mr_SECN                        Customer no of Send.
     C                   EVAL      Mr_NWSN = A8BTID                             Branch TID Address
 
      **  Default Customer no of destination.
      **  If the destination is a customer number, load the destination,
      **  Otherwide, the customer number of the account.
 
     C**********         EVAL      WkCnum = %Subst(MGDSTN:1:6) + '0'                          CSD027
     C**********         TESTN                   WkCnum               99                      CSD027
     C                   IF        %Subst(MGDSTN:7:4) = *BLANKS
     C**********                   AND *IN99                                                  CSD027
     C                   MOVEL     MGDSTN        Mr_DECN
     C                   ELSE
     C                   EVAL      Mr_DECN = MGCNUM
     C                   ENDIF
 
      **  Default Destination.
 
     C                   EVAL      Mr_NWDS = MGDSTN
 
      **  If the destination is a SWIFT address, retrieves the customer number of
      **  destination.
     C                   IF        %Subst(MGDSTN : 7 : 4) <> *Blanks
 
     C                   EVAL      WSwiftId = MGDSTN
     C     WSwiftId      CHAIN     @CUSTGE                            99
     C**  Try removing branch 'XXX' if fails the first time.
     C                   IF        *IN99 = *ON And
     C                             %Subst(WSwiftId : 9 : 3) = 'XXX'
     C                   EVAL      %Subst(WSwiftId : 9 : 3) = '   '
     C     WSwiftId      CHAIN     @CUSTGE                            99
     C                   ENDIF
     C                   IF        *IN99 = *OFF
     C                   MOVEL     BBCUST        Mr_DECN
     C                   ENDIF
     C
      **  If the destination is a customer number, retrieve the SWIFT address of dest.
     C
     C                   ELSE
     C
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      MGDSTN        P@KEY1
     C                   PARM                    P@KYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        P@RTCD = *BLANKS
     C                   MOVEL     BBCUST        Mr_DECN
     C                   IF        BBCSID <> *BLANKS
     C                   EVAL      Mr_NWDS = BBCSID
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C
     C                   EVAL      Mr_MTPY = '941'                              Message Type
     C                   EVAL      Mr_MPRY = 'N'                                Message Priority
     C                   SELECT
     C                   WHEN      MGDMST = 'C'                                 Created
     C                   EVAL      Mr_MGSG = '1'                                Msg Status Group
     C                   EVAL      Mr_MGST = 'CRTD'                             Message Status
     C                   WHEN      MGDMST = 'R'                                 Ready to send
     C                   EVAL      Mr_MGSG = '2'                                Msg Status Group
     C                   EVAL      Mr_MGST = 'RSND'                             Message Status
     C                   WHEN      MGDMST = 'D'                                 Deleted
     C                   EVAL      Mr_MGSG = '4'                                Msg Status Group
     C                   EVAL      Mr_MGST = 'DLTD'                             Message Status
     C                   ENDSL
     C                   EVAL      Mr_HRDT = #SWIFTDt(BJRDNB+ENDSMN)            History Retention Dt
     C                   EVAL      WkMGDE  = #SWIFTDt(N41LSD)                   Msg Generation Date
     C                   MOVE      WkMGDE        Mr_MGDE                        Msg Generation Date
     C                   EVAL      Mr_MGTM = N41LST                             Msg Generation Time
     C                   EVAL      Mr_LADT = BJMRDT                             Last Action date
     C                   TIME                    Mr_LATM                        Last Action time
     C                   EVAL      Mr_CCY  = MGCCY                              Last Action date
     C                   IF        MGACNO <> *ZEROS                             Account Number SWIFT
     C                   MOVEL(P)  MGACNO        Mr_SACN                        Retail Account Numb.
     C                   ELSE
     C                   EXSR      SRAccnt                                                    CGL029
     C                   MOVE(P)   MGAccnt       Mr_SACN                        Full Account Number
     C                   ENDIF
     C                   IF        Gl_ATYP = 'R'                                Account Type A or R
     C                   EVAL      Mr_AORR = 'R'                                Retail
     C                   ELSE
     C                   EVAL      Mr_AORR = 'A'                                Other
     C                   ENDIF
     C                   EVAL      Mr_DESI = 'N'                                Demand Statement Id.
     C                   EVAL      Mr_BRCA = MGBRCA                             Branch Code
     C                   EVAL      Mr_CIND = '2'                                1 = 1999, 2 =2000
 
      ** Reset working fields.
 
     C                   EVAL      Curlength = *ZEROS                           Current Length
     C                   EVAL      CurTRNO   = *BLANKS                          Curr. Transact. Ref.
 
      *    ----------    -----
     C     @LdMsgRef     ENDSR
 
      *========================================================================*
      * $ShiftItem : Shift the items not process to the correct occurence.     *
      *------------------------------------------------------------------------*
 
     C     $ShiftItem    BEGSR
      *    ----------    -----
 
      ** Remark:  M contains the occurences to unload on MGOMSGPD,
      **          P contains the last occurence processed,
      **          L contains the last occurence to process.
 
      ** Position on the first occurence to process.
 
     C                   EVAL      P = P + 1
     C     P             DO        L             X
 
      ** Load working field with item detail to move.
 
     C     X             OCCUR     MULT
     C                   EVAL      SavMULT = MULT
 
      ** Release the old occurence.
 
     C                   CLEAR                   MULT
 
      ** Load working correct occurence with item detail.
 
     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
     C                   EVAL      MULT = SavMULT
 
     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
     C                   ENDDO
 
      *    ----------    -----
     C     @ShiftItem    ENDSR
 
      *========================================================================*
      * $CrtMsgRef : Create Message reference.                                 *
      *------------------------------------------------------------------------*
 
     C     $CrtMsgRef    BEGSR
      *    ----------    -----
 
      ** Unload multi-occurence DsMsgRef in PF/MGOREFPD.
 
     C     1             DO        Mr            X
 
      ** The multi-occurence DsMsgRef has the same layout as PF/MGOREFPD.
 
     C     X             OCCUR     DsMsgRef
     C                   WRITE     MGOREFD0
 
     C                   ENDDO
 
      *    ----------    -----
     C     @CrtMsgRef    ENDSR
 
      *========================================================================*
      * $MEP920    : Update MEP920PD parts details                             *
      *------------------------------------------------------------------------*
 
     C     $MEP920       BEGSR
      *    -------       -----
 
      ** Key to access 920 parts file
 
     C     KMEP          KLIST
     C                   KFLD                    KeyIMIR                        Network
     C                   KFLD                    KeyMSGR                        Branch Code - Alpha
     C                   KFLD                    KeyACTR                        Customer number
 
     C                   MOVEL     MGIMIR        KeyIMIR
     C                   MOVEL     '941'         KeyMSGR
     C                   MOVEL     MGFL25        KeyACTR
 
      **  Find record
 
     C     KMEP          CHAIN     MEP920L0                           99
 
     C                   IF        NOT *IN99
     C                   EVAL      MPM94X = MFLD                                Curr. Transac. Ref
     C                   UPDATE    MEP920P0
     C                   ENDIF
 
      *    -------       -----
     C     @MEP920       ENDSR
      *****************************************************************                       CGL029
      /EJECT                                                                                  CGL029
      *****************************************************************                       CGL029
      *                                                               *                       CGL029
      *  SRAccnt - Handles the Network Account and Full Account.      *                       CGL029
      *                                                               *                       CGL029
      *****************************************************************                       CGL029
     C     SRAccnt       BEGSR                                                                CGL029
      *                                                                                       CGL029
     C                   MOVE      MGNWRK        WkNWRK                                       CGL029
     C                   MOVE      MGBRCA        WkBRCA                                       CGL029
     C                   MOVE      MGCNUM        WkCUST                                       CGL029
     C                   MOVE      MGCCY         WkCCY                                        CGL029
     C                   MOVE      MGACCD        WkACCD                                       CGL029
     C                   MOVE      MGACSQ        WkACSQ                                       CGL029
     C                   MOVE      MGNATY        WkNATY                                       CGL029
      *                                                                                       CGL029
     C                   ENDSR                                                                CGL029
      *****************************************************************                       CGL029
      /EJECT                                                                                  CGL029
      *****************************************************************                       CGL029
 
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *------------------------------------------------------------------------*
 
     C     *INZSR        BEGSR
      *    ------        -----
 
      ** Initialise Copyright Array
 
     C                   MOVEA     CPY@          CPY@@            80
 
      ** Initialise LDA
 
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBPGM
     C                   MOVEL     PSProcMod     DBMOD
     C                   OUT       LDA
 
      ** Retrieve Bank details.
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDBANK        PARM      SDBANK        DSFDY
 
      **  Access SDMGMEPD for message management data.
 
     C                   CALL      'AOMGMER0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDMGME        PARM      SDMGME        DSFDY
 
      ** Check if feature CSW020 'SWIFT Decimal Places' is present.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      'CSW020'      P@SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CSW020
     C                   ENDIF
     C/COPY OFCPYSRCZ,CGL146_060                                                              CGL146
      ** Check if feature CMG006 is switched on.                                              CMG006
 
     C                   CALL      'AOSARDR0'                                                 CMG006
     C                   PARM      *BLANKS       P@RTCD                                       CMG006
     C                   PARM      '*KEY   '     P@OPTN                                       CMG006
     C                   PARM      'CMG006'      P@SARD                                       CMG006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CMG006
      *
     C     P@RTCD        IFEQ      *BLANKS                                                    CMG006
     C                   MOVE      'Y'           CMG006                                       CMG006
     C                   ENDIF                                                                CMG006
      * Check system values                                                                   CMG006
     C                   CALL      'AOSVALR0'                                                 CMG006
     C                   PARM                    @RTCD             7                          CMG006
     C                   PARM      FldDstn       SVALK1           20                          CMG006
     C                   PARM                    SVAL1           200                          CMG006
     C                   PARM      *BLANK        SVALK2           20                          CMG006
     C                   PARM                    SVAL2           200                          CMG006
     C                   PARM      *BLANK        SVALK3           20                          CMG006
     C                   PARM                    SVAL3           200                          CMG006
     C                   PARM      *BLANK        SVALK4           20                          CMG006
     C                   PARM                    SVAL4           200                          CMG006
     C                   PARM      *BLANK        SVALK5           20                          CMG006
     C                   PARM                    SVAL5           200                          CMG006
     C                   PARM      *BLANK        SVALK6           20                          CMG006
     C                   PARM                    SVAL6           200                          CMG006
     C                   PARM      *BLANK        SVALK7           20                          CMG006
     C                   PARM                    SVAL7           200                          CMG006
     C                   PARM      *BLANK        SVALK8           20                          CMG006
     C                   PARM                    SVAL8           200                          CMG006
     C                   PARM      *BLANK        SVALK9           20                          CMG006
     C                   PARM                    SVAL9           200                          CMG006
     C                   PARM      *BLANK        SVALK0           20                          CMG006
     C                   PARM                    SVAL10          200                          CMG006
      *                                                                                       CMG006
     C     @RTCD         IFNE      *BLANK                                                     CMG006
     C                   MOVEL     FldDstn       DBKEY                                        CMG006
     C                   MOVEL     'SDSVALPD'    DBFILE                                       CMG006
     C                   MOVEL     '001'         DBASE                                        CMG006
     C                   SETON                                        U7U8                    CMG006
     C                   EXSR      *PSSR                                                      CMG006
 
     C                   ELSE                                                                 CMG006
 
     C                   MOVEL     SVAL1         WDstn            10            Dstn Destn    CMG006
 
     C                   ENDIF                                                                CMG006
      ** Key to access Network Account or Posting details.
 
     C     Key           KLIST
     C                   KFLD                    MGNWRK                         Network
     C                   KFLD                    MGBRCA                         Account Branch
     C                   KFLD                    MGCNUM                         Account Customer
     C                   KFLD                    MGCCY                          Account Currency
     C                   KFLD                    MGACCD                         Account Code
     C                   KFLD                    MGACSQ                         Account Sequence
     C                   KFLD                    MGNATY                         Network Account type
     C                   KFLD                    MGDSTN                         MT94x Destination
 
      *    ------        -----
     C     @INZSR        ENDSR
 
      *****************************************************************                       CMG006
      * SrGetDS - Get SWIFT Destination                               *                       CMG006
      *****************************************************************                       CMG006
     C     SrGetDs       BEGSR                                                                CMG006
      **    Default Destination.                                                              CMG006
     C                   Eval      Kdstn   =     MGDSTN                                       CMG006
                                                                                              CMG006
      *   If the destination is a SWIFT address, retrieves the customer number of             CMG006
      *   destination.                                                                        CMG006
     C                   IF        %Subst(MGDSTN : 7 : 4) =  *Blanks                          CMG006
      *   If the destination is a customer number, retrieve the SWIFT address of dest.        CMG006
     C                                                                                        CMG006
     C                   CALLB     'AOCUSTR0'                                                 CMG006
     C                   PARM      *BLANKS       P@RTCD            7                          CMG006
     C                   PARM      '*KEY'        P@OPTN            7                          CMG006
     C                   PARM      MGDSTN        P@KEY1           10                          CMG006
     C                   PARM                    P@KYST            7                          CMG006
     C     SDCUST        PARM      SDCUST        DSSDY                                        CMG006
                                                                                              CMG006
     C                   If        P@RTCD = *BLANKS   and  BBCSID <> *BLANKS                  CMG006
     C                   Movel     BBCSID        Kdstn                                        CMG006
     C                   Endif                                                                CMG006
     C                   Endif                                                                CMG006
      *                                                                                       CMG006
     C                   ENDSR                                                                CMG006
      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
 
     C     *PSSR         BEGSR
      *    ----------    ------
 
      **  Write database error to report
 
     C                   OPEN      MG000941AU
     C                   WRITE     HEADAU
     C                   EXSR      SRAccnt                                                    CGL029
     C                   EVAL      DNTAC = MGNetAcc                             Network Account
     C                   WRITE     DBERROR
 
     C                   DUMP
     C                   ROLBK
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
 
     C                   RETURN
 
      *    ----------    ------
     C     @PSSR         ENDSR
 
      *========================================================================*
      /COPY MGCPYSRC,MGSWIFTRAN
**  CPY@
(c) Finastra International Limited 2002

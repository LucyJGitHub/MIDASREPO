     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Create Passbook Update Control Detail Rec')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE004248 - Midas RE Create Passbook Update Control Detail Rec*
      *                                                               *
      *  Called By: REC004248 - Initialisation program for CRE072     *
      *             GLAMADUPD - Midas GL Account database update      *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE072 *CREATE     Date 30Jun11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE072 - BankFusion Midas Teller Related Changes             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    nn         Function of Indicator                           *
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
      ** Midas RE REIADCD By full a/c number
     FREIACDL3  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas GL Account details - full a/c number
     FACCNTL10  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(Ac_)
      *
      ** Midas RE Passbook Update Control Detail by A/C no.
     FPBUDCL0   UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(Pb_)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
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
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WRun            S              1A
      *
      ** Entry Parameters
      *
     D P_Option        S              4A
     D P_CustNum       S              6A
     D P_Currency      S              3A
     D P_AccCode       S             10S 0
     D P_AccSeq        S              2S 0
     D P_Branch        S              3A
     D P_RetCode       S              7A
      *
      ** AccntKey list
      *
     D CustNum         S              6A
     D Currency        S              3A
     D AccCode         S             10S 0
     D AccSeq          S              2S 0
     D Branch          S              3A
      *
      ** Access Object Parameters
      *
     D PRetCode        S              7A
     D PSysValK1       S             20A
     D PSysVal1        S            200A
     D PSysValK2       S             20A
     D PSysVal2        S            200A
     D PSysValK3       S             20A
     D PSysVal3        S            200A
     D PSysValK4       S             20A
     D PSysVal4        S            200A
     D PSysValK5       S             20A
     D PSysVal5        S            200A
     D PSysValK6       S             20A
     D PSysVal6        S            200A
     D PSysValK7       S             20A
     D PSysVal7        S            200A
     D PSysValK8       S             20A
     D PSysVal8        S            200A
     D PSysValK9       S             20A
     D PSysVal9        S            200A
     D PSysValK10      S             20A
     D PSysVal10       S            200A
      *
      ** Work variables
      *
     D WStartLine      S              2A
      *
      ** System value for Passbook Printing
      *
     D WConst          C                   'PassbookStartLineTel'
      *
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
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C                   IF        P_Option = '*ALL   '
     C                   EXSR      SRGenAll
     C                   ELSEIF    P_Option = '*NEW   '
     C                   EXSR      SRGenNew
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRGenNew - Generate PBUDCPD record of one specific account   *
      *                                                              *
      ****************************************************************
     C     SRGenNew      BEGSR
      *
     C                   IF        P_CustNum  = *BLANKS OR
     C                             P_Currency = *BLANKS OR
     C                             P_AccCode  = *ZERO OR
     C                             P_AccSeq   = *ZERO OR
     C                             P_Branch   = *BLANKS
      *
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   EVAL      CustNum = P_CustNum
     C                   EVAL      Currency= P_Currency
     C                   EVAL      AccCode = P_AccCode
     C                   EVAL      AccSeq  = P_AccSeq
     C                   EVAL      Branch  = P_Branch
      *
     C     AccntKey      CHAIN     ACCNTL10
      *
     C                   IF        %FOUND(ACCNTL10) AND
     C                             Ac_ATYP = 'R'
      *
     C                   EXSR      SRWritePB
      *
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRGenAll - Generate PBUDCPD record of ALL accounts in ACCNTAB*
      *                                                              *
      ****************************************************************
     C     SRGenAll      BEGSR
      *
     C                   READ      ACCNTL10
      *
     C                   DOW       NOT(%EOF(ACCNTL10))
      *
     C                   IF        Ac_ATYP = 'R' AND
     C                             Ac_STYP = 'S'
      *
     C                   EVAL      CustNum = Ac_CNUM
     C                   EVAL      Currency= Ac_CCY
     C                   EVAL      AccCode = Ac_ACOD
     C                   EVAL      AccSeq  = Ac_ACSQ
     C                   EVAL      Branch  = Ac_BRCA
      *
     C                   EXSR      SRWritePB
      *
     C                   ENDIF
      *
     C                   READ      ACCNTL10
      *
     C                   ENDDO
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRWritePB - Write record in PBUDCPD                          *
      *                                                              *
      ****************************************************************
     C     SRWritePB     BEGSR
      *
     C     AccntKey      CHAIN     REIACDL3
      *
     C                   IF        %FOUND(REIACDL3) AND
     C                             PBKU = 'Y'
      *
     C     Ac_ACNO       CHAIN     PBUDCL0
      *
     C                   IF        NOT(%FOUND(PBUDCL0))
      *
     C                   EVAL      Pb_RECI = 'D'
     C                   EVAL      Pb_ACNO = Ac_ACNO
     C                   MOVEL     PSysVal1      Pb_SPBL
     C                   EVAL      Pb_CFPB = Ac_CFSB
     C                   EVAL      Pb_PSTD = Ac_DACO
      *
     C                   WRITE     PBUDCPDF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Start processing                                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    P_Option
     C                   PARM                    P_CustNum
     C                   PARM                    P_Currency
     C                   PARM                    P_AccCode
     C                   PARM                    P_AccSeq
     C                   PARM                    P_Branch
     C                   PARM                    P_RetCode
      *
      ** Define key list for file ACCNTL10 & REIACL3
      *
     C     AccntKey      KLIST
     C                   KFLD                    CustNum
     C                   KFLD                    Currency
     C                   KFLD                    AccCode
     C                   KFLD                    AccSeq
     C                   KFLD                    Branch
      *
      ** Access system values for Passbook Printing
      *
     C                   EVAL      PSysValK1 = WConst
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    PSysValK1
     C                   PARM                    PSysVal1
     C                   PARM                    PSysValK2
     C                   PARM                    PSysVal2
     C                   PARM                    PSysValK3
     C                   PARM                    PSysVal3
     C                   PARM                    PSysValK4
     C                   PARM                    PSysVal4
     C                   PARM                    PSysValK5
     C                   PARM                    PSysVal5
     C                   PARM                    PSysValK6
     C                   PARM                    PSysVal6
     C                   PARM                    PSysValK7
     C                   PARM                    PSysVal7
     C                   PARM                    PSysValK8
     C                   PARM                    PSysVal8
     C                   PARM                    PSysValK9
     C                   PARM                    PSysVal9
     C                   PARM                    PSysValK10
     C                   PARM                    PSysVal10
      *
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDSVALJ0'
     C                   EVAL      DBKEY  =  PSysValK1
     C                   EVAL      DBASE  =  1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Save value of PassbookStartLineTel
      *
     C                   MOVE      PSysVal1      WStartLine
      *
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
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      P_RetCode = '*ERROR'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR

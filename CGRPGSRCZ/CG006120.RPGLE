     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Tax Self Declaration Statement - Driver')     *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG006120 - Midas CG Tax Self Declaration Statement - Driver  *
      *                                                               *
      *  Function:  This program drives the Tax Self Declaration      *
      *             Statement                                         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR782344           Date 31May11               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG23147           Date 02Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 01Apr05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR782344 - SDC000770 component failed due to database error  *
      *             in SDCUSTPD file                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG23147 - Program dump in component SDC000769               *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *  U7+U8 - Database Error                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMain     - Main program execution                          *
      *  SRRead     - Read Customer and Non-Account Holder File       *
      *  SRRtvCTS   - Retrieve Customer Tax Status                    *
      *  SRRtvNTS   - Retrieve Non-Account Holder Tax Status          *
      *  SRPrint    - Print Statement                                 *
      *  SRPush     - Push values on the stack                        *
      *  SRPop      - Pop (unwinds) values off the stack              *
      *  SRClear    - Clear stack                                     *
      *  SRAudit    - Audit Report Processing                         *
      *  *INZSR     - Program Initialisation Subroutine               *
      *  *PSSR      - Program Exception Subroutine                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Additional Customer Details Retrieval
 
     FSDNAHOL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Non-Account Holder Retrieval
 
     FSDACTXL4  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD CTTX by Customer Retrieval
 
     FSDNHTXL4  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD NHTX by Non-Account Holder Reference Retrieval
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for access objects, second DS
                                                                                            AR782344
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   AR782344
      ** Data structure for access objects, third DS                                        AR782344
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Data structure for SD Customer details file
 
     D DSPARM          DS
      ** Data Structure of Parameters Passed to CG006130
     D PTaxYear                1      4  0
     D PRef                    5     14
     D PRefInd                15     15
     D PRepName               16     35
     D PRepTown               36     45
     D PBranch                46     48                                                     BUG23147
 
     D PDATA           DS           100
     D PTaxYrEnt               1      4
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D PRetCde         S              7A
     D PRtCd           S              7A
     D POptn           S              7A
     D PCustNo         S             10A
     D PErrInf         S              7A
     D W0CMT           S              3A
     D WProduce        S              1A
     D WAUTO           S              1A
 
      ** Standard CG Utility Parameters
     D PZSeq           S              5A
 
      ** Work Variables
     D WRecCnt         S             15S 0
     D WValue          S             10A
     D WPrint          S              1A
 
     D/COPY CGCPYSRC,SRERRDLE
      ** Fields, Data Structures, and Arrays Definition for CG Error Processing
 
     D/COPY CGCPYSRC,CGAUDTDLE
      ** Fields, Data Structures, and Arrays Definition for CG Audit Processing
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Push the currently running routine into the stack.
 
     C                   EVAL      WValue = 'Main'
     C                   EXSR      SRPush
 
      ** Main Processing
      ** ===============
 
     C                   EXSR      SRMain
 
      ** Audit Processing
      ** ================
 
     C                   EXSR      SRAudit
 
      ** Pop values off the stack.
 
     C                   EXSR      SRPop
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Main program execution                              *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
 
     C                   EVAL      WValue = 'SRMain'
     C                   EXSR      SRPush
 
     C                   EXSR      SRRead
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRead - Read Customer and Non-Account Holder File           *
      *                                                               *
      *****************************************************************
     C     SRRead        BEGSR
 
     C                   EVAL      WValue = 'SRRead'
     C                   EXSR      SRPush
 
     C                   EVAL      WRecCnt = *ZERO
 
      ** Read customers file
      ** ===================
 
     C     *LOVAL        SETLL     SDACUSL1
     C                   READ      SDACUSL1
 
     C                   DOW       NOT %EOF
 
      ** Retrieve customer tax status
 
     C                   EXSR      SRRtvCTS
 
     C                   READ      SDACUSL1
     C                   ENDDO
 
      ** Read non-account holders file
      ** =============================
 
     C     *LOVAL        SETLL     SDNAHOL1
     C                   READ      SDNAHOL1
 
     C                   DOW       NOT %EOF
 
      ** Retrieve non-account holder tax status
 
     C                   EXSR      SRRtvNTS
 
     C                   READ      SDNAHOL1
     C                   ENDDO
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvCTS - Retrieve customer tax status in every             *
      *             country of tax                                    *
      *                                                               *
      *****************************************************************
     C     SRRtvCTS      BEGSR
 
     C                   EVAL      WValue = 'SRRtvCTS'
     C                   EXSR      SRPush
 
     C                   EVAL      WPrint = 'N'
 
     C                   MOVE      PTaxYrEnt     PTaxYear
     C                   EVAL      PRef = E5CUST
     C                   EVAL      PRefInd = 'C'
 
     C                   EXSR      SRRRepDet
     C                   EVAL      PRepName = BBCRNM
     C                   EVAL      PRepTown = BBCRTN
 
     C     E5CUST        SETLL     SDACTXL4
     C     E5CUST        READE     SDACTXL4
 
     C                   DOW       NOT %EOF
 
      ** Print statement when tax status is 'S'
 
     C                   IF        AXETXS = 'S'
     C                   EVAL      WPrint = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C     E5CUST        READE     SDACTXL4
     C                   ENDDO
 
     C                   IF        WPrint = 'Y'
     C                   EXSR      SRPrint
     C                   EVAL      WRecCnt = WRecCnt + 1
     C                   ENDIF
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvNTS - Retrieve non-account holder tax status in         *
      *             every country of tax                              *
      *                                                               *
      *****************************************************************
     C     SRRtvNTS      BEGSR
 
     C                   EVAL      WValue = 'SRRtvNTS'
     C                   EXSR      SRPush
 
     C                   EVAL      WPrint = 'N'
 
     C                   MOVE      PTaxYrEnt     PTaxYear
     C                   EVAL      PRef = NHNAHO
     C                   EVAL      PRefInd = 'N'
     C                   EVAL      PRepName = NHNARN
     C                   EVAL      PRepTown = NHNATW
 
     C     NHNAHO        SETLL     SDNHTXL4
     C     NHNAHO        READE     SDNHTXL4
 
     C                   DOW       NOT %EOF
 
      ** Print statement when tax status is 'S'
 
     C                   IF        NXETXS = 'S'
     C                   EVAL      WPrint = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C     NHNAHO        READE     SDNHTXL4
     C                   ENDDO
 
     C                   IF        WPrint = 'Y'
     C                   EXSR      SRPrint
     C                   EVAL      WRecCnt = WRecCnt + 1
     C                   ENDIF
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrint - Print Statement                                    *
      *                                                               *
      *****************************************************************
     C     SRPrint       BEGSR
 
     C                   EVAL      PBranch = BBBRCD                                         BUG23147
     C                   EVAL      WValue = 'SRPrint'
     C                   EXSR      SRPush
 
     C                   CALL      'CG006130'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    W0CMT
     C                   PARM                    WProduce
     C                   PARM                    WAUTO
     C                   PARM                    DSPARM
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'CG006130'
     C                   EVAL      DBKey = *BLANKS
     C                   EVAL      DBase = 1
     C                   EVAL      PRetCde = PRtCd                                          AR782344
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPush - Push values on the stack                            *
      *                                                               *
      *****************************************************************
     C     SRPush        BEGSR
 
     C                   EVAL      Q = Q + 1
     C                   EVAL      @STK(Q) = WValue
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop - Pop (unwind) values off the stack                    *
      *                                                               *
      *****************************************************************
     C     SRPop         BEGSR
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   EVAL      Q = Q - 1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClear - Clear stack                                        *
      *                                                               *
      *****************************************************************
     C     SRClear       BEGSR
 
     C                   MOVEA     *BLANKS       @STK(1)
     C                   EVAL      Q = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRRepDet - Retrieve Report Details                          *
      *                                                               *
      *****************************************************************
     C     SRRRepDet     BEGSR
 
     C                   EVAL      WValue = 'SRRRepDet'
     C                   EXSR      SRPush
 
     C                   MOVEL     E5CUST        PCustNo
 
     C**********         CALL      'AOCUSTR0'                                               AR782344
     C                   CALL      'AOCUSTR1'                                               AR782344
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCustNo
     C                   PARM      *BLANKS       PErrInf
     C*****SDCUST        PARM      SDCUST        DSSDY                                      AR782344
     C     SDCUST        PARM      SDCUST        DSLDY                                      AR782344
 
     C**********         IF        PRtCd <> *BLANKS                                         AR782344
     C                   IF        PRtCd <> *BLANKS AND                                     AR782344
     C                             BBCLST <> 'Y' AND                                        AR782344
     C                             BBDTDL = 0                                               AR782344
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBKey = *BLANKS
     C                   EVAL      DBase = 2
     C                   EVAL      PRetCde = PRtCd                                          AR782344
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Audit Report Processing                            *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
     C                   EVAL      WValue = 'SRAudit'
     C                   EXSR      SRPush
 
      ** Output the count of records read.
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG006120'    I#REF
     C                   MOVEL     'CGD1907'     I#TITL
     C                   MOVEL     'CGD1908'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVEL     *BLANKS       I#SUB
     C                   MOVEL     'SDACUSPD'    I#SUB
     C                   MOVEL     'CAD1021'     I#TEXT
     C                   Z-ADD     WRecCnt       I#QTY
     C                   Z-ADD     *ZERO         I#DECS
     C                   MOVEL     '1'           I#EDIT
 
      ** Write a line of text.
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*LINE   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PZSeq
 
      ** Skip a line.
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*SKIP   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PZSeq
 
      ** Produce the Audit Report.
 
      ** Close the Audit printer file.
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG006120'    I#REF
     C                   MOVEL     'CGD1907'     I#TITL
     C                   MOVEL     'CGD1908'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVEL     'CAD1008'     I#TEXT
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*CLOSE  '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PZSeq
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry Parameters
      ** ================
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    PRetCde
     C                   PARM                    W0CMT
     C                   PARM                    PDATA
 
      ** Set the program name.
 
     C                   MOVEL     ##PGM         DBPgm
 
      ** Open the Audit printer file.
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG006120AU'  I#SPLN
     C                   MOVEL     'CG006120'    I#REF
     C                   MOVEL     'CGD1907'     I#TITL
     C                   MOVEL     'CGD1908'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*OPEN   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PZSeq
 
      ** Clear stack.
 
     C                   EXSR      SRClear
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY CGCPYSRC,SRERRCLE
      /EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
      /EJECT
      *****************************************************************

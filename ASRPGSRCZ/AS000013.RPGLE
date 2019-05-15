     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Forecast Transactions Update')                *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000013 - Forecast Transactions Update                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    LR         Last Record Indicator (program termination)     *
      *    U7 and U8  DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRDeriv   - Process Hedge Derivatives of Forecast Transaction*
      *  SRHedge   - Process Hedged Items of Forecast Transactions    *
      *  SRUpdURPL - Update the Unrealized Profit/Loss                *
      *  SRNumDec  - Set the amount according to the transaction      *
      *              currency's number of decimal places              *
      *  SRCcyDet  - Access currency details                          *
      *  SRReset   - Reset variables and arrays                       *
      *                                                               *
      *  *INZSR - Initialise                                          *
      *  *PSSR - Error processing                                     *
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
 
      ** Midas AS Hedge Linkage File Retrieval by Hedge ID
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(LK:2)
 
      ** Midas AS Hedge transaction by Module/HdgId/HdgInd
     FASHTRNLF  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(TR:2)
 
      ** Midas AS Forecast transaction file retrieval index
     FASFHTRL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FH:2)
 
      ** Deals File
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Transaction Numbers
     D ArrDLNO         S              6  0 DIM(100)
 
      ** Array of Amounts
     D ArrAMNT         S             20  5 DIM(100)
 
      ** External DS for Midas Modules
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for Access Objects
     D PRetCode        S              7
     D POption         S              7
     D PCurrency       S              3
 
      ** Work variables
     D WInAMNT         S             13  0
     D WOutAMNT        S             13  3
     D WrkAMNT         S             13  3
     D WSumAMNT        S             20  7
     D WProduct        S             20  7
     D WrkURPL         S             13  3
     D WSumURPL        S             20  3
     D WFactor         S             20 13
     D WrkPCTG         S              6  4
     D WrkVar          S             20  3
     D Wx              S              3  0
     D WRun            S              1
     D WFHURPL         S             13  0
 
      ** Key Fields
     D KModule         S              2
     D KHedgeID        S              6  0
     D KDHind          S              1
     D KNPVM           S              1
     D KDEAL           S              6  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
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
 
      ** Retrieve all live hedge linkages from ASHGLKPD
 
     C                   READ      ASHGLKL1
 
     C                   DOW       NOT %EOF(ASHGLKL1)
 
     C                   IF        LKRECI = 'D'
     C                   EVAL      KModule = 'FH'
     C                   EVAL      KHedgeID = LKHEDI
     C                   EVAL      KDHind = 'H'
 
      ** Check if hedged item is a forecast transaction
 
     C     KHTRN         CHAIN     ASHTRNLF
 
     C                   IF        %FOUND(ASHTRNLF)
 
      ** Reset variables and arrays
 
     C                   EXSR      SRReset
 
      ** Access hedge currency details
 
     C                   EXSR      SRCcyDet
 
      ** Process Hedged Items
 
     C                   EXSR      SRHedge
 
      ** Process Derivatives
 
     C                   EVAL      KModule = 'DL'
     C                   EVAL      KDHind = 'D'
 
     C                   EXSR      SRDeriv
 
      ** Compute and update the Unrealized Profit/Loss allocation
      ** of each Forecast Transaction for the hedge linkage
 
     C                   EXSR      SRUpdURPL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      ASHGLKL1
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDeriv - Process Hedge Derivatives of Forecast Transactions  *
      *                                                               *
      *****************************************************************
 
     C     SRDeriv       BEGSR
 
     C     KHTRN         SETLL     ASHTRNLF
     C     KHTRN         READE     ASHTRNLF
 
     C                   DOW       NOT %EOF(ASHTRNLF)
 
      ** Access deal details to get the UNRL
 
     C*****TRDLNO        CHAIN     DEALS                                                      CLE148
     C                   MOVEL     TRDLNO        TRDLNO2           6 0                        CLE148
     C     TRDLNO2       CHAIN     DEALS                                                      CLE148
 
     C                   IF        %FOUND(DEALS)
     C                   IF        RCDT = 'B' OR RCDT = 'C' OR
     C                             RCDT = 'D'
     C                   EVAL      WInAMNT = FSURPL
     C                   ENDIF
     C                   IF        RCDT = 'G'
     C                   EVAL      WInAMNT = UNRL
     C                   ENDIF
     C                   EVAL      WrkPCTG = TRPCTG / 100
     C                   EXSR      SRNumDec
     C                   EVAL      WrkURPL = WOutAMNT * WrkPCTG
 
     C                   EVAL      WSumURPL = WSumURPL + WrkURPL
     C                   ENDIF
 
     C     KHTRN         READE     ASHTRNLF
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHedge - Process Hedged Items of Forecast Transactions       *
      *                                                               *
      *****************************************************************
 
     C     SRHedge       BEGSR
 
     C                   EVAL      Wx = 1
 
     C     KHTRN         SETLL     ASHTRNLF
     C     KHTRN         READE     ASHTRNLF
 
     C                   DOW       NOT %EOF(ASHTRNLF)
     C*****TRDLNO        CHAIN     ASFHTRL1                                                   CLE148
     C                   MOVEL     TRDLNO        TRDLNO2                                      CLE148
     C     TRDLNO2       CHAIN     ASFHTRL1                                                   CLE148
 
     C                   IF        %FOUND(ASFHTRL1)  AND  FHRECI = 'D'
 
     C                   EVAL      WInAMNT = FHAMNT
     C                   EXSR      SRNumDec
     C                   EVAL      WrkAMNT = WOutAMNT
 
     C                   EVAL      WrkPCTG = TRPCTG / 100
     C                   EVAL      WProduct = WrkAMNT * WrkPCTG
     C                   EVAL      WSumAMNT = WSumAMNT + WProduct
 
      ** Save values in array for use in update later
 
     C**********         EVAL      ArrDLNO(Wx) = TRDLNO                                       CLE148
     C                   EVAL      ArrDLNO(Wx) = TRDLNO2                                      CLE148
     C                   EVAL      ArrAMNT(Wx) = WProduct
     C                   EVAL      Wx = Wx + 1
     C                   ENDIF
 
     C     KHTRN         READE     ASHTRNLF
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdURPL - Update the Unrealized Profit/Loss                 *
      *                                                               *
      *****************************************************************
 
     C     SRUpdURPL     BEGSR
 
     C                   EVAL      Wx = 1
     C                   EVAL(R)   WFactor = WSumURPL / WSumAMNT
     C                   EVAL      WFHURPL = 0
 
      ** If the sum of URPL for derivative is positive and WFactor is also positive
      ** or the sum of URPL for derivative is negative and WFactor is also negative
      ** reverse the sign of the WFactor to negate the URPL of the derivative
 
     C                   IF        WSumURPL >= 0 AND WFactor >= 0 OR
     C                             WSumURPL < 0 AND WFactor < 0
     C                   EVAL      WFactor = WFactor * -1
     C                   ENDIF
 
     C                   DOW       ArrDLNO(Wx) <> *ZERO
 
     C     ArrDLNO(Wx)   CHAIN     ASFHTRL1
 
     C                   IF        %FOUND(ASFHTRL1)  AND  FHRECI = 'D'
     C     ArrAMNT(Wx)   MULT(H)   WFactor       WrkVAR
 
     C                   SELECT
     C                   WHEN      A6NBDP = *ZERO
     C     ArrAMNT(Wx)   MULT(H)   WFactor       WFHURPL
     C                   EVAL      FHURPL = FHURPL + WFHURPL
 
     C                   WHEN      A6NBDP = 1
     C     WrkVar        MULT(H)   10            WFHURPL
     C                   EVAL      FHURPL = FHURPL + WFHURPL
 
     C                   WHEN      A6NBDP = 2
     C     WrkVar        MULT(H)   100           WFHURPL
     C                   EVAL      FHURPL = FHURPL + WFHURPL
 
     C                   WHEN      A6NBDP = 3
     C     WrkVar        MULT(H)   1000          WFHURPL
     C                   EVAL      FHURPL = FHURPL + WFHURPL
     C                   ENDSL
 
     C                   UPDATE    ASFHTRD0
     C                   ENDIF
 
     C                   EVAL      Wx = Wx + 1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNumDec - Set the amount according to the transaction        *
      *            currency's number of decimal places                *
      *                                                               *
      *****************************************************************
 
     C     SRNumDec      BEGSR
 
     C                   SELECT
     C                   WHEN      A6NBDP = *ZERO
     C                   EVAL      WOutAMNT = WInAMNT
 
     C                   WHEN      A6NBDP = 1
     C                   EVAL      WOutAMNT = WInAMNT / 10
 
     C                   WHEN      A6NBDP = 2
     C                   EVAL      WOutAMNT = WInAMNT / 100
 
     C                   WHEN      A6NBDP = 3
     C                   EVAL      WOutAMNT = WInAMNT / 1000
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCcyDet - Access currency details                            *
      *                                                               *
      *****************************************************************
 
     C     SRCcyDet      BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      LKCYCD        PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = PCurrency
     C                   EVAL      DBASE  = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReset - Reset variables and arrays                          *
      *                                                               *
      *****************************************************************
 
     C     SRReset       BEGSR
 
     C                   EVAL      WSumURPL = *ZERO
     C                   EVAL      WSumAMNT = *ZERO
     C                   EVAL      ArrDLNO = *ZERO
     C                   EVAL      ArrAMNT = *ZERO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Key list  for ASHTRNLF
 
     C     KHTRN         KLIST
     C                   KFLD                    KModule
     C                   KFLD                    KHedgeID
     C                   KFLD                    KDHind
 
     C     KURPL         KLIST
     C                   KFLD                    KNPVM
     C                   KFLD                    KDEAL
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 

     H DEBUG
     H COPYRIGHT('(C) Copyright Finastra International Limited')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee history sequence and RECI update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LER136 - Midas LE history sequence and RECI update.          *
      *                                                               *
      *  Function:  This program update fees sequence to '00' and     *
      *  (COB)      RECI to 'M' for all settlement records on LEFHST  *
      *             if fees on LEFEED was to be matured.              *
      *                                                               *
      *  Called By: LER135 - Midas LE Fee accruals, update and A/C    *
      *                      key generation.                          *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2007            *
      *                                                               *
      *  Last Amend No. CLE071             Date 18Jul18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD043383           Date 30Mar17               *
      *                 AR632102B          Date 21Dec12               *
      *                 AR632103B          Date 21Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 250628   *CREATE   Date 04Oct07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD043383 - Only the fee maturity event should have a record  *
      *             ID equal to 'M' for proper display in the enquiry.*
      *  AR632102B - For matured fees, there are still records in PF/ *
      *              LEFHST with fee sequence not equal to '00'.      *
      *              Amended program to ensure that fee sequence of   *
      *              all records of a maturing fee will be updated to *
      *              '00'. (Child: AR632103)                          *
      *  AR632103B - During COB, incorrect amount of accruals posted  *
      *              newly inserted fee.                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  250628 - If fee was matured, matured all live fee settlement *
      *           details on PF/LEFHST through LER136.                *
      *           Applied fix 240073.                                 *
      *                                                               *
      *****************************************************************
 
     F***LEFHSTL6  UF   E           K DISK    INFSR(*pssr)                                 AR632103B
     FLEFHSTL8  UF   E           K DISK    INFSR(*pssr)                                    AR632103B
 
     D CustNum         S              6
     D*LoanNum**       S              6P 0                                                    CLE148
     D LoanNum         S              6A                                                      CLE148
     D FeeSeq          S              2P 0
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
 
      /EJECT
      *
     C     LEKEY         KLIST
     C                   KFLD                    Branch
     C                   KFLD                    CustNum
     C                   KFLD                    Facility
     C                   KFLD                    LoanNum
     C                   KFLD                    FeeSeq
      *
     C     *ENTRY        PLIST
     C                   PARM                    Branch            3
     C                   PARM                    CustNum
     C                   PARM                    Facility          5 0
     C                   PARM                    LoanNUm
     C                   PARM                    FeeSeq
     C                   PARM                    WRTCD             7
     C                   PARM                    WPGM              6                       AR632102B
      *
     C     LEKEY         CHAIN     LEFHSTF                            01
      *
     C                   DOW       *IN01 = '0'
      *
     C**********         EVAL      HIRECI = 'M'                                             MD043383
      *                                                                                    AR632102B
     C     WPGM          IFEQ      'LER130'                                                AR632102B
     C                   EVAL      HIFSEQ = 0
     C                   ENDIF                                                             AR632102B
      *                                                                                    AR632102B
     C                   UPDATE    LEFHSTF
      *
     C     LEKEY         READE     LEFHSTF                                01
      *
     C                   ENDDO
 
     C                   EVAL      *INLR = '1'
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: Main Subroutine                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   EVAL      WRTCD = '*ERR'
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(C) Finastra International Limited 2007

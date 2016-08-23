     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*S*D ***RPGBASEBNC****************************************************                     BUG27914
/*STD *  RPGBASEBNC                                                   *            BUG27914 BUG28163
/*EXI *  TEXT('Midas GP Update of Global File GPCLEARPD')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP003005 - GP Update of Global File GPCLEARPD                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. BUG28163           Date 05Oct10               *
      *  Prev Amend No. BUG27914 *REDUNDANTDate 09Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP203  *CREATE    Date 02Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG28163 - Forward movements does not appear on PABE         *
      *             (Recompile due to GPCLEARPD reinstatement)        *
      *  BUG27914 - RAME Design Changes                               *
      *  CAP203 - Teller Related APIs - Account Movements             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8 -  Database Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR      -  Program exception error routine                *
      *  *INZSR     -  Initialisation Subroutine                      *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.           *
      *                                                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGPCLEARL0 UF A E           K DISK
     F                                     RENAME(APOSTPDF:CLEARPDF)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data Structure for Midas GL Items in Clearing Detail File(CLEARPD)
      ** Defined GPCLEARPD fields only
     D P_CLEARPD       DS           620
     D**RECI****               1      1                                                     BUG28163
     D**CNUM****               2      7                                                     BUG28163
     D**CCYI****               8     10                                                     BUG28163
     D**ACSQ****              15     16  0                                                  BUG28163
     D**ACNO****              23     32  0                                                  BUG28163
     D**PSTD****              33     35P 0                                                  BUG28163
     D**VALD****              36     38P 0                                                  BUG28163
     D**PNAR****              44     73                                                     BUG28163
     D**PSTA****              74     80P 0                                                  BUG28163
     D**DRCR****              81     81  0                                                  BUG28163
     D**BRCA****             103    105                                                     BUG28163
     D**ACOD****             590    599  0                                                  BUG28163
     D GPCLEAR       E DS                  EXTNAME(GPCLEARPD)                               BUG28163
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
      *
      ** Global File Updates
      *
     C     MODE          IFEQ      'D'
     C     BRCH          SETLL     GPCLEARL0
     C     BRCH          READE     GPCLEARL0
 
     C                   DOW       %FOUND(GPCLEARL0) AND
     C                             NOT %EOF(GPCLEARL0)
     C                   DELETE    CLEARPDF
     C     BRCH          READE     GPCLEARL0
     C                   ENDDO
 
     C                   ENDIF
 
     C     MODE          IFEQ      'I'
     C                   EVAL      GPCLEAR = P_CLEARPD                                      BUG28163
     C                   WRITE     CLEARPDF
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  *INZSR - Initial Subroutine                                 *
      *                                                              *
      *  Called by: Implicitly on program activation                 *
      *                                                              *
      *  Calls: None                                                 *
      *                                                              *
      ****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
     C                   PARM                    BRCH              3
     C                   PARM                    P_CLEARPD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************

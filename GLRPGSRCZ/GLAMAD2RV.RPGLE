     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account LUX retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD2RV-  GL Account LUX Retrieve                          *
      *                                                               *
      *  Function:  This module retrieves a record from REACX1PD      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 09May06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *
     FREACX1L0  IF   E           K DISK    INFSR(*PSSR)
      **
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D AcctLUXFilFmt E DS                  EXTNAME(REACX1PD)
      **
      *
     D FrontOfcId      S             40
     D*Customer*       S              6s 0                                                   CSD027A
     D Customer        S              6                                                      CSD027A
     D Currency        S              3
     D Accountcd       S             10
     D Account#        S             10S 0
     D Acctseqnc       S              2s 0
     D Branch          S              3
     D RetailAcct      S             10
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
 
     C                   CLEAR                   AcctLUXFilFmt
 
     C     KEY           CHAIN     REACX1L0
     C                   EVAL      *INLR=*ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  *INZSR - Initial Processing
      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    ActionCode
     C                   PARM                    FrontOfcID
     C                   PARM                    Customer
     C                   PARM                    Currency
     C                   PARM                    Accountcd
     C                   PARM                    Acctseqnc
     C                   PARM                    Branch
     C                   PARM                    RetailAcct
     C                   PARM                    AcctLUXFilFmt
      *
      ** Key fields list
      *
     C     KEY           KLIST
     C                   KFLD                    Customer
     C                   KFLD                    Currency
     C                   KFLD                    Account#
     C                   KFLD                    Acctseqnc
     C                   KFLD                    Branch
      *
      ** Move entry account code (10A) to a numeric field
      *
     C                   MOVE      AccountCd     Account#
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005

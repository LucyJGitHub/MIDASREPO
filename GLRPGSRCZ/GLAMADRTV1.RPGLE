     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account BOE Retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADRTV1- Account Details Extension RETRIEVE               *
      *                                                               *
      *  Function:  This module retrieve the details of extension file*
      *             BYACCTX0.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FBYACCTY0  IF   E           K DISK    INFSR(*PSSR)
 
      * Account Details Extension File
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
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
 
     D AcctExFilFmt  E DS                  EXTNAME(BYACCTX0)
      ** External DS for Account Details Extension
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** parameter fields
 
     D PRetCodeIn      S             10
     D PActn           S              1
     D PFOTRID         S             40
     D PCust           S              6
     D PCurcy          S              3
     D PAcctCde        S             10
     D PAcctSeq        S              2
     D PBranch         S              3
     D PRtlAcct        S             10
 
      ** key fields
 
     D KBranch         S                   LIKE(LBRCD)
     D KCust           S                   LIKE(LCNUM)
     D KCurcy          S                   LIKE(LCCY )
     D KAcctCde        S                   LIKE(LACOD)
     D KAcctSeq        S                   LIKE(LACSQ)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      ** Initialization
      *
     C                   EXSR      INIT
     C
     C     Acct_Key      CHAIN     BYACCTY0
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Clear Outputs
      *
     C                   CLEAR                   AcctExFilFmt
      *
      ** move parameter fields to key fields
      *
     C                   MOVE      PBranch       KBranch
     C                   MOVE      PCust         KCust
     C                   MOVE      PCurcy        KCurcy
     C                   MOVE      PAcctCde      KAcctCde
     C                   MOVE      PAcctSeq      KAcctSeq
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** key list
      *
     C     Acct_Key      KLIST
     C                   KFLD                    KBranch
     C                   KFLD                    KCust
     C                   KFLD                    KCurcy
     C                   KFLD                    KAcctCde
     C                   KFLD                    KAcctSeq
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Return code
      *
     C                   PARM                    PRetCodeIn
      *
      ** Action Code
      *
     C                   PARM                    PActn
      *
      ** Front Office Transaction ID
      *
     C                   PARM                    PFOTRID
      *
      ** Customer
      *
     C                   PARM                    PCust
      *
      ** Currency
      *
     C                   PARM                    PCurcy
      *
      ** Account Code
      *
     C                   PARM                    PAcctCde
      *
      ** Account Sequence
      *
     C                   PARM                    PAcctSeq
      *
      ** Branch
      *
     C                   PARM                    PBranch
      *
      ** Outputs
      *
      ** Retail Account Number
      *
     C                   PARM                    PRtlAcct
      *
      ** Account Details File Format
      *
     C                   PARM                    AcctExFilFmt
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'GLAMADRTV1'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************

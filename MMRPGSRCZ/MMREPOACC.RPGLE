     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM REPO Calculate total nominal and value')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMREPOACC - REPO Calculate Total Nominal and Value           *
      *                                                               *
      *  Function:  This module calculates the total nominal and      *
      *             value of depot movements entered thru the REPOs   *
      *             maintenance (APIs)                                *
      *                                                               *
      *  Component of: MMREPOCTL                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 240474             Date 21Aug06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  240474 - APISERVER dumping when calling MM0011 because it    *
      *           uses AOCREPT which is use to send message for       *
      *           interactive jobs.                                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         File not found indicator for chain operation.   *
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
 
     FSECTY     IF   E           K DISK
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Incoming REPO Depot Transaction
     D TranInDEPO    E DS                  EXTNAME(MMRPDDPD)
 
      * Incoming Transaction in File Format
     D ValidDEPO     E DS                  EXTNAME(MMVRPDDPD)
 
      ** DS for MM0010 module
     D P_0010          DS           256
     D  P_NDCY                 1      3
     D  P_NDAM                 4     10P 0
     D  P_DBCY                11     13
     D  P_DBAM                14     20P 0
     D  P_DBDT                21     23P 0
     D  P_CRCY                24     26
     D  P_CRAM                27     33P 0
     D  P_PDCY                34     36
     D  P_PDAM                37     43P 0
     D  P_CRDT                44     46P 0
     D  P_RATE                47     53P 8
     D  P_MDIN                54     54  0
     D  P_OVRT                55     55
     D  P_SDIN                56     56
     D  P_RTDS                57     59P 4
      *
     D  P_FRCY                11     13
     D  P_FRAM                14     20P 0
     D  P_FRDT                21     23P 0
     D  P_TOCY                24     26
     D  P_TOAM                27     33P 0
     D  P_TODT                44     46P 0
      *
     D  P_PMSQ                60     69
     D  P_INDC                70     74
     D  P_RTCD                75     81
     D  P_INTC                82     99  3
     D  P_INTD               100    117  3
      *
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PCCY            S              3
     D BJRDNB          S              5P 0
 
     D WDNOML          S             12S 0
     D W_Nom           S             15P 0
     D PAccNom         S             15P 0
     D PAccVal         S             15P 0
 
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
 
      ** Access security details file for the number of nominal decimal places
 
     C     DDSECT        CHAIN     SECTY                              99
 
     C                   Z-ADD     0             WDNOML
 
     C                   CLEAR                   P_0010
 
     C                   Z-ADD     0             P_NDAM
     C                   Z-ADD     0             P_PDAM
     C                   Z-ADD     0             P_MDIN
     C                   Z-ADD     0             P_FRAM
     C                   Z-ADD     0             P_TOAM
     C                   Z-ADD     0             P_TODT
     C                   Z-ADD     0             P_INTC
     C                   Z-ADD     0             P_INTD
 
     C                   MOVE      NMCY          P_DBCY
 
     C                   Z-ADD     IFVDVL        P_DBAM
 
     C                   MOVE      PCCY          P_CRCY
     C                   Z-ADD     0             P_CRAM
     C                   Z-ADD     BJRDNB        P_DBDT
     C                   Z-ADD     BJRDNB        P_CRDT
 
     C                   Z-ADD     IFEXCR        P_RATE
 
     C                   MOVE      'Y'           P_OVRT
     C                   MOVE      'N'           P_SDIN
     C                   Z-ADD     0             P_RTDS
     C                   MOVEL     'MMRPDL'      P_PMSQ
     C                   MOVE      *BLANKS       P_INDC
     C                   MOVE      *BLANKS       P_RTCD
      *
     C                   EVAL      P_PMSQ = '*BATCH'                                          240474
     C                   CALL      'MM0011'
     C                   PARM                    P_0010
 
      ** Database error handling
 
     C                   IF        P_RTCD = '*ERROR*'
 
     C                   EVAL      DBFile = 'MM0011  '
     C                   EVAL      DBKey = '*FIRST '
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
      *
     C                   ELSE
 
     C                   IF        P_RTCD <> *BLANKS                                          240474
     C                   EVAL      RetCodeIn = P_RTCD                                         240474
     C                   ELSE                                                                 240474
                                                                                              240474
     C                   ADD       P_CRAM        PAccVal
 
     C                   Z-ADD     IFNOML        WDNOML
      *
      ** Format Nominal to have 4 dp's irrespective of actual no.
      *
      ** If Nominal Decimal Places = 0 then Multiply by 10000
     C                   IF        NMDP = 0
     C     10000         MULT      WDNOML        W_Nom
     C                   ADD       W_Nom         PAccNom
     C                   ENDIF
      *
      ** If Nominal Decimal Places = 1 then Multiply by 1000
     C                   IF        NMDP = 1
     C     1000          MULT      WDNOML        W_Nom
     C                   ADD       W_Nom         PAccNom
     C                   ENDIF
     C
      *
      ** If Nominal Decimal Places = 2 then Multiply by 100
     C                   IF        NMDP = 2
     C     100           MULT      WDNOML        W_Nom
     C                   ADD       W_Nom         PAccNom
     C                   ENDIF
     C
      ** If Nominal Decimal Places = 3 then Multiply by 10
     C                   IF        NMDP = 3
     C     10            MULT      WDNOML        W_Nom
     C                   ADD       W_Nom         PAccNom
     C                   ENDIF
      *
      ** If Nominal Decimal Places = 4 then Multiply by 1
     C                   IF        NMDP = 4
     C     1             MULT      WDNOML        W_Nom
     C                   ADD       W_Nom         PAccNom
     C                   ENDIF
                                                                                              240474
     C                   ENDIF                                                                240474
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      *
      * Input parameters
      *
      * Return code
     C                   PARM                    RetCodeIn
      * Transaction information (DS) from source system
     C                   PARM                    TranInDEPO
      * Validated depot movements details
     C                   PARM                    ValidDEPO
      * Deal Currency
     C                   PARM                    PCCY
      * Midas Run Day Numner
     C                   PARM                    BJRDNB
      *
      * Input/Output parameters
      * Total Nominal accumulated
      * Total Value accumulated
     C                   PARM                    PAccNom
     C                   PARM                    PAccVal
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
**  CPY@
(c) Finastra International Limited 2001

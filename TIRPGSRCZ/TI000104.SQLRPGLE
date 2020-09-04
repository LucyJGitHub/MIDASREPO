     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas TI SDNOSTPD Trigger - GJPF Nostros')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Module                              *
      *                                                               *
      *  TI000104 - Midas TI Trigger program                          *
      *                                                               *
      *  Function:  This program updates/adds/deletes a record in     *
      *             GJPF for Nostros                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Called By: SCTRIGGER                                         *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 245323             Date 04Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BG7590             Date 21Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CSD025             Date 11Jan05               *
      *                 BG3697  *CREATE    Date 23May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245323 - Apply fix 237768.                                   *
      *  237768 - Trigger is not working.  Use A7OACN instead of      *
      *           A7OANN.                                             *
      *  BG7590 - Insert not working                                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CSD025 - Customer De-Activation                              *
      *  BG3697 - Convert TI SQL triggers to RPG                      *
      *                                                               *
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D PARM1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event
     D  TRGEVENT              31     31
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D  EntryData            117  10117A
 
     D PARM2           DS
     D  LENG                   1      4B 0
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Long DS for Access Programs
 
      * Parameter for access to Customer Details
     D PCustNo         S             10A
     D PErrInf         S              7A
 
      * DS to define Nostro fields
     DNOSTFormat     E DS                  ExtName(SDNOSTPD)
 
      * 'Before' variables for SQL key details and update checking
     DBNostro          S              6
     DBAccount         S             34
     D**********BOurAc           S             14                                             237768
     DBOurAc           S             34                                                       237768
     DAOurAc           S             34                                                       237768
 
      * Work variables, GJPF fields
     D WKACSN          S              2
     DGJNostro         S              6
     DGJAccount        S             34
     DNostro           S             10
 
     D Run             PR                  ExtPgm('QCMDEXC')                                  237768
     D cmdstr                      3000A   Const Options(*VarSize)                            237768
     D cmdlen                        15P 5 Const                                              237768
     D cmdDbcs                        3A   Const Options(*NOPASS)                             237768
     D msg             S           3000A                                                      237768
      *****************************************************************
     C/EJECT
      *****************************************************************
 
      * Entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      * Recover before and after image
     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     PARM1:OffSet  I#BIMG         4000
 
     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG         4000
      *                                                                                       237768
      ** Error occurs if insert is made.  A7ACSN cannot be moved to WKACSN                    237768
      *                                                                                       237768
      *
      * Get variables from before image
     C                   If        TrgEvent <> '1'                                            BG7590
     C                   Eval      NostFormat = I#BIMG
     C                   Eval      BNostro    = A7CYCD + A7NONB
     C                   MoveL     A7ACSN        WKACSN
     C                   Eval      BAccount = A7BRCD + A7CUST + A7CYCD + A7ACCD
     C                             + WKACSN
     C**********         Eval      BOurAc = A7OANN                                            237768
     C                   If        ((%LEN(%TRIM(A7OACN)) = 35 ) AND                           237768
     C                             (TrgEvent <> '2'))                                         237768
     C                   EVAL      msg='SNDMSG MSG(''TI000104:Field "Our +                    237768
     C                             Account No. at Nostro" with value '+                       237768
     C                             A7OACN + ' for Nostro ' + BNostro +                        237768
     C                             ' is truncated in TI'') TOMSGQ(MOPERQ) +                   237768
     C                             MSGTYPE(*INFO)'                                            237768
     C                   CALLP     run(msg : %LEN(msg))                                       237768
     C                   Endif                                                                237768
     C                   Eval      BOurAc = A7OACN                                            237768
     C                   EndIf                                                                BG7590
 
      * Get after image
     C                   Eval      NostFormat = I#AIMG
 
      * Set SQL return code
     C                   Eval      SQLCOD = 0
 
      * Trigger event types:
      * '1'=Insert, '2'=Delete, '3'=Update
 
      * Get additional details for amends and inserts
     C                   If        TrgEvent <> '2'
 
      * Access SDCUSTPD to get account name
     C                   Call      'AOCUSTR0'
     C                   Parm      *BLANKS       @RtCd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      A7CUST        PCustNo
     C                   Parm      *BLANKS       PErrInf
     C     SDCUST        Parm      SDCUST        DSSDY
      *
     C                   If        @RtCd <> *Blanks
     C                   ExSR      *PSSR
     C                   EndIf
      *
      * Set up some of the GJPF fields
     C                   Eval      GJNostro   = A7CYCD + A7NONB
     C                   MoveL     A7ACSN        WKACSN
     C                   Eval      GJAccount = A7BRCD + A7CUST + A7CYCD + A7ACCD
     C                             + WKACSN
     C                   If        (%LEN(%TRIM(A7OACN)) = 35 )                                237768
     C                   EVAL      msg='SNDMSG MSG(''TI000104:Field "Our +                    237768
     C                             Account No. at Nostro" with value '+                       237768
     C                             A7OACN + ' for Nostro ' + GJNostro +                       237768
     C                             ' is truncated in TI'') TOMSGQ(MOPERQ) +                   237768
     C                             MSGTYPE(*INFO)'                                            237768
     C                   CALLP     run(msg : %LEN(msg))                                       237768
     C                   Endif                                                                237768
     C                   Eval      AOurAc = A7OACN                                            237768
     C                   EndIf
      *
      * Insert
     C                   If        TrgEvent = '1'
     C/EXEC SQL
     C+ INSERT INTO GJPF
     C+ (GJNST,
     C+  GJNDS,
     C+  GJCCY,
     C+  GJABF,
     C+  GJANF,
     C+  GJASF,
     C+  GJXM,
     C+  GJACCT,
     C+  GJOAN,
     C+  GJXMR,
     C+  DUALACTION,
     C+  CUSER,
     C+  AUSER)
     C+ VALUES(
     C+ :GJNostro,
     C+ :BBCNA1,
     C+ :A7CYCD,
     C+ ' ',
     C+ ' ',
     C+ ' ',
     C+ '08',
     C+ :GJAccount,
     C********** + :A7OANN,                                                                   237768
     C+ :AOurAc,                                                                              237768
     C+ 'ND',
     C+ ' ',
     C+ 0,
     C+ 0)
     C/END-EXEC
     C                   EndIf
      *
      * Delete
     C                   If        TrgEvent = '2'
     C/EXEC SQL
     C+ DELETE FROM GJPF
     C+ WHERE GJNST = :BNostro
     C/END-EXEC
     C                   EndIf
      *
      * Update
     C                   If        TrgEvent = '3'
      *
      * Check if any of the fields to go on GJPF have changed -
      * only update if true
     C                   If        BNostro  <> GJNostro Or
     C                             BAccount <> GJAccount Or
     C**********                   BOurAc   <> A7OANN                                         237768
     C                             BOurAc   <> AOurAc                                         237768
     C/EXEC SQL
     C+ UPDATE GJPF Set
     C+ GJNDS  = :BBCNA1,
     C+ GJCCY  = :A7CYCD,
     C+ GJACCT = :GJAccount,
     C********** + GJOAN  = :A7OANN                                                           237768
     C+ GJOAN  = :AOurAc                                                                      237768
     C+ WHERE GJNST = :BNostro
     C/END-EXEC
 
     C                   EndIf
     C                   EndIf
      *
      * Check for successful completion
     C                   If        SQLCOD <> 0
     C                   ExSR      *PSSR
     C                   EndIf
 
     C                   SetOn                                        LR
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE
 
     C                   SetOn                                        LR
     C                   Return
 
     C                   EndSR
 
      **---------------------------------------------------------------
      *****************************************************************

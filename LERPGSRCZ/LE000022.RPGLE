     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
     H THREAD(*SERIALIZE)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Calculate Facility Transaction Exposure')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000022 - Calculate Facility Transaction Exposure           *
      *                                                               *
      *  Function:  This program is called from LE0491 and will       *
      *             calculate the facility exposures (for 10 days) in *
      *             facility currency by invoking java method         *
      *             'calculateTransactionExposureInFccy'              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG8158A           Date 07Jun06               *
      *                 BUG8158            Date 25Apr05               *
      *                 BUG6135            Date 02Mar05               *
      *                 BUG3382            Date 22Jun04               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG8158A (Reopen) - COB: LEC06A 10015 failed                 *
      *  BUG8158 - Length or start position is out of range for the   *
      *            string operation                                   *
      *  BUG6135 - LEC06A 100015 failed due to incorrect class path.  *
      *  BUG3382 - Facilities popup called from deals input shows an  *
      *            available amount of ZERO when a credit line has    *
      *            been drawn upon                                    *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Prototype for a Java String object
     D crtString       PR              O   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             *CONSTRUCTOR)
     D   value                       10A   CONST VARYING
 
      ** Prototype for a Java Integer object
     D crtInteger      PR              O   EXTPROC(*JAVA:
     D                                             'java.lang.Integer':
     D                                             *CONSTRUCTOR)
     D   value2                      10I 0 VALUE
 
      ** Prototype for RPGWrapper object creation (instantiation)
     D crtCalcClass    PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                      BUG6135
     D**********                           wrapper.as400.RPGWrapper':                        BUG6135
     D                                     wrapper.access.RPGWrapper':                       BUG6135
     D                                     *CONSTRUCTOR)
     D   value3                        O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
 
      ** Prototype for CalcClass' calculateTransactionExposureInFccy method
     D getValues       PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                      BUG6135
     D**********                           wrapper.as400.RPGWrapper':                        BUG6135
     D                                     wrapper.access.RPGWrapper':                       BUG6135
     D                                     'calculateTransactionExposureInFccy')
     D                                     CLASS(*JAVA:'java.lang.String')
     D   Int1                        10I 0 VALUE
     D   String2                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   String3                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
 
      ** Prototype for java string's getBytes method
     D***cvtToBytes      PR           260A   EXTPROC(*JAVA:                                  BUG3382
     D cvtToBytes      PR           273A   EXTPROC(*JAVA:                                    BUG3382
     D                                             'java.lang.String':
     D                                             'getBytes')
     D                                     VARYING
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WRPG            C                   CONST('rpg')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ArrUPPER        S              1    CTDATA DIM(26) PERRCD(26)
     D ArrLOWER        S              1    CTDATA DIM(26) PERRCD(26)
 
     D WSystem         DS
     D   WChar1                1      1
     D   WChar2                2      2
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Create CalcClass object field
     D CalcClassObj    S               O   CLASS(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                      BUG6135
     D**********                           wrapper.as400.RPGWrapper')                        BUG6135
     D                                     wrapper.access.RPGWrapper')                       BUG6135
 
      ** Create string objects
     D Parm1           S             10I 0
     D Parm2           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm3           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm4           S               O   CLASS(*JAVA:'java.lang.String')
     D RcvParms        S               O   CLASS(*JAVA:'java.lang.String')
 
     D PRtnCde         S              7
     D PDLNO           S              6  0
     D PMOD            S              2
     D PSMOD           S              4
     D PChar260        S            260
     D PCEXP           S             13  0                                                   BUG3382
 
     D WFolder         S              5A
     D***WRcvStr         S            260A   VARYING                                         BUG3382
     D WRcvStr         S            273A   VARYING                                           BUG3382
     D Ix              S              3  0
     D Iy              S              3  0
     D Iz              S              2  0
     D Idx             S              2  0
     D WKCEXP          S             13                                                      BUG3382
     D WRun            S              1
     D WError          S              5                                                     BUG8158A
 
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
 
      ** Create java string objects for all parameters to be passed to java
 
     C                   EVAL      Parm1 = PDLNO
     C                   EVAL      Parm2 = crtString(PMOD)
     C                   EVAL      Parm3 = crtString(PSMOD)
 
      ** Invoke the getValues method of the CalcClass object
 
     C                   EVAL      RcvParms = getValues(CalcClassObj:
     C                                                  Parm1:
     C                                                  Parm2:
     C                                                  Parm3)
 
      ** Convert the received java string to RPG bytes (Varying alpha field)
 
     C                   EVAL      WRcvStr = cvtToBytes(RcvParms)
 
      ** Retrieve all fields from received string via substring function
 
     C                   MOVEL     WRcvStr       WError                                     BUG8158A
     C**********         IF        WRcvStr = 'ERROR'                                        BUG8158A
     C                   IF        WError =  'ERROR'                                        BUG8158A
     C                   EVAL      PRtnCde = '*NRF   '
     C                   ELSE
 
      ** Retrieve all fields from received string via substring function
 
     C                   MOVE      *BLANKS       PChar260
     C                   MOVE      *ZEROS        PCEXP                                       BUG3382
     C**********         MOVEL     WRcvStr       PChar260                                    BUG3382
     C                   EVAL      %LEN(WRcvStr) = 273                                       BUG8158
     C                   EVAL      PChar260 = %SUBST(WRcvStr:1:260)                          BUG3382
     C                   EVAL      WKCEXP = %SUBST(WRcvStr:261:13)                           BUG3382
     C                   MOVE      WKCEXP        PCEXP                                       BUG3382
     C                   ENDIF
 
     C                   RETURN
 
      **********************************************************************
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtnCde
     C                   PARM                    PDLNO
     C                   PARM                    PMOD
     C                   PARM                    PSMOD
     C                   PARM                    PChar260
     C                   PARM                    PCEXP                                       BUG3382
 
     C                   IN        SDSTAT
     C                   EVAL      WSystem = LIBR
 
     C                   EVAL      Idx = 1
     C     WChar1        LOOKUP    ArrUPPER(Idx)                          89
 
     C                   IF        *IN89 = *ON
     C                   EVAL      WChar1 = ArrLOWER(Idx)
     C                   ENDIF
 
     C                   EVAL      Idx = 1
     C     WChar2        LOOKUP    ArrUPPER(Idx)                          89
 
     C                   IF        *IN89 = *ON
     C                   EVAL      WChar2 = ArrLOWER(Idx)
     C                   ENDIF
 
     C     WSystem       CAT       WRPG          WFolder
 
     C                   EVAL      Parm4 = crtString(WFolder)
 
      ** Create "CalcClass" object to access its 'calculateTransactionExposureInFccy'
      ** 'calculateTransactionExposureInFccy' method
 
     C                   EVAL      CalcClassObj = crtCalcClass(Parm4)
 
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
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
** ArrUPPER
ABCDEFGHIJKLMNOPQRSTUVQXYZ
** ArrLOWER
abcdefghijklmnopqrstuvwxyz

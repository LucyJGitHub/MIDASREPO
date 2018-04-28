     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
     H THREAD(*SERIALIZE)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Calculate Facility FX Margin Exposure')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000023 - Calculate Facility FX Margin Exposure             *
      *                                                               *
      *  Function:  This program is called from LE0491 and will       *
      *             calculate the facility FX margin exposures (for   *
      *             10 days) by invoking java method                  *
      *             calculateFacilityFxmrReqmt                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. BUG6135            Date 02Mar05               *
      *                 BUG3644            Date 12Jul04               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6135 - LEC06A 100015 failed due to incorrect class path.  *
      *  BUG3644 - Serious Error in Collateralised Lending            *
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
     D   String                        O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
 
      ** Prototype for CalcClass' calculateTransactionExposureInFccy method
     D getValues       PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                      BUG6135
     D**********                           wrapper.as400.RPGWrapper':                        BUG6135
     D                                     wrapper.access.RPGWrapper':                       BUG6135
     D                                     'calculateFacilityFxmrReqmt')
     D                                     CLASS(*JAVA:'java.lang.String')
     D***String1                       O   CLASS(*JAVA:'java.lang.String')            BUG3644 CSD027
     D   String0                       O   CLASS(*JAVA:'java.lang.String')                    CSD027
     D                                     CONST                                             BUG3644
     D***Int1**                      10I 0 VALUE                                              CSD027
     D   String1                       O   CLASS(*JAVA:'java.lang.String')                    CSD027
     D                                     CONST                                              CSD027
     D   Int2                        10I 0 VALUE
     D   Int3                        10I 0 VALUE
 
      ** Prototype for java string's getBytes method
     D cvtToBytes      PR           130A   EXTPROC(*JAVA:
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
 
     D ArrEXPA         S             13    DIM(10)
 
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
     D Parm0           S               O   CLASS(*JAVA:'java.lang.String')                   BUG3644
     D*Parm1***        S             10I 0                                                    CSD027
     D Parm1           S               O   CLASS(*JAVA:'java.lang.String')                    CSD027
     D Parm2           S             10I 0
     D Parm3           S             10I 0
     D Parm4           S               O   CLASS(*JAVA:'java.lang.String')
     D RcvParms        S               O   CLASS(*JAVA:'java.lang.String')
 
     D PRtnCde         S              7
     D*PFCCU***        S              6  0                                                    CSD027
     D PFCCU           S              6                                                       CSD027
     D PFACT           S              3  0
     D PFCNO           S              2  0
     D PChar130        S            130
     D PFBRC           S              3                                                      BUG3644
 
     D WRcvStr         S            130A   VARYING
     D Ix              S              3  0
     D Iy              S              3  0
     D Iz              S              2  0
     D Idx             S              2  0
     D WFolder         S              5
     D WRun            S              1
 
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
 
     C                   EVAL      Parm0 = crtString(PFBRC)                                  BUG3644
     C*****              EVAL      Parm1 = PFCCU                                              CSD027
     C                   EVAL      Parm1 = crtString(PFCCU)                                   CSD027
     C                   EVAL      Parm2 = PFACT
     C                   EVAL      Parm3 = PFCNO
 
      ** Invoke the getValues method of the CalcClass object
 
     C                   EVAL      RcvParms = getValues(CalcClassObj:
     C                                                  Parm0:                               BUG3644
     C                                                  Parm1:
     C                                                  Parm2:
     C                                                  Parm3)
 
      ** Convert the received java string to RPG bytes (Varying alpha field)
 
     C                   EVAL      WRcvStr = cvtToBytes(RcvParms)
 
      ** Retrieve all fields from received string via substring function
 
     C                   IF        WRcvStr = 'ERROR'
     C                   EVAL      PRtnCde = '*NRF   '
     C                   ELSE
     C                   MOVEL     WRcvStr       PChar130
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
     C                   PARM                    PFCCU
     C                   PARM                    PFACT
     C                   PARM                    PFCNO
     C                   PARM                    PChar130
     C                   PARM                    PFBRC                                       BUG3644
 
      ** Get system prefix and convert it to lowercase
 
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
      ** 'calculateFacilityFxmrReqmt' method
 
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

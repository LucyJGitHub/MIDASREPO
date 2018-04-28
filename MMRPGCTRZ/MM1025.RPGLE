     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Calculate Yield Rate For Bills Bought')       *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MM1025 - CALCULATE YIELD RATE FOR BILLS BOUGHT               *
      *                                                               *
      *  Function:  This module calculates a yield rate for a bill    *
      *             given the value date, maturity date, effective    *
      *             interest rate and calculation method.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD026986           Date 16May14               *
      *  Prev Amend No. CDL093             Date 07Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026986 - remove changes made by CDL093                     *
      *  CDL093 - MM Interest calculation type 9.                     *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     D**********ZZStartDate     S              8S 0                                  CDL093 MD026986
     D**********ZZEndDate       S              8S 0                                  CDL093 MD026986
     D**********@@Rtn           S              1A                                    CDL093 MD026986
     D**********#29Feb          S              1A                                    CDL093 MD026986
      /EJECT
      *
      ** CALCULATE YIELD RATE
      *
     C                   EXSR      CALYLD
      *
      *  RETURN
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* CALYLD - CALCULATE YIELD RATE (FOR BILLS BOUGHT)              *
     C*                                                               *
     C*****************************************************************
     C     CALYLD        BEGSR
      *
      **  CALCULATE DAYS TO MATURITY
      *
     C     ##END         SUB       ##BEG         W#DMAT            5 0
      **********                                                                     CDL093 MD026986
     C**********         If        ##CALC= '9'                                       CDL093 MD026986
      **********                                                                     CDL093 MD026986
     C**********         CALLB     'ZDATE9'                                          CDL093 MD026986
     C**********         PARM                    ##BEG                               CDL093 MD026986
     C**********         Parm                    ZZStartDate                         CDL093 MD026986
     C**********         Parm                    @@Rtn                               CDL093 MD026986
      **********                                                                     CDL093 MD026986
      **********                                                                     CDL093 MD026986
     C**********         CALLB     'ZDATE9'                                          CDL093 MD026986
     C**********         PARM                    ##END                               CDL093 MD026986
     C**********         Parm                    ZZEndDate                           CDL093 MD026986
     C**********         Parm                    @@Rtn                               CDL093 MD026986
      **********                                                                     CDL093 MD026986
      ***Check*if the period contains a Feb 29                                       CDL093 MD026986
      **********                                                                     CDL093 MD026986
     C**********         CallB     'ZFEB29CHK'                                       CDL093 MD026986
     C**********         Parm                    ZZStartDate                         CDL093 MD026986
     C**********         Parm                    ZZEndDate                           CDL093 MD026986
     C**********         Parm                    #29Feb                              CDL093 MD026986
      **********                                                                     CDL093 MD026986
     C**********         ENDIF                                                       CDL093 MD026986
      *
      **  DETERMINE DAYS IN YEAR
      *
     C     ##CALC        IFEQ      '2'
     C     ##CALC        OREQ      '3'
     C     ##CALC        OREQ      '5'
     C                   Z-ADD     360           W#DINY            3 0
     C                   END
      *
     C     ##CALC        IFEQ      '1'
     C     ##CALC        OREQ      '4'
     C*****##CALC*****   OREQ      '9'                                               CDL093 MD026986
     C*****#29Feb*****   ANDNE     'Y'                                               CDL093 MD026986
     C                   Z-ADD     365           W#DINY
     C                   END
      *
     C     ##CALC        IFEQ      '6'
     C*****##CALC*****   OREQ      '9'                                               CDL093 MD026986
     C*****#29Feb*****   ANDEQ     'Y'                                               CDL093 MD026986
     C                   Z-ADD     366           W#DINY
     C                   END
      *
      **  CALCULATE YIELD RATE
      *
     C     ##DIRT        MULT      W#DINY        W#NUMR           15 5
     C                   MULT      100           W#NUMR
      *
     C     W#DINY        MULT      100           W#DENO           15 5
      *
     C     ##DIRT        MULT      W#DMAT        W#ADJD           15 5
     C                   SUB       W#ADJD        W#DENO
      *
     C     W#DENO        IFNE      *ZERO
     C     W#NUMR        DIV       W#DENO        ##YLD
     C                   ELSE
     C                   Z-ADD     *ZERO         ##YLD
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Parameters passed into the program
     C     *ENTRY        PLIST
      *
      ** INPUTS
      *
      ** Start Date
     C                   PARM                    ##BEG             5 0
      *
      ** End Date
     C                   PARM                    ##END             5 0
      *
      ** Interest Rate
     C                   PARM                    ##DIRT           11 7
      *
      ** Calculation Method
     C                   PARM                    ##CALC            1
      *
      ** OUTPUTS
      *
      ** Yield
     C                   PARM                    ##YLD            11 7
     C                   ENDSR
     C*****************************************************************

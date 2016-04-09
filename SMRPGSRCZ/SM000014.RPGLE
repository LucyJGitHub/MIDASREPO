     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update data for mapped files')                *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000014 - Update data for mapped files                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSM007             Date 08Nov05               *
      *                 CGL034             Date 13Sep04               *
      *                 CGL029  *CREATE     Date 13Feb04              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSM007 - Account Code conversion processing                  *
      *           Specifically handling APOSTPD                       *
      *  CGL034 - Perform conversion from external table.             *
      *  CGL029 - Increase Account Code to 10 digits.                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrAPOST - Special Processing for file which have APOSTPD     *                       CSM007
      *            Format                                             *                       CSM007
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
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
 
     FINPFILE   UF   F32766        DISK    INFSR(*PSSR)
     F                                     USROPN
     FSMACFXL0  IF   E           K DISK    INFSR(*PSSR)
     FSMACFNL0  UF   E           K DISK    INFSR(*PSSR)
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)                                       CSM007
     FSMAC10PD  IF   E           K DISK    INFSR(*PSSR)                                       CSM007
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ ===================================  ¦
      ** +--------------------------------------+
 
     D WNewStart       S              5  0 DIM(100)
     D WOldLen         S              2  0 DIM(100)
     D WNewLen         S              2  0 DIM(100)
     D WDigit          S              2  0 DIM(100)
     D WField          S             10    DIM(100)                                           CSM007
     D WFormat         S             10    DIM(100)                                           CSM007
     D SDCurr        E DS                  EXTNAME(SDCURRPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
     D PFile           S             10
     D PRetCde         S              7
     D PCurr           S              3
     D POptn           S              7
     D A               S              5  0
     D B               S              2  0
     D C               S              2  0
     D D               S             10                                                       CSM007
     D E               S             10                                                       CSM007
     D W               S              2  0
     D Y               S              2  0
     D Z               S              2  0
     D WFldMap         S             24
     D WUpd21          S             21
     D WUpd18          S             18
     D WNumDig         S              2  0
     D WAcodNum15      S              4  0                                                    CSM007
      *
     D LETTERS         C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D Numbers         C                   '0123456789'                                       CSM007
      *
     D WFld4           S              4
     D WFld4n          S             10
      *
      ** 12-long account - normally for partial account (customer/account code/seq)
      *
     D WFld12          DS
     D  WCnum12                1      6
     D  WAcod12                7     10
     D  WSeq12                11     12
     D WFld12n         DS
     D  WCnum12n               1      6
     D  WAcod12n               7     16
     D  WSeq12n               17     18
 
     **  15-long account - normally for partial with ccy (customer/ccy/account code/seq)
 
     D WFld15          DS
     D  WCnum15                1      6
     D  WCcy15                 7      9
     D  WAcod15               10     13
     D  WSeq15                14     15
     D WFld15n         DS
     D  WCnum15n               1      6
     D  WCcy15n                7      9
     D  WAcod15n              10     19
     D  WSeq15n               20     21
 
     **  18-long account - normally for full account (customer/ccy/account code/seq/branch)
     **  full account could also be branch/customer/ccy/account code/seq
 
     D WFld18          DS
     D  WCnum18a               1      6
     D  WCcy18a                7      9
     D  WAcod18a              10     13
     D  WSeq18a               14     15
     D  WBr18a                16     18
     D  WBr18b                 1      3
     D  WCnum18b               4      9
     D  WCcy18b               10     12
     D  WAcod18b              13     16
     D  WSeq18b               17     18
     D WFld18n         DS
     D  WCnum18x               1      6
     D  WCcy18x                7      9
     D  WAcod18x              10     19
     D  WSeq18x               20     21
     D  WBr18x                22     24
     D  WBr18y                 1      3
     D  WCnum18y               4      9
     D  WCcy18y               10     12
     D  WAcod18y              13     22
     D  WSeq18y               23     24
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     IINPFILE   NS
     I                                  132766  RecData
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PFile            10
 
      ** Initialise array and counters
 
     C                   Clear                   Z
     C                   Clear                   Y
     C                   Clear                   WNewStart
     C                   Clear                   WOldLen
     C                   Clear                   WNewLen
     C                   Clear                   WField                                       CSM007
     C                   Clear                   WFormat                                      CSM007
      *
      * Put in an array all fields to be changed for the file
     C     PFILE         Setll     SMACFXL0
     C                   Read      SMACFXL0
     C                   DoW       NOT %EOF AND
     C                             AXFile = PFile
      *                                                                                       CGL034
      *  Include numeric and alpha fields.                                                    CGL034
      *                                                                                       CGL034
     C**********         If        AXNDIG = 0 OR                                              CGL034
     C**********                   AXNDIG <> 0 AND AXLENG <> 4                                CGL034
     C                   Eval      Z = Z + 1
     C                   Eval      WNewStart(Z) = AXSPNW
     C                   Eval      WOldLen(Z) = AXLENG
     C                   Eval      WNewLen(Z) = AXLENG + 6
     C                   Eval      WDigit(Z) = AXNDIG
     C                   Eval      WFormat(Z) = AXSHRD                                        CSM007
     C                   Eval      WField(Z) = AXFLDN                                         CSM007
     C**********         EndIf                                                                CGL034
 
     C                   Read      SMACFXL0
     C                   EndDo
 
      ** If there are fields to be changed, read all records in the file and
      ** process accordingly:
      ** move right for all values with reference to account code
      ** move left for the rest but this is already done by the *MAP *DROP copy command
      **      if the field is character
      ** if field is numeric, need to remove the 6 zeros in the beginning and process as though
      **      field is a character
 
     C                   If        Z > 0
     C                   Open      INPFILE                              80
     C                   If        *IN80 = '0'
     C                   Read      INPFILE
     C                   DoW       NOT %EOF
     C                   Eval      Y = 1
     C                   Exsr      SRUpdate
 
      ** Update existing record and read next
 
     C                   Except
     C                   Read      INPFILE
     C                   EndDo
     C                   EndIf
 
     C                   EndIf
 
     C     PFILE         CHAIN     SMACFND0                           10
     C     *IN10         IFEQ      '0'
     C                   EVAL      PROCS = 'C'
     C                   UPDATE    SMACFND0
     C                   ENDIF
 
     C                   Close     INPFILE
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdate - Updates affected fields per record                *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SrUpdate      BegSr
 
      ** Read through all fields kept in the array
 
     C                   DoW       Y <= Z
     C                   Eval      A = WNewStart(Y)
     C                   Eval      B = WNewLen(Y)
     C                   Eval      C = WOldLen(Y)
     C                   Eval      D = WField(Y)                                              CSM007
     C                   Eval      E = WFormat(Y)                                             CSM007
     C                   Eval      WNumDig = WDigit(Y)
     C                   Eval      WFldMap = %SUBST(RecData:A:B)
 
     C                   Select
 
      ** Field is an account code
 
     C                   When      C = 4
      *                                                                                       CGL034
      *  If field is alpha,                                                                   CGL034
      *                                                                                       CGL034
     C     WNumDig       IfEq      0                                                          CGL034
      *                                                                                       CGL034
      *  set WFld4 to the left 4 characters of the field.                                     CGL034
      *                                                                                       CGL034
     C                   Eval      WFld4 = WFldMap
      *                                                                                       CGL034
      *  If field is NOT alpha,                                                               CGL034
      *                                                                                       CGL034
     C                   Else                                                                 CGL034
      *                                                                                       CGL034
      *  set WFld4 to the right 4 characters of the field.                                    CGL034
      *                                                                                       CGL034
     C                   Eval      WFld4 = %SUBST(WFldMap:7:4)                                CGL034
      *                                                                                       CGL034
     C                   EndIf                                                                CGL034
      *                                                                                       CGL034
     C                   If        WFld4 = '****'
     C                   Eval      WFld4n = *ALL'*'
     C                   Else
     C                   If        WFld4 <> *blanks
      *                                                                                       CGL034
      *  Call program SD00AC10  to perform conversion to 10-digit account code.               CGL034
      *                                                                                       CGL034
     C**********         Eval      WFld4n = *zeros                                            CGL034
     C**********         Move      WFld4         WFld4n                                       CGL034
     C                   Call      'SM00AC10'                                                 CGL034
     C                   Parm                    WFld4                                        CGL034
     C                   Parm                    WFld4n                                       CGL034
     C                   Else
     C                   Clear                   WFld4n
     C                   EndIf
     C                   EndIf
     C                   Eval      %SUBST(RecData:A:B) = WFld4n
 
      ** Field contains a partial account (ignore when nostro or retail account)
 
     C                   When      C = 12
     C                   If        WNumDig = 0
     C                   Eval      WFld12 = WFldMap
     C                   Else
     C                   Eval      WUpd18 = WFldMap
     C                   Move      WUpd18        WFld12
     C                   EndIf
      *
     C                   If        WSeq12 <> *BLANKS and
     C                             WSeq12 <> '00'
     C                   Eval      WFld12n = *zeros
     C     ' '           Scan      WFld12        W
     C                   If        W = 0
     C                   Eval      WCnum12n = WCnum12
     C                   Eval      WSeq12n = WSeq12
      *                                                                                       CGL034
      *  Call program SD00AC10  to perform conversion to 10-digit account code.               CGL034
      *                                                                                       CGL034
     C**********         Move      WAcod12       WAcod12n                                     CGL034
     C                   Call      'SM00AC10'                                                 CGL034
     C                   Parm                    WAcod12                                      CGL034
     C                   Parm                    WAcod12n                                     CGL034
     C                   Eval      %SUBST(RecData:A:B) = WFld12n
     C                   EndIf
     C                   EndIf
      *
      ** Field contains a partial account with branch (ignore when nostro or retail account)
     C                   When      C = 15
      ** If the file is APOSTPD or shares the format of APOSTPD and the field is the          CSM007
      ** original transaction field (OTRF) then it may require speocial treatment             CSM007
     C                   If        PFILE = 'APOSTPD' and D = 'OTRF' or                        CSM007
     C                             E = 'APOSTPD' and D = 'OTRF'                               CSM007
     C                   ExSr      SrAPOST                                                    CSM007
     C                   Else                                                                 CSM007
     C                   If        WNumDig = 0
     C                   Eval      WFld15 = WFldMap
     C                   Else
     C                   Eval      WUpd21 = WFldMap
     C                   Move      WUpd21        WFld15
     C                   EndIf
      *
     C                   IF        %CHECK(LETTERS : WCcy15) = *ZERO
     C                   Eval      WFld15n = *zeros
     C     ' '           Scan      WFld15        W
     C                   If        W = 0
     C                   Eval      WCnum15n = WCnum15
     C                   Eval      WCcy15n = WCcy15
     C                   Eval      WSeq15n = WSeq15
      *                                                                                       CGL034
      *  Call program SD00AC10  to perform conversion to 10-digit account code.               CGL034
      *                                                                                       CGL034
     C**********         Move      WAcod15       WAcod15n                                     CGL034
     C                   Call      'SM00AC10'                                                 CGL034
     C                   Parm                    WAcod15                                      CGL034
     C                   Parm                    WAcod15n                                     CGL034
     C                   Eval      %SUBST(RecData:A:B) = WFld15n
     C                   EndIf
     C                   EndIf
     C                   EndIf                                                                CSM007
      *
      ** Field contains a full account (ignore when nostro or retail account)
     C                   When      C = 18
     C                   If        WNumDig = 0
     C                   Eval      WFld18 = WFldMap
     C                   Else
     C                   Move      WFldMap       WFld18
     C                   EndIf
     C                   Eval      WFld18n = *zeros
     C     ' '           Scan      WFld18        W
     C                   If        W = 0
 
      ** Check whether branch is at the beginning or end.  Use ccy for uniqueness.
 
     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       PRetCde
     C                   Parm      '*KEY'        POptn
     C                   Parm      WCcy18a       PCurr
     C     SDCurr        Parm      SDCurr        DSSDY
     C                   If        PRetCde = *Blanks
     C                   Eval      WCnum18x = WCnum18a
     C                   Eval      WCcy18x = WCcy18a
     C                   Eval      WSeq18x = WSeq18a
     C                   Eval      WBr18x = WBr18a
      *                                                                                       CGL034
      *  Call program SD00AC10  to perform conversion to 10-digit account code.               CGL034
      *                                                                                       CGL034
     C*****              Move      WAcod18a      WAcod18x                                     CGL034
     C                   Call      'SM00AC10'                                                 CGL034
     C                   Parm                    WAcod18a                                     CGL034
     C                   Parm                    WAcod18x                                     CGL034
     C                   Eval      %SUBST(RecData:A:B) = WFld18n
 
     C                   Else
     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       PRetCde
     C                   Parm      '*KEY'        POptn
     C                   Parm      WCcy18b       PCurr
     C     SDCurr        Parm      SDCurr        DSSDY
     C                   If        PRetCde = *Blanks
     C                   Eval      WCnum18y = WCnum18b
     C                   Eval      WCcy18y = WCcy18b
     C                   Eval      WSeq18y = WSeq18b
     C                   Eval      WBr18y = WBr18b
      *                                                                                       CGL034
      *  Call program SD00AC10  to perform conversion to 10-digit account code.               CGL034
      *                                                                                       CGL034
     C**********         Move      WAcod18b      WAcod18y                                     CGL034
     C                   Call      'SM00AC10'                                                 CGL034
     C                   Parm                    WAcod18b                                     CGL034
     C                   Parm                    WAcod18y                                     CGL034
     C                   Eval      %SUBST(RecData:A:B) = WFld18n
     C                   Endif
     C                   Endif
 
     C                   EndIf
 
     C                   EndSl
 
     C                   Eval      Y = Y + 1
     C                   EndDo
 
     C                   EndSr
 
      *****************************************************************                       CSM007
      /EJECT                                                                                  CSM007
      *****************************************************************                       CSM007
      *                                                               *                       CSM007
      *  SrAPOST  - Updates affected fields per record                *                       CSM007
      *                                                               *                       CSM007
      *  Called by: SrUpdate                                          *                       CSM007
      *                                                               *                       CSM007
      *  Calls:     None                                              *                       CSM007
      *                                                               *                       CSM007
      *****************************************************************                       CSM007
     C     SrAPOST       BegSr                                                                CSM007
                                                                                              CSM007
     C                   If        WNumDig = 0                                                CSM007
     C                   Eval      WFld15 = WFldMap                                           CSM007
     C                   Else                                                                 CSM007
     C                   Eval      WUpd21 = WFldMap                                           CSM007
     C                   Move      WUpd21        WFld15                                       CSM007
     C                   EndIf                                                                CSM007
      *                                                                                       CSM007
     C                   IF        %CHECK(LETTERS : WCcy15) = *ZERO                           CSM007
     C     WCcy15        chain     SDCURRL0                                                   CSM007
     C                   If        %found                                                     CSM007
     C                   Eval      WFld15n = *zeros                                           CSM007
     C     ' '           Scan      WFld15        W                                            CSM007
     C                   If        W = 0                                                      CSM007
     C                   IF        %CHECK(Numbers : WAcod15) = *ZERO                          CSM007
     C                   Move      WAcod15       WAcodNum15                                   CSM007
     C     WAcodNum15    chain     SMAC10PD                                                   CSM007
     C                   If        %found                                                     CSM007
     C                   Eval      WCnum15n = WCnum15                                         CSM007
     C                   Eval      WCcy15n = WCcy15                                           CSM007
     C                   Eval      WSeq15n = WSeq15                                           CSM007
      *                                                                                       CSM007
      *  Call program SD00AC10  to perform conversion to 10-digit account code.               CSM007
      *                                                                                       CSM007
     C**********         Move      WAcod15       WAcod15n                                     CSM007
     C                   Call      'SM00AC10'                                                 CSM007
     C                   Parm                    WAcod15                                      CSM007
     C                   Parm                    WAcod15n                                     CSM007
     C                   Eval      %SUBST(RecData:A:B) = WFld15n                              CSM007
     C                   EndIf                                                                CSM007
     C                   EndIf                                                                CSM007
     C                   EndIf                                                                CSM007
     C                   EndIf                                                                CSM007
     C                   EndIf                                                                CSM007
                                                                                              CSM007
     C                   EndSr                                                                CSM007
                                                                                              CSM007
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR    - Program exception error routine                   *
      *             Called automatically if a program error occurs,   *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     *PSSR         BegSr
 
     C     PFILE         CHAIN     SMACFND0                           10
     C     *IN10         IFEQ      '0'
     C                   EVAL      PROCS = 'F'
     C                   UPDATE    SMACFND0
     C                   ENDIF
 
     C                   DUMP
 
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
 
 
     C                   RETURN
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
     OINPFILE   E
     O                       RecData          32766
      *****************************************************************

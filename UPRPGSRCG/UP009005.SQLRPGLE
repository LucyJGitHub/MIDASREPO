     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Update target file')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP009005 - Update target file                                *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. CPK030             Date 12Feb15               *
      *  Prev Amend No. AR1092254A         Date 14Mar13               *
      *                 AR926961A          Date 28Mar12               *
      *                 AR854642           Date 30Nov11               *
      *                 AR859322           Date 09Nov11               *
      *                 CUP021  *CREATE    Date 20Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPK030 - Correct concatenation.                              *
      *  AR1092254A - Error processing BFTEVTCODE records on AMEND    *
      *  AR926961A - Menu item does not appear even if user already   *
      *             has permission and menu item                      *
      *  AR854642 - Wrong field used to check for updates.            *
      *  AR859322 - Handle binary fields.                             *
      *  CUP021 - Rewrite of Action File processing                   *
      *                                                               *
      *****************************************************************

     FUPAFFDL1  IF   E           K DISK
     FUPAFFDL3  IF   E           K DISK    RENAME(UPAFFDD0:U_UPAFFDD0)
     F                                     PREFIX(U_)
     FUPAFFDL0  IF   E           K DISK    RENAME(UPAFFDD0:I_UPAFFDD0)
     F                                     PREFIX(I_)
     FUPAFDVL1  IF   E           K DISK
      *
     D RecNFind        S              1A
     D RecCount        S              8  0
     D STMT            S           4000A
     D WhereStr        S           2000A
     D SetStr          S           1900A
     D ColLine         S           1000A
     D ValLine         S           2800A
     D Pos             S              5  0
     D NumOfCol        S              5  0
     D PrevFile        S             10A
     D Indx            S              4  0
     D KNum            S              3  0
     D FNum            S              3  0
     D CNumber         S             15  0
     D FieldLen        S              5  0
     D Recursive       S              1A
     D QuoteChar       S              1A    INZ('''')
     D OutString       S            400A
     D Idx             S              3  0
     D OIdx            S              3  0
     D XPos            S              3  0
     D WFile           S             10
     D WKey            S              1
     D IOfield         S             16
     D NumDP           S              1  0
     D ZADIG           S              2  0
     D ZADEC           S              1  0
     D Z1              S              2  0
     D Z2              S              2  0
     D ZADEC2          S              2  0
     D ZFIELD          S             16
      *
     DTxtLine          DS
     D*Txt******                      1    DIM(200)                                         AR859322
     D Txt                            1    DIM(1000)                                        AR859322
     DOutLine          DS
     D*XOut*****                      1    DIM(400)                                         AR859322
     D XOut                           1    DIM(2000)                                        AR859322

     DFmtInp           DS
     D FmtInp30A               1     30A
     D FmtInp01P               1     01P 0
     D FmtInp03P               1     02P 0
     D FmtInp05P               1     03P 0
     D FmtInp07P               1     04P 0
     D FmtInp09P               1     05P 0
     D FmtInp11P               1     06P 0
     D FmtInp13P               1     07P 0
     D FmtInp15P               1     08P 0
     D FmtInp17P               1     09P 0
     D FmtInp19P               1     10P 0
     D FmtInp21P               1     11P 0
     D FmtInp23P               1     12P 0
     D FmtInp25P               1     13P 0
     D FmtInp27P               1     14P 0
     D FmtInp29P               1     15P 0
     D FmtInp01S               1     01S 0
     D FmtInp02S               1     02S 0
     D FmtInp03S               1     03S 0
     D FmtInp04S               1     04S 0
     D FmtInp05S               1     05S 0
     D FmtInp06S               1     06S 0
     D FmtInp07S               1     07S 0
     D FmtInp08S               1     08S 0
     D FmtInp09S               1     09S 0
     D FmtInp10S               1     10S 0
     D FmtInp11S               1     11S 0
     D FmtInp12S               1     12S 0
     D FmtInp13S               1     13S 0
     D FmtInp14S               1     14S 0
     D FmtInp15S               1     15S 0
     D FmtInp16S               1     16S 0
     D FmtInp17S               1     17S 0
     D FmtInp18S               1     18S 0
     D FmtInp19S               1     19S 0
     D FmtInp20S               1     20S 0
     D FmtInp21S               1     21S 0
     D FmtInp22S               1     22S 0
     D FmtInp23S               1     23S 0
     D FmtInp24S               1     24S 0
     D FmtInp25S               1     25S 0
     D FmtInp26S               1     26S 0
     D FmtInp27S               1     27S 0
     D FmtInp28S               1     28S 0
     D FmtInp29S               1     29S 0
     D FmtInp30S               1     30S 0
     D FmtInp02B               1     02B 0                                                  AR859322
     D FmtInp04B               1     04B 0                                                  AR859322
      *
     D KeyField        S             10A   DIM(10)
     D KeyPosit        S              5  0 DIM(10)
     D KeyLen          S              5  0 DIM(10)
     D KeyDP           S              2  0 DIM(10)
     D KeyType         S              1A   DIM(10)
     D ZA1             S              1    DIM(16)
     D ZA2             S              1    DIM(16)
      *
     C                   EVAL      RecCount = 0
     C                   EVAL      Recursive = 'F'
     C                   EVAL      *IN61 = '0'
      *
      * Read driving file until EOF.
     C     *IN61         DOWEQ     '0'
     C                   READ      UPAFDVL1                               61
     C                   IF        *IN61 = '0'
      *
     C                   IF        PrevFile <> ATFILE
     C                   EXSR      GetKeyInfo
     C                   EVAL      PrevFile = ATFILE
     C                   ENDIF
      *
     C                   EVAL      RecCount = RecCount + 1
     C                   EXSR      BuildKey
      * Setup fields for update.
     C     WFile         SETLL     UPAFFDL3
     C                   EVAL      *IN60 = '0'
      *
     C                   EVAL      FNum = 0
     C                   DOW       *IN60 = '0'
     C     WFile         READE     UPAFFDL3                               60
     C                   IF        *IN60 = '0'
     C                   IF        (ATACT = 'A' and
     C                             AFIGNU  <>  'Y') or
     C                             ATACT = 'I'
     C                   EVAL      FNum = FNum + 1
     C                   EXSR      BuildSetStr
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        ATACT  = 'I' or ATACT  = 'A'
     C                   EXSR      UpdateRecord
     C                   ELSE
     C                   IF        ATACT  = 'D'
     C                   EXSR      DeleteRecord
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   SETON                                        LR
      /EJECT
      *****************************************************************
      *                                                               *
      * Get key information                                           *
      *                                                               *
      *****************************************************************
     C     GetKeyInfo    BEGSR
      *
      * Get key information.
     C                   MOVE      ATFILE        WFile
     C                   MOVE      *LOVAL        WKey
     C                   EVAL      *IN60 = '0'
     C                   EVAL      KNum = 0
     C     FFDKey        SETLL     UPAFFDL1
      *
     C                   DOW       *IN60 = '0'
     C     WFile         READE     UPAFFDL1                               60
     C                   IF        *IN60 = '0'
     C                   EVAL      KNum = KNum + 1
     C                   EVAL      KeyField(KNum) = AFFDNM
     C                   EVAL      KeyPosit(KNum) = AFFDPS
     C                   EVAL      KeyLen(KNum) = AFFDLN
     C                   EVAL      KeyDP(KNum) = AFFDDP
     C                   EVAL      KeyType(KNum) = AFFDTP
     C                   ENDIF
     C                   ENDDO
      *
     C     GetKeyInfoE   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * Build set strings                                             *
      *                                                               *
      *****************************************************************
     C     BuildSetStr   BEGSR

      /free
        IF FNum > 1;
       //*SetStr*=*%TRIM(SetStr) + ' ,';                                                    //CPK030
          SetStr = %TRIMR(SetStr) + ' ,';                                                   //CPK030
        ELSE;
          SetStr = 'SET';
        ENDIF;

       //SetStr*=*%TRIM(SetStr)*+ ' ' + U_AFFDNM + ' =';                                    //CPK030
        SetStr = %TRIMR(SetStr) + ' ' + U_AFFDNM + ' =';                                    //CPK030

       //IF*U_AFFDTP*<>*'S'*and*U_AFFDTP*<>*'P';********************************          //AR859322
       //IF**I_AFFDTP*<>*'S'*and*I_AFFDTP*<>*'P'*and*I_AFFDTP*<>*'B';*********** //AR859322 AR854642
         IF  U_AFFDTP <> 'S' and U_AFFDTP <> 'P' and U_AFFDTP <> 'B';                     //AR854642
          EXSR ReplaceQuote;
          SetStr = %TRIMR(SetStr) + ' ' + '''' +
                        %TRIMR(OutString) + '''';
        ELSE;
         FmtInp30A =  %SUBST(ATDATA:U_AFFDPS:U_AFFDLN);
         FieldLen = U_AFFDLN;
         IF U_AFFDTP = 'P';
          EXSR      ConvPack;
         ENDIF;                                                                           //AR859322
       //ELSE;******************************************************************          //AR859322
       //IF*I_AFFDTP*=*'S';***************************************************** //AR859322 AR854642
         IF U_AFFDTP = 'S';                                                               //AR854642
          EXSR      ConvSign;
         ENDIF;
       //IF*I_AFFDTP*=*'B';***************************************************** //AR859322 AR854642
        IF U_AFFDTP = 'B';                                                                //AR854642
         EXSR      ConvBin;                                                               //AR859322
        ENDIF;                                                                            //AR859322
       //*SetStr*=*%TRIM(SetStr) + ' ' + %TRIM(IOField);                                    //CPK030
          SetStr = %TRIMR(SetStr) + ' ' + %TRIM(IOField);                                   //CPK030
        ENDIF;

      /end-free
     C     BuildSetStrE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Build key                                                     *
      *                                                               *
      *****************************************************************
     C     BuildKey      BEGSR

      /free
       Indx = 0;
       WhereStr = *BLANKS;
       DOW Indx < Knum   ;
        Indx = Indx +1;
        IF Indx > 1;
       //*WhereStr*=*%TRIM(WhereStr) + ' and';                                              //CPK030
          WhereStr = %TRIMR(WhereStr) + ' and';                                             //CPK030
        ELSE;
          WhereStr = 'Where';
        ENDIF;

       //WhereStr*=*%TRIM(WhereStr) + ' ' + KeyField(Indx) + ' =';                          //CPK030
        WhereStr = %TRIMR(WhereStr) + ' ' + %TRIMR(KeyField(Indx)) + ' =';                  //CPK030

        IF KeyType(Indx) <> 'S' and KeyType(Indx) <> 'P';
        IF KeyType(Indx) = 'B' and ATFILE = 'BFTEVTCODE';                               //AR1092254A
          FmtInp30A = %SUBST(ATDATA:KeyPosit(Indx):KeyLen(Indx));                       //AR1092254A
          FieldLen = KeyLen(Indx);                                                      //AR1092254A
          ExSR      ConvBin;                                                            //AR1092254A
       //*WhereStr*=*%TRIM(WhereStr) + ' ' + IOField;                            //AR1092254A CPK030
          WhereStr = %TRIMR(WhereStr) + ' ' + IOField;                                      //CPK030
       //IF*ATACT*=*'D'*and**AFKEYF*=*'Y';************************************//AR926961A AR1092254A
        ELSEIF ATACT = 'D' and  AFKEYF = 'Y';                                           //AR1092254A
        EXSR BldDelWhr;                                                                  //AR926961A
       //*WhereStr*=*%TRIM(WhereStr) + ' ' + '''' + OutString + '''';             //AR926961A CPK030
          WhereStr = %TRIMR(WhereStr) + ' ' + '''' +
                          %TRIMR(OutString) + '''';                                         //CPK030
        ELSE;                                                                            //AR926961A
       //*WhereStr*=*%TRIM(WhereStr) + ' ' + '''' +                                         //CPK030
          WhereStr = %TRIMR(WhereStr) + ' ' + '''' +
                        %SUBST(ATDATA:KeyPosit(Indx):KeyLen(Indx))       ;                  //CPK030
          WhereStr = %TRIMR(WhereStr) + '''';                                               //CPK030
        ENDIF;                                                                           //AR926961A
        ELSE;
         FmtInp30A = %SUBST(ATDATA:KeyPosit(Indx):KeyLen(Indx));
         FieldLen = KeyLen(Indx);
         IF KeyType(Indx) = 'P';
          EXSR      ConvPack;
         ELSE;
          ExSR      ConvSign;
         ENDIF;
       //*WhereStr*=*%TRIM(WhereStr) + ' ' + IOField;                                       //CPK030
          WhereStr = %TRIMR(WhereStr) + ' ' + IOField;                                      //CPK030
        ENDIF;

       ENDDO;
      /end-free
     C     BuildKeyE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Replace quotations                                            *
      *                                                               *
      *****************************************************************
     C     ReplaceQuote  BEGSR

      /free
       XPos = %SCAN(QuoteChar:%SUBST(ATDATA:U_AFFDPS:U_AFFDLN));
       OutString = *blanks;
       OutLine = *blanks;
       IF XPos > 0;
         TxtLine = %SUBST(ATDATA:U_AFFDPS:U_AFFDLN);
         OutString = *blanks;
         Idx = 1;
         OIdx = 1;
          DOW Idx <= U_AFFDLN;
           XOut(OIdx) = Txt(Idx);
           IF Txt(Idx) = QuoteChar;
              XOut(OIdx + 1) = QuoteChar;
              OIdx = OIdx + 1;
           ENDIF;
           OIdx = OIdx + 1;
           Idx = Idx + 1;
          ENDDO;
       ELSE;
         OutLine = %SUBST(ATDATA:U_AFFDPS:U_AFFDLN);
       ENDIF;
         OutString = Outline;
      /End-free

     C     ReplaceQuoteE ENDSR
      /EJECT                                                                             //AR926961A
      *****************************************************************                  //AR926961A
      *                                                               *                  //AR926961A
      * Build delete key                                              *                  //AR926961A
      *                                                               *                  //AR926961A
      *****************************************************************                  //AR926961A
     C     BldDelWhr     BEGSR                                                           //AR926961A
      /free                                                                              //AR926961A
       XPos = %SCAN(QuoteChar:%SUBST(ATDATA:KeyPosit(Indx):KeyLen(Indx)));               //AR926961A
       OutString = *blanks;                                                              //AR926961A
       OutLine = *blanks;                                                                //AR926961A
       IF XPos > 0;                                                                      //AR926961A
         TxtLine = %SUBST(ATDATA:KeyPosit(Indx):KeyLen(Indx));                           //AR926961A
         OutString = *blanks;                                                            //AR926961A
         Idx = 1;                                                                        //AR926961A
         OIdx = 1;                                                                       //AR926961A
          DOW Idx <= KeyLen(Indx);                                                       //AR926961A
           XOut(OIdx) = Txt(Idx);                                                        //AR926961A
           IF Txt(Idx) = QuoteChar;                                                      //AR926961A
              XOut(OIdx + 1) = QuoteChar;                                                //AR926961A
              OIdx = OIdx + 1;                                                           //AR926961A
           ENDIF;                                                                        //AR926961A
           OIdx = OIdx + 1;                                                              //AR926961A
           Idx = Idx + 1;                                                                //AR926961A
          ENDDO;                                                                         //AR926961A
       ELSE;                                                                             //AR926961A
         OutLine = %SUBST(ATDATA:KeyPosit(Indx):KeyLen(Indx));                           //AR926961A
       ENDIF;                                                                            //AR926961A
         OutString = Outline;                                                            //AR926961A
      /End-free                                                                          //AR926961A
                                                                                         //AR926961A
     C                   ENDSR                                                           //AR926961A
      *                                                                                  //AR926961A
      /EJECT
      *****************************************************************
      *                                                               *
      * Update record                                                 *
      *                                                               *
      *****************************************************************
     C     UpdateRecord  BEGSR
      *
     C                   EVAL      Stmt = 'update ' + ATFILE + ' ' +
     C**********                              %TRIM(SetStr) + ' ' +                           CPK030
     C                                        %TRIMR(SetStr) + ' ' +                          CPK030
     C                                        %TRIM(WhereStr)
      *
     C                   EVAL      RecNFind = 'Y'
      *
     C/exec SQL whenever SQLERROR goto ERR_TAG_U
     C/END-EXEC
     C/exec SQL whenever NOT FOUND goto ERR_TAG_U
     C/END-EXEC

     C/EXEC SQL
     C+ execute immediate :Stmt
     C/END-EXEC

     C                   EVAL      RecNFind = 'N'

     C     ERR_TAG_U     TAG
     C                   IF        RecNFind = 'Y'
     C                   EXSR      InsertRec
     C                   ENDIF

     C     UpdateRecordE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Delete record                                                 *
      *                                                               *
      *****************************************************************
     C     DeleteRecord  BEGSR
      *
     C                   EVAL      Stmt = 'delete from ' + ATFILE + ' ' +
     C                                        %TRIM(WhereStr)
      *
     C                   EVAL      RecNFind = 'Y'
      *
     C/exec SQL whenever SQLERROR goto ErrTagD
     C/END-EXEC
     C/exec SQL whenever NOT FOUND goto ErrTagD
     C/END-EXEC

     C/EXEC SQL
     C+ execute immediate :Stmt
     C/END-EXEC
      *
     C                   EVAL      RecNFind = 'N'
      *
     C     ErrTagD       TAG
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Convert packed                                                *
      *                                                               *
      *****************************************************************
     C     ConvPack      BEGSR
      *
     C     FmtInp30A     IFEQ      *BLANK
     C                   EVAL      CNumber = 0
     C                   ELSE
      *
     C                   SELECT
     C     FieldLen      WHENEQ    01
     C                   EVAL      CNumber = FmtInp01P
     C     FieldLen      WHENEQ    02
     C                   EVAL      CNumber = FmtInp03P
     C     FieldLen      WHENEQ    03
     C                   EVAL      CNumber = FmtInp05P
     C     FieldLen      WHENEQ    04
     C                   EVAL      CNumber = FmtInp07P
     C     FieldLen      WHENEQ    05
     C                   EVAL      CNumber = FmtInp09P
     C     FieldLen      WHENEQ    06
     C                   EVAL      CNumber = FmtInp11P
     C     FieldLen      WHENEQ    07
     C                   EVAL      CNumber = FmtInp13P
     C     FieldLen      WHENEQ    08
     C                   EVAL      CNumber = FmtInp15P
     C     FieldLen      WHENEQ    09
     C                   EVAL      CNumber = FmtInp17P
     C     FieldLen      WHENEQ    10
     C                   EVAL      CNumber = FmtInp19P
     C     FieldLen      WHENEQ    11
     C                   EVAL      CNumber = FmtInp21P
     C     FieldLen      WHENEQ    12
     C                   EVAL      CNumber = FmtInp23P
     C     FieldLen      WHENEQ    13
     C                   EVAL      CNumber = FmtInp25P
     C     FieldLen      WHENEQ    14
     C                   EVAL      CNumber = FmtInp27P
     C     FieldLen      WHENEQ    15
     C                   EVAL      CNumber = FmtInp29P
     C                   OTHER
     C                   EVAL      CNumber = 0
     C                   ENDSL
     C                   ENDIF
      *
     C                   MOVE      CNumber       IOField
     C                   Z-ADD     KeyDP(Indx)   NumDP
     C                   EVAL      ZFIELD = IOField
     C                   EVAL      ZADEC = NumDP
     C                   EXSR      ZEDIT
      *
     C     ConvPackE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Convert signed fields                                         *
      *                                                               *
      *****************************************************************
     C     ConvSign      BEGSR
      *
     C     FmtInp30A     IFEQ      *BLANK
     C                   EVAL      CNumber = 0
     C                   ELSE
      *
     C                   SELECT
     C     FieldLen      WHENEQ    01
     C                   EVAL      CNumber = FmtInp01S
     C     FieldLen      WHENEQ    02
     C                   EVAL      CNumber = FmtInp02S
     C     FieldLen      WHENEQ    03
     C                   EVAL      CNumber = FmtInp03S
     C     FieldLen      WHENEQ    04
     C                   EVAL      CNumber = FmtInp04S
     C     FieldLen      WHENEQ    05
     C                   EVAL      CNumber = FmtInp05S
     C     FieldLen      WHENEQ    06
     C                   EVAL      CNumber = FmtInp06S
     C     FieldLen      WHENEQ    07
     C                   EVAL      CNumber = FmtInp07S
     C     FieldLen      WHENEQ    08
     C                   EVAL      CNumber = FmtInp08S
     C     FieldLen      WHENEQ    09
     C                   EVAL      CNumber = FmtInp09S
     C     FieldLen      WHENEQ    10
     C                   EVAL      CNumber = FmtInp10S
     C     FieldLen      WHENEQ    11
     C                   EVAL      CNumber = FmtInp11S
     C     FieldLen      WHENEQ    12
     C                   EVAL      CNumber = FmtInp12S
     C     FieldLen      WHENEQ    13
     C                   EVAL      CNumber = FmtInp13S
     C     FieldLen      WHENEQ    14
     C                   EVAL      CNumber = FmtInp14S
     C     FieldLen      WHENEQ    15
     C                   EVAL      CNumber = FmtInp15S
     C     FieldLen      WHENEQ    16
     C                   EVAL      CNumber = FmtInp16S
     C     FieldLen      WHENEQ    17
     C                   EVAL      CNumber = FmtInp17S
     C     FieldLen      WHENEQ    18
     C                   EVAL      CNumber = FmtInp18S
     C     FieldLen      WHENEQ    19
     C                   EVAL      CNumber = FmtInp19S
     C     FieldLen      WHENEQ    20
     C                   EVAL      CNumber = FmtInp20S
     C     FieldLen      WHENEQ    21
     C                   EVAL      CNumber = FmtInp21S
     C     FieldLen      WHENEQ    22
     C                   EVAL      CNumber = FmtInp22S
     C     FieldLen      WHENEQ    23
     C                   EVAL      CNumber = FmtInp23S
     C     FieldLen      WHENEQ    24
     C                   EVAL      CNumber = FmtInp24S
     C     FieldLen      WHENEQ    25
     C                   EVAL      CNumber = FmtInp25S
     C     FieldLen      WHENEQ    26
     C                   EVAL      CNumber = FmtInp26S
     C     FieldLen      WHENEQ    27
     C                   EVAL      CNumber = FmtInp27S
     C     FieldLen      WHENEQ    28
     C                   EVAL      CNumber = FmtInp28S
     C     FieldLen      WHENEQ    29
     C                   EVAL      CNumber = FmtInp29S
     C     FieldLen      WHENEQ    30
     C                   EVAL      CNumber = FmtInp30S
     C                   OTHER
     C                   EVAL      CNumber = 0
     C                   ENDSL
     C                   ENDIF
      *
     C                   MOVE      CNumber       IOField
     C                   Z-ADD     KeyDP(Indx)   NumDP
     C                   CALL      'ZEDIT'
     C                   PARM                    IOField
     C                   PARM                    NumDP
      *
     C     ConvSignE     ENDSR
      *
      /EJECT
      *****************************************************************                     AR859322
      *                                                               *                     AR859322
      * Convert binary                                                *                     AR859322
      *                                                               *                     AR859322
      *****************************************************************                     AR859322
     C     ConvBin       BEGSR                                                              AR859322
      *                                                                                     AR859322
     C     FmtInp30A     IFEQ      *BLANK                                                   AR859322
     C                   EVAL      CNumber = 0                                              AR859322
     C                   ELSE                                                               AR859322
      *                                                                                     AR859322
     C                   SELECT                                                             AR859322
     C     FieldLen      WHENEQ    02                                                       AR859322
     C                   EVAL      CNumber = FmtInp02B                                      AR859322
     C     FieldLen      WHENEQ    04                                                       AR859322
     C                   EVAL      CNumber = FmtInp04B                                      AR859322
     C                   OTHER                                                              AR859322
     C                   EVAL      CNumber = 0                                              AR859322
     C                   ENDSL                                                              AR859322
     C                   ENDIF                                                              AR859322
      *                                                                                     AR859322
     C                   MOVE      CNumber       IOField                                    AR859322
      *                                                                                     AR859322
     C     ConvBinE      ENDSR                                                              AR859322
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Insert Record                                                 *
      *                                                               *
      *****************************************************************
     C     InsertRec     BEGSR
      *
     C                   Z-ADD     0             Pos
     C                   Z-ADD     0             NumOfCol
     C     IFFDKey       SETLL     I_UPAFFDD0                           99
     C                   DOW       *IN99 = '0'
     C     WFile         READE     I_UPAFFDD0                             99
     C                   IF        *IN99 = '0'
     C                   IF        I_AFCOID <> 'Y'
     C                   EVAL      NumOfCol = NumOfCol + 1
     C                   EXSR      BuildCol
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      /free
       //Stmt*=*'insert into ' + ATFILE + %TRIM(ColLine) + ')' +                            //CPK030
       //******'*values ' + %TRIM(ValLine) + ')';                                           //CPK030
        Stmt = 'insert into ' + ATFILE + %TRIMR(ColLine) + ')' +                            //CPK030
               ' values ' + %TRIMR(ValLine) + ')';                                          //CPK030
      /end-free
      *
     C/exec SQL whenever SQLERROR goto ErrTagI
     C/END-EXEC
     C/exec SQL whenever NOT FOUND goto ErrTagI
     C/END-EXEC
      *
     C/EXEC SQL
     C+ execute immediate :Stmt
     C/END-EXEC
      *
     C     ErrTagI       TAG
      *
     C     InsertRecE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Build columns                                                 *
      *                                                               *
      *****************************************************************
     C     BuildCol      BEGSR
      *
      /free
       IF NumOfCol > 1;
       //*ColLine*=*%TRIM(ColLine) + ',';                                                   //CPK030
       //*ValLine*=*%TRIM(ValLine) + ',';                                                   //CPK030
          ColLine = %TRIMR(ColLine) + ',';                                                  //CPK030
          ValLine = %TRIMR(ValLine) + ',';                                                  //CPK030
       ELSE;
          ColLine = '(';
          ValLine = '(';
       ENDIF;

       //*ColLine**=*%TRIM(ColLine) + I_AFFDNM;                                             //CPK030
          ColLine  = %TRIMR(ColLine) + I_AFFDNM;                                            //CPK030
       //*IF**I_AFFDTP*<>*'S'*and*I_AFFDTP*<>*'P';******************************          //AR859322
          IF  I_AFFDTP <> 'S' and I_AFFDTP <> 'P' and I_AFFDTP <> 'B';                    //AR859322
             U_AFFDPS = I_AFFDPS;
             U_AFFDLN = I_AFFDLN;
             EXSR ReplaceQuote;
       //****ValLine = %TRIM(ValLine) + '''' +                                              //CPK030
             ValLine = %TRIMR(ValLine) + '''' +                                             //CPK030
                     %TRIMR(OutString) + '''';
          ELSE;
             FmtInp30A = %SUBST(ATDATA:I_AFFDPS:I_AFFDLN);
             FieldLen = I_AFFDLN;
             IF I_AFFDTP = 'P';
                EXSR      ConvPack;
             ENDIF;                                                                       //AR859322
       //****ELSE;**************************************************************          //AR859322
             IF I_AFFDTP = 'S';                                                           //AR859322
                EXSR      ConvSign;
             ENDIF;
             IF I_AFFDTP = 'B';                                                           //AR859322
                EXSR      ConvBin;                                                        //AR859322
             ENDIF;                                                                       //AR859322
       //****ValLine = %TRIM(ValLine) + IOField;                                            //CPK030
             ValLine = %TRIMR(ValLine) + IOField;                                           //CPK030
          ENDIF;

      /end-free
      *
     C     BuildColE     ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit numeric field                                    *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
      *
     C                   MOVEA     ' '           ZA1
     C                   MOVEA     ' '           ZA2
     C                   Z-ADD     16            Z1
     C                   Z-ADD     16            Z2
      *
     C     16            SUB       ZADEC         ZADEC2
     C                   MOVEA     ZFIELD        ZA1
      *
      * Check to see if there are any decimal places.
     C     ZADEC         COMP      0                                      91
     C   91              GOTO      ZT20
      *
     C     ZT10          TAG
      *
      * Set up decimals.
     C                   MOVE      ZA1(Z1)       ZA2(Z2)
     C     Z1            SUB       1             Z1
     C     Z2            SUB       1             Z2
     C*
     C     Z2            COMP      0                                      90
     C   90              GOTO      ZT30
      *
      * Check if it is the end of the decimals.
     C     Z2            COMP      ZADEC2                             90
     C   90              GOTO      ZT10
      *
      * Put in decimal place.
     C                   MOVE      '.'           ZA2(Z2)
     C     Z2            SUB       1             Z2
     C     ZT20          TAG
      *
      * Set up integers.
     C                   MOVE      ZA1(Z1)       ZA2(Z2)
     C     Z1            SUB       1             Z1
     C     Z2            SUB       1             Z2
      *
     C     Z2            COMP      0                                  90
     C   90              GOTO      ZT20
      *
      * Put in leading blanks.
     C     ZT30          TAG
      *
     C                   Z-ADD     1             Z2
      *
     C     ZT40          TAG
      *
     C     ZA2(Z2)       COMP      '0'                                9090
     C   90ZA2(Z2)       COMP      ' '                                9090
      *
     C   90              GOTO      ZT50
      *
     C                   MOVE      ' '           ZA2(Z2)
     C     Z2            ADD       1             Z2
      *
     C     Z2            COMP      16                                   90
     C   90              GOTO      ZT40
      *
      * If no integers put in leading zero.
     C     ZT50          TAG
      *
     C                   Z-ADD     ZADEC2        Z2
     C  N91Z2            SUB       1             Z2
     C     ZA2(Z2)       COMP      ' '                                    90
     C   90              MOVE      '0'           ZA2(Z2)
      *
      * Set up output field.
     C     ZT60          TAG
      *
     C                   MOVEA     ZA2           ZFIELD
      *
     C     ZEDITE        ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     FFDKey        KLIST
     C                   KFLD                    WFile
     C                   KFLD                    WKey

     C     IFFDKey       KLIST
     C                   KFLD                    WFile
     C                   KFLD                    Pos
      *
     C     INZSRE        ENDSR
      /EJECT
      ********************************************************************
     C     *PSSR         BEGSR
      *
     C     Recursive     IFEQ      *blanks
     C                   MOVE      'Y'           Recursive
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
      *
     C     PSSRE         ENDSR
      *********************************************************************

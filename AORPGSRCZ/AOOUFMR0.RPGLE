     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AO Outgoing Message Field Management')           *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  AOOUFMR0 - Midas AO Outgoing Message Field Management        *
      *                                                               *
      *  Function:  This program will retrieve details in MEOUFMPD    *
      *              and return it to calling program.                *
      *                                                               *
      *  This program will access MEOUMPD with complete key           *                       250600
      *  if no record is found, with partial keys meaning that keys   *                       250600
      *  are set to blanks (and not ignored) to check if a record     *                       250600
      *  with partial keys exist in the file                          *                       250600
      *  For branch and country, the current value will be replaced   *                       250600
      *  by keywork *FTF or *NFT has been output in the field         *                       250600
      *  To call the record with ACOUNTIBAN  or ACOUNTLINE use option *                       250600
      *  *KEY or *VERIFY                                              *                       250600
      *  To call the record with *FORMAT (the first call) use option  *                       250600
      *  *KEY or *VERIFY, for subsequent, use *NEXTEQ                 *                       250600
      *                                                               *                       250600
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CSW213             Date 03Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG15045           Date 19Oct07               *
      *                 250804A            Date 10Oct07               *
      *                 250600             Date 04Oct07               *
      *                 BUG14874           Date 18Sep07               *
      *                 BUG14771           Date 12Aug07               *
      *                 BUG14593           Date 12Aug07               *
      *                 CSW207A            Date 04Jul07               *
      *                 CSW207             Date 04Jul07               *
      *                 BUG14042           Date 25Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032  *CREATE    Date 11Sep06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW213 - SWIFT Changes 2013 (Recompile)                      *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  BUG15045 - System does not accept an External account input  *
      *             in Ordering customer field                        *
      *  250804A - Enhance fix CFT032/CSW207                          *
      *  250600 - Fix errors related to CFT032/CSW207                 *
      *  BUG14874 - Error encountered in Ordering Customer field      *
      *  BUG14771 - Amended the input function and the message        *
      *             generation for CFT032                             *
      *  BUG14593 - Swift 2007 error in SP08                           *
      *  CSW207A - Swift 2007 Standard Changes                        *
      *  CSW207 - Swift 2007 Standard Changes                         *
      *  BUG14042 - CFT032 Errors ; applied fix 13798                 *
      *  CFT032 - Account Line in Field 50X in MT103                  *
      *                                                               *
      *****************************************************************
 
      ** Midas ME Outgoing Message Field - Retrieval Index
 
     FMEOUFML1  IF   E           K DISK    INFSR(*PSSR) USROPN
 
      ** Midas ME Outgoing Message Field - Retrieval Index                                  BUG14042
                                                                                            BUG14042
     FMEOUFML2  IF   E           K DISK    INFSR(*PSSR) USROPN                              BUG14042
     F                                     RENAME(@OUFMPD:@OUFMPD2)                         BUG14042
                                                                                            BUG14042
      ** Midas ME Outgoing Message Field - Retrieval Index                                  BUG14042
                                                                                            BUG14042
     FMEOUFML3  IF   E           K DISK    INFSR(*PSSR) USROPN                              BUG14042
     F                                     RENAME(@OUFMPD:@OUFMPD3)                         BUG14042
                                                                                            BUG14042
      ** Midas ME Outgoing Message Field - Retrieval Index                                  BUG14042
                                                                                            BUG14042
     FMEOUFML4  IF   E           K DISK    INFSR(*PSSR) USROPN                              BUG14042
     F                                     RENAME(@OUFMPD:@OUFMPD4)                         BUG14042
                                                                                            BUG14042
      ** Midas ME Outgoing Message Field - Retrieval Index                                  BUG14042
                                                                                            BUG14042
     FMEOUFML5  IF   E           K DISK    INFSR(*PSSR) USROPN                              BUG14042
     F                                     RENAME(@OUFMPD:@OUFMPD5)                         BUG14042
                                                                                            BUG14042
      ** Midas ME Outgoing Message Field - Retrieval Index                                  BUG14042
                                                                                            BUG14042
     FMEOUFML6  IF   E           K DISK    INFSR(*PSSR) USROPN                              BUG14042
     F                                     RENAME(@OUFMPD:@OUFMPD6)                         BUG14042
                                                                                            BUG14042
      ** Midas ME SWIFT ISO country codes retrieval
 
     FMEISOCL1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRPROCESS - Detail Processing                                *
      *                                                               *
      *****************************************************************
     D/EJECT
 
      ** Array containing Copyright statement
 
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      * Program Status data structure
 
     D  PSDS          SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
      ** Local data area for database error details
 
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Midas SD Location codes
 
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
 
      ** Midas SD Country codes
 
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** Midas SD Branch codes
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
     D SDCUST        E DS                  Extname(SDCUSTPD)                                 250804A
     D  QQDFA1       E                     ExtFld(QQDFAC)                                    250804A
      * Customer details of the branch                                                       250804A
      **  Midas ME Outgoing Message Field Management
 
     D D@FMT         E DS                  EXTNAME(MEOUFMPD)
     D S_@FMT        E DS                  EXTNAME(MEOUFMPD)                                  250600
     D                                     Prefix(S_)                                         250600
 
      **  Short data structures for Access Objects
 
     D P@FMT         E DS                  EXTNAME(DSFDY)
 
      **  Short data structures for Access Objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)                                    250804A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D P@RTCD          S              7A
     D P@OPTN          S              7A
     D P@NTWRK         S              6A
     D P@MTYP          S              3A
     D P@MTAG          S              5A
     D*P@SBRCH**       S              3A                                                      250600
     D P@SBRC4A        S              4A                                                    BUG14042
     D*P@CTRY***       S              2A                                                      250600
     D P@CTRY4A        S              4A                                                    BUG14042
     D P@SBRCH         S              4A                                                      250600
     D P@CTRY          S              4A                                                      250600
     D P@CURR          S              3A
     D P@NSTRO         S              2A
     D P@ACTI          S             10A
     D P@CNLOC         S              3A
     D P@CNCD          S              2A
 
     D P@BRCA          S              3A                                                      250600
     D @DFATF          S              4A
     D @SFATF          S              4A
 
     D @SBRCH          S              4A                                                      250600
     D @CTRY           S              4A                                                      250600
     D @CURR           S              3A                                                      250600
     D @NSTRO          S              2A                                                      250600
      *                                                                                       250600
     D Step1           S              2S 0                                                    250600
     D Step2           S              2S 0                                                    250600
     D Step3           S              2S 0                                                    250600
     D SavBranch       S              4A                                                    BUG14042
     D SavCountry      S              4A                                                    BUG14042
     D SavCurr         S              4A                                                     CSW207A
     D SavNost         S              2A                                                     CSW207A
                                                                                            BUG14042
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      **  Perform Detail Processing.
 
     C                   EXSR      SRPROCESS
 
     C                   RETURN
 
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROCESS -- Subroutine to do the Detail Processing.         *
      *                                                               *
      *****************************************************************
 
     C     SRPROCESS     BEGSR
 
     C                   EVAL      P@RTCD  =  *BLANKS
     C**********         Eval      P@SBRCH = P@SBRC4A                              BUG14042 BUG15045
     C**********         Eval      P@CTRY  = P@CTRY4A                              BUG14042 BUG15045
     C**********         Eval      OMFLAG = ' '                                    BUG14042 BUG15045
 
      ** Access Option *SAME input
 
     C                   IF        P@OPTN = '*SAME '
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN91 = *ON
     C                   ENDIF
     C                   GOTO      T@SKIP
     C                   ENDIF
 
      ** Set off indicators
 
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN96 = *OFF
 
      ** First call - open file
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN01 = *ON
     C                   OPEN      MEOUFML1                             91
     C                   OPEN      MEOUFML2                             91                  BUG14042
     C                   OPEN      MEOUFML3                             91                  BUG14042
     C                   OPEN      MEOUFML4                             91                  BUG14042
     C                   OPEN      MEOUFML5                             91                  BUG14042
     C                   OPEN      MEOUFML6                             91                  BUG14042
     C                   IF        *IN91 = *ON
     C                   EVAL      *INLR = *ON
     C                   GOTO      T@SKIP
     C                   ENDIF
     C                   ENDIF
 
      ** Last call - close file and terminate program
 
     C                   IF        P@OPTN = '*FREE  '
     C                   CLOSE     MEOUFML1                             92
     C                   CLOSE     MEOUFML2                             92                  BUG14042
     C                   CLOSE     MEOUFML3                             92                  BUG14042
     C                   CLOSE     MEOUFML4                             92                  BUG14042
     C                   CLOSE     MEOUFML5                             92                  BUG14042
     C                   CLOSE     MEOUFML6                             92                  BUG14042
     C                   IF        *IN92 = *ON
     C                   EVAL      *INLR = *ON
     C                   GOTO      T@SKIP
     C                   ENDIF
     C                   ENDIF
 
      ** Caller requests first record
 
     C                   IF        P@OPTN = '*FIRST '
     C     *LOVAL        SETLL     MEOUFML1                           9390
     C                   IF        *IN93 = *ON
     C                   GOTO      T@SKIP
     C                   ENDIF
     C                   IF        *IN90 = *ON
     C                   EVAL      *INLR = *ON
     C                   GOTO      T@SKIP
     C                   ENDIF
     C                   EVAL      P@OPTN = '*NEXT  '
     C                   ENDIF
 
      ** Caller requests next record
 
     C**********         IF        P@OPTN = '*NEXT  '                                         250600
     C**********         READ      MEOUFML1                             9094                  CSW207
     C**********         IF        *IN94 = *ON                                                CSW207
     C**********         GOTO      T@SKIP                                                     CSW207
     C**********         ENDIF                                                                CSW207
     C**********         IF        *IN90 = *ON                                                CSW207
     C**********         EVAL      *INLR = *ON                                                CSW207
     C**********         GOTO      T@SKIP                                                     CSW207
     C**********         ENDIF                                                                CSW207
                                                                                              CSW207
      ** Save Sender Branch/Country                                                           CSW207
                                                                                              CSW207
     C                   EVAL      SavBranch = P@SBRC4A                                       CSW207
     C                   EVAL      SavCountry = P@CTRY4A                                      CSW207
                                                                                              CSW207
      ** Check MEOUFML1 file for the combination of keys                                      CSW207
                                                                                              CSW207
     C**********         SELECT                                                      CSW207 BUG14874
                                                                                              CSW207
      ***1.*Network,*Message*Type,*Message*Tag,*Branch,                                CSW207 250600
      ******Country,*Currency,Nostro,*Action                                           CSW207 250600
                                                                                              CSW207
     C**********         WHEN      P@SBRC4A <> *Blanks   AND                         CSW207 BUG14874
     C**********                   P@CTRY4A <> *Blanks   AND                         CSW207 BUG14874
     C**********                   P@CURR   <> *Blanks   AND                         CSW207 BUG14874
     C**********                   P@NSTRO  <> *Blanks   OR                          CSW207 BUG14874
     C**********                   P@SBRC4A =  *Blanks   AND                         CSW207 BUG14874
     C**********                   P@CTRY4A <> *Blanks   AND                         CSW207 BUG14874
     C**********                   P@CURR   <> *Blanks   AND                         CSW207 BUG14874
     C**********                   P@NSTRO  =  *Blanks                               CSW207 BUG14874
                                                                                              CSW207
     C*****K@MEOUFM      READE     MEOUFML1                             9094           CSW207 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *OFF                                      BUG14874 250600
     C**********         GOTO      T@SKIP                                            BUG14874 250600
     C**********         ENDIF                                                       BUG14874 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *ON                                         CSW207 250600
                                                                                              CSW207
      ***Not*found,*use*@SFATF*for*sender's*branch                                     CSW207 250600
                                                                                              CSW207
     C**********         EVAL      P@SBRC4a = @SFATF                                   CSW207 250600
                                                                                              CSW207
     C*****K@MEOUFM      READE     MEOUFML1                             9094           CSW207 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *OFF                                      BUG14874 250600
     C**********         GOTO      T@SKIP                                            BUG14874 250600
     C**********         ENDIF                                                       BUG14874 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *ON                                         CSW207 250600
                                                                                              CSW207
      ***Still*not*found,*restore*sender's*branch,*and*use*@DFATF*for                  CSW207 250600
      ***Country*of*location                                                           CSW207 250600
                                                                                              CSW207
     C**********         EVAL      P@SBRC4A = SavBranch                                CSW207 250600
     C**********         EVAL      P@CTRY4A = @DFATF                                   CSW207 250600
     C*****K@MEOUFM      READE     MEOUFML1                             9094           CSW207 250600
                                                                                            BUG14874
     C**********         IF        *IN94 = *ON                                       BUG14874 250600
     C**********         EVAL      P@CTRY4A = @DFATF                                 BUG14874 250600
     C**********         EVAL      P@SBRC4A = @SFATF                                 BUG14874 250600
     C*****K@MEOUFM      READE     MEOUFML1                             9094         BUG14874 250600
                                                                                            BUG14874
     C**********         IF        *IN94 = *ON                                       CSW207 BUG14874
     C**********         IF        *IN94 = *OFF                                      BUG14874 250600
     C**********         GOTO      T@SKIP                                              CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
     C**********         ENDIF                                                       BUG14874 250600
     C**********         ENDIF                                                         CSW207 250600
     C**********         IF        *IN90 = *ON                                         CSW207 250600
     C**********         EVAL      *INLR = *ON                                         CSW207 250600
     C**********         GOTO      T@SKIP                                              CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
                                                                                              CSW207
      ***2.*Network,*Message*Type,*Message*Tag,*Branch,                                CSW207 250600
      ******Country,*Currency,*Action                                                  CSW207 250600
                                                                                              CSW207
     C**********         WHEN      P@SBRC4A <> *Blanks   AND                         CSW207 BUG14874
     C**********                   P@CTRY4A <> *Blanks   AND                         CSW207 BUG14874
     C**********                   P@CURR   <> *Blanks   AND                         CSW207 BUG14874
     C**********                   P@NSTRO  = *Blanks                                CSW207 BUG14874
                                                                                              CSW207
     C**********         EVAL      P@SBRC4A = SavBranch                              BUG14874 250600
     C**********         EVAL      P@CTRY4A  = SavCountry                            BUG14874 250600
                                                                                            BUG14874
     C*****K@MEOUFM2     READE     MEOUFML2                             9094           CSW207 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *OFF                                      BUG14874 250600
     C**********         GOTO      T@SKIP                                            BUG14874 250600
     C**********         ENDIF                                                       BUG14874 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *ON                                         CSW207 250600
                                                                                              CSW207
      ***Not*found,*use*@SFATF*for*sender's*branch                                     CSW207 250600
                                                                                              CSW207
     C**********         EVAL      P@SBRC4a = @SFATF                                   CSW207 250600
                                                                                              CSW207
     C*****K@MEOUFM2     READE     MEOUFML2                             9094           CSW207 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *OFF                                      BUG14874 250600
     C**********         GOTO      T@SKIP                                            BUG14874 250600
     C**********         ENDIF                                                       BUG14874 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *ON                                         CSW207 250600
                                                                                              CSW207
      ***Still*not*found,*restore*sender's*branch,*and*use*@DFATF*for                  CSW207 250600
      ***Country*of*location                                                           CSW207 250600
                                                                                              CSW207
     C**********         EVAL      P@SBRC4A = SavBranch                                CSW207 250600
     C**********         EVAL      P@CTRY4A = @DFATF                                   CSW207 250600
     C*****K@MEOUFM2     READE     MEOUFML2                             9094           CSW207 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *ON                                       BUG14874 250600
     C**********         EVAL      P@SBRC4A = @SFATF                                 BUG14874 250600
     C**********         EVAL      P@CTRY4A = @DFATF                                 BUG14874 250600
     C*****K@MEOUFM2     READE     MEOUFML2                             9094         BUG14874 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *ON                                       CSW207 BUG14874
     C**********         IF        *IN94 = *OFF                                      BUG14874 250600
     C**********         GOTO      T@SKIP                                              CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
     C**********         IF        *IN90 = *ON                                         CSW207 250600
     C**********         EVAL      *INLR = *ON                                         CSW207 250600
     C**********         GOTO      T@SKIP                                              CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
                                                                                              CSW207
      ***3.*Network,*Message*Type,*Message*Tag,*Branch,                                CSW207 250600
      ******Currency,*Nostro,*Action                                                   CSW207 250600
                                                                                              CSW207
     C**********         WHEN      P@SBRC4A <> *Blanks   AND                         CSW207 BUG14874
     C**********                   P@CTRY4A = *Blanks    AND                         CSW207 BUG14874
     C**********                   P@CURR   <> *Blanks   AND                         CSW207 BUG14874
     C**********                   P@NSTRO  <> *Blanks                               CSW207 BUG14874
                                                                                              CSW207
     C*****K@MEOUFM3     READE     MEOUFML3                             9094           CSW207 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *OFF                                      BUG14874 250600
     C**********         GOTO      T@SKIP                                            BUG14874 250600
     C**********         ENDIF                                                       BUG14874 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *ON                                         CSW207 250600
                                                                                              CSW207
      ***Not*found,*use*@SFATF*for*sender's*branch                                     CSW207 250600
                                                                                              CSW207
     C**********         EVAL      P@SBRC4a = @SFATF                                   CSW207 250600
                                                                                              CSW207
     C*****K@MEOUFM3     READE     MEOUFML3                             9094           CSW207 250600
     C**********         IF        *IN94 = *ON                                       CSW207 BUG14874
     C**********         IF        *IN94 = *OFF                                      BUG14874 250600
     C**********         GOTO      T@SKIP                                              CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
     C**********         IF        *IN90 = *ON                                         CSW207 250600
     C**********         EVAL      *INLR = *ON                                         CSW207 250600
     C**********         GOTO      T@SKIP                                              CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
                                                                                              CSW207
      ***4.*Network,*Message*Type,*Message*Tag,*Branch,                                CSW207 250600
      ******Currency,*Action                                                           CSW207 250600
                                                                                              CSW207
     C**********         WHEN      P@SBRC4A <> *Blanks   AND                         CSW207 BUG14874
     C**********                   P@CTRY4A = *Blanks    AND                         CSW207 BUG14874
     C**********                   P@CURR   <> *Blanks   AND                         CSW207 BUG14874
     C**********                   P@NSTRO  = *Blanks                                CSW207 BUG14874
                                                                                              CSW207
     C**********         EVAL      P@SBRC4A = SavBranch                              BUG14874 250600
                                                                                            BUG14874
     C*****K@MEOUFM4     READE     MEOUFML4                             9094           CSW207 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *OFF                                      BUG14874 250600
     C**********         GOTO      T@SKIP                                            BUG14874 250600
     C**********         ENDIF                                                       BUG14874 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *ON                                         CSW207 250600
                                                                                              CSW207
      ***Not*found,*use*@SFATF*for*sender's*branch                                     CSW207 250600
                                                                                              CSW207
     C**********         EVAL      P@SBRC4a = @SFATF                                   CSW207 250600
                                                                                              CSW207
     C*****K@MEOUFM4     READE     MEOUFML4                             9094           CSW207 250600
     C**********         IF        *IN94 = *ON                                       CSW207 BUG14874
     C**********         IF        *IN94 = *OFF                                      BUG14874 250600
     C**********         GOTO      T@SKIP                                              CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
     C**********         IF        *IN90 = *ON                                         CSW207 250600
     C**********         EVAL      *INLR = *ON                                         CSW207 250600
     C**********         GOTO      T@SKIP                                              CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
                                                                                              CSW207
      ***5.*Network,*Message*Type,*Message*Tag,*Branch,*Action                         CSW207 250600
                                                                                              CSW207
     C**********         WHEN      P@SBRC4A <> *Blanks   AND                         CSW207 BUG14874
     C**********                   P@CTRY4A = *Blanks    AND                         CSW207 BUG14874
     C**********                   P@CURR   =  *Blanks   AND                         CSW207 BUG14874
     C**********                   P@NSTRO  = *Blanks                                CSW207 BUG14874
     C**********                   OR  P@SBRC4A <> *Blanks                          CSW207A BUG14874
     C**********                   AND P@CTRY4A <> *Blanks                          CSW207A BUG14874
     C**********                   AND P@CURR   =  *Blanks                          CSW207A BUG14874
     C**********                   AND P@NSTRO  = *Blanks                           CSW207A BUG14874
                                                                                              CSW207
     C**********         EVAL      P@SBRC4A = SavBranch                              BUG14874 250600
                                                                                            BUG14874
     C*****K@MEOUFM5     READE     MEOUFML5                             9094           CSW207 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *OFF                                      BUG14874 250600
     C**********         GOTO      T@SKIP                                            BUG14874 250600
     C**********         ENDIF                                                       BUG14874 250600
      *                                                                                     BUG14874
     C**********         IF        *IN94 = *ON                                         CSW207 250600
                                                                                              CSW207
      ***Not*found,*use*@SFATF*for*sender's*branch                                     CSW207 250600
                                                                                              CSW207
     C**********         EVAL      P@SBRC4a = @SFATF                                   CSW207 250600
                                                                                              CSW207
     C*****K@MEOUFM5     READE     MEOUFML5                             9094           CSW207 250600
     C**********         IF        *IN94 = *ON                                       CSW207 BUG14874
     C**********         IF        *IN94 = *OFF                                      BUG14874 250600
     C**********         GOTO      T@SKIP                                              CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
     C**********         IF        *IN90 = *ON                                         CSW207 250600
     C**********         EVAL      *INLR = *ON                                         CSW207 250600
     C**********         GOTO      T@SKIP                                              CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
                                                                                              CSW207
      ***6.*Network,*Message*Type,*Message*Tag,*Action                                 CSW207 250600
                                                                                              CSW207
     C**********         OTHER                                                      CSW207A BUG14874
     C**********         WHEN      P@SBRC4A = *Blanks    AND                                 CSW207A
     C**********                   P@CTRY4A = *Blanks    AND                                 CSW207A
     C**********                   P@CURR   =  *Blanks   AND                                 CSW207A
     C**********                   P@NSTRO  = *Blanks                                        CSW207A
                                                                                              CSW207
     C**********         EVAL      P@SBRC4A = SavBranch                              BUG14874 250600
                                                                                            BUG14874
     C*****K@MEOUFM6     READE     MEOUFML6                             9094           CSW207 250600
     C**********         IF        *IN94 = *ON                                       CSW207 BUG14874
     C**********         IF        *IN94 = *OFF                                      BUG14874 250600
     C**********         GOTO      T@SKIP                                              CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
     C**********         IF        *IN90 = *ON                                         CSW207 250600
     C**********         EVAL      *INLR = *ON                                         CSW207 250600
     C**********         GOTO      T@SKIP                                              CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
                                                                                              CSW207
     C**********         ENDSL                                                       CSW207 BUG14874
      *                                                                                       CSW207
      ***Restore*saved*sender*branch/country                                           CSW207 250600
      *                                                                                       CSW207
     C**********         EVAL      P@SBRC4A = SavBranch                                CSW207 250600
     C**********         EVAL      P@CTRY4A = SavCountry                               CSW207 250600
                                                                                              CSW207
     C**********         ENDIF                                                                250600
                                                                                            BUG14874
     C**********         ENDIF                                                       BUG14874 250600
 
      ** Caller requests next record with same key as previous call                           250600
      ** Note this is not based on the input parameter but based on keys saved during previous250600
      ** call.                                                                                250600
     C                   IF        P@OPTN = '*NEXTEQ'                                         250600
      *                                                                                       250600
     C                   Eval      P@NTWRK =  S_OMNWRK                                        250600
     C                   Eval      P@MTYP  =  S_OMMTPY                                        250600
     C                   Eval      P@MTAG  =  S_OMMTAG                                        250600
     C                   Eval      P@SBRCH =  S_OMSBRC                                        250600
     C                   Eval      P@CTRY  =  S_OMCTRY                                        250600
     C                   Eval      P@CURR  =  S_OMCURR                                        250600
     C                   Eval      P@NSTRO =  S_OMNOST                                        250600
     C                   Eval      P@ACTI  =  S_OMACTI                                        250600
      *                                                                                       250600
     C     K@MEOUFM      READE     MEOUFML1                             9094                  250600
     C                   IF        *IN94 = *ON                                                250600
     C                                                                                        250600
     C                   GOTO      T@SKIP                                                     250600
     C                   ENDIF                                                                250600
     C                   IF        *IN90 = *ON                                                250600
     C                   EVAL      *INLR = *ON                                                250600
     C                   GOTO      T@SKIP                                                     250600
     C                   ENDIF                                                                250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
      ** Caller requests last record
 
     C                   IF        P@OPTN = '*LAST  '
     C     *HIVAL        SETGT     MEOUFML1                             90
     C                   IF        *IN90 = *ON
     C                   EVAL      *INLR = *ON
     C                   GOTO      T@SKIP
     C                   ENDIF
     C                   EVAL      P@OPTN = '*PREV  '
     C                   ENDIF
 
      ** Caller requests previous record
 
     C                   IF        P@OPTN = '*PREV  '
     C                   READP     MEOUFML1                             9094
     C                   IF        *IN94 = *ON
     C                   GOTO      T@SKIP
     C                   ENDIF
     C                   IF        *IN90 = *ON
     C                   EVAL      *INLR = *ON
     C                   GOTO      T@SKIP
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      @SFATF   =  *blanks
     C                   EVAL      @DFATF   =  *blanks
 
      ** Caller requests record indicated by key
      ** Set FATF Flag
 
     C                   IF        P@OPTN   = '*KEY   '
     C                             OR P@OPTN= '*VERIFY'
 
     C                   Eval      @SBRCH = P@SBRCH                                           250600
     C                   Eval      @CTRY = P@CTRY                                             250600
     C                   Eval      @CURR = P@CURR                                             250600
     C                   Eval      @NSTRO = P@NSTRO                                           250600
      ** FATF FLAG for SENDER
      ** Access Branch
 
     C     P@SBRCH       IFNE      *BLANK
     C                   EVAL      P@BRCA = P@SBRCH                                           250600
     C
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C**********         PARM                    P@SBRCH                                      250600
     C                   PARM                    P@BRCA                                       250600
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C     P@RTCD        IFNE      *BLANKS
     C                   MOVEL     P@SBRCH       DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     01            DBASE
     c                   EVAL      @SFATF = '*FTF'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Location Code details of Branch.
 
     C                   If        A8LCCD <> *Blanks                                         250804A
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      A8LCCD        P@CNLOC
     C     SDLOCN        PARM      SDLOCN        DSSDY
      *
     C     P@RTCD        IFNE      *BLANKS
     C                   Z-ADD     02            DBASE
     C                   MOVEL     A8LCCD        DBKEY
     C                   MOVEL     'SDLOCNPD'    DBFILE
     C                   EVAL      @SFATF = '*FTF'
     C                   EXSR      *PSSR
     C                   Else                                                                250804A
     C                   Eval      P@CNCD = DVCNCD                                           250804A
     C                   ENDIF
      *                                                                                      250804A
     C                   Else                                                                250804A
      *                                                                                      250804A
     C                   Movel(P)  A8BICN        @KEY1                                       250804A
      *                                                                                      250804A
     C                   CALL      'AOCUSTR1'                                                250804A
     C                   PARM      '*BLANKS'     @RTCD             7                         250804A
     C                   PARM      '*KEY   '     P@OPTN                                      250804A
     C                   PARM                    @KEY1            10                         250804A
     C                   PARM      *BLANKS       @KYST             7                         250804A
     C     SDCUST        PARM      SDCUST        DSLDY                                       250804A
      *                                                                                      250804A
     C                   Eval      P@CNCD = BBCOLC                                           250804A
      *                                                                                      250804A
     C                   Endif                                                               250804A
      *
      ** Retrieve Country Code details.
      *
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C**********         PARM      DVCNCD        P@CNCD                                      205804A
     C                   PARM                    P@CNCD                                      250804A
     C     SDCTRY        PARM      SDCTRY        DSSDY
      *
     C     P@RTCD        IFNE      *BLANKS
     C                   Z-ADD     03            DBASE
     C                   MOVEL     DVCNCD        DBKEY
     C                   MOVEL     'SDCTRYPD'    DBFILE
     C                   EVAL      @SFATF = '*FTF'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Use A4ISOC from Country Code details to chain
      ** to MEISOCL1.
      *
     C     A4ISOC        CHAIN     MEISOCL1
     C                   IF        %FOUND(MEISOCL1)
     C                   IF        M3FATF = 'Y'
     C                   EVAL      @SFATF = '*FTF'
     C                   ELSE
     C**********         EVAL      @SFATF = '*NTF'                                          BUG14771
     C                   EVAL      @SFATF = '*NFT'                                          BUG14771
     C                   ENDIF
      *
     C                   ELSE
     C**********         EVAL      @SFATF = '*FTF'                                          BUG14771
     C                   EVAL      @SFATF = '*NFT'                                          BUG14771
     C                   ENDIF
      *
     C                   ENDIF
 
      ** FATF FLAG for DESTINATION
      ** Access Country Code
 
     C                   IF        P@CTRY<> *BLANKS
     C**********         If        DVCNCD = P@CTRY                                    250600 250804A
     C                   If        P@CNCD = P@CTRY                                           250804A
     C                   Eval      @DFATF = @SFATF                                            250600
     C                   Else                                                                 250600
 
      ** Retrieve Country Code details.
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    P@CTRY
     C     SDCTRY        PARM      SDCTRY        DSSDY
      *
     C     P@RTCD        IFNE      *BLANKS
     C                   Z-ADD     04            DBASE
     C                   MOVEL     P@CTRY        DBKEY
     C                   MOVEL     'SDCTRYPD'    DBFILE
     C                   EVAL      @DFATF = '*FTF'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Use A4ISOC from Country Code details to chain
      ** to MEISOCL1.
      *
     C     A4ISOC        CHAIN     MEISOCL1
     C                   IF        %FOUND(MEISOCL1)
     C                   IF        M3FATF = 'Y'
     C                   EVAL      @DFATF = '*FTF'
     C                   ELSE
     C**********         EVAL      @DFATF = '*NTF'                                            250600
     C                   EVAL      @DFATF = '*NFT'                                            250600
     C                   ENDIF
 
     C                   ELSE
      * If no definition found, that means that the country is NOT defined as FATF            250600
     C**********         EVAL      @DFATF = '*FTF'                                          BUG14771
     C                   EVAL      @DFATF = '*NFT'                                          BUG14771
     C                   ENDIF
      *
     C                   ENDIF                                                                250600
     C                   ENDIF
 
      ** Save Sender Branch/Country                                                         BUG14042
                                                                                            BUG14042
     C                   EVAL      SavBranch = P@SBRC4A                                     BUG14042
     C                   EVAL      SavCountry = P@CTRY4A                                    BUG14042
                                                                                            BUG14042
      ** Check MEOUFML1 file for the combination of keys
 
     C**********         SELECT                                                    BUG14042 BUG14771
                                                                                            BUG14042
      ***1.*Network,*Message*Type,*Message*Tag,*Branch,                              BUG14042 250600
      ******Country,*Currency,Nostro,*Action                                         BUG14042 250600
                                                                                            BUG14042
     C**********         WHEN      P@SBRC4A <> *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@CTRY4A <> *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@CURR   <> *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@NSTRO  <> *Blanks   OR                        BUG14042 BUG14771
     C**********                   P@SBRC4A =  *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@CTRY4A <> *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@CURR   <> *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@NSTRO  <> *Blanks                             BUG14042 BUG14771
      **********                                                                   BUG14042 BUG14771
     C                   Eval      Step1 = 0                                                  250600
     C                   Eval      Step2 = 0                                                  250600
     C                   Eval      Step3 = 0                                                  250600
      *                                                                                       250600
     C                   Seton                                        95                      250600
     C                   DOW       *IN95 = *ON                                                250600
      *                                                                                       250600
     C                   If        Step2 = 4                                                  250600
     C                   If        Step3 = 0                                                  250600
     C                   Eval      P@SBRCH = @SBRCH                                           250600
     C                   Else                                                                 250600
     C                   Eval      P@SBRCH = *Blanks                                          250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   Eval      Step2 = 0                                                  250600
     C                   Eval      Step1 = Step1 + 1                                          250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C     K@MEOUFM      SETLL     MEOUFML1                               95                 250804A
     C     *IN95         Ifeq      '1'                                                       250804A
     C     K@MEOUFM      READE     MEOUFML1                             9095                 250804A
     C                   Else                                                                250804A
     C                   SETON                                            95                 250804A
     C                   EndIf                                                               250804A
      *                                                                                      250804A
     C*****K@MEOUFM      CHAIN     MEOUFML1                           9590                   250804A
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *OFF                                      BUG14771 250600
     C**********         GOTO      T@SKIP                                            BUG14771 250600
     C**********         ENDIF                                                       BUG14771 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *ON                                                250600
                                                                                            BUG14042
      ***Not*found,*use*@SFATF*for*sender's*branch                                   BUG14042 250600
                                                                                            BUG14042
     C**********         EVAL      P@SBRC4a = @SFATF                                 BUG14042 250600
                                                                                            BUG14042
     C*****K@MEOUFM      CHAIN     MEOUFML1                           9590           BUG14042 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *OFF                                      BUG14771 250600
     C**********         GOTO      T@SKIP                                            BUG14771 250600
     C**********         ENDIF                                                       BUG14771 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *ON                                       BUG14042 250600
                                                                                            BUG14042
      ***Still*not*found,*restore*sender's*branch,*and*use*@DFATF*for                BUG14042 250600
      ***Country*of*location                                                         BUG14042 250600
                                                                                            BUG14042
     C**********         EVAL      P@SBRC4A = SavBranch                              BUG14042 250600
     C**********         EVAL      P@CTRY4A = @DFATF                                 BUG14042 250600
     C*****K@MEOUFM      CHAIN     MEOUFML1                           9590           BUG14042 250600
                                                                                            BUG14771
     C**********         IF        *IN95 = *ON                                       BUG14771 250600
     C**********         EVAL      P@CTRY4A = @DFATF                                 BUG14771 250600
     C**********         EVAL      P@SBRC4A = @SFATF                                 BUG14771 250600
     C*****K@MEOUFM      CHAIN     MEOUFML1                           9590           BUG14771 250600
                                                                                            BUG14771
     C**********         IF        *IN95 = *ON                                     BUG14042 BUG14771
     C                   IF        *IN95 = *OFF                                             BUG14771
     C                   GOTO      T@SKIP
     C                   ENDIF                                                              BUG14042
     C**********         ENDIF                                                       BUG14042 250600
     C**********         ENDIF                                                       BUG14771 250600
     C**********         ENDIF                                                                250600
     C                   IF        *IN90 = *ON
     C                   EVAL      *INLR = *ON
     C                   GOTO      T@SKIP
     C                   ENDIF
 
      ***2.*Network,*Message*Type,*Message*Tag,*Branch,                              BUG14042 250600
      ******Country,*Currency,*Action                                                BUG14042 250600
                                                                                            BUG14042
     C**********         WHEN      P@SBRC4A <> *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@CTRY4A <> *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@CURR   <> *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@NSTRO  = *Blanks                              BUG14042 BUG14771
                                                                                            BUG14771
     C**********         EVAL      P@SBRC4A = SavBranch                              BUG14771 250600
     C**********         EVAL      P@CTRY4A  = SavCountry                            BUG14771 250600
                                                                                            BUG14771
                                                                                            BUG14042
     C*****K@MEOUFM2     CHAIN     MEOUFML2                           9590           BUG14042 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *OFF                                      BUG14771 250600
     C**********         GOTO      T@SKIP                                            BUG14771 250600
     C**********         ENDIF                                                       BUG14771 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *ON                                       BUG14042 250600
                                                                                            BUG14042
      ***Not*found,*use*@SFATF*for*sender's*branch                                   BUG14042 250600
                                                                                            BUG14042
     C**********         EVAL      P@SBRC4a = @SFATF                                 BUG14042 250600
                                                                                            BUG14042
     C*****K@MEOUFM2     CHAIN     MEOUFML2                           9590           BUG14042 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *OFF                                      BUG14771 250600
     C**********         GOTO      T@SKIP                                            BUG14771 250600
     C**********         ENDIF                                                       BUG14771 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *ON                                       BUG14042 250600
                                                                                            BUG14042
      ***Still*not*found,*restore*sender's*branch,*and*use*@DFATF*for                BUG14042 250600
      ***Country*of*location                                                         BUG14042 250600
                                                                                            BUG14042
     C**********         EVAL      P@SBRC4A = SavBranch                              BUG14042 250600
     C**********         EVAL      P@CTRY4A = @DFATF                                 BUG14042 250600
     C*****K@MEOUFM2     CHAIN     MEOUFML2                           9590           BUG14042 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *ON                                       BUG14771 250600
     C**********         EVAL      P@SBRC4A = @SFATF                                 BUG14771 250600
     C**********         EVAL      P@CTRY4A = @DFATF                                 BUG14771 250600
     C*****K@MEOUFM2     CHAIN     MEOUFML2                           9590           BUG14771 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *ON                                      CSW207A BUG14593
     C**********         EVAL      SavCurr = P@CURR                                 CSW207A BUG14593
     C**********         EVAL      P@SBRC4A = *BLANKS                               CSW207A BUG14593
     C**********         EVAL      P@CTRY4A = *BLANKS                               CSW207A BUG14593
     C**********         EVAL      P@CURR = *BLANKS                                 CSW207A BUG14593
     C*****K@MEOUFM2     CHAIN     MEOUFML2                           9590          CSW207A BUG14593
     C**********         EVAL      P@SBRC4A = SavBranch                             CSW207A BUG14593
     C**********         EVAL      P@CTRY4A = SavCountry                            CSW207A BUG14593
     C**********         EVAL      P@CURR   = SavCurr                               CSW207A BUG14593
     C**********         ENDIF                                                      CSW207A BUG14593
     C**********         IF        *IN95 = *ON                                     BUG14042 BUG14771
     C**********         IF        *IN95 = *OFF                                      BUG14771 250600
     C**********         GOTO      T@SKIP                                            BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
     C**********         ENDIF                                                       BUG14771 250600
     C**********         IF        *IN90 = *ON                                       BUG14042 250600
     C**********         EVAL      *INLR = *ON                                       BUG14042 250600
     C**********         GOTO      T@SKIP                                            BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
                                                                                            BUG14042
     C**********         EVAL      P@SBRC4A = SavBranch                              BUG14771 250600
     C**********         EVAL      P@CTRY4A  = SavCountry                            BUG14771 250600
                                                                                            BUG14771
      ***3.*Network,*Message*Type,*Message*Tag,*Branch,                              BUG14042 250600
      ******Currency,*Nostro,*Action                                                 BUG14042 250600
                                                                                            BUG14042
     C**********         WHEN      P@SBRC4A <> *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@CTRY4A = *Blanks    AND                       BUG14042 BUG14771
     C**********                   P@CURR   <> *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@NSTRO  <> *Blanks                             BUG14042 BUG14771
                                                                                            BUG14042
     C*****K@MEOUFM3     CHAIN     MEOUFML3                           9590           BUG14042 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *OFF                                      BUG14771 250600
     C**********         GOTO      T@SKIP                                            BUG14771 250600
     C**********         ENDIF                                                       BUG14771 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *ON                                       BUG14042 250600
                                                                                            BUG14042
      ***Not*found,*use*@SFATF*for*sender's*branch                                   BUG14042 250600
                                                                                            BUG14042
     C**********         EVAL      P@SBRC4a = @SFATF                                 BUG14042 250600
                                                                                            BUG14042
     C*****K@MEOUFM3     CHAIN     MEOUFML3                           9590           BUG14042 250600
     C**********         IF        *IN95 = *ON                                     BUG14042 BUG14771
     C**********         IF        *IN95 = *OFF                                      BUG14771 250600
     C**********         GOTO      T@SKIP                                            BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
     C**********         IF        *IN90 = *ON                                       BUG14042 250600
     C**********         EVAL      *INLR = *ON                                       BUG14042 250600
     C**********         GOTO      T@SKIP                                            BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
                                                                                            BUG14042
      ***4.*Network,*Message*Type,*Message*Tag,*Branch,                              BUG14042 250600
      ******Currency,*Action                                                         BUG14042 250600
                                                                                            BUG14042
     C**********         WHEN      P@SBRC4A <> *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@CTRY4A = *Blanks    AND                       BUG14042 BUG14771
     C**********                   P@CURR   <> *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@NSTRO  = *Blanks                              BUG14042 BUG14771
                                                                                            BUG14042
     C**********         EVAL      P@SBRC4A = SavBranch                              BUG14771 250600
                                                                                            BUG14771
     C*****K@MEOUFM4     CHAIN     MEOUFML4                           9590           BUG14042 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *OFF                                      BUG14771 250600
     C**********         GOTO      T@SKIP                                            BUG14771 250600
     C**********         ENDIF                                                       BUG14771 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *ON                                       BUG14042 250600
                                                                                            BUG14042
      ***Not*found,*use*@SFATF*for*sender's*branch                                   BUG14042 250600
                                                                                            BUG14042
     C**********         EVAL      P@SBRC4a = @SFATF                                 BUG14042 250600
                                                                                            BUG14042
     C*****K@MEOUFM4     CHAIN     MEOUFML4                           9590           BUG14042 250600
     C**********         IF        *IN95 = *ON                                     BUG14042 BUG14771
     C**********         IF        *IN95 = *OFF                                      BUG14771 250600
     C**********         GOTO      T@SKIP                                            BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
     C**********         IF        *IN90 = *ON                                       BUG14042 250600
     C**********         EVAL      *INLR = *ON                                       BUG14042 250600
     C**********         GOTO      T@SKIP                                            BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
                                                                                            BUG14042
      ***5.*Network,*Message*Type,*Message*Tag,*Branch,*Action                       BUG14042 250600
                                                                                            BUG14042
     C**********         WHEN      P@SBRC4A <> *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@CTRY4A = *Blanks    AND                       BUG14042 BUG14771
     C**********                   P@CURR   =  *Blanks   AND                       BUG14042 BUG14771
     C**********                   P@NSTRO  = *Blanks                              BUG14042 BUG14771
     C**********                   OR  P@SBRC4A <> *Blanks                          CSW207A BUG14771
     C**********                   AND P@CTRY4A <> *Blanks                          CSW207A BUG14771
     C**********                   AND P@CURR   =  *Blanks                          CSW207A BUG14771
     C**********                   AND P@NSTRO  = *Blanks                           CSW207A BUG14771
                                                                                            BUG14042
     C**********         EVAL      P@SBRC4A = SavBranch                              BUG14771 250600
                                                                                            BUG14771
     C*****K@MEOUFM5     CHAIN     MEOUFML5                           9590           BUG14042 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *OFF                                      BUG14771 250600
     C**********         GOTO      T@SKIP                                            BUG14771 250600
     C**********         ENDIF                                                       BUG14771 250600
      *                                                                                     BUG14771
     C**********         IF        *IN95 = *ON                                       BUG14042 250600
                                                                                            BUG14042
      ***Not*found,*use*@SFATF*for*sender's*branch                                   BUG14042 250600
                                                                                            BUG14042
     C**********         EVAL      P@SBRC4a = @SFATF                                 BUG14042 250600
                                                                                            BUG14042
     C*****K@MEOUFM5     CHAIN     MEOUFML5                           9590           BUG14042 250600
     C**********         IF        *IN95 = *ON                                     BUG14042 BUG14771
     C**********         IF        *IN95 = *OFF                                      BUG14771 250600
     C**********         GOTO      T@SKIP                                            BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
     C**********         IF        *IN90 = *ON                                       BUG14042 250600
     C**********         EVAL      *INLR = *ON                                       BUG14042 250600
     C**********         GOTO      T@SKIP                                            BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
                                                                                            BUG14042
      ***6.*Network,*Message*Type,*Message*Tag,*Action                               BUG14042 250600
                                                                                            BUG14042
     C**********         OTHER                                                      CSW207A BUG14771
     C**********         WHEN      P@SBRC4A = *Blanks    AND                        BUG14042 CSW207A
     C**********                   P@CTRY4A = *Blanks    AND                        BUG14042 CSW207A
     C**********                   P@CURR   =  *Blanks   AND                        BUG14042 CSW207A
     C**********                   P@NSTRO  = *Blanks                               BUG14042 CSW207A
                                                                                            BUG14042
     C**********         EVAL      P@SBRC4A = SavBranch                              BUG14771 250600
                                                                                            BUG14771
     C*****K@MEOUFM6     CHAIN     MEOUFML6                           9590           BUG14042 250600
     C**********         IF        *IN95 = *ON                                     BUG14042 BUG14771
     C**********         IF        *IN95 = *OFF                                      BUG14771 250600
     C**********         GOTO      T@SKIP                                            BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
     C**********         IF        *IN90 = *ON                                       BUG14042 250600
     C**********         EVAL      *INLR = *ON                                       BUG14042 250600
     C**********         GOTO      T@SKIP                                            BUG14042 250600
     C**********         ENDIF                                                       BUG14042 250600
                                                                                            BUG14042
     C**********         ENDSL                                                     BUG14042 BUG14771
                                                                                            BUG14042
      ***restore*saved*sender*branch/country                                         BUG14042 250600
                                                                                            BUG14042
     C**********         EVAL      P@SBRC4A = SavBranch                              BUG14042 250600
     C**********         EVAL      P@CTRY4A = SavCountry                             BUG14042 250600
                                                                                            BUG14042
      *                                                                                       250600
     C                   If        Step3 = 1                                                  250600
     C                             and Step2 = 1                                              250600
     C                             and Step1 = 5                                              250600
     C                   GOTO      T@SKIP                                                     250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   Eval      Step2 = Step2 + 1                                          250600
      *                                                                                       250600
     C                   If        Step2 = 1                                                  250600
      *                                                                                       250600
     C                   If        P@CTRY <> *BLANKS                                          250600
     C                   Eval      P@CTRY = @DFATF                                            250600
      *                                                                                       250600
     C                   If        Step3 = 0                                                  250600
     C                   Eval      P@SBRCH = @SBRCH                                           250600
     C                   Else                                                                 250600
     C                   Eval      P@SBRCH = *Blanks                                          250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   Else                                                                 250600
     C                   Eval      Step2 = Step2 + 1                                          250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   If        Step2 = 2                                                  250600
     C                   Eval      P@CTRY = @CTRY                                             250600
     C                   Eval      P@SBRCH = @SFATF                                           250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   If        Step2 = 3                                                  250600
     C                   Eval      P@CTRY = @DFATF                                            250600
     C                   Eval      P@SBRCH = @SFATF                                           250600
     C                   Endif                                                                250600
      *                                                                                       250600
      * Nostro field is optional, do not test twice if passed as blanks                       250600
      *                                                                                       250600
     C                   If        @NSTRO = *Blanks                                           250600
     C                   If        Step1 = 1                                                  250600
     C                             or Step1 = 4                                               250600
     C                   Eval      Step1 = Step1 + 1                                          250600
     C                   Endif                                                                250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   If        Step2 = 4                                                  250600
     C                   Select                                                               250600
      *                                                                                       250600
     C                   When      Step1 = 0                                                  250600
     C                   Iter                                                                 250600
      *                                                                                       250600
     C                   When      Step1 = 1                                                  250600
     C                   Eval      P@CTRY  = @CTRY                                            250600
     C                   Eval      P@CURR  = @CURR                                            250600
     C                   Eval      P@NSTRO = *Blanks                                          250600
      *                                                                                       250600
     C                   When      Step1 = 2                                                  250600
     C                   Eval      P@CTRY  = @CTRY                                            250600
     C                   Eval      P@CURR  = *Blanks                                          250600
     C                   Eval      P@NSTRO = *Blanks                                          250600
      *                                                                                       250600
     C                   When      Step1 = 3                                                  250600
     C                   Eval      P@CTRY  = *Blanks                                          250600
     C                   Eval      P@CURR  = @CURR                                            250600
     C                   Eval      P@NSTRO = @NSTRO                                           250600
      *                                                                                       250600
     C                   When      Step1 = 4                                                  250600
     C                   Eval      P@CTRY  = *Blanks                                          250600
     C                   Eval      P@CURR  = @CURR                                            250600
     C                   Eval      P@NSTRO = *Blanks                                          250600
      *                                                                                       250600
     C                   When      Step1 = 5                                                  250600
     C                   Eval      P@CTRY  = *Blanks                                          250600
     C                   Eval      P@CURR  = *Blanks                                          250600
     C                   Eval      P@NSTRO = *Blanks                                          250600
      *                                                                                       250600
     C                   When      Step1 = 6                                                  250600
     C                             And Step3 = 0                                              250600
     C                   Eval      P@SBRCH = *Blanks                                          250600
     C                   Eval      P@CTRY  = @CTRY                                            250600
     C                   Eval      P@CURR  = @CURR                                            250600
     C                   Eval      P@NSTRO = @NSTRO                                           250600
     C                   Eval      Step3 = Step3 + 1                                          250600
     C                   Eval      Step1 = 0                                                  250600
      *                                                                                       250600
     C                   Other                                                                250600
     C                   GOTO      T@SKIP                                                     250600
      *                                                                                       250600
     C                   EndSl                                                                250600
      *                                                                                       250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   ENDDO                                                                250600
      *                                                                                       250600
     C                   ENDIF
 
     C                   IF        P@OPTN<> '*KEY   ' AND
     C                             P@OPTN<> '*VERIFY' AND
     C                             P@OPTN<> '*PREV  ' AND
     C                             P@OPTN<> '*VERIFY' AND
     C                             P@OPTN<> '*NEXTEQ' AND                                     250600
     C                             P@OPTN<> '*FREE  '
     C                   EVAL      *IN96 = *ON
     C                   END
 
      ** No record found or End of file - return error code
 
     C     T@SKIP        TAG
                                                                                             CSW207A
     C**********         IF        *IN95 = *ON                                        CSW207A 250600
     C**********                   OR *IN94 = *ON                                     CSW207A 250600
      ***Save*data                                                                    CSW207A 250600
     C**********         EVAL      SavBranch  = P@SBRC4A                             CSW207A CSW207A
     C**********         EVAL      SavCountry = P@CTRY4A                             CSW207A CSW207A
     C**********         EVAL      SavCurr    = P@CURR                                CSW207A 250600
     C**********         EVAL      SavNost    = P@NSTRO                               CSW207A 250600
     C**********         EVAL      P@SBRC4A =  *Blanks                                CSW207A 250600
     C**********         EVAL      P@CTRY4A =  *Blanks                                CSW207A 250600
     C**********         EVAL      P@CURR   =  *Blanks                                CSW207A 250600
     C**********         EVAL      P@NSTRO  =  *Blanks                                CSW207A 250600
     C***95K@MEOUFM6     CHAIN     MEOUFML6                           9590            CSW207A 250600
     C***94K@MEOUFM6     READE     MEOUFML6                             9094          CSW207A 250600
      ***Restore*data                                                                 CSW207A 250600
     C**********         EVAL      P@SBRC4A =  SavBranch                              CSW207A 250600
     C**********         EVAL      P@CTRY4A =  SavCountry                             CSW207A 250600
     C**********         EVAL      P@CURR   =  SavCurr                                CSW207A 250600
     C**********         EVAL      P@NSTRO  =  SavNost                                CSW207A 250600
     C**********         ENDIF                                                        CSW207A 250600
      * Restore key if no record found or in  case of single call (ACOUNTIBAN/ACOUNTLINE)     250600
     C                   If        *IN95 = *ON                                                250600
     C                             or P@ACTI = 'ACOUNTIBAN'                                   250600
     C                             or P@ACTI = 'ACOUNTLINE'                                   250600
     C                   Eval      P@SBRCH = @SBRCH                                           250600
     C                   Eval      P@CTRY  = @CTRY                                            250600
     C                   Eval      P@CURR  = @CURR                                            250600
     C                   Eval      P@NSTRO = @NSTRO                                           250600
     C                   Endif                                                                250600
 
     C                   CLEAR                   P@RTCD
 
     C                   SELECT
 
     C                   WHEN      *IN90 = *ON
     C                   EVAL      P@RTCD = '*ERROR '
 
     C                   WHEN      *IN91 = *ON
     C                   EVAL      P@RTCD = '*OPEN  '
 
     C                   WHEN      *IN92 = *ON
     C                   EVAL      P@RTCD = '*CLOSE '
 
     C                   WHEN      *IN93 = *ON
     C                   EVAL      P@RTCD = '*EMPTY '
 
     C                   WHEN      *IN94 = *ON
     C                   EVAL      P@RTCD = '*EOF   '
 
     C                   WHEN      *IN95 = *ON
     C                   EVAL      P@RTCD = '*NRF   '
     C**********         Eval      OMFLAG = 'O'                                      BUG14042 250600
 
     C                   WHEN      *IN96 = *ON
     C                   EVAL      P@RTCD = '*OPTION'
 
     C                   ENDSL
 
      ** Map Output Parameters
 
     C                   IF        P@OPTN<>  '*VERIFY' AND
     C                             P@OPTN<>  '*FREE  ' AND
     C                             P@OPTN<>  '*OPTION'
      *                                                                                       250600
     C                   If        P@RTCD = *BLANKS                                           250600
      *                                                                                       250600
     C                   EVAL      P@FMT  = D@FMT
      *                                                                                       250600
     C                   EVAL      S_@FMT  = D@FMT                                            250600
      *                                                                                       250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD
     C                   PARM                    P@OPTN
     C                   PARM                    P@NTWRK
     C                   PARM                    P@MTYP
     C                   PARM                    P@MTAG
     C**********         PARM                    P@SBRCH                                    BUG14042
     C**********         PARM                    P@CTRY                                     BUG14042
     C**********         PARM                    P@SBRC4A                            BUG14042 250600
     C**********         PARM                    P@CTRY4A                            BUG14042 250600
     C                   PARM                    P@SBRCH                                      250600
     C                   PARM                    P@CTRY                                       250600
     C                   PARM                    P@CURR
     C                   PARM                    P@NSTRO
     C                   PARM                    P@ACTI
     C                   PARM                    P@FMT
 
     C     K@MEOUFM      KLIST
     C                   KFLD                    P@NTWRK
     C                   KFLD                    P@MTYP
     C                   KFLD                    P@MTAG
     C**********         KFLD                    P@SBRCH                                    BUG14042
     C**********         KFLD                    P@CTRY                                     BUG14042
     C**********         KFLD                    P@SBRC4A                            BUG14042 250600
     C**********         KFLD                    P@CTRY4A                            BUG14042 250600
     C                   KFLD                    P@SBRCH                                      250600
     C                   KFLD                    P@CTRY                                       250600
     C                   KFLD                    P@CURR
     C                   KFLD                    P@NSTRO
     C                   KFLD                    P@ACTI
 
     C     K@MEOUFM2     KLIST                                                              BUG14042
     C                   KFLD                    P@NTWRK                                    BUG14042
     C                   KFLD                    P@MTYP                                     BUG14042
     C                   KFLD                    P@MTAG                                     BUG14042
     C                   KFLD                    P@SBRC4A                                   BUG14042
     C                   KFLD                    P@CTRY4A                                   BUG14042
     C                   KFLD                    P@CURR                                     BUG14042
     C                   KFLD                    P@ACTI                                     BUG14042
                                                                                            BUG14042
     C     K@MEOUFM3     KLIST                                                              BUG14042
     C                   KFLD                    P@NTWRK                                    BUG14042
     C                   KFLD                    P@MTYP                                     BUG14042
     C                   KFLD                    P@MTAG                                     BUG14042
     C                   KFLD                    P@SBRC4A                                   BUG14042
     C                   KFLD                    P@CURR                                     BUG14042
     C                   KFLD                    P@NSTRO                                    BUG14042
     C                   KFLD                    P@ACTI                                     BUG14042
                                                                                            BUG14042
     C     K@MEOUFM4     KLIST                                                              BUG14042
     C                   KFLD                    P@NTWRK                                    BUG14042
     C                   KFLD                    P@MTYP                                     BUG14042
     C                   KFLD                    P@MTAG                                     BUG14042
     C                   KFLD                    P@SBRC4A                                   BUG14042
     C                   KFLD                    P@CURR                                     BUG14042
     C                   KFLD                    P@ACTI                                     BUG14042
                                                                                            BUG14042
     C     K@MEOUFM5     KLIST                                                              BUG14042
     C                   KFLD                    P@NTWRK                                    BUG14042
     C                   KFLD                    P@MTYP                                     BUG14042
     C                   KFLD                    P@MTAG                                     BUG14042
     C                   KFLD                    P@SBRC4A                                   BUG14042
     C                   KFLD                    P@ACTI                                     BUG14042
                                                                                            BUG14042
     C     K@MEOUFM6     KLIST                                                              BUG14042
     C                   KFLD                    P@NTWRK                                    BUG14042
     C                   KFLD                    P@MTYP                                     BUG14042
     C                   KFLD                    P@MTAG                                     BUG14042
     C                   KFLD                    P@ACTI                                     BUG14042
                                                                                            BUG14042
      ** Set up Local Data Area (LDA)
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBPGM  = 'AOOUFMR0'
     C                   EVAL      DBMOD  = *BLANKS
     C                   EVAL      DBASE  = 0
     C                   EVAL      DBPROC = *BLANKS
     C                   OUT       LDA
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      P@RTCD = '*ERROR'
     C                   DUMP
 
     C                   RETURN
 
     C                   ENDSR
 
      /EJECT
** CPY@
(c) Misys International Banking Systems Ltd. 2006

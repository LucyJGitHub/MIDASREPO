     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO IBAN calculate IBAN for accounts')            *
      *****************************************************************
      *                                                               *
      *  Midas - Access Object                                        *
      *                                                               *
      *  AOIBANR6 - IBAN Calculate IBAN for Account                   *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR940312           Date 24Mar12               *
      *                 CRE075             Date 06Dec10               *
      *                 AR738915           Date 30Mar11               *
      *                 CFT044             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 242564             Date 30Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRE026             Date 24May06               *
      *                 242708             Date 17Oct06               *
      *                 239296             Date 25Apr06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 199186             Date 27Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004  *CREATE    Date 20Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR940312 - Serious Midas error occurred in AMAD (Recompile)  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  AR738915 - Portuguese IBAN incorrect format                  *
      *             (Child: AR738916)                                 *
      *  CFT044 - Portuguese IBAN                                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  242564 - Same fix as 242708.                                 *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  242708 - Apply fix 239296                                    *
      *  239296 - IBAN is not generated correctly because fields are  *
      *           in incorrect positions due to new 10-digit account  *
      *           code.                                               *
      *  239296 - IBAN is not generated correctly because fields are  *
      *           in incorrect positions due to new 10-digit account  *
      *           code.                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  199186 - Additional Method for Greece IBAN generation.       *
      *  CFT004 - International Bank Account Number                   *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      * GL Account Master Detail ( Key = IBAN Number)
     FACCNTL6   IF   E           K DISK    usropn
     F                                     RENAME(ACCNTABF:@ACCL6)
      * SD Country Codes
     FSDCTRYL2  IF   E           K DISK
      * SD Account Codes Extension                                                            CER001
     FSDACX3PD  IF   E           K DISK    USROPN                                             CER001
     F/COPY WNCPYSRC,AOIBAN6F03
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  70  - CHAIN Indicator (SDCTRYL2)                             *
      *  71  - READ  Indicator (ACCNTL6)                              *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D  WKBBAN         S              1    DIM(26)
      * Work BBAN field
      *                                                                                       CFT044
     D  CFT044         S              1                                                       CFT044
     D  PORIBN         S              1                                                       CFT044
      * CFT044 work variables                                                                 CFT044
      *
     D                 DS
     D WIBID                   1     10                                         O:BBAN Number
     D WIBID1                  1     10    DIM(10)                              O:BBAN Number
      * Bank/Branch Identifier
     D                 DS
     D  WKIBAN                 1     34
     D  WKIBAN1                1     34    DIM(34)
      * Work BBAN field
      *
     D                 DS
     D OIBAN1                  1     34                                         O:BBAN Number
     D OIBAN                   1     34    DIM(34)                              O:BBAN Number
      * Output IBAN
     D                 DS                                                                     199186
     D WKBRCD                  1      4                                                       199186
     D WKBRC1                  1      4    DIM(4)                                             199186
      * Bank/Branch Identifier                                                                199186
     D ACNT            DS           491                                                       239296
     D ACNUM                   2      7                                                       239296
     D ACCY                    8     10                                                       239296
     D AACOD                  11     20                                                       239296
     D AACSQ                  21     22                                                       239296
     D ABRCA                  29     31                                                       239296
     D AATYP                  32     32                                                       239296
     D AACNO                 196    205                                                       239296
     D AIBAN                 455    488                                                       239296
     D AIBSEQN               489    491                                                       239296
     D                 DS
      * Method 1
     D**W1IBAN**               1     18                                                       CGL029
     D  W1IBAN                 1     24                                                       CGL029
     D  W1BRCA                 1      3
     D  W1CNUM                 4      9
     D  W1CCY                 10     12
     D**W1ACOD**              13     16                                                       CGL029
     D**W1ACSQ**              17     18                                                       CGL029
     D  W1ACOD                13     22                                                       CGL029
     D  W1ACSQ                23     24                                                       CGL029
     D                 DS
      * Method 2
     D  W2IBAN                 1     13
     D  W2BID2                 1      2
     D  W2CNUM                 3      8
     D  W2CCY                  9     11
     D  W2SEQ2                12     13
     D                 DS
      * Method 3
     D  W3IBAN                 1     12
     D  W3BID1                 1      1
     D  W3CNUM                 2      7
     D  W3CCY                  8     10
     D  W3SEQ2                11     12
     D                 DS
      * Method 4
     D  W4IBAN                 1     10
     D  W4BID1                 1      1
     D  W4CNUM                 2      7
     D  W4SEQ3                 8     10
     D                 DS                                                                     199186
      * Method 5                                                                              199186
     D**W5IBAN**               1     15                                                199186 CGL029
     D  W5IBAN                 1     21                                                       CGL029
     D  W5CNUM                 1      6                                                       199186
     D  W5CCY                  7      9                                                       199186
     D**W5ACOD**              10     13                                                199186 CGL029
     D**W5ACSQ**              14     15                                                199186 CGL029
     D  W5ACOD                10     19                                                       CGL029
     D  W5ACSQ                20     21                                                       CGL029
      *
     D                 DS                                                                     CER001
     D  WL3IBAN                1     13                                                       CER001
     D  WL3BID1                1      1                                                       CER001
     D  WL3CNUM                2      7                                                       CER001
     D  WL3CCY                 8     10                                                       CER001
     D  WL3ACOD               11     11                                                       CER001
     D  WL3SEQ2               12     13                                                       CER001
      *                                                                                       CER001
      * Portugal IBAN format (Method 5)                                                       CFT044
     D                 DS                                                                     CFT044
     D  ##IBAN                 1     21                                                       CFT044
     D  ##NIBBK                1      4                                                       CFT044
     D  ##NIBBR                5      8                                                       CFT044
     D  ##ZERO                 9      9                                                       CFT044
     D  ##ACNO                10     19                                                       CFT044
     D  ##CHKD2               20     21                                                       CFT044
     D  ##NIBA                 1     21                                                       CFT044
      *                                                                                       CFT044
     D/COPY WNCPYSRC,AOIBAN6D01
      *
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)
      * Data Structure DSSDY (Input Parameter)
      *
     D D@FMT         E DS                  EXTNAME(ACCNTAB)
      * ACCNTABF - Account details record format data structure
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * Data Structure for Module Details Access Program
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      * External DS for Retail Details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      * Branch Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Data Structure DSFDY
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER001
     D SLCD          E                     EXTFLD(LCD)                                        CER001
      *                                                                                       CER001
      ** Externally described DS for SAR details                                              CER001
      *                                                                                       CER001
      /SPACE 3
      *
      /EJECT
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD            7            O:Return code
     C                   PARM                    P@FMT                          I:Action
      *
     C     KACC5         KLIST
     C                   KFLD                    @@NOBL                         O:Return code
     C/COPY WNCPYSRC,AOIBAN6C01
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  RETAIL    - Construct IBAN using Retail method               *
      *              ( Retail Account Number)                         *
      *  METHOD1   - Construct IBAN using method 1                    *
      *              ( Branch,Cust,Ccy,Accnt Code,Accnt sequence)     *
      *  METHOD2   - Construct IBAN using method 2                    *
      *              ( Branch,Cust,Ccy, 2 char. Sequence)             *
      *  METHOD3   - Construct IBAN using method 3                    *
      *              ( Branch IBAN Id (1A),Cust,Ccy, 2 char. Sequence)*
      *  METHOD4   - Construct IBAN using method 4                    *
      *              ( Branch IBAN Id (2A),Cust, 3 char. Sequence)    *
      *  METHOD5   - Construct IBAN using method 5 (Greece)           *                       199186
      *              (Cust,Ccy,Accnt Code,Accnt sequence)             *                       199186
      *  PAD       - Replace Blanks by Zeros                          *
      *  FORMAT    - Format IBAN and check IBAN is unique             *
      *                                                               *
      *****************************************************************
      *MAIN
      *
     C                   MOVE      *BLANKS       P@RTCD
      *
      * Get Account Details
     C**********         MOVEL     P@FMT         D@FMT                                        239296
     C                   MOVEL     P@FMT         ACNT                                         239296
                                                                                              239296
     C                   MOVEL(P)  ACNUM         CNUM                                         239296
     C                   MOVEL(P)  ACCY          CCY                                          239296
     C                   MOVEL(P)  AACOD         ACOD                                         239296
     C                   MOVEL(P)  AACSQ         ACSQ                                         239296
     C                   MOVEL(P)  ABRCA         BRCA                                         239296
     C                   MOVEL     AATYP         ATYP                                         239296
     C                   MOVEL(P)  AACNO         ACNO                                         239296
     C                   MOVEL     AIBAN         IBAN                                         239296
     C                   MOVEL     AIBSEQN       IBSEQN                                       239296
      *
      * Check that no IBAN has been already set for this account
     C     IBAN          IFNE      *BLANKS
     C                   MOVE      '*IBAN  '     P@RTCD
     C                   RETURN
     C                   ENDIF
      *
     C/COPY WNCPYSRC,AOIBAN6C05
      * Check if retail is on
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM      '*FIRST'      @@OPTN            7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @@RTCD        IFNE      *BLANKS
     C                   MOVE      '*ERROR'      P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      * Get Retail ICD if on
     C     BGRTBN        IFEQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM      '*FIRST '     @@OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
     C     @@RTCD        IFNE      *BLANKS
     C                   MOVE      '*ERROR'      P@RTCD
     C                   RETURN
     C                   ENDIF
      *
     C                   ELSE
      *   Set Retail Number Used to No
     C                   MOVE      'N'           BMRANR
     C                   ENDIF
      *
      ** CFT044 - Portugal IBAN format                                                        CFT044
      *                                                                                       CFT044
     C                   MOVEL     'N'           CFT044                                       CFT044
     C                   CALL      'AOSARDR0'                                                 CFT044
     C                   PARM      *BLANKS       @@RTCD                                       CFT044
     C                   PARM      '*VERIFY'     @@OPTN                                       CFT044
     C                   PARM      'CFT044'      @@SARD                                       CFT044
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT044
      *                                                                                       CFT044
     C                   IF        @@RTCD = *BLANKS                                           CFT044
     C                   MOVEL     'Y'           CFT044                                       CFT044
     C                   ENDIF                                                                CFT044
      *                                                                                       CFT044
      * Get Branch Details
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM      '*KEY   '     @@OPTN
     C                   PARM      BRCA          @@BRCA            3
     C     SDBRCH        PARM      SDBRCH        P@FMT
      *
     C     @@RTCD        IFNE      *BLANKS
     C                   MOVE      '*ERROR'      P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      * Get ISO Country Code
     C                   CALLB     'AOIBANR7'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM      BRCA          @@BRCA
     C                   PARM                    @@CTRY            2
      *
     C     @@RTCD        IFNE      *BLANKS
     C                   MOVE      '*ERROR'      P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      * Get Country Details
     C     @@CTRY        CHAIN     SDCTRYL2                           70
      *
     C     *IN70         IFNE      *OFF
     C                   MOVE      '*ERROR'      P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      * Do Initial Format of IBAN
      *   Set ISO Country Code
     C                   MOVEL     @@CTRY        OIBAN(1)
     C                   MOVE      @@CTRY        OIBAN(2)
      *   Set Check Digits to '00'
     C                   MOVE      '0'           OIBAN(3)
     C                   MOVE      '0'           OIBAN(4)
      *   Set Bank/Branch Identifier
     C     A8IBID        IFNE      *BLANKS
     C                   Z-ADD     1             WPOS1             2 0
     C                   Z-ADD     5             WPOS2             2 0
     C                   MOVEL     A8IBID        WIBID
     C     ' '           SCAN      A8IBID        WEND1             2 0
     C     WEND1         IFEQ      0
     C     1             ADD       A4BBRL        WEND1
     C                   ENDIF
     C     WPOS1         DOWLT     WEND1
     C                   MOVE      WIBID1(WPOS1) OIBAN(WPOS2)
     C                   ADD       1             WPOS1
     C                   ADD       1             WPOS2
     C                   ENDDO
      * If Bank Identifier is shorter than Bank Identifier Length inSDCTRYPD
      * fill the difference with '0'
     C     WPOS1         DOWLE     A4BBRL
     C                   MOVE      '0'           OIBAN(WPOS2)
     C                   ADD       1             WPOS1
     C                   ADD       1             WPOS2
     C                   ENDDO
     C                   ENDIF
      *
      * Identify type of IBAN to be generated
     C                   MOVE      *BLANKS       WKIBAN
     C/COPY WNCPYSRC,AOIBAN6C02
     C                   MOVE      'N'           METH5             1                          199186
     C                   MOVE      'N'           PORIBN                                       CFT044
     C                   Z-ADD     WPOS2         SPOS2             2 0                        199186
     C                   SELECT
      *
      * RETAIL:
     C                   WHEN           (A8GENM ='2')
     C                             AND  (ATYP   ='R')
     C                             AND  (BMRANR ='Y')
     C                   EXSR      RETAIL
      *
     C                   WHEN           (A8GENM ='4')
     C                             AND  (ATYP   ='R')
     C                             AND  (BMRANR ='Y')
     C                   EXSR      RETAIL
      *
      * METHOD1:
     C                   WHEN           (A8GENM ='2')
     C                             AND  (ATYP   ='R')
     C                             AND  (BMRANR ='N')
     C                             AND  (A8GLFM ='1')
     C                   EXSR      METHOD1
      *
     C                   WHEN           (A8GENM ='4')
     C                             AND  NOT(ATYP   ='R')
     C                             AND  (A8GLFM ='1')
     C                   EXSR      METHOD1
      *
     C                   WHEN           (A8GENM ='3')
     C                             AND  (A8GLFM ='1')
     C                   EXSR      METHOD1
      *
      * METHOD2:
     C                   WHEN           (A8GENM ='2')
     C                             AND  (ATYP   ='R')
     C                             AND  (BMRANR ='N')
     C                             AND  (A8GLFM ='2')
     C                   EXSR      METHOD2
      *
     C                   WHEN           (A8GENM ='4')
     C                             AND  NOT(ATYP   ='R')
     C                             AND  (A8GLFM ='2')
     C                   EXSR      METHOD2
      *
     C                   WHEN           (A8GENM ='3')
     C                             AND  (A8GLFM ='2')
     C                   EXSR      METHOD2
      *
      * METHOD3:
     C                   WHEN           (A8GENM ='2')
     C                             AND  (ATYP   ='R')
     C                             AND  (BMRANR ='N')
     C                             AND  (A8GLFM ='3')
     C                   EXSR      METHOD3
      *
     C                   WHEN           (A8GENM ='4')
     C                             AND  NOT(ATYP   ='R')
     C                             AND  (A8GLFM ='3')
     C                   EXSR      METHOD3
      *
     C                   WHEN           (A8GENM ='3')
     C                             AND  (A8GLFM ='3')
     C                   EXSR      METHOD3
      *
      *
      * METHOD4:
     C                   WHEN           (A8GENM ='2')
     C                             AND  (ATYP   ='R')
     C                             AND  (BMRANR ='N')
     C                             AND  (A8GLFM ='4')
     C                   EXSR      METHOD4
      *
     C                   WHEN           (A8GENM ='4')
     C                             AND  NOT(ATYP   ='R')
     C                             AND  (A8GLFM ='4')
     C                   EXSR      METHOD4
      *
     C                   WHEN           (A8GENM ='3')
     C                             AND  (A8GLFM ='4')
     C                   EXSR      METHOD4
      *                                                                                       199186
     C/COPY WNCPYSRC,AOIBAN6C06
      ** METHOD 5 :                                                                           199186
      *                                                                                       199186
     C                   WHEN           (A8GENM ='3')                                         199186
     C                             AND  (A8GLFM ='5')                                         199186
     C                   EXSR      METHOD5                                                    199186
      *
     C                   WHEN      A8GENM ='5'                                                CFT044
     C                             AND ATYP = 'R'                                             CFT044
     C                             AND BMRANR = 'Y'                                           CFT044
     C                             AND CFT044 = 'Y'                                           CFT044
     C                   EXSR      GENMET5                                                    CFT044
      *                                                                                       CFT044
     C                   OTHER
     C                   MOVE      '*GENMTH'     P@RTCD
     C                   RETURN
      *
     C                   ENDSL
      *
     C/COPY WNCPYSRC,AOIBAN6C03
      * Format Field
     C                   EXSR      PAD
     C                   EXSR      FORMAT
      *
      * Exit
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      ********************************************************************
      *
      *    RETAIL    - Construct IBAN using Retail method
      *                ( Retail Account Number)
      *
      *    CALLED BY: MAIN      - Main Processing
      *
      *    CALLS    :
      *
      ********************************************************************
      *
     C     RETAIL        BEGSR
      *
      * Construct Field
     C                   MOVEL     ACNO          WKIBAN
     C                   MOVE      'AAA'         IBSEQN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *
      *    METHOD1   - Construct IBAN using method 1
      *               ( Branch,Cust,Ccy,Accnt Code,Accnt sequence)
      *
      *    CALLED BY: MAIN      - Main Processing
      *
      *    CALLS    :
      *
      ********************************************************************
      *
     C     METHOD1       BEGSR
      *
      * Construct Field
     C                   MOVE      BRCA          W1BRCA
     C                   MOVE      CNUM          W1CNUM
     C                   MOVE      CCY           W1CCY
     C                   MOVE      ACOD          W1ACOD
     C                   MOVE      ACSQ          W1ACSQ
      *
     C                   MOVEL     W1IBAN        WKIBAN
     C                   MOVE      'AAA'         IBSEQN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *
      *    METHOD2   - Construct IBAN using method 2
      *               ( Branch,Cust,Ccy, 2 char. Sequence)
      *
      *    CALLED BY: MAIN      - Main Processing
      *
      *    CALLS    :
      *
      ********************************************************************
      *
     C     METHOD2       BEGSR
      *
      * Calculate Number of Accounts
     C                   MOVE      CNUM          @@CNUM
     C                   CALLB     'AOIBANR8'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM      BRCA          @@BRCA
     C                   PARM                    @@CNUM            6
     C                   PARM      CCY           @@CCY             3
     C                   PARM                    @@SEQN            3
      *
     C     @@RTCD        IFNE      *BLANKS
     C                   MOVE      @@RTCD        P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      *
      * Construct Field
     C                   MOVE      A8BID2        W2BID2
     C                   MOVE      CNUM          W2CNUM
     C                   MOVE      CCY           W2CCY
     C                   MOVE      @@SEQN        W2SEQ2
      *
     C                   MOVEL     W2IBAN        WKIBAN
     C                   MOVE      @@SEQN        IBSEQN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *
      *    METHOD3   - Construct IBAN using method 3
      *                ( Branch IBAN Id (1A),Cust,Ccy, 2 char. Sequence)
      *
      *    CALLED BY: MAIN      - Main Processing
      *
      *    CALLS    :
      *
      ********************************************************************
      *
     C     METHOD3       BEGSR
      *
      * Calculate Number of Accounts
     C                   MOVE      CNUM          @@CNUM
     C                   CALLB     'AOIBANR8'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM      BRCA          @@BRCA
     C                   PARM                    @@CNUM
     C                   PARM      CCY           @@CCY
     C                   PARM                    @@SEQN
      *
     C     @@RTCD        IFNE      *BLANKS
     C                   MOVE      @@RTCD        P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      *
      * Construct Field
     C     ULX053        IFNE      'Y'                                                        CER001
     C                   MOVE      A8BID1        W3BID1
     C                   MOVE      CNUM          W3CNUM
     C                   MOVE      CCY           W3CCY
     C                   MOVE      @@SEQN        W3SEQ2
      *
     C                   MOVEL     W3IBAN        WKIBAN
     C                   MOVE      @@SEQN        IBSEQN
     C                   ELSE                                                                 CER001
     C                   MOVE      A8BID1        WL3BID1                                      CER001
     C                   MOVE      CNUM          WL3CNUM                                      CER001
     C                   MOVE      CCY           WL3CCY                                       CER001
     C                   MOVE      ACSQ          WL3SEQ2                                      CER001
      *                                                                                       CER001
     C                   MOVEL     W3IBAN        WKIBAN                                       CER001
     C                   MOVE      @@SEQN        IBSEQN                                       CER001
     C                   MOVE      ACOD          ACOD10           10                          CER001
     C                   OPEN      SDACX3PD                                                   CER001
     C     ACOD10        CHAIN     SDACX3PD                           80                      CER001
     C     *IN80         IFNE      *OFF                                                       CER001
     C                   CLOSE     SDACX3PD                                                   CER001
     C                   MOVE      '*ERROR'      P@RTCD                                       CER001
     C                   RETURN                                                               CER001
     C                   ENDIF                                                                CER001
     C                   MOVE      ACIBAN        WL3ACOD                                      CER001
     C                   MOVEL     WL3IBAN       WKIBAN                                       CER001
     C                   MOVEL     ACIBAN        IBSEQN                                       CER001
     C                   MOVE      ACSQ          IBSEQN                                       CER001
     C                   CLOSE     SDACX3PD                                                   CER001
                                                                                              CER001
     C                   ENDIF                                                                CER001
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *
      *    METHOD4   - Construct IBAN using method 4
      *                ( Branch IBAN Id (1A),Cust, 3 char. Sequence)
      *
      *    CALLED BY: MAIN      - Main Processing
      *
      *    CALLS    :
      *
      ********************************************************************
      *
     C     METHOD4       BEGSR
      *
      * Calculate Number of Accounts
     C                   MOVE      CNUM          @@CNUM
     C                   CALLB     'AOIBANR8'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM      BRCA          @@BRCA
     C                   PARM                    @@CNUM
     C                   PARM      *BLANKS       @@CCY
     C                   PARM                    @@SEQN
      *
     C     @@RTCD        IFNE      *BLANKS
     C                   MOVE      @@RTCD        P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      *
      * Construct Field
     C                   MOVE      A8BID1        W4BID1
     C                   MOVE      CNUM          W4CNUM
     C                   MOVE      @@SEQN        W4SEQ3
      *
     C                   MOVEL     W4IBAN        WKIBAN
     C                   MOVE      @@SEQN        IBSEQN
      *
     C                   ENDSR
     C/COPY WNCPYSRC,AOIBAN6C04
      /EJECT
      *****************************************************************                       199186
      *                                                               *                       199186
      *    METHOD5   - Construct IBAN using method 5 (Greece)         *                       199186
      *               (Cust,Ccy,Accnt Code,Accnt sequence)            *                       199186
      *                                                               *                       199186
      *    CALLED BY: MAIN      - Main Processing                     *                       199186
      *                                                               *                       199186
      *    CALLS    :                                                 *                       199186
      *                                                               *                       199186
      *****************************************************************                       199186
      *                                                                                       199186
     C     METHOD5       BEGSR                                                                199186
      *                                                                                       199186
      ** Construct Field                                                                      199186
      *                                                                                       199186
     C                   MOVE      'Y'           METH5                                        199186
     C                   MOVEL     '0'           WKBRCD                                       199186
     C                   MOVE      BRCA          WKBRCD                                       199186
     C                   Z-ADD     1             SPOS1             2 0                        199186
     C     SPOS1         DOWLE     4                                                          199186
     C                   MOVE      WKBRC1(SPOS1) OIBAN(SPOS2)                                 199186
     C                   ADD       1             SPOS1                                        199186
     C                   ADD       1             SPOS2                                        199186
     C                   ENDDO                                                                199186
     C                   MOVE      CNUM          W5CNUM                                       199186
     C                   MOVE      CCY           W5CCY                                        199186
     C                   MOVE      ACOD          W5ACOD                                       199186
     C                   MOVE      ACSQ          W5ACSQ                                       199186
      *                                                                                       199186
     C                   MOVEL     W5IBAN        WKIBAN                                       199186
     C                   MOVE      'AAA'         IBSEQN                                       199186
      *                                                                                       199186
     C                   ENDSR                                                                199186
      /EJECT                                                                                  199186
      *****************************************************************                       CFT044
      *                                                               *                       CFT044
      *    GENMET5   - Construct IBAN using IBAN generation method 5  *                       CFT044
      *                Portugal IBAN format                           *                       CFT044
      *                                                               *                       CFT044
      *    CALLED BY: MAIN      - Main Processing                     *                       CFT044
      *                                                               *                       CFT044
      *    CALLS    :                                                 *                       CFT044
      *                                                               *                       CFT044
      *****************************************************************                       CFT044
      *                                                                                       CFT044
     C     GENMET5       BEGSR                                                                CFT044
      *                                                                                       CFT044
      **  Set check digits in position 3-4 to zero                                            CFT044
      **  (These will be calculated in AOIBANR0)                                              CFT044
      *                                                                                       CFT044
     C                   MOVE      'Y'           PORIBN                                       CFT044
      *                                                                                       CFT044
      **  Set NIB Branch and Bank Number fields                                               CFT044
     C                   MOVEL     A8IBID        ##NIBBK                                      CFT044
     C**********         MOVEL     A8IBID        ##NIBBR                             CFT044 AR738915
     C     4             SUBST     A8IBID:5      ##NIBBR                                    AR738915
      *                                                                                       CFT044
      **  Set Retail Number field                                                             CFT044
     C                   MOVE      '0'           ##ZERO                                       CFT044
     C                   MOVE      ACNO          ##ACNO                                       CFT044
      *                                                                                       CFT044
      **  Calculate last 2 digits by calling AOIBANR9                                         CFT044
     C                   CALLB     'AOIBANR9'                                                 CFT044
     C                   PARM      *BLANKS       @@RTCD                                       CFT044
     C                   PARM                    ##IBAN                                       CFT044
     C                   PARM      *BLANKS       WKIBAN                                       CFT044
      *                                                                                       CFT044
     C     @@RTCD        IFNE      *BLANKS                                                    CFT044
     C                   MOVE      '*ERROR'      P@RTCD                                       CFT044
     C                   RETURN                                                               CFT044
     C                   ENDIF                                                                CFT044
      *                                                                                       CFT044
     C                   ENDSR                                                                CFT044
      *                                                                                       CFT044
      /EJECT                                                                                  CFT044
      *****************************************************************
      *
      *    PAD     -  Replace Blanks by zeros
      *
      *    CALLED BY: MAIN      - Main Processing
      *
      *    CALLS    :
      *
      ********************************************************************
      *
     C     PAD           BEGSR
      *
      * Calculate Final Length of BBAN
     C     A4BBAN        SUB       A4BBRL        WFINLG            2 0
      *                                                                                       199186
     C     METH5         IFEQ      'Y'                                                        199186
     C                   SUB       4             WFINLG                                       199186
     C                   ENDIF                                                                199186
      *                                                                                     AR738915
     C     PORIBN        IFEQ      'Y'                                                      AR738915
     C                   ADD       A4BBRL        WFINLG                                     AR738915
     C                   ENDIF                                                              AR738915
      *
      * Calculate Actual Length of BBAN
     C     ' '           SCAN      WKIBAN        WACTLG            2 0
     C                   SUB       1             WACTLG
      *
      * Calculate Length of BBAN to pad
     C     WFINLG        SUB       WACTLG        WPADLG            2 0
      *
      * Construct field
     C                   Z-ADD     1             WPOS1
     C     WPOS1         DOWLE     WPADLG
     C                   MOVE      '0'           WKBBAN(WPOS1)
     C                   ADD       1             WPOS1
     C                   ENDDO
      *
     C                   Z-ADD     1             WPOS2
     C     WPOS1         DOWLE     WFINLG
     C                   MOVE      WKIBAN1(WPOS2)WKBBAN(WPOS1)
     C                   ADD       1             WPOS1
     C                   ADD       1             WPOS2
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *
      *    FORMAT    - Format IBAN and check IBAN is unique
      *
      *    CALLED BY: MAIN      - Main Processing
      *
      *    CALLS    :
      *
      ********************************************************************
      *
     C     FORMAT        BEGSR
      *
      * Add rest of details to IBAN
     C
     C                   Z-ADD     1             WPOS1
     C     A4BBRL        ADD       5             WPOS2
      *                                                                                       199186
     C     METH5         IFEQ      'Y'                                                        199186
     C                   ADD       4             WPOS2                                        199186
     C                   ENDIF                                                                199186
      *                                                                                       199186
     C     PORIBN        IFEQ      'Y'                                                        CFT044
     C                   SUB       A4BBRL        WPOS2                                        CFT044
     C                   ENDIF                                                                CFT044
      *                                                                                       CFT044
     C     WPOS1         DOWLE     WFINLG
     C                   MOVE      WKBBAN(WPOS1) OIBAN(WPOS2)
     C                   ADD       1             WPOS1
     C                   ADD       1             WPOS2
     C                   ENDDO
      *
      * Calculate Check Digits
     C                   CALLB     'AOIBANR0'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM      'C'           @@ACTN            1
     C                   PARM                    @@CTRY
     C                   PARM      OIBAN1        @@IIBN           34
     C                   PARM                    @@OBBN           30
     C                   PARM                    OIBAN1
     C                   PARM                    @@CKDG            2
      *
     C     @@RTCD        IFNE      *BLANKS
     C                   MOVE      @@RTCD        P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      * Format IBAN
     C                   CALLB     'AOIBANR3'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM      OIBAN1        @@IIB1           47
     C                   PARM                    @@WHBL           47
     C                   PARM                    @@NOBL           34
      *
     C     @@RTCD        IFNE      *BLANKS
     C                   MOVE      '*LENGTH'     P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      * Set up file field
     C                   MOVE      @@NOBL        IBAN
      *                                                                                       239296
      ** Pass ACNT to P@FMT because D@FMT contains 4-digit account code                       239296
      *                                                                                       239296
     C**********         MOVEL     D@FMT         P@FMT                                        239296
     C                   MOVE      IBAN          AIBAN                                        239296
     C                   MOVEL     IBSEQN        AIBSEQN                                      239296
     C                   MOVEL     ACNT          P@FMT                                        239296
      *
     C                   MOVEL     BRCA          WBRCA             3
     C**********         Z-ADD     CNUM          WCNUM             6 0                        CSD027
     C                   MOVE      CNUM          WCNUM             6                          CSD027
     C                   MOVEL     CCY           WCCY              3
     C**********         Z-ADD     ACOD          WACOD             4 0                        CGL029
     C                   Z-ADD     ACOD          WACOD            10 0                        CGL029
     C                   Z-ADD     ACNO          WACNO            10 0
     C                   Z-ADD     ACSQ          WACSQ             2 0
      *
      *
      * Ensure IBAN is unique
     C                   OPEN      ACCNTL6
     C     KACC5         SETLL     @ACCL6
     C     KACC5         READE     @ACCL6                                 71
     C                   CLOSE     ACCNTL6
      *  If a record is found, produce error code
     C     *IN71         IFEQ      *OFF
     C     WCNUM         IFNE      CNUM
     C     WCCY          ORNE      CCY
     C     WACOD         ORNE      ACOD
     C     WACSQ         ORNE      ACSQ
     C     WBRCA         ORNE      BRCA
     C     WACNO         ORNE      ACNO
     C                   MOVE      '*UNIQUE'     P@RTCD
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER001
      ** ULX053 - IBANLUX - Luxembourg standard for IBAN                                      CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX053            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @@RTCD                                       CER001
     C                   PARM      '*VERIFY'     @@OPTN                                       CER001
     C                   PARM      'ULX053'      @@SARD            6                          CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @@RTCD = *BLANKS                                           CER001
     C                   MOVEL     'Y'           ULX053                                       CER001
     C                   ENDIF                                                                CER001
      *
     C                   ENDSR
      /EJECT
      ********************************************************************
** CPY@
(c) Finastra International Limited 2001

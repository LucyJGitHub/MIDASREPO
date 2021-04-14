     H DEBUG                                                                                MD056543
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                     MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('CG Consolidated Deal Amendment Extract')               *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  CG7040 - CG Consolidated Deal Amendment Extract              *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 MD029242           Date 25Nov14               *
      *                 CER070             Date 19Aug14               *
      *                 CDL096             Date 24Nov14               *
      *                 MD031008           Date 16Oct14               *
      *                 CDL094             Date 01Sep14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23572           Date 27Mar09               *
      *                 BUG22974           Date 19Feb09               *
      *                 BUG22741           Date 18Feb09               *
      *                 CER040  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD to readable  *
      *             unicode equivalent.                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD029242 - System should generate Dealing CM correspondences *
      *             also for the Customers with SWIFT-Id (suppressed  *
      *             by CER038)                                        *
      *           - Created new system value to condition the         *
      *             suppression of correspondence if customer has     *
      *             Swift ID                                          *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  MD031008 - Missing new fields in Confirmation for DEAM.      *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23572 - CHIPSABA Not Accept '0' on screen, so that populat*
      *             with blanks when '0' values in database           *
      *  BUG22974 - Comment out extra calling of PSHGRP, in CGINPS by *
      *             which 1 extra opening tag is written              *
      *  BUG22741 - Populate Telex Number, when STTX Address is blank *
      *             in SDCUSTPD                                       *
      *  CER040 - Consolidated MM Deal Confirmation Correspondence    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ---------------                                              *
      *                                                               *
      *  90   -    Poffered for READE LOOPS                           *
      *  99   -    General error indicator                            *
      *                                                               *
      *****************************************************************
     FDEALS     IF   E           K DISK
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     F                                     IGNORE(DEALSDGF)
      *
      ** Correspondent file by customer number
      *
     FCGCORRL4  IF   E           K DISK
      *
     F/SPACE 5
      *
     D*COPY*CGCPYSRC,CGPACKE                                                                MD056543
     D*COPY*CGCPYSRC,SRERRE                                                                 MD056543
     D/COPY CGCPYSRC,CGPACKEILE                                                             MD056543
     D/COPY CGCPYSRC,SRERRDLE                                                               MD056543
      *
      ** Number Arrays
      *
     D*##NUMA***       S              1    DIM(29)                                          MD056543
      *
      ** Array of Currencies accessed by program
      *
     D ##CY            S              3    DIM(100)
      *
      ** Loan Deal Types.
      *
     D #LN             S              2    DIM(7) CTDATA PERRCD(7)
      *
      ** Copyright array.
      *
      *
      ** Look-up string for RDE definition Array
      *
     D ##SDS           DS
     D  ##S                    1   5632
     D                                     DIM(22)                                          MD056543
      *
     D #@SDS           DS
     D  #@S                 5120   5120
      *
      ** Packed data string.
      *
     D                 DS
     D  ##W                    1     20
     D                                     DIM(20)
     D  ##WNUM                 1     20  0
      *
      ** Number Field
      *
     D                 DS
     D  ##ITMA                 1      8
     D  ##ITEM                 1      8  0
      *
      ** Used to convert item reference from character to numeric
      *
     D                 DS
     D  ##NCIT                 1      6
     D  NMCY                   1      3
     D  SITP                   4      6
     D                 DS
     D  ##CCCC                 1      5
     D  ##CCY                  1      3
     D  ##CCD                  4      5
      *
      ** For error reporting
      *
      ** Named constants
      *
     D W#PTYP          C                   CONST('CONSOL    ')
     D W#PSTY          C                   CONST('CONFI     ')
     D W#PHON          C                   CONST('Telephone')
      *
      ** External DS for incomplete reference
      *
     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
      *
      ** External DS for Bank details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for General Ledger details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  GLACCD       E                     EXTFLD(QQACCD)
      *
      ** External DS for Module details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** External DS for Securities Trading Module details
      *
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** External DS for Trading Module details
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  TMACCD       E                     EXTFLD(QQACCD)
      *
      ** External DS for Dealing Module details
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  DLACCD       E                     EXTFLD(QQACCD)
      *
      ** External DS for Retail details
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  RLACCD       E                     EXTFLD(QQACCD)
      *
      ** External DS for Message Management details
      *
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      *
      ** External DS for Funds Transfer details
      *
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      *
      ** External DS for branch details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  BRACCD       E                     EXTFLD(QQDFAC)
      *
      ** External DS for customer details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS for Account officer details
      *
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      *
      ** External DS for nostro details
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      ** External DS for Counterparty nostro details
      *
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** External DS for Broker details
      *
     D SDBROK        E DS                  EXTNAME(SDBROKPD)
      *
      ** External DS for currency details
      *
     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
      *
      ** MIDAS Switchable Features Accessed Via Access Program
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Record format of PF/CGUDTAPD for use as a parameter
      *
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
      *
     D*COPY*CGCPYSRC,CGPACKI                                                                MD056543
     D/COPY CGCPYSRC,CGPACKIILE                                                             MD056543
      *
      ** External DS for parameter passed from CG7030
      *
     D DSPARM        E DS                  EXTNAME(DLDACOPD)
      *                                                                                     BUG22741
      **  External DS for Additinal Customer details                                        BUG22741
      *                                                                                     BUG22741
     D SDACUS        E DS                  EXTNAME(SDACUSPD)                                BUG22741
      *
      ** Data Structure for Compilation - Copyright Insertion
      *
     D CPYR            DS
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     I*COPY*CGCPYSRC,SRERRI                                                                 MD056543
      *
      ** DS to store subroutine specific data.
      ** - Saved Path
      *
     D ##PATH          DS                  OCCURS(20)
     D  ##GRPS                 1      6
      *
     D ##BIND          DS                  OCCURS(20)
     D  ##PBIN                 1      6  0 INZ(1)
     D  ##TBIN                 7     12  0 INZ(1)
      *
     D                 DS
     D  #@BIND                 1      6  0 INZ(1)
      *
     D #PDS            DS
     D  P1                     1      3  0 INZ(0)
     D  P2                     4      6  0
     D  P3                     7      9  0
     D  P4                    10     12  0
     D  P5                    13     15  0
      *
     D P1PARM          DS           768
      *
      ** Pay - Settlement method
      *
     D  P1PSTM                 1      2  0
      *
      ** Pay - Our Nostro
      *
     D  P1POQQ                 3     14
      *
      ** Pay - Intermidiary bank no
      *
     D  P1PIBN                15     25
      *
      ** Pay - Intermidiary account no
      *
     D  P1PIBA                26     60
      *
      ** Pay - Ordering bank No
      *
     D**********                             61  690P1POBN                                    CER059
     D  P1POBN                61     69                                                       CER059
      *
      ** Pay - Ordering customer no
      *
     D**********                             70  780P1POCN                                    CER059
     D  P1POCN                70     78                                                       CER059
      *
      ** Receiver Correspondent no
      *
     D  P1RCRN                79     89
      *
      ** Receiver Correspondent a/c line
      *
     D  P1RCRA                90    124
      *
      ** Receiver Number
      *
     D  P1RVNO               125    135
      *
      ** A/C with bank no
      *
     D  P1AWBN               136    146
      *
      ** A/C with bank a/c line
      *
     D  P1AWBA               147    181
      *
      ** Beneficiary number
      *
     D  P1BENN               182    192
      *
      ** Beneficiary account line
      *
     D  P1BENA               193    227
      *
      ** Details of pay 1
      *
     D  P1DTP1               228    262
      *
      ** Details of pay 2
      *
     D  P1DTP2               263    297
      *
      ** Details of pay 3
      *
     D  P1DTP3               298    332
      *
      ** Details of pay 4
      *
     D  P1DTP4               333    367
      *
      ** Details of Charges
      *
     D  P1DCHG               368    370
      *
      ** Bank to bank info - 1
      *
     D  P1BTB1               371    405
      *
      ** Bank to bank info - 2
      *
     D  P1BTB2               406    440
      *
      ** Bank to bank info - 3
      *
     D  P1BTB3               441    475
      *
      ** Bank to bank info - 4
      *
     D  P1BTB4               476    510
      *
      ** Bank to bank info - 5
      *
     D  P1BTB5               511    545
      *
      ** Bank to bank info - 6
      *
     D  P1BTB6               546    580
      *
      ** Currency
      *
     D  P1CCY                581    583
      *
      ** 087000 - include additional details to allow determination
      ** of prime retail account for settlement method 04.
      *
     D  P1CNUM               584    589
     D  P1ACCD               590    599
     D  P1BRCH               600    602
     D  P1PONS               603    620
      *
      ** Parameters for call to CG4985.
      *
     D P3PARM          DS           256
      *
      ** Output Sequence
      *
     D  P1OSEQ                 1      9  0
      *
      ** UDC item number
      *
     D  P1ITEM                10     17  0
      *
      ** This bind level
      *
     D  P1TBIN                18     25  0
      *
      ** Previous bind level
      *
     D  P1PBIN                26     33  0
      *
      ** Parameters for call to CG4975.
      *
     D P6PARM          DS           256
      *
      ** Receipt - Settlement method
      *
     D  P1RSTM                 1      2  0
      *
      ** Receipt - Our Nostro
      *
     D  P1ROQQ                 3     14
      *
      ** Receipt - Intermidiary bank no
      *
     D  P1RIBN                15     25
      *
      ** Receipt - Intermidiary account no
      *
     D  P1RIBA                26     60
      *
      ** Receipt - Ordering bank No
      *
     D**********                             61  690P1ROBN                                    CER059
     D  P1ROBN                61     69                                                       CER059
      *
      ** Receipt - Ordering customer no
      *
     D**********                             70  780P1ROCN                                    CER059
     D  P1ROCN                70     78                                                       CER059
      *
      ** Branch
      *
     D  R1BRCH                79     81
      *
      ** Currency
      *
     D  R1CCY                 82     84
      *
      ** 087000 - include additional details to allow determination
      ** of prime retail account for settlement method 04.
      *
     D  R1CNUM                85     90
     D  R1ACCD                91    100
     D  P1RONS               101    118
      *
      ** Parameters for call to CG4975.
      *
     D P5PARM          DS           256
      *
      ** Output Sequence
      *
     D  R1OSEQ                 1      9  0
      *
      ** UDC item number
      *
     D  R1ITEM                10     17  0
      *
      ** This bind level
      *
     D  R1TBIN                18     25  0
      *
      ** Previous bind level
      *
     D  R1PBIN                26     33  0
      *                                                                                     MD029242
      ** System Value field                                                                 MD029242
      *                                                                                     MD029242
     D SVAL1           DS           200                                                     MD029242
     D  SVAL11                 1      1                                                     MD029242
      *                                                                                     MD029242
      ** Named constants                                                                    MD029242
      *                                                                                     MD029242
     D #SUPRS          C                   CONST('SupCorr4CustwSwiftID')                    MD029242
     C/SPACE 5
      *****************************************************************
      *  Process     -  MAINLINE                                      *
      *  Function    -  Mainline processing                           *
      *                                                               *
      *  Called by   -  None                                          *
      *  Calls       -  SRINIT - Initial Processing - On First Call   *
      *                 SRINZ  - Initialise Fields on Each Invocation *
      *                 SRMAIN - Main Processing                      *
      *****************************************************************
      *
      ** Parameter list for current program invocation.
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT             3
     C                   PARM                    ##COPD            1
     C                   PARM                    ##AUTO            1
     C                   PARM                    DSPARM
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      ** Initial processing - Once Only
      *
     C     ##INIT        IFEQ      *BLANKS
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT            1
     C                   ENDIF
      *
      ** Initialisation processing
      *
     C                   EXSR      SRINZ
      *
      ** Main processing
      *
     C                   EXSR      SRMAIN
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      ** Terminate program
      *
     C                   RETURN
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRMAIN                                        *
      *  Function    -  Main processing                               *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -                                                *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRMAIN'      @STK(Q)
      *
      ** Read Deals file to get all the related key-fields
      *
     C     FDLNO         CHAIN     DEALS                              99
      *
      ** If deal not found
      *
     C     *IN99         IFEQ      '1'
      *
      ** Database error
      *
     C                   MOVEL     'DEALSDC '    W0FILE
     C                   MOVEL     FDLNO         W0KEY
     C                   Z-ADD     13            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Generate reference number by writing to PF/CGUDCRPD
      ** If no confirmation to be produced, then bypass
      *
     C                   MOVEL     'N'           ##SPPS
     C                   EXSR      SRAUTO
     C     ##SPPS        CABEQ     'Y'           EXMAIN
     C                   MOVE      'N'           ##COPD
     C                   EXSR      SRGENR
     C     ##COPD        CABEQ     'N'           EXMAIN
      *
      ** Extract
      *
     C                   EXSR      ZFGE97
      *
     C     EXMAIN        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  ZFGE97                                        *
      *  Function    -  Process: FGE097 - Consolidated Conf.          *
      *                                                               *
      *  Called by   -  SRMAIN                                        *
      *  Calls       -                                                *
      *****************************************************************
     C     ZFGE97        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'ZFGE97'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'ZFGE97'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
     C                   EXSR      BRANCH                                       1
      *
     C                   EXSR      CGBRCH                                       2
      *
     C                   EXSR      BROKER                                       3
      *
     C                   EXSR      D@BASM                                       4
      *
     C                   EXSR      D@LADS                                       5
      *
     C                   EXSR      CUST                                         6
      *
     C                   EXSR      Z97DET                                       7
      *
     C                   EXSR      ACOF                                         8
      *
     C                   EXSR      CGINPS                                       9
      *
     C                   EXSR      D@RECS                                       10
      *
      ** Extended Settlement Receipts
      *
     C     FPRFL         IFEQ      'B'                                          both
     C     FPRFL         OREQ      'R'                                          receive
     C                   EXSR      EX@REC                                       11
     C                   END
      *
     C                   EXSR      D@PAYS                                       12
      *
      ** Extended Settlement Payments
      *
     C     FPRFL         IFEQ      'B'                                          both
     C     FPRFL         OREQ      'P'                                          pay
     C                   EXSR      EX@PAY                                       13
     C                   END
      *                                                                                     MD031008
      ** Retrieve Receive Details for CDL094                                                MD031008
      *                                                                                     MD031008
     C     CDL094        IFEQ      'Y'                                                      MD031008
     C                   MOVEL(P)  CCY           @NSKYB                                     MD031008
     C                   EXSR      RTVRCV                                                   MD031008
     C                   ENDIF                                                              MD031008
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  ACOF                                          *
      *  Function    -  Account Officer Details                       *
      *                                                               *
      *  Called by   -  ZFGE97                                        *
      *  Calls       -  SRRRDE                                        *
      *                 SRADTA - Format Extract Data                  *
      *                 SRODTA - Output Extract Data                  *
      *                 SRERR  - Database Error                       *
      *****************************************************************
     C     ACOF          BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'ACOF  '      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'ACOF  '      ##GRPS
      *
     C                   EXSR      SRPATH
      *
      ** Do not process if Account Officer blank.
      *
     C     BBACOC        IFEQ      *BLANKS
     C                   GOTO      EXACOF
     C                   ENDIF
      *
      **  Access Account Officer Details
      *
     C                   CALL      'AOACOFR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      BBACOC        ##KEY2            2
     C     SDACOF        PARM      SDACOF        DSSDY
      *
      ** Account Officer details not found
      *
     C     ##RTCD        IFNE      *BLANK
     C                   GOTO      EXACOF
     C                   END
     C                   Z-ADD     0             R1                3 0
      *
     C                   EXSR      PSHGRS
      *
      ** 1. Account Officer Code
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ACOF_COD'    #@RDE
     C                   MOVE      'E '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     AZACOC        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 2. Account Officer Department
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ACOF_DEP'    #@RDE
     C                   MOVE      'T '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     AZDPCD        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 3.Account Officer Name
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ACOF_NAM'    #@RDE
     C                   MOVE      'E '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     AZACON        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 4.Account Officer Telephone Number
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ACOF_TEL'    #@RDE
     C                   MOVE      'P '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     AZAPHN        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 5.Account Officer Telephone Extension
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ACOF_TEL'    #@RDE
     C                   MOVE      'X '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     AZAEXT        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Accumulate RDE's and associated data and output to
      ** PF/CGUDTAPD.
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     EXACOF        TAG
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  CGINPS                                        *
      *  Function    -  Process: FGE097 - Interest Paid Separately    *
      *                          Information                          *
      *                                                               *
      *  Called by   -  ZFGE97                                        *
      *  Calls       -                                                *
      *                                                               *                     BUG22974
      *  Note       : The extraction of RDE's must be maintained for  *                     BUG22974
      *               both the hardcoded subrourine and \Copy CGINPS  *                     BUG22974
      *****************************************************************
     C     CGINPS        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'CGINPS'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'CGINPS'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Reset arrays
      *
     C                   MOVEL     *BLANK        ##R
     C                   MOVEL     *BLANK        ##D
     C                   MOVEL     *BLANK        ##S
      *
      ** Get Nostro Details
      *
     C                   MOVE      INSA          UFREST           13
      *
      ** If Nostronumber and interest paid seperately
      *
     C     UFREST        IFEQ      *BLANK
     C     IPDS          ANDEQ     'Y'
      *
     C     ISCY          IFNE      *BLANK
     C                   MOVE      ISCY          ##ICCY            3
     C                   ELSE
     C                   MOVE      CCY           ##ICCY
     C                   ENDIF
      *
     C                   MOVEL     INSA          ##NOST            2
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      ##ICCY        @KEYB             3
     C                   PARM      *BLANKS       @KEYC             4
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      ##NOST        @KEYE             2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDNOSTPD'    W0FILE
     C                   MOVEL     ##NOST        W0KEY
     C                   Z-ADD     11            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** If Nostro exists
      *
     C     @RTCD         IFEQ      *BLANK
      *
      ** Get Customer details of Nostro
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      A7CUST        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     A7CUST        W0KEY
     C                   Z-ADD     12            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   ENDIF
     C                   ENDIF
      *
     C**********           EXSR PSHGRS                                                      BUG22974
      *
      ** Int Settlement Method
      *
     C                   MOVEL     IMET          ##D(1)
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZIMET'      #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(1)
      *
      ** Int Nostro Name
      *
      ** If Nostronumber and interest paid seperately
      *
     C     UFREST        IFEQ      *BLANK
     C     IPDS          ANDEQ     'Y'
     C                   MOVEL     BBCRNM        ##D(2)
     C                   ELSE
     C                   MOVEL     *BLANK        ##D(2)
     C                   ENDIF
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZINOS'      #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(2)
      *
      ** Int Settlement Acc
      *
      ** If Nostronumber or Interest not paid seperately
      *
     C     UFREST        IFEQ      *BLANK
     C     IPDS          OREQ      'N'
     C                   MOVEL     *BLANK        ##D(3)
     C                   ELSE
     C                   MOVEL     INSA          ##D(3)
     C                   ENDIF
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZINSA'      #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(3)
      *
      ** Int Nostro Town
      *
      ** If Nostronumber and Interest paid separately
      *
     C     UFREST        IFEQ      *BLANK
     C     IPDS          ANDEQ     'Y'
     C                   MOVEL     BBCRTN        ##D(4)
     C                   ELSE
     C                   MOVEL     *BLANK        ##D(4)
     C                   ENDIF
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZINTW'      #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(4)
      *
      ** Interest Paid Seperately Indicator
      *
     C                   MOVEL     IPDS          ##D(5)
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZINPS'      #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(5)
      *
     C                   MOVEL     *BLANKS       UFTNN            30
     C                   MOVEL     *BLANKS       UFTNT            20
     C     INOS          IFNE      *BLANKS
     C     IPDS          ANDEQ     'Y'
      *
      ** See if it is a customer number
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      INOS          @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
      *
      ** See if it is a counterparty nostro
      *
     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      INOS          @ARCD             8
     C     SDCNST        PARM      SDCNST        DSFDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDCNSTPD'    W0FILE
     C                   MOVEL     INOS          W0KEY
     C                   Z-ADD     23            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ELSE
      *
      ** Save Counterparty nostro information
      *
     C                   MOVEL     AWCPNM        UFTNN            30
     C                   MOVEL     AWCNTN        UFTNT            20
     C                   ENDIF
     C                   ELSE
      *
      ** Save Customer information
      *
     C                   MOVEL     BBCRNM        UFTNN            30
     C                   MOVEL     BBCRTN        UFTNT            20
     C                   ENDIF
     C                   ENDIF
      *
      ** Int Counterparty Nostro Name
      *
     C                   MOVEL     UFTNN         ##D(6)
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZCINOS '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(6)
      *
      ** Int Counterparty Nostro Town
      *
     C                   MOVEL     UFTNT         ##D(7)
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZCINTW'     #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(7)
      *
      ** Accumulate RDE's and associated data and output to
      ** PF/CGUDTAPD.
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
     C     EXINPS        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************                     MD031008
     C/SPACE 5                                                                              MD031008
      *****************************************************************                     MD031008
      * Subroutine  :  RTVRCV                                         *                     MD031008
      * Function    :  Retrieve Receive Details for CDL094            *                     MD031008
      * Called by   :                                                 *                     MD031008
      * Calls       :                                                 *                     MD031008
      *                                                               *                     MD031008
      *****************************************************************                     MD031008
     C     RTVRCV        BEGSR                                                              MD031008
      *                                                                                     MD031008
      **  Set up subroutine stack name                                                      MD031008
      *                                                                                     MD031008
     C                   ADD       1             Q                                          MD031008
     C                   MOVEL     'RTVRCV'      @STK(Q)                                    MD031008
      *                                                                                     MD031008
      *................................................................                     MD031008
      *                                                                                     MD031008
      **  Set up Path.                                                                      MD031008
      *                                                                                     MD031008
     C                   ADD       1             P1                                         MD031008
     C     P1            OCCUR     ##PATH                                                   MD031008
     C                   MOVEL(P)  'RTVRCV'      ##GRPS                                     MD031008
      *                                                                                     MD031008
     C                   EXSR      SRPATH                                                   MD031008
      *                                                                                     MD031008
     C                   EXSR      PSHGRS                                                   MD031008
      *                                                                                     MD031008
      ** Retrieve Receive Details (Bank to Bank information, Intermediary,                  MD031008
      ** Beneficiary, Delivery Agent, Account lines)                                        MD031008
      *                                                                                     MD031008
     C                   Z-ADD     0             R1                3 0                      MD031008
     C                   ADD       1             R1                                         MD031008
     C                   CLEAR                   R#DATA                                     MD031008
     C                   CLEAR                   R#DEFN                                     MD031008
     C                   CLEAR                   #@RDE                                      MD031008
     C                   MOVEL     'RBTB1   '    #@RDE                                      MD031008
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD031008
     C                   MOVEL     RBTB1         R#DATA                                     MD031008
     C                   MOVEL     R#DATA        ##D(R1)                                    MD031008
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD031008
      *                                                                                     MD031008
     C                   ADD       1             R1                                         MD031008
     C                   CLEAR                   R#DATA                                     MD031008
     C                   CLEAR                   R#DEFN                                     MD031008
     C                   CLEAR                   #@RDE                                      MD031008
     C                   MOVEL     'RBTB2   '    #@RDE                                      MD031008
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD031008
     C                   MOVEL     RBTB2         R#DATA                                     MD031008
     C                   MOVEL     R#DATA        ##D(R1)                                    MD031008
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD031008
      *                                                                                     MD031008
     C                   ADD       1             R1                                         MD031008
     C                   CLEAR                   R#DATA                                     MD031008
     C                   CLEAR                   R#DEFN                                     MD031008
     C                   CLEAR                   #@RDE                                      MD031008
     C                   MOVEL     'RBTB3   '    #@RDE                                      MD031008
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD031008
     C                   MOVEL     RBTB3         R#DATA                                     MD031008
     C                   MOVEL     R#DATA        ##D(R1)                                    MD031008
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD031008
      *                                                                                     MD031008
     C                   ADD       1             R1                                         MD031008
     C                   CLEAR                   R#DATA                                     MD031008
     C                   CLEAR                   R#DEFN                                     MD031008
     C                   CLEAR                   #@RDE                                      MD031008
     C                   MOVEL     'RBTB4   '    #@RDE                                      MD031008
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD031008
     C                   MOVEL     RBTB4         R#DATA                                     MD031008
     C                   MOVEL     R#DATA        ##D(R1)                                    MD031008
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD031008
      *                                                                                     MD031008
     C                   ADD       1             R1                                         MD031008
     C                   CLEAR                   R#DATA                                     MD031008
     C                   CLEAR                   R#DEFN                                     MD031008
     C                   CLEAR                   #@RDE                                      MD031008
     C                   MOVEL     'RBTB5   '    #@RDE                                      MD031008
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD031008
     C                   MOVEL     RBTB5         R#DATA                                     MD031008
     C                   MOVEL     R#DATA        ##D(R1)                                    MD031008
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD031008
      *                                                                                     MD031008
     C                   ADD       1             R1                                         MD031008
     C                   CLEAR                   R#DATA                                     MD031008
     C                   CLEAR                   R#DEFN                                     MD031008
     C                   CLEAR                   #@RDE                                      MD031008
     C                   MOVEL     'RBTB6   '    #@RDE                                      MD031008
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD031008
     C                   MOVEL     RBTB6         R#DATA                                     MD031008
     C                   MOVEL     R#DATA        ##D(R1)                                    MD031008
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD031008
      *                                                                                     MD031008
      *                                                                                     MD031008
     C     RSTM          IFEQ      08                                                       MD031008
      *                                                                                     MD031008
      ** Call AONOSTR1 to retrieve receive details                                          MD031008
      *                                                                                     MD031008
     C                   CALL      'AONOSTR1'                                               MD031008
     C                   PARM      '*MSG   '     ##RTCD                                     MD031008
     C                   PARM      '*KEY   '     ##OPTN                                     MD031008
     C                   PARM      *BLANKS       @NSKYA            6                        MD031008
     C                   PARM                    @NSKYB            3                        MD031008
     C                   PARM      *BLANKS       @NSKYC           10                        MD031008
     C                   PARM      *BLANKS       @NSKYD            2                        MD031008
     C                   PARM      RONS          @NSKYE            2                        MD031008
     C                   PARM      *BLANKS       @KEYF             3                        MD031008
     C                   PARM      *BLANKS       @KEYG            10                        MD031008
     C                   PARM      *BLANKS       @KEYH             1                        MD031008
     C     SDNOST        PARM      SDNOST        DSSDY                                      MD031008
     C     ##RTCD        IFEQ      *BLANK                                                   MD031008
     C                   ADD       1             R1                                         MD031008
     C                   CLEAR                   R#DATA                                     MD031008
     C                   CLEAR                   R#DEFN                                     MD031008
     C                   CLEAR                   #@RDE                                      MD031008
     C                   MOVEL     'A7RF56  '    #@RDE                                      MD031008
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD031008
     C                   MOVEL     A7RF56        R#DATA                                     MD031008
     C                   MOVEL     R#DATA        ##D(R1)                                    MD031008
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD031008
      *                                                                                     MD031008
     C                   ADD       1             R1                                         MD031008
     C                   CLEAR                   R#DATA                                     MD031008
     C                   CLEAR                   R#DEFN                                     MD031008
     C                   CLEAR                   #@RDE                                      MD031008
     C                   MOVEL     'A7RA56  '    #@RDE                                      MD031008
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD031008
     C                   MOVEL     A7RA56        R#DATA                                     MD031008
     C                   MOVEL     R#DATA        ##D(R1)                                    MD031008
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD031008
      *                                                                                     MD031008
     C                   ADD       1             R1                                         MD031008
     C                   CLEAR                   R#DATA                                     MD031008
     C                   CLEAR                   R#DEFN                                     MD031008
     C                   CLEAR                   #@RDE                                      MD031008
     C                   MOVEL     'A7RF57  '    #@RDE                                      MD031008
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD031008
     C                   MOVEL     A7RF57        R#DATA                                     MD031008
     C                   MOVEL     R#DATA        ##D(R1)                                    MD031008
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD031008
      *                                                                                     MD031008
     C                   ADD       1             R1                                         MD031008
     C                   CLEAR                   R#DATA                                     MD031008
     C                   CLEAR                   R#DEFN                                     MD031008
     C                   CLEAR                   #@RDE                                      MD031008
     C                   MOVEL     'A7RA57  '    #@RDE                                      MD031008
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD031008
     C                   MOVEL     A7RA57        R#DATA                                     MD031008
     C                   MOVEL     R#DATA        ##D(R1)                                    MD031008
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD031008
      *                                                                                     MD031008
     C                   ADD       1             R1                                         MD031008
     C                   CLEAR                   R#DATA                                     MD031008
     C                   CLEAR                   R#DEFN                                     MD031008
     C                   CLEAR                   #@RDE                                      MD031008
     C                   MOVEL     'A7RF58  '    #@RDE                                      MD031008
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD031008
     C                   MOVEL     A7RF58        R#DATA                                     MD031008
     C                   MOVEL     R#DATA        ##D(R1)                                    MD031008
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD031008
      *                                                                                     MD031008
     C                   ADD       1             R1                                         MD031008
     C                   CLEAR                   R#DATA                                     MD031008
     C                   CLEAR                   R#DEFN                                     MD031008
     C                   CLEAR                   #@RDE                                      MD031008
     C                   MOVEL     'A7RA58  '    #@RDE                                      MD031008
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD031008
     C                   MOVEL     A7RA58        R#DATA                                     MD031008
     C                   MOVEL     R#DATA        ##D(R1)                                    MD031008
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD031008
      *                                                                                     MD031008
     C                   ENDIF                                                              MD031008
     C                   ENDIF                                                              MD031008
      *                                                                                     MD031008
      **  Accumulate RDE's and associated data and output to                                MD031008
      **  PF/CGUDTAPD.                                                                      MD031008
      *                                                                                     MD031008
     C                   EXSR      SRADTA                                                   MD031008
     C                   EXSR      SRODTA                                                   MD031008
      *                                                                                     MD031008
      *................................................................                     MD031008
      *                                                                                     MD031008
     C     EXRCV         TAG                                                                MD031008
      *                                                                                     MD031008
      **  Unwind subroutine stack name                                                      MD031008
      *                                                                                     MD031008
     C                   EXSR      POPGRS                                                   MD031008
      *                                                                                     MD031008
      ** Decrement Path DS index                                                            MD031008
      *                                                                                     MD031008
     C     P1            OCCUR     ##PATH                                                   MD031008
     C                   CLEAR                   ##GRPS                                     MD031008
     C                   SUB       1             P1                                         MD031008
      *                                                                                     MD031008
      ** Unwind subroutine stack name                                                       MD031008
      *                                                                                     MD031008
     C                   MOVEA     *BLANKS       @STK(Q)                                    MD031008
     C                   SUB       1             Q                                          MD031008
      *                                                                                     MD031008
     C                   ENDSR                                                              MD031008
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  Z97DET                                        *
      *  Function    -  Process: FGE097 - DLCACOPA fields             *
      *                                                               *
      *  Called by   -  ZFGE97                                        *
      *  Calls       -                                                *
      *****************************************************************
     C     Z97DET        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'Z97DET'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'Z97DET'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
     C                   Z-ADD     0             R1                3 0
      *
      ** FGE097 - Interest Amount Accrued
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZFINTA '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FINTA         ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     FCCY          ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** FGE097 - Interest Amount Paid
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZFINTP '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FINTP         ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     FCCY          ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** FGE097 - New Interest Rate
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZFNINT '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FNINT         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** FGE097 - New Principal
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZFNPPL '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FNPPL         ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     FCCY          ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** FGE097 - Old interest rate
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZFOINT '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FOINT         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** FGE097 - Principal change
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZFPCHG '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FPCHG         ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     FCCY          ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** FGE097 - Pay/Receive Flag
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZFPRFL '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FPRFL         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** FGE097 - Capitalisation Indicator
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZFCAPT '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FCAPT         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Deal Type
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZDTYP  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     DTYP          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  CGBRCH                                        *
      *  Function    -  Process : FGE091 - Branch Information         *
      *                                                               *
      *  Called by   -  ZFGE97                                        *
      *  Calls       -                                                *
      *****************************************************************
     C     CGBRCH        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'CGBRCH'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'CGBRCH'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Access branch file to retrieve Branch internal customer
      ** of originating branch of deal
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG    '    ##RTCD            7
     C                   PARM      '*KEY    '    ##OPTN            7
     C                   PARM      ORBR          ##BRCD            3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDBRCHPD'    W0FILE
     C                   MOVEL     BRCA          W0KEY
     C                   Z-ADD     28            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *
      ** Get Customer Details for Branch Internal Customer
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      A8BICN        ##KEY1           10
     C                   PARM      *BLANKS       ##KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     A8BICN        W0KEY
     C                   Z-ADD     29            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *                                                                                     BUG22741
      ** Get Additional Customer Details for Branch Internal Customer                       BUG22741
      *                                                                                     BUG22741
     C                   CALL      'AOACUSR0'                                               BUG22741
     C                   PARM      *BLANKS       ##RTCD                                     BUG22741
     C                   PARM      '*KEY   '     ##OPTN                                     BUG22741
     C                   PARM      A8BICN        ##KEY             6                        BUG22741
     C     SDACUS        PARM      SDACUS        DSSDY                                      BUG22741
      *                                                                                     BUG22741
      ** Database error                                                                     BUG22741
      *                                                                                     BUG22741
     C     ##RTCD        IFNE      *BLANKS                                                  BUG22741
     C                   MOVEL     'SDACUSPD'    W0FILE                                     BUG22741
     C                   MOVEL     A8BICN        W0KEY                                      BUG22741
     C                   Z-ADD     31            W0ERNB                                     BUG22741
     C                   MOVEL     'MEM5004'     W0MSGD                                     BUG22741
     C                   MOVEL     'MIDAS  '     W0MSGF                                     BUG22741
     C                   EXSR      SRERR                                                    BUG22741
     C                   END                                                                BUG22741
      *
      ** Store Booking Branch, Branch Internal Customer Number and Name
      *
     C     *LIKE         DEFINE    BRCA          BBBRCA
     C                   MOVEL     BRCA          BBBRCA
     C     *LIKE         DEFINE    BBCUST        BBBICN
     C                   MOVEL     BBCUST        BBBICN
     C     *LIKE         DEFINE    BBCRNM        BICRNM
     C                   MOVEL     BBCRNM        BICRNM
      *
      ** Get Correspondent Details for Branch Internal Customer
      *
     C     A8BICN        CHAIN     CGCORRL4                           99
      *
      ** If Correspondent not found
      *
     C     *IN99         IFEQ      '1'
      *
      ** Database error
      *
     C                   MOVEL     'CGCORRPD'    W0FILE
     C                   MOVEL     A8BICN        W0KEY
     C                   Z-ADD     30            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Reset arrays
      *
     C                   MOVEL     *BLANKS       ##R
     C                   MOVEL     *BLANKS       ##D
     C                   MOVEL     *BLANKS       ##S
      *
      ** Telex Number
      *
     C     BBSTAD        IFNE      *BLANKS                                                  BUG22741
     C                   MOVEL     BBSTAD        ##D(1)
     C                   ELSE                                                               BUG22741
     C                   MOVEL     E5TXNB        ##D(1)                                     BUG22741
     C                   ENDIF                                                              BUG22741
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZSTAD'      #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(1)
      *
      ** Telephone Number
      *
     C                   MOVEL     BBCTNB        ##D(2)
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZCTNB'      #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(2)
      *
      ** SWIFT Code
      *
     C                   MOVEL     BBCSID        ##D(3)
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZCSID'      #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(3)
      *
      ** German Bankleitzahl
      *
     C                   MOVEL     BBBLCD        ##D(4)
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZBLCD'      #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(4)
      *
      ** Fax Number
      *
     C                   MOVEL     CDFAX         ##D(5)
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZFAX'       #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(5)
      *
      ** Branch Internal Customer Number
      *
     C                   MOVEL     A8BICN        ##D(6)
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BICNBR'      #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(6)
      *
      ** Chips Id (Branch-Internal Customer):
      *
     C                   MOVEL     BBCHID        ##D(7)
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BCHIPS'      #@RDE
     C                   MOVE      '_ID '        #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(7)
      *
      ** Chips ABA (Branch-Internal Customer)
      *
     C     BBCABA        IFNE      0                                                        BUG23572
     C                   MOVEL     BBCABA        ##D(8)
     C                   ELSE                                                               BUG23572
     C                   MOVE      *BLANK        ##D(8)                                     BUG23572
     C                   ENDIF                                                              BUG23572
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BCHIPS'      #@RDE
     C                   MOVE      '_ABA'        #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(8)
      *
      ** Chaps sort code (Branch-Internal Customer)
      *
     C                   MOVEL     BBCHSC        ##D(9)
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BCHAPS'      #@RDE
     C                   MOVE      '_SRT'        #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(9)
      *
      ** BOJ (Branch-Internal Customer)
      *
     C                   MOVEL     BBBFIC        ##D(10)
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BBOJ'        #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(10)
      *
      ** Fedwire (Branch-Internal Customer)
      *
     C                   MOVEL     BBFWCD        ##D(11)
     C                   RESET                   ##RDEF
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BFEDWI'      #@RDE
     C                   MOVE      'RE  '        #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDEF        ##R(11)
      *
      ** Accumulate RDE's and associated data and output to
      ** PF/CGUDTAPD.
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
     C     EXBRC         TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  D@RECS                                        *
      *  Function    -  Process: Receive Settlement Ins               *
      *                                                               *
      *  Called by   -  ZFGE97                                        *
      *  Calls       -                                                *
      *****************************************************************
     C     D@RECS        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'D@RECS'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'D_RECS'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Determine settlement instruction fields
      *
     C                   MOVEL     'R'           ##PYRC                         *Pay/Receive
     C                   MOVEL     FCCY          ##CCY                          *Settlemt currncy
     C                   MOVEL     'N'           ##ROLL                         *Rollover
      *
     C     FSETP         IFNE      00
     C                   MOVEL     FSETP         ##SETP                         *Settlemt type
     C                   MOVEL     FOSAR         ##OURN                         *Our nostro/ A/C
     C                   MOVEL     FTSAR         ##THRN                         *Their nostro
     C                   ELSE
     C                   MOVEL     RSTM          ##SETP                         *Settlemt type
     C                   MOVEL     RONS          ##OURN                         *Our nostro/ A/C
     C                   MOVEL     RIBN          ##THRN                         *Their nostro
     C                   ENDIF
      *
     C                   MOVEL     ROBR          ##STBR                         *Settlemt branch
     C                   MOVEL     *BLANKS       ##FACO                         *For account of
     C                   EXSR      SRDSET
      *
     C                   Z-ADD     0             R1                3 0
      *
      ** 1. Receive - Our A/C - Line 1
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'A1'          #@RDE
     C                   MOVEL     'S_RECOUR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##OAC1        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 2. Receive - Our A/C - Line 2
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'A2'          #@RDE
     C                   MOVEL     'S_RECOUR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##OAC2        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 3. Receive - Our Nostro Name
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'NN'          #@RDE
     C                   MOVEL     'S_RECOUR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##ONN         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 4. Receive - Our Nostro Town
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'NT'          #@RDE
     C                   MOVEL     'S_RECOUR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##ONT         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 5. Receive - Our A/C (Gen.Led.)
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'XG'          #@RDE
     C                   MOVEL     'S_RECOUR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##OGA         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 6. Receive - Our A/C (Retail)
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'XR'          #@RDE
     C                   MOVEL     'S_RECOUR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##ORA         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 7. Receive - Their A/C - Line 1
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'A1'          #@RDE
     C                   MOVEL     'S_RECTHR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##TAC1        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 8. Receive - Their A/C - Line 2
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'A2'          #@RDE
     C                   MOVEL     'S_RECTHR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##TAC2        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 9. Receive - Their Nostro Name
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'NN'          #@RDE
     C                   MOVEL     'S_RECTHR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##TNN         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Receive - Their Nostro Town
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'NT'          #@RDE
     C                   MOVEL     'S_RECTHR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##TNT         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRDSET                                        *
      *  Function    -  Determine Settlement Instruction Fields       *
      *                                                               *
      *  Called by   -  D_RECS, D_PAYS                                *
      *  Calls       -                                                *
      *****************************************************************
     C     SRDSET        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDSET'      @STK(Q)
      *
     C                   CALL      'CG99DSET'                           99      *
      *
      ** In
      *
     C                   PARM                    ##PYRC            1            *Pay/Receive
     C                   PARM                    ##CCY             3            *Settlemt currncy
     C                   PARM                    ##ROLL            1            *Rollover
     C                   PARM                    ##SETP            2            *Settlemt type
     C                   PARM                    ##STBR            3            *Settlemt branch
     C                   PARM                    ##OURN           12            *Our nostro/ A/C
     C                   PARM                    ##THRN            8            *Their nostro
     C                   PARM                    ##FACO            8            *For account of
     C                   PARM      BBBRCA        ##BKBR            3            *Booking  branch
     C                   PARM      BBBICN        ##BKBB            6            *Booking  br BICN
     C                   PARM      ##CUST        ##CNTP            6            *Customer
     C                   PARM      BNACCD        ##CSAC           10            *Compen.Susp. A/C
     C                   PARM      BMACCD        ##CADC           10            *Current A/C dflt
     C                   PARM      BKACCD        ##COMS           10            *Computer Sus A/C
     C                   PARM      BLACCD        ##DEFA           10            *Tradng Dflt A/C
     C                   PARM      BJLCCY        ##LOCY            3            *Local Currency
     C                   PARM      BLONOC        ##ONOC            1            *Ourselves/Nostro
      *
      ** Out
      *
     C                   PARM      *BLANKS       ##OAC1            3            *Our Line 1
     C                   PARM      *BLANKS       ##OAC2            3            *Our Line 2
     C                   PARM      *BLANKS       ##ONN            30            *Our Nostro Name
     C                   PARM      *BLANKS       ##ONT            20            *Our Nostro Town
     C                   PARM      *BLANKS       ##OGA            24            *Our GL A/C
     C                   PARM      *BLANKS       ##ORA            20            *Our RE a/C
     C                   PARM      *BLANKS       ##TAC1            3            *Thr Line 1
     C                   PARM      *BLANKS       ##TAC2            3            *Thr Line 2
     C                   PARM      *BLANKS       ##TNN            30            *Thr Nostro Name
     C                   PARM      *BLANKS       ##TNT            20            *Thr Nostro Town
     C                   PARM      *BLANKS       ##FAL1            3            *FACO Line 1
     C                   PARM      *BLANKS       ##FAL2            3            *FACO Line 2
     C                   PARM      *BLANKS       ##FAN            30            *FACO Name
     C                   PARM      *BLANKS       ##FAT            20            *FACO Town
     C                   PARM      *BLANKS       ##RTCD            7            *Return Code
      *
     C     *IN99         IFEQ      '1'
     C     ##RTCD        ORNE      *BLANKS
      *
      ** Database error
      *
     C                   MOVEL     'CG99DSET'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     14            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  D@PAYS                                        *
      *  Function    -  Process: Payment Settlement Ins               *
      *                                                               *
      *  Called by   -  ZFGE97                                        *
      *  Calls       -                                                *
      *****************************************************************
     C     D@PAYS        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'D@PAYS'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'D_PAYS'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Determine settlement instruction fields
      *
     C                   MOVEL     'P'           ##PYRC                         *Pay/Receive
     C                   MOVEL     FCCY          ##CCY                          *Settlemt currncy
     C                   MOVEL     'N'           ##ROLL                         *Rollover
      *
     C     FPSET         IFNE      00
     C                   MOVEL     FPSET         ##SETP                         *Settlemt type
     C                   MOVEL     FOSAP         ##OURN                         *Our nostro/ A/C
     C                   MOVEL     FFACO         ##FACO                         *For account of
     C                   MOVEL     FISEP         ##THRN                         *Their nostro
     C                   ELSE
     C                   MOVEL     PSTM          ##SETP                         *Settlemt type
     C                   MOVEL     PONS          ##OURN                         *Our nostro/ A/C
     C                   MOVEL     BENN          ##FACO                         *For account of
     C     RVNO          IFNE      *BLANKS                                      * RECEIVING MT100
     C     RCRN          IFNE      *BLANKS                                      * RECEIVER CORRES
     C                   MOVEL     RCRN          ##THRN                         *Their nostro
     C                   ELSE
     C                   MOVEL     *HIVAL        ##THRN                         *Their nostro
     C                   END                                                     = OUR NOSTRO
     C                   ELSE
     C                   MOVEL     AWBN          ##THRN                         *Their nostro
     C                   END
      *
     C                   ENDIF
     C                   MOVEL     POBR          ##STBR                         *Settlemt branch
      *
     C                   EXSR      SRDSET
      *
     C                   Z-ADD     0             R1                3 0
      *
      ** 1. Payment - Our A/C - Line 1
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'A1'          #@RDE
     C                   MOVEL     'S_PAYOUR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##OAC1        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 2. Payment - Our A/C - Line 2
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'A2'          #@RDE
     C                   MOVEL     'S_PAYOUR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##OAC2        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 3. Payment - Our Nostro Name
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'NN'          #@RDE
     C                   MOVEL     'S_PAYOUR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##ONN         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 4. Payment - Our Nostro Town
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'NT'          #@RDE
     C                   MOVEL     'S_PAYOUR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##ONT         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 5. Payment - Our A/C (Gen.Led.)
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'XG'          #@RDE
     C                   MOVEL     'S_PAYOUR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##OGA         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 6. Payment - Our A/C (Retail)
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'XR'          #@RDE
     C                   MOVEL     'S_PAYOUR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##ORA         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 7. Payment - Their A/C - Line 1
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'A1'          #@RDE
     C                   MOVEL     'S_PAYTHR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##TAC1        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 8. Payment - Their A/C - Line 2
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'A2'          #@RDE
     C                   MOVEL     'S_PAYTHR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##TAC2        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 9. Payment - Their Nostro Name
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'NN'          #@RDE
     C                   MOVEL     'S_PAYTHR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##TNN         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 10. Payment - Their Nostro Town
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'NT'          #@RDE
     C                   MOVEL     'S_PAYTHR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##TNT         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 11. Payment - For A/C Of - Line 1
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'L1'          #@RDE
     C                   MOVEL     'S_PAYZFA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##FAL1        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 12. Payment - For A/C Of - Line 2
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'L2'          #@RDE
     C                   MOVEL     'S_PAYZFA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##FAL2        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 13. Payment - For A/C Of Name
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'ON'          #@RDE
     C                   MOVEL     'S_PAYZFA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##FAN         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 14. Payment - For A/C Of Town
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'OT'          #@RDE
     C                   MOVEL     'S_PAYZFA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##FAT         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  D@LADS                                        *
      *  Function    -  Process: Loan & Deposit Settlemnt Detls       *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     D@LADS        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'D@LADS'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'D_LADS'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve the currency details.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ##RTCD                         B:Return Cd
     C                   PARM      '*KEY'        ##OPTN                         I:Option
     C                   PARM      FCCY          ##CCYP            3            I:Currency Code
     C     SDCURR        PARM      *BLANKS       DSSDY                          O:Format
      *
      ** Database Error
      *
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     FCCY          W0KEY
     C                   Z-ADD     18            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   Z-ADD     0             R1                3 0
      *
      ** 1. Currency Description
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CCY_DESC'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     A6CYNM        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 2. Deal Confirmation Narrative
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CONFNARR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     CNNA          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 3. Deal Currency
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CURRENCY'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     CCY           R#DATA                         from DEALSDCF
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 4. Gross Interest
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'ST'          #@RDE
     C                   MOVEL     'GRS INTR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     *ZEROS        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     FCCY          ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 5. Interest Rate
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT RATE'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     INTR          ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 6. Loan/Deposit indicator
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'OS'          #@RDE
     C                   MOVEL     'LOAN/DEP'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   Z-ADD     1             #A                1 0
     C     DTYP          LOOKUP    #LN(#A)                                99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'L'           R#DATA
     C                   ELSE
     C                   MOVEL     'D'           R#DATA
     C                   END
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 7. Last interest payment date
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'LST IPDA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     SLID          ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 8. Net Interest
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'ST'          #@RDE
     C                   MOVEL     'NET INTR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     *ZEROS        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     FCCY          ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 9.Next Interest Payment Date = Event date
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'NXT IPDA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FVDAT         ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 10.Precious Metal Indicator
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'IN'          #@RDE
     C                   MOVEL     'PREC_MET'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     A6PMRT        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 11.Principal
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'L '          #@RDE
     C                   MOVEL     'PRINCIPA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C     FNPPL         SUB       FPCHG         UFPRIN           13 0
     C                   MOVEL     UFPRIN        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     FCCY          ##CCY
      *
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 12.Tax
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'TAX     '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     *ZEROS        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     FCCY          ##CCY
      *
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 13.Tax Indicator
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'TAXI    '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     TAXI          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  D@BASM                                        *
      *  Function    -  Process: Base Deal Event Details              *
      *                                                               *
      *  Called by   -  ZFGE97                                        *
      *  Calls       -                                                *
      *****************************************************************
     C     D@BASM        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'D@BASM'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'D_BASM'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
     C                   Z-ADD     0             R1                3 0
      *
      ** 1. Deal Date
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'E '          #@RDE
     C                   MOVEL     'DEAL DAT'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     DDAT          ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 2. Deal Number
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'ER'          #@RDE
     C                   MOVEL     'DEALNUMB'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FDLNO         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 3. Event Date
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'EVENT_DA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FVDAT         ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  CUST                                          *
      *  Function    -  Process: Customer Details                     *
      *                                                               *
      *  Called by   -  ZFGE97                                        *
      *  Calls       -                                                *
      *****************************************************************
     C     CUST          BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'CUST  '      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'CUST  '      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Access Customer Details
      ** (LF/SDCUSTL1)
      *
     C                   MOVEL     CNUM          UFKEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       UFRTCD            7
     C                   PARM      '*KEY   '     UFOPTN            7
     C                   PARM                    UFKEY1           10
     C                   PARM      *BLANKS       UFKYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** If not found, Database Error.
      *
     C     UFRTCD        IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     CNUM          W0KEY
     C                   Z-ADD     15            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Store Customer Name
      *
     C     *LIKE         DEFINE    BBCRNM        CPCRNM
     C                   MOVEL     BBCRNM        CPCRNM
      *
     C                   Z-ADD     0             R1                3 0
      *
      ** Customer address line 1
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      '1 '          #@RDE
     C                   MOVEL     'CUST_ADR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCNA1        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Customer address line 2
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      '2 '          #@RDE
     C                   MOVEL     'CUST_ADR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCNA2        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Customer address line 3
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      '3 '          #@RDE
     C                   MOVEL     'CUST_ADR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCNA3        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Customer address line 4
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      '4 '          #@RDE
     C                   MOVEL     'CUST_ADR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCNA4        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Customer Name
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'E '          #@RDE
     C                   MOVEL     'CUST_NAM'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCRNM        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Customer Number
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUSTOMER'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCUST        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Customer Town
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUST_TOW'    #@RDE
     C                   MOVE      'N '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCRTN        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  BROKER                                        *
      *  Function    -  Process: Broker Details                       *
      *                                                               *
      *  Called by   -  ZFGE97                                        *
      *  Calls       -                                                *
      *****************************************************************
     C     BROKER        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'BROKER'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'BROKER'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Get Broker Details
      *
     C     BRKC          IFNE      ##BROK
      *
     C     BRKC          IFNE      'TELX'
     C     BRKC          ANDNE     'PHON'
     C     BRKC          ANDNE     'MAIL'
     C     BRKC          ANDNE     'SWAP'
     C                   CALL      'AOBROKR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      BRKC          ##BROK            4
     C     SDBROK        PARM      SDBROK        DSFDY
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDBROKPD'    W0FILE
     C                   MOVEL     BRKC          W0KEY
     C                   Z-ADD     16            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
     C                   END
      *
     C                   Z-ADD     0             R1                3 0
      *
      ** Broker (Code)
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BROKER  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BRKC          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Broker Name
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'AM'          #@RDE
     C                   MOVEL     'BROKER N'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   SELECT
     C     A9BROK        WHENEQ    'TELX'
     C                   MOVEL     'Telex'       R#DATA
     C     A9BROK        WHENEQ    'PHON'
     C                   MOVEL     W#PHON        R#DATA
     C     A9BROK        WHENEQ    'MAIL'
     C                   MOVEL     'Mail'        R#DATA
     C                   OTHER
     C                   MOVEL     A9BKNM        R#DATA
     C                   ENDSL
      *
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Broker Town
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'WN'          #@RDE
     C                   MOVEL     'BROKER T'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   SELECT
     C     A9BROK        WHENEQ    'TELX'
     C     A9BROK        OREQ      'PHON'
     C     A9BROK        OREQ      'MAIL'
     C                   MOVEL     *BLANKS       R#DATA
     C                   OTHER
     C                   MOVEL     A9BRTN        R#DATA
     C                   ENDSL
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  BRANCH                                        *
      *  Function    -  Process: Branch Details                       *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     BRANCH        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'BRANCH'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'BRANCH'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Get Branch Details
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG    '    UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      FBRCA         UFBRCD            3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      ** Database Error
      *
     C     UFRTCD        IFNE      *BLANKS
     C                   MOVEL     'SDBRCHPD'    W0FILE
     C                   MOVEL     FBRCA         W0KEY
     C                   Z-ADD     17            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   Z-ADD     0             R1                3 0
      *
      ** Branch (Code)
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BRANCH  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     A8BRCD        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Branch Name
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'AM'          #@RDE
     C                   MOVEL     'BRANCH N'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     A8BRNM        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRINZ                                         *
      *  Function    -  Initialise Fields on Program Invocation       *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -                                                *
      *****************************************************************
     C     SRINZ         BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRINZ '      @STK(Q)
      *
      ** Initialise work fields
      *
     C                   Z-ADD     *ZEROS        ##W050            5 0
     C                   Z-ADD     *ZEROS        ##W150           15 0
     C                   Z-ADD     *ZEROS        ##W157           15 7
     C                   Z-ADD     *ZEROS        #1                6 0
     C                   Z-ADD     *ZEROS        #2                6 0
     C                   Z-ADD     *ZEROS        #3                6 0
     C                   MOVE      *BLANKS       S#PATH          256
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
      *
      ** Initialise output sequence (to CGUDTAPD)
      *
     C                   Z-ADD     *ZEROS        ##OSEQ
      *
      ** DJU Additions for CG4999 1st version **
      *
     C                   MOVE      *BLANKS       #@RDE            10
     C     *LIKE         DEFINE    ##TBIN        #@TBIN
      *
     C     1             OCCUR     ##BIND
     C                   RESET                   ##BIND
     C                   RESET                   #@BIND
     C                   RESET                   #PDS
      *
      ** Initialise XML increment
      *
     C                   EXSR      INIXML
      *
     C     EXINZ         TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  EX@REC                                        *
      *  Function    -  Other receipt settlement instructions         *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     EX@REC        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'EX@REC'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'ex_rec'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Set up data.
      *
     C                   EXSR      MOVDTB
      *
     C                   CALL      'CG4975'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM                    P6PARM
     C                   PARM                    P4PARM          140            Path
     C                   PARM                    W0CMT             3
     C                   PARM                    P5PARM
     C                   PARM                    ##REFR
     C                   PARM                    P@ICR
     C                   PARM      'N'           ##MAST
      *
      ** Reset Sequence number.
      *
     C                   Z-ADD     R1OSEQ        ##OSEQ
     C                   Z-ADD     R1TBIN        DETBIN
     C                   Z-ADD     R1PBIN        DEPBIN
      *
     C                   EXSR      POPGRS
      *
     C     EXXREC        TAG
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  EX@PAY                                        *
      *  Function    -  Other payment settlement instructions         *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     EX@PAY        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'EX@PAY'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'ex_pay'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Set up data.
      *
     C                   EXSR      MOVDTA
      *
     C                   CALL      'CG4985'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM                    P1PARM
     C                   PARM                    P2PARM          140            Path
     C                   PARM                    W0CMT             3
     C                   PARM                    P3PARM
     C                   PARM                    ##REFR
     C                   PARM                    P@ICR
     C                   PARM      'N'           ##MAST
      *
      ** Reset Sequence number.
      *
     C                   Z-ADD     P1OSEQ        ##OSEQ
     C                   Z-ADD     P1TBIN        DETBIN
     C                   Z-ADD     P1PBIN        DEPBIN
      *
     C                   EXSR      POPGRS
      *
     C     EXXPAY        TAG
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      *  Subroutine  -  MOVDTA                                        *
      *  Function    -  Set up parameters for call to CG4985.         *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     MOVDTA        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MOVDTA'      @STK(Q)
      *
     C                   CLEAR                   P1PARM
     C     FPSET         IFNE      00
     C                   Z-ADD     FPSET         P1PSTM
     C                   MOVEL     FOSAP         P1PONS
     C                   ELSE
     C                   Z-ADD     PSTM          P1PSTM
     C                   MOVEL     PONS          P1PONS
     C                   END
     C                   MOVEL     PIBN          P1PIBN
     C                   MOVEL     PIBA          P1PIBA
     C**********           Z-ADDPOBN      P1POBN                                              CER059
     C**********           Z-ADDPOCN      P1POCN                                              CER059
     C                   MOVEL     POBN          P1POBN                                       CER059
     C                   MOVEL     POCN          P1POCN                                       CER059
     C                   MOVEL     RCRN          P1RCRN
     C                   MOVEL     RCRA          P1RCRA
     C                   MOVEL     RVNO          P1RVNO
     C                   MOVEL     AWBN          P1AWBN
     C                   MOVEL     AWBA          P1AWBA
     C                   MOVEL     BENN          P1BENN
     C                   MOVEL     BENA          P1BENA
     C                   MOVEL     DTP1          P1DTP1
     C                   MOVEL     DTP2          P1DTP2
     C                   MOVEL     DTP3          P1DTP3
     C                   MOVEL     DTP4          P1DTP4
     C                   MOVEL     DCHG          P1DCHG
     C                   MOVEL     BTB1          P1BTB1
     C                   MOVEL     BTB2          P1BTB2
     C                   MOVEL     BTB3          P1BTB3
     C                   MOVEL     BTB4          P1BTB4
     C                   MOVEL     BTB5          P1BTB5
     C                   MOVEL     BTB6          P1BTB6
      *
      ** If EMU CEU003 is installed, use settlement currency if
      ** defined.
      *
     C     CEU003        IFEQ      'Y'
     C     STCY          ANDNE     *BLANKS
     C                   MOVEL     STCY          P1CCY
     C                   ELSE
     C                   MOVEL     CCY           P1CCY
     C                   ENDIF
      *
     C                   CLEAR                   P2PARM
     C                   MOVEL     S#PATH        P2PARM
      *
     C                   CLEAR                   P3PARM
     C                   Z-ADD     ##OSEQ        P1OSEQ
     C                   Z-ADD     ##ITEM        P1ITEM
     C                   Z-ADD     DETBIN        P1TBIN
     C                   Z-ADD     DEPBIN        P1PBIN
      *
     C                   MOVEL     POBR          P1BRCH
     C                   MOVEL     CNUM          P1CNUM
     C                   MOVEL     BMACCD        P1ACCD
      *
     C     EXVDTA        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  MOVDTB                                        *
      *  Function    -  Set up parameters for call to CG4975.         *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     MOVDTB        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MOVDTB'      @STK(Q)
      *
     C                   CLEAR                   P6PARM
     C     FSETP         IFNE      00
     C                   Z-ADD     FSETP         P1RSTM
     C                   MOVEL     FOSAR         P1RONS
     C                   ELSE
     C                   Z-ADD     RSTM          P1RSTM
     C                   MOVEL     RONS          P1RONS
     C                   END
     C                   MOVEL     RIBN          P1RIBN
     C                   MOVEL     RIBA          P1RIBA
     C**********           Z-ADDROBN      P1ROBN                                              CER059
     C**********           Z-ADDROCN      P1ROCN                                              CER059
     C                   MOVEL     ROBN          P1ROBN                                       CER059
     C                   MOVEL     ROCN          P1ROCN                                       CER059
     C                   MOVEL     ROBR          R1BRCH
      *
      ** If EMU CEU003 is installed, use settlement currency if
      ** defined.
      *
     C     CEU003        IFEQ      'Y'
     C     STCY          ANDNE     *BLANKS
     C                   MOVEL     STCY          R1CCY
     C                   ELSE
     C                   MOVEL     CCY           R1CCY
     C                   ENDIF
      *
     C                   CLEAR                   P4PARM
     C                   MOVEL     S#PATH        P4PARM
      *
     C                   CLEAR                   P5PARM
     C                   Z-ADD     ##OSEQ        R1OSEQ
     C                   Z-ADD     ##ITEM        R1ITEM
     C                   Z-ADD     DETBIN        R1TBIN
     C                   Z-ADD     DEPBIN        R1PBIN
      *
      ** 087000 - set up details for primary retail account
      *
     C                   MOVEL     CNUM          R1CNUM
     C                   MOVEL     BMACCD        R1ACCD
      *
     C     EXVDTB        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRINIT                                        *
      *  Function    -  Initial processing - First Call Only          *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -  None                                          *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      ** Call access program for Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*FIRST  '    ##OPTN            7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
     C     ##RTCD        IFNE      *BLANKS
      *
      ** Database error
      *
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     01            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     BJDFIN        COMP      'M'                                    98    MMDDYY, 98 ON
      *
      ** Determine Number of decimal places - Base currency
      *
     C                   MOVEL     BJCYCD        ##CCY
     C                   EXSR      SRDCDT
     C                   Z-ADD     A6NBDP        BASCDP            1 0
      *
      ** Call access program for General Ledger Details
      *
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
     C     ##RTCD        IFNE      *BLANKS
      *
      ** Database error
      *
     C                   MOVEL     'AOGELRR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     02            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Call access program for Midas Modules Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDMMOD        PARM      SDMMOD        DSSDY
      *
     C     ##RTCD        IFNE      *BLANKS
      *
      ** Database error
      *
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     03            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Call acces program for Securities Trading Data Details
      *
     C     BGSECS        IFEQ      'Y'
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
     C     ##RTCD        IFNE      *BLANKS
      *
      ** Database error
      *
     C                   MOVEL     'AOSTRDR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     04            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   ENDIF
      *
      ** Call access program for trading data details
      *
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDTRAD        PARM      SDTRAD        DSSDY
      *
     C     ##RTCD        IFNE      *BLANKS
      *
      ** Database error
      *
     C                   MOVEL     'AOTRADR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     05            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Call access program for Dealing data details
      *
     C     BGDLMM        IFEQ      'Y'
     C     BGDLFX        OREQ      'Y'
     C                   CALL      'AODEALR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDDEAL        PARM      SDDEAL        DSSDY
      *
     C     ##RTCD        IFNE      *BLANKS
      *
      ** Database error
      *
     C                   MOVEL     'AODEALR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     06            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Call access program for Retail details
      *
     C     BGRTBN        IFEQ      'Y'
     C     BGIOAC        OREQ      'Y'
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDRETL        PARM      SDRETL        DSSDY
      *
     C     ##RTCD        IFNE      *BLANKS
      *
      ** Database error
      *
     C                   MOVEL     'AORETLR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     07            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Call access program for Message Management Details
      *
     C     BGNWMI        IFEQ      'Y'
     C                   CALL      'AOMGMER0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDMGME        PARM      SDMGME        DSSDY
      *
     C     ##RTCD        IFNE      *BLANKS
      *
      ** Database error
      *
     C                   MOVEL     'AOMGMER0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     08            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Call access program for Funds Transfer Details
      *
     C     BGFDTR        IFEQ      'Y'
     C                   CALL      'AOFTFRR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDFTFR        PARM      SDFTFR        DSSDY
      *
     C     ##RTCD        IFNE      *BLANKS
      *
      ** Database error
      *
     C                   MOVEL     'AOFTFRR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     09            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Check for CEU003 = EMU Dealing Settlement Currency Conversion
      *
     C     *LIKE         DEFINE    @SARD         ##SARD
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU003'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU003            1
     C                   ELSE
     C                   MOVE      'N'           CEU003
     C                   ENDIF
     C/COPY WNCPYSRC,CG4010CP14
      *
      ** Access Switchable Features file and check if CCG015 is
      ** installed (Correspondence Manager)
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CCG015'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     ##RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CCG015            1
     C                   ELSE
     C                   MOVE      'N'           CCG015
      *
     C     ##RTCD        IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL   '    W0KEY
     C                   Z-ADD     19            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access Switchable Features file and check if CER038 is
      ** installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CER038'      PSARD             6
      *
     C     PRTCD         IFEQ      ' '
     C                   MOVE      'Y'           CER038            1
     C                   ELSE
     C                   MOVE      'N'           CER038
     C                   ENDIF
      *                                                                                     MD029242
      ** If CER038 is switched on, check if Suppress Correspondence for                     MD029242
      ** Customer with Swift ID is 'Y/N'                                                    MD029242
      *                                                                                     MD029242
     C     CER038        IFEQ      'Y'                                                      MD029242
     C                   MOVEL     *BLANKS       SUPCON            1                        MD029242
     C                   CALL      'AOSVALR0'                                               MD029242
     C                   PARM                    P@RTCD            7                        MD029242
     C                   PARM      #SUPRS        P@OP01           20                        MD029242
     C     SVAL1         PARM                    P@VL01          200                        MD029242
     C                   PARM      *BLANK        P@OP02           20                        MD029242
     C                   PARM                    P@VL02          200                        MD029242
     C                   PARM      *BLANK        P@OP03           20                        MD029242
     C                   PARM                    P@VL03          200                        MD029242
     C                   PARM      *BLANK        P@OP04           20                        MD029242
     C                   PARM                    P@VL04          200                        MD029242
     C                   PARM      *BLANK        P@OP05           20                        MD029242
     C                   PARM                    P@VL05          200                        MD029242
     C                   PARM      *BLANK        P@OP06           20                        MD029242
     C                   PARM                    P@VL06          200                        MD029242
     C                   PARM      *BLANK        P@OP07           20                        MD029242
     C                   PARM                    P@VL07          200                        MD029242
     C                   PARM      *BLANK        P@OP08           20                        MD029242
     C                   PARM                    P@VL08          200                        MD029242
     C                   PARM      *BLANK        P@OP09           20                        MD029242
     C                   PARM                    P@VL09          200                        MD029242
     C                   PARM      *BLANK        P@OP10           20                        MD029242
     C                   PARM                    P@VL10          200                        MD029242
      *                                                                                     MD029242
     C     P@RTCD        IFNE      *BLANKS                                                  MD029242
     C     P@RTCD        ANDNE     '*NRF   '                                                MD029242
     C                   MOVEL     'SDSVALPD'    W0FILE                         ************MD029242
     C                   MOVEL     '*CALL'       W0KEY                          * DBERROR50 MD029242
     C                   Z-ADD     50            W0ERNB                         ************MD029242
     C                   MOVEL     'MEM5003'     W0MSGD                                     MD029242
     C                   MOVEL     'MIDAS  '     W0MSGF                                     MD029242
     C                   EXSR      SRERR                                                    MD029242
     C                   ENDIF                                                              MD029242
      *                                                                                     MD029242
     C     P@RTCD        IFEQ      *BLANKS                                                  MD029242
     C                   MOVEL     SVAL11        SUPCON                                     MD029242
     C                   ENDIF                                                              MD029242
      *                                                                                     MD029242
     C                   ENDIF                                                              MD029242
      *                                                                                     MD031008
      ** Check if CDL094 is ON                                                              MD031008
      *                                                                                     MD031008
     C                   CALL      'AOSARDR0'                                               MD031008
     C                   PARM      *BLANKS       @RTCD                                      MD031008
     C                   PARM      '*VERIFY'     @OPTN                                      MD031008
     C                   PARM      'CDL094'      @SARD                                      MD031008
     C                   PARM                    DSFDY                                      MD031008
      *                                                                                     MD031008
     C     @RTCD         IFNE      *BLANKS                                                  MD031008
     C     @RTCD         ANDNE     '*NRF    '                                               MD031008
     C                   MOVEL     'SCSARDPD'    W0FILE                                     MD031008
     C                   MOVEL     'CDL094'      W0KEY                                      MD031008
     C                   Z-ADD     51            W0ERNB                                     MD031008
     C                   MOVEL     'MEM5004'     W0MSGD                                     MD031008
     C                   MOVEL     'MIDAS  '     W0MSGF                                     MD031008
     C                   EXSR      SRERR                                                    MD031008
     C                   ENDIF                                                              MD031008
      *                                                                                     MD031008
     C     @RTCD         IFEQ      *BLANKS                                                  MD031008
     C                   MOVE      'Y'           CDL094            1                        MD031008
     C                   ELSE                                                               MD031008
     C                   MOVE      'N'           CDL094                                     MD031008
     C                   ENDIF                                                              MD031008
      *
     C     EXINIT        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
      /SPACE 5
      *****************************************************************
      *  Subroutine  -  SRADTA                                        *
      *  Function    -  Accumulate RDEs and associated data for output*
      *                                                               *
      *  Called by   -  Simple group set subroutines                  *
      *  Calls       -  CG3999 - Format and Pack Data                 *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     SRADTA        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRADTA'      @STK(Q)
      *
      ** Reformat RDE data
      *
     C                   EXSR      SRRFMN
      *
      ** Pack RDEs and associated data into data string
      *
     C                   CLEAR                   ##SDS
      *
      ** If FGE200 is installed, value of W0ACT is '*NEWARR'
      *
     C     CCG015        IFEQ      'Y'
     C                   MOVEL     '*NEWARR '    W0ACT
     C                   MOVEL     S#PATH        W0SPAT
     C                   ELSE
     C                   MOVEL     '*PACK   '    W0ACT
     C                   MOVEL     *BLANKS       W0SPAT
     C                   ENDIF
      *
     C                   CALL      'CG3999'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM                    W0ACT
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT           70
     C                   PARM                    ##RN
     C                   PARM                    ##DN
     C                   PARM                    ##FM
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANKS
      *
     C                   MOVEL     'CG3999  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY
     C                   Z-ADD     10            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   EXSR      WRTRDE
      *
      ** Append Data from pack routine.
      *
     C     #@SDS         CAT       ##SDS:0       #@SDS
      *
     C                   MOVEL     *BLANKS       ##R
     C                   MOVEL     *BLANKS       ##D
     C                   MOVEL     *BLANKS       ##S
      *
     C     EXADTA        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Subroutine  -  SRODTA                                        *
      *  Function    -  Output Accumulated data to PF/CGUDTAPD        *
      *                                                               *
      *  Called by   -  Simple group set subroutines                  *
      *  Calls       -  CG9020 - Output Data to CGUDTAPD              *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     SRODTA        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRODTA'      @STK(Q)
      *
      ** Initialise Write Format Parameter.
      *
     C                   CLEAR                   W0FMT
      *
      ** Set up Control Information.
      *
     C                   Z-ADD     ##ITEM        DEITEM
     C                   ADD       1             ##OSEQ
     C                   Z-ADD     ##OSEQ        DEOSEQ
     C                   Z-ADD     ##PBIN        DEPBIN
     C                   Z-ADD     ##TBIN        DETBIN
     C                   MOVE      'FR'          DEFSLI
     C                   MOVE      *BLANKS       W0PATH
     C                   MOVEL     S#PATH        W0PATH
      *
      ** Append Data from pack routine.
      *
     C     W0FMT         CAT       #@SDS:0       W0FMT
      *
      ** Output PF/CGUDTAPD Record.
      *
     C     CCG015        IFEQ      'N'
     C                   CALL      'CG9020'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*WRITE  '    W0ACT
     C                   PARM                    W0PATH          256
     C                   PARM                    W0FMT
     C                   PARM      *BLANKS       W0TITL            7
     C                   PARM      *BLANKS       W0ULIN            7
     C                   PARM                    W0CMT
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANKS
      *
     C                   MOVEL     'CG9020  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY
     C                   Z-ADD     20            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
     C                   CLEAR                   #@SDS
      *
     C     EXODTA        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRBIND                                        *
      *  Function    -  Generate Binding numbers                      *
      *                                                               *
      *  Called by   -  All Repeating Group Set Subroutines           *
      *  Calls       -                                                *
      *****************************************************************
     C     SRBIND        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRBIND'      @STK(Q)
      *
     C     P1            SUB       1             P2
     C     P2            OCCUR     ##BIND
      *
     C                   Z-ADD     ##TBIN        #@TBIN
     C     P1            OCCUR     ##BIND
     C                   Z-ADD     #@TBIN        ##PBIN
      *
     C                   ADD       1             #@BIND
     C                   Z-ADD     #@BIND        ##TBIN
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRPATH                                        *
      *  Function    -  Generate Path String /GS1/GS2...              *
      *                                                               *
      *  Called by   -  All Group Set subroutines                     *
      *  Calls       -                                                *
      *****************************************************************
     C     SRPATH        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPATH'      @STK(Q)
      *
     C                   CLEAR                   S#PATH
      *
     C                   DO        P1            P2
     C     P2            OCCUR     ##PATH
     C     S#PATH        CAT       '\':0         S#PATH
     C     S#PATH        CAT       ##GRPS:0      S#PATH
     C                   END
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Subroutine  -  SRRFMN                                        *
      *  Function    -  Reformat RDE data                             *
      *                                                               *
      *  Called by   -  SRADTA                                        *
      *  Calls       -                                                *
      *****************************************************************
     C     SRRFMN        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRFMN'      @STK(Q)
      *
      ** Loop through RDE's and data
      *
     C                   Z-ADD     0             #1
     C     #1            DOUEQ     20
     C                   ADD       1             #1
     C                   MOVEL     ##R(#1)       R#DEFN
     C                   MOVEL     ##D(#1)       R#DATA
      *
      ** If data present and RDE is edited
      *
     C     R#DATA        IFNE      *BLANKS
     C     ##RDEC        ANDNE     *BLANKS
      *
      ** Reformat Amount
      *
     C                   Z-ADD     1             #2
     C     *BLANKS       LOOKUP    ##NUMA(#2)                             99    *
     C                   Z-ADD     20            #3
     C                   Z-ADD     0             ##WNUM
     C     #2            DOWGT     1
     C     #2            ANDLE     20
     C     #3            ANDGT     1
     C                   SUB       1             #2
     C                   MOVEL     ##NUMA(#2)    ##W(#3)
     C                   SUB       1             #3
     C                   ENDDO
      *
      ** Sign the amount
      *
     C     ##SIGN        IFEQ      '-'
     C                   Z-SUB     ##WNUM        ##NUMB
     C                   ELSE
     C                   Z-ADD     ##WNUM        ##NUMB
     C                   END
      *
      ** Default Edit Type
      *
     C     ##EDTT        IFEQ      *BLANKS
     C                   MOVEL     ##RDET        ##EDTT
     C                   END
      *
      ** Default Decimal Places
      *
     C     ##DCPA        IFEQ      *BLANKS
     C                   MOVEL     ##RDED        ##DCPA
     C                   END
      *
      ** New RDE data
      *
     C                   MOVEL     R#DATA        ##D(#1)
     C                   ENDIF
     C                   ENDDO
      *
     C     EXRFMN        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRDCDT                                        *
      *  Function    -  Determine Currency Details                    *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     SRDCDT        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDCDT'      @STK(Q)
      *
      ** Access array of Currency Details already loaded
      *
     C                   Z-ADD     1             C                 3 0
     C     ##CCY         LOOKUP    ##CY(C)                                99
      *
      ** If no match is found determine the next free space in the
      ** loaded currency array.
      *
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     1             C
     C     *BLANKS       LOOKUP    ##CY(C)                                99
      *
      ** If no space is left, set the Currency Data data structure to
      ** the 101st occurrence so that when the new details are
      ** retrieved no existing details are overwritten.
      *
     C     *IN99         IFEQ      *OFF
     C     101           OCCUR     SDCURR
      *
      ** If a space is found, set up the new currency into the array
      ** and position the Currency Data data structure on the
      ** occurrence matching the array index.
      *
     C                   ELSE
     C                   MOVE      ##CCY         ##CY(C)
     C     C             OCCUR     SDCURR
     C                   ENDIF
      *
      ** Retrieve the currency details.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ##RTCD                         B:Return Cd
     C                   PARM      '*KEY'        ##OPTN                         I:Option
     C                   PARM      ##CCY         ##CCYP            3            I:Currency Code
     C     SDCURR        PARM      *BLANKS       DSSDY                          O:Format
      *
      ** Database Error
      *
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     ##CCY         W0KEY
     C                   Z-ADD     24            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** If the currency has been retrieved earlier, position the
      ** Currency Data data structure on the relevant occurrence.
      *
     C                   ELSE
     C     C             OCCUR     SDCURR
     C                   ENDIF
      *
     C     EXDCDT        TAG
      *
      ** Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRGENR                                        *
      *  Function    -  Generate reference number                     *
      *                by writing to PF/CGUDCRPD                      *
      *                                                               *
      *  Called by   -  SRMAIN - Main Processing                      *
      *  Calls       -  CG9010 - Create reference record              *
      *****************************************************************
     C     SRGENR        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRGENR'      @STK(Q)
      *
      ** Generate reference number and check if further processing
      ** required. Set up all available information in the record
      ** format before calling.
      *
     C                   CLEAR                   ##UDCR
      *
      ** Booking/Main Branch (Mandatory)
      *
     C                   MOVEL     BRCA          DRBRCA
      *
      ** Originating Branch (Optional)
      *
     C                   MOVEL     ORBR          DRORBR
      *
      ** Module identifier (Mandatory)
      *
     C                   MOVEL     'DL'          DRMODI
      *
      ** Midas Transaction Number (Mandatory)
      *
     C                   MOVEL     DLNO          DRMTRN
      *
      ** Midas GL Account Reference CNUMCCYACODACSQBRCA  (Optional)
      *
     C                   MOVEL     *BLANKS       DRMACT
      *
     C                   MOVEL     W#PTYP        DRPTYP                         * print type
     C                   MOVEL     W#PSTY        DRPSTP                         * print s/type
      *
      ** Customer Number (Mandatory)
      *
     C                   MOVEL     CNUM          ##CUST
      *
     C                   CALL      'CG9010'
     C                   PARM                    ##RTCD            7
     C                   PARM      '*GEN'        ##MODE           10
     C                   PARM      W0CMT         ##CMT             3
     C                   PARM                    ##CUST            6
     C                   PARM                    ##UDCR
     C                   PARM                    ##ITMA            8
      *
      ** Blank return code implies generate correspondence.
      ** CGD1270 => no error, but suppress output for this transaction.
      *
     C     ##RTCD        IFEQ      *BLANKS
     C     DRPTYP        CAT(P)    ':':0         COLON            11
     C     COLON         CAT(P)    DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
     C                   END
      *
     C     ##RTCD        IFEQ      *BLANKS
      *
     C                   MOVE      'Y'           ##COPD
      *
     C                   ELSE
      *
     C     ##RTCD        IFNE      'CGD1270'
     C                   MOVEL     'CG9010  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY
     C                   Z-ADD     22            W0ERNB
     C                   MOVEL     'CGD1286'     W0MSGD
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
     C     EXGENR        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRAUTO                                        *
      *  Function    -  Auto transmission processing                  *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     SRAUTO        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRAUTO'      @STK(Q)
      *
      ** Get Branch Details
      *
     C     BRCA          IFNE      ##BRCD
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG    '    ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM      BRCA          ##BRCD            3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDBRCHPD'    W0FILE
     C                   MOVEL     BRCA          W0KEY
     C                   Z-ADD     27            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Get Customer Details for Branch Internal Customer
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      A8BICN        ##KEY1           10
     C                   PARM      *BLANKS       ##KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     A8BICN        W0KEY
     C                   Z-ADD     28            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Store Booking Branch, Branch Internal Customer Number and Name
      *
     C                   MOVEL     BRCA          BBBRCA
     C                   MOVEL     BBCUST        BBBICN
     C                   MOVEL     BBCRNM        BICRNM
      *
      ** Store : Sender's (i.e. Branch)
      **         SWIFT TID Address,
      **         STTX Address
      **         Telex Address
      ** (All used in message routing)
      *
     C                   MOVEL     A8BTID        ##SCSD
     C                   MOVEL     BBSTAD        ##SSTD
     C                   MOVEL     BBTXA1        ##STXA
      *
      ** Get Customer Details
      *
     C                   MOVEL     CNUM          ##KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM                    ##KEY1
     C                   PARM      *BLANKS       ##KYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     CNUM          W0KEY
     C                   Z-ADD     29            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Store Customer Name
      *
     C                   MOVEL     BBCRNM        CPCRNM
      *
      ** Store : Destination Customer's (i.e. Counterparty)
      **         SWIFT TID Address,
      **         STTX Address
      **         Telex Address
      **         Default Network for MTnnn messages
      ** (All used in message routing)
      *
     C                   MOVEL     BBCSID        ##DCSD
     C                   MOVEL     BBSTAD        ##DSTD
     C                   MOVEL     BBTXA1        ##DTXA
     C                   MOVEL     BBDNW3        ##DDNW                         *MT300 messages
      *
      ** Determine Message Routing
      *
     C                   CALL      'CG99DTMR'                           99      *
     C                   PARM                    ##SCSD           12            *Send. SWIFT Ad
     C                   PARM                    ##SSTD           12            *Send. STTX  Ad
     C                   PARM                    ##STXA           10            *Send. Telex Ad
     C                   PARM                    ##DCSD           12            *Dest. SWIFT Ad
     C                   PARM                    ##DSTD           12            *Dest. STTX  Ad
     C                   PARM                    ##DTXA           10            *Dest. Telex Ad
     C                   PARM                    ##DDNW            6            *Dest. Deflt Ne
     C                   PARM      BGMSDL        ##MSDL            1            *Midas/SWIFT D/
     C                   PARM      BGMTMI        ##MTMI            1            *Midas/Telex Li
     C                   PARM      BLSWPY        ##SWPY            1 0          *SWIFT conf prt
     C                   PARM      BLTXPY        ##TXPY            1 0          *TELEX conf prt
     C                   PARM      *BLANKS       ##NETW            6            *Network
     C                   PARM      *BLANKS       ##RTCD            7
      *
     C     *IN99         IFEQ      '1'
     C     ##RTCD        ORNE      *BLANKS
      *
      ** Database error
      *
     C                   MOVEL     'CG99DTMR'    W0FILE
     C                   MOVEL     ##RTCD        W0KEY
     C                   Z-ADD     30            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   EXSR      SRDAUT
     C                   MOVEL     'N'           ##SPPS            1
     C                   MOVEL     ##AUTO        DRATRM
      *
      ** if auto transmission
      *
     C     ##AUTO        IFEQ      'Y'
     C     CER038        ANDEQ     'Y'
     C     SUPCON        ANDEQ     'Y'                                                      MD029242
      *
      ** set suppress indicator
      *
     C                   MOVE      'Y'           ##SPPS
      *
     C                   ENDIF
     C     EXAUTO        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRDAUT                                        *
      *  Function    -  Determine if Auto-Transmission of Confirmation*
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     SRDAUT        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDAUT'      @STK(Q)
      *
     C                   MOVEL     'N'           ##AUTO            1
      *
     C     BGSWDL        IFEQ      'Y'                                          * SWIFT/DEALING
     C     BGMTDL        OREQ      'Y'                                          * MIDAS/TELEX/D
      *
     C     DTYP          IFNE      'ID'                                         * NOT INT.DEPOS
     C     DTYP          ANDNE     'IL'                                         *  OR INT.LOAN
      *
     C     ##NETW        IFNE      'PAPER '                                     * NETWORK
     C                   MOVEL     'Y'           ##AUTO
     C                   END
     C                   END
      *
     C                   END
      *
     C/COPY WNCPYSRC,CG4010CP21
      *
     C     EXDAUT        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD056543
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD056543
     C/SPACE 5
     C*COPY*CGCPYSRC,SRERRC                                                                 MD056543
     C/COPY CGCPYSRC,SRERRCLE                                                               MD056543
     C/SPACE 5
     C*COPY*CGCPYSRC,CGNWEX                                                          CCG015 MD056543
     C/COPY CGCPYSRC,CGNWEXCILE                                                             MD056543
**CTDATA #LN
IPTICLLNDLILPL
**CTDATA ##CPY
"(c) Finastra International Limited 2008"

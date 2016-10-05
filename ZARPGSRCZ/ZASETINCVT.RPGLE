     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Settle Instructions Conversion:File>Scrn')    *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  ZASETINCVT - SETTLE INSTRUCTIONS CONVERSION:                 *
      *               FILE TO SCREEN FORMAT                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD040199           Date 05Aug16               *
      *  Prev Amend No. MD033870           Date 17Apr15               *
      *                 AR1023850          Date 25Nov14               *
      *                 CDL094             Date 03Jun14               *
      *                 MD026923           Date 24May14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE033             Date 26Apr05               *
      *                 CLE031             Date 26Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             DATE 26Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003             Date 03Jun98               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040199 - ISDA Agreement Version reflected incorrectly in   *
      *             MT reports and deals enquiry. Reverse MD-33870.   *
      *  MD033870 - Wrong value for DDAGVV. Corrected MOVE and MOVEL. *
      *  AR1023850 - Version of ISDA field gets value "0000" instead  *
      *              of blanks                                        *
      *  CDL094 -  Enhance  Receive Settlement Instructions           *
      *  MD026923 - Display customer number in java screen            *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE033 - Settlement method 09                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *  CSW097 - Swift 97 Changes for MT360s and MT340s              *
      *  CAP003 - Phase II of Midas API conversions                   *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      * DATA STRUCTURE FOR CUSTOMER DETAILS
 
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      ** EXTERNAL DS FOR COUNTERPARTY NOSTRO DETAILS
                                                                                              CLE033
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE033
      ** EXTERNAL DS FOR SAR DETAILS                                                          CLE033
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      * FILE RECEIVE INSTRUCTIONS
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      * FILE PAYMENT INSTRUCTIONS
 
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      * FILE FRA/IRS INSTRUCTIONS
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      * SCREEN RECEIVE INSTRUCTIONS
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      * SCREEN PAYMENT INSTRUCTIONS
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      * SCREEN FRA/IRS INSTRUCTIONS
                                                                                             CSF011A
     D ACCT          E DS                  EXTNAME(ACCNTAB)                                  CSF011A
     D                                     PREFIX(AC_)                                       CSF011A
      ** External DS for Account Details                                                     CSF011A
                                                                                             CSF011A
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                 CSF011A
      ** External DS for Nostro Details                                                      CSF011A
 
     D RUNDAT          DS
     D  @MBIN                 13     13
      *
      ** DATA STRUCTURE FOR MULTIBRANCH INDICATOR USING RUNDAT.
      *
     D                 DS                                                                    CSF011A
     D  A#OURA                 1     18                                                      CSF011A
     D  A#NOST                 1      2                                                      CSF011A
     D  A#CNUM                 1      6                                                      CSF011A
     D  A#RENO                 1     10                                                      CSF011A
     D  A#ACOD                 7     16                                                      CSF011A
     D  A#ACAS                 7     18                                                      CSF011A
     D  A#ACSQ                17     18                                                      CSF011A
     D  A#REST                 3     18                                                      CSF011A
     D  A#RES2                11     18                                                      CSF011A
                                                                                             CSF011A
     D @PARTY          S             10A                                                     CSF011A
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
     D ##BRCA          S              3A                                                     CSF011A
     D @CUST           S              6A                                                     CSF011A
     D @CYCD           S              3A                                                     CSF011A
     D @ACCD           S             10A                                                     CSF011A
     D @ACSN           S              2A                                                     CSF011A
     D @NONB           S              2A                                                     CSF011A
     D @BRCD           S              3A                                                     CSF011A
     D @CSSN           S             10A                                                     CSF011A
     D @PNOI           S              1A                                                     CSF011A
     D @RTCD           S              7A                                                     CSF011A
     D @ACID           S             10A                                                     CSF011A
     D @BRCA           S              3A                                                     CSF011A
     D @TYPE           S              7A                                                     CSF011A
     D @NOSN           S              2A                                                     CSF011A
                                                                                             CSF011A
      /EJECT
     C*****************************************************************
      *
      ** INITIALIZE ALL SCREEN INSTRUCTIONS
      *
     C                   EXSR      INITSC
      *
      * CONVERT RECEIVE INSTRUCTIONS FROM FILE TO SCREEN FORMAT
      *
     C                   EXSR      CVTREC
      *
      * CONVERT PAYMENT INSTRUCTIONS FROM FILE TO SCREEN FORMAT
      *
     C                   EXSR      CVTPAY
      *
      * CONVERT FRA/IRS INSTRUCTIONS FROM FILE TO SCREEN FORMAT
      *
     C                   EXSR      CVTFRI
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CVTREC - CONVERT RECEIVE INSTRUCTIONS                         *
      *                                                               *
      *****************************************************************
     C     CVTREC        BEGSR
      *
     C                   MOVEL     FLRSCY        DDRSCY
      *
     C                   MOVEL     FLRSTM        DDRSTM
      *
     C                   MOVEL     FLRONS        A#OURA                                      CSF011A
     C     @MBIN         IFEQ      'Y'
     C     FLRSTM        ANDEQ     05
     C     CLE033        OREQ      'Y'                                                        CLE033
     C     FLRSTM        ANDEQ     09                                                         CLE033
     C                   MOVEL     FLROBR        DDRONX
     C                   MOVE      FLRONS        DDRONX
     C                   ELSE
     C                   MOVEL     FLRONS        DDRONX
     C                   END
                                                                                             CSF011A
     C                   IF        A#OURA <> *BLANKS                                         CSF011A
     C                   IF        FLRSCY  = *BLANKS                                         CSF011A
     C                   MOVE      #TRCCY        @CYCD                                       CSF011A
     C                   ELSE                                                                CSF011A
     C                   MOVE      FLRSCY        @CYCD                                       CSF011A
     C                   ENDIF                                                               CSF011A
     C                   MOVEL     FLROBR        ##BRCA                                      CSF011A
     C                   EXSR      CNIRTV                                                    CSF011A
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                   EVAL      DDRSH1 = BBCSSN                                           CSF011A
     C                   EVAL      DDRRN1 = BBCRNM                                           CSF011A
     C                   EVAL      DDRRT1 = BBCRTN                                           CSF011A
     C                   EVAL      DDRAC1 = AC_ANAM                                          CSF011A
     C                   EVAL      DDRSI1 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * Convert to shortname from counterparty nostro
     C                   MOVEL     FLRIBN        @@WK08            8
     C                   EXSR      CVTCPN
     C                   MOVEL     @@WK10        DDRIBN
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                   EVAL      DDRSH2 = BBCSSN                                           CSF011A
     C                   EVAL      DDRRN2 = BBCRNM                                           CSF011A
     C                   EVAL      DDRRT2 = BBCRTN                                           CSF011A
     C                   EVAL      DDRSI2 = BBCSID                                           CSF011A
     C                   ELSEIF    @PARTY = 'COUNTNS'                                        CSF011A
     C                   EVAL      DDRSH2 = AWCSN1  + AWCSN2                                 CSF011A
     C                   EVAL      DDRRN2 = AWCPNM                                           CSF011A
     C                   EVAL      DDRRT2 = AWCNTN                                           CSF011A
     C                   EVAL      DDRSI2 = AWSWID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
     C                   MOVEL     FLRIBA        DDRIBA
      *
      * Convert to shortname from customer number
     C                   MOVEL     FLROBN        @@WK06            6
     C                   EXSR      CVTCSN
     C                   MOVEL     @@WK10        DDROBN
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                   EVAL      DDRSH3 = BBCSSN                                           CSF011A
     C                   EVAL      DDRRN3 = BBCRNM                                           CSF011A
     C                   EVAL      DDRRT3 = BBCRTN                                           CSF011A
     C                   EVAL      DDRSI3 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * Convert to shortname from customer number
     C                   MOVEL     FLROCN        @@WK06
     C                   EXSR      CVTCSN
     C                   MOVEL     @@WK10        DDROCN
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                   EVAL      DDRSH4 = BBCSSN                                           CSF011A
     C                   EVAL      DDRRN4 = BBCRNM                                           CSF011A
     C                   EVAL      DDRRT4 = BBCRTN                                           CSF011A
     C                   EVAL      DDRSI4 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *                                                                                       CDL018
     C                   MOVEL     FLRMAC        DDRMAC                                       CDL018
      *                                                                                       CLE031
      ** Edit exchange rate to add decimal point                                              CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       DDREXR                                       CLE031
     C     FLREXI        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      *BLANKS       @@WK14           14                          CLE031
     C                   MOVE      FLREXR        @@WK14                                       CLE031
     C                   EXSR      CVTAMT                                                     CLE031
     C                   MOVEL     @@WK14        DDREXR                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVEL     FLREXI        DDREXI                                       CLE031
      *
      * Receive Bank to Bank Information fields                                               CDL094
     C                   MOVE      *BLANKS       DDRBB1                                       CDL094
     C                   MOVE      *BLANKS       DDRBB2                                       CDL094
     C                   MOVE      *BLANKS       DDRBB3                                       CDL094
     C                   MOVE      *BLANKS       DDRBB4                                       CDL094
     C                   MOVE      *BLANKS       DDRBB5                                       CDL094
     C                   MOVE      *BLANKS       DDRBB6                                       CDL094
     C                   MOVE      FLRBB1        DDRBB1                                       CDL094
     C                   MOVE      FLRBB2        DDRBB2                                       CDL094
     C                   MOVE      FLRBB3        DDRBB3                                       CDL094
     C                   MOVE      FLRBB4        DDRBB4                                       CDL094
     C                   MOVE      FLRBB5        DDRBB5                                       CDL094
     C                   MOVE      FLRBB6        DDRBB6                                       CDL094
      *                                                                                       CDL094
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CVTPAY - CONVERT PAYMENT INSTRUCTIONS                         *
      *                                                               *
      *****************************************************************
     C     CVTPAY        BEGSR
      *
     C                   MOVEL     FLPSCY        DDPSCY
      *
     C                   MOVEL     FLPSTM        DDPSTM
      *
     C                   MOVEL     FLPONS        A#OURA                                      CSF011A
     C     @MBIN         IFEQ      'Y'
     C     FLPSTM        ANDEQ     05
     C     CLE033        OREQ      'Y'                                                        CLE033
     C     FLPSTM        ANDEQ     09                                                         CLE033
     C                   MOVEL     FLPOBR        DDPONX
     C                   MOVE      FLPONS        DDPONX
     C                   ELSE
     C                   MOVEL     FLPONS        DDPONX
     C                   END
                                                                                             CSF011A
     C                   IF        A#OURA <> *BLANKS                                         CSF011A
     C                   IF        FLPSCY = *BLANKS                                          CSF011A
     C                   MOVE      #TPCCY        @CYCD                                       CSF011A
     C                   ELSE                                                                CSF011A
     C                   MOVE      FLPSCY        @CYCD                                       CSF011A
     C                   ENDIF                                                               CSF011A
     C                   MOVEL     FLPOBR        ##BRCA                                      CSF011A
     C                   EXSR      CNIRTV                                                    CSF011A
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                   EVAL      DDPSH1 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN1 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT1 = BBCRTN                                           CSF011A
     C                   EVAL      DDPAC1 = AC_ANAM                                          CSF011A
     C                   EVAL      DDPSI1 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * Convert to shortname from counterparty nostro
     C                   MOVEL     FLPIBN        @@WK08
     C                   EXSR      CVTCPN
     C                   MOVEL     @@WK10        DDPIBN
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                   EVAL      DDPSH6 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN6 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT6 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI6 = BBCSID                                           CSF011A
     C                   ELSEIF    @PARTY = 'COUNTNS'                                        CSF011A
     C                   EVAL      DDPSH6 = AWCSN1 + AWCSN2                                  CSF011A
     C                   EVAL      DDPRN6 = AWCPNM                                           CSF011A
     C                   EVAL      DDPRT6 = AWCNTN                                           CSF011A
     C                   EVAL      DDPSI6 = AWSWID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
     C                   MOVEL     FLPIBA        DDPIBA
      *
      * Convert to shortname from customer number
     C                   MOVEL     FLPOBN        @@WK06
     C                   EXSR      CVTCSN
     C                   MOVEL     @@WK10        DDPOBN
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                   EVAL      DDPSH4 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN4 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT4 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI4 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * Convert to shortname from customer number
     C                   MOVEL     FLPOCN        @@WK06
     C                   EXSR      CVTCSN
     C                   MOVEL     @@WK10        DDPOCN
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                   EVAL      DDPSH3 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN3 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT3 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI3 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * Convert to shortname from counterparty nostro
     C                   MOVEL     FLRCRN        @@WK08
     C                   EXSR      CVTCPN
     C                   MOVEL     @@WK10        DDRCRN
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                   EVAL      DDPSH5 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN5 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT5 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI5 = BBCSID                                           CSF011A
     C                   ELSEIF    @PARTY  = 'COUNTNS'                                       CSF011A
     C                   EVAL      DDPSH5 = AWCSN1 + AWCSN2                                  CSF011A
     C                   EVAL      DDPRN5 = AWCPNM                                           CSF011A
     C                   EVAL      DDPRT5 = AWCNTN                                           CSF011A
     C                   EVAL      DDPSI5 = AWSWID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
     C                   MOVEL     FLRCRA        DDRCRA
      *
      * Convert to shortname from counterparty nostro
     C                   MOVEL     FLRVNO        @@WK08
     C                   EXSR      CVTCPN
     C                   MOVEL     @@WK10        DDRVNO
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                   EVAL      DDPSH2 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN2 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT2 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI2 = BBCSID                                           CSF011A
     C                   ELSEIF    @PARTY  = 'COUNTNS'                                       CSF011A
     C                   EVAL      DDPSH2 = AWCSN1 + AWCSN2                                  CSF011A
     C                   EVAL      DDPRN2 = AWCPNM                                           CSF011A
     C                   EVAL      DDPRT2 = AWCNTN                                           CSF011A
     C                   EVAL      DDPSI2 = AWSWID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * Convert to shortname from counterparty nostro
     C                   MOVEL     FLAWBN        @@WK08
     C                   EXSR      CVTCPN
     C                   MOVEL     @@WK10        DDAWBN
                                                                                             CSF011A
     C                   IF        DDAWBN <> *BLANKS                                         CSF011A
     C                   IF        @PARTY = 'NOSEL '                                         CSF011A
     C                   MOVEL     FLAWBN        A#OURA                                      CSF011A
     C                   MOVEL     FLPSCY        @CYCD                                       CSF011A
     C                   EXSR      CNIRTV                                                    CSF011A
     C                   ENDIF                                                               CSF011A
     C                   IF        @PARTY = 'COUNTNS'                                        CSF011A
     C                   EVAL      DDPSH7 = AWCSN1 + AWCSN2                                  CSF011A
     C                   EVAL      DDPRN7 = AWCPNM                                           CSF011A
     C                   EVAL      DDPRT7 = AWCNTN                                           CSF011A
     C                   EVAL      DDPSI7 = AWSWID                                           CSF011A
     C                   ELSEIF    @PARTY = 'CUSTNUM'                                        CSF011A
     C                   EVAL      DDPSH7 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN7 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT7 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI7 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
      *
     C                   MOVEL     FLAWBA        DDAWBA
      *
      * Convert to shortname from counterparty nostro
     C                   MOVEL     FLBENN        @@WK08
     C                   EXSR      CVTCPN
     C                   MOVEL     @@WK10        DDBENN
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                   EVAL      DDPSH8 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN8 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT8 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI8 = BBCSID                                           CSF011A
     C                   ELSEIF    @PARTY = 'COUNTNS'                                        CSF011A
     C                   EVAL      DDPSH8 = AWCSN1 + AWCSN2                                  CSF011A
     C                   EVAL      DDPRN8 = AWCPNM                                           CSF011A
     C                   EVAL      DDPRT8 = AWCNTN                                           CSF011A
     C                   EVAL      DDPSI8 = AWSWID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
     C                   MOVEL     FLBENA        DDBENA
     C                   MOVEL     FLDTP1        DDDTP1
     C                   MOVEL     FLDTP2        DDDTP2
     C                   MOVEL     FLDTP3        DDDTP3
     C                   MOVEL     FLDTP4        DDDTP4
     C                   MOVEL     FLDCHG        DDDCHG
     C                   MOVEL     FLIC72        DDIC72
     C                   MOVEL     FLBTB1        DDBTB1
     C                   MOVEL     FLBTB2        DDBTB2
     C                   MOVEL     FLBTB3        DDBTB3
     C                   MOVEL     FLBTB4        DDBTB4
     C                   MOVEL     FLBTB5        DDBTB5
     C                   MOVEL     FLBTB6        DDBTB6
     C                   MOVEL     FLCVMR        DDCVMR
     C                   MOVEL     FLPMAC        DDPMAC                                       CDL018
      *                                                                                       CLE031
      ** Edit exchange rate to add decimal point                                              CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       DDPEXR                                       CLE031
     C     FLPEXI        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      *BLANKS       @@WK14           14                          CLE031
     C                   MOVE      FLPEXR        @@WK14                                       CLE031
     C                   EXSR      CVTAMT                                                     CLE031
     C                   MOVEL     @@WK14        DDPEXR                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVEL     FLPEXI        DDPEXI                                       CLE031
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CVTFRI - CONVERT FRA & IRS INSTRUCTIONS                       *
      *                                                               *
      *****************************************************************
     C     CVTFRI        BEGSR
      *
     C                   MOVEL     ##FRIF        ##FRIS
                                                                                CAP003
     C     FLAGDT        IFEQ      *ZEROS                                       CAP003
     C                   MOVE      *BLANKS       DDAGDT                         CAP003
     C                   END                                                    CAP003
                                                                                CAP003
     C     FLAGVV        IFEQ      *ZEROS                                       CAP003
     C     FLAGVC        ANDEQ     *ZEROS                                       CSW097
     C                   MOVE      *BLANKS       DDAGVV                         CAP003
     C                   ELSE                                                   CSW097
     C**********         MOVE      FLAGVV        DDAGVV                CSW097 MD033870
     C**********         MOVEL     FLAGVC        DDAGVV                CSW097 MD033870
     C**********         MOVEL     FLAGVV        DDAGVV                            MD033870 MD040199
     C**********         MOVE      FLAGVC        DDAGVV                            MD033870 MD040199
     C                   MOVE      FLAGVV        DDAGVV                                     MD040199
     C                   MOVEL     FLAGVC        DDAGVV                                     MD040199
     C                   END                                                    CAP003
                                                                                CAP003
     C     FLISDA        IFEQ      *ZEROS                                       CAP003
     C     FLAGTY        ANDEQ     *BLANK                                       CSW097
     C     FLAGDT        ANDEQ     *ZEROS                                       CSW097
     C     FLAGVV        ANDEQ     *ZEROS                                       CSW097
     C     FLAGVC        ANDEQ     *ZEROS                                       CSW097
     C                   MOVE      *BLANKS       DDISDA                         CSW097
     C                   ENDIF                                                  CSW097
      *
     C     FLISDA        IFEQ      *ZEROS                                                  AR1023850
     C                   MOVE      *BLANKS       DDISDA                                    AR1023850
     C                   ENDIF                                                             AR1023850
                                                                                           AR1023850
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* CVTCSN - Convert a customer number to a shortname             *
     C*                                                               *
     C*****************************************************************
     C     CVTCSN        BEGSR
      *
     C                   MOVEL     *BLANKS       @@WK10           10
     C                   MOVE      *BLANKS       @PARTY                                      CSF011A
     C*
     C     @@WK06        IFNE      *ZEROS
     C     @@WK06        ANDNE     *BLANKS
     C*
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @@WK06        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C*
     C     @RTCD         IFEQ      *BLANKS
     C     @KYST         ANDNE     '*ERROR '
     C**********         MOVEL     BBCSSN        @@WK10                                     MD026923
     C                   EVAL      @@WK10 = BBCUST                                          MD026923
     C                   MOVEL     'CUSTNUM'     @PARTY                                      CSF011A
     C                   END
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* CVTCPN - Convert a counterparty nostro to a shortname         *
     C*                                                               *
     C*****************************************************************
     C     CVTCPN        BEGSR
      *
     C                   MOVEL     *BLANKS       @@WK10           10
     C                   MOVE      *BLANKS       @PARTY                                      CSF011A
      *
     C     @@WK08        IFNE      *ZEROS
     C     @@WK08        ANDNE     *BLANKS
      *
     C                   CALLB     'AOCNSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @@WK08        @ARCD             8
     C     SDCNST        PARM      SDCNST        DSFDY
      *
      * If not a counterparty nostro, it must be a customer number
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @@WK08        @@WK06
     C                   EXSR      CVTCSN
     C                   ELSE
     C                   MOVEL     'COUNTNS'     @PARTY                                      CSF011A
     C                   MOVEL     @@WK08        @@WK10
     C                   END
      *
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT                                                                                  CLE031
     C*****************************************************************                       CLE031
     C*                                                               *                       CLE031
     C* CVTAMT - Convert a amount to have the decimal point added     *                       CLE031
     C*                                                               *                       CLE031
     C*****************************************************************                       CLE031
     C     CVTAMT        BEGSR                                                                CLE031
      *                                                                                       CLE031
     C     @@WK14        IFNE      *ZEROS                                                     CLE031
     C     @@WK14        ANDNE     *BLANKS                                                    CLE031
      *                                                                                       CLE031
     C                   MOVE      @@WK14        ZFIELD                                       CLE031
     C                   CALLB     'ZEDIT'                                                    CLE031
     C                   PARM                    ZFIELD           16                          CLE031
     C                   PARM      8             ZADEC             1 0                        CLE031
     C                   MOVE      ZFIELD        @@WK14                                       CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVEL     *BLANKS       @@WK14                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDSR                                                                CLE031
     C*****************************************************************                       CLE031
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * CNIRTV - Retrive Customer and Account Details                 *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     CNIRTV        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   SETOFF                                       515253                 CSF011A
     C                   SETOFF                                       54                     CSF011A
                                                                                             CSF011A
     C                   CLEAR                   ACCT                                        CSF011A
     C                   CLEAR                   SDCUST                                      CSF011A
                                                                                             CSF011A
     C                   TESTN                   A#NOST               51                     CSF011A
     C                   TESTN                   A#ACOD               52                     CSF011A
     C   52              TESTN                   A#ACSQ               52                     CSF011A
     C                   TESTN                   A#RENO               53                     CSF011A
                                                                                             CSF011A
     C                   SELECT                                                              CSF011A
                                                                                             CSF011A
      ** Customer Number                                                                     CSF011A
                                                                                             CSF011A
     C                   WHEN      A#CNUM <> *BLANKS AND                                     CSF011A
     C                             %LEN(A#CNUM) = 6 AND                                      CSF011A
     C                             *IN51 = *OFF AND                                          CSF011A
     C                             A#ACAS = *BLANKS                                          CSF011A
     C                   EVAL      *IN54 = *ON                                               CSF011A
     C                   EVAL      @@WK06 = A#CNUM                                           CSF011A
                                                                                             CSF011A
      ** Nostro Account                                                                      CSF011A
                                                                                             CSF011A
     C                   WHEN      *IN51 = *ON AND A#REST = *BLANKS                          CSF011A
     C                   MOVE      A#NOST        @NONB                                       CSF011A
     C                   EXSR      ACNOST                                                    CSF011A
     C                   MOVEL     *BLANKS       @ACID                                       CSF011A
     C                   MOVEL     A7CUST        @ACID                                       CSF011A
     C                   MOVE      A7ACCD        @ACCD                                       CSF011A
     C                   MOVE      A7ACSN        @ACSN                                       CSF011A
     C                   MOVE      A7BRCD        @BRCA                                       CSF011A
     C                   IF        @RTCD <> *BLANKS                                          CSF011A
     C                   EVAL      *IN54 = *ON                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Partial/GL Account                                                                  CSF011A
                                                                                             CSF011A
     C                   WHEN      *IN52 = *ON                                               CSF011A
     C                   MOVEL     *BLANKS       @ACID                                       CSF011A
     C                   MOVEL     A#CNUM        @ACID                                       CSF011A
     C                   MOVE      A#ACSQ        @ACSN                                       CSF011A
     C                   MOVE      A#ACOD        @ACCD                                       CSF011A
     C                   MOVE      ##BRCA        @BRCA                                       CSF011A
                                                                                             CSF011A
      ** Retail Account                                                                      CSF011A
                                                                                             CSF011A
     C                   WHEN      *IN53 = *ON AND A#RES2 = *BLANKS                          CSF011A
     C                   MOVEL     A#RENO        @ACID                                       CSF011A
     C                   MOVE      *BLANKS       @CYCD                                       CSF011A
     C                   MOVE      *BLANKS       @ACSN                                       CSF011A
     C                   MOVE      *BLANKS       @ACCD                                       CSF011A
     C                   MOVE      *BLANKS       @BRCA                                       CSF011A
                                                                                             CSF011A
     C                   ENDSL                                                               CSF011A
                                                                                             CSF011A
     C  N54              EXSR      ACACCT                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EXSR      CVTCSN                                                    CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      ****************************************************************                       CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACNOST - Access Nostro Details                                *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACNOST        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AONOSTR0'                                                CSF011A
     C                   PARM      *BLANKS       @RTCD                                       CSF011A
     C                   PARM      '*KEY   '     @OPTN                                       CSF011A
     C                   PARM      *BLANKS       @CUST                                       CSF011A
     C                   PARM                    @CYCD                                       CSF011A
     C                   PARM      *BLANKS       @ACCD                                       CSF011A
     C                   PARM      *BLANKS       @ACSN                                       CSF011A
     C                   PARM                    @NONB                                       CSF011A
     C                   PARM      *BLANKS       @BRCD                                       CSF011A
     C                   PARM      *BLANKS       @CSSN                                       CSF011A
     C                   PARM      *BLANKS       @PNOI                                       CSF011A
     C     SDNOST        PARM      SDNOST        DSFDY                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACACCT - Access Account Details                               *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACACCT        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AOACCTV0'                                                CSF011A
     C                   PARM      *BLANKS       @RTCD                                       CSF011A
     C                   PARM                    @ACID                                       CSF011A
     C                   PARM                    @CYCD                                       CSF011A
     C                   PARM                    @ACCD                                       CSF011A
     C                   PARM                    @ACSN                                       CSF011A
     C                   PARM                    @BRCA                                       CSF011A
     C                   PARM                    @TYPE                                       CSF011A
     C                   PARM                    @NOSN                                       CSF011A
     C     ACCT          PARM      ACCT          DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   EVAL      @@WK06 = AC_CNUM                                          CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT
      *****************************************************************
      *                                                               *
      * INITSC - INITIALIZE ALL SCREEN INSTRUCTIONS                   *
      *                                                               *
      *****************************************************************
     C     INITSC        BEGSR
      *
      * INITIALIZE RECEIVE INSTRUCTIONS
      *
     C                   CLEAR                   ##RECS
     C                   MOVEL     '00'          DDRSTM
      *
      * INITIALIZE PAYMENT INSTRUCTIONS
      *
     C                   CLEAR                   ##PAYS
     C                   MOVEL     '00'          DDPSTM
      *
      * INITIALIZE FRA & IRS INSTRUCTIONS
      *
     C                   CLEAR                   ##FRIS
     C*
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
      ** PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      *
      ** File Payment Settlement Instruction
     C                   PARM                    ##PAYF
      *
      ** File Receipt Settlement Instruction
     C                   PARM                    ##RECF
      *
      ** File FRA/IRS Settlement Instruction
     C                   PARM                    ##FRIF
      *
      ** OUTPUT
      *
      ** Screen Payment Settlement Instruction
     C                   PARM                    ##PAYS
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM                    ##RECS
      *
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM                    ##FRIS
     C                   PARM                    #TRCCY                                      CSF011A
     C                   PARM                    #TPCCY                                      CSF011A
      *
      ** READ DATA AREA - RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *                                                                                       CLE033
      ** Access SAR details file to determine if CLE033 is switched on                        CLE033
      *                                                                                       CLE033
     C                   CallB     'AOSARDR0'                                                 CLE033
     C                   Parm      *Blanks       PRTCD             7                          CLE033
     C                   Parm      '*VERIFY'     POPTN             7                          CLE033
     C                   Parm      'CLE033'      PSARD             6                          CLE033
     C     SCSARD        Parm      SCSARD        DSFDY                                        CLE033
      *                                                                                       CLE033
     C                   Move      'N'           CLE033            1                          CLE033
     C                   If        PRTCD = *Blanks                                            CLE033
     C                   Eval      CLE033 = 'Y'                                               CLE033
     C                   Endif                                                                CLE033
      *
     C                   ENDSR
      *****************************************************************

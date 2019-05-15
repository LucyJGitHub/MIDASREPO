     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV WI/WO Extended Settlement - Validat.')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEDMES2VL - Depot Movement WI/WO Extended Settlement   *
      *                  - Validation                                 *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 16May13               *
      *                 AR642262           Date 14Sep10               *
      *                 AR640699           Date 09Sep10               *
      *                 AR596955           Date 11Aug10               *
      *                 AR589197           Date 11Aug10               *
      *                 AR581048           Date 23Jul10               *
      *                 CSW210             Date 04May10               *
      *                 BUG28003           Date 12Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 CSW206D            Date 24Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CAP087             Date 03Aug05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 225421             Date 03Mar04               *
      *                 CSE045  *CREATE    Date 06Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR642262 - Error in IBAN validation                          *
      *  AR640699 - Debtor Address - DSS/Account test                 *
      *  AR596955 - On authorisation values of fields Place of        *
      *             Clearing and QFIN changes                         *
      *  AR589197 - The input validation of //xx has been removed if  *
      *             ISO15022 is switched on, it should be reapplied   *
      *             as the code is still used                         *
      *  AR581048 - Warning messages are not the same as in the FDS   *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  BUG28003 - Value for 'Beneficiary Securities (Customer)' and *
      *             'Counterparty Safekeeping A/c' was reset after    *
      *             Authorization                                     *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSW206D - Change Control for SWIFT 2006 Standard Changes     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           (recompile due to changes in file SEDMWIPD)         *
      *           and SEEDMWIPD)                                      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  225421 - Validation of non-ISO15022 requirement should only  *
      *           being done based on the ISO15022 indicator only.    *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCUSTL7  IF   E           K DISK    RENAME(@CUSTGE:SDCUSTD7)
      ** Midas SD Customers by unique SWIFT ID
 
      /COPY WNCPYSRC,SEDME2V001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *                                                                                       CSW210
      * Named Constant used to determine if a field contains invalid                          CSW210
      * characters for Telex and S.W.I.F.T.                                                   CSW210
                                                                                              CSW210
     D ISO             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-                       CSW210
     D                                      abcdefghijklmnopqrstuvwxyz-                       CSW210
     D                                      1234567890 /+-?:().,'''                           CSW210
      *                                                                                       CSW210
      ** Named Constant used to determine if a field is alphabetic                            CSW210
                                                                                              CSW210
     D ALPHAB          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                       CSW210
                                                                                              CSW210
      * Named Constant used to determine if a field is alphabetic                             CSW210
      * with numbers                                                                          CSW210
                                                                                              CSW210
     D ALPHAN          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-                       CSW210
     D                                     1234567890'                                        CSW210
      *                                                                                       CSW210
      ** Named Constant used to determine if a field is numeric                               CSW210
                                                                                              CSW210
     D NMBRS           C                   '0123456789'                                       CSW210
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D VA0             S              1    DIM(36) CTDATA PERRCD(36)
      ** Alphabetic and numeric characters, used for validations
 
      ** Work Arrays
     D WARY            S              1    DIM(10)
     D WIMDArr         S             12    DIM(9)
     D @IM             S             12    DIM(9)
 
     D NewDPMVFld    E DS                  EXTNAME(SEDMWIPD)
      ** New fields in screen format (whole API message from/to Caller)
 
     D DPMVOkFlags   E DS                  EXTNAME(SEEDMWIPD)
      ** SEDPMV Error Indicators flags
 
     D NewSEDMX2     E DS                  EXTNAME(SEVDMX2PD)
      ** New Extension File in file format
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer details
 
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      ** Counterparty Nostro details
 
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      ** BIC Directory
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First Data Structure for Access Objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second Data Structure for Access Objects
 
      ** Data Structure used to validate a text line
     D WWLI35          DS            35
     D  WW0507                 5      7
     D  WW0510                 5     10
     D  WW0512                 5     12
     D  WW0513                 5     13
     D  WW0535                 5     35
     D  WW0835                 8     35
     D  WW1135                11     35
     D  WW1335                13     35
     D  WW1435                14     35
 
      ** Data Structures used as parameters for ME9940
      *
      ** Input
     D I#PARM          DS           512
      ** Field to be validated
     D  I#VFLD                 1      5
      ** Pay/Receive Settlement (PAY/REC)
     D  I#PR                   6      8
      ** Customer/Counterparty/BIC indentified
     D  I#PRTT                 9      9
     D  I#PRTY                10     20
      ** Pay Currency
     D  I#PCCY                21     23
      ** Receive Currency
     D  I#RCCY                24     26
      ** Account Line
     D  I#ACLN                27     61
      ** Account Line Character 1
     D  I#ACC1                27     27
      ** Account Line Character 2
     D  I#ACC2                28     28
      ** Account Line Character 3
     D  I#ACC3                29     29
      ** Account Line first 4 characters
     D  I#ACCL                27     30
      ** Account Line Clearing System
     D  I#ACCS                29     30
      ** Account Line No account data
     D  I#SPC1                31     61
      ** Message Type
     D  I#MTYP                62     64
      ** Intermediary Institution for Bank to Bank validation
     D  I#INBT                65     65
     D  I#INBK                66     76
      ** Account with Institution for Bank to Bank validation
     D  I#AWBT                77     77
     D  I#AWBK                78     88
      ** Beneficiary for Bank to Bank validation
     D  I#BENT                89     89
     D  I#BENF                90    100
      ** Pay and Receive Settlement Methods
     D  I#RSTM               101    102
     D  I#PSTM               103    104
      ** Field 53 and 54 Entered
     D  I#5354               105    105
      ** Midas Module
     D  I#MMOD               106    107
      ** Pay and Receive Settlement Accounts
     D  I#PYAC               108    125
     D  I#RCAC               126    143
      ** Transaction Type
     D  I#TTYP               144    145
      ** Cover required
     D  I#COVR               146    146
      ** Bank to Bank Information
     D  I#BTB                257    466
     D  I#BTB1               257    291
     D  I#BTB2               292    326
     D  I#BTB3               327    361
     D  I#BTB4               362    396
     D  I#BTB5               397    431
     D  I#BTB6               432    466
      *
      ** Output
     D O#PARM          DS           512
      ** Account Line modified
     D  O#ACLN                 1     35
      ** Bank to Bank Information
     D  O#BTB                257    466
     D  O#BTB1               257    291
     D  O#BTB2               292    326
     D  O#BTB3               327    361
     D  O#BTB4               362    396
     D  O#BTB5               397    431
     D  O#BTB6               432    466
      *
      ** Errors
     D E#PARM          DS           256
      ** Calling Program
     D  E#CPGM                 1     10
      ** Error message sent
     D  E#ERRM                12     12
      ** Warning message sent
     D  E#WARN                13     13
      ** Error index
     D  E#INDX                14     18  0
      ** Message text to prefix error message
     D  E#MSGD                19     25
     D  E#MSGF                26     35
      ** Error codes array
     D  E#ERCD                51    200
     D  O#E                   51    200
      *                                                                                       CSW210
      ** Data Structure redefining Address fields                                             CSW210
     D  ADDRSS                 1    210                                                       CSW210
     D  ADCHK1                 1     35                                                       CSW210
     D  ADCHK2                36     70                                                       CSW210
     D  ADCHK3                71    105                                                       CSW210
     D  ADCHK4               106    140                                                       CSW210
      *                                                                                       CSW210
      ** Blank Line Analysis data structure                                                   CSW210
     D  ADCH26                36    210                                                       CSW210
     D  ADCH36                71    210                                                       CSW210
      *                                                                                       CSW210
      ** SWIFT Address Analysis data structure                                                CSW210
     D  ADSLSH                 1      1                                                       CSW210
     D  ADSWFT                 1     11                                                       CSW210
     D  ADEXSW                12     35                                                       CSW210
     D  ADSLS2                36     36                                                       CSW210
     D  ADSWF2                36     46                                                       CSW210
     D  ADEXS2                47     70                                                       CSW210
      *                                                                                       CSW210
      ** Customer Analysis data structure                                                     CSW210
     D  ADCUST                 1     10                                                       CSW210
     D  ADEXCS                11     35                                                       CSW210
     D  ADCNUM                 1      6                                                       CSW210
     D  ADEXCN                 7     35                                                       CSW210
     D  ADCUS2                36     45                                                       CSW210
     D  ADXCS2                46     70                                                       CSW210
     D  ADCNM2                36     41                                                       CSW210
     D  ADXCN2                42     70                                                       CSW210
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for error message arrays
     D Idx             S              3P 0
 
      ** Index for warning message arrays
     D WIdx            S              3P 0
 
     D C#RTCD          S              7                                                       CSW210
     D C#OPTN          S              7                                                       CSW210
     D C#CNUM          S             10                                                       CSW210
     D C#KYST          S              7                                                       CSW210
      *                                                                                       CSW210
      ** SWIFT Address Validation                                                             CSW210
     D   ##CSID        S              1                                                       CSW210
     D   ADLINE        S              1                                                       CSW210
     D   ADSLON        S              1                                                       CSW210
                                                                                              CSW210
      ** Debtor Address Category Flag                                                         CSW210
     D   @ACBT         S              1A                                                      CSW210
     D   @ACB1         S             35A                                                      CSW210
     D   @ACB2         S             35A                                                      CSW210
     D   AD#1          S              1A                                                      CSW210
     D   AD#2          S              1A                                                      CSW210
     D   AD#3          S              1A                                                      CSW210
     D   AD#4          S              1A                                                      CSW210
     D   W@            S              5S 0                                                    CSW210
     D   W@L           S              5S 0                                                    CSW210
     D   W@P           S              5S 0                                                    CSW210
     D   W@SBBL        S             12A                                                      CSW210
     D   WSCODE        S             35A                                                      CSW210
      *                                                                                       CSW210
      ** Debtor Address                                                                       CSW210
     D WSADRS          DS           140                                                       CSW210
     D  WSDAD1                 1     35                                                       CSW210
     D  WSDAD2                36     70                                                       CSW210
     D  WSDAD234              70     70                                                     AR640699
     D  WSDAD3                71    105                                                       CSW210
     D  WSDAD4               106    140                                                       CSW210
      *                                                                                       CSW210
     DCLSWTK           DS                                                                     CSW210
     D SW                      1     12                                                       CSW210
                                                                                              CSW210
      ** IBAN DS                                                                              CSW210
     D DSIBAN          DS                                                                     CSW210
     D  DSISLH                 1      1                                                       CSW210
     D  DSIBN2                 2     35                                                       CSW210
                                                                                              CSW210
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      /COPY WNCPYSRC,SEDME2V002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SEDME2V003
 
      ** Validate Account For Payment fields
      *
     C                   EXSR      SRAFPN
     C                   EXSR      SRAFPL
 
      /COPY WNCPYSRC,SEDME2V004
 
      ** Validate Debtor fields                                                               CSW210
      *                                                                                       CSW210
     C     CSW210        IFEQ      'Y'                                                        CSW210
      *                                                                                       CSW210
     C                   EXSR      SRDIDN                                                     CSW210
     C                   EXSR      SRDADD                                                     CSW210
     C                   EXSR      SRDLIN                                                     CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Validate Account With Institution fields
      *
     C                   EXSR      SRAWIA
     C                   EXSR      SRAWIN
 
      /COPY WNCPYSRC,SEDME2V005
 
 B1  C*****DS1522        IFNE      'Y'                                                        CSW210
     C*****CSE028        OREQ      'N'                                                        225421
     C*****DSGMES        ANDEQ     'Y'                                                        CSW210
      *
      /COPY WNCPYSRC,SEDME2V006
      *
     C                   EXSR      SRAWIL
      *
      /COPY WNCPYSRC,SEDME2V007
      *
 E1  C**********         ENDIF                                                                CSW210
 
      /COPY WNCPYSRC,SEDME2V008
 
      ** Validate Beneficiary of Money fields
      *
     C                   EXSR      SRBOFA
     C                   EXSR      SRBOFN
 
      /COPY WNCPYSRC,SEDME2V009
 
 B1  C*****DS1522        IFNE      'Y'                                                        CSW210
     C*****CSE028        OREQ      'N'                                                        225421
     C*****DSGMES        ANDEQ     'Y'                                                 225421 CSW210
      *
      /COPY WNCPYSRC,SEDME2V010
      *
     C                   EXSR      SRBOF1
      *                                                                                       CSW210
     C     CSW210        IFEQ      'N'                                                        CSW210
     C                   EXSR      SRBOF2
     C                   ENDIF                                                                CSW210
      *
      /COPY WNCPYSRC,SEDME2V011
      *
 E1  C**********         ENDIF                                                                CSW210
 
      /COPY WNCPYSRC,SEDME2V012
 
      ** Validate Sender to Receiver Information
      *
 B1  C     DS1522        IFNE      'Y'
     C*****CSE028        OREQ      'N'                                                        225421
     C     DSGMES        ANDEQ     'Y'                                                        225421
      *
      /COPY WNCPYSRC,SEDME2V013
      *
     C                   EXSR      SRSRL1
     C                   EXSR      SRSRL2
     C                   EXSR      SRSRL3
      *
      /COPY WNCPYSRC,SEDME2V014
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEDME2V015
 
      ** Validate Further Information field
      *
     C                   EXSR      SRFIN1
     C                   EXSR      SRFIN2
 
      /COPY WNCPYSRC,SEDME2V016
 
      ***Validate*Registration*Details*field***************************                       CSW210
      *
     C**********         EXSR      SRRED1                                                     CSW210
     C**********         EXSR      SRRED2                                                     CSW210
 
      ***/COPY*WNCPYSRC,SEDME2V017                                                            CSW210
 
      ** Validate Narrative field
      *
     C                   EXSR      SRNAL1
     C                   EXSR      SRNAL2
 
      /COPY WNCPYSRC,SEDME2V018
 
      ** Validate Instructing Party fields
      *
     C                   EXSR      SRIPYN
 
      /COPY WNCPYSRC,SEDME2V019
 
 B1  C     DS1522        IFNE      'Y'
     C*****CSE028        OREQ      'N'                                                        225421
     C     DSGMES        ANDEQ     'Y'                                                        225421
      *
      /COPY WNCPYSRC,SEDME2V020
      *
     C                   EXSR      SRIPYL
      *
      /COPY WNCPYSRC,SEDME2V021
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEDME2V022
 
      ***Validate*Investor*********************************************                       CSW210
      *
 B1  C*****CSW098        IFEQ      'Y'                                                        CSW210
      *
      ***/COPY*WNCPYSRC,SEDME2V023                                                            CSW210
      *
     C**********         EXSR      SRINVE                                                     CSW210
      *
      ***/COPY*WNCPYSRC,SEDME2V024                                                            CSW210
      *
 E1  C**********         ENDIF                                                                CSW210
 
      /COPY WNCPYSRC,SEDME2V025
 
      ** Validate Counterparty fields
      *
     C                   EXSR      SRCTYN
     C                   EXSR      SRCTYL
 
      /COPY WNCPYSRC,SEDME2V026
 
      ** Validate Safekeeping Account fields
      *
     C                   EXSR      SRSKAN
 
      /COPY WNCPYSRC,SEDME2V027
 
 B1  C     DS1522        IFNE      'Y'
     C*****CSE028        OREQ      'N'                                                        225421
     C     DSGMES        ANDEQ     'Y'                                                        225421
      *
      /COPY WNCPYSRC,SEDME2V028
      *
     C                   EXSR      SRSKAL
      *
      /COPY WNCPYSRC,SEDME2V029
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEDME2V030
 
      ** Validate Clearing Correspondent fields
      *
     C                   EXSR      SRCCTN
 
      /COPY WNCPYSRC,SEDME2V031
 
      ** Validate Deliverer's Instructing Party field
      *
     C                   EXSR      SRDCTL
 
      /COPY WNCPYSRC,SEDME2V032
 
      ** Validate Receiver of Securities fields
      *
     C                   EXSR      SRRSSA
     C                   EXSR      SRRSSN
 
      /COPY WNCPYSRC,SEDME2V033
 
 B1  C     DS1522        IFNE      'Y'
     C*****CSE028        OREQ      'N'                                                        225421
     C     DSGMES        ANDEQ     'Y'                                                        225421
      *
      /COPY WNCPYSRC,SEDME2V034
      *
     C                   EXSR      SRRSS1
     C                   EXSR      SRRSS2
     C                   EXSR      SRRSS3
     C                   EXSR      SRRSS4
      *
      /COPY WNCPYSRC,SEDME2V035
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEDME2V036
 
      ** Validate Deliverer of Securities fields
      *
     C                   EXSR      SRDSSA
     C                   EXSR      SRDSSN
 
      /COPY WNCPYSRC,SEDME2V037
 
 B1  C     DS1522        IFNE      'Y'
     C*****CSE028        OREQ      'N'                                                        225421
     C     DSGMES        ANDEQ     'Y'                                                        225421
      *
      /COPY WNCPYSRC,SEDME2V038
      *
     C                   EXSR      SRDSS1
     C                   EXSR      SRDSS2
     C                   EXSR      SRDSS3
     C                   EXSR      SRDSS4
      *
      /COPY WNCPYSRC,SEDME2V039
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEDME2V040
 
      ** Validate Beneficiary of Securities fields
      *
     C                   EXSR      SRBSSA
     C                   EXSR      SRBSSN
 
      /COPY WNCPYSRC,SEDME2V041
 
 B1  C     DS1522        IFNE      'Y'
     C*****CSE028        OREQ      'N'                                                        225421
     C     DSGMES        ANDEQ     'Y'                                                        225421
      *
      /COPY WNCPYSRC,SEDME2V042
      *
     C                   EXSR      SRBSS1
     C                   EXSR      SRBSS2
      *
      /COPY WNCPYSRC,SEDME2V043
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEDME2V044
 
      ** Validate screen format 3 fields
      *
 B1  C                   IF        CSE028 = 'Y'
      *
      /COPY WNCPYSRC,SEDME2V045
      *
      ** Intermediary Fields
      *
     C                   EXSR      SRINTM
      *
      /COPY WNCPYSRC,SEDME2V046
      *
      ** Safekeeping Account Fields
      *
     C                   EXSR      SRSAFE
      *
      /COPY WNCPYSRC,SEDME2V047
      *
      ** Place of Settlement
      *
     C                   EXSR      SRPSET
      *                                                                                       CSW210
      ** Validate Registration Details field                                                  CSW210
      *                                                                                       CSW210
     C                   EXSR      SRRED1                                                     CSW210
     C                   EXSR      SRRED2                                                     CSW210
                                                                                              CSW210
      /COPY WNCPYSRC,SEDME2V017                                                               CSW210
      *                                                                                       CSW210
     C     CSW210        IFEQ      'Y'                                                        CSW210
      *                                                                                       CSW210
      ** Qualified Foreign Intermediary                                                       CSW210
      *                                                                                       CSW210
     C                   EXSR      SRQFIN                                                     CSW210
      *                                                                                       CSW210
      ** Place of Clearing                                                                    CSW210
      *                                                                                       CSW210
     C                   EXSR      SRPCLR                                                     CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Validate Investor                                                                    CSW210
      *                                                                                       CSW210
 B1  C     CSW098        IFEQ      'Y'                                                        CSW210
      *                                                                                       CSW210
      /COPY WNCPYSRC,SEDME2V023                                                               CSW210
      *                                                                                       CSW210
     C                   EXSR      SRINVE                                                     CSW210
      *                                                                                       CSW210
      /COPY WNCPYSRC,SEDME2V024                                                               CSW210
      *                                                                                       CSW210
 E1  C                   ENDIF                                                                CSW210
      *
      /COPY WNCPYSRC,SEDME2V048
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEDME2V049
 
      ** If no error found, set up the valid file fields
      *
 B1  C                   IF        Idx = 0
      *
      /COPY WNCPYSRC,SEDME2V050
      *
     C                   EXSR      SetupValid
      *
      /COPY WNCPYSRC,SEDME2V051
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEDME2V052
 
      ** Return to the caller
      *
     C                   RETURN
 
      /COPY WNCPYSRC,SEDME2V053
 
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      **  SRAFPN    - VALIDATE A/C FOR PAYMENT :53:                   *
      *****************************************************************
     C     SRAFPN        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSAFPN        IFNE      *BLANKS
      *
      ** ACCOUNT FOR PAYMENT MUST BE LEFT BLANK FOR CLEARANCE 1 TO 4
      *
     C                   IF        @CLAS = 'E' OR @CLAS = 'C'
     C                   EVAL      DSAFPNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAFPN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5216'
      *
     C                   ELSE
      *
      ** ACCOUNT FOR PAYMENT MUST BE LEFT BLANK FOR INSTRUCTIONS FREE
      *
     C     @INST         IFEQ      'RECFREE'
     C     @INST         OREQ      'DELFREE'
     C                   EVAL      DSAFPNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAFPN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5217'
     C                   END
      *
     C                   END
      *
      ** SET ERROR INDICATOR ON THIS FIELD BEFORE VALIDATION.
      *
     C     DSAFPNOK      IFEQ      'Y'
     C                   MOVE      'N'           DSAFPNOK
      *
      ** VALIDATE CUSTOMER NO/SHORTNAME/NOSTRO
      *
     C                   MOVE      DSAFPN        WWCUST           10
     C                   MOVEL (P) 'DSAFPN'      WWFLDNAM         10
     C                   EXSR      SRCUST
      *
      ** RESET ERROR INDICATOR IF FIELD IS VALID
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C     WWCUSS        OREQ      'N'
     C                   MOVE      'Y'           DSAFPNOK
     C                   END
      *
      ** CUSTOMER NO/SHORTNAME
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C**********         MOVEL     BBCUST        WWAFPN                                     AR596955
     C                   EVAL      WWAFPN = BBCUST                                          AR596955
     C                   END
      *
      ** NOSTRO
      *
     C     WWCUSS        IFEQ      'N'
     C**********         MOVEL     AWCPNC        WWAFPN                                     AR596955
     C                   EVAL      WWAFPN = AWCPNC                                          AR596955
     C                   END
      *
     C                   END
      *
     C                   ELSE
      *
      ** ELSE IF SCREEN FIELD IS BLANK, ENSURE WORKFIELD IS ALSO BLANK
      *
     C                   MOVE      *BLANKS       WWAFPN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAFPL - VALIDATE A/C FOR PAYMENT A/C LINE :53:               *
      *****************************************************************
     C     SRAFPL        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C                   MOVEL     DSAFPL        WWAFPL            1
      *
     C     DSAFPL        IFNE      *BLANKS
     C     WWAFPL        ANDNE     '#'
      *
     C                   IF        @CLAS = 'E' OR @CLAS = 'C'
      *
     C     DSAFPN        IFEQ      *BLANKS
     C                   EVAL      DSAFPLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAFPL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5216'
     C                   END
      *
     C                   ELSE
      *
      ** ACCOUNT FOR PAYMENT MUST BE LEFT BLANK FOR INSTRUCTIONS FREE
      *
     C     @INST         IFNE      'RECFREE'
     C     @INST         ANDNE     'DELFREE'
      *
     C     DSAFPN        IFEQ      *BLANKS
     C                   EVAL      DSAFPLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAFPL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5217'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C     DS1522        IFNE      'Y'
     C*****CSE028        OREQ      'N'                                                        225421
     C     DSGMES        ANDEQ     'Y'                                                        225421
      *
     C                   MOVEL     DSAFPL        WWLI01            1
      *
     C     WWLI01        IFNE      '/'
     C                   EVAL      DSAFPLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAFPL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5210'
     C                   END
      *
     C                   MOVEL     DSAFPL        WWLI02            2
      *
     C     WWLI02        IFEQ      '//'
     C                   EVAL      DSAFPLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAFPL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5211'
     C                   END
      *
     C                   MOVE      DSAFPL        WWLI34           34
      *
     C     WWLI01        IFEQ      '/'
     C     WWLI34        ANDEQ     *BLANKS
     C                   EVAL      DSAFPLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAFPL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5212'
     C                   END
      *
     C                   ENDIF
      *
     C                   IF        CFT004 = 'Y' AND                                           CSW210
     C                             CSW210 = 'Y'                                               CSW210
     C                   EVAL      DSIBAN = DSAFPL                                            CSW210
     C                   EXSR      SRIBAN                                                     CSW210
      *                                                                                       CSW210
     C                   EVAL      VDFAP1 = WVIBAN                                            CSW210
     C                   IF        WIBRTN <> *BLANKS                                          CSW210
     C                   EVAL      DSAFPL = WIBRTN                                            CSW210
     C                   ENDIF                                                                CSW210
     C                   IF        WIBNWR = 'Y'                                               CSW210
     C                   EVAL      DSAFPL = WTIBAN                                            CSW210
     C                   EVAL      DSAFPLOK = 'N'                                             CSW210
     C   99              EVAL      WFldNamArr(WIdx) = 'DSAFPL'                                CSW210
     C***99*****         EVAL      WMsgDtaArr(WIdx)  = 'Acc. for Payment'            CSW210 AR581048
     C***99*****         EVAL      WMsgDtaArr(WIdx)  = 'A/c for Payment +          AR581048 MD000091
     C**********                   Account Line'                                   AR581048 MD000091
     C                   IF        *IN99 = *ON                                              MD000091
     C                   EVAL      MsgDtaTmp = 'A/c for Payment Account Line'               MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr + %TRIM(MsgDtaTmp)             MD000091
     C                   ENDIF                                                              MD000091
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   END
      *
      ** EITHER SWIFT FIELD 53 OR (57 AND 58) CAN BE ENTERED
      *
     C     @REDE         IFEQ      'TS'
     C     DSAFPN        ANDNE     *BLANKS
     C     @REDE         OREQ      'TS'
     C     DSAFPL        ANDNE     *BLANKS
      *
     C     DSAWIN        IFNE      *BLANKS
     C     DSAWIL        ORNE      *BLANKS
     C     DSBOFN        ORNE      *BLANKS
     C     DSBOF1        ORNE      *BLANKS
     C     DSBOF2        ORNE      *BLANKS
     C                   EVAL      DSAFPLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAFPL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5215'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      * SRDIDN - VALIDATE DEBTOR IDENTIFICATION                       *                       CSW210
      *****************************************************************                       CSW210
     C     SRDIDN        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Validate if Debtor Identification is not blanks                                      CSW210
      *                                                                                       CSW210
     C     DSDIDN        IFNE      *BLANKS                                                    CSW210
      *                                                                                       CSW210
      ** Debtor ID must be blank if instructions free of payment                              CSW210
      *                                                                                       CSW210
     C     @INST         IFEQ      'RECFREE'                                                  CSW210
     C     @INST         OREQ      'DELFREE'                                                  CSW210
      *                                                                                       CSW210
     C                   EVAL      DSDIDNOK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDIDN'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00112'                                CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Debtor Address Lines must be blanks if Debtor ID is entered                          CSW210
      *                                                                                       CSW210
     C     DSDAD1        IFNE      *BLANKS                                                    CSW210
     C     DSDAD2        ORNE      *BLANKS                                                    CSW210
     C     DSDAD3        ORNE      *BLANKS                                                    CSW210
     C     DSDAD4        ORNE      *BLANKS                                                    CSW210
      *                                                                                       CSW210
     C                   EVAL      DSDIDNOK = 'N'                                             CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C                   EVAL      DSDAD2OK = 'N'                                             CSW210
     C                   EVAL      DSDAD3OK = 'N'                                             CSW210
     C                   EVAL      DSDAD4OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00113'                                CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Set error indicator on this field before validation                                  CSW210
      *                                                                                       CSW210
     C                   IF        DSDIDNOK = 'Y'                                             CSW210
     C                   EVAL      DSDIDNOK = 'N'                                             CSW210
      *                                                                                       CSW210
      ** Validate Customer No/Shortname/Nostro                                                CSW210
      *                                                                                       CSW210
     C                   MOVE      DSDIDN        WWCUST                                       CSW210
     C                   EVAL      WWFLDNAM = 'DSDIDN'                                        CSW210
     C                   EXSR      SRCUST                                                     CSW210
      *                                                                                       CSW210
      ** Reset error indicator if field is valid                                              CSW210
      *                                                                                       CSW210
     C                   IF        WWCUSS = 'C' OR                                            CSW210
     C                             WWCUSS = 'S' OR                                            CSW210
     C                             WWCUSS = 'N'                                               CSW210
     C                   EVAL      DSDIDNOK = 'Y'                                             CSW210
     C                   END                                                                  CSW210
      *                                                                                       CSW210
      ** Customer No/Shortname                                                                CSW210
      *                                                                                       CSW210
     C     WWCUSS        IFEQ      'C'                                                        CSW210
     C     WWCUSS        OREQ      'S'                                                        CSW210
     C**********         MOVEL     BBCUST        WWDIDN           10                 CSW210 AR596955
     C                   EVAL      WWDIDN = BBCUST                                          AR596955
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Nostro                                                                               CSW210
      *                                                                                       CSW210
     C     WWCUSS        IFEQ      'N'                                                        CSW210
     C**********         MOVEL     AWCPNC        WWDIDN                              CSW210 AR596955
     C                   EVAL      WWDIDN = AWCPNC                                          AR596955
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ELSE                                                                 CSW210
      *                                                                                       CSW210
      ** Else If Screen Field is Blank, ensure workfield is also Blank                        CSW210
      *                                                                                       CSW210
     C                   MOVE      *BLANKS       WWDIDN                                       CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDSR                                                                CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      * SRDADD - VALIDATE DEBTOR ADDRESS                              *                       CSW210
      *****************************************************************                       CSW210
     C     SRDADD        BEGSR                                                                CSW210
      *                                                                                       CSW210
     C                   EVAL      WSDAD1 = DSDAD1                                            CSW210
     C                   EVAL      WSDAD2 = DSDAD2                                            CSW210
     C                   EVAL      WSDAD3 = DSDAD3                                            CSW210
     C                   EVAL      WSDAD4 = DSDAD4                                            CSW210
     C                   EVAL      @ACBT = *BLANKS                                            CSW210
      *                                                                                       CSW210
      ** Validate if Debtor Address is not blanks                                             CSW210
      *                                                                                       CSW210
     C                   IF        WSADRS <> *BLANKS                                          CSW210
      *                                                                                       CSW210
      ** Debtor Address must be blank if instructions free of payment                         CSW210
      *                                                                                       CSW210
     C     @INST         IFEQ      'RECFREE'                                                  CSW210
     C     @INST         OREQ      'DELFREE'                                                  CSW210
      *                                                                                       CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00112'                                CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Validate SWIFT Address                                                               CSW210
      *                                                                                       CSW210
     C                   EVAL      ADDRSS = WSADRS                                            CSW210
      *                                                                                       CSW210
     C                   IF        @ACBT = *BLANKS AND                                        CSW210
     C                             WSADRS <> *BLANKS                                          CSW210
      *                                                                                       CSW210
      ** If 1st 11 Chars of 1st line then SWIFT address assumed                               CSW210
      ** Or first is '/' and second is SWIFT Address                                          CSW210
      *                                                                                       CSW210
      ** If field does not begin with '/' and is not longer than 11                           CSW210
      ** characters, validate as a S.W.I.F.T. Address                                         CSW210
      *                                                                                       CSW210
     C                   IF        ADCH26 = *BLANKS AND                                       CSW210
     C                             ADEXSW = *BLANKS AND                                       CSW210
     C                             ADSLSH <> '/'                                              CSW210
      *                                                                                       CSW210
      ** First 11 characters should be key for CLSWT.                                         CSW210
      *                                                                                       CSW210
     C                   MOVEL     ADCHK1        CLSWTK                                       CSW210
      *                                                                                       CSW210
     C                   EXSR      SRSWIFT                                                    CSW210
      *                                                                                       CSW210
     C                   IF        ##CSID = 'Y'                                               CSW210
      *                                                                                       CSW210
      ** Send error to screen                                                                 CSW210
      *                                                                                       CSW210
     C                   IF        *IN31 = *ON                                                CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00078'                                CSW210
     C                   GOTO      EXDADD                                                     CSW210
      *                                                                                       CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      @ACBT = 'S'                                                CSW210
      *                                                                                       CSW210
      ** No SWIFT address record.                                                             CSW210
      *                                                                                       CSW210
     C                   IF        *IN32 = *ON AND                                            CSW210
     C                             *IN31 = *OFF                                               CSW210
      *                                                                                       CSW210
      ** If text changed then warning needs to be changed                                     CSW210
      *                                                                                       CSW210
     C                   MOVEL     CLSWTK        @ACB1                                        CSW210
      *                                                                                       CSW210
      ** Send warning to screen                                                               CSW210
      *                                                                                       CSW210
     C                   EVAL      DSDAD1OK = 'W'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             WIdx                                         CSW210
     C   99              EVAL      WMsgIdArr(WIdx)  = 'ST00079'                               CSW210
     C   99              EVAL      WFldNamArr(WIdx) = 'DSDAD1'                                CSW210
     C                   GOTO      EXDADD                                                     CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Validate Swift Codeword                                                              CSW210
      *                                                                                       CSW210
     C                   IF        @ACBT = *BLANKS AND                                        CSW210
     C                             WSADRS <> *BLANKS                                          CSW210
      *                                                                                       CSW210
      ** If first character is not '/'.                                                       CSW210
      *                                                                                       CSW210
     C                   IF        ADSLSH = '/'                                               CSW210
      *                                                                                       CSW210
     C                   EVAL      @ACBT = 'C'                                                CSW210
     C                   EVAL      WSCODE = DSDAD1                                            CSW210
      *                                                                                       CSW210
      ** check for presence and position of terminating '/'; W@ is                            CSW210
      ** position of second '/'                                                               CSW210
      *                                                                                       CSW210
     C     '/'           SCAN      WSCODE:2      W@                       50                  CSW210
      *                                                                                       CSW210
      ** If second '/' not found - error: codeword must end '/'                               CSW210
     C                   IF        *IN50 = *OFF                                               CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00115'                                CSW210
     C                   GOTO      EXDADD                                                     CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** If '/' is in posn. 2 - error: '//' invalid for codeword                              CSW210
     C                   IF        W@ = 2                                                     CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00116'                                CSW210
     C                   GOTO      EXDADD                                                     CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** If '/' is in posn. 11 or greater - error: codeword should be                         CSW210
      ** 8 characters or fewer.                                                               CSW210
     C                   IF        W@ > 10                                                    CSW210
      *                                                                                       CSW210
     C                   IF        CSW201 = 'Y'                                               CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00120'                                CSW210
     C                   GOTO      EXDADD                                                     CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00117'                                CSW210
     C                   GOTO      EXDADD                                                     CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** If any characters after second '/' - error: should be blank                          CSW210
      *                                                                                       CSW210
     C     35            SUB       W@            W@L                                          CSW210
     C     W@            ADD       1             W@P                                          CSW210
     C     W@L           SUBST     WSCODE:W@P    W@SBBL                                       CSW210
     C                   IF        W@SBBL <> *BLANKS                                          CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00118'                                CSW210
     C                   GOTO      EXDADD                                                     CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** If codeword contains non-upper case or non-numeric characters                        CSW210
      *                                                                                       CSW210
     C                   IF        CSW201 = 'Y'                                               CSW210
      *                                                                                       CSW210
     C     ALPHAN        CHECK     WSCODE:2      W@L                                          CSW210
     C                   IF        W@L < W@                                                   CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00121'                                CSW210
     C                   GOTO      EXDADD                                                     CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ELSE                                                                 CSW210
      *                                                                                       CSW210
      ** If codeword contains non-upper case alpha characters - error:                        CSW210
      ** codeword should be SWIFT 8a.                                                         CSW210
      *                                                                                       CSW210
     C     ALPHAB        CHECK     WSCODE:2      W@L                                          CSW210
     C                   IF        W@L < W@                                                   CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00119'                                CSW210
     C                   GOTO      EXDADD                                                     CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   IF        ADEXCS <> *BLANKS                                          CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00117'                                CSW210
     C                   GOTO      EXDADD                                                     CSW210
     C                   ELSE                                                                 CSW210
     C                   IF        DSDAD2 = *BLANKS                                           CSW210
     C                   EVAL      DSDAD2OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD2'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00122'                                CSW210
     C                   GOTO      EXDADD                                                     CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      FLD = DSDAD2                                               CSW210
     C                   EXSR      SRSWSET                                                    CSW210
     C                   IF        *IN99 = *ON                                                CSW210
     C                   MOVE      'Y'           AD#2                                         CSW210
     C                   EVAL      DSDAD2OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C                   ADD       1             Idx                                          CSW210
     C                   EVAL      FldNameArr(Idx) = 'DSDAD2'                                 CSW210
     C                   EVAL      MsgIdArr(Idx)   = 'ST00081'                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                            AR640699
      ** CODEWORD is valid and second line is more than 34 characters                       AR640699
                                                                                            AR640699
     C                   IF        DSDAD1OK <> 'N'                                          AR640699
     C                             AND WSDAD234 <> *BLANKS                                  AR640699
     C                   EVAL      DSDAD1OK = 'N'                                           AR640699
     C                   EVAL      DSDAD2OK = 'N'                                           AR640699
     C     Idx           COMP      ArrayMax                             99      -Lower-     AR640699
     C   99              ADD       1             Idx                                        AR640699
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                               AR640699
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00124'                              AR640699
     C                   GOTO      EXDADD                                                   AR640699
     C                   ENDIF                                                              AR640699
                                                                                            AR640699
     C                   IF        DSDAD3 <> *BLANKS OR                                       CSW210
     C                             DSDAD4 <> *BLANKS                                          CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00123'                                CSW210
     C                   GOTO      EXDADD                                                     CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Validate Standard Address                                                            CSW210
      *                                                                                       CSW210
     C                   IF        @ACBT = *BLANKS AND                                        CSW210
     C                             WSADRS <> *BLANKS                                          CSW210
     C                   EXSR      SRADCHK                                                    CSW210
      *                                                                                       CSW210
     C                   IF        *IN92 = *ON                                                CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00080'                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   IF        DSDAD1OK = 'Y' AND                                         CSW210
     C                             DSDAD2OK = 'Y' AND                                         CSW210
     C                             DSDAD3OK = 'Y' AND                                         CSW210
     C                             DSDAD4OK = 'Y' AND                                         CSW210
     C                             @ACBT = *BLANKS                                            CSW210
     C                   EVAL      @ACBT = 'A'                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     CSR   EXDADD        ENDSR                                                                CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      * SRSWIFT - Validation for SWIFT Address                        *                       CSW210
      *****************************************************************                       CSW210
     C     SRSWIFT       BEGSR                                                                CSW210
                                                                                              CSW210
     C                   MOVEA     '00'          *IN(31)                                      CSW210
                                                                                              CSW210
      *  Test positions 1-8 for valid SWIFT Characters                                        CSW210
                                                                                              CSW210
      *  Check how many characters are alphanumeric                                           CSW210
     C                   MOVEL     *BLANKS       FLD                                          CSW210
     C                   MOVEL     CLSWTK        FLD              35                          CSW210
     C     ALPHAN        CHECK     FLD           X#                3 0    90                  CSW210
                                                                                              CSW210
      * If the first 8 or 11 are ok proceed                                                   CSW210
     C                   IF        *IN90 = *ON AND                                            CSW210
     C                             X# = 9      OR                                             CSW210
     C                             *IN90 = *ON AND                                            CSW210
     C                             X# = 12                                                    CSW210
     C     ' '           CHECK     FLD:X#                                 90                  CSW210
                                                                                              CSW210
      * Check for blanks if before 8 or 11 then assume address                                CSW210
     C                   IF        *IN90 = *ON AND                                            CSW210
     C                             X# = 11                                                    CSW210
     C                   EVAL      *IN31 = *ON                                                CSW210
     C                   EVAL      ##CSID = 'Y'                                               CSW210
     C                   GOTO      EXSWFT                                                     CSW210
     C                   END                                                                  CSW210
     C                   END                                                                  CSW210
                                                                                              CSW210
      *  Invalid format - Not a S.W.I.F.T.                                                    CSW210
     C                   IF        *IN90 = *ON                                                CSW210
     C                   EVAL      ##CSID = 'N'                                               CSW210
     C                   GOTO      EXSWFT                                                     CSW210
     C                   END                                                                  CSW210
                                                                                              CSW210
      *  Call Access object to validate identifier                                            CSW210
     C                   MOVEL     FLD           W9BICC                                       CSW210
     C     3             SUBST     FLD:9         W9BICB                                       CSW210
                                                                                              CSW210
     C                   CALL      'ME1400'                                                   CSW210
     C                   PARM      *BLANKS       W9RTN             7                          CSW210
     C                   PARM                    W9BICC            8                          CSW210
     C                   PARM                    W9BICB            3                          CSW210
     C                   PARM                    SDCUST                                       CSW210
     C                   PARM                    SDCNST                                       CSW210
     C                   PARM                    MEBICD                                       CSW210
     C                   PARM      *BLANKS       W9CUST            1                          CSW210
     C                   PARM      *BLANKS       W9CNST            1                          CSW210
     C                   PARM      *BLANKS       W9BICD            1                          CSW210
                                                                                              CSW210
     C                   SELECT                                                               CSW210
      *                                                                                       CSW210
      ** Record not found on directory but found on others                                    CSW210
      ** - BIC directory has data so error                                                    CSW210
     C                   WHEN      W9RTN = 'MIN0244' OR                                       CSW210
     C                             W9RTN = 'MIN0245' OR                                       CSW210
     C                             W9RTN = 'MIN0246'                                          CSW210
     C                   EVAL      *IN31 = *ON                                                CSW210
     C                   EVAL      ##CSID = 'Y'                                               CSW210
      *                                                                                       CSW210
      ** Record not found - S.W.I.F.T does not exist                                          CSW210
     C                   WHEN      W9RTN = 'Y2U0005'                                          CSW210
     C                   EVAL      *IN32 = *ON                                                CSW210
     C                   EVAL      ##CSID = 'Y'                                               CSW210
      *                                                                                       CSW210
      ** Record found - BIC exists                                                            CSW210
     C                   WHEN      W9RTN = *BLANKS                                            CSW210
     C                   EVAL      ##CSID = 'Y'                                               CSW210
      *                                                                                       CSW210
     C                   ENDSL                                                                CSW210
      *                                                                                       CSW210
     CSR   EXSWFT        ENDSR                                                                CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      * SRADCHK - Validation for Standard Address                     *                       CSW210
      *****************************************************************                       CSW210
     C     SRADCHK       BEGSR                                                                CSW210
                                                                                              CSW210
      *  Set off indicators & error flags                                                     CSW210
     C                   MOVEA     '000'         *IN(91)                                      CSW210
     C                   EVAL      AD#1 = 'N'                                                 CSW210
     C                   EVAL      AD#2 = 'N'                                                 CSW210
     C                   EVAL      AD#3 = 'N'                                                 CSW210
     C                   EVAL      AD#4 = 'N'                                                 CSW210
     C                   MOVE      *BLANKS       FLD              35                          CSW210
      *                                                                                       CSW210
      ** There should be no embedded spaces                                                   CSW210
      *                                                                                       CSW210
     C                   IF        ADCHK1 = *BLANKS  AND                                      CSW210
     C                             ADCHK2 <> *BLANKS OR                                       CSW210
      *                                                                                       CSW210
     C                             ADCHK1 = *BLANKS  AND                                      CSW210
     C                             ADCHK3 <> *BLANKS OR                                       CSW210
      *                                                                                       CSW210
     C                             ADCHK1 = *BLANKS  AND                                      CSW210
     C                             ADCHK4 <> *BLANKS OR                                       CSW210
      *                                                                                       CSW210
     C                             ADCHK2 = *BLANKS  AND                                      CSW210
     C                             ADCHK3 <> *BLANKS OR                                       CSW210
      *                                                                                       CSW210
     C                             ADCHK2 = *BLANKS  AND                                      CSW210
     C                             ADCHK4 <> *BLANKS OR                                       CSW210
      *                                                                                       CSW210
     C                             ADCHK3 = *BLANKS  AND                                      CSW210
     C                             ADCHK4 <> *BLANKS                                          CSW210
      *                                                                                       CSW210
     C                   EVAL      *IN92 = *ON                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Check for non-valid SWIFT characters                                                 CSW210
      *                                                                                       CSW210
     C                   IF        ADCHK1 <> *BLANKS                                          CSW210
     C                   EVAL      FLD = ADCHK1                                               CSW210
     C                   EXSR      SRSWSET                                                    CSW210
     C                   IF        *IN99 = *ON                                                CSW210
     C                   MOVE      'Y'           AD#1                                         CSW210
     C                   EVAL      DSDAD1OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD1'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00081'                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   IF        ADCHK2 <> *BLANKS                                          CSW210
     C                   EVAL      FLD = ADCHK2                                               CSW210
     C                   EXSR      SRSWSET                                                    CSW210
     C                   IF        *IN99 = *ON                                                CSW210
     C                   MOVE      'Y'           AD#2                                         CSW210
     C                   EVAL      DSDAD2OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD2'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00081'                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   IF        ADCHK3 <> *BLANKS                                          CSW210
     C                   EVAL      FLD = ADCHK3                                               CSW210
     C                   EXSR      SRSWSET                                                    CSW210
     C                   IF        *IN99 = *ON                                                CSW210
     C                   MOVE      'Y'           AD#3                                         CSW210
     C                   EVAL      DSDAD3OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD3'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00081'                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   IF        ADCHK4 <> *BLANKS                                          CSW210
     C                   EVAL      FLD = ADCHK4                                               CSW210
     C                   EXSR      SRSWSET                                                    CSW210
     C                   IF        *IN99 = *ON                                                CSW210
     C                   MOVE      'Y'           AD#4                                         CSW210
     C                   EVAL      DSDAD4OK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDAD4'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00081'                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDSR                                                                CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      * SRSWSET - Check for valid SWIFT characters used               *                       CSW210
      *****************************************************************                       CSW210
     C     SRSWSET       BEGSR                                                                CSW210
                                                                                              CSW210
     C                   EVAL      *IN99 = *OFF                                               CSW210
                                                                                              CSW210
     C     ISO           CHECK     FLD           X#                3 0    99                  CSW210
      *                                                                                       CSW210
     C                   ENDSR                                                                CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      * SRDLIN - VALIDATE DEBTOR ACCOUNT LINE                         *                       CSW210
      *****************************************************************                       CSW210
     C     SRDLIN        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Validate if Debtor Account Line is not blanks                                        CSW210
      *                                                                                       CSW210
     C     DSDLIN        IFNE      *BLANKS                                                    CSW210
      *                                                                                       CSW210
      ** Debtor ID must be blank if instructions free of payment                              CSW210
      *                                                                                       CSW210
     C     @INST         IFEQ      'RECFREE'                                                  CSW210
     C     @INST         OREQ      'DELFREE'                                                  CSW210
      *                                                                                       CSW210
     C                   EVAL      DSDLINOK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDLIN'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00112'                                CSW210
      *                                                                                       CSW210
     C                   ELSE                                                                 CSW210
      *                                                                                       CSW210
      ** If Debtor Account Line is input, Debtor ID or Address is mandatory                   CSW210
      *                                                                                       CSW210
     C     DSDIDN        IFEQ      *BLANKS                                                    CSW210
     C     DSDAD1        ANDEQ     *BLANKS                                                    CSW210
     C     DSDAD2        ANDEQ     *BLANKS                                                    CSW210
     C     DSDAD3        ANDEQ     *BLANKS                                                    CSW210
     C     DSDAD4        ANDEQ     *BLANKS                                                    CSW210
      *                                                                                       CSW210
     C                   EVAL      DSDLINOK = 'N'                                             CSW210
     C     Idx           COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             Idx                                          CSW210
     C   99              EVAL      FldNameArr(Idx) = 'DSDLIN'                                 CSW210
     C   99              EVAL      MsgIdArr(Idx)   = 'ST00082'                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   IF        CFT004 = 'Y' AND                                           CSW210
     C                             CSW210 = 'Y'                                               CSW210
     C                   EVAL      DSIBAN = DSDLIN                                            CSW210
     C                   EXSR      SRIBAN                                                     CSW210
      *                                                                                       CSW210
     C                   EVAL      VDFDBT = WVIBAN                                            CSW210
     C                   IF        WIBRTN <> *BLANKS                                          CSW210
     C                   EVAL      DSDLIN = WIBRTN                                            CSW210
     C                   ENDIF                                                                CSW210
     C                   IF        WIBNWR = 'Y'                                               CSW210
     C                   EVAL      DSDLIN = WTIBAN                                            CSW210
     C                   EVAL      DSDLINOK = 'N'                                             CSW210
     C   99              EVAL      WFldNamArr(WIdx) = 'DSDLIN'                                CSW210
     C***99*****         EVAL      WMsgDtaArr(WIdx)  = 'Debtor A/c Line'             CSW210 MD000091
     C                   IF        *IN99 = *ON                                              MD000091
     C                   EVAL      MsgDtaTmp = 'Debtor A/c Line'                            MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr + %TRIM(MsgDtaTmp)             MD000091
     C                   ENDIF                                                              MD000091
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDSR                                                                CSW210
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAWIA - VALIDATE A/C WITH INSTITUTION TAG :57:               *
      *****************************************************************
     C     SRAWIA        BEGSR
      *
      ** THIS FIELD CAN ONLY BE ENTERED FOR CLEARANCE TYPE 1 TO 4      *
      *
     C                   IF        @CLAS = 'E' OR @CLAS = 'C'
      *
     C     DSAWIA        IFNE      'A'
     C     DSAWIA        ANDNE     'D'
     C     DSAWIA        ANDNE     *BLANK
     C                   EVAL      DSAWIAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAWIA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5220'
     C                   END
      *
      ** THE A/C LINES MAY NOT BE LEFT BLANK WHEN ENTERING THE TAG FIELD
      *
     C     DSAWIA        IFNE      *BLANK
     C     DSAWIL        ANDEQ     *BLANK
     C                   EVAL      DSAWILOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAWIL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5227'
     C                   END
      *
     C                   ELSE
      *
      ** THIS FIELD MUST BE LEFT BLANK IF CLEARANCE TYPE NOT 1 TO 4    **
      *
     C     DSAWIA        IFNE      *BLANK
     C                   EVAL      DSAWIAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAWIA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5221'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAWIN - VALIDATE A/C WITH INSTITUTION :57:                   *
      *****************************************************************
     C     SRAWIN        BEGSR
      *
     C                   MOVEL     *BLANKS       WAWIN
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSAWIN        IFNE      *BLANKS
      *
      ** TAG FIELD MUST BE LEFT BLANK
      *
     C     DSAWIA        IFNE      *BLANKS
     C                   EVAL      DSAWINOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAWIN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5228'
     C                   ELSE
      *
      ** SET ERROR INDICATOR ON THIS FIELD BEFORE VALIDATION
      *
     C                   MOVE      'N'           DSAWINOK
      *
      ** VALIDATE CUSTOMER NO/SHORTNAME/NOSTRO
      *
     C                   MOVE      DSAWIN        WWCUST
     C                   EVAL      WWFLDNAM = 'DSAWIN'
     C                   EXSR      SRCUST
      *
      ** RESET ERROR INDICATOR IF FIELD IS VALID
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C     WWCUSS        OREQ      'N'
     C                   MOVE      'Y'           DSAWINOK
     C                   END
      *
      ** CUSTOMER NO/SHORTNAME
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
      *
      ** A/C MUST BE A BANK
      *
     C     WWBNBI        IFNE      'Y'
     C                   EVAL      DSAWINOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAWIN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5225'
     C                   ELSE
     C**********         MOVEL     BBCUST        WWAWIN                                     AR596955
     C                   EVAL      WWAWIN = BBCUST                                          AR596955
     C                   END
      *
     C                   END
      *
      ** NOSTRO
      *
     C     WWCUSS        IFEQ      'N'
     C**********         MOVEL     AWCPNC        WWAWIN                                     AR596955
     C                   EVAL      WWAWIN = AWCPNC                                          AR596955
     C                   END
      *
     C     CSW098        IFEQ      'Y'
     C                   MOVEL     WWAWIN        WAWIN
     C                   ENDIF
      *
      ** EITHER DSBOFN OR DSBOF1 MUST NOT BE LEFT BLANK
      ** (SWIFT FIELD 58 MUST BE ENTERED IF 57 IS ENTERED)
      *
     C     DSBOFN        IFEQ      *BLANKS
     C     DSBOF1        ANDEQ     *BLANKS
     C                   MOVE      *BLANKS       WWAWIN
     C                   EVAL      DSBOFNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBOFN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5226'
     C                   END
      *
     C                   END
      *
     C                   ELSE
      *
      ** ELSE IF SCREEN FIELD IS BLANK, ENSURE WORKFIELD IS ALSO BLANK
      *
     C                   MOVE      *BLANKS       WWAWIN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAWIL - VALIDATE A/C WITH INSTITUTION A/C LINE :57:          *
      *****************************************************************
     C     SRAWIL        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C                   MOVEL     DSAWIL        WWAWIL            1
     C                   MOVEL     DSAWIL        WWLI02                                     AR589197
      *
     C     DSAWIL        IFNE      *BLANKS
     C     WWAWIL        ANDNE     '#'
      *
 B1  C     DS1522        IFNE      'Y'                                                        CSW210
     C     DSGMES        ANDEQ     'Y'                                                        CSW210
     C     WWLI02        OREQ      '//'                                                     AR589197
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER2         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER2
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER2         IFNE      'Y'
      *
     C     DSAWIN        IFEQ      *BLANKS
     C     DSAWIA        ANDEQ     *BLANKS
     C                   MOVE      '1'           OVER2
     C                   EVAL      DSAWINOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAWIN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5230'
     C                   ELSE
     C                   MOVEL     DSAWIL        WWLI01
     C                   MOVEL     DSAWIL        WWLI02
     C                   MOVEL     DSAWIL        WWLI04            4
     C                   MOVEL     DSAWIL        WWLI05            5
     C                   MOVEL     DSAWIL        WWLI35
     C                   MOVE      'N'           DSAWILOK
     C                   EVAL      WWFLDNAM = 'DSAWIL'
     C                   MOVE      '1'           OVER2
      *
     C     CSW098        IFNE      'Y'
     C                   EXSR      SRLI35
     C                   ELSE
      *
      ** Set up parameters for call to ME9940
      *
     C                   CLEAR                   I#PARM
     C                   CLEAR                   O#PARM
     C                   CLEAR                   E#PARM
     C                   MOVEL     'AWBK '       I#VFLD
     C                   MOVEL     WAWIN         I#PRTY
     C                   MOVEL     'MEC0017'     E#MSGD
      *
     C                   EXSR      SRME99
      *
      ** If no issuer code defined for the currency clearing system,
      ** a warning message has been issued, so change the error flag to 'W'
      *
     C     WICNIL        IFEQ      'Y'
     C                   EVAL      DSAWILOK = 'W'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     WWER35        IFNE      'Y'
      *
     C                   IF        DSAWILOK <> 'W'
     C                   MOVE      'Y'           DSAWILOK
     C                   END
      *
     C                   MOVE      '0'           OVER2
     C                   MOVEL     WWLI35        DSAWIL
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   IF        CFT004 = 'Y' AND                                           CSW210
     C                             CSW210 = 'Y'                                               CSW210
     C                   EVAL      DSIBAN = DSAWIL                                            CSW210
     C                   EXSR      SRIBAN                                                     CSW210
      *                                                                                       CSW210
     C                   EVAL      VDFAI1 = WVIBAN                                            CSW210
     C                   IF        WIBRTN <> *BLANKS                                          CSW210
     C                   EVAL      DSAWIL = WIBRTN                                            CSW210
     C                   ENDIF                                                                CSW210
     C                   IF        WIBNWR = 'Y'                                               CSW210
     C                   EVAL      DSAWIL = WTIBAN                                            CSW210
     C                   EVAL      DSAWILOK = 'N'                                             CSW210
     C   99              EVAL      WFldNamArr(WIdx) = 'DSAWIL'                                CSW210
     C***99*****         EVAL      WMsgDtaArr(WIdx) = 'Acc. w/ Institution'          CSW210 AR581048
     C***99*****         EVAL      WMsgDtaArr(WIdx) = 'A/c with +                  AR581048 MD000091
     C**********                   Institution Account Line'                       AR581048 MD000091
     C                   IF        *IN99 = *ON                                              MD000091
     C                   EVAL      MsgDtaTmp = 'A/c with/ Institution +                     MD000091
     C                                         Account Line'                                MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr + %TRIM(MsgDtaTmp)             MD000091
     C                   ENDIF                                                              MD000091
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBOFA - VALIDATE BENEFICIARY OF MONEY TAG :58:               *
      *****************************************************************
     C     SRBOFA        BEGSR
      *
      ** THIS FIELD CAN ONLY BE ENTERED FOR CLEARANCE TYPE 1 TO 4
      *
     C                   IF        @CLAS = 'E' OR @CLAS = 'C'
      *
     C     DSBOFA        IFNE      'D'
     C     DSBOFA        ANDNE     *BLANK
     C                   EVAL      DSBOFAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBOFA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5222'
     C                   END
      *
      ** THE A/C LINES MAY NOT BE LEFT BLANK WHEN ENTERING THE TAG FIELD
      *
     C     DSBOFA        IFNE      *BLANK
     C     DSBOF1        ANDEQ     *BLANK
     C                   EVAL      DSBOF1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBOF1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5227'
     C                   END
      *
     C                   ELSE
      *
      ** THIS FIELD MUST BE LEFT BLANK IF CLEARANCE TYPE NOT 1 TO 4
      *
     C     DSBOFA        IFNE      *BLANK
     C                   EVAL      DSBOFAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBOFA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5221'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBOFN - VALIDATE BENEFICIARY OF MONEY :58:                   *
      *****************************************************************
     C     SRBOFN        BEGSR
      *
     C                   MOVEL     *BLANKS       WBOFN
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSBOFN        IFNE      *BLANKS
      *
      ** TAG FIELD MUST BE LEFT BLANK
      *
     C     DSBOFA        IFNE      *BLANKS
     C                   EVAL      DSBOFNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBOFN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5228'
     C                   ELSE
      *
      ** SET ERROR INDICATOR ON THIS FIELD BEFORE VALIDATION
      *
     C                   MOVE      'N'           DSBOFNOK
      *
      ** VALIDATE CUSTOMER NO/SHORTNAME/NOSTRO
      *
     C                   MOVE      DSBOFN        WWCUST
     C                   EVAL      WWFLDNAM = 'DSBOFN'
     C                   EXSR      SRCUST
      *
      ** RESET ERROR INDICATOR IF FIELD IS VALID
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C     WWCUSS        OREQ      'N'
     C                   MOVE      'Y'           DSBOFNOK
     C                   END
      *
      ** CUSTOMER NO/SHORTNAME
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C**********         MOVEL     BBCUST        WWBOFN                                     AR596955
     C                   EVAL      WWBOFN = BBCUST                                          AR596955
     C                   END
      *
      ** NOSTRO
      *
     C     WWCUSS        IFEQ      'N'
     C**********         MOVEL     AWCPNC        WWBOFN                                     AR596955
     C                   EVAL      WWBOFN = AWCPNC                                          AR596955
     C                   END
      *
     C     CSW098        IFEQ      'Y'
     C                   MOVEL     WWBOFN        WBOFN
     C                   ENDIF
      *
      ** EITHER DSAWIN OR DSAWIL MUST BE NON BLANK
      ** (SWIFT FIELD 57 MUST BE ENTERED IF 58 IS ENTERED)
      *
     C     DSAWIN        IFEQ      *BLANKS
     C     DSAWIL        ANDEQ     *BLANKS
      *
     C                   IF        CSE028 <> 'Y' OR DS1522 <> 'Y' OR
     C                             DSGMES <> 'Y'
     C                   MOVE      *BLANKS       WWBOFN
     C                   EVAL      DSAWINOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSAWIN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5245'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ELSE
      *
      ** ELSE IF SCREEN FIELD IS BLANK, ENSURE WORKFIELD IS ALSO BLANK
      *
     C                   MOVE      *BLANKS       WWBOFN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBOF1 - VALIDATE BENEFICIARY OF MONEY A/C LINE :58:          *
      *****************************************************************
     C     SRBOF1        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C                   MOVEL     DSBOF1        WWBOF1            1
     C                   MOVEL     DSBOF1        WWLI02                                     AR589197
      *
     C     DSBOF1        IFNE      *BLANKS
     C     WWBOF1        ANDNE     '#'
      *
 B1  C     DS1522        IFNE      'Y'                                                        CSW210
     C     DSGMES        ANDEQ     'Y'                                                        CSW210
     C     WWLI02        OREQ      '//'                                                     AR589197
      *                                                                                       CSW210
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER3         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER3
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER3         IFNE      'Y'
      *
     C     DSBOFN        IFEQ      *BLANKS
     C     DSBOFA        ANDEQ     *BLANKS
     C                   MOVE      '1'           OVER3
     C                   EVAL      DSBOFNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBOFN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5230'
     C                   ELSE
     C                   MOVEL     DSBOF1        WWLI01
     C                   MOVEL     DSBOF1        WWLI02
     C                   MOVEL     DSBOF1        WWLI04
     C                   MOVEL     DSBOF1        WWLI05
     C                   MOVEL     DSBOF1        WWLI35
      *
     C     WWLI02        IFEQ      '//'
     C     WWCUSS        ANDEQ     'C'
     C     WWBNBI        ANDEQ     'N'
     C     WWLI02        OREQ      '//'
     C     WWCUSS        ANDEQ     'S'
     C     WWBNBI        ANDEQ     'N'
     C                   MOVE      '1'           OVER3
     C                   EVAL      DSBOF1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBOF1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5250'
     C                   ELSE
     C                   MOVE      'N'           DSBOF1OK
     C                   EVAL      WWFLDNAM = 'DSBOF1'
     C                   MOVE      '1'           OVER3
      *
     C     CSW098        IFNE      'Y'
     C                   EXSR      SRLI35
     C                   ELSE
      *
      ** Set up parameters for call to ME9940
      *
     C                   CLEAR                   I#PARM
     C                   CLEAR                   O#PARM
     C                   CLEAR                   E#PARM
     C                   MOVEL     'BENF '       I#VFLD
     C                   MOVEL     WBOFN         I#PRTY
     C                   MOVEL     'MEC0018'     E#MSGD
      *
     C                   EXSR      SRME99
      *
      ** If no issuer code defined for the currency clearing system,
      ** a warning message has been sent, so change the error flag to 'W'
      *
     C     WICNIL        IFEQ      'Y'
     C                   MOVE      'W'           DSBOF1OK
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     WWER35        IFNE      'Y'
      *
     C                   IF        DSBOF1OK <> 'W'
     C                   MOVE      'Y'           DSBOF1OK
     C                   ENDIF
      *
     C                   MOVE      '0'           OVER3
     C                   MOVEL     WWLI35        DSBOF1
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   IF        CFT004 = 'Y' AND                                           CSW210
     C                             CSW210 = 'Y'                                               CSW210
     C                   EVAL      DSIBAN = DSBOF1                                            CSW210
     C                   EXSR      SRIBAN                                                     CSW210
      *                                                                                       CSW210
     C                   EVAL      VDFBF1 = WVIBAN                                            CSW210
     C                   IF        WIBRTN <> *BLANKS                                          CSW210
     C                   EVAL      DSBOF1 = WIBRTN                                            CSW210
     C                   ENDIF                                                                CSW210
     C                   IF        WIBNWR = 'Y'                                               CSW210
     C                   EVAL      DSBOF1 = WTIBAN                                            CSW210
     C                   EVAL      DSBOF1OK = 'N'                                             CSW210
     C   99              EVAL      WFldNamArr(WIdx) = 'DSBOF1'                                CSW210
     C***99*****         EVAL      WMsgDtaArr(WIdx)  = 'Bene. Money A/c Line'        CSW210 AR581048
     C***99*****         EVAL      WMsgDtaArr(WIdx)  = 'Beneficiary of +           AR581048 MD000091
     C**********                   Money Account Line'                             AR581048 MD000091
     C                   IF        *IN99 = *ON                                              MD000091
     C                   EVAL      MsgDtaTmp = 'Beneficiary of Money +                      MD000091
     C                                         Account Line'                                MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr + %TRIM(MsgDtaTmp)             MD000091
     C                   ENDIF                                                              MD000091
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBOF2 - VALIDATE BENEFICIARY OF MONEY A/C LINE :58:          *
      *****************************************************************
     C     SRBOF2        BEGSR
      *
      ** VALIDATE IF NOT BLANK AND NOT OVERRIDDEN
      *
     C                   MOVEL     DSBOF2        WWBOF2            1
      *
     C     DSBOF2        IFNE      *BLANKS
     C     WWBOF2        ANDNE     '#'
     C     OVER3         ANDNE     'Y'                                          1st line overr.
      *
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER3         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER3
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER3         IFNE      'Y'
      *
     C     DSBOF1        IFEQ      *BLANKS
     C                   EVAL      DSBOF1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBOF1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5255'
     C                   END
      *
     C     WWBOF1        IFNE      '/'
     C     WWBOF2        ANDEQ     '/'
     C                   MOVE      '1'           OVER3
     C                   EVAL      DSBOF2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBOF2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5256'
     C                   END
      *
     C                   MOVEL     DSBOF2        WWLI02
      *
     C     WWBOF2        IFEQ      '/'
     C     WWLI02        ANDNE     '//'
     C                   MOVE      '1'           OVER3
     C                   EVAL      DSBOF2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBOF2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5257'
     C                   END
      *
     C     DSBOF2        IFEQ      DSBOF1
     C                   EVAL      DSBOF2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBOF2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5258'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSRL1 - VALIDATE SENDER TO RECEIVER INFO LINE 1 :72:         *
      *****************************************************************
     C     SRSRL1        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C                   MOVE      *BLANK        WKSRL1            1
     C                   MOVE      *BLANKS       WWSRL1            1
     C                   MOVE      *BLANKS       WWVALI            1
      *
     C     DSSRL1        IFNE      *BLANKS
     C                   MOVEL     DSSRL1        WWSRL1
      *
     C     WWSRL1        IFEQ      '/'
      *
     C     @REDE         IFEQ      'TS'
     C     @CLAS         ANDNE     'E'
     C     @CLAS         ANDNE     'C'
     C                   MOVEL     DSSRL1        WWSR10           10
     C                   MOVEL     WWSR10        WWSR06            6
     C                   MOVE      WWSR10        WWSR04            4
      *
     C     WWSR06        IFEQ      '/PRIOR'
     C     WWSR04        ANDEQ     'REQ/'
     C                   MOVE      'Y'           WWVALI
     C                   MOVE      'Y'           WKSRL1
     C                   END
      *
     C                   END
      *
     C     @REDE         IFEQ      'TP'
     C     @CLAS         ANDNE     'E'
     C     @CLAS         ANDNE     'C'
     C                   MOVEL     DSSRL1        WWSR10
     C                   MOVEL     WWSR10        WWSR06
     C                   MOVE      WWSR10        WWSR04
      *
     C     WWSR06        IFEQ      '/TRADE'
     C     WWSR04        ANDEQ     'CP/ '
     C                   MOVE      'Y'           WWVALI
     C                   MOVE      'Y'           WKSRL1
     C                   END
      *
     C                   END
      *
     C                   MOVEL     DSSRL1        WWSR06
     C                   MOVEL     DSSRL1        WWSR07            7
     C                   MOVEL     DSSRL1        WWSR08            8
      *
     C     WWSR06        IFEQ      '/AGEN/'
     C     WWSR06        OREQ      '/PRIN/'
     C     WWSR06        OREQ      '/PHON/'
     C                   MOVE      'Y'           WWVALI
     C                   END
      *
     C     WWSR07        IFEQ      '/TELEX/'
     C                   MOVE      'Y'           WWVALI
     C                   END
      *
     C     WWSR08        IFEQ      '/BROKER/'
     C                   MOVE      'Y'           WWVALI
     C                   END
      *
     C                   IF        @CLAS = 'E' OR @CLAS = 'C'
     C                   MOVEL     DSSRL1        WWSR10
     C                   MOVEL     WWSR10        WWSR06
     C                   MOVE      WWSR10        WWSR04
     C                   MOVE      DSSRL1        WWSR25           25
      *
     C     WWSR06        IFEQ      '/ADDPR'
     C     WWSR04        ANDEQ     'TY/ '
     C     WWSR25        ANDEQ     *BLANKS
     C                   MOVE      'Y'           WWVALI
     C                   MOVE      'Y'           WKSRL1
     C                   END
      *
     C     WWSR06        IFEQ      '/CANCE'
     C     WWSR04        ANDEQ     'L/  '
     C     WWSR25        ANDEQ     *BLANKS
     C                   MOVE      'Y'           WWVALI
     C                   MOVE      'Y'           WKSRL1
     C                   END
      *
     C     WWSR06        IFEQ      '/CONFI'
     C     WWSR04        ANDEQ     'RM/ '
     C     WWSR25        ANDEQ     *BLANKS
     C                   MOVE      'Y'           WWVALI
     C                   MOVE      'Y'           WKSRL1
     C                   END
      *
     C                   END
      *
     C     CSW014        IFEQ      'Y'
     C                   MOVEL     DSSRL1        WWSR06            6
      *
     C     WWSR06        IFEQ      '/OCMT/'
     C                   MOVE      'Y'           WWVALI
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     CSW201        IFEQ      'Y'
     C                   MOVEL     DSSRL1        WWSR10
     C                   EXSR      SR2001
     C                   ENDIF
      *
     C     WWVALI        IFNE      'Y'
     C                   EVAL      DSSRL1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL1'
      *
     C   99CSW201        IFEQ      'Y'
     C                   EVAL      MsgIdArr(Idx)   = 'SEW5293'
     C                   ELSE
     C                   EVAL      MsgIdArr(Idx)   = 'SEW5265'
     C                   ENDIF
      *
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSRL2 - VALIDATE SENDER TO RECEIVER INFO LINE 2 :72:         *
      *****************************************************************
     C     SRSRL2        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C                   MOVE      *BLANKS       WWSRL2            1
     C                   MOVE      *BLANKS       WWVALI
      *
     C     DSSRL2        IFNE      *BLANKS
      *
     C     DSSRL1        IFEQ      *BLANKS
     C                   EVAL      DSSRL1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5255'
     C                   END
      *
     C                   MOVEL     DSSRL2        WWSRL2
      *
     C     WWSRL1        IFNE      '/'
     C     WWSRL2        ANDEQ     '/'
     C                   EVAL      DSSRL2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5256'
     C                   END
      *
     C                   MOVEL     DSSRL2        WWLI02
      *
     C     CSW201        IFEQ      'Y'
     C     WWLI02        ANDNE     '//'
     C                   MOVEL     DSSRL2        WWSR10
     C                   EXSR      SR2001
      *
     C     WWVALI        IFNE      'Y'
     C                   EVAL      DSSRL2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5293'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     CSW201        IFEQ      'N'
      *
     C     WKSRL1        IFEQ      *BLANK
     C     WWSRL1        ANDEQ     '/'
     C     WWLI02        ANDNE     '//'
     C                   EVAL      DSSRL2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5214'
     C                   END
      *
     C     WWSRL2        IFEQ      '/'
     C     WWLI02        ANDNE     '//'
     C                   EVAL      DSSRL2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5257'
     C                   END
      *
     C                   ENDIF
      *
     C                   MOVE      DSSRL2        WWLI33           33
      *
     C     WWLI02        IFEQ      '//'
     C     WWLI33        ANDEQ     *BLANKS
     C                   EVAL      DSSRL2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5213'
     C                   END
      *
     C     DSSRL2        IFEQ      DSSRL1
     C                   EVAL      DSSRL2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5258'
     C                   END
      *
     C     CSW201        IFEQ      'N'
      *
     C     WKSRL1        IFNE      *BLANK
     C     DSSRL2        ANDNE     *BLANKS
     C                   EVAL      DSSRL2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5259'
     C                   END
      *
     C                   ENDIF
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSRL3 - VALIDATE SENDER TO RECEIVER INFO LINE 3 :72:         *
      *****************************************************************
     C     SRSRL3        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C                   MOVE      *BLANKS       WWVALI
      *
     C     DSSRL3        IFNE      *BLANKS
      *
     C     DSSRL2        IFEQ      *BLANKS
     C                   EVAL      DSSRL2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5255'
     C                   END
      *
     C                   MOVEL     DSSRL3        WWSRL3            1
      *
     C     WWSRL2        IFNE      '/'
     C     WWSRL3        ANDEQ     '/'
     C                   EVAL      DSSRL3OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL3'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5256'
     C                   END
      *
     C                   MOVEL     DSSRL3        WWLI02
      *
     C     CSW201        IFEQ      'Y'
     C     WWLI02        ANDNE     '//'
     C                   MOVEL     DSSRL3        WWSR10
     C                   EXSR      SR2001
      *
     C     WWVALI        IFNE      'Y'
     C                   EVAL      DSSRL3OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL3'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5293'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     CSW201        IFEQ      'N'
      *
     C     WWSRL2        IFEQ      '/'
     C     WWLI02        ANDNE     '//'
     C                   EVAL      DSSRL3OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL3'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5214'
     C                   END
      *
     C     WWSRL2        IFEQ      '/'
     C     WWLI02        ANDNE     '//'
     C                   EVAL      DSSRL3OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL3'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5257'
     C                   END
      *
     C                   ENDIF
      *
     C                   MOVE      DSSRL3        WWLI33
      *
     C     WWLI02        IFEQ      '//'
     C     WWLI33        ANDEQ     *BLANKS
     C                   EVAL      DSSRL3OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL3'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5213'
     C                   END
      *
     C     DSSRL3        IFEQ      DSSRL2
     C                   EVAL      DSSRL3OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSRL3'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5258'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFIN1 - VALIDATE FURTHER INFORMATION LINE 1 :77:             *
      *****************************************************************
     C     SRFIN1        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSFIN1        IFNE      *BLANKS
      *
     C                   MOVEL     DSFIN1        WWLI01
      *
     C     WWLI01        IFEQ      '/'
     C                   EVAL      DSFIN1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSFIN1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5285'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFIN2 - VALIDATE FURTHER INFORMATION LINE 2 :77:             *
      *****************************************************************
     C     SRFIN2        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSFIN2        IFNE      *BLANKS
      *
     C     DSFIN1        IFEQ      *BLANKS
     C                   EVAL      DSFIN1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSFIN1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5255'
     C                   END
      *
     C     DSFIN2        IFEQ      DSFIN1
     C                   EVAL      DSFIN2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSFIN2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5258'
     C                   END
      *
     C                   MOVEL     DSFIN2        WWLI01
      *
     C     WWLI01        IFEQ      '/'
     C                   EVAL      DSFIN2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSFIN2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5285'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRED1 - VALIDATE REGISTRATION DERAILS LINE 1 :77:            *
      *****************************************************************
     C     SRRED1        BEGSR
      *
      ** VALIDATE FIELD IF NOT BLANK
      *
     C     DSRED1        IFNE      *BLANKS
      *
     C                   MOVEL     DSRED1        WWLI01
      *
     C     WWLI01        IFEQ      '/'
     C                   EVAL      DSRED1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRED1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5285'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRED2 - VALIDATE REGISTRATION DERAILS LINE 1 :77:            *
      *****************************************************************
     C     SRRED2        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSRED2        IFNE      *BLANKS
      *
     C     DSRED1        IFEQ      *BLANKS
     C                   EVAL      DSRED1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRED1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5255'
     C                   END
      *
     C     DSRED2        IFEQ      DSRED1
     C                   EVAL      DSRED2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRED2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5258'
     C                   END
      *
     C                   MOVEL     DSRED2        WWLI01
      *
     C     WWLI01        IFEQ      '/'
     C                   EVAL      DSRED2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRED2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5285'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRNAL1 - VALIDATE NARRATIVE 1 :79:                            *
      *****************************************************************
     C     SRNAL1        BEGSR
      *
      ** VALIDATE FIELD IF NOT BLANK
      *
     C                   MOVE      *BLANKS       WWNAL1            1
      *
     C     DSNAL1        IFNE      *BLANKS
      *
     C                   MOVEL     DSNAL1        WWNAL1
     C                   MOVE      DSNAL1        WWLI34
      *
     C     WWNAL1        IFEQ      '/'
     C     WWLI34        ANDEQ     *BLANKS
     C                   EVAL      DSNAL1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSNAL1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5263'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRNAL2 - VALIDATE NARRATIVE 2                                 *
      *****************************************************************
     C     SRNAL2        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSNAL2        IFNE      *BLANKS
      *
     C     DSNAL1        IFEQ      *BLANKS
     C                   EVAL      DSNAL1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSNAL1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5255'
     C                   END
      *
     C                   MOVEL     DSNAL2        WWNAL2            1
      *
     C     WWNAL1        IFNE      '/'
     C     WWNAL2        ANDEQ     '/'
     C                   EVAL      DSNAL2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSNAL2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5256'
     C                   END
      *
     C                   MOVEL     DSNAL2        WWLI02
      *
     C     WWNAL1        IFEQ      '/'
     C     WWLI02        ANDNE     '//'
     C                   EVAL      DSNAL2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSNAL2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5214'
     C                   END
      *
     C     WWNAL2        IFEQ      '/'
     C     WWLI02        ANDNE     '//'
     C                   EVAL      DSNAL2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSNAL2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5257'
     C                   END
      *
     C                   MOVE      DSNAL2        WWLI33
      *
     C     WWLI02        IFEQ      '//'
     C     WWLI33        ANDEQ     *BLANKS
     C                   EVAL      DSNAL2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSNAL2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5213'
     C                   END
      *
     C     DSNAL2        IFEQ      DSNAL1
     C                   EVAL      DSNAL2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSNAL2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5258'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRIPYN - VALIDATE INSTRUCTING PARTY                           *
      *****************************************************************
     C     SRIPYN        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSIPYN        IFNE      *BLANKS
      *
      ** THIS FIELD MAY NOT BE USED WHEN CLEARANCE TYPE IS 1 TO 4
      *
     C                   IF        (@CLAS = 'E' OR @CLAS = 'C')
     C                             AND DSGMEC <> 'Y'
     C                   EVAL      DSIPYNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSIPYN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5267'
     C                   END
      *
      ** SET ERROR INDICATOR ON THIS FIELD BEFORE VALIDATION.
      *
     C     DSIPYNOK      IFEQ      'Y'
     C                   MOVE      'N'           DSIPYNOK
      *
      ** VALIDATE CUSTOMER NO/SHORTNAME/NOSTRO
      *
     C                   MOVE      DSIPYN        WWCUST
     C                   EVAL      WWFLDNAM = 'DSIPYN'
     C                   EXSR      SRCUST
      *
      ** RESET ERROR INDICATOR IF FIELD IS VALID
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C     WWCUSS        OREQ      'N'
     C                   MOVE      'Y'           DSIPYNOK
     C                   END
      *
      ** CUSTOMER NO/SHORTNAME
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C**********         MOVEL     BBCUST        WWIPYN                                     AR596955
     C                   EVAL      WWIPYN = BBCUST                                          AR596955
     C                   END
     C                   END
      *
      ** NOSTRO
      *
     C     WWCUSS        IFEQ      'N'
     C**********         MOVEL     AWCPNC        WWIPYN                                     AR596955
     C                   EVAL      WWIPYN = AWCPNC                                          AR596955
     C                   END
      *
     C                   ELSE
      *
      ** ELSE IF SCREEN FIELD IS BLANK, ENSURE WORKFIELD IS ALSO BLANK
      *
     C                   MOVE      *BLANKS       WWIPYN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRIPYL - VALIDATE INSTRUCTING PARTY A/C LINE                  *
      *****************************************************************
     C     SRIPYL        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C                   MOVEL     DSIPYL        WWIPYL            1
      *
     C     DSIPYL        IFNE      *BLANKS
     C     WWIPYL        ANDNE     '#'
      *
     C                   IF        (@CLAS = 'E' OR @CLAS = 'C')
     C                             AND DSGMEC <> 'Y'
      *
     C     DSIPYN        IFEQ      *BLANKS
     C                   EVAL      DSIPYLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSIPYL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5267'
     C                   END
      *
     C                   END
      *
     C     WWIPYL        IFNE      '/'
     C                   EVAL      DSIPYLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSIPYL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5210'
     C                   END
      *
     C                   MOVEL     DSIPYL        WWLI02
      *
     C     WWLI02        IFEQ      '//'
     C                   EVAL      DSIPYLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSIPYL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5211'
     C                   END
      *
     C                   MOVE      DSIPYL        WWLI34
      *
     C     WWLI01        IFEQ      '/'
     C     WWLI34        ANDEQ     *BLANKS
     C                   EVAL      DSIPYLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSIPYL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5212'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINVE - To Validate Investor                                 *
      *****************************************************************
     C     SRINVE        BEGSR
      *
     C     DSINVE        IFNE      *BLANKS
      *
     C     DSINVEOK      IFEQ      'Y'
     C                   MOVEL     DSINVE        WWCUST
     C                   EVAL      WWFLDNAM = 'DSINVE'
     C                   EXSR      SRCUST
      *
     C                   SELECT
     C     WWCUSS        WHENEQ    'C'
     C     WWCUSS        OREQ      'S'
     C**********         MOVEL     BBCUST        WWINVE                                     AR596955
     C                   EVAL      WWINVE = BBCUST                                          AR596955
     C     WWCUSS        WHENEQ    'N'
     C**********         MOVEL     AWCPNC        WWINVE                                     AR596955
     C                   EVAL      WWINVE = AWCPNC                                          AR596955
      *
      ** Set on error indicator for Investor.
      *
     C                   OTHER
     C                   MOVE      'N'           DSINVEOK
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       WWINVE
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCTYN - VALIDATE COUNTERPARTY                                *
      *****************************************************************
     C     SRCTYN        BEGSR
      *
      ** Counterparty is mandatory if first intermediary is entered
      *
     C     DSCTYN        IFEQ      *BLANKS
     C*****CSE028        ANDEQ     'Y'                                                        225421
     C     DS1522        ANDEQ     'Y'
     C     DSGMES        ANDEQ     'Y'
     C     DSIMMD1       ANDNE     *BLANKS
     C                   EVAL      DSCTYNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSCTYN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW9008'
     C                   ENDIF
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSCTYN        IFNE      *BLANKS
     C     CSW098        ANDNE     'Y'
     C     DSIMMD1       ANDEQ     *BLANKS
      *
     C     DSCTYN        ORNE      *BLANKS
     C*****CSE028        ANDEQ     'Y'                                                        225421
     C     DS1522        ANDEQ     'Y'
     C     DSGMES        ANDEQ     'Y'
     C     DSIMMD1       ANDEQ     *BLANKS
      *
      ** THIS FIELD MAY ONLY BE USED TO GENERATE A MT512
      *
     C     DSGMEC        IFNE      'Y'
     C     CSW098        ANDNE     'Y'
     C                   EVAL      DSCTYNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSCTYN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5207'
     C                   END
      *
      ** SET ERROR INDICATOR ON THIS FIELD BEFORE VALIDATION.
      *
     C     DSCTYNOK      IFEQ      'Y'
     C                   MOVE      'N'           DSCTYNOK
      *
      ** VALIDATE CUSTOMER NO/SHORTNAME/NOSTRO
      *
     C                   MOVE      DSCTYN        WWCUST
     C                   EVAL      WWFLDNAM = 'DSCTYN'
     C                   EXSR      SRCUST
      *
      ** RESET ERROR INDICATOR IF FIELD IS VALID
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C     WWCUSS        OREQ      'N'
     C                   MOVE      'Y'           DSCTYNOK
     C                   END
      *
      ** CUSTOMER NO/SHORTNAME
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C**********         MOVEL     BBCUST        WWCTYN                                     AR596955
     C                   EVAL      WWCTYN = BBCUST                                          AR596955
     C                   END
      *
      ** NOSTRO
      *
     C     WWCUSS        IFEQ      'N'
     C**********         MOVEL     AWCPNC        WWCTYN                                     AR596955
     C                   EVAL      WWCTYN = AWCPNC                                          AR596955
     C                   END
      *
     C                   END
      *
     C                   ELSE
      *
      ** ELSE IF SCREEN FIELD IS BLANK, ENSURE WORKFIELD IS ALSO BLANK
      *
     C                   IF        DSCTYN = *BLANKS                                         BUG28003
     C                   MOVE      *BLANKS       WWCTYN
                                                                                            BUG28003
     C                   ELSE                                                               BUG28003
     C                   EVAL      WWCTYN = DSCTYN                                          BUG28003
     C                   ENDIF                                                              BUG28003
                                                                                            BUG28003
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCTYL - VALIDATE COUNTERPARTY A/C LINE                       *
      *****************************************************************
     C     SRCTYL        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C                   MOVEL     DSCTYL        WWCTYL            1
      *
     C     DSCTYL        IFNE      *BLANKS
     C     WWCTYL        ANDNE     '#'
     C     CSW098        ANDNE     'Y'
      *
     C     DSCTYL        ORNE      *BLANKS
     C     WWCTYL        ANDNE     '#'                                                        225421
     C*****CSE028        ANDEQ     'Y'
     C     DS1522        ANDEQ     'Y'
     C     DSGMES        ANDEQ     'Y'
      *
     C     DSGMEC        IFNE      'Y'
     C     CSW098        ANDNE     'Y'
      *
     C     DSCTYN        IFEQ      *BLANKS
     C                   EVAL      DSCTYLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSCTYL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5207'
     C                   END
      *
     C                   END
      *
     C                   MOVEL     DSCTYL        WWLI02
      *
     C     WWLI02        IFEQ      '//'
     C                   EVAL      DSCTYLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSCTYL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5211'
     C                   END
      *
     C                   MOVE      DSCTYL        WWLI34
      *
     C     WWLI01        IFEQ      '/'
     C     WWLI34        ANDEQ     *BLANKS
     C                   EVAL      DSCTYLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSCTYL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5212'
     C                   END
      *
     C                   END
      *
     C     CSW098        IFEQ      'Y'
      *
     C     CSE028        IFNE      'Y'
     C     DS1522        ORNE      'Y'
     C     DSGMES        ORNE      'Y'
     C                   MOVE      *BLANKS       DSCTYL
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSKAN - VALIDATE SAFEKEEPING ACCOUNT :83:                    *
      *****************************************************************
     C     SRSKAN        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSSKAN        IFNE      *BLANKS
      *
      ** SET ERROR INDICATOR ON THIS FIELD BEFORE VALIDATION
      *
     C                   MOVE      'N'           DSSKANOK
      *
      ** VALIDATE CUSTOMER NO/SHORTNAME/NOSTRO
      *
     C                   MOVE      DSSKAN        WWCUST
     C                   EVAL      WWFLDNAM = 'DSSKAN'
     C                   EXSR      SRCUST
      *
      ** RESET ERROR INDICATOR IF FIELD IS VALID
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C     WWCUSS        OREQ      'N'
     C                   MOVE      'Y'           DSSKANOK
     C                   END
      *
      ** CUSTOMER NO/SHORTNAME
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C**********         MOVEL     BBCUST        WWSKAN                                     AR596955
     C                   EVAL      WWSKAN = BBCUST                                          AR596955
     C                   END
      *
      ** NOSTRO
      *
     C     WWCUSS        IFEQ      'N'
     C**********         MOVEL     AWCPNC        WWSKAN                                     AR596955
     C                   EVAL      WWSKAN = AWCPNC                                          AR596955
     C                   END
      *
     C                   ELSE
      *
      ** ELSE IF SCREEN FIELD IS BLANK, ENSURE WORKFIELD IS ALSO BLANK
      *
     C                   MOVE      *BLANKS       WWSKAN
     C                   END
      *
      ** Safekeeping A/C is mandatory if ISO15022 is 'Y'
      *
     C***********        IF        (CSE028 = 'Y' AND DS1522 = 'Y' AND                         225421
     C***********                   DSGMES = 'Y')                                             225421
     C                   IF        (DSGMES = 'Y' AND DS1522 = 'Y')                            225421
     C                                           AND
     C                             (CSW003 <> 'Y' OR
     C                              (@CLAS <> 'C' AND @CLAS <> 'E'))
      *
     C     DSSKAL        IFEQ      *BLANKS
     C     DSSAFA        ANDEQ     *BLANKS
     C                   EVAL      DSSKALOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSKAL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW9004'
     C                   ENDIF
      *
     C     DSSKAL        IFNE      *BLANKS
     C     DSSAFA        ANDNE     *BLANKS
     C                   EVAL      DSSKALOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSKAL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW9007'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSKAL - VALIDATE SAFEKEEPING ACCOUNT A/C LINE :83:           *
      *****************************************************************
     C     SRSKAL        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C                   MOVEL     DSSKAL        WWSKAL            1
      *
     C     DSSKAL        IFNE      *BLANKS
     C     WWSKAL        ANDNE     '#'
      *
      ** SAFEKEEPING ACCOUNT MUST BE LEFT BLANK FOR CLEARANCE 1 TO 4
      ** (SAFEKEEPING ACCOUNT MUST BE ENTERED ON FIRST WINDOW)
      *
     C                   IF        @CLAS = 'E' OR @CLAS = 'C'
      *
     C                   IF        DSSKAN = *BLANKS
     C                   EVAL      DSSKALOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSKAL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5272'
     C                   ENDIF
      *
     C                   ELSE
      *
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER6         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER6
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER6         IFNE      'Y'
      *
     C     WWSKAL        IFNE      '/'
     C                   MOVE      '1'           OVER6
     C                   EVAL      DSSKALOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSKAL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5210'
     C                   END
      *
     C                   MOVEL     DSSKAL        WWLI02
      *
     C     WWLI02        IFEQ      '//'
     C                   MOVE      '1'           OVER6
     C                   EVAL      DSSKALOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSKAL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5211'
     C                   END
      *
     C                   MOVE      DSSKAL        WWLI34
      *
     C     WWLI01        IFEQ      '/'
     C     WWLI34        ANDEQ     *BLANKS
     C                   MOVE      '1'           OVER6
     C                   EVAL      DSSKALOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSKAL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5212'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCCTN - VALIDATE CLEARING CORRESPONDENT :84:                 *
      *****************************************************************
     C     SRCCTN        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSCCTN        IFNE      *BLANKS
      *
      ** CLEARANCE TYPE MUST BE 1, 2, 3 or 4
      *
     C                   IF        @CLAS <> 'E' AND @CLAS <> 'C'
     C                   EVAL      DSCCTNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSCCTN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5275'
     C                   END
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       WKRTCD            7
     C                   PARM      '*KEY   '     WKOPTN            7
     C                   PARM      DSCCTN        WKVAR            10
     C                   PARM                    WKYSTS            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     WKRTCD        IFEQ      *BLANK
     C     WKYSTS        ANDNE     '*ERROR'
     C                   MOVEL     BBCSID        DSCCTN
     C                   ELSE
     C     DSCCTN        CHAIN     SDCUSTD7                           99
      *
     C     *IN99         IFEQ      *ON
      *
      ** Check if SWIFT Address exist in BIC file
      *
     C                   CALL      'AOBICDV0'
     C                   PARM      *BLANKS       @CRTCD            7
     C                   PARM                    DSCCTN
     C                   PARM                    @CTYPE            7
     C                   PARM                    DSSDY
      *
     C     @CRTCD        IFNE      '*BICFND'
     C     @CTYPE        ANDNE     '*BIC'
     C                   EVAL      DSCCTNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSCCTN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5276'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDCTL - VALIDATE DELIVER'S INSTRUCTING PARTY :85:            *
      *****************************************************************
     C     SRDCTL        BEGSR
      *
      ** Deliverer Instruction Party is mandatory if ISO15022 is 'Y'
      ** and movement type is Walk-In.
      *
     C     DS1522        IFEQ      'Y'
     C     DSGMES        ANDEQ     'Y'
     C*****CSE028        ANDEQ     'Y'                                                        225421
     C     DPMVType      ANDEQ     'WI'
     C     DSDCTL        ANDEQ     *BLANKS
      *
 B1  C     CSE029        IFNE      'Y'
     C     DDDPBN        IFNE      *BLANKS
     C                   MOVEL     DDDPBN        DSDCTL
     C                   ELSE
     C                   EVAL      DSDCTLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDCTL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW9002'
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     WCPTY         DSDCTL
     C                   END
      *
     C                   ENDIF
      *
      ** VALIDATE IF NOT BLANK AND ISO15022 ISN'T 'Y'
      *
     C     DSDCTL        IFNE      *BLANKS
      *
     C     DS1522        IFNE      'Y'
     C*****CSE028        OREQ      'N'                                                        225421
     C     DSGMES        ANDEQ     'Y'                                                        225421
      *
      ** DSDCTL MUST START BY A SLASH "/" FOLLOWED BY 5 DIGITS
      *
     C                   MOVEL     DSDCTL        WWLI01
     C                   MOVE      DSDCTL        WWLI05
     C                   MOVEL     WWLI05        WWNUM6            6 0
     C                   MOVEL     WWNUM6        WWALF5            5
      *
     C     WWLI05        IFNE      WWALF5
     C     WWLI01        ORNE      '/'
     C                   EVAL      DSDCTLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDCTL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5281'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRSSA - VALIDATE RECEIVER OF SECURITIES TAG :87:             *
      *****************************************************************
     C     SRRSSA        BEGSR
      *
      ** THIS FIELD CAN ONLY BE ENTERED FOR CLEARANCE TYPE 1 TO 4
      *
     C                   IF        @CLAS = 'E' OR @CLAS = 'C'
      *
     C     DSRSSA        IFNE      'C'
     C     DSRSSA        ANDNE     'D'
     C     DSRSSA        ANDNE     *BLANK
     C                   EVAL      DSRSSAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSSA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5223'
     C                   END
      *
      ** THE A/C LINES MAY NOT BE LEFT BLANK WHEN ENTERING THE TAG FIELD
      *
     C     DSRSSA        IFNE      *BLANK
     C     DSRSS1        ANDEQ     *BLANK
     C                   EVAL      DSRSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5227'
     C                   END
      *
     C                   ELSE
      *
      ** THIS FIELD MUST BE LEFT BLANK IF CLEARANCE TYPE NOT 1 TO 4
      *
     C     DSRSSA        IFNE      *BLANK
     C                   EVAL      DSRSSAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSSA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5221'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRSSN - VALIDATE RECEIVER OF SECURITIES :87:                 *
      *****************************************************************
     C     SRRSSN        BEGSR
      *
      ** Receiver of securities is mandatory is ISO15022 is 'Y'
      ** and movement type is Walk-Out.
      *
     C     DSRSSN        IFEQ      *BLANKS
     C     DDDPBN        ANDNE     *BLANKS
     C     DPMVType      ANDEQ     'WO'
     C                   MOVEL     DDDPBN        DSRSSN
     C                   ENDIF
      *
     C     DS1522        IFEQ      'Y'
     C     DSGMES        ANDEQ     'Y'
     C*****CSE028        ANDEQ     'Y'                                                        225421
     C     DPMVType      ANDEQ     'WO'
     C     DSRSSN        ANDEQ     *BLANKS
     C                   EVAL      DSRSSNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSSN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW9006'
     C                   ENDIF
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSRSSN        IFNE      *BLANKS
      *
      ** TAG FIELD MUST BE LEFT BLANK
      *
     C     DSRSSA        IFNE      *BLANKS
     C                   EVAL      DSRSSNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSSN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5228'
     C                   END
      *
      ** THIS FIELD MAY ONLY BE ENTERED FOR RECEIPT INSTRUCTIONS
      *
     C     @REDE         IFEQ      'TP'
     C     DSGMEC        ANDNE     'Y'
     C                   EVAL      DSRSSNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSSN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5291'
     C                   END
      *
      ** SET ON ERROR INDICATOR FOR THIS FIELD BEFORE VALIDATION
      *
     C     DSRSSNOK      IFEQ      'Y'
     C                   MOVE      'N'           DSRSSNOK
      *
      ** VALIDATE CUSTOMER NO/SHORTNAME/NOSTRO
      *
     C                   MOVE      DSRSSN        WWCUST
     C                   EVAL      WWFLDNAM = 'DSRSSN'
     C                   EXSR      SRCUST
      *
      ** RESET ERROR INDICATOR IF FIELD IS VALID
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C     WWCUSS        OREQ      'N'
     C                   MOVE      'Y'           DSRSSNOK
     C                   END
      *
      ** CUSTOMER NO/SHORTNAME
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C**********         MOVEL     BBCUST        WWRSSN                                     AR596955
     C                   EVAL      WWRSSN = BBCUST                                          AR596955
     C                   END
      *
      ** NOSTRO
      *
     C     WWCUSS        IFEQ      'N'
     C**********         MOVEL     AWCPNC        WWRSSN                                     AR596955
     C                   EVAL      WWRSSN = AWCPNC                                          AR596955
     C                   END
      *
     C                   END
      *
     C                   ELSE
      *
      ** ELSE IF SCREEN FIELD IS BLANK, ENSURE WORKFIELD IS ALSO BLANK
      *
     C                   MOVE      *BLANKS       WWRSSN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRSS1 - VALIDATE RECEIVER OF SECURITIES A/C LINE 1 :87:      *
      *****************************************************************
     C     SRRSS1        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C                   MOVEL     DSRSS1        WWRSS1            1
      *
     C     DSRSS1        IFNE      *BLANKS
     C     WWRSS1        ANDNE     '#'
      *
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER7         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER7
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER7         IFNE      'Y'
      *
     C     @REDE         IFEQ      'TP'
     C     DSGMEC        ANDNE     'Y'
     C                   EVAL      DSRSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5291'
     C                   END
      *
     C     WWRSS1        IFNE      '/'
     C                   MOVE      '1'           OVER7
     C                   EVAL      DSRSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5210'
     C                   END
      *
     C                   MOVEL     DSRSS1        WWLI02
      *
     C     WWRSS1        IFEQ      '//'
     C                   MOVE      '1'           OVER7
     C                   EVAL      DSRSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5211'
     C                   END
      *
     C                   MOVE      DSRSS1        WWLI34
      *
     C     WWLI01        IFEQ      '/'
     C     WWLI34        ANDEQ     *BLANKS
     C                   MOVE      '1'           OVER7
     C                   EVAL      DSRSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5212'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRSS2 - VALIDATE RECEIVER OF SECURITIES A/C LINE 2 :87:      *
      *****************************************************************
     C     SRRSS2        BEGSR
      *
      ** VALIDATE IF NOT BLANK AND NOT OVERRIDDEN
      *
     C                   MOVEL     DSRSS2        WWRSS2            1
      *
     C     DSRSS2        IFNE      *BLANKS
     C     WWRSS2        ANDNE     '#'
     C     OVER7         ANDNE     'Y'                                          1st line overr.
      *
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER7         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER7
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER7         IFNE      'Y'
      *
     C     DSRSS1        IFEQ      *BLANKS
     C                   EVAL      DSRSS2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5255'
     C                   END
      *
     C     DSRSS2        IFEQ      DSRSS1
     C                   EVAL      DSRSS2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5258'
     C                   END
      *
     C                   MOVEL     DSRSS2        WWLI02
     C                   MOVE      DSRSS2        WWLI33
      *
     C     WWLI02        IFNE      '//'
     C     WWLI33        OREQ      *BLANKS
     C                   MOVE      '1'           OVER7
     C                   EVAL      DSRSS2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5213'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRSS3 - VALIDATE RECEIVER OF SECURITIES A/C LINE 3 :87:      *
      *****************************************************************
     C     SRRSS3        BEGSR
      *
      ** VALIDATE IF NOT BLANK AND NOT OVERRIDDEN
      *
     C                   MOVEL     DSRSS3        WWRSS3            1
      *
     C     DSRSS3        IFNE      *BLANKS
     C     WWRSS3        ANDNE     '#'
     C     OVER7         ANDNE     'Y'                                          1st line overr.
      *
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER7         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER7
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER7         IFNE      'Y'
      *
     C     DSRSS2        IFEQ      *BLANKS
     C                   EVAL      DSRSS3OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS3'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5255'
     C                   END
      *
     C     DSRSS3        IFEQ      DSRSS2
     C                   EVAL      DSRSS3OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS3'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5258'
     C                   END
      *
     C                   MOVEL     DSRSS3        WWLI02
     C                   MOVE      DSRSS3        WWLI33
      *
     C     WWLI02        IFNE      '//'
     C     WWLI33        OREQ      *BLANKS
     C                   MOVE      '1'           OVER7
     C                   EVAL      DSRSS3OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS3'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5213'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRSS4 - VALIDATE RECEIVER OF SECURITIES A/C LINE 4 :87:      *
      *****************************************************************
     C     SRRSS4        BEGSR
      *
      ** VALIDATE IF NOT BLANK AND NOT OVERRIDDEN
      *
     C                   MOVEL     DSRSS4        WWRSS4            1
      *
     C     DSRSS4        IFNE      *BLANKS
     C     WWRSS4        ANDNE     '#'
     C     OVER7         ANDNE     'Y'                                          1st line overr.
      *
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER7         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER7
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER7         IFNE      'Y'
      *
     C     DSRSS3        IFEQ      *BLANKS
     C                   EVAL      DSRSS4OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS4'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5255'
     C                   END
      *
     C     DSRSS4        IFEQ      DSRSS3
     C                   EVAL      DSRSS4OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS4'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5258'
     C                   END
      *
     C                   MOVEL     DSRSS4        WWLI02
     C                   MOVE      DSRSS4        WWLI33
      *
     C     WWLI02        IFNE      '//'
     C     WWLI33        OREQ      *BLANKS
     C                   MOVE      '1'           OVER7
     C                   EVAL      DSRSS4OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRSS4'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5213'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDSSA - VALIDATE DELIVERER OF SECURITIES TAG :87:            *
      *****************************************************************
     C     SRDSSA        BEGSR
      *
      ** THIS FIELD CAN ONLY BE ENTERED FOR CLEARANCE TYPE 1 TO 4
      *
     C                   IF        @CLAS = 'E' OR @CLAS = 'C'
      *
     C     DSDSSA        IFNE      'C'
     C     DSDSSA        ANDNE     'D'
     C     DSDSSA        ANDNE     *BLANK
     C                   EVAL      DSDSSAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSSA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5223'
     C                   END
      *
      ** THE A/C LINES MAY NOT BE LEFT BLANK WHEN ENTERING THE TAG FIELD
      *
     C     DSDSSA        IFNE      *BLANK
     C     DSDSS1        ANDEQ     *BLANK
     C                   EVAL      DSDSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5227'
     C                   END
      *
     C                   ELSE
      *
      ** THIS FIELD MUST BE LEFT BLANK IF CLEARANCE TYPE NOT 1 TO 4
      *
     C     DSDSSA        IFNE      *BLANK
     C                   EVAL      DSDSSAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSSA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5221'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDSSN - VALIDATE DELIVERER OF SECURITIES :87:                *
      *****************************************************************
     C     SRDSSN        BEGSR
      *
      ** Deliverer of securities is mandatory if ISO15022 is 'Y'
      ** and movement type is Walk-In.
      *
     C     DSDSSN        IFEQ      *BLANKS
     C     DDDPBN        ANDNE     *BLANKS
     C     DPMVType      ANDEQ     'WI'
     C                   MOVE      DDDPBN        DSDSSN
     C                   ENDIF
      *
     C     DS1522        IFEQ      'Y'
     C     DSGMES        ANDEQ     'Y'
     C*****CSE028        ANDEQ     'Y'                                                        225421
     C     DPMVType      ANDEQ     'WI'
     C     DSDSSN        ANDEQ     *BLANKS
     C                   EVAL      DSDSSNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSSN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW9003'
     C                   ENDIF
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSDSSN        IFNE      *BLANKS
      *
      ** TAG FIELD MUST BE LEFT BLANK
      *
     C     DSDSSA        IFNE      *BLANKS
     C                   EVAL      DSDSSNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSSN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5228'
     C                   END
      *
      ** THIS FIELD MAY ONLY BE ENTERED FOR DELIVER INSTRUCTIONS
      *
     C     @REDE         IFEQ      'TS'
     C     DSGMEC        ANDNE     'Y'
     C                   EVAL      DSDSSNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSSN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5290'
     C                   END
      *
      ** SET ON ERROR INDICATOR FOR THIS FIELD BEFORE VALIDATION
      *
     C     DSDSSNOK      IFEQ      'Y'
     C                   MOVE      'N'           DSDSSNOK
      *
      ** VALIDATE CUSTOMER NO/SHORTNAME/NOSTRO
      *
     C                   MOVE      DSDSSN        WWCUST
     C                   EVAL      WWFLDNAM = 'DSDSSN'
     C                   EXSR      SRCUST
      *
      ** RESET ERROR INDICATOR IF FIELD IS VALID
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C     WWCUSS        OREQ      'N'
     C                   MOVE      'Y'           DSDSSNOK
     C                   END
      *
      ** CUSTOMER NO/SHORTNAME
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C**********         MOVEL     BBCUST        WWDSSN                                     AR596955
     C                   EVAL      WWDSSN = BBCUST                                          AR596955
     C                   END
      *
      ** NOSTRO
      *
     C     WWCUSS        IFEQ      'N'
     C**********         MOVEL     AWCPNC        WWDSSN                                     AR596955
     C                   EVAL      WWDSSN = AWCPNC                                          AR596955
     C                   END
      *
     C                   END
      *
     C                   ELSE
      *
      ** ELSE if screen field is blank but account line 1 is not blank
      ** THEN it is an error.
      *
     C     DSDSSN        IFEQ      *BLANKS
     C     DSDSS1        ANDNE     *BLANKS
     C                   MOVE      '1'           OVER8
     C                   EVAL      DSDSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5208'
     C                   ENDIF
      *
      ** ELSE IF SCREEN FIELD IS BLANK, ENSURE WORKFIELD IS ALSO BLANK
      *
     C                   MOVE      *BLANKS       WWDSSN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDSS1 - VALIDATE DELIVERER OF SECURITES A/C LINE 1 :87:      *
      *****************************************************************
     C     SRDSS1        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C                   MOVEL     DSDSS1        WWDSS1            1
      *
     C     DSDSS1        IFNE      *BLANKS
     C     WWDSS1        ANDNE     '#'
      *
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER8         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER8
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER8         IFNE      'Y'
      *
     C     @REDE         IFEQ      'TS'
     C     DSGMEC        ANDNE     'Y'
     C                   EVAL      DSDSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5290'
     C                   END
      *
     C     WWDSS1        IFNE      '/'
     C                   MOVE      '1'           OVER8
     C                   EVAL      DSDSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5210'
     C                   END
      *
     C                   MOVEL     DSDSS1        WWLI02
      *
     C     WWDSS1        IFEQ      '//'
     C                   MOVE      '1'           OVER8
     C                   EVAL      DSDSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5211'
     C                   END
      *
     C                   MOVE      DSDSS1        WWLI34
      *
     C     WWLI01        IFEQ      '/'
     C     WWLI34        ANDEQ     *BLANKS
     C                   MOVE      '1'           OVER8
     C                   EVAL      DSDSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5212'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDSS2 - VALIDATE DELIVERER OF SECURITES A/C LINE 2 :87:      *
      *****************************************************************
     C     SRDSS2        BEGSR
      *
      ** VALIDATE IF NOT BLANK AND NOT OVERRIDDEN
      *
     C                   MOVEL     DSDSS2        WWDSS2            1
      *
     C     DSDSS2        IFNE      *BLANKS
     C     WWDSS2        ANDNE     '#'
     C     OVER8         ANDNE     'Y'                                          1st line overr.
      *
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER8         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER8
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER8         IFNE      'Y'
      *
     C     DSDSS1        IFEQ      *BLANKS
     C                   EVAL      DSDSS2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5255'
     C                   END
      *
     C     DSDSS2        IFEQ      DSDSS1
     C                   EVAL      DSDSS2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5258'
     C                   END
      *
     C                   MOVEL     DSDSS2        WWLI02
     C                   MOVE      DSDSS2        WWLI33
      *
     C     WWLI02        IFNE      '//'
     C     WWLI33        OREQ      *BLANKS
     C                   MOVE      '1'           OVER8
     C                   EVAL      DSDSS2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5213'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDSS3 - VALIDATE DELIVERER OF SECURITES A/C LINE 3 :87:      *
      *****************************************************************
     C     SRDSS3        BEGSR
      *
      ** VALIDATE IF NOT BLANK AND NOT OVERRIDDEN
      *
     C                   MOVEL     DSDSS3        WWDSS3            1
      *
     C     DSDSS3        IFNE      *BLANKS
     C     WWDSS3        ANDNE     '#'
     C     OVER8         ANDNE     'Y'                                          1st line overr.
      *
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER8         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER8
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER8         IFNE      'Y'
      *
     C     DSDSS2        IFEQ      *BLANKS
     C                   EVAL      DSDSS3OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS3'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5255'
     C                   END
      *
     C     DSDSS3        IFEQ      DSDSS2
     C                   EVAL      DSDSS3OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS3'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5258'
     C                   END
      *
     C                   MOVEL     DSDSS3        WWLI02
     C                   MOVE      DSDSS3        WWLI33
      *
     C     WWLI02        IFNE      '//'
     C     WWLI33        OREQ      *BLANKS
     C                   MOVE      '1'           OVER8
     C                   EVAL      DSDSS3OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS3'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5213'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDSS4 - VALIDATE DELIVERER OF SECURITES A/C LINE 4 :87:      *
      *****************************************************************
     C     SRDSS4        BEGSR
      *
      ** VALIDATE IF NOT BLANK AND NOT OVERRIDDEN
      *
     C                   MOVEL     DSDSS4        WWDSS4            1
      *
     C     DSDSS4        IFNE      *BLANKS
     C     WWDSS4        ANDNE     '#'
     C     OVER8         ANDNE     'Y'                                          1st line overr.
      *
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER8         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER8
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER8         IFNE      'Y'
      *
     C     DSDSS3        IFEQ      *BLANKS
     C                   EVAL      DSDSS4OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS4'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5255'
     C                   END
      *
     C     DSDSS4        IFEQ      DSDSS3
     C                   EVAL      DSDSS4OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS4'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5258'
     C                   END
      *
     C                   MOVEL     DSDSS4        WWLI02
     C                   MOVE      DSDSS4        WWLI33
      *
     C     WWLI02        IFNE      '//'
     C     WWLI33        OREQ      *BLANKS
     C                   MOVE      '1'           OVER8
     C                   EVAL      DSDSS4OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSDSS4'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5213'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBSSA - VALIDATE BENEFICIARY OF SECURITIES TAG :88:          *
      *****************************************************************
     C     SRBSSA        BEGSR
      *
      ** THIS FIELD CAN ONLY BE ENTERED FOR CLEARANCE TYPE 1 TO 4
      *
     C                   IF        @CLAS = 'E' OR @CLAS = 'C'
      *
     C     DSBSSA        IFNE      'C'
     C     DSBSSA        ANDNE     'D'
     C     DSBSSA        ANDNE     *BLANK
     C                   EVAL      DSBSSAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBSSA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5223'
     C                   END
      *
      ** THE A/C LINES MAY NOT BE LEFT BLANK WHEN ENTERING THE TAG FIELD
      *
     C     DSBSSA        IFNE      *BLANK
     C     DSBSS1        ANDEQ     *BLANK
     C                   EVAL      DSBSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5227'
     C                   END
      *
     C                   ELSE
      *
      ** THIS FIELD MUST BE LEFT BLANK IF CLEARANCE TYPE NOT 1 TO 4
      *
     C     DSBSSA        IFNE      *BLANK
     C                   EVAL      DSBSSAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBSSA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5221'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBSSN - VALIDATE BENEFICIARY OF SECURITIES :88:              *
      *****************************************************************
     C     SRBSSN        BEGSR
      *
      ** Beneficiary is mandatory if ISO15022 is 'Y'
      ** and movement type is Walk-Out.
      *
     C     DS1522        IFEQ      'Y'
     C     DSGMES        ANDEQ     'Y'
     C*****CSE028        ANDEQ     'Y'                                                        225421
     C     DPMVType      ANDEQ     'WO'
     C     DSBSSN        ANDEQ     *BLANKS
     C                   EVAL      DSBSSNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBSSN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW9005'
     C                   ENDIF
      *
      ** VALIDATE IF NOT BLANK
      *
     C     DSBSSN        IFNE      *BLANKS
      *
      ** TAG FIELD MUST BE LEFT BLANK
      *
     C     DSBSSA        IFNE      *BLANKS
     C                   EVAL      DSBSSNOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBSSN'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5228'
     C                   ELSE
      *
      ** SET ON ERROR INDICATOR FOR THIS FIELD BEFORE VALIDATION
      *
     C                   MOVE      'N'           DSBSSNOK
      *
      ** VALIDATE CUSTOMER NO/SHORTNAME/NOSTRO
      *
     C                   MOVE      DSBSSN        WWCUST
     C                   EVAL      WWFLDNAM = 'DSBSSN'
     C                   EXSR      SRCUST
      *
      ** RESET ERROR INDICATOR IF FIELD IS VALID
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C     WWCUSS        OREQ      'N'
     C                   MOVE      'Y'           DSBSSNOK
     C                   END
      *
      ** CUSTOMER NO/SHORTNAME
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C**********         MOVEL     BBCUST        WWBSSN                                     AR596955
     C                   EVAL      WWBSSN = BBCUST                                          AR596955
     C                   END
      *
      ** NOSTRO
      *
     C     WWCUSS        IFEQ      'N'
     C**********         MOVEL     AWCPNC        WWBSSN                                     AR596955
     C                   EVAL      WWBSSN = AWCPNC                                          AR596955
     C                   END
      *
     C                   END
      *
     C                   ELSE
      *
      ** ELSE IF SCREEN FIELD IS BLANK, ENSURE WORKFIELD IS ALSO BLANK
      *
     C                   MOVE      *BLANKS       WWBSSN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBSS1 - VALIDATE BENEFICIARY OF SECURITIES A/C LINE :88:     *
      *****************************************************************
     C     SRBSS1        BEGSR
      *
      ** VALIDATE IF NOT BLANK
      *
     C                   MOVEL     DSBSS1        WWBSS1            1
      *
     C     DSBSS1        IFNE      *BLANKS
     C     WWBSS1        ANDNE     '#'
      *
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER9         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER9
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER9         IFNE      'Y'
      *
     C     WWBSS1        IFNE      '/'
     C                   MOVE      '1'           OVER9
     C                   EVAL      DSBSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5210'
     C                   END
      *
     C                   MOVEL     DSBSS1        WWLI02
      *
     C     WWBSS1        IFEQ      '//'
     C                   MOVE      '1'           OVER9
     C                   EVAL      DSBSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5211'
     C                   END
      *
     C                   MOVE      DSBSS1        WWLI34
      *
     C     WWLI01        IFEQ      '/'
     C     WWLI34        ANDEQ     *BLANKS
     C                   MOVE      '1'           OVER9
     C                   EVAL      DSBSS1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBSS1'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5212'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBSS2 - VALIDATE BENEFICIARY OF SECURITIES A/C LINE :88:     *
      *****************************************************************
     C     SRBSS2        BEGSR
      *
      ** VALIDATE IF NOT BLANK AND NOT OVERRIDDEN
      *
     C                   MOVEL     DSBSS2        WWBSS2            1
      *
     C     DSBSS2        IFNE      *BLANKS
     C     WWBSS2        ANDNE     '#'
     C     OVER9         ANDNE     'Y'                                          1st line overr.
      *
      ** OVERRIDE BY F18
      *
     C     @CLAS         IFEQ      'C'
     C     @INKS         ANDEQ     '1'
     C     OVER9         ANDEQ     '1'
     C                   MOVE      '0'           @INKS
     C                   MOVE      'Y'           OVER9
     C                   END
      *
      ** IF NOT OVERRIDDEN
      *
     C     OVER9         IFNE      'Y'
      *
     C     DSBSS1        IFEQ      *BLANKS
     C                   EVAL      DSBSS2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBSS2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5255'
     C                   END
      *
     C     DSBSS2        IFEQ      DSBSS1
     C                   EVAL      DSBSS2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBSS2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5258'
     C                   END
      *
     C                   MOVEL     DSBSS2        WWLI02
     C                   MOVE      DSBSS2        WWLI33
      *
     C     WWLI02        IFNE      '//'
     C     WWLI33        OREQ      *BLANKS
     C                   MOVE      '1'           OVER9
     C                   EVAL      DSBSS2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSBSS2'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5213'
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINTM - Validate Intermediary Fields                         *
      *****************************************************************
     C     SRINTM        BEGSR
      *
     C                   MOVE      'N'           WERROR            1
     C                   MOVE      'Y'           WImFlg            1
     C                   CLEAR                   WIMDArr
      *
      ** Previous Intermediary field should not be blank
      *
     C                   IF        DSIMMD1 = *BLANKS and DSIMMD2 <> *BLANKS
     C                   EVAL      DSIMMD1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Idx = Idx + 1
     C   99              EVAL      MsgIdArr(Idx) = 'SE10025'
     C   99              EVAL      FldNameArr(Idx) = 'DSIMMD1'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
      *
     C**********         IF        DSIMMD2 = *BLANKS and DSIMMD3 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      DSIMMD2OK = 'N'                                           CSW206D
     C*****Idx**         COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10024'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMMD2'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
      *
     C**********         IF        DSIMMD3 = *BLANKS and DSIMMD4 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      DSIMMD3OK = 'N'                                           CSW206D
     C*****Idx**         COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10023'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMMD3'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
      *
     C**********         IF        DSIMMD4 = *BLANKS and DSIMMD5 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      DSIMMD4OK = 'N'                                           CSW206D
     C*****Idx**         COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10022'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMMD4'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
      *
     C**********         IF        DSIMMD5 = *BLANKS and DSIMMD6 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      DSIMMD5OK = 'N'                                           CSW206D
     C*****Idx**         COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10021'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMMD5'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
      *
     C**********         IF        DSIMMD6 = *BLANKS and DSIMMD7 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      DSIMMD6OK = 'N'                                           CSW206D
     C*****Idx**         COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10020'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMMD6'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
      *
     C**********         IF        DSIMMD7 = *BLANKS and DSIMMD8 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      DSIMMD7OK = 'N'                                           CSW206D
     C*****Idx           COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10019'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMMD7'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
      *
     C**********         IF        DSIMMD8 = *BLANKS and DSIMMD9 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      DSIMMD8OK = 'N'                                           CSW206D
     C*****Idx**         COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10018'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMMD8'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
                                                                                             CSW206E
     C                   IF        DSIMMD2 = *BLANKS and DSIMMD3 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      DSIMMD2OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10024'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMMD2'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                      CSW206E
     C                   IF        DSIMMD3 = *BLANKS and DSIMMD4 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      DSIMMD3OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10023'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMMD3'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                      CSW206E
     C                   IF        DSIMMD4 = *BLANKS and DSIMMD5 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      DSIMMD4OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10022'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMMD4'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                      CSW206E
     C                   IF        DSIMMD5 = *BLANKS and DSIMMD6 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      DSIMMD5OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10021'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMMD5'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                      CSW206E
     C                   IF        DSIMMD6 = *BLANKS and DSIMMD7 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      DSIMMD6OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10020'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMMD6'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                      CSW206E
     C                   IF        DSIMMD7 = *BLANKS and DSIMMD8 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      DSIMMD7OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10019'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMMD7'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                      CSW206E
     C                   IF        DSIMMD8 = *BLANKS and DSIMMD9 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      DSIMMD8OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10018'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMMD8'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E
      *
      ** Check if Intermediary is valid customer or BIC code
      *
 B1  C                   IF        WERROR = 'N'
      *
     C                   MOVE      DSIMMD1       @IM(1)
     C                   MOVE      DSIMMD2       @IM(2)
     C**********         MOVE      DSIMMD3       @IM(3)                                      CSW206D
     C**********         MOVE      DSIMMD4       @IM(4)                                      CSW206D
     C**********         MOVE      DSIMMD5       @IM(5)                                      CSW206D
     C**********         MOVE      DSIMMD6       @IM(6)                                      CSW206D
     C**********         MOVE      DSIMMD7       @IM(7)                                      CSW206D
     C**********         MOVE      DSIMMD8       @IM(8)                                      CSW206D
     C**********         MOVE      DSIMMD9       @IM(9)                                      CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVE      DSIMMD3       @IM(3)                                      CSW206E
     C                   MOVE      DSIMMD4       @IM(4)                                      CSW206E
     C                   MOVE      DSIMMD5       @IM(5)                                      CSW206E
     C                   MOVE      DSIMMD6       @IM(6)                                      CSW206E
     C                   MOVE      DSIMMD7       @IM(7)                                      CSW206E
     C                   MOVE      DSIMMD8       @IM(8)                                      CSW206E
     C                   MOVE      DSIMMD9       @IM(9)                                      CSW206E
     C                   ENDIF                                                               CSW206E
     C                   Z-ADD     1             X                 3 0
     C                   Z-ADD     1             C                 3 0
      *
 B2  C**********         DOW       X < 10                                                    CSW206D
 B2  C**********         DOW       X < 3                                             CSW206D CSW206E
 B2  C                   DOW       X < 10                                                    CSW206E
      *
 B3  C                   IF        @IM(X) <> *BLANKS
     C                   EVAL      WWIMMD = @IM(X)
     C                   EXSR      SRCUST2
      *
 B4  C                   IF        JFIMMD <> *BLANKS
     C                   EVAL      WWIMMD = JFIMMD
 E4  C                   ENDIF
      *
     C                   EVAL      @IM(X) = WWIMMD
      *
 B4  C                   IF        (PBICR = 'MIN0246' and WCLAS = 'B') or
     C                             (@RTCD <> *BLANKS) or (WUnqeFlg = 'Y')
      *
     C                   MOVE      X             WFldNum           1
     C     'DSIMMD'      CAT       WFldNum       WFIELD            7
      *
      ** Select OK flag to set to 'N'
      *
 B5  C                   SELECT
 X5  C                   WHEN      C = 1
     C                   EVAL      DSIMMD1OK = 'N'
      *
 X5  C                   WHEN      C = 3
     C                   EVAL      DSIMMD2OK = 'N'
      *
 X5  C**********         WHEN      C = 5                                                     CSW206D
     C**********         EVAL      DSIMMD3OK = 'N'                                           CSW206D
      *
 X5  C**********         WHEN      C = 7                                                     CSW206D
     C**********         EVAL      DSIMMD4OK = 'N'                                           CSW206D
      *
 X5  C**********         WHEN      C = 9                                                     CSW206D
     C**********         EVAL      DSIMMD5OK = 'N'                                           CSW206D
      *
 X5  C**********         WHEN      C = 11                                                    CSW206D
     C**********         EVAL      DSIMMD6OK = 'N'                                           CSW206D
      *
 X5  C**********         WHEN      C = 13                                                    CSW206D
     C**********         EVAL      DSIMMD7OK = 'N'                                           CSW206D
      *
 X5  C**********         WHEN      C = 15                                                    CSW206D
     C**********         EVAL      DSIMMD8OK = 'N'                                           CSW206D
      *
 X5  C**********         WHEN      C = 17                                                    CSW206D
     C**********         EVAL      DSIMMD9OK = 'N'                                           CSW206D
      *                                                                                      CSW206E
 X5  C                   WHEN      C = 5                                                     CSW206E
     C                   EVAL      DSIMMD3OK = 'N'                                           CSW206E
      *                                                                                      CSW206E
 X5  C                   WHEN      C = 7                                                     CSW206E
     C                   EVAL      DSIMMD4OK = 'N'                                           CSW206E
      *                                                                                      CSW206E
 X5  C                   WHEN      C = 9                                                     CSW206E
     C                   EVAL      DSIMMD5OK = 'N'                                           CSW206E
      *                                                                                      CSW206E
 X5  C                   WHEN      C = 11                                                    CSW206E
     C                   EVAL      DSIMMD6OK = 'N'                                           CSW206E
      *                                                                                      CSW206E
 X5  C                   WHEN      C = 13                                                    CSW206E
     C                   EVAL      DSIMMD7OK = 'N'                                           CSW206E
      *                                                                                      CSW206E
 X5  C                   WHEN      C = 15                                                    CSW206E
     C                   EVAL      DSIMMD8OK = 'N'                                           CSW206E
      *                                                                                      CSW206E
 X5  C                   WHEN      C = 17                                                    CSW206E
     C                   EVAL      DSIMMD9OK = 'N'                                           CSW206E
 E5  C                   ENDSL
      *
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Idx = Idx + 1
     C   99              EVAL      FldNameArr(Idx) = WFIELD
      *
 B5  C   99              IF        WUnqeFlg = 'Y'
     C                   EVAL      MsgIdArr(Idx) = 'SE10038'
 X5  C                   ELSE
     C                   EVAL      MsgIdArr(Idx) = 'SE10026'
 E5  C                   ENDIF
      *
 E4  C                   ENDIF
      *
 E3  C                   ENDIF
      *
     C                   ADD       2             C
     C                   ADD       1             X
      *
     C                   IF        CSW206 = 'Y' and X = 3                                    CSW206E
     C                   EVAL      X = 10                                                    CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                      CSW206E
 E2  C                   ENDDO
      *
     C                   MOVEA     @IM(1)        DSIMMD1
     C                   MOVEA     @IM(2)        DSIMMD2
     C**********         MOVEA     @IM(3)        DSIMMD3                                     CSW206D
     C**********         MOVEA     @IM(4)        DSIMMD4                                     CSW206D
     C**********         MOVEA     @IM(5)        DSIMMD5                                     CSW206D
     C**********         MOVEA     @IM(6)        DSIMMD6                                     CSW206D
     C**********         MOVEA     @IM(7)        DSIMMD7                                     CSW206D
     C**********         MOVEA     @IM(8)        DSIMMD8                                     CSW206D
     C**********         MOVEA     @IM(9)        DSIMMD9                                     CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVEA     @IM(3)        DSIMMD3                                     CSW206E
     C                   MOVEA     @IM(4)        DSIMMD4                                     CSW206E
     C                   MOVEA     @IM(5)        DSIMMD5                                     CSW206E
     C                   MOVEA     @IM(6)        DSIMMD6                                     CSW206E
     C                   MOVEA     @IM(7)        DSIMMD7                                     CSW206E
     C                   MOVEA     @IM(8)        DSIMMD8                                     CSW206E
     C                   MOVEA     @IM(9)        DSIMMD9                                     CSW206E
     C                   ENDIF                                                               CSW206E
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSAFE - Validate Safekeeping Account Fields                  *
      *****************************************************************
     C     SRSAFE        BEGSR
      *
      ** Corresponding Intermediary field should not be blank
      *
     C                   IF        DSIMSA1 <> *BLANKS and DSIMMD1 = *BLANKS
     C                   EVAL      DSIMSA1OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Idx = Idx + 1
     C   99              EVAL      MsgIdArr(Idx) = 'SE10009'
     C   99              EVAL      FldNameArr(Idx) = 'DSIMSA1'
     C                   ENDIF
      *
     C                   IF        DSIMSA2 <> *BLANKS and DSIMMD2 = *BLANKS
     C                   EVAL      DSIMSA2OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Idx = Idx + 1
     C   99              EVAL      MsgIdArr(Idx) = 'SE10010'
     C   99              EVAL      FldNameArr(Idx) = 'DSIMSA2'
     C                   ENDIF
      *
     C**********         IF        DSIMSA3 <> *BLANKS and DSIMMD3 = *BLANKS                  CSW206D
     C**********         EVAL      DSIMSA3OK = 'N'                                           CSW206D
     C*****Idx**         COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10011'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMSA3'                               CSW206D
     C**********         ENDIF                                                               CSW206D
      *
     C**********         IF        DSIMSA4 <> *BLANKS and DSIMMD4 = *BLANKS                  CSW206D
     C**********         EVAL      DSIMSA4OK = 'N'                                           CSW206D
     C*****Idx**         COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10012'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMSA4'                               CSW206D
     C**********         ENDIF                                                               CSW206D
      *
     C**********         IF        DSIMSA5 <> *BLANKS and DSIMMD5 = *BLANKS                  CSW206D
     C**********         EVAL      DSIMSA5OK = 'N'                                           CSW206D
     C*****Idx**         COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10013'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMSA5'                               CSW206D
     C**********         ENDIF                                                               CSW206D
      *
     C**********         IF        DSIMSA6 <> *BLANKS and DSIMMD6 = *BLANKS                  CSW206D
     C**********         EVAL      DSIMSA6OK = 'N'                                           CSW206D
     C*****Idx**         COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10014'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMSA6'                               CSW206D
     C**********         ENDIF                                                               CSW206D
      *
     C**********         IF        DSIMSA7 <> *BLANKS and DSIMMD7 = *BLANKS                  CSW206D
     C**********         EVAL      DSIMSA7OK = 'N'                                           CSW206D
     C*****Idx**         COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10015'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMSA7'                               CSW206D
     C**********         ENDIF                                                               CSW206D
      *
     C**********         IF        DSIMSA8 <> *BLANKS and DSIMMD8 = *BLANKS                  CSW206D
     C**********         EVAL      DSIMSA8OK = 'N'                                           CSW206D
     C*****Idx**         COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10016'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMSA8'                               CSW206D
     C**********         ENDIF                                                               CSW206D
      *
     C**********         IF        DSIMSA9 <> *BLANKS and DSIMMD9 = *BLANKS                  CSW206D
     C**********         EVAL      DSIMSA9OK = 'N'                                           CSW206D
     C*****Idx**         COMP      ArrayMax                             99      -Lower-      CSW206D
     C***99*****         EVAL      Idx = Idx + 1                                             CSW206D
     C***99*****         EVAL      MsgIdArr(Idx) = 'SE10017'                                 CSW206D
     C***99*****         EVAL      FldNameArr(Idx) = 'DSIMSA9'                               CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
                                                                                             CSW206E
     C                   IF        DSIMSA3 <> *BLANKS and DSIMMD3 = *BLANKS                  CSW206E
     C                   EVAL      DSIMSA3OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10011'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMSA3'                               CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                      CSW206E
     C                   IF        DSIMSA4 <> *BLANKS and DSIMMD4 = *BLANKS                  CSW206E
     C                   EVAL      DSIMSA4OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10012'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMSA4'                               CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                      CSW206E
     C                   IF        DSIMSA5 <> *BLANKS and DSIMMD5 = *BLANKS                  CSW206E
     C                   EVAL      DSIMSA5OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10013'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMSA5'                               CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                      CSW206E
     C                   IF        DSIMSA6 <> *BLANKS and DSIMMD6 = *BLANKS                  CSW206E
     C                   EVAL      DSIMSA6OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10014'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMSA6'                               CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                      CSW206E
     C                   IF        DSIMSA7 <> *BLANKS and DSIMMD7 = *BLANKS                  CSW206E
     C                   EVAL      DSIMSA7OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10015'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMSA7'                               CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                      CSW206E
     C                   IF        DSIMSA8 <> *BLANKS and DSIMMD8 = *BLANKS                  CSW206E
     C                   EVAL      DSIMSA8OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10016'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMSA8'                               CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                      CSW206E
     C                   IF        DSIMSA9 <> *BLANKS and DSIMMD9 = *BLANKS                  CSW206E
     C                   EVAL      DSIMSA9OK = 'N'                                           CSW206E
     C     Idx           COMP      ArrayMax                             99      -Lower-      CSW206E
     C   99              EVAL      Idx = Idx + 1                                             CSW206E
     C   99              EVAL      MsgIdArr(Idx) = 'SE10017'                                 CSW206E
     C   99              EVAL      FldNameArr(Idx) = 'DSIMSA9'                               CSW206E
     C                   ENDIF                                                               CSW206E
     C                   ENDIF                                                               CSW206E
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPSET - Validate Place of Settlement                         *
      *****************************************************************
     C     SRPSET        BEGSR
      *
     C                   EVAL      WImFlg = 'Y'
      *
     C                   IF        DSPSET <> *BLANKS
     C                   EVAL      WWIMMD = DSPSET
     C                   EXSR      SRCUST2
     C                   EVAL      DSPSET = WWIMMD
      *
     C                   IF        (PBICR = 'MIN0246' and WCLAS = 'B') or
     C                             (@RTCD <> *BLANKS)
     C                   EVAL      DSPSETOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              EVAL      Idx = Idx + 1
     C   99              EVAL      MsgIdArr(Idx) = 'SE10031'
     C   99              EVAL      FldNameArr(Idx) = 'DSPSET'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      * SRQFIN - VALIDATE QUALIFIED FOREIGN INTERMEDIARY              *                       CSW210
      *****************************************************************                       CSW210
     C     SRQFIN        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Validate if Qualified Foreign Intermediary is not blank                              CSW210
      *                                                                                       CSW210
     C     DSQFIN        IFNE      *BLANKS                                                    CSW210
      *                                                                                       CSW210
      ** Set error indicator on this field before validation                                  CSW210
      *                                                                                       CSW210
     C                   IF        DSQFINOK = 'Y'                                             CSW210
     C                   EVAL      DSQFINOK = 'N'                                             CSW210
      *                                                                                       CSW210
      ** Validate Qualified Foreign Intermediary                                              CSW210
      *                                                                                       CSW210
     C                   MOVE      DSQFIN        WWCUST                                       CSW210
     C                   EVAL      WWFLDNAM = 'DSQFIN'                                        CSW210
     C                   EXSR      SRCUST                                                     CSW210
      *                                                                                       CSW210
      ** Reset error indicator if field is valid                                              CSW210
      *                                                                                       CSW210
     C                   IF        WWCUSS = 'C' OR                                            CSW210
     C                             WWCUSS = 'S' OR                                            CSW210
     C                             WWCUSS = 'N'                                               CSW210
     C                   EVAL      DSQFINOK = 'Y'                                             CSW210
     C                   END                                                                  CSW210
      *                                                                                       CSW210
      ** Customer Number/Shortname                                                            CSW210
      *                                                                                       CSW210
     C     WWCUSS        IFEQ      'C'                                                        CSW210
     C     WWCUSS        OREQ      'S'                                                        CSW210
     C**********         MOVEL     BBCUST        WWQFIN           10                 CSW210 AR596955
     C                   EVAL      WWQFIN = BBCUST                                          AR596955
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Nostro                                                                               CSW210
      *                                                                                       CSW210
     C     WWCUSS        IFEQ      'N'                                                        CSW210
     C**********         MOVEL     AWCPNC        WWQFIN                              CSW210 AR596955
     C                   EVAL      WWQFIN = AWCPNC                                          AR596955
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ELSE                                                                 CSW210
      *                                                                                       CSW210
      ** Else If Screen Field is Blank, ensure workfield is also Blank                        CSW210
      *                                                                                       CSW210
     C                   MOVE      *BLANKS       WWQFIN                                       CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDSR                                                                CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      * SRPCLR - VALIDATE PLACE OF CLEARING                           *                       CSW210
      *****************************************************************                       CSW210
     C     SRPCLR        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Validate if Place of Clearing is not blank                                           CSW210
      *                                                                                       CSW210
     C     DSPCLR        IFNE      *BLANKS                                                    CSW210
      *                                                                                       CSW210
      ** Set error indicator on this field before validation                                  CSW210
      *                                                                                       CSW210
     C                   IF        DSPCLROK = 'Y'                                             CSW210
     C                   EVAL      DSPCLROK = 'N'                                             CSW210
      *                                                                                       CSW210
      ** Validate Place of Clearing                                                           CSW210
      *                                                                                       CSW210
     C                   MOVE      DSPCLR        WWCUST                                       CSW210
     C                   EVAL      WWFLDNAM = 'DSPCLR'                                        CSW210
     C                   EXSR      SRCUST                                                     CSW210
      *                                                                                       CSW210
      ** Reset error indicator if field is valid                                              CSW210
      *                                                                                       CSW210
     C                   IF        WWCUSS = 'C' OR                                            CSW210
     C                             WWCUSS = 'S' OR                                            CSW210
     C                             WWCUSS = 'N'                                               CSW210
     C                   EVAL      DSPCLROK = 'Y'                                             CSW210
     C                   END                                                                  CSW210
      *                                                                                       CSW210
      ** Customer Number/Shortname                                                            CSW210
      *                                                                                       CSW210
     C     WWCUSS        IFEQ      'C'                                                        CSW210
     C     WWCUSS        OREQ      'S'                                                        CSW210
     C**********         MOVEL     BBCUST        WWPCLR           10                 CSW210 AR596955
     C                   EVAL      WWPCLR = BBCUST                                          AR596955
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Nostro                                                                               CSW210
      *                                                                                       CSW210
     C     WWCUSS        IFEQ      'N'                                                        CSW210
     C**********         MOVEL     AWCPNC        WWPCLR                              CSW210 AR596955
     C                   EVAL      WWPCLR = AWCPNC                                          AR596955
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ELSE                                                                 CSW210
      *                                                                                       CSW210
      ** Else If Screen Field is Blank, ensure workfield is also Blank                        CSW210
      *                                                                                       CSW210
     C                   MOVE      *BLANKS       WWPCLR                                       CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDSR                                                                CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      * SRIBAN - to check IBAN                                        *                       CSW210
      *****************************************************************                       CSW210
     C     SRIBAN        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Temporary work variable for IBAN                                                     CSW210
      *                                                                                       CSW210
     C                   MOVEL     *BLANKS       WIBRTN           35                          CSW210
     C                   MOVEL     *BLANKS       WTIBAN           34                          CSW210
     C                   MOVEL     *BLANKS       WTIBA1           47                          CSW210
     C                   MOVEL     'N'           WVIBAN            1                          CSW210
     C                   MOVEL     'N'           WIBNWR            1                          CSW210
     C                   IF        DSISLH = '/'                                               CSW210
     C                   MOVEL     DSIBN2        WTIBA1                                       CSW210
     C                   ELSE                                                                 CSW210
     C                   MOVEL     DSIBAN        WTIBA1                                       CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   CALL      'AOIBANR3'                                                 CSW210
     C                   PARM      *BLANKS       @RTCD                                        CSW210
     C                   PARM                    WTIBA1                                       CSW210
     C                   PARM                    WIBLNK           47                          CSW210
     C                   PARM                    WOBLNK           34                          CSW210
      *                                                                                       CSW210
     C     2             SUBST     WOBLNK:1      WOBCH             2                          CSW210
     C     2             SUBST     WOBLNK:3      WOBNB             2                          CSW210
      *                                                                                       CSW210
     C     ALPHAB        CHECK     WOBCH                                  81                  CSW210
     C  N81NMBRS         CHECK     WOBNB                                  81                  CSW210
      *                                                                                       CSW210
      ** IBAN starts with 'AANN'                                                              CSW210
      *                                                                                       CSW210
     C                   IF        *IN81 = *OFF                                               CSW210
     C                   EVAL      WTIBAN = WOBLNK                                            CSW210
      *                                                                                       CSW210
     C                   CALL      'AOIBANR5'                           81                    CSW210
     C                   PARM      *BLANKS       @RTCD                                        CSW210
     C                   PARM                    WTIBAN                                       CSW210
      *                                                                                       CSW210
     C                   IF        @RTCD = *BLANKS AND                                        CSW210
     C                             *IN81 = *OFF                                               CSW210
     C                   EVAL      WVIBAN = 'Y'                                               CSW210
     C                   MOVEL     WTIBAN        WIBRTN                                       CSW210
     C                   ELSE                                                                 CSW210
     C     WIdx          COMP      ArrayMax                             99      -Lower-       CSW210
     C   99              ADD       1             WIdx                                         CSW210
     C                   SELECT                                                               CSW210
     C                   WHEN      @RTCD = '      1'                                          CSW210
     C   99              EVAL      WMsgIdArr(WIdx) = 'ST00102'                                CSW210
     C                   WHEN      @RTCD = '      2'                                          CSW210
     C   99              EVAL      WMsgIdArr(WIdx) = 'ST00103'                                CSW210
     C                   WHEN      @RTCD = '      3'                                          CSW210
     C   99              EVAL      WMsgIdArr(WIdx) = 'ST00104'                                CSW210
     C                   WHEN      @RTCD = '      4'                                          CSW210
     C   99              EVAL      WMsgIdArr(WIdx) = 'ST00105'                                CSW210
     C                   WHEN      @RTCD = '      5'                                          CSW210
     C   99              EVAL      WMsgIdArr(WIdx) = 'ST00106'                                CSW210
     C                   OTHER                                                                CSW210
     C   99              EVAL      WMsgIdArr(WIdx) = 'ST00107'                                CSW210
     C                   ENDSL                                                                CSW210
     C                   EVAL      WIBNWR = 'Y'                                               CSW210
     C**********         IF        DSISLH = '/'                                      CSW210 AR642262
     C*****'/'**         CAT       WTIBAN        WTIBAN                              CSW210 AR642262
     C**********         ENDIF                                                       CSW210 AR642262
     C                   EVAL      WTIBAN = DSIBAN                                          AR642262
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDSR                                                                CSW210
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCUST - VALIDATE CUSTOMER NUMBER/SHORTNAME/NOSTRO            *
      *****************************************************************
     C     SRCUST        BEGSR
      *
     C                   MOVE      *BLANKS       WWCUSS            1
      *
      ** Call Access Program for Customer Details using the Customer
      ** No. or the Customer Shortname.
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      WWCUST        WKEY1            10
     C                   PARM      *BLANKS       WKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** If Return code is blank then set WWCUSS to 'C' if Customer
      ** Number; to 'S' if Customer Shortname.
      *
     C     @RtCd         IFEQ      *BLANK
     C     WKYST         ANDNE     '*ERROR'
      *
     C     WKYST         IFEQ      '*CNUM'
     C                   MOVE      'C'           WWCUSS
     C                   ELSE
     C                   MOVE      'S'           WWCUSS
     C                   END
      *
      ** If Customer Number or Shortname then save file fields.
      *
     C                   MOVE      BBCABA        WWCABA
     C                   MOVE      BBCSID        WWCSID
     C                   MOVE      BBBLCD        WWBLCD
     C                   MOVE      BBFWCD        WWFWCD
     C                   MOVE      BBCHID        WWCHID
     C                   MOVE      BBCHSC        WWCHSC
     C                   MOVE      BBBNBI        WWBNBI
      *
      ** else (error on Customer file) may be a Counterparty Nostro
      *
     C                   ELSE
     C                   MOVEL     WWCUST        WWNOST            8
     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      WWNOST        WKEY2             8
     C     SDCNST        PARM      SDCNST        DSFDY
      *
      ** If Counterparty Nostro found set WWCUSS to 'N'.
      *
     C     @RtCd         IFEQ      *BLANK
     C                   MOVE      'N'           WWCUSS
     C                   MOVE      AWSWID        WWCSID
     C                   MOVE      AWFWCD        WWFWCD            9
     C                   MOVE      'Y'           WWBNBI
     C                   END
      *
     C                   END
      *
      ** If no record found on either file then send error message
      *
     C     WWCUSS        IFNE      'C'
     C     WWCUSS        ANDNE     'S'
     C     WWCUSS        ANDNE     'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = WWFLDNAM
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5205'
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRLI35 - VALIDATE A 35 ALPHA INPUT FIELD                      *
      *****************************************************************
     C     SRLI35        BEGSR
      *
      ** INIT FLAG TO SEND ERROR MESSAGE IF 35A FIELDS NOT CORRECTLY FORMATTED
      *
     C                   MOVE      *BLANKS       WWER35
      *
      ** VALIDATE FIRST CHARACTER
      *
     C     WWLI01        IFNE      '/'
     C                   MOVE      'Y'           WWER35            1
     C                   END
      *
      ** VALIDATE FIRST 2 CHARACTERS
      *
     C     WWLI02        IFEQ      '//'
     C     WWLI04        ANDNE     '//BL'
     C     WWLI04        ANDNE     '//CH'
     C     WWLI04        ANDNE     '//CP'
     C     WWLI04        ANDNE     '//FW'
     C     WWLI04        ANDNE     '//SC'
     C                   MOVE      'Y'           WWER35
     C                   END
      *
      ** VALIDATE FIRST 4 CHARACTERS
      *
     C     @NMCY         IFNE      'USD'
      *
     C     WWLI04        IFEQ      '//CH'
     C     WWLI04        OREQ      '//CP'
     C     WWLI04        OREQ      '//FW'
     C                   MOVE      'Y'           WWER35
     C                   END
      *
     C                   END
      *
     C     @NMCY         IFNE      'DEM'
     C     WWLI04        ANDEQ     '//BL'
     C                   MOVE      'Y'           WWER35
     C                   END
      *
      ** INVALID ENTRY
      *
     C     WWER35        IFEQ      'Y'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = WWFLDNAM
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5235'
     C                   END
      *
      ** VALIDATE FIRST 5 CHARACTERS
      *
     C     WWLI05        IFEQ      '//CP '
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
      *
      ** IF //CP IS FOLLOWED BY BLANKS THEN DEFAULT THIS TO THE
      ** CUSTOMER CHIPS PARTICIPANT
      *
     C     WWBNBI        IFEQ      'Y'
     C     WW0535        ANDEQ     *BLANKS
     C                   MOVEL     WWCABA        WW0507
     C                   END
      *
     C                   END
      *
      ** ERROR IF ' //CP' IS NOT FOLLOWED BY A 3 DIGIT NUMBER
      ** FOLLOWED BY BLANKS
      *
     C                   MOVEL     WW0507        WWNUM4            4 0
     C                   MOVEL     WWNUM4        WWALP3            3
      *
     C     WW0507        IFNE      WWALP3
     C     WW0835        ORNE      *BLANKS
     C                   MOVE      'Y'           WWER35
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = WWFLDNAM
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5236'
     C                   END
      *
     C                   END
      *
      ** IF LEFTMOST 4 CHARS ARE '//FW' FOLLOWED BY BLANKS AND
      ** CUSTOMER SWIFT ID IS BLANK THEN SET UP FEDWIRE ACCOUNT
      *
     C     WWLI04        IFEQ      '//FW'
      *
     C     WW0535        IFEQ      *BLANKS
     C     WWCSID        ANDEQ     *BLANKS
     C                   MOVEL     WWFWCD        WW0513
     C                   END
      *
      ** ERROR IF POSITIONS 14 -35 OF WWLI35 ARE NOT BLANK
      *
     C     WW1435        IFNE      *BLANKS
     C                   MOVE      'Y'           WWER35
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = WWFLDNAM
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5237'
     C                   END
      *
      ** FEDWIRE ACCOUNT MAY ONLY BE BLANK FOR A BANK WITH A VALID SWIFT ADDRESS
      *
     C     WW0513        IFEQ      *BLANKS
      *
     C     WWCUSS        IFNE      'C'
     C     WWCUSS        ANDNE     'S'
     C     WWBNBI        OREQ      'N'
     C     WWCSID        OREQ      *BLANKS
     C                   MOVE      'Y'           WWER35
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = WWFLDNAM
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5238'
     C                   END
      *
     C                   ELSE
      *
      ** ELSE, MUST BE A 9 DIGIT NUMBER
      *
     C                   MOVEL     WW0513        WWNU10           10 0
     C                   MOVEL     WWNU10        WWALP9            9
      *
     C     WW0513        IFNE      WWALP9
     C                   MOVE      'Y'           WWER35
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = WWFLDNAM
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5239'
     C                   END
      *
     C                   END
      *
      ** CUSTOMER OR BANK MUST HAVE A SWIFT ADDRESS OR A FEDWIRE A/C
      *
     C     WWCSID        IFEQ      *BLANKS
     C     WWFWCD        ANDEQ     *BLANKS
     C                   MOVE      'Y'           WWER35
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = WWFLDNAM
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5240'
     C                   END
      *
     C                   END
      *
      ** IF LEFTMOST 4 CHARS OF WWLI35 ARE '//BL' FOLLOWED BY BLANKS
      ** SET UP THE BANKLEITZAHL CODE
      *
     C     WWLI04        IFEQ      '//BL'
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
      *
     C     WWBNBI        IFEQ      'Y'
     C     WW0535        ANDEQ     *BLANKS
     C                   MOVEL     WWBLCD        WW0512
     C                   END
      *
     C                   END
      *
      ** ERROR IF '//BL' NOT FOLLOWED BY 8 DIGITS NUMBER FOLLOWED BY BLANKS
      *
     C                   MOVEL     WW0512        WWNUM9            9 0
     C                   MOVEL     WWNUM9        WWALP8            8
      *
     C     WW0512        IFNE      WWALP8
     C     WW1335        ORNE      *BLANKS
     C                   MOVE      'Y'           WWER35
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = WWFLDNAM
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5241'
     C                   END
      *
     C                   END
      *
      ** IF LEFTMOST 4 CHARS OF WWLI35 ARE '//CH' FOLLOWED BY BLANKS
      ** SET UP CUSTOMER CHIPS UNIVERSAL ID
      *
     C     WWLI04        IFEQ      '//CH'
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
      *
     C     WWBNBI        IFEQ      'Y'
     C     WW0535        ANDEQ     *BLANKS
     C                   MOVEL     WWCHID        WW0510
     C                   END
      *
     C                   END
      *
     C                   END
      *
      ** IF LEFTMOST 4 CHARS OF WWLI35 ARE '//SC' FOLLOWED BY BLANKS
      ** SET UP CHAPS SORT CODE
      *
     C     WWLI04        IFEQ      '//SC'
      *
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
      *
     C     WWBNBI        IFEQ      'Y'
     C     WW0535        ANDEQ     *BLANKS
     C                   MOVEL     WWCHSC        WW0510
     C                   END
      *
     C                   END
      *
     C                   END
      *
      ** ERROR IF '//CH' OR '//SC' ARE NOT FOLLOWED BY A 6 DIGITS NUMBER
      *
     C     WWLI04        IFEQ      '//CH'
     C     WWLI04        OREQ      '//SC'
      *
     C                   MOVEL     WW0510        WWNUM7            7 0
     C                   MOVEL     WWNUM7        WWALP6            6
      *
     C     WW0510        IFNE      WWALP6
     C     WW1135        ORNE      *BLANKS
     C                   MOVE      'Y'           WWER35
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = WWFLDNAM
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5242'
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRME99 - To Validate Account with Line via ME9940             *
      *****************************************************************
     C     SRME99        BEGSR
      *
      ** Clear result flags
      *
     C                   MOVE      *BLANKS       WWER35
     C                   MOVE      *BLANKS       WICNIL            1
      *
      ** Set up common parameters
      *
     C                   MOVE      *BLANKS       W0RTN
     C                   MOVEL     'PAY'         I#PR
      *
     C     WWCUSS        IFEQ      'N'
     C                   MOVEL     'X'           I#PRTT
     C                   ELSE
     C                   MOVEL     WWCUSS        I#PRTT
     C                   ENDIF
      *
     C                   MOVEL     @NMCY         I#PCCY
     C                   MOVEL     @NMCY         I#RCCY
     C                   MOVEL     WWLI35        I#ACLN
     C                   MOVEL     '5XX'         I#MTYP                                     AR589197
     C                   MOVEL     'SEDMES2VL '  E#CPGM
     C                   MOVEL     'MEMSG'       E#MSGF
      *
      ** Call the checking program
      *
     C                   CALL      'ME9940'
     C                   PARM                    W0RTN             7
     C                   PARM                    I#PARM
     C                   PARM                    O#PARM
     C                   PARM                    E#PARM
     C                   PARM      *BLANKS       Z#PARM          256
      *
     C                   MOVEL     O#ACLN        WWLI35
      *
     C     E#ERRM        IFNE      *BLANKS
     C                   MOVEL     'Y'           WWER35
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = WWFLDNAM
     C   99              EVAL      MsgIdArr(Idx)   = E#MSGD
     C   99              EVAL      MsgDtaArr(Idx)  = Z#PARM
     C                   ELSE
      *
      ** Check whether Issuer Code has been defined for the currency
      ** clearing system. If not, set flag on to issue warning message
      ** for later display (SEW5176).
      *
     C                   MOVEL     Z#PARM        W#ISCD            4
      *
     C     WWLI02        IFEQ      '//'
     C     W#ISCD        ANDEQ     *BLANKS
     C                   MOVEL     'Y'           WICNIL
     C     WIdx          COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             WIdx
     C   99              EVAL      WFldNamArr(WIdx) = WWFLDNAM
     C   99              EVAL      WMsgIdArr(WIdx)  = 'SEW5176'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR2001 - To Validate Swift2001 Codewords                      *
      *****************************************************************
     C     SR2001        BEGSR
      *
     C                   MOVEA     WWSR10        WARY
     C                   MOVE      'N'           WERR              1
     C                   Z-ADD     1             X
      *
     C     X             DOWLT     10
     C     WERR          ANDEQ     'N'
     C                   ADD       1             X
     C     WARY(X)       LOOKUP    VA0                                    90
      *
     C     WARY(X)       IFEQ      '/'
     C                   LEAVE
     C                   ENDIF
      *
     C     *IN90         IFEQ      *OFF
     C     X             OREQ      10
     C     WARY(X)       ANDNE     '/'
     C                   MOVE      'Y'           WERR
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     WARY(2)       IFNE      '/'
     C     WERR          ANDEQ     'N'
     C                   MOVE      'Y'           WWVALI
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCUST2 - Check a field as a customer / BIC reference         *
      *****************************************************************
     C     SRCUST2       BEGSR
      *
     C                   MOVE      'C'           WCLAS             1
     C                   MOVE      'N'           WUnqeFlg          1
     C                   EVAL      JFIMMD = *BLANKS
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      WWIMMD        WKEY1
     C                   PARM                    WKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** If Return code is not blank then check if entry is a valid BIC code
      *
     C                   IF        @RtCd <> *BLANKS
     C                   MOVEL     WWIMMD        PCSID8
     C                   MOVE      WWIMMD        PCSID4            4
     C                   MOVEL     PCSID4        PCSID3
      *
     C                   EVAL      WCLAS = 'B'
      *
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       PBICR             7
     C                   PARM                    PCSID8            8
     C                   PARM                    PCSID3            3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       PBICC             1
     C                   PARM      *BLANKS       PBICS             1
     C                   PARM      *BLANKS       PBICI             1
      *
     C                   IF        PBICR = *BLANKS
     C                             OR PBICR = 'MIN0244' AND
     C                             PBICC = 'Y'
     C                   EVAL      @RtCd = *BLANKS
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      WWIMMD = BBCUST
     C                   EVAL      JFIMMD = BBCSID
     C                   ENDIF
      *
      ** Check settlement account is unique
      *
     C                   IF        WImFlg = 'Y'
     C                   Z-ADD     1             WCtr              3 0
      *
     C**********         DOW       WCtr <= 9                                                 CSW206D
     C**********         DOW       WCtr <= 2                                         CSW206D CSW206E
     C                   DOW       WCtr <= 9                                                 CSW206E
      *
     C                   IF        WIMDArr(WCtr) = *BLANKS
     C                   MOVEL     WWIMMD        WIMDArr(WCtr)
     C                   LEAVE
     C                   ELSE
      *
     C                   IF        WIMDArr(WCtr) = WWIMMD
     C                   EVAL      WUnqeFlg = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupValid - Set up the valid file fields                     *
      *****************************************************************
     C     SetupValid    BEGSR
      *
     C                   IF        SVACTN = 'I'
     C                   MOVE      DDDPSS        VD2DPSS
     C                   MOVE      DDDPRN        VD2DPRN
     C                   ENDIF
      *
     C     CSW003        IFEQ      'Y'
     C                   MOVE      'S'           VD2WHEN
     C                   ENDIF
      *
     C                   MOVE      WWAFPN        VD2AFPN
     C                   MOVE      DSAFPL        VD2AFPL
      *
     C     DSBOFN        IFNE      *BLANKS
     C     DSBOF1        ORNE      *BLANKS
     C                   MOVE      DSAWIA        VD2AWIA
     C                   MOVE      WWAWIN        VD2AWIN
     C                   MOVE      DSAWIL        VD2AWIL
     C                   ELSE
     C                   MOVE      *BLANKS       VD2AWIA
     C                   MOVE      *BLANKS       VD2AWIN
     C                   MOVE      *BLANKS       VD2AWIL
     C                   END
      *
     C     DSAWIN        IFNE      *BLANKS
     C     DSAWIL        ORNE      *BLANKS
     C*****CSE028        OREQ      'Y'                                                        225421
     C     DS1522        ANDEQ     'Y'
     C     DSGMES        ANDEQ     'Y'
     C                   MOVE      DSBOFA        VD2BOFA
     C                   MOVE      WWBOFN        VD2BOFN
     C                   MOVE      DSBOF1        VD2BOF1
     C                   IF        CSW210 = 'N'                                               CSW210
     C                   MOVE      DSBOF2        VD2BOF2
     C                   ENDIF                                                                CSW210
     C                   ELSE
     C                   MOVE      *BLANKS       VD2BOFA
     C                   MOVE      *BLANKS       VD2BOFN
     C                   MOVE      *BLANKS       VD2BOF1
     C                   MOVE      *BLANKS       VD2BOF2
     C                   END
      *
     C                   MOVE      DSSRL1        VD2SRL1
     C                   MOVE      DSSRL2        VD2SRL2
     C                   MOVE      DSSRL3        VD2SRL3
     C                   MOVE      DSFIN1        VD2FIN1
     C                   MOVE      DSFIN2        VD2FIN2
     C                   MOVE      DSRED1        VD2RED1
     C                   MOVE      DSRED2        VD2RED2
     C                   MOVE      DSNAL1        VD2NAL1
     C                   MOVE      DSNAL2        VD2NAL2
     C                   MOVE      WWIPYN        VD2IPYN
     C                   MOVE      DSIPYL        VD2IPYL
     C                   MOVE      WWCTYN        VD2CTYN
     C                   MOVE      DSCTYL        VD2CTYL
     C                   MOVE      WWSKAN        VD2SKAN
     C                   MOVE      DSSKAL        VD2SKAL
     C                   MOVE      DSCCTN        VD2CCTN
     C                   MOVE      DSDCTL        VD2DCTL
     C                   MOVE      DSRSSA        VD2RSSA
     C                   MOVE      WWRSSN        VD2RSSN
     C                   MOVE      DSRSS1        VD2RSS1
     C                   MOVE      DSRSS2        VD2RSS2
     C                   MOVE      DSRSS3        VD2RSS3
     C                   MOVE      DSRSS4        VD2RSS4
     C                   MOVE      DSDSSA        VD2DSSA
     C                   MOVE      WWDSSN        VD2DSSN
     C                   MOVE      DSDSS1        VD2DSS1
     C                   MOVE      DSDSS2        VD2DSS2
     C                   MOVE      DSDSS3        VD2DSS3
     C                   MOVE      DSDSS4        VD2DSS4
      *
     C*****DSRSSN        IFNE      *BLANKS                                                  BUG28003
     C*****DSRSS1        ORNE      *BLANKS                                                  BUG28003
     C*****DSDSSN        ORNE      *BLANKS                                                  BUG28003
     C*****DSDSS1        ORNE      *BLANKS                                                  BUG28003
     C                   MOVE      DSBSSA        VD2BSSA
     C                   MOVE      WWBSSN        VD2BSSN
     C                   MOVE      DSBSS1        VD2BSS1
     C                   MOVE      DSBSS2        VD2BSS2
     C**********         ELSE                                                               BUG28003
     C**********         MOVE      *BLANKS       VD2BSSA                                    BUG28003
     C**********         MOVE      *BLANKS       VD2BSSN                                    BUG28003
     C**********         MOVE      *BLANKS       VD2BSS1                                    BUG28003
     C**********         MOVE      *BLANKS       VD2BSS2                                    BUG28003
     C**********         END                                                                BUG28003
      *
     C                   MOVE      WWINVE        VD2INVE
      *
     C                   IF        CSE028 = 'Y'
     C                   EVAL      VD2IMD1 = DSIMMD1
     C                   EVAL      VD2IMD2 = DSIMMD2
     C**********         EVAL      VD2IMD3 = DSIMMD3                                         CSW206D
     C**********         EVAL      VD2IMD4 = DSIMMD4                                         CSW206D
     C**********         EVAL      VD2IMD5 = DSIMMD5                                         CSW206D
     C**********         EVAL      VD2IMD6 = DSIMMD6                                         CSW206D
     C**********         EVAL      VD2IMD7 = DSIMMD7                                         CSW206D
     C**********         EVAL      VD2IMD8 = DSIMMD8                                         CSW206D
     C**********         EVAL      VD2IMD9 = DSIMMD9                                         CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      VD2IMD3 = DSIMMD3                                         CSW206E
     C                   EVAL      VD2IMD4 = DSIMMD4                                         CSW206E
     C                   EVAL      VD2IMD5 = DSIMMD5                                         CSW206E
     C                   EVAL      VD2IMD6 = DSIMMD6                                         CSW206E
     C                   EVAL      VD2IMD7 = DSIMMD7                                         CSW206E
     C                   EVAL      VD2IMD8 = DSIMMD8                                         CSW206E
     C                   EVAL      VD2IMD9 = DSIMMD9                                         CSW206E
     C                   ENDIF                                                               CSW206E
     C                   EVAL      VD2IMS1 = DSIMSA1
     C                   EVAL      VD2IMS2 = DSIMSA2
     C**********         EVAL      VD2IMS3 = DSIMSA3                                         CSW206D
     C**********         EVAL      VD2IMS4 = DSIMSA4                                         CSW206D
     C**********         EVAL      VD2IMS5 = DSIMSA5                                         CSW206D
     C**********         EVAL      VD2IMS6 = DSIMSA6                                         CSW206D
     C**********         EVAL      VD2IMS7 = DSIMSA7                                         CSW206D
     C**********         EVAL      VD2IMS8 = DSIMSA8                                         CSW206D
     C**********         EVAL      VD2IMS9 = DSIMSA9                                         CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      VD2IMS3 = DSIMSA3                                         CSW206E
     C                   EVAL      VD2IMS4 = DSIMSA4                                         CSW206E
     C                   EVAL      VD2IMS5 = DSIMSA5                                         CSW206E
     C                   EVAL      VD2IMS6 = DSIMSA6                                         CSW206E
     C                   EVAL      VD2IMS7 = DSIMSA7                                         CSW206E
     C                   EVAL      VD2IMS8 = DSIMSA8                                         CSW206E
     C                   EVAL      VD2IMS9 = DSIMSA9                                         CSW206E
     C                   ENDIF                                                               CSW206E
     C                   EVAL      VD2PSET = DSPSET
     C                   EVAL      VD2NAC1 = DSNAC1
     C                   EVAL      VD2NAC2 = DSNAC2
     C                   ENDIF
      *                                                                                       CSW210
     C                   IF        CSW210 = 'Y'                                               CSW210
     C                   EVAL      VD2DIDN = WWDIDN                                           CSW210
     C                   EVAL      VD2DAD1 = DSDAD1                                           CSW210
     C                   EVAL      VD2DAD2 = DSDAD2                                           CSW210
     C                   EVAL      VD2DAD3 = DSDAD3                                           CSW210
     C                   EVAL      VD2DAD4 = DSDAD4                                           CSW210
     C                   EVAL      VD2DLIN = DSDLIN                                           CSW210
     C                   EVAL      VD2QFIN = WWQFIN                                           CSW210
     C                   EVAL      VD2PCLR = WWPCLR                                           CSW210
      *                                                                                       CSW210
     C                   IF        CFT004 = 'Y'                                               CSW210
     C                   IF        VDFAI1 = *BLANKS                                           CSW210
     C                   EVAL      VDFAI1 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
     C                   IF        VDFAP1 = *BLANKS                                           CSW210
     C                   EVAL      VDFAP1 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
     C                   IF        VDFBF1 = *BLANKS                                           CSW210
     C                   EVAL      VDFBF1 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
     C                   IF        VDFDBT = *BLANKS                                           CSW210
     C                   EVAL      VDFDBT = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      ** Actual Action Code
     C                   PARM                    SVACTN            1
      ** Screen Fields
     C                   PARM                    NewDPMVFld
      ** Depot movement type
     C                   PARM                    DPMVType          2
      ** Receive/Deliver type
     C                   PARM                    @REDE             2
      ** Calculated Instructions Type
     C                   PARM                    @INST             7
      ** Security Customer classification
     C                   PARM                    @CLAS             1
      ** Security information: Nominal currency
     C                   PARM                    @NMCY             3
      ** Features Status
     C                   PARM                    CSE028            1
     C                   PARM                    CSW003            1
     C                   PARM                    CSW014            1
     C                   PARM                    CSW098            1
     C                   PARM                    CSW201            1
     C                   PARM                    CSE029            1
     C                   PARM                    CSW206            1                         CSW206E
     C                   PARM                    CSW210            1                          CSW210
     C                   PARM                    CFT004            1                          CSW210
      *
      ** INPUT/OUTPUT PARAMETERS
      ** Override validations flags
     C                   PARM                    OVER2             1
     C                   PARM                    OVER3             1
     C                   PARM                    OVER6             1
     C                   PARM                    OVER7             1
     C                   PARM                    OVER8             1
     C                   PARM                    OVER9             1
      ** Overide validations Fonction Key
     C                   PARM                    @INKS             1
     C                   PARM                    WCPTY             6
      *
      ** OUTPUT PARAMETERS
      ** Error indicator flags from/to caller
     C                   PARM                    DPMVOkFlags
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0
      ** Valid Core Extension details layout (DS) from/to caller
     C                   PARM                    NewSEDMX2
      *
      /COPY WNCPYSRC,SEDME2V054
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Define work fields
      *
     C     *LIKE         DEFINE    BBCABA        WWCABA
     C     *LIKE         DEFINE    BBCSID        WWCSID
     C     *LIKE         DEFINE    BBBLCD        WWBLCD
     C     *LIKE         DEFINE    BBCHID        WWCHID
     C     *LIKE         DEFINE    BBCHSC        WWCHSC
     C     *LIKE         DEFINE    BBBNBI        WWBNBI
     C     *LIKE         DEFINE    VD2AFPN       WWAFPN
     C     *LIKE         DEFINE    VD2AWIN       WWAWIN
     C     *LIKE         DEFINE    VD2AWIN       WAWIN
     C     *LIKE         DEFINE    VD2BOFN       WWBOFN
     C     *LIKE         DEFINE    VD2BOFN       WBOFN
     C     *LIKE         DEFINE    VD2IPYN       WWIPYN
     C     *LIKE         DEFINE    VD2CTYN       WWCTYN
     C     *LIKE         DEFINE    VD2SKAN       WWSKAN
     C     *LIKE         DEFINE    VD2RSSN       WWRSSN
     C     *LIKE         DEFINE    VD2DSSN       WWDSSN
     C     *LIKE         DEFINE    VD2BSSN       WWBSSN
     C     *LIKE         DEFINE    VD2INVE       WWINVE
     C     *LIKE         DEFINE    DSIMMD1       WWIMMD
     C     *LIKE         DEFINE    DSIMMD1       JFIMMD
     C     *LIKE         DEFINE    VD2DIDN       WWDIDN                                       CSW210
     C     *LIKE         DEFINE    VD2QFIN       WWQFIN                                       CSW210
     C     *LIKE         DEFINE    VD2PCLR       WWPCLR                                       CSW210
      *
      /COPY WNCPYSRC,SEDME2V055
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003
**CTDATA VA0
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789

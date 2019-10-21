     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL COB Collateral Revaluation')                  *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001500 - Midas GL COB Collateral Revaluation               *
      *                                                               *
      *  Function:  This module will revalue all collaterals held     *
      *             within MidasPlus.                                 *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE147             Date 30Sep11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      *                 BUG27959           Date 05Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27655           Date 12May10               *
      *                 CAP205             Date 05Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 252005             Date 31Jul08               *
      *                 BUG17986           Date 15Apr08               *
      *                 249974             Date 07Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11623           Date 27Jun06               *
      *                 CDL049             Date 07Jul06               *
      *                 238590             Date 14May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CDL038             Date 10May05               *
      *                 BUG6436            Date 30Mar05               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL028             Date 07Feb05               *
      *                 CLE041             Date 11Oct04               *
      *                 CLE040             Date 05Jul04               *
      *                 CGL014  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CLE147 - Aggregate Facility (Recompile)                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  BUG27959 - Error in minimum credit balance format            *
      *  BUG27655 - Convert minimum credit balance to Midas amount    *
      *  CAP205 - Retail Account Balance Check                        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  252005 - Compute for Credit Agreement lending value and      *
      *           ensure that records on GLCOLLPD will be processed   *
      *  BUG17986 - After COB MM Deposit list view is showing zero    *
      *             blocked collateral amount and collateral amount   *
      *  249974 - Collateral flag of transactions should not be       *
      *           reset regardless of the collateral amounts.         *
      *  BUG11623 - Sequence No. column should be included (Recompile)*
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  238590 - Do not process collateral registers having non -    *
      *           COMPLETE status.                                    *
      *           Applied fix of BUG6436.                             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndication Manager (Recompile)                     *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG6436- Exclude collateral records with incomplete status   *
      *           during update of Collateral details.                *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  CGL014 - Collaterals Processing                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FGLCOLLL1  UF   E           K DISK    INFSR(*PSSR)
     FGLCOLLQ0  UF A E           K DISK    INFSR(*PSSR) PREFIX(Q)                             CAP205
     FGLCOLAL2  UF   E           K DISK    INFSR(*PSSR)
     FGLCOLAL8  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLAD0:GLCOLAN0)
     FSDCLLML1  UF   E           K DISK    INFSR(*PSSR)
     FGLCOLLJ0  IF   E           K DISK    INFSR(*PSSR)
     FFOCLT     UF   E           K DISK    INFSR(*PSSR)
     FSDFOCSL0  UF   E           K DISK    INFSR(*PSSR)
     FFCLTYL1   UF   E           K DISK    INFSR(*PSSR)
     FFCLTYL3   IF   E           K DISK    INFSR(*PSSR)                                       252005
     F                                     RENAME(FCLTYFMF:FCLTYFM3)                          252005
     F                                     PREFIX(T_)                                         252005
     FLEFCLTLG  UF   E           K DISK    INFSR(*PSSR)
     FCLOANL4   UF   E           K DISK    INFSR(*PSSR)
     FACCNTL0   UF   E           K DISK    INFSR(*PSSR)
     FDEALALL   UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     F                                     IGNORE(DEALSDGF)
     FMMDEALLL  UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(MMDENBP0)
     F                                     IGNORE(MMDENSP0)
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     FSEBLKPL1  UF A E           K DISK    INFSR(*PSSR)
     FGL001500P1O    E             PRINTER INFDS(SPOOL1)  USROPN

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area Giving Installation Control Details

     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

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

     D WTMST           S             26A   DIM(9999)
     D WACTAMT         S             15A   DIM(9999)

     D SPOOL1          DS
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for currency details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for switchable details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D TIMESTAMP       S               Z

      ** Calculator Parameters

     D PCAVTD          S             15  0
     D PCAVD1          S             15  0
     D PCAVD2          S             15  0
     D PCAVD3          S             15  0
     D PCAVD4          S             15  0
     D PCAVD5          S             15  0
     D PCAVD6          S             15  0
     D PCAVD7          S             15  0
     D PCAVD8          S             15  0
     D PCAVD9          S             15  0
     D PCLVTD          S             15  0
     D PCLVD1          S             15  0
     D PCLVD2          S             15  0
     D PCLVD3          S             15  0
     D PCLVD4          S             15  0
     D PCLVD5          S             15  0
     D PCLVD6          S             15  0
     D PCLVD7          S             15  0
     D PCLVD8          S             15  0
     D PCLVD9          S             15  0
     D PTOTAL          S             15  0
     D PPCTAL          S             10  7
     D PNUMAL          S              4S 0
     D PALAMT          S           9999

      ** Convert Variables

     D WINAMT          S             15  0
     D WRATE           S             13  8
     D WSPRT1          S             13  8
     D WSPRT2          S             13  8
     D WMDIN           S              1
     D WMDIN1          S              1
     D WMDIN2          S              1
     D WCCY1           S              3
     D WCCY2           S              3
     D WNBDP1          S              1  0
     D WNBDP2          S              1  0
     D WOUTAMT         S             15  0

      ** Access Object Variables

     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D CGL014          S              1
     D CAP205          S              1                                                       CAP205

      ** Key Fields

     D KCNUM           S              6
     D KFACT           S              3
     D KFCNO           S              2

      ** Work Variables

     D WRUN            S              1
     D WERROR          S              1
     D WLESCD          S              1
     D WFXSCD          S              1
     D WSECURED        S              1
     D WCOLFLG         S              1
     D WERRIN          S              1
     D WFOUND          S              1
     D WFIRST          S              1
     D DIFLN1          S              3  0
     D RQDLN1          S              3  0
     D A               S              4S 0
     D B               S              4S 0
     D C               S              4S 0
     D WLIMIT          S              4S 0
     D WEND            S              6S 0
     D WSEQN           S              5S 0
     D WBLKDAT         S              5  0
     D WCDCNUM         S              6
     D WCACNUM         S              6
     D WBLKNOM         S             13  0
     D WCOLAMT         S             15  0
     D WLENDD1         S             15  0
     D WLENDD2         S             15  0
     D WLENDD3         S             15  0
     D WLENDD4         S             15  0
     D WLENDD5         S             15  0
     D WLENDD6         S             15  0
     D WLENDD7         S             15  0
     D WLENDD8         S             15  0
     D WLENDD9         S             15  0
     D WLENDD10        S             15  0
     D WCBLKAM         S             15  0
     D WCOLNOM         S             15  0
     D WCOLVAL         S             15  0
     D WBLKAMT         S             15  0
     D TempAmount      S             15  0                                                    CAP205
     D WFolder         S              5
     D WAllocErr       S              1
     D Idx             S              2  0

      ** +--------------------------------------+
      ** ¦ Prototypes                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+

      ** Prototype for a Java String object
     D crtString       PR              O   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             *CONSTRUCTOR)
     D   value                       10A   CONST VARYING

      ** Prototype for RPGWrapper object creation (instantiation)
     D crtCalcClass    PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                       CLE041
     D**********                           wrapper.as400.RPGWrapper':                         CLE041
     D                                     wrapper.access.RPGWrapper':                        CLE041
     D                                     *CONSTRUCTOR)
     D   String7                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST

      ** Prototype for CalcClass' calculateCavClvAllocation method
     D getValues       PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                       CLE041
     D**********                           wrapper.as400.RPGWrapper':                         CLE041
     D                                     wrapper.access.RPGWrapper':                        CLE041
     D                                     'calculateCavClvAllocation')
     D                                     CLASS(*JAVA:'java.lang.String')
     D   String1                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   String2                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   String3                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D***Int4***                     10I 0 VALUE                                              CSD027
     D   String4                       O   CLASS(*JAVA:'java.lang.String')                    CSD027
     D                                     CONST                                              CSD027
     D   String5                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   String6                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST

      ** Prototype for java string's getBytes method
     D cvtToBytes      PR          9999A   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             'getBytes')
     D                                     VARYING

      ** Create CalcClass object field
     D CalcClassObj    S               O   CLASS(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                       CLE041
     D**********                           wrapper.as400.RPGWrapper')                         CLE041
     D                                     wrapper.access.RPGWrapper')                        CLE041

      ** Create string objects
     D Parm1           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm2           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm3           S               O   CLASS(*JAVA:'java.lang.String')
     D*Parm4****       S             10I 0                                                    CSD027
     D Parm4           S               O   CLASS(*JAVA:'java.lang.String')                    CSD027
     D Parm5           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm6           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm7           S               O   CLASS(*JAVA:'java.lang.String')
     D RcvParms        S               O   CLASS(*JAVA:'java.lang.String')

     D WRcvStr         S           9999A   VARYING
     D WRcvFld0        S              1
     D WRcvFld1        S             15
     D WRcvFld2        S             15
     D WRcvFld3        S             15
     D WRcvFld4        S             15
     D WRcvFld5        S             15
     D WRcvFld6        S             15
     D WRcvFld7        S             15
     D WRcvFld8        S             15
     D WRcvFld9        S             15
     D WRcvFld10       S             15
     D WRcvFld11       S             15
     D WRcvFld12       S             15
     D WRcvFld13       S             15
     D WRcvFld14       S             15
     D WRcvFld15       S             15
     D WRcvFld16       S             15
     D WRcvFld17       S             15
     D WRcvFld18       S             15
     D WRcvFld19       S             15
     D WRcvFld20       S             15
     D WRcvFld21       S             15
     D WRcvFld22       S             10
     D WRcvFld23       S              4
     D WRcvFld24       S           9670

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Update Collateral Details file

     C                   EXSR      SRCOLLDET

      ** Update Collateral Allocation file

     C                   EXSR      SRCOLLALL

      ** Update Client Limits file

     C                   EXSR      SRCLLIMIT

      ** Update Futures & Options Clients file

     C                   EXSR      SRFOCLDET

      ** Update Facilities file

     C                   EXSR      SRFACILTY

      ** Update Customer Loans file

     C                   EXSR      SRCUSLOAN

      ** Update Account Details file

     C                   EXSR      SRACCOUN1

      ** Update MM Loan/Deposit/CD Issued file

     C                   EXSR      SRDEALING

      ** Update SE Manually Blocked Positions file

     C                   EXSR      SRSEMBLKP

      ** Update Account Details file

     C                   EXSR      SRACCOUN2

      ** Check that sufficient lines remain for the format

     C                   EVAL      RQDLN1 = 1
     C     OFLLN1        SUB       PRTLN1        DIFLN1

     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF

      ** Write 'No Details' if no error was reported

     C                   IF        WERROR = 'N'
     C                   WRITE     NODTLS
     C                   ENDIF

      ** Write out trailer format

     C                   WRITE     TRAILP1

     C                   CLOSE     GL001500P1

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCOLLDET - Update Collateral Details File                    *
      *                                                               *
      *****************************************************************

     C     SRCOLLDET     BEGSR

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C**********         IF        CDRECI = 'D'                                              BUG6436
     C                   IF        CDRECI = 'D' and CDSTAT = 'C'                             BUG6436

      ** Compute for collateral's current asset valuation, lending value
      ** and total allocation

     C                   EXSR      SRGETCOLD

      ** Update GLCOLLPD file

     C                   EVAL      CDVAMT = PCAVD1
     C                   EVAL      CDLAMT = PCLVD1
     C                   EVAL      CDTOTA = PTOTAL
     C                   EVAL      CDPCTA = PPCTAL
     C                   EVAL      CDCAV1 = PCAVTD
     C                   EVAL      CDCAV2 = PCAVD1
     C                   EVAL      CDCAV3 = PCAVD2
     C                   EVAL      CDCAV4 = PCAVD3
     C                   EVAL      CDCAV5 = PCAVD4
     C                   EVAL      CDCAV6 = PCAVD5
     C                   EVAL      CDCAV7 = PCAVD6
     C                   EVAL      CDCAV8 = PCAVD7
     C                   EVAL      CDCAV9 = PCAVD8
     C                   EVAL      CDCA10 = PCAVD9
     C                   EVAL      CDCLV1 = PCLVTD
     C                   EVAL      CDCLV2 = PCLVD1
     C                   EVAL      CDCLV3 = PCLVD2
     C                   EVAL      CDCLV4 = PCLVD3
     C                   EVAL      CDCLV5 = PCLVD4
     C                   EVAL      CDCLV6 = PCLVD5
     C                   EVAL      CDCLV7 = PCLVD6
     C                   EVAL      CDCLV8 = PCLVD7
     C                   EVAL      CDCLV9 = PCLVD8
     C                   EVAL      CDCL10 = PCLVD9

      ** Generate a timestamp

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TIMESTAMP

     C                   EVAL      CDTSTP = TIMESTAMP

     C                   IF        CDCOPT = 'P'
     C                   EVAL      CDREVP = CDPRTP
     C                   ENDIF

     C                   UPDATE    GLCOLLD0

      ** Move timestamp and actual amounts to array

     C                   IF        WLIMIT <> 0

     C                   EVAL      A = 1
     C                   EVAL      B = 1
     C                   EVAL      C = 27

     C                   DOW       A <= PNUMAL
     C                   EVAL      WTMST(A) = (%SUBST(PALAMT:B:26))
     C                   EVAL      WACTAMT(A) = (%SUBST(PALAMT:C:15))
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 41
     C                   EVAL      C = C + 41
     C                   ENDDO

      ** Update GLCOLAPD file

     C                   EVAL      A = 1

     C                   DOW       A <= PNUMAL

     C     WTMST(A)      CHAIN     GLCOLAL8                           15

     C                   IF        *IN15 = *OFF
     C                   MOVE      WACTAMT(A)    CAACMT
     C                   UPDATE    GLCOLAN0
     C                   ENDIF

     C                   EVAL      A = A + 1

     C                   ENDDO

     C                   ENDIF

     C                   ENDIF

      ** Read next record

     C                   READ      GLCOLLL1
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCOLLALL - Update Collateral Allocation File                 *
      *                                                               *
      *****************************************************************

     C     SRCOLLALL     BEGSR

      ** Access all records in GLCOLAPD file

     C     *LOVAL        SETLL     GLCOLAL2
     C                   READ      GLCOLAL2

     C                   DOW       NOT %EOF(GLCOLAL2)

     C     CACREF        CHAIN     GLCOLLL1                           15

      ** If not found in PF/GLCOLLPD, delete record

     C                   IF        *IN15 = *ON or CDGNSP <> 'G'
     C                   DELETE    GLCOLAD0
     C                   ENDIF

      ** Read next record

     C                   READ      GLCOLAL2
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLLIMIT - Update Client Limits File                         *
      *                                                               *
      *****************************************************************

     C     SRCLLIMIT     BEGSR

      ** Access all records in SDCLLMPD file

     C     *LOVAL        SETLL     SDCLLML1
     C                   READ      SDCLLML1

     C                   DOW       NOT %EOF(SDCLLML1)

     C                   EVAL      WLESCD = *BLANKS
     C                   EVAL      WFXSCD = *BLANKS

      ** If LE limit amount > 0

     C                   IF        DZMMAM > 0

      ** If on system level

     C                   IF        DZLEVL = 'S' and DZBCCD = 'SYS'

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   MOVE      CDCNUM        WCDCNUM

     C                   IF        CDRECI = 'D' and CDSTAT = 'C' and
     C                             CDENTY = 'K' and WCDCNUM = DZCUST and
     C                             CDMODS = 'MM' AND CDGNSP = 'S'
     C                   EVAL      WLESCD = 'Y'
     C                   LEAVE
     C                   ELSE
     C                   READ      GLCOLLL1
     C                   ENDIF

     C                   ENDDO

     C                   IF        WLESCD = *BLANKS

     C     *LOVAL        SETLL     GLCOLLJ0
     C                   READ      GLCOLLJ0

     C                   DOW       NOT %EOF(GLCOLLJ0)

     C                   MOVE      CACNUM        WCACNUM

     C                   IF        CDRECI = 'D' and CDGNSP = 'G' and
     C                             CABRCA = *BLANKS and WCACNUM = DZCUST and
     C                             CAMODS = 'MM' and CDSTAT = 'C'
     C                   EVAL      WLESCD = 'Y'
     C                   LEAVE
     C                   ELSE
     C                   READ      GLCOLLJ0
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

     C                   ENDIF

      ** If on branch level

     C                   IF        DZLEVL = 'B'

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   MOVE      CDCNUM        WCDCNUM

     C                   IF        CDRECI = 'D' and CDGNSP = 'S' and
     C                             CDENTY = 'B' and WCDCNUM = DZCUST and
     C                             CDMODS = 'MM' AND CDSTAT = 'C' and
     C                             CDBRCA = DZBCCD
     C                   EVAL      WLESCD = 'Y'
     C                   LEAVE
     C                   ELSE
     C                   READ      GLCOLLL1
     C                   ENDIF

     C                   ENDDO

     C                   IF        WLESCD = *BLANKS

     C     *LOVAL        SETLL     GLCOLLJ0
     C                   READ      GLCOLLJ0

     C                   DOW       NOT %EOF(GLCOLLJ0)

     C                   MOVE      CACNUM        WCACNUM

     C                   IF        CDRECI = 'D' and CDGNSP = 'G' and
     C                             CABRCA = DZBCCD and WCACNUM = DZCUST and
     C                             CAMODS = 'MM' and CDSTAT = 'C'
     C                   EVAL      WLESCD = 'Y'
     C                   LEAVE
     C                   ELSE
     C                   READ      GLCOLLJ0
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

     C                   ENDIF

      ** If on company level

     C                   IF        DZLEVL = 'C'

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   MOVE      CDCNUM        WCDCNUM

     C                   IF        CDRECI = 'D' and CDGNSP = 'S' and
     C                             CDENTY = 'C' and CDCMPY = DZBCCD and
     C                             WCDCNUM = DZCUST and CDMODS = 'MM' and
     C                             CDSTAT = 'C'
     C                   EVAL      WLESCD = 'Y'
     C                   LEAVE
     C                   ELSE
     C                   READ      GLCOLLL1
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

     C                   ENDIF

      ** If FX limit amount > 0

     C                   IF        DZFLAM > 0

      ** If on system level

     C                   IF        DZLEVL = 'S' and DZBCCD = 'SYS'

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   MOVE      CDCNUM        WCDCNUM

     C                   IF        CDRECI = 'D' and CDGNSP = 'S' and
     C                             CDENTY = 'K' and WCDCNUM = DZCUST and
     C                             CDMODS = 'FX' AND CDSTAT = 'C'
     C                   EVAL      WFXSCD = 'Y'
     C                   LEAVE
     C                   ELSE
     C                   READ      GLCOLLL1
     C                   ENDIF

     C                   ENDDO

     C                   IF        WFXSCD = *BLANKS

     C     *LOVAL        SETLL     GLCOLLJ0
     C                   READ      GLCOLLJ0

     C                   DOW       NOT %EOF(GLCOLLJ0)

     C                   MOVE      CACNUM        WCACNUM

     C                   IF        CDRECI = 'D' and CDGNSP = 'G' and
     C                             CABRCA = *BLANKS and WCACNUM = DZCUST and
     C                             CAMODS = 'FX' and CDSTAT = 'C'
     C                   EVAL      WFXSCD = 'Y'
     C                   LEAVE
     C                   ELSE
     C                   READ      GLCOLLJ0
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

     C                   ENDIF

      ** If on branch level

     C                   IF        DZLEVL = 'B'

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   MOVE      CDCNUM        WCDCNUM

     C                   IF        CDRECI = 'D' and CDGNSP = 'S' and
     C                             CDENTY = 'B' and WCDCNUM = DZCUST and
     C                             CDMODS = 'FX' AND CDSTAT = 'C' and
     C                             CDBRCA = DZBCCD
     C                   EVAL      WFXSCD = 'Y'
     C                   LEAVE
     C                   ELSE
     C                   READ      GLCOLLL1
     C                   ENDIF

     C                   ENDDO

     C                   IF        WFXSCD = *BLANKS

     C     *LOVAL        SETLL     GLCOLLJ0
     C                   READ      GLCOLLJ0

     C                   DOW       NOT %EOF(GLCOLLJ0)

     C                   MOVE      CACNUM        WCACNUM

     C                   IF        CDRECI = 'D' and CDGNSP = 'G' and
     C                             CABRCA = DZBCCD and WCACNUM = DZCUST and
     C                             CAMODS = 'FX' and CDSTAT = 'C'
     C                   EVAL      WFXSCD = 'Y'
     C                   LEAVE
     C                   ELSE
     C                   READ      GLCOLLJ0
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

     C                   ENDIF

      ** If on company level

     C                   IF        DZLEVL = 'C'

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   MOVE      CDCNUM        WCDCNUM

     C                   IF        CDRECI = 'D' and CDGNSP = 'S' and
     C                             CDENTY = 'C' and CDCMPY = DZBCCD and
     C                             WCDCNUM = DZCUST and CDMODS = 'FX' and
     C                             CDSTAT = 'C'
     C                   EVAL      WFXSCD = 'Y'
     C                   LEAVE
     C                   ELSE
     C                   READ      GLCOLLL1
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

     C                   ENDIF

      ** Update file

     C                   EVAL      DZSECD = WLESCD
     C                   EVAL      DZFLSC = WFXSCD
     C                   UPDATE    @DZREHT

      ** Read next record

     C                   READ      SDCLLML1
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFOCLDET - Update Futures & Options Clients File             *
      *                                                               *
      *****************************************************************

     C     SRFOCLDET     BEGSR

      ** Access all records in FOCLTD file

     C     *LOVAL        SETLL     FOCLT
     C                   READ      FOCLT

     C                   DOW       NOT %EOF(FOCLT)

     C                   EVAL      WCOLAMT = 0

     C     *LOVAL        SETLL     GLCOLLJ0
     C                   READ      GLCOLLJ0

     C                   IF        %EOF(GLCOLLJ0)

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   IF        CDRECI ='D' and CDGNSP = 'S' and
     C                             CDCNUM = CBCD and CDMODS = 'FO' and
     C                             CDSTAT = 'C'

     C                   IF        CDCCY <> CLCC
     C                   EVAL      WCCY1 = CDCCY
     C                   EVAL      WCCY2 = CLCC
     C                   EVAL      WINAMT = CDLAMT
     C                   EXSR      SRCONVERT
     C                   EVAL      WCOLAMT = WCOLAMT + WOUTAMT
     C                   ELSE
     C                   EVAL      WCOLAMT = WCOLAMT + CDLAMT
     C                   ENDIF

     C                   ENDIF

     C                   READ      GLCOLLL1
     C                   ENDDO

     C                   ELSE

     C                   DOW       NOT %EOF(GLCOLLJ0)

      ** Convert amount

     C                   IF        CDRECI ='D' and CDGNSP = 'S' and
     C                             CDCNUM = CBCD and CDMODS = 'FO' and
     C                             CDSTAT = 'C'

     C                   IF        CDCCY <> CLCC
     C                   EVAL      WCCY1 = CDCCY
     C                   EVAL      WCCY2 = CLCC
     C                   EVAL      WINAMT = CDLAMT
     C                   EXSR      SRCONVERT
     C                   EVAL      WCOLAMT = WCOLAMT + WOUTAMT
     C                   ELSE
     C                   EVAL      WCOLAMT = WCOLAMT + CDLAMT
     C                   ENDIF

     C                   ENDIF

     C                   IF        CDRECI = 'D' and CDGNSP = 'G' and
     C                             CACNUM = CBCD and CAMODS = 'FO' and
     C                             CDSTAT = 'C'

     C                   IF        CDCCY <> CLCC
     C                   EVAL      WCCY1 = CDCCY
     C                   EVAL      WCCY2 = CLCC
     C                   EVAL      WINAMT = CAACMT
     C                   EXSR      SRCONVERT
     C                   EVAL      WCOLAMT = WCOLAMT + WOUTAMT
     C                   ELSE
     C                   EVAL      WCOLAMT = WCOLAMT + CAACMT
     C                   ENDIF

     C                   ENDIF

     C                   READ      GLCOLLJ0
     C                   ENDDO

     C                   ENDIF

     C                   IF        WCOLAMT < 0
     C                   EVAL      WCOLAMT = 0
     C                   ENDIF

      ** Update file

     C                   EVAL      CLAM = WCOLAMT
     C                   UPDATE    FOCLTDF

     C                   MOVE      CBCD          BHCUST
     C     BHCUST        CHAIN     SDFOCSL0                           15

     C                   IF        *IN15 = *OFF
     C                   EVAL      BHCOAM = WCOLAMT
     C                   UPDATE    @BHRED0
     C                   ENDIF

      ** Read next record

     C                   READ      FOCLT
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFACILTY - Update Facilities File                            *
      *                                                               *
      *****************************************************************

     C     SRFACILTY     BEGSR

      ** Access all records in FCLTYFM file

     C     *LOVAL        SETLL     FCLTYL1
     C                   READ      FCLTYL1

     C                   DOW       NOT %EOF(FCLTYL1)

     C     KFCLT         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO

     C                   MOVE      CNUM          KCNUM
     C                   MOVE      FACT          KFACT
     C                   MOVE      FCNO          KFCNO

     C     KFCLT         CHAIN     LEFCLTLG                           15

      ** Initialise fields

     C                   IF        *IN15 = *OFF

     C                   EVAL      WSECURED = 'N'
     C                   EVAL      WLENDD1 = 0
     C                   EVAL      WLENDD2 = 0
     C                   EVAL      WLENDD3 = 0
     C                   EVAL      WLENDD4 = 0
     C                   EVAL      WLENDD5 = 0
     C                   EVAL      WLENDD6 = 0
     C                   EVAL      WLENDD7 = 0
     C                   EVAL      WLENDD8 = 0
     C                   EVAL      WLENDD9 = 0
     C                   EVAL      WLENDD10 = 0

     C     TRCA          IFNE      'CA'                                                       252005
                                                                                              252005
     C     *LOVAL        SETLL     GLCOLLJ0
     C                   READ      GLCOLLJ0

     C**********         IF        %EOF(GLCOLLJ0)                                             252005

     C                   DOW       NOT %EOF(GLCOLLJ0)                                         252005
                                                                                              252005
     C                   IF        CDRECI = 'D' and CDGNSP = 'G' and                          252005
     C                             CAMODS = 'LE' and CAFCUS = CNUM and                        252005
     C                             CAFTYP = FACT and CAFSEQ = FCNO and                        252005
     C                             CDSTAT = 'C'                                               252005
                                                                                              252005
     C                   EVAL      WSECURED = 'Y'                                             252005
      *                                                                                       252005
      ** Convert amount                                                                       252005
      *                                                                                       252005
     C                   IF        CDCCY <> FCCY                                              252005
     C                   EVAL      WCCY1 = CDCCY                                              252005
     C                   EVAL      WCCY2 = FCCY                                               252005
     C                   EVAL      WINAMT = CAACMT                                            252005
     C                   EXSR      SRCONVERT                                                  252005
     C                   EVAL      WLENDD1 = WLENDD1 + WOUTAMT                                252005
     C                   EVAL      WLENDD2 = WLENDD2 + WOUTAMT                                252005
     C                   EVAL      WLENDD3 = WLENDD3 + WOUTAMT                                252005
     C                   EVAL      WLENDD4 = WLENDD4 + WOUTAMT                                252005
     C                   EVAL      WLENDD5 = WLENDD5 + WOUTAMT                                252005
     C                   EVAL      WLENDD6 = WLENDD6 + WOUTAMT                                252005
     C                   EVAL      WLENDD7 = WLENDD7 + WOUTAMT                                252005
     C                   EVAL      WLENDD8 = WLENDD8 + WOUTAMT                                252005
     C                   EVAL      WLENDD9 = WLENDD9 + WOUTAMT                                252005
     C                   EVAL      WLENDD10 = WLENDD10 + WOUTAMT                              252005
     C                   ELSE                                                                 252005
     C                   EVAL      WLENDD1 = WLENDD1 + CAACMT                                 252005
     C                   EVAL      WLENDD2 = WLENDD2 + CAACMT                                 252005
     C                   EVAL      WLENDD3 = WLENDD3 + CAACMT                                 252005
     C                   EVAL      WLENDD4 = WLENDD4 + CAACMT                                 252005
     C                   EVAL      WLENDD5 = WLENDD5 + CAACMT                                 252005
     C                   EVAL      WLENDD6 = WLENDD6 + CAACMT                                 252005
     C                   EVAL      WLENDD7 = WLENDD7 + CAACMT                                 252005
     C                   EVAL      WLENDD8 = WLENDD8 + CAACMT                                 252005
     C                   EVAL      WLENDD9 = WLENDD9 + CAACMT                                 252005
     C                   EVAL      WLENDD10 = WLENDD10 + CAACMT                               252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   READ      GLCOLLJ0                                                   252005
     C                   ENDDO                                                                252005
                                                                                              252005
     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   IF        CDRECI = 'D' and CDGNSP = 'S' and
     C                             CDMODS = 'LE' and CDFCUS = CNUM and
     C                             CDFTYP = FACT and CDFSEQ = FCNO and
     C                             CDSTAT = 'C'

     C                   EVAL      WSECURED = 'Y'

      ** Convert amount

     C                   IF        CDCCY = FCCY

     C                   EVAL      WLENDD1 = WLENDD1 + CDCLV1
     C                   EVAL      WLENDD2 = WLENDD2 + CDCLV2
     C                   EVAL      WLENDD3 = WLENDD3 + CDCLV3
     C                   EVAL      WLENDD4 = WLENDD4 + CDCLV4
     C                   EVAL      WLENDD5 = WLENDD5 + CDCLV5
     C                   EVAL      WLENDD6 = WLENDD6 + CDCLV6
     C                   EVAL      WLENDD7 = WLENDD7 + CDCLV7
     C                   EVAL      WLENDD8 = WLENDD8 + CDCLV8
     C                   EVAL      WLENDD9 = WLENDD9 + CDCLV9
     C                   EVAL      WLENDD10 = WLENDD10 + CDCL10

     C                   ELSE

      ** Convert amount

     C                   EVAL      WCCY1 = CDCCY
     C                   EVAL      WCCY2 = FCCY
     C                   EVAL      WINAMT = CDCLV1
     C                   EXSR      SRCONVERT
     C                   EVAL      WLENDD1 = WLENDD1 + WOUTAMT

     C                   EVAL      WINAMT = CDCLV2
     C                   EXSR      SRCONVERT
     C                   EVAL      WLENDD2 = WLENDD2 + WOUTAMT

     C                   EVAL      WINAMT = CDCLV3
     C                   EXSR      SRCONVERT
     C                   EVAL      WLENDD3 = WLENDD3 + WOUTAMT

     C                   EVAL      WINAMT = CDCLV4
     C                   EXSR      SRCONVERT
     C                   EVAL      WLENDD4 = WLENDD4 + WOUTAMT

     C                   EVAL      WINAMT = CDCLV5
     C                   EXSR      SRCONVERT
     C                   EVAL      WLENDD5 = WLENDD5 + WOUTAMT

     C                   EVAL      WINAMT = CDCLV6
     C                   EXSR      SRCONVERT
     C                   EVAL      WLENDD6 = WLENDD6 + WOUTAMT

     C                   EVAL      WINAMT = CDCLV7
     C                   EXSR      SRCONVERT
     C                   EVAL      WLENDD7 = WLENDD7 + WOUTAMT

     C                   EVAL      WINAMT = CDCLV8
     C                   EXSR      SRCONVERT
     C                   EVAL      WLENDD8 = WLENDD8 + WOUTAMT

     C                   EVAL      WINAMT = CDCLV9
     C                   EXSR      SRCONVERT
     C                   EVAL      WLENDD9 = WLENDD9 + WOUTAMT

     C                   EVAL      WINAMT = CDCL10
     C                   EXSR      SRCONVERT
     C                   EVAL      WLENDD10 = WLENDD10 + WOUTAMT

     C                   ENDIF

     C                   ENDIF

     C                   READ      GLCOLLL1

     C                   ENDDO

     C                   ENDIF                                                                252005
     C**********         ELSE                                                                 252005
      **********                                                                              252005
     C**********         DOW       NOT %EOF(GLCOLLJ0)                                         252005
      **********                                                                              252005
     C**********         IF        CDRECI = 'D' and CDGNSP = 'S' and                          252005
     C**********                   CDMODS = 'LE' and CDFCUS = CNUM and                        252005
     C**********                   CDFTYP = FACT and CDFSEQ = FCNO and                        252005
     C**********                   CDSTAT = 'C'                                               252005
      **********                                                                              252005
     C**********         EVAL      WSECURED = 'Y'                                             252005
      **********                                                                              252005
      ***Convert*amount                                                                       252005
      **********                                                                              252005
     C**********         IF        CDCCY = FCCY                                               252005
      **********                                                                              252005
     C**********         EVAL      WLENDD1 = WLENDD1 + CDCLV1                                 252005
     C**********         EVAL      WLENDD2 = WLENDD2 + CDCLV2                                 252005
     C**********         EVAL      WLENDD3 = WLENDD3 + CDCLV3                                 252005
     C**********         EVAL      WLENDD4 = WLENDD4 + CDCLV4                                 252005
     C**********         EVAL      WLENDD5 = WLENDD5 + CDCLV5                                 252005
     C**********         EVAL      WLENDD6 = WLENDD6 + CDCLV6                                 252005
     C**********         EVAL      WLENDD7 = WLENDD7 + CDCLV7                                 252005
     C**********         EVAL      WLENDD8 = WLENDD8 + CDCLV8                                 252005
     C**********         EVAL      WLENDD9 = WLENDD9 + CDCLV9                                 252005
     C**********         EVAL      WLENDD10 = WLENDD10 + CDCL10                               252005
      **********                                                                              252005
     C**********         ELSE                                                                 252005
      **********                                                                              252005
      ***Convert*amount                                                                       252005
      **********                                                                              252005
     C**********         EVAL      WCCY1 = CDCCY                                              252005
     C**********         EVAL      WCCY2 = FCCY                                               252005
     C**********         EVAL      WINAMT = CDCLV1                                            252005
     C**********         EXSR      SRCONVERT                                                  252005
     C**********         EVAL      WLENDD1 = WLENDD1 + WOUTAMT                                252005
      **********                                                                              252005
     C**********         EVAL      WINAMT = CDCLV2                                            252005
     C**********         EXSR      SRCONVERT                                                  252005
     C**********         EVAL      WLENDD2 = WLENDD2 + WOUTAMT                                252005
      **********                                                                              252005
     C**********         EVAL      WINAMT = CDCLV3                                            252005
     C**********         EXSR      SRCONVERT                                                  252005
     C**********         EVAL      WLENDD3 = WLENDD3 + WOUTAMT                                252005
      **********                                                                              252005
     C**********         EVAL      WINAMT = CDCLV4                                            252005
     C**********         EXSR      SRCONVERT                                                  252005
     C**********         EVAL      WLENDD4 = WLENDD4 + WOUTAMT                                252005
      **********                                                                              252005
     C**********         EVAL      WINAMT = CDCLV5                                            252005
     C**********         EXSR      SRCONVERT                                                  252005
     C**********         EVAL      WLENDD5 = WLENDD5 + WOUTAMT                                252005
      **********                                                                              252005
     C**********         EVAL      WINAMT = CDCLV6                                            252005
     C**********         EXSR      SRCONVERT                                                  252005
     C**********         EVAL      WLENDD6 = WLENDD6 + WOUTAMT                                252005
      **********                                                                              252005
     C**********         EVAL      WINAMT = CDCLV7                                            252005
     C**********         EXSR      SRCONVERT                                                  252005
     C**********         EVAL      WLENDD7 = WLENDD7 + WOUTAMT                                252005
      **********                                                                              252005
     C**********         EVAL      WINAMT = CDCLV8                                            252005
     C**********         EXSR      SRCONVERT                                                  252005
     C**********         EVAL      WLENDD8 = WLENDD8 + WOUTAMT                                252005
      **********                                                                              252005
     C**********         EVAL      WINAMT = CDCLV9                                            252005
     C**********         EXSR      SRCONVERT                                                  252005
     C**********         EVAL      WLENDD9 = WLENDD9 + WOUTAMT                                252005
      **********                                                                              252005
     C**********         EVAL      WINAMT = CDCL10                                            252005
     C**********         EXSR      SRCONVERT                                                  252005
     C**********         EVAL      WLENDD10 = WLENDD10 + WOUTAMT                              252005
      **********                                                                              252005
     C**********         ENDIF                                                                252005
      **********                                                                              252005
     C**********         ELSE                                                                 252005
      **********                                                                              252005
     C**********         IF        CDRECI = 'D' and CDGNSP = 'G' and                          252005
     C**********                   CAMODS = 'LE' and CAFCUS = CNUM and                        252005
     C**********                   CAFTYP = FACT and CAFSEQ = FCNO and                        252005
     C**********                   CDSTAT = 'C'                                               252005
      **********                                                                              252005
     C**********         EVAL      WSECURED = 'Y'                                             252005
      **********                                                                              252005
      ***Convert*amount                                                                       252005
      **********                                                                              252005
     C**********         IF        CDCCY <> FCCY                                              252005
     C**********         EVAL      WCCY1 = CDCCY                                              252005
     C**********         EVAL      WCCY2 = FCCY                                               252005
     C**********         EVAL      WINAMT = CAACMT                                            252005
     C**********         EXSR      SRCONVERT                                                  252005
     C**********         EVAL      WLENDD1 = WLENDD1 + WOUTAMT                                252005
     C**********         EVAL      WLENDD2 = WLENDD2 + WOUTAMT                                252005
     C**********         EVAL      WLENDD3 = WLENDD3 + WOUTAMT                                252005
     C**********         EVAL      WLENDD4 = WLENDD4 + WOUTAMT                                252005
     C**********         EVAL      WLENDD5 = WLENDD5 + WOUTAMT                                252005
     C**********         EVAL      WLENDD6 = WLENDD6 + WOUTAMT                                252005
     C**********         EVAL      WLENDD7 = WLENDD7 + WOUTAMT                                252005
     C**********         EVAL      WLENDD8 = WLENDD8 + WOUTAMT                                252005
     C**********         EVAL      WLENDD9 = WLENDD9 + WOUTAMT                                252005
     C**********         EVAL      WLENDD10 = WLENDD10 + WOUTAMT                              252005
     C**********         ELSE                                                                 252005
     C**********         EVAL      WLENDD1 = WLENDD1 + CAACMT                                 252005
     C**********         EVAL      WLENDD2 = WLENDD2 + CAACMT                                 252005
     C**********         EVAL      WLENDD3 = WLENDD3 + CAACMT                                 252005
     C**********         EVAL      WLENDD4 = WLENDD4 + CAACMT                                 252005
     C**********         EVAL      WLENDD5 = WLENDD5 + CAACMT                                 252005
     C**********         EVAL      WLENDD6 = WLENDD6 + CAACMT                                 252005
     C**********         EVAL      WLENDD7 = WLENDD7 + CAACMT                                 252005
     C**********         EVAL      WLENDD8 = WLENDD8 + CAACMT                                 252005
     C**********         EVAL      WLENDD9 = WLENDD9 + CAACMT                                 252005
     C**********         EVAL      WLENDD10 = WLENDD10 + CAACMT                               252005
     C**********         ENDIF                                                                252005
      **********                                                                              252005
     C**********         ENDIF                                                                252005
      **********                                                                              252005
     C**********         ENDIF                                                                252005
      **********                                                                              252005
     C**********         READ      GLCOLLJ0                                                   252005
     C**********         ENDDO                                                                252005
      **********                                                                              252005
     C**********         ENDIF                                                                252005

      ** Set lending values to 0 if negative

     C                   IF        WLENDD1 < 0
     C                   EVAL      WLENDD1 = 0
     C                   ENDIF

     C                   IF        WLENDD2 < 0
     C                   EVAL      WLENDD2 = 0
     C                   ENDIF

     C                   IF        WLENDD3 < 0
     C                   EVAL      WLENDD3 = 0
     C                   ENDIF

     C                   IF        WLENDD4 < 0
     C                   EVAL      WLENDD4 = 0
     C                   ENDIF

     C                   IF        WLENDD5 < 0
     C                   EVAL      WLENDD5 = 0
     C                   ENDIF

     C                   IF        WLENDD6 < 0
     C                   EVAL      WLENDD6 = 0
     C                   ENDIF

     C                   IF        WLENDD7 < 0
     C                   EVAL      WLENDD7 = 0
     C                   ENDIF

     C                   IF        WLENDD8 < 0
     C                   EVAL      WLENDD8 = 0
     C                   ENDIF

     C                   IF        WLENDD9 < 0
     C                   EVAL      WLENDD9 = 0
     C                   ENDIF

     C                   IF        WLENDD10 < 0
     C                   EVAL      WLENDD10 = 0
     C                   ENDIF

      ** Update file

     C                   EVAL      SECI = WSECURED
     C                   UPDATE    FCLTYFMF

     C                   EVAL      FCXCV1 = WLENDD1
     C                   EVAL      FCXCV2 = WLENDD2
     C                   EVAL      FCXCV3 = WLENDD3
     C                   EVAL      FCXCV4 = WLENDD4
     C                   EVAL      FCXCV5 = WLENDD5
     C                   EVAL      FCXCV6 = WLENDD6
     C                   EVAL      FCXCV7 = WLENDD7
     C                   EVAL      FCXCV8 = WLENDD8
     C                   EVAL      FCXCV9 = WLENDD9
     C                   EVAL      FCXC10 = WLENDD10
     C                   UPDATE    LEFCLTD0

     C                   ENDIF

      ** Read next record

     C                   READ      FCLTYL1
     C                   ENDDO
      *                                                                                       252005
      ** Access all CA records in FCLTYFM file                                                252005
      *                                                                                       252005
     C     *LOVAL        SETLL     FCLTYL1                                                    252005
     C                   READ      FCLTYL1                                                    252005
                                                                                              252005
     C                   DOW       NOT %EOF(FCLTYL1)                                          252005
                                                                                              252005
     C                   MOVE      CNUM          KCNUM                                        252005
     C                   MOVE      FACT          KFACT                                        252005
     C                   MOVE      FCNO          KFCNO                                        252005
                                                                                              252005
     C                   IF        TRCA = 'CA'                                                252005
                                                                                              252005
     C                   EVAL      WLENDD1 = 0                                                252005
     C                   EVAL      WLENDD2 = 0                                                252005
     C                   EVAL      WLENDD3 = 0                                                252005
     C                   EVAL      WLENDD4 = 0                                                252005
     C                   EVAL      WLENDD5 = 0                                                252005
     C                   EVAL      WLENDD6 = 0                                                252005
     C                   EVAL      WLENDD7 = 0                                                252005
     C                   EVAL      WLENDD8 = 0                                                252005
     C                   EVAL      WLENDD9 = 0                                                252005
     C                   EVAL      WLENDD10 = 0                                               252005
                                                                                              252005
     C     *LOVAL        SETLL     FCLTYL3                                                    252005
     C                   READ      FCLTYL3                                                    252005
                                                                                              252005
     C                   DOW       NOT %EOF(FCLTYL3)                                          252005
                                                                                              252005
     C                   IF        T_CANM = CNUM and T_CAFT = FACT and                        252005
     C                             T_CAFN = FCNO                                              252005
                                                                                              252005
     C                   MOVE      T_CNUM        KCNUM                                        252005
     C                   MOVE      T_FACT        KFACT                                        252005
     C                   MOVE      T_FCNO        KFCNO                                        252005
                                                                                              252005
     C     KFCLT         CHAIN     LEFCLTLG                           15                      252005
                                                                                              252005
     C                   IF        *IN15 = *OFF                                               252005
      *                                                                                       252005
      ** If same currency move amount                                                         252005
      *                                                                                       252005
     C                   IF        T_FCCY = FCCY                                              252005
     C                   EVAL      WLENDD1 = WLENDD1 + FCXCV1                                 252005
     C                   EVAL      WLENDD2 = WLENDD2 + FCXCV2                                 252005
     C                   EVAL      WLENDD3 = WLENDD3 + FCXCV3                                 252005
     C                   EVAL      WLENDD4 = WLENDD4 + FCXCV4                                 252005
     C                   EVAL      WLENDD5 = WLENDD5 + FCXCV5                                 252005
     C                   EVAL      WLENDD6 = WLENDD6 + FCXCV6                                 252005
     C                   EVAL      WLENDD7 = WLENDD7 + FCXCV7                                 252005
     C                   EVAL      WLENDD8 = WLENDD8 + FCXCV8                                 252005
     C                   EVAL      WLENDD9 = WLENDD9 + FCXCV9                                 252005
     C                   EVAL      WLENDD10 = WLENDD10 + FCXC10                               252005
      *                                                                                       252005
      ** Convert amount if different currency                                                 252005
      *                                                                                       252005
     C                   ELSE                                                                 252005
      *                                                                                       252005
      ** if Multiply/Divide indicator is 'M'                                                  252005
      *                                                                                       252005
     C                   IF        T_CMDI = 'M'                                               252005
     C                   EVAL      WLENDD1 = WLENDD1 + FCXCV1 * T_CAXR                        252005
     C                   EVAL      WLENDD2 = WLENDD2 + FCXCV2 * T_CAXR                        252005
     C                   EVAL      WLENDD3 = WLENDD3 + FCXCV3 * T_CAXR                        252005
     C                   EVAL      WLENDD4 = WLENDD4 + FCXCV4 * T_CAXR                        252005
     C                   EVAL      WLENDD5 = WLENDD5 + FCXCV5 * T_CAXR                        252005
     C                   EVAL      WLENDD6 = WLENDD6 + FCXCV6 * T_CAXR                        252005
     C                   EVAL      WLENDD7 = WLENDD7 + FCXCV7 * T_CAXR                        252005
     C                   EVAL      WLENDD8 = WLENDD8 + FCXCV8 * T_CAXR                        252005
     C                   EVAL      WLENDD9 = WLENDD9 + FCXCV9 * T_CAXR                        252005
     C                   EVAL      WLENDD10 = WLENDD10 + FCXC10 * T_CAXR                      252005
     C                   ENDIF                                                                252005
      *                                                                                       252005
      ** if Multiply/Divide indicator is 'D'                                                  252005
      *                                                                                       252005
     C                   IF        T_CMDI = 'D'                                               252005
     C                   EVAL      WLENDD1 = WLENDD1 + FCXCV1 / T_CAXR                        252005
     C                   EVAL      WLENDD2 = WLENDD2 + FCXCV2 / T_CAXR                        252005
     C                   EVAL      WLENDD3 = WLENDD3 + FCXCV3 / T_CAXR                        252005
     C                   EVAL      WLENDD4 = WLENDD4 + FCXCV4 / T_CAXR                        252005
     C                   EVAL      WLENDD5 = WLENDD5 + FCXCV5 / T_CAXR                        252005
     C                   EVAL      WLENDD6 = WLENDD6 + FCXCV6 / T_CAXR                        252005
     C                   EVAL      WLENDD7 = WLENDD7 + FCXCV7 / T_CAXR                        252005
     C                   EVAL      WLENDD8 = WLENDD8 + FCXCV8 / T_CAXR                        252005
     C                   EVAL      WLENDD9 = WLENDD9 + FCXCV9 / T_CAXR                        252005
     C                   EVAL      WLENDD10 = WLENDD10 + FCXC10 / T_CAXR                      252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   READ      FCLTYL3                                                    252005
     C                   ENDDO                                                                252005
                                                                                              252005
     C                   MOVE      CNUM          KCNUM                                        252005
     C                   MOVE      FACT          KFACT                                        252005
     C                   MOVE      FCNO          KFCNO                                        252005
     C     KFCLT         CHAIN     LEFCLTLG                           15                      252005
     C                   IF        *IN15 = *OFF                                               252005
      *                                                                                       252005
      ** Set lending values to 0 if negative                                                  252005
      *                                                                                       252005
     C                   IF        WLENDD1 < 0                                                252005
     C                   EVAL      WLENDD1 = 0                                                252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   IF        WLENDD2 < 0                                                252005
     C                   EVAL      WLENDD2 = 0                                                252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   IF        WLENDD3 < 0                                                252005
     C                   EVAL      WLENDD3 = 0                                                252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   IF        WLENDD4 < 0                                                252005
     C                   EVAL      WLENDD4 = 0                                                252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   IF        WLENDD5 < 0                                                252005
     C                   EVAL      WLENDD5 = 0                                                252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   IF        WLENDD6 < 0                                                252005
     C                   EVAL      WLENDD6 = 0                                                252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   IF        WLENDD7 < 0                                                252005
     C                   EVAL      WLENDD7 = 0                                                252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   IF        WLENDD8 < 0                                                252005
     C                   EVAL      WLENDD8 = 0                                                252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   IF        WLENDD9 < 0                                                252005
     C                   EVAL      WLENDD9 = 0                                                252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   IF        WLENDD10 < 0                                               252005
     C                   EVAL      WLENDD10 = 0                                               252005
     C                   ENDIF                                                                252005
      *                                                                                       252005
      ** Update file                                                                          252005
      *                                                                                       252005
     C                   UPDATE    FCLTYFMF                                                   252005
                                                                                              252005
     C                   EVAL      FCXCV1 = WLENDD1                                           252005
     C                   EVAL      FCXCV2 = WLENDD2                                           252005
     C                   EVAL      FCXCV3 = WLENDD3                                           252005
     C                   EVAL      FCXCV4 = WLENDD4                                           252005
     C                   EVAL      FCXCV5 = WLENDD5                                           252005
     C                   EVAL      FCXCV6 = WLENDD6                                           252005
     C                   EVAL      FCXCV7 = WLENDD7                                           252005
     C                   EVAL      FCXCV8 = WLENDD8                                           252005
     C                   EVAL      FCXCV9 = WLENDD9                                           252005
     C                   EVAL      FCXC10 = WLENDD10                                          252005
     C                   UPDATE    LEFCLTD0                                                   252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   ENDIF                                                                252005
                                                                                              252005
     C                   READ      FCLTYL1                                                    252005
     C                   ENDDO                                                                252005

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUSLOAN - Update Customer Loans File                        *
      *                                                               *
      *****************************************************************

     C     SRCUSLOAN     BEGSR

      ** Access all records in CLOANCL file

     C     *LOVAL        SETLL     CLOANL4
     C                   READ      CLOANL4

     C                   DOW       NOT %EOF(CLOANL4)

     C                   EVAL      WSECURED = 'N'

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   IF        CDRECI = 'D' and CDGNSP = 'S' and
     C                             CDMODS = 'LE' and CDLNLM = LNRF and
     C                             CDSTAT = 'C'
     C                   EVAL      WSECURED = 'Y'
     C                   LEAVE
     C                   ENDIF

     C                   READ      GLCOLLL1
     C                   ENDDO

     C                   IF        WSECURED = 'N'

     C     *LOVAL        SETLL     GLCOLLJ0
     C                   READ      GLCOLLJ0

     C                   DOW       NOT %EOF(GLCOLLJ0)

     C                   IF        CDRECI = 'D' and CDGNSP = 'G' and
     C                             CAMODS = 'LE' and CALNLM = LNRF and
     C                             CDSTAT = 'C'
     C                   EVAL      WSECURED = 'Y'
     C                   LEAVE
     C                   ENDIF

     C                   READ      GLCOLLJ0
     C                   ENDDO

     C                   ENDIF

      ** Update file

     C                   IF        WSECURED = 'Y'
     C                   BITON     '0'           RELI
     C                   ELSE
     C                   BITOFF    '0'           RELI
     C                   ENDIF

     C                   UPDATE    CLOANCLF

      ** Read next record

     C                   READ      CLOANL4
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACCOUN1 - Update Account Details File                       *
      *                                                               *
      *****************************************************************

     C     SRACCOUN1     BEGSR

      ** Access all records in ACCNTAB file

     C     *LOVAL        SETLL     ACCNTL0
     C                   READ      ACCNTL0

     C                   DOW       NOT %EOF(ACCNTL0)

     C                   IF        ATYP = 'R'

     C                   EVAL      WSECURED = 'N'

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   IF        CDRECI = 'D' and CDGNSP = 'S' and
     C                             CDMODS = 'RE' and CDSBRC = BRCA and
     C                             CDSCNM = CNUM  and CDSCCY = CCY and
     C                             CDSACD = ACOD and CDSSEQ = ACSQ and
     C                             CDSTAT = 'C'
     C                   EVAL      WSECURED = 'Y'
     C                   LEAVE
     C                   ENDIF

     C                   READ      GLCOLLL1
     C                   ENDDO

     C                   IF        WSECURED = 'N'

     C     *LOVAL        SETLL     GLCOLLJ0
     C                   READ      GLCOLLJ0

     C                   DOW       NOT %EOF(GLCOLLJ0)

     C                   IF        CDRECI = 'D' and CDGNSP = 'G' and
     C                             CASBRC = BRCA and CASCNM = CNUM and
     C                             CASCCY = CCY and CASACD = ACOD and
     C                             CASSEQ = ACSQ and CAMODS = 'RE' and
     C                             CDSTAT = 'C'
     C                   EVAL      WSECURED = 'Y'
     C                   LEAVE
     C                   ENDIF

     C                   READ      GLCOLLJ0
     C                   ENDDO

     C                   ENDIF

      ** Update file

     C                   EVAL      ODSC = WSECURED
     C                   UPDATE    ACCNTABF

     C                   ENDIF

      ** Read next record

     C                   READ      ACCNTL0
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDEALING - Update MM Loan/Deposit/CD Issued File             *
      *                                                               *
      *****************************************************************

     C     SRDEALING     BEGSR

      ** Access all records in DEALSDC file

     C     *LOVAL        SETLL     DEALALL
     C                   READ      DEALALL

     C                   DOW       NOT %EOF(DEALALL)

     C                   EVAL      WCOLAMT = 0
     C                   EVAL      WCBLKAM = 0

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   IF        CDRECI = 'D' and CDCOPT = 'D' and
     C                             CDDEAL = DLNO and CDSTAT = 'C'

     C**********         IF        CDAPCT = 'A'                                             BUG17986
     C**********         EVAL      WCOLVAL = CDNAMT                                         BUG17986
     C**********         ELSE                                                               BUG17986
     C                   EVAL      WCOLVAL = CDVAMT                                         BUG17986
     C                   IF        CDMNNA <> 0                                              BUG17986
     C                   EVAL      WCOLVAL = CDMNNA
     C                   ENDIF

      ** Convert amount

     C                   IF        CDCCY = CCY
     C                   EVAL      WCOLAMT = WCOLAMT + WCOLVAL
     C                   ELSE
     C                   EVAL      WCCY1 = CDCCY
     C                   EVAL      WCCY2 = CCY
     C                   EVAL      WINAMT = WCOLVAL
     C                   EXSR      SRCONVERT
     C                   EVAL      WCOLAMT = WCOLAMT + WOUTAMT
     C                   ENDIF

     C                   IF        CDBCOL = 'Y'

     C                   IF        CDCCY = CCY
     C                   EVAL      WCBLKAM = WCBLKAM + WCOLVAL
     C                   ELSE
     C                   EVAL      WCCY1 = CDCCY
     C                   EVAL      WCCY2 = CCY
     C                   EVAL      WINAMT = WCOLVAL
     C                   EXSR      SRCONVERT
     C                   EVAL      WCBLKAM = WCBLKAM + WOUTAMT
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   READ      GLCOLLL1
     C                   ENDDO

     C                   IF        WCBLKAM < 0
     C                   EVAL      WCBLKAM = 0
     C                   ENDIF

     C                   IF        WCOLAMT <= 0
     C                   EVAL      WCOLAMT = 0
     C***********        EVAL      WCOLFLG = 'N'                                              249974
     C***********        ELSE                                                                 249974
     C***********        EVAL      WCOLFLG = 'Y'                                              249974
     C                   ENDIF

      ** Update file

     C                   EVAL      COLA = WCOLAMT
     C***********        EVAL      COLF = WCOLFLG                                             249974
     C                   EVAL      BCAM = WCBLKAM
     C                   UPDATE    DEALSDCF

     C     DLNO          CHAIN     MMDELDP0                           15

     C                   IF        *IN15 = *OFF
     C                   EVAL      HKCOLA = WCOLAMT
     C***********        EVAL      HKCOLF = WCOLFLG                                           249974
     C                   EVAL      HKBCAM = WCBLKAM
     C                   UPDATE    MMDELDP0
     C                   ENDIF

      ** Read next record

     C                   READ      DEALALL
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSEMBLKP - Update SE Manually Blocked Positions File         *
      *                                                               *
      *****************************************************************

     C     SRSEMBLKP     BEGSR

      ** Access all records in GLCOLLPD file

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   IF        CDRECI = 'D' and CDCOPT = 'P' and
     C                             CDSTAT = 'C' and CDCSEC <> *BLANKS

     C     CDCSEC        CHAIN     SECTY                              15

     C                   IF        *IN15 = *OFF

     C     *LOVAL        SETLL     SEBLKPL1
     C                   READ      SEBLKPL1

      ** Determine Warning/Error indicator

     C                   IF        CGL014 = 'N'
     C                   EVAL      WERRIN = 'W'
     C                   ELSE

     C                   IF        CDBCOL = 'Y'
     C                   EVAL      WERRIN = 'E'
     C                   ELSE
     C                   EVAL      WERRIN = 'W'
     C                   ENDIF

     C                   ENDIF

      ** Determine sequence

     C                   IF        WERRIN = 'W'
     C                   EVAL      WSEQN = 99900
     C                   ELSE
     C                   EVAL      WSEQN = 99901
     C                   ENDIF

     C                   EVAL      WFOUND = 'N'

      ** Check if record exists in SEBLKPPD

     C                   DOW       NOT %EOF(SEBLKPL1)

     C                   IF        VDBLTY = 'P' and VDBRCD = CDCSBR and
     C                             VDCNUM = CDCSCN and VDPTFR = CDPTFR and
     C                             VDSESN = CDCSEC and ((WSEQN = 99900 and
     C                             WERRIN = 'W') or (WSEQN = 99901 and
     C                             WERRIN = 'E'))

     C                   IF        (CDEDAT = VDBEDT and (MATY = 0 or
     C                             (CDEDAT <> 0 and CDEDAT < MATY))) or
     C                             (MATY = VDBEDT and (CDEDAT = 0 or
     C                             (MATY <> 0 and MATY < CDEDAT)))
     C                   EVAL      WFOUND = 'Y'
     C                   LEAVE
     C                   ENDIF

     C                   ENDIF

     C                   READ      SEBLKPL1
     C                   ENDDO

      ** If record not found in SEBLKPPD, write new record

     C                   IF        WFOUND = 'N'

     C                   EVAL      VDRECI = 'D'
     C                   EVAL      VDLCD = 99999
     C                   EVAL      VDCHTP = 'I'
     C                   EVAL      VDLUID = PSUser
     C                   EVAL      VDBRCD = CDCSBR
     C                   EVAL      VDCNUM = CDCSCN
     C                   EVAL      VDPTFR = CDPTFR
     C                   EVAL      VDBLTY = 'P'
     C                   EVAL      VDSESN = CDCSEC

     C                   IF        MATY <> 0 and MATY < CDEDAT or
     C                             CDEDAT = 0
     C                   EVAL      VDBEDT = MATY
     C                   ELSE

     C                   IF        CDEDAT <> 0 and CDEDAT < MATY or
     C                             MATY = 0
     C                   EVAL      VDBEDT = CDEDAT
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      VDSEQN = WSEQN
     C                   EVAL      VDNOMB = 0

     C                   IF        CDDESC <> *BLANKS
     C                   EVAL      VDBNAR = CDDESC
     C                   ELSE
     C                   EVAL      VDBNAR = 'COLLATERAL'
     C                   ENDIF

     C                   EVAL      VDBSTT = CDVDAT
     C                   EVAL      VDEWIN = WERRIN
     C                   EVAL      VDCOLF = 'Y'
     C                   EVAL      VDCOLA = 0

     C                   WRITE     SEBLKPD0
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   READ      GLCOLLL1
     C                   ENDDO

      ** Access all records in SEBLKPPD file

     C     *LOVAL        SETLL     SEBLKPL1
     C                   READ      SEBLKPL1

     C                   DOW       NOT %EOF(SEBLKPL1)

     C                   IF        VDBLTY = 'P' and VDSEQN = 99900 or
     C                             VDBLTY = 'P' and VDSEQN = 99901

     C                   EVAL      WCOLNOM = 0
     C                   EVAL      WBLKNOM = 0
     C                   EVAL      WBLKDAT = VDBSTT

     C     VDSESN        CHAIN     SECTY                              15

     C                   IF        *IN15 = *OFF

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   IF        CDRECI = 'D' and CDCOPT = 'P' and
     C                             CDCSBR = VDBRCD and CDCSCN = VDCNUM and
     C                             CDPTFR = VDPTFR and CDCSEC = VDSESN and
     C                             CDSTAT = 'C' and CDCSEC <> *BLANKS

     C                   IF        CDBCOL = 'N' and VDSEQN = 99900 or
     C                             CDBCOL = 'Y' and VDSEQN = 99901

     C                   IF        (CDEDAT = VDBEDT and (MATY = 0 or
     C                             (CDEDAT <> 0 and CDEDAT < MATY))) or
     C                             (MATY = VDBEDT and (CDEDAT = 0 or
     C                             (MATY <> 0 and MATY < CDEDAT)))

     C                   IF        CDAPCT = 'A'
     C                   EVAL      WCOLVAL = CDNAMT
     C                   ELSE
     C                   EVAL      WCOLVAL = CDMNNA
     C                   ENDIF

     C                   EVAL      WCOLNOM = WCOLNOM + WCOLVAL
     C                   EVAL      WBLKNOM = WBLKNOM + WCOLVAL

     C                   IF        CDVDAT < WBLKDAT or WBLKDAT = 0
     C                   EVAL      WBLKDAT = CDVDAT
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   READ      GLCOLLL1
     C                   ENDDO

     C                   IF        WBLKNOM < 0
     C                   EVAL      WBLKNOM = 0
     C                   ENDIF

     C                   IF        WCOLNOM <= 0
     C                   EVAL      WCOLNOM = 0
     C***********        EVAL      WCOLFLG = 'N'                                              249974
     C***********        ELSE                                                                 249974
     C***********        EVAL      WCOLFLG = 'Y'                                              249974
     C                   ENDIF

      ** Update file

     C                   EVAL      VDCOLA = WCOLNOM
     C***********        EVAL      VDCOLF = WCOLFLG                                           249974
     C                   EVAL      VDBSTT = WBLKDAT

     C                   IF        VDLCD = 99999
     C                   EVAL      VDLCD = BJRDNB
     C                   EVAL      VDNOMB = WBLKNOM
     C                   ENDIF

     C                   IF        VDNOMB < WCOLNOM
     C                   EVAL      VDNOMB = WCOLNOM
     C                   ENDIF

     C                   IF        VDSEQN = 99900
     C                   EVAL      VDEWIN = 'W'
     C                   ELSE

     C                   IF        VDSEQN = 99901
     C                   EVAL      VDEWIN = 'E'
     C                   ENDIF

     C                   ENDIF

     C                   UPDATE    SEBLKPD0

     C                   ENDIF

     C                   ENDIF

      ** Read next record

     C                   READ      SEBLKPL1
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACCOUN2 - Update Account Details File                       *
      *                                                               *
      *****************************************************************

     C     SRACCOUN2     BEGSR

     C                   IF        CGL014 = 'Y'

      ** Access all records in ACCNTAB file

     C     *LOVAL        SETLL     ACCNTL0
     C                   READ      ACCNTL0

     C                   DOW       NOT %EOF(ACCNTL0)

     C                   IF        ATYP = 'R'

     C                   EVAL      WBLKAMT = 0
     C                   EVAL      WCOLAMT = 0

     C     *LOVAL        SETLL     GLCOLLL1
     C                   READ      GLCOLLL1

     C                   DOW       NOT %EOF(GLCOLLL1)

     C                   IF        CDRECI = 'D' and CDCOPT = 'A' and
     C                             CDCBRC = BRCA and CDCCNM = CNUM and
     C                             CDCCCY = CCY and CDCACD = ACOD and
     C                             CDCSEQ = ACSQ and CDSTAT = 'C'

     C**********         IF        CDAPCT = 'A'                                             BUG17986
     C**********         EVAL      WCOLVAL = CDNAMT                                         BUG17986
     C**********         ELSE                                                               BUG17986
     C                   EVAL      WCOLVAL = CDVAMT                                         BUG17986
     C                   IF        CDMNNA <> 0                                              BUG17986
     C                   EVAL      WCOLVAL = CDMNNA
     C                   ENDIF

     C                   IF        CDCCY = CCY
     C                   EVAL      WCOLAMT = WCOLAMT + WCOLVAL
     C                   ELSE
     C                   EVAL      WCCY1 = CDCCY
     C                   EVAL      WCCY2 = CCY
     C                   EVAL      WINAMT = WCOLVAL
     C                   EXSR      SRCONVERT
     C                   EVAL      WCOLAMT = WCOLAMT + WOUTAMT
     C                   ENDIF

     C                   IF        CDBCOL = 'Y'

     C                   IF        CDCCY = FCCY
     C                   EVAL      WBLKAMT = WBLKAMT + WCOLVAL
                                                                                              CAP205
     C                   IF        CAP205 = 'Y'                                               CAP205
     C                   EVAL      TempAmount = WCOLVAL                                       CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
     C                   ELSE
     C                   EVAL      WCCY1 = CDCCY
     C                   EVAL      WCCY2 = CCY
     C                   EVAL      WINAMT = WCOLVAL
     C                   EXSR      SRCONVERT
     C                   EVAL      WBLKAMT = WBLKAMT + WOUTAMT
                                                                                              CAP205
     C                   IF        CAP205 = 'Y'                                               CAP205
     C                   EVAL      TempAmount = WOUTAMT                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   ENDIF
                                                                                              CAP205
     C                   IF        CAP205 = 'Y'                                               CAP205
     C     KBrchRef      CHAIN     GLCOLLQ0                                                   CAP205
                                                                                              CAP205
     C                   IF        NOT %FOUND(GLCOLLQ0)                                       CAP205
     C                   EVAL      QCDXBRC = CDCBRC                                           CAP205
     C                   EVAL      QCDXREF = CDCREF                                           CAP205
     C                   EVAL      QCDXCBC = TempAmount                                       CAP205
     C                   WRITE     GLCOLQD0                                                   CAP205
     C                   ELSE                                                                 CAP205
     C                   EVAL      QCDXCBC = TempAmount                                       CAP205
     C                   UPDATE    GLCOLQD0                                                   CAP205
     C                   ENDIF                                                                CAP205
     C                   ENDIF                                                                CAP205

     C                   ENDIF

     C                   ENDIF

     C                   READ      GLCOLLL1
     C                   ENDDO

     C                   IF        WBLKAMT < 0
     C                   EVAL      WBLKAMT = 0
     C                   ENDIF

     C                   IF        WCOLAMT <= 0
     C                   EVAL      WCOLAMT = 0
     C***********        EVAL      WCOLFLG = 'N'                                              249974
     C***********        ELSE                                                                 249974
     C***********        EVAL      WCOLFLG = 'Y'                                              249974
     C                   ENDIF

      ** Update file

     C                   EVAL      BCOA = WBLKAMT
     C***********        EVAL      COLF = WCOLFLG                                             249974
     C                   EVAL      COLA = WCOLAMT
                                                                                            BUG27959
     C                   CALL      'AOCURRR0'                                               BUG27959
     C                   PARM      *BLANKS       PRTCD                                      BUG27959
     C                   PARM      '*KEY   '     POPTN                                      BUG27959
     C                   PARM      CCY           WCCY2                                      BUG27959
     C     SDCURR        PARM      SDCURR        DSSDY                                      BUG27959
                                                                                            BUG27959
      ** Database error                                                                     BUG27959
                                                                                            BUG27959
     C                   IF        PRTCD <> *BLANKS                                         BUG27959
     C                   EVAL      DBFILE = 'SDCURRPD'                                      BUG27959
     C                   EVAL      DBASE = 6                                                BUG27959
     C                   EVAL      DBKEY = WCCY2                                            BUG27959
     C                   EXSR      *PSSR                                                    BUG27959
     C                   ENDIF                                                              BUG27959
     C                   EVAL      WNBDP2 = A6NBDP                                          BUG27959

     C                   EVAL      WCOLAMT = WCOLAMT / 10**WNBDP2                           BUG27655
     C                   IF        MINB < WCOLAMT
     C                   EVAL      MINB = WCOLAMT
     C                   ENDIF

     C                   UPDATE    ACCNTABF

     C                   ENDIF

      ** Read next record

     C                   READ      ACCNTL0
     C                   ENDDO

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCONVERT - Convert Currency                                  *
      *                                                               *
      *****************************************************************

     C     SRCONVERT     BEGSR

      ** From currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WCCY1
     C     SDCURR        PARM      SDCURR        DSSDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = WCCY1
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Save necessary details

     C                   EVAL      WSPRT1 = A6SPRT
     C                   EVAL      WMDIN1 = A6MDIN
     C                   EVAL      WNBDP1 = A6NBDP

      ** To currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WCCY2
     C     SDCURR        PARM      SDCURR        DSSDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = WCCY2
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Save necessary details

     C                   EVAL      WSPRT2 = A6SPRT
     C                   EVAL      WMDIN2 = A6MDIN
     C                   EVAL      WNBDP2 = A6NBDP

      ** Get exchange rate

     C                   CALLB     'ZXRATE'
     C                   PARM                    WSPRT1
     C                   PARM                    WMDIN1
     C                   PARM                    WSPRT2
     C                   PARM                    WMDIN2
     C                   PARM                    WRATE
     C                   PARM                    WMDIN

      ** Convert amount

     C                   CALLB     'ZCONVZ1'
     C                   PARM                    WINAMT
     C                   PARM                    WRATE
     C                   PARM                    WMDIN
     C                   PARM                    WCCY1
     C                   PARM                    WCCY2
     C                   PARM                    WNBDP1
     C                   PARM                    WNBDP2
     C                   PARM                    WOUTAMT

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGETCOLD - Get Collateral Details                           *
      *                                                               *
      *****************************************************************

     C     SRGETCOLD     BEGSR

      ** Create/Instantiate "CalcClass" java object (one time only)
      ** so as to access its "calculateCavClvAllocation" method later

     C                   IF        WFIRST = 'Y'
     C                   EVAL      Parm7 = crtString(WFolder)
     C                   EVAL      CalcClassObj = crtCalcClass(Parm7)
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF

      ** Create java string objects for all parameters to be passed to
      ** calculateCavClvAllocation

     C                   EVAL      Parm1 = crtString(CDCREF)
     C                   EVAL      Parm2 = crtString(CDCOPT)
     C                   EVAL      Parm3 = crtString(CDCSBR)
     C*****              EVAL      Parm4 = CDCSCN                                             CSD027
     C                   EVAL      Parm4 = crtString(CDCSCN)                                  CSD027
     C                   EVAL      Parm5 = crtString(CDPTFR)
     C                   EVAL      Parm6 = crtString(CDCSEC)

      ** Invoke the calculateCavClvAllocation method of the CalcClass object

     C                   EVAL      RcvParms = getValues(CalcClassObj:
     C                                                  Parm1:
     C                                                  Parm2:
     C                                                  Parm3:
     C                                                  Parm4:
     C                                                  Parm5:
     C                                                  Parm6)

      ** Convert the received java string to RPG bytes (Varying alpha field)

     C                   EVAL      WRcvStr = *BLANKS
     C                   EVAL      WRcvStr = cvtToBytes(RcvParms)

      ** Retrieve all fields from received string via substring function

     C                   EVAL      WRcvFld0 = %SUBST(WRcvStr:1:1)

      ** Report if error occurred in calculator processing

     C                   IF        WRcvFld0 = 'E'

     C                   MOVEL     *ZEROS        PCAVTD
     C                   MOVEL     *ZEROS        PCAVD1
     C                   MOVEL     *ZEROS        PCAVD2
     C                   MOVEL     *ZEROS        PCAVD3
     C                   MOVEL     *ZEROS        PCAVD4
     C                   MOVEL     *ZEROS        PCAVD5
     C                   MOVEL     *ZEROS        PCAVD6
     C                   MOVEL     *ZEROS        PCAVD7
     C                   MOVEL     *ZEROS        PCAVD8
     C                   MOVEL     *ZEROS        PCAVD9
     C                   MOVEL     *ZEROS        PCLVTD
     C                   MOVEL     *ZEROS        PCLVD1
     C                   MOVEL     *ZEROS        PCLVD2
     C                   MOVEL     *ZEROS        PCLVD3
     C                   MOVEL     *ZEROS        PCLVD4
     C                   MOVEL     *ZEROS        PCLVD5
     C                   MOVEL     *ZEROS        PCLVD6
     C                   MOVEL     *ZEROS        PCLVD7
     C                   MOVEL     *ZEROS        PCLVD8
     C                   MOVEL     *ZEROS        PCLVD9
     C                   MOVEL     *ZEROS        PTOTAL
     C                   MOVEL     *ZEROS        PPCTAL
     C                   MOVEL     *ZEROS        PNUMAL
     C                   MOVEL     *ZEROS        PALAMT

      ** Produce report

     C                   EVAL      WERROR = 'Y'
     C                   EXSR      SRREPORT

     C                   ELSE

     C                   EVAL      WRcvFld1 = %SUBST(WRcvStr:1:15)
     C                   EVAL      WRcvFld2 = %SUBST(WRcvStr:16:15)
     C                   EVAL      WRcvFld3 = %SUBST(WRcvStr:31:15)
     C                   EVAL      WRcvFld4 = %SUBST(WRcvStr:46:15)
     C                   EVAL      WRcvFld5 = %SUBST(WRcvStr:61:15)
     C                   EVAL      WRcvFld6 = %SUBST(WRcvStr:76:15)
     C                   EVAL      WRcvFld7 = %SUBST(WRcvStr:91:15)
     C                   EVAL      WRcvFld8 = %SUBST(WRcvStr:106:15)
     C                   EVAL      WRcvFld9 = %SUBST(WRcvStr:121:15)
     C                   EVAL      WRcvFld10 = %SUBST(WRcvStr:136:15)
     C                   EVAL      WRcvFld11 = %SUBST(WRcvStr:151:15)
     C                   EVAL      WRcvFld12 = %SUBST(WRcvStr:166:15)
     C                   EVAL      WRcvFld13 = %SUBST(WRcvStr:181:15)
     C                   EVAL      WRcvFld14 = %SUBST(WRcvStr:196:15)
     C                   EVAL      WRcvFld15 = %SUBST(WRcvStr:211:15)
     C                   EVAL      WRcvFld16 = %SUBST(WRcvStr:226:15)
     C                   EVAL      WRcvFld17 = %SUBST(WRcvStr:241:15)
     C                   EVAL      WRcvFld18 = %SUBST(WRcvStr:256:15)
     C                   EVAL      WRcvFld19 = %SUBST(WRcvStr:271:15)
     C                   EVAL      WRcvFld20 = %SUBST(WRcvStr:286:15)
     C                   EVAL      WRcvFld21 = %SUBST(WRcvStr:301:15)
     C                   EVAL      WRcvFld22 = %SUBST(WRcvStr:316:10)
     C                   EVAL      WRcvFld23 = %SUBST(WRcvStr:326:4)

     C                   EVAL      WAllocErr = %SUBST(WRcvStr:326:1)

     C                   IF        WAllocErr = 'E'
     C                   EVAL      WERROR = 'Y'
     C                   EXSR      SRREPORT
     C                   ENDIF

     C                   IF        WRcvFld23 <> *ZEROS and WAllocErr <> 'E'
     C                   MOVE      WRcvFld23     WLIMIT
     C                   ELSE
     C                   MOVE      *ZEROS        WLIMIT
     C                   ENDIF

     C                   IF        WLIMIT <> 0
     C                   EVAL      WEND = WLIMIT * 41
     C                   EVAL      WRcvFld24 = %SUBST(WRcvStr:330:WEND)
     C                   ELSE
     C                   EVAL      WRcvFld24 = *BLANKS
     C                   ENDIF

     C                   MOVEL     WRcvFld1      PCAVTD
     C                   MOVEL     WRcvFld2      PCAVD1
     C                   MOVEL     WRcvFld3      PCAVD2
     C                   MOVEL     WRcvFld4      PCAVD3
     C                   MOVEL     WRcvFld5      PCAVD4
     C                   MOVEL     WRcvFld6      PCAVD5
     C                   MOVEL     WRcvFld7      PCAVD6
     C                   MOVEL     WRcvFld8      PCAVD7
     C                   MOVEL     WRcvFld9      PCAVD8
     C                   MOVEL     WRcvFld10     PCAVD9
     C                   MOVEL     WRcvFld11     PCLVTD
     C                   MOVEL     WRcvFld12     PCLVD1
     C                   MOVEL     WRcvFld13     PCLVD2
     C                   MOVEL     WRcvFld14     PCLVD3
     C                   MOVEL     WRcvFld15     PCLVD4
     C                   MOVEL     WRcvFld16     PCLVD5
     C                   MOVEL     WRcvFld17     PCLVD6
     C                   MOVEL     WRcvFld18     PCLVD7
     C                   MOVEL     WRcvFld19     PCLVD8
     C                   MOVEL     WRcvFld20     PCLVD9
     C                   MOVEL     WRcvFld21     PTOTAL
     C                   MOVEL     WRcvFld22     PPCTAL
     C                   MOVEL     WRcvFld23     PNUMAL
     C                   MOVEL     WRcvFld24     PALAMT

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRREPORT - Report Errors Encountered in Calculator            *
      *                                                               *
      *****************************************************************

     C     SRREPORT      BEGSR

     C                   MOVEL     CDCREF        RCDCREF
     C                   EVAL      RCDDESC = 'ERROR OCCURRED IN CALCULATOR +
     C                                       PROCESSING'

      ** Check that sufficient lines remain for the format

     C                   EVAL      RQDLN1 = 2
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     DETAIL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     KBrchRef      KLIST                                                                CAP205
     C                   KFLD                    CDCBRC                                       CAP205
     C                   KFLD                    CDCREF                                       CAP205
                                                                                              CAP205
     C                   EVAL      DBPGM = 'GL001500'

      ** Access bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if CGL014 is switched on

     C                   EVAL      CGL014 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL014'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = 'CGL014'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CGL014 = 'Y'
     C                   ENDIF
                                                                                              CAP205
      ** Check if CAP205 is switched on                                                       CAP205
                                                                                              CAP205
     C                   EVAL      CAP205 = 'N'                                               CAP205
     C                   CALLB     'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       PRTCD                                        CAP205
     C                   PARM      '*VERIFY'     POPTN                                        CAP205
     C                   PARM      'CAP205'      PSARD                                        CAP205
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP205
                                                                                              CAP205
      ** Database error                                                                       CAP205
                                                                                              CAP205
     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '                    CAP205
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP205
     C                   EVAL      DBASE = 5                                                  CAP205
     C                   EVAL      DBKEY = 'CAP205'                                           CAP205
     C                   EXSR      *PSSR                                                      CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
     C                   IF        PRTCD = *BLANKS                                            CAP205
     C                   EVAL      CAP205 = 'Y'                                               CAP205
     C                   ENDIF                                                                CAP205

     C                   EVAL      WFIRST = 'Y'
     C                   EVAL      WERROR = 'N'

      ** Open report file

     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0

     C                   OPEN      GL001500P1
     C                   WRITE     HEADP1

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

     C                   ENDSR

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program Exception Error Routine                          *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
** ArrUPPER
ABCDEFGHIJKLMNOPQRSTUVQXYZ
** ArrLOWER
abcdefghijklmnopqrstuvwxyz

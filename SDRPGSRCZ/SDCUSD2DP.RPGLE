     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer details display - primary screen')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDCUSD2DP  - Customer Details Display - Primary Screen       *
      *                                                               *
      *  Function:  This module displays the primary details screen   *
      *             of the customer details screen input function     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW216             Date 14Mar16               *
      *                 CSW214             Date 02Jun14               *
      *                 CFT050             Date 03Jun13               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 261588             Date 02Sep09               *
      *                 BUG23648           Date 21Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15037           Date 16Oct07               *
      *                 BUG14991           Date 10Oct07               *
      *                 BUG14840           Date 02Aug07               *
      *                 CSW207A            Date 02Aug07               *
      *                 CSW207             Date 06Jul07               *
      *                 248028             Date 04Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG3517            Date 20Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9150            Date 21Jul06               *
      *                 237595             Date 07Feb06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG8134            Date 10Oct05               *
      *                 BUG10755           Date 08Mar06               *
      *                 BUG10738           Date 02Mar06               *
      *                 CSD028             Date 22Aug05               *
      *                 CSD025A            Date 27Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 BUG6216            Date 10Mar05               *
      *                 BUG5450            Date 08Mar05               *
      *                 BUG6074            Date 28Feb05               *
      *                 217230             Date 02Sep03               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG2950            Date 02Jun04               *
      *                 CFX001             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001             Date 23May03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 212226             Date 13Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 202787             Date 08May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW024             Date 31Aug01               *
      *                 191530             Date 05Jun01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 175680             Date 03Mar00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP014             Date 14Dec99               *
      *                 CAP034  *CREATE    Date 01May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  CFT050 - SWIFTRef Directories upload                         *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,SDH00106                                 *
      *             WNCPYSRC,SDH00107                                 *
      *             WNCPYSRC,SDH00108                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  261588 - Recompiled over changed SDCUSD2DDF.                 *
      *  BUG23648 - INCA and Party Cap. Indicator are enabled during  *
      *             enquiry (Recompile)                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15037 - Error message should be a warning                 *
      *  BUG14991 - SWIFT 2007 Additional fields not protected        *
      *             during Customer Detail Enquiry (Recompile)        *
      *  BUG14840- Missing objects from Swift 2007 delivery.          *
      *            (Recompile)                                        *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  248028 - Can't edit Customer Type.  Apply 237285.            *
      *  BUG3517 - Branch on customer should not be amendable         *
      *  BUG9150 - Change shortname to amendable field                *
      *  237595 - Recompiled over changes made in DSPF/SDCUSD2DDF.    *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  BUG8134 - Recompiled source to fix this bug                  *
      *  BUG10755 - Cosmetic error for new customer definition screen *
      *  BUG10738 - Customer insert doesn't continue on second screen *
      *             upon Enter                                        *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *  CSD025A- Inactive status                                     *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198 - Cannot save new Details for CUSD (Recompile)       *
      *  BUG6216 - Strange 1-char field appears in CUstomer Details   *
      *            Maintenance                                        *
      *  BUG5450 - Designated In Currency field should not be         *
      *            displayed in Customer Details                      *
      *  BUG6074 - Change shortname to non-amendable field            *
      *  217230 - Tax/Non-tax field on Customer Maintenance must be   *
      *           amendable even for PB Customer. Recompiled due to   *
      *           change in display file.                             *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG2950- Recompiled due to changed DSPF/SDCUSD2DDF.          *
      *  CFX001 - FX Margin Trading                                   *
      *  CLE025 - Credit Lines                                        *
      *  CGP001 - Global Processing                                   *
      *  212226 - DDPRBA indicator problem.                           *
      *  202787 - PB Customer Maintenance - Fields protection         *
      *           Correct fix 175680 as same indicator is used by     *
      *           CSD007. Replace *IN74 with *IN77.                   *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *  191530 - SDCUSDSIN - Unable to send msg RE7105B.  Need to    *
      *           recompile pgm to pick up changes made in cpysrc     *
      *           MSGHNDDATA.                                         *
      *  175680 - PB Customer Maintenance - Fields protection         *
      *  CSD007 - Customer Closing: new Closure status fields         *
      *  CDL008 - Continous Linked Settlement (Recompiled)            *
      *  CAP014 - Repair function enhancements                        *
      *  CAP034 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCUSD2DDFCF   E             WORKSTN
 
      * Customer Details Retrieval                                                            CSD007
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD007
                                                                                              CSD007
      ** Customer Details Acceptance - Retrieve Index                                         CSD031
     FSDACSTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD031
     F                                     RENAME(SDCUSTD0:SDACSTD1)                          CSD031
                                                                                              CSD031
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      ** Customer Details Retrieval Shadow File                                               CSD028
     FSDCDSHL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD028
     F                                     RENAME(@BBREBF:@BBRESH)                            CSD028
                                                                                              CSD028
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      ********66**CSD025*switch****************************************               CSD025 BUG6216
      *       64  Nondisplay Central Data and Effective Date fields   *                       CSD031
      *       65  Protect selected fields if CSD037 is ON             *                       CSD031
      *       67  Error on Private Banking Field                      *
      *       68  Condition Display of Private Banking Field          *
      *       69  Position cursor on first screen field if no errors  *
      *       70  Protect screen fields                               *
      *       71  Enable function keys F7/F8 (read previous/next)     *
      *       72  Enable function key F10 (delete)                    *
      *       73  Enable function key F23 (further details)           *
      *       74  Enable function key F22 (closure/release)           *                       CSD007
      *       78  CSD025 switch                                       *                      BUG6216
      *       79  Protect/Enable shortname                            *                      BUG6074
      *       81  Condition non display of margin type field          *
      *       82  Condition display of Retail 3 field                 *
      *       83  Condition display of Management Accounts field      *
      *       84  Condition display of COB deletion field             *
      *       85  Condition display of Branch Code field              *
      *       86  Condition display of Suspended Date field           *
      *       88  Condition display of DRS Shortname fields           *
      *       89  Condition display of Base Rate Tax field            *
      *       97  Subfile end                                         *
      *       99  Read error                                          *
      ********************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **--------------------------------------------------------------------------------------------
 
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
 
     D @EI             S              1    DIM(60)
 
 
     D CuPrim        E DS                  EXTNAME(SDCUPRPD)
     D OKCuPrim      E DS                  EXTNAME(SDECUPRPD)
      ** Swift Extension                                                                      CSW207
     D CuSwft        E DS                  EXTNAME(SDCUSWPD)                                  CSW207
      ** Swift Extension - OK Indicators                                                      CSW207
     D OKCuSwft      E DS                  EXTNAME(SDECUSWPD)                                 CSW207
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for SAR Details                                                          CSD007
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD007
                                                                                              CSD007
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CGP001          S              1A                                                      CGP001
                                                                                              CGP001
     D CFX001          S              1                                                       CFX001
     D CLE025          S              1                                                       CLE025
                                                                                              CLE025
     D CSD037          S              1A                                                      CSD031
                                                                                              CSD031
     D PAccMde         S              1A                                                      CSD031
                                                                                              CSD031
     D CSD028          S              1                                                       CSD028
     D P@Rtcd          S              7                                                       CSD028
     D P@Optn          S              7                                                       CSD028
     D P@Sard          S              6                                                       CSD028
     D CSW207          S              1A                                                      CSW207
     D WDDBDRK         S             12A                                                      CFT050
     D @INKV           S              1A                                                      CFT050
     D @EINKV          S              1A                                                      CFT050
     D CFT050          S              1A                                                      CFT050
     D CFT004          S              1A                                                      CFT050
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
                                                                                              212226
      ** Private Banking Customer                                                             212226
     C                   MOVE      *OFF          *IN68                                        212226
     C     BGN4ST        IFEQ      'N'                                                        212226
     C                   MOVE      *ON           *IN68                                        212226
     C                   ENDIF                                                                212226
      ** Enable F21 Key                                                                       CFT050
     C                   EVAL      *IN79 = *OFF                                               CFT050
     C                   IF        CFT050 = 'Y'                                               CFT050
     C                             AND CFT004 = 'Y'                                           CFT050
      *                                                                                       CFT050
     C                   SELECT                                                               CFT050
     C                   WHEN      DDACTN = 'I'                                               CFT050
     C                   EVAL      *IN79 = *ON                                                CFT050
     C                   IF        WDDBDRK = *BLANKS                                          CFT050
     C                   EVAL      DFCF21 = 'F21=Link  '                                      CFT050
     C                   ELSE                                                                 CFT050
     C                   EVAL      DFCF21 = 'F21=Unlink'                                      CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
     C                   WHEN      DDACTN = 'A'                                               CFT050
     C                   EVAL      *IN79 = *ON                                                CFT050
     C                   EVAL      DFCF21 = 'F21=Link  '                                      CFT050
     C                   IF        WDDBDRK <> *BLANKS                                         CFT050
     C                   EVAL      DFCF21 = 'F21=Unlink'                                      CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
     C                   ENDSL                                                                CFT050
      *                                                                                       CFT050
     C                   ENDIF                                                                CFT050
      *
      * Main processing
      *
     C                   EXSR      MAIN
      *
      * Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   MOVEA     OKCuPrim      @EI
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   MOVEA     OKCuSwft      @EI(43)                                      CSW207
     C                   ENDIF                                                                CSW207
      *
      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
 
 
      ** Set up the customer reference to be used by the message handler
     C                   EVAL      TranRef = DDCUSN
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
      *
      * Position cursor on first field if no errors
      *
     C     'N'           LOOKUP    @EI                                    69
      *
      * Protect Suspended Date field on Insert
      *
     C                   MOVE      *OFF          *IN86
     C     DDACTN        IFEQ      'I'
     C                   MOVE      *ON           *IN86
     C                   ENDIF
                                                                                              CSD007
      ** If CSD007 is installed, retrieve Customer Status                                     CSD007
                                                                                              CSD007
     C                   EVAL      DDCLST = *BLANKS                                           CSD007
     C                   EVAL      DDCLDT = *BLANKS                                           CSD007
                                                                                              CSD007
     C     CSD007        IFEQ      'Y'                                                        CSD007
     C     DDACTN        ANDNE     'I'                                                        CSD007
     C     DDACTN        ANDNE     ' '                                                        CSW024
                                                                                              CSD031
     C                   IF        CSD037 = 'Y' AND                                           CSD031
     C                             PAccMde = 'A'                                              CSD031
     C     DDCUSN        CHAIN     SDACSTL1                           80                      CSD031
     C                   ELSE                                                                 CSD031
                                                                                              CSD028
      ** Access customer details shadow file                                                  CSD028
                                                                                              CSD028
     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
     C     DDCUSN        CHAIN     SDCDSHL1                           80                      CSD028
     C                   ELSE                                                                 CSD028
     C     DDCUSN        CHAIN     SDCUSTL1                           80                      CSD007
     C                   ENDIF                                                                CSD028
     C                   ENDIF                                                                CSD031
                                                                                              CSD007
      ** If Customer is not on file, database error                                           CSD007
                                                                                              CSD007
     C     *IN80         IFEQ      *ON                                                        CSD007
     C                   MOVEL     'SDCUSTL1'    DBFILE                                       CSD007
     C                   MOVEL     '906'         DBASE                                        CSD007
     C                   MOVEL     DDCUSN        DBKEY                                        CSD007
     C                   EXSR      SRERR                                                      CSD007
     C                   ELSE                                                                 CSD007
                                                                                              CSD007
      ** Else, set Status and Change date                                                     CSD007
                                                                                              CSD007
     C                   SELECT                                                               CSD007
     C                   WHEN      BBDTDL <> *ZERO                                            CSD007
     C                   EVAL      DDCLST = 'DELETED'                                         CSD007
     C                   Z-ADD     BBDTDL        ZDAYNO                                       CSD007
     C                   EXSR      ZDATE2                                                     CSD007
     C                   MOVE      ZDATE         DDCLDT                                       CSD007
                                                                                              CSD007
     C                   WHEN      BBCLST = 'Y'                                               CSD007
     C                   EVAL      DDCLST = 'CLOSED '                                         CSD007
     C                   Z-ADD     BBCLDT        ZDAYNO                                       CSD007
     C                   EXSR      ZDATE2                                                     CSD007
     C                   MOVE      ZDATE         DDCLDT                                       CSD007
                                                                                             CSD025A
     C                   WHEN      DDDEAC='Y' and CSD025='Y'                                 CSD025A
     C                   EVAL      DDCLST = 'INACTIVE'                                       CSD025A
                                                                                              CSD007
     C                   OTHER                                                                CSD007
     C                   EVAL      DDCLST = 'ACTIVE '                                         CSD007
     C     BBCLDT        IFNE      *ZERO                                                      CSD007
     C                   Z-ADD     BBCLDT        ZDAYNO                                       CSD007
     C                   EXSR      ZDATE2                                                     CSD007
     C                   MOVE      ZDATE         DDCLDT                                       CSD007
     C                   ENDIF                                                                CSD007
     C                   ENDSL                                                                CSD007
                                                                                              CSD007
     C                   ENDIF                                                                CSD007
                                                                                              CSD007
     C                   ENDIF                                                                CSD007
                                                                                            BUG10738
     C**********         IF        CSD007 = 'Y' AND (DDACTN = 'I'                  BUG10738 BUG10755
     C**********                   OR DDACTN = ' ')                                BUG10738 BUG10755
     C**********         EVAL      *IN75 = *ON                                     BUG10738 BUG10755
     C**********         ENDIF                                                     BUG10738 BUG10755
                                                                                             BUG6074
      ***Protect*shortname**                                                         BUG6074 BUG9150
                                                                                             BUG6074
     C**********         EVAL      *IN79 = *OFF                                      BUG6074 BUG9150
     C**********         IF         DDACTN = 'A'                                     BUG6074 BUG9150
     C**********         EVAL      *IN79 = *ON                                       BUG6074 BUG9150
     C**********         ENDIF                                                       BUG6074 BUG9150
      *
      * Protect all fields
      *
     C                   MOVE      *OFF          *IN70
     C***CAP014          SELECT                                                 CAP014
     C***  DDACTN        WHENEQ    'I'                                          CAP014
     C***  DDACTN        WHENEQ    'A'                                          CAP014
     C***                OTHER                                                  CAP014
     C***                MOVE      *ON           *IN70                          CAP014
     C***CAP014          ENDSL                                                  CAP014
      *                                                                         CAP014
      * ENABLE DETAIL FIELDS (ALL FIELDS EXCEPT ACTION CODE & DEAL NUMBER)      CAP014
      *                                                                         CAP014
     C     @EDTFD        COMP      'Y'                                7070      CAP014
      *                                                                         175680
      * Protect all fields except: Designated  In Ccy, Parent Indicator         175680
      * Parent, Suspended Date, Date of First Contact and Branch                175680
      *                                                                         175680
     C**********         MOVE      *OFF          *IN74                                 175680 202787
     C                   MOVE      '0'           *IN77                                        202787
     C     DDACTN        IFEQ      'A'                                          175680
     C     DDPRBA        ANDEQ     'Y'                                          175680
     C**********         MOVE      *ON           *IN70                               175680 BUG15037
     C**********         MOVE      *ON           *IN74                                 175680 202787
     C                   MOVE      '1'           *IN77                                        202787
     C                   ENDIF                                                  175680
      *                                                                                       CSD031
      ** Protect Name, Shortname, Address, Status, Report Name, Global                        CSD031
      ** Customer, Town, Account Officer, Retail Customer Group,                              CSD031
      ** Branch, Country of Domicile, Country of Citizenship, Parent                          CSD031
      ** Customer and Location Code if CSD037 in ON.                                          CSD031
      *                                                                                       CSD031
     C                   EVAL      *IN65  = *OFF                                              CSD031
     C                   IF        CSD037 = 'Y'                                               CSD031
     C     DDCUSN        CHAIN     SDCUSTL1                                                   CSD031
     C                   IF        %FOUND(SDCUSTL1)                                           CSD031
     C                   EVAL      *IN65  = *ON                                               CSD031
     C                   ENDIF                                                                CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
      ** Nondisplay Central Data and Effective Date fields if Central                         CSD031
      ** Data is not "Y".                                                                     CSD031
      *                                                                                       CSD031
     C                   EVAL      *IN64  = *ON                                               CSD031
     C                   IF        DDGPDT = 'Y'                                               CSD031
     C                   EVAL      *IN64  = *OFF                                              CSD031
     C                   ENDIF                                                                CSD031
      *
      ** Check if SWIFT 2007 is installed :                                                   CSW207
      *                                                                                       CSW207
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   EVAL      *IN66  = *OFF                                              CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      *IN66  = *ON                                               CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
      * ENABLE FUNCTION KEYS
      *
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKJ        COMP      'Y'                                    72
     C     @EINKW        COMP      'Y'                                    74                  CSD007
     C     @EINKX        COMP      'Y'                                    73
      *
      * WRITE MESSAGE SUBFILE, PRIMARY DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     SDCUSDPS0
     C                   WRITE     SDCUSDPD1
     C                   WRITE     SDCUSDPF1
      *
      * READ DETAILS SCREEN, If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      SDCUSDPD1                              99
     C                   ENDIF
      *
      ** IF EXIT/PREVIOUS SCREEN NOT SELECTED
      ** PROCESS USER REQUEST FOR DATA TABLES WITH QUERY '?'
      *
     C     @INKC         IFNE      *ON
     C     @INKL         ANDNE     *ON
      *
      * Location Code
     C                   MOVEL     DDLCCD        QRYFLD            1
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD0550S'
     C                   PARM                    RETURN            7
     C                   PARM                    DDLCCD
     C                   ENDIF
      *
      **Designated*In-currency*****************************************
     C**********         MOVEL     DDDINC        QRYFLD                                      BUG5450
     C*****QRYFLD        IFEQ      '?'                                                       BUG5450
     C**********         CALL      'SD0020S'                                                 BUG5450
     C**********         PARM                    RETURN                                      BUG5450
     C**********         PARM                    DDDINC                                      BUG5450
     C**********         ENDIF                                                               BUG5450
      *
      * Parent Indicator
     C                   MOVEL     DDPAIN        QRYFLD            1
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'Y2VLLSR'
     C                   PARM                    RETURN            7
     C                   PARM      1104000       Y2LSNO            7 0
     C     DDPAIN        PARM                    SELECTION        20
     C                   ENDIF
      *
      * Parent Customer Number
     C                   MOVEL     DDPCNB        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD0010S'
     C                   PARM                    RETURN
     C                   PARM                    DDPCNB
     C                   ENDIF
      *
      * Account Officer
     C                   MOVEL     DDACOC        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD0201S'
     C                   PARM                    RETURN
     C                   PARM                    DDACOC
     C                   ENDIF
      *
      * Country of Citizenship
     C                   MOVEL     DDCNCZ        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD0180S'
     C                   PARM                    RETURN
     C                   PARM                    DDCNCZ
     C                   ENDIF
      *
      * Branch Indicator
     C                   MOVEL     DDBSIN        QRYFLD            1
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'Y2VLLSR'
     C                   PARM                    RETURN            7
     C                   PARM      1100850       Y2LSNO            7 0
     C     DDBSIN        PARM                    SELECTION        20
     C                   ENDIF
      *
      * Country of Domicile
     C                   MOVEL     DDCOLC        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD0180S'
     C                   PARM                    RETURN
     C                   PARM                    DDCOLC
     C                   ENDIF
      *
      * Bank/Non-bank Indicator
     C                   MOVEL     DDBNBI        QRYFLD            1
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'Y2VLLSR'
     C                   PARM                    RETURN            7
     C                   PARM      1100770       Y2LSNO            7 0
     C     DDBNBI        PARM                    SELECTION        20
     C                   ENDIF
      *
      * Local Institution Code
     C                   MOVEL     DDLINC        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD0090S'
     C                   PARM                    RETURN
     C                   PARM                    DDLINC
     C                   ENDIF
      *
      * Local Industry Code
     C                   MOVEL     DDLICD        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD0100S'
     C                   PARM                    RETURN
     C                   PARM                    DDLICD
     C                   ENDIF
      *
      * Branch Code
     C                   MOVEL     DDBRCD        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD0061S'
     C                   PARM                    RETURN
     C                   PARM                    DDBRCD
     C                   ENDIF
      *
      * Risk Weighting Code
     C                   MOVEL     DDRWCD        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD1400S'
     C                   PARM                    RETURN
     C                   PARM                    DDRWCD
     C                   ENDIF
      *
      * MA Analysis by Assoc. Customer
     C                   MOVEL     DDMCAC        QRYFLD            1
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'Y2VLLSR'
     C                   PARM                    RETURN            7
     C                   PARM      1182543       Y2LSNO            7 0
     C     DDMCAC        PARM                    SELECTION        20
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      * Clear message subfile
      *
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * SET RETURN KEYS
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKW         @INKW                                        CSD007
     C                   MOVE      *INKX         @INKX
     C                   MOVE      *INKV         @INKV                                        CFT050
     C/COPY WNCPYSRC,SDH00106
      *
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************                       CSD007
      /EJECT                                                                                  CSD007
      *****************************************************************                       CSD007
      * ZDATE2 - Format a date for output                                                     CSD007
      *****************************************************************                       CSD007
                                                                                              CSD007
     C     ZDATE2        BEGSR                                                                CSD007
                                                                                              CSD007
     C                   CALLB     'ZDATE2'                                                   CSD007
     C                   PARM                    ZDAYNO            5 0                        CSD007
     C                   PARM                    BJDFIN                                       CSD007
     C                   PARM                    ZDATE             6 0                        CSD007
     C                   PARM                    ZADATE            7                          CSD007
                                                                                              CSD007
     C                   ENDSR                                                                CSD007
                                                                                              CSD007
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Custo (IN SCREEN FORMAT - Primary)
     C                   PARM                    CuPrim
      *
      * Fields in error
     C                   PARM                    OKCuPrim
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED KEY & DETAIL FIELDS
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS (AND KH = KEY 08 = READ NEXT)
      * KJ = COMMAND KEY 10 = DELETE
      * KW = COMMAND KEY 22 = CONFIRM CLOSURE/RELEASE                                         CSD007
      * KX = COMMAND KEY 23 = FURTHER DETAILS
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKW            1                          CSD007
     C                   PARM                    @EINKX            1
      ** Switchable features                                                                  CLE025
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
      ** Transaction Type                                                                     CSD028
     C                   PARM                    TransType                                    CSD028
     C                   PARM                    CSD037                                       CSD031
     C                   PARM                    @EINKV                                       CFT050
      *                                                                                       CSW207
      * Customer (IN SCREEN FORMAT - Swift Extension)                                         CSW207
     C                   PARM                    CuSwft                                       CSW207
      *                                                                                       CSW207
      * Fields in error                                                                       CSW207
     C                   PARM                    OKCuSwft                                     CSW207
      ** Linkage record key                                                                   CFT050
     C                   PARM                    WDDBDRK                                      CFT050
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C/COPY WNCPYSRC,SDH00107
     C                   PARM                    @INKW             1                          CSD007
     C                   PARM                    @INKX             1
     C                   PARM                    @INKV                                        CFT050
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      ** Acceptance Mode                                                                      CSD031
     C                   PARM                    PAccMde                                      CSD031
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSDPDSP'  DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      ** GET MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** Set screen conditioning indicators
      *
     C     BGUDRS        IFEQ      'Y'
     C                   MOVE      *ON           *IN88
     C                   ENDIF
     C     BGMBIN        IFEQ      'N'
     C                   MOVE      *ON           *IN85
     C                   ENDIF
     C     BGNVST        IFEQ      'N'
     C                   MOVE      *ON           *IN83
     C                   ENDIF
     C     BGNXST        IFEQ      'N'
     C     BGNXST        OREQ      *BLANK
     C                   MOVE      *ON           *IN82
     C                   ENDIF
     ** The following codes need to be executed everytime this module                         212226
     ** is run, thus, taken out of the *INZSR.                                                212226
      ***Private*Banking*Module****************************************                       212226
     C*****BGN4ST        IFEQ      'N'                                                        212226
     C**********         MOVE      *ON           *IN68                                        212226
     C**********         ENDIF                                                                212226
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Check if switchable feature S01424 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01424'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01424'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
     C     @RTCD         IFEQ      '*NRF   '
     C                   MOVE      *ON           *IN84
     C                   END
      *
      ** Check if switchable feature CDL001 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL001'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CDL001'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
     C     @RTCD         IFEQ      '*NRF   '
     C                   MOVE      *ON           *IN81
     C                   END
      *
      ** Check if switchable feature S01383 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01383'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      *ON           *IN89
     C                   ENDIF
                                                                                              CSD007
      ** Check if switchable feature CSD007 is switched on.                                   CSD007
                                                                                              CSD007
     C                   CALLB     'AOSARDR0'                                                 CSD007
     C                   PARM      *BLANKS       @RTCD                                        CSD007
     C                   PARM      '*VERIFY'     @OPTN                                        CSD007
     C                   PARM      'CSD007'      @SARD                                        CSD007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD007
                                                                                              CSD007
     C     @RTCD         IFNE      *BLANKS                                                    CSD007
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD007
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD007
     C                   MOVEL     '905'         DBASE                                        CSD007
     C                   MOVEL     @SARD         DBKEY                                        CSD007
     C                   EXSR      SRERR                                                      CSD007
     C                   ENDIF                                                                CSD007
                                                                                              CSD007
     C     @RTCD         IFEQ      *BLANKS                                                    CSD007
     C                   MOVEL     'Y'           CSD007            1                          CSD007
     C                   EVAL      *IN75 = *OFF                                               CSD007
     C                   ELSE                                                                 CSD007
     C                   MOVEL     'N'           CSD007                                       CSD007
     C                   EVAL      *IN75 = *ON                                                CSD007
     C                   ENDIF                                                                CSD007
                                                                                              CSD007
      ** Check if Global Data Layout Enhancement (CGP001) is on.                              CGP001
                                                                                              CGP001
     C                   EVAL      CGP001 = 'N'                                               CGP001
     C                   EVAL      *IN87 = *ON                                                CGP001
                                                                                              CGP001
     C                   CALLB     'AOSARDR0'                                                 CGP001
     C                   PARM      *BLANKS       @RTCD                                        CGP001
     C                   PARM      '*VERIFY'     @OPTN                                        CGP001
     C                   PARM      'CGP001'      @SARD                                        CGP001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGP001
                                                                                              CGP001
     C                   IF        @RTCD = *BLANKS                                            CGP001
     C                   EVAL      CGP001 = 'Y'                                               CGP001
     C                   EVAL      *IN87 = *OFF                                               CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
     C                   IF        @RTCD <> *BLANKS and                                       CGP001
     C                             @RTCD <> '*NRF   '                                         CGP001
     C                   EVAL      DBFILE= 'SCSARDPD'                                         CGP001
     C                   EVAL      DBKEY = @SARD                                              CGP001
     C                   EVAL      DBASE = 907                                                CGP001
     C                   EXSR      SRERR                                                      CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
      ** If CLE025 is on, display Facility Mandatory and Include Offsets fields               CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
     C                             OR  CFX001 = 'Y'                                           CFX001
     C                   EVAL      *IN76 = *ON                                                CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      *IN76 = *OFF                                               CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
      *                                                                                       CSD025
      ** Check if switchable feature CSD025 is switched on.                                   CSD025
      *                                                                                       CSD025
     C                   CALL      'AOSARDR0'                                                 CSD025
     C                   PARM      *BLANKS       @RTCD                                        CSD025
     C                   PARM      '*VERIFY'     @OPTN                                        CSD025
     C                   PARM      'CSD025'      @SARD                                        CSD025
      *                                                                                       CSD025
      ** DATABASE ERROR                                                                       CSD025
      *                                                                                       CSD025
      ** Replace *IN66 with *IN78 because the former is being reset                          BUG6216
      ** using @Z0 along with other screen error indicators.                                 BUG6216
      *                                                                                      BUG6216
     C**********         MOVE      *ON           *IN66                                CSD025 BUG6216
     C                   MOVE      *ON           *IN78                                       BUG6216
      *                                                                                       CSD025
     C     @RTCD         IFNE      *BLANKS                                                    CSD025
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD025
     C                   MOVEL     'CSD025'      DBKEY                                        CSD025
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD025
     C                   MOVEL     '910'         DBASE                                        CSD025
     C                   EXSR      SRERR                                                      CSD025
     C                   END                                                                  CSD025
      *                                                                                       CSD025
     C                   MOVE      'N'           CSD025                                      CSD025A
      *                                                                                      CSD025A
     C     @RTCD         IFEQ      *BLANKS                                                    CSD025
     C**********         MOVE      *OFF          *IN66                                CSD025 BUG6216
     C                   MOVE      *OFF          *IN78                                       BUG6216
     C                   MOVE      'Y'           CSD025            1                         CSD025A
     C                   ENDIF                                                                CSD025
                                                                                              CSD028
      ** Check if switchable feature CSD028, KYC is switched on.                              CSD028
                                                                                              CSD028
     C                   CALLB     'AOSARDR0'                                                 CSD028
     C                   PARM      *BLANKS       P@Rtcd                                       CSD028
     C                   PARM      '*VERIFY'     P@Optn                                       CSD028
     C                   PARM      'CSD028'      P@Sard                                       CSD028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD028
                                                                                              CSD028
     C                   IF        P@Rtcd <> *BLANKS  AND P@Rtcd <> '*NRF   '                 CSD028
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD028
     C                   MOVEL     '908'         DBASE                                        CSD028
     C                   MOVEL     P@Sard        DBKEY                                        CSD028
     C                   EXSR      SRERR                                                      CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
     C                   IF        P@Rtcd = *BLANKS                                           CSD028
     C                   EVAL      CSD028 = 'Y'                                               CSD028
     C                   ELSE                                                                 CSD028
     C                   EVAL      CSD028 = 'N'                                               CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       P@Rtcd                                       CSW207
                                                                                              CSW207
     C                   IF        P@Rtcd  = 'CSW2007'                                        CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAl      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
     C/COPY WNCPYSRC,SDH00108
                                                                                              CSW207
      *                                                                                       CFT050
      ** Check if switchable feature CFT050 is switched on.                                   CFT050
      *                                                                                       CFT050
     C                   CALLB     'AOSARDR0'                                                 CFT050
     C                   PARM      *BLANKS       @RTCD                                        CFT050
     C                   PARM      '*VERIFY'     @OPTN                                        CFT050
     C                   PARM      'CFT050'      @SARD                                        CFT050
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT050
                                                                                              CFT050
     C     @RTCD         IFNE      *BLANKS                                                    CFT050
     C     @RTCD         ANDNE     '*NRF   '                                                  CFT050
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT050
     C                   MOVEL     '906'         DBASE                                        CFT050
     C                   MOVEL     @SARD         DBKEY                                        CFT050
     C                   EXSR      SRERR                                                      CFT050
     C                   ENDIF                                                                CFT050
                                                                                              CFT050
     C                   MOVEL     'N'           CFT050                                       CFT050
     C     @RTCD         IFEQ      *BLANKS                                                    CFT050
     C                   MOVEL     'Y'           CFT050                                       CFT050
     C                   ENDIF                                                                CFT050
                                                                                              CFT050
      *                                                                                       CFT050
      ** Check if switchable feature CFT004 is switched on.                                   CFT050
      *                                                                                       CFT050
     C                   CALLB     'AOSARDR0'                                                 CFT050
     C                   PARM      *BLANKS       @RTCD                                        CFT050
     C                   PARM      '*VERIFY'     @OPTN                                        CFT050
     C                   PARM      'CFT004'      @SARD                                        CFT050
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT050
                                                                                              CFT050
     C     @RTCD         IFNE      *BLANKS                                                    CFT050
     C     @RTCD         ANDNE     '*NRF   '                                                  CFT050
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT050
     C                   MOVEL     '907'         DBASE                                        CFT050
     C                   MOVEL     @SARD         DBKEY                                        CFT050
     C                   EXSR      SRERR                                                      CFT050
     C                   ENDIF                                                                CFT050
                                                                                              CFT050
     C                   MOVEL     'N'           CFT004                                       CFT050
     C     @RTCD         IFEQ      *BLANKS                                                    CFT050
     C                   MOVEL     'Y'           CFT004                                       CFT050
     C                   ENDIF                                                                CFT050
                                                                                              CFT050
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SDCUSDPDSP'  DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminte the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000

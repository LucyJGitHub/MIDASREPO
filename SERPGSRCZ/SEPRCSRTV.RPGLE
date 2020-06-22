     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Market prices action validation')             *
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module                                    *
      *                                                               *
      *  SEPRCSRTV - SE Market Price Retrieve                         *
      *              (with Action Code versus Security Validation)    *
      *                                                               *
      *  Function:  This module validates the implied action code of  *
      *             'I' against Security key fields                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR1075401          Date 01Jun20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD047196           Date 08Aug17               *
      *                 MD037408           Date 25May16               *
      *                 AR1092524          Date 12Mar13               *
      *                 255418             Date 13Nov12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248150             Date 04Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 241575             Date 14Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11512           Date 19Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG10949           Date 19Jan06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9982            Date 19Jan06               *
      *                 BUG9725            Date 05Jan06               *
      *                 BUG8550            Date 07Oct05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 214817             Date 28Mar03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD010             Date 03May02               *
      *                 205873             Date 16May01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060             Date 04Oct00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CAP030  *CREATE    Date 26Feb99               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1075401 - Increase QANOML and QAOTNM length in PMCPOSPD.   *
      *              Recompiled. (Child: AR1075402)                   *
      *  MD046248 - Finastra Rebranding                               *
      *  MD047196 - Authority Validation not working.                 *
      *  MD037408 - SE PRICES Input Insert New Security Shortname not *
      *             validated initially eventhough value of field is  *
      *             invalid                                           *
      *  AR1092524 - Data inserted in Branch, Market & Book were not  *
      *           displayed in the Main list view of Securities       *
      *           Prices.                                             *
      *  255418 - Validate if the customer entered is existing.       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248150 - Security Prices Updates through API : Unable to     *
      *           repair invalid price entries. Apply 209850.         *
      *  241575 - Get err message 'A serious Midas error has occurred'*
      *           when try to input any price. Use new logical file   *
      *           CPOSNL3 instead of CPOSN which is already used      *
      *           somewhere else. Patterned on GEMS 219714            *
      *  BUG11512 - Deletion not allowed; applied 232345              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10949 - Apply BUG9982. Price not shown upon enquire.      *
      *             Also include the fixed made by BUG9725 when       *
      *             swithable feature CAP060 is off.                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9982- Price not shown upon enquire.                       *
      *           Also include the fixed made by BUG9725 when         *
      *           swithable feature CAP060 is off.                    *
      *  BUG9725- Clear @PTFR if Price Type <> 'CT' or 'CD'           *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CGL031 - Taxation on Savings Income (Recompile)              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  214817 - Not able to '?' on security field. Fix is to call   *
      *           SE0043 when '?' is entered.                         *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *           (Recompile)                                         *
      *  205873 - Check if security price is insert or amend          *
      *           if CSD006 is on                                     *
      *  CAP060 - Conversion of Midas Screen Input Program into full  *
      *           API, including repair program which CAP030 does not *
      *           include                                             *
      *  CAP030 - API for SE Price input                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F**********PRICE     IF   E           K DISK    INFSR(*PSSR)                             CAP060
     FPRICEL1   IF   E           K DISK    INFSR(*PSSR)                                       CAP060

     FSECTY     IF   E           K DISK    INFSR(*PSSR)

     FSECTYL5   IF   E           K DISK    INFSR(*PSSR)                                       CAP060
     F                                     RENAME(SECTYDF:SECTYMDF)                           CAP060
     F                                     PREFIX(MDF)                                        CAP060

     FPRICEL0   IF   E           K DISK    INFSR(*PSSR)                                       CAP060
     F                                     RENAME(PRICEDF:SEPRCSFOI)                          CAP060

     FBKPHD     IF   E           K DISK    INFSR(*PSSR)                                       CAP060
                                                                                              CAP060
     F***CPOSN**   IF   E           K DISK    INFSR(*PSSR)                             CAP060 241575
     FCPOSNL3   IF   E           K DISK    INFSR(*PSSR)                                       241575
                                                                                              CAP060
     FPMPORTPD  IF   E           K DISK    INFSR(*PSSR)                                       CAP060
                                                                                              CAP060
     FPMAPOSLL  IF   E           K DISK    INFSR(*PSSR)                                       CAP060
                                                                                              CAP060
     FEXVALDL1  IF   E           K DISK    INFSR(*PSSR)                                       CAP060
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * DATA STRUCTURE FOR Midas Module Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D PRCSFilFmt    E DS                  EXTNAME(PRICED)
     D FL_RECI       E                     EXTFLD(RECI)                                      CAP060

      ** Price record in File Format

     D ZMUSER        E DS                  EXTNAME(ZMUSER)
      ** Obtain default branch for user

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                 CAP060
      ** Branch details                                                                      CAP060
      *                                                                                      CAP060
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 CAP060
     D** Customer Details                                                                    CAP060
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                    CGL029
      *                                                                                      CAP060
     D SDSECS        E DS                  EXTNAME(SDSECSPD)                                  255418
     D BFZONE        E                     EXTFLD(SEZONE)                                     255418
                                                                                              255418
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                                 CAP060
      ** Portfolio Management ICD                                                            CAP060
                                                                                             CAP060
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)                                 CAP060
      ** Book Details                                                                        CAP060
                                                                                             CAP060
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                 CAP060
     D** Currency Details                                                                    CAP060
                                                                                             CAP060
      ** Array for manipulating decimal positions                                            CAP060
     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)                           CAP060

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
     D Wx              S              3P 0                                                   CAP060

     D* Profit Centre Switchable Feature                                                     CAP060
     D CAC005          S              1A                                                     CAP060

     D* Sec Prices API switchable feature                                                    CAP060
     D CAP060F         S              1A                                                     CAP060

     D* Sec Prices API switchable feature                                                    205873
     D CSD006F         S              1A                                                     205873

     D* Customer No in file format                                                           CAP060
     D*@PCNM****       S              6S 0                                            CAP060  CSD027
     D @PCNM           S              6A                                                      CSD027
     D WSECN           S             10A                                                      214817
     D CSE010          S              1A                                                      214817
     D/COPY WNCPYSRC,SEH00067
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
      **  GET ZMUSER to access default branch.                                               BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
      *                                                                                      BUG8550
     C                   EXSR      INIT
      *
      * VALIDATE SECURITY KEY FIELDS
      *
      * If CAP060 is off, perform the following validation:                                   CAP060
      * ----------------------------------------------------                                  CAP060
     C**********         IF        CAP060F= 'N'                                      CAP060 BUG11512
      **********                                                                            BUG11512
     C**********         EXSR      VAL                                                      BUG11512
      *****************************************************************                     BUG11512
      ****Carry*out*no*further*validation*if*errors*have*occurred.*****                     BUG11512
      *****************************************************************                     BUG11512
     C*****OKACTN        IFEQ      'N'                                                      BUG11512
     C*****OKPSSN        OREQ      'N'                                                      BUG11512
     C*****OKPPRT        OREQ      'N'                                                      BUG11512
     C**********         RETURN                                                             BUG11512
     C**********         END                                                                BUG11512
      *****************************************************************                     BUG11512
      ****-----------------------------------------------**************                     BUG11512
      *****Access*Security*Checking************************************                     BUG11512
      ****-----------------------------------------------**************                     BUG11512
      *****************************************************************                     BUG11512
     C*****RespMode      IFEQ      'S'                                                      BUG11512
     C**********         EXSR      SecChk                                                   BUG11512
     C**********         ENDIF                                                              BUG11512
     C**********                                                                            BUG11512
      **********                                                                            BUG11512
      **Return**                                                                            BUG11512
      **********                                                                            BUG11512
     C**********         RETURN                                                             BUG11512
     C**********         ENDIF                                                       CAP060 BUG11512
                                                                                              CAP060
      * If CAP060 is on,  perform the following validation:                                   CAP060
      * ---------------------------------------------------                                   CAP060
     C                   IF        CAP060F= 'Y'                                               CAP060
      *                                                                                       CAP060
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'                                   CAP060
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE                          CAP060
      *                                                                                       CAP060
     C     ModeofOp      IFEQ      '*FRONT'                                                   CAP060
     C                   EXSR      VFRNT                                                      CAP060
      *                                                                                       CAP060
      **  Carry out no further validation if errors have occurred.                            CAP060
      *                                                                                       CAP060
     C     OKACTN        IFEQ      'N'                                                        CAP060
     C                   RETURN                                                               CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                     BUG11512
     C                   ENDIF                                                              BUG11512
      *                                                                                       CAP060
      * VALIDATE SECURITY KEY FIELDS                                                          CAP060
      *                                                                                       CAP060
      * Check for any ? processing                                                            CAP060
     C                   EXSR      CHKSEL                                                     CAP060
                                                                                              CAP060
      * Validate key fields                                                                   CAP060
     C                   EXSR      MDFVAL                                                     CAP060
      *                                                                                       CAP060
      **  Carry out no further validation if errors have occurred.                            CAP060
      *                                                                                       CAP060
     C     OKACTN        IFEQ      'N'                                                        CAP060
     C     OKPSSN        OREQ      'N'                                                        CAP060
     C     OKPBRA        OREQ      'N'                                                        CAP060
     C     OKPRFC        OREQ      'N'                                                        CAP060
     C     OKPBOK        OREQ      'N'                                                        CAP060
     C                   RETURN                                                               CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       CAP060
      *  *-----------------------------------------------*                                    CAP060
      *  * Access Security Checking                      *                                    CAP060
      *  *-----------------------------------------------*                                    CAP060
      *                                                                                       CAP060
     C     RespMode      IFEQ      'S'                                                        CAP060
     C                   EXSR      SecChk                                                     CAP060
     C                   ENDIF                                                                CAP060
     C* this change obviates the need for an a/code if the data is coming from MDF;           205873
     C* based on the data sent, we work out here whether we need to amend or insert           205873
     C                   IF        CSD006F = 'Y' AND                                          205873
     C                             ModeofOp =  '*FRONT'                                       205873
      * Retrieve price from file                                                              205873
     C     @PRICK        CHAIN     PRICEL1                                                    205873
     C                   IF        %FOUND AND                                                 205873
     C                             RECI <> '*'                                                205873
     C                   EVAL      DDACTN = 'A'                                               205873
     C                   ELSE                                                                 205873
     C                   EVAL      DDACTN = 'I'                                               205873
     C                   ENDIF                                                                205873
     C                   ENDIF                                                                205873
      *                                                                                       CAP060
      *  *--------------------------------*                                                   CAP060
      *  * Validation for Action Code 'I' *                                                   CAP060
      *  *--------------------------------*                                                   CAP060
      *                                                                                       CAP060
     C     DDACTN        IFEQ      'I'                                                        CAP060
     C                   EXSR      VALACI                                                     CAP060
     C                   END                                                                  CAP060
      *                                                                                       CAP060
      *  *--------------------------------*                                                   CAP060
      *  * Validation for Action Code 'E' *                                                   CAP060
      *  *--------------------------------*                                                   CAP060
      *                                                                                       CAP060
     C     DDACTN        IFEQ      'E'                                                        CAP060
     C                   EXSR      RTVPRCS                                                    CAP060
     C                   END                                                                  CAP060
      *                                                                                       CAP060
      *  *--------------------------------*                                                   CAP060
      *  * Validation for Action Code 'A' *                                                   CAP060
      *  *--------------------------------*                                                   CAP060
      *                                                                                       CAP060
     C     DDACTN        IFEQ      'A'                                                        CAP060
     C                   EXSR      RTVPRCS                                                    CAP060
     C                   EXSR      VALACA                                                     CAP060
     C                   END                                                                  CAP060
      *                                                                                       CAP060
      *  *--------------------------------*                                                   CAP060
      *  * Validation for Action Code 'D' *                                                   CAP060
      *  *--------------------------------*                                                   CAP060
      *                                                                                       CAP060
     C     DDACTN        IFEQ      'D'                                                        CAP060
     C                   EXSR      RTVPRCS                                                    CAP060
     C                   EXSR      VALACD                                                     CAP060
     C                   END                                                                  CAP060
      * Return                                                                                CAP060
     C                   RETURN                                                               CAP060
     C**********         ENDIF                                                       CAP060 BUG11512
      *****************************************************************
      /EJECT
      *****************************************************************
      **VAL*-*VALIDATE*SECURITY*KEY*FIELDS*****************************                     BUG11512
      *****************************************************************                     BUG11512
     C*****VAL**         BEGSR                                                              BUG11512
      *****************************************************************                     BUG11512
      ***Check*that*Action*code*is*'I'*or*'A'*and*security*shortname*entered                BUG11512
      *****************************************************************                     BUG11512
     C*****DDACTN        IFNE      'I'                                                      BUG11512
     C*****DDACTN        ANDNE     'A'                                                      BUG11512
     C*****DDACTN        ANDNE     'E'                                              BUG9982 BUG11512
     C**********         MOVE      'N'           OKACTN                                     BUG11512
     C**********         ADD       1             Ix                                         BUG11512
     C**********         MOVEL     'DDACTN'      FldNameArr(Ix)                             BUG11512
     C**********         MOVEL     'MMA0805'     MsgIdArr(Ix)                               BUG11512
     C**********         GOTO      EVAL                                                     BUG11512
     C**********         END                                                                BUG11512
     C*****DDPSSN        IFEQ      *BLANKS                                                  BUG11512
     C**********         MOVE      'N'           OKPSSN                                     BUG11512
     C**********         ADD       1             Ix                                         BUG11512
     C**********         MOVEL     'DDPSSN'      FldNameArr(Ix)                             BUG11512
     C**********         MOVEL     'MMA0806'     MsgIdArr(Ix)                               BUG11512
     C**********         GOTO      EVAL                                                     BUG11512
     C**********         END                                                                BUG11512
      ****************************************************************                      BUG11512
      ***Action*code*is*'I'or*'A',*check*the*key*fields***************                      BUG11512
      ****************************************************************                      BUG11512
      ****************************************************************                      BUG11512
      ***Security*shortname*must*reference*an*active*security*record**                      BUG11512
      ****************************************************************                      BUG11512
     C*****DDPSSN        CHAIN     SECTYDF                            33                    BUG11512
     C**N33RECI*         COMP      'D'                                3333                  BUG11512
     C******IN33         IFEQ      '1'                                                      BUG11512
     C**********         MOVE      'N'           OKPSSN                                     BUG11512
     C**********         ADD       1             Ix                                         BUG11512
     C**********         MOVEL     'DDPSSN'      FldNameArr(Ix)                             BUG11512
     C**********         MOVEL     'MMA0802'     MsgIdArr(Ix)                               BUG11512
     C**********         GOTO      EVAL                                                     BUG11512
     C**********         ENDIF                                                              BUG11512
      ****************************************************************                      BUG11512
      ***The*only*Price*type*allowed*is*'V*'*i.e.*Change*to*Market Price                    BUG11512
      ****************************************************************                      BUG11512
     C*****DDPPRT        IFNE      'V '                                                     BUG11512
     C**********         MOVE      'N'           OKPPRT                                     BUG11512
     C**********         ADD       1             Ix                                         BUG11512
     C**********         MOVEL     'DDPPRT'      FldNameArr(Ix)                             BUG11512
     C**********         MOVEL     'MMA0803'     MsgIdArr(Ix)                               BUG11512
     C**********         GOTO      EVAL                                                     BUG11512
     C**********         END                                                                BUG11512
      ****************************************************************                      BUG11512
      ***If*Action*=*Input,*Price*should*not*already*exist************                      BUG11512
      ****************************************************************                      BUG11512
     C**********         MOVEL     DDPSSN        @PSSN                                      BUG11512
     C*******************MOVEL     *BLANKS       @PCNM                                        CAP060
     C**********         MOVEL     *ZEROS        @PCNM                                 CAP060 CSD027
     C**********         EVAL      @PCNM = *BLANKS                                   CSD027 BUG11512
     C**********         MOVEL     ' '           @PMKT                                      BUG11512
     C**********         MOVEL     *BLANKS       @PBRA                                      BUG11512
     C**********         MOVEL     *BLANKS       @PBOK                                      BUG11512
     C**********         MOVEL     DDPPRT        @PPRT                                      BUG11512
     C*****BGPFMG        IFEQ      'Y'                                                      BUG11512
     C**********         MOVEL     '    '        @PTFR                                      BUG11512
     C**********         ELSE                                                               BUG11512
     C**********         MOVEL     '9997'        @PTFR                                      BUG11512
     C**********         ENDIF                                                              BUG11512
     ******************************************************************             BUG9982 BUG11512
      ***@PTFR*should*be*blanks*if*Price*Type*<>*'CT'*or*'CV'**********             BUG9982 BUG11512
     C**********         IF        DDPPRT <> 'CT'                                   BUG9982 BUG11512
     C**********                   AND DDPPRT <> 'CV'                               BUG9982 BUG11512
     C**********         EVAL      @PTFR = *BLANKS                                  BUG9982 BUG11512
     C**********         ENDIF                                                      BUG9982 BUG11512
     ******************************************************************             BUG9982 BUG11512
     C*****@PRICK********CHAIN     PRICE                              99                      CAP060
     C*****@PRICK        CHAIN     PRICEL1                            99             CAP060 BUG11512
     C******IN99         IFEQ      '0'                                                      BUG11512
     C*****RECI*         ANDNE     '*'                                                      BUG11512
     C*****DDACTN        IFEQ      'I'                                                      BUG11512
     C**********         CLEAR                   PRCSFilFmt                                 BUG11512
     C**********         MOVE      'N'           OKPSSN                                     BUG11512
     C**********         ADD       1             Ix                                         BUG11512
     C**********         MOVEL     'DDPSSN'      FldNameArr(Ix)                             BUG11512
     C**********         MOVEL     'MMA0804'     MsgIdArr(Ix)                               BUG11512
     C**********         GOTO      EVAL                                                     BUG11512
     C**********         ENDIF                                                              BUG11512
     C**********         ELSE                                                               BUG11512
      *****************************************************************                     BUG11512
      ***Action*code*=*A,*live*record*must*exist***********************                     BUG11512
      *****************************************************************                     BUG11512
     C*****DDACTN        IFEQ      'A'                                                      BUG11512
     C**********         MOVE      'N'           OKPSSN                                     BUG11512
     C**********         ADD       1             Ix                                         BUG11512
     C**********         MOVEL     'DDPSSN'      FldNameArr(Ix)                             BUG11512
     C**********         MOVEL     'MMA0807'     MsgIdArr(Ix)                               BUG11512
     C**********         GOTO      EVAL                                                     BUG11512
     C**********         ENDIF                                                              BUG11512
     C**********         ENDIF                                                              BUG11512
      *****************************************************************s                    BUG11512
     C*****EVAL*         ENDSR                                                              BUG11512
      *****************************************************************
      /EJECT
      *****************************************************************                       CAP060
      * MDFVAL  - VALIDATE SECURITY KEY FIELDS, WHEN CAP060 is ON                             CAP060
      *****************************************************************                       CAP060
     C     MDFVAL        BEGSR                                                                CAP060
      *                                                                                       CAP060
      ** Check that Action code is 'I','A','D' or 'E'                                         CAP060
      *                                                                                       CAP060
      *  Action Code                                                                          CAP060
      *  -----------                                                                          CAP060
     C                   IF        CSD006F='N'                                                205873
     C     DDACTN        IFNE      'I'                                                        CAP060
     C     DDACTN        ANDNE     'A'                                                        CAP060
     C     DDACTN        ANDNE     'E'                                                        CAP060
     C     DDACTN        ANDNE     'D'                                                        CAP060
     C                   MOVE      'N'           OKACTN                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1158'     MsgIdArr(Ix)                                 CAP060
     C                   GOTO      EMDFVAL                                                    CAP060
     C                   END                                                                  CAP060
     C                   ENDIF                                                                205873
                                                                                              CAP060
      *  Security Shortname                                                                   CAP060
      *  ------------------                                                                   CAP060
     C     DDPSSN        IFEQ      *BLANKS                                                    CAP060
     C                   MOVE      'N'           OKPSSN                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPSSN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA0806'     MsgIdArr(Ix)                                 CAP060
     C                   GOTO      EMDFVAL                                                    CAP060
     C                   END                                                                  CAP060
                                                                                              CAP060
      *  Customer                                                                             CAP060
      *  --------                                                                             CAP060
      * If client shortname has been entered fetch the number                                 CAP060
     C                   MOVEL     DDPCNM        @KEYC                                        CAP060
     C                   CALL      'AOCUSTR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*KEY   '     @OPTN                                        CAP060
     C                   PARM                    @KEYC            10                          CAP060
     C                   PARM      *BLANKS       @KYST             7                          CAP060
     C     SDCUST        PARM      SDCUST        DSSDY                                        CAP060
                                                                                              CAP060
     C     @RTCD         IFEQ      *BLANKS                                                    CAP060
     C                   MOVEL(P)  BBCUST        DDPCNM                                       CAP060
     C                   MOVEL     BBCUST        @PCNM                                        CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVEL     DDPCNM        @PCNM                                        CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       CAP060
      * Set up fields for chains to files                                                     CAP060
     C                   MOVE      DDPSSN        @PSSN                                        CAP060
     C                   MOVEL     DDPMKT        @PMKT                                        CAP060
     C                   MOVEL     DDPBRA        @PBRA                                        CAP060
     C                   MOVEL     DDPBOK        @PBOK                                        CAP060
     C                   MOVEL     DDPPRT        @PPRT                                        CAP060
     C                   MOVEL     DDPTFR        @PTFR                                      BUG11512
     C                   MOVEL     DDPBOK        PBCD              2                          CAP060
     C                   MOVEL     DDPRFC        PRFC              4                          CAP060
     C/COPY WNCPYSRC,SEH00125
      *                                                                                       CAP060
      ** Branch                                                                               CAP060
      ** ------                                                                               CAP060
      *                                                                                       CAP060
      * If branch is not entered, use default branch to check authority                       CAP060
      * of user                                                                               CAP060
     C                   IF        BJSBRC = *BLANKS                                           CAP060
     C                   IF        DDPBRA = *BLANKS                                           CAP060
     C                   EVAL      ZBR = DBRN                                                 CAP060
                                                                                              CAP060
      * If multibranching,                                                                    CAP060
      * branch hasn't been entered,                                                           CAP060
      * price type is not 'V'                                                                 CAP060
      * and portfolio has not been entered, default the branch, else set it to blanks         CAP060
                                                                                              CAP060
     C                   IF        DDPPRT <> 'V'   AND                                        CAP060
     C                             DDPTFR = *BLANKS                                           CAP060
     C                   EVAL      DDPBRA = DBRN                                              CAP060
     C                   ELSE                                                                 CAP060
     C                   EVAL      DDPBRA = *BLANKS                                           CAP060
     C                   ENDIF                                                                CAP060
     C                   ELSE                                                                 CAP060
      * If multibranching, and branch has been entered, validate it.                          CAP060
                                                                                              CAP060
     C**********         CALL      'AOBRCHR0'                                          CAP060 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7                          CAP060
     C                   PARM      '*KEY   '     @OPTN             7                          CAP060
     C                   PARM      DDPBRA        @DSNB             3                          CAP060
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 CAP060 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS                                                    CAP060
     C                   MOVE      'N'           OKPBRA                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDBRSN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1159'     MsgIdArr(Ix)                                 CAP060
     C                   GOTO      EMDFVAL                                                    CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVEL     A8BRCD        DDPBRA                                       CAP060
     C                   MOVEL     A8BRCD        ZBR               3                          CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       CAP060
      * Profit Centre                                                                         CAP060
      * --------------                                                                        CAP060
      *                                                                                       CAP060
      ** If CAC005 is on, validate the profit centre                                          CAP060
      *                                                                                       CAP060
     C                   IF        CAC005 = 'Y'                                               CAP060
      *                                                                                       CAP060
      * Profit Centre should be entered if                                                    CAP060
      * price type is 'DT' or 'DV'.                                                           CAP060
      *                                                                                       CAP060
     C     DDPPRT        IFEQ      'DT'                                                       CAP060
     C     DDPRFC        ANDEQ     *BLANKS                                                    CAP060
     C     DDPPRT        OREQ      'DV'                                                       CAP060
     C     DDPRFC        ANDEQ     *BLANKS                                                    CAP060
     C                   MOVE      'N'           OKPRFC                                       CAP060
     C                   MOVE      'N'           OKPBOK                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPRFC'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1115'     MsgIdArr(Ix)                                 CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       CAP060
     C     DDPBOK        IFNE      *BLANKS                                                    CAP060
     C                   CALL      'AOBKPCR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*PSEUDO'     @OPTN                                        CAP060
     C                   PARM      DDPBOK        PBOOK             2                          CAP060
     C                   PARM      DDPRFC        PPRFC             4                          CAP060
     C                   PARM                    PPSCD             2                          CAP060
      *                                                                                       CAP060
     C     @RTCD         IFEQ      *BLANKS                                                    CAP060
      *                                                                                       CAP060
      * Set up fields for chain to book header file                                           CAP060
     C                   MOVEL     PPSCD         @PBOK                                        CAP060
     C                   MOVE      'Y'           OKPRFC                                       CAP060
     C                   ELSE                                                                 CAP060
      *                                                                                       CAP060
      * Profit Centre is not authorised to use the book                                       CAP060
     C                   MOVE      'N'           OKPRFC                                       CAP060
     C                   MOVE      'N'           OKPBOK                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPRFC'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1114'     MsgIdArr(Ix)                                 CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       CAP060
      * Portfolio Reference                                                                   CAP060
      * -------------------                                                                   CAP060
                                                                                              CAP060
      * If portfolio management is on                                                         CAP060
     C                   IF        DDACTN <> 'E' AND                                        BUG11512
     C                             DDACTN <> 'D'                                            BUG11512
     C                   IF        BGPFMG     = 'Y'                                           CAP060
     C                   IF        DDPTFR =  FCR997 AND                                       CAP060
     C                             FCPORS      <> 'B' AND                                     CAP060
     C                             BGN4ST   <> 'Y' OR                                         CAP060
     C                             FCPORS        = 'B' AND                                    CAP060
     C                             DDPTFR <> *BLANKS AND                                      CAP060
     C                             DDPTFR = FCR997 AND                                        CAP060
     C                             BGN4ST   <> 'Y'                                            CAP060
     C                   MOVE      '9997'        @PTFR                                        CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVEL     DDPTFR        @PTFR                                        CAP060
     C                   ENDIF                                                                CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVEL     *BLANKS       @PTFR                                        CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                     BUG11512
     C                   ENDIF                                                              BUG11512

     C     EMDFVAL       ENDSR                                                                CAP060
      *****************************************************************                       CAP060
      /EJECT                                                                                  CAP060
      **********************************************************************                  CAP060
      * RTVPRCS - RETRIEVE Transaction DETAILS IF ACTION CODE 'A', 'E' OR 'D'                 CAP060
      **********************************************************************                  CAP060
     C     RTVPRCS       BEGSR                                                                CAP060
                                                                                              CAP060
      ** @PTFR should be blanks if Price Type <> 'CT' or 'CV'                                BUG9725
                                                                                             BUG9725
     C                   IF        DDPPRT <> 'CT'                                            BUG9725
     C                             AND DDPPRT <> 'CV'                                        BUG9725
     C                   EVAL      @PTFR = *BLANKS                                           BUG9725
     C                   ENDIF                                                               BUG9725
                                                                                             BUG9725
      * Retrieve price from file                                                              CAP060
     C     @PRICK        CHAIN     PRICEL1                            99                      CAP060
                                                                                              CAP060
     C                   MOVE      RECI          FL_RECI                                      CAP060

      * Price details not found                                                               CAP060
     C     *IN99         IFEQ      '1'                                                        CAP060
     C                   MOVEL     'N'           OKACTN                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1130'     MsgIdArr(Ix)                                 CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C     EndRTV        ENDSR                                                                CAP060
      *****************************************************************                       CAP060
      /EJECT                                                                                  CAP060
      *****************************************************************                       CAP060
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE                             CAP060
      *****************************************************************                       CAP060
     C     VFRNT         BEGSR                                                                CAP060
     C*                                                                                       CAP060
     C* ERROR IF ACTION CODE IS NOT 'I','A','E' OR 'D'                                        CAP060
     C*                                                                                       CAP060
     C     DDACTN        IFNE      'I'                                                        CAP060
     C     DDACTN        ANDNE     'A'                                                        CAP060
     C     DDACTN        ANDNE     'E'                                                        CAP060
     C     DDACTN        ANDNE     'D'                                                        CAP060
     C                   MOVEL     'N'           OKACTN                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)                                 CAP060
     C                   ENDIF                                                                CAP060
     C*                                                                                       CAP060
     C* Error if front office transaction ID is blank                                         CAP060
     C*                                                                                       CAP060
     C     FOTRID        IFEQ      *BLANK                                                     CAP060
     C                   MOVE      'N'           OKACTN                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)                                 CAP060
     C                   GOTO      EVFRNT                                                     CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C* If CAP060 on, access Security master file                                             CAP060
     C* with front office ID, to get security shortname                                       CAP060
     C**********         IF        CAP060F= 'Y'                                        CAP060 248150
     C                   IF        CAP060F= 'Y' AND CSD006F = 'Y'                             248150
                                                                                              CAP060
     C     FOTRID        CHAIN     SECTYL5                                                    CAP060
                                                                                              CAP060
     C* MDF Id must be present on securities file, whether this is an insert or amend         CAP060
     C                   IF         NOT %FOUND(SECTYL5 )                                      CAP060
     C                   MOVE      'N'           OKACTN                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1155'     MsgIdArr(Ix)                                 CAP060
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)                                CAP060
     C                   GOTO      EVFRNT                                                     CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C                   IF         %FOUND(SECTYL5 )                                          CAP060
     C                   EVAL      DDPSSN = MDFSESN                                           CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C                   ENDIF                                                                CAP060
     C*                                                                                       CAP060
     C     EVFRNT        ENDSR                                                                CAP060
      *****************************************************************                       CAP060
      /EJECT                                                                                  CAP060
      *****************************************************************                       CAP060
      * VALACI - VALIDATION OF ACTION CODE 'I'                                                CAP060
      *****************************************************************                       CAP060
     C     VALACI        BEGSR                                                                CAP060
      *                                                                                       CAP060
      * Access Transaction from the Transactions file                                         CAP060
      *                                                                                       CAP060
     C     @PRICK        CHAIN     PRICEL1                            99                      CAP060
                                                                                              CAP060
     C                   MOVE      RECI          FL_RECI                                      CAP060
                                                                                              CAP060
      *                                                                                       CAP060
      * Error if present already                                                              CAP060
      *                                                                                       CAP060
     C     *IN99         IFEQ      '0'                                                        CAP060
     C     RECI          ANDNE     '*'                                                        CAP060
     C/COPY WNCPYSRC,SEH00120
     C                   MOVEL     'N'           OKACTN                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1129'     MsgIdArr(Ix)                                 CAP060
     C/COPY WNCPYSRC,SEH00121
     C                   ENDIF                                                                CAP060
      *                                                                                       CAP060
     C                   IF        DDPPRT <> 'V ' AND                                         CAP060
     C                             DDPPRT <> 'DT' AND                                         CAP060
     C                             DDPPRT <> 'DV' AND                                         CAP060
     C                             DDPPRT <> 'CT' AND                                         CAP060
     C                             DDPPRT <> 'CV'                                             CAP060
     C                   MOVE      'N'           OKPPRT                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPPRT'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1116'     MsgIdArr(Ix)                                 CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C* Price type 'V ' - No Customer, Market, Branch or Book entry                           CAP060
     C* allowed                                                                               CAP060
     C*                                                                                       CAP060
     C                   IF        DDPPRT ='V'                                                CAP060
     C                   IF        DDPCNM <> *BLANKS OR                                       CAP060
     C                             DDPMKT <> *BLANKS OR                                       CAP060
     C                             DDPBRA <> *BLANKS OR                                       CAP060
     C                             DDPBOK <> *BLANKS                                          CAP060
     C                   MOVE      'N'           OKPCNM                                       CAP060
     C                   MOVE      'N'           OKPMKT                                       CAP060
     C                   MOVE      'N'           OKPBRA                                       CAP060
     C                   MOVE      'N'           OKPBOK                                       CAP060
     C                   MOVE      'N'           OKPPRT                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPPRT'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1117'     MsgIdArr(Ix)                                 CAP060
     C                   ENDIF                                                                CAP060
     C                                                                                        CAP060
     C     DDPSSN        CHAIN     SECTYDF                            99                      CAP060
     C  N99RECI          COMP      'D'                                9999                    CAP060
     C     *IN99         IFEQ      '1'                                                        CAP060
     C                   MOVE      'N'           OKPSSN                                       CAP060
     C                   MOVE      'N'           OKPPRT                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPSSN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1122'     MsgIdArr(Ix)                                 CAP060
                                                                                              CAP060
     C* Else translate Market price (MKPR) on SECTYD to current price                         CAP060
                                                                                              CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVE      *BLANKS       ZFIELD                                       CAP060
     C                   MOVE      MKPR          ZFIELD                                       CAP060
     C                   Z-ADD     8             ZADEC                                        CAP060
     C                   CALLB     'ZEDIT'                                                    CAP060
     C                   PARM                    ZFIELD           16                          CAP060
     C                   PARM                    ZADEC             1 0                        CAP060
     C                   MOVE      *BLANKS       DDCURP                                       CAP060
     C                   MOVE      ZFIELD        DDCURP                                       CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C*                                                                                       CAP060
     C* Price type 'DT' or 'DV'                                                               CAP060
     C*                                                                                       CAP060
     C                   IF         DDPPRT = 'DT' OR                                          CAP060
     C                              DDPPRT = 'DV'                                             CAP060
                                                                                              CAP060
     C                   IF         DDPCNM <> *BLANKS                                         CAP060
     C* No customer entry allowed                                                             CAP060
     C*                                                                                       CAP060
     C                   MOVE      'N'           OKPPRT                                       CAP060
     C                   MOVE      'N'           OKPCNM                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPCNM'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1118'     MsgIdArr(Ix)                                 CAP060
     C                   ENDIF                                                                CAP060
     C*                                                                                       CAP060
     C* Must reference an active Book file record                                             CAP060
     C*                                                                                       CAP060
     C                   CALL      'AOBOOKR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*KEY   '     @OPTN                                        CAP060
     C                   PARM      DDPBOK        @BKEY             2                          CAP060
     C     SDBOOK        PARM      SDBOOK        DSFDY                                        CAP060
     C     @RTCD         IFNE      *BLANKS                                                    CAP060
     C                   MOVE      'N'           OKPBOK                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPBOK'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1128'     MsgIdArr(Ix)                                 CAP060
     C                   ENDIF                                                                CAP060
     C*                                                                                       CAP060
     C* Must reference an active Book position header record                                  CAP060
     C*                                                                                       CAP060
     C                   MOVE      DDPBRA        @PBRA                                        CAP060
     C                   MOVE      DDPPRT        @BASIS                                       CAP060
      *                                                                                       CAP060
      ** Convert to pseudo book                                                               CAP060
      *                                                                                       CAP060
     C                   IF        CAC005 = 'Y'                                               CAP060
     C                   CALL      'AOBKPCR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*PSEUDO'     @OPTN                                        CAP060
     C                   PARM      DDPBOK        PBOOK             2                          CAP060
     C                   PARM      DDPRFC        PPRFC             4                          CAP060
     C                   PARM                    PPSCD             2                          CAP060
                                                                                              CAP060
     C                   IF        @RTCD = *BLANKS                                            CAP060
     C                   MOVEL     PPSCD         @PBOK                                        CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVE      *BLANKS       @PBOK                                        CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C     BKPHDK        CHAIN     BKPHDDF                            99                      CAP060
     C                   IF        *IN99                                                      CAP060
     C                   MOVE      'N'           OKPSSN                                       CAP060
     C                   MOVE      'N'           OKPMKT                                       CAP060
     C                   MOVE      'N'           OKPBRA                                       CAP060
     C                   MOVE      'N'           OKPBOK                                       CAP060
     C                   MOVE      'N'           OKPPRT                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPBOK'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1119'     MsgIdArr(Ix)                                 CAP060
     C                   ELSE                                                                 CAP060
     C                   IF        RECI <> 'D'                                                CAP060
     C                   MOVE      'N'           OKPSSN                                       CAP060
     C                   MOVE      'N'           OKPMKT                                       CAP060
     C                   MOVE      'N'           OKPBRA                                       CAP060
     C                   MOVE      'N'           OKPBOK                                       CAP060
     C                   MOVE      'N'           OKPPRT                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPBOK'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1119'     MsgIdArr(Ix)                                 CAP060
     C*                                                                                       CAP060
     C* Else translate Latest average price (LAVP) from BKHPD file                            CAP060
     C* to current price                                                                      CAP060
     C*                                                                                       CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVE      *BLANKS       ZFIELD                                       CAP060
     C                   MOVE      LAVP          ZFIELD                                       CAP060
     C                   Z-ADD     8             ZADEC                                        CAP060
     C                   CALLB     'ZEDIT'                                                    CAP060
     C                   PARM                    ZFIELD           16                          CAP060
     C                   PARM                    ZADEC             1 0                        CAP060
     C                   MOVE      *BLANKS       DDCURP                                       CAP060
     C                   MOVE      ZFIELD        DDCURP                                       CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     C*                                                                                       CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C* Price type 'CT' or 'CV'                                                               CAP060
                                                                                              CAP060
     C                   IF        DDPPRT = 'CT' OR                                           CAP060
     C                             DDPPRT = 'CV'                                              CAP060
     C*                                                                                       CAP060
     C* Book entry not allowed                                                                CAP060
     C*                                                                                       CAP060
     C                   IF        DDPBOK <> *BLANKS                                          CAP060
     C                   MOVE      'N'           OKPBOK                                       CAP060
     C                   MOVE      'N'           OKPPRT                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPBOK'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1120'     MsgIdArr(Ix)                                 CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       255418
      ** Customer must be a valid SE customer                                                 255418
      *                                                                                       255418
     C                   IF        DDPCNM <> *BLANKS                                          255418
     C                   MOVEL     DDPCNM        @KEYC                                        255418
     C                   CALL      'AOSECSR0'                                                 255418
     C                   PARM      *BLANKS       @RTCD                                        255418
     C                   PARM      '*KEY   '     @OPTN                                        255418
     C                   PARM                    @KEYC            10                          255418
     C     SDSECS        PARM      SDSECS        DSSDY                                        255418
     C     @RTCD         IFNE      *BLANKS                                                    255418
     C                   MOVE      'N'           OKPCNM                                       255418
     C                   ADD       1             Ix                                           255418
     C                   MOVEL     'DDPCNM'      FldNameArr(Ix)                               255418
     C**********         MOVEL     '45045848'    MsgIdArr(Ix)                        255418 MD037408
     C                   MOVEL     '5045848'     MsgIdArr(Ix)                               MD037408
     C                   ELSE                                                                 255418
      *                                                                                       255418
      ** Securities customer must either be safe custody or discretionary customer            255418
      *                                                                                       255418
     C                   IF        BFCLAS <> 'S' AND BFCLAS <> 'D'                            255418
     C                   MOVE      'N'           OKPCNM                                       255418
     C                   ADD       1             Ix                                           255418
     C                   MOVEL     'DDPCNM'      FldNameArr(Ix)                               255418
     C**********         MOVEL     '45045849'    MsgIdArr(Ix)                        255418 MD037408
     C                   MOVEL     '5045849'     MsgIdArr(Ix)                               MD037408
     C                   ENDIF                                                                255418
     C                   ENDIF                                                                255418
     C                   ENDIF                                                                255418
                                                                                              CAP060
     C* Combination of security, customer and branch                                          CAP060
     C* must reference an active Customer position                                            CAP060
                                                                                              CAP060
     C                   IF        DDPBRA <> *BLANKS                                          CAP060
     C     CPOSNK        CHAIN     CPOSNDF                            99                      CAP060
     C                   IF        *IN99                                                      CAP060
     C                   MOVE      'N'           OKPSSN                                       CAP060
     C                   MOVE      'N'           OKPCNM                                       CAP060
     C                   MOVE      'N'           OKPMKT                                       CAP060
     C                   MOVE      'N'           OKPBRA                                       CAP060
     C                   MOVE      'N'           OKPPRT                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPSSN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1121'     MsgIdArr(Ix)                                 CAP060
     C                   ELSE                                                                 CAP060
     C                   IF        RECI <> 'D'                                                CAP060
     C                   MOVE      'N'           OKPSSN                                       CAP060
     C                   MOVE      'N'           OKPCNM                                       CAP060
     C                   MOVE      'N'           OKPMKT                                       CAP060
     C                   MOVE      'N'           OKPBRA                                       CAP060
     C                   MOVE      'N'           OKPPRT                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPSSN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1121'     MsgIdArr(Ix)                                 CAP060
                                                                                              CAP060
     C* Else translate Customer position price to Current price                               CAP060
                                                                                              CAP060
     C                   ELSE                                                                 CAP060
                                                                                              CAP060
     C* Fetch nominal security details                                                        CAP060
                                                                                              CAP060
     C     DDPSSN        CHAIN     SECTYDF                            33                      CAP060
                                                                                           AR1092524
     C     DDPMKT        IFNE      MKTI                                                    AR1092524
     C                   MOVE      'N'           OKPSSN                                    AR1092524
     C                   MOVE      'N'           OKPCNM                                    AR1092524
     C                   MOVE      'N'           OKPMKT                                    AR1092524
     C                   MOVE      'N'           OKPBRA                                    AR1092524
     C                   MOVE      'N'           OKPPRT                                    AR1092524
     C                   ADD       1             Ix                                        AR1092524
     C                   MOVEL     'DDPSSN'      FldNameArr(Ix)                            AR1092524
     C                   MOVEL     'MMA1121'     MsgIdArr(Ix)                              AR1092524
     C                   ENDIF                                                             AR1092524
                                                                                              CAP060
     C* Fetch nominal currency decimal places                                                 CAP060
                                                                                              CAP060
     C                   CALL      'AOCURRR0'                                                 CAP060
     C                   PARM      '*DBERR '     @RTCD                                        CAP060
     C                   PARM      '*KEY   '     @OPTN                                        CAP060
     C                   PARM      NMCY          @CKEY             3                          CAP060
     C     SDCURR        PARM      SDCURR        DSSDY                                        CAP060
                                                                                              CAP060
     C                   Z-ADD     *ZEROS        WK15N8           15 8                        CAP060
                                                                                              CAP060
     C     DDPPRT        IFEQ      'CT'                                                       CAP060
                                                                                              CAP060
     C     CSNT          IFNE      *ZEROS                                                     CAP060
     C     CSNT          IFLT      0                                                          CAP060
     C                   Z-SUB     CSNT          CSNT                                         CAP060
     C                   END                                                                  CAP060
     C     CSPT          DIV       CSNT          WK15N8                                       CAP060
     C                   END                                                                  CAP060
                                                                                              CAP060
     C                   ELSE                                                                 CAP060
     C     CSNV          IFNE      *ZEROS                                                     CAP060
     C     CSNV          IFLT      0                                                          CAP060
     C                   Z-SUB     CSNV          CSNV                                         CAP060
     C                   END                                                                  CAP060
     C     CSPV          DIV       CSNV          WK15N8                                       CAP060
     C     SPBS          IFEQ      'P'                                                        CAP060
     C                   MULT      100           WK15N8                                       CAP060
     C                   END                                                                  CAP060
     C                   END                                                                  CAP060
                                                                                              CAP060
     C                   END                                                                  CAP060
                                                                                              CAP060
     C     5             SUB       NMDP          DC                1 0                        CAP060
     C                   ADD       A6NBDP        DC                                           CAP060
     C                   DIV       POWER8(DC)    WK15N8                                       CAP060
     C                   MOVE      *BLANKS       ZFIELD                                       CAP060
     C                   MOVE      WK15N8        ZFIELD                                       CAP060
     C                   Z-ADD     8             ZADEC                                        CAP060
     C                   CALLB     'ZEDIT'                                                    CAP060
     C                   PARM                    ZFIELD           16                          CAP060
     C                   PARM                    ZADEC             1 0                        CAP060
     C                   MOVE      ZFIELD        DDCURP                                       CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C** Branch code and Portfolio ref. may not be entered together                           CAP060
                                                                                              CAP060
     C                   IF        DDPTFR <> *BLANKS AND                                      CAP060
     C                             DDPBRA <> *BLANKS                                          CAP060
     C                   MOVE      'N'           OKPBRA                                       CAP060
     C                   MOVE      'N'           OKPTFR                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPTFR'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1123'     MsgIdArr(Ix)                                 CAP060
     C                   END                                                                  CAP060
                                                                                              CAP060
     C*  Either Branch code or Portfolio ref. must be entered                                 CAP060
                                                                                              CAP060
     C                   IF        DDPTFR = *BLANKS AND                                       CAP060
     C                             DDPBRA = *BLANKS                                           CAP060
     C                   MOVE      'N'           OKPBRA                                       CAP060
     C                   MOVE      'N'           OKPTFR                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPTFR'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1124'     MsgIdArr(Ix)                                 CAP060
     C                   END                                                                  CAP060
                                                                                              CAP060
     C                   IF        DDPTFR <> *BLANKS AND                                      CAP060
     C                             DDPBRA = *BLANKS                                           CAP060
                                                                                              CAP060
     C* Must reference a current Portfolio position and must be greater                       CAP060
     C* than or equal to the date when the position was set up.                               CAP060
                                                                                              CAP060
     C                   IF        DDPPRT = 'CT'                                              CAP060
     C                   MOVE      'T'           WTVDA                                        CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVE      'V'           WTVDA                                        CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C** Format Portfolio Reference before chaining PMAPOSPD                                  CAP060
                                                                                              CAP060
     C                   IF         DDPTFR = FCR997 AND                                       CAP060
     C                              FCPORS <> 'B'   AND                                       CAP060
     C                              BGN4ST <> 'Y' OR                                          CAP060
     C                              FCPORS = 'B' AND                                          CAP060
     C                              DDPTFR <> *BLANKS AND                                     CAP060
     C                              DDPTFR = FCR997 AND                                       CAP060
     C                              BGN4ST <> 'Y'                                             CAP060
     C                   MOVE      '9997'        WPTFR             4                          CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVE      DDPTFR        WPTFR                                        CAP060
     C                   END                                                                  CAP060
                                                                                              CAP060
     C                   MOVE      *HIVAL        @PVDT                                        CAP060
                                                                                              CAP060
     C     POSKEY        SETGT     PMAPOSLL                                                   CAP060
     C                   READP     PMAPOSLL                               99                  CAP060
                                                                                              CAP060
     C                   IF        *IN99 OR                                                   CAP060
     C                             @PCNM <> QACNUM OR                                         CAP060
     C                             WPTFR <> QAPTFR OR                                         CAP060
     C                             DDPSSN <> QATDSS OR                                        CAP060
     C                             WTVDA <> QATVDA                                            CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'MMA1132'     MsgIdArr(Ix)                                 CAP060
     C                   MOVE      'N'           OKPSSN                                       CAP060
     C                   MOVE      'N'           OKPCNM                                       CAP060
     C                   MOVE      'N'           OKPTFR                                       CAP060
     C                   MOVEL     'DDPSSN'      FldNameArr(Ix)                               CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C** Validate portfolio reference                                                         CAP060
                                                                                              CAP060
     C                   IF        BGPFMG = 'Y' AND                                           CAP060
     C                             DDPTFR <> FCR997 AND                                       CAP060
     C                             DDPTFR <> *BLANKS OR                                       CAP060
     C                             BGN4ST = 'Y' AND                                           CAP060
     C                             DDPTFR <> *BLANKS                                          CAP060
                                                                                              CAP060
     C     PORKEY        CHAIN     PMPORTPD                           99                      CAP060
                                                                                              CAP060
     C** Must be a valid Portfolio Reference for Customer                                     CAP060
                                                                                              CAP060
     C                   IF        *IN99 OR                                                   CAP060
     C                             PNRECI = '*'                                               CAP060
     C                   MOVE      'N'           OKPTFR                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPTFR'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1125'     MsgIdArr(Ix)                                 CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C** Warning if selected Portfolio has been flagged for closure                           CAP060
                                                                                              CAP060
     C                   IF        OKPTFR = 'Y' AND                                           CAP060
     C                             DDPTFR <> WPTFR AND                                        CAP060
     C                             PNDPCL <> 0                                                CAP060
     C                   MOVE      'N'           OKPTFR                                       CAP060
     C                   ADD       1             Wx                                           CAP060
     C                   MOVEL     'DDPTFR'      WFldNamArr(Wx)                               CAP060
     C                   MOVEL     'MMA1125'     WMsgIdArr(Wx)                                CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C                   ENDIF                                                                CAP060
     C                                                                                        CAP060
                                                                                              CAP060
      **   If Book code is entered then must validate Buy- sell field                         CAP060
      **   If BYSL is 'Y' then user shall not be allowed to enter                             CAP060
      **   a book.                                                                            CAP060
      ** Access book details file SDBOOKPD via access object program                          CAP060
                                                                                              CAP060
     C     DDPBOK        IFNE      *BLANKS                                                    CAP060
     C                   CALL      'AOBOOKR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD             7                          CAP060
     C                   PARM      '*KEY   '     @OPTN             7                          CAP060
     C                   PARM      DDPBOK        @BKCD             2                          CAP060
     C     SDBOOK        PARM      SDBOOK        DSFDY                                        CAP060
      *                                                                                       CAP060
     C     BDBYSL        IFEQ      'Y'                                                        CAP060
     C                   MOVE      'N'           OKPBOK                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPBOK'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1127'     MsgIdArr(Ix)                                 CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       CAP060
     C     EVALAI        ENDSR                                                                CAP060
      *****************************************************************                       CAP060
      /EJECT                                                                                  CAP060
      *****************************************************************                       CAP060
      * VALACD - VALIDATION OF ACTION CODE 'D'                                                CAP060
      *****************************************************************                       CAP060
     C     VALACD        BEGSR                                                                CAP060
                                                                                              CAP060
      **  If Delete, RECI must be D or A                                                      CAP060
                                                                                              CAP060
     C                   IF        RECI <> 'D'  AND                                           CAP060
     C                             RECI <> 'A'                                                CAP060
     C/COPY WNCPYSRC,SEH00068
     C                   MOVE      'N'           OKACTN                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1131'     MsgIdArr(Ix)                                 CAP060
     C/COPY WNCPYSRC,SEH00069
     C                   ENDIF                                                                CAP060
     C     EVALAD        ENDSR                                                                CAP060
      *****************************************************************                       CAP060
      * VALACA - VALIDATION OF ACTION CODE 'A'                                                CAP060
      *****************************************************************                       CAP060
     C     VALACA        BEGSR                                                                CAP060
                                                                                              CAP060
     C                   IF        RECI <> 'D'                                                CAP060
     C/COPY WNCPYSRC,SEH00070
     C                   MOVE      'N'           OKACTN                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1131'     MsgIdArr(Ix)                                 CAP060
     C/COPY WNCPYSRC,SEH00071
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C                   IF        DDPPRT = 'V'                                               CAP060

     C     DDPSSN        CHAIN     SECTYDF                            99                      CAP060
     C                   IF        *IN99  OR                                                  CAP060
     C                             RECI <> 'D'                                                CAP060
     C                   MOVE      'N'           OKPSSN                                       CAP060
     C                   MOVE      'N'           OKPPRT                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPSSN'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1122'     MsgIdArr(Ix)                                 CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
      *                                                                                       CAP060
      *    If Book code is entered then must validate Buy- sell field                         CAP060
      *    If BYSL is 'Y' then user shall not be allowed to enter                             CAP060
      *    a book.                                                                            CAP060
      *  Access book details file SDBOOKPD via access object program                          CAP060
                                                                                              CAP060
     C     DDPBOK        IFNE      *BLANKS                                                    CAP060
     C                   CALL      'AOBOOKR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD             7                          CAP060
     C                   PARM      '*KEY   '     @OPTN             7                          CAP060
     C                   PARM      DDPBOK        @BKCD             2                          CAP060
     C     SDBOOK        PARM      SDBOOK        DSFDY                                        CAP060
      *                                                                                       CAP060
     C     BDBYSL        IFEQ      'Y'                                                        CAP060
     C                   MOVE      'N'           OKPBOK                                       CAP060
     C                   ADD       1             Ix                                           CAP060
     C                   MOVEL     'DDPBOK'      FldNameArr(Ix)                               CAP060
     C                   MOVEL     'MMA1127'     MsgIdArr(Ix)                                 CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     C     EVALAC        ENDSR                                                                CAP060
      *****************************************************************
      /EJECT
      *****************************************************************
      * SecChk - Validation of user's action code security.
      *****************************************************************
     C     SecChk        BEGSR
      *
      * Single branching.
      *
     C     BJSBRC        IFNE      *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ACTN              1
     C                   PARM                    @ERR              1 0
      *
      * Multibranching.
      *
     C                   ELSE
      *
      * Access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                       CAP060
     C*******************IN        ZMUSER                                                     CAP060
     C*******************UNLOCK    ZMUSER                                                     CAP060
      *                                                                                       CAP060
     C                   IF        CAP060F= 'Y'                                               CAP060
     C                   CALL      'ZVACTBU'                                                  CAP060
     C                   PARM      DDACTN        ACTN                                         CAP060
     C                   PARM                    ZBR                                          CAP060
     C                   PARM                    @ERR              1 0                        CAP060
     C                   ELSE                                                                 CAP060
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ACTN
     C                   PARM      DBRN          ZDFB              3
     C                   PARM                    @ERR              1 0
     C                   ENDIF                                                                CAP060
     C                   ENDIF
      *
      * This action code invalid for user.
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKPBRA                                       CAP060
     C*******************MOVE      'N'           OKPSSN                                       CAP060
     C*******************MOVE      'N'           OKPPRT                                       CAP060
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0704'     MsgIdArr(Ix)
     C                   ELSE                                                               MD047196
     C     @ERR          IFEQ      2                                                        MD047196
     C                   MOVE      'N'           OKACTN                                     MD047196
     C                   MOVE      'N'           OKPBRA                                     MD047196
     C                   ADD       1             Ix                                         MD047196
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             MD047196
     C                   MOVEL     'MMA0086'     MsgIdArr(Ix)                               MD047196
     C                   ENDIF                                                              MD047196
     C                   END
      *
     C     ESecChk       ENDSR
     C********************************************************************                    CAP060
     C*                                                                  *                    CAP060
     C* CHKSEL - Subroutine to check whether a ? has been entered        *                    CAP060
     C***********on*customer,*branch*or*book******************************             CAP060 214817
     C*          on security, customer, branch or book                   *                    214817
     C*                                                                  *                    CAP060
     C********************************************************************                    CAP060
     C*                                                                                       CAP060
     C     CHKSEL        BEGSR                                                                CAP060
      *                                                                                       214817
      ** Check for ? on security field and call security selection pgm.                       214817
      *                                                                                       214817
     C                   IF        DDPSSN <> *BLANKS AND CSE010 = 'Y'                         214817
     C                             AND ModeofOp <> '*FRONT'                                   214817
     C     '?'           SCAN      DDPSSN                                 01                  214817
                                                                                              214817
     C                   IF        *IN01                                                      214817
     C                   CALL      'SE0043'                                                   214817
     C                   PARM                    DDACTN                                       214817
     C                   PARM      '?'           WSECN                                        214817
                                                                                              214817
     C                   IF        WSECN <> *BLANKS                                           214817
     C                   EVAL      DDPSSN = WSECN                                             214817
     C                   ELSE                                                                 214817
     C                   EVAL      DDPSSN = *BLANKS                                           214817
     C                   ENDIF                                                                214817
     C                   ENDIF                                                                214817
     C                   ENDIF                                                                214817
                                                                                              CAP060
     C* Check for ? on branch field                                                           CAP060
     C                   MOVEL     DDPBRA        @STP              1                          CAP060
     C     @STP          IFEQ      '?'                                                        CAP060
     C**********         CALL      'AOBRCHR0'                                          CAP060 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*KEY   '     @OPTN                                        CAP060
     C                   PARM                    DDPBRA                                       CAP060
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 CAP060 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
                                                                                              CAP060
     C                   MOVE      *BLANKS       DDPBRA                                       CAP060
     C     @RTCD         IFEQ      *BLANKS                                                    CAP060
     C                   MOVEL     A8BRCD        DDPBRA                                       CAP060
     C                   END                                                                  CAP060
     C                   END                                                                  CAP060
     C* Check for ? on Customer                                                               CAP060
     C                   MOVEL     DDPCNM        @STP                                         CAP060
     C     @STP          IFEQ      '?'                                                        CAP060
     C                   CALL      'AOCUSTR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*KEY   '     @OPTN                                        CAP060
     C                   PARM                    DDPCNM                                       CAP060
     C                   PARM      *BLANKS       @KYST             7                          CAP060
     C     SDCUST        PARM      SDCUST        DSSDY                                        CAP060
                                                                                              CAP060
     C                   MOVE      *BLANKS       DDPCNM                                       CAP060
     C     @RTCD         IFEQ      *BLANKS                                                    CAP060
     C                   MOVEL     BBCUST        DDPCNM                                       CAP060
     C                   END                                                                  CAP060
     C                   END                                                                  CAP060
                                                                                              CAP060
     C* Check for ? on Book                                                                   CAP060
     C                   MOVEL     DDPBOK        @STP                                         CAP060
     C     @STP          IFEQ      '?'                                                        CAP060
     C                   CALL      'AOBOOKR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*KEY   '     @OPTN                                        CAP060
     C                   PARM                    DDPBOK                                       CAP060
     C     SDBOOK        PARM      SDBOOK        DSFDY                                        CAP060
     C                   MOVE      *BLANKS       DDPBOK                                       CAP060
     C                   SETOFF                                       26                      CAP060
     C     @RTCD         IFEQ      *BLANKS                                                    CAP060
     C                   MOVEL     BDBKCD        DDPBOK                                       CAP060
     C                   END                                                                  CAP060
     C                   END                                                                  CAP060
     C                   ENDSR                                                                CAP060
      *                                                                                       CAP060
     C*****************************************************************
     C* INIT - INITIALIZATION
     C*****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   CLEAR                   PRCSFilFmt
     C                   EVAL      PRCRSK = *ZERO                                             CAS006
     C                   EVAL      PRLQPR = *ZERO                                             CAS006
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKPSSN
     C                   MOVEL     'Y'           OKPPRT
     C                   MOVEL     'Y'           OKPCNM                                       CAP060
     C                   MOVEL     'Y'           OKPMKT                                       CAP060
     C                   MOVEL     'Y'           OKPBRA                                       CAP060
     C                   MOVEL     'Y'           OKPBOK                                       CAP060
     C                   MOVEL     'Y'           OKPPRT                                       CAP060
     C                   MOVEL     'Y'           OKPTFR                                       CAP060
     C                   MOVEL     'Y'           OKPPRT                                       CAP060
     C                   MOVEL     'Y'           OKPRFC                                       CAP060
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    RespMode          1
      *                                                                                       CAP060
      * Front Office Id                                                                       CAP060
     C                   PARM                    FOTRID           20                          CAP060
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Security
     C                   PARM                    DDPSSN           10
      *
      * Customer Shortname                                                                    CAP060
     C                   PARM                    DDPCNM           10                          CAP060
      *                                                                                       CAP060
      * Market                                                                                CAP060
     C                   PARM                    DDPMKT            1                          CAP060
      *                                                                                       CAP060
      * Branch                                                                                CAP060
     C                   PARM                    DDPBRA            3                          CAP060
      *                                                                                       CAP060
      * Book                                                                                  CAP060
     C                   PARM                    DDPBOK            2                          CAP060
      *                                                                                       CAP060
      * Profit Centre                                                                         CAP060
     C                   PARM                    DDPRFC            4                          CAP060
      *
      * Price Type
     C                   PARM                    DDPPRT            2
      *
      * Portfolio Reference                                                                   CAP060
     C                   PARM                    DDPTFR            4                          CAP060
      * ICD
      * Extel Indicator
     C                   PARM                    BVEXOP            1                          CAP060

      * OUTPUTS
      *
      **(Current)*forward*rates*in*file*format                                                CAP060
      * (Current) securities prices in file format                                            CAP060
     C                   PARM                    PRCSFilFmt
      * If CAC005 is on, this is the book code the user entered on the screen                 CAP060
     C                   PARM                    PBCD              2                          CAP060
      * If CAC005 is on, this is the pseudo book                                              CAP060
      * If CAC005 is off, this is the book the user entered on the screen                     CAP060
     C                   PARM                    @PBOK             2                          CAP060
      * profit centre, in file format                                                         CAP060
     C                   PARM                    PRFC              4                          CAP060
      * Customer number in file format                                                        CAP060
     C                   PARM                    @PCNM                                        CAP060
      * Current Price retrieved, depending on price type                                      CAP060
     C                   PARM                    DDCURP           16                          CAP060
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Security
     C                   PARM                    OKPSSN            1
      *
      * OK - Customer Shortname                                                               CAP060
     C                   PARM                    OKPCNM            1                          CAP060
      *                                                                                       CAP060
      * OK - Market                                                                           CAP060
     C                   PARM                    OKPMKT            1                          CAP060
      *                                                                                       CAP060
      * OK - Branch                                                                           CAP060
     C                   PARM                    OKPBRA            1                          CAP060
      *                                                                                       CAP060
      * OK - Book                                                                             CAP060
     C                   PARM                    OKPBOK            1                          CAP060
      *                                                                                       CAP060
      * OK - Profit Centre                                                                    CAP060
     C                   PARM                    OKPRFC            1                          CAP060
      *
      * OK - Price Type
     C                   PARM                    OKPPRT            1
      *                                                                                       CAP060
      * OK - Portfolio Reference                                                              CAP060
     C                   PARM                    OKPTFR            1                          CAP060
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *                                                                                       CAP060
      ** Warnings                                                                             CAP060
      *                                                                                       CAP060
     C                   PARM                    WFldNamArr                                   CAP060
     C                   PARM                    WMsgIdArr                                    CAP060
     C                   PARM                    WMsgDtaArr                                   CAP060
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      * Warning array index (3P0) from/to caller                                              CAP060
     C                   PARM                    WX                                           CAP060
     C                   PARM      FCR997        @CR997            4                          CAP060
     C/COPY WNCPYSRC,SEH00072
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEPRCSRTV'   DBPGM
      *
      * Key Lists
      *
     C     @PRICK        KLIST
     C                   KFLD                    @PSSN            10
     C*******************KFLD                    @PCNM             6 0                        CAP060
     C                   KFLD                    @PCNM                                        CAP060
     C                   KFLD                    @PMKT             1
     C                   KFLD                    @PBRA             3
     C                   KFLD                    @PBOK             2
     C                   KFLD                    @PPRT             2
     C                   KFLD                    @PTFR             4

     C     BKPHDK        KLIST                                                                CAP060
     C                   KFLD                    DDPSSN                                       CAP060
     C                   KFLD                    @PBRA                                        CAP060
     C                   KFLD                    @PBOK                                        CAP060
     C                   KFLD                    DDPMKT                                       CAP060
     C                   KFLD                    @BASIS            1                          CAP060
                                                                                              CAP060
     C     CPOSNK        KLIST                                                                CAP060
     C                   KFLD                    @PBRA                                        CAP060
     C                   KFLD                    DDPSSN                                       CAP060
     C                   KFLD                    @PCNM                                        CAP060
     C*                                                                                       CAP060
     C     PORKEY        KLIST                                                                CAP060
     C                   KFLD                    @PCNM                                        CAP060
     C                   KFLD                    DDPTFR                                       CAP060
     C*                                                                                       CAP060
     C     POSKEY        KLIST                                                                CAP060
     C                   KFLD                    @PCNM                                        CAP060
     C                   KFLD                    WPTFR                                        CAP060
     C                   KFLD                    DDPSSN                                       CAP060
     C                   KFLD                    WTVDA             1                          CAP060
     C                   KFLD                    @PVDT             5 0                        CAP060

      ** ACCESS BANK DETAILS
      *  (database error handling done in access program)
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** ACCESS MIDAS MODULE DETAILS
      *  (database error handling done in access program)
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     BGPFMG        IFEQ      'Y'                                                        CAP060
     C                   CALL      'AOPORTR0'                                                 CAP060
     C                   PARM      *BLANKS       P@RTCD            7                          CAP060
     C                   PARM      '*FIRST '     P@OPTN            7                          CAP060
     C     SDPORT        PARM      SDPORT        DSFDY                                        CAP060
     C                   ENDIF                                                                CAP060

      ***  Check if CAC005 is on                                                              CAP060
      *                                                                                       CAP060
     C                   CALL      'AOSARDR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*VERIFY'     @OPTN                                        CAP060
     C                   PARM      'CAC005'      @SARD             6                          CAP060
      *                                                                                       CAP060
     C     @RTCD         IFEQ      *BLANKS                                                    CAP060
     C                   MOVE      'Y'           CAC005                                       CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVE      'N'           CAC005                                       CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       CAP060
     C                   CALL      'AOSARDR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*VERIFY'     @OPTN                                        CAP060
     C                   PARM      'CAP060'      @SARD             6                          CAP060
      *                                                                                       CAP060
     C     @RTCD         IFEQ      *BLANKS                                                    CAP060
     C                   MOVE      'Y'           CAP060F                                      CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVE      'N'           CAP060F                                      CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       214817
     C                   CALL      'AOSARDR0'                                                 214817
     C                   PARM      *BLANKS       @RTCD                                        214817
     C                   PARM      '*VERIFY'     @OPTN                                        214817
     C                   PARM      'CSE010'      @SARD             6                          214817
      *                                                                                       214817
     C     @RTCD         IFEQ      *BLANKS                                                    214817
     C                   MOVE      'Y'           CSE010                                       214817
     C                   ELSE                                                                 214817
     C                   MOVE      'N'           CSE010                                       214817
     C                   ENDIF                                                                214817
                                                                                              214817
     C                   CALL      'AOSARDR0'                                                 205873
     C                   PARM      *BLANKS       @RTCD                                        205873
     C                   PARM      '*VERIFY'     @OPTN                                        205873
     C                   PARM      'CSD006'      @SARD             6                          205873
      *                                                                                       205873
     C     @RTCD         IFEQ      *BLANKS                                                    205873
     C                   MOVE      'Y'           CSD006F                                      205873
     C                   ELSE                                                                 205873
     C                   MOVE      'N'           CSD006F                                      205873
     C                   ENDIF                                                                205873
                                                                                              CAP060
     C******DTAARA       DEFINE                  ZMUSER                               CAP060 BUG8550
     C**********         IN        ZMUSER                                             CAP060 BUG8550
     C**********         UNLOCK    ZMUSER                                             CAP060 BUG8550
     C/COPY WNCPYSRC,SEH00073
                                                                                              CAP060
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate extension file details (SWIFT)')     *
/*XBI *  OVRDBF FILE(TRADSDZ3) TOFILE(TRADSDY2) SHARE(*NO)            *                       201429
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SETRADEVAL - Validate SWIFT Details screen.                  *
      *               (Trades Extension Details)                      *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             SWIFT Details associated with an SE trade.        *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the validation    *
      *  routine for the said fields. This routine has been retrieved *
      *  from SE1805 and has been converted to ILE RPG and copied     *
      *  into this member.  Necessary code to make this compileable   *
      *  has been added (entry and exit points and some declares).    *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
      *                                                               *
      *  Component of: SE1805 - Trade Extensions maintenance          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR596191           Date 19Aug14               *
      *                 AR573194           Date 09Jul10               *
      *                 AR892580           Date 02Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR639840           Date 09Sep10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14806           Date 10Sep07               *
      *                 CPK027             Date 17Apr07               *
      *                 245823             Date 20Feb07               *
      *                 229443             Date 19Oct04               *
      *                 BUG13112           Date 24Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 225421  (BUG1356)  Date 03Mar04               *
      *                 CSE039             Date 04Apr03               *
      *                 CAS006             Date 21Jan03               *
      *                 213187             Date 07Feb03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210517             Date 21Nov02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208195             Date 12Aug02               *
      *                 184406             Date 21Mar02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201429             Date 14Jan02               *
      *                 201233             Date 20Dec01               *
      *                 198308             Date 28Nov01               *
      *                 199797             Date 01Nov01               *
      *                 195592             Date 16Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      *                 CSW201             Date 02May01               *
      *                 195716             Date 18Jul01               *
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 175217             Date 12Sep00               *
      *                 175216             Date 12Sep00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 16Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 09Sep98               *
      *                 CAP003 *CREATE     Date 02Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR596191 - Error on Safekeeping Account is issued even if    *
      *             a valid value is inserted                         *
      *  AR573194 - TRDN screen does not continue on deal cannot be   *
      *           saved.                                              *
      *  AR892580 - Warnings and Error Descriptions were not          *
      *             available in BYSL                                 *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR639840 - Safekeeping Account is being blanked-out          *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  BUG14806 - Safekeeping Account is Mandatory                  *
      *  CPK027 - Errors in compiling MP1_3_TTTS - TCNR now 6A.       *
      *  245823 - Apply part of existing fix 229443 from M4.01.02.    *
      *           Second part, fix 223804, is already in SETSWFTDFT.  *
      *  229443 - Default Confirmation and Settlement Message Request *
      *           to 'N' for Trades with a PB Client.                 *
      *  BUG13112 - Trades - Safekeeping acct is mandatory if         *
      *             ISO15022 IS 'Y'                                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  225421 - Validation of non-ISO15022 requirement should only  *
      *           being done based on the ISO15022 indicator only.    *
      *  CSE039 - Auto-settlement of trades                           *
      *         - Recompiled due to change in SETRSEPD                *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  213187 - Message appears in extended settlement screen when  *
      *           depot and clearance type is changed. Fix is to blank*
      *           out unnecessary fields.                             *
      *  210517 - Missing TRADSDX2 record from the API                *
      *  208195 - Database Error occured when client number is blank. *
      *  184406 - Counterparty Euroclear/Cedel code is not accepted.  *
      *           Amended SR/SREUCL to accept codes starting with a   *
      *           letter followed by numeric characters when the first*
      *           position is '/'. Also accept euroclear/cedel codes  *
      *           starting with '//XE' or '//XC' followed by '9' plus *
      *           set of alphabetic letters and numeric characters.   *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  201429 - New validation needed for ISO15022 in               *
      *           extended settlement screen.                         *
      *  201233 - If message is unroutable, settlement of message     *
      *           request cannot be a 'Y'.                            *
      *  198308 - DBERR when inserting a new Trade.  Need to          *
      *           initialise Idx.                                     *
      *  199797 - Additional changes and fixes for CSE028 (SSIs).     *
      *  195592 - Remove invalid core fix 175217.                     *
      *  CSE028 - Standing Settlement Instructions Enhancement        *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  195716 - Standing Instructions Override is taken as blank    *
      *           even if a 'Y' or an 'N' was typed in on the         *
      *           previous screen (Screen A).  The problem is at      *
      *           Screen B.                                           *
      *  CSE022 - Depository Definition Enhancement                   *
      *  175217 - Validate settlement message requests to see that    *
      *           if 'Y' points to valid customer.                    *
      *  175216 - Add additional field for "Standing Instructions     *
      *           Override" missed at SWIFT 98 change.                *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *           Recompiled due to database changes                  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMGECONL0  IF   E           K DISK
     FTRADSDZ3  IF   E           K DISK                                                       201429
     FSDCUSTL1  IF   E           K DISK                                                       229443
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRDEV033
 
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
 
 
      ** Trade Primary Details in screen format
     D TrPrim        E DS                  EXTNAME(SETRPRPD)
     D TR1_CLTY      E                     EXTFLD(DDCLTY)
      ** Trade Secondary Details in screen format
     D TrSeco        E DS                  EXTNAME(SETRSEPD)
      ** Trade Exchange Rates in screen format
     D TrExch        E DS                  EXTNAME(SETREXPD)
      ** Trade Settlement Instructions in screen format
     D TrSett        E DS                  EXTNAME(SETRSTPD)
      ** Trade Extension File details (SWIFT) in screen format
     D TrSwft        E DS                  EXTNAME(SETRSWPD)
 
 
      ** Flags to indicate whether SWIFT fields are OK
     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
 
 
      * Valid Trade layout
     D ValidTrad     E DS                  EXTNAME(SEVTRADPD)
 
      * File Fields for Securities SWIFT (Extension) screen.
     D ValidTrX1     E DS                  EXTNAME(SEVTRX1PD)
 
      ** TRADSDX2 record                                                                      210517
     D PTradeX2      E DS                  EXTNAME(TRADSDX2)                                  210517
     D                                     PREFIX(X2:2)                                       210517
 
      ** Security Customer Details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      ** Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Second Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
 
     D MGFUN           S              1    DIM(50)
      ** Array used to check Fungibility Codes
 
     D                 DS
      ** Data Structure to set up field for chain to SDCUSTPD
     D**CustNum*               1      6  0                                                    CSD027
     D  CustNum                1      6A                                                      CSD027
     D  CustAlp                1      6
 
     D VA0             S              1    DIM(10) CTDATA PERRCD(10)
     D VA01            S              1    DIM(26) CTDATA PERRCD(26)                          184406
      ** Array used in EUCL validations
     D VA1             S              3    DIM(10) CTDATA PERRCD(10)
      ** Array for Instructions type validation (alphabetic)
     D VA2             S              3    DIM(30) CTDATA PERRCD(10)
      ** Array for Cedel codes validation (numeric)
     D VA3             S              3    DIM(20) CTDATA PERRCD(10)
      ** Array for Euroclear codes validation (numeric)
     D VA4             S              8    DIM(9) CTDATA PERRCD(1)
      ** Array for valid Further Identification fields
 
 
     D EU1             S              1    DIM(6)
      ** Array used to split SEUCL into individual characters
 
     D                 DS
      ** Euroclear/Cedel code validation
     D  DDEUCL_X               1     10
     D  DDEUCL11               1      1
     D  DDEUCL14               1      4
     D  DDEUCL33               3      3
     D  DDEUCL27               2      7
     D  DDEUCL59               5      9
     D  DDEUCL510              5     10
      *
     D                 DS
      ** Safekeeping Account
     D  DDSAFA_X               1      6
     D  DDSAFA26               2      6
 
     D                 DS
      ** KMGECO data structure
     D  W_GECO                 1     20
     D  W_DEST                 1      5
     D  W_INST                 6     12
     D  W_INSS                13     20
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(SETDEXPD)                    CAP004
      * SE Trades Extra Data - File (D/B) format                                CAP004
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
     D Ix              S              3P 0                                                  AR596191
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
     D CSE028          S              1A                                                      CSE028
                                                                                              CSW202
     D CSW202          S              1A                                                      CSW202
     D PRtCd           S              7A                                                      CSW202
     D ValSafe         S              1A                                                    AR573194
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SETRDEV034
 
      *******************************************************************
      /EJECT
      *******************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *******************************************************************
      *
      /COPY WNCPYSRC,SETRDEV001
 
      ** INITIAL PROCESSING
     C                   EXSR      INIT
      /COPY WNCPYSRC,SETRDEV002
      *
      ** Validate Settlement message request
      /COPY WNCPYSRC,SETRDEV003
     C                   EXSR      SRGMES
                                                                                              CSE028
     ** Validate ISO15022 Message                                                             CSE028
                                                                                              CSE028
     C                   IF        CSE028 = 'Y'                                               CSE028
     C                             AND CSW202 = 'N'                                           CSW202
     C                             OR ( DDSNEW = 'Y' AND DDGMES = 'Y')                        225421
     C                   EXSR      SRSNEW                                                     CSE028
     C                   ENDIF                                                                CSE028
                                                                                              CSE028
      /COPY WNCPYSRC,SETRDEV004
      *
      ** Validate Time of trade
      /COPY WNCPYSRC,SETRDEV005
     C                   EXSR      SRTRTT
      *                                                                                       201429
      ** Validate safekeeping account.                                                        201429
      *                                                                                       201429
     C**********         IF        Screen = 'A' AND DDCLTY <> '5' OR                 201429 AR573194
     C                   IF        Screen = 'A' AND DDCLTY = '5' OR                         AR573194
     C                             Screen = 'B' AND DDTDTP = 'TP' AND                         201429
     C**********                   (DELF_CLAS = 'E' OR DELF_CLAS = 'C') OR           201429 AR573194
     C                             ((DELF_CLAS = 'E' AND DDCLTY = '4') OR                   AR573194
     C                              (DELF_CLAS = 'E' AND DDCLTY = '5') OR                   AR573194
     C                              (DELF_CLAS = 'C' AND DDCLTY = '2') OR                   AR573194
     C                              (DELF_CLAS = 'C' AND DDCLTY = '5')) OR                  AR573194
     C                             Screen = 'B' AND DDTDTP = 'TS' AND                         201429
     C**********                   (DELF_CLAS = 'E' OR DELF_CLAS = 'C')              201429 AR573194
     C                             ((DELF_CLAS = 'E' AND DDCLTY = '4') OR                   AR573194
     C                              (DELF_CLAS = 'E' AND DDCLTY = '5') OR                   AR573194
     C                              (DELF_CLAS = 'C' AND DDCLTY = '2') OR                   AR573194
     C                              (DELF_CLAS = 'C' AND DDCLTY = '5'))                     AR573194
     C                   EVAL      ValSAFE = 'N'                                            AR573194
     C                   ELSE                                                               AR573194
     C                   EVAL      ValSAFE = 'Y'                                            AR573194
     C                   ENDIF                                                              AR573194
      *                                                                                       201429
     C                   IF        ValSAFE = 'Y'                                            AR573194
     C                   IF        DDSNEW = 'Y' AND DDGMES = 'Y'                              201429
     C***********                  AND CSE028 = 'Y' AND PUYAT <> 'N'                   201429 225421
     C                             AND PUYAT <> 'N'                                           225421
      *                                                                                       201429
      ** Retrieve X2 file to check if safekeeping account                                     201429
      ** has been entered.                                                                    201429
      *                                                                                       201429
     C                   IF        PTradeX2 = *Blanks                                         210517
     C     KEY001        CHAIN     TRADSDD2                           01                      201429
     C                   IF        NOT(*IN01)                                                 201429
     C                   MOVE      T2SKAL        P2SAFA           35                          201429
     C                   ELSE                                                                 201429
     C                   MOVE      *BLANKS       P2SAFA                                       201429
     C                   ENDIF                                                                201429
     C                   ELSE                                                                 210517
     C**********         EVAL      P2SAFA = X2SKAL                                   210517 BUG13112
     C**********         EVAL      P2SAFA = X2SKAN                                 BUG13112 BUG14806
     C                   IF        X2SKAN = *BLANKS                                         BUG14806
     C                   EVAL      P2SAFA = X2SKAL                                          BUG14806
     C                   ELSE                                                               BUG14806
     C                   EVAL      P2SAFA = X2SKAN                                          BUG14806
     C                   ENDIF                                                              BUG14806
     C                   ENDIF                                                                210517
      *                                                                                       201429
     C                   IF        DDSAFA = *BLANKS AND                                       201429
     C                             P2SAFA = *BLANKS                                           201429
     C                   Z-ADD     1             Ix                                         AR596191
     C     'SEW9004'     LOOKUP    MsgIDArr(Ix)                           99                AR596191
     C     *IN99         IFEQ      '0'                                                      AR596191
     C                   ADD       1             Idx                                          201429
     C**********         EVAL      FldNameArr(Idx) = 'DDSAFA'                        201429 AR639840
     C**********         EVAL      FldNameArr(Idx) = 'ESSKAL'                      AR639840 AR892580
     C                   SELECT                                                             AR892580
     C                   WHEN      Screen = 'A'                                             AR892580
     C                   EVAL      FldNameArr(Idx) = 'AESSKAL'                              AR892580
     C                   WHEN      Screen = 'B'                                             AR892580
     C                   EVAL      FldNameArr(Idx) = 'BESSKAL'                              AR892580
     C                   ENDSL                                                              AR892580
     C                   EVAL      MsgIDArr(Idx) = 'SEW9004'                                  201429
     C                   ENDIF                                                              AR596191
     C                   MOVE      'N'           DDSAFAOK                                     201429
     C                   ENDIF                                                                201429
      *                                                                                       201429
     C                   IF        DDSAFA <> *BLANKS AND                                      201429
     C                             P2SAFA <> *BLANKS                                          201429
     C                   Z-ADD     1             Ix                                         AR596191
     C     'SEW9007'     LOOKUP    MsgIDArr(Ix)                           99                AR596191
     C     *IN99         IFEQ      '0'                                                      AR596191
     C                   ADD       1             Idx                                          201429
     C                   EVAL      FldNameArr(Idx) = 'DDSAFA'                                 201429
     C                   EVAL      MsgIDArr(Idx) = 'SEW9007'                                  201429
     C                   ENDIF                                                              AR596191
     C                   MOVE      'N'           DDSAFAOK                                     201429
     C                   ENDIF                                                                201429
      *                                                                                       201429
     C                   ENDIF                                                                201429
     C                   ENDIF                                                                201429
      *                                                                                       201429
      /COPY WNCPYSRC,SETRDEV006
     C**********         IF        DDSNEW <> 'Y' or CSE028 = 'N'                       199797 225421
     C                   IF        DDSNEW <> 'Y' AND DDGMES = 'Y'                             225421
      *
      ** Validate Instructions type
      /COPY WNCPYSRC,SETRDEV007
     C                   EXSR      SRINST
      /COPY WNCPYSRC,SETRDEV008
      *
      ** Validate Instructions sub-type
      /COPY WNCPYSRC,SETRDEV009
     C                   EXSR      SRINSS
      /COPY WNCPYSRC,SETRDEV010
      *
      ** Validate Euroclear/Cedel code
      /COPY WNCPYSRC,SETRDEV011
     C                   EXSR      SREUCL
      /COPY WNCPYSRC,SETRDEV012
      *
      ** Validate Safekeeping Account
      /COPY WNCPYSRC,SETRDEV013
     C                   EXSR      SRSAFA
      /COPY WNCPYSRC,SETRDEV014
      *
      ** Validate Requested priority
      /COPY WNCPYSRC,SETRDEV015
     C                   EXSR      SRRPTY
      /COPY WNCPYSRC,SETRDEV016
      *
      ** Validate Guaranteed delivery
      /COPY WNCPYSRC,SETRDEV017
     C                   EXSR      SRGDEL
      /COPY WNCPYSRC,SETRDEV018
      *
      ** Validate Sender's role
      /COPY WNCPYSRC,SETRDEV019
     C                   EXSR      SRSROL
      /COPY WNCPYSRC,SETRDEV020
     C                   ENDIF                                                                199797
      *
      ** Validate Fungibility Code
      /COPY WNCPYSRC,SETRDEV021
     C                   EXSR      SRFCOD
      /COPY WNCPYSRC,SETRDEV022
      *
      ** Validate Fungible trade indicator
      /COPY WNCPYSRC,SETRDEV023
     C                   EXSR      SRFTID
      /COPY WNCPYSRC,SETRDEV024
      *
      ** Process these validations only for Screen A as they are                              195716
      ** blanks during the processing for Screen B                                            195716
     C     Screen        IFEQ      'A'                                                        195716
      *                                                                                       195716
      ** Validate confirmation message request
      /COPY WNCPYSRC,SETRDEV025
     C                   EXSR      SRGMEC
      /COPY WNCPYSRC,SETRDEV026
      *
      ** Validate Customer/Counterparty ind.
      /COPY WNCPYSRC,SETRDEV027
     C                   EXSR      SRCCID
      /COPY WNCPYSRC,SETRDEV028
      *
      ** Validate Further identification
      /COPY WNCPYSRC,SETRDEV029
     C*************      IF        DDSNEW <> 'Y' or CSE028 = 'N'                        199797225421
     C                   IF        DDSNEW <> 'Y' AND DDGMES = 'Y'                             225421
     C                   EXSR      SRFID1
     C                   ENDIF                                                                199797
      /COPY WNCPYSRC,SETRDEV030
      ** Validate Standing Instructions Override                                175216
     C                   EXSR      SRIORA                                       175216
      *
     C                   ENDIF                                                                195716
      *                                                                                       195716
      ** Update File fields with validated values
      *
      /COPY WNCPYSRC,SETRDEV031
     C     Idx           IFEQ      0
     C                   EXSR      UPDFIL
     C                   ENDIF
      /COPY WNCPYSRC,SETRDEV032
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SETRDEV035
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGMES - Validate Settlement Message Request.                *
      *                                                               *
      *****************************************************************
     C     SRGMES        BEGSR
      *
      ** Default to 'N' if PB customer                                                        229443
      *                                                                                       229443
     C                   IF        DDACTN = 'I'                                               229443
     C**********         Z-ADD     TCNR          CustNum                               229443 CPK027
     C                   MOVE      TCNR          CustNum                                      CPK027
     C     CustAlp       CHAIN(N)  SDCUSTL1                           85                      229443
     C                   IF        BBPRBA = 'Y' and *IN85 = *OFF                              229443
     C                   EVAL      DDGMES = 'N'                                               229443
     C                   ENDIF                                                                229443
     C                   ENDIF                                                                229443
      *                                                                                       229443
      ** Assumed to be 'Y' when left blank
      ** unless Trade is in the Grey Market.
      ** And unless Destinatination of Settlement is 'UNROUTABLE'.                            201233
      *
     C     DDGMES        IFEQ      *BLANK
     C*****TDMI          IFNE      'G'                                                        201233
     C                   IF        TDMI <> 'G' AND                                            201233
     C                             DDROTS <> '  UNROUTABLE'                                   201233
     C                   MOVEL     'Y'           DDGMES
     C                   ELSE
     C                   MOVE      'N'           DDGMES
     C                   ENDIF
     C                   END
      *
      ** If DDGMES is not 'Y' or 'N'
      *
     C     DDGMES        IFNE      'Y'
     C     DDGMES        ANDNE     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDGMES'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5101'
     C                   MOVE      'N'           DDGMESOK
     C                   END
      *
      ***  If Settlement Message Request is 'Y', Trade may not be in
      ***  the Grey Market.
      *
     C     DDGMES        IFEQ      'Y'
     C     TDMI          ANDEQ     'G'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDGMES'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5292'
     C                   MOVE      'N'           DDGMESOK
     C                   ENDIF
      *                                                                                       201233
      ** If Destination of Settlement is 'UNROUTABLE', then Settlement                        201233
      ** Message Request cannot be 'Y'.                                                       201233
      *                                                                                       201233
     C                   IF        DDGMES = 'Y' AND                                           201233
     C                             DDROTS = '  UNROUTABLE'                                    201233
     C                   ADD       1             Idx                                          201233
     C                   EVAL      FldNameArr(Idx) = 'DDGMES'                                 201233
     C                   EVAL      MsgIDArr(Idx) = 'SEW9001'                                  201233
     C                   MOVE      'N'           DDGMESOK                                     201233
     C                   ENDIF                                                                201233
      *                                                                                       CSE028
      ** The codings below introduced by fix 175217 is no longer valid                        CSE028
      ** is CSE028 is installed. Bypass coding when CSE028 is present.                        CSE028
      ** The code below has now been removed altogether as it is in error                     195592
      **                                                                                      195592
     C**********         IF        CSE028 = 'N'                                        CSE028 195592
      **********                                                                              195592
      **********                                                                       175217 195592
      ****If*DDGMES is 'Y' then check that the counterparty has a STTX                 175217 195592
      ****or*SWIFT ADDRESS or TELEX ADDRESS.                                           175217 195592
      **********                                                                       175217 195592
     C*****DDGMES        IFEQ      'Y'                                                 175217 195592
     C**********         Z-ADD     TCNR          CustNum                               175217 195592
     C**********         CALL      'AOCUSTR0'                                          175217 195592
     C**********         PARM      *BLANKS       @RTCD                                 175217 195592
     C**********         PARM      '*KEY   '     @OPTN                                 175217 195592
     C**********         PARM      CustAlp       @KEY1            10                   175217 195592
     C**********         PARM                    @KYST             7                   175217 195592
     C*****SDCUST        PARM      SDCUST        DSSDY                                 175217 195592
      **********                                                                       175217 195592
     C*****BBCSID        IFEQ      *BLANKS                                             175217 195592
     C*****BBSTAD        ANDEQ     *BLANKS                                             175217 195592
     C*****BBTXA1        ANDEQ     *BLANKS                                             175217 195592
     C**********         ADD       1             Idx                                   175217 195592
     C**********         EVAL      FldNameArr(Idx) = 'DDGMES'                          175217 195592
     C**********         EVAL      MsgIDArr(Idx) =  'SEW5178'                          175217 195592
     C**********         MOVE      'N'           DDGMESOK                              175217 195592
     C**********         ENDIF                                                         175217 195592
     C**********         ENDIF                                                         175217 195592
      **********                                                                       175217 195592
     C**********         ENDIF                                                         CSE028 195592
      *                                                                                       CSE028
      **  If settlement message request was previously 'Y' then issue
      **  a warning message if the user changes this value. The message
      **  will inform the user that outstanding settlements exist for
      **  this trade.
      *
     C     DDACTN        IFEQ      'A'
     C     P@_DDGMES     ANDEQ     'Y'
     C     DDACTN        OREQ      'C'
     C     P@_DDGMES     ANDEQ     'Y'
      *
     C     P@_DDGMES     IFNE      DDGMES
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDGMES'
     C                   EVAL      WMsgIDArr(WIdx) = 'SEW5853'
     C                   MOVE      'W'           DDGMESOK
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                       CSE028
      /EJECT                                                                                  CSE028
      *****************************************************************                       CSE028
      *                                                               *                       CSE028
      *  SRSNEW - Validate ISO15022 Message                           *                       CSE028
      *                                                               *                       CSE028
      *****************************************************************                       CSE028
                                                                                              CSE028
     C     SRSNEW        BEGSR                                                                CSE028
                                                                                              CSE028
     C                   IF        DDSNEW = *BLANK and DDACTN = 'I'                           CSE028
     C                   EVAL      DDSNEW = 'Y'                                               CSE028
     C                   ENDIF                                                                CSE028
                                                                                              CSE028
     C                   IF        DDSNEW = 'Y' or DDSNEW = 'N'                               199797
     C                             or DDSNEW = *BLANK                                         199797
                                                                                              199797
     C                   IF        DDACTN = 'A'                                               CSE028
                                                                                              CSE028
     C**********         TESTB     '0'           TMSI                 01               CSE028 201429
                                                                                              CSE028
     C**********         IF        *IN01 = '1' or T1RCDG = 'Y'                         CSE028 201429
                                                                                              CSE028
      ** ISO15022 Message indicator may not be amended once SWIFT messages has been generated CSE028
                                                                                              CSE028
     C                   IF        DDSNEW <> T1NEW                                            CSE028
     C                             AND DDGMES = 'Y' AND T1LSWS > 1                            201429
     C                   ADD       1             Idx                                          CSE028
     C                   EVAL      FldNameArr(Idx) = 'DDSNEW'                                 CSE028
     C                   EVAL      MsgIDArr(Idx) = 'SE10037'                                  CSE028
     C                   MOVE      'N'           DDSNEWOK                                     CSE028
     C                   ENDIF                                                                CSE028
                                                                                              CSE028
      *                                                                                       201429
      ** If Amend and ISO15022 is blanked out and no swift message generated yet              201429
      ** then default value to 'N'                                                            201429
      *                                                                                       201429
     C                   IF        DDSNEW = *BLANK AND T1LSWS <= 1                            201429
     C                   MOVE      'N'           DDSNEW                                       201429
     C                   ENDIF                                                                CSE028
                                                                                              CSE028
     C                   ENDIF                                                                CSE028
                                                                                              CSE028
     C**********         IF        DDSNEW <> 'Y' and DDSNEW <> 'N'                     CSE028 199797
     C**********                   and DDSNEW <> *BLANK                                CSE028 199797
                                                                                              199797
     C                   ELSE                                                                 199797
                                                                                              199797
     C                   ADD       1             Idx                                          CSE028
     C                   EVAL      FldNameArr(Idx) = 'DDSNEW'                                 CSE028
     C                   EVAL      MsgIDArr(Idx) = 'SE10030'                                  CSE028
     C                   MOVE      'N'           DDSNEWOK                                     CSE028
     C                   ENDIF                                                                CSE028
                                                                                              CSE028
     C                   ENDSR                                                                CSE028
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRTT - Validate Time of Trade Field (STRTT).               *
      *                                                               *
      *****************************************************************
     C     SRTRTT        BEGSR
      *
      ** TIME is mandatory for Bonds and ISMA/IPMA
      *
     C     DDTRTT        IFEQ      *BLANKS
     C     PROT          ANDEQ     '1'
     C     DDAIIP        ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTRTT'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5145'
     C                   MOVE      'N'           DDTRTTOK
     C                   END
      *
      ** TIME is mandatory for instructions sent to Cedel
      *
     C     DDTRTT        IFEQ      *BLANKS
     C     W_DEST        ANDEQ     'CEDEL'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTRTT'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5146'
     C                   MOVE      'N'           DDTRTTOK
     C                   END
      *
      ** Check time is valid
      *
     C     DDTRTT        IFNE      *BLANKS
 
     C                   TESTN                   DDTRTT               98
     C                   MOVE      DDTRTT        @@TEST            1
     C                   TESTZ                   @@TEST                   99
 
     C     *IN98         IFEQ      '0'
     C     *IN99         OREQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTRTT'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5147'
     C                   MOVE      'N'           DDTRTTOK
 
     C                   ELSE
 
     C                   MOVEL     DDTRTT        W_NUM5            5 0
     C                   MOVEL     W_NUM5        W_ALP4            4
     C                   MOVEL     DDTRTT        W_HOUR            2 0
     C                   MOVE      DDTRTT        W_MINS            2 0
     C     DDTRTT        IFNE      W_ALP4
     C     W_HOUR        ORGT      23
     C     W_HOUR        ORLT      0
     C     W_MINS        ORGT      59
     C     W_MINS        ORLT      0
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTRTT'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5147'
     C                   MOVE      'N'           DDTRTTOK
     C                   END
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINST - Validate Instructions Type (SINST).                 *
      *                                                               *
     C*****************************************************************
     C     SRINST        BEGSR
      *
      ** Check the following for MT580 only
      *
     C     W_DEST        IFEQ      'CEDEL'
     C     W_DEST        OREQ      'EOC  '
      *
      ** A settlement message is requested
      *
     C     DDGMES        IFEQ      'Y'
      *
      ** Check instructions type as a alpha input field
      *
     C     DDINST        LOOKUP    VA1                                    86
      *
      ** If not found and sent to Cedel
      ** ( Note MT580 have only Cedel or Euroclear destination )
      *
     C     *IN86         IFEQ      '0'
     C     W_DEST        ANDEQ     'CEDEL'
      *
     C     DDINST        LOOKUP    VA2                                    86
     C     *IN86         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINST'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5102'
     C                   MOVE      'N'           DDINSTOK
     C                   END
     C                   END
      *
      ** If not found and sent to Euroclear
      *
     C     *IN86         IFEQ      '0'
     C     W_DEST        ANDEQ     'EOC  '
      *
     C     DDINST        LOOKUP    VA3                                    86
     C     *IN86         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINST'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5103'
     C                   MOVE      'N'           DDINSTOK
     C                   END
     C                   END
     C                   END
      *
     C                   ELSE
      *                                                                                       213187
      ** If action code is 'C' or 'A' and clearance type changed to '5'                       213187
      *                                                                                       213187
     C     DDACTN        IFEQ      'C'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C     DDACTN        OREQ      'A'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C                   MOVEL     *BLANKS       DDINST                                       213187
     C                   ENDIF                                                                213187
      *                                                                                       213187
      ** Must not be entered if clearance type is not 1, 2, 3 or 4
     C     DDINST        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINST'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5111'
     C                   MOVE      'N'           DDINSTOK
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINSS - Validate Instructions Sub-Type (SINSS).             *
      *                                                               *
      *****************************************************************
     C     SRINSS        BEGSR
      *
      ** When Trade Purchase
      *
     C     DDTDTP        IFEQ      'TP'
     C     Screen        ANDNE     'B'
     C     DDTDTP        OREQ      'TS'
     C     Screen        ANDEQ     'B'
     C     DDPCOD        IFNE      '1'
     C     DDPCOD        ANDNE     '5'
     C                   MOVEL     'RECFREE'     W_INST            7
     C                   ELSE
     C                   MOVEL     'RECAPMT'     W_INST
     C                   END
     C                   END
      *
      ** When Trade Sale
      *
     C     DDTDTP        IFEQ      'TS'
     C     Screen        ANDNE     'B'
     C     DDTDTP        OREQ      'TP'
     C     Screen        ANDEQ     'B'
     C     DDPCOD        IFNE      '1'
     C     DDPCOD        ANDNE     '5'
     C                   MOVEL     'DELFREE'     W_INST
     C                   ELSE
     C                   MOVEL     'DELAPMT'     W_INST
     C                   END
     C                   END
      *
      ** Instructions type and Instructions sub-type
     C                   MOVEL     DDINST        W_INSS            8
     C                   MOVE      DDINSS        W_INSS
      *
      ** Key: Destination, Trade type, Pay code, Instructions type
      **      and sub-type
      *
     C                   MOVEL     W_GECO        KMGECO           20
      *
      ** Check the following for MT580 only
     C     W_DEST        IFEQ      'CEDEL'
     C     W_DEST        OREQ      'EOC  '
      *
      ** A settlement message is requested
     C     DDGMES        IFEQ      'Y'
      *
      ** Check internal or bridge instructions sub-type
     C     DDINST        IFEQ      'INT'
     C     DDINST        OREQ      'BRI'
      *
     C     DDINSS        IFNE      'SETTL'
     C     DDINSS        ANDNE     'MATCH'
     C     DDINSS        ANDNE     'TRANS'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINSS'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5104'
     C                   MOVE      'N'           DDINSSOK
     C                   END
     C                   END
      *
      **Check external sub-type
     C     DDINST        IFEQ      'EXT'
      *
     C     DDINSS        IFNE      'BOOK '
     C     DDINSS        ANDNE     ' BOOK'
     C     DDINSS        ANDNE     'PHYSI'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINSS'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5105'
     C                   MOVE      'N'           DDINSSOK
     C                   END
     C                   END
      *
      ** Check instructions sub-type depending of type of delivering
     C     KMGECO        CHAIN     MGECONL0                           86
     C     *IN86         IFEQ      '1'
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINSS'
      *
     C     W_INST        IFEQ      'RECFREE'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5107'
     C                   ELSE
     C     W_INST        IFEQ      'RECAPMT'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5108'
     C                   ELSE
     C     W_INST        IFEQ      'DELFREE'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5109'
     C                   ELSE
     C                   EVAL      MsgIDArr(Idx) = 'SEW5110'
     C                   END
     C                   END
     C                   END
      *
     C                   MOVE      'N'           DDINSSOK
     C                   END
     C                   END
      *
     C                   ELSE
      *                                                                                       213187
      ** If action code is 'C' or 'A' and clearance type changed to '5'                       213187
      *                                                                                       213187
     C     DDACTN        IFEQ      'C'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C     DDACTN        OREQ      'A'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C                   MOVEL     *BLANKS       DDINSS                                       213187
     C                   ENDIF                                                                213187
      *                                                                                       213187
      ** Must not be entered if clearance type is not 1, 2, 3 or 4
     C     DDINSS        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINSS'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5112'
     C                   MOVE      'N'           DDINSSOK
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREUCL - Validate Euroclear/Cedel Code (SEUCL).              *
      *                                                               *
      *****************************************************************
     C     SREUCL        BEGSR
      *
     C                   MOVEL     DDEUCL        DDEUCL_X
      *
      ** Check the following for MT580 only
     C     W_DEST        IFEQ      'CEDEL'
     C     W_DEST        OREQ      'EOC  '
      *
      ** A settlement message is requested
     C     DDGMES        IFEQ      'Y'
      *
      ** If not overridden
     C     OVRErrors     IFNE      'Y'
      *
      ** EUCL must start by  "//XC" or "//XE" or "/"
     C     DDEUCL11      IFNE      '/'
     C     DDEUCL14      ANDNE     '//XC'
     C     DDEUCL14      ANDNE     '//XE'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEUCL'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5115'
     C                   MOVE      'N'           DDEUCLOK
     C                   END
      *
      ** EUCL must be a 5 or 6 digits number
     C     DDEUCL33      IFEQ      'X'
     C                   MOVE      DDEUCL510     W_EUCL            6
     C                   ELSE
     C     DDEUCL11      IFEQ      '/'
     C                   MOVE      DDEUCL27      W_EUCL
     C                   ELSE
     C                   MOVEL     DDEUCL        W_EUCL
     C                   END
     C                   END
      *
     C                   MOVEA     W_EUCL        EU1
     C                   SETOFF                                       84
     C                   SETOFF                                       85
     C                   Z-ADD     0             I                 2 0
     C     I             DOWLE     4
     C     *IN84         ANDEQ     '0'
     C                   ADD       1             I
      *
     C     EU1(I)        IFEQ      ' '
     C                   SETON                                        84
     C                   ELSE
      *                                                                                       184406
      ** Store value of the 5th position.                                                     184406
      *                                                                                       184406
     C     I             IFEQ      1                                                          184406
     C                   MOVEL     EU1(I)        CG55              1                          184406
     C                   ENDIF                                                                184406
      *                                                                                       184406
     C     EU1(I)        LOOKUP    VA0                                    85
     C     *IN85         IFEQ      '0'
     C                   SETON                                        84
      *                                                                                       184406
      ** If not numeric, check if a valid alphabetic letter.                                  184406
      *                                                                                       184406
     C     DDEUCL14      IFEQ      '//XE'                                                     184406
     C     DDEUCL14      OREQ      '//XC'                                                     184406
      *                                                                                       184406
      ** Validate if 6th to 9th positions are alphabetic letter                               184406
      ** and make sure that 5th position is '9'.                                              184406
      *                                                                                       184406
     C     I             IFGE      2                                                          184406
     C     I             ANDLE     5                                                          184406
     C     CG55          IFEQ      '9'                                                        184406
     C     EU1(I)        LOOKUP    VA01                                   85                  184406
     C     *IN85         IFEQ      '1'                                                        184406
     C                   MOVE      '0'           *IN84                                        188406
     C                   ENDIF                                                                184406
     C                   ENDIF                                                                184406
     C                   ENDIF                                                                184406
      *                                                                                       184406
     C                   ENDIF                                                                184406
      *                                                                                       184406
      ** EUCL can start by "/X" where X is a valid alphabetic letter.                         184406
      *                                                                                       184406
     C     DDEUCL11      IFEQ      '/'                                                        184406
     C     DDEUCL14      ANDNE     '//XC'                                                     184406
     C     DDEUCL14      ANDNE     '//XE'                                                     184406
     C     I             ANDEQ     1                                                          184406
     C     EU1(I)        LOOKUP    VA01                                   85                  184406
     C     *IN85         IFEQ      '1'                                                        184406
     C                   MOVE      '0'           *IN84                                        184406
     C                   ENDIF                                                                184406
     C                   ENDIF                                                                184406
     C                   END
     C                   END
      *
     C                   END
      *
      ** Euroclear/Cedel Code is not valid
     C     *IN84         IFEQ      '1'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEUCL'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5115'
     C                   MOVE      'N'           DDEUCLOK
     C                   END
     C                   END
     C                   END
      *
     C                   ELSE
      *                                                                                       213187
      ** If action code is 'C' or 'A' and clearance type changed to '5'                       213187
      *                                                                                       213187
     C     DDACTN        IFEQ      'C'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C     DDACTN        OREQ      'A'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C                   MOVEL     *BLANKS       DDEUCL                                       213187
     C                   ENDIF                                                                213187
      *                                                                                       213187
      ** Must not be entered if clearance type is not 1, 2, 3 or 4
     C     DDEUCL        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEUCL'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5116'
     C                   MOVE      'N'           DDEUCLOK
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSAFA - Validate Safekeeping Account (SSAFA).               *
      *                                                               *
      *****************************************************************
     C     SRSAFA        BEGSR
      *
     C                   MOVEL     DDSAFA        DDSAFA_X
      *
      ** Check the following for MT580 only
     C     W_DEST        IFEQ      'CEDEL'
     C     W_DEST        OREQ      'EOC  '
      *
      ** A settlement message is requested
     C     DDGMES        IFEQ      'Y'
      *
      ** If not overridden
     C     OVRErrors     IFNE      'Y'
      *
      ** SAFA must start by a slash "/"
     C                   MOVEL     DDSAFA        W_SAFA            1
     C     W_SAFA        IFNE      '/'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSAFA'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5120'
     C                   MOVE      'N'           DDSAFAOK
     C                   END
      *
      ** SAFA must be a 5 digits number
     C                   MOVEA     DDSAFA        EU1
     C                   SETOFF                                       84
     C                   SETOFF                                       85
     C                   Z-ADD     1             I
     C     I             DOWLE     5
     C     *IN84         ANDEQ     '0'
     C                   ADD       1             I
      *
     C     EU1(I)        IFEQ      ' '
     C                   SETON                                        84
     C                   ELSE
     C     EU1(I)        LOOKUP    VA0                                    85
     C     *IN85         IFEQ      '0'
     C                   SETON                                        84
     C                   END
     C                   END
      *
     C                   END
      *
      ** Safekeeping A/c is not valid
     C     *IN84         IFEQ      '1'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSAFA'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5120'
     C                   MOVE      'N'           DDSAFAOK
     C                   END
      *
      ** Euroclear/Cedel must be different as Safekeeping Account
     C                   MOVEL     *BLANKS       AAEUCL            6
     C     DDSAFA        IFNE      *BLANKS
     C                   MOVEL     DDEUCL        AAEUCL
     C     AAEUCL        IFEQ      DDSAFA
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEUCL'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5121'
     C                   MOVE      'N'           DDEUCLOK
     C                   ELSE
      *
     C     DDEUCL14      IFEQ      '//XC'
     C     DDEUCL59      ANDEQ     DDSAFA26
     C     DDEUCL14      OREQ      '//XE'
     C     DDEUCL59      ANDEQ     DDSAFA26
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEUCL'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5121'
     C                   MOVE      'N'           DDEUCLOK
     C                   END
     C                   END
     C                   END
      *
     C                   END
     C                   END
      *
     C                   ELSE
      *                                                                                       213187
      ** If action code is 'C' or 'A' and clearance type changed to '5'                       213187
      *                                                                                       213187
     C     DDACTN        IFEQ      'C'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C     DDACTN        OREQ      'A'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C                   MOVEL     *BLANKS       DDSAFA                                       213187
     C                   ENDIF                                                                213187
      *                                                                                       213187
      ** Must not be entered if clearance type is not 1, 2, 3 or 4
     C     DDSAFA        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSAFA'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5116'
     C                   MOVE      'N'           DDSAFAOK
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRPTY - Validate Requested Priority Field (SRPTY).          *
      *                                                               *
      *****************************************************************
     C     SRRPTY        BEGSR
      *
      ** A settlement message is requested
     C     DDGMES        IFEQ      'Y'
      *
      ** If DDRPTYis not '1', '2', '3' , '4' or blank
     C     DDRPTY        IFNE      '1'
     C     DDRPTY        ANDNE     '2'
     C     DDRPTY        ANDNE     '3'
     C     DDRPTY        ANDNE     '4'
     C     DDRPTY        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRPTY'
     C**********         EVAL      MsgIDArr(Idx) = 'SEW5125'                                  199797
     C                   EVAL      MsgIDArr(Idx) = 'SEW5860'                                  199797
     C                   MOVE      'N'           DDRPTYOK
     C                   END
      *                                                                                       213187
      ** If action code is 'C' or 'A' and clearance type changed to '5'                       213187
      *                                                                                       213187
     C     DDACTN        IFEQ      'C'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C     DDACTN        OREQ      'A'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C                   MOVEL     *BLANKS       DDRPTY                                       213187
     C                   ENDIF                                                                213187
      *
     C     W_DEST        IFEQ      'CEDEL'
     C     DDRPTY        ANDEQ     '4'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRPTY'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5126'
     C                   MOVE      'N'           DDRPTYOK
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGDEL - Validate Guaranteed Delivery Field (SGDEL).         *
      *                                                               *
      *****************************************************************
     C     SRGDEL        BEGSR
      *
      ** A settlement message is requested
     C     DDGMES        IFEQ      'Y'
      *                                                                                       213187
      ** If action code is 'C' or 'A' and clearance type changed to '5'                       213187
      *                                                                                       213187
     C     DDACTN        IFEQ      'C'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C     DDACTN        OREQ      'A'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C                   MOVEL     *BLANKS       DDGDEL                                       213187
     C                   ENDIF                                                                213187
      *
      ** If DDGDELis not 'G' or blank
     C     DDGDEL        IFNE      'G'
     C     DDGDEL        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDGDEL'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5150'
     C                   MOVE      'N'           DDGDELOK
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSROL - Validate Sender's Role (SSROL).                     *
      *                                                               *
      *****************************************************************
     C     SRSROL        BEGSR
      *
      ** Check the following for MT580 only
     C     W_DEST        IFEQ      'CEDEL'
     C     W_DEST        OREQ      'EOC  '
      *
      ** A settlement message is requested
     C     DDGMES        IFEQ      'Y'
      *
      ** If DDSROL is not AGEN, CUST, PRIN or blank
     C     DDSROL        IFNE      'AGEN'
     C     DDSROL        ANDNE     'CUST'
     C     DDSROL        ANDNE     'PRIN'
     C     DDSROL        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSROL'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5165'
     C                   MOVE      'N'           DDSROLOK
     C                   END
     C                   END
      *
     C                   ELSE
      *                                                                                       213187
      ** If action code is 'C' or 'A' and clearance type changed to '5'                       213187
      *                                                                                       213187
     C     DDACTN        IFEQ      'C'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C     DDACTN        OREQ      'A'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C                   MOVEL     *BLANKS       DDSROL                                       213187
     C                   ENDIF                                                                213187
      *                                                                                       213187
      ** Must not be entered if clearance type is not 1, 2, 3 or 4
     C     DDSROL        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSROL'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5166'
     C                   MOVE      'N'           DDSROLOK
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFCOD - Validate Fungibility Code Field (SRPTY).            *
      *                                                               *
      *****************************************************************
     C     SRFCOD        BEGSR
      *
      ** Check the following for MT580 only
     C     W_DEST        IFEQ      'CEDEL'
     C     W_DEST        OREQ      'EOC  '
      *
      ** A settlement message is requested
     C     DDGMES        IFEQ      'Y'
      *
     C     DDFCOD        IFNE      *BLANKS
     C     W_DEST        ANDNE     'CEDEL'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFCOD'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5155'
     C                   MOVE      'N'           DDFCODOK
     C                   END
      *
      ** If entered, DDFCOD must be in the range 0 to 7.
     C     DDFCOD        IFNE      '0'
     C     DDFCOD        ANDNE     '1'
     C     DDFCOD        ANDNE     '2'
     C     DDFCOD        ANDNE     '3'
     C     DDFCOD        ANDNE     '5'
     C     DDFCOD        ANDNE     '6'
     C     DDFCOD        ANDNE     '7'
     C     DDFCOD        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFCOD'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5156'
     C                   MOVE      'N'           DDFCODOK
     C                   END
      *
      ** Check combinations between instructions and fungibility codes
      ** (Only for Cedel).
     C     W_DEST        IFEQ      'CEDEL'
     C     KMGECO        CHAIN     MGECONL0                           85
     C     *IN85         IFEQ      '0'
     C                   MOVEA     MGXFUN        MGFUN
     C     DDFCOD        LOOKUP    MGFUN                                  85
     C     *IN85         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFCOD'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5157'
     C                   MOVE      'N'           DDFCODOK
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C                   ELSE
      *                                                                                       213187
      ** If action code is 'C' or 'A' and clearance type changed to '5'                       213187
      *                                                                                       213187
     C     DDACTN        IFEQ      'C'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C     DDACTN        OREQ      'A'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C                   MOVEL     *BLANKS       DDFCOD                                       213187
     C                   ENDIF                                                                213187
      *                                                                                       213187
      ** Must not be entered if clearance type is not 1, 2, 3 or 4
     C     DDFCOD        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFCOD'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5159'
     C                   MOVE      'N'           DDFCODOK
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFTID - Validate Fungibility Trade Indicator Field.         *
      *                                                               *
      *****************************************************************
     C     SRFTID        BEGSR
      *
      ** Check the following for MT580 only
     C     W_DEST        IFEQ      'CEDEL'
     C     W_DEST        OREQ      'EOC  '
      *
      ** A settlement message is requested
     C     DDGMES        IFEQ      'Y'
      *
      ** If DDFTIDis not 'Y', 'N' or blank
     C     DDFTID        IFNE      'Y'
     C     DDFTID        ANDNE     'N'
     C     DDFTID        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFTID'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5160'
     C                   MOVE      'N'           DDFTIDOK
     C                   END
     C                   END
      *
     C                   ELSE
      *                                                                                       213187
      ** If action code is 'C' or 'A' and clearance type changed to '5'                       213187
      *                                                                                       213187
     C     DDACTN        IFEQ      'C'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C     DDACTN        OREQ      'A'                                                        213187
     C     DDCLTY        ANDEQ     '5'                                                        213187
     C                   MOVEL     *BLANKS       DDFTID                                       213187
     C                   ENDIF                                                                213187
      *
      ** Must not be entered if clearance type is not 1, 2, 3 or 4
     C     DDFTID        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFTID'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5161'
     C                   MOVE      'N'           DDFTIDOK
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGMEC - Validate Confirmation Message Request.              *
      *                                                               *
      *****************************************************************
     C     SRGMEC        BEGSR
      *                                                                                       229443
      ** Default to 'N' if PB customer                                                        229443
      *                                                                                       229443
     C                   IF        DDACTN = 'I'                                               229443
     C**********         Z-ADD     TCNR          CustNum                               229443 CPK027
     C                   MOVE      TCNR          CustNum                                      CPK027
     C     CustAlp       CHAIN(N)  SDCUSTL1                           85                      229443
     C                   IF        BBPRBA = 'Y' and *IN85 = *OFF                              229443
     C                   EVAL      DDGMEC = 'N'                                               229443
     C                   ENDIF                                                                229443
     C                   ENDIF                                                                229443
      *
      ** Assumed to be 'Y' when left blank
     C     DDGMEC        IFEQ      *BLANK
     C                   MOVEL     'Y'           DDGMEC
     C                   END
      *
      ** If DDGMECis not 'Y' or 'N' or blanks
     C     DDGMEC        IFNE      'Y'
     C     DDGMEC        ANDNE     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDGMEC'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5125'
     C                   MOVE      'N'           DDGMECOK
     C                   END
      *
      **  If DDGMECis 'Y' then check that the counterparty has a STTX
      **  or SWIFT ADDRESS or TELEX ADDRESS.
      *
     C     DDGMEC        IFEQ      'Y'
     C*****TCNR*         IFNE      *ZEROS                                              208195 CSD027
     C**********         Z-ADD     TCNR          CustNum                                      CSD027
     C     TCNR          IFNE      *BLANKS                                                    CSD027
     C                   EVAL      CustNum = TCNR                                             CSD027
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      CustAlp       @KEY1            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     BBCSID        IFEQ      *BLANKS
     C     BBSTAD        ANDEQ     *BLANKS
     C     BBTXA1        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDGMEC'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5127'
     C                   MOVE      'N'           DDGMECOK
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                208195
      *
      **  If confirmation message request was previously 'Y' then issue
      **  a warning message if the user changes this value. The message
      **  will inform the user that outstanding settlements exist for
      **  this trade.
      *
     C     DDACTN        IFEQ      'A'
     C     P@_DDGMEC     ANDEQ     'Y'
     C     DDACTN        OREQ      'C'
     C     P@_DDGMEC     ANDEQ     'Y'
      *
     C     P@_DDGMEC     IFNE      DDGMEC
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDGMEC'
     C                   EVAL      WMsgIDArr(WIdx) = 'SEW5854'
     C                   MOVE      'W'           DDGMECOK
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCCID - Validate Customer/Counterparty Indicator Field.     *
      *                                                               *
      *****************************************************************
     C     SRCCID        BEGSR
      *
      ** A confirmation message is requested
     C     DDGMEC        IFEQ      'N'
     C                   ELSE
      *
      ** If DDCCIDis not 'C' or 'P'
     C     DDCCID        IFNE      'C'
     C     DDCCID        ANDNE     'P'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCCID'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5140'
     C                   MOVE      'N'           DDCCIDOK
     C                   END
      *
      ** If T1CONG is 'Y' and DDCCID not equal to T1CCID from file
      ** (ie con generated and DDCCID changed).
      *
     C     P@_T1CONG     IFEQ      'Y'
     C     DDCCID        ANDNE     P@_DDCCID
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCCID'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5141'
     C                   MOVE      'N'           DDCCIDOK
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFID1 - Validate Further Identification Field (SFID1).      *
      *                                                               *
      *****************************************************************
     C     SRFID1        BEGSR
      *
      ** A confirmation message is requested
     C     DDGMEC        IFEQ      'N'
     C     DDFID1        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFID1'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5171'
     C                   MOVE      'N'           DDFID1OK
     C                   END
     C                   ELSE
      *
      ** Field 23/subfield 2 is NOT mandatory.
      ** If entered, must be: FORWARD, OPTION, REGULAR, STELLAGE or SPOT
     C     DDFID1        IFNE      *BLANKS
     C     DDFID1        LOOKUP    VA4                                    41
     C     *IN41         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFID1'
     C                   EVAL      MsgIDArr(Idx) = 'SEW5136'
     C                   MOVE      'N'           DDFID1OK
     C                   END
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      * SRIORA - Routine to validate Standing Instuctions Override    *         175216
      *          Field DDIORA.                                        *         175216
      ***************************************************************           175216
     C*                                                                         175216
     C     SRIORA        BEGSR                                                  175216
      *                                                               *         175216
      ** Only perform validation if Swift 2001 is NOT installed                               CSW201
      ** AND CSE028 (Standing Settlements Instruction) NOT installed                          CSE028
      *                                                                                       CSW201
     C     CSW201        IFNE      'Y'                                                        CSW201
     C     CSE028        ANDNE     'Y'                                                        CSE028
      *                                                                                       CSW201
     C     DDIORA        IFNE      'Y'                                          175216
     C     DDIORA        ANDNE     'N'                                          175216
     C                   ADD       1             Idx                            175216
     C                   EVAL      FldNameArr(Idx) = 'DDIORA'                   175216
     C                   EVAL      MsgIDArr(Idx) = 'SEW5179'                    175216
     C                   MOVE      'N'           DDIORAOK                       175216
     C                   END                                                    175216
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                         175216
     C                   ENDSR                                                  175216
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDFIL - Routine to move screen fields to file fields.       *
      *                                                               *
      *****************************************************************
     C     UPDFIL        BEGSR
      *
     C                   MOVE      DDGMES        T1GMES
     C                   MOVE      DDINST        T1INST
     C                   MOVE      DDINSS        T1INSS
     C                   MOVE      DDEUCL        T1EUCL
     C                   MOVE      DDSAFA        T1SAFA
     C                   MOVE      DDRPTY        T1RPTY
     C                   MOVE      DDGMEC        T1GMEC
     C                   MOVE      DDFID1        T1FID1
     C                   MOVE      DDCCID        T1CCID
     C                   MOVE      DDTRTT        T1TRTT
     C                   MOVE      DDGDEL        T1GDEL
     C                   MOVE      DDFCOD        T1FCOD
     C                   MOVE      DDFTID        T1FTID
     C                   MOVE      DDSROL        T1SROL
     C                   MOVE      DDIORA        T1SIOR                         175216
      *
     C     CSW003        IFEQ      'Y'
     C                   MOVEL     Screen        T1WHEN
     C                   ENDIF
      *
     C                   IF        CSE028 = 'Y'                                               CSE028
     C                             OR DDSNEW = 'Y'                                            225421
     C                   EVAL      T1NEW = DDSNEW                                             CSE028
     C                   EVAL      T1STMP = DDSTMP                                            CSE028
     C                   EVAL      T1CHID = DDCHID                                            CSE028
     C                   EVAL      T1TRRM = DDTRRM                                            CSE028
     C                   ENDIF                                                                CSE028
                                                                                              CSE028
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INIT - INITIAL PROCESSING                                     *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      * Retrieve customer details for Deliver From Depot (DELF)
      *
     C*****DELF*         IFNE      *ZEROS                                                     CSD027
     C     DELF          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      DELF          @SCKY             6
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @SCKY
     C     SDSECS        PARM      SDSECS        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     DELF          DBKEY
     C                   MOVEL     'SDSECSPD'    DBFILE                         ************
     C                   MOVEL     '801'         DBASE                          * DBERR 901*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** Initialize 'Deliver From' details
      *
     C                   MOVE      BFCLAS        DELF_CLAS         1
     C                   MOVEL     BFNDR1        BFDRF1                                       CSE022
     C                   MOVE      BFDRF1        DELF_DRF1         6
     C                   MOVEL     BFNDR2        BFDRF2                                       CSE022
     C                   MOVE      BFDRF2        DELF_DRF2         6
     C                   ENDIF
      *
      * Retrieve customer details for 'Deliver To' Depot (DELT).
      *
     C*****DELT*         IFNE      *ZEROS                                                     CSD027
     C     DELT          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      DELT          @SCKY
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @SCKY
     C     SDSECS        PARM      SDSECS        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     DELT          DBKEY
     C                   MOVEL     'SDSECSPD'    DBFILE                         ************
     C                   MOVEL     '802'         DBASE                          * DBERR 902*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** Initialize 'Deliver To' details
      *
     C                   MOVE      BFCLAS        DELT_CLAS         1
     C                   MOVEL     BFNDR1        BFDRF1                                       CSE022
     C                   MOVE      BFDRF1        DELT_DRF1         6
     C                   MOVEL     BFNDR2        BFDRF2                                       CSE022
     C                   MOVE      BFDRF2        DELT_DRF2         6
     C                   ENDIF
      *
      * Retrieve customer details for counterparty (TCNR).
      *
     C*****TCNR*         IFNE      *ZEROS                                              208195 CSD027
     C     TCNR          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      TCNR          @SCKY
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @SCKY
     C     SDSECS        PARM      SDSECS        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     TCNR          DBKEY
     C                   MOVEL     'SDSECSPD'    DBFILE                         ************
     C                   MOVEL     '803'         DBASE                          * DBERR 903*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** Initialize 'Counterparty' details
      *
     C                   MOVE      BFCLAS        TCNR_CLAS         1
     C                   MOVEL     BFNDR1        BFDRF1                                       CSE022
     C                   MOVE      BFDRF1        TCNR_DRF1         6                           S0111
     C                   MOVEL     BFNDR2        BFDRF2                                       CSE022
     C                   MOVE      BFDRF2        TCNR_DRF2         6                           S0111
     C                   ENDIF                                                                208195
      *
      ** Network routing and addresses for settlements
      ** ---------------------------------------------
      *
     C     Screen        IFEQ      'A'
 
     C     DDTDTP        IFEQ      'TP'
     C                   MOVE      DELT          Dest_DEPOT        6
     C                   ELSE
     C                   MOVE      DELF          Dest_DEPOT
     C                   END
 
     C                   ELSE
 
     C     DDTDTP        IFEQ      'TP'
     C                   MOVE      DELF          Dest_DEPOT
     C                   ELSE
     C                   MOVE      DELT          Dest_DEPOT
     C                   ENDIF
 
     C                   END
      *
      ** Retrieve Cedel/Euroclear destination
      ** ------------------------------------
      *
     C                   MOVE      *BLANKS       W_DEST            5
      *
     C**********         MOVE      Dest_DEPOT    W_DEPOT           6 0                        CSD027
     C                   MOVE      Dest_DEPOT    W_DEPOT           6                          CSD027
     C     W_DEPOT       IFEQ      DELT
     C                   SELECT
     C     DELT_CLAS     WHENEQ    'E'
     C                   MOVE      'EOC  '       W_DEST
     C     DELT_CLAS     WHENEQ    'C'
     C                   MOVE      'CEDEL'       W_DEST
     C                   ENDSL
     C                   ENDIF
      *
     C     W_DEPOT       IFEQ      DELF
     C                   SELECT
     C     DELF_CLAS     WHENEQ    'E'
     C                   MOVE      'EOC  '       W_DEST
     C     DELF_CLAS     WHENEQ    'C'
     C                   MOVE      'CEDEL'       W_DEST
     C                   ENDSL
     C                   ENDIF
     C**********         Z-ADD     0             Idx                                 198308 AR596191
      *
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
     C                   MOVEL     'SETRADEVAL'  DBPGM
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
      **------------------**
      ** Entry Parameters **
      **------------------**
     C     *ENTRY        PLIST
      *
      ** INPUTS
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Screen (A or B)
     C                   PARM                    Screen            1
      *
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Details
     C                   PARM                    TrPrim
     C                   PARM                    TrSeco
     C                   PARM                    TrExch
     C                   PARM                    TrSett
      *
      ** Trade Extension File details
     C                   PARM                    TrSwft
     C                   PARM                    ExtData                        CAP004
      *
      ** Previous inds
     C                   PARM                    P@_DDGMES         1
     C                   PARM                    P@_DDGMEC         1
     C                   PARM                    P@_DDCCID         1
     C                   PARM                    P@_T1CONG         1
      *
      ** Processing type
     C                   PARM                    PROT              1
      *
      ** Override errors
     C                   PARM                    OVRErrors         1
      *
      ** Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
      *                                                                                       CSW201
      ** Swift 2001 flag                                                                      CSW201
     C                   PARM                    CSW201            1                          CSW201
      *                                                                                       201233
      ** Destination of settlement                                                            201233
     C                   PARM                    DDROTS           12                          201233
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT             1                          201429
                                                                                              210517
      ** Tradsdx2 data                                                                        210517
                                                                                              210517
     C                   PARM                    PTradeX2                                     210517
      *
      ** OUTPUTS
      *
      * OK Flags
     C                   PARM                    OKTrSwft
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      * Valid Trade layout (DS) (Extension file) from/to caller
     C                   PARM                    ValidTrX1
      *
      ** Check if switchable feature CSW003 is switched on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSW003'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSW003'      DBKEY                          ************
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERR 904*
     C                   MOVEL     '900'         DBASE                          ************
     C                   EXSR      SRERR
     C                   END
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSW003
     C                   ELSE
     C                   MOVE      'N'           CSW003            1
     C                   END
                                                                                              CSE028
      ** Check if switchable feature CSE028 is switched on.                                   CSE028
                                                                                              CSE028
     C                   CALLB     'AOSARDR0'                                                 CSE028
     C                   PARM      *BLANKS       @RTCD                                        CSE028
     C                   PARM      '*VERIFY'     @OPTN                                        CSE028
     C                   PARM      'CSE028'      @SARD                                        CSE028
                                                                                              CSE028
      ** Database Error                                                                       CSE028
                                                                                              CSE028
     C                   IF        @RTCD <> *BLANKS and                                       CSE028
     C                             @RTCD <> '*NRF   '                                         CSE028
     C                   MOVEL     'CSE028'      DBKEY                                        CSE028
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE028
     C                   MOVEL     '901'         DBASE                                        CSE028
     C                   EXSR      SRERR                                                      CSE028
     C                   ENDIF                                                                CSE028
                                                                                              CSE028
     C                   IF        @RTCD = *BLANK                                             CSE028
     C                   EVAL      CSE028 = 'Y'                                               CSE028
     C                   ELSE                                                                 CSE028
     C                   EVAL      CSE028 = 'N'                                               CSE028
     C                   ENDIF                                                                CSE028
                                                                                              CSW202
      ** Check if CSW202 is switched on                                                       CSW202
                                                                                              CSW202
     C                   EVAL      CSW202 = 'N'                                               CSW202
     C                   CALL      'SWIF2002'                                                 CSW202
     C                   PARM      *BLANKS       PRtCd                                        CSW202
                                                                                              CSW202
     C                   IF        PRtCd = 'CSW2002'                                          CSW202
     C                   EVAL      CSW202 = 'Y'                                               CSW202
     C                   ENDIF                                                                CSW202
      *
     C     KEY001        KLIST                                                                201429
     C                   KFLD                    DDTDRF                                       201429
     C                   KFLD                    SCREEN                                       201429
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SETRDEV036
 
     C                   ENDSR
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
**  VA0  - ALL NUMERIC CHARS
0123456789
**  VA01 - ALL ALPHABETIC CHARS                                                               184406
ABCDEFGHIJKLMNOPQRSTUVWXYZ                                                                    184406
**  VA1  - INSTRUCTIONS TYPE VALIDATIONS (ALPAHABETIC)
INTBRIEXT#####################
**  VA2  - CEDEL CODES VALIDATIONS (NUMERIC)
31  3141  414F  4F4T  4T51  51
5F  5F5T  5T61  616F  6F81  81
8A  8A8D  8D8M  8M############
**  VA3  - EUROCLEAR CODES VALIDATIONS (NUMERIC)
01 02 03 03C03K07 07C07K######
##############################
**  VA4  - VALID FURTHER IDENTIFICATION FIELDS
FORWARD
OPTION
REGULAR
STELLAGE
SPOT
 FORWARD
  OPTION
 REGULAR
    SPOT

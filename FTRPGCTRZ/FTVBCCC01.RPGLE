     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate BIC / clearing code')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVBCCC01 - Validate BIC and customer shortname              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      * This module receives two parameters : 35A and 11A.            *
      *                                                               *
      * When validating a RFT Header field:                           *
      * The first field may contain a clearing code preceded by a     *
      * '//' or an account identifier preceded by a '/'.              *
      *                                                               *
      * When validating a RFT Detail field:                           *
      * The first field may contain a clearing code preceded by a     *
      * '//' or else be blank.                                        *
      *                                                               *
      * The second field may contain a BIC, customer number           *
      * or shortname that has a BIC assigned to it from #DCUSTPD.     *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD034557           Date 01Jun15               *
      *                 MD034498           Date 25May15               *
      *                 MD034390           Date 14May15               *
      *                 CSW215             Date 06Apr15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206             Date 03Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 221760             Date 01Apr04               *
      *                 226083             Date 23Mar04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSW200             Date 21Aug00               *
      *                 CFT006  *CREATE    Date 20Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034557 - Character inserted in 13th-14th digit for         *
      *             clearing code CN is accepted                      *
      *  MD034498 - Additional validation for //RT//CN allowing       *
      *             CNAPS clearing code for SWIFT 2015 changes        *
      *  MD034390 - CCTD and RFTD do not validate input for fields    *
      *             generating 52a, 56a, 57a when Clearing codes is   *
      *             supplied in transaction screen does affecting the *
      *             reports output                                    *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  CSW206 - SWIFT 2006 Standard Changes                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221760 - Do not validate SWIFT ID if MEBICDPD is empty.      *
      *  226083 - Correct various errors in RFT validation            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  CSW200 - SWIFT 2000 enhancements                             *
      *  CFT006 - MT101 FT development                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FMEBICDL2  IF   E           K DISK
      * BIC File
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,ERR_XARRYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **********************************************************************
      /EJECT                                                               *
      **********************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D Account         DS
     D**P@CNUM**               1      6  0                                                    CSD027
     D  P@CNUM                 1      6                                                       CSD027
     D  P@CUCD                 7      9
     D  P@ACCD                10     19  0                                                    CGL029
     D  P@ACSQ                20     21  0                                                    CGL029
     D  P@BRCA                22     24                                                       CGL029
     D**P@ACCD**              10     13  0                                                    CGL029
     D**P@ACSQ**              14     15  0                                                    CGL029
     D**P@BRCA**              16     18                                                       CGL029
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     DArrDig           S              1    DIM(10) CTDATA PERRCD(10)
     D ALPHAN          S              1    DIM(36) CTDATA PERRCD(36)                          CSW202
     DStrArr           S              1    DIM(35)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * DS for access programs, long data structure
     D P@FMT         E DS                  EXTNAME(DSFDY)
      * DS for access programs, short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     DSDCUST         E DS                  EXTNAME(SDCUSTPD)
 
     D  OverRide       S              1    INZ('N')
     D  OvrSt          S              3  0 INZ(*Zeros)
     D  OvrEd          S              3  0 INZ(*Zeros)
 
     D  @Type          S              7    INZ(*Blanks)
     D  @KEY1          S             10    INZ(*Blanks)
     D  @KYST          S              7    INZ(*Blanks)
     D  ClrOrAcc       S             35
     D  BicCSname      S             11
 
     D  Char18         S             18    INZ(*Blanks)
     D  @Clr           S              7    INZ(*Blanks)
     D  SPos           S              3  0 INZ(*Zeros)
     D  EPos           S              3  0 INZ(*Zeros)
     D  DigLen         S              3  0 INZ(*Zeros)
     D  FirstBlank     S              3  0 INZ(*Zeros)
 
      * SWIFT 2000 flag                                                         CSW200
     D  CSW200         S              1                                         CSW200
                                                                                CSW200
      * Name of field being validated                                           CSW200
     D  DDSName        S             10                                         CSW200
                                                                                              CSW201
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CSW201
      ** Return code when calling SWIF2001                                                    CSW201
     D PRTCD           S              7A                                                      CSW201
                                                                                CSW200
     D CSW202          S              1                                                       CSW202
                                                                                              CSW202
     D CSW206          S              1                                                       CSW206
                                                                                              CSW206
     D CSW215          S              1                                                       CSW215
                                                                                              CSW215
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *********************************************************************
      /EJECT                                                              *
      *********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   IF        RetCodeIn = 'DETAIL'
     C                   EXSR      Detail
     C                   ELSE
     C                   EXSR      Header
     C                   ENDIF
 
     C                   SETON                                          LR
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * HEADER - Validate BIC entry to a RFT header field             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOBICDV0                                               *
      *                                                               *
      *****************************************************************
     C     Header        BEGSR
      *
      * If the entry in field 2 is a valid BIC or the shortname
      *  / customer number has a BIC assigned to it.
     C                   Eval      Char18 = BicCSname
     C**********         CallB     'AOBICDV0'                                                 221760
     C                   CallB     'AOBICDV01'                                                221760
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    Char18
     C                   Parm                    @Type
     C                   Parm                    DSSDY
 
     C                   Select
     C                   When      @Type = '*BIC'
     C*  Or Customer number or shortname with valid BIC (MEBICDPD is filled)                  226083
     C                             Or  @TYPE      = '*NUMBER'                                 226083
     C                             And RetCodeIn  = '*BICFND'                                 226083
     C                             Or  @TYPE      = '*SHNAME'                                 226083
     C                             And RetCodeIn  = '*BICFND'                                 226083
     C*  Or Customer number or shortname with valid BIC (MEBICDPD is empty)                   226083
     C                             Or  @TYPE      = '*NUMBER'                                 226083
     C                             And RetCodeIn  = *blank                                    226083
     C                             Or  @TYPE      = '*SHNAME'                                 226083
     C                             And RetCodeIn  = *blank                                    226083
 
      * If the first field contains '//', field 1 must contain a
      * clearing code :
     C                   If        ClrOrAcc <> *Blanks
     C                   If        %subst(ClrOrAcc:1:4) <> '//AT'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//AU'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//BL'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//CC'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//ES'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//FW'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//IT'    AND
     C*******************          %subst(ClrOrAcc:1:4) <> '//RT'    AND        CSW200
     C*******************          %subst(ClrOrAcc:1:4) <> '//SC'               CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//SC'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//HK'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//IE'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//GR'    AND                      CSW202
     C                             %subst(ClrOrAcc:1:4) <> '//IN'    AND                      CSW202
     C                             %subst(ClrOrAcc:1:4) <> '//PL'    AND                      CSW206
     C                             %subst(ClrOrAcc:1:4) <> '//CN'    AND                      CSW215
     C                             %subst(ClrOrAcc:1:4) <> '//PT'    OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//RT'    AND        CSW200
     C                             CSW200               =  'Y'       OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//HK'    AND        CSW200
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//IE'    AND        CSW200
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             ((%SUBST(ClrOrAcc:1:4) = '//GR'   OR                       CSW202
     C                             %SUBST(ClrOrAcc:1:4) =  '//IN')   AND                      CSW202
     C                             (CSW202              <> 'Y'       OR                       CSW202
     C                             DDSName              <> 'OINST3'  AND                      CSW202
     C                             DDSName              <> 'HACSV1'))OR                       CSW202
     C                             %subst(ClrOrAcc:1:4) =  '//PT'    AND        CSW200
     C**********                   CSW200               <> 'Y'                         CSW200 CSW206
     C                             CSW200               <> 'Y'       OR                       CSW206
     C                             %subst(ClrOrAcc:1:4) =  '//PL'    AND                      CSW206
     C                             CSW206               <> 'Y'                                CSW206
     C                             OR %SUBST(ClrOrAcc:1:4) = '//CN' AND                       CSW215
     C                             CSW215 <> 'Y'                                              CSW215
 
     C                   Eval      RetCodeIn = '*INVALIDCC'
     C                   Return
     C                   Else
     C                   Eval      @Clr = '*NOTALL'
     C                   Exsr      @ChkClrDig
     C                   Endif
     C                   Endif
 
     C                   When      @Type = '*NRF'  or  RetCodeIn = '*NOBIC'
 
     C                   If        BicCSName <> *Blanks
     C                             And DDSNAME <> 'PINSTA'                                    226083
     C                             And DDSNAME <> 'PACA11'                                    226083
     C                   Eval      RetCodeIn = '*11ERROR'
     C                   Endif                                                                226083
                                                                                            MD034390
     C                   If        %SUBST(ClrOrAcc:1:4) = '//CN'                            MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//AT'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//AU'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//BL'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//CC'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//ES'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//FW'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//GR'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//HK'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//IE'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//IN'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//IT'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//PL'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//PT'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//SC'                         MD034390
     C                   EVAL      @Clr = '*ALL'                                            MD034390
     C                   EXSR      @ChkClrDig                                               MD034390
     C                   ENDIF                                                              MD034390
                                                                                              226083
     C***********        Else                                                                 226083
      ***********                                                                             226083
     C***********        If        ClrOrAcc <> *Blanks                                        226083
     C***********        If        %subst(ClrOrAcc:1:4) <> '//AT'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//AU'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//BL'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//CC'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//ES'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//FW'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//IT'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//RT'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//SC'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//CH'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//CP'    AND                      226083
     C*******************          %subst(ClrOrAcc:1:4) <> '//SW'                      CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//SW'    AND               CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//HK'    AND               CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//IE'    AND               CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//PT'    AND               CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//GR'    AND               CSW202 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//IN'    AND               CSW202 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//RU'    OR                CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) =  '//RT'    AND               CSW202 226083
     C***********                  CSW200               =  'Y'       OR                CSW202 226083
     C***********                  %subst(ClrOrAcc:1:4) =  '//HK'    AND               CSW200 226083
     C***********                  CSW200               <> 'Y'       OR                CSW202 226083
     C***********                  %subst(ClrOrAcc:1:4) =  '//IE'    AND               CSW202 226083
     C***********                  CSW200               <> 'Y'       OR                CSW202 226083
     C***********                  %subst(ClrOrAcc:1:4) =  '//PT'    AND               CSW200 226083
     C***********                  CSW200               <> 'Y'       OR                CSW200 226083
     C***********                  ((%SUBST(ClrOrAcc:1:4) = '//GR'   OR                CSW202 226083
     C***********                  %SUBST(ClrOrAcc:1:4) =  '//IN')   AND               CSW202 226083
     C***********                  (CSW202              <> 'Y'       OR                CSW202 226083
     C***********                  DDSName              <> 'OINST3'  AND               CSW202 226083
     C***********                  DDSName              <> 'HACSV1'))OR                CSW202 226083
     C***********                  %subst(ClrOrAcc:1:4) =  '//RU'    AND               CSW200 226083
     C***********                  CSW200               <> 'Y'                         CSW200 226083
      ***********                                                                             226083
     C***********        Eval      RetCodeIn = '*INVALIDCC'                                   226083
     C***********        Return                                                               226083
     C***********        Else                                                                 226083
     C***********        Eval      @Clr = '*ALL'                                              226083
     C***********        Exsr      @ChkClrDig                                                 226083
     C***********        Endif                                                                226083
     C***********        Endif                                                                226083
     C***********        Endif                                                                226083
      ***********                                                                             226083
      ** Otherwise, @Type is '*NUMBER' or '*SHNAME' and a BIC is valid for
      ** this customer.
     C                   Other
 
     C                   If        ClrOrAcc <> *Blanks
     C                   If        %subst(ClrOrAcc:1:4) <> '//AT'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//AU'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//BL'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//CC'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//ES'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//FW'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//IT'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//RT'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//SC'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//CH'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//CP'    AND
     C*******************          %subst(ClrOrAcc:1:4) <> '//SW'               CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//SW'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//HK'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//IE'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//PT'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//GR'    AND                      CSW202
     C                             %subst(ClrOrAcc:1:4) <> '//IN'    AND                      CSW202
     C                             %subst(ClrOrAcc:1:4) <> '//PL'    AND                      CSW206
     C                             %subst(ClrOrAcc:1:4) <> '//CN'    AND                      CSW215
     C                             %subst(ClrOrAcc:1:4) <> '//RU'    OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//RT'    AND        CSW200
     C                             CSW200               =  'Y'       OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//HK'    AND        CSW200
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//IE'    AND        CSW200
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//PT'    AND        CSW200
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             ((%SUBST(ClrOrAcc:1:4) = '//GR'   OR                       CSW202
     C                             %SUBST(ClrOrAcc:1:4) =  '//IN')   AND                      CSW202
     C                             (CSW202              <> 'Y'       OR                       CSW202
     C                             DDSName              <> 'OINST3'  AND                      CSW202
     C                             DDSName              <> 'HACSV1'))OR                       CSW202
     C                             %subst(ClrOrAcc:1:4) =  '//RU'    AND        CSW200
     C**********                   CSW200               <> 'Y'                         CSW200 CSW206
     C                             CSW200               <> 'Y'       OR                       CSW206
     C                             %subst(ClrOrAcc:1:4) =  '//PL'    AND                      CSW206
     C                             CSW206               <> 'Y'                                CSW206
     C                             OR %SUBST(ClrOrAcc:1:4) = '//CN' AND                       CSW215
     C                             CSW215 <> 'Y'                                              CSW215
 
     C                   Eval      RetCodeIn = '*INVALIDCC'
     C                   Return
     C                   Else
     C                   Eval      @Clr = '*ALL'
     C                   Exsr      @ChkClrDig
     C                   Endif
     C                   Endif
 
     C                   Endsl
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DETAIL - Validate BIC entry to a RFT detail field             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOBICDV0                                               *
      *                                                               *
      *****************************************************************
     C     Detail        BEGSR
      *
      * If the entry in field 2 is a valid BIC or the shortname
      *  / customer number has a BIC assigned to it.
     C                   Eval      Char18 = BicCSname
 
     C**********         CallB     'AOBICDV0'                                                 221760
     C                   CallB     'AOBICDV01'                                                221760
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    Char18
     C                   Parm                    @Type
     C                   Parm                    DSSDY
 
     C                   Select
 
     C                   When      @Type = '*BIC'
     C*  Or Customer number or shortname with valid BIC (MEBICDPD is filled)                  226083
     C                             Or  @TYPE      = '*NUMBER'                                 226083
     C                             And RetCodeIn  = '*BICFND'                                 226083
     C                             Or  @TYPE      = '*SHNAME'                                 226083
     C                             And RetCodeIn  = '*BICFND'                                 226083
     C*  Or Customer number or shortname with valid BIC (MEBICDPD is empty)                   226083
     C                             Or  @TYPE      = '*NUMBER'                                 226083
     C                             And RetCodeIn  = *blank                                    226083
     C                             Or  @TYPE      = '*SHNAME'                                 226083
     C                             And RetCodeIn  = *blank                                    226083
 
      * 1st of the 35-long fields can only contain a '//' followed by
      * one of the clearing codes below (or else be blank).
     C                   If        ClrOrAcc <> *Blanks
     C                   If        %subst(ClrOrAcc:1:4) <> '//AT'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//AU'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//BL'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//CC'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//ES'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//FW'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//IT'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//RT'    AND
     C*****************************%subst(ClrOrAcc:1:4) <> '//SC'               CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//SC'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//HK'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//IE'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//PT'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//GR'    AND                      CSW202
     C                             %subst(ClrOrAcc:1:4) <> '//IN'    AND                      CSW202
     C                             %subst(ClrOrAcc:1:4) <> '//PL'    AND                      CSW206
     C                             %subst(ClrOrAcc:1:4) <> '//CN'    AND                      CSW215
     C                             %subst(ClrOrAcc:1:4) <> '//NZ'    OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//RT'    AND        CSW200
     C                             CSW200               =  'Y'       AND        CSW200
     C                             DDSName              <> 'PACCI35' OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//HK'    AND        CSW200
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//IE'    AND        CSW200
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//PT'    AND        CSW200
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//NZ'    AND        CSW200
     C                             (CSW201              <> 'Y'       OR                       CSW201
     C                             (CSW201              =  'Y'       AND                      CSW201
     C                              DDSName             <> 'PACA35'  AND                      CSW201
     C                             DDSName              <> 'PINST1'))AND                      CSW201
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             ((%SUBST(ClrOrAcc:1:4) = '//GR'   OR                       CSW202
     C                             %SUBST(ClrOrAcc:1:4) =  '//IN')   AND                      CSW202
     C                             (CSW202              <> 'Y'       OR                       CSW202
     C                             DDSName              <> 'PORDI35' AND                      CSW202
     C                             DDSName              <> 'PACCI35' AND                      CSW202
     C                             DDSName              <> 'PASI35'  AND                      CSW202
     C                             DDSName              <> 'PACA35'  AND                      CSW202
     C                             DDSName              <> 'PINST1'))OR                       CSW202
     C                             %subst(ClrOrAcc:1:4) =  '//NZ'    AND        CSW200
     C                             CSW200               =  'Y'       AND        CSW200
     C                             DDSName              <> 'PACCI35'            CSW200
     C                             AND (CSW201          <> 'Y'       OR                       CSW201
     C                             (DDSName             <> 'PACA35'  AND                      CSW201
     C**********                   DDSName              <> 'PINST1'))                  CSW201 CSW206
     C                             DDSName              <> 'PINST1')) OR                      CSW206
     C                             %SUBST(ClrOrAcc:1:4) =  '//PL'    AND                      CSW206
     C                             CSW206               <> 'Y'                                CSW206
     C                             OR %SUBST(ClrOrAcc:1:4) = '//CN' AND                       CSW215
     C                             CSW215 <> 'Y'                                              CSW215
 
     C                   Eval      RetCodeIn = '*INVALIDCC'
     C                   Return
     C                   Else
     C                   Eval      @Clr = '*NOTALL'
     C                   Exsr      @ChkClrDig
     C                   Endif
     C                   Endif
 
     C                   When      @Type = '*NRF'  or  RetCodeIn = '*NOBIC'
     C                             And DDSNAME <> 'PINSTA'                                    226083
     C                             And DDSNAME <> 'PACA11'                                    226083
 
     C                   If        BicCSName <> *Blanks
     C                   Eval      RetCodeIn = '*11ERROR'
     C                   ENDIF                                                                226083
                                                                                            MD034390
     C                   If        %SUBST(ClrOrAcc:1:4) = '//CN'                            MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//AT'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//AU'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//BL'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//CC'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//ES'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//FW'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//GR'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//HK'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//IE'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//IN'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//IT'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//PL'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//PT'                         MD034390
     C                             OR %SUBST(ClrOrAcc:1:4) = '//SC'                         MD034390
     C                             OR (%SUBST(ClrOrAcc:1:4) = '//RT'                        MD034498
     C                             AND CSW215= 'Y'                                          MD034498
     C                             AND DDSName = 'PACCI35')                                 MD034498
     C                   EVAL      @Clr = '*ALL'                                            MD034390
     C                   EXSR      @ChkClrDig                                               MD034390
     C                   ENDIF                                                              MD034390
     C*                                                                                       226083
     C***********        Else                                                                 226083
      ***********                                                                             226083
     C***********        If        ClrOrAcc <> *Blanks                                        226083
     C***********        If        %subst(ClrOrAcc:1:4) <> '//AT'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//AU'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//BL'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//CC'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//ES'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//FW'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//IT'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//RT'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//SC'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//CH'    AND                      226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//CP'    AND                      226083
     C*******************          %subst(ClrOrAcc:1:4) <> '//SW'               CSW200
     C***********                  %subst(ClrOrAcc:1:4) <> '//SW'    AND               CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//HK'    AND               CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//IE'    AND               CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//PT'    AND               CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//RU'    AND               CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//GR'    AND               CSW202 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//IN'    AND               CSW202 226083
     C***********                  %subst(ClrOrAcc:1:4) <> '//NZ'    OR                CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) =  '//RT'    AND               CSW200 226083
     C***********                  CSW200               =  'Y'       AND               CSW200 226083
     C***********                  DDSName              <> 'PACCI35' OR                CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) =  '//HK'    AND               CSW200 226083
     C***********                  CSW200               <> 'Y'       OR                CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) =  '//IE'    AND               CSW200 226083
     C***********                  CSW200               <> 'Y'       OR                CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) =  '//PT'    AND               CSW200 226083
     C***********                  CSW200               <> 'Y'       OR                CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) =  '//RU'    AND               CSW200 226083
     C***********                  CSW200               <> 'Y'       OR                CSW200 226083
     C***********                  %subst(ClrOrAcc:1:4) =  '//NZ'    AND               CSW200 226083
     C***********                  (CSW201              <> 'Y'       OR                CSW201 226083
     C***********                  (CSW201              =  'Y'       AND               CSW201 226083
     C***********                   DDSName             <> 'PACA35'  AND               CSW201 226083
     C***********                  DDSName              <> 'PINST1'))AND               CSW201 226083
     C***********                  CSW200               <> 'Y'       OR                CSW200 226083
     C***********                  ((%SUBST(ClrOrAcc:1:4) = '//GR'   OR                CSW202 226083
     C***********                  %SUBST(ClrOrAcc:1:4) =  '//IN')   AND               CSW202 226083
     C***********                  (CSW202              <> 'Y'       OR                CSW202 226083
     C***********                  DDSName              <> 'PORDI35' AND               CSW202 226083
     C***********                  DDSName              <> 'PACCI35' AND               CSW202 226083
     C***********                  DDSName              <> 'PASI35'  AND               CSW202 226083
     C***********                  DDSName              <> 'PACA35'  AND               CSW202 226083
     C***********                  DDSName              <> 'PINST1'))OR                CSW202 226083
     C***********                  %subst(ClrOrAcc:1:4) =  '//NZ'    AND               CSW200 226083
     C***********                  CSW200               =  'Y'       AND               CSW200 226083
     C***********                  DDSName              <> 'PACCI35'                   CSW200 226083
     C***********                  AND (CSW201          <> 'Y'       OR                CSW201 226083
     C***********                  (DDSName             <> 'PACA35'  AND               CSW201 226083
     C***********                  DDSName              <> 'PINST1'))                  CSW201 226083
      ***********                                                                             226083
     C***********        Eval      RetCodeIn = '*INVALIDCC'                                   226083
     C***********        Return                                                               226083
     C***********        Else                                                                 226083
     C***********        Eval      @Clr = '*ALL'                                              226083
     C***********        Exsr      @ChkClrDig                                                 226083
     C***********        Endif                                                                226083
     C***********        Endif                                                                226083
     C***********        Endif                                                                226083
 
      ** Otherwise, @Type is '*NUMBER' or '*SHNAME' and a BIC is valid for
      ** this customer.
     C                   Other
 
     C                   If        ClrOrAcc <> *Blanks
     C                   If        %subst(ClrOrAcc:1:4) <> '//AT'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//AU'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//BL'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//CC'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//ES'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//FW'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//IT'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//RT'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//SC'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//CH'    AND
     C                             %subst(ClrOrAcc:1:4) <> '//CP'    AND
     C*******************          %subst(ClrOrAcc:1:4) <> '//SW'               CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//SW'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//HK'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//IE'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//PT'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//RU'    AND        CSW200
     C                             %subst(ClrOrAcc:1:4) <> '//GR'    AND                      CSW202
     C                             %subst(ClrOrAcc:1:4) <> '//IN'    AND                      CSW202
     C                             %subst(ClrOrAcc:1:4) <> '//PL'    AND                      CSW206
     C                             %subst(ClrOrAcc:1:4) <> '//CN'    AND                      CSW215
     C                             %subst(ClrOrAcc:1:4) <> '//NZ'    OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//RT'    AND        CSW200
     C                             CSW200               =  'Y'       AND        CSW200
     C                             DDSName              <> 'PACCI35' OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//HK'    AND        CSW200
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//IE'    AND        CSW200
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//PT'    AND        CSW200
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//RU'    AND        CSW200
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             %subst(ClrOrAcc:1:4) =  '//NZ'    AND        CSW200
     C                             (CSW201              <> 'Y'       OR                       CSW201
     C                             (CSW201              =  'Y'       AND                      CSW201
     C                              DDSName             <> 'PACA35'  AND                      CSW201
     C                             DDSName              <> 'PINST1'))AND                      CSW201
     C                             CSW200               <> 'Y'       OR         CSW200
     C                             ((%SUBST(ClrOrAcc:1:4) = '//GR'   OR                       CSW202
     C                             %SUBST(ClrOrAcc:1:4) =  '//IN')   AND                      CSW202
     C                             (CSW202              <> 'Y'       OR                       CSW202
     C                             DDSName              <> 'PORDI35' AND                      CSW202
     C                             DDSName              <> 'PACCI35' AND                      CSW202
     C                             DDSName              <> 'PASI35'  AND                      CSW202
     C                             DDSName              <> 'PACA35'  AND                      CSW202
     C                             DDSName              <> 'PINST1'))OR                       CSW202
     C                             %subst(ClrOrAcc:1:4) =  '//NZ'    AND        CSW200
     C                             CSW200               =  'Y'       AND        CSW200
     C                             DDSName              <> 'PACCI35'            CSW200
     C                             AND (CSW201          <> 'Y'       OR                       CSW201
     C                             (DDSName             <> 'PACA35'  AND                      CSW201
     C**********                   DDSName              <> 'PINST1'))                  CSW201 CSW206
     C                             DDSName              <> 'PINST1')) OR                      CSW206
     C                             %SUBST(ClrOrAcc:1:4) =  '//PL'    AND                      CSW206
     C                             CSW206               <> 'Y'                                CSW206
     C                             OR %SUBST(ClrOrAcc:1:4) = '//CN' AND                       CSW215
     C                             CSW215 <> 'Y'                                              CSW215
 
     C                   Eval      RetCodeIn = '*INVALIDCC'
     C                   Return
     C                   Else
     C                   Eval      @Clr = '*ALL'
     C                   Exsr      @ChkClrDig
     C                   Endif
     C                   Endif
 
 
     C                   EndSl
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * @ChkClrDig : Check clearing code digits are correct           *
      *****************************************************************
     C     @ChkClrDig    Begsr
 
     C                   Select
 
      * Clear code //AT must have a 5 digit number //AT12345...
     C                   When      %Subst(ClrOrAcc:1:4) = '//AT'
     C                   Eval      SPos = 5
     C                   Eval      EPos = 9
     C                   Eval      DigLen = 5
     C                   Eval      FirstBlank = 10
     C                   Exsr      ChkDigit
 
      * Clear code //AU, or SC must have a 6 digit number //AT123456..
      * Same applies to codes //IE (if CSW200 is on) and //NZ (if               CSW200
      * CSW200 is on and field is Acc. With in a MT102).                        CSW200
      * Same applies to codes //NZ (if CSW201 is on and field is either                       CSW201
      * Account with Institution or Intermediary in an MT101.)                                CSW201
     C                   When      %Subst(ClrOrAcc:1:4) = '//AU' OR
     C                             %Subst(ClrOrAcc:1:4) = '//IE' AND            CSW200
     C                             CSW200               = 'Y'    OR             CSW200
     C                             %Subst(ClrOrAcc:1:4) = '//NZ' AND            CSW200
     C                             CSW200               = 'Y'    AND            CSW200
     C                             DDSName              = 'PACCI35' OR          CSW200
     C                             %Subst(ClrOrAcc:1:4) = '//SC'
     C                             OR %Subst(ClrOrAcc:1:4) = '//NZ'                           CSW201
     C                             AND CSW201           = 'Y'       AND                       CSW201
     C                             (DDSName             = 'PACA35'  OR                        CSW201
     C                             DDSName              = 'PINST1')                           CSW201
     C                   Eval      SPos = 5
     C                   Eval      EPos = 10
     C                   Eval      DigLen = 6
     C                   Eval      FirstBlank = 11
     C                   Exsr      ChkDigit
 
      * Clear code //BL must have a 8 digit number //BL12345678
      * Same applies if code is //PT and CSW200 is on.                          CSW200
     C*******************When      %Subst(ClrOrAcc:1:4) = '//BL'                CSW200
     C                   When      %Subst(ClrOrAcc:1:4) = '//BL' OR             CSW200
     C                             %Subst(ClrOrAcc:1:4) = '//PT' AND            CSW200
     C**********                   CSW200               = 'Y'                          CSW200 CSW206
     C                             CSW200               = 'Y'    OR                           CSW206
     C                             %Subst(ClrOrAcc:1:4) = '//PL' AND                          CSW206
     C                             CSW206               = 'Y'                                 CSW206
     C                   Eval      SPos = 5
     C                   Eval      EPos = 12
     C                   Eval      DigLen = 8
     C                   Eval      FirstBlank = 13
     C                   Exsr      ChkDigit
 
      * Clear code //CC, or ES must have a 9 digit number //CC123456789
      *  If //ES, ensure that element 9 contains digit.
     C                   When      %Subst(ClrOrAcc:1:4) = '//CC'  OR
     C                             %Subst(ClrOrAcc:1:4) = '//ES'
 
     C                   If        %Subst(ClrOrAcc:1:4) = '//ES'
     C                   Eval      OverRide = 'Y'
     C                   Eval      OvrSt    = 13
     C                   Eval      OvrEd    = 13
     C                   Endif
 
     C                   Eval      SPos = 5
     C                   Eval      EPos = 13
     C                   Eval      DigLen = 9
     C                   Eval      FirstBlank = 14
     C                   Exsr      ChkDigit
 
      * Clear code //IT must have an 11 to 23 digit number //IT123456789
     C                   When      %Subst(ClrOrAcc:1:4) = '//IT'
 
     C                   Eval      SPos = 5
     C                   Eval      EPos = 15
     C                   Eval      DigLen = 11
     C                   Eval      FirstBlank = 28
     C                   Exsr      ChkDigit
 
      * Clear code //SW must have an 3 to 6 digit number //SW123456
     C                   When      %Subst(ClrOrAcc:1:4) = '//SW'
 
     C                   Eval      SPos = 5
     C                   Eval      EPos = 11
     C                   Eval      DigLen = 6
     C                   Eval      FirstBlank = 12
     C                   Eval      OvrSt = 8
     C                   Eval      OvrEd = 11
     C                   Eval      OverRide = 'Y'
     C                   Exsr      ChkDigit
 
      * Clear code //RT must not have any digits
      * (certain special conditions apply if CSW200 is on - EXSR SRRT).         CSW200
     C                   When      %Subst(ClrOrAcc:1:4) = '//RT'
     C                   Exsr      SRRT                                         CSW200
 
     C*******************Eval      SPos = 5                                     CSW200
     C*******************Eval      EPos = 1                                     CSW200
     C*******************Eval      DigLen = 11                                  CSW200
     C*******************Eval      FirstBlank = 5                               CSW200
     C*******************Exsr      ChkDigit                                     CSW200
 
      * Clear code //HK must have a 3 digit number //HK123.                     CSW200
     C                   When      %Subst(ClrOrAcc:1:4) = '//HK'                CSW200
                                                                                CSW200
     C                   Eval      SPos = 5                                     CSW200
     C                   Eval      EPos = 7                                     CSW200
     C                   Eval      DigLen = 3                                   CSW200
     C                   Eval      FirstBlank = 8                               CSW200
     C                   Exsr      ChkDigit                                     CSW200
                                                                                CSW200
      * Clear code //FW must not have any digits OR 9 digits
     C                   When      %Subst(ClrOrAcc:1:4) = '//FW'
      * FW : If BIC entered, then //FW no digits
      * FW : If BIC not entered, then //FW 9 digits
     C                   If        @Type = '*BIC   '
     C*  Or Customer number or shortname with valid BIC (MEBICDPD is filled)                  226083
     C                             Or  @TYPE      = '*NUMBER'                                 226083
     C                             And RetCodeIn  = '*BICFND'                                 226083
     C                             Or  @TYPE      = '*SHNAME'                                 226083
     C                             And RetCodeIn  = '*BICFND'                                 226083
     C*  Or Customer number or shortname with valid BIC (MEBICDPD is empty)                   226083
     C                             Or  @TYPE      = '*NUMBER'                                 226083
     C                             And RetCodeIn  = *blank                                    226083
     C                             Or  @TYPE      = '*SHNAME'                                 226083
     C                             And RetCodeIn  = *blank                                    226083
     C                   Eval      SPos = 5
     C                   Eval      EPos = 1
     C                   Eval      DigLen = 11
     C                   Eval      FirstBlank = 5
     C                   Exsr      ChkDigit
     C                   Else
     C                   Eval      SPos = 5
     C                   Eval      EPos = 13
     C                   Eval      DigLen = 9
     C                   Eval      FirstBlank = 14
     C                   Exsr      ChkDigit
     C                   Endif
 
      ** Clearing code //CN must be followed by 12 to 14 digits                               CSW215
                                                                                              CSW215
     C                   WHEN      %SUBST(ClrOrAcc:1:4) = '//CN'                              CSW215
     C                             AND CSW215 = 'Y'                                           CSW215
     C                   EVAL      SPos = 5                                                   CSW215
     C                   EVAL      EPos = 18                                                  CSW215
     C                   EVAL      DigLen = 14                                                CSW215
     C                   EVAL      FirstBlank = 19                                            CSW215
     C                   EVAL      OvrSt = 17                                                 CSW215
     C                   EVAL      OvrEd = 18                                                 CSW215
     C                   IF        %SUBST(ClrOrAcc:18:1) = *BLANKS                          MD034557
     C                   IF        %SUBST(ClrOrAcc:17:1) <> *BLANKS                         MD034557
     C                   EVAL      OvrSt = 18                                               MD034557
     C                   ENDIF                                                              MD034557
     C                   EVAL      OverRide = 'Y'                                             CSW215
     C                   ELSE                                                               MD034557
     C                   EVAL      OverRide = 'N'                                           MD034557
     C                   ENDIF                                                              MD034557
     C                   EXSR      ChkDigit                                                   CSW215
                                                                                              CSW215
     C                   When      @Clr='*ALL'
     C                   Select
 
      * Clear code //CP must have a 4 digit number (5 -> 8) //CP1234....
     C                   When      %Subst(ClrOrAcc:1:4) = '//CP'
     C                   Eval      SPos = 5
     C                   Eval      EPos = 8
     C                   Eval      DigLen = 0
     C                   Eval      FirstBlank = 9
     C                   Exsr      ChkDigit
 
      * Clear code //CH must have a 6 digit number //CP123456
     C                   When      %Subst(ClrOrAcc:1:4) = '//CH'
     C                   Eval      SPos = 5
     C                   Eval      EPos = 10
     C                   Eval      DigLen = 6
     C                   Eval      FirstBlank = 11
     C                   Exsr      ChkDigit
 
      * Clear code //FW must have a 9 digit number //CP123456789
     C                   When      %Subst(ClrOrAcc:1:4) = '//FW'
     C                   Eval      SPos = 5
     C                   Eval      EPos = 13
     C                   Eval      DigLen = 6
     C                   Eval      FirstBlank = 14
     C                   Exsr      ChkDigit
                                                                                CSW200
      * Clear code //RU may be followed by 0 to 9 digits.                       CSW200
     C                   When      %Subst(ClrOrAcc:1:4) = '//RU'                CSW200
                                                                                CSW200
     C                   Eval      SPos = 5                                     CSW200
     C                   Eval      EPos = 13                                    CSW200
     C                   Eval      DigLen = 9                                   CSW200
     C                   Eval      FirstBlank = 14                              CSW200
     C                   Eval      OvrSt = 5                                    CSW200
     C                   Eval      OvrEd = 13                                   CSW200
     C                   Eval      OverRide = 'Y'                               CSW200
     C                   Exsr      ChkDigit                                     CSW200
                                                                                CSW200
      ** Clearing code //GR must be followed by exactly 7 digits                              CSW202
                                                                                              CSW202
     C                   WHEN      %SUBST(ClrOrAcc:1:4) = '//GR'                              CSW202
     C                   EVAL      SPos = 5                                                   CSW202
     C                   EVAL      EPos = 11                                                  CSW202
     C                   EVAL      DigLen = 7                                                 CSW202
     C                   EVAL      FirstBlank = 12                                            CSW202
     C                   EXSR      ChkDigit                                                   CSW202
                                                                                              CSW202
      ** Clearing code //IN must be followed by exactly                                       CSW202
      ** 11 uppercase alphanumeric characters.                                                CSW202
                                                                                              CSW202
     C                   WHEN      %SUBST(ClrOrAcc:1:4) = '//IN'                              CSW202
     C                   EVAL      SPos = 5                                                   CSW202
     C                   EVAL      EPos = 15                                                  CSW202
     C                   EVAL      DigLen = 11                                                CSW202
     C                   EVAL      FirstBlank = 16                                            CSW202
     C                   EXSR      ChkALPHAN                                                  CSW202
                                                                                              CSW202
     C                   Endsl
 
     C                   Endsl
 
     C                   Endsr
                                                                                              CSW202
      *****************************************************************                       CSW202
      /EJECT                                                                                  CSW202
      *****************************************************************                       CSW202
      * ChkALPHAN : Check uppercase alphanumeric characters           *                       CSW202
      *****************************************************************                       CSW202
                                                                                              CSW202
     C     ChkALPHAN     BEGSR                                                                CSW202
                                                                                              CSW202
     C                   MOVEA     ClrOrAcc      StrArr(1)                                    CSW202
     C                                                                                        CSW202
     C                   IF        OverRide = 'Y'                                             CSW202
     C                   EVAL      OverRide = 'N'                                             CSW202
     C                   DOW       OvrSt <= OvrEd                                             CSW202
     C                   MOVEA     '0'           StrArr(OvrSt)                                CSW202
     C                   EVAL      OvrSt = OvrSt + 1                                          CSW202
     C                   ENDDO                                                                CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
      ** Check that the first blank space is correct                                          CSW202
                                                                                              CSW202
     C                   IF        StrArr(FirstBlank) <> *BLANK                               CSW202
     C                   EVAL      RetCodeIn = '*DIGITERR'                                    CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
     C     SPos          DOWLE     EPos                                                       CSW202
     C     StrArr(SPos)  LOOKUP    ALPHAN(1)                              99                  CSW202
     C                   IF        *IN99 = *OFF                                               CSW202
     C                   EVAL      RetCodeIn = '*DIGITERR'                                    CSW202
     C                   LEAVE                                                                CSW202
     C                   ENDIF                                                                CSW202
     C                   EVAL      SPos = SPos + 1                                            CSW202
     C                   ENDDO                                                                CSW202
                                                                                              CSW202
      ** Now ensure that the remaining characters are blank                                   CSW202
                                                                                              CSW202
     C                   EVAL      EPos = EPos + 1                                            CSW202
     C                   IF        EPos < 5                                                   CSW202
     C                   EVAL      EPos = 5                                                   CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
     C     EPos          DOWLE     35                                                         CSW202
     C                   IF        StrArr(EPos) <> *BLANK                                     CSW202
     C                   EVAL      RetCodeIn = '*BLANKERR'                                    CSW202
     C                   LEAVE                                                                CSW202
     C                   ENDIF                                                                CSW202
     C                   EVAL      EPos = EPos + 1                                            CSW202
     C                   ENDDO                                                                CSW202
                                                                                              CSW202
     C                   ENDSR                                                                CSW202
                                                                                              CSW202
      *****************************************************************                       CSW202
      /EJECT                                                                                  CSW202
      *****************************************************************
      * ChkDigit : Check that number of digits are correct            *
      *****************************************************************
     C     ChkDigit      Begsr
 
     C                   Movea     ClrOrAcc      StrArr(1)
     C
     C                   If        OverRide = 'Y'
     C                   Eval      OverRide = 'N'
     C                   Dow       OvrSt <= OvrEd
     C                   Movea     '0'           StrArr(OvrSt)
     C                   Eval      OvrSt = OvrSt + 1
     C                   Enddo
     C                   Endif
 
      * Check that the first blank space is correct
     C                   If        StrArr(FirstBlank) <> *Blank
     C                   Eval      RetCodeIn = '*DIGITERR'
     C                   Endif
 
     C     SPos          Dowle     EPos
     C     StrArr(SPos)  Lookup    ArrDig(1)                              99
     C                   If        *In99 = *Off
     C                   Eval      RetCodeIn = '*DIGITERR'
     C                   Leave
     C                   Endif
     C                   Eval      SPos = SPos + 1
     C                   Enddo
 
      * Now ensure that the remaining characters are blank
     C                   Eval      EPos = EPos + 1
     C                   If        EPos < 5
     C                   Eval      EPos = 5
     C                   Endif
 
     C     EPos          Dowle     35
     C                   If        StrArr(EPos) <> *Blank
     C                   Eval      RetCodeIn = '*BLANKERR'
     C                   Leave
     C                   Endif
     C                   Eval      EPos = EPos + 1
     C                   Enddo
 
     C                   Endsr
 
      *****************************************************************         CSW200
      * SRRT  :  Check Real Time clearing code                        *         CSW200
      *****************************************************************         CSW200
     C     SRRT          Begsr                                                  CSW200
                                                                                CSW200
      * If SWIFT 2000 not on clearing code must have no digits                  CSW200
     C                   If        CSW200 <> 'Y'                                CSW200
                                                                                CSW200
     C                   If        %Subst(ClrOrAcc:5) <> *Blanks                CSW200
     C                   Eval      RetCodeIn = '*DIGITERR'                      CSW200
     C                   EndIf                                                  CSW200
                                                                                CSW200
     C                   Else                                                   CSW200
                                                                                CSW200
      * If DDSName is not 'Account With' from an MT102 - error.                 CSW200
     C                   If        DDSName <> 'PACCI35'                         CSW200
     C                   Eval      RetCodeIn = '*INVALIDCC'                     CSW200
     C                   Return                                                 CSW200
     C                   Else                                                   CSW200
                                                                                CSW200
      * If entry in 2nd field, clearing code must have no digits...             CSW200
     C                   If        BicCSName <> *Blanks                         CSW200
     C                   If        %Subst(ClrOrAcc:5) <> *Blanks                CSW200
     C                   Eval      RetCodeIn = '*DIGITERR'                      CSW200
     C                   EndIf                                                  CSW200
                                                                                CSW200
     C                   Else                                                   CSW200
                                                                                CSW200
      * ... else no entry in 2nd field - Real Time clearing code (//RT)         CSW200
      *     may be followed by another clearing code (but not //RT):            CSW200
     C                   If        %subst(ClrOrAcc:5:4) <> '//AT'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//AU'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//BL'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//CC'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//ES'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//FW'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//IT'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//SC'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//CH'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//CP'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//SW'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//HK'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//IE'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//PT'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//NZ'    AND        CSW200
     C                             %subst(ClrOrAcc:5:4) <> '//RU'               CSW200
     C                             AND %subst(ClrOrAcc:5:4) <> '//CN'                       MD034498
                                                                                CSW200
     C                   Eval      RetCodeIn = '*INVALIDCC'                     CSW200
     C                   Return                                                 CSW200
     C                   Else                                                   CSW200
     C                   Eval      @Clr = '*ALL'                                CSW200
     C                   Exsr      @ChkClrDig2                                  CSW200
     C                   Endif                                                  CSW200
                                                                                CSW200
     C                   EndIf                                                  CSW200
      *                  * End of 'If BicCSName <> *Blanks'                     CSW200
                                                                                CSW200
     C                   EndIf                                                  CSW200
      *                  * End of 'If DDSName <> 'PACCI35''                     CSW200
                                                                                CSW200
     C                   EndIf                                                  CSW200
      *                  * End of 'If CSW200 <> 'Y''                            CSW200
                                                                                CSW200
     C                   Endsr                                                  CSW200
                                                                                CSW200
      *****************************************************************         CSW200
      * @ChkClrDig2 - Check clearing code digits for RT are correct    *        CSW200
      *****************************************************************         CSW200
     C     @ChkClrDig2   Begsr                                                  CSW200
                                                                                CSW200
     C                   Select                                                 CSW200
                                                                                CSW200
      * Clearing code //AT must be followed by 5 digits.                        CSW200
     C                   When      %Subst(ClrOrAcc:5:4) = '//AT'                CSW200
     C                   Eval      SPos = 9                                     CSW200
     C                   Eval      EPos = 13                                    CSW200
     C                   Eval      DigLen = 5                                   CSW200
     C                   Eval      FirstBlank = 14                              CSW200
     C                   Exsr      ChkDigit                                     CSW200
                                                                                CSW200
      * Clearing codes //AU, //SC, //IE & //NZ must be followed by 6 digits.    CSW200
     C                   When      %Subst(ClrOrAcc:5:4) = '//AU'    OR          CSW200
     C                             %Subst(ClrOrAcc:5:4) = '//SC'    OR          CSW200
     C                             %Subst(ClrOrAcc:5:4) = '//IE'    AND         CSW200
     C                             CSW200               = 'Y'       OR          CSW200
     C                             %Subst(ClrOrAcc:5:4) = '//NZ'    AND         CSW200
     C                             CSW200               = 'Y'       AND         CSW200
     C                             DDSName              = 'PACCI35'             CSW200
     C                   Eval      SPos = 9                                     CSW200
     C                   Eval      EPos = 14                                    CSW200
     C                   Eval      DigLen = 6                                   CSW200
     C                   Eval      FirstBlank = 15                              CSW200
     C                   Exsr      ChkDigit                                     CSW200
                                                                                CSW200
      * Clearing code //HK must be followed by 3 digits.                        CSW200
     C                   When      %Subst(ClrOrAcc:5:4) = '//HK'                CSW200
     C                   Eval      SPos = 9                                     CSW200
     C                   Eval      EPos = 11                                    CSW200
     C                   Eval      DigLen = 3                                   CSW200
     C                   Eval      FirstBlank = 12                              CSW200
     C                   Exsr      ChkDigit                                     CSW200
                                                                                CSW200
      * Clearing codes //BL and //PT must be followed by 8 digits.              CSW200
     C                   When      %Subst(ClrOrAcc:5:4) = '//BL'    OR          CSW200
     C                             %Subst(ClrOrAcc:5:4) = '//PT'    AND         CSW200
     C                             CSW200               = 'Y'                   CSW200
     C                   Eval      SPos = 9                                     CSW200
     C                   Eval      EPos = 16                                    CSW200
     C                   Eval      DigLen = 8                                   CSW200
     C                   Eval      FirstBlank = 17                              CSW200
     C                   Exsr      ChkDigit                                     CSW200
                                                                                CSW200
      * Clearing code //CC must be followed by a 9 digit number.  Code //ES     CSW200
      * must be followed by 8 to 9 digits.                                      CSW200
     C                   When      %Subst(ClrOrAcc:5:4) = '//CC'  OR            CSW200
     C                             %Subst(ClrOrAcc:5:4) = '//ES'                CSW200
                                                                                CSW200
     C                   If        %Subst(ClrOrAcc:5:4) = '//ES'                CSW200
     C                   Eval      OverRide = 'Y'                               CSW200
     C                   Eval      OvrSt    = 17                                CSW200
     C                   Eval      OvrEd    = 17                                CSW200
     C                   Endif                                                  CSW200
                                                                                CSW200
     C                   Eval      SPos = 9                                     CSW200
     C                   Eval      EPos = 17                                    CSW200
     C                   Eval      DigLen = 9                                   CSW200
     C                   Eval      FirstBlank = 18                              CSW200
     C                   Exsr      ChkDigit                                     CSW200
                                                                                CSW200
      * Clearing code //IT may be followed by 11 to 23 digits.                  CSW200
     C                   When      %Subst(ClrOrAcc:5:4) = '//IT'                CSW200
     C                   Eval      SPos = 9                                     CSW200
     C                   Eval      EPos = 19                                    CSW200
     C                   Eval      DigLen = 11                                  CSW200
     C                   Eval      FirstBlank = 32                              CSW200
     C                   Exsr      ChkDigit                                     CSW200
                                                                                CSW200
      * Clearing code //SW may be follweed by 3 to 6 digits.                    CSW200
     C                   When      %Subst(ClrOrAcc:5:4) = '//SW'                CSW200
                                                                                CSW200
     C                   Eval      SPos = 9                                     CSW200
     C                   Eval      EPos = 14                                    CSW200
     C                   Eval      DigLen = 6                                   CSW200
     C                   Eval      FirstBlank = 15                              CSW200
     C                   Eval      OverRide = 'Y'                               CSW200
     C                   Eval      OvrSt    = 12                                CSW200
     C                   Eval      OvrEd    = 14                                CSW200
     C                   Exsr      ChkDigit                                     CSW200
                                                                                CSW200
      * Clearing code //FW must be followed by exactly 9 digits if a BIC is     CSW200
      * not entered and must be followed by no characters if a BIC is input.    CSW200
     C                   When      %Subst(ClrOrAcc:5:4) = '//FW'                CSW200
                                                                                CSW200
     C                   If        @Type = '*BIC'                               CSW200
     C*  Or Customer number or shortname with valid BIC (MEBICDPD is filled)                  226083
     C                             Or  @TYPE      = '*NUMBER'                                 226083
     C                             And RetCodeIn  = '*BICFND'                                 226083
     C                             Or  @TYPE      = '*SHNAME'                                 226083
     C                             And RetCodeIn  = '*BICFND'                                 226083
     C*  Or Customer number or shortname with valid BIC (MEBICDPD is empty)                   226083
     C                             Or  @TYPE      = '*NUMBER'                                 226083
     C                             And RetCodeIn  = *blank                                    226083
     C                             Or  @TYPE      = '*SHNAME'                                 226083
     C                             And RetCodeIn  = *blank                                    226083
     C                   Eval      SPos = 9                                     CSW200
     C                   Eval      EPos = 1                                     CSW200
     C                   Eval      DigLen = 15                                  CSW200
     C                   Eval      FirstBlank = 9                               CSW200
     C                   Exsr      ChkDigit                                     CSW200
     C                   Else                                                   CSW200
     C                   Eval      SPos = 9                                     CSW200
     C                   Eval      EPos = 17                                    CSW200
     C                   Eval      DigLen = 9                                   CSW200
     C                   Eval      FirstBlank = 18                              CSW200
     C                   Exsr      ChkDigit                                     CSW200
     C                   EndIf                                                  CSW200
                                                                                CSW200
      * If a BIC has not been entered: code //CH must be followed by 6          CSW200
      * digits, code //CP must be followed by 4 digits and code //RU may        CSW200
      * be followed by 0 to 9 digits.                                           CSW200
     C                   When      @Clr = '*ALL'                                CSW200
                                                                                CSW200
     C                   Select                                                 CSW200
                                                                                CSW200
     C                   When      %Subst(ClrOrAcc:5:4) = '//CP'                CSW200
     C                   Eval      SPos = 9                                     CSW200
     C                   Eval      EPos = 12                                    CSW200
     C                   Eval      DigLen = 4                                   CSW200
     C                   Eval      FirstBlank = 13                              CSW200
     C                   Exsr      ChkDigit                                     CSW200
                                                                                CSW200
     C                   When      %Subst(ClrOrAcc:5:4) = '//CH'                CSW200
     C                   Eval      SPos = 9                                     CSW200
     C                   Eval      EPos = 14                                    CSW200
     C                   Eval      DigLen = 6                                   CSW200
     C                   Eval      FirstBlank = 15                              CSW200
     C                   Exsr      ChkDigit                                     CSW200
                                                                                CSW200
     C                   When      %Subst(ClrOrAcc:5:4) = '//RU'                CSW200
     C                   Eval      SPos = 9                                     CSW200
     C                   Eval      EPos = 17                                    CSW200
     C                   Eval      DigLen = 0                                   CSW200
     C                   Eval      FirstBlank = 18                              CSW200
     C                   Eval      OverRide = 'Y'                               CSW200
     C                   Eval      OvrSt    = 9                                 CSW200
     C                   Eval      OvrEd    = 17                                CSW200
     C                   Exsr      ChkDigit                                     CSW200
                                                                                CSW200
      ** Clearing code //CN must be followed by 12 to 14 digits                             MD034498
                                                                                            MD034498
     C                   WHEN      %SUBST(ClrOrAcc:5:4) = '//CN'                            MD034498
     C                             AND CSW215 = 'Y'                                         MD034498
     C                   EVAL      SPos = 9                                                 MD034498
     C                   EVAL      EPos = 22                                                MD034498
     C                   EVAL      DigLen = 18                                              MD034498
     C                   EVAL      FirstBlank = 23                                          MD034498
     C                   EVAL      OvrSt = 21                                               MD034498
     C                   EVAL      OvrEd = 22                                               MD034498
     C                   IF        %SUBST(ClrOrAcc:22:1) = *BLANKS                          MD034557
     C                   IF        %SUBST(ClrOrAcc:21:1) <> *BLANKS                         MD034557
     C                   EVAL      OvrSt = 22                                               MD034557
     C                   ENDIF                                                              MD034557
     C                   EVAL      OverRide = 'Y'                                           MD034498
     C                   ELSE                                                               MD034557
     C                   EVAL      OverRide = 'N'                                           MD034557
     C                   ENDIF                                                              MD034557
     C                   EXSR      ChkDigit                                                 MD034498
     C                   EndSl                                                  CSW200
                                                                                CSW200
     C                   EndSl                                                  CSW200
                                                                                CSW200
                                                                                CSW200
     C                   EndSr                                                  CSW200
                                                                                CSW200
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
     C                   Parm                    ClrOrAcc
     C                   Parm                    BicCSname
     C                   Parm                    DDSName                        CSW200
 
      * Parameter List : AOCCNTR0
     C     KlistAcc      Klist
     C                   Kfld                    P@CNUM
     C                   Kfld                    P@CUCD
     C                   Kfld                    P@ACCD
     C                   Kfld                    P@ACSQ
     C                   Kfld                    P@BRCA
 
      ** Check if SWIFT 2000 is applicable.                                     CSW200
                                                                                CSW200
     C                   CALLB     'SWIF2000'                                   CSW200
     C                   PARM      *BLANKS       RetCode7          7            CSW200
                                                                                CSW200
     C                   IF        RetCode7 <> *Blanks                          CSW200
     C                   EVAL      CSW200 = 'Y'                                 CSW200
     C                   ELSE                                                   CSW200
     C                   EVAL      CSW200 = 'N'                                 CSW200
     C                   ENDIF                                                  CSW200
                                                                                CSW200
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       PRTCD                                        CSW201
      *                                                                                       CSW201
     C                   IF        PRTCD = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW202
      ** Check if SWIFT 2002 is installed                                                     CSW202
                                                                                              CSW202
     C                   CALL      'SWIF2002'                                                 CSW202
     C                   PARM      *BLANKS       PRTCD                                        CSW202
                                                                                              CSW202
     C                   IF        PRTCD = 'CSW2002'                                          CSW202
     C                   EVAL      CSW202 = 'Y'                                               CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      CSW202 = 'N'                                               CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW206
      ** Check if SWIFT 2006 is installed                                                     CSW206
                                                                                              CSW206
     C                   CALL      'SWIF2006'                                                 CSW206
     C                   PARM      *BLANKS       PRTCD                                        CSW206
                                                                                              CSW206
     C                   IF        PRTCD = 'CSW2006'                                          CSW206
     C                   EVAL      CSW206 = 'Y'                                               CSW206
     C                   ELSE                                                                 CSW206
     C                   EVAL      CSW206 = 'N'                                               CSW206
     C                   ENDIF                                                                CSW206
      *                                                                                       CSW215
      ** Check if SWIFT 2015 enhancement is installed                                         CSW215
      *                                                                                       CSW215
     C                   CALL      'SWIF2015'                                                 CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
                                                                                              CSW215
     C                   IF        PRTCD = 'CSW2015'                                          CSW215
     C                   EVAL      CSW215 = 'Y'                                               CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      CSW215 = 'N'                                               CSW215
     C                   ENDIF                                                                CSW215
 
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  CTDATA ArrDig
0123456789
**  ALPHAN                                                                                    CSW202
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789                                                          CSW202

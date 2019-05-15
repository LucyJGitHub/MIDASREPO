     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Update EU Saving Tax Customer Position')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEETCPUPD - Update EU Saving Tax Customer Position File      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *    This program update EU Saving Tax information in ETCPOSND  *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 CSD027A            Date 05May06               *
      *                 CPK024             Date 12Apr06               *
      *                 BUG11164           Date 06Apr06               *
      *                 237063             Date 20Nov05               *
      *                 236453             Date 11Oct05               *
      *                 234711             Date 11Aug05               *
      *                 235546             Date 27Jul05               *
      *                 235045             Date 28Jul05               *
      *                 234916             Date 13Jul05               *
      *                 234829             Date 08Jul05               *
      *                 234635             Date 04Jul05               *
      *                 234599             Date 01Jul05               *
      *                 234577             Date 29Jun05               *
      *                 234552             Date 29Jun05               *
      *                 236814             Date 28Jun05               *
      *                 236813             Date 28Jun05               *
      *                 236696             Date 28Jun05               *
      *                 234440  *CREATE    Date 18Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027A - Conversion Of Customer Number to Alpha (Recompile) *
      *  CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by    *
      *           UTC0012.                                            *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  236453 - Dubble records with RECI equal 'D' on ETCPOSND when *
      *           original purchased date of walk in equal to zero    *
      *  234711 - Original purchase date in WO is incorrect.  This is *
      *           due to the WI having a wrong average purchase date. *
      *           Original purchase date should be used instead of    *
      *           the movement date for WI to derive the correct      *
      *           purchase date.                                      *
      *  235546 - EU Tax backvaluations                               *
      *           Always need to process amendments to pick up        *
      *           changes in the nominal                              *
      *  235045 - Only update file if Customer is taxable             *
      *  234916 - Incorrect Purchase Interest when change in position.*
      *  234829 - Ex-Coupon Processing when position is zero.         *
      *  234635 - Ex-Coupon Processing                                *
      *  234599 - Get effect date using location of the branch        *
      *  234577 - Rounding errors                                     *
      *           Unanotated changes. 17 x EVAL changed to EVAL(H)    *
      *           Position updating with dec places                   *
      *           Trades backvaued before transition date processing  *
      *  234552 - Incomplete trades must not update positions         *
      *           Market Indicator equal *BLANK on trade              *
      *           Backvalue pior to effective date                    *
      *           Process action code 'A' as complete indicator may   *
      *           have changed.                                       *
      *  236814 - Condition on wrong value                            *
      *  236813 - Reset Purchase Interest across coupon date          *
      *  236696 - Interest over transition date wrong                 *
      *  234440 - Purchas Interest Management                         *
      *                                                               *
      *****************************************************************
 
     FETCPOSL0  UF A E           K DISK    PREFIX(C_) COMMIT
     FETCPOSL3  UF   E           K DISK
     F                                     RENAME(ETCPOSNDF:DLCPOSNDF)
     F                                     COMMIT                                             237063
     F***SDCTTXPD  IF   E           K DISK    PREFIX(E_)                                      234599
     FINVTP     IF   E           K DISK    INFSR(*pssr) PREFIX(I_)                            234577
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
 
      ** Include the SE standard declares
     D/COPY SECPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** Array for manipulating decimal positions                                             233774
     D POWER9          S              9  4 DIM(9) CTDATA PERRCD(1)                            233774
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D CDArr                 183    230
     D CRArr                 231    242
     D ValidTrade    E DS                  EXTNAME(SEVTRADPD)
     D                                     PREFIX(T_)
     D ValidDpmv     E DS                  EXTNAME(SEVDPMVPD)
     D                                     PREFIX(D_)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * DATA STRUCTURE FOR CURRENCY DETAILS
 
      ** External DS for Branch Details                                                       234599
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  234599
                                                                                              234599
      ** External DS for Location Details                                                     234599
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  234599
                                                                                              234599
      ** External DS for Securities Clients                                                   234599
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  234599
     D                                     PREFIX(E_)                                         234599
                                                                                              234599
                                                                                              234599
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WAMT            S             15  0                                                    234577
     D IRATE           S             15  9                                                    234577
     D W_NomCcyDec     S              1  0                                                    234577
     D Tr_Type         S              1A
     D Actn_Code       S              1A
     D @BRCH           S                   LIKE(CSBA)
     D @SECN           S                   LIKE(CSSC)
     D @MKET           S                   LIKE(CSMK)
     D @CUSN           S                   LIKE(CSCN)
     D @PTFR           S                   LIKE(PTFR)
     D*@DATE****       S                   LIKE(CSDA)                                         CPK024
     D @DATE1          S                   LIKE(CSDA)                                         CPK024
     D @TMST           S                   LIKE(TMST)
      ** Timestamp for the transaction                                          CAP006
     D TimeStamp       S               Z                                        CAP006
                                                                                CAP006
     D IO_Ind          S              1  0
     D Indx            S              1  0
     D To_Do           S              1
     D Last_Pos_Date   S                   LIKE(CSDA)
     D @TREF           S                   LIKE(TREF)
     D W_CSNV          S                   LIKE(CSNV)
     D W_CSAV          S                   LIKE(CSAV)
     D W_SAPD          S                   LIKE(SAPD)
     D W_CSPI          S                   LIKE(CSPI)
     D W_APNC          S                   LIKE(APNC)
     D Tr_NOML         S                   LIKE(T_NOML)
     D Trn_APNC        S                   LIKE(APNC)
     D Pur_Int         S                   LIKE(CSPI)
     D Pur_Date        S                   LIKE(SAPD)
     D Fiscal_Num      S                   LIKE(CSAV)
     D Trn_APNC_I      S                   LIKE(APNC)
     D Pur_Int_I       S                   LIKE(CSPI)
     D Pur_Date_I      S                   LIKE(SAPD)
     D Fiscal_Num_I    S                   LIKE(CSAV)
     D Trn_APNC_O      S                   LIKE(APNC)
     D Pur_Int_O       S                   LIKE(CSPI)
     D Pur_Date_O      S                   LIKE(SAPD)
     D Fiscal_Num_O    S                   LIKE(CSAV)
     D Eff_Date        S                   LIKE(E_EWEDT1)                                     234552
     D WCNCD           S                   LIKE(E_EWCTRT)                                     234599
     D WCOLC           S                   LIKE(E_EWCTRR)                                     234599
     D Ex_Coupon       S              1A
     D TCustomer       S              6A                                                      235045
     D Taxable         S              1A                                                      235045
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
                                                                                              234577
      ** Access Nominal Currency details                                                      234577
                                                                                              234577
     C                   EXSR      ACSNOMC                                                    234577
 
      ** Initialization
 
     C************       IF        Actn_Code <> 'A' AND Actn_Code <> 'Y'                      234552
     C                   IF        Actn_Code <> 'Y'                                           234552
     C                   EVAL      To_Do = 'Y'
                                                                                              234552
     C************       IF        Actn_Code = 'A'                                            235546
     C************       EXSR      Needed_ToDo                                                235546
     C************       END                                                                  235546
 
     C                   IF        Tr_Type = 'T' AND T_TINC = 'I'                             234552
     C************       RETURN                                                               234552
     C                   EVAL      To_Do = 'N'
     C                   ENDIF                                                                234552
                                                                                              235045
     C                   IF        To_Do = 'Y'                                                235045
     C                   EXSR      SRCheckTax                                                 235045
     C                   IF        Taxable <> 'Y'                                             235045
     C                   EVAL      To_Do = 'N'                                                235045
     C                   ENDIF                                                                235045
     C                   ENDIF                                                                235045
                                                                                              234552
     C                   IF        To_Do = 'Y'
 
     C                   IF        Actn_Code <> 'I'
     C                   EXSR      Del_Record
     C                   ENDIF
 
     C                   EXSR      Up_Last_Rec
 
     C                   IF        Actn_Code <> 'D'
     C                   EXSR      Add_Record
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
      ** Return
 
     C                   SETON                                        LR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Needed_ToDo - Check if the record need to be process          *
      *****************************************************************
     C     Needed_ToDo   BEGSR
 
     C                   IF        Tr_Type = 'D'
     C                   EVAL      @TREF = D_DPRN
     C                   ELSE
     C                   EVAL      @TREF = T_TDRF
     C                   ENDIF
 
     C     CPKey1        CHAIN     ETCPOSL3                           89
     C                   IF        *IN89 = '0'
     C                   EVAL      To_Do = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  235045
      *****************************************************************                       235045
      * SRCheckTax  - Check if Customer is taxable                    *                       235045
      *****************************************************************                       235045
     C     SRCheckTax    BEGSR                                                                235045
                                                                                              235045
     C                   IF        Tr_Type = 'D'                                              235045
     C                   MOVE      D_DPBN        TCustomer                                    235045
     C                   ELSE                                                                 235045
     C                   MOVE      T_TCNR        TCustomer                                    235045
     C                   ENDIF                                                                235045
                                                                                              235045
     C                   CALL      'SECHECKTAX'                                               235045
     C                   PARM                    RetCodeIn                                    235045
     C                   PARM                    TCustomer                                    235045
                                                                                              235045
     C                   PARM                    Taxable                                      235045
                                                                                              235045
     C                   ENDSR                                                                235045
      *****************************************************************                       235045
     C/EJECT
      *****************************************************************
      * Del_Record - Delete Record from ETCPOSND                      *
      *****************************************************************
     C     Del_Record    BEGSR
 
     C                   IF        Tr_Type = 'D'
     C                   EVAL      @TREF = D_DPRN
     C                   ELSE
     C                   EVAL      @TREF = T_TDRF
     C                   ENDIF
 
     C     CPKey1        CHAIN     ETCPOSL3                           89
     C                   IF        *IN89 = '0'
     C                   DELETE    DLCPOSNDF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Up_Last_Rec - Get the position record and update Status       *
      *****************************************************************
     C     Up_Last_Rec   BEGSR
 
     C                   EVAL      Eff_Date = 0                                               234577
                                                                                              234577
     C                   IF        Tr_Type = 'D'
     C                   EVAL      @BRCH = D_DPBA
     C                   EVAL      @SECN = D_DPSS
     C                   EVAL      @MKET = D_DPMK
     C************       IF        @MKET = ' '                                                234552
     C************       EVAL      @MKET = MKTI                                               234552
     C************       ENDIF                                                                234552
     C                   EVAL      @CUSN = D_DPBN
     C                   EVAL      @PTFR = D_PTFR
     C                   ELSE
     C                   EVAL      @BRCH = T_TDBA
     C                   EVAL      @SECN = T_TDSS
     C                   EVAL      @MKET = T_TDMI
     C                   EVAL      @CUSN = T_TCNR
     C                   EVAL      @PTFR = T_PTFR
     C                   ENDIF
 
     C                   IF        @MKET = ' '                                                234552
     C                   EVAL      @MKET = MKTI                                               234552
     C                   ENDIF                                                                234552
     C                   EVAL      @TMST = *HIVAL
     C**********         EVAL      @DATE = *HIVAL                                             CPK024
     C                   EVAL      @DATE1 = *HIVAL                                            CPK024
     C                   EVAL      W_CSNV = 0
     C                   EVAL      W_CSAV = 0
     C                   EVAL      W_SAPD = 0
     C                   EVAL      W_CSPI = 0
 
     C     CPKey2        SETGT     ETCPOSL0
     C     CPKey3        READPE    ETCPOSL0                               89
     C                   IF        *IN89 = '0'
     C                   EVAL      W_CSNV = C_CSNV
     C                   EVAL      W_CSAV = C_CSAV
     C                   EVAL      W_SAPD = C_SAPD
     C                   EVAL      W_APNC = C_APNC
     C                   EVAL      W_CSPI = C_CSPI
 
     C                   EVAL      Last_Pos_Date = C_CSDA
     C                   IF        Actn_Code = 'D'
     C                   EVAL      C_RECI = 'D'
     C                   ELSE
     C                   EVAL      C_RECI = 'H'
     C                   ENDIF
 
     C                   UPDATE    ETCPOSNDF
 
     C                   IF        C_TTYPE = 'O'                                              234577
     C                   EVAL      Eff_Date = C_CSDA                                          234552
     C                   ENDIF                                                                234577
                                                                                              234577
     C                   ELSE                                                                 234552
                                                                                              234577
      ** If there is not opening record with effective date                                   234599
      ** Then get effective date                                                              234599
     C************       READ      SDCTTXPD                               89           234552 234599
     C                   EXSR      SRGetEffD                                                  234599
     C                   EVAL      Eff_Date = E_EWEDT1                                        234552
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  234599
      *****************************************************************                       234599
      *                                                               *                       234599
      * SRGetEffD - Get effect Date                                   *                       234599
      *                                                               *                       234599
      *****************************************************************                       234599
                                                                                              234599
     C     SRGetEffD     BEGSR                                                                234599
                                                                                              234599
     C                   CALLB     'AOBRCHR0'                                                 234599
     C                   PARM      *BLANKS       @RTCD                                        234599
     C                   PARM      '*KEY   '     @OPTN                                        234599
     C                   PARM                    @BRCH                                        234599
     C     SDBRCH        PARM      SDBRCH        DSFDY                                        234599
                                                                                              234599
     C     @RTCD         IFNE      *BLANKS                                                    234599
     C                   EVAL      DBKEY = @BRCH                                              234599
     C                   EVAL      DBFILE = 'SDBRCHPD'                                        234599
     C                   EVAL      DBASE = 3                                                  234599
     C                   EXSR      *PSSR                                                      234599
     C                   ENDIF                                                                234599
                                                                                              234599
     C                   MOVEL     A8LCCD        @LCCD             3                          234599
     C                   CALL      'AOLOCNR0'                                                 234599
     C                   PARM      *BLANKS       @RTCD                                        234599
     C                   PARM      '*KEY   '     @OPTN                                        234599
     C                   PARM                    @LCCD                                        234599
     C     SDLOCN        PARM      SDLOCN        DSFDY                                        234599
                                                                                              234599
     C     @RTCD         IFNE      *BLANKS                                                    234599
     C                   EVAL      DBKEY = A8LCCD                                             234599
     C                   EVAL      DBFILE = 'SDLOCNPD'                                        234599
     C                   EVAL      DBASE = 4                                                  234599
     C                   EXSR      *PSSR                                                      234599
     C                   ENDIF                                                                234599
                                                                                              234599
      ** Get Effect Date                                                                      234599
                                                                                              234599
     C                   EVAL      WCNCD = DVCNCD                                             234599
     C                   EVAL      WCOLC = DVCNCD                                             234599
                                                                                              234599
     C                   CALL      'AOCTTXR0'                                                 234599
     C                   PARM      *BLANKS       @RTCD                                        234599
     C                   PARM      '*KEY   '     @OPTN                                        234599
     C                   PARM      WCNCD         @PCTRT            2                          234599
     C                   PARM      WCOLC         @PCTRR            2                          234599
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        234599
                                                                                              234599
     C                   IF        @RTCD = '*NRF   '                                          234599
                                                                                              234599
     C                   EVAL      WCOLC = *BLANK                                             234599
     C                   CALL      'AOCTTXR0'                                                 234599
     C                   PARM      *BLANKS       @RTCD                                        234599
     C                   PARM      '*KEY   '     @OPTN                                        234599
     C                   PARM      WCNCD         @PCTRT                                       234599
     C                   PARM      WCOLC         @PCTRR                                       234599
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        234599
                                                                                              234599
      ** Database Error                                                                       234599
                                                                                              234599
     C     @RTCD         IFNE      *BLANK                                                     234599
     C                   EVAL      DBKEY = @PCTRT + ' ' + @PCTRR                              234599
     C                   EVAL      DBFILE = 'SDCTTXPD'                                        234599
     C                   EVAL      DBASE = 6                                                  234599
     C                   EXSR      *PSSR                                                      234599
     C                   ENDIF                                                                234599
     C                   ENDIF                                                                234599
                                                                                              234599
     C                   ENDSR                                                                234599
      *****************************************************************                       234599
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRZLCD - Compute Last Coupon Date                             *
      *                                                               *
      *****************************************************************
 
     C     SRZLCD        BEGSR
 
     C                   CALLB     'ZLCD'
     C                   PARM                    ISSD
     C                   PARM                    ITLD
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    LCPN                                       BUG11164
      *
      ** Event Control Date
      ** Date Format
     C                   PARM                    ZECD              5 0
     C                   PARM                    BJDFIN
                                                                                              CSE005
      ** Nominal Currency                                                                     CSE005
      ** Security Investment Type                                                             CSE005
      ** Effect on Holidays on Coupon Dates                                                   CSE005
     C                   PARM                    NMCY                                         CSE005
     C                   PARM                    SITP                                         CSE005
     C                   PARM                    BCNV                                         CSE005
     C                   PARM                    HCY1                                         237063
     C                   PARM                    HCY2                                         237063
     C                   PARM                    HCY3                                         237063
     C                   PARM                    HCY4                                         237063
     C                   PARM                    HCY5                                         237063
     C                   PARM                    HCY6                                         237063
     C                   PARM                    HCY7                                         237063
     C                   PARM                    HCY8                                         237063
     C                   PARM                    HCY9                                         237063
 
      * OUTPUTS
      ** Last Coupon Date before Control Date
     C                   PARM                    ZZLCD             5 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Add_Record - Add Record to ETCPOSND                           *
      *****************************************************************
     C     Add_Record    BEGSR
 
     C                   EVAL      C_RECI = 'D'
 
     C                   IF        Tr_Type = 'D'
     C                   EXSR      Setup_Dpmv
     C                   ELSE
     C                   EXSR      Setup_Trad
     C                   ENDIF
 
     C                   EVAL      ZECD = C_CSDA
     C                   EXSR      SRZLCD
     C                   IF        ZZLCD > Last_Pos_Date
     C                   EVAL      W_CSPI = 0
     C                   ENDIF
 
     C                   IF        C_CSNV > 0 AND W_CSNV >0
     C                   IF        IO_Ind = 1
     C                   EVAL      Pur_Int = Pur_Int_I
     C                   EVAL      Pur_Date = Pur_Date_I
     C                   EVAL      Fiscal_Num = Fiscal_Num_I
     C                   EVAL      Trn_APNC = Trn_APNC_I
     C                   ELSE
                                                                                              236813
     C                   IF        ZZLCD > Last_Pos_Date                                      236813
     C                   EVAL      Pur_Int = 0                                                236813
     C                   ELSE                                                                 236813
     C                   EVAL      Pur_Int = Pur_Int_O
     C                   END                                                                  236813
                                                                                              236813
     C                   EVAL      Pur_Date = Pur_Date_O
     C                   EVAL      Fiscal_Num = Fiscal_Num_O
     C                   EVAL      Trn_APNC = Trn_APNC_O
     C                   END
     C                   ENDIF
 
     C                   IF        C_CSNV < 0 AND W_CSNV < 0
     C*****************  IF        IO_Ind = 0
     C                   IF        IO_Ind = -1
     C                   EVAL      Pur_Int = Pur_Int_I
     C                   EVAL      Pur_Date = Pur_Date_I
     C                   EVAL      Fiscal_Num = Fiscal_Num_I
     C                   EVAL      Trn_APNC = Trn_APNC_I
     C                   ELSE
     C                   IF        ZZLCD > Last_Pos_Date                                      236813
     C                   EVAL      Pur_Int = 0                                                236813
     C                   ELSE                                                                 236813
     C                   EVAL      Pur_Int = Pur_Int_O
     C                   END                                                                  236813
     C                   EVAL      Pur_Date = Pur_Date_O
     C                   EVAL      Fiscal_Num = Fiscal_Num_O
     C                   EVAL      Trn_APNC = Trn_APNC_O
     C                   END
     C                   ENDIF
 
     C                   IF        ( C_CSNV > 0 AND W_CSNV <= 0 ) OR
     C                             ( C_CSNV < 0 AND W_CSNV >= 0 )
     C                   EVAL(H)   Pur_Int = Pur_Int_I * C_CSNV / Tr_NOML
     C                   EVAL      Pur_Date = Pur_Date_I * C_CSNV /
     C                                           Tr_NOML
     C                   EVAL(H)   Fiscal_Num = Fiscal_Num_I * C_CSNV /
     C                                           Tr_NOML
     C                   EVAL(H)   Trn_APNC = Trn_APNC_I * C_CSNV /
     C                                                  Tr_NOML
     C                   EVAL      W_CSAV = 0
     C                   EVAL      W_SAPD = 0
     C**************     EVAL      W_CSPI = 0                                                 234916
     C                   EVAL      W_APNC = 0
     C                   ENDIF
 
      ** For transaction with value pior to effective date                                    234552
      ** the transaction date is equal to effective date                                      234552
                                                                                              234552
     C                   IF        C_CSDA < Eff_Date                                          234552
     C                   EVAL      C_CSDA = Eff_Date                                          234552
     C                   END                                                                  234552
                                                                                              234635
     C                   IF        Ex_Coupon = 'X'                                            234635
                                                                                              234635
     C                   IF        Tr_Type = 'D' OR                                           234635
     C                             Tr_Type = 'T' AND T_TDTP = 'TS'                            234635
     C                   EVAL      Pur_Int = 0                                                234635
     C                   ENDIF                                                                234635
                                                                                              234635
     C                   IF        Tr_Type = 'T' AND T_TDTP = 'TP'                            234635
     C                   EVAL      Pur_Int = Pur_Int_I                                        234635
     C                   ENDIF                                                                234635
                                                                                              234635
     C                   ENDIF                                                                234635
                                                                                              234552
     C                   IF        C_CSNV <> 0
     C                   EVAL      C_CSAV = W_CSAV +
     C                                    (Fiscal_Num * IO_Ind)
     C                   EVAL      C_SAPD = W_SAPD +
     C                                    (Pur_Date * IO_Ind)
     C                   EVAL      C_CSPI = W_CSPI + (Pur_Int * IO_Ind)
     C                   EVAL      C_APNC = W_APNC + (Trn_APNC * IO_Ind)
     C**********         EVAL      C_AVFP = C_CSAV / C_CSNV                                   236696
     C                   EVAL      C_APDT = C_SAPD / C_CSNV
     C                   EVAL      Indx = 5 - NMDP + A6NBDP
     C                   EVAL(H)   C_LAVP = (C_APNC / C_CSNV )
     C                                      / POWER9(Indx)
     C                   EVAL(H)   C_AVFP = (C_CSAV / C_CSNV )                                236696
     C                                      / POWER9(Indx)                                    236696
     C                   IF        SPBS = 'P'
     C                   EVAL      C_LAVP = C_LAVP * 100
     C                   EVAL      C_AVFP = C_AVFP * 100                                      236696
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      C_CSAV = 0
     C                   EVAL      C_SAPD = 0
                                                                                              234829
     C                   IF        Ex_Coupon = 'X'                                            234829
     C                   EVAL      C_CSPI = W_CSPI + (Pur_Int * IO_Ind)                       234829
     C                   ELSE                                                                 234829
     C                   EVAL      C_CSPI = 0
     C                   ENDIF                                                                234829
                                                                                              234829
     C                   EVAL      C_APNC = 0
     C                   EVAL      C_AVFP = 0
     C                   EVAL      C_APDT = 0
     C                   EVAL      C_LAVP = 0
     C                   ENDIF
 
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
     C                   EVAL      C_TMST  = TimeStamp                          CAP006
                                                                                CAP006
     C                   WRITE     ETCPOSNDF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Setup_Dpmv - Setup field using details from DPTMVD (WI/WO)   *
      *****************************************************************
     C     Setup_Dpmv    BEGSR
 
     C                   EVAL      C_CSBA = D_DPBA
     C                   EVAL      C_CSSC = D_DPSS
     C                   EVAL      C_CSMK = D_DPMK
     C                   EVAL      Ex_Coupon = D_DPIN
     C                   IF        C_CSMK = ' '
     C                   EVAL      C_CSMK = MKTI
     C                   ENDIF
     C                   EVAL      C_CSCN = D_DPBN
     C                   EVAL      C_PTFR = D_PTFR
     C                   EVAL      C_TTYPE = 'D'
     C                   EVAL      C_TREF = D_DPRN
 
     C                   IF        D_DPMV = 'WI'
     C**********         EVAL      C_CSDA = D_DPMD                                            234711
     C     D_OPDT        IFNE      *ZERO                                                      236453
     C                   EVAL      C_CSDA = D_OPDT                                            234711
     C                   ELSE                                                                 236453
     C                   EVAL      C_CSDA = D_DPMD                                            236453
     C                   ENDIF                                                                236453
     C                   EVAL      IO_Ind = 1
     C                   ELSE
     C                   EVAL      C_CSDA = D_DPDO
     C                   EVAL      IO_Ind = -1
     C                   END
 
     C                   IF        C_CSDA < Eff_Date                                          234577
     C                             AND CPNR <> 0                                              234577
     C                   EVAL      WAMT = D_DPNA                                              234577
     C                   EXSR      CALINT                                                     234577
     C                   EVAL      Pur_Int_I = ZZACINT1                                       234577
     C                   ELSE                                                                 234577
     C                   EVAL      Pur_Int_I = D_OPIN
     C                   END                                                                  234577
     C                   EVAL      Pur_Date_I = C_CSDA * D_DPNA
     C                   EVAL      Indx = 5 - NMDP + A6NBDP
     C                   EVAL(H)   Fiscal_Num_I = D_FSPP * D_DPNA *
     C                                          POWER9(Indx)
     C                   EVAL(H)   Trn_APNC_I = D_MKTP * D_DPNA *
     C                                          POWER9(Indx)
     C                   IF        SPBS = 'P'
     C                   EVAL(H)   Fiscal_Num_I = Fiscal_Num_I/100
     C                   EVAL(H)   Trn_APNC_I = Trn_APNC_I/100
     C                   ENDIF
     C                   IF        W_CSNV <> 0
     C                   EVAL(H)   Pur_Int_O = W_CSPI * D_DPNA / W_CSNV
     C                   EVAL      Pur_Date_O = W_SAPD * D_DPNA / W_CSNV
     C                   EVAL(H)   Fiscal_Num_O = W_CSAV * D_DPNA / W_CSNV
     C                   EVAL(H)   Trn_APNC_O = W_APNC * D_DPNA / W_CSNV
     C                   ELSE
     C                   EVAL      Pur_Int_O = 0
     C                   EVAL      Pur_Date_O = 0
     C                   EVAL      Fiscal_Num_O = Fiscal_Num_I
     C                   EVAL      Trn_APNC_O = Trn_APNC_O
     C                   ENDIF
 
     C                   EVAL      Tr_Noml = D_DPNA * IO_Ind
     C                   EVAL      C_CSNV = W_CSNV + (D_DPNA * IO_Ind)
 
     C                   IF        D_DPMV = 'WI'                                              236453
     C                   EVAL      C_CSDA = D_DPMD                                            236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Setup_Trad - Setup field using details from TRADSD (TS/TP)   *
      *****************************************************************
     C     Setup_Trad    BEGSR
 
     C                   EVAL      C_CSBA = T_TDBA
     C                   EVAL      C_CSSC = T_TDSS
     C                   EVAL      C_CSMK = T_TDMI
     C                   EVAL      C_CSCN = T_TCNR
     C                   EVAL      C_PTFR = T_PTFR
     C                   EVAL      C_CSDA = T_TDVD
     C                   EVAL      C_TTYPE = 'T'
     C                   EVAL      C_TREF = T_TDRF
     C                   EVAL      Ex_Coupon = T_ACIN                                         234635
 
     C                   IF        T_TDTP = 'TS'
     C                   EVAL      IO_Ind = 1
     C                   ELSE
     C                   EVAL      IO_Ind = -1
     C                   ENDIF
 
     C                   IF        C_CSDA < Eff_Date                                          234577
     C                             AND CPNR <> 0                                              234577
     C                   EVAL      WAMT = T_NOML                                              234577
     C                   EXSR      CALINT                                                     234577
     C                   EVAL      Pur_Int_I = ZZACINT1                                       234577
     C                   ELSE                                                                 234577
     C                   EVAL      Pur_Int_I = T_ITRA
     C                   END                                                                  234577
     C                   EVAL      Pur_Date_I = C_CSDA * T_NOML
     C**********         EVAL      Fiscal_Num_I = T_FSPP * T_NOML                             236696
     C                   EVAL      Indx = 5 - NMDP + A6NBDP                                   236696
     C                   EVAL(H)   Fiscal_Num_I = T_FSPP * T_NOML *                           236696
     C                                          POWER9(Indx)                                  236696
     C                   IF        SPBS = 'P'                                                 236696
     C                   EVAL(H)   Fiscal_Num_I = Fiscal_Num_I/100                            236696
     C                   ENDIF                                                                236696
     C                   EVAL      Trn_APNC_I = T_TCSR
 
     C                   IF        W_CSNV <> 0
     C                   EVAL(H)   Pur_Int_O = W_CSPI * T_NOML / W_CSNV
     C                   EVAL      Pur_Date_O = W_SAPD * T_NOML / W_CSNV
     C                   EVAL(H)   Fiscal_Num_O = W_CSAV * T_NOML / W_CSNV
     C                   EVAL(H)   Trn_APNC_O = W_APNC * T_NOML / W_CSNV
     C                   ELSE
     C                   EVAL      Pur_Int_O = 0
     C                   EVAL      Pur_Date_O = 0
     C                   EVAL      Fiscal_Num_O = Fiscal_Num_I
     C                   EVAL      Trn_APNC_O = Trn_APNC_I
     C                   ENDIF
 
     C                   EVAL      Tr_Noml = T_NOML * IO_Ind
     C                   EVAL      C_CSNV = W_CSNV + (T_NOML * IO_Ind)
 
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  234577
      *****************************************************************                       234577
      * Calculate interest as at transition date                      *                       234577
      *****************************************************************                       234577
     C     CALINT        BEGSR                                                                234577
     C     KLINVT        KLIST                                                                234577
     C                   KFLD                    NMCY                                         234577
     C                   KFLD                    SITP                                         234577
     C     KLINVT        CHAIN     INVTPDF                            99                      234577
      *                                                                                       234577
      ** Last coupon date                                                                     234577
                                                                                              234577
     C                   CALLB     'ZLCD'                                                     234577
     C                   PARM                    ISSD                                         234577
     C                   PARM                    ITLD                                         234577
     C                   PARM                    FCPN                                         234577
     C                   PARM                    MATY                                         234577
     C                   PARM                    CDArr                                        234577
     C                   PARM                    CRArr                                        234577
     C                   PARM                    LCPN                                       BUG11164
     C                   PARM                    Eff_Date                                     234577
     C                   PARM                    BJDFIN                                       234577
     C                   PARM                    NMCY                                         234577
     C                   PARM                    SITP                                         234577
     C                   PARM                    BCNV                                         234577
     C                   PARM                    HCY1                                         237063
     C                   PARM                    HCY2                                         237063
     C                   PARM                    HCY3                                         237063
     C                   PARM                    HCY4                                         237063
     C                   PARM                    HCY5                                         237063
     C                   PARM                    HCY6                                         237063
     C                   PARM                    HCY7                                         237063
     C                   PARM                    HCY8                                         237063
     C                   PARM                    HCY9                                         237063
     C                   PARM                    ZZLCD             5 0                        234577
                                                                                              234577
      ** Next coupon date                                                                     234577
                                                                                              234577
     C                   CALLB     'ZNCD'                                                     234577
     C                   PARM                    ITLD                                         234577
     C                   PARM                    FCPN                                         234577
     C                   PARM                    MATY                                         234577
     C                   PARM                    CDArr                                        234577
     C                   PARM                    CRArr                                        234577
     C                   PARM                    Eff_Date                                     234577
     C                   PARM                    BJDFIN                                       234577
     C                   PARM                    NMCY                                         234577
     C                   PARM                    SITP                                         234577
     C                   PARM                    BCNV                                         234577
     C                   PARM                    ZZLCD             5 0                        234577
     C                   PARM                    HCY1                                         237063
     C                   PARM                    HCY2                                         237063
     C                   PARM                    HCY3                                         237063
     C                   PARM                    HCY4                                         237063
     C                   PARM                    HCY5                                         237063
     C                   PARM                    HCY6                                         237063
     C                   PARM                    HCY7                                         237063
     C                   PARM                    HCY8                                         237063
     C                   PARM                    HCY9                                         237063
     C                   PARM                    ZZNCD             5 0                        234577
                                                                                              234577
      ** Accrued coupon                                                                       234577
                                                                                              234577
     C                   EVAL      IRATE = CPNR                                               234577
     C                   MOVE      A6NBDP        W_NomCcyDec                                  234577
                                                                                              234577
     C                   CALLB     'ZACCR'                                                    234577
     C                   PARM                    WAMT                                         234577
     C                   PARM                    IRATE                                        234577
     C                   PARM                    ZZLCD                                        234577
     C                   PARM                    Eff_Date                                     234577
     C                   PARM                    SECTY                                        234577
     C                   PARM                    IADJ                                         234577
     C                   PARM                    ZZNCD                                        234577
     C                   PARM                    W_NomCcyDec                                  234577
     C                   PARM                    I_PROT                                       234577
     C                   PARM                    BJDFIN                                       234577
                                                                                              234577
      ** Output                                                                               234577
                                                                                              234577
     C                   PARM                    ZZACINT1         15 0                        234577
     C                   PARM                    ZZACINT2         15 1                        234577
     C                   PARM                    ZRP               1                          234577
     C                   PARM                    NODAYS1           5 0                        234577
     C                   PARM                    NODAYS2           5 0                        234577
     C                   ENDSR                                                                234577
      *****************************************************************                       234577
     C/EJECT                                                                                  234577
      *****************************************************************                       234577
      * Access Nominal Currency Details                               *                       234577
      *****************************************************************                       234577
     C     ACSNOMC       BEGSR                                                                234577
     C                   CALL      'AOCURRR0'                                                 234577
     C                   PARM      *BLANKS       @RTCD                                        234577
     C                   PARM      '*KEY   '     @OPTN                                        234577
     C                   PARM      NMCY          @CURR             3                          234577
     C     SDCURR        PARM      SDCURR        DSSDY                                        234577
                                                                                              234577
      ** Database error.                                                                      234577
                                                                                              234577
     C                   IF        @RTCD <> *BLANKS                                           234577
     C                   EVAL      DBKEY = @CURR                                              234577
     C                   EVAL      DBFILE = 'SDCURRPD'                                        234577
     C                   MOVEL     '915'         DBASE                                        234577
     C                   EXSR      *PSSR                                                      234577
     C                   ENDIF                                                                234577
     C                   ENDSR                                                                234577
      *****************************************************************                       234577
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
 
     C                   PARM                    RetCodeIn
     C                   PARM                    Actn_Code
     C                   PARM                    Tr_Type
     C                   PARM                    ValidTrade
     C                   PARM                    ValidDpmv
     C                   PARM                    SECTY
 
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
 
     C*******************CALL      'AOCURRR0'                                                 234577
     C*******************PARM      *BLANKS       @RTCD                                        234577
     C*******************PARM      '*KEY   '     @OPTN                                        234577
     C*******************PARM      NMCY          @CURR             3                          234577
     C*****SDCURR********PARM      SDCURR        DSSDY                                        234577
      ********************                                                                    234577
      ***Database*error.                                                                      234577
      *******************                                                                     234577
     C*******************IF        @RTCD <> *BLANKS                                           234577
     C*******************EVAL      DBKEY = @CURR                                              234577
     C*******************EVAL      DBFILE = 'SDCURRPD'                                        234577
     C*******************MOVEL     '915'         DBASE                                        234577
     C*******************EXSR      *PSSR                                                      234577
     C*******************ENDIF                                                                234577
      *
      ** Define key list for file
 
     C     CPKey1        KLIST
     C                   KFLD                    Tr_Type
     C                   KFLD                    @TREF
 
     C     CPKey2        KLIST
     C                   KFLD                    @BRCH
     C                   KFLD                    @CUSN
     C                   KFLD                    @SECN
     C                   KFLD                    @MKET
     C                   KFLD                    @PTFR
     C**********         KFLD                    @Date                                        CPK024
     C                   KFLD                    @Date1                                       CPK024
     C                   KFLD                    @TMST
 
     C     CPKey3        KLIST
     C                   KFLD                    @BRCH
     C                   KFLD                    @CUSN
     C                   KFLD                    @SECN
     C                   KFLD                    @MKET
     C                   KFLD                    @PTFR
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2005
**  POWER9 - ARRAY OF POWERS FOR CURRENCY CONVERSION                                          233774
000000001                                                                                     233774
000000010                                                                                     233774
000000100                                                                                     233774
000001000                                                                                     233774
000010000                                                                                     233774
000100000                                                                                     233774
001000000                                                                                     233774
010000000                                                                                     233774
100000000                                                                                     233774

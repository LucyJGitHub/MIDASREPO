     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL FATCA Year End High Value Review')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GL000622 - Midas GL FATCA Year End High Value Review         *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CGL177             Date 11Jan16               *
      *  Prev Amend No. CGL157             Date 15Jan16               *
      *                 MD046248           Date 27Oct17               *
      *                 MD045218           Date 17Apr17               *
      *                 MD044423           Date 01Mar17               *
      *                 MD043973           Date 03Feb17               *
      *                 MD043635           Date 18Jan17               *
      *                 MD043065           Date 12Dec16               *
      *                 MD042920           Date 06Dec16               *
      *                 CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  CGL157 - CRS Reporting                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD045218 - Account Review is not displayed in listview       *
      *  MD044423 - FATCA Classification Date is not updated when     *
      *             FATCA Classification is changed by FATCA EOY      *
      *  MD043973 - FATCA Account closed file entries are not         *
      *             transferred to FATCA EOY archive file (Recompile) *
      *  MD043635 - GLC000620 00002 failed during COB                 *
      *  MD043065 - Could not find record error is displayed          *
      *  MD042920 - GLC000620 00002 failed during COB                 *
      *  CGL154 - FATCA Reporting                                     *
      *                                                               *
      *****************************************************************
 
      ** Midas SD FATCA Customers
     FSDFTCSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F_)
     F                                     RENAME(SDFTCSD0:SDFTCSD1)
 
      ** Midas SD FATCA Customers
     FSDFTCSL7  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A_)
 
      ** Midas SD FATCA Non Account Holder
     FSDFTNHL7  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(B_)
                                                                                              CGL157
      ** Midas SD CRS Customers                                                               CGL157
     FSDCRSHL0  IF   E           K DISK    INFSR(*PSSR)                                       CGL157
     F                                     PREFIX(C_)                                         CGL157
                                                                                              CGL157
      ** Midas SD CRS Customers                                                               CGL157
     FSDCRSHL1  UF   E           K DISK    INFSR(*PSSR)                                       CGL157
     F                                     PREFIX(E_)                                         CGL157
     F                                     RENAME(SDCRSHD0:SDCRSHD1)                          CGL157
                                                                                              CGL157
      ** Midas SD CRS Non Account Holder                                                      CGL157
     FSDCRNHL0  IF   E           K DISK    INFSR(*PSSR)                                       CGL157
     F                                     PREFIX(D_)                                         CGL157
                                                                                              CGL157
      ** Midas SD CRS Non Account Holder                                                      CGL157
     FSDCRNHL1  UF   E           K DISK    INFSR(*PSSR)                                       CGL157
     F                                     PREFIX(G_)                                         CGL157
     F                                     RENAME(SDCRNHD0:SDCRNHD1)                          CGL157
 
      ** Midas SD Joint Account Member
     FSDJACCL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(J_)
 
      ** Midas SD Joint Account Member
     FSDJACCL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(K_)
     F                                     RENAME(SDJACCD0:SDJACCD1)
 
      ** Midas GL Customer Balance Collection File
     FGLCSBAL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Account Review Details File
     FSDACRVL0  UF A E           K DISK    INFSR(*PSSR)
                                                                                            MD043065
     FSDACEXL0  O    E             DISK    INFSR(*PSSR)                                     MD043065
     F                                     PREFIX(EX)                                       MD043065
 
      ** Midas SD FATCA High Value Account Review Report
     FGL000622P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN
                                                                                              CGL157
      ** Midas SD CRS High Value Account Review Report                                        CGL157
     FGL000622P2O    E             PRINTER INFSR(*PSSR)                                       CGL157
     F                                     INFDS(SPOOL2)                                      CGL157
     F                                     USROPN                                             CGL157
 
      ** Midas SD FATCA High Value Account Review Report Audit
     FGL000622AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** System value High Value Currency
     D SysVal1         C                   'FATCAHighValueCcy'
      ** System value High Value Account
     D SysVal2         C                   'FATCAHighValAcc'
      ** System value Low Value Account (Individual)
     D SysVal3         C                   'FATCALowValAccIndiv'
      ** System value Low Value Account (Entity)
     D SysVal4         C                   'FATCALowValAccEntity'
      ** System value Account Review Default Frequency
     D SysVal5         C                   'AcRevDftFreq'
      ** System value High Value Currency                                                     CGL157
     D SysVal6         C                   'CRSHighValCCY'                                    CGL157
      ** System value High Value Account (Entity)                                             CGL157
     D SysVal7         C                   'CRSLowValAmount'                                  CGL157
      ** System value High Value Account (Individual)                                         CGL157
     D SysVal8         C                   'CRSHighValAmtInd'                                 CGL157
      ** System value Low Value Amount                                                        CGL157
     D SysVal9         C                   'CRSHighValAmtEnt'                                 CGL157
 
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for Securities Customers
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for customer details
     D SDCUSD        E DS                  EXTNAME(SDCUSTPD)
 
      ** Externally described DS for additional customer details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
 
      ** Externally described DS for fatca customer details
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
 
      ** Externally described DS for non account holder
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Externally described DS for account review
     D SDACRV        E DS                  EXTNAME(SDACRVPD)
 
      ** External DS Based On SCSARDPD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
                                                                                              CGL177
      ** External data structure for SVAL                                                     CGL177
     D SDCRSH        E DS                  EXTNAME(SDCRSHPD)                                  CGL177
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR 'BEFORE UPDATE' CUSTOMER
 
     D B_FTCSD       E DS                  EXTNAME(SDFTCSPD)
     D                                     PREFIX(B_)
     D A_FTCSD       E DS                  EXTNAME(SDFTCSPD)
     D                                     PREFIX(A_)
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR 'BEFORE UPDATE' NAHO
 
     D B_FTNHD       E DS                  EXTNAME(SDFTNHPD)
     D                                     PREFIX(B_)
     D A_FTNHD       E DS                  EXTNAME(SDFTNHPD)
     D                                     PREFIX(A_)
 
      ** File Information Data Structure for GL000622P1
 
     D Spool1          DS
     D  Sfile                 83     92
     D  Sfnum                123    124B 0
     D  Oflln1               188    189B 0
     D  Prtln1               367    368B 0
                                                                                              CGL157
     D Spool2          DS                                                                     CGL157
     D  Sfile2                83     92                                                       CGL157
     D  Sfnum2               123    124B 0                                                    CGL157
     D  Oflln2               188    189B 0                                                    CGL157
     D  Prtln2               367    368B 0                                                    CGL157
 
     D SpoolU          DS
     D  SfileU                83     92
     D  SfnumU               123    124B 0
 
     D/COPY ZACPYSRC,PSDS
 
      ** Parameter variables for AOSVALR0 string
 
     D SValK1          S             20A
     D SValK2          S             20A
     D SValK3          S             20A
     D SValK4          S             20A
     D SValK5          S             20A
     D SVal5           S            200A
     D SValK6          S             20A
     D*SVal6****       S            200A                                                      CGL157
     D SValK7          S             20A
     D*SVal7****       S            200A                                                      CGL157
     D SValK8          S             20A
     D*SVal8****       S            200A                                                      CGL157
     D SValK9          S             20A
     D*SVal9****       S            200A                                                      CGL157
     D SValK0          S             20A
     D SVal10          S            200A
 
      ** Data structure for AOSVALR0 string
 
     D SVal1           DS           200
     D  SVal13                 1      3A
     D SVal2           DS           200
     D  SVal213                1     13A
     D SVal3           DS           200
     D  SVal313                1     13A
     D SVal4           DS           200
     D  SVal413                1     13A
                                                                                              CGL157
     D SVal6           DS           200                                                       CGL157
     D  SVal63                 1      3A                                                      CGL157
     D SVal7           DS           200                                                       CGL157
     D  SVal713                1     13A                                                      CGL157
     D SVal8           DS           200                                                       CGL157
     D  SVal813                1     13A                                                      CGL157
     D SVal9           DS           200                                                       CGL157
     D  SVal913                1     13A                                                      CGL157
 
     D ZHOLDS          DS
 
      ** Data structure defined over holiday file fields
      ** Data structure has been copied from ZHOLILE
      ** and some definitions renamed due to naming conflicts
 
     D  DGCYCD                 1      3
     D  DGLCCD                 4      6
     D  DGYRNB                 7     10  0
     D  DGJDNB                11     13P 0
     D  DGDDNB                14     16P 0
     D  ZDS1                  17    202
     D  ZDS2                 203    382
     D  ZHL0                  17    382
 
      ** Parameters for access object programs
 
     D Prtcd           S              7A
     D Poptn           S              7A
     D Pkey            S              6A
     D PSard           S              6A
 
      ** Other fields used
 
     D Wrun            S              1A
     D Wetyp           S              2A
     D Wtrpt           S              6A
     D Wcccn           S              6A
     D Wdlno           S              6A
     D Wlnrf           S              6A
     D Wtnbr           S              6A
     D Wcbcd           S              6A
     D Wevent          S              7A
     D Kinst           S              5A
     D KSCDT           S              5S 0
     D KSEQN           S              3S 0
 
     D Kcust           S              6A
     D Kcustn          S              6S 0
     D Wamount         S             15S 0
     D Wccy            S              3A
 
     D Pcust           S              6A
     D PBefCUST        S           5000A
     D PAftCUST        S           5000A
     D PBefCUXC        S           5000A
     D PAftCUXC        S           5000A
     D PBefACUS        S           5000A
     D PAftACUS        S           5000A
     D PBefFTCS        S           5000A
     D PAftFTCS        S           5000A
     D PBefJACC        S           5000A
     D PAftJACC        S           5000A
     D PBefCUAH        S           5000A                                                    MD043635
     D PAftCUAH        S           5000A                                                    MD043635
     D Pacrv           S              1A
     D Pelec           S              1A
     D PBefCRSH        S           5000A                                                      CGL177
     D PAftCRSH        S           5000A                                                      CGL177
     D PBefCRSD        S           5000A                                                      CGL177
     D PAftCRSD        S           5000A                                                      CGL177
 
      ** Parameters for ZCONVZ1
 
     D Zamtci          S             15P 0
     D Zexch           S             13P 8
     D Zmd             S              1A
     D Zccyi           S              3A
     D Zccyo           S              3A
     D Zcdpi           S              1P 0
     D Zcdpo           S              1P 0
     D Zamtco          S             15P 0
     D ZHL             S              1    DIM(366)
     D ZHL1            S              1    DIM(366)
 
     D ZVARS           DS
 
      ** Data structure to define variables used in holiday subroutines
 
     D  ZIND                   1      1
     D  ZINDX                  2      4  0
     D  ZDAYNO                 5      7P 0
     D  ZDYNBR                 8     10P 0
     D  ZNRDYS                11     12  0
     D  @ZWRDY                13     14  0
 
     D  ZCCY                  15     17
     D  ZLOC                  18     20
     D  @ZWRKI                15     20
 
     D  ZSCCY                 21     23
     D  ZSLOC                 24     26
     D  ZSWEXX                27     30  0
     D  ZSJAN                 31     33P 0
     D  ZSDCM                 34     36P 0
     D  RTNCD                 37     43
     D  @ZWRKO                21     43
 
     D  ZOPTN                 44     50
     D  ZZCCY                 51     53
     D  ZZLOC                 54     56
     D  ZZDYNO                57     59P 0
     D  ZSRTN                 60     66
 
      ** Parameters for ZXRATE
 
     D Zrate1          S             13P 8
     D Zmdi1           S              1A
     D Zrate2          S             13P 8
     D Zmdi2           S              1A
     D ZrateX          S             13P 8
     D ZmdiX           S              1A
 
     D PCurr           S              3A
     D Zfield          S             16A
     D Zadec           S              1P 0
     D Zadig           S              2P 0
     D LowValInd       S             13P 0
     D LowValEnt       S             13P 0
     D HighValue       S             13P 0
     D HighValId2      S             13P 0                                                    CGL157
     D HighValEt2      S             13P 0                                                    CGL157
     D LowVale2        S             13P 0                                                    CGL157
     D Zfld15          S             15P 0
     D Zdecs           S              1P 0
     D Zecode          S              1A
     D Zout21          S             21A
     D Plowi           S             18A
     D Plowe           S             18A
     D Phigt           S             18A
     D Phvcy           S              3A
     D Phii2           S             18A                                                      CGL157
     D Phie2           S             18A                                                      CGL157
     D Plot2           S             18A                                                      CGL157
     D Phvy2           S              3A                                                      CGL157
     D WHvAM           S             15P 0
     D Wwpsta          S             15P 0
     D Wwcsty          S              1A
     D Wwclac          S              5A
     D Wwpcla          S              5A
     D Knaho           S             10A
     D PClas           S              7A
     D PCustNo         S              6A
     D PKey1           S             10A
     D PKySt           S              7A
     D Whvin           S              1A
     D Wwhvac          S              1A
     D ZalignOK        S              1A
     D RtCdScDt        S              7A
     D AcRvFreq        S              1A
     D AcRvComp        S              1A
     D AcRvScDt        S              5P 0
     D CSD092          S              1A
     D ZDATIN          S              6A
     D ZDMday          S              1A
     D ZERR            S              1A
     D WWYy            S              2A
     D WWYy1           S              2S 0
     D WWACRF          S              1A
     D CGL154          S              1A                                                      CGL157
     D CGL177          S              1A                                                      CGL157
     D WProc154        S              1A                                                      CGL157
     D WProc157        S              1A                                                      CGL157
 
      ** ZSFILE Parameters
 
     D Zseq            S              5A
     D Zenty           S              3A
     D Zserr           S              1A
     D Zsnum           S              6P 0
 
     D Difln1          S              2  0
     D Rqdln1          S              2  0
     D Difln2          S              2  0                                                    CGL157
     D Rqdln2          S              2  0                                                    CGL157
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
 
     C                   EXSR      SrCustomer
     C                   EXSR      SrNonAccntH
     C                   EXSR      SrAudit
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCustomer - This subroutine will process customer asset      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrCompute, SrCustDet                                   *
      *                                                               *
      *****************************************************************
 
     C     SrCustomer    BEGSR
 
     C                   EVAL      WProc154 = ' '                                             CGL157
     C                   EVAL      WProc157 = ' '                                             CGL157
     C                   IF        CGL154 = 'Y'                                               CGL157
     C     *LOVAL        SETLL     SDFTCSL7
     C                   READ      SDFTCSL7
 
      ** Read until a record is not found
 
     C                   DOW       NOT %EOF(SDFTCSL7)
 
     C                   EVAL      Kcust = A_FACUST
     C                   EVAL      WHvAM = 0
     C                   EVAL      B_FTCSD = A_FTCSD
     C                   EVAL      Wwcsty = A_FACSTY
     C                   EVAL      Wwclac = A_FACLAC
     C                   EVAL      Wwhvac = A_FAHVAC
     C                   EVAL      WProc154 = 'Y'                                             CGL157
 
     C                   EXSR      SrCompute
 
     C     Kcust         SETLL     SDJACCL4
     C     Kcust         READE     SDJACCL4
 
     C                   DOW       NOT %EOF(SDJACCL4)
 
     C     J_JCJANO      CHAIN     SDFTCSL1
     C                   IF        %FOUND(SDFTCSL1) AND
     C                             F_FACSTY = 'J' AND
     C                             F_FAHVAC <> 'N' AND
     C                             F_FALCTP <> 'D'
     C                   EVAL      Kcust = J_JCJANO
     C                   EVAL      A_FTCSD = B_FTCSD
     C                   EXSR      SrCompute
     C                   ENDIF
 
     C     Kcust         READE     SDJACCL4
     C                   ENDDO
 
      ** Print details of fatca customer
 
     C                   IF        A_FACLAC <> Wwclac OR
     C**********                   A_FAHVAC <> Wwhvac                                       MD043065
     C                             A_FAHVAC <> XRHVIN                                       MD043065
     C                   EXSR      SRCustDet
 
     C                   IF        A_FACLAC <> Wwclac
     C                   EVAL      A_FAPCLA = A_FACLAC
     C                   EVAL      A_FACLAC = Wwclac
     C                   EVAL      A_FACLAD = BJRDNB                                        MD044423
     C                   ENDIF
     C                   EVAL      A_FAHVAC = XRHVIN
 
     C                   UPDATE    SDFTCSD0
 
      ** Log changes to history of customer information
 
     C                   IF        CSD092 = 'Y'
     C                   IF        CGL177 = 'N'                                               CGL177
     C                   CALL      'SD009696'
     C                   PARM      A_FACUST      Pcust
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM      B_FTCSD       PBefFTCS
     C                   PARM      A_FTCSD       PAftFTCS
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH                                   MD043635
     C                   PARM      *BLANKS       PAftCUAH                                   MD043635
     C                   PARM      *BLANKS       PBefCUXC
     C                   PARM      *BLANKS       PAftCUXC
     C                   PARM      *BLANKS       Pacrv
     C                   PARM      *BLANKS       Pelec
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                                CGL177
 
      ** Generate an account review if the high value indicator is
      ** changed to high
 
     C                   IF        A_FAHVAC = 'H' AND
     C                             A_FAHVAC <> B_FAHVAC
 
     C                   EVAL      KCUST = A_FACUST
 
     C                   MOVE      BJMRDT        WWYy
     C                   EVAL      ZDATIN = '0630' + WWYy
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATIN
     C                   PARM      0             ZDAYNO
     C                   PARM      'M'           BJDFIN
     C                   PARM      ' '           ZERR
 
     C                   IF        BJRDNB <= ZDAYNO
     C                   EVAL      WWYy1 = 0
     C                   MOVE      WWYy          WWYy1
     C                   EVAL      WWYy1 = WWYy1 + 1
     C                   MOVE      WWYy1         WWYy
     C                   EVAL      ZDATIN = '0630' + WWYy
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATIN
     C                   PARM      0             ZDAYNO
     C                   PARM      'M'           BJDFIN
     C                   PARM      ' '           ZERR
     C                   ENDIF
 
     C                   EVAL      ZCCY = BJCYCD
     C                   EVAL      ZLOC = *BLANKS
 
     C                   DOU       ZIND = 'W'
 
      ** Check if holiday on currency
 
     C                   EVAL      *IN94 = '0'
     C                   EXSR      ZCHKH
 
      ** If a holiday, increment/decrement day number as required
 
     C                   IF        ZIND = 'H'
     C                   EVAL      ZDAYNO = ZDAYNO - 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      KSCDT = ZDAYNO
     C                   EVAL      KSEQN = 999
     C     KACRV         SETGT     SDACRVL0
     C                   READP     SDACRVL0
 
     C                   IF        ARCUST = KCUST AND
     C                             ARSCDT = KSCDT
     C**********         CLEAR                   SDACRV                                     MD045218
     C                   EVAL      ARSEQN = ARSEQN + 1
     C**********         CLEAR                   SDACRV                                     MD043065
     C                   ELSE
     C                   CLEAR                   SDACRV                                     MD043065
     C                   EVAL      ARSEQN = 1
     C                   ENDIF
 
     C                   EVAL      ARSCDT = KSCDT
     C                   EVAL      ARCUST = A_FACUST
     C                   EVAL      ARPURP = 'FATCA High Value +
     C                                      Account Review'
 
     C                   EVAL      ARACRF = WWACRF
     C                   EVAL      ARCOMP = 'N'
     C                   EVAL      ARMAGE = 'G'
     C                   EVAL      ARLTYP = 'I'
     C                   EVAL      ARLUSR = PSUser
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    ARTMST
 
     C                   WRITE     SDACRVD0
                                                                                            MD043065
     C                   EVAL      EXDDCUST = ARCUST                                        MD043065
     C                   EVAL      EXDDSCDF = *BLANKS                                       MD043065
     C                   MOVEL     ARSCDT        EXDDSCDF                                   MD043065
     C                   EVAL      EXDDSEQN = %TRIML(%CHAR(ARSEQN):'0')                     MD043065
     C                   EVAL      EXDDFOID = ARFOID                                        MD043065
     C                   WRITE     TSDACRVD0                                                MD043065
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      SDFTCSL7
 
     C                   ENDDO
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        CGL177 = 'Y'                                               CGL157
     C                   EVAL      WProc154 = ' '                                             CGL157
     C     *LOVAL        SETLL     SDCRSHL1                                                   CGL157
     C                   READ      SDCRSHL1                                                   CGL157
                                                                                              CGL157
      ** Read until a record is not found                                                     CGL157
                                                                                              CGL157
     C                   DOW       NOT %EOF(SDCRSHL1)                                         CGL157
     C                   IF        E_CRTYPE <> 'F'                                            CGL157
     C                             AND E_CRTYPE <> ' '                                        CGL157
     C                             AND E_CRHVAL <> 'N'                                        CGL157
                                                                                              CGL157
     C                   EVAL      PBefCRSH = SDCRSH                                          CGL177
     C                   EVAL      Kcust = E_CRCUST                                           CGL157
     C                   EVAL      WHvAM = 0                                                  CGL157
     C***********        EVAL      B_FTCSD = A_FTCSD                                          CGL157
     C                   EVAL      Wwcsty = E_CRTYPE                                          CGL157
     C                   EVAL      Wwhvac = E_CRHVAL                                          CGL157
     C                   EVAL      Wwclac = *Blanks                                           CGL157
     C                   EVAL      WProc157 = 'Y'                                             CGL157
                                                                                              CGL157
     C                   EXSR      SrCompute                                                  CGL157
                                                                                              CGL157
     C     Kcust         SETLL     SDJACCL4                                                   CGL157
     C     Kcust         READE     SDJACCL4                                                   CGL157
                                                                                              CGL157
     C                   DOW       NOT %EOF(SDJACCL4)                                         CGL157
                                                                                              CGL157
     C     J_JCJANO      CHAIN     SDCRSHL0                                                   CGL157
     C                   IF        %FOUND(SDCRSHL0) AND                                       CGL157
     C                             C_CRTYPE = 'J' AND                                         CGL157
     C                             C_CRHVAL <> 'N'                                            CGL157
     C                   EVAL      Kcust = J_JCJANO                                           CGL157
     C**********         EVAL      A_FTCSD = B_FTCSD                                          CGL157
     C                   EXSR      SrCompute                                                  CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C     Kcust         READE     SDJACCL4                                                   CGL157
     C                   ENDDO                                                                CGL157
                                                                                              CGL157
      ** Print details of CRS customer                                                        CGL157
                                                                                              CGL157
     C                   IF        E_CRHVAL <> X2HVIN                                         CGL157
     C                   EXSR      SRCustDt2                                                  CGL157
                                                                                              CGL157
     C                   EVAL      E_CRHVAL = X2HVIN                                          CGL157
                                                                                              CGL157
     C                   UPDATE    SDCRSHD1                                                   CGL157
     C                   EVAL      PAftCRSH = SDCRSH                                          CGL177
     C                   IF        CSD092 = 'Y'                                               CGL177
                                                                                              CGL177
      ** Log changes to history of customer information                                       CGL177
                                                                                              CGL177
     C                   IF        CGL154 = 'Y'                                               CGL177
     C                   CALL      'SD009696'                                                 CGL177
     C                   PARM      A_FACUST      Pcust                                        CGL177
     C                   PARM      *BLANKS       PBefCUST                                     CGL177
     C                   PARM      *BLANKS       PAftCUST                                     CGL177
     C                   PARM      *BLANKS       PBefACUS                                     CGL177
     C                   PARM      *BLANKS       PAftACUS                                     CGL177
     C                   PARM      B_FTCSD       PBefFTCS                                     CGL177
     C                   PARM      A_FTCSD       PAftFTCS                                     CGL177
     C                   PARM      *BLANKS       PBefJACC                                     CGL177
     C                   PARM      *BLANKS       PAftJACC                                     CGL177
     C                   PARM      *BLANKS       PBefCUXC                                     CGL177
     C                   PARM      *BLANKS       PAftCUXC                                     CGL177
     C                   PARM      *BLANKS       Pacrv                                        CGL177
     C                   PARM      *BLANKS       Pelec                                        CGL177
     C                   PARM                    PBefCRSH                                     CGL177
     C                   PARM                    PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ELSE                                                                 CGL177
     C                   CALL      'SD009696'                                                 CGL177
     C                   PARM      E_CRCUST      Pcust                                        CGL177
     C                   PARM      *BLANKS       PBefCUST                                     CGL177
     C                   PARM      *BLANKS       PAftCUST                                     CGL177
     C                   PARM      *BLANKS       PBefACUS                                     CGL177
     C                   PARM      *BLANKS       PAftACUS                                     CGL177
     C                   PARM      *BLANKS       PBefFTCS                                     CGL177
     C                   PARM      *BLANKS       PAftFTCS                                     CGL177
     C                   PARM      *BLANKS       PBefJACC                                     CGL177
     C                   PARM      *BLANKS       PAftJACC                                     CGL177
     C                   PARM      *BLANKS       PBefCUXC                                     CGL177
     C                   PARM      *BLANKS       PAftCUXC                                     CGL177
     C                   PARM      *BLANKS       Pacrv                                        CGL177
     C                   PARM      *BLANKS       Pelec                                        CGL177
     C                   PARM                    PBefCRSH                                     CGL177
     C                   PARM                    PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** Generate an account review if the high value indicator is                            CGL177
      ** changed to high                                                                      CGL177
                                                                                              CGL177
     C                   IF        CSD092 = 'Y'                                               CGL177
     C                   IF        E_CRHVAL = 'H' AND                                         CGL177
     C                             E_CRHVAL <> Wwhvac                                         CGL177
                                                                                              CGL177
     C                   EVAL      KCUST = E_CRCUST                                           CGL177
                                                                                              CGL177
     C                   MOVE      BJMRDT        WWYy                                         CGL177
     C                   EVAL      ZDATIN = '0630' + WWYy                                     CGL177
                                                                                              CGL177
     C                   CALLB     'ZDATE1'                                                   CGL177
     C                   PARM                    ZDATIN                                       CGL177
     C                   PARM      0             ZDAYNO                                       CGL177
     C                   PARM      'M'           BJDFIN                                       CGL177
     C                   PARM      ' '           ZERR                                         CGL177
                                                                                              CGL177
     C                   IF        BJRDNB <= ZDAYNO                                           CGL177
     C                   EVAL      WWYy1 = 0                                                  CGL177
     C                   MOVE      WWYy          WWYy1                                        CGL177
     C                   EVAL      WWYy1 = WWYy1 + 1                                          CGL177
     C                   MOVE      WWYy1         WWYy                                         CGL177
     C                   EVAL      ZDATIN = '0630' + WWYy                                     CGL177
                                                                                              CGL177
     C                   CALLB     'ZDATE1'                                                   CGL177
     C                   PARM                    ZDATIN                                       CGL177
     C                   PARM      0             ZDAYNO                                       CGL177
     C                   PARM      'M'           BJDFIN                                       CGL177
     C                   PARM      ' '           ZERR                                         CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   EVAL      ZCCY = BJCYCD                                              CGL177
     C                   EVAL      ZLOC = *BLANKS                                             CGL177
                                                                                              CGL177
     C                   DOU       ZIND = 'W'                                                 CGL177
                                                                                              CGL177
      ** Check if holiday on currency                                                         CGL177
                                                                                              CGL177
     C                   EVAL      *IN94 = '0'                                                CGL177
     C                   EXSR      ZCHKH                                                      CGL177
                                                                                              CGL177
      ** If a holiday, increment/decrement day number as required                             CGL177
                                                                                              CGL177
     C                   IF        ZIND = 'H'                                                 CGL177
     C                   EVAL      ZDAYNO = ZDAYNO - 1                                        CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   ENDDO                                                                CGL177
                                                                                              CGL177
     C                   EVAL      KSCDT = ZDAYNO                                             CGL177
     C                   EVAL      KSEQN = 999                                                CGL177
     C     KACRV         SETGT     SDACRVL0                                                   CGL177
     C                   READP     SDACRVL0                                                   CGL177
                                                                                              CGL177
     C                   IF        ARCUST = KCUST AND                                         CGL177
     C                             ARSCDT = KSCDT                                             CGL177
     C                   CLEAR                   SDACRV                                       CGL177
     C                   EVAL      ARSEQN = ARSEQN + 1                                        CGL177
     C                   CLEAR                   SDACRV                                       CGL177
     C                   ELSE                                                                 CGL177
     C                   EVAL      ARSEQN = 1                                                 CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   EVAL      ARSCDT = KSCDT                                             CGL177
     C                   EVAL      ARCUST = E_CRCUST                                          CGL177
     C                   EVAL      ARPURP = 'CRS High Value +                                 CGL177
     C                                      Account Review'                                   CGL177
     C                   EVAL      ARACRF = *BLANKS                                           CGL177
     C                   EVAL      ARCOMP = 'N'                                               CGL177
     C                   EVAL      ARMAGE = 'G'                                               CGL177
     C                   EVAL      ARLTYP = 'I'                                               CGL177
     C                   EVAL      ARLUSR = PSUser                                            CGL177
                                                                                              CGL177
     C                   CALLB     'ZAGENTMSTM'                                               CGL177
     C                   PARM                    ARTMST                                       CGL177
                                                                                              CGL177
     C                   WRITE     SDACRVD0                                                   CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   READ      SDCRSHL1                                                   CGL157
                                                                                              CGL157
     C                   ENDDO                                                                CGL157
     C                   ENDIF                                                                CGL157
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNonAccntH - This subroutine will process non account        *
      *               holder customer asset                           *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrCompute, SRNahoDet                                   *
      *                                                               *
      *****************************************************************
 
     C     SrNonAccntH   BEGSR
 
     C                   EVAL      WProc154 = ' '                                             CGL157
     C                   EVAL      WProc157 = ' '                                             CGL157
     C                   IF        CGL154 = 'Y'                                               CGL157
     C                   EVAL      WProc154 = 'Y'                                             CGL157
     C     *LOVAL        SETLL     SDFTNHL7
     C                   READ      SDFTNHL7
 
      ** Read until a record is not found
 
     C                   DOW       NOT %EOF(SDFTNHL7)
 
     C                   EVAL      Knaho = B_FNNAHO
     C                   EVAL      WHvAM = 0
     C                   EVAL      A_FTNHD = B_FTNHD
     C                   EVAL      Wwcsty = B_FNNHTY
     C                   EVAL      Wwclac = B_FNCLAC
     C                   EVAL      Wwhvac = B_FNHVAC
     C                   EVAL      XRHVIN = Wwhvac
 
     C     Knaho         SETLL     SDJACCL7
     C     Knaho         READE     SDJACCL7
 
     C                   DOW       NOT %EOF(SDJACCL7)
 
     C     K_JCJANO      CHAIN     SDFTCSL1
     C                   IF        %FOUND(SDFTCSL1) AND
     C                             F_FACSTY = 'J' AND
     C                             F_FAHVAC <> 'N' AND
     C                             F_FALCTP <> 'D'
     C                   EVAL      Kcust = K_JCJANO
     C                   EXSR      SrCompute
     C                   ENDIF
 
     C     Knaho         READE     SDJACCL7
     C                   ENDDO
 
      ** Print details of fatca non account holder
 
     C                   IF        B_FNCLAC <> Wwclac OR
     C                             B_FNHVAC <> XRHVIN
     C                   EXSR      SRNahoDet
 
     C                   EVAL      B_FNCLAC = Wwclac
     C                   EVAL      B_FNPCLA = A_FNCLAC
     C                   EVAL      B_FNHVAC = XRHVIN
     C                   EVAL      B_FNCLAD = BJRDNB                                        MD044423
 
     C                   UPDATE    SDFTNHD0
     C                   ENDIF
 
     C                   READ      SDFTNHL7
 
     C                   ENDDO
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        CGL177 = 'Y'                                               CGL157
     C                   EVAL      WProc154 = ' '                                             CGL157
     C                   EVAL      WProc157 = 'Y'                                             CGL157
     C     *LOVAL        SETLL     SDCRNHL1                                                   CGL157
     C                   READ      SDCRNHL1                                                   CGL157
                                                                                              CGL157
      ** Read until a record is not found                                                     CGL157
                                                                                              CGL157
     C                   DOW       NOT %EOF(SDCRNHL1)                                         CGL157
     C                   IF        G_NRTYPE <> 'F'                                            CGL157
     C                             AND G_NRTYPE <> ' '                                        CGL157
     C                             AND G_NRHVAL <> 'N'                                        CGL157
                                                                                              CGL157
     C                   EVAL      Knaho = G_NRNAHO                                           CGL157
     C                   EVAL      WHvAM = 0                                                  CGL157
     C**********         EVAL      A_FTNHD = B_FTNHD                                          CGL157
     C                   EVAL      Wwcsty = G_NRTYPE                                          CGL157
     C                   EVAL      X2HVIN = Wwhvac                                            CGL157
                                                                                              CGL157
     C     Knaho         SETLL     SDJACCL7                                                   CGL157
     C     Knaho         READE     SDJACCL7                                                   CGL157
                                                                                              CGL157
     C                   DOW       NOT %EOF(SDJACCL7)                                         CGL157
                                                                                              CGL157
     C     K_JCJANO      CHAIN     SDCRSHL0                                                   CGL157
     C                   IF        %FOUND(SDCRSHL0) AND                                       CGL157
     C                             C_CRTYPE = 'J' AND                                         CGL157
     C                             C_CRHVAL <> 'N'                                            CGL157
     C                   EVAL      Kcust = K_JCJANO                                           CGL157
     C                   EXSR      SrCompute                                                  CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C     Knaho         READE     SDJACCL7                                                   CGL157
     C                   ENDDO                                                                CGL157
                                                                                              CGL157
      ** Print details of CRS non account holder                                              CGL157
                                                                                              CGL157
     C                   IF        G_NRHVAL <> X2HVIN                                         CGL157
     C                   EXSR      SRNahoDt2                                                  CGL157
                                                                                              CGL157
     C                   EVAL      G_NRHVAL = X2HVIN                                          CGL157
                                                                                              CGL157
     C                   UPDATE    SDCRNHD1                                                   CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   READ      SDCRNHL1                                                   CGL157
                                                                                              CGL157
     C                   ENDDO                                                                CGL157
     C                   ENDIF                                                                CGL157
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCompute - This subroutine will calculate customer asset     *
      *                                                               *
      * Called by: SrCustomer, SrNonAccntH                            *
      *                                                               *
      * Calls: SRRtvCurr, SRFmtAmount, AOFATCR0                       *
      *                                                               *
      *****************************************************************
 
     C     SrCompute     BEGSR
 
     C     Kcust         SETLL     GLCSBAL0
     C     Kcust         READE     GLCSBAL0
 
     C                   DOW       NOT %EOF(GLCSBAL0) AND
     C                             Kcust = CBCUST
 
      ** Retrieve high value currency rate
 
     C                   EVAL      PCurr = CBCURR
     C                   EXSR      SRRtvCurr
     C                   EVAL      Zrate1 = A6SPRT
     C                   EVAL      Zmdi1 = A6MDIN
     C                   EVAL      Zccyi = PCurr
     C                   EVAL      Zcdpi = A6NBDP
     C                   EVAL      Zamtci = CBBALN
     C                   EXSR      SRCvtAmount
     C                   ADD       Zamtco        WHvAm
 
     C     Kcust         READE     GLCSBAL0
     C                   ENDDO
 
     C                   IF        CGL154 = 'Y'                                               CGL157
     C                             AND WProc154 = 'Y'                                         CGL157
     C                   SELECT
 
     C                   WHEN      WHvAM >= HighValue
     C                   EVAL      WHvIn = 'H'
 
     C                   WHEN      Wwcsty = 'P' AND WHvAM < HighValue
     C                             AND WHvAm >= LowValInd
     C                   EVAL      WHvIn = 'M'
 
     C                   WHEN      Wwcsty <> 'P' AND WHvAM <HighValue
     C                             AND WHvAm >= LowValEnt
     C                   EVAL      WHvIn = 'M'
 
     C                   OTHER
     C                   EVAL      WHvIn = 'L'
     C                   ENDSL
 
     C                   IF        Wwclac <> *BLANKS
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      WWCLAC        PClas
     C     SDFATC        PARM      SDFATC        DSFDY
 
     C                   IF        PRtcd <> *BLANKS AND
     C                             Prtcd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      Dbkey  = Wwclac
     C                   EVAL      Dbfile = 'SDFATCPD'
     C                   EVAL      Dbase  = 01
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check whether High Value Indicator can be changed
 
     C                   SELECT
 
     C                   WHEN      Wwhvac = *BLANKS AND WHvIn <>
     C                             *BLANKS
     C                   EVAL      XRHVIN = WHvIn
 
     C                   IF        FCDHVA <> *BLANKS AND
     C                             WHvIn = 'H'
     C                   EVAL      Wwclac = FCDHVA
     C                   ENDIF
 
     C                   IF        FCDMVA <> *BLANKS AND
     C                             WHvIn = 'M'
     C                   EVAL      Wwclac = FCDMVA
     C                   ENDIF
 
     C                   WHEN      Wwhvac = 'L' AND WHvIn = 'M'
     C                   EVAL      XRHVIN = WHvIn
 
     C                   IF        FCDMVA <> *BLANKS
     C                   EVAL      Wwclac = FCDMVA
     C                   ENDIF
 
     C                   WHEN      (Wwhvac = 'L' AND WHvIn = 'H') OR
     C                             (Wwhvac = 'M' AND WHvIn = 'H')
     C                   EVAL      XRHVIN = WHvIn
 
     C                   IF        FCDHVA <> *BLANKS
     C                   EVAL      Wwclac = FCDHVA
     C                   ENDIF
 
     C                   OTHER
     C                   EVAL      XRHVIN = Wwhvac
     C                   ENDSL
 
     C                   ENDIF
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        CGL177 = 'Y'                                               CGL157
     C                             AND WProc157 = 'Y'                                         CGL157
     C                   SELECT                                                               CGL157
                                                                                              CGL157
     C                   WHEN      Wwcsty = 'P' AND WHvAM >= HighValId2                       CGL157
     C                   EVAL      WHvIn = 'H'                                                CGL157
                                                                                              CGL157
     C                   WHEN      Wwcsty <> 'P' AND WHvAM >= HighValEt2                      CGL157
     C                   EVAL      WHvIn = 'H'                                                CGL157
                                                                                              CGL157
     C                   WHEN      WHvAM < LowVale2                                           CGL157
     C                   EVAL      WHvIn = 'L'                                                CGL157
                                                                                              CGL157
     C                   OTHER                                                                CGL157
     C                   EVAL      WHvIn = 'M'                                                CGL157
     C                   ENDSL                                                                CGL157
                                                                                              CGL157
      ** Check whether High Value Indicator can be changed                                    CGL157
                                                                                              CGL157
     C                   SELECT                                                               CGL157
                                                                                              CGL157
     C                   WHEN      Wwhvac = *BLANKS                                           CGL157
     C                             AND WHvIn <> *BLANKS                                       CGL157
     C                   EVAL      X2HVIN = WHvIn                                             CGL157
                                                                                              CGL157
     C                   WHEN      Wwhvac = 'L' AND WHvIn = 'M'                               CGL157
     C                   EVAL      X2HVIN = WHvIn                                             CGL157
                                                                                              CGL157
     C                   WHEN      (Wwhvac = 'L' AND WHvIn = 'H') OR                          CGL157
     C                             (Wwhvac = 'M' AND WHvIn = 'H')                             CGL157
     C                   EVAL      X2HVIN = WHvIn                                             CGL157
                                                                                              CGL157
     C                   OTHER                                                                CGL157
     C                   EVAL      X2HVIN = Wwhvac                                            CGL157
     C                   ENDSL                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvCurr - Retrieve Currency Details                        *
      *                                                               *
      *  Called by: SrCompute                                         *
      *                                                               *
      *  Calls: AOCURRR0                                              *
      *                                                               *
      *****************************************************************
 
     C     SRRtvCurr     BEGSR
 
      ** Retrieve currency information
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'SDCURRPD'
     C                   EVAL      Dbkey  = PCurr
     C                   EVAL      Dbase  = 02
     C                   EVAL      Dbpgm = 'GL000622'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtAmount - Convert amount                                 *
      *                                                               *
      *  Called by: SrCompute                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRCvtAmount   BEGSR
 
      ** Calculate cross exchange rate
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    Zrate1
     C                   PARM                    Zmdi1
     C                   PARM                    Zrate2
     C                   PARM                    Zmdi2
     C                   PARM      *ZEROS        ZrateX
     C                   PARM      *BLANKS       ZmdiX
 
      ** Convert amount
 
     C                   CALL      'ZCONVZ1'
     C                   PARM                    ZamtcI
     C                   PARM      ZRATEX        Zexch
     C                   PARM      ZMDIX         Zmd
     C                   PARM                    ZccyI
     C                   PARM                    ZccyO
     C                   PARM                    ZcdpI
     C                   PARM                    ZcdpO
     C                   PARM      *ZEROS        ZamtcO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAlgAmount - Align amount                                   *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: ZALIGN                                                *
      *                                                               *
      *****************************************************************
 
     C     SRAlgAmount   BEGSR
 
      ** Align amount
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK
     C                   PARM                    Zfield
     C                   PARM                    Zadec
     C                   PARM                    Zadig
 
     C                   ENDSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAudit - Print Audit Report                                 *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SrAudit       BEGSR
 
     C                   WRITE     CONTROL

     C                   IF        CGL154 = 'Y'                                               CGL157
     C                   WRITE     CONTROL1                                                   CGL157
     C                   WRITE     GL000622R2
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        CGL177 = 'Y'                                               CGL157
     C                   WRITE     CONTROL2                                                   CGL157
     C                   WRITE     GL000622R5                                                 CGL157
     C                   ENDIF                                                                CGL157
 
     C                   IF        RRCUST = 0 AND
     C**********                   RRNAHO = 0                                                 CGL157
     C                             RRNAHO = 0 AND                                             CGL157
     C                             R2CUST = 0 AND                                             CGL157
     C                             R2NAHO = 0                                                 CGL157
     C                   WRITE     TRAILER
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmount - Format amount                                  *
      *                                                               *
      *  Called by: SRCustDet, SRNahoDet, *INZSR                      *
      *                                                               *
      *  Calls: ZSEDIT                                                *
      *                                                               *
      *****************************************************************
 
     C     SRFmtAmount   BEGSR
 
      ** Format amount
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    Zfld15
     C                   PARM                    Zdecs
     C                   PARM      'J'           Zecode
     C                   PARM                    Zout21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader - Header subroutine                                 *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRHeader      BEGSR
 
     C                   EVAL      XRHIGT = %TRIML(Phigt)
     C                   EVAL      XRLOWI = %TRIML(Plowi)
     C                   EVAL      XRLOWE = %TRIML(Plowe)
 
     C                   WRITE     GL000622R0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCustDet - Print customer details                           *
      *                                                               *
      *  Called by: SrCustomer                                        *
      *                                                               *
      *  Calls: AOCUSTR0, AOACUSR0, AOFATCR0                          *
      *                                                               *
      *****************************************************************
 
     C     SRCustDet     BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      A_FACUST      Pkey1
     C                   PARM                    Pkyst
     C     SDCUSD        PARM      SDCUSD        DSSDY
 
     C                   IF        Prtcd <> *BLANKS
     C                             AND Prtcd <> '*CUSDEL'
     C                             AND Prtcd <> '*CUSCLS'
     C                   EVAL      Dbfile = 'SDCUSDPD'
     C                   EVAL      Dbase  = 03
     C                   EVAL      Dbkey  = A_FACUST
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Customer Details
 
     C                   EVAL      XRCUST = BBCUST
     C                   EVAL      XRCSSN = BBCSSN
     C                   EVAL      XRRPNM = BBCRNM
     C                   EVAL      XRRPTN = BBCRTN
 
      ** Retrieve US TIN
 
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      BBCUST        PCustNo
     C     SDACUS        PARM      SDACUS        DSLDY
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      XRUTIN = E5TINO
     C                   ELSE
     C                   EVAL      XRUTIN = *BLANKS
     C                   ENDIF
 
      ** FATCA Customer Type
 
     C                   EVAL      XRCUTP = A_FACSTY
 
      ** Current FATCA Classification
 
     C                   EVAL      XRCCLC = A_FACLAC
 
      ** New FATCA Classification
 
     C                   EVAL      XRNCLC = Wwclac
 
      ** Retrieve description for New FATCA Classification Code
 
     C                   IF        XRNCLC <> *BLANKS
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      XRNCLC        PClas
     C     SDFATC        PARM      SDFATC        DSFDY
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      XRNCLD = FCDESC
     C                   ELSE
     C                   EVAL      XRNCLD = *BLANKS
     C                   IF        PRtcd <> *BLANKS AND
     C                             Prtcd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      Dbkey  = XRNCLC
     C                   EVAL      Dbfile = 'SDFATCPD'
     C                   EVAL      Dbase  = 04
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** High Value Calculated
 
     C                   EVAL      Zfld15 = WHvAm
     C                   EVAL      Zdecs = ZcdpO
     C                   EXSR      SRFmtAmount
     C                   MOVE      Zout21        XRHVAM
 
     C                   Eval      Rqdln1 = 3
     C                   Eval      Difln1 = Oflln1 - Prtln1
 
     C                   IF        DifLn1 <= Rqdln1
     C                   EXSR      SRHeader
     C                   ENDIF
 
     C                   WRITE     GL000622R1
     C                   EVAL      RRCUST = RRCUST + 1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNahoDet - Non Account Holder Details subroutine            *
      *                                                               *
      *  Called by: SrNonAccntH                                       *
      *                                                               *
      *  Calls: AONAHOR0, AOFATCR0                                    *
      *                                                               *
      *****************************************************************
 
     C     SRNahoDet     BEGSR
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM                    KNaho
     C     SDNAHO        PARM      SDNAHO        DSSDY
 
     C                   IF        Prtcd <> *BLANKS
     C                   EVAL      Dbfile = 'SDNAHOPD'
     C                   EVAL      Dbase  = 05
     C                   EVAL      Dbkey  = A_FNNAHO
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Non Account Holder Details
 
     C                   EVAL      XRCUST = NHNAHO
     C                   EVAL      XRCSSN = *BLANKS
     C                   EVAL      XRRPNM = NHNARN
     C                   EVAL      XRRPTN = NHNATW
     C                   EVAL      XRUTIN = *BLANKS
 
      ** FATCA NAHO Type
 
     C                   EVAL      XRCUTP = A_FNNHTY
 
      ** Current FATCA Classification
 
     C                   EVAL      XRCCLC = A_FNCLAC
     C                   EVAL      XRNCLC = Wwclac
 
      ** Retrieve description for New FATCA Classification Code
 
     C                   IF        XRNCLC <> *BLANKS
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      XRNCLC        PClas
     C     SDFATC        PARM      SDFATC        DSFDY
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      XRNCLD = FCDESC
     C                   ELSE
     C                   EVAL      XRNCLD = *BLANKS
     C                   IF        PRtcd <> *BLANKS AND
     C                             Prtcd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      Dbkey  = XRNCLC
     C                   EVAL      Dbfile = 'SDFATCPD'
     C                   EVAL      Dbase  = 06
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** High Value Calculated
 
     C                   EVAL      Zfld15 = WHvAm
     C                   EVAL      Zdecs = ZcdpO
     C                   EXSR      SRFmtAmount
     C                   MOVE      Zout21        XRHVAM
 
     C                   Eval      Rqdln1 = 3
     C                   Eval      Difln1 = Oflln1 - Prtln1
 
     C                   IF        DifLn1 <= Rqdln1
     C                   EXSR      SRHeader
     C                   ENDIF
 
     C                   WRITE     GL000622R1
     C                   EVAL      RRNAHO = RRNAHO + 1
 
     C                   ENDSR
 
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SRHeadr2 - Header subroutine                                 *                       CGL157
      *                                                               *                       CGL157
      *  Called by: *INZSR                                            *                       CGL157
      *                                                               *                       CGL157
      *  Calls: None                                                  *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
                                                                                              CGL157
     C     SRHeadr2      BEGSR                                                                CGL157
                                                                                              CGL157
     C                   EVAL      X2LOGT = %TRIML(Plot2)                                     CGL157
     C                   EVAL      X2HIWI = %TRIML(Phii2)                                     CGL157
     C                   EVAL      X2HIWE = %TRIML(Phie2)                                     CGL157
                                                                                              CGL157
     C                   WRITE     GL000622R3                                                 CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
                                                                                              CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SRCustDt2 - Print customer details                           *                       CGL157
      *                                                               *                       CGL157
      *  Called by: SrCustomer                                        *                       CGL157
      *                                                               *                       CGL157
      *  Calls: AOCUSTR0                                              *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
                                                                                              CGL157
     C     SRCustDt2     BEGSR                                                                CGL157
                                                                                              CGL157
     C                   CALL      'AOCUSTR0'                                                 CGL157
     C                   PARM      *BLANKS       Prtcd                                        CGL157
     C                   PARM      '*KEY   '     Poptn                                        CGL157
     C                   PARM      E_CRCUST      Pkey1                                        CGL157
     C                   PARM                    Pkyst                                        CGL157
     C     SDCUSD        PARM      SDCUSD        DSSDY                                        CGL157
                                                                                              CGL157
     C                   IF        Prtcd <> *BLANKS                                           CGL157
     C                             AND Prtcd <> '*CUSDEL'                                     CGL157
     C                             AND Prtcd <> '*CUSCLS'                                     CGL157
     C                   EVAL      Dbfile = 'SDCUSDPD'                                        CGL157
     C                   EVAL      Dbase  = 03                                                CGL157
     C                   EVAL      Dbkey  = E_CRCUST                                          CGL157
     C                   EXSR      *PSSR                                                      CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Customer Details                                                                     CGL157
                                                                                              CGL157
     C                   EVAL      X2CUST = BBCUST                                            CGL157
     C                   EVAL      X2CSSN = BBCSSN                                            CGL157
     C                   EVAL      X2RPNM = BBCRNM                                            CGL157
     C                   EVAL      X2RPTN = BBCRTN                                            CGL157
                                                                                              CGL157
      ** CRS Customer Type                                                                    CGL157
                                                                                              CGL157
     C                   EVAL      X2CUTP = E_CRTYPE                                          CGL157
     C                   EVAL      X2CSTP = E_CRSTYP                                          CGL157
                                                                                              CGL157
      ** High Value Calculated                                                                CGL157
                                                                                              CGL157
     C                   EVAL      Zfld15 = WHvAm                                             CGL157
     C                   EVAL      Zdecs = ZcdpO                                              CGL157
     C                   EXSR      SRFmtAmount                                                CGL157
     C                   MOVE      Zout21        X2HVAM                                       CGL157
                                                                                              CGL157
     C                   Eval      Rqdln2 = 3                                                 CGL157
     C                   Eval      Difln2 = Oflln2 - Prtln2                                   CGL157
                                                                                              CGL157
     C                   IF        DifLn2 <= Rqdln2                                           CGL157
     C                   EXSR      SRHeadr2                                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   WRITE     GL000622R4                                                 CGL157
     C                   EVAL      R2CUST = R2CUST + 1                                        CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
                                                                                              CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SRNahoDt2 - Non Account Holder Details subroutine            *                       CGL157
      *                                                               *                       CGL157
      *  Called by: SrNonAccntH                                       *                       CGL157
      *                                                               *                       CGL157
      *  Calls: AONAHOR0                                              *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
                                                                                              CGL157
     C     SRNahoDt2     BEGSR                                                                CGL157
                                                                                              CGL157
     C                   CALL      'AONAHOR0'                                                 CGL157
     C                   PARM      *BLANKS       Prtcd                                        CGL157
     C                   PARM      '*KEY   '     Poptn                                        CGL157
     C                   PARM      G_NRNAHO      KNaho                                        CGL157
     C     SDNAHO        PARM      SDNAHO        DSSDY                                        CGL157
                                                                                              CGL157
     C                   IF        Prtcd <> *BLANKS                                           CGL157
     C                   EVAL      Dbfile = 'SDNAHOPD'                                        CGL157
     C                   EVAL      Dbase  = 05                                                CGL157
     C                   EVAL      Dbkey  = G_NRNAHO                                          CGL157
     C                   EXSR      *PSSR                                                      CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Non Account Holder Details                                                           CGL157
                                                                                              CGL157
     C                   EVAL      X2CUST = NHNAHO                                            CGL157
     C                   EVAL      X2CSSN = *BLANKS                                           CGL157
     C                   EVAL      X2RPNM = NHNARN                                            CGL157
     C                   EVAL      X2RPTN = NHNATW                                            CGL157
                                                                                              CGL157
      ** CRS NAHO Type                                                                        CGL157
                                                                                              CGL157
     C                   EVAL      X2CUTP = G_NRTYPE                                          CGL157
     C                   EVAL      X2CSTP = G_NRSTYP                                          CGL157
                                                                                              CGL157
      ** High Value Calculated                                                                CGL157
                                                                                              CGL157
     C                   EVAL      Zfld15 = WHvAm                                             CGL157
     C                   EVAL      Zdecs = ZcdpO                                              CGL157
     C                   EXSR      SRFmtAmount                                                CGL157
     C                   MOVE      Zout21        X2HVAM                                       CGL157
                                                                                              CGL157
     C                   Eval      Rqdln2 = 3                                                 CGL157
     C                   Eval      Difln2 = Oflln2 - Prtln2                                   CGL157
                                                                                              CGL157
     C                   IF        DifLn2 <= Rqdln2                                           CGL157
     C                   EXSR      SRHeadr2                                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   WRITE     GL000622R4                                                 CGL157
     C                   EVAL      R2NAHO = R2NAHO + 1                                        CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
                                                                                              CGL157
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, AOSVALR0, SRRtvCurr, SRAlgAmount,            *
      *        SRFmtAmount, SRHeader                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      Dbpgm = 'GL000622'
     C                   EVAL      Dbfile = *BLANKS
     C                   EVAL      Dbkey =  *BLANKS
     C                   EVAL      Dbase = 0
     C                   OUT       LDA
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*FIRST  '    Poptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      Dbkey  = Poptn
     C                   EVAL      Dbfile = 'SDBANKPD'
     C                   EVAL      Dbase  = 07
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RRRUNA = BJMRDT
 
      ** Check whether CSD092 is available
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSD092'      PSard
     C     Scsard        PARM      Scsard        Dsfdy
 
     C                   IF        PRtcd <> *BLANKS
     C                   IF        PRtcd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = PSard
     C                   EVAL      DBASE  = 8
     C                   EVAL      DBPGM = 'GL000622'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      CSD092 = 'N'
     C                   ELSE
     C                   EVAL      CSD092 = 'Y'
     C                   ENDIF
 
     C                   EVAL      *IN50 = '0'                                                CGL157
     C                   EVAL      *IN51 = '0'                                                CGL157
                                                                                              CGL157
      ** Check whether CGL154 is available                                                    CGL157
                                                                                              CGL157
     C                   CALL      'AOSARDR0'                                                 CGL157
     C                   PARM      *Blanks       PRtcd                                        CGL157
     C                   PARM      '*VERIFY'     POptn                                        CGL157
     C                   PARM      'CGL154'      PSard                                        CGL157
     C     Scsard        PARM      Scsard        Dsfdy                                        CGL157
                                                                                              CGL157
     C                   IF        PRtcd <> *BLANKS                                           CGL157
     C                   IF        PRtcd <> '*NRF'                                            CGL157
     C     *LOCK         IN        LDA                                                        CGL157
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL157
     C                   EVAL      DBKEY  = PSard                                             CGL157
     C                   EVAL      DBASE  = 10                                                CGL157
     C                   EVAL      DBPGM = 'GL000622'                                         CGL157
     C                   OUT       LDA                                                        CGL157
     C                   EXSR      *PSSR                                                      CGL157
     C                   ENDIF                                                                CGL157
     C                   EVAL      CGL154 = 'N'                                               CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      CGL154 = 'Y'                                               CGL157
     C                   EVAL      *IN50 = '1'                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Check whether CGL177 is available                                                    CGL157
                                                                                              CGL157
     C                   CALL      'AOSARDR0'                                                 CGL157
     C                   PARM      *Blanks       PRtcd                                        CGL157
     C                   PARM      '*VERIFY'     POptn                                        CGL157
     C                   PARM      'CGL177'      PSard                                        CGL157
     C     Scsard        PARM      Scsard        Dsfdy                                        CGL157
                                                                                              CGL157
     C                   IF        PRtcd <> *BLANKS                                           CGL157
     C                   IF        PRtcd <> '*NRF'                                            CGL157
     C     *LOCK         IN        LDA                                                        CGL157
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL157
     C                   EVAL      DBKEY  = PSard                                             CGL157
     C                   EVAL      DBASE  = 11                                                CGL157
     C                   EVAL      DBPGM = 'GL000622'                                         CGL157
     C                   OUT       LDA                                                        CGL157
     C                   EXSR      *PSSR                                                      CGL157
     C                   ENDIF                                                                CGL157
     C                   EVAL      CGL177 = 'N'                                               CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      CGL177 = 'Y'                                               CGL157
     C                   EVAL      *IN51 = '1'                                                CGL157
     C                   ENDIF                                                                CGL157

      ** Check system value high/low account information
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    SValK1
     C                   PARM                    SVal1
     C                   PARM                    SValK2
     C                   PARM                    SVal2
     C                   PARM                    SValK3
     C                   PARM                    SVal3
     C                   PARM                    SValK4
     C                   PARM                    SVal4
     C                   PARM      SysVal5       SValK5
     C                   PARM                    SVal5
     C                   PARM                    SValK6
     C                   PARM                    SVal6
     C                   PARM                    SValK7
     C                   PARM                    SVal7
     C                   PARM                    SValK8
     C                   PARM                    SVal8
     C                   PARM                    SValK9
     C                   PARM                    SVal9
     C                   PARM                    SValK0
     C                   PARM                    SVal10
 
     C                   IF        PRtcd <> *BLANKS  AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'SDSVALPD'
     C                   EVAL      Dbkey = SValK1
     C                   EVAL      Dbase = 09
     C                   EVAL      Dbpgm = 'GL000622'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WWACRF = SVAL5
 
     C                   CALL      'GPAOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      SysVal1       SValK1
     C                   PARM                    SVal1
     C                   PARM      SysVal2       SValK2
     C                   PARM                    SVal2
     C                   PARM      SysVal3       SValK3
     C                   PARM                    SVal3
     C                   PARM      SysVal4       SValK4
     C                   PARM                    SVal4
     C                   PARM                    SValK5
     C                   PARM                    SVal5
     C**********         PARM                    SValK6                                       CGL157
     C                   PARM      SysVal6       SValK6                                       CGL157
     C                   PARM                    SVal6
     C**********         PARM                    SValK7                                       CGL157
     C                   PARM      SysVal7       SValK7                                       CGL157
     C                   PARM                    SVal7
     C**********         PARM                    SValK8                                       CGL157
     C                   PARM      SysVal8       SValK8                                       CGL157
     C                   PARM                    SVal8
     C**********         PARM                    SValK9                                       CGL157
     C                   PARM      SysVal9       SValK9                                       CGL157
     C                   PARM                    SVal9
     C                   PARM                    SValK0
     C                   PARM                    SVal10
 
     C                   IF        PRtcd <> *BLANKS  AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'GPSVALPD'
     C                   EVAL      Dbkey = SValK1
     C                   EVAL      Dbase = 19
     C                   EVAL      Dbpgm = 'GL000622'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        CGL154 = 'Y'                                               CGL157
     C                   EVAL      PCurr = SVal13
     C                   EXSR      SRRtvCurr
 
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13
 
     C                   EVAL      Zfield = SVal313
     C                   EXSR      SRAlgAmount
     C                   MOVE      Zfield        LowValInd
 
     C                   EVAL      Zfield = SVal413
     C                   EXSR      SRAlgAmount
     C                   MOVE      Zfield        LowValEnt
 
     C                   EVAL      Zfield = SVal213
     C                   EXSR      SRAlgAmount
     C                   MOVE      Zfield        HighValue
 
      ** Retrieve high value currency rate
 
     C                   EVAL      PCurr = SVal13
     C                   EVAL      XRHVCY = SVal13
     C                   EXSR      SRRtvCurr
     C                   EVAL      Zrate2 = A6SPRT
     C                   EVAL      Zmdi2 = A6MDIN
     C                   EVAL      ZccyO = PCurr
     C                   EVAL      ZcdpO = A6NBDP
 
      ** Format system values for report
      ** Low Value Threshold (Individual)
 
     C                   EVAL      Zfld15 = LowValInd
     C                   EVAL      Zdecs = A6NBDP
     C                   EXSR      SRFmtAmount
     C                   MOVE      Zout21        Plowi
 
      ** Low Value Threshold (Entity)
 
     C                   EVAL      Zfld15 = LowValEnt
     C                   EVAL      Zdecs = A6NBDP
     C                   EXSR      SRFmtAmount
     C                   MOVE      Zout21        Plowe
 
      ** High Value Threshold
 
     C                   EVAL      Zfld15 = HighValue
     C                   EVAL      Zdecs = A6NBDP
     C                   EXSR      SRFmtAmount
     C                   MOVE      Zout21        Phigt
 
      ** High Value Currency
 
     C                   EVAL      Phvcy = SVal13
     C                   EXSR      SRRtvCurr
     C                   EVAL      Zrate2 = A6SPRT
     C                   EVAL      Zmdi2 = A6MDIN
     C                   EVAL      ZccyO = PHVCY
     C                   EVAL      ZcdpO = A6NBDP
 
     C                   OPEN      GL000622P1
     C                   EXSR      SRHeader                                                 MD042920
 
     C                   Z-ADD     Sfnum         Zsnum
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       Zseq
     C                   PARM      *BLANKS       Zenty
     C                   PARM                    Sfile
     C                   PARM                    Zsnum
     C                   PARM                    Zserr
 
      ** error during ZSFILE processing, return to calling program
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        CGL177 = 'Y'                                               CGL157
     C                   EVAL      PCurr = SVal63                                             CGL157
     C                   EXSR      SRRtvCurr                                                  CGL157
                                                                                              CGL157
     C                   EVAL      Zadec = A6NBDP                                             CGL157
     C                   EVAL      Zadig = 13                                                 CGL157
                                                                                              CGL157
     C                   EVAL      Zfield = SVal813                                           CGL157
     C                   EXSR      SRAlgAmount                                                CGL157
     C                   MOVE      Zfield        HighValId2                                   CGL157
                                                                                              CGL157
     C                   EVAL      Zfield = SVal913                                           CGL157
     C                   EXSR      SRAlgAmount                                                CGL157
     C                   MOVE      Zfield        HighValEt2                                   CGL157
                                                                                              CGL157
     C                   EVAL      Zfield = SVal713                                           CGL157
     C                   EXSR      SRAlgAmount                                                CGL157
     C                   MOVE      Zfield        LowVale2                                     CGL157
                                                                                              CGL157
      ** Retrieve high value currency rate                                                    CGL157
                                                                                              CGL157
     C                   EVAL      PCurr = SVal63                                             CGL157
     C                   EVAL      X2HVCY = SVal63                                            CGL157
     C                   EXSR      SRRtvCurr                                                  CGL157
     C                   EVAL      Zrate2 = A6SPRT                                            CGL157
     C                   EVAL      Zmdi2 = A6MDIN                                             CGL157
     C                   EVAL      ZccyO = PCurr                                              CGL157
     C                   EVAL      ZcdpO = A6NBDP                                             CGL157
                                                                                              CGL157
      ** Format system values for report                                                      CGL157
      ** High Value Threshold (Individual)                                                    CGL157
                                                                                              CGL157
     C                   EVAL      Zfld15 = HighValId2                                        CGL157
     C                   EVAL      Zdecs = A6NBDP                                             CGL157
     C                   EXSR      SRFmtAmount                                                CGL157
     C                   MOVE      Zout21        Phii2                                        CGL157
                                                                                              CGL157
      ** High Value Threshold (Entity)                                                        CGL157
                                                                                              CGL157
     C                   EVAL      Zfld15 = HighValEt2                                        CGL157
     C                   EVAL      Zdecs = A6NBDP                                             CGL157
     C                   EXSR      SRFmtAmount                                                CGL157
     C                   MOVE      Zout21        Phie2                                        CGL157
                                                                                              CGL157
      ** Low Value Threshold                                                                  CGL157
                                                                                              CGL157
     C                   EVAL      Zfld15 = LowVale2                                          CGL157
     C                   EVAL      Zdecs = A6NBDP                                             CGL157
     C                   EXSR      SRFmtAmount                                                CGL157
     C                   MOVE      Zout21        Plot2                                        CGL157
                                                                                              CGL157
      ** High Value Currency                                                                  CGL157
                                                                                              CGL157
     C                   EVAL      Phvcy = SVal63                                             CGL157
     C                   EXSR      SRRtvCurr                                                  CGL157
     C                   EVAL      Zrate2 = A6SPRT                                            CGL157
     C                   EVAL      Zmdi2 = A6MDIN                                             CGL157
     C                   EVAL      ZccyO = PHVCY                                              CGL157
     C                   EVAL      ZcdpO = A6NBDP                                             CGL157
                                                                                              CGL157
     C                   OPEN      GL000622P2                                                 CGL157
                                                                                              CGL157
     C                   Z-ADD     Sfnum2        Zsnum                                        CGL157
     C                   CALL      'ZSFILE'                                                   CGL157
     C                   PARM      *BLANKS       Zseq                                         CGL157
     C                   PARM      *BLANKS       Zenty                                        CGL157
     C                   PARM                    Sfile2                                       CGL157
     C                   PARM                    Zsnum                                        CGL157
     C                   PARM                    Zserr                                        CGL157
                                                                                              CGL157
      ** error during ZSFILE processing, return to calling program                            CGL157
                                                                                              CGL157
     C                   IF        ZSERR = 'Y'                                                CGL157
     C                   EVAL      *INU7 = *ON                                                CGL157
     C                   EVAL      *INU8 = *ON                                                CGL157
     C                   EVAL      *INLR = *ON                                                CGL157
     C                   RETURN                                                               CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
 
     C                   IF        CGL154 = 'Y'                                               CGL157
     C                   EXSR      SRHeader
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        CGL177 = 'Y'                                               CGL157
     C                   EXSR      SRHeadr2                                                   CGL157
     C                   ENDIF                                                                CGL157
 
      ** Initialize fields
 
     C                   EVAL      CBCUST = *BLANKS
     C                   EVAL      RRCUST = *ZEROS
     C                   EVAL      RRNAHO = *ZEROS
     C                   EVAL      R2CUST = *ZEROS                                            CGL157
     C                   EVAL      R2NAHO = *ZEROS                                            CGL157
 
     C     KACRV         KLIST
     C                   KFLD                    KCUST
     C                   KFLD                    KSCDT
     C                   KFLD                    KSEQN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        Wrun = *BLANK
 
     C                   WRITE     CONTROL
     C                   WRITE     DBERROR
 
     C                   EVAL      Wrun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
     C/COPY ZSRSRC,ZCHKHLE
     C/COPY ZSRSRC,ZACCHLE
 
      *****************************************************************

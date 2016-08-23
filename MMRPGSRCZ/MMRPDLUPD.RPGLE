     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Update repo details')                         *
/*OVRF*: OVRDBF SEDMRPXX DPTMVD                                     : *
/*OVRF*: OVRDBF SEDMRPX1 DPTMVDY1                                   : *
/*OVRF*: OVRDBF SEDMRPX2 DPTMVDY2                                   : *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMRPDLUPD - MM Update Repo Details                           *
      *                                                               *
      *  Function: This Program updates depot movement file with      *
      *            Repo details                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CRE073             Date 06Dec10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249287             Date 19Jul07               *
      *                 246912             Date 24Apr07               *
      *                 244855             Date 30Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245848             Date 01Mar07               *
      *                 245794             Date 28Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10853           Date 15Mar06               *
      *                 BUG10346           Date 08Feb06               *
      *                 CAP087             Date 05Sep05               *
      *                 233352             Date 06May05               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204662             Date 16Apr02               *
      *                 CSC011             Date 14Mar02               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 1June99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249287 - Recompile on MMRPTRPD.                              *
      *  246912 - Generate new transaction reference no. if the deal  *
      *           number is already used as depot movement reference. *
      *  244855 - File out of balance in SEC0601 in program SE0340    *
      *           due to incorrect update of audit file record when   *
      *           repo rollover is done. Fix is to use the correct    *
      *           last change type field.                             *
      *  245848 - Update Depot movements file when action is amend    *
      *  245794 - If a change was done on the securities narrative,   *
      *           update the record.                                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10853 - CGL029 changes missing for repos (Recompile)      *
      *  BUG10346 - Zeroise no. of inserted records for proper        *
      *             trailer file update.                              *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
      *  233352 - Problem in REPO API (Recompile)                     *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  207006 - Add Counterparty & Market Centre to SSI (Recompile) *
      *  204662 - Depot reference should be the same than deal number *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *           Recompile.                                          *
      *  CSE006 - Repurchase Agreements.                              *
      *                                                               *
      *****************************************************************

     FSEDMRPXX  UF   E             DISK    USROPN
     F                                     INFSR(*PSSR)

     FSEDMRPX1  UF   E           K DISK
     F                                     INFSR(*PSSR)

     FSEDMRPX2  UF   E           K DISK
     F                                     INFSR(*PSSR)

     FDPTMVDL1  UF A E           K DISK    COMMIT PREFIX(D)
     F                                     INFSR(*PSSR)
     F                                     RENAME(DPTMVDF:DPMVL1)

     FDPTMVDY1  UF A E           K DISK    COMMIT PREFIX(D)
     F                                     INFSR(*PSSR)
     F                                     RENAME(DPTMVDD1:DPMVY1)

     FDPTMVDY2  UF A E           K DISK    COMMIT PREFIX(D)
     F                                     INFSR(*PSSR)
     F                                     RENAME(DPTMVDD2:DPMVY2)

     FUDEPP     UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)

     FSECRTNL1  UF A E           K DISK    COMMIT PREFIX(D)
     F                                     INFSR(*PSSR)

     FSECRTTL1  UF A E           K DISK    COMMIT PREFIX(D)
     F                                     INFSR(*PSSR)

     FSECRTNTPPDIF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     RENAME(SECRTNF1:TEMPNF1)

     FSECRTTTPPDIF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     RENAME(SECRTTF1:TEMPTF1)
     FDPTMVA    UF   E             DISK    COMMIT
     FUDEPPA    UF   E             DISK    COMMIT
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

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Trans_Ref       S              6A
     D Trans_Num       S              6S 0
     D ##DPNA          S             11S 0
     D ##ORED          S                   LIKE(DORED)
     D ##DPMS          S                   LIKE(DDPMS)
     D ##TACI          S                   LIKE(DTACI)
     D DepotPos        S              1A                                                      CAP087
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D NwDlFilFmt    E DS                  EXTNAME(MMVLDNIPD)
     D**  New Deal in File Format

     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
     D**  External Data Structure for Securities ICD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D**  External Data Structure for Bank Details
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D**  Long data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D**  Short data structure
     D SEDXX         E DS                  EXTNAME(SEDMRPXX)
     D**  Data structure of Depot Movement File
     D DPTXX         E DS                  EXTNAME(DPTMVDL1) PREFIX(D)
     D**  Data structure of Depot Movement File
     D SEDX1         E DS                  EXTNAME(SEDMRPX1)
     D**  Data structure of Depot Movement File
     D DPTY1         E DS                  EXTNAME(DPTMVDY1) PREFIX(D)
     D**  Data structure of Depot Movement File
     D SEDX2         E DS                  EXTNAME(SEDMRPX2)
     D**  Data structure of Depot Movement File
     D DPTY2         E DS                  EXTNAME(DPTMVDY2) PREFIX(D)
     D**  Data structure of Certificate Numbers Temporary File
     D TEMPTN        E DS                  EXTNAME(SECRTNTPPD)
     D**  Data structure of Certificate Numbers File
     D RTNT1         E DS                  EXTNAME(SECRTNL1) PREFIX(D)
     D**  Data structure of Certifiactes Units Temporary File
     D TEMPTT        E DS                  EXTNAME(SECRTTTPPD)
     D**  Data structure of Certificates Units File
     D RTTT1         E DS                  EXTNAME(SECRTTL1) PREFIX(D)
     D**  Data structure of Depot Movement File
                                                                                              CSC011
     D Trailer       E DS                  EXTNAME(MMRPTRPD)                                  CSC011
      ** Repot Depot Movement record set trailer                                              CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
                                                                                              CSC011
     D                 DS
      **  Data structure for dummy reference number for depo extension
     D  DRefNo                 1      6
     D  DumConst               1      1
     D  DumRef                 2      6

     D FIXML           DS                                                                     204662
      **  Data structure for fixml                                                            204662
     D  WDPRNN                 1      6S 0                                                    204662
     D  WDPRNA                 1      6                                                       204662
                                                                                              204662
     D                 DS                                                                     CSC011
      **  Data structure to split  fee account number into 12 and 3                           CSC011
     D***W#ACCN*                1     16                                               CSC011 CGL029
     D***DDACCA*                1     12                                               CSC011 CGL029
     D***DDACCB*               13     15                                               CSC011 CGL029
     D  W#ACCN                 1     22                                                       CGL029
     D  DDACCA                 1     18                                                       CGL029
     D  DDACCB                19     21                                                       CGL029
                                                                                              CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D WTimestamp      S             26A                                                      CSC011
     D***PDealNo         S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
     D WDealNo         S              6A                                                      CSC011
     D My1st           S              1A   INZ(*BLANKS)                                       CSC011
     D Counter         S              3  0                                                    CSC011
                                                                                              CSC011
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** If this module was called from SE module, bypass update of depot movement            CAP087
      ** file (DPTMVD) and only do the update of the User Depot positions file (UDEPPD).      CAP087
      *                                                                                       CAP087
     C                   IF        DepotPos = 'Y'                                             CAP087
      *                                                                                       CAP087
      ** Set TNLU to zero (patterned after SEDPMVUPD where generation of TNLU has been        CAP087
      ** removed)                                                                             CAP087
     C                   EVAL      TNLU = 0                                                   CAP087
     C                   Z-ADD     0             ##UINS                                     BUG10346
      *                                                                                       CAP087
      ** Run appropriate subroutine depending on the change type.                             CAP087
      *                                                                                       CAP087
     C                   IF        DCHTP   = 'D'                                              CAP087
     C                   EXSR      DDELET                                                     CAP087
     C                   ELSE                                                                 CAP087
     C                   EXSR      DMAINT                                                     CAP087
     C                   END                                                                  CAP087
      *                                                                                       CAP087
     C                   ELSE                                                                 CAP087
     C*
     C* Audit counts
     C*
     C                   Z-ADD     0             ##DDEL            5 0
     C                   Z-ADD     0             ##DAMD            5 0
     C                   Z-ADD     0             ##DINS            5 0
     C                   Z-ADD     0             ##DNOR            5 0
     C                   Z-ADD     0             ##UINS            5 0
     C                   Z-ADD     0             W#NOML           15 0                        CSC011
     C                   EVAL      My1st = 'Y'                                                CSC011
     C                   EVAL      Counter = 0                                                CSC011
     C
     C                   OPEN      SEDMRPXX
     C                   READ      SEDMRPXX                               89
     C
     C                   DOW       *IN89 = *OFF
     C
     C                   Z-ADD     0             ##DDEL                                       CAP067
     C                   Z-ADD     0             ##DAMD                                       CAP067
     C                   Z-ADD     0             ##DINS                                       CAP067
     C                   Z-ADD     0             ##DNOR                                       CAP067
     C                   Z-ADD     0             ##UINS                                       CAP067
      *
     C** Set up Reference number data structure to check whether a
     C** dummy reference number was generated
      *
     C                   EVAL      DRefNo = DPRN
      *
      ** Set up Reference number if blank or dummy
     C                   IF        DPRN = *BLANKS or DumConst = 'X'
     C
     C                   MOVE      IKDN38        DPRNKEY           6                          246912
     C     DPRNKEY       CHAIN     DPTMVDL1                           90                      246912
     C     *IN90         IFEQ      '1'                                                        246912
     C                   EVAL      WDPRNN = IKDN38                                            204662
     C                   EVAL      DDPRN  = WDPRNA                                            204662
     C                   MOVE      DDPRN         Trans_Ref                                    204662
     C                   Z-ADD     WDPRNN        Trans_Num                                    204662
     C                   ELSE                                                                 246912
     C                   CALLB     'ZATRNRTV'                                                 246912
     C                   PARM      *Blanks       RetCodeOut                                   246912
     C                   PARM      'SE'          MODU              2                          246912
     C                   PARM      'D'           TRTY              1                          246912
     C                   PARM      *Blanks       Trans_Ref                                    246912
     C                   PARM      *Zeros        Trans_Num                                    246912
      *                                                                                       246912
      ** Database Error                                                                       246912
      *                                                                                       246912
     C     RetCodeOut    IFNE      *BLANK                                                     246912
     C                   MOVEL     'ZATRNRTV'    DBFILE                         ************* 246912
     C                   MOVEL     '001'         DBASE                          * DBERR 001 * 246912
     C                   MOVEL     DPRN          DBKEY                          ************* 246912
     C                   EXSR      *PSSR                                                      246912
     C                   ENDIF                                                                246912
     C                   ENDIF                                                                246912
      *                                                                                       246912
     C                   MOVEL     SEDXX         DPTXX
     C
     C**********         CALLB     'ZATRNRTV'                                                 204662
     C**********         PARM      *Blanks       RetCodeOut                                   204662
     C**********         PARM      'SE'          MODU              2                          204662
     C**********         PARM      'D'           TRTY              1                          204662
     C**********         PARM      *Blanks       Trans_Ref                                    204662
     C**********         PARM      *Zeros        Trans_Num                                    204662
      *
      ***DATABASE*ERROR************************************************                       204662
      *
     C*****RetCodeOut    IFNE      *BLANK                                                     204662
     C**********         MOVEL     'ZATRNRTV'    DBFILE                         ************  204662
     C**********         MOVEL     '001'         DBASE                          * DBERR 001*  204662
     C**********         MOVEL     DPRN          DBKEY                          ************  204662
     C**********         EXSR      *PSSR                                                      204662
     C**********         END                                                                  204662
     C
     C                   MOVE      Trans_Ref     DDPRN
     C                   EVAL      DORED = BJRDNB
     C                   EVAL      DLCD = BJRDNB
     C
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    NATN              5 0
      *
      * DATABASE ERROR
      *
     C     ReturnCode    IFNE      *BLANK
     C                   MOVEL     'ZTNLU1'      DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     NATN          DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C
     C                   EVAL      DTNLU = NATN
     C
     C                   BITOFF    '01'          DTACI
     C                   BITOFF    '0'           DDPMS
     C                   EVAL      DDPAD = IKDN38
     C                   EVAL      DORBR = IKORBR
      *
      ** If CAC005 is on convert Book Code to Pseudo Book
     C                   IF        CAC005 = 'Y'
     C                   CALL      'AOBKPCR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*PSEUDO'     POPTN             7
     C                   PARM      IKBOKC        PBOOK             2
     C                   PARM      IKPRFC        PPRFC             4
     C                   PARM                    PPSCD             2
      *
     C                   EVAL      DDPBK = PPSCD
      *
     C                   ELSE
     C                   EVAL      DDPBK = IKBOKC
     C                   ENDIF
     C                   EVAL      DCHTP = 'I'
     C                   WRITE     DPMVL1
     C*
     C** Need to update certificates files with correct reference number
     C*
     C     DRefNo        CHAIN     SECRTNTPPD                         89
     C     *IN89         DOWEQ     *OFF
     C                   EVAL      CNTDRF = DDPRN
     C                   MOVEL     TEMPTN        RTNT1
     C                   WRITE     SECRTNF1
     C     DRefNo        READE     SECRTNTPPD                             89
     C                   ENDDO
     C
     C     DRefNo        CHAIN     SECRTTTPPD                         89
     C     *IN89         DOWEQ     *OFF
     C                   EVAL      TCTDRF = DDPRN
     C                   MOVEL     TEMPTT        RTTT1
     C                   WRITE     SECRTTF1
     C     DRefNo        READE     SECRTTTPPD                             89
     C                   ENDDO
     C
     C                   ELSE
      *
      ** Reference number is not blank or a dummy refernce
      *
     C
     C     DPRN          CHAIN     DPTMVDL1                           89
     C
      * It is now possible that several records has the same Depot Reference (as long         CAP087
      * as combination DPRN+DPSS+DPMV is unique) hence required to read the file until        CAP087
      * correct record (to be updated) is retrieved.                                          CAP087
     C                   DOW       *IN89 = *OFF                                               CAP087
      * Reference read is same as key reference                                               CAP087
     C                   IF        DDPRN = DPRN                                               CAP087
      * Security and Depot Movement Type is same as that of key, leave the loop.              CAP087
     C                   IF        DDPSS = DPSS AND DDPMV = DPMV                              CAP087
     C                   LEAVE                                                                CAP087
      * else, continue searching the file for matching combination for DPRN+DPSS+DPMV         CAP087
     C                   ELSE                                                                 CAP087
     C                   READ      DPTMVDL1                               89                  CAP087
     C                   ENDIF                                                                CAP087
      * Reference read now differs as key reference (i.e. record not found), issue            CAP087
      * database error.                                                                       CAP087
     C                   ELSE                                                                 CAP087
     C                   EVAL      *IN89 = *ON                                                CAP087
     C                   ENDIF                                                                CAP087
     C                   ENDDO                                                                CAP087
      *                                                                                       CAP087
     C                   IF        *IN89 = *ON
     C                   MOVEL     'DPTMVDL1'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 001*
     C                   MOVEL     DPRN          DBKEY                          ************
     C                   EXSR      *PSSR
     C
     C                   ELSE
      *
      ** Only update record if there have been changes to amendable fields
      *
     C                   IF        IKMTYP = 'CD' or IKMTYP = 'IT'
     C                             or IKMTYP = 'TD'
      *
     C                   IF        RECI <> DRECI or DPMV <> DDPMV
     C                             or DPID <> DDPID or DPMD <> DDPMD
     C                             or DPOD <> DDPOD
     C                             or DPBA <> DDPBA or DPBK <> DDPBK
     C                             or DPBN <> DDPBN or DPNA <> DDPNA
     C**********                   or MKTP <> DMKTP                                           245794
     C                             or DPNR <> DDPNR or MKTP <> DMKTP                          245794
     C                             or DCCE <> DDCCE or DCHA <> DDCHA
     C                             or DCSE <> DDCSE or DCAB <> DDCAB
     C                             or DCAT <> DDCAT or DPVD <> DDPVD
     C                             or DCAT <> DDCAT or DPVD <> DDPVD
     C                             or DVIN <> DDVIN or DMIN <> DDMIN
     C                             or DEXRT <> DDEXRT
     C                             or CHTP = 'A'                                              245848
     C                   MOVE      'Y'           UpdateReq         1
     C                   ELSE
     C                   MOVE      'N'           UpdateReq         1
     C                   ENDIF
     C                   ENDIF
     C
     C                   IF        IKMTYP = 'CL' or IKMTYP = 'IP'
     C                             or IKMTYP = 'TI'
      *
     C                   IF        RECI <> DRECI or DPMV <> DDPMV
     C                             or DPID <> DDPID
     C                             or DPOD <> DDPOD or DPDO <> DDPDO
     C                             or DPBA <> DDPBA or DPBK <> DDPBK
     C                             or DPBN <> DDPBN or DPNA <> DDPNA
     C**********                   or MKTP <> DMKTP                                           245794
     C                             or DPNR <> DDPNR or MKTP <> DMKTP                          245794
     C                             or DCCE <> DDCCE or DCHA <> DDCHA
     C                             or DCSE <> DDCSE or DCAB <> DDCAB
     C                             or DCAT <> DDCAT or DPVD <> DDPVD
     C                             or DCAT <> DDCAT or DPVD <> DDPVD
     C                             or DVIN <> DDVIN or DMIN <> DDMIN
     C                             or DEXRT <> DDEXRT
     C                             or CHTP = 'A'                                              245848
     C                   MOVE      'Y'           UpdateReq         1
     C                   ELSE
     C                   MOVE      'N'           UpdateReq         1
     C                   ENDIF
     C                   ENDIF
      *
      *
     C                   IF        UpdateReq = 'Y'
      *
      ** Save Value of Nominal before new amount is entered
      *
     C                   EVAL      ##DPNA = DDPNA
      *
      ** Save Value of Original Entry Date
      *
     C                   EVAL      ##ORED = DORED
      *
      ** Save Value of Accounting Indicator
      *
     C                   EVAL      ##TACI = DTACI
      *
      ** Save Value of Message Indicator
      *
     C                   EVAL      ##DPMS = DDPMS
      *
      ** Update permanent record using temporary record
      *
     C                   CLEAR                   DPTXX
     C                   MOVEL     SEDXX         DPTXX
     C
     C                   EVAL      DORBR = IKORBR
      *
      ** If CAC005 is on convert Book Code to Pseudo Book
     C                   IF        CAC005 = 'Y'
     C                   CALL      'AOBKPCR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*PSEUDO'     POPTN             7
     C                   PARM      IKBOKC        PBOOK             2
     C                   PARM      IKPRFC        PPRFC             4
     C                   PARM                    PPSCD             2
      *
     C                   EVAL      DDPBK = PPSCD
      *
     C                   ELSE
     C                   EVAL      DDPBK = IKBOKC
     C                   ENDIF
     C                   EVAL      DLCD = BJRDNB
     C                   EVAL      DORED = ##ORED
     C                   EVAL      DTACI = ##TACI
     C                   EVAL      DDPMS = ##DPMS
     C
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    NATN              5 0
      *
      * DATABASE ERROR
      *
     C     ReturnCode    IFNE      *BLANK
     C                   MOVEL     'ZTNLU1'      DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 001*
     C                   MOVEL     NATN          DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C
     C                   EVAL      DTNLU = NATN
     C                   EVAL      DRECI = RECI
     C                   UPDATE    DPMVL1
     C
     C                   ELSE
     C                   MOVE      'N'           UpdInd            1
     C                   ENDIF
     C*
     C** Need to update certificates files
     C*
     C** Access Temporary Certificates file for records relating to Depot
     C** Movement. Check whether record already exists on permanent
     C** Certificates file. If so overwrite current record, else write new
     C** record.
     C*
     C     K#Cert        KLIST
     C                   KFLD                    CNTDRF
     C                   KFLD                    CNSEQN
     C
     C     DRefNo        CHAIN     SECRTNTPPD                         89
     C     *IN89         DOWEQ     *OFF
     C     K#Cert        CHAIN     SECRTNL1                           89
     C     *IN89         IFEQ      *OFF
     C                   CLEAR                   RTNT1
     C                   MOVEL     TEMPTN        RTNT1
     C                   UPDATE    SECRTNF1
     C                   ELSE
     C                   MOVEL     TEMPTN        RTNT1
     C                   WRITE     SECRTNF1
     C                   ENDIF
     C     DRefNo        READE     SECRTNTPPD                             89
     C                   ENDDO
     C
     C     DRefNo        CHAIN     SECRTTTPPD                         89
     C     *IN89         DOWEQ     *OFF
     C     DRefNo        CHAIN     SECRTTL1                           89
     C     *IN89         IFEQ      *OFF
     C                   CLEAR                   RTNT1
     C                   MOVEL     TEMPTT        RTTT1
     C                   UPDATE    SECRTTF1
     C                   ELSE
     C                   MOVEL     TEMPTT        RTTT1
     C                   WRITE     SECRTTF1
     C                   ENDIF
     C     DRefNo        READE     SECRTTTPPD                             89
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
     C*
     C* Update Audit totals if record updated
     C*
     C                   IF        UpdInd <> 'N'
     C*****CHTP*         IFEQ      'D'                                                        244855
     C     DCHTP         IFEQ      'D'                                                        244855
     C                   ADD       1             ##DDEL
     C                   SUB       1             ##DNOR
     C                   END
     C*****CHTP*         IFEQ      'A'                                                        244855
     C     DCHTP         IFEQ      'A'                                                        244855
     C                   ADD       1             ##DAMD
     C                   END
     C*****CHTP*         IFEQ      'I'                                                        244855
     C     DCHTP         IFEQ      'I'                                                        244855
     C                   ADD       1             ##DINS
     C                   ADD       1             ##DNOR
     C                   END
     C*
     C                   ELSE
     C                   EVAL      UpdInd = *Blanks
     C                   ENDIF
     C*
     C
     C*
     C** If S01401 is switched on depot movement extension records require
     C** update
     C*
     C                   IF        S01401 = 'Y'
     C
     C                   MOVEL     DPSS          K#DPSS           10
     C                   MOVEL     DRefNo        K#TDRF            6
     C
     C     K#RCD         KLIST
     C                   KFLD                    K#DPSS
     C                   KFLD                    K#TDRF
      *
      ** Copy temporary records across to permanent file
      *
     C     K#RCD         CHAIN     SEDMRPX1                           89
      *
      ** If new records are to be entered then delete old records
      *
     C     *IN89         IFEQ      *OFF
     C     K#RCD         CHAIN     DPTMVDY1                           88
     C     *IN88         DOWEQ     *OFF
     C                   DELETE    DPTMVDY1
     C     K#RCD         READE     DPTMVDY1                               88
     C                   ENDDO
     C                   ENDIF
      *
     C     *IN89         DOWEQ     *OFF
     C                   EVAL      DPDPRN = DDPRN
     C                   MOVEL     SEDX1         DPTY1
     C                   WRITE     DPMVY1
     C                   DELETE    DPTMVDD1
     C     K#RCD         READE     SEDMRPX1                               89
     C                   ENDDO
      *
      ** Copy temporary records across to permanent file
      *
     C     K#RCD         CHAIN     SEDMRPX2                           89
      *
      ** If new records are to be entered then delete old records
      *
     C     *IN89         IFEQ      *OFF
     C     K#RCD         CHAIN     DPTMVDY2                           88
     C     *IN88         DOWEQ     *OFF
     C                   DELETE    DPTMVDY2
     C     K#RCD         READE     DPTMVDY2                               88
     C                   ENDDO
     C                   ENDIF
      *
     C     *IN89         DOWEQ     *OFF
     C                   EVAL      D2DPRN = DDPRN
     C                   MOVEL     SEDX2         DPTY2
     C                   WRITE     DPMVY2
     C                   DELETE    DPTMVDD2
     C     K#RCD         READE     SEDMRPX2                               89
     C                   ENDDO
      *
     C                   ENDIF
     C
      ** Update Depo Positions file
     C*
     C*  Deal Deletion
     C*
     C     CHTP          IFEQ      'D'
     C                   EXSR      DDELET
     C                   ELSE
     C                   EXSR      DMAINT
     C                   END
     C*
     C** Reset ##DPNA
     C*
     C                   EVAL      ##DPNA = *Zero
     C
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed, write to the standard                       CSC011
      ** log file when support system is active                                               CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = *BLANKS                                         CSC011
     C                   EVAL      Counter = Counter + 1                                      CSC011
      ** Setup Loans/Deposits support log                                                     CSC011
                                                                                              CSC011
     C                   CALLB     'MMREPOLOG'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    IKLACT                                       CSC011
     C                   PARM                    DPTXX                                        CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    W#NOML                                       CSC011
                                                                                              CSC011
      ** Write to support database log file                                                   CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *BLANKS                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'MMRPDM'                                       CSC011
     C                   EVAL      APUSERID = PSUser                                          CSC011
     C                   EVAL      APRPRLOCN = IKREPA                                         CSC011
     C                   MOVEL     DMFRNT        APFOTRANID                                   CSC011
     C                   MOVEL     IKAFRT        APFOASOCID                                   CSC011
     C                   MOVEL     IKDN38        PDealNo                                      CSC011
     C                   EVAL      PADealNo = *BLANKS                                         CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       WTimestamp                                   CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM                    PADealNo                                     CSC011
                                                                                              CSC011
      ** If error occured,                                                                    CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLANKS                                      CSC011
                                                                                              CSC011
     C                   EVAL      ReturnCode = '*ERROR'                                      CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If processing the 1st record, save fee details for trailer update later.             CSC011
     C                   IF        My1st = 'Y'                                                CSC011
     C                   EVAL      THNARR = DPNR                                              CSC011
     C                   MOVEL     DCHA          THFEAM                                       CSC011
     C                   EVAL      THFECY = DCCE                                              CSC011
     C                   MOVEL     DCSE          THFESM                                       CSC011
     C                   EVAL      DDACCA = DCAT                                              CSC011
     C                   EVAL      DDACCB = DCAB                                              CSC011
     C                   EVAL      THACCN = W#ACCN                                            CSC011
     C                   EVAL      My1st = 'N'                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
     C*
     C** Delete record from temporary file and read next one
     C                   DELETE    SEDMRPXX
     C                   READ      SEDMRPXX                               89
     C
     C                   ENDDO
     C
     C                   IF        RetCodeOut = *BLANKS                                       CSC011
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed, write to the standard                       CSC011
      ** log file when support system is active                                               CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = *BLANKS                                         CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'MMRPTR'                                       CSC011
     C                   EVAL      APUSERID = PSUser                                          CSC011
     C                   EVAL      APRPRLOCN = IKREPA                                         CSC011
     C                   MOVEL     IKFRNT        APFOTRANID                                   CSC011
     C                   MOVEL     IKAFRT        APFOASOCID                                   CSC011
     C                   MOVEL     IKDN38        PDealNo                                      CSC011
     C                   EVAL      PADealNo = *BLANKS                                         CSC011
                                                                                              CSC011
     C                   MOVEL     Counter       THNODP                                       CSC011
     C                   MOVEL     W#NOML        THCNTN                                       CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = Trailer                                         CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       WTimestamp                                   CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM                    PADealNo                                     CSC011
                                                                                              CSC011
      ** If error occured,                                                                    CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLANKS                                      CSC011
                                                                                              CSC011
     C                   EVAL      ReturnCode = '*ERROR'                                      CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   CLOSE     SEDMRPXX
     C
     C                   END                                                                  CAP087
      *                                                                                       CAP087
     C                   RETURN
     C
     C********************************************************************
     C* DDELET - DEAL DELETION
     C********************************************************************
     C     DDELET        BEGSR
     C*
     C* Update User Depot Positions for reversals
     C*
     C                   MOVE      DDPID         DEPOT
     C                   EXSR      DEPREV
     C*
     C* Update Depot Movements Audit file
     C*
     C                   EXSR      UPDDPA
     C*
     C                   ENDSR
     C********************************************************************
     C* DMAINT - DEPOT MOVEMENT MAINTENANCE PERFORMED
     C********************************************************************
     C     DMAINT        BEGSR
     C*
     C* If change type is amend reverse nominal
     C* amount off positions file prior to new update
     C*
     C                   IF        DCHTP = 'A'
     C                   MOVE      DDPID         DEPOT
     C                   EXSR      DEPREV
     C                   ENDIF
     C*
     C* Update User Depot Positions for insertions
     C* and for amendments with the 'after' status
     C*
     C                   MOVE      DDPID         DEPOT
     C                   EXSR      DEPINS
     C*
     C* Update Depot Movements Audit file
     C*
     C                   EXSR      UPDDPA
     C*
     C* Update User Depot Positions Audit file
     C*
     C                   EXSR      UPDUDA
     C*
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  DEPINS - Subroutine to Update Depot Position Files - Insert. *
      *                                                               *
      *****************************************************************
     C     DEPINS        BEGSR
     C*
     C* Key to access User Depots
     C*
     C     UDEPPK        KLIST
     C                   KFLD                    DDPBA
     C                   KFLD                    DDPSS
     C**********         KFLD                    DEPOT             6 0                        CSD027
     C                   KFLD                    DEPOT             6                          CSD027
     C                   KFLD                    DDPBK
     C                   KFLD                    DDPMK
     C*
     C* Update User In depot - value fields only updated if movement date
     C* not after run date
     C*
     C     UDEPPK        CHAIN     UDEPPDF                            33
     C  N33RECI          COMP      '*'                                    34
     C*
     C* Not found, create new record
     C*
     C   33
     CORN33
     CAN 34              DO
     C                   MOVE      'D'           RECI
     C                   MOVE      DDPBA         UDBA
     C                   MOVE      DDPSS         UDSN
     C                   MOVE      DEPOT         UDPT
     C                   MOVE      DDPBK         UDBK
     C                   MOVE      DDPMK         UDMK
     C                   Z-ADD     BJRDNB        UDDT
     C                   Z-ADD     *ZEROS        UECN
     C                   Z-ADD     *ZEROS        UDNT
     C                   Z-ADD     *ZEROS        UDNV
     C                   Z-ADD     *ZEROS        UDNS
     C                   Z-ADD     *ZEROS        UNRT
     C                   Z-ADD     *ZEROS        UNRV
     C                   Z-ADD     *ZEROS        UDTP
     C                   Z-ADD     *ZEROS        UDPV
     C                   Z-ADD     *ZEROS        UDTS
     C                   Z-ADD     *ZEROS        UDSV
     C                   Z-ADD     *ZEROS        USNT
     C                   Z-ADD     *ZEROS        USNR
     C                   Z-ADD     *ZEROS        USNV
     C                   Z-ADD     *ZEROS        USRV
     C                   Z-ADD     *ZEROS        UNSI
     C                   END
     C*
     C     DDPMV         IFEQ      'RP'
     C     DDPMD         ANDGT     BJRDNB
     C     DDPMV         OREQ      'BL'
     C     DDPMD         ANDGT     BJRDNB
     C     DDPMV         OREQ      'PD'
     C     DDPMD         ANDGT     BJRDNB
     C                   SUB       DDPNA         USNT
     C     DDPDO         IFLE      BJRDNB
     C                   SUB       DDPNA         USNV
     C                   END
     C                   END
     C*
     C     DDPMV         IFEQ      'RR'
     C     DDPDO         ANDGT     BJRDNB
     C     DDPMV         OREQ      'BB'
     C     DDPMD         ANDGT     BJRDNB
     C     DDPMV         OREQ      'PL'
     C     DDPMD         ANDGT     BJRDNB
     C                   ADD       DDPNA         USNR
     C     DDPMD         IFLE      BJRDNB
     C                   ADD       DDPNA         USRV
     C                   END
     C                   END
     C*
     C* Write a record to the user depot positions file
     C*
     C     *IN33         IFEQ      '1'
     C                   WRITE     UDEPPDF
     C*
     C                   ADD       1             ##UINS
     C*
     C* Update an existing record on the user depot positions file
     C*
     C                   ELSE
     C                   UPDATE    UDEPPDF
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  DEPREV - Subroutine to Update Depot Position Files - Reverse *
      *                                                               *
      *****************************************************************
     C     DEPREV        BEGSR
     C*
     C* Update User In depot record
     C*
     C     UDEPPK        CHAIN     UDEPPDF                            33
     C*
     C     DDPMV         IFEQ      'RP'
     C     DDPMD         ANDGT     BJRDNB
     C     DDPMV         OREQ      'BL'
     C     DDPMD         ANDGT     BJRDNB
     C     DDPMV         OREQ      'PD'
     C     DDPMD         ANDGT     BJRDNB
     C                   ADD       ##DPNA        USNT
     C     DDPDO         IFLE      BJRDNB
     C                   ADD       ##DPNA        USNV
     C                   END
     C                   END
     C*
     C     DDPMV         IFEQ      'RR'
     C     DDPDO         ANDGT     BJRDNB
     C     DDPMV         OREQ      'BB'
     C     DDPMD         ANDGT     BJRDNB
     C     DDPMV         OREQ      'PL'
     C     DDPMD         ANDGT     BJRDNB
     C                   SUB       ##DPNA        USNR
     C     DDPMD         IFLE      BJRDNB
     C                   SUB       ##DPNA        USRV
     C                   END
     C                   END
     C*
     C  N33              UPDATE    UDEPPDF
     C*
     C                   ENDSR
     C********************************************************************
     C* UPDDPA - UPDATE DEPOT MOVEMENTS AUDIT
     C********************************************************************
     C     UPDDPA        BEGSR
     C*
     C* Update Audit file
     C*
     C     1             CHAIN     DPTMVAF                            99        *
     C     *IN99         IFEQ      '0'
     C                   ADD       ##DDEL        SDEL
     C                   ADD       ##DAMD        SAMD
     C                   ADD       ##DINS        SINS
     C                   ADD       ##DNOR        NORE
     C                   UPDATE    DPTMVAF
     C                   END
     C                   ENDSR
     C********************************************************************
     C* UPDUDA - UPDATE USER DEPOT POSITIONS
     C********************************************************************
     C     UPDUDA        BEGSR
     C*
     C* UPDATE THE AUDIT RECORD
     C*
     C     1             CHAIN     UDEPPAF                            99
     C     *IN99         IFEQ      '0'
     C                   ADD       ##UINS        NORE
     C                   UPDATE    UDEPPAF
     C                   END
     C                   ENDSR
     C********************************************************************
     C********************************************************************
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

     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    NwDlFilFmt
     C                   PARM                    DPTXX                                        CAP087
     C                   PARM                    DepotPos                                     CAP087
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMRPDLUPD'   DBPGM
     C                   OUT       LDA
      *
      ** Access securities trading details
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
     C*
      *
      ** Check if Australian Brokerage is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'S01401'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01401            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           S01401
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 904*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if CAC005 is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CAC005'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CAC005            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CAC005
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
     C                   END
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C                   PARM                    DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 007                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001

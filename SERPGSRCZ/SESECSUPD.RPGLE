     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security details database updates')           *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECSUPD - Security details database update                 *
      *                                                               *
      *  Function: This module performs the update of Midas database. *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSRPR                                      *
      *                SESECSUPP                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG11009           Date 30Mar06               *
      *                 237063             Date 20Nov05               *
      *                 CGL032             Date 05Jul04               *
      *                 BUG9529            Date 17Nov05               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 CSE037             Date 29Apr02               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208194             Date 20Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 CSE031             Date 27Nov01               *
      *                 193883             Date 21Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 03Oct00               *
      *                 CAP140             Date 17Oct00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG11009 - Wrong calculation of purchased interest.          *
      *             Applied fix 231841.                               *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *           (Introduced same code changes as that of BUG9529)   *
      *  CGL032 - Automatic Exchange of Information (Recompile)       *
      *  BUG9529 - Use full length of SEVSECSPD data structure        *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CSE037 - Countervalue rounding                               *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  208194 - Recalculate Last Coupon Date in Amend Mode if       *
      *           Rundate less than First Coupon Date. Applied concept*
      *           of core fix 186003 in API version.                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  193883 - To avoid DBerr set-up Front ID correctly.           *
      *  CSD006 - Market Data Feed - recompile, timestamp added to    *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs. Recompile only.   *
      *  CSE023 - Treaty Withholding Tax (Recompile)                  *
      *           EXVALD file                                         *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Securities details file
     FSECTY     UF A E           K DISK    COMMIT
      *
      ** Securities audit file
     FSECTYA    UF A E             DISK    COMMIT
     F                                     PREFIX(SA)
      *
      ** Extel price validation details file
     FEXVALD    UF A E           K DISK    COMMIT
     F                                     PREFIX(XD)
      *
      ** Extel price validation trailer file
     FEXVALZ    UF   E             DISK    COMMIT
     F                                     PREFIX(XZ)
      *
      ** Security diary events details file
     FSEDEV     UF A E           K DISK    COMMIT
     F                                     PREFIX(ED)
      *
      ** Security diary events audit file
     FSEDEVA    UF   E             DISK    COMMIT
     F                                     PREFIX(EA)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Securities for file update - valid file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
     D*NwSEFilFmt1             1    899                                               CSE065 BUG9529
      ** Coupon/Rate days
     D  CDArr                183    230
      ** Coupon/Rate inds
     D  CRArr                231    242
      *
      ** Securities for file update - Midas file format
     D SectyUpdf     E DS                  EXTNAME(SECTYD)
     D*SectyUpdf1              1    899                                               CSE065 BUG9529
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(CH)
      *
      ** Investment Types file
                                                                                              CSC011
      ** Switchable features description                                                      CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D  SCLCD        E                     EXTFLD(LCD)                                        CSC011
                                                                                              CSC011
      ** Dummy data structure                                                                 CSC011
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC011
                                                                                              CSE065
      ***DS*for*Access*Objects*-*long*data*structure*******************               CSE065 BUG9529
     D*DSSDY****     E DS                  EXTNAME(DSSDY)                             CSE065 BUG9529
                                                                                              CSC011
      ** 24x7 Status Data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** Midas API Message Header Format Definition                                           CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
     D PINVTPD       E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(P)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Work variables
     D WRTN            S              1A
     D WSREFN          S              7S 0
     D Wc              S              2P 0
     D WNoDel          S              5P 0
      *
      ** Parameters for ZARTVJOBA
     D PReturn         S              6A
     D PType           S              1A
     D WType           S              1A
      *
      ** Parameters for SE0042
     D WPVCCH          S              1A
     D WPMDCH          S              1A
     D WPERR           S              1A
      *
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
 
      *
      ** Standing Data
     D BVEXOP          S              1A
     D BJSBRC          S              3A
     D BJRDNB          S              5P 0
     D BJDFIN          S              1A
      *
      ** Switchable Features
     D CSE007          S              1A
     D CEU017          S              1A
     D S01511          S              1A
     D CSE031          S              1A                                                      CSE031
     D CSC011          S              1A                                                      CSC011
     D CSE037          S              1A                                                      CSE037
     D CSE071          S              1A                                                      CSE071
     D*CSE065***       S              1A                                              CSE065 BUG9529
     D CRE073          S              1A                                                      CRE073
      *
     D PDBRN           S              3A
     D PMode           S              6A
     D PFRNT           S             20A
     D PActn           S              1A
     D PSesN           S             10A
     D OKACTN          S              1A
     D OKSESN          S              1A
     D PTimeStamp      S             26Z
     D PMsgSndRtn      S             10A
     D PZLCD           S              5P 0
     D POSesN          S             10A
     D PPOldSecDtl     S              1A
     D PDBError        S            132A
     D PNatn           S              5P 0
      *                                                                                       CSE031
     D PRtCd           S              7A                                                      CSE031
     D POptn           S              7A                                                      CSE031
                                                                                              CSC011
      ** Entry Parameters for AOSARDR0                                                        CSC011
     D PRetCode        S              7A                                                      CSC011
     D POption         S              7A                                                      CSC011
     D PKey            S              6A                                                      CSC011
                                                                                              CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D Timestamp       S             26A                                                      CSC011
     D PDealNum        S             18A                                                      CSC011
     D PADealNo        S             18A                                                      CSC011
     D PReturnCode     S             10A                                                      CSC011
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Retrieve next available transaction number.
      *
     C                   CALLB     'ZTNLU1'
     C                   PARM                    RetCodeOut
     C                   PARM                    PNATN
      *
      ** Check for update by another workstation.
      *
     C                   EXSR      SRChkOthUpd
      *
      ** Continue processing if no errors found.
      *
     C                   IF        RetCodeIn = *BLANKS
      *
      ** Perform corresponding processing for Insert, Amend and Delete.
     C     S1CHTP        CASEQ     'I'           SRInsert
     C     S1CHTP        CASEQ     'A'           SRAmend
     C     S1CHTP        CASEQ     'D'           SRDelete
     C                   ENDCS
 
     C                   ENDIF
     C/COPY WNCPYSRC,SESECSDC01
      *
      ** Update audit record if no error occured.
      *
     C                   IF        RetCodeIn = *BLANKS
      *
      ** Fetch Audit record
     C     1             CHAIN     SECTYAF                            70
      *
      ** Update if found
     C     *IN70         IFEQ      '0'
 
     C                   SELECT
     C                   WHEN      S1CHTP = 'I'
     C                   EVAL      SASINS = SASINS + 1
     C                   EVAL      SANORE = SANORE + 1
 
     C                   WHEN      S1CHTP = 'A'
     C                   EVAL      SASAMD = SASAMD + 1
 
     C                   WHEN      S1CHTP = 'D'
     C                   EVAL      SASDEL = SASDEL + 1
     C                   EVAL      SANORE = SANORE - 1
     C                   ENDSL
 
     C                   Z-ADD     BJRDNB        SALCD
     C                   EVAL      SACHTP = 'A'
     C                   EVAL      SATNLU = PNATN
 
     C                   UPDATE    SECTYAF
 
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SECTYA'
     C                   EVAL      DBKEY = 'AUDIT'
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CSC011
      ** If SC24X7 is installed, call SESECSLOG and APLOGTRAN                                 CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
                                                                                              CSC011
     C                   CALLB     'SESECSLOG'                                                CSC011
     C                   PARM      *Blanks       PReturnCode                                  CSC011
     C                   PARM                    SectyUpdF                                    CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
     C                   IF        PReturnCode = *Blanks                                      CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'SESECS'                                       CSC011
     C                   EVAL      APFOTRANID = S1FRNT                                        CSC011
     C                   EVAL      APRPRLOCN  = S1REPA                                        CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
     C                   EVAL      PDealNum   = SESN                                          CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       PReturnCode                                  CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       Timestamp                                    CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PReturnCode <> *Blanks                                     CSC011
     C                   EVAL      RetCodeIn = '*ERROR'                                       CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert - Insert Securities record                          *
      *                                                               *
      *****************************************************************
     C     SRInsert      BEGSR
      *
      ** Check if record already exists in Securities file.
      ** Error if it already exists.
      *
     C     S1SESN        CHAIN     SECTYDF                            70
 
     C                   IF        *IN70 = *OFF AND RECI = 'D'
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SECTYD'
     C                   EVAL      DBKEY = S1SESN
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
 
     C                   ELSE
      *
      ** Generate Timestamp.
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
      *
      ** Get Last Coupon Rate
     C                   CALLB     'ZLCD'
     C                   PARM                    S1ISSD
     C                   PARM                    S1ITLD
     C                   PARM                    S1FCPN
     C                   PARM                    S1MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    S1LCPN                                     BUG11009
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    S1NMCY
     C                   PARM                    S1SITP
     C                   PARM                    S1BCNV
     C                   PARM                    S1HCY1                                       CSE071
     C                   PARM                    S1HCY2                                       CSE071
     C                   PARM                    S1HCY3                                       CSE071
     C                   PARM                    S1HCY4                                       CSE071
     C                   PARM                    S1HCY5                                       CSE071
     C                   PARM                    S1HCY6                                       CSE071
     C                   PARM                    S1HCY7                                       CSE071
     C                   PARM                    S1HCY8                                       CSE071
     C                   PARM                    S1HCY9                                       CSE071
     C                   PARM                    PZLCD
 
     C                   EVAL      S1TMST = PTimestamp
     C                   EVAL      S1TNLU = PNATN
     C                   EVAL      S1RECI = 'D'
     C                   Z-ADD     BJRDNB        S1LCD
     C                   Z-ADD     PZLCD         S1LCPN
      *                                                                                       CSE031
      ** In Insert mode make the Next Coupon Date equal to the First                          CSE031
      *  Coupon Date.                                                                         CSE031
     C                   IF        CSE031 = 'Y'                                               CSE031
     C                             OR CSE071 = 'Y'                                            CSE071
      *                                                                                       CSE031
     C                   CALL      'AOINVTR0'                                                 CSE031
     C                   PARM      *BLANKS       PRtcd                                        CSE031
     C                   PARM      '*KEY   '     POptn                                        CSE031
     C                   PARM                    S1SITP                                       CSE031
     C                   PARM                    S1NMCY                                       CSE031
     C     PINVTPD       PARM      PINVTPD       DSFDY                                        CSE031
                                                                                              CSE031
     C                   IF        PRtcd <> *BLANKS                                           CSE031
     C     *LOCK         IN        LDA                                                        CSE031
     C                   EVAL      DBKEY = S1SITP + S1NMCY                                    CSE031
     C                   EVAL      DBFILE = 'INVTPD'                                          CSE031
     C                   Z-ADD     16            DBASE                                        CSE031
     C                   OUT       LDA                                                        CSE031
     C                   EXSR      *PSSR                                                      CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   IF        PPROT = '3' OR PPROT = '8'                                 CSE031
     C                             OR CSE071 = 'Y' AND (PPROT = '1'                           CSE071
     C                             OR PPROT = '5' OR PPROT = '6' OR PPROT = '9')              CSE071
      *                                                                                       CSE031
     C                   Z-ADD     S1FCPN        S1NCD                                        CSE031
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE031
      *
      ** Initialise new fields added to File
     C                   EVAL      S1SRRB = *BLANKS
     C                   EVAL      S1SRBK = *ZEROS
 
     C**********         MOVEL     NwSEFilFmt    SectyUpdF                                    CSE065
     C**********         MOVEL     NwSEFilFmt1   SectyUpdF1                           CSE065 BUG9529
      *                                                                                       CSE065
     C**********         IF        CSE065 = 'Y'                                       CSE065 BUG9529
     C**********         Z-ADD     S1ALDT        ALDT                                 CSE065 BUG9529
     C**********         ELSE                                                         CSE065 BUG9529
     C**********         Z-ADD     *ZEROS        ALDT                                 CSE065 BUG9529
     C**********         ENDIF                                                        CSE065 BUG9529
     C                   MOVEL     NwSEFilFmt    SectyUpdF                                   BUG9529
 
     C                   ENDIF
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        FRNT = *BLANKS                                             CSC011
     C                   EVAL      FRNT = 'MD' + SESN                                         CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CRE073
      ** Update CRE073 fields                                                                 CRE073
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   EVAL      CNSP  = S1CNSP                                             CRE073
     C                   EVAL      CNSG  = S1CNSG                                             CRE073
     C                   EVAL      RDMT  = S1RDMT                                             CRE073
     C                   EVAL      RDFD  = S1RDFD                                             CRE073
     C                   EVAL      CNP01 = S1CNP01                                            CRE073
     C                   EVAL      CNG01 = S1CNG01                                            CRE073
     C                   EVAL      RDM01 = S1RDM01                                            CRE073
     C                   EVAL      RDF01 = S1RDF01                                            CRE073
     C                   EVAL      CNP02 = S1CNP02                                            CRE073
     C                   EVAL      CNG02 = S1CNG02                                            CRE073
     C                   EVAL      RDM02 = S1RDM02                                            CRE073
     C                   EVAL      RDF02 = S1RDF02                                            CRE073
     C                   EVAL      CNP03 = S1CNP03                                            CRE073
     C                   EVAL      CNG03 = S1CNG03                                            CRE073
     C                   EVAL      RDM03 = S1RDM03                                            CRE073
     C                   EVAL      RDF03 = S1RDF03                                            CRE073
     C                   EVAL      CNP04 = S1CNP04                                            CRE073
     C                   EVAL      CNG04 = S1CNG04                                            CRE073
     C                   EVAL      RDM04 = S1RDM04                                            CRE073
     C                   EVAL      RDF04 = S1RDF04                                            CRE073
     C                   EVAL      CNP05 = S1CNP05                                            CRE073
     C                   EVAL      CNG05 = S1CNG05                                            CRE073
     C                   EVAL      RDM05 = S1RDM05                                            CRE073
     C                   EVAL      RDF05 = S1RDF05                                            CRE073
     C                   EVAL      CNP06 = S1CNP06                                            CRE073
     C                   EVAL      CNG06 = S1CNG06                                            CRE073
     C                   EVAL      RDM06 = S1RDM06                                            CRE073
     C                   EVAL      RDF06 = S1RDF06                                            CRE073
     C                   EVAL      CNP07 = S1CNP07                                            CRE073
     C                   EVAL      CNG07 = S1CNG07                                            CRE073
     C                   EVAL      RDM07 = S1RDM07                                            CRE073
     C                   EVAL      RDF07 = S1RDF07                                            CRE073
     C                   EVAL      CNP08 = S1CNP08                                            CRE073
     C                   EVAL      CNG08 = S1CNG08                                            CRE073
     C                   EVAL      RDM08 = S1RDM08                                            CRE073
     C                   EVAL      RDF08 = S1RDF08                                            CRE073
     C                   EVAL      CNP09 = S1CNP09                                            CRE073
     C                   EVAL      CNG09 = S1CNG09                                            CRE073
     C                   EVAL      RDM09 = S1RDM09                                            CRE073
     C                   EVAL      RDF09 = S1RDF09                                            CRE073
     C                   EVAL      CNP10 = S1CNP10                                            CRE073
     C                   EVAL      CNG10 = S1CNG10                                            CRE073
     C                   EVAL      RDM10 = S1RDM10                                            CRE073
     C                   EVAL      RDF10 = S1RDF10                                            CRE073
      *                                                                                       CRE073
     C                   ENDIF                                                                CRE073
      *
      ** If record does not exist, write record on file. Otherwise,
      ** update record only if it is not a live record.
      *
     C                   IF        *IN70 = *ON
     C                   WRITE     SECTYDF                              99
     C                   ELSE
     C                   UPDATE    SECTYDF                              99
     C                   ENDIF
 
     C                   IF        *IN99 = *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     S1SREF        DBKey
     C                   MOVEL     'SECTYD '     DBFile
     C                   Z-ADD     13            DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *
      ** If the EXTEL option indicator is 'Y', output to PF/EXVALD
      *
     C                   IF        BVEXOP = 'Y'
     C                   EXSR      SRIVAL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIVAL - Subroutine to Insert Validation records with        *
      *           default values, for each new Security.              *
      *                                                               *
      *****************************************************************
     C     SRIVAL        BEGSR
      *
      ** Access validation details, If record already exist - error
      *
     C     S1SESN        CHAIN     EXVALD                             70
 
     C                   IF        *IN70 = *OFF AND XDRECI = 'D'
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'EXVALD'
     C                   EVAL      DBKEY = S1SESN
     C                   Z-ADD     3             DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
 
     C                   ELSE
      *
      ** Write validation details
     C                   EVAL      XDRECI = 'D'
     C                   EVAL      XDSESN = S1SESN
     C                   MOVEL     S1SREF        XDA1P
     C                   EVAL      XDEXAP = 'Y'
     C                   Z-ADD     0             XDUPBD
     C                   Z-ADD     0             XDLPBD
     C                   Z-ADD     0             XDPMOV
     C                   Z-ADD     BJRDNB        XDLCD
     C                   EVAL      XDCHTP = 'I'
     C                   EVAL      XDTNLU = PNATN
      *
      ** If record does not exist, write record on file. Otherwise,
      ** update record only if it is not a live record.
     C                   IF        *IN70 = *ON
     C                   WRITE     EXVALDF
     C                   ELSE
     C                   UPDATE    EXVALDF
     C                   ENDIF
      *
      ** Check trailer exists
     C     1             CHAIN     EXVALZ                             70
 
     C                   IF        *IN70 = *ON OR XZRECI <> 'Z'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'EXVALZ'
     C                   EVAL      DBKEY = 'MISSING TRAILER'
     C                   Z-ADD     4             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** Update trailer
     C                   EVAL      XZNINS = XZNINS + 1
     C                   EVAL      XZNORE = XZNORE + 1
     C                   UPDATE    EXVALZF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend - Amend Securities record                            *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR
      *
      ** Check if record already exists in Securities file.
      *
     C     S1SESN        CHAIN     SECTYDF                            70
      *
      ** Error if it does not exists.
      *
     C                   IF        *IN70
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SECTYD'
     C                   EVAL      DBKEY = S1SESN
     C                   Z-ADD     5             DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
     C/COPY WNCPYSRC,SESECSDC02
      *
      ** Check, if value currency or maturity date has changed
      *
     C                   IF        CSE007 = 'Y' OR CEU017 = 'Y'
 
     C                   IF        S1VLCY <> CHVLCY
     C                   MOVE      'Y'           WPVCCH
     C                   ELSE
     C                   MOVE      'N'           WPVCCH
     C                   ENDIF
 
     C                   IF        S1MATY <> CHMATY
     C                   MOVE      'Y'           WPMDCH
     C                   ELSE
     C                   MOVE      'N'           WPMDCH
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If feature S01511 is active
      *
     C                   IF        S01511 = 'Y'
      *
      ** If market indicator has been changed, check if market migration
      ** not active then set market migration indicator on security else
      ** do not continue with the market migration update
      *
     C                   IF        S1MKTI <> CHMKTI
 
     C                   IF        SMAI = 'Y'
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SECTYD'
     C                   EVAL      DBKEY = S1SESN
     C                   Z-ADD     6             DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
 
     C                   ELSE
 
     C                   MOVE      'Y'           SMAI
     C                   EXCEPT    MARKUP
      *
      ** Call SEC7000 to update markets on position, settlement and
      ** trades files.  This happens before the security is updated.
     C                   MOVE      'N'           WRTN
     C                   CALL      'SEC7000'
     C                   PARM                    S1SESN
     C                   PARM                    S1MKTI
     C                   PARM                    WRTN
      *
      ** If it is not successful then the security does not get updated.
     C                   IF        WRTN = '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SECTYD'
     C                   EVAL      DBKEY = S1SESN
     C                   Z-ADD     7             DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** CHAIN again to the security as the file pointer needs to reset.
     C     S1SESN        CHAIN     SECTYDF                            70
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      S1SMAI = 'N'
 
     C                   ENDIF
      *
      ** Generate Timestamp.
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
      *
      ** Translate records to file layout
      *
     C                   EVAL      S1TMST = PTimestamp
     C                   Z-ADD     BJRDNB        S1LCD
     C                   EVAL      S1TNLU = PNATN
     C**********         MOVEL     NwSEFilFmt    SectyUpdF                                    CSE065
     C**********         MOVEL     NwSEFilFmt1   SectyUpdF1                           CSE065 BUG9529
      *                                                                                       CSE065
     C**********         IF        CSE065 = 'Y'                                       CSE065 BUG9529
     C**********         Z-ADD     S1ALDT        ALDT                                 CSE065 BUG9529
     C**********         ELSE                                                         CSE065 BUG9529
     C**********         Z-ADD     *ZEROS        ALDT                                 CSE065 BUG9529
     C**********         ENDIF                                                        CSE065 BUG9529
     C                   MOVEL     NwSEFilFmt    SectyUpdF                                   BUG9529
      *
      ** If val. currency or maturity date has changed, update
      ** diary events before updating security record, if
      ** Corporate actions or Securities Redomination are installed.
      *
     C                   IF        CSE007 = 'Y' OR  CEU017 = 'Y'
     C/COPY WNCPYSRC,SESECSDC03
      *
     C                   IF        (WPVCCH = 'Y' AND S1ORED <> S1LCD) OR
     C                             (WPMDCH = 'Y' AND S1ORED <> S1LCD)
 
     C                   CALL      'SE0042'
     C                   PARM                    WPVCCH
     C                   PARM                    WPMDCH
     C                   PARM                    S1SESN
     C                   PARM                    VLCY
     C                   PARM                    SEXR
     C                   PARM                    SMDI
     C                   PARM                    MATY
     C                   PARM      *BLANK        WPERR
 
     C                   IF        WPERR <> *BLANK
      *
      ** Immediately end of program database error
     C                   IF        WPERR = '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SECET'
     C                   EVAL      DBKEY = S1SESN + 'XR'
     C                   Z-ADD     8             DBASE
     C                   OUT       LDA
     C                   ENDIF
 
     C                   IF        WPERR = '2'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SEDEVA'
     C                   EVAL      DBKEY = '1'
     C                   Z-ADD     9             DBASE
     C                   OUT       LDA
     C                   ENDIF
 
     C                   EXSR      SRERR
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      *                                                                                       208194
      ** Recalculate Last Coupon Date (LCPN) in Amend Mode if Rundate                         208194
      ** less than First Coupn Date (FCPN).                                                   208194
      *                                                                                       208194
     C                   IF        BJRDNB < FCPN                                              208194
     C                   CALLB     'ZLCD'                                                     208194
     C                   PARM                    S1ISSD                                       208194
     C                   PARM                    S1ITLD                                       208194
     C                   PARM                    S1FCPN                                       208194
     C                   PARM                    S1MATY                                       208194
     C                   PARM                    CDArr                                        208194
     C                   PARM                    CRArr                                        208194
     C                   PARM                    S1LCPN                                     BUG11009
     C                   PARM                    BJRDNB                                       208194
     C                   PARM                    BJDFIN                                       208194
     C                   PARM                    S1NMCY                                       208194
     C                   PARM                    S1SITP                                       208194
     C                   PARM                    S1BCNV                                       208194
     C                   PARM                    S1HCY1                                       CSE071
     C                   PARM                    S1HCY2                                       CSE071
     C                   PARM                    S1HCY3                                       CSE071
     C                   PARM                    S1HCY4                                       CSE071
     C                   PARM                    S1HCY5                                       CSE071
     C                   PARM                    S1HCY6                                       CSE071
     C                   PARM                    S1HCY7                                       CSE071
     C                   PARM                    S1HCY8                                       CSE071
     C                   PARM                    S1HCY9                                       CSE071
     C                   PARM                    PZLCD                                        208194
      *                                                                                       208194
     C                   EVAL      S1TMST = PTimestamp                                        208194
     C                   EVAL      S1TNLU = PNATN                                             208194
     C                   EVAL      S1RECI = 'D'                                               208194
     C                   Z-ADD     BJRDNB        S1LCD                                        208194
     C                   Z-ADD     BJRDNB        LCD                                          208194
     C                   Z-ADD     PZLCD         S1LCPN                                       208194
     C                   Z-ADD     PZLCD         LCPN                                         208194
     C                   ENDIF                                                                208194
      *                                                                                       208194
     C                   UPDATE    SECTYDF                              99
 
     C                   IF        *IN99 = *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     S1SREF        DBKey
     C                   MOVEL     'SECTYD '     DBFile
     C                   Z-ADD     14            DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *
      ** If the extel option indicator is 'Y', update PF/EXVALD
      *
     C                   IF        BVEXOP = 'Y'
     C                   EXSR      SRAVAL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAVAL - Subroutine to Amend Validation records, if present, *
      *           for an Amended Security.                            *
      *                                                               *
      *****************************************************************
     C     SRAVAL        BEGSR
      *
      ** Access validation details, If record does not exist - end process
      *
     C     S1SESN        CHAIN     EXVALD                             70
 
     C                   IF        *IN70 = *OFF AND XDRECI = 'D'
     C                   MOVE      S1SREF        WSREFN
      *
      ** Amend validation details
     C                   IF        WSREFN <> XDA1P
     C                   MOVEL     S1SREF        XDA1P
     C                   EVAL      XDTNLU = PNATN
     C                   Z-ADD     BJRDNB        XDLCD
     C                   EVAL      XDCHTP = 'A'
     C                   UPDATE    EXVALDF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDELETE - Delete Securities record                          *
      *                                                               *
      *****************************************************************
     C     SRDelete      BEGSR
      *
      ** Check if record already exists in Securities file.
      *
     C     S1SESN        CHAIN     SECTYDF                            70
      *
      ** Error if it does not exists.
      *
     C                   IF        *IN70 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SECTYD'
     C                   EVAL      DBKEY = S1SESN
     C                   Z-ADD     10            DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Generate Timestamp.
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
      *
      ** Amend last update details
      *
     C                   EVAL      TMST = PTimestamp
     C                   EVAL      RECI = 'C'
     C                   Z-ADD     BJRDNB        LCD
     C                   EVAL      CHTP = 'D'
     C                   EVAL      TNLU = PNATN
 
     C                   UPDATE    SECTYDF                              99
 
     C                   IF        *IN99 = *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     S1SREF        DBKey
     C                   MOVEL     'SECTYD '     DBFile
     C                   Z-ADD     15            DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check LF/SEDEV - Security Diary Events
      *
     C                   Z-ADD     0             WNODEL
     C     S1SESN        SETLL     SEDEVDF
     C     S1SESN        READE     SEDEVDF                                70
 
     C     *IN70         DOWEQ     '0'
     C     *IN70         IFEQ      '0'
     C     EDRECI        ANDEQ     'M'
     C                   MOVE      '*'           EDRECI
     C                   UPDATE    SEDEVDF
     C                   ADD       1             WNODEL
     C                   ENDIF
     C     S1SESN        READE     SEDEVDF                                70
     C                   ENDDO
 
     C                   IF        WNODEL > 0
     C     1             CHAIN     SEDEVAF                            70
     C                   IF        *IN70
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SEDEVA'
     C                   EVAL      DBKEY = 'MISSING TRAILER'
     C                   Z-ADD     11            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      EANORE = EANORE - WNODEL
     C                   EVAL      EANODE = EANODE + WNODEL
     C                   UPDATE    SEDEVAF
     C                   ENDIF
     C                   ENDIF
      *
      ** If the extel option indicator is 'Y', update PF/EXVALD
      *
     C                   IF        BVEXOP = 'Y'
     C                   EXSR      SRDVAL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDVAL - Subroutine to Delete Validation records, if present,*
      *           for a Deleted Security.                             *
      *                                                               *
      *****************************************************************
     C     SRDVAL        BEGSR
      *
      ** Access validation details, If record does not exist - end process
      *
     C     S1SESN        CHAIN     EXVALD                             70
 
     C                   IF        *IN70 = *OFF AND XDRECI = 'D'
 
     C                   EVAL      XDRECI = '*'
     C                   Z-ADD     BJRDNB        XDLCD
     C                   EVAL      XDCHTP = 'D'
     C                   EVAL      XDTNLU = PNATN
     C                   UPDATE    EXVALDF
      *
      ** Check trailer exists
     C     1             CHAIN     EXVALZ                             70
 
     C                   IF        *IN70 = *ON OR XZRECI <> 'Z'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'EXVALZ'
     C                   EVAL      DBKEY = 'MISSING TRAILER'
     C                   Z-ADD     12            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** Update trailer
     C                   EVAL      XZNDEL = XZNDEL + 1
     C                   UPDATE    EXVALZF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkOthUpd - Check for update by another workstation        *
      *                                                               *
      *****************************************************************
     C     SRChkOthUpd   BEGSR
      *
      ** Determine whether program is running interactively or in batch
      ** ( 0 = batch   1 = interactive).
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PReturn
     C                   PARM                    Ptype
      *
      ** If Insert, set retrieve mode to '*FRONT' (Access using Front Office
      ** Id).  Otherwise, set retrieve mode to blank  (Access using Midas
      ** transaction Id).
      *
     C                   EVAL      WType = PType
 
     C**********         IF        S1CHTP <> 'I'                                193883
     C**********         MOVEL     '1'           WType                          193883
     C**********         ENDIF                                                  193883
 
     C                   IF        WType = '0'
      *                                                                         193883
     C     S1CHTP        IFeq      'I'                                          193883
     C                   MOVE      '*FRONT'      PMode
     C                   ELSE
     C                   MOVE      *BLANKS       PMode
     C                   END                                                    193883
      *                                                                         193883
     C                   ELSE                                                   193883
     C                   MOVE      *BLANKS       PMode                          193883
     C                   ENDIF
 
     C                   CALLB     'SESECSRTV'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM      *BLANK        ARRespMode
      *
      ** Action Code
     C                   PARM      S1CHTP        PACTN
      *
      ** Front Office Transaction Id
     C                   PARM      S1FRNT        PFRNT
      *
      ** Security shortname
     C                   PARM      S1SESN        PSESN
      *
      ** Old Security from link proccessing
     C                   PARM      *BLANKS       POSESN
      *
      ** Process old security details indicator
     C                   PARM      *BLANKS       PPOldSecDtl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK Security Shortname
     C                   PARM                    OKSESN
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment type details
     C                   PARM                    PINVTPD
      *
      ** Error if Timestamp is not the same (record has been changed
      ** by another workstation).
      *
      ** Processing varies according to mode program is running in.
      ** In interacive mode, simply check whether the Timestamp field
      ** has been updated since the original Incoming Security was
      ** fetched by this program.  In batch (API input), check return
      ** parameters from retrieve module for errors, and send
      ** message to system operator.
      *
      ** Interactive mode:
      *
     C                   IF        PType = '1'
 
     C                   IF        CHTMST <> S1TMST
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   ENDIF
      *
      ** Batch mode:
      *
     C                   ELSE
 
     C                   IF        OKACTN = 'N' OR OKSESN = 'N'
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   Z-ADD     1             Wc
 
     C     Wc            DOWLE     ArrayMax
     C     FldNameArr(Wc)ANDNE     *BLANKS
     C                   CLEAR                   PDBError
     C                   EVAL      PDBError = MsgIDArr(Wc)
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn
     C                   PARM                    PDBError
     C                   PARM      *BLANKS       PDummyMsgID
     C                   PARM      *BLANKS       PDummyMsgF
     C                   ADD       1             Wc
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERR - Routine for Exception Errors                         *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
 
     C                   EVAL      RetCodeIn = '*ERROR '
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
      *
      ** Terminate program.
      *
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDSTRD - Extel option
     C                   PARM                    BVEXOP
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Midas Run Day Number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate Actions
     C                   PARM                    CSE007
      *
      ** Securities Redenomination
     C                   PARM                    CEU017
      *
      ** Market migration
     C                   PARM                    S01511
      *
      ** MDF
     C                   PARM                    CSD006            1                          CSD006
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE037
      ** Coupon Fixing for Floating Rate Notes.                                               CSE037
     C                   PARM                    CSE037                                       CSE037
      *                                                                                       CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
                                                                                              CSC011
      ** Check if 24x7 Midas Availability is installed                                        CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *Blanks       PRetCode                                     CSC011
     C                   PARM      '*VERIFY'     POption                                      CSC011
     C                   PARM      'CSC011'      PKey                                         CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRetCode = *Blanks                                         CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   IF        PRetCode <> '*NRF   '                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBASE  = 901                                               CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CRE073
      ** Check if CRE073 is installed                                                         CRE073
                                                                                              CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRetCode                                     CRE073
     C                   PARM      '*VERIFY'     POption                                      CRE073
     C                   PARM      'CRE073'      PKey                                         CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C                   IF        PRetCode = *BLANKS                                         CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   IF        PRetCode <> '*NRF   '                                      CRE073
     C     *LOCK         IN        LDA                                                        CRE073
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBKEY  = 'CRE073'                                          CRE073
     C                   EVAL      DBASE  = 903                                               CRE073
     C                   OUT       LDA                                                        CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CSE065
      ***Check*if*CSE065*is*installed**********************************               CSE065 BUG9529
     C**********         EVAL      CSE065 = 'N'                                       CSE065 BUG9529
     C**********         CALLB     'AOSARDR0'                                         CSE065 BUG9529
     C**********         PARM      *Blanks       PRetCode                             CSE065 BUG9529
     C**********         PARM      '*VERIFY'     POption                              CSE065 BUG9529
     C**********         PARM      'CSE065'      PKey                                 CSE065 BUG9529
     C*****SCSARD        PARM      SCSARD        DSSDY                                CSE065 BUG9529
                                                                                              CSE065
     C**********         IF        PRTCD = *Blanks                                    CSE065 BUG9529
     C**********         EVAL      CSE065 = 'Y'                                       CSE065 BUG9529
     C**********         ELSE                                                         CSE065 BUG9529
     C**********         IF        PRTCD <> '*NRF   '                                 CSE065 BUG9529
     C******LOCK         IN        LDA                                                CSE065 BUG9529
     C**********         EVAL      DBFILE = 'SCSARDPD'                                CSE065 BUG9529
     C**********         EVAL      DBKEY  = 'CSE065'                                  CSE065 BUG9529
     C**********         EVAL      DBASE  = 902                                       CSE065 BUG9529
     C**********         OUT       LDA                                                CSE065 BUG9529
     C**********         EXSR      *PSSR                                              CSE065 BUG9529
     C**********         ENDIF                                                        CSE065 BUG9529
     C**********         ENDIF                                                        CSE065 BUG9529
     C/COPY WNCPYSRC,SESECSDC04
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     OSECTYDF   E            MARKUP
     O                       SMAI
      *****************************************************************
      /EJECT
      *****************************************************************
      *

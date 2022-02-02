     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058079
/*STD *  RPGSQLBND                                                    *                     MD058079
/*EXI *  TEXT('Midas GL Fontis i/f - intra-day proj. mvmts. gen.')
      *****************************************************************
      *                                                               *
      *  Midas - Midas-Fontis Interface                               *
      *                                                               *
      *  GL2805 - Intra-day Proj. Mvmts Generation                    *
      *                                                               *
      *  Function:  To process the real time posting file for all     *
      *             active Fontis accounts and generate a MT942       *
      *             message for each active account.                  *
      *                                                               *
      *  Close of Business                                            *
      *                                                               *
      *  Called By: GLC2805 - Clears member FONTIS942 in PF/GLFDTAPD  *
      *                       and replaces it with an updated copy    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058079           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 08Mar10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CPK016             Date 03Sep03               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 181476             Date 13Jul00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW020             Date 11JAN00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 169692             Date 20OCT99               *
      *                 169526             Date 20OCT99               *
      *                 166768             Date 11Aug99               *
      *                 165718             Date 11Aug99               *
      *                 165717             Date 11Aug99               *
      *                 CGL007             Date 26Mar99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CGL004 *CREATE     Date 17JAN97               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058079 - Deliverable Data Split for sundry files           *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CPK016 - Release 5 packaging.  Clash of field names.         *
      *  181476 - Value date and posting date are in wrong order for  *
      *            field :61:.                                        *
      *  CSW020 - SWIFT Decimal Places                                *
      *           Add a new parameter for program ZM0040              *
      *  169692 - With CGL006 installed, some postings which have     *
      *           been reported in the previous MT942 still get       *
      *           reported on the new one.                            *
      *  169526 - Provide recovery for GLFONAPD and GLRSSVPD.         *
      *  166768 - Statement number on fld 28 should be increment      *
      *           for each message  generated.                        *
      *  165718 - Always output both :90C: and :90D: tags even if     *
      *           either debit or credit total is 0; if both DR and   *
      *           CR amounts are 0, no interim message is produced.   *
      *  165717 - Field :25: should contain the Midas Retail Number if*
      *           retail account numbers are supported by the system. *
      *  CGL007 - Account Postings Enquiry (Recompile)                *
      *  CGL004 - Midas-Fontis Interface                              *
      *                                                               *
      *****************************************************************
     F***GLFONAL0IF**E        K        DISK                               166768
     FGLFONAL0  UF   E           K DISK                                         166768
     F                                     INFSR(*PSSR)                         169526
     F                                     COMMIT                               169526
     FRSACMTL1  IF   E           K DISK
     F                                     IGNORE(APOSTPDF)
     FGLRSSVL1  IF   E           K DISK                                         CGL006
     F                                     RENAME(RSACMTPO:GLRSL1PO)
     FACCNT     IF   E           K DISK
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
     F***GLRSSVPDO***E           K        DISK                     CGL006 169526
     FGLRSSVPD  O    E           K DISK    USROPN                               169526
     F                                     RENAME(RSACMTPO:GLRSSVPO)
     F                                     INFSR(*PSSR)                         169526
     F                                     COMMIT                               169526
     F*GLFNARL0* IF   E           K DISK                                                    MD058079
     FGLFREFL0  UF A E           K DISK
     FGLFDTAPD  O    E             DISK
     F/COPY WNCPYSRC,GL2805F001
     FGL2805AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
      /EJECT
      *****************************************************************
      *                                                               *
      *   Indicator Usage                                             *
      *   ---------------                                             *
      *                                                               *
      *   21        Member not found on message ref. file GLFREFL0    *
      *   22        No Record Found/Last record on GLFONAL0           *
      *   23        Account not found on account master file ACCNT    *
      *   25        Acc not found on today's posting file RSACMTL1    *
      *                                            format APOSTPDF    *
      *   26        No Rec Found/Last rec on Narrative file GLFNARL0  *
      *   30        No Records found on 1 or more files               *
      *   31        Error on write of detail line                     *
      *                                                               *
      *   U7 & U8   Database error                                    *
      *   nn        X                                                 *
      *                                                               *
      *****************************************************************
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D @FM             S              1    DIM(256)
      *
     D RSACMT        E DS                  EXTNAME(GLRSSVPD)
     D**********                              1  15 ACCTNO                                    CGL029
     D  CUSCCY                 1      9
      *
     D GLRSSV        E DS                  EXTNAME(GLRSSVPD)
     D  CUSNGL       E                     EXTFLD(CUSN)
     D  CCYDGL       E                     EXTFLD(CCYD)
     D  #ACDE@       E                     EXTFLD(ACDEQQ)
     D  ACDEGL       E                     EXTFLD(ACDE)
     D  ASNCGL       E                     EXTFLD(ASNC)
     D  BRCAGL       E                     EXTFLD(BRCA)
     D  PTDTGL       E                     EXTFLD(PTDT)
     D  VUDTGL       E                     EXTFLD(VUDT)
     D  TRYPGL       E                     EXTFLD(TRYP)
     D  NRTCGL       E                     EXTFLD(NRTC)
     D  NRTDGL       E                     EXTFLD(NRTD)
     D  TNMRGL       E                     EXTFLD(TNMR)
     D  CQNRGL       E                     EXTFLD(CQNR)
     D  MVAMGL       E                     EXTFLD(MVAM)
     D  DORCGL       E                     EXTFLD(DORC)
     D  FUNDGL       E                     EXTFLD(FUND)
     D  TBIDGL       E                     EXTFLD(TBID)
     D  APBIGL       E                     EXTFLD(APBI)
     D  PASSGL       E                     EXTFLD(PASS)
     D  XRFIGL       E                     EXTFLD(XRFI)
     D  XRFNGL       E                     EXTFLD(XRFN)
     D  #FUND@       E                     EXTFLD(FUNDQQ)
     D  OTR1GL       E                     EXTFLD(OTR1)
     D  CMODGL       E                     EXTFLD(CMOD)
     D  ETYPGL       E                     EXTFLD(ETYP)
     D  MTYPGL       E                     EXTFLD(MTYP)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** LDA for database error reporting
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
     D  @JOB                 244    253
     D  @USER                254    263
     D  @NUM                 264    269
      ** Program Status Data Structure - gives Job name, user and
      ** number
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for bank details table
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    165717
      * Data Structure for Midas Module Details Access Program            165717
     D*                                                                   165717
     D SDRETL        E DS                  EXTNAME(SDRETLPD)                    165717
      * Data Structure for Retail Data Access Program                     165717
      *                                                                   165717
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure for currency details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Data structure for customer details
      *
     D GLFONT        E DS           256    EXTNAME(GLFONTDA)
      ** FONTIS Data Area
     D GLFNAR        E DS                  EXTNAME(GLFNAJW0)                                MD058079
     D/COPY WNCPYSRC,GL2805I001
      *
     D MNM             DS
     D  W@MNM                  1     10
     D  W@MDAT                 2      7  0
      ** Member name - date
      *
     D SPOOLU          DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
      ** File Information Data Structure for GL2805AU
      *
     D @20             DS
     D  @PFX                   1      2
     D  @DAT                   3      8  0
     D  @TIM                   9     12  0
     D  @SEQ                  13     15  0
      ** Transaction Reference Number data structure
      *
     D                 DS
     D**********                              1  18 F1FULA                                    CGL029
     D  F1FULA                 1     24
     D  K#BRCA                 1      3
     D**********                              4   90K#CNUM                                    CSD027
     D  K#CNUM                 4      9
     D  K#CCY                 10     12
     D**********                             13  160K#ACOD                                    CGL029
     D**********                             17  180K#ACSQ                                    CGL029
     D  K#ACOD                13     22  0
     D  K#ACSQ                23     24  0
      ** Full Account Data Structure(GLFONAPD)
      *
      ** Full Account Data Structure(RSACMTL1)
      *
     D                 DS
     D  @DATA                  1    256
     D  @TO                    1    256
     D                                     DIM(256)
     D  @TAG4                  1      4
     D  @TAG5                  1      5
     D/COPY WNCPYSRC,GL2805I003
     D  @DAT4                  5    256
     D  @DAT5                  6    256
      ** Message data
      *
     D                 DS
     D  SPOS                   1      7
     D  @SPID                  6      7
      ** Source of posting
      *
     D                 DS
     D  @28                    1      9
     D  @28S1                  1      5  0
     D  @28SL                  6      6    INZ('/')
     D  @28S2                  7      9
      ** Field :28:
     D                 DS
     D  @34F                   1      5
     D  @34FS1                 1      3
     D  @34FS2                 4      5
      ** Field :34F:
      *
     D                 DS
     D  @13                    1     10
     D  @13S1                  1      6
     D  @13S2                  7     10
      ** Field :13:
      *
     D                 DS
     D  @61                    1     55
     D  @61S1                  1      6
     D  @61S2                  7     10
     D  @61S3                 11     11
      ** SWIFT Currency field (@61S4) not required
     D  @61S5                 12     26
     D  @61S6                 27     30
     D  @61S6A                27     27
     D  @61S6B                28     30
     D  @61S7                 31     46
     D  @61S8                 47     55
     D  @61S8A                47     48
     D  @61S8B                49     49
     D  @61S8C                50     55
     D  @61S8D                49     55
      ** Field :61: subfields 1 to 8
      *
     D                 DS
     D  @90D                   1     23
     D  @90DS1                 1      5  0
     D  @90DS2                 6      8
     D  @90DS3                 9     23
      ** Field :90D:
      *
     D                 DS
     D  @90C                   1     23
     D  @90CS1                 1      5  0
     D  @90CS2                 6      8
     D  @90CS3                 9     23
      ** Field :90C:
      *
     D                 DS
     D  @ASIR                  1      7
     D  @MODI                  1      1
     D  @TNMR                  2      7
      ** GL posting reference for field :61: subfield 8
      *
     D                 DS
     D  @F4DAT                 1    256
     D  @F4S1                  1      6    INZ('{1:F01')
     D  @F4S2                  7     18
     D  @F4S3                 19     36    INZ('0000000000}{2:I942')
     D  @F4S4                 37     48    INZ('            ')
     D  @F4S5                 49    128    INZ('U3003}{4:')
      ** Swift Header
      *
     D                 DS
     D  W#NEWT                 1      6  0
     D  W#NEW2                 1      4  0
      *
     D FONT            C                   CONST('FONTIS942')
      ** Arrays used to compress data in field :61:
      *
     IGLRSL1PO
     I              CUSN                        CUSNGL
     I              CCYD                        CCYDGL
     I              ACDE                        ACDEGL
     I              ASNC                        ASNCGL
     I              BRCA                        BRCAGL
     I              PTDT                        PTDTGL
     I              VUDT                        VUDTGL
     I              TRYP                        TRYPGL
     I              NRTC                        NRTCGL
     I              NRTD                        NRTDGL
     I              TNMR                        TNMRGL
     I              CQNR                        CQNRGL
     I              MVAM                        MVAMGL
     I              DORC                        DORCGL
     I              FUND                        FUNDGL
     I              TBID                        TBIDGL
     I              APBI                        APBIGL
     I              PASS                        PASSGL
     I              XRFI                        XRFIGL
     I              XRFN                        XRFNGL
     I              OTR1                        OTR1L
     I              CMOD                        CMODGL
     I              ETYP                        ETYPGL
     I              MTYP                        MTYPGL
     I/COPY WNCPYSRC,GL2805I002
      *
      /EJECT
      *
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   INIT      Initial process                                   *
      *   MAIN      Main detail process                               *
      *   CREATE    Create ISO MT942                                  *
      *   FLD20     Create field :20: (Transaction Reference Number)  *
      *   FLD25     Create field :25: (Account i/d)                   *
      *   FLD28C    Create field :28C:(Statement number/sequence)     *
      *   FLD34F    Create field :34F:(Floor Limit Indicator)         *
      *   FLD13     Create field :13: (Date/Time Indicator)           *
      *   FLD61     Create all field :61:s (Postings)                 *
      *   SF6       Format field :61:, subfield 6                     *
      *   SF7       Format field :61:, subfield 7                     *
      *   SF8       Format field :61:, subfield 8                     *
      *   SF9       Format field :61:, subfield 9                     *
      *   FLD90D    Create field :90D: (No. & sum of debit entries)   *
      *   FLD90C    Create field :90C: (No. & sum of credit entries)  *
      *   AUDIT     Audit Report and End Program                      *
      *   *PSSR     Process errors                                    *
      *                                                               *
      *****************************************************************
      *
      /EJECT
      *
      *================================================================
      *  P R O G R A M    S T A R T                                   *
      *================================================================
      *
      ** Receive Parameter List
     C     *ENTRY        PLIST
     C                   PARM                    MNM              10
     C**********           PARM           ANUM   18                                           CGL029
     C                   PARM                    ANUM             24
      *
      ** Execute initial process
     C                   EXSR      INIT
      *
      ** Execute main detail process
     C                   EXSR      MAIN
      *
      ** Output Audit Report and End Program
     C                   EXSR      AUDIT
     C*                                                                   169526
     C                   COMMIT                                                                16952
      *                                                                   169526
      *  Close file at this exit point.  (This code is not done on        169526
      *  *PSSR as it will be automatically closed when the job ends.)     169526
     C     CGL006        IFEQ      'Y'                                                         16952
     C                   CLOSE     GLRSSVPD                                                    16952
     C                   ENDIF                                                                 16952
      *
      ** Terminate RPG program
     C                   SETON                                        LR
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  INIT                                           *
      * Function    :  Perform initial processing                     *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  AOBANKR0                                       *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
      ** Initialise object copyright statement
     C                   MOVEA     CPY@          MKI@             80
      *
      ** Initialise LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBASE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVEL     'GL2805'      DBPGM
     C                   OUT       LDA
      *
      ** Initialise record counters
     C                   Z-ADD     0             W@RED
     C                   Z-ADD     0             W@WRI
      *
      ** Initialise work field for value date
     C                   MOVE      *BLANKS       W@61S2            6
      *
      ** Set up key list for full account id.
     C     K#ACID        KLIST
     C**********           KFLD           K#CNUM  60                                          CSD027
     C                   KFLD                    K#CNUM            6
     C                   KFLD                    K#CCY             3
     C**********           KFLD           K#ACOD  40                                          CGL029
     C                   KFLD                    K#ACOD
     C                   KFLD                    K#ACSQ            2 0
     C                   KFLD                    K#BRCA            3
      *
      ** Set up key list for full account id. (for rsacmtl1 &GLRSSVL1)
     C     K#ACMT        KLIST
     C                   KFLD                    K#BRCA            3
     C**********           KFLD           K#CNUM  60                                          CSD027
     C                   KFLD                    K#CNUM            6
     C                   KFLD                    K#CCY             3
     C**********           KFLD           K#ACOD  40                                          CGL029
     C                   KFLD                    K#ACOD
     C                   KFLD                    K#ACSQ            2 0
      *                                                                   169692
      ** Set up key list for full account id. (for GLRSSVL1)              169692
     C     K#ACM2        KLIST                                                                 16969
     C                   KFLD                    K#BRCA            3                           16969
     C**********           KFLD           K#CNUM  60                                   169692 CSD027
     C                   KFLD                    K#CNUM            6
     C                   KFLD                    K#CCY             3                           16969
     C**********           KFLD           K#ACOD  40                                   169692 CGL029
     C                   KFLD                    K#ACOD
     C                   KFLD                    K#ACSQ            2 0                         16969
     C                   KFLD                    VUDT                                          16969
     C                   KFLD                    MVAM                                          16969
     C                   KFLD                    DORC                                          16969
      *
      *
      ** Set up key list to access narrative table
     C     K#FNAR        KLIST
     C                   KFLD                    L#TTYP            2
     C                   KFLD                    L#FTTR            1
      *
      ** Access SDBANKPD for bank ICD
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C                   PARM                    SDBANK
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '001'         DBASE                          * * * * * * * *
     C                   MOVEL     'FIRST'       DBKEY                          *  DBERR 001  *
     C                   MOVEL     'SDBANKPD'    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/COPY WNCPYSRC,GL2805C011
      ** Check whether Retail installed and Retail A/C Numbers supported  165717
      *                                                                   165717
     C                   CALL      'AOMMODR0'                                                  16571
     C                   PARM      '*MSG    '    @RTCD             7                           16571
     C                   PARM      '*FIRST  '    @OPTN             7                           16571
     C                   PARM                    SDMMOD                                        16571
      *                                                                   165717
     C     @RTCD         IFNE      *BLANKS                                                     16571
     C     *LOCK         IN        LDA                                                         16571
     C                   MOVE      '007'         DBASE                          * * * * * * * *16571
     C                   MOVEL     'FIRST'       DBKEY                          *  DBERR 007  *16571
     C                   MOVEL     'SDMMODPD'    DBFILE                         * * * * * * * *16571
     C                   OUT       LDA                                                         16571
     C                   EXSR      *PSSR                                                       16571
     C                   ENDIF                                                                 16571
      *                                                                   165717
     C     BGRTBN        IFEQ      'Y'                                                         16571
     C     BGNXST        OREQ      'Y'                                                         16571
     C                   CALL      'AORETLR0'                                                  16571
     C                   PARM      '       '     @RTCD             7                           16571
     C                   PARM      '*FIRST '     @OPTN             7                           16571
     C                   PARM                    SDRETL                                        16571
      *                                                                   165717
     C     @RTCD         IFNE      *BLANKS                                                     16571
     C     *LOCK         IN        LDA                                                         16571
     C                   MOVE      '008'         DBASE                          * * * * * * * *16571
     C                   MOVEL     'FIRST'       DBKEY                          *  DBERR 008  *16571
     C                   MOVEL     'SDRETLPD'    DBFILE                         * * * * * * * *16571
     C                   OUT       LDA                                                         16571
     C                   EXSR      *PSSR                                                       16571
     C                   ENDIF                                                                 16571
     C                   ENDIF                                                                 16571
      *
      ** Check whether switchable feature CGL005, to use field 28c
      ** instead of 28 is switched on.
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL005'      @SAR              6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL005            1
     C                   ENDIF
      *
      ** Check whether switchable feature CGL006, to produce incrementa
      ** MT942 messages for fontis V3 is switche on
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL006'      @SAR              6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL006            1
     C                   OPEN      GLRSSVPD                                                    16952
     C                   ENDIF
     C/COPY WNCPYSRC,GL2805C001
      *                                                                   CSW020
      ** Check whether switchable feature CSW020, SWIFT decimal           CSW020
      ** places is switched on.                                           CSW020
     C                   CALL      'AOSARDR0'                                                  CSW02
     C                   PARM      *BLANKS       @RTCD                                         CSW02
     C                   PARM      '*VERIFY'     @OPTN                                         CSW02
     C                   PARM      'CSW020'      @SAR              6                           CSW02
      *                                                                   CSW020
     C     @RTCD         IFEQ      *BLANK                                                      CSW02
     C                   MOVE      'Y'           CSW020            1                           CSW02
     C                   MOVE      'N'           WSWDPC            1                           CSW02
     C                   ELSE                                                                  CSW02
     C                   MOVE      ' '           WSWDPC                                        CSW02
     C                   ENDIF                                                                 CSW02
      *
     C                   ENDSR                                                  INIT
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  MAIN                                           *
      * Function    :  Perform main detail processing                 *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  CREATE                                         *
      *****************************************************************
      *
     C     MAIN          BEGSR
      *
     C     ANUM          IFNE      *BLANKS                                      B01
     C     ANUM          CHAIN     GLFONAL0                           22
     C                   ELSE                                                   I01
     C                   READ      GLFONAL0                               22
     C                   ENDIF                                                  E01
      *
      ** No records found
     C     *IN22         IFEQ      '1'                                          B01
     C                   MOVE      *ON           *IN30
     C                   ELSE                                                   I01
      *
      ** Do while not EOF
     C     *IN22         DOWEQ     '0'                                          B02
     C                   ADD       1             W@RED
      *
      ** Next working day
     C     F1WD42        IFLT      BJDNWD                                       B03
     C     F1GN42        ANDEQ     'Y'
      *
     C     K#ACID        CHAIN     ACCNT                              23
      *
      ** If record not found perform standard DB Error processing
     C     *IN23         IFEQ      '1'                                          B04
     C     *LOCK         IN        LDA
     C                   MOVE      '002'         DBASE                          * * * * * * * *
     C                   MOVEL     'PROGRAM'     DBKEY                          *  DBERR 002  *
     C                   MOVEL     'ACCNT   '    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE                                                   I04
      *
      ** Live account details are found
     C     RECI          IFEQ      'D'                                          B05
     C     F1FONA        ANDEQ     'Y'
     C     F1ATVD        ANDLT     BJDNWD
     C     F1DATV        ANDEQ     *ZEROS
     C     RECI          OREQ      'D'                                          I05
     C     F1FONA        ANDEQ     'Y'
     C     F1ATVD        ANDLT     BJDNWD
     C     F1DATV        ANDGE     BJDNWD
      *
      ** Generate MT942 message
     C                   EXSR      CREATE
      *
     C                   ENDIF                                                  E05
     C                   ENDIF                                                  E04
     C                   ENDIF                                                  E03
     C                   READ      GLFONAL0                               22
      *
     C     ANUM          IFNE      *BLANKS                                      B03
     C                   SETON                                        22
     C                   ENDIF                                                  E03
      *
     C                   ENDDO                                                  E02
      *
     C                   ENDIF                                                  E01
      *
     C                   ENDSR                                                  MAIN
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  CREATE                                         *
      * Function    :  Create ISO MT942 message for transmission      *
      *                to FONTIS                                      *
      *                                                               *
      * Called by   :  MAIN                                           *
      * Calls       :  FLD20      Create field :20:                   *
      *                FLD25      Create field :25:                   *
      *                FLD34F     Create field :34F:                  *
      *                FLD13      Create field :13:                   *
      *                FLD61      Create all field :61:s              *
      *                FLD86      Create field :86:                   *
      *                FLD90D     Create field :90D:                  *
      *                FLD90C     Create field :90C:                  *
      *****************************************************************
      *
     C     CREATE        BEGSR
      *
      ** Set up & initialise total amount, and number of debit/credit's
     C                   Z-ADD     *ZERO         W@DRNO            3 0
     C                   Z-ADD     *ZERO         W@CRNO            3 0
     C                   Z-ADD     *ZERO         W@DRAM           13 0
     C                   Z-ADD     *ZERO         W@CRAM           13 0
      *
      ** Access first posting for this account
     C                   SETOFF                                       25
     C     K#ACMT        SETLL     RSACMTPO                               80
     C***********K#ACMT    SETLLGLRSL1PO                 80        CGL006 169692
      *
     C     ACCT1         DOUNE     F1FULA                                       B01
     C     *IN25         OREQ      '1'
     C     PTDT          ORGE      BJRDNB
     C     VUDT          ANDLT     BJDNWD
     C     NEWPST        ANDEQ     'Y'
     C/COPY WNCPYSRC,GL2805C012
     C                   READ      RSACMTPO                               25
     C/COPY WNCPYSRC,GL2805C018
     C**********           MOVE ACCTNO    ACCT1  18                                           CGL029
     C                   MOVEL     ACDE          ACTSQN           12
     C                   MOVE      ASNC          ACTSQN
     C                   MOVEL     CUSCCY        ACCTNO           21
     C                   MOVE      ACTSQN        ACCTNO
     C                   MOVE      ACCTNO        ACCT1            24
     C                   MOVEL     BRCA          ACCT1
     C                   MOVE      'Y'           NEWPST            1
      *
     C**         IGNORE IF ALREADY WRITTEN TO FONTIS942                   CGL006
     C     CGL006        IFEQ      'Y'                                          B02            CGL00
     C     ACCT1         ANDEQ     F1FULA                                                      CGL00
     C     *IN25         ANDEQ     '0'                                                         CGL00
     C     PTDT          ANDGE     BJRDNB                                                      CGL00
     C     VUDT          ANDLT     BJDNWD                                                      CGL00
     C/COPY WNCPYSRC,GL2805C013
     C***********          READ GLRSL1PO                 27        CGL006 169692
     C************IN27     IFNE '1'                        I03     CGL006 169692
     C***********GLRSSV    ANDEQRSACMT                             CGL006 169692
     C***********          MOVE 'N'       NEWPST                   CGL006 169692
     C***********          END                             E03     CGL006 169692
     C*                                                                   169692
     C                   EXSR      SRFIND                                                      16969
     C*                                                                   169692
     C                   END                                                    E02            CGL00
      *
     C                   ENDDO                                                  E01
      *
     C     ACCT1         IFEQ      F1FULA                                       B01
     C     *IN25         ANDEQ     '0'
      *
      ** Write Swift Header to PF/GLFDTAPD
     C     *DTAARA       DEFINE    GLFONTDA      GLFONT
     C     *LOCK         IN        GLFONT
     C                   MOVE      F6FNBC        @F4S2
     C                   MOVEL     @F4DAT        F4DATA
     C                   WRITE     GLFDTAD0
     C                   OUT       GLFONT
      *
      ** Create field :20: (Transaction Reference Number)
     C                   EXSR      FLD20
      *
      ** Create field :25: (Account i/d)
     C                   EXSR      FLD25
      *
      ** Create field :28C:, if CGL005 switched on.
     C     CGL005        IFEQ      'Y'
     C                   EXSR      FLD28C
     C                   ENDIF
      *
      ** Create field :34F:(Floor Limit Indicator)
     C                   EXSR      FLD34F
      *
      ** Create field :13: (Date/Time Indicator)
     C                   EXSR      FLD13
     C/COPY WNCPYSRC,GL2805C010
     C                   ENDIF                                                  E01
      *
      ** If found then account id read from RSACMTL0 is the same as
      ** that being processed on GLFONAL0
      *
     C     ACCT1         DOWEQ     F1FULA                                       B01
     C     *IN25         ANDEQ     '0'
      *
     C     PTDT          IFGE      BJRDNB                                       B02
     C     VUDT          ANDLT     BJDNWD                                       B02
     C     NEWPST        ANDEQ     'Y'
     C/COPY WNCPYSRC,GL2805C014
      *
     C     FUND          IFNE      *BLANKS                                      B03
     C                   MOVE      'Y'           FTYN              1
     C                   ELSE                                                   X03
     C                   MOVE      'N'           FTYN
     C                   END                                                    E03
      *
     C                   MOVE      TRYP          L#TTYP
     C                   MOVE      FTYN          L#FTTR
     C*****K#FNAR        CHAIN     GLFNARL0                           26                    MD058079
     C/EXEC SQL                                                                             MD058079
     C+ SELECT *                                                                            MD058079
     C+ into :GLFNAR                                                                        MD058079
     C+ from GLFNAJW0                                                                       MD058079
     C+ where F2PMTT = :L#TTYP and F2FTTR = :L#FTTR                                         MD058079
     C/END-EXEC                                                                             MD058079
     C                   SETOFF                                       26                    MD058079
     C                   If        SQLCODE = 100                                            MD058079
     C                   SETON                                        26                    MD058079
     C                   ENDIF                                                              MD058079
      *
      ** Maintain Debit or Credit count and totals
     C     DORC          IFEQ      0                                            B03
     C                   ADD       1             W@DRNO
     C                   ADD       MVAM          W@DRAM
     C                   ELSE                                                   I03
     C                   ADD       1             W@CRNO
     C                   ADD       MVAM          W@CRAM
     C                   ENDIF                                                  E03
      *
      ** Create all field :61:s (Postings)
     C                   EXSR      FLD61
      *
      ** Create field :86: (Narrative)  : Condition as per SF9
     C     @DATA         IFNE      *BLANKS                                      B03
     C/COPY WNCPYSRC,GL2805C007
     C                   EXSR      FLD86
     C/COPY WNCPYSRC,GL2805C002
     C                   ENDIF                                                  E03
     C/COPY WNCPYSRC,GL2805C006
     C                   ENDIF                                                  E02
      *
      ** Read next record
     C                   READ      RSACMTPO                               25
     C/COPY WNCPYSRC,GL2805C019
     C**********           MOVE ACCTNO    ACCT1  18                                           CGL029
     C                   MOVEL     ACDE          ACTSQN
     C                   MOVE      ASNC          ACTSQN
     C                   MOVEL     CUSCCY        ACCTNO
     C                   MOVE      ACTSQN        ACCTNO
     C                   MOVE      ACCTNO        ACCT1
     C                   MOVEL     BRCA          ACCT1
     C                   MOVE      'Y'           NEWPST
      *
     C**         ignore if already written to FONTIS942                   CGL006
     C     CGL006        IFEQ      'Y'                                          B02            CGL00
     C     ACCT1         ANDEQ     F1FULA                                                      CGL00
     C     *IN25         ANDEQ     '0'                                                         CGL00
     C     PTDT          ANDGE     BJRDNB                                                      CGL00
     C/COPY WNCPYSRC,GL2805C015
     C     VUDT          ANDLT     BJDNWD                                                      CGL00
     C/COPY WNCPYSRC,GL2805C017
     C***********          READ GLRSL1PO                 27        CGL006 169692
     C************IN27     IFNE '1'                        I03     CGL006 169692
     C***********GLRSSV    ANDEQRSACMT                             CGL006 169692
     C***********          MOVE 'N'       NEWPST                   CGL006 169692
     C***********          END                             E03     CGL006 169692
     C*                                                                   169692
     C                   EXSR      SRFIND                                                      16969
     C*                                                                   169692
     C                   END                                                    E02            CGL00
      *
     C                   ENDDO                                                  E01
     C/COPY WNCPYSRC,GL2805C009
      *
     C     W@DRNO        IFGT      0                                            B01
     C     W@CRNO        ORGT      0                                            B01           165718
     C                   EXSR      FLD90D
     C***********          ENDIF                           E01           165718
      *
     C***********W@CRNO    IFGT 0                          B01           165718
     C                   EXSR      FLD90C
     C                   ENDIF                                                  E01
      *
      ** Write Swift Trailer to PF/GLFDTAPD
     C     W@DRNO        IFGT      0                                            B01
     C     W@CRNO        ORGT      0
     C                   MOVE      *BLANKS       F4DATA
     C                   MOVEL     '-}'          F4DATA
     C                   WRITE     GLFDTAD0
     C                   ENDIF                                                  E01
      *
     C                   ENDSR                                                  CREATE
      /EJECT
     C/COPY WNCPYSRC,GL2805C008
      *
      *****************************************************************
      * Subroutine  :  FLD20                                          *
      * Function    :  Create field :20: (Transaction Reference       *
      *                Number)                                        *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     FLD20         BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':20:'        @TAG4
     C                   MOVEL     'MF'          @PFX
      *
     C     MNM           IFEQ      FONT
     C                   CALL      'ZM0060'
     C                   PARM      BJRDNB        ZMDAY             5 0
     C                   PARM                    ZSDATE            6
     C                   MOVEL     ZSDATE        @DAT
     C                   ELSE
     C                   MOVEL     W@MDAT        @DAT
     C                   ENDIF
      *
      ** Initialise Transaction Reference time subfield
     C                   TIME                    W#NEWT            6 0
     C     W#NEW2        IFEQ      W#OLDT                                       B01
     C                   ADD       1             @SEQ
     C                   ELSE                                                   I01
     C                   Z-ADD     1             @SEQ
     C                   Z-ADD     W#NEW2        W#OLDT            4 0
     C                   MOVE      W#OLDT        @TIM
     C                   ENDIF                                                  E01
      *
     C                   MOVEL     @20           @DAT4
     C                   MOVEL     @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
      ** Keep a count of the number of records written to GLFDTAPD
     C                   ADD       1             W@WRI
      *
     C                   ENDSR                                                  FLD20
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD25                                          *
      * Function    :  Create field :25: (Account i/d)                *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     FLD25         BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':25:'        @TAG4
     C     ATYP          IFEQ      'R'                                                         16571
     C     BMRANR        ANDEQ     'Y'                                                         16571
     C     ACNO          ANDNE     *ZEROS                                                      16571
     C                   MOVEL     ACNO          @DAT4                                         16571
     C                   ELSE                                                                  16571
     C                   MOVEL     F1FULA        @DAT4
     C                   END                                                                   16571
     C/COPY WNCPYSRC,GL2805C021
     C                   MOVEL     @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
     C                   ENDSR                                                  FLD25
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD28C                                         *
      * Function    :  Create field :28C:                             *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     FLD28C        BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':28C:'       @TAG5
     C     F1FNSQ        ADD       1             @28S1
     C                   MOVEL     '1 '          @28S2
     C                   MOVEL     @28           @DAT5
     C                   MOVEL     @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *                                                                   166768
      ** Update sequence number                                           166768
     C                   ADD       1             F1FNSQ                                        16676
     C                   UPDATE    GLFONAD0                                                    16676
      *
     C                   ENDSR                                                  FLD28C
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD34F                                         *
      * Function    :  Create field :34F:(Floor Limit Indicator)      *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD34F        BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':34F:'       @TAG5
     C                   MOVEL     '0,'          @34FS2
      *
      ** Determine SWIFT currency
     C                   CALL      'ZM0040'
     C                   PARM                    ZAMNT            13 0
     C                   PARM      CCY           ZCCY              3
     C                   PARM                    ZSAMNT           15
     C     @34FS1        PARM                    ZSCCY             3
     C                   PARM      *BLANKS       ZERR              1
     C                   PARM      WSWDPC        ZSWDPC            1                           CSW02
      *
      ** If program fails, report database error
     C     ZERR          IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '003'         DBASE                          * * * * * * * *
     C                   MOVEL     'PROGRAM'     DBKEY                          *  DBERR 003  *
     C                   MOVEL     'ZM0040  '    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     @34F          @DAT5
     C                   MOVEL     @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
     C                   ENDSR                                                  FLD34F
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD13                                          *
      * Function    :  Create field :13: (Date/Time Indicator)        *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0060     Return date in ISO format           *
      *                ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD13         BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':13:'        @TAG4
      *
     C     MNM           IFEQ      FONT
     C                   CALL      'ZM0060'
     C                   PARM      BJRDNB        ZMDAY             5 0
     C                   PARM                    ZSDATE            6
     C                   MOVEL     ZSDATE        @13S1
     C                   ELSE
     C                   MOVEL     W@MDAT        @13S1
     C                   ENDIF
      *
     C                   MOVEL     @TIM          @13S2
      *
      ** Move data to output record
     C                   MOVEL     @13           @DAT4
     C                   MOVE      @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
     C                   ENDSR                                                  FLD13
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD61                                          *
      * Function    :  Create all field :61:s (postings)              *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0060     Return date in ISO format           *
      *                ZM0040     Return ccy/amount in ISO format     *
      *                SF6        Create subfield 6                   *
      *                SF7        Create subfield 7                   *
      *                SF8        Create subfield 8                   *
      *                SF9        Create subfield 9                   *
      *****************************************************************
      *
     C     FLD61         BEGSR
      *
      ** Format all field :61:s
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   CLEAR                   @61
     C                   MOVEL     ':61:'        @TAG4
      *
      ***Set*up*subfield*1*(posting*date,*YYMMDD)
     C***********PTDT      IFNE 0                          B01                                181476
     C***********          CALL 'ZM0060'                                                      181476
     C***********          PARM PTDT      ZMDAY   50                                          181476
     C***********@61S1     PARM           ZMDATE  6                                           181476
     C***********          ENDIF                           E01                                181476
      ** Set up subfield 1 (value date, YYMMDD)                                               181476
     C                   CALL      'ZM0060'
     C                   PARM      VUDT          ZMDAY             5 0
     C     @61S1         PARM                    ZMDATE            6
      *
      ***Set*up*subfield*2*(value*date,*MMDD)                                                 181476
     C***********          CALL 'ZM0060'                                                      181476
     C***********          PARM VUDT      ZMDAY   50                                          181476
     C***********W@61S2    PARM           ZMDATE  6                                           181476
     C***********          MOVE W@61S2    @61S2                                               181476
      ** Set up subfield 2 (posting date, MMDD)                                               181476
     C     PTDT          IFNE      0                                            B01
     C                   CALL      'ZM0060'
     C                   PARM      PTDT          ZMDAY             5 0
     C     W@61S2        PARM                    ZMDATE            6
     C                   MOVE      W@61S2        @61S2
     C                   ENDIF                                                  E01
     C/COPY WNCPYSRC,GL2805C016
      *
      ** Set up subfield 3 (debit/credit indicator)
     C     DORC          IFEQ      0                                            B01
     C                   MOVE      'D'           @61S3
     C                   ELSE                                                   I01
     C                   MOVE      'C'           @61S3
     C                   ENDIF                                                  E01
      *
      ** Set up subfield 5 (posting amount)
     C                   Z-ADD     MVAM          @WKAMT           13 0
     C/COPY WNCPYSRC,GL2805C020
     C                   CALL      'ZM0040'
     C                   PARM      @WKAMT        ZAMNT            13 0
     C                   PARM      CCY           ZCCY              3
     C     @61S5         PARM                    ZSAMNT           15
     C                   PARM                    ZSCCY             3
     C                   PARM      *BLANKS       ZERR              1
     C                   PARM      WSWDPC        ZSWDPC            1                           CSW02
      *
      ** If program fails, report database error
     C     ZERR          IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '004'         DBASE                          * * * * * * * *
     C                   MOVEL     'PROGRAM'     DBKEY                          *  DBERR 004  *
     C                   MOVEL     'ZM0040  '    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Format subfield 6
     C                   EXSR      SF6
      *
      ** Format subfield 7
     C                   EXSR      SF7
      *
      ** Format subfield 8
     C                   EXSR      SF8
      *
     C     @61S8D        IFEQ      *BLANKS
     C                   CLEAR                   @61S8
     C                   ENDIF
      *
      ** When all subfields for this line formatted, compress and
      ** output to file.
     C                   Z-ADD     4             T                 5 0
     C                   CLEAR                   @FM
     C                   MOVEA     @61           @FM
     C     1             DO        55            S                 5 0          B01
     C     @FM(S)        IFNE      ' '                                          B02
     C                   ADD       1             T
     C                   MOVE      @FM(S)        @TO(T)
     C                   ENDIF                                                  E02
     C                   ENDDO                                                  E01
      *
      ** Move data to output record
     C                   MOVE      @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
      ** Write copy of posting record to daily file
     C     CGL006        IFEQ      'Y'                                                         16952
     C                   WRITE     GLRSSVPO
     C                   ENDIF                                                                 16952
      *
      ** Format subfield 9
     C                   EXSR      SF9
      *
     C                   ENDSR                                                  FLD61
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  SF6                                            *
      * Function    :  Create subfield 6 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF6           BEGSR
      *
      ** First character of subfield 6 should always be 'F'
     C                   MOVE      'F'           @61S6A
      *
      ** Fill K-list fields to chain for Transaction Type ID
     C     FUND          IFNE      *BLANKS                                      B01
     C                   MOVE      'Y'           L#FTTR
     C                   ELSE                                                   I01
     C                   MOVE      'N'           L#FTTR
     C                   ENDIF                                                  E01
      *
     C                   MOVEL     TRYP          L#TTYP
      *
     C     *IN26         IFEQ      '0'                                          B01
     C     F2STTI        ANDNE     *BLANKS
     C                   MOVE      F2STTI        @61S6B
     C                   ELSE                                                   I01
      *
      ** If unable to set up code, default to 'MSC' - miscellaneous
     C                   MOVE      'MSC'         @61S6B
     C                   ENDIF                                                  E01
      *
     C                   ENDSR                                                  SF6
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  SF7                                            *
      * Function    :  Create subfield 7 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF7           BEGSR
      *
      ** Use first 16 characters of narrative description
     C                   MOVEL     NRTD          @61S7
      *
     C                   ENDSR                                                  SF7
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  SF8                                            *
      * Function    :  Create subfield 8 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF8           BEGSR
      *
      ** Subfield 8 should always begin with '//'
     C                   MOVE      '//'          @61S8A
      *
      ** Narrative details found
     C     TNMR          IFNE      *BLANKS
     C     *IN26         IFEQ      '0'
     C                   MOVE      F2TRMD        @61S8B
     C                   MOVE      TNMR          @61S8C
     C                   ELSE
     C                   MOVE      TNMR          @61S8D
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR                                                  SF8
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  SF9                                            *
      * Function    :  Create subfield 9 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF9           BEGSR
      *
      ** Clear tag & data fields for writing of subfield 9
     C                   CLEAR                   @DATA
      *
      ** Retrieve SwiftNarrative from narrative table (If found)
     C     *IN26         IFEQ      '0'                                          B01
     C                   MOVEL     F2NATV        @DATA
     C                   END                                                    E01
      *
      ** If data in subfield 9, write to file
     C     @DATA         IFNE      *BLANKS                                      B01
     C                   MOVE      @DATA         F4DATA
     C                   WRITE     GLFDTAD0
     C                   ENDIF                                                  E01
      *
     C                   ENDSR                                                  SF9
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD86                                          *
      * Function    :  Create field :86: (narrative)                  *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :                                                 *
      *****************************************************************
      *
     C     FLD86         BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':86:'        @TAG4
      *
      ** Use first 16 characters of narrative description
     C/COPY WNCPYSRC,GL2805C004
     C                   MOVEL     @61S7         @DAT4
     C/COPY WNCPYSRC,GL2805C005
     C                   MOVEL     @DATA         F4DATA
     C                   WRITE     GLFDTAD0
      *
     C                   ENDSR
     C/COPY WNCPYSRC,GL2805C003
      *
      *****************************************************************
      * Subroutine  :  FLD90D                                         *
      * Function    :  Create field :90D: (number and sum             *
      *                                           of debit entries)   *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD90D        BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':90D:'       @TAG5
      *
      ** Number of debit entries
     C                   Z-ADD     W@DRNO        @90DS1
      *
      ** Set up subfield 3 (Sum of debit entries)
     C                   CALL      'ZM0040'
     C                   PARM      W@DRAM        ZAMNT            13 0
     C                   PARM      CCY           ZCCY              3
     C     @90DS3        PARM                    ZSAMNT           15
     C     @90DS2        PARM                    ZSCCY             3
     C                   PARM      *BLANKS       ZERR              1
     C                   PARM      WSWDPC        ZSWDPC            1                           CSW02
      *
      ** If program fails, report database error
     C     ZERR          IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '005'         DBASE                          * * * * * * * *
     C                   MOVEL     'PROGRAM'     DBKEY                          *  DBERR 005  *
     C                   MOVEL     'ZM0040  '    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Move data to output record
     C                   MOVEL     @90D          @DAT5
     C                   MOVE      @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
     C                   ENDSR                                                  FLD90D
      /EJECT
      *****************************************************************
      * Subroutine  :  FLD90C                                         *
      * Function    :  Create field :90C: (number and sum             *
      *                                           of credit entries)  *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD90C        BEGSR
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':90C:'       @TAG5
      *
      ** Number of credit entries
     C                   Z-ADD     W@CRNO        @90CS1
      *
      *
      ** Set up subfield 3 (Sum of debit entries)
     C                   CALL      'ZM0040'
     C                   PARM      W@CRAM        ZAMNT            13 0
     C                   PARM      CCY           ZCCY              3
     C     @90CS3        PARM                    ZSAMNT           15
     C     @90CS2        PARM                    ZSCCY             3
     C                   PARM      *BLANKS       ZERR              1
     C                   PARM      WSWDPC        ZSWDPC            1                           CSW02
      *
      ** If program fails, report database error
     C     ZERR          IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '006'         DBASE                          * * * * * * * *
     C                   MOVEL     'PROGRAM'     DBKEY                          *  DBERR 006  *
     C                   MOVEL     'ZM0040  '    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Move data to output record
     C                   MOVEL     @90C          @DAT5
     C                   MOVE      @DATA         F4DATA
      *
      ** Write record to file
     C                   WRITE     GLFDTAD0
      *
     C                   ENDSR                                                  FLD90C
      /EJECT
      *****************************************************************
      * Subroutine  :  AUDIT                                          *
      * Function    :  Produce Audit Report                           *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :                                                 *
      *****************************************************************
      *
     C     AUDIT         BEGSR
      *
      ** Check for an index record for that day's member
     C     MNM           CHAIN     GLFREFL0                           21
      *
     C                   MOVE      MNM           F3MBRN
     C                   MOVE      'P'           F3DNLS
     C                   Z-ADD     0             F3RSTN
     C                   MOVE      *BLANKS       F3RSTU
     C                   Z-ADD     0             F3RSTD
     C                   Z-ADD     0             F3RTIM
     C                   Z-ADD     0             F3DLDL
     C                   Z-ADD     0             F3TDNL
      *
     C     *IN21         IFEQ      '1'
     C                   WRITE     GLFREFD0
     C                   ELSE
     C                   UPDATE    GLFREFD0
     C                   ENDIF
      *
      ** Open Audit printer file PRTF/GL2805AU
     C                   OPEN      GL2805AU
      *
      ** Write title header
     C                   WRITE     GL2805A1
      *
      ** If no record found on the file PF/GLFONAPD
      ** OR no record found on the file PF/RSACMTL1
     C     *IN30         IFEQ      '1'                                          B01
     C     W@RED         ANDEQ     0
      *
      ** Write 'no messages to report'
     C                   WRITE     GL2805A3
     C                   ELSE                                                   I01
      *
      ** Write out details
     C                   WRITE     GL2805A2                             31
     C                   ENDIF                                                  E01
      *
      ** Write out 'End of Report'
     C                   WRITE     GL2805A5
      *
      ** Close Audit printer file PRTF/GL2805AU
     C                   CLOSE     GL2805AU
      *
     C                   ENDSR                                                  AUDIT
      /EJECT                                                              169692
      *****************************************************************   169692
      * Subroutine  :  SRFIND                                         *   169692
      * Function    :  Find out if posting has already been reported  *   169692
      *                in previous MT942s                             *   169692
      * Called by   :  CREATE                                         *   169692
      * Calls       :                                                 *   169692
      *****************************************************************   169692
      *                                                                   169692
     C     SRFIND        BEGSR                                                                 16969
      *                                                                   169692
     C     K#ACM2        CHAIN     GLRSL1PO                           27                       16969
      *                                                                   169692
     C     *IN27         DOWEQ     *OFF                                                        16969
     C     NEWPST        ANDEQ     'Y'                                                         16969
      *                                                                   169692
     C     GLRSSV        IFEQ      RSACMT                                                      16969
     C                   MOVE      'N'           NEWPST                                        16969
     C                   ENDIF                                                                 16969
      *                                                                   169692
     C     K#ACM2        READE     GLRSL1PO                               27                   16969
      *                                                                   169692
     C                   ENDDO                                                                 16969
      *                                                                   169692
     C                   ENDSR                                                  SRFIND         16969
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  *PSSR                                          *
      * Function    :  Called autmatically if a program error occurs  *
      *                or directly in case of database errors.        *
      *                This program DUMPs the program just once.      *
      *                                                               *
      * Called by   :  Automatically                                  *
      *                INIT                                           *
      *                                                               *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Check to see if *PSSR has been already called
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
      ** DUMP and write database error report
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   OPEN      GL2805AU
     C                   WRITE     GL2805A4
     C                   WRITE     GL2805A5
      *
      ** Close Audit printer file PRTF/GL2805AU
     C                   CLOSE     GL2805AU
      *
     C                   ENDIF
      *
      ** If *PSSR already run, end program.
      *
     C                   ROLBK                                                                 16952
     C                   RETURN
      *
     C                   ENDSR                                                  *PSSR
      *
      ********************************************************************
** CPY@
(c) Finastra International Limited 2001
